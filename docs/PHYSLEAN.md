# PhysLean (formerly HepLean): access and integration

**What it is.** PhysLean (renamed from HepLean; Tooby-Smith et al., arXiv:2405.08863)
is an open-source Lean 4 + Mathlib formalization of physics: Standard Model &
beyond (anomaly cancellation, Higgs, CKM, Spin(10), Pati-Salam, two-Higgs-
doublet, right-handed neutrinos), QFT, classical field theory, relativity,
Lorentz group, condensed matter, statistical mechanics, string theory, and
more. **641 `.lean` files, Apache-2.0 licensed.** The Lean library is named
**`Physlib`** (source root `Physlib/`).

Apache-2.0 is permissive: per [`../AGENTS.md`](../AGENTS.md) ("External code and
licensing") we MAY consult it, use it as a comparison target / source of ideas,
and reuse with attribution - but the project style is to **translate the
mathematics and clean-room formalize**, not copy implementation text into
trusted Lean.

## Current access (three tiers, two already live)

### 1. Semantic search - LIVE (`lean-explore` MCP)

The `lean-explore` MCP already indexes PhysLean under package label **`Physlib`**
(offline, GPU-backed). This is the primary discovery tool.

```text
mcp__lean-explore__search_summary  query="Higgs potential Standard Model"  packages=["Physlib"]
  -> StandardModel.HiggsField.Potential, StandardModel.GaugeGroupI, TwoHiggsDoublet..., ...
mcp__lean-explore__get_source_code / get_docstring / get_module / get_dependencies  <id>
```

Use it before formalizing anything SM/QFT/relativity-adjacent: check whether
PhysLean already has the object, read its source, and either cite it or
clean-room port the idea. Note the index may lag PhysLean master; cross-check
against the source clone (tier 2) for anything recent.

### 2. Full-source reference clone - LIVE

A shallow clone lives at **`AgentTasks/external/PhysLean`** (gitignored;
`master`, toolchain v4.31.0). Use `Grep`/`Read` over it for full-text browsing,
convention-checking, and clean-room porting. Refresh with
`git -C AgentTasks/external/PhysLean pull` (or re-clone `--depth 1`).

Directly relevant areas for this project: `Physlib/Relativity` (Lorentz group,
spinors), `Physlib/Particles/StandardModel` and `.../BeyondTheStandardModel/Spin10`
(cross-checks for our octonion/Spin(10) and SM-charge work),
`Physlib/QFT`, `Physlib/ClassicalFieldTheory`.

### 3. Build dependency (import PhysLean in our Lean) - BLOCKED by version pin

**PhysLean master requires Lean/Mathlib v4.31.0; we are hard-pinned to v4.28.0**
(for Aristotle and Sphere-Packing-Lean; see `lakefile.toml`). Adding
`require Physlib` at master would force a single Mathlib version and fail to
resolve. So a direct build integration is **not available without changing our
pin**, which the lakefile explicitly forbids.

Options if a genuine `import Physlib.*` dependency is ever needed:

- **(a) Pin a v4.28.0-era PhysLean commit** as an *optional* require behind a
  separate lake root (the pattern the lakefile already uses for `PhysicsSMSPL`).
  PhysLean tracked Mathlib v4.28.0 around mid-2025; `git log` an unshallowed
  clone for the commit whose `lean-toolchain` is `v4.28.0`, and
  `require Physlib git=... rev=<that-commit>`. Cost: that older PhysLean lacks
  recent additions, and a second Mathlib-consistent require is fiddly.
- **(b) Bump the whole stack to v4.31.0.** NOT recommended - breaks the
  Aristotle + SpherePacking pin; only do it if Mathlib, SpherePacking, and the
  Aristotle workflow all rebuild cleanly under v4.31.0 (the lakefile's rule).
- **(c) Don't build-integrate.** Recommended default: tiers 1+2 give full
  read/discovery/clean-room access, which is the project's preferred mode anyway
  (translate math, don't copy). Only escalate to (a) for a specific,
  load-bearing import that cannot be clean-room reproduced.

## Optional: full-text meaning search alongside our own docs

To search PhysLean *by meaning at the chunk level* alongside this repo's docs
(not just declaration summaries), ingest its `.lean`/docs into the Neo4j
`ne_chunk`/doc index via `Scripts/lit/neo4j_doc_search.py` / `lit_ingest.py`
(Neo4j must be up; the MCP was down in the 2026-07-08 session). This is additive
and only worth doing if tier-1 declaration search proves too coarse.

## Recommendation

For "fully accessible" in this project's sense - **discovery + reference +
clean-room porting - you now have it** (tiers 1+2). Build-time `import` is the
only piece gated, and it is gated by the deliberate v4.28.0 pin, not by tooling.
Keep the pin; use semantic search + the source clone; escalate to a
v4.28.0-era optional require only for a specific unavoidable import.
