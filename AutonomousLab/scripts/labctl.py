#!/usr/bin/env python3
"""Validate and operate the AFPL persistent state.

This tool deliberately uses only the Python standard library. It is a small
control surface for institutional memory, not a general agent framework.
"""

from __future__ import annotations

import argparse
import contextlib
import datetime as dt
import hashlib
import json
import os
import shutil
import socket
import subprocess
import sys
import time
import uuid
from collections import Counter
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
STATE_DIR = ROOT / "state"
LAB_STATE_PATH = STATE_DIR / "LAB_STATE.json"
PORTFOLIO_PATH = STATE_DIR / "PORTFOLIO.json"
WORK_ITEMS_PATH = STATE_DIR / "WORK_ITEMS.json"
LEDGER_PATH = STATE_DIR / "LEDGER.md"
FORECASTS_PATH = STATE_DIR / "FORECASTS.json"
ARISTOTLE_JOBS_PATH = STATE_DIR / "ARISTOTLE_JOBS.json"
CLAIMS_PATH = STATE_DIR / "CLAIMS.json"
FILE_LEASES_PATH = STATE_DIR / "FILE_LEASES.json"
HANDOFF_PATH = STATE_DIR / "HANDOFF.md"
MESSAGES_PATH = STATE_DIR / "MESSAGES.json"
ROLE_SCHEDULE_PATH = STATE_DIR / "ROLE_SCHEDULE.json"

MODELS = {"codex", "claude", "opus", "aristotle", "human"}
# Aristotle is a submit-and-return proof service: it can be the skeptic of
# record for a formal claim (via audit jobs), but it cannot own a work item,
# because owners must read and mutate lab state.
INTERACTIVE_MODELS = {"codex", "claude", "human"}
# `opus` remains a legacy schema value so historical messages and forecasts
# continue to validate. It is not an assignable channel: AFPL uses only the
# user-started interactive Claude Code session for Claude-family work.
MODEL_FAMILIES = {
    "codex": "gpt",
    "claude": "claude",
    "opus": "claude",
    "aristotle": "aristotle",
    "human": "human",
}
ROLES = {
    "research_scientist",
    "skeptic",
    "visionary",
    "phenomenologist",
    "reproducer",
    "superstar",
    "educator",
    "archivist",
    "lab_manager",
}
ROLE_ALIASES = {"impact_strategist": "superstar"}
WORK_STATUSES = {
    "PROPOSED",
    "TRIAGED",
    "LITERATURE_MAPPED",
    "SPECIFIED",
    "PREREGISTERED",
    "EXECUTING",
    "VERIFYING",
    "RED_TEAM",
    "REPLICATING",
    "INTEGRATED",
    "RELEASE_CANDIDATE",
    "RELEASED",
    "BLOCKED",
    "KILLED",
    "SUPERSEDED",
    "PARKED",
    "RETRACTED",
}
ACTIVE_WORK_STATUSES = {
    "EXECUTING",
    "VERIFYING",
    "RED_TEAM",
    "REPLICATING",
}
QUEUE_STATUSES = {
    "TRIAGED",
    "LITERATURE_MAPPED",
    "SPECIFIED",
    "PREREGISTERED",
    "BLOCKED",
}
TRANSITIONS = {
    "PROPOSED": {"TRIAGED", "PARKED", "KILLED"},
    "TRIAGED": {"LITERATURE_MAPPED", "SPECIFIED", "PARKED", "KILLED"},
    "LITERATURE_MAPPED": {"SPECIFIED", "PARKED", "KILLED"},
    "SPECIFIED": {"PREREGISTERED", "BLOCKED", "PARKED", "KILLED"},
    "PREREGISTERED": {"EXECUTING", "BLOCKED", "PARKED", "KILLED"},
    "EXECUTING": {"VERIFYING", "BLOCKED", "KILLED", "PARKED"},
    "VERIFYING": {"RED_TEAM", "EXECUTING", "BLOCKED", "KILLED"},
    "RED_TEAM": {"REPLICATING", "EXECUTING", "KILLED", "PARKED"},
    "REPLICATING": {"INTEGRATED", "EXECUTING", "KILLED", "BLOCKED"},
    "INTEGRATED": {"RELEASE_CANDIDATE", "RETRACTED", "SUPERSEDED"},
    "RELEASE_CANDIDATE": {"RELEASED", "INTEGRATED", "RETRACTED"},
    "RELEASED": {"RETRACTED", "SUPERSEDED"},
    "BLOCKED": {"EXECUTING", "SPECIFIED", "PARKED", "KILLED"},
    "PARKED": {"TRIAGED", "SPECIFIED", "SUPERSEDED"},
    "KILLED": {"SUPERSEDED"},
    "SUPERSEDED": set(),
    "RETRACTED": {"SUPERSEDED"},
}
# States whose first entry resolves the item's preregistered forecast.
FORECAST_RESOLUTIONS = {
    "INTEGRATED": "success",
    "RELEASED": "success",
    "KILLED": "failure",
    "RETRACTED": "failure",
}
JOB_STATUSES = {
    "submitted",
    "running",
    "idle",
    "unknown",
    "harvested",
    "integrated",
    "deferred",
    "cancelled",
    "failed",
}
ACTIVE_JOB_STATUSES = {"submitted", "running"}
REVIEW_STATUSES = {"RED_TEAM", "REPLICATING"}
CLAIM_GRADES = {"T", "T|H", "M", "M+E", "S", "C", "I", "X"}
AVAILABILITY_STATUSES = {"available", "degraded", "unavailable"}
EXECUTION_MODES = {"collaborative", "solo"}
SOLO_EXECUTORS = {"codex", "claude"}
MESSAGE_KINDS = {"request", "review", "completion", "blocker", "notice"}
MESSAGE_PRIORITIES = {"low", "normal", "high", "urgent"}
MESSAGE_STATES = {"open", "claimed", "completed", "cancelled"}
ROLE_MODES = {"continuous", "event_driven", "periodic"}
ROLE_ACTIVATION_STATES = {"active", "completed", "cancelled"}
ROLE_DUTY_ORDER = [
    "lab_manager",
    "visionary",
    "superstar",
    "archivist",
    "phenomenologist",
    "educator",
]
CADENCES = {"daily": 1, "weekly": 7, "monthly": 31, "quarterly": 93, "annual": 366}


def now_iso() -> str:
    return dt.datetime.now().astimezone().isoformat(timespec="seconds")


def model_family(model: str) -> str:
    return MODEL_FAMILIES.get(model, "unknown")


def execution_mode(state: dict[str, Any]) -> dict[str, Any]:
    """Return the execution mode, defaulting old state to collaborative."""
    value = state.get("execution_mode")
    if isinstance(value, dict):
        return value
    return {
        "kind": "collaborative",
        "active_model": None,
        "proof_backend": "aristotle",
        "independent_review_policy": "cross_family_required",
    }


def solo_active_model(state: dict[str, Any]) -> str | None:
    mode = execution_mode(state)
    if mode.get("kind") != "solo":
        return None
    active = mode.get("active_model")
    return active if isinstance(active, str) else None


def model_execution_allowed(state: dict[str, Any], model: str) -> bool:
    """Whether a model may take an executor role in the current mode."""
    active = solo_active_model(state)
    return active is None or model in {active, "human"}


def execution_mode_text(state: dict[str, Any]) -> str:
    mode = execution_mode(state)
    if mode.get("kind") == "solo":
        return f"solo / active={mode.get('active_model', '?')}"
    return "collaborative"


def solo_mode_expired(
    state: dict[str, Any], now: dt.datetime | None = None
) -> bool:
    mode = execution_mode(state)
    if mode.get("kind") != "solo":
        return False
    try:
        planned_end = dt.datetime.fromisoformat(str(mode["planned_end_at"]))
    except (KeyError, ValueError):
        return True
    return planned_end <= (now or dt.datetime.now().astimezone())


def normalized_repo_path(value: str) -> str:
    """Return a stable repository-relative path or raise ValueError."""
    path = Path(value.replace("\\", "/"))
    if path.is_absolute() or ".." in path.parts or not path.parts:
        raise ValueError(f"path must be repository-relative without '..': {value}")
    return path.as_posix().rstrip("/")


def paths_overlap(left: str, right: str) -> bool:
    left_parts = Path(left).parts
    right_parts = Path(right).parts
    width = min(len(left_parts), len(right_parts))
    return left_parts[:width] == right_parts[:width]


def state_watermark() -> str:
    """Hash the machine-readable state that a handoff summarizes."""
    digest = hashlib.sha256()
    for path in sorted(STATE_DIR.glob("*.json")):
        digest.update(path.name.encode("utf-8"))
        digest.update(b"\0")
        digest.update(path.read_bytes())
        digest.update(b"\0")
    return digest.hexdigest()


def artifact_digest(value: str) -> tuple[str, str]:
    """Hash a repository artifact, including a stable recursive directory hash."""
    normalized = normalized_repo_path(value)
    path = ROOT.parent / normalized
    if not path.exists():
        raise ValueError(f"artifact does not exist: {normalized}")
    digest = hashlib.sha256()
    if path.is_file():
        digest.update(path.read_bytes())
    else:
        files = sorted(candidate for candidate in path.rglob("*") if candidate.is_file())
        for candidate in files:
            digest.update(candidate.relative_to(path).as_posix().encode("utf-8"))
            digest.update(b"\0")
            digest.update(candidate.read_bytes())
            digest.update(b"\0")
    return normalized, digest.hexdigest()


def load_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        value = json.load(handle)
    if not isinstance(value, dict):
        raise ValueError(f"{path} must contain a JSON object")
    return value


def parse_iso(value: str) -> dt.datetime:
    parsed = dt.datetime.fromisoformat(value)
    if parsed.tzinfo is None:
        raise ValueError("timestamp must include a UTC offset")
    return parsed


def load_role_schedule() -> dict[str, Any]:
    if not ROLE_SCHEDULE_PATH.exists():
        return {"schema_version": 1, "policies": {}, "activations": []}
    return load_json(ROLE_SCHEDULE_PATH)


def role_schedule_rows(
    registry: dict[str, Any], now: dt.datetime | None = None
) -> list[dict[str, Any]]:
    """Return current activation coverage for every declared role policy."""
    now = now or dt.datetime.now().astimezone()
    activations = registry.get("activations", [])
    rows: list[dict[str, Any]] = []
    for role, policy in registry.get("policies", {}).items():
        mode = policy.get("mode")
        role_activations = [
            activation
            for activation in activations
            if activation.get("role") == role
        ]
        active = [
            activation
            for activation in role_activations
            if activation.get("status") == "active"
        ]
        active.sort(key=lambda value: value.get("started_at", ""), reverse=True)
        completed = [
            activation
            for activation in role_activations
            if activation.get("status") == "completed"
        ]
        completed.sort(
            key=lambda value: value.get("completed_at", ""), reverse=True
        )
        row: dict[str, Any] = {
            "role": role,
            "mode": mode,
            "status": mode.upper() if isinstance(mode, str) else "INVALID",
            "active": active[0] if active else None,
            "last_completed": completed[0] if completed else None,
            "due_at": None,
        }
        if mode == "periodic":
            if active:
                due_at = parse_iso(active[0]["due_at"])
                row["due_at"] = due_at
                row["status"] = "ACTIVE" if due_at > now else "OVERDUE_ACTIVE"
            else:
                if completed:
                    cadence = float(policy["cadence_hours"])
                    due_at = parse_iso(completed[0]["completed_at"]) + dt.timedelta(
                        hours=cadence
                    )
                else:
                    due_at = parse_iso(policy["first_due_at"])
                row["due_at"] = due_at
                row["status"] = "DUE" if due_at <= now else "SCHEDULED"
        elif active:
            due_at = parse_iso(active[0]["due_at"])
            row["due_at"] = due_at
            row["status"] = "ACTIVE" if due_at > now else "OVERDUE_ACTIVE"
        rows.append(row)
    order = {role: index for index, role in enumerate(ROLE_DUTY_ORDER)}
    rows.sort(key=lambda row: (order.get(row["role"], 100), row["role"]))
    return rows


def overdue_role_rows(
    registry: dict[str, Any], now: dt.datetime | None = None
) -> list[dict[str, Any]]:
    return [
        row
        for row in role_schedule_rows(registry, now)
        if row["status"] in {"DUE", "OVERDUE_ACTIVE"}
    ]


def atomic_write_json(path: Path, value: dict[str, Any]) -> None:
    temporary = path.with_suffix(
        path.suffix + f".{os.getpid()}.{uuid.uuid4().hex}.tmp"
    )
    try:
        with temporary.open("w", encoding="utf-8", newline="\n") as handle:
            json.dump(value, handle, indent=2, ensure_ascii=True)
            handle.write("\n")
            handle.flush()
            os.fsync(handle.fileno())
        deadline = time.monotonic() + 2.0
        while True:
            try:
                os.replace(temporary, path)
                break
            except PermissionError:
                # Windows can briefly deny replacement while another process
                # has just closed the destination or a scanner is inspecting it.
                if time.monotonic() >= deadline:
                    raise
                time.sleep(0.05)
    finally:
        temporary.unlink(missing_ok=True)


@contextlib.contextmanager
def state_write_lock(name: str, timeout_seconds: float = 10.0):
    """Serialize a registry read-modify-write transaction across processes."""
    lock_dir = STATE_DIR / f".{name}.lock"
    deadline = time.monotonic() + timeout_seconds
    while True:
        try:
            lock_dir.mkdir()
            break
        except FileExistsError:
            try:
                age = time.time() - lock_dir.stat().st_mtime
                if age > 300:
                    lock_dir.rmdir()
                    continue
            except FileNotFoundError:
                continue
            if time.monotonic() >= deadline:
                raise TimeoutError(f"timed out waiting for state lock {name}")
            time.sleep(0.05)
    try:
        yield
    finally:
        try:
            lock_dir.rmdir()
        except FileNotFoundError:
            pass


def append_ledger(model: str, role: str, work_id: str, message: str) -> None:
    # System clock with a numeric offset: hand-written stamps have drifted
    # from wall time in past runs, and %Z is verbose on Windows.
    stamp = dt.datetime.now().astimezone().strftime("%Y-%m-%d %H:%M %z")
    entry = (
        f"\n## {stamp} - {model} - {role} - {work_id}\n\n"
        f"- {message.strip()}\n"
    )
    with LEDGER_PATH.open("a", encoding="utf-8", newline="\n") as handle:
        handle.write(entry)


def _duplicates(values: list[str]) -> list[str]:
    counts = Counter(values)
    return sorted(value for value, count in counts.items() if count > 1)


def validate_data(
    state: dict[str, Any],
    portfolio: dict[str, Any],
    work_items: dict[str, Any],
) -> list[str]:
    errors: list[str] = []

    for name, document in (
        ("LAB_STATE", state),
        ("PORTFOLIO", portfolio),
        ("WORK_ITEMS", work_items),
    ):
        if document.get("schema_version") != 1:
            errors.append(f"{name}: schema_version must be 1")

    mode = execution_mode(state)
    mode_kind = mode.get("kind")
    if mode_kind not in EXECUTION_MODES:
        errors.append(
            "LAB_STATE: execution_mode.kind must be collaborative or solo"
        )
    elif mode_kind == "solo":
        if mode.get("active_model") not in SOLO_EXECUTORS:
            errors.append(
                "LAB_STATE: solo execution_mode requires active_model codex or claude"
            )
        if mode.get("proof_backend") != "aristotle":
            errors.append(
                "LAB_STATE: solo execution_mode proof_backend must be aristotle"
            )
        if mode.get("independent_review_policy") != "defer_cross_family":
            errors.append(
                "LAB_STATE: solo execution_mode must defer unavailable "
                "cross-family review"
            )
        if not str(mode.get("reason", "")).strip():
            errors.append("LAB_STATE: solo execution_mode requires a reason")
        try:
            started = parse_iso(mode["started_at"])
            planned_end = parse_iso(mode["planned_end_at"])
            if planned_end <= started:
                errors.append(
                    "LAB_STATE: solo execution_mode planned_end_at must follow started_at"
                )
        except (KeyError, TypeError, ValueError):
            errors.append(
                "LAB_STATE: solo execution_mode requires offset-aware started_at and "
                "planned_end_at"
            )
    elif mode.get("active_model") is not None:
        errors.append(
            "LAB_STATE: collaborative execution_mode active_model must be null"
        )

    projects = portfolio.get("projects")
    if not isinstance(projects, list):
        errors.append("PORTFOLIO: projects must be a list")
        projects = []
    project_ids = [p.get("id") for p in projects if isinstance(p, dict)]
    if None in project_ids or "" in project_ids:
        errors.append("PORTFOLIO: every project needs a nonempty id")
    for duplicate in _duplicates([p for p in project_ids if isinstance(p, str)]):
        errors.append(f"PORTFOLIO: duplicate project id {duplicate}")
    project_by_id = {
        p["id"]: p
        for p in projects
        if isinstance(p, dict) and isinstance(p.get("id"), str) and p["id"]
    }

    required_project_fields = {
        "id",
        "title",
        "program",
        "status",
        "priority",
        "srl",
        "lead_model",
        "skeptic_model",
        "current_gate",
        "kill_condition",
        "next_action",
        "target_review",
    }
    for project in projects:
        if not isinstance(project, dict):
            errors.append("PORTFOLIO: project entries must be objects")
            continue
        missing = sorted(required_project_fields - project.keys())
        if missing:
            errors.append(f"{project.get('id', '?')}: missing project fields {missing}")
        if project.get("lead_model") not in MODELS:
            errors.append(f"{project.get('id', '?')}: invalid lead_model")
        if project.get("skeptic_model") not in MODELS:
            errors.append(f"{project.get('id', '?')}: invalid skeptic_model")
        if MODEL_FAMILIES.get(project.get("lead_model")) == MODEL_FAMILIES.get(
            project.get("skeptic_model")
        ):
            errors.append(
                f"{project.get('id', '?')}: lead and skeptic must be from "
                "different model families"
            )
        srl = project.get("srl")
        if not isinstance(srl, int) or not 0 <= srl <= 9:
            errors.append(f"{project.get('id', '?')}: srl must be an integer 0..9")
        if not str(project.get("kill_condition", "")).strip():
            errors.append(f"{project.get('id', '?')}: missing kill_condition")

    active_ids = state.get("active_project_ids")
    if not isinstance(active_ids, list):
        errors.append("LAB_STATE: active_project_ids must be a list")
        active_ids = []
    for project_id in active_ids:
        if project_id not in project_by_id:
            errors.append(f"LAB_STATE: unknown active project {project_id}")
        elif project_by_id[project_id].get("status") != "active":
            errors.append(f"LAB_STATE: active project {project_id} is not status=active")
    science_count = len([p for p in active_ids if p != "LAB-INFRA"])
    max_science = state.get("work_in_progress_limits", {}).get("active_science_projects")
    if isinstance(max_science, int) and science_count > max_science:
        errors.append(
            f"LAB_STATE: {science_count} active science projects exceeds limit {max_science}"
        )

    items = work_items.get("items")
    if not isinstance(items, list):
        errors.append("WORK_ITEMS: items must be a list")
        items = []
    item_ids = [i.get("id") for i in items if isinstance(i, dict)]
    for duplicate in _duplicates([i for i in item_ids if isinstance(i, str)]):
        errors.append(f"WORK_ITEMS: duplicate item id {duplicate}")

    required_item_fields = {
        "id",
        "project_id",
        "parent_id",
        "depends_on",
        "title",
        "status",
        "priority",
        "role",
        "owner_model",
        "skeptic_model",
        "exact_claim",
        "nearest_work",
        "success_criterion",
        "kill_condition",
        "next_action",
        "resource_ceiling",
        "deliverables",
        "evidence_paths",
        "claim_ids",
        "verification_commands",
        "forecast_success",
        "target_date",
    }
    active_by_model: Counter[str] = Counter()
    for item in items:
        if not isinstance(item, dict):
            errors.append("WORK_ITEMS: item entries must be objects")
            continue
        item_id = item.get("id", "?")
        missing = sorted(required_item_fields - item.keys())
        if missing:
            errors.append(f"{item_id}: missing work-item fields {missing}")
        if item.get("project_id") not in project_by_id:
            errors.append(f"{item_id}: unknown project_id {item.get('project_id')}")
        if item.get("status") not in WORK_STATUSES:
            errors.append(f"{item_id}: invalid status {item.get('status')}")
        if item.get("role") not in ROLES:
            errors.append(f"{item_id}: invalid role {item.get('role')}")
        if item.get("owner_model") not in MODELS:
            errors.append(f"{item_id}: invalid owner_model")
        elif item.get("owner_model") not in INTERACTIVE_MODELS:
            errors.append(
                f"{item_id}: owner_model must be an interactive agent; "
                "aristotle participates through jobs on an owned item"
            )
        if item.get("skeptic_model") not in MODELS:
            errors.append(f"{item_id}: invalid skeptic_model")
        if MODEL_FAMILIES.get(item.get("owner_model")) == MODEL_FAMILIES.get(
            item.get("skeptic_model")
        ):
            errors.append(
                f"{item_id}: owner and skeptic must be from different model families"
            )
        for field in (
            "exact_claim",
            "nearest_work",
            "success_criterion",
            "kill_condition",
            "next_action",
            "resource_ceiling",
        ):
            if not str(item.get(field, "")).strip():
                errors.append(f"{item_id}: missing {field}")
        for field in (
            "depends_on",
            "deliverables",
            "evidence_paths",
            "claim_ids",
            "verification_commands",
        ):
            if not isinstance(item.get(field), list):
                errors.append(f"{item_id}: {field} must be a list")
        if not item.get("deliverables"):
            errors.append(f"{item_id}: deliverables must not be empty")
        if not item.get("verification_commands"):
            errors.append(f"{item_id}: verification_commands must not be empty")
        forecast = item.get("forecast_success")
        if not isinstance(forecast, (int, float)) or not 0 <= forecast <= 1:
            errors.append(f"{item_id}: forecast_success must be in [0,1]")
        if item.get("status") in ACTIVE_WORK_STATUSES:
            active_by_model[str(item.get("owner_model"))] += 1

    item_id_set = {value for value in item_ids if isinstance(value, str)}
    dependency_graph: dict[str, list[str]] = {}
    for item in items:
        if not isinstance(item, dict) or not isinstance(item.get("id"), str):
            continue
        item_id = item["id"]
        parent_id = item.get("parent_id")
        if parent_id is not None and parent_id not in item_id_set:
            errors.append(f"{item_id}: unknown parent_id {parent_id}")
        dependencies = item.get("depends_on", [])
        if isinstance(dependencies, list):
            dependency_graph[item_id] = []
            for dependency in dependencies:
                if dependency not in item_id_set:
                    errors.append(f"{item_id}: unknown dependency {dependency}")
                elif dependency == item_id:
                    errors.append(f"{item_id}: cannot depend on itself")
                else:
                    dependency_graph[item_id].append(dependency)

    visiting: set[str] = set()
    visited: set[str] = set()

    def visit(item_id: str) -> None:
        if item_id in visiting:
            errors.append(f"WORK_ITEMS: dependency cycle includes {item_id}")
            return
        if item_id in visited:
            return
        visiting.add(item_id)
        for dependency in dependency_graph.get(item_id, []):
            visit(dependency)
        visiting.remove(item_id)
        visited.add(item_id)

    for item_id in dependency_graph:
        visit(item_id)

    max_per_model = state.get("work_in_progress_limits", {}).get(
        "executing_items_per_model"
    )
    if isinstance(max_per_model, int):
        for model, count in active_by_model.items():
            if count > max_per_model:
                errors.append(
                    f"WORK_ITEMS: {model} has {count} active items, limit {max_per_model}"
                )

    return errors


def validate_registries(
    state: dict[str, Any], work_items: dict[str, Any]
) -> list[str]:
    """Validate the optional registry files (forecasts, jobs, claims).

    Missing files are allowed; malformed files are errors. Kept separate from
    validate_data so existing callers and tests keep their signature.
    """
    errors: list[str] = []
    item_ids = {
        item.get("id")
        for item in work_items.get("items", [])
        if isinstance(item, dict)
    }

    if FORECASTS_PATH.exists():
        forecasts = load_json(FORECASTS_PATH)
        if forecasts.get("schema_version") != 1:
            errors.append("FORECASTS: schema_version must be 1")
        entries = forecasts.get("entries", [])
        if not isinstance(entries, list):
            errors.append("FORECASTS: entries must be a list")
            entries = []
        for entry in entries:
            if not isinstance(entry, dict):
                errors.append("FORECASTS: entries must be objects")
                continue
            if entry.get("outcome") not in set(FORECAST_RESOLUTIONS.values()):
                errors.append(
                    f"FORECASTS {entry.get('item_id', '?')}: invalid outcome"
                )
            forecast = entry.get("forecast_success")
            if not isinstance(forecast, (int, float)) or not 0 <= forecast <= 1:
                errors.append(
                    f"FORECASTS {entry.get('item_id', '?')}: forecast out of range"
                )

    if ARISTOTLE_JOBS_PATH.exists():
        registry = load_json(ARISTOTLE_JOBS_PATH)
        if registry.get("schema_version") != 1:
            errors.append("ARISTOTLE_JOBS: schema_version must be 1")
        jobs = registry.get("jobs", [])
        if not isinstance(jobs, list):
            errors.append("ARISTOTLE_JOBS: jobs must be a list")
            jobs = []
        active = 0
        for job in jobs:
            if not isinstance(job, dict):
                errors.append("ARISTOTLE_JOBS: job entries must be objects")
                continue
            if not str(job.get("id", "")).strip():
                errors.append("ARISTOTLE_JOBS: every job needs a nonempty id")
            if job.get("status") not in JOB_STATUSES:
                errors.append(
                    f"ARISTOTLE_JOBS {job.get('id', '?')}: invalid status"
                )
            if job.get("status") in ACTIVE_JOB_STATUSES:
                active += 1
            work_item_id = job.get("work_item_id")
            if work_item_id is not None and work_item_id not in item_ids:
                errors.append(
                    f"ARISTOTLE_JOBS {job.get('id', '?')}: unknown work item "
                    f"{work_item_id}"
                )
        cap = state.get("work_in_progress_limits", {}).get("aristotle_projects")
        if isinstance(cap, int) and active > cap:
            errors.append(
                f"ARISTOTLE_JOBS: {active} active jobs exceeds fleet cap {cap} "
                "(record a Lab Manager capacity exception or cancel)"
            )

    if CLAIMS_PATH.exists():
        registry = load_json(CLAIMS_PATH)
        if registry.get("schema_version") != 1:
            errors.append("CLAIMS: schema_version must be 1")
        claims = registry.get("claims", [])
        if not isinstance(claims, list):
            errors.append("CLAIMS: claims must be a list")
            claims = []
        for duplicate in _duplicates(
            [c.get("id") for c in claims if isinstance(c, dict) and c.get("id")]
        ):
            errors.append(f"CLAIMS: duplicate claim id {duplicate}")
        for claim in claims:
            if not isinstance(claim, dict):
                errors.append("CLAIMS: claim entries must be objects")
                continue
            claim_id = claim.get("id", "?")
            if claim.get("grade") not in CLAIM_GRADES:
                errors.append(f"CLAIMS {claim_id}: invalid grade")
            srl = claim.get("srl")
            if not isinstance(srl, int) or not 0 <= srl <= 9:
                errors.append(f"CLAIMS {claim_id}: srl must be an integer 0..9")
            if claim.get("grade") in {"M", "M+E"}:
                anchors = claim.get("decl_anchors")
                if not isinstance(anchors, list) or not anchors:
                    errors.append(
                        f"CLAIMS {claim_id}: grade {claim.get('grade')} requires "
                        "nonempty decl_anchors"
                    )
        claim_ids = {
            claim.get("id") for claim in claims if isinstance(claim, dict)
        }
        for item in work_items.get("items", []):
            if not isinstance(item, dict):
                continue
            for claim_id in item.get("claim_ids", []):
                if claim_id not in claim_ids:
                    errors.append(
                        f"WORK_ITEMS {item.get('id', '?')}: unknown claim_id {claim_id}"
                    )

    if FILE_LEASES_PATH.exists():
        registry = load_json(FILE_LEASES_PATH)
        if registry.get("schema_version") != 1:
            errors.append("FILE_LEASES: schema_version must be 1")
        leases = registry.get("leases", [])
        if not isinstance(leases, list):
            errors.append("FILE_LEASES: leases must be a list")
            leases = []
        now = dt.datetime.now().astimezone()
        active: list[dict[str, Any]] = []
        for lease in leases:
            if not isinstance(lease, dict):
                errors.append("FILE_LEASES: lease entries must be objects")
                continue
            try:
                path = normalized_repo_path(str(lease.get("path", "")))
            except ValueError as exc:
                errors.append(f"FILE_LEASES: {exc}")
                continue
            if path != lease.get("path"):
                errors.append(f"FILE_LEASES: path is not normalized: {lease.get('path')}")
            if lease.get("owner_model") not in INTERACTIVE_MODELS:
                errors.append(f"FILE_LEASES {path}: invalid owner_model")
            if lease.get("work_item_id") not in item_ids:
                errors.append(f"FILE_LEASES {path}: unknown work_item_id")
            try:
                expires = dt.datetime.fromisoformat(str(lease.get("expires_at")))
            except ValueError:
                errors.append(f"FILE_LEASES {path}: invalid expires_at")
                continue
            if expires > now:
                active.append(lease)
        for index, left in enumerate(active):
            for right in active[index + 1 :]:
                if paths_overlap(left["path"], right["path"]):
                    errors.append(
                        "FILE_LEASES: overlapping active leases "
                        f"{left['path']} and {right['path']}"
                    )

    if MESSAGES_PATH.exists():
        registry = load_json(MESSAGES_PATH)
        if registry.get("schema_version") != 1:
            errors.append("MESSAGES: schema_version must be 1")
        messages = registry.get("messages", [])
        if not isinstance(messages, list):
            errors.append("MESSAGES: messages must be a list")
            messages = []
        message_ids = [
            message.get("id")
            for message in messages
            if isinstance(message, dict) and message.get("id")
        ]
        for duplicate in _duplicates(message_ids):
            errors.append(f"MESSAGES: duplicate message id {duplicate}")
        for message in messages:
            if not isinstance(message, dict):
                errors.append("MESSAGES: message entries must be objects")
                continue
            message_id = message.get("id", "?")
            if message.get("from_model") not in INTERACTIVE_MODELS:
                errors.append(f"MESSAGES {message_id}: invalid from_model")
            if message.get("to_model") not in INTERACTIVE_MODELS | {"all"}:
                errors.append(f"MESSAGES {message_id}: invalid to_model")
            if message.get("kind") not in MESSAGE_KINDS:
                errors.append(f"MESSAGES {message_id}: invalid kind")
            if message.get("priority") not in MESSAGE_PRIORITIES:
                errors.append(f"MESSAGES {message_id}: invalid priority")
            if message.get("state") not in MESSAGE_STATES:
                errors.append(f"MESSAGES {message_id}: invalid state")
            work_item_id = message.get("work_item_id")
            if work_item_id is not None and work_item_id not in item_ids:
                errors.append(f"MESSAGES {message_id}: unknown work_item_id")
            for field in ("subject", "body", "created_at", "expires_at"):
                if not str(message.get(field, "")).strip():
                    errors.append(f"MESSAGES {message_id}: missing {field}")
            for field in ("artifacts", "commands", "acknowledgements"):
                if not isinstance(message.get(field), list):
                    errors.append(f"MESSAGES {message_id}: {field} must be a list")
            for artifact in message.get("artifacts", []):
                if not isinstance(artifact, dict):
                    errors.append(f"MESSAGES {message_id}: invalid artifact record")
                    continue
                try:
                    normalized = normalized_repo_path(str(artifact.get("path", "")))
                except ValueError as exc:
                    errors.append(f"MESSAGES {message_id}: {exc}")
                    continue
                if normalized != artifact.get("path"):
                    errors.append(f"MESSAGES {message_id}: artifact path not normalized")
                digest = artifact.get("sha256")
                if not isinstance(digest, str) or len(digest) != 64:
                    errors.append(f"MESSAGES {message_id}: invalid artifact digest")
            if message.get("state") == "claimed":
                if message.get("claimed_by") not in INTERACTIVE_MODELS:
                    errors.append(f"MESSAGES {message_id}: claimed message lacks owner")
                if not message.get("claim_expires_at"):
                    errors.append(f"MESSAGES {message_id}: claimed message lacks expiry")
            if message.get("state") == "completed":
                if message.get("completed_by") not in INTERACTIVE_MODELS:
                    errors.append(f"MESSAGES {message_id}: completed message lacks owner")
                if not message.get("completed_at"):
                    errors.append(f"MESSAGES {message_id}: completed message lacks time")

    if ROLE_SCHEDULE_PATH.exists():
        registry = load_json(ROLE_SCHEDULE_PATH)
        if registry.get("schema_version") != 1:
            errors.append("ROLE_SCHEDULE: schema_version must be 1")
        policies = registry.get("policies", {})
        if not isinstance(policies, dict):
            errors.append("ROLE_SCHEDULE: policies must be an object")
            policies = {}
        missing_roles = sorted(ROLES - set(policies))
        extra_roles = sorted(set(policies) - ROLES)
        if missing_roles:
            errors.append(f"ROLE_SCHEDULE: missing role policies {missing_roles}")
        if extra_roles:
            errors.append(f"ROLE_SCHEDULE: unknown role policies {extra_roles}")
        for role, policy in policies.items():
            if not isinstance(policy, dict):
                errors.append(f"ROLE_SCHEDULE {role}: policy must be an object")
                continue
            mode = policy.get("mode")
            if mode not in ROLE_MODES:
                errors.append(f"ROLE_SCHEDULE {role}: invalid mode")
            cadence = policy.get("cadence_hours")
            if mode == "periodic":
                if not isinstance(cadence, (int, float)) or cadence <= 0:
                    errors.append(
                        f"ROLE_SCHEDULE {role}: periodic cadence must be positive"
                    )
                try:
                    parse_iso(str(policy.get("first_due_at")))
                except ValueError:
                    errors.append(f"ROLE_SCHEDULE {role}: invalid first_due_at")
            elif cadence is not None:
                errors.append(
                    f"ROLE_SCHEDULE {role}: nonperiodic cadence must be null"
                )
            session = policy.get("session_hours")
            if mode != "continuous" and (
                not isinstance(session, (int, float)) or session <= 0
            ):
                errors.append(
                    f"ROLE_SCHEDULE {role}: session_hours must be positive"
                )
            if not str(policy.get("output_contract", "")).strip():
                errors.append(f"ROLE_SCHEDULE {role}: missing output_contract")
        activations = registry.get("activations", [])
        if not isinstance(activations, list):
            errors.append("ROLE_SCHEDULE: activations must be a list")
            activations = []
        activation_ids = [
            activation.get("id")
            for activation in activations
            if isinstance(activation, dict) and activation.get("id")
        ]
        for duplicate in _duplicates(activation_ids):
            errors.append(f"ROLE_SCHEDULE: duplicate activation id {duplicate}")
        active_by_role: Counter[str] = Counter()
        for activation in activations:
            if not isinstance(activation, dict):
                errors.append("ROLE_SCHEDULE: activation entries must be objects")
                continue
            activation_id = activation.get("id", "?")
            role = activation.get("role")
            if role not in ROLES:
                errors.append(f"ROLE_SCHEDULE {activation_id}: invalid role")
            if activation.get("model") not in INTERACTIVE_MODELS:
                errors.append(f"ROLE_SCHEDULE {activation_id}: invalid model")
            if activation.get("model_family") != model_family(
                str(activation.get("model"))
            ):
                errors.append(
                    f"ROLE_SCHEDULE {activation_id}: incorrect model_family"
                )
            status = activation.get("status")
            if status not in ROLE_ACTIVATION_STATES:
                errors.append(f"ROLE_SCHEDULE {activation_id}: invalid status")
            if status == "active" and role in ROLES:
                active_by_role[role] += 1
            for field in ("started_at", "due_at"):
                try:
                    parse_iso(str(activation.get(field)))
                except ValueError:
                    errors.append(
                        f"ROLE_SCHEDULE {activation_id}: invalid {field}"
                    )
            for field in ("packet_path", "deliverable_path"):
                try:
                    normalized = normalized_repo_path(
                        str(activation.get(field, ""))
                    )
                except ValueError as exc:
                    errors.append(f"ROLE_SCHEDULE {activation_id}: {exc}")
                    continue
                if normalized != activation.get(field):
                    errors.append(
                        f"ROLE_SCHEDULE {activation_id}: {field} not normalized"
                    )
            work_item_id = activation.get("work_item_id")
            if work_item_id is not None and work_item_id not in item_ids:
                errors.append(
                    f"ROLE_SCHEDULE {activation_id}: unknown work_item_id"
                )
            if status == "completed":
                try:
                    parse_iso(str(activation.get("completed_at")))
                except ValueError:
                    errors.append(
                        f"ROLE_SCHEDULE {activation_id}: invalid completed_at"
                    )
                artifact = activation.get("artifact")
                if not isinstance(artifact, dict):
                    errors.append(
                        f"ROLE_SCHEDULE {activation_id}: completed activation lacks artifact"
                    )
                elif not isinstance(artifact.get("sha256"), str) or len(
                    artifact.get("sha256", "")
                ) != 64:
                    errors.append(
                        f"ROLE_SCHEDULE {activation_id}: invalid artifact digest"
                    )
        for role, count in active_by_role.items():
            if count > 1:
                errors.append(
                    f"ROLE_SCHEDULE: role {role} has {count} active activations"
                )

    return errors


def record_forecast_resolution(
    item: dict[str, Any], new_status: str, model: str, role: str
) -> bool:
    """Record the item's forecast outcome on first entry to a resolving state."""
    if new_status not in FORECAST_RESOLUTIONS:
        return False
    if FORECASTS_PATH.exists():
        forecasts = load_json(FORECASTS_PATH)
    else:
        forecasts = {"schema_version": 1, "entries": []}
    entries = forecasts.setdefault("entries", [])
    if any(entry.get("item_id") == item["id"] for entry in entries):
        return False
    entries.append(
        {
            "item_id": item["id"],
            "forecast_success": item.get("forecast_success"),
            "outcome": FORECAST_RESOLUTIONS[new_status],
            "resolved_status": new_status,
            "resolved_at": dt.datetime.now().astimezone().isoformat(
                timespec="seconds"
            ),
            "recorded_by": f"{model}/{role}",
        }
    )
    forecasts["updated_at"] = dt.datetime.now().astimezone().isoformat(
        timespec="seconds"
    )
    atomic_write_json(FORECASTS_PATH, forecasts)
    return True


def load_all() -> tuple[dict[str, Any], dict[str, Any], dict[str, Any]]:
    return (
        load_json(LAB_STATE_PATH),
        load_json(PORTFOLIO_PATH),
        load_json(WORK_ITEMS_PATH),
    )


def command_validate(_: argparse.Namespace) -> int:
    state, portfolio, work = load_all()
    errors = validate_data(state, portfolio, work)
    errors.extend(validate_registries(state, work))
    if errors:
        print("AFPL state validation failed:")
        for error in errors:
            print(f"- {error}")
        return 1
    print("AFPL state validation passed.")
    return 0


def command_mode(_: argparse.Namespace) -> int:
    state, _, _ = load_all()
    mode = execution_mode(state)
    print(f"AFPL execution mode: {execution_mode_text(state)}")
    print(f"- proof backend: {mode.get('proof_backend', 'aristotle')}")
    print(
        "- independent review policy: "
        f"{mode.get('independent_review_policy', 'cross_family_required')}"
    )
    if mode.get("kind") == "solo":
        print(f"- started: {mode.get('started_at')}")
        print(f"- planned end: {mode.get('planned_end_at')}")
        print(f"- reason: {mode.get('reason')}")
        print(
            "- boundary: same-family role changes are self-audits; reviews "
            "requiring another interactive family remain queued"
        )
        if solo_mode_expired(state):
            print("- WARNING: planned solo interval has expired; leave a handoff and reset mode")
    return 0


def command_mode_set(args: argparse.Namespace) -> int:
    now = dt.datetime.now().astimezone()
    if args.kind == "solo":
        if args.active_model not in SOLO_EXECUTORS:
            print(
                "Solo mode requires --active-model codex or claude.",
                file=sys.stderr,
            )
            return 1
        if args.hours is None or args.hours <= 0:
            print("Solo mode requires positive --hours.", file=sys.stderr)
            return 1
        if not args.reason.strip():
            print("Solo mode requires --reason.", file=sys.stderr)
            return 1
        planned_end = now + dt.timedelta(hours=args.hours)
        new_mode = {
            "kind": "solo",
            "active_model": args.active_model,
            "proof_backend": "aristotle",
            "independent_review_policy": "defer_cross_family",
            "started_at": now.isoformat(timespec="seconds"),
            "planned_end_at": planned_end.isoformat(timespec="seconds"),
            "reason": args.reason.strip(),
        }
    else:
        if args.active_model is not None:
            print(
                "Collaborative mode does not accept --active-model.",
                file=sys.stderr,
            )
            return 1
        new_mode = {
            "kind": "collaborative",
            "active_model": None,
            "proof_backend": "aristotle",
            "independent_review_policy": "cross_family_required",
            "started_at": now.isoformat(timespec="seconds"),
            "planned_end_at": None,
            "reason": args.reason.strip() or "Resumed multi-model operation.",
        }
    try:
        with state_write_lock("lab-state"):
            state, portfolio, work = load_all()
            old_mode = execution_mode_text(state)
            state["execution_mode"] = new_mode
            errors = validate_data(state, portfolio, work)
            if errors:
                for error in errors:
                    print(f"- {error}", file=sys.stderr)
                return 1
            atomic_write_json(LAB_STATE_PATH, state)
    except TimeoutError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    append_ledger(
        args.model,
        "lab_manager",
        "EXECUTION-MODE",
        f"Changed execution mode from {old_mode} to {execution_mode_text(state)}. "
        f"Reason: {new_mode['reason']}",
    )
    print(f"Set AFPL execution mode: {execution_mode_text(state)}")
    if args.kind == "solo":
        print(f"Planned end: {new_mode['planned_end_at']}")
        print(
            "Cross-family reviews that the active model cannot satisfy will be "
            "reported as deferred, not waived."
        )
    print("Regenerate the handoff with `labctl.py handoff`.")
    return 0


def command_status(_: argparse.Namespace) -> int:
    state, portfolio, work = load_all()
    errors = validate_data(state, portfolio, work)
    if errors:
        print(f"WARNING: {len(errors)} validation error(s); run `labctl.py validate`.")
    cycle = state["current_cycle"]
    print(f"{state['lab_name']} ({state['short_name']})")
    print(
        f"Cycle {cycle['id']}: {cycle['status']} / {cycle['phase']} "
        f"({cycle['started_at']} -> {cycle['planned_end_at']})"
    )
    print(f"Execution mode: {execution_mode_text(state)}")
    mode = execution_mode(state)
    if mode.get("kind") == "solo":
        print(f"  planned end: {mode.get('planned_end_at')}")
        print("  cross-family review: deferred when the required family is paused")
    print(f"Strategic period: Year {state['strategic_year']} {state['strategic_quarter']}")
    print("Availability:")
    for model, record in state["availability"].items():
        detail = f" - {record.get('detail')}" if record.get("detail") else ""
        print(f"  {model}: {record['status']}{detail}")
    projects = {p["id"]: p for p in portfolio["projects"]}
    print("Active projects:")
    for project_id in state["active_project_ids"]:
        project = projects[project_id]
        print(
            f"  {project_id} [P{project['priority']}, SRL {project['srl']}]: "
            f"{project['current_gate']}"
        )
    active_items = [i for i in work["items"] if i["status"] in ACTIVE_WORK_STATUSES]
    print(f"Active work items ({len(active_items)}):")
    for item in sorted(active_items, key=lambda value: -value["priority"]):
        paused = " [PAUSED BY MODE]" if not model_execution_allowed(
            state, item["owner_model"]
        ) else ""
        print(
            f"  {item['id']} {item['status']} P{item['priority']} "
            f"{item['owner_model']}/{item['role']}{paused}: {item['next_action']}"
        )
    if ROLE_SCHEDULE_PATH.exists():
        rows = role_schedule_rows(load_role_schedule())
        print("Periodic role duties:")
        for row in rows:
            if row["mode"] != "periodic":
                continue
            model = row["active"].get("model") if row["active"] else "-"
            print(
                f"  {role_display_name(row['role'])}: {row['status']} "
                f"model={model} due="
                f"{row['due_at'].isoformat(timespec='seconds') if row['due_at'] else '-'}"
            )
    return 0


def command_queue(_: argparse.Namespace) -> int:
    _, _, work = load_all()
    items = [i for i in work["items"] if i["status"] in QUEUE_STATUSES]
    items.sort(key=lambda value: (-value["priority"], value["target_date"], value["id"]))
    if not items:
        print("AFPL queue is empty.")
        return 0
    for index, item in enumerate(items, start=1):
        print(
            f"{index}. {item['id']} [{item['status']}, P{item['priority']}, "
            f"forecast={item['forecast_success']:.2f}]\n"
            f"   owner={item['owner_model']}/{item['role']} "
            f"skeptic={item['skeptic_model']}\n"
            f"   next={item['next_action']}"
        )
    return 0


def review_route(item: dict[str, Any], state: dict[str, Any]) -> tuple[str, str]:
    """Choose an available channel in the required independent family."""
    requested = str(item["skeptic_model"])
    family = model_family(requested)
    if requested == "aristotle":
        return requested, "proof-service audit"
    active = solo_active_model(state)
    if active is not None:
        if model_family(active) == family:
            label = (
                "solo active independent family"
                if model_family(item.get("owner_model", "")) != family
                else "solo same-family self-audit only"
            )
            return active, label
        return requested, "deferred by solo mode"
    availability = state.get("availability", {})
    candidates = [
        channel
        for channel in INTERACTIVE_MODELS
        if model_family(channel) == family
        and availability.get(channel, {}).get("status") in {"available", "degraded"}
    ]
    candidates.sort(
        key=lambda channel: (
            availability.get(channel, {}).get("status") != "available",
            channel != requested,
            channel,
        )
    )
    if not candidates:
        return requested, "required family unavailable"
    chosen = candidates[0]
    label = "requested channel" if chosen == requested else "same-family fallback"
    return chosen, label


def prioritized_review_items(
    state: dict[str, Any], work: dict[str, Any]
) -> list[dict[str, Any]]:
    items = [item for item in work["items"] if item["status"] in REVIEW_STATUSES]
    status_rank = {"RED_TEAM": 0, "REPLICATING": 1}
    items.sort(
        key=lambda item: (
            status_rank[item["status"]],
            -item["priority"],
            item["target_date"],
            item["id"],
        )
    )
    return items


def command_review_queue(_: argparse.Namespace) -> int:
    state, _, work = load_all()
    items = prioritized_review_items(state, work)
    if not items:
        print("AFPL independent-review queue is empty.")
        return 0
    print(f"Independent-review queue ({len(items)}):")
    for index, item in enumerate(items, start=1):
        channel, route = review_route(item, state)
        print(
            f"{index}. {item['id']} [{item['status']}, P{item['priority']}]\n"
            f"   builder={item['owner_model']} ({model_family(item['owner_model'])}) "
            f"required_skeptic_family={model_family(item['skeptic_model'])}\n"
            f"   route={channel} ({route}) target={item['target_date']}\n"
            f"   nearest={item['nearest_work']}\n"
            f"   next={item['next_action']}"
        )
    return 0


def render_handoff(
    state: dict[str, Any], portfolio: dict[str, Any], work: dict[str, Any]
) -> str:
    projects = {project["id"]: project for project in portfolio["projects"]}
    active = sorted(
        [item for item in work["items"] if item["status"] in ACTIVE_WORK_STATUSES],
        key=lambda item: (-item["priority"], item["id"]),
    )
    queued = sorted(
        [item for item in work["items"] if item["status"] in QUEUE_STATUSES],
        key=lambda item: (-item["priority"], item["id"]),
    )
    jobs: list[dict[str, Any]] = []
    if ARISTOTLE_JOBS_PATH.exists():
        jobs = [
            job
            for job in load_json(ARISTOTLE_JOBS_PATH).get("jobs", [])
            if job.get("status") in ACTIVE_JOB_STATUSES
        ]
    messages: list[dict[str, Any]] = []
    if MESSAGES_PATH.exists():
        now = dt.datetime.now().astimezone()
        messages = [
            message
            for message in load_messages().get("messages", [])
            if message.get("state") in {"open", "claimed"}
            and not message_is_expired(message, now)
        ]
    lines = [
        "# Generated AFPL handoff",
        "",
        f"Generated-at: `{now_iso()}`",
        f"State-watermark: `{state_watermark()}`",
        "",
        "This operational handoff is generated from machine-readable state. "
        "Scientific boundary notes belong in work artifacts and the ledger, not "
        "in manually reconstructed status prose.",
        "",
        "## North star",
        "",
        state["north_star"],
        "",
        "## Cycle",
        "",
        f"- ID: `{state['current_cycle']['id']}`",
        f"- Phase: `{state['current_cycle']['phase']}`",
        f"- Planned end: `{state['current_cycle']['planned_end_at']}`",
        f"- Execution mode: `{execution_mode_text(state)}`",
        "",
    ]
    mode = execution_mode(state)
    if mode.get("kind") == "solo":
        lines.extend(
            [
                "## Solo-mode boundary",
                "",
                f"- Active executor: `{mode.get('active_model')}`",
                f"- Proof backend: `{mode.get('proof_backend')}`",
                f"- Planned end: `{mode.get('planned_end_at')}`",
                "- Same-family role changes are self-audits, not independent review.",
                "- Builder/skeptic assignments remain unchanged; unavailable "
                "cross-family reviews accumulate as explicit review debt.",
                "",
            ]
        )
    lines.extend(
        [
        "## Active work",
        "",
        ]
    )
    if not active:
        lines.append("- None.")
    for item in active:
        channel, route = review_route(item, state)
        dependencies = ", ".join(item["depends_on"]) or "none"
        owner_state = (
            "active"
            if model_execution_allowed(state, item["owner_model"])
            else "paused by execution mode"
        )
        lines.extend(
            [
                f"### {item['id']} - {item['title']}",
                "",
                f"- Project: `{item['project_id']}` ({projects[item['project_id']]['title']})",
                f"- State/priority: `{item['status']}` / P{item['priority']}",
                f"- Owner: `{item['owner_model']}/{item['role']}` ({owner_state})",
                f"- Independent review route: `{channel}` ({route})",
                f"- Dependencies: {dependencies}",
                f"- Nearest unproved work: {item['nearest_work']}",
                f"- Next action: {item['next_action']}",
                f"- Evidence: {', '.join(item['evidence_paths']) or 'not yet attached'}",
                "",
            ]
        )
    lines.extend(["## Active Aristotle jobs", ""])
    if not jobs:
        lines.append("- None recorded as submitted or running.")
    for job in jobs:
        lines.append(
            f"- `{job['id']}` [{job['status']}] "
            f"({job.get('work_item_id') or 'unlinked'}): {job['title']}"
        )
    lines.extend(["", "## Open coordination messages", ""])
    if not messages:
        lines.append("- None.")
    for message in messages:
        lines.append(
            f"- `{message['id']}` [{message['priority']} {message['state']}] "
            f"{message['from_model']} -> {message['to_model']}: {message['subject']}"
        )
    lines.extend(["", "## Dependency-ready queue", ""])
    if not queued:
        lines.append("- Empty.")
    for item in queued[:5]:
        owner_state = (
            "active"
            if model_execution_allowed(state, item["owner_model"])
            else "paused by execution mode"
        )
        lines.append(
            f"- `{item['id']}` [{item['status']}, P{item['priority']}]: "
            f"{item['next_action']} (owner {item['owner_model']}: {owner_state})"
        )
    lines.extend(["", "## Next control actions", ""])
    if mode.get("kind") == "solo":
        lines.extend(
            [
                "1. Clear only reviews routed to the active family; leave all "
                "other reviews explicitly deferred.",
                "2. Harvest or refill the Aristotle fleet using `labctl.py jobs`.",
                "3. Execute dependency-ready work owned by the active model, then "
                "regenerate this handoff.",
                "",
            ]
        )
    else:
        lines.extend(
            [
                "1. Clear the highest-priority item in `labctl.py review-queue`.",
                "2. Harvest or refill the Aristotle fleet using `labctl.py jobs`.",
                "3. Run `labctl.py supervise` before selecting new execution work.",
                "",
            ]
        )
    return "\n".join(lines)


def command_handoff(args: argparse.Namespace) -> int:
    if args.check:
        if not HANDOFF_PATH.exists():
            print("HANDOFF.md is missing.", file=sys.stderr)
            return 1
        marker = f"State-watermark: `{state_watermark()}`"
        if marker not in HANDOFF_PATH.read_text(encoding="utf-8"):
            print("HANDOFF.md is stale; regenerate with `labctl.py handoff`.")
            return 1
        print("HANDOFF.md matches current machine-readable state.")
        return 0
    state, portfolio, work = load_all()
    HANDOFF_PATH.write_text(
        render_handoff(state, portfolio, work), encoding="utf-8", newline="\n"
    )
    print(f"Generated {HANDOFF_PATH.relative_to(ROOT)}.")
    return 0


def render_reproduction_manifest(item: dict[str, Any]) -> str:
    lines = [
        f"# Reproduction manifest: {item['id']}",
        "",
        f"- Work item: `{item['id']}`",
        f"- Project: `{item['project_id']}`",
        f"- Builder family: `{model_family(item['owner_model'])}`",
        f"- Required reproducer family: `{model_family(item['skeptic_model'])}`",
        f"- Exact claim: {item['exact_claim']}",
        f"- Nearest unproved work: {item['nearest_work']}",
        "",
        "## Artifacts",
        "",
    ]
    lines.extend(f"- `{path}`" for path in item["evidence_paths"])
    lines.extend(["", "## Commands", ""])
    lines.extend(f"```powershell\n{command}\n```" for command in item["verification_commands"])
    lines.extend(
        [
            "",
            "## Independence and verdict",
            "",
            "The reproducer must use a different model family from the builder, "
            "record the exact environment and outputs, and classify the result as "
            "replicated, narrower-than-stated, non-reproducible, or blocked.",
            "",
        ]
    )
    return "\n".join(lines)


def command_repro_manifest(args: argparse.Namespace) -> int:
    _, _, work = load_all()
    matches = [item for item in work["items"] if item["id"] == args.work_item]
    if not matches:
        print(f"Unknown work item: {args.work_item}", file=sys.stderr)
        return 1
    content = render_reproduction_manifest(matches[0])
    if args.output:
        output = Path(args.output)
        output.write_text(content, encoding="utf-8", newline="\n")
        print(f"Wrote {output}.")
    else:
        print(content)
    return 0


def command_transition(args: argparse.Namespace) -> int:
    state, portfolio, work = load_all()
    items = work["items"]
    matches = [item for item in items if item["id"] == args.work_item]
    if not matches:
        print(f"Unknown work item: {args.work_item}", file=sys.stderr)
        return 1
    item = matches[0]
    old_status = item["status"]
    new_status = args.status
    if new_status not in WORK_STATUSES:
        print(f"Invalid status: {new_status}", file=sys.stderr)
        return 1
    if not args.force and new_status not in TRANSITIONS.get(old_status, set()):
        print(
            f"Transition {old_status} -> {new_status} is not standard; use --force "
            "only with a decision/incident record.",
            file=sys.stderr,
        )
        return 1
    item["status"] = new_status
    work["updated_at"] = dt.datetime.now().astimezone().isoformat(timespec="seconds")
    errors = validate_data(state, portfolio, work)
    if errors:
        print("Transition would make state invalid:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1
    atomic_write_json(WORK_ITEMS_PATH, work)
    append_ledger(
        args.model,
        args.role,
        args.work_item,
        f"Transitioned {old_status} -> {new_status}. {args.note}",
    )
    if record_forecast_resolution(item, new_status, args.model, args.role):
        print(
            f"Recorded forecast resolution for {args.work_item} "
            f"({FORECAST_RESOLUTIONS[new_status]})."
        )
    print(f"Transitioned {args.work_item}: {old_status} -> {new_status}")
    return 0


def command_log(args: argparse.Namespace) -> int:
    append_ledger(args.model, args.role, args.item, args.message)
    print(f"Appended ledger entry for {args.item}.")
    return 0


def command_due(_: argparse.Namespace) -> int:
    state, _, work = load_all()
    now = dt.datetime.now().astimezone()
    today = now.date()
    overdue: list[str] = []

    cycle_start = state.get("current_cycle", {}).get("started_at")
    for cadence, days in CADENCES.items():
        last = state.get("last_reviews", {}).get(cadence)
        reference = last or cycle_start
        if reference is None:
            overdue.append(f"{cadence} review: never run")
            continue
        last_date = dt.datetime.fromisoformat(reference).date()
        age = (today - last_date).days
        if age >= days:
            suffix = "since cycle start, never run" if last is None else "old"
            overdue.append(f"{cadence} review: {age} days {suffix}")

    active_solo = solo_active_model(state)
    for model, record in state.get("availability", {}).items():
        if active_solo is not None and model not in {active_solo, "aristotle"}:
            continue
        checked = record.get("last_checked")
        if checked is None:
            overdue.append(f"availability {model}: never checked")
            continue
        age_hours = (now - dt.datetime.fromisoformat(checked)).total_seconds() / 3600
        if age_hours >= 24:
            overdue.append(
                f"availability {model}: last checked {age_hours:.0f}h ago "
                f"(status {record.get('status')})"
            )

    for item in work.get("items", []):
        if item.get("status") in ACTIVE_WORK_STATUSES | QUEUE_STATUSES:
            target = item.get("target_date")
            if target and dt.date.fromisoformat(target) < today:
                overdue.append(
                    f"work item {item['id']}: target {target} passed "
                    f"(status {item['status']})"
                )

    if ARISTOTLE_JOBS_PATH.exists():
        jobs = load_json(ARISTOTLE_JOBS_PATH).get("jobs", [])
        stale = [
            job["id"]
            for job in jobs
            if isinstance(job, dict)
            and job.get("status") in {"idle", "unknown", "harvested"}
        ]
        if stale:
            overdue.append(
                "aristotle jobs awaiting harvest/integration: " + ", ".join(stale)
            )

    if MESSAGES_PATH.exists():
        now = dt.datetime.now().astimezone()
        expired = [
            message["id"]
            for message in load_messages().get("messages", [])
            if message.get("state") in {"open", "claimed"}
            and message_is_expired(message, now)
        ]
        if expired:
            overdue.append("coordination messages expired open: " + ", ".join(expired))

    if not overdue:
        print("Nothing overdue.")
        return 0
    print("Overdue:")
    for line in overdue:
        print(f"- {line}")
    return 0


def command_review_done(args: argparse.Namespace) -> int:
    if args.cadence not in CADENCES:
        print(f"Invalid cadence: {args.cadence}", file=sys.stderr)
        return 1
    with state_write_lock("lab-state"):
        state, portfolio, work = load_all()
        now = dt.datetime.now().astimezone().isoformat(timespec="seconds")
        reviews = state.setdefault("last_reviews", {})
        reviews[args.cadence] = now
        errors = validate_data(state, portfolio, work)
        if errors:
            for error in errors:
                print(f"- {error}", file=sys.stderr)
            return 1
        atomic_write_json(LAB_STATE_PATH, state)
    append_ledger(
        args.model,
        "lab_manager",
        f"REVIEW-{args.cadence.upper()}",
        f"Completed {args.cadence} review. {args.note}",
    )
    print(f"Recorded {args.cadence} review at {now}.")
    return 0


def command_availability(args: argparse.Namespace) -> int:
    with state_write_lock("lab-state"):
        state, portfolio, work = load_all()
        record = state.setdefault("availability", {}).setdefault(args.target, {})
        record["status"] = args.status
        if args.detail is not None:
            record["detail"] = args.detail
        elif args.status == "available":
            record.pop("detail", None)
        record["last_checked"] = dt.datetime.now().astimezone().isoformat(
            timespec="seconds"
        )
        errors = validate_data(state, portfolio, work)
        if errors:
            for error in errors:
                print(f"- {error}", file=sys.stderr)
            return 1
        atomic_write_json(LAB_STATE_PATH, state)
    append_ledger(
        args.model,
        "lab_manager",
        "AVAILABILITY",
        f"Set {args.target} availability to {args.status}."
        + (f" Detail: {args.detail}" if args.detail else ""),
    )
    print(f"Set {args.target}: {args.status}")
    return 0


def load_messages() -> dict[str, Any]:
    if MESSAGES_PATH.exists():
        return load_json(MESSAGES_PATH)
    return {"schema_version": 1, "updated_at": now_iso(), "messages": []}


def message_is_expired(message: dict[str, Any], now: dt.datetime | None = None) -> bool:
    instant = now or dt.datetime.now().astimezone()
    try:
        return dt.datetime.fromisoformat(message["expires_at"]) <= instant
    except (KeyError, ValueError):
        return True


def message_addressed_to(message: dict[str, Any], model: str) -> bool:
    return message.get("to_model") in {model, "all"}


def message_acknowledged_by(message: dict[str, Any], model: str) -> bool:
    return any(
        acknowledgement.get("model") == model
        for acknowledgement in message.get("acknowledgements", [])
        if isinstance(acknowledgement, dict)
    )


def command_send(args: argparse.Namespace) -> int:
    _, _, work = load_all()
    if args.item is not None and not any(
        item["id"] == args.item for item in work["items"]
    ):
        print(f"Unknown work item: {args.item}", file=sys.stderr)
        return 1
    if args.ttl_hours <= 0:
        print("--ttl-hours must be positive.", file=sys.stderr)
        return 1
    artifacts = []
    try:
        for artifact in args.artifact:
            path, digest = artifact_digest(artifact)
            artifacts.append({"path": path, "sha256": digest})
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    now = dt.datetime.now().astimezone()
    message_id = (
        "msg-"
        + now.strftime("%Y%m%d-%H%M%S-")
        + uuid.uuid4().hex[:8]
    )
    message = {
        "id": message_id,
        "from_model": args.from_model,
        "to_model": args.to_model,
        "kind": args.kind,
        "priority": args.priority,
        "state": "open",
        "work_item_id": args.item,
        "subject": args.subject,
        "body": args.message,
        "artifacts": artifacts,
        "commands": args.command,
        "created_at": now.isoformat(timespec="seconds"),
        "expires_at": (now + dt.timedelta(hours=args.ttl_hours)).isoformat(
            timespec="seconds"
        ),
        "acknowledgements": [],
    }
    try:
        with state_write_lock("messages"):
            registry = load_messages()
            registry.setdefault("messages", []).append(message)
            registry["updated_at"] = now_iso()
            atomic_write_json(MESSAGES_PATH, registry)
    except TimeoutError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    append_ledger(
        args.from_model,
        "lab_manager",
        args.item or "MAILBOX",
        f"Sent {message_id} to {args.to_model}: {args.subject}",
    )
    print(message_id)
    return 0


def command_inbox(args: argparse.Namespace) -> int:
    registry = load_messages()
    now = dt.datetime.now().astimezone()
    messages = []
    for message in registry.get("messages", []):
        if not message_addressed_to(message, args.model):
            continue
        if not args.include_closed and message.get("state") in {"completed", "cancelled"}:
            continue
        if not args.include_expired and message_is_expired(message, now):
            continue
        if not args.include_acknowledged and message_acknowledged_by(message, args.model):
            continue
        messages.append(message)
    rank = {"urgent": 0, "high": 1, "normal": 2, "low": 3}
    messages.sort(
        key=lambda message: (
            rank.get(message.get("priority"), 9),
            message.get("created_at", ""),
            message.get("id", ""),
        )
    )
    if not messages:
        print(f"Mailbox for {args.model} is empty.")
        return 0
    print(f"Mailbox for {args.model} ({len(messages)}):")
    for message in messages:
        claim = ""
        if message.get("claimed_by"):
            claim = (
                f" claimed={message['claimed_by']}"
                f" until={message.get('claim_expires_at')}"
            )
        print(
            f"  {message['id']} [{message['priority']} {message['kind']} "
            f"{message['state']}]{claim}\n"
            f"    from={message['from_model']} item={message.get('work_item_id') or '-'}\n"
            f"    {message['subject']}\n"
            f"    {message['body']}"
        )
        for artifact in message.get("artifacts", []):
            print(f"    artifact={artifact['path']} sha256={artifact['sha256']}")
        for command in message.get("commands", []):
            print(f"    run={command}")
    return 0


def command_ack(args: argparse.Namespace) -> int:
    try:
        with state_write_lock("messages"):
            registry = load_messages()
            message = next(
                (entry for entry in registry.get("messages", []) if entry["id"] == args.message_id),
                None,
            )
            if message is None:
                print(f"Unknown message: {args.message_id}", file=sys.stderr)
                return 1
            if not message_addressed_to(message, args.model):
                print("Message is not addressed to this model.", file=sys.stderr)
                return 1
            if not message_acknowledged_by(message, args.model):
                message.setdefault("acknowledgements", []).append(
                    {"model": args.model, "at": now_iso(), "note": args.note}
                )
                registry["updated_at"] = now_iso()
                atomic_write_json(MESSAGES_PATH, registry)
    except TimeoutError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    append_ledger(
        args.model,
        "lab_manager",
        message.get("work_item_id") or "MAILBOX",
        f"Acknowledged {args.message_id}. {args.note}",
    )
    print(f"Acknowledged {args.message_id}.")
    return 0


def command_claim_message(args: argparse.Namespace) -> int:
    if args.hours <= 0:
        print("--hours must be positive.", file=sys.stderr)
        return 1
    now = dt.datetime.now().astimezone()
    try:
        with state_write_lock("messages"):
            registry = load_messages()
            message = next(
                (entry for entry in registry.get("messages", []) if entry["id"] == args.message_id),
                None,
            )
            if message is None:
                print(f"Unknown message: {args.message_id}", file=sys.stderr)
                return 1
            if not message_addressed_to(message, args.model):
                print("Message is not addressed to this model.", file=sys.stderr)
                return 1
            if message.get("state") in {"completed", "cancelled"}:
                print(f"Message is already {message['state']}.", file=sys.stderr)
                return 1
            existing_expiry = message.get("claim_expires_at")
            claim_live = False
            if existing_expiry:
                claim_live = dt.datetime.fromisoformat(existing_expiry) > now
            if claim_live and message.get("claimed_by") != args.model:
                print(
                    f"Message is claimed by {message.get('claimed_by')} until "
                    f"{existing_expiry}.",
                    file=sys.stderr,
                )
                return 1
            message["state"] = "claimed"
            message["claimed_by"] = args.model
            message["claimed_at"] = now.isoformat(timespec="seconds")
            message["claim_expires_at"] = (
                now + dt.timedelta(hours=args.hours)
            ).isoformat(timespec="seconds")
            if not message_acknowledged_by(message, args.model):
                message.setdefault("acknowledgements", []).append(
                    {"model": args.model, "at": now_iso(), "note": "claimed"}
                )
            registry["updated_at"] = now_iso()
            atomic_write_json(MESSAGES_PATH, registry)
    except TimeoutError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    append_ledger(
        args.model,
        "lab_manager",
        message.get("work_item_id") or "MAILBOX",
        f"Claimed {args.message_id} for {args.hours:g} hours.",
    )
    print(f"Claimed {args.message_id}.")
    return 0


def command_complete_message(args: argparse.Namespace) -> int:
    try:
        with state_write_lock("messages"):
            registry = load_messages()
            message = next(
                (entry for entry in registry.get("messages", []) if entry["id"] == args.message_id),
                None,
            )
            if message is None:
                print(f"Unknown message: {args.message_id}", file=sys.stderr)
                return 1
            if message.get("state") != "claimed" or message.get("claimed_by") != args.model:
                print("Model must hold the live claim before completing.", file=sys.stderr)
                return 1
            message["state"] = "completed"
            message["completed_by"] = args.model
            message["completed_at"] = now_iso()
            message["completion_note"] = args.note
            registry["updated_at"] = now_iso()
            atomic_write_json(MESSAGES_PATH, registry)
    except TimeoutError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    append_ledger(
        args.model,
        "lab_manager",
        message.get("work_item_id") or "MAILBOX",
        f"Completed {args.message_id}. {args.note}",
    )
    print(f"Completed {args.message_id}.")
    return 0


def load_leases() -> dict[str, Any]:
    if FILE_LEASES_PATH.exists():
        return load_json(FILE_LEASES_PATH)
    return {"schema_version": 1, "updated_at": now_iso(), "leases": []}


def active_leases(registry: dict[str, Any]) -> list[dict[str, Any]]:
    now = dt.datetime.now().astimezone()
    result = []
    for lease in registry.get("leases", []):
        try:
            expires = dt.datetime.fromisoformat(lease["expires_at"])
        except (KeyError, ValueError):
            continue
        if expires > now:
            result.append(lease)
    return result


def command_leases(_: argparse.Namespace) -> int:
    leases = active_leases(load_leases())
    if not leases:
        print("No active file leases.")
        return 0
    print(f"Active file leases ({len(leases)}):")
    for lease in sorted(leases, key=lambda value: value["path"]):
        print(
            f"  {lease['path']} -> {lease['owner_model']}/{lease['work_item_id']} "
            f"until {lease['expires_at']}"
        )
    return 0


def command_lease(args: argparse.Namespace) -> int:
    _, _, work = load_all()
    if args.model not in INTERACTIVE_MODELS:
        print("Only an interactive agent may hold a file lease.", file=sys.stderr)
        return 1
    item = next((item for item in work["items"] if item["id"] == args.work_item), None)
    if item is None:
        print(f"Unknown work item: {args.work_item}", file=sys.stderr)
        return 1
    try:
        path = normalized_repo_path(args.path)
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    try:
        with state_write_lock("file-leases"):
            registry = load_leases()
            leases = active_leases(registry)
            conflict = next(
                (lease for lease in leases if paths_overlap(path, lease["path"])),
                None,
            )
            if conflict is not None:
                print(
                    f"Lease conflict: {path} overlaps {conflict['path']} held by "
                    f"{conflict['owner_model']}/{conflict['work_item_id']}.",
                    file=sys.stderr,
                )
                return 1
            now = dt.datetime.now().astimezone()
            lease = {
                "path": path,
                "owner_model": args.model,
                "work_item_id": args.work_item,
                "acquired_at": now.isoformat(timespec="seconds"),
                "expires_at": (now + dt.timedelta(hours=args.hours)).isoformat(
                    timespec="seconds"
                ),
                "note": args.note,
            }
            registry["leases"] = leases + [lease]
            registry["updated_at"] = now_iso()
            atomic_write_json(FILE_LEASES_PATH, registry)
    except TimeoutError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    append_ledger(
        args.model,
        "lab_manager",
        args.work_item,
        f"Leased {path} for {args.hours:g} hours. {args.note}",
    )
    print(f"Leased {path} to {args.model}/{args.work_item}.")
    return 0


def command_release_lease(args: argparse.Namespace) -> int:
    try:
        path = normalized_repo_path(args.path)
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    try:
        with state_write_lock("file-leases"):
            registry = load_leases()
            before = len(registry.get("leases", []))
            registry["leases"] = [
                lease
                for lease in registry.get("leases", [])
                if not (
                    lease.get("path") == path
                    and lease.get("owner_model") == args.model
                )
            ]
            if len(registry["leases"]) == before:
                print(f"No lease on {path} held by {args.model}.", file=sys.stderr)
                return 1
            registry["updated_at"] = now_iso()
            atomic_write_json(FILE_LEASES_PATH, registry)
    except TimeoutError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    append_ledger(
        args.model,
        "lab_manager",
        "FILE-LEASE",
        f"Released lease on {path}. {args.note}",
    )
    print(f"Released lease on {path}.")
    return 0


def role_display_name(role: str) -> str:
    return "Impact Strategist" if role == "superstar" else role.replace("_", " ").title()


def generate_role_packet(
    model: str,
    role: str,
    packet_path: str,
    project_id: str | None,
    work_item_id: str | None,
    activation_contract: str,
) -> None:
    """Generate a role packet through the canonical packet builder."""
    destination = ROOT.parent / packet_path
    destination.parent.mkdir(parents=True, exist_ok=True)
    command = [
        sys.executable,
        str(ROOT / "scripts" / "build_role_packet.py"),
        "--model",
        model,
        "--role",
        role,
        "--output",
        str(destination),
    ]
    if project_id:
        command.extend(["--project", project_id])
    if work_item_id:
        command.extend(["--work-item", work_item_id])
    result = subprocess.run(
        command,
        cwd=ROOT.parent,
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        raise ValueError(
            "role packet generation failed: "
            + (result.stderr.strip() or result.stdout.strip())
        )
    with destination.open("a", encoding="utf-8", newline="\n") as handle:
        handle.write("\n## Bounded activation contract\n\n")
        handle.write(activation_contract.rstrip() + "\n")


def command_role_status(_: argparse.Namespace) -> int:
    registry = load_role_schedule()
    rows = role_schedule_rows(registry)
    print("AFPL role-duty coverage:")
    for row in rows:
        policy = registry.get("policies", {}).get(row["role"], {})
        cadence = policy.get("cadence_hours")
        cadence_text = (
            f"every {cadence:g}h" if isinstance(cadence, (int, float)) else row["mode"]
        )
        detail = ""
        if row["active"]:
            detail = (
                f" model={row['active']['model']} id={row['active']['id']}"
            )
        if row["due_at"] is not None:
            detail += f" due={row['due_at'].isoformat(timespec='seconds')}"
        print(
            f"  {role_display_name(row['role'])}: {row['status']} "
            f"({cadence_text}){detail}"
        )
    overdue = overdue_role_rows(registry)
    if overdue:
        print(
            "Overdue role duties: "
            + ", ".join(role_display_name(row["role"]) for row in overdue)
        )
        return 2
    return 0


def command_role_start(args: argparse.Namespace) -> int:
    role = ROLE_ALIASES.get(args.role, args.role)
    state, portfolio, work = load_all()
    projects = {project["id"] for project in portfolio.get("projects", [])}
    items = {item["id"]: item for item in work.get("items", [])}
    if args.project is not None and args.project not in projects:
        print(f"Unknown project: {args.project}", file=sys.stderr)
        return 1
    if args.work_item is not None and args.work_item not in items:
        print(f"Unknown work item: {args.work_item}", file=sys.stderr)
        return 1
    inferred_project = (
        items[args.work_item]["project_id"] if args.work_item is not None else None
    )
    if args.project is not None and inferred_project is not None and (
        args.project != inferred_project
    ):
        print("Work item does not belong to the selected project.", file=sys.stderr)
        return 1
    project_id = args.project or inferred_project
    if not model_execution_allowed(state, args.model) and not args.force:
        print(
            f"Model {args.model} is paused by {execution_mode_text(state)}; "
            "only the active solo executor may start a role.",
            file=sys.stderr,
        )
        return 1
    availability = state.get("availability", {}).get(args.model, {})
    if availability.get("status") == "unavailable" and not args.force:
        print(f"Model channel is unavailable: {args.model}", file=sys.stderr)
        return 1
    now = dt.datetime.now().astimezone()
    activation_id = (
        "role-"
        + now.strftime("%Y%m%d-%H%M%S")
        + "-"
        + uuid.uuid4().hex[:8]
    )
    packet_path = normalized_repo_path(
        f"AutonomousLab/work/role-activations/{activation_id}_packet.md"
    )
    try:
        deliverable_path = normalized_repo_path(
            args.deliverable
            or f"AutonomousLab/work/role-activations/{activation_id}_deliverable.md"
        )
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    try:
        with state_write_lock("role-schedule"):
            registry = load_role_schedule()
            policy = registry.get("policies", {}).get(role)
            if policy is None:
                print(f"No role policy for {role}.", file=sys.stderr)
                return 1
            active = [
                activation
                for activation in registry.get("activations", [])
                if activation.get("role") == role
                and activation.get("status") == "active"
            ]
            if active and not args.force:
                print(
                    f"Role already active: {role} ({active[0]['id']}).",
                    file=sys.stderr,
                )
                return 1
            if active and args.force:
                for activation in active:
                    activation["status"] = "cancelled"
                    activation["completed_at"] = now.isoformat(timespec="seconds")
                    activation["summary"] = (
                        f"Superseded by forced activation {activation_id}."
                    )
            completed = [
                activation
                for activation in registry.get("activations", [])
                if activation.get("role") == role
                and activation.get("status") == "completed"
            ]
            completed.sort(
                key=lambda value: value.get("completed_at", ""), reverse=True
            )
            if (
                completed
                and policy.get("rotate_model_families")
                and completed[0].get("model_family") == model_family(args.model)
                and solo_active_model(state) is None
                and not args.force
            ):
                alternatives = [
                    model
                    for model in ("codex", "claude")
                    if model_family(model) != model_family(args.model)
                    and state.get("availability", {}).get(model, {}).get("status")
                    == "available"
                ]
                if alternatives:
                    print(
                        f"Role family must rotate; available alternatives: {alternatives}",
                        file=sys.stderr,
                    )
                    return 1
            default_hours = policy.get("session_hours") or 1.0
            hours = args.hours if args.hours is not None else float(default_hours)
            if hours <= 0:
                print("Role duration must be positive.", file=sys.stderr)
                return 1
            due = now + dt.timedelta(hours=hours)
            mode_note = ""
            if solo_active_model(state) is not None:
                mode_note = (
                    "- Solo-mode boundary: this activation preserves role cadence, "
                    "but any same-family audit is a self-audit and cannot satisfy an "
                    "independent-review gate.\n"
                )
            contract = (
                f"- Activation: `{activation_id}`\n"
                f"- Role: `{role_display_name(role)}` (`{role}`)\n"
                f"- Model: `{args.model}` / family `{model_family(args.model)}`\n"
                f"- Due: `{due.isoformat(timespec='seconds')}`\n"
                f"- Required deliverable: `{deliverable_path}`\n"
                f"- Output contract: {policy['output_contract']}\n"
                f"{mode_note}"
                f"- Completion: run `python AutonomousLab/scripts/labctl.py "
                f"role-complete {activation_id} --model {args.model} "
                f"--artifact {deliverable_path} --summary \"...\"`.\n"
                "Do not substitute a generic status memo for the stated output contract."
            )
            generate_role_packet(
                args.model,
                role,
                packet_path,
                project_id,
                args.work_item,
                contract,
            )
            activation = {
                "id": activation_id,
                "role": role,
                "model": args.model,
                "model_family": model_family(args.model),
                "status": "active",
                "started_at": now.isoformat(timespec="seconds"),
                "due_at": due.isoformat(timespec="seconds"),
                "project_id": project_id,
                "work_item_id": args.work_item,
                "packet_path": packet_path,
                "deliverable_path": deliverable_path,
                "note": args.note,
            }
            registry.setdefault("activations", []).insert(0, activation)
            registry["updated_at"] = now_iso()
            atomic_write_json(ROLE_SCHEDULE_PATH, registry)
    except (TimeoutError, ValueError) as exc:
        print(str(exc), file=sys.stderr)
        return 1
    append_ledger(
        args.model,
        role,
        args.work_item or f"ROLE-{role.upper()}",
        f"Started bounded role activation {activation_id}; due {due.isoformat(timespec='seconds')}. "
        f"Deliverable: {deliverable_path}. {args.note}",
    )
    print(f"Started {role_display_name(role)} activation {activation_id}.")
    print(f"Packet: {packet_path}")
    print(f"Deliverable: {deliverable_path}")
    return 0


def command_role_complete(args: argparse.Namespace) -> int:
    try:
        artifact_path, artifact_sha = artifact_digest(args.artifact)
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    try:
        with state_write_lock("role-schedule"):
            registry = load_role_schedule()
            activation = next(
                (
                    entry
                    for entry in registry.get("activations", [])
                    if entry.get("id") == args.activation_id
                ),
                None,
            )
            if activation is None:
                print(f"Unknown role activation: {args.activation_id}", file=sys.stderr)
                return 1
            if activation.get("status") != "active":
                print("Role activation is not active.", file=sys.stderr)
                return 1
            if activation.get("model") != args.model:
                print("Only the activation owner can complete it.", file=sys.stderr)
                return 1
            expected = activation.get("deliverable_path")
            if artifact_path != expected:
                print(
                    f"Artifact must match the contracted deliverable: {expected}",
                    file=sys.stderr,
                )
                return 1
            completed_at = dt.datetime.now().astimezone()
            activation["status"] = "completed"
            activation["completed_at"] = completed_at.isoformat(timespec="seconds")
            activation["artifact"] = {
                "path": artifact_path,
                "sha256": artifact_sha,
            }
            activation["summary"] = args.summary
            registry["updated_at"] = now_iso()
            atomic_write_json(ROLE_SCHEDULE_PATH, registry)
            policy = registry.get("policies", {}).get(activation["role"], {})
    except TimeoutError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    append_ledger(
        args.model,
        activation["role"],
        activation.get("work_item_id") or f"ROLE-{activation['role'].upper()}",
        f"Completed role activation {args.activation_id}. Artifact: {artifact_path} "
        f"(sha256 {artifact_sha}). {args.summary}",
    )
    print(f"Completed role activation {args.activation_id}.")
    cadence = policy.get("cadence_hours")
    if isinstance(cadence, (int, float)):
        next_due = completed_at + dt.timedelta(hours=float(cadence))
        print(f"Next due: {next_due.isoformat(timespec='seconds')}")
    return 0


def command_supervise(_: argparse.Namespace) -> int:
    """Run one read-only supervisory pass; never loop or mutate science."""
    state, portfolio, work = load_all()
    errors = validate_data(state, portfolio, work)
    errors.extend(validate_registries(state, work))
    reviews = prioritized_review_items(state, work)
    actionable_reviews = [
        item
        for item in reviews
        if "deferred" not in review_route(item, state)[1]
    ]
    deferred_reviews = len(reviews) - len(actionable_reviews)
    queued = sorted(
        [item for item in work["items"] if item["status"] in QUEUE_STATUSES],
        key=lambda item: (-item["priority"], item["target_date"], item["id"]),
    )
    actionable_queue = [
        item
        for item in queued
        if model_execution_allowed(state, item["owner_model"])
    ]
    jobs = []
    if ARISTOTLE_JOBS_PATH.exists():
        jobs = [
            job
            for job in load_json(ARISTOTLE_JOBS_PATH).get("jobs", [])
            if job.get("status") in ACTIVE_JOB_STATUSES
        ]
    cap = state.get("work_in_progress_limits", {}).get("aristotle_projects", 0)
    handoff_fresh = (
        HANDOFF_PATH.exists()
        and f"State-watermark: `{state_watermark()}`"
        in HANDOFF_PATH.read_text(encoding="utf-8")
    )
    mailbox = load_messages()
    now = dt.datetime.now().astimezone()
    active_solo = solo_active_model(state)
    mailbox_models = (active_solo,) if active_solo is not None else ("codex", "claude")
    unread = {
        model: sum(
            message_addressed_to(message, model)
            and message.get("state") in {"open", "claimed"}
            and not message_is_expired(message, now)
            and not message_acknowledged_by(message, model)
            for message in mailbox.get("messages", [])
        )
        for model in mailbox_models
    }
    role_registry = load_role_schedule()
    role_debts = overdue_role_rows(role_registry, now)
    print("AFPL bounded supervisor: one read-only pass")
    print(f"- execution mode: {execution_mode_text(state)}")
    if solo_mode_expired(state, now):
        print("- solo interval: EXPIRED (handoff and explicit mode reset required)")
    print(f"- validation: {'PASS' if not errors else f'FAIL ({len(errors)})'}")
    print(
        f"- review backlog: {len(reviews)} "
        f"({len(actionable_reviews)} actionable, {deferred_reviews} deferred)"
    )
    print(f"- Aristotle fleet: {len(jobs)}/{cap} active")
    print(f"- handoff: {'fresh' if handoff_fresh else 'STALE'}")
    print(f"- active leases: {len(active_leases(load_leases()))}")
    print(
        "- unread mailbox: "
        + ", ".join(f"{model}={count}" for model, count in unread.items())
    )
    print(
        "- overdue role duties: "
        + (
            ", ".join(role_display_name(row["role"]) for row in role_debts)
            if role_debts
            else "none"
        )
    )
    if errors:
        print("Next action: repair state validation before scientific mutation.")
        return 1
    if role_debts:
        role = role_debts[0]["role"]
        print(
            "Next action: start overdue role duty "
            f"{role_display_name(role)} with `labctl.py role-start {role} ...`."
        )
    elif actionable_reviews:
        item = actionable_reviews[0]
        channel, route = review_route(item, state)
        print(
            f"Next action: review {item['id']} with {channel} ({route}); "
            f"nearest work: {item['nearest_work']}"
        )
    elif actionable_queue:
        print(
            f"Next action: specify or execute queued item {actionable_queue[0]['id']}."
        )
    elif deferred_reviews:
        print(
            "Next action: continue active-family verification or Aristotle work; "
            "the remaining independent reviews are deferred by solo mode."
        )
    else:
        print("Next action: replenish a dependency-ready work item.")
    if len(jobs) < cap:
        print(f"Fleet action: {cap - len(jobs)} Aristotle slot(s) available.")
    if not handoff_fresh:
        print("State action: regenerate with `labctl.py handoff` after mutations settle.")
    return 0


def command_jobs(_: argparse.Namespace) -> int:
    state, _, _ = load_all()
    if not ARISTOTLE_JOBS_PATH.exists():
        print("No ARISTOTLE_JOBS.json registry yet.")
        return 0
    registry = load_json(ARISTOTLE_JOBS_PATH)
    jobs = registry.get("jobs", [])
    cap = state.get("work_in_progress_limits", {}).get("aristotle_projects")
    active = [job for job in jobs if job.get("status") in ACTIVE_JOB_STATUSES]
    print(f"Aristotle jobs: {len(jobs)} recorded, {len(active)} active (cap {cap}).")
    for job in jobs:
        item = job.get("work_item_id") or "-"
        print(
            f"  {job.get('id')} [{job.get('status')}] item={item}: "
            f"{job.get('title', '')}"
        )
    return 0


def command_job_register(args: argparse.Namespace) -> int:
    state, _, work = load_all()
    if args.work_item is not None and not any(
        item["id"] == args.work_item for item in work["items"]
    ):
        print(f"Unknown work item: {args.work_item}", file=sys.stderr)
        return 1
    try:
        with state_write_lock("aristotle-jobs"):
            registry = load_json(ARISTOTLE_JOBS_PATH)
            if any(job.get("id") == args.job_id for job in registry.get("jobs", [])):
                print(f"Aristotle job already registered: {args.job_id}", file=sys.stderr)
                return 1
            job = {
                "id": args.job_id,
                "work_item_id": args.work_item,
                "title": args.title,
                "status": args.status,
                "submitted_at": args.submitted_at or now_iso(),
                "notes": args.notes,
            }
            registry.setdefault("jobs", []).insert(0, job)
            registry["updated_at"] = now_iso()
            active = sum(
                entry.get("status") in ACTIVE_JOB_STATUSES
                for entry in registry["jobs"]
            )
            cap = state.get("work_in_progress_limits", {}).get("aristotle_projects")
            if isinstance(cap, int) and active > cap:
                print(f"Registration would exceed Aristotle fleet cap {cap}.", file=sys.stderr)
                return 1
            atomic_write_json(ARISTOTLE_JOBS_PATH, registry)
    except TimeoutError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    append_ledger(
        args.model,
        "lab_manager",
        args.work_item or "ARISTOTLE",
        f"Registered Aristotle job {args.job_id} [{args.status}]: {args.title}",
    )
    print(f"Registered Aristotle job {args.job_id}.")
    return 0


def command_job_update(args: argparse.Namespace) -> int:
    try:
        with state_write_lock("aristotle-jobs"):
            registry = load_json(ARISTOTLE_JOBS_PATH)
            job = next(
                (entry for entry in registry.get("jobs", []) if entry.get("id") == args.job_id),
                None,
            )
            if job is None:
                print(f"Unknown Aristotle job: {args.job_id}", file=sys.stderr)
                return 1
            old_status = job["status"]
            job["status"] = args.status
            if args.note:
                job["notes"] = (
                    job.get("notes", "")
                    + f" [{now_iso()} {args.model}] {args.note}"
                ).strip()
            registry["updated_at"] = now_iso()
            atomic_write_json(ARISTOTLE_JOBS_PATH, registry)
    except TimeoutError as exc:
        print(str(exc), file=sys.stderr)
        return 1
    append_ledger(
        args.model,
        "lab_manager",
        job.get("work_item_id") or "ARISTOTLE",
        f"Updated Aristotle job {args.job_id}: {old_status} -> {args.status}. "
        f"{args.note}",
    )
    print(f"Updated Aristotle job {args.job_id}: {old_status} -> {args.status}.")
    return 0


def command_probe(_: argparse.Namespace) -> int:
    results: list[str] = []
    try:
        with socket.create_connection(("127.0.0.1", 7687), timeout=2):
            results.append("neo4j bolt (127.0.0.1:7687): reachable")
    except OSError:
        results.append(
            "neo4j bolt (127.0.0.1:7687): NOT reachable "
            "(see memory: start Neo4j headless if lit tooling is needed)"
        )
    lake = shutil.which("lake")
    results.append(f"lake: {lake if lake else 'NOT on PATH'}")
    claude = shutil.which("claude")
    aristotle = shutil.which("aristotle")
    results.append(f"claude code: {claude if claude else 'NOT on PATH'}")
    results.append(f"aristotle: {aristotle if aristotle else 'NOT on PATH'}")
    for line in results:
        print(line)
    return 0


def command_begin_cycle(args: argparse.Namespace) -> int:
    with state_write_lock("lab-state"):
        state, portfolio, work = load_all()
        now = dt.datetime.now().astimezone()
        end = now + dt.timedelta(hours=args.hours)
        state["current_cycle"] = {
            "id": args.cycle_id,
            "status": "active",
            "phase": args.phase,
            "started_at": now.isoformat(timespec="seconds"),
            "planned_end_at": end.isoformat(timespec="seconds"),
        }
        errors = validate_data(state, portfolio, work)
        if errors:
            for error in errors:
                print(f"- {error}", file=sys.stderr)
            return 1
        atomic_write_json(LAB_STATE_PATH, state)
    append_ledger(
        args.model,
        "lab_manager",
        args.cycle_id,
        f"Began {args.hours:g}-hour cycle in phase {args.phase}.",
    )
    print(f"Began cycle {args.cycle_id}; planned end {end.isoformat(timespec='seconds')}")
    return 0


def command_dashboard(args: argparse.Namespace) -> int:
    """Run the read-only AFPL monitoring dashboard in the foreground."""
    command = [
        sys.executable,
        str(ROOT / "scripts" / "serve_dashboard.py"),
        "--host",
        args.host,
        "--port",
        str(args.port),
    ]
    return subprocess.call(command, cwd=ROOT.parent)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Operate AFPL persistent state.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    validate_parser = subparsers.add_parser("validate", help="Validate all state files.")
    validate_parser.set_defaults(function=command_validate)

    status_parser = subparsers.add_parser("status", help="Show lab status.")
    status_parser.set_defaults(function=command_status)

    mode_parser = subparsers.add_parser("mode", help="Show the execution mode.")
    mode_parser.set_defaults(function=command_mode)

    mode_set_parser = subparsers.add_parser(
        "mode-set", help="Switch between collaborative and solo execution."
    )
    mode_set_parser.add_argument("kind", choices=sorted(EXECUTION_MODES))
    mode_set_parser.add_argument(
        "--active-model", choices=sorted(SOLO_EXECUTORS)
    )
    mode_set_parser.add_argument("--hours", type=float)
    mode_set_parser.add_argument("--reason", default="")
    mode_set_parser.add_argument(
        "--model", required=True, choices=sorted(INTERACTIVE_MODELS)
    )
    mode_set_parser.set_defaults(function=command_mode_set)

    dashboard_parser = subparsers.add_parser(
        "dashboard", help="Serve the live read-only lab dashboard."
    )
    dashboard_parser.add_argument("--host", default="127.0.0.1")
    dashboard_parser.add_argument("--port", type=int, default=8765)
    dashboard_parser.set_defaults(function=command_dashboard)

    role_status_parser = subparsers.add_parser(
        "role-status", help="Show periodic and event-driven role-duty coverage."
    )
    role_status_parser.set_defaults(function=command_role_status)

    role_start_parser = subparsers.add_parser(
        "role-start", help="Start a bounded role activation and generate its packet."
    )
    role_start_parser.add_argument(
        "role", choices=sorted(ROLES | set(ROLE_ALIASES))
    )
    role_start_parser.add_argument(
        "--model", required=True, choices=sorted(INTERACTIVE_MODELS)
    )
    role_start_parser.add_argument("--hours", type=float)
    role_start_parser.add_argument("--project")
    role_start_parser.add_argument("--work-item")
    role_start_parser.add_argument("--deliverable")
    role_start_parser.add_argument("--note", default="")
    role_start_parser.add_argument("--force", action="store_true")
    role_start_parser.set_defaults(function=command_role_start)

    role_complete_parser = subparsers.add_parser(
        "role-complete", help="Complete a role activation with a hashed artifact."
    )
    role_complete_parser.add_argument("activation_id")
    role_complete_parser.add_argument(
        "--model", required=True, choices=sorted(INTERACTIVE_MODELS)
    )
    role_complete_parser.add_argument("--artifact", required=True)
    role_complete_parser.add_argument("--summary", required=True)
    role_complete_parser.set_defaults(function=command_role_complete)

    queue_parser = subparsers.add_parser("queue", help="Show the prioritized queue.")
    queue_parser.set_defaults(function=command_queue)

    review_queue_parser = subparsers.add_parser(
        "review-queue", help="Show independent reviews in priority order."
    )
    review_queue_parser.set_defaults(function=command_review_queue)

    handoff_parser = subparsers.add_parser(
        "handoff", help="Generate or freshness-check the state-derived handoff."
    )
    handoff_parser.add_argument("--check", action="store_true")
    handoff_parser.set_defaults(function=command_handoff)

    repro_parser = subparsers.add_parser(
        "repro-manifest", help="Render a deterministic reproduction manifest."
    )
    repro_parser.add_argument("work_item")
    repro_parser.add_argument("--output")
    repro_parser.set_defaults(function=command_repro_manifest)

    send_parser = subparsers.add_parser(
        "send", help="Send a durable acknowledged inter-agent message."
    )
    send_parser.add_argument("--from", dest="from_model", required=True, choices=sorted(INTERACTIVE_MODELS))
    send_parser.add_argument("--to", dest="to_model", required=True, choices=sorted(INTERACTIVE_MODELS | {"all"}))
    send_parser.add_argument("--kind", required=True, choices=sorted(MESSAGE_KINDS))
    send_parser.add_argument("--priority", default="normal", choices=sorted(MESSAGE_PRIORITIES))
    send_parser.add_argument("--item")
    send_parser.add_argument("--subject", required=True)
    send_parser.add_argument("--message", required=True)
    send_parser.add_argument("--artifact", action="append", default=[])
    send_parser.add_argument("--command", action="append", default=[])
    send_parser.add_argument("--ttl-hours", type=float, default=24.0)
    send_parser.set_defaults(function=command_send)

    inbox_parser = subparsers.add_parser(
        "inbox", help="Show unacknowledged messages addressed to a model."
    )
    inbox_parser.add_argument("--model", required=True, choices=sorted(INTERACTIVE_MODELS))
    inbox_parser.add_argument("--include-acknowledged", action="store_true")
    inbox_parser.add_argument("--include-expired", action="store_true")
    inbox_parser.add_argument("--include-closed", action="store_true")
    inbox_parser.set_defaults(function=command_inbox)

    ack_parser = subparsers.add_parser("ack", help="Acknowledge a mailbox message.")
    ack_parser.add_argument("message_id")
    ack_parser.add_argument("--model", required=True, choices=sorted(INTERACTIVE_MODELS))
    ack_parser.add_argument("--note", default="")
    ack_parser.set_defaults(function=command_ack)

    claim_parser = subparsers.add_parser(
        "claim-message", help="Claim a mailbox task for a bounded interval."
    )
    claim_parser.add_argument("message_id")
    claim_parser.add_argument("--model", required=True, choices=sorted(INTERACTIVE_MODELS))
    claim_parser.add_argument("--hours", type=float, default=4.0)
    claim_parser.set_defaults(function=command_claim_message)

    complete_parser = subparsers.add_parser(
        "complete-message", help="Complete a mailbox task held by this model."
    )
    complete_parser.add_argument("message_id")
    complete_parser.add_argument("--model", required=True, choices=sorted(INTERACTIVE_MODELS))
    complete_parser.add_argument("--note", required=True)
    complete_parser.set_defaults(function=command_complete_message)

    transition_parser = subparsers.add_parser("transition", help="Transition a work item.")
    transition_parser.add_argument("work_item")
    transition_parser.add_argument("status")
    transition_parser.add_argument("--model", required=True, choices=sorted(MODELS))
    transition_parser.add_argument("--role", required=True, choices=sorted(ROLES))
    transition_parser.add_argument("--note", required=True)
    transition_parser.add_argument("--force", action="store_true")
    transition_parser.set_defaults(function=command_transition)

    cycle_parser = subparsers.add_parser("begin-cycle", help="Begin a bounded lab cycle.")
    cycle_parser.add_argument("cycle_id")
    cycle_parser.add_argument("--hours", type=float, default=24.0)
    cycle_parser.add_argument("--phase", default="research")
    cycle_parser.add_argument("--model", required=True, choices=sorted(MODELS))
    cycle_parser.set_defaults(function=command_begin_cycle)

    log_parser = subparsers.add_parser(
        "log", help="Append a system-clock-stamped ledger entry."
    )
    log_parser.add_argument("--model", required=True, choices=sorted(MODELS))
    log_parser.add_argument("--role", required=True, choices=sorted(ROLES))
    log_parser.add_argument("--item", required=True)
    log_parser.add_argument("--message", required=True)
    log_parser.set_defaults(function=command_log)

    due_parser = subparsers.add_parser(
        "due", help="List overdue cadence reviews, stale availability, and targets."
    )
    due_parser.set_defaults(function=command_due)

    review_parser = subparsers.add_parser(
        "review-done", help="Record a completed cadence review."
    )
    review_parser.add_argument("cadence", choices=sorted(CADENCES))
    review_parser.add_argument("--model", required=True, choices=sorted(MODELS))
    review_parser.add_argument("--note", default="")
    review_parser.set_defaults(function=command_review_done)

    availability_parser = subparsers.add_parser(
        "availability", help="Record a model/service availability check."
    )
    availability_parser.add_argument("target", choices=sorted(MODELS))
    availability_parser.add_argument("status", choices=sorted(AVAILABILITY_STATUSES))
    availability_parser.add_argument("--detail")
    availability_parser.add_argument("--model", required=True, choices=sorted(MODELS))
    availability_parser.set_defaults(function=command_availability)

    jobs_parser = subparsers.add_parser(
        "jobs", help="List the Aristotle job registry against the fleet cap."
    )
    jobs_parser.set_defaults(function=command_jobs)

    job_register_parser = subparsers.add_parser(
        "job-register", help="Transactionally register an Aristotle job."
    )
    job_register_parser.add_argument("job_id")
    job_register_parser.add_argument("--work-item")
    job_register_parser.add_argument("--title", required=True)
    job_register_parser.add_argument("--status", default="submitted", choices=sorted(JOB_STATUSES))
    job_register_parser.add_argument("--submitted-at")
    job_register_parser.add_argument("--notes", required=True)
    job_register_parser.add_argument("--model", required=True, choices=sorted(INTERACTIVE_MODELS))
    job_register_parser.set_defaults(function=command_job_register)

    job_update_parser = subparsers.add_parser(
        "job-update", help="Transactionally update an Aristotle job status."
    )
    job_update_parser.add_argument("job_id")
    job_update_parser.add_argument("status", choices=sorted(JOB_STATUSES))
    job_update_parser.add_argument("--note", default="")
    job_update_parser.add_argument("--model", required=True, choices=sorted(INTERACTIVE_MODELS))
    job_update_parser.set_defaults(function=command_job_update)

    leases_parser = subparsers.add_parser("leases", help="List active file leases.")
    leases_parser.set_defaults(function=command_leases)

    lease_parser = subparsers.add_parser(
        "lease", help="Acquire a bounded repository path lease."
    )
    lease_parser.add_argument("path")
    lease_parser.add_argument("--work-item", required=True)
    lease_parser.add_argument("--model", required=True, choices=sorted(MODELS))
    lease_parser.add_argument("--hours", type=float, default=4.0)
    lease_parser.add_argument("--note", default="")
    lease_parser.set_defaults(function=command_lease)

    release_parser = subparsers.add_parser(
        "release-lease", help="Release a repository path lease."
    )
    release_parser.add_argument("path")
    release_parser.add_argument("--model", required=True, choices=sorted(MODELS))
    release_parser.add_argument("--note", default="")
    release_parser.set_defaults(function=command_release_lease)

    supervisor_parser = subparsers.add_parser(
        "supervise", help="Run one bounded read-only supervisory pass."
    )
    supervisor_parser.set_defaults(function=command_supervise)

    probe_parser = subparsers.add_parser(
        "probe", help="Check locally probeable services (informational)."
    )
    probe_parser.set_defaults(function=command_probe)

    return parser


def main() -> int:
    args = build_parser().parse_args()
    return int(args.function(args))


if __name__ == "__main__":
    raise SystemExit(main())
