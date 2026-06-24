#!/usr/bin/env python3
"""Fetch, inspect, and optionally integrate idle Aristotle projects.

The script is intentionally conservative:

* Results are stored under AgentTasks/aristotle-output/<project-id>/.
* Archives are extracted with path traversal checks.
* Candidate Lean files are copied only with --apply.
* Targeted Lake builds are opt-in with --build.

It does not replace review. It gives the reviewer a deterministic report and
removes the fragile manual steps around result fetching, extraction, placeholder
scans, and module-name construction.
"""

from __future__ import annotations

import argparse
import dataclasses
import difflib
import pathlib
import re
import shutil
import subprocess
import sys
import tarfile
from collections.abc import Iterable


REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]
DEFAULT_OUTPUT_ROOT = REPO_ROOT / "AgentTasks" / "aristotle-output"
UUID_RE = re.compile(
    r"\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-"
    r"[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\b"
)
PLACEHOLDER_RE = re.compile(
    r"\b(sorry|admit|axiom|opaque|unsafe|native_decide)\b"
)
LEAN_CANDIDATE_RE = re.compile(r"Aristotle\.lean$")
TASK_FIELD_RE = re.compile(
    r"^\s*(project_id|job_id|task_id|target_file|expected_module|output_dir|source_staged_from):\s*(.+?)\s*$"
)
THEOREM_SIGNATURE_RE = re.compile(
    r"(?ms)^[ \t]*(?:@[^\n]*\n[ \t]*)*"
    r"(?:(?:private|protected|noncomputable)\s+)*"
    r"(theorem|lemma)\s+([A-Za-z0-9_'.]+)\b.*?:=\s*by"
)


@dataclasses.dataclass
class TaskMetadata:
    project_id: str
    task_id: str | None = None
    target_file: str | None = None
    expected_module: str | None = None
    output_dir: str | None = None
    source_staged_from: str | None = None
    note_path: pathlib.Path | None = None


@dataclasses.dataclass
class Candidate:
    source: pathlib.Path
    repo_relative: pathlib.Path
    module: str
    placeholder_hits: list[str]


def rel(path: pathlib.Path) -> str:
    try:
        return path.resolve().relative_to(REPO_ROOT).as_posix()
    except ValueError:
        return str(path)


def run_command(
    command: list[str],
    *,
    cwd: pathlib.Path = REPO_ROOT,
    check: bool = False,
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command,
        cwd=str(cwd),
        text=True,
        encoding="utf-8",
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=check,
    )


def normalize_project_statuses(statuses: Iterable[str]) -> set[str]:
    normalized: set[str] = set()
    for status in statuses:
        upper = status.upper()
        if upper in {"COMPLETE", "COMPLETE_WITH_ERRORS"}:
            # Aristotle API v3 exposes project states, not terminal job states.
            # Completed projects are normally IDLE.  Keep the old spellings as
            # compatibility aliases for existing command habits and task notes.
            normalized.add("IDLE")
        else:
            normalized.add(upper)
    return normalized


def parse_aristotle_list(statuses: set[str]) -> list[str]:
    result = run_command(["aristotle", "list"], check=True)
    projects: list[str] = []
    for line in result.stdout.splitlines():
        match = UUID_RE.search(line)
        if not match:
            continue
        parts = line.split()
        status = next((part for part in parts if part in statuses), "")
        if status:
            projects.append(match.group(0).lower())
    return projects


def parse_task_notes(paths: Iterable[pathlib.Path]) -> dict[str, TaskMetadata]:
    metadata: dict[str, TaskMetadata] = {}
    for note in paths:
        if not note.exists():
            raise FileNotFoundError(f"Task note does not exist: {note}")
        text = note.read_text(encoding="utf-8")
        found_explicit_project = False
        active_project: str | None = None
        for line in text.splitlines():
            field_match = TASK_FIELD_RE.match(line)
            if not field_match:
                continue
            key, value = field_match.group(1), field_match.group(2).strip("`\"'")
            if key in {"project_id", "job_id"}:
                # `job_id` was the repository's API-v1/v2 field name.  In the
                # Aristotle API-v3 project/task model this same UUID is a
                # project ID for our submit/download workflow.
                active_project = value.lower()
                found_explicit_project = True
                metadata.setdefault(
                    active_project,
                    TaskMetadata(project_id=active_project, note_path=note),
                )
                continue
            if active_project is None:
                continue
            record = metadata.setdefault(
                active_project,
                TaskMetadata(project_id=active_project, note_path=note),
            )
            if key == "task_id":
                record.task_id = value.lower()
            elif key == "target_file":
                record.target_file = value
            elif key == "expected_module":
                record.expected_module = value
            elif key == "output_dir":
                record.output_dir = value
            elif key == "source_staged_from":
                record.source_staged_from = value
        if not found_explicit_project:
            project_ids = {match.group(0).lower() for match in UUID_RE.finditer(text)}
            for project_id in project_ids:
                metadata.setdefault(project_id, TaskMetadata(project_id=project_id, note_path=note))
    for record in metadata.values():
        if record.target_file and record.source_staged_from:
            if not record.target_file.startswith("AgentTasks/"):
                record.target_file = f"{record.source_staged_from}/{record.target_file}"
    return metadata


def assert_under(child: pathlib.Path, parent: pathlib.Path) -> None:
    child_resolved = child.resolve()
    parent_resolved = parent.resolve()
    if child_resolved != parent_resolved and parent_resolved not in child_resolved.parents:
        raise ValueError(f"Path {child_resolved} is not under {parent_resolved}")


def safe_extract_tar(archive: pathlib.Path, destination: pathlib.Path) -> None:
    destination.mkdir(parents=True, exist_ok=True)
    with tarfile.open(archive) as tar:
        members_to_extract = []
        for member in tar.getmembers():
            parts = pathlib.Path(member.name).parts
            if any(p == ".lake" for p in parts):
                continue
            # On Windows, long paths can exceed MAX_PATH. Only extract Lean files and summary.md
            # to keep path lengths short and avoid FileNotFoundError.
            name_lower = member.name.lower()
            if not (name_lower.endswith(".lean") or name_lower.endswith("summary.md")):
                continue
            target = destination / member.name
            assert_under(target, destination)
            members_to_extract.append(member)
        # "data" filter also rejects symlinks/devices, which the name check
        # above does not cover (and silences the Python 3.12+ deprecation).
        tar.extractall(destination, members=members_to_extract, filter="data")



def fetch_project(project_id: str, output_root: pathlib.Path) -> pathlib.Path:
    project_dir = output_root / project_id
    project_dir.mkdir(parents=True, exist_ok=True)
    marker = project_dir / ".aristotle-download-fetched"
    if marker.exists():
        return project_dir

    old_marker = project_dir / ".aristotle-result-fetched"
    if old_marker.exists():
        return project_dir

    destination = project_dir / "project-files.tar.gz"
    print(f"Fetching {project_id} -> {rel(destination)}")
    result = run_command(
        ["aristotle", "download", project_id, "--destination", str(destination)]
    )
    if result.returncode != 0:
        print(result.stdout)
        raise RuntimeError(f"aristotle download failed for {project_id}")
    marker.write_text(result.stdout, encoding="utf-8", newline="\n")
    return project_dir


def extract_archives(job_dir: pathlib.Path) -> None:
    extract_root = job_dir / "extracted"
    for path in list(job_dir.rglob("*")):
        if path.is_dir() or path.name.startswith("."):
            continue
        if extract_root in path.parents:
            continue
        if not tarfile.is_tarfile(path):
            continue
        relative_parent = path.parent.relative_to(job_dir)
        target = extract_root / relative_parent / path.stem
        if target.exists():
            continue
        print(f"Extracting {rel(path)} -> {rel(target)}")
        safe_extract_tar(path, target)


def strip_lean_comments(text: str) -> str:
    out = []
    i = 0
    n = len(text)
    nesting = 0
    in_line_comment = False
    in_string = False
    while i < n:
        if in_line_comment:
            if text[i] == '\n':
                in_line_comment = False
                out.append('\n')
            i += 1
        elif nesting > 0:
            if i + 1 < n and text[i] == '/' and text[i+1] == '-':
                nesting += 1
                i += 2
            elif i + 1 < n and text[i] == '-' and text[i+1] == '/':
                nesting -= 1
                i += 2
            else:
                if text[i] == '\n':
                    out.append('\n')
                i += 1
        elif in_string:
            if text[i] == '\\' and i + 1 < n:
                out.append(text[i:i+2])
                i += 2
            elif text[i] == '"':
                in_string = False
                out.append('"')
                i += 1
            else:
                out.append(text[i])
                i += 1
        else:
            if i + 1 < n and text[i] == '/' and text[i+1] == '-':
                nesting += 1
                i += 2
            elif i + 1 < n and text[i] == '-' and text[i+1] == '-':
                in_line_comment = True
                i += 2
            elif text[i] == '"':
                in_string = True
                out.append('"')
                i += 1
            else:
                out.append(text[i])
                i += 1
    return "".join(out)


def discover_summary_files(job_dir: pathlib.Path) -> list[pathlib.Path]:
    return sorted(job_dir.rglob("summary.md"))


def discover_candidates(job_dir: pathlib.Path, metadata: TaskMetadata | None) -> list[Candidate]:
    candidate_paths: set[pathlib.Path] = set()
    if metadata and metadata.target_file:
        suffix = metadata.target_file.replace("\\", "/")
        if metadata.expected_module:
            suffix = metadata.expected_module.replace(".", "/") + ".lean"
        else:
            parts = pathlib.Path(metadata.target_file).parts
            if len(parts) >= 2:
                suffix = "/".join(parts[-2:])
        for path in job_dir.rglob(pathlib.Path(metadata.target_file).name):
            if path.as_posix().replace("\\", "/").endswith(suffix):
                candidate_paths.add(path)
    else:
        for path in job_dir.rglob("*.lean"):
            if LEAN_CANDIDATE_RE.search(path.name):
                parts = path.parts
                if "PhysicsSM" in parts:
                    candidate_paths.add(path)

    candidates: list[Candidate] = []
    for source in sorted(candidate_paths):
        if metadata and metadata.target_file:
            repo_relative = pathlib.Path(metadata.target_file)
            module = metadata.expected_module or module_name(repo_relative)
        else:
            try:
                physics_index = source.parts.index("PhysicsSM")
            except ValueError:
                continue
            repo_relative = pathlib.Path(*source.parts[physics_index:])
            if repo_relative.parts[0] != "PhysicsSM":
                continue
            module = module_name(repo_relative)
        text = source.read_text(encoding="utf-8")
        clean_text = strip_lean_comments(text)
        hits = sorted({match.group(1) for match in PLACEHOLDER_RE.finditer(clean_text)})
        candidates.append(
            Candidate(
                source=source,
                repo_relative=repo_relative,
                module=module,
                placeholder_hits=hits,
            )
        )
    return candidates


def module_name(path: pathlib.Path) -> str:
    no_suffix = path.with_suffix("")
    return ".".join(no_suffix.parts)


def theorem_signatures(text: str) -> dict[str, str]:
    return {match.group(2): match.group(0) for match in THEOREM_SIGNATURE_RE.finditer(text)}


def changed_line_counts(old_text: str, new_text: str) -> tuple[int, int]:
    added = 0
    removed = 0
    diff = difflib.unified_diff(
        old_text.splitlines(),
        new_text.splitlines(),
        lineterm="",
    )
    for line in diff:
        if line.startswith(("+++", "---", "@@")):
            continue
        if line.startswith("+"):
            added += 1
        elif line.startswith("-"):
            removed += 1
    return added, removed


def signature_report(candidate: Candidate) -> list[str]:
    destination = REPO_ROOT / candidate.repo_relative
    if not destination.exists():
        return ["live file: missing; review full candidate before applying"]

    old_text = destination.read_text(encoding="utf-8")
    new_text = candidate.source.read_text(encoding="utf-8")
    added, removed = changed_line_counts(old_text, new_text)

    old_signatures = theorem_signatures(old_text)
    new_signatures = theorem_signatures(new_text)
    old_names = set(old_signatures)
    new_names = set(new_signatures)
    added_names = sorted(new_names - old_names)
    removed_names = sorted(old_names - new_names)
    changed_names = sorted(
        name
        for name in old_names & new_names
        if old_signatures[name] != new_signatures[name]
    )

    report = [f"diff stats: +{added} / -{removed} lines"]
    if not added_names and not removed_names and not changed_names:
        report.append("theorem/lemma signatures: unchanged")
    else:
        pieces = []
        if changed_names:
            pieces.append("changed " + ", ".join(changed_names[:8]))
        if added_names:
            pieces.append("added " + ", ".join(added_names[:8]))
        if removed_names:
            pieces.append("removed " + ", ".join(removed_names[:8]))
        report.append("theorem/lemma signatures: " + "; ".join(pieces))
    report.append(
        "review diff: git diff --no-index -- "
        f"{rel(destination)} {rel(candidate.source)}"
    )
    return report


def copy_candidate(candidate: Candidate) -> None:
    destination = REPO_ROOT / candidate.repo_relative
    assert_under(destination, REPO_ROOT)
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(candidate.source, destination)


def build_module(module: str) -> bool:
    print(f"Building {module}")
    result = run_command(["lake", "build", module])
    if result.returncode != 0:
        print(result.stdout)
        return False
    return True


def print_project_report(
    project_id: str,
    job_dir: pathlib.Path,
    metadata: TaskMetadata | None,
    candidates: list[Candidate],
) -> None:
    print("")
    print(f"Project {project_id}")
    print(f"  Output: {rel(job_dir)}")
    if metadata:
        if metadata.note_path:
            print(f"  Task note: {rel(metadata.note_path)}")
        if metadata.task_id:
            print(f"  Task ID: {metadata.task_id}")
        if metadata.target_file:
            print(f"  Expected target: {metadata.target_file}")
        if metadata.expected_module:
            print(f"  Expected module: {metadata.expected_module}")
    summaries = discover_summary_files(job_dir)
    for summary in summaries[:3]:
        print(f"  Summary: {rel(summary)}")
    if len(summaries) > 3:
        print(f"  Summary: ... plus {len(summaries) - 3} more")

    if not candidates:
        print("  Candidates: none discovered")
        return
    print("  Candidates:")
    for candidate in candidates:
        hits = ", ".join(candidate.placeholder_hits) if candidate.placeholder_hits else "none"
        print(f"    - {rel(candidate.source)}")
        print(f"      -> {candidate.repo_relative.as_posix()}")
        print(f"      module: {candidate.module}")
        print(f"      placeholders: {hits}")
        for line in signature_report(candidate):
            print(f"      {line}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("project_ids", nargs="*", help="Aristotle project IDs to inspect")
    parser.add_argument(
        "--from-list",
        action="store_true",
        help="Use `aristotle list` to find idle projects.",
    )
    parser.add_argument(
        "--status",
        action="append",
        default=None,
        help="Project status to accept when using --from-list (default: IDLE). "
        "May be repeated. Legacy COMPLETE/COMPLETE_WITH_ERRORS aliases map to IDLE.",
    )
    parser.add_argument(
        "--task-note",
        action="append",
        default=[],
        type=pathlib.Path,
        help="Task note to scan for Aristotle metadata. May be repeated.",
    )
    parser.add_argument(
        "--output-root",
        default=DEFAULT_OUTPUT_ROOT,
        type=pathlib.Path,
        help="Directory for fetched Aristotle output.",
    )
    parser.add_argument("--no-fetch", action="store_true", help="Inspect existing output only.")
    parser.add_argument("--apply", action="store_true", help="Copy candidate files into the repo.")
    parser.add_argument("--build", action="store_true", help="Run targeted lake builds after copying.")
    args = parser.parse_args()
    if args.status is None:
        # argparse appends to a non-None default, which would make the default
        # statuses impossible to narrow; resolve the default here instead.
        args.status = ["IDLE"]

    output_root = args.output_root
    if not output_root.is_absolute():
        output_root = REPO_ROOT / output_root
    assert_under(output_root, REPO_ROOT)

    task_metadata = parse_task_notes(args.task_note)
    project_ids = [project.lower() for project in args.project_ids]
    if args.from_list:
        statuses = normalize_project_statuses(args.status)
        for project in parse_aristotle_list(statuses):
            if project not in project_ids:
                project_ids.append(project)
    if not project_ids:
        parser.error("provide project IDs or use --from-list")

    any_failure = False
    for project_id in project_ids:
        if not UUID_RE.fullmatch(project_id):
            print(f"Skipping invalid project ID: {project_id}", file=sys.stderr)
            any_failure = True
            continue
        metadata = task_metadata.get(project_id)
        job_dir = output_root / project_id
        if args.no_fetch:
            if not job_dir.exists():
                print(f"Missing output directory: {rel(job_dir)}", file=sys.stderr)
                any_failure = True
                continue
        else:
            job_dir = fetch_project(project_id, output_root)
        extract_archives(job_dir)
        candidates = discover_candidates(job_dir, metadata)
        print_project_report(project_id, job_dir, metadata, candidates)

        blocked = [candidate for candidate in candidates if candidate.placeholder_hits]
        if blocked:
            print("  Apply: blocked by placeholder hits")
            any_failure = True
            continue
        if args.apply:
            for candidate in candidates:
                print(f"  Copying -> {candidate.repo_relative.as_posix()}")
                copy_candidate(candidate)
            if args.build:
                for candidate in candidates:
                    if not build_module(candidate.module):
                        any_failure = True
        else:
            print("  Apply: dry run only; rerun with --apply to copy candidates")

    return 1 if any_failure else 0


if __name__ == "__main__":
    raise SystemExit(main())
