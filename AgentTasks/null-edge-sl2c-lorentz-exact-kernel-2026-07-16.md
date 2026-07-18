# Null-edge SL(2,C) Lorentz exact kernel

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Claim grade: `M [comp]` for the finite exact-kernel theorem only
Status: harvested, integrated, built, and independently approved

## Objective

Prove the remaining kernel-containment direction for the concrete
Pauli/Hermitian Lorentz action: a determinant-one two-by-two complex matrix
whose congruence action fixes every Hermitian Minkowski vector must be `+I` or
`-I`.

Together with the already-proved central-sign inclusion, this establishes the
exact kernel `{+I,-I}`.  Properness was proved independently; neither result
proves surjectivity onto `SO^+(1,3)`.

## Focused proof target

- Source:
  `AgentTasks/aristotle-standalone/null-edge-sl2c-lorentz-action-20260716/SL2CLorentzKernel/Core.lean`
- Context pack:
  `AgentTasks/context-packs/sl2c-lorentz-exact-kernel-20260716-20260716-141602.md`
- Exact theorem:
  `hermitianCongruence_kernel`.
- Hypothesis: `A` fixes `pauliLift p` by congruence for every real Minkowski
  four-vector `p`.
- Conclusion: `A = 1` or `A = -(1 : SL2C)`.

The submitted focused source imported only Mathlib and typechecked with one
proof handoff marker. Aristotle returned a complete proof, which passes under
the pinned toolchain without a proof handoff marker.

## Aristotle

```yaml
aristotle:
  project_id: e21233fd-7d64-4c33-acf7-a2783f7b9e9b
  task_id: b73651ae-20a4-4c16-a4da-1da4fc594334
  target_file: PhysicsSM/Draft/NullEdge/SL2CLorentzAction.lean
  expected_module: PhysicsSM.Draft.NullEdge.SL2CLorentzAction
  submission_project: AgentTasks/aristotle-submit/null-edge-sl2c-lorentz-exact-kernel-20260716-project
  output_dir: AgentTasks/aristotle-output/e21233fd-7d64-4c33-acf7-a2783f7b9e9b
  status: harvested_and_integrated
```

## Production bridge

1. Assume `sl2ToEtaLorentz A = 1`.
2. Recover `sl2LorentzMatrix A = 1` from equality of the bundled eta-Lorentz
   elements.
3. Use `sl2LorentzMatrix_mulVec` to prove `sl2LorentzLinear A p = p` for every
   Minkowski vector.
4. Use `pauli_sl2LorentzLinear` to prove Hermitian congruence fixes every
   `pauliHermitianEquiv p`.
5. Apply the focused finite theorem and identify `-(1 : SL2C)` with the
   production `minusIdentity`.
6. Conclude `concreteHasExactCentralKernel` in
   `LorentzAtlasSpinLiftBoundary.lean`.

Every step is kernel-checked after integration. The focused Pauli lift was
matched to `pauliHermitianEquiv` before the proof was promoted.

## Semantic review checklist

- Preserve Mathlib's bundled determinant-one group `SL(2, Complex)`.
- Preserve the mostly-minus Pauli convention.
- Preserve congruence order `A * X * A^dagger`.
- Do not replace fixation of every Pauli/Hermitian vector by a weaker scalar
  or determinant condition.
- Do not add connectedness, continuity, or unproved spectral assumptions.
- Do not claim surjectivity or properness from the kernel theorem.

## Verification

- `lake env lean AgentTasks/aristotle-standalone/null-edge-sl2c-lorentz-action-20260716/SL2CLorentzKernel/Core.lean`
  passed with exactly the expected target handoff warning.
- Aristotle project `e21233fd-7d64-4c33-acf7-a2783f7b9e9b`, task
  `b73651ae-20a4-4c16-a4da-1da4fc594334`, was submitted from the focused
  package on 2026-07-16 and registered in the autonomous lab.
- Aristotle returned a complete proof with the submitted theorem unchanged.
  The extracted source passes directly under the pinned repository toolchain.
- The proof is integrated as `hermitianLorentzAction_kernel`, with the
  production capstones `sl2ToEtaLorentz_eq_one_iff` and
  `sl2ToRestrictedLorentz_eq_one_iff`.
- `lake env lean PhysicsSM/Draft/NullEdge/SL2CLorentzAction.lean` passed cleanly
  after integration.
- The dependent 8056-job `LorentzAtlasSpinLiftBoundary` build passed, replaying
  only pre-existing warnings from two imported modules.

## Remaining gates

1. Prove surjectivity onto `SO^+(1,3)`.
2. Derive graph-selected restricted Lorentz transitions and local lifts rather
   than supplying them.

## Independent semantic review

Claude independently checked the concrete Schur step, determinant reduction to
`c^2 = 1`, both directions of `sl2ToEtaLorentz_eq_one_iff`, and transfer to the
restricted subgroup. Verdict: **APPROVED**, with no hidden assumptions and no
surjectivity claim.

Review artifact:
`AutonomousLab/reviews/CLAUDE_REVIEW_SL2C_EXACT_KERNEL_2026-07-16.md`.
