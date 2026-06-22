"""Launch the lean-explore local MCP server with models on the Intel Arc (XPU).

Fixes two problems with lean-explore's local MCP server on this machine, without
editing third-party source (so it survives `uv tool` reinstalls). Launched with
the lean-explore tool-env interpreter (which carries the `+xpu` torch build);
see `.mcp.json`.

1. Device. lean-explore's `EmbeddingClient`/`RerankerClient` auto-select via
   `_select_device()`, which only knows `cuda` -> `mps` -> `cpu`; on this box
   (Intel Arc A750, no NVIDIA) that lands on CPU (~30 s/query). We patch both to
   prefer the Intel XPU and run the two Qwen3-0.6B models in fp16 (~2.4 GB vs
   ~4.8 GB - the Arc is shared with Ollama). Falls back to the original order if
   XPU is unavailable.

2. The search hang. The clients dispatch model inference to a thread pool via
   `loop.run_in_executor(...)`. On Intel XPU that moves the GPU work off the
   thread that owns the SYCL context, which deadlocks (the search reaches the
   embedding step and never returns). The standalone `asyncio.run` case only
   worked by luck of thread layout. Fix: patch `embed`/`rerank` to run inference
   INLINE (no executor) so all XPU work stays on the one FastMCP event-loop
   thread, and pre-warm the models synchronously at startup so that thread also
   loads them and the first real query is fast. A query then briefly blocks the
   loop (~2-3 s), which is fine.
"""

import os
import sys

# Models are cached; force HF offline (no network HEAD requests that stall the
# loop) and silence tqdm/HF chatter. Set before any heavy import.
os.environ.setdefault("TQDM_DISABLE", "1")
os.environ.setdefault("HF_HUB_DISABLE_PROGRESS_BARS", "1")
os.environ.setdefault("HF_HUB_DISABLE_SYMLINKS_WARNING", "1")
os.environ.setdefault("TRANSFORMERS_VERBOSITY", "error")
os.environ.setdefault("HF_HUB_OFFLINE", "1")
os.environ.setdefault("TRANSFORMERS_OFFLINE", "1")

import asyncio

import torch

from lean_explore.search import Service
from lean_explore.util import EmbeddingClient, RerankerClient
from lean_explore.util.embedding_client import EmbeddingResponse
from lean_explore.util.reranker_client import RerankerResponse


def _log(msg: str) -> None:
    print(f"[lean_explore_xpu] {msg}", file=sys.stderr, flush=True)


# --- 1. Device selection: prefer the Intel Arc (XPU), run the models in fp16. ---

def _xpu_first(self) -> str:
    if hasattr(torch, "xpu") and torch.xpu.is_available():
        return "xpu"
    if torch.cuda.is_available():
        return "cuda"
    mps = getattr(torch.backends, "mps", None)
    if mps is not None and mps.is_available():
        return "mps"
    return "cpu"


def _half_on_xpu(init):
    def wrapped(self, *args, **kwargs):
        init(self, *args, **kwargs)
        if getattr(self, "device", "") == "xpu" and getattr(self, "model", None) is not None:
            try:
                self.model = self.model.half()
            except Exception as exc:
                _log(f"fp16 cast skipped: {exc}")

    return wrapped


for _cls in (EmbeddingClient, RerankerClient):
    _cls._select_device = _xpu_first
    _cls.__init__ = _half_on_xpu(_cls.__init__)


# --- 2. Run all model inference INLINE (no run_in_executor) so XPU work stays ---
#        on the event-loop thread that owns the SYCL context.

async def _embed_inline(self, texts, is_query: bool = False):
    encode_kwargs = {"show_progress_bar": False, "convert_to_numpy": True, "batch_size": 256}
    if is_query:
        encode_kwargs["prompt_name"] = "query"
    embeddings = self.model.encode(texts, **encode_kwargs)
    return EmbeddingResponse(
        texts=texts,
        embeddings=[emb.tolist() for emb in embeddings],
        model=self.model_name,
    )


async def _rerank_inline(self, query, documents, batch_size: int | None = None):
    if not documents:
        return RerankerResponse(query=query, scores=[], model=self.model_name)
    if batch_size is None:
        batch_size = 16  # conservative for the shared 8 GB Arc
    if len(documents) <= batch_size:
        return self.rerank_sync(query, documents)
    pairs = [self._format_pair(query, doc) for doc in documents]
    all_scores: list[float] = []
    for i in range(0, len(pairs), batch_size):
        all_scores.extend(self._compute_scores_sync(pairs[i : i + batch_size]))
    return RerankerResponse(query=query, scores=all_scores, model=self.model_name)


EmbeddingClient.embed = _embed_inline
RerankerClient.rerank = _rerank_inline


# --- 3. Synchronous pre-warm at startup: load the models on this (main) thread ---
#        before serving, so the first real query is warm and on the right thread.

_orig_service_init = Service.__init__


def _service_init_with_prewarm(self, *args, **kwargs):
    _orig_service_init(self, *args, **kwargs)
    try:
        asyncio.run(self.search(query="warmup", limit=1, rerank_top=1))
        _log("pre-warm complete (models on xpu, FAISS loaded)")
    except Exception as exc:
        _log(f"pre-warm failed (first query will be cold): {exc}")


Service.__init__ = _service_init_with_prewarm


if __name__ == "__main__":
    from lean_explore.mcp.server import main

    sys.argv = ["lean-explore-mcp-xpu", "--backend", "local"]
    main()
