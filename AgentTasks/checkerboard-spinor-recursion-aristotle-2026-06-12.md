# Aristotle task: checkerboard directed recursion package (wave 1, job 1)

Date: 2026-06-12

## Goal

Fill the 6 documented `sorry`s in

```text
PhysicsSM/Draft/CheckerboardSpinorRecursionAristotle.lean
```

on top of the trusted finite checkerboard module
`PhysicsSM/Spinor/Checkerboard.lean`:

```lean
histories_nodup            -- histories n has no duplicates
length_histories           -- |histories n| = 2^n
pathWeight_eq_pow_turnCount -- pathWeight mu d h = mu ^ turnCount d h
pathSum_last_step          -- last-step (detector-side) decomposition
pathSum_eq_iterate_evolve  -- path sum = n-fold iterate of one-step evolution
pathSum_klein_gordon       -- discrete Klein-Gordon / telegraph equation
```

## Mathematical intent

Items 1, 2, and 4 of the theorem sequence in
`Sources/Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md`
(program: `Sources/Luminal_Motion_Checkerboard_Research_Program.md`, WP1).
The last-step recursion is the discrete 1+1D Dirac equation; the
Klein-Gordon target is the finite exact form of the
Gaveau--Jacobson--Kac--Schulman telegraph correspondence.

All statements oracle-validated by brute force:
`Scripts/oracle/validate_checkerboard.py` (ALL OK, 2026-06-12).

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, no `native_decide`.
- Do not change definitions or statements. Helper lemmas welcome.

## Verification

```bash
lake env lean PhysicsSM/Draft/CheckerboardSpinorRecursionAristotle.lean
```

Axiom check on each finished theorem: only
`[propext, Classical.choice, Quot.sound]`.

## Submission

**Status**: COMPLETE, integrated 2026-06-12
**Job ID**: `1a408f17-bbfa-41f3-833f-3920e3291adb`
**Submitted**: 2026-06-12
**Submission project**: `AgentTasks/aristotle-submit/checkerboard-wave1-20260612-project`
**Output archive**: `AgentTasks/aristotle-output/checkerboard-spinor-recursion-20260612-correct`
**Selected extraction**: `AgentTasks/aristotle-output/picked-completed-20260612`

Integrated into:

```text
PhysicsSM/Draft/CheckerboardSpinorRecursionAristotle.lean
```

Verification run after integration:

```bash
lake build PhysicsSM.Draft.CheckerboardSpinorRecursionAristotle
```
