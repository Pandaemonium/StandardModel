#!/usr/bin/env python3
"""Validate and operate the AFPL persistent state.

This tool deliberately uses only the Python standard library. It is a small
control surface for institutional memory, not a general agent framework.
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import shutil
import socket
import sys
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

MODELS = {"codex", "claude", "opus", "aristotle", "human"}
# Aristotle is a submit-and-return proof service: it can be the skeptic of
# record for a formal claim (via audit jobs), but it cannot own a work item,
# because owners must read and mutate lab state.
INTERACTIVE_MODELS = {"codex", "claude", "opus", "human"}
# Independence is judged by model family, not model name: an interactive
# Claude session and the Opus review wrapper are the same family and do not
# provide independent review of each other's claims.
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
CLAIM_GRADES = {"T", "T|H", "M", "M+E", "S", "C", "I", "X"}
AVAILABILITY_STATUSES = {"available", "degraded", "unavailable"}
CADENCES = {"daily": 1, "weekly": 7, "monthly": 31, "quarterly": 93, "annual": 366}


def load_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        value = json.load(handle)
    if not isinstance(value, dict):
        raise ValueError(f"{path} must contain a JSON object")
    return value


def atomic_write_json(path: Path, value: dict[str, Any]) -> None:
    temporary = path.with_suffix(path.suffix + ".tmp")
    with temporary.open("w", encoding="utf-8", newline="\n") as handle:
        json.dump(value, handle, indent=2, ensure_ascii=True)
        handle.write("\n")
    temporary.replace(path)


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
        "title",
        "status",
        "priority",
        "role",
        "owner_model",
        "skeptic_model",
        "exact_claim",
        "success_criterion",
        "kill_condition",
        "next_action",
        "resource_ceiling",
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
            "success_criterion",
            "kill_condition",
            "next_action",
            "resource_ceiling",
        ):
            if not str(item.get(field, "")).strip():
                errors.append(f"{item_id}: missing {field}")
        forecast = item.get("forecast_success")
        if not isinstance(forecast, (int, float)) or not 0 <= forecast <= 1:
            errors.append(f"{item_id}: forecast_success must be in [0,1]")
        if item.get("status") in ACTIVE_WORK_STATUSES:
            active_by_model[str(item.get("owner_model"))] += 1

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
        print(
            f"  {item['id']} {item['status']} P{item['priority']} "
            f"{item['owner_model']}/{item['role']}: {item['next_action']}"
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

    for model, record in state.get("availability", {}).items():
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

    if not overdue:
        print("Nothing overdue.")
        return 0
    print("Overdue:")
    for line in overdue:
        print(f"- {line}")
    return 0


def command_review_done(args: argparse.Namespace) -> int:
    state, portfolio, work = load_all()
    now = dt.datetime.now().astimezone().isoformat(timespec="seconds")
    reviews = state.setdefault("last_reviews", {})
    if args.cadence not in CADENCES:
        print(f"Invalid cadence: {args.cadence}", file=sys.stderr)
        return 1
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
    results.append(
        "opus wrapper / aristotle: no cheap local probe; verify manually and "
        "record with `labctl.py availability <model> <status> --model <actor>`"
    )
    for line in results:
        print(line)
    return 0


def command_begin_cycle(args: argparse.Namespace) -> int:
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


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Operate AFPL persistent state.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    validate_parser = subparsers.add_parser("validate", help="Validate all state files.")
    validate_parser.set_defaults(function=command_validate)

    status_parser = subparsers.add_parser("status", help="Show lab status.")
    status_parser.set_defaults(function=command_status)

    queue_parser = subparsers.add_parser("queue", help="Show the prioritized queue.")
    queue_parser.set_defaults(function=command_queue)

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
