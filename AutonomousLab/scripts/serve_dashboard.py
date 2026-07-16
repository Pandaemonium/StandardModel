#!/usr/bin/env python3
"""Serve the AFPL monitoring dashboard on localhost."""

from __future__ import annotations

import argparse
import json
import sys
from http import HTTPStatus
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import unquote, urlparse

from dashboard_data import REPO_ROOT, ROOT, build_snapshot


DASHBOARD_DIR = ROOT / "dashboard"


class DashboardHandler(SimpleHTTPRequestHandler):
    """Serve static dashboard assets plus live, read-only lab state."""

    server_version = "AFPLDashboard/1.0"

    def __init__(self, *args: object, **kwargs: object) -> None:
        super().__init__(*args, directory=str(DASHBOARD_DIR), **kwargs)

    def send_json(self, value: object, status: HTTPStatus = HTTPStatus.OK) -> None:
        body = json.dumps(value, ensure_ascii=True).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self) -> None:  # noqa: N802 - stdlib handler API
        parsed = urlparse(self.path)
        if parsed.path == "/api/state":
            try:
                self.send_json(build_snapshot())
            except Exception as exc:
                self.send_json(
                    {"error": f"{type(exc).__name__}: {exc}"},
                    HTTPStatus.INTERNAL_SERVER_ERROR,
                )
            return
        if parsed.path == "/api/health":
            self.send_json({"ok": True})
            return
        if parsed.path.startswith("/repo/"):
            self.serve_repo_file(parsed.path.removeprefix("/repo/"))
            return
        super().do_GET()

    def serve_repo_file(self, relative: str) -> None:
        candidate = (REPO_ROOT / unquote(relative)).resolve()
        try:
            candidate.relative_to(REPO_ROOT.resolve())
        except ValueError:
            self.send_error(HTTPStatus.FORBIDDEN)
            return
        if not candidate.is_file():
            self.send_error(HTTPStatus.NOT_FOUND)
            return
        suffix = candidate.suffix.lower()
        if suffix not in {".md", ".json", ".lean", ".tex", ".txt", ".py"}:
            self.send_error(HTTPStatus.UNSUPPORTED_MEDIA_TYPE)
            return
        body = candidate.read_bytes()
        self.send_response(HTTPStatus.OK)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, format: str, *args: object) -> None:
        sys.stdout.write(f"dashboard: {self.address_string()} - {format % args}\n")
        sys.stdout.flush()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8765)
    args = parser.parse_args()
    server = ThreadingHTTPServer((args.host, args.port), DashboardHandler)
    print(f"AFPL dashboard: http://{args.host}:{args.port}", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
