# Round 023 context: after P2 branch-reflection Mandelstam package

Date: 2026-06-24.

## Program gestalt

The constrained loop advances one high-value publication-worthy result per
round, using Codex as integrator. The strongest current lanes:

- `P1-F`: Plucker mass, observer-conditioned normalization, frame audit.
- `P2-R`: finite Dirac / branch-reflection / super-Dirac square-root bridge.
- `P4-R`: null-step quantum-walk/chirality dynamics.
- `P7-R`: observer channels and relative-entropy/proper-time readout.
- `P9-F`: source-visibility, screen/harmonic projection, and noise guardrails.

This round is deciding what to do after the P2 trace ladder has become much
stronger.

## Latest integrated P2 theorem state

Live module:

```text
PhysicsSM/Draft/NullEdgeP2TwoReflectionTrace.lean
```

Definitions:

```text
RMat2 := Matrix (Fin 2) (Fin 2) Real
chiralHamiltonian (h p m : Real) : RMat2
branchReflection (h p m E : Real) : RMat2
trace2 (M : RMat2) : Real
tracelessMat (a b c : Real) : RMat2
```

The trace ladder now includes:

```text
trace2_mul_two_branchReflections_formula
trace2_mul_two_branchReflections_symm
trace2_branchReflection_sq_eq_two_on_massShell
trace2_mul_three_branchReflections_eq_zero
trace2_mul_four_branchReflections_formula
trace2_four_diagWitness_eq_two
trace2_four_alternatingWitness_eq_neg_two
trace2_four_branchReflections_nonconstant
trace2_mul_four_traceless_mandelstam
branchReflection_eq_tracelessMat_coords
trace2_mul_tracelessMat_coords
trace2_mul_two_branchReflections_from_coords
trace2_mul_four_branchReflections_mandelstam_ordered
trace2_branchReflection_sq_eq_two_on_massShell_from_coords
```

Scientific meaning: in the real two-generator branch-reflection model, a
four-step trace is determined by pairwise two-traces. This is a no-independent
four-scalar guardrail, not a curvature theorem.

## Aristotle's latest recommendation

After proving the branch-reflection package, Aristotle recommended:

```text
Introduce a named geometric substitution map
oneDiamondSub : edge/branch data -> 4-tuple of (h,p,m,E) coordinates

Then prove a bridge lemma:
trace2_oneDiamond_eq_mandelstam_of_sub
```

The warning is that the geometry must live in the definition and properties of
the substitution map. We should not rename a generic four-trace as curvature.

## Decision needed

We need exactly one next Aristotle job. Possible directions:

1. `P2/P3 design job`: ask Aristotle to critique and scaffold the one-diamond
   substitution-map API, with no code required.
2. `P2 proof job`: stage a small abstract `DiamondBranchData` structure with
   four branch coordinates and prove the Mandelstam readout theorem for it.
3. `P9-F pivot`: return to source visibility/noise/harmonic projection, where
   the strongest open gate is a response law or intrinsic coarse map.
4. `P1/P7 pivot`: observer-channel/relative-entropy bridge, especially the
   link between dephasing/chirality coherence and normalized `m/E`.

Please recommend exactly one high-value next job. If it is a proof job, give a
concrete theorem statement shape. If it is a strategy/audit job, say why that
is more valuable than a proof right now and what exact output should be asked
from Aristotle.
