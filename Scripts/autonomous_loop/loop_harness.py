#!/usr/bin/env python3
"""Small helper for the null-edge autonomous loop harness.

This script intentionally avoids project-specific side effects unless a command
explicitly asks for them. It creates and updates durable loop artifacts under
AgentTasks/autonomous-loop.
"""

from __future__ import annotations

import argparse
import datetime as _dt
import json
import subprocess
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
LOOP = ROOT / "AgentTasks" / "autonomous-loop"
RUNS = LOOP / "runs"
STATE = LOOP / "state.json"


def now_stamp() -> str:
    return _dt.datetime.now().strftime("%Y-%m-%d %H:%M:%S")


def run_stamp() -> str:
    return _dt.datetime.now().strftime("%Y%m%d-%H%M%S")


def load_state() -> dict[str, Any]:
    if not STATE.exists():
        raise SystemExit(f"Missing state file: {STATE}")
    return json.loads(STATE.read_text(encoding="utf-8"))


def save_state(state: dict[str, Any]) -> None:
    state["updated"] = _dt.date.today().isoformat()
    STATE.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8", newline="\n")


def append(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8", newline="\n") as handle:
        handle.write(text)


def cmd_status(_: argparse.Namespace) -> None:
    state = load_state()
    compact = {
        "current_state": state.get("current_state"),
        "current_objective": state.get("current_objective"),
        "active_aristotle_round": state.get("active_aristotle_round"),
        "active_aristotle_projects": state.get("active_aristotle_projects", []),
        "pending_integrations": state.get("pending_integrations", []),
        "pending_pro_packets": state.get("pending_pro_packets", []),
        "open_user_questions": state.get("open_user_questions", []),
    }
    print(json.dumps(compact, indent=2))


def cmd_set_state(args: argparse.Namespace) -> None:
    state = load_state()
    state["current_state"] = args.state
    if args.objective:
        state["current_objective"] = args.objective
    save_state(state)
    print(f"Updated state to {args.state}")


def cmd_new_run(args: argparse.Namespace) -> None:
    stamp = run_stamp()
    run_dir = RUNS / stamp
    run_dir.mkdir(parents=True, exist_ok=False)
    objective = args.objective or "Unspecified autonomous loop objective"
    report = run_dir / "loop-report.md"
    report.write_text(
        f"# Autonomous loop run - {stamp}\n\n"
        f"Started: {now_stamp()}\n\n"
        f"Objective:\n- {objective}\n\n"
        "## Actions\n\n- ...\n\n"
        "## Results\n\n- ...\n\n"
        "## Next action\n\n- ...\n",
        encoding="utf-8",
        newline="\n",
    )
    state = load_state()
    state["current_state"] = "SNAPSHOT"
    state["current_objective"] = objective
    state["active_run_dir"] = str(run_dir.relative_to(ROOT)).replace("\\", "/")
    save_state(state)
    print(run_dir)


def cmd_record_friction(args: argparse.Namespace) -> None:
    entry = (
        f"\n## {_dt.date.today().isoformat()} - {args.title}\n\n"
        f"Area: {args.area}\n"
        f"Severity: {args.severity}\n"
        "Status: open\n\n"
        "What happened:\n"
        f"- {args.detail}\n\n"
        "Why it matters:\n"
        f"- {args.impact or 'Not yet analyzed.'}\n\n"
        "Proposed fix:\n"
        f"- {args.fix or 'Not yet proposed.'}\n"
    )
    append(LOOP / "friction-log.md", entry)
    print("Recorded friction")


def cmd_queue_pro(args: argparse.Namespace) -> None:
    entry = (
        f"\n## {_dt.date.today().isoformat()} - {args.title}\n\n"
        "Status: draft\n"
        f"Related gate: {args.gate}\n"
        "Packet path: tbd\n\n"
        "Question:\n"
        f"- {args.question}\n\n"
        "Context needed:\n"
        f"- {args.context or 'Add compact project state and relevant theorem status.'}\n\n"
        "What success would look like:\n"
        f"- {args.success or 'Actionable route, no-go risks, theorem package, and claim guardrails.'}\n"
    )
    append(LOOP / "pro-question-queue.md", entry)
    state = load_state()
    state.setdefault("pending_pro_packets", []).append(args.title)
    save_state(state)
    print("Queued Pro question")


def cmd_queue_claude(args: argparse.Namespace) -> None:
    entry = (
        f"\n## {_dt.date.today().isoformat()} - {args.title}\n\n"
        "Status: draft\n"
        f"Aristotle round: {args.round or 'tbd'}\n"
        "Packet path: tbd\n\n"
        "Ask Claude to attack:\n"
        f"- {args.question}\n\n"
        "Required output:\n"
        "- missed blockers; theorem-statement risks; overclaim risks; next-job recommendations; publication-language warnings.\n"
    )
    append(LOOP / "claude-review-queue.md", entry)
    print("Queued Claude review")


def cmd_queue_aristotle(args: argparse.Namespace) -> None:
    entry = (
        f"\n## {args.job_id or 'PROPOSED'} - {args.title}\n\n"
        "Status: proposed\n"
        "Project ID: tbd\n"
        "Task ID: tbd\n"
        f"Target: {args.target}\n"
        f"Submitted: {args.submitted or 'n/a'}\n"
        "Integrated: n/a\n\n"
        "Purpose:\n"
        f"- {args.purpose or 'Add purpose before submission.'}\n\n"
        "Acceptance criteria:\n"
        f"- {args.acceptance or 'Add exact theorem/semantic criteria before submission.'}\n\n"
        "Semantic review notes:\n"
        "- Pending.\n"
    )
    append(LOOP / "aristotle-queue.md", entry)
    print("Queued Aristotle job")


def cmd_snapshot_aristotle(args: argparse.Namespace) -> None:
    stamp = run_stamp()
    out_dir = RUNS / stamp
    out_dir.mkdir(parents=True, exist_ok=True)
    out = out_dir / "aristotle-list.txt"
    proc = subprocess.run(
        ["aristotle", "list", "--limit", str(args.limit)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=False,
    )
    out.write_text(proc.stdout + proc.stderr, encoding="utf-8", newline="\n")
    print(out)
    if proc.returncode != 0:
        raise SystemExit(proc.returncode)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Null-edge autonomous loop helper")
    sub = parser.add_subparsers(required=True)

    command = sub.add_parser("status", help="print compact state")
    command.set_defaults(func=cmd_status)

    command = sub.add_parser("set-state", help="set current loop state")
    command.add_argument("state")
    command.add_argument("--objective")
    command.set_defaults(func=cmd_set_state)

    command = sub.add_parser("new-run", help="create a run directory and report stub")
    command.add_argument("--objective")
    command.set_defaults(func=cmd_new_run)

    command = sub.add_parser("record-friction", help="append a friction-log entry")
    command.add_argument("--title", required=True)
    command.add_argument("--detail", required=True)
    command.add_argument("--area", default="other")
    command.add_argument("--severity", default="medium", choices=["low", "medium", "high"])
    command.add_argument("--impact")
    command.add_argument("--fix")
    command.set_defaults(func=cmd_record_friction)

    command = sub.add_parser("queue-pro", help="append a Pro question queue entry")
    command.add_argument("--title", required=True)
    command.add_argument("--question", required=True)
    command.add_argument("--gate", default="other")
    command.add_argument("--context")
    command.add_argument("--success")
    command.set_defaults(func=cmd_queue_pro)

    command = sub.add_parser("queue-claude", help="append a Claude review queue entry")
    command.add_argument("--title", required=True)
    command.add_argument("--question", required=True)
    command.add_argument("--round")
    command.set_defaults(func=cmd_queue_claude)

    command = sub.add_parser("queue-aristotle", help="append an Aristotle queue entry")
    command.add_argument("--title", required=True)
    command.add_argument("--target", required=True)
    command.add_argument("--job-id")
    command.add_argument("--submitted")
    command.add_argument("--purpose")
    command.add_argument("--acceptance")
    command.set_defaults(func=cmd_queue_aristotle)

    command = sub.add_parser("snapshot-aristotle", help="run aristotle list and save output under runs/")
    command.add_argument("--limit", type=int, default=35)
    command.set_defaults(func=cmd_snapshot_aristotle)

    return parser


def main() -> None:
    args = build_parser().parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
