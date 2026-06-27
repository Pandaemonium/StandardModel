#!/usr/bin/env python3
"""Send a prepared packet to Claude and log the full prompt/response.

Default target: Claude Opus through the installed Claude Code CLI.

Every real call writes exactly one Markdown log under
`AgentTasks/model-calls/claude/` containing the prompt, command, stdout,
stderr, return code, timestamps, and status. Dry runs also create a log unless
`--no-log` is passed.
"""

from __future__ import annotations

import argparse
import datetime as dt
import re
import shlex
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
LOG_DIR = ROOT / "AgentTasks" / "model-calls" / "claude"

# Read-only research MCP config for review calls (neo4j forced read-only,
# scholarly, lean-explore; no write servers, no slow lean-lsp lake serve).
DEFAULT_MCP_CONFIG = ROOT / "Scripts" / "autonomous_loop" / "review.mcp.json"
# Capability model (verified against this Claude CLI build):
#   `--tools default` + `--permission-mode bypassPermissions` is the combination
#   that actually exposes built-in AND MCP tools non-interactively. The narrower
#   `--allowed-tools` allowlist silently suppressed everything but Read, so we do
#   NOT use it; instead we gate capability with a denylist that takes precedence.
DEFAULT_TOOLS = "default"
DEFAULT_PERMISSION_MODE = "bypassPermissions"
# Block all mutation paths a reviewer never needs. Bash stays ENABLED so the
# reviewer can run the read-only semantic-search scripts (neo4j_paper_search.py
# --chunks, neo4j_doc_search.py); `--safe` adds Bash here for zero write surface.
DEFAULT_DISALLOWED = (
    "Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write"
)


def slugify(text: str) -> str:
    text = text.strip().lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    text = text.strip("-")
    return text or "claude-call"


_LANG_BY_SUFFIX = {
    ".lean": "lean",
    ".md": "markdown",
    ".py": "python",
    ".json": "json",
    ".toml": "toml",
}


def _lang(path: Path) -> str:
    return _LANG_BY_SUFFIX.get(path.suffix.lower(), "text")


def embed_sources(paths: list[str]) -> str:
    """Render each file verbatim in a labeled, fenced block.

    Adversarial review of a formalization is only meaningful against the ACTUAL
    theorem statements and definitions; a prose paraphrase cannot expose a
    semantic mismatch between the intended math and the Lean. So the packet must
    carry the real source, not a summary of it.
    """
    blocks: list[str] = []
    for raw in paths:
        path = Path(raw)
        text = path.read_text(encoding="utf-8")
        n_lines = text.count("\n") + 1
        try:
            label = path.resolve().relative_to(ROOT).as_posix()
        except ValueError:
            label = path.as_posix()
        if n_lines > 1200:
            print(
                f"warning: {label} is {n_lines} lines; consider sending only the "
                "relevant declarations to stay within budget.",
                flush=True,
            )
        blocks.append(f"### {label} ({n_lines} lines)\n\n```{_lang(path)}\n{text}\n```")
    return "\n\n".join(blocks)


def read_prompt(args: argparse.Namespace) -> str:
    pieces: list[str] = []
    if args.packet:
        pieces.append(Path(args.packet).read_text(encoding="utf-8"))
    if args.prompt:
        pieces.append(args.prompt)
    if not pieces:
        raise SystemExit("Provide --packet and/or --prompt.")
    prompt = "\n\n".join(pieces)

    if args.source_file:
        sources = embed_sources(args.source_file)
        prompt += (
            "\n\n## Verbatim source artifacts under review\n\n"
            "These are the ACTUAL files. Base every finding on the real "
            "statements and definitions below, not on any paraphrase above. For "
            "each theorem under review, explicitly check whether the Lean "
            "matches its intended reading, and flag every mismatch.\n\n"
            f"{sources}\n\n"
            "## Final instruction\n\n"
            "Produce your review now, strictly in the Required output format "
            "specified above."
        )
    return prompt


def make_log_path(slug: str) -> Path:
    stamp = dt.datetime.now().strftime("%Y-%m-%d-%H%M%S")
    return LOG_DIR / f"{stamp}-{slugify(slug)}.md"


def write_log(
    *,
    path: Path,
    provider: str,
    model: str,
    status: str,
    command: list[str],
    started: str,
    finished: str,
    prompt: str,
    stdout: str,
    stderr: str,
    returncode: int | None,
    dry_run: bool,
    timeout_seconds: int,
    max_budget_usd: str,
) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    command_text = " ".join(shlex.quote(part) for part in command)
    body = f"""# Claude model call log

## Metadata

- Provider: `{provider}`
- Model: `{model}`
- Status: `{status}`
- Dry run: `{dry_run}`
- Started: `{started}`
- Finished: `{finished}`
- Timeout seconds: `{timeout_seconds}`
- Max budget USD: `{max_budget_usd}`
- Return code: `{returncode}`

## Command

```text
{command_text}
```

## Prompt

```text
{prompt}
```

## Response stdout

```text
{stdout}
```

## Response stderr

```text
{stderr}
```
"""
    path.write_text(body, encoding="utf-8", newline="\n")


def main() -> None:
    parser = argparse.ArgumentParser(description="Send a packet to Claude Opus and log prompt/response.")
    parser.add_argument("--packet", help="Markdown packet path to send.")
    parser.add_argument("--prompt", help="Additional or standalone prompt text.")
    parser.add_argument(
        "--source-file",
        action="append",
        default=[],
        metavar="PATH",
        help="Embed a file verbatim into the packet (repeatable). Send the ACTUAL "
        "Lean of every theorem/definition under review, not a paraphrase.",
    )
    parser.add_argument("--slug", default="claude-review", help="Slug for the log filename.")
    parser.add_argument("--model", default="opus", help="Claude CLI model name. Default: opus.")
    parser.add_argument(
        "--max-budget-usd",
        default="1.50",
        help="Claude CLI max budget. Default 1.50 (embedded artifacts + optional "
        "read tools cost more than a prose-only call).",
    )
    parser.add_argument(
        "--tools",
        default=DEFAULT_TOOLS,
        help=f"Claude CLI --tools (built-in set). Default '{DEFAULT_TOOLS}' "
        "(writes are removed via the denylist, not here). Use '' for none.",
    )
    parser.add_argument(
        "--mcp-config",
        default=str(DEFAULT_MCP_CONFIG),
        help="MCP server config to load (--bare skips auto-discovery). Default: the "
        "read-only review config (neo4j read-only, scholarly, lean-explore).",
    )
    parser.add_argument(
        "--no-strict-mcp-config",
        dest="strict_mcp_config",
        action="store_false",
        help="Allow MCP servers beyond --mcp-config (default: strict).",
    )
    parser.add_argument(
        "--permission-mode",
        default=DEFAULT_PERMISSION_MODE,
        help=f"Claude CLI --permission-mode. Default '{DEFAULT_PERMISSION_MODE}' so "
        "tools fire non-interactively; the denylist blocks writes.",
    )
    parser.add_argument(
        "--allowed-tools",
        default="",
        help="Optional permission allowlist passthrough. Off by default - in this "
        "CLI build an allowlist suppressed all tools but Read.",
    )
    parser.add_argument(
        "--disallowed-tools",
        default=DEFAULT_DISALLOWED,
        help="Permission denylist; takes precedence. Default: all write tools "
        "(Bash stays enabled for read-only search scripts).",
    )
    parser.add_argument(
        "--safe",
        action="store_true",
        help="Also block Bash (zero write surface; disables the semantic-search "
        "scripts that need a shell).",
    )
    parser.add_argument(
        "--no-mcp",
        action="store_true",
        help="Do not load any MCP servers (built-in tools only).",
    )
    parser.add_argument(
        "--no-tools",
        action="store_true",
        help="Legacy mode: no tools, no MCP (reproduces the old prose-only call).",
    )
    parser.add_argument("--timeout-seconds", type=int, default=600)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--no-log", action="store_true")
    parser.add_argument("--claude-bin", default="claude")
    args = parser.parse_args()

    prompt = read_prompt(args)
    command = [
        args.claude_bin,
        "-p",
        "--bare",
        "--model",
        args.model,
        "--max-budget-usd",
        args.max_budget_usd,
        "--output-format",
        "text",
        "--add-dir",
        str(ROOT),
    ]
    if args.no_tools:
        command += ["--tools", ""]
    else:
        command += ["--tools", args.tools, "--permission-mode", args.permission_mode]
        disallowed = args.disallowed_tools
        if args.safe and "Bash" not in disallowed.split():
            disallowed = (disallowed + " Bash").strip()
        if args.allowed_tools:
            command += ["--allowed-tools", args.allowed_tools]
        if disallowed:
            command += ["--disallowed-tools", disallowed]
        if not args.no_mcp and args.mcp_config:
            command += ["--mcp-config", args.mcp_config]
            if args.strict_mcp_config:
                command += ["--strict-mcp-config"]
    started = dt.datetime.now().isoformat(timespec="seconds")
    stdout = ""
    stderr = ""
    returncode: int | None = None
    status = "dry-run"

    if args.dry_run:
        stdout = "Dry run only. No Claude call was made."
    else:
        try:
            proc = subprocess.run(
                command,
                input=prompt,
                text=True,
                capture_output=True,
                cwd=ROOT,
                timeout=args.timeout_seconds,
                check=False,
            )
            stdout = proc.stdout
            stderr = proc.stderr
            returncode = proc.returncode
            status = "completed" if proc.returncode == 0 else "failed"
        except subprocess.TimeoutExpired as exc:
            stdout = exc.stdout or ""
            stderr = exc.stderr or ""
            returncode = None
            status = "timeout"

    finished = dt.datetime.now().isoformat(timespec="seconds")
    if not args.no_log:
        log_path = make_log_path(args.slug)
        write_log(
            path=log_path,
            provider="Claude CLI",
            model=args.model,
            status=status,
            command=command,
            started=started,
            finished=finished,
            prompt=prompt,
            stdout=stdout,
            stderr=stderr,
            returncode=returncode,
            dry_run=args.dry_run,
            timeout_seconds=args.timeout_seconds,
            max_budget_usd=args.max_budget_usd,
        )
        print(log_path)
    else:
        print(status)

    if status not in {"completed", "dry-run"}:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
