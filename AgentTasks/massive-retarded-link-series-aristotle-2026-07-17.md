# Aristotle job: finite massive retarded link series

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: integrated and verified

Semantic context pack:
`AgentTasks/context-packs/massive-retarded-link-series-20260717-20260717-012247.md`
(SHA-256 `3B9FF5BE6D4EBBE4003497B455F40AD220375C821301C1A32DFF46F3F45104A0`).

## Objective

Prove the exact finite massive-from-massless retarded series algebra:

```text
G_m(H) = sum_{k=0}^{H-1} (-massSq)^k K^(k+1),
(I + massSq K) G_m(H) = K - (-massSq)^H K^(H+1),
G_m(H) (I + massSq K) = K - (-massSq)^H K^(H+1).
```

Then prove exact termination for a nilpotent kernel, zero-mass reduction, and
the displayed three-event link-chain witness where a two-hop endpoint term is
present although the primitive endpoint matrix entry vanishes.

## Scope boundary

The primitive retarded kernel and squared-mass parameter are supplied. The
result is finite matrix algebra. It does not prove that the kernel is selected
from a causal graph, distinguish links from all causal relations in general,
derive a Higgs mass, construct an interacting field theory, or prove a
continuum Klein-Gordon Green function.

## Target

`AgentTasks/aristotle-standalone/massive-retarded-link-series-20260717/MassiveRetardedLinkSeries/Core.lean`

Preserve all public definitions and theorem statements. Small private helper
lemmas are welcome. The final source must contain no proof holes or new
assumptions.

Preflight: `lake env lean` accepts the focused source with exactly six
intended proof-hole warnings and no errors. Source SHA-256:
`D53D5E1578FA88770AB83DDD3DDF64D2427B9D1D7501312DF08450CDF9F7FA0A`.

## Provenance

Clean-room finite algebra based on the matrix geometric-series construction in
Steven Johnston, "Particle propagators on discrete spacetime," arXiv
`0806.3083`, and the massive-from-massless causal-set Green-function treatment
in Nomaan X, Fay Dowker, and Sumati Surya, "Scalar Field Green Functions on
Causal Sets," arXiv `1701.07212`. No source implementation was copied.

## Submission metadata

```yaml
aristotle:
  project_id: f428c1cb-e952-4f09-89a3-c64699827c36
  task_id: a5d949fc-a102-48bb-ac34-824874df32f7
  target_file: MassiveRetardedLinkSeries/Core.lean
  expected_module: MassiveRetardedLinkSeries.Core
  source_root: AgentTasks/aristotle-standalone/massive-retarded-link-series-20260717
  submission_project: AgentTasks/aristotle-submit/massive-retarded-link-series-20260717-project
  integration_target: PhysicsSM/Draft/NullEdge/MassiveRetardedLinkSeries.lean
  output_dir: AgentTasks/aristotle-output/f428c1cb-e952-4f09-89a3-c64699827c36
  status: integrated
```

Submitted as a focused Mathlib package at 2026-07-17 01:24 PDT. The focused
source passed the pinned repository environment with exactly six intended
proof-hole warnings. Aristotle warned that the fresh package contained no
local `.lake` dependency cache; this is a packaging-efficiency warning, not a
source error. The task was reported as `QUEUED`; no wait loop was started.

## Integration result

Aristotle completed all six proof targets without changing a public definition
or theorem statement. The returned source was reviewed and ported to
`PhysicsSM/Draft/NullEdge/MassiveRetardedLinkSeries.lean` under the project
namespace, with provenance and build-enforced axiom guards added.

Verification:

- `lake env lean PhysicsSM/Draft/NullEdge/MassiveRetardedLinkSeries.lean`
- `lake build PhysicsSM.Draft.NullEdge.MassiveRetardedLinkSeries` (8,026 jobs)
- Lean LSP diagnostics: empty.
- `lean_verify` on `threeLink_massive_multiedge_witness`: only `propext`,
  `Classical.choice`, and `Quot.sound`; no source-scan warnings.
