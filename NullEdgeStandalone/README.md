# NullEdgeStandalone

Standalone Lean package for the core null-edge finite algebra material from
`PhysicsSM`.

This extraction keeps the original `PhysicsSM.*` module names so theorem names
match the monorepo, but it builds from this directory with only `Mathlib` as a
Lake dependency.  It includes the trusted Pluecker mass theorem, the twistor
chart wrapper, the static chiral slash bridge, the dual-soldered operator square
and Krein/spectral APIs, the finite tetrad-postulate theorem, and the current
Gate C audit stack through projected/Wilson release interfaces.

Post-Aristotle triage: the load-bearing spine is the Pluecker mass identity,
the graded super-Dirac square, the concrete tetrahedral dual-solder frame, and
the bare-symbol chirality no-go, now sharpened branch-by-branch in
`PhysicsSM.Draft.NullEdgeHyperdiamondNoGo`. The new
`PhysicsSM.Draft.NullEdgeHyperdiamondOperatorScaffold` gives the next
operator-facing API: first-order stencil data, principal-symbol crosswalk,
inherited square law, inherited bare chirality no-go, and projector audit
obligations, plus a Borici-Creutz convention-data landing zone and a
source-independent no-four-edge/fifth-vector obstruction. The Gate C
projected/Wilson release stack is included for audit
history only and should be treated as frozen schema material until a concrete
projected physical operator is constructed.

This directory now also contains the first 1+1D checkerboard dynamical seed:
`PhysicsSM.Draft.Checkerboard1D`. It proves that the finite mass channel is
exactly the null-direction reversal amplitude and proves the finite
matrix-power path-sum theorem for the checkerboard transfer, including
turn-grouped weights, tuple/list bridge lemmas, reverse-turn invariance, and a
unitary isotropic normalization. `PhysicsSM.Draft.CheckerboardContinuumNext`
adds the next finite layer: turn-count parity, fixed endpoint velocity
binomial counts, and the one-parameter group law for the unitary isotropic
step. `PhysicsSM.Draft.CheckerboardSpacetimeCounts` refines the count by
right/left outgoing-edge totals, proves the immediate zero cases, proves the
boundary cases, proves marginalization back to the coarser velocity count, and
proves the Earle/Jacobson-Schulman binomial-product closed form plus the direct
closed-form marginal consistency check. It now also includes small direct-count
examples, proof-library lemmas for auditing the endpoint formula, and an
entrywise generating-function bridge from the spacetime endpoint counts back to
the finite isotropic checkerboard propagator, including the packaged
binomial-product closed-form version. The continuum Dirac limit remains future
analytic work, but `PhysicsSM.Draft.CheckerboardDiracScaling` now fixes the
topology-explicit statement boundary: the finite momentum-space checkerboard
symbol power, the continuum Dirac evolution symbol, the local matrix norm
comparison, and the refinement data under which a future theorem should be
stated. The same module now also contains the pointwise per-step
second-order estimate, the one-step continuum-exponential bridge, scoped
L-infinity and L2 operator-norm stability facts, finite-product unitarity, and
a reusable matrix-power/Trotter stability toolkit; the full continuum statement
is still not claimed.

Run from this directory:

```powershell
lake build NullEdgeStandalone
```

Important docs:

- [`docs/BUILD.md`](docs/BUILD.md) - build commands and package shape.
- [`docs/COLLABORATOR_ONBOARDING.md`](docs/COLLABORATOR_ONBOARDING.md) - project map and first-week guide for new collaborators.
- [`docs/PHYSICS_CONTEXT.md`](docs/PHYSICS_CONTEXT.md) - physics target and claim boundaries for Aristotle.
- [`docs/ARISTOTLE_EVALUATION.md`](docs/ARISTOTLE_EVALUATION.md) - Aristotle's objective continue/rethink/freeze assessment.
- [`docs/CHECKERBOARD_1D.md`](docs/CHECKERBOARD_1D.md) - 1+1D checkerboard dynamical seed.
- [`docs/CHECKERBOARD_LITERATURE_REVIEW.md`](docs/CHECKERBOARD_LITERATURE_REVIEW.md) - checkerboard literature review and next proof split.
- [`docs/CHECKERBOARD_ARISTOTLE_REPORT.md`](docs/CHECKERBOARD_ARISTOTLE_REPORT.md) - integrated checkerboard path-sum result.
- [`docs/CHECKERBOARD_CONTINUUM_NEXT_REPORT.md`](docs/CHECKERBOARD_CONTINUUM_NEXT_REPORT.md) - integrated checkerboard continuum-next result and next finite endpoint-count plan.
- [`docs/CHECKERBOARD_CONTINUUM_QUOTIENT_ESTIMATES.md`](docs/CHECKERBOARD_CONTINUUM_QUOTIENT_ESTIMATES.md) - checkerboard small-angle quotient and little-o estimates.
- [`docs/CHECKERBOARD_NORMED_PRODUCT_BOUND.md`](docs/CHECKERBOARD_NORMED_PRODUCT_BOUND.md) - checkerboard entrywise L1 norm and product/remainder norm identities.
- [`docs/CHECKERBOARD_DIRAC_LIMIT_STATEMENT.md`](docs/CHECKERBOARD_DIRAC_LIMIT_STATEMENT.md) - topology-explicit checkerboard-to-Dirac theorem boundary and missing analytic lemmas.
- [`docs/HYPERDIAMOND_CROSSWALK.md`](docs/HYPERDIAMOND_CROSSWALK.md) - 3+1D hyperdiamond/no-go reframing.
- [`docs/HYPERDIAMOND_NOGO_ARISTOTLE_REPORT.md`](docs/HYPERDIAMOND_NOGO_ARISTOTLE_REPORT.md) - integrated hyperdiamond no-go result.
- [`docs/HYPERDIAMOND_BRIDGE_REPORT.md`](docs/HYPERDIAMOND_BRIDGE_REPORT.md) - integrated hyperdiamond bridge result.
- [`docs/HYPERDIAMOND_OPERATOR_SCAFFOLD.md`](docs/HYPERDIAMOND_OPERATOR_SCAFFOLD.md) - first-order stencil API and exact next operator crosswalk target.
- [`docs/HYPERDIAMOND_BORICI_CREUTZ_LITERATURE_REVIEW.md`](docs/HYPERDIAMOND_BORICI_CREUTZ_LITERATURE_REVIEW.md) - convention review before any named Borici-Creutz equivalence claim.
- [`docs/BORICI_CREUTZ_NEXT_CONVENTION_DATA.md`](docs/BORICI_CREUTZ_NEXT_CONVENTION_DATA.md) - exact source data still needed for a named Borici-Creutz crosswalk.
- [`docs/NO_FOUR_EDGE_POLE_STRUCTURE_REPORT.md`](docs/NO_FOUR_EDGE_POLE_STRUCTURE_REPORT.md) - source-independent no-four-edge/fifth-vector pole-structure obstruction.
- [`docs/NULL_EDGE_NEXT_STEP_REPORT.md`](docs/NULL_EDGE_NEXT_STEP_REPORT.md) - integrated checkerboard/Borici-Creutz next-step report.
- [`docs/CHIRALPROJ_AUDIT.md`](docs/CHIRALPROJ_AUDIT.md) - audit of the sufficient chirality projector.
- [`docs/GATE_C_ASSUMPTION_LEDGER.md`](docs/GATE_C_ASSUMPTION_LEDGER.md) - represented vs missing Gate C assumptions.
- [`docs/NEXT_THEOREMS.md`](docs/NEXT_THEOREMS.md) - exact next Lean targets by claim type.
- [`docs/ARISTOTLE_INTEGRATION_SLOTS.md`](docs/ARISTOTLE_INTEGRATION_SLOTS.md) - landing zones for active Aristotle jobs.
- [`docs/TRUST_AND_SCOPE.md`](docs/TRUST_AND_SCOPE.md) - trusted vs draft labels.
- [`docs/THEOREM_MAP.md`](docs/THEOREM_MAP.md) - theorem index by topic.
- [`docs/CONVENTIONS.md`](docs/CONVENTIONS.md) - null-edge conventions.
- [`docs/GATE_C.md`](docs/GATE_C.md) - Gate C status and claim boundaries.
- [`docs/PROVENANCE.md`](docs/PROVENANCE.md) - source modules and copied material.
