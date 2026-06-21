"""Launch the lean-explore local MCP server with models on the Intel Arc (XPU).

lean-explore's `EmbeddingClient` and `RerankerClient` auto-select a device with
`_select_device()`, which only knows `cuda` -> `mps` -> `cpu`; on this machine
(Intel Arc A750, no NVIDIA) that always falls back to CPU (~30 s/query). This
wrapper monkeypatches both clients to prefer the Intel XPU and to run the two
Qwen3-0.6B models in fp16, then starts the normal `--backend local` MCP server.

Why a wrapper instead of editing the package: it survives `uv tool` reinstalls
and does not modify third-party source. It is launched with the lean-explore
tool-env interpreter (which carries the `+xpu` torch build); see `.mcp.json`.

fp16 matters here: the Arc has 8 GB and is shared with Ollama, so two fp32 0.6B
models (~4.8 GB) would risk OOM, while fp16 (~2.4 GB) coexists. If XPU is
unavailable (e.g. torch reverted to the CPU build) the patch falls back to the
original cuda/mps/cpu order, so the server still runs.
"""

import sys

import torch

from lean_explore.util import EmbeddingClient, RerankerClient


def _xpu_first(self) -> str:
    """Prefer the Intel XPU; otherwise the upstream cuda/mps/cpu order."""
    if hasattr(torch, "xpu") and torch.xpu.is_available():
        return "xpu"
    if torch.cuda.is_available():
        return "cuda"
    mps = getattr(torch.backends, "mps", None)
    if mps is not None and mps.is_available():
        return "mps"
    return "cpu"


def _half_on_xpu(init):
    """Wrap a client __init__ to cast its model to fp16 when running on XPU."""

    def wrapped(self, *args, **kwargs):
        init(self, *args, **kwargs)
        if getattr(self, "device", "") == "xpu" and getattr(self, "model", None) is not None:
            try:
                self.model = self.model.half()
            except Exception as exc:  # keep fp32 on this model rather than crash
                print(f"[lean_explore_xpu] fp16 cast skipped: {exc}", file=sys.stderr)

    return wrapped


for _cls in (EmbeddingClient, RerankerClient):
    _cls._select_device = _xpu_first
    _cls.__init__ = _half_on_xpu(_cls.__init__)

if __name__ == "__main__":
    from lean_explore.mcp.server import main

    sys.argv = ["lean-explore-mcp-xpu", "--backend", "local"]
    main()
