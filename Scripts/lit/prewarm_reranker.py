"""One-time pre-warm + functional test for the lean-explore reranker.

Why this exists
---------------
lean-explore's local backend reranks with ``Qwen/Qwen3-Reranker-0.6B`` (a ~1.2 GB
``transformers`` causal-LM reranker), downloaded lazily on the first ``search``
that passes ``rerank_top > 0``. That download happens inside the MCP request, so a
cold fetch + FAISS load exceeds the client watchdog, gets killed mid-download, and
leaves a partial HuggingFace cache that re-downloads next time.

Running this script once, outside any request timeout, downloads and loads the
model into the HuggingFace cache and runs a real rerank so later in-server
reranking only has to read from disk. Run it with the lean-explore tool env's
interpreter so it populates that env's cache:

    "C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe" \
        Scripts/lit/prewarm_reranker.py
"""

import asyncio
import time

import torch
from lean_explore.util.reranker_client import RerankerClient


def main() -> None:
    print(f"torch {torch.__version__}; cuda_available={torch.cuda.is_available()}")
    t0 = time.time()
    client = RerankerClient()  # downloads Qwen/Qwen3-Reranker-0.6B on first run
    print(f"reranker loaded on device={client.device} in {time.time() - t0:.1f}s")

    query = "determinant of a sum of rank one matrices"
    documents = [
        "Cauchy-Binet formula expressing a determinant as a sum over minors",
        "the determinant of a sum of rank-one Hermitian matrices equals the sum "
        "of pairwise squared wedge products",
        "a continuous function on a compact set attains its maximum",
    ]
    t1 = time.time()
    resp = asyncio.run(client.rerank(query, documents))
    print(f"rerank() returned {len(resp.scores)} scores in {time.time() - t1:.1f}s")
    for doc, score in zip(documents, resp.scores):
        print(f"  {score:+.4f}  {doc[:70]}")


if __name__ == "__main__":
    main()
