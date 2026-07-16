"""Tests for the read-only AFPL monitoring snapshot."""

from __future__ import annotations

import datetime as dt
import json
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

import dashboard_data  # noqa: E402


class DashboardSnapshotTests(unittest.TestCase):
    def test_snapshot_is_json_serializable_and_valid(self) -> None:
        snapshot = dashboard_data.build_snapshot(
            dt.datetime(2026, 7, 12, 18, 0, tzinfo=dt.timezone(dt.timedelta(hours=-7)))
        )
        json.dumps(snapshot)
        self.assertTrue(snapshot["validation"]["ok"], snapshot["validation"]["errors"])
        self.assertIn("projects", snapshot)
        self.assertIn("roles", snapshot)
        self.assertIn("jobs", snapshot)
        self.assertIn("claims", snapshot)
        self.assertIn("execution_mode", snapshot["lab"])

    def test_tightened_roles_are_visible_at_exact_cadence(self) -> None:
        snapshot = dashboard_data.build_snapshot()
        roles = {row["role"]: row for row in snapshot["roles"]}
        self.assertEqual(roles["visionary"]["cadence_hours"], 3.0)
        self.assertEqual(roles["superstar"]["label"], "Impact Strategist")
        self.assertEqual(roles["superstar"]["cadence_hours"], 6.0)

    def test_dashboard_assets_exist(self) -> None:
        dashboard = ROOT / "dashboard"
        for name in ("index.html", "styles.css", "app.js"):
            path = dashboard / name
            self.assertTrue(path.is_file(), path)
            self.assertGreater(path.stat().st_size, 100)


if __name__ == "__main__":
    unittest.main()
