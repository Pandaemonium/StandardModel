from __future__ import annotations

import importlib.util
import json
import subprocess
import sys
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
        for model in ("codex", "claude", "opus", "aristotle"):
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
        work["items"][0]["skeptic_model"] = "opus"
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
            "opus", "educator", work_item_id="EDU-OVERVIEW-001"
        )
        self.assertIn("- Project: `LAB-INFRA`", packet)
        self.assertIn("Build the first evidence-preserving", packet)


if __name__ == "__main__":
    unittest.main()
