# Aristotle task: Spin(10) Lie Algebra Stabilizers & Selector Theorem

Date: 2026-06-12

## Goal

Fill the `sorry`s in

```text
PhysicsSM/Draft/Spin10StabilizerLieAlgebra.lean
```

proving:

- `hypercharge_in_mixed_stabilizer`: Hypercharge generator `hyperchargeOp` stabilizes the vacuum spinor nonprojectively and the weak spinor projectively.
- `vacuum_eigenvalue_zero`: Mixed pair stabilizer bivectors act on the vacuum with eigenvalue 0.
- `standard_stabilizer_isomorphic_to_sm_lie_algebra`: The mixed pair stabilizer algebra contains a Lie subalgebra isomorphic to `su(3) ⊕ su(2) ⊕ u(1)`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide`.
- Do not change definitions or sign conventions. Helper lemmas welcome.

## Verification

```bash
lake env lean PhysicsSM/Draft/Spin10StabilizerLieAlgebra.lean
```

Axiom check on each finished theorem: only `[propext, Classical.choice, Quot.sound]`.

## Submission

**Status**: integrated
**Job ID**: `08ce0a09-de99-489f-bba6-90bbda91d3a2`
**Submitted**: 2026-06-12
**Submission project**: `AgentTasks/aristotle-submit/wave7-20260612-project`
**Output**: `AgentTasks/aristotle-output/spin10-lie-stabilizer-20260612/`
