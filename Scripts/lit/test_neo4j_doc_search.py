#!/usr/bin/env python3
"""Network-free tests for incremental repository document discovery."""

from __future__ import annotations

import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import neo4j_doc_search as docs  # noqa: E402


class IncrementalDiscoveryTests(unittest.TestCase):
    def test_changed_mode_does_not_walk_unrelated_roots(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            changed_source = root / "Sources" / "changed.md"
            unchanged_source = root / "Sources" / "unchanged.md"
            lab_note = root / "AutonomousLab" / "work" / "note.md"
            changed_source.parent.mkdir(parents=True)
            lab_note.parent.mkdir(parents=True)
            changed_source.write_text("changed", encoding="utf-8")
            unchanged_source.write_text("unchanged", encoding="utf-8")
            lab_note.write_text("lab", encoding="utf-8")

            with patch.object(docs, "REPO", root), patch.object(
                docs,
                "_git_changed_paths",
                return_value={changed_source.resolve(), (root / "AutonomousLab").resolve()},
            ):
                found = {p.resolve() for p in docs.iter_files(changed_only=True)}

            self.assertEqual(found, {changed_source.resolve(), lab_note.resolve()})

    def test_changed_mode_prunes_submission_bundles(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            excluded = root / "AgentTasks" / "aristotle-submit" / "job" / "note.md"
            excluded.parent.mkdir(parents=True)
            excluded.write_text("duplicate", encoding="utf-8")

            with patch.object(docs, "REPO", root), patch.object(
                docs,
                "_git_changed_paths",
                return_value={(root / "AgentTasks" / "aristotle-submit").resolve()},
            ):
                self.assertEqual(list(docs.iter_files(changed_only=True)), [])

    def test_changed_mode_includes_latex_manuscripts(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            manuscript = root / "Sources" / "paper.tex"
            manuscript.parent.mkdir(parents=True)
            manuscript.write_text(r"\section{Result}", encoding="utf-8")

            with patch.object(docs, "REPO", root), patch.object(
                docs, "_git_changed_paths", return_value={manuscript.resolve()}
            ):
                self.assertEqual(
                    list(docs.iter_files(changed_only=True)), [manuscript.resolve()]
                )

    def test_latex_chunking_preserves_section_titles(self) -> None:
        chunks = docs._chunk_latex(
            "\\title{Test Paper}\n\\section{First Gate}\nA result.\n"
            "\\subsection{Boundary}\nA caveat."
        )
        headings = [heading for heading, _text in chunks]
        self.assertEqual(headings, ["preamble", "First Gate", "Boundary"])

    def test_selected_files_accepts_indexed_latex_and_rejects_other_files(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            manuscript = root / "Sources" / "paper.tex"
            excluded = root / "scratch.txt"
            manuscript.parent.mkdir(parents=True)
            manuscript.write_text("paper", encoding="utf-8")
            excluded.write_text("scratch", encoding="utf-8")

            with patch.object(docs, "REPO", root):
                self.assertEqual(docs.selected_files(["Sources/paper.tex"]), [manuscript])
                with self.assertRaises(SystemExit):
                    docs.selected_files(["scratch.txt"])


class ExactLookupTests(unittest.TestCase):
    def test_normalize_repo_path_handles_windows_and_dot_prefix(self) -> None:
        self.assertEqual(
            docs._normalize_repo_path(r".\PhysicsSM\Draft\NullEdge\Core.lean"),
            "PhysicsSM/Draft/NullEdge/Core.lean",
        )

    def test_exact_path_lookup_uses_project_and_normalized_path(self) -> None:
        class Result:
            def data(self):
                return [{"path": "PhysicsSM/Core.lean", "chunk_count": 2}]

        class Session:
            def __init__(self):
                self.query = None
                self.params = None

            def __enter__(self):
                return self

            def __exit__(self, *_args):
                return False

            def run(self, query, **params):
                self.query = query
                self.params = params
                return Result()

        class Driver:
            def __init__(self, session):
                self._session = session
                self.closed = False

            def session(self, database):
                self.database = database
                return self._session

            def close(self):
                self.closed = True

        session = Session()
        driver = Driver(session)
        with patch.object(docs, "_driver", return_value=(driver, "neo4j")):
            rows = docs.exact_results(r".\PhysicsSM\Core.lean", None)

        self.assertEqual(rows[0]["chunk_count"], 2)
        self.assertEqual(session.params["project"], docs.PROJECT)
        self.assertEqual(session.params["path"], "PhysicsSM/Core.lean")
        self.assertIn("count(c) AS chunk_count", session.query)
        self.assertTrue(driver.closed)

    def test_exact_declaration_lookup_can_be_path_restricted(self) -> None:
        class Result:
            def data(self):
                return [{"declaration": "mass_identity", "ord": 4}]

        class Session:
            def __enter__(self):
                return self

            def __exit__(self, *_args):
                return False

            def run(self, query, **params):
                self.query = query
                self.params = params
                return Result()

        class Driver:
            def __init__(self, session):
                self._session = session

            def session(self, database):
                return self._session

            def close(self):
                pass

        session = Session()
        with patch.object(docs, "_driver", return_value=(Driver(session), "neo4j")):
            rows = docs.exact_results("PhysicsSM/Core.lean", "mass_identity")

        self.assertEqual(rows[0]["declaration"], "mass_identity")
        self.assertEqual(session.params["declaration"], "mass_identity")
        self.assertEqual(session.params["path"], "PhysicsSM/Core.lean")
        self.assertIn("c.ord AS ord", session.query)


if __name__ == "__main__":
    unittest.main()
