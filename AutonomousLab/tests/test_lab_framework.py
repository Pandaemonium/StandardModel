from __future__ import annotations

import concurrent.futures
import importlib.util
import json
import subprocess
import sys
import tempfile
import types
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = ROOT.parent


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class LabFrameworkTests(unittest.TestCase):
    def test_labctl_validate_command(self) -> None:
        result = subprocess.run(
            [sys.executable, str(ROOT / "scripts" / "labctl.py"), "validate"],
            cwd=REPO_ROOT,
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("validation passed", result.stdout)

    def test_every_model_has_every_role(self) -> None:
        roles = {
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
        for role in roles:
            self.assertTrue((ROOT / "roles" / "core" / f"{role}.md").is_file())
        for model in ("codex", "claude", "aristotle"):
            for role in roles:
                self.assertTrue((ROOT / "roles" / model / f"{role}.md").is_file())

    def test_active_builder_and_skeptic_are_cross_family(self) -> None:
        labctl = load_module("labctl", ROOT / "scripts" / "labctl.py")
        work = json.loads((ROOT / "state" / "WORK_ITEMS.json").read_text(encoding="utf-8"))
        for item in work["items"]:
            self.assertNotEqual(
                labctl.MODEL_FAMILIES[item["owner_model"]],
                labctl.MODEL_FAMILIES[item["skeptic_model"]],
                item["id"],
            )

    def test_same_family_pair_is_rejected(self) -> None:
        labctl = load_module("labctl_family", ROOT / "scripts" / "labctl.py")
        state, portfolio, work = labctl.load_all()
        work = json.loads(json.dumps(work))
        work["items"][0]["owner_model"] = "claude"
        work["items"][0]["skeptic_model"] = "claude"
        errors = labctl.validate_data(state, portfolio, work)
        self.assertTrue(any("model families" in error for error in errors), errors)

    def test_aristotle_cannot_own_work_items(self) -> None:
        labctl = load_module("labctl_owner", ROOT / "scripts" / "labctl.py")
        state, portfolio, work = labctl.load_all()
        work = json.loads(json.dumps(work))
        work["items"][0]["owner_model"] = "aristotle"
        errors = labctl.validate_data(state, portfolio, work)
        self.assertTrue(any("interactive agent" in error for error in errors), errors)

    def test_transitions_cover_every_status(self) -> None:
        labctl = load_module("labctl_transitions", ROOT / "scripts" / "labctl.py")
        self.assertEqual(set(labctl.TRANSITIONS), labctl.WORK_STATUSES)
        for source, targets in labctl.TRANSITIONS.items():
            self.assertLessEqual(targets, labctl.WORK_STATUSES, source)

    def test_registry_files_validate(self) -> None:
        labctl = load_module("labctl_registries", ROOT / "scripts" / "labctl.py")
        state, _, work = labctl.load_all()
        self.assertEqual(labctl.validate_registries(state, work), [])

    def test_review_queue_is_priority_ordered(self) -> None:
        labctl = load_module("labctl_review_queue", ROOT / "scripts" / "labctl.py")
        work = {
            "items": [
                {"id": "LOW", "status": "RED_TEAM", "priority": 10, "target_date": "2026-07-12"},
                {"id": "REPLAY", "status": "REPLICATING", "priority": 99, "target_date": "2026-07-12"},
                {"id": "HIGH", "status": "RED_TEAM", "priority": 20, "target_date": "2026-07-13"},
                {"id": "DONE", "status": "INTEGRATED", "priority": 100, "target_date": "2026-07-12"},
            ]
        }
        ids = [item["id"] for item in labctl.prioritized_review_items({}, work)]
        self.assertEqual(ids, ["HIGH", "LOW", "REPLAY"])

    def test_review_route_uses_interactive_claude_channel(self) -> None:
        labctl = load_module("labctl_review_route", ROOT / "scripts" / "labctl.py")
        state = {
            "availability": {
                "claude": {"status": "available"},
            }
        }
        item = {"skeptic_model": "claude"}
        channel, route = labctl.review_route(item, state)
        self.assertEqual(channel, "claude")
        self.assertEqual(route, "requested channel")

    def test_solo_mode_routes_only_reviews_the_active_family_can_satisfy(self) -> None:
        labctl = load_module("labctl_solo_review", ROOT / "scripts" / "labctl.py")
        state = {
            "execution_mode": {
                "kind": "solo",
                "active_model": "claude",
            },
            "availability": {
                "codex": {"status": "available"},
                "claude": {"status": "available"},
            },
        }
        codex_built = {"owner_model": "codex", "skeptic_model": "claude"}
        channel, route = labctl.review_route(codex_built, state)
        self.assertEqual((channel, route), ("claude", "solo active independent family"))

        claude_built = {"owner_model": "claude", "skeptic_model": "codex"}
        channel, route = labctl.review_route(claude_built, state)
        self.assertEqual((channel, route), ("codex", "deferred by solo mode"))

    def test_solo_mode_pauses_other_interactive_executors(self) -> None:
        labctl = load_module("labctl_solo_executor", ROOT / "scripts" / "labctl.py")
        state = {
            "execution_mode": {
                "kind": "solo",
                "active_model": "claude",
            }
        }
        self.assertTrue(labctl.model_execution_allowed(state, "claude"))
        self.assertTrue(labctl.model_execution_allowed(state, "human"))
        self.assertFalse(labctl.model_execution_allowed(state, "codex"))
        self.assertTrue(labctl.model_execution_allowed({}, "codex"))

    def test_solo_mode_blocks_paused_model_role_start(self) -> None:
        labctl = load_module("labctl_solo_role", ROOT / "scripts" / "labctl.py")
        old_load_all = labctl.load_all
        labctl.load_all = lambda: (
            {
                "execution_mode": {
                    "kind": "solo",
                    "active_model": "claude",
                },
                "availability": {
                    "codex": {"status": "available"},
                    "claude": {"status": "available"},
                },
            },
            {"projects": [{"id": "LAB-INFRA"}]},
            {"items": []},
        )
        try:
            args = types.SimpleNamespace(
                role="visionary",
                model="codex",
                hours=None,
                project="LAB-INFRA",
                work_item=None,
                deliverable=None,
                note="must be rejected",
                force=False,
            )
            self.assertEqual(labctl.command_role_start(args), 1)
        finally:
            labctl.load_all = old_load_all

    def test_invalid_solo_mode_is_rejected(self) -> None:
        labctl = load_module("labctl_solo_validation", ROOT / "scripts" / "labctl.py")
        state, portfolio, work = labctl.load_all()
        state = json.loads(json.dumps(state))
        state["execution_mode"] = {
            "kind": "solo",
            "active_model": "opus",
            "proof_backend": "aristotle",
            "independent_review_policy": "cross_family_required",
            "started_at": "2026-07-13T20:00:00-07:00",
            "planned_end_at": "2026-07-13T19:00:00-07:00",
            "reason": "",
        }
        errors = labctl.validate_data(state, portfolio, work)
        self.assertTrue(any("active_model" in error for error in errors), errors)
        self.assertTrue(any("defer" in error for error in errors), errors)
        self.assertTrue(any("requires a reason" in error for error in errors), errors)
        self.assertTrue(any("planned_end_at" in error for error in errors), errors)

    def test_work_dependency_cycle_is_rejected(self) -> None:
        labctl = load_module("labctl_dependency_cycle", ROOT / "scripts" / "labctl.py")
        state, portfolio, work = labctl.load_all()
        work = json.loads(json.dumps(work))
        first = work["items"][0]
        second = work["items"][1]
        first["depends_on"] = [second["id"]]
        second["depends_on"] = [first["id"]]
        errors = labctl.validate_data(state, portfolio, work)
        self.assertTrue(any("dependency cycle" in error for error in errors), errors)

    def test_overlapping_paths_are_detected(self) -> None:
        labctl = load_module("labctl_lease_paths", ROOT / "scripts" / "labctl.py")
        self.assertTrue(
            labctl.paths_overlap(
                "PhysicsSM/Draft/NullEdge", "PhysicsSM/Draft/NullEdge/GateC2.lean"
            )
        )
        self.assertFalse(
            labctl.paths_overlap("PhysicsSM/Algebra", "Sources/Manuscript.tex")
        )

    def test_parallel_lease_transactions_preserve_both_writes(self) -> None:
        labctl = load_module("labctl_parallel_leases", ROOT / "scripts" / "labctl.py")
        with tempfile.TemporaryDirectory() as temporary:
            state_dir = Path(temporary)
            lease_path = state_dir / "FILE_LEASES.json"
            ledger_path = state_dir / "LEDGER.md"
            lease_path.write_text(
                json.dumps({"schema_version": 1, "leases": []}) + "\n",
                encoding="utf-8",
            )
            ledger_path.write_text("# Test ledger\n", encoding="utf-8")
            old_state_dir = labctl.STATE_DIR
            old_lease_path = labctl.FILE_LEASES_PATH
            old_ledger_path = labctl.LEDGER_PATH
            labctl.STATE_DIR = state_dir
            labctl.FILE_LEASES_PATH = lease_path
            labctl.LEDGER_PATH = ledger_path
            try:
                def acquire(path: str) -> int:
                    return labctl.command_lease(
                        types.SimpleNamespace(
                            model="codex",
                            work_item="DYN-MODULAR-001",
                            path=path,
                            hours=1.0,
                            note="test",
                        )
                    )

                with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
                    results = list(pool.map(acquire, ["Sources/A.tex", "Sources/B.tex"]))
                self.assertEqual(results, [0, 0])
                registry = json.loads(lease_path.read_text(encoding="utf-8"))
                self.assertEqual(
                    {lease["path"] for lease in registry["leases"]},
                    {"Sources/A.tex", "Sources/B.tex"},
                )
            finally:
                labctl.STATE_DIR = old_state_dir
                labctl.FILE_LEASES_PATH = old_lease_path
                labctl.LEDGER_PATH = old_ledger_path

    def test_mailbox_ack_claim_complete_lifecycle(self) -> None:
        labctl = load_module("labctl_mailbox_lifecycle", ROOT / "scripts" / "labctl.py")
        with tempfile.TemporaryDirectory() as temporary:
            state_dir = Path(temporary)
            messages_path = state_dir / "MESSAGES.json"
            ledger_path = state_dir / "LEDGER.md"
            messages_path.write_text(
                json.dumps({"schema_version": 1, "messages": []}) + "\n",
                encoding="utf-8",
            )
            ledger_path.write_text("# Test ledger\n", encoding="utf-8")
            old_state_dir = labctl.STATE_DIR
            old_messages_path = labctl.MESSAGES_PATH
            old_ledger_path = labctl.LEDGER_PATH
            labctl.STATE_DIR = state_dir
            labctl.MESSAGES_PATH = messages_path
            labctl.LEDGER_PATH = ledger_path
            try:
                send_args = types.SimpleNamespace(
                    from_model="codex",
                    to_model="claude",
                    kind="review",
                    priority="high",
                    item="CONT-LIVE-001",
                    subject="Review continuum artifact",
                    message="Run the exact checks.",
                    artifact=["AutonomousLab/README.md"],
                    command=["python AutonomousLab/scripts/labctl.py validate"],
                    ttl_hours=2.0,
                )
                self.assertEqual(labctl.command_send(send_args), 0)
                registry = json.loads(messages_path.read_text(encoding="utf-8"))
                message_id = registry["messages"][0]["id"]
                self.assertEqual(
                    labctl.command_ack(
                        types.SimpleNamespace(
                            message_id=message_id, model="claude", note="seen"
                        )
                    ),
                    0,
                )
                self.assertEqual(
                    labctl.command_claim_message(
                        types.SimpleNamespace(
                            message_id=message_id, model="claude", hours=1.0
                        )
                    ),
                    0,
                )
                self.assertEqual(
                    labctl.command_complete_message(
                        types.SimpleNamespace(
                            message_id=message_id,
                            model="claude",
                            note="review complete",
                        )
                    ),
                    0,
                )
                message = json.loads(messages_path.read_text(encoding="utf-8"))[
                    "messages"
                ][0]
                self.assertEqual(message["state"], "completed")
                self.assertEqual(message["completed_by"], "claude")
                self.assertEqual(len(message["artifacts"][0]["sha256"]), 64)
            finally:
                labctl.STATE_DIR = old_state_dir
                labctl.MESSAGES_PATH = old_messages_path
                labctl.LEDGER_PATH = old_ledger_path

    def test_parallel_mailbox_sends_preserve_both_messages(self) -> None:
        labctl = load_module("labctl_parallel_mailbox", ROOT / "scripts" / "labctl.py")
        with tempfile.TemporaryDirectory() as temporary:
            state_dir = Path(temporary)
            messages_path = state_dir / "MESSAGES.json"
            ledger_path = state_dir / "LEDGER.md"
            messages_path.write_text(
                json.dumps({"schema_version": 1, "messages": []}) + "\n",
                encoding="utf-8",
            )
            ledger_path.write_text("# Test ledger\n", encoding="utf-8")
            old_state_dir = labctl.STATE_DIR
            old_messages_path = labctl.MESSAGES_PATH
            old_ledger_path = labctl.LEDGER_PATH
            labctl.STATE_DIR = state_dir
            labctl.MESSAGES_PATH = messages_path
            labctl.LEDGER_PATH = ledger_path
            try:
                def send(subject: str) -> int:
                    return labctl.command_send(
                        types.SimpleNamespace(
                            from_model="codex",
                            to_model="claude",
                            kind="notice",
                            priority="normal",
                            item="LAB-BOOTSTRAP-001",
                            subject=subject,
                            message="concurrency test",
                            artifact=[],
                            command=[],
                            ttl_hours=1.0,
                        )
                    )

                with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
                    results = list(pool.map(send, ["first", "second"]))
                self.assertEqual(results, [0, 0])
                registry = json.loads(messages_path.read_text(encoding="utf-8"))
                self.assertEqual(
                    {message["subject"] for message in registry["messages"]},
                    {"first", "second"},
                )
            finally:
                labctl.STATE_DIR = old_state_dir
                labctl.MESSAGES_PATH = old_messages_path
                labctl.LEDGER_PATH = old_ledger_path

    def test_parallel_availability_updates_preserve_both_records(self) -> None:
        labctl = load_module("labctl_parallel_availability", ROOT / "scripts" / "labctl.py")
        with tempfile.TemporaryDirectory() as temporary:
            state_dir = Path(temporary)
            state_path = state_dir / "LAB_STATE.json"
            portfolio_path = state_dir / "PORTFOLIO.json"
            work_path = state_dir / "WORK_ITEMS.json"
            ledger_path = state_dir / "LEDGER.md"
            state_path.write_text(
                (ROOT / "state" / "LAB_STATE.json").read_text(encoding="utf-8"),
                encoding="utf-8",
            )
            portfolio_path.write_text(
                (ROOT / "state" / "PORTFOLIO.json").read_text(encoding="utf-8"),
                encoding="utf-8",
            )
            work_path.write_text(
                (ROOT / "state" / "WORK_ITEMS.json").read_text(encoding="utf-8"),
                encoding="utf-8",
            )
            ledger_path.write_text("# Test ledger\n", encoding="utf-8")
            old_values = {
                "STATE_DIR": labctl.STATE_DIR,
                "LAB_STATE_PATH": labctl.LAB_STATE_PATH,
                "PORTFOLIO_PATH": labctl.PORTFOLIO_PATH,
                "WORK_ITEMS_PATH": labctl.WORK_ITEMS_PATH,
                "LEDGER_PATH": labctl.LEDGER_PATH,
            }
            labctl.STATE_DIR = state_dir
            labctl.LAB_STATE_PATH = state_path
            labctl.PORTFOLIO_PATH = portfolio_path
            labctl.WORK_ITEMS_PATH = work_path
            labctl.LEDGER_PATH = ledger_path
            try:
                def update(target: str) -> int:
                    return labctl.command_availability(
                        types.SimpleNamespace(
                            model="codex",
                            target=target,
                            status="degraded",
                            detail=f"parallel-{target}",
                        )
                    )

                with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
                    results = list(pool.map(update, ["codex", "claude"]))
                self.assertEqual(results, [0, 0])
                state = json.loads(state_path.read_text(encoding="utf-8"))
                self.assertEqual(state["availability"]["codex"]["detail"], "parallel-codex")
                self.assertEqual(state["availability"]["claude"]["detail"], "parallel-claude")
                self.assertEqual(list(state_dir.glob("LAB_STATE.json.*.tmp")), [])
            finally:
                for name, value in old_values.items():
                    setattr(labctl, name, value)

    def test_aristotle_job_register_and_update_lifecycle(self) -> None:
        labctl = load_module("labctl_job_lifecycle", ROOT / "scripts" / "labctl.py")
        with tempfile.TemporaryDirectory() as temporary:
            state_dir = Path(temporary)
            jobs_path = state_dir / "ARISTOTLE_JOBS.json"
            ledger_path = state_dir / "LEDGER.md"
            jobs_path.write_text(
                json.dumps({"schema_version": 1, "jobs": []}) + "\n",
                encoding="utf-8",
            )
            ledger_path.write_text("# Test ledger\n", encoding="utf-8")
            old_state_dir = labctl.STATE_DIR
            old_jobs_path = labctl.ARISTOTLE_JOBS_PATH
            old_ledger_path = labctl.LEDGER_PATH
            labctl.STATE_DIR = state_dir
            labctl.ARISTOTLE_JOBS_PATH = jobs_path
            labctl.LEDGER_PATH = ledger_path
            try:
                self.assertEqual(
                    labctl.command_job_register(
                        types.SimpleNamespace(
                            job_id="test-job",
                            work_item="DYN-MODULAR-001",
                            title="Test theorem",
                            status="submitted",
                            submitted_at="2026-07-12",
                            notes="isolated lifecycle test",
                            model="codex",
                        )
                    ),
                    0,
                )
                self.assertEqual(
                    labctl.command_job_update(
                        types.SimpleNamespace(
                            job_id="test-job",
                            status="integrated",
                            note="replayed locally",
                            model="codex",
                        )
                    ),
                    0,
                )
                job = json.loads(jobs_path.read_text(encoding="utf-8"))["jobs"][0]
                self.assertEqual(job["status"], "integrated")
                self.assertIn("replayed locally", job["notes"])
            finally:
                labctl.STATE_DIR = old_state_dir
                labctl.ARISTOTLE_JOBS_PATH = old_jobs_path
                labctl.LEDGER_PATH = old_ledger_path

    def test_handoff_and_reproduction_manifest_are_state_derived(self) -> None:
        labctl = load_module("labctl_handoff", ROOT / "scripts" / "labctl.py")
        state, portfolio, work = labctl.load_all()
        handoff = labctl.render_handoff(state, portfolio, work)
        self.assertIn(state["north_star"], handoff)
        active = [
            item for item in work["items"] if item["status"] in labctl.ACTIVE_WORK_STATUSES
        ]
        if active:
            self.assertIn(active[0]["id"], handoff)
        self.assertIn(labctl.state_watermark(), handoff)
        continuum = next(
            item for item in work["items"] if item["id"] == "CONT-PROJ-001"
        )
        manifest = labctl.render_reproduction_manifest(continuum)
        self.assertIn("D-PROJ-L2", str(continuum["claim_ids"]))
        self.assertIn("lake build", manifest)
        self.assertIn("Required reproducer family: `claude`", manifest)

    def test_role_packet_contains_state_and_roles(self) -> None:
        module = load_module("build_role_packet", ROOT / "scripts" / "build_role_packet.py")
        packet = module.compose_packet(
            "codex", "skeptic", "NE-GAUGE-CHIRAL", "GAUGE-COV-001"
        )
        self.assertIn("Core role: Skeptic", packet)
        self.assertIn("Codex overlay: Skeptic", packet)
        self.assertIn("GAUGE-COV-001", packet)
        self.assertIn("Gauge conjugation covariance", packet)

    def test_work_item_infers_project_in_packet_header(self) -> None:
        module = load_module(
            "build_role_packet_inference", ROOT / "scripts" / "build_role_packet.py"
        )
        packet = module.compose_packet(
            "claude", "educator", work_item_id="EDU-OVERVIEW-001"
        )
        self.assertIn("- Project: `LAB-INFRA`", packet)
        self.assertIn("Build the first evidence-preserving", packet)

    def test_strategic_role_cadences_are_enforced(self) -> None:
        schedule = json.loads(
            (ROOT / "state" / "ROLE_SCHEDULE.json").read_text(encoding="utf-8")
        )
        self.assertEqual(schedule["policies"]["visionary"]["cadence_hours"], 3.0)
        self.assertEqual(schedule["policies"]["superstar"]["cadence_hours"], 6.0)
        self.assertEqual(schedule["policies"]["archivist"]["cadence_hours"], 6.0)
        self.assertEqual(schedule["policies"]["lab_manager"]["cadence_hours"], 3.0)

    def test_role_schedule_due_and_active_states(self) -> None:
        labctl = load_module("labctl_role_rows", ROOT / "scripts" / "labctl.py")
        registry = {
            "policies": {
                "visionary": {
                    "mode": "periodic",
                    "cadence_hours": 3.0,
                    "first_due_at": "2026-07-12T12:00:00-07:00",
                }
            },
            "activations": [],
        }
        now = labctl.parse_iso("2026-07-12T13:00:00-07:00")
        row = labctl.role_schedule_rows(registry, now)[0]
        self.assertEqual(row["status"], "DUE")
        registry["activations"].append(
            {
                "id": "role-test",
                "role": "visionary",
                "status": "active",
                "started_at": "2026-07-12T12:30:00-07:00",
                "due_at": "2026-07-12T13:30:00-07:00",
            }
        )
        row = labctl.role_schedule_rows(registry, now)[0]
        self.assertEqual(row["status"], "ACTIVE")

    def test_role_activation_requires_hashed_contracted_artifact(self) -> None:
        labctl = load_module("labctl_role_lifecycle", ROOT / "scripts" / "labctl.py")
        with tempfile.TemporaryDirectory() as temporary:
            repo_root = Path(temporary) / "repo"
            lab_root = repo_root / "AutonomousLab"
            state_dir = lab_root / "state"
            state_dir.mkdir(parents=True)
            schedule_path = state_dir / "ROLE_SCHEDULE.json"
            ledger_path = state_dir / "LEDGER.md"
            schedule_path.write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "policies": {
                            "visionary": {
                                "mode": "periodic",
                                "cadence_hours": 3.0,
                                "session_hours": 1.0,
                                "first_due_at": "2026-07-12T12:00:00-07:00",
                                "rotate_model_families": True,
                                "output_contract": "Rank decisive gates.",
                            }
                        },
                        "activations": [],
                    }
                )
                + "\n",
                encoding="utf-8",
            )
            ledger_path.write_text("# Test ledger\n", encoding="utf-8")
            old_values = {
                "ROOT": labctl.ROOT,
                "STATE_DIR": labctl.STATE_DIR,
                "ROLE_SCHEDULE_PATH": labctl.ROLE_SCHEDULE_PATH,
                "LEDGER_PATH": labctl.LEDGER_PATH,
                "load_all": labctl.load_all,
                "generate_role_packet": labctl.generate_role_packet,
            }
            labctl.ROOT = lab_root
            labctl.STATE_DIR = state_dir
            labctl.ROLE_SCHEDULE_PATH = schedule_path
            labctl.LEDGER_PATH = ledger_path
            labctl.load_all = lambda: (
                {
                    "availability": {
                        "codex": {"status": "available"},
                        "claude": {"status": "available"},
                    }
                },
                {"projects": [{"id": "LAB-INFRA"}]},
                {"items": []},
            )

            def fake_packet(
                _model: str,
                _role: str,
                packet_path: str,
                _project: str | None,
                _item: str | None,
                contract: str,
            ) -> None:
                target = repo_root / packet_path
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text(contract + "\n", encoding="utf-8")

            labctl.generate_role_packet = fake_packet
            try:
                start = types.SimpleNamespace(
                    role="visionary",
                    model="codex",
                    hours=None,
                    project="LAB-INFRA",
                    work_item=None,
                    deliverable=None,
                    note="test activation",
                    force=False,
                )
                self.assertEqual(labctl.command_role_start(start), 0)
                registry = json.loads(schedule_path.read_text(encoding="utf-8"))
                activation = registry["activations"][0]
                deliverable = repo_root / activation["deliverable_path"]
                deliverable.parent.mkdir(parents=True, exist_ok=True)
                deliverable.write_text("ranked gates\n", encoding="utf-8")
                complete = types.SimpleNamespace(
                    activation_id=activation["id"],
                    model="codex",
                    artifact=activation["deliverable_path"],
                    summary="completed test",
                )
                self.assertEqual(labctl.command_role_complete(complete), 0)
                completed = json.loads(schedule_path.read_text(encoding="utf-8"))[
                    "activations"
                ][0]
                self.assertEqual(completed["status"], "completed")
                self.assertEqual(len(completed["artifact"]["sha256"]), 64)
            finally:
                for name, value in old_values.items():
                    setattr(labctl, name, value)


if __name__ == "__main__":
    unittest.main()
