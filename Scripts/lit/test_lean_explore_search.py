"""End-to-end test of the lean-explore local search pipeline WITH reranking.

Runs the same ``Service`` the MCP server uses, but without the client watchdog,
and times each phase so we can see the cold FAISS-load and rerank costs and any
real errors. Run with the lean-explore tool env interpreter.
"""

import asyncio
import time

from lean_explore.search.service import Service


async def run() -> None:
    t0 = time.time()
    service = Service()  # lazy; FAISS/DB load on first search
    print(f"Service() constructed in {time.time() - t0:.1f}s")

    query = "determinant of a sum of rank one matrices equals sum of squared minors"
    t1 = time.time()
    resp = await service.search(query=query, limit=5, rerank_top=50)
    print(f"search(rerank_top=50) returned {resp.count} hits in {time.time() - t1:.1f}s "
          f"(reported {resp.processing_time_ms} ms)")
    for r in resp.results:
        name = getattr(r, "name", None) or getattr(r, "primary_declaration", "?")
        score = getattr(r, "score", None)
        print(f"  {score}  {name}")

    # A second query reuses the warm engine - shows steady-state latency.
    t2 = time.time()
    resp2 = await service.search(query="Clifford algebra quadratic form", limit=3, rerank_top=50)
    print(f"second warm search returned {resp2.count} hits in {time.time() - t2:.1f}s")


if __name__ == "__main__":
    asyncio.run(run())
