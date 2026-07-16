# Red-team report: GRAV-DPI-001

- Builder family: Claude, via the focused Aristotle package
- Skeptic/reproducer: Codex
- Returned project: `74503dba-277a-4579-8e76-4c03b481c6b1`
- Live artifact: `PhysicsSM/Draft/NullEdge/FiniteClassicalDPI.lean`
- Verdict: **finite classical theorem accepted; gravity interpretation withheld**

## Statement audit

The returned target statement is unchanged. For `T : n -> m -> Real`, the
push-forward is

```text
(T p) i = sum_j T i j p j,
```

and stochasticity is `sum_i T i j = 1` for each input `j`. This is a
**column-stochastic** convention. The standalone package called it
row-stochastic in prose, but its theorem and proof use the correct column sum.
The live module fixes the prose without changing the mathematics.

The theorem requires `p >= 0` and `q > 0` pointwise. Strict positivity of `q`
is the displayed support condition needed for the finite logarithmic formula.
The normalization hypotheses are explicit for the probability reading, though
the proof is stronger and does not use them.

## Nondegeneracy and boundary controls

- `identityTwo_relEntropy_eq` proves the equality boundary for the identity
  channel.
- `collapseTwoToOne_strict` proves strict contraction for a many-to-one channel
  acting on a point mass versus the uniform two-point distribution.

The strict control rules out a theorem that merely rewrites both sides to the
same expression. The identity control prevents overclaiming universal strictness.

## Scope boundary

This result is generic finite classical information theory. No theorem in the
artifact constructs a null-edge gravitational coarse-graining channel, maps
relative entropy to area or curvature, or derives a field equation. Therefore
the appropriate claim grade is `M` for classical DPI only. Any gravitational
use requires a separate work item with a physically derived channel and an
independent response-law theorem.

## Verification

- The downloaded Aristotle file replayed locally with the repository toolchain.
- `lake build PhysicsSM.Draft.NullEdge.FiniteClassicalDPI` passed 8,027 jobs.
- `lake build PhysicsSM.Draft.NullEdge.OvernightTheoryAxiomGuard` passed 8,381
  jobs with the standard `propext`, `Classical.choice`, and `Quot.sound`
  footprint pinned for the theorem and both controls.

No executable placeholder or compiler-trust shortcut occurs in the live module.
