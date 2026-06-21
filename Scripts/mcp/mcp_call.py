#!/usr/bin/env python3
"""Minimal stdio MCP client for ad-hoc calls from the shell.

Why this exists
---------------
When an MCP server is added or fixed in ``.mcp.json``, an already-running client
session (Claude Code, Codex, ...) does not pick up the new tools until it
reconnects. This helper lets us drive a configured MCP server directly --
``initialize`` then a single ``tools/list`` or ``tools/call`` -- without a
session restart. It speaks the newline-delimited JSON MCP stdio transport.

Usage
-----
    python Scripts/mcp/mcp_call.py <server> --list
    python Scripts/mcp/mcp_call.py <server> <tool> --args '{"query": "..."}'
    python Scripts/mcp/mcp_call.py <server> <tool> --args-file args.json

``<server>`` is a key under ``mcpServers`` in ``.mcp.json`` (e.g. ``scholarly``,
``zotero_write``, ``neo4j_graph``, ``local-qwen``).

The server command, args, and env are taken from ``.mcp.json``; ``${VAR}`` and
``${VAR:-default}`` references are expanded from the current environment. This is
the documented workaround in ``Scripts/MCP_SERVERS.md``.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import threading

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
MCP_CONFIG = os.path.join(REPO_ROOT, ".mcp.json")

ENV_RE = re.compile(r"\$\{([^}]+)\}")


def expand(value: str) -> str:
    """Expand ${VAR} and ${VAR:-default} from the environment (unset -> '')."""

    def repl(match: "re.Match[str]") -> str:
        name = match.group(1)
        default = ""
        if ":-" in name:
            name, default = name.split(":-", 1)
        return os.environ.get(name, default)

    return ENV_RE.sub(repl, value)


def load_server(name: str):
    with open(MCP_CONFIG, encoding="utf-8") as handle:
        config = json.load(handle)
    servers = config.get("mcpServers", {})
    if name not in servers:
        raise SystemExit(
            f"server {name!r} not in {MCP_CONFIG}; known: {', '.join(sorted(servers))}"
        )
    spec = servers[name]
    command = [expand(spec["command"])] + [expand(a) for a in spec.get("args", [])]
    env = dict(os.environ)
    for key, raw in spec.get("env", {}).items():
        env[key] = expand(raw)
    return command, env


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("server", help="server name from .mcp.json")
    parser.add_argument("tool", nargs="?", help="tool name; omit for tools/list")
    parser.add_argument("--args", default="{}", help="tool arguments as a JSON string")
    parser.add_argument("--args-file", help="read tool arguments from a JSON file")
    parser.add_argument("--list", action="store_true", help="list tools and exit")
    parser.add_argument("--timeout", type=float, default=90.0, help="hard kill after N seconds")
    parser.add_argument("--raw", action="store_true", help="print the full JSON-RPC result")
    ns = parser.parse_args()

    command, env = load_server(ns.server)
    proc = subprocess.Popen(
        command,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        env=env,
        cwd=REPO_ROOT,
    )

    # Drain stderr in the background so server log lines never block us.
    err_chunks: list[bytes] = []
    threading.Thread(
        target=lambda: err_chunks.append(proc.stderr.read() or b""), daemon=True
    ).start()

    # Watchdog: never hang forever on a silent server.
    watchdog = threading.Timer(ns.timeout, proc.kill)
    watchdog.start()

    def send(obj: dict) -> None:
        proc.stdin.write((json.dumps(obj) + "\n").encode("utf-8"))
        proc.stdin.flush()

    def recv(want_id: int):
        while True:
            line = proc.stdout.readline()
            if not line:
                return None  # EOF / killed
            line = line.strip()
            if not line:
                continue
            try:
                msg = json.loads(line)
            except json.JSONDecodeError:
                continue  # ignore non-JSON noise on stdout
            if msg.get("id") == want_id:
                return msg

    def fail(note: str) -> int:
        watchdog.cancel()
        proc.kill()
        stderr = (err_chunks[0].decode("utf-8", "replace") if err_chunks else "").strip()
        sys.stderr.write(note + "\n")
        if stderr:
            sys.stderr.write("--- server stderr ---\n" + stderr + "\n")
        return 1

    try:
        send(
            {
                "jsonrpc": "2.0",
                "id": 1,
                "method": "initialize",
                "params": {
                    "protocolVersion": "2025-03-26",
                    "capabilities": {},
                    "clientInfo": {"name": "mcp_call", "version": "0.1.0"},
                },
            }
        )
        if recv(1) is None:
            return fail(f"no initialize response from {ns.server!r}")
        send({"jsonrpc": "2.0", "method": "notifications/initialized"})

        if ns.list or not ns.tool:
            send({"jsonrpc": "2.0", "id": 2, "method": "tools/list", "params": {}})
            resp = recv(2)
            if resp is None:
                return fail("no tools/list response")
            tools = resp.get("result", {}).get("tools", [])
            print(json.dumps(
                {"server": ns.server,
                 "tools": [{"name": t["name"], "description": t.get("description", "")} for t in tools]},
                indent=2, ensure_ascii=False))
        else:
            if ns.args_file:
                with open(ns.args_file, encoding="utf-8") as handle:
                    arguments = json.load(handle)
            else:
                arguments = json.loads(ns.args)
            send(
                {
                    "jsonrpc": "2.0",
                    "id": 3,
                    "method": "tools/call",
                    "params": {"name": ns.tool, "arguments": arguments},
                }
            )
            resp = recv(3)
            if resp is None:
                return fail(f"no response to tools/call {ns.tool!r}")
            if "error" in resp:
                return fail("tool error: " + json.dumps(resp["error"], ensure_ascii=False))
            result = resp.get("result", resp)
            if ns.raw:
                print(json.dumps(result, indent=2, ensure_ascii=False))
            else:
                # Prefer structuredContent; else concatenate text content blocks.
                if isinstance(result, dict) and result.get("structuredContent") is not None:
                    print(json.dumps(result["structuredContent"], indent=2, ensure_ascii=False))
                elif isinstance(result, dict) and isinstance(result.get("content"), list):
                    for block in result["content"]:
                        if block.get("type") == "text":
                            print(block.get("text", ""))
                else:
                    print(json.dumps(result, indent=2, ensure_ascii=False))
    finally:
        watchdog.cancel()
        try:
            proc.stdin.close()
            proc.wait(timeout=5)
        except Exception:
            proc.kill()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
