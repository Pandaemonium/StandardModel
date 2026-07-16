#!/usr/bin/env python3
"""Build a read-only monitoring snapshot from authoritative AFPL state."""

from __future__ import annotations

import datetime as dt
import json
import re
from collections import Counter
from pathlib import Path
from typing import Any

import labctl


ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = ROOT.parent
STATE_DIR = ROOT / "state"

ACTIVE_WORK = {"EXECUTING", "VERIFYING", "RED_TEAM", "REPLICATING"}
REVIEW_WORK = {"RED_TEAM", "REPLICATING"}
ACTIVE_JOBS = {"submitted", "running"}
TERMINAL_WORK = {"INTEGRATED", "RELEASE_CANDIDATE", "RELEASED"}
ROLE_LABELS = {
    "research_scientist": "Research Scientist",
    "skeptic": "Skeptic",
    "visionary": "Visionary",
    "phenomenologist": "Phenomenologist",
    "reproducer": "Reproducer",
    "superstar": "Impact Strategist",
    "educator": "Educator",
    "archivist": "Archivist",
    "lab_manager": "Lab Manager",
}


def load_json(name: str, default: dict[str, Any]) -> dict[str, Any]:
    path = STATE_DIR / name
    if not path.exists():
        return default
    with path.open("r", encoding="utf-8") as handle:
        value = json.load(handle)
    return value if isinstance(value, dict) else default


def parse_time(value: Any) -> dt.datetime | None:
    if not isinstance(value, str) or not value:
        return None
    try:
        parsed = dt.datetime.fromisoformat(value)
    except ValueError:
        return None
    if parsed.tzinfo is None:
        return parsed.replace(tzinfo=dt.timezone.utc)
    return parsed


def iso_time(value: Any) -> str | None:
    if isinstance(value, dt.datetime):
        return value.isoformat(timespec="seconds")
    if isinstance(value, str):
        return value
    return None


def seconds_until(value: Any, now: dt.datetime) -> int | None:
    parsed = parse_time(value) if not isinstance(value, dt.datetime) else value
    if parsed is None:
        return None
    return round((parsed - now).total_seconds())


def state_file_health(now: dt.datetime) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for path in sorted(STATE_DIR.glob("*.json")):
        modified = dt.datetime.fromtimestamp(path.stat().st_mtime).astimezone()
        rows.append(
            {
                "name": path.name,
                "modified_at": modified.isoformat(timespec="seconds"),
                "age_seconds": max(0, round((now - modified).total_seconds())),
            }
        )
    return rows


def recent_ledger_entries(limit: int = 8) -> list[dict[str, str]]:
    path = STATE_DIR / "LEDGER.md"
    if not path.exists():
        return []
    text = path.read_text(encoding="utf-8")
    headings = list(re.finditer(r"^##\s+(.+?)\s*$", text, flags=re.MULTILINE))
    rows: list[dict[str, str]] = []
    for index, match in enumerate(headings):
        end = headings[index + 1].start() if index + 1 < len(headings) else len(text)
        body = text[match.end() : end].strip()
        summary = " ".join(
            line.lstrip("- ").strip()
            for line in body.splitlines()
            if line.strip()
        )
        rows.append({"heading": match.group(1), "summary": summary})
    return rows[-limit:][::-1]


def validation_snapshot(
    state: dict[str, Any],
    portfolio: dict[str, Any],
    work_items: dict[str, Any],
) -> dict[str, Any]:
    errors: list[str] = []
    try:
        errors.extend(labctl.validate_data(state, portfolio, work_items))
        errors.extend(labctl.validate_registries(state, work_items))
    except Exception as exc:  # A malformed registry must remain visible.
        errors.append(f"validation raised {type(exc).__name__}: {exc}")
    return {"ok": not errors, "errors": errors}


def build_snapshot(now: dt.datetime | None = None) -> dict[str, Any]:
    now = now or dt.datetime.now().astimezone()
    state = load_json("LAB_STATE.json", {"schema_version": 1})
    portfolio = load_json("PORTFOLIO.json", {"projects": []})
    work_registry = load_json("WORK_ITEMS.json", {"items": []})
    role_registry = load_json("ROLE_SCHEDULE.json", {"policies": {}, "activations": []})
    claim_registry = load_json("CLAIMS.json", {"claims": []})
    job_registry = load_json("ARISTOTLE_JOBS.json", {"jobs": []})
    message_registry = load_json("MESSAGES.json", {"messages": []})
    lease_registry = load_json("FILE_LEASES.json", {"leases": []})
    forecast_registry = load_json("FORECASTS.json", {"entries": []})

    projects = [row for row in portfolio.get("projects", []) if isinstance(row, dict)]
    work = [row for row in work_registry.get("items", []) if isinstance(row, dict)]
    claims = [row for row in claim_registry.get("claims", []) if isinstance(row, dict)]
    jobs = [row for row in job_registry.get("jobs", []) if isinstance(row, dict)]
    messages = [row for row in message_registry.get("messages", []) if isinstance(row, dict)]
    leases = [row for row in lease_registry.get("leases", []) if isinstance(row, dict)]
    forecasts = [row for row in forecast_registry.get("entries", []) if isinstance(row, dict)]

    project_work: Counter[str] = Counter(str(item.get("project_id")) for item in work)
    project_active: Counter[str] = Counter(
        str(item.get("project_id")) for item in work if item.get("status") in ACTIVE_WORK
    )
    project_rows = []
    for project in sorted(projects, key=lambda row: row.get("priority", 0), reverse=True):
        project_id = str(project.get("id", ""))
        project_rows.append(
            {
                **project,
                "work_count": project_work[project_id],
                "active_work_count": project_active[project_id],
            }
        )

    role_rows = []
    try:
        computed_roles = labctl.role_schedule_rows(role_registry, now)
    except Exception:
        computed_roles = []
    policies = role_registry.get("policies", {})
    for row in computed_roles:
        active = row.get("active") or {}
        completed = row.get("last_completed") or {}
        policy = policies.get(row.get("role"), {})
        role_rows.append(
            {
                "role": row.get("role"),
                "label": ROLE_LABELS.get(str(row.get("role")), str(row.get("role"))),
                "mode": row.get("mode"),
                "status": row.get("status"),
                "cadence_hours": policy.get("cadence_hours"),
                "due_at": iso_time(row.get("due_at")),
                "seconds_until_due": seconds_until(row.get("due_at"), now),
                "model": active.get("model") or completed.get("model"),
                "active_id": active.get("id"),
                "last_completed_at": completed.get("completed_at"),
                "artifact_path": (completed.get("artifact") or {}).get("path"),
                "summary": completed.get("summary"),
            }
        )

    pipeline = Counter(str(item.get("status", "UNKNOWN")) for item in work)
    active_work = sorted(
        [item for item in work if item.get("status") in ACTIVE_WORK],
        key=lambda row: row.get("priority", 0),
        reverse=True,
    )
    queued_work = sorted(
        [
            item
            for item in work
            if item.get("status") not in ACTIVE_WORK | TERMINAL_WORK | {"KILLED", "SUPERSEDED", "RETRACTED"}
        ],
        key=lambda row: row.get("priority", 0),
        reverse=True,
    )

    job_statuses = Counter(str(job.get("status", "unknown")) for job in jobs)
    job_rows = sorted(
        jobs,
        key=lambda row: (
            0 if row.get("status") in ACTIVE_JOBS else 1,
            str(row.get("submitted_at", "")),
        ),
    )
    claim_grades = Counter(str(claim.get("grade", "?")) for claim in claims)

    action_messages = [
        message
        for message in messages
        if message.get("state") in {"open", "claimed"}
        and not (parse_time(message.get("expires_at")) and parse_time(message.get("expires_at")) < now)
    ]
    action_messages.sort(
        key=lambda row: (
            {"urgent": 0, "high": 1, "normal": 2, "low": 3}.get(str(row.get("priority")), 4),
            str(row.get("created_at", "")),
        )
    )

    active_leases = []
    for lease in leases:
        expires = parse_time(lease.get("expires_at"))
        if expires is None or expires > now:
            active_leases.append({**lease, "seconds_until_expiry": seconds_until(expires, now)})

    resolved_forecasts = [entry for entry in forecasts if entry.get("outcome") in {"success", "failure"}]
    brier = None
    if resolved_forecasts:
        brier = sum(
            (float(entry.get("forecast_success", 0)) - (1 if entry.get("outcome") == "success" else 0)) ** 2
            for entry in resolved_forecasts
        ) / len(resolved_forecasts)

    validation = validation_snapshot(state, portfolio, work_registry)
    overdue_roles = sum(row.get("status") in {"DUE", "OVERDUE_ACTIVE"} for row in role_rows)

    return {
        "meta": {
            "generated_at": now.isoformat(timespec="seconds"),
            "watermark": labctl.state_watermark(),
            "repository": str(REPO_ROOT),
        },
        "lab": {
            "name": state.get("lab_name"),
            "short_name": state.get("short_name"),
            "north_star": state.get("north_star"),
            "strategic_year": state.get("strategic_year"),
            "strategic_quarter": state.get("strategic_quarter"),
            "cycle": state.get("current_cycle", {}),
            "execution_mode": labctl.execution_mode(state),
            "release_state": state.get("release_state"),
            "human_release_required": state.get("human_release_required"),
        },
        "validation": validation,
        "kpis": {
            "active_projects": sum(project.get("status") == "active" for project in projects),
            "active_work": len(active_work),
            "review_work": sum(item.get("status") in REVIEW_WORK for item in work),
            "blocked_work": pipeline.get("BLOCKED", 0),
            "overdue_roles": overdue_roles,
            "active_jobs": sum(job.get("status") in ACTIVE_JOBS for job in jobs),
            "action_messages": len(action_messages),
            "machine_claims": sum(claim_grades.get(grade, 0) for grade in ("M", "M+E")),
        },
        "availability": [
            {"model": model, **detail}
            for model, detail in state.get("availability", {}).items()
            if isinstance(detail, dict)
        ],
        "projects": project_rows,
        "roles": role_rows,
        "work": {
            "pipeline": dict(pipeline),
            "active": active_work,
            "queued": queued_work[:8],
            "total": len(work),
        },
        "claims": {
            "grades": dict(claim_grades),
            "total": len(claims),
            "latest": list(reversed(claims[-8:])),
        },
        "jobs": {
            "statuses": dict(job_statuses),
            "total": len(jobs),
            "rows": job_rows[:12],
        },
        "messages": action_messages[:10],
        "leases": active_leases,
        "forecasts": {
            "resolved": len(resolved_forecasts),
            "total": len(forecasts),
            "brier_score": brier,
        },
        "ledger": recent_ledger_entries(),
        "state_files": state_file_health(now),
    }


if __name__ == "__main__":
    print(json.dumps(build_snapshot(), indent=2, ensure_ascii=True))
