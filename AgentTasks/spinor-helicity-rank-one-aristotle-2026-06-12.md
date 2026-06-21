# Aristotle task: spinor-helicity rank-one factorization (wave 1, job 4)

Date: 2026-06-12

## Goal

Fill the 8 documented `sorry`s in

```text
PhysicsSM/Draft/SpinorHelicityRankOneAristotle.lean
```

(self-contained file; defines `minkHerm`, `rankOne`, `momentumOf`):

```lean
minkHerm_conjTranspose
det_minkHerm          -- det = Minkowski norm, signature (+,-,-,-)
trace_minkHerm        -- trace = 2 p0
minkHerm_injective
minkHerm_momentumOf   -- lambda lambda^dagger = sigma.(momentumOf lambda)
momentumOf_null
momentumOf_nonneg
minkHerm_rankOne_iff  -- CAPSTONE: null + future-pointing <-> rank-one factorization
```

## Mathematical intent

WP6a of `Sources/Luminal_Motion_Checkerboard_Research_Program.md`: the
`K = C`, `d = 4` case of the division-algebra spinor-helicity
correspondence (`Spin(d-1,1) = SL(2,K)`, null momentum = rank-one
Hermitian bispinor; cf. Baez--Huerta arXiv:1003.3436 Section 2,
clean-room formalization). Later waves: `K = H` (`d = 6`) and the
octonionic `d = 10` case connecting to `PhysicsSM.Spinor.SpinorTenfold*`.

Oracle checks of det/rank-one facts in
`Scripts/oracle/validate_checkerboard.py` (ALL OK, 2026-06-12).

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, no `native_decide`.
- Do not change definitions or statements. Helper lemmas welcome.
- Forward construction guidance (case split on `p 0 + p 3 = 0`) is in the
  module docstring and the submission prompt.

## Verification

```bash
lake env lean PhysicsSM/Draft/SpinorHelicityRankOneAristotle.lean
```

Axiom check on each finished theorem: only
`[propext, Classical.choice, Quot.sound]`.

## Submission

**Status**: COMPLETE, integrated 2026-06-12
**Job ID**: `3d60d672-06d8-4534-aa2f-5567f9355267`
**Submitted**: 2026-06-12
**Submission project**: `AgentTasks/aristotle-submit/checkerboard-wave1-20260612-project`
**Output archive**: `AgentTasks/aristotle-output/spinor-helicity-rank-one-20260612`
**Selected extraction**: `AgentTasks/aristotle-output/picked-completed-20260612`

Integrated into:

```text
PhysicsSM/Draft/SpinorHelicityRankOneAristotle.lean
```

Verification run after integration:

```bash
lake build PhysicsSM.Draft.SpinorHelicityRankOneAristotle
```
