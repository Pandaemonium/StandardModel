#!/usr/bin/env python3
"""Compose a self-contained AFPL role packet from persistent state."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = ROOT.parent
MODELS = ("codex", "claude", "opus", "aristotle")
ROLES = (
    "research_scientist",
    "skeptic",
    "visionary",
    "phenomenologist",
    "reproducer",
    "superstar",
    "educator",
    "archivist",
    "lab_manager",
)


def load_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def select_by_id(values: list[dict[str, Any]], identifier: str | None) -> Any:
    if identifier is None:
        return None
    for value in values:
        if value.get("id") == identifier:
            return value
    raise ValueError(f"Unknown identifier: {identifier}")


def compose_packet(
    model: str,
    role: str,
    project_id: str | None = None,
    work_item_id: str | None = None,
) -> str:
    if model not in MODELS:
        raise ValueError(f"Unknown model: {model}")
    if role not in ROLES:
        raise ValueError(f"Unknown role: {role}")

    state = load_json(ROOT / "state" / "LAB_STATE.json")
    portfolio = load_json(ROOT / "state" / "PORTFOLIO.json")
    work_items = load_json(ROOT / "state" / "WORK_ITEMS.json")
    project = select_by_id(portfolio["projects"], project_id)
    work_item = select_by_id(work_items["items"], work_item_id)
    if work_item is not None and project is None:
        project = select_by_id(portfolio["projects"], work_item["project_id"])
    if work_item is not None and project is not None:
        if work_item["project_id"] != project["id"]:
            raise ValueError("Work item does not belong to the selected project")
    selected_project_id = project["id"] if project is not None else None

    core_role = (ROOT / "roles" / "core" / f"{role}.md").read_text(encoding="utf-8")
    overlay = (ROOT / "roles" / model / f"{role}.md").read_text(encoding="utf-8")
    charter = (ROOT / "CHARTER.md").read_text(encoding="utf-8")
    operating = (ROOT / "OPERATING_SYSTEM.md").read_text(encoding="utf-8")
    handoff = (ROOT / "state" / "HANDOFF.md").read_text(encoding="utf-8")

    sections = [
        "# AFPL role packet",
        f"- Model: `{model}`\n- Role: `{role}`\n- Project: `{selected_project_id or 'portfolio-level'}`\n- Work item: `{work_item_id or 'none selected'}`",
        "## Superior repository contract\n\nRead and obey `AGENTS.md` at repository root. It overrides this packet on conflict.",
        f"## Lab charter\n\n{charter}",
        f"## Core role constitution\n\n{core_role}",
        f"## Model overlay\n\n{overlay}",
        f"## Operating loop\n\n{operating}",
        "## Current machine-readable state\n\n```json\n"
        + json.dumps(state, indent=2, ensure_ascii=True)
        + "\n```",
    ]
    if project is not None:
        sections.append(
            "## Selected project\n\n```json\n"
            + json.dumps(project, indent=2, ensure_ascii=True)
            + "\n```"
        )
    if work_item is not None:
        sections.append(
            "## Selected work item\n\n```json\n"
            + json.dumps(work_item, indent=2, ensure_ascii=True)
            + "\n```"
        )
    sections.extend(
        [
            f"## Current handoff\n\n{handoff}",
            "## Final instruction\n\n"
            "Work in the assigned role. Read the exact canonical artifacts before acting. "
            "Update persistent state and the append-only ledger after material transitions. "
            "Do not claim independent review from another persona of the same model.",
        ]
    )
    return "\n\n".join(sections).rstrip() + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="Build an AFPL role packet.")
    parser.add_argument("--model", required=True, choices=MODELS)
    parser.add_argument("--role", required=True, choices=ROLES)
    parser.add_argument("--project")
    parser.add_argument("--work-item")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    try:
        packet = compose_packet(args.model, args.role, args.project, args.work_item)
    except ValueError as error:
        parser.error(str(error))
    if args.output is None:
        print(packet, end="")
    else:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(packet, encoding="utf-8", newline="\n")
        print(args.output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
