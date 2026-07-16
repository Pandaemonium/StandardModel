# Aristotle strategy/proof: Pluecker-HNU intertwiner

```yaml
aristotle:
  project_id: f0d38cd0-cdec-46ef-800b-b588e3e07740
  task_id: c9f31d7f-a8ae-4ade-9d36-e03b2db004a9
  target_file: PlueckerHNUIntertwiner.lean
  expected_module: PlueckerHNUIntertwiner
  status: submitted
```

## Purpose

The grand synthesis identified a real unification gap. The Pluecker modules
derive a rest operator `Bz` from null-spinor area, while the HNU module derives
the exact infrared Weyl generator of a depth-eight regulator. The manuscript
must not imply these are the same mass/dynamics object until an explicit bridge
is proved.

## Request

Read the uploaded live `PlueckerMassOperator`, `Pluecker3Plus1ComplexMass`,
`HNUExactCore`, and `HNUInfraredTangent` modules. Design and formalize the
strongest nonvacuous bridge currently possible.

1. Identify the exact source/target spaces, chirality gradings, Pauli basis,
   phase conventions, and time normalization.
2. State an explicit intertwiner or block-embedding theorem showing how `Bz`
   enters a massive extension of the HNU infrared generator.
3. Require the map to be constructed from displayed null-spinor/regulator data;
   an arbitrary chosen isomorphism or a hypothesis asserting equality is not a
   derivation.
4. Prove phase covariance and the zero-mass collinearity boundary are preserved.
5. Include an explicit nonzero rational/Gaussian-rational witness.
6. If the current HNU endpoint is strictly massless and no canonical massive
   extension is defined, return a sharp no-canonicity/missing-data theorem and
   the smallest additional local coin/update definition that would make the
   bridge testable.

Acceptance: theorem, finite counterexample, or sharpened missing axiom. Do not
rename an input mass as an emergent result. Do not claim many-step convergence,
physical mass selection, chirality isolation, or Standard Model dynamics. Add
standard-three guards to every finite theorem and finish with a semantic report
distinguishing imported definitions from derived structure.
## 2026-07-13 harvest and live integration

Task `c9f31d7f-a8ae-4ade-9d36-e03b2db004a9` returned a compiling bridge, but
the raw artifact duplicated the live HNU and Pluecker APIs and described its
rectangular intertwiner as forced.  The candidate was therefore not copied
wholesale.

Interactive Claude review returned `APPROVE-SUBSET` in
`AutonomousLab/reviews/CLAUDE_REVIEW_PlueckerHNUIntertwiner_2026-07-13.md`.
The accepted subset was ported through the live imports as
`PhysicsSM/Draft/NullEdge/PlueckerHNUIntertwiner.lean`.  A second independent
review of that exact file returned `APPROVE` in
`AutonomousLab/reviews/CLAUDE_REVIEW_PlueckerHNUIntertwiner_LIVE_2026-07-13.md`.

The integrated theorem package proves:

- the exact HNU endpoint tangent is `-i` times the upper-right Weyl kinetic
  block of the live massless four-component Dirac representation;
- one explicit matrix `W` intertwines the live four-component Pluecker mass
  with the live two-component Pluecker rest operator;
- the latter is the normalized `W`-compression of the former;
- no nonzero `2 x 2` matrix anticommutes with all three HNU Pauli velocities,
  so a single two-component Weyl point cannot carry this relativistic mass;
- the Gaussian-rational value `z = 3 + 4i` is a nonzero exact control with
  squared gap `25`.

The result is deliberately not called canonical, does not derive `z` from the
HNU endpoint, and omits the raw artifact's tautological phase-specialization
theorems.  Focused direct replay and targeted build pass.  Aggregate guard
replay was started after import wiring; its first run exceeded the local
three-minute command timeout without returning a Lean error and must be rerun
with a longer timeout before final handoff.

Successor task `82733834-727d-44b0-aea0-fca3042df1a5` now classifies every
matrix satisfying the two intertwining equations.  Its purpose is to decide
whether the bridge has a natural selector or a genuine normalized moduli space;
mere construction of a second example is not accepted as full classification.
