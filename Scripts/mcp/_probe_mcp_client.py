"""Authoritative out-of-session probe of the lean-explore MCP server.

Uses the real `mcp` client library (the same protocol implementation the Claude
client uses) to spawn the wrapper, initialize, list tools, and call
`search_summary`. This distinguishes a genuine server deadlock from a limitation
of the minimal `mcp_call.py` harness. Run with the lean-explore tool-env python.
"""

import asyncio
import sys
import time

from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

WRAPPER = sys.argv[1] if len(sys.argv) > 1 else "c:/Projects/StandardModel/Scripts/mcp/lean_explore_xpu.py"


async def main() -> None:
    params = StdioServerParameters(command=sys.executable, args=[WRAPPER])
    async with stdio_client(params) as (read, write):
        async with ClientSession(read, write) as session:
            await asyncio.wait_for(session.initialize(), timeout=60)
            tools = await asyncio.wait_for(session.list_tools(), timeout=30)
            print("tools:", [t.name for t in tools.tools], flush=True)

            t0 = time.time()
            res = await asyncio.wait_for(
                session.call_tool(
                    "search_summary",
                    {"query": "determinant of sum of rank one matrices", "limit": 3},
                ),
                timeout=200,
            )
            print(f"call_tool returned in {time.time() - t0:.1f}s", flush=True)
            for block in res.content:
                text = getattr(block, "text", None)
                if text:
                    print(text[:800], flush=True)


if __name__ == "__main__":
    asyncio.run(main())
