#!/usr/bin/env python3
"""Network-free regression tests for the Zotero recovery path in lit_ingest."""

from __future__ import annotations

import os
import sys
import unittest
from unittest.mock import patch

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import lit_ingest as ingest  # noqa: E402


class ZoteroRecoveryTests(unittest.TestCase):
    def test_normalize_arxiv_strips_prefix_and_version(self) -> None:
        self.assertEqual(ingest.normalize_arxiv(" arXiv:1909.06070v3 "), "1909.06070")

    @patch.object(ingest, "_zotero_call")
    def test_find_existing_matches_archive_location(self, call) -> None:
        item = {
            "key": "342HA4DS",
            "data": {
                "key": "342HA4DS",
                "title": "Symmetry-breaking and zero-one laws",
                "archiveLocation": "1909.06070v1",
                "url": "http://arxiv.org/abs/1909.06070v1",
            },
        }
        call.return_value = {"results": [item]}

        self.assertIs(
            ingest.zotero_find_existing("1909.06070", item["data"]["title"]),
            item,
        )
        call.assert_called_once_with(
            "zotero_search_items",
            {"query": "Symmetry-breaking and zero-one laws", "limit": 25},
        )

    @patch.object(ingest, "_zotero_call")
    def test_find_existing_rejects_title_only_collision(self, call) -> None:
        call.return_value = {
            "results": [
                {
                    "key": "AAAAAAAA",
                    "data": {
                        "archiveLocation": "2000.00001v1",
                        "url": "http://arxiv.org/abs/2000.00001v1",
                    },
                }
            ]
        }

        self.assertIsNone(ingest.zotero_find_existing("1909.06070", "Same title"))

    @patch.object(ingest, "_zotero_call")
    def test_find_existing_matches_url_when_archive_location_missing(self, call) -> None:
        item = {
            "key": "BBBBBBBB",
            "data": {"url": "https://arxiv.org/abs/gr-qc/0605006v1"},
        }
        call.return_value = {"results": [item]}

        self.assertIs(
            ingest.zotero_find_existing("gr-qc/0605006", "BHS"),
            item,
        )


if __name__ == "__main__":
    unittest.main()
