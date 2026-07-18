# Aristotle job: three-prong causal-diamond Lorentz witness

Date: 2026-07-16  
Work item: `GRAV-ORDER-OPERATOR-001`  
Status: completed independent comparison; no duplicate live module added

```yaml
aristotle:
  project_id: 24faf055-0650-423c-bc67-332a60420480
  task_id: 01dd6003-9d76-4bab-9b25-908158f2fb03
  target_file: ThreeProngLorentzWitness/Core.lean
  expected_module: ThreeProngLorentzWitness.Core
  source_root: AgentTasks/aristotle-standalone/three-prong-lorentz-witness-20260716
  submission_project: AgentTasks/aristotle-submit/three-prong-lorentz-witness-20260716-project
  integration_target: PhysicsSM/Draft/NullEdge/ThreeProngLorentzWitness.lean
  status: integrated
```

## Objective

Prove the first nonvacuous positive Lorentzian G2 witness surviving the direct
retarded polynomial-projector no-go. The graph is a five-event closed causal
diamond with one bottom, three incomparable middle events, and one top. The
normalized project-sign local four-dimensional causal row at the top must have
weights `8,-1,-1,-1,0`. Four explicit centered zero-sum probes should then form
a basis with exact Gram matrix `diag(1,-1,-1,-1)`.

## Exact targets

Focused Mathlib-only source:
`AgentTasks/aristotle-standalone/three-prong-lorentz-witness-20260716/ThreeProngLorentzWitness/Core.lean`.

Semantic context pack:
`AgentTasks/context-packs/three-prong-lorentz-witness-20260716-20260716-161759.md`.

Preserve all public definitions and theorem statements. In particular:

1. prove all five events lie in the displayed closed diamond;
2. compute the actual open-interval counts through `layeredPastWeight`, rather
   than replacing the graph-derived row by supplied weights;
3. prove the four displayed probes are zero-sum and linearly independent;
4. prove their exact mostly-minus Gram matrix; and
5. package them as a `Fin 4` basis of the zero-sum space.

Small private helper lemmas are welcome. Do not replace exact equality by sign
inequalities, assume the Gram result, choose a basis unrelated to the displayed
probes, or weaken the graph-derived weight bridge. If a target is false, return
the explicit counterexample or minimal corrected statement instead.

## Mathematical reason

For a weighted-difference form at top event `x`, the difference-coordinate map
from zero-sum fields to the predecessor differences `f(y)-f(x)` is invertible.
The quadratic form is therefore congruent to one half of the diagonal weight
matrix. In the three-prong diamond, the bottom-to-top open interval contains
the three middle events, so the local coefficient is `c_3=-8`; each middle-to-
top interval is empty, so the coefficient is `c_0=1`. The normalized project
sign flips these to `8,-1,-1,-1`. The time probe has difference `1/2`, while
each spatial probe has difference `sqrt 2`, giving exact entries `1,-1,-1,-1`.

## Scope boundary

Success proves a finite graph-native Lorentzian rank-four witness and nothing
more. The overall row normalization is fixed to `-1`; physical scale remains a
separate Weyl normalization. The theorem does not derive a universal selector,
show typicality, isolate four modes on larger carriers, provide a fourth/fifth
spectral gap, transport the sector across overlaps, construct a refinement
family, or establish a continuum tetrad, curvature, stress-energy, or Einstein
dynamics.

## Preregistered successor gates

- **Pass:** every exact target above is kernel checked unchanged, with a
  standard assumption footprint and an explicit nonzero Lorentz Gram witness.
- **Kill/narrow:** any weight sign or interval-count mismatch, failure of probe
  independence, or need to supply the Gram matrix independently of the causal
  row.
- **After pass only:** generalize the diagonal-congruence theorem, characterize
  rank and inertia by nonzero row weights, and test graph-native persistence on
  a separately preregistered refinement family.

## Preflight

`lake env lean` passed on the focused source with exactly seven intended proof-
hole warnings and one harmless unused-variable linter warning. A full semantic
document-index refresh exceeded five minutes and was terminated; the context
pack was then generated successfully from the last completed local indexes.
No source or theorem statement was changed to accommodate the timeout.

The focused source SHA-256 at submission was
`306255718e7341eee9f0c72933f91d528baeb9dbd993de79f9ba955ec2bb118e`.
The standalone package fetched the pinned Mathlib cache successfully, but its
cold isolated `lake env lean` invocation exceeded both 120-second and
300-second local timeouts without diagnostics. The byte-identical source had
already passed under the same pinned toolchain in the main checkout. Aristotle
project `24faf055-0650-423c-bc67-332a60420480`, task
`01dd6003-9d76-4bab-9b25-908158f2fb03`, was submitted with explicit
verbatim-statement, narrow-build, and counterexample-if-false instructions.

## Harvest and disposition

Aristotle returned `IDLE` with every intended proof complete and no public
statement changes. The returned source proves the exact graph-derived weight
row, zero-sum membership, linear independence, four-dimensional finrank, the
exact `diag(1,-1,-1,-1)` Gram matrix, and the basis packaging. It contains no
proof holes or trust-expanding declarations.

Local replay passed:

```text
lake env lean AgentTasks/aristotle-output/24faf055-0650-423c-bc67-332a60420480/extracted/project-files.tar/three-prong-lorentz-witness-20260716-project_aristotle/ThreeProngLorentzWitness/Core.lean
```

No duplicate module was copied into `PhysicsSM`. The live production chain
already proves the same finite witness and additionally reaches
`ProbeFrameLorentzGauge.HasLorentzianInertia` through
`CorrectedPairingCarrierInertiaWitness.lean`. The standalone return is retained
as an independent exact replay and semantic comparison.
