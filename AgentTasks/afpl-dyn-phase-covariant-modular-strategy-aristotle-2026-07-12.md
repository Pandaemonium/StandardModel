# Aristotle strategy job: phase-covariant modular selection

## Context

`DYNModularMaxEntCapstone` proves unique fixed-energy Gibbs selection and the
actual modular-flow equality for the canonical real transfer `Bz 1`. The
Pluecker rest operator is generally `Bz z`, where the complex phase is an
oriented-area datum. The accepted capstone explicitly does not claim that its
selected flow sees this general phase.

## Task

Design the exact phase-covariant successor without hiding the phase in a basis
choice. Read all canonical rest, pair-generator, Gibbs, and full-Fock modules.

Required output:

1. Define an explicit diagonal phase unitary for `z != 0` and prove the exact
   conjugation relation between `Bz z` and `|z| * Bz 1`, including orientation
   and square-root/half-phase issues.
2. Derive Gibbs-state and modular-flow covariance under that unitary, with
   inverse temperature and scale factors explicit.
3. State an arbitrary-density fixed-expectation max-entropy theorem for the
   normalized observable `Bz z / |z|` or explain why a different normalization
   is required.
4. Separate gauge-removable constant phase from operational phase differences
   across links, histories, or the canonical full-Fock `Uop` witness.
5. Provide exact Lean theorem skeletons and a `z = 0` boundary control.

Do not claim the single-site spectrum observes phase, do not divide by `|z|`
without a nonzero hypothesis, and do not identify a basis covariance theorem
with a spatial gauge field. Write `AFPL_DYN_PHASE_COVARIANT_STRATEGY.md`.

## Primary files

- `PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean`
- `PhysicsSM/Draft/NullEdge/PairModularSelection.lean`
- `PhysicsSM/Draft/NullEdge/DYNModularMaxEntCapstone.lean`
- `PhysicsSM/Draft/NullEdge/CanonicalFullFockPairExponential.lean`

Success is a convention-locked theorem ladder ready for proof or a precise
obstruction showing which phase claim is merely coordinate covariance.

## Submission metadata

- Aristotle project: `f3898781-139b-4f5f-b8ac-06a464352f0c`
- Submission project: `AgentTasks/aristotle-submit/dyn-phase-covariant-20260712-project`
- Lab work item: `DYN-MODULAR-001`
- Status: integrated 2026-07-13 by Codex after cross-family audit

## Harvest

Aristotle returned a placeholder-free theorem ladder in
`PhaseCovariantModularSelection.lean`. Codex replayed the file against the live
pinned repository, promoted only that new module, and tightened the prose so
that the relative-phase bilinear is called invariant rather than operational.
The separate `Uop` inequality remains the operational witness. The returned
copies of `GeneralMaxEntropy`, the aggregate guard, and `PhysicsSMDraft` were
stale and were not copied.

Verification:

- `lake env lean PhysicsSM/Draft/NullEdge/PhaseCovariantModularSelection.lean`
- `lake build PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection`

Independent Claude review `msg-20260713-031429-c07cb08a`: ACCEPT. It confirmed
the conjugation orientation, `beta * norm(z)` rescaling, zero boundary,
half-phase scope, and invariant-versus-operational phase separation.
