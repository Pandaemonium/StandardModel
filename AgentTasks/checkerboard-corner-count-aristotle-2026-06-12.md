# Aristotle task: checkerboard corner-count binomial closed forms (wave 1, job 2)

Date: 2026-06-12

## Goal

Fill the 8 documented `sorry`s in

```text
PhysicsSM/Draft/CheckerboardCornerCountAristotle.lean
```

on top of the trusted `PhysicsSM/Spinor/Checkerboard.lean`:

```lean
endpoint_shift                       -- endpoint translation
pathWeight_eq_pow_turnCount          -- local restatement (self-contained file)
pathSum_eq_sum_turnHistories         -- kernel = polynomial in mu with count coefficients
length_turnHistories_flipAll         -- flip symmetry of the counts
length_turnHistories_even            -- |..., right->right, 2r corners| = C(p,r) C(q-1,r-1)
length_turnHistories_odd             -- |..., right->left, 2r+1 corners| = C(p,r) C(q-1,r)
length_turnHistories_zero            -- cornerless = straight line
length_turnHistories_right_right_odd -- parity vanishing
```

## Mathematical intent

Item 3 of the theorem sequence in
`Sources/Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md`
(program WP1b): the closed binomial formulas behind the discrete Bessel
kernel of the 1+1D Feynman checkerboard (Feynman--Hibbs Problem 2-6;
Skopenkov--Ustinov arXiv:2007.12879). The two binomial counts are the
hard/central targets; runs-and-compositions combinatorics, derived via
Pascal absorption of the two first-step subcases.

All closed forms oracle-validated by brute force for all `p + q <= 11`:
`Scripts/oracle/validate_checkerboard.py` (ALL OK, 2026-06-12). The
hypotheses `0 < q` (and `0 < r` in the even case) are genuinely needed.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, no `native_decide`.
- Do not change definitions or statements. Helper lemmas welcome.

## Verification

```bash
lake env lean PhysicsSM/Draft/CheckerboardCornerCountAristotle.lean
```

Axiom check on each finished theorem: only
`[propext, Classical.choice, Quot.sound]`.

## Submission

**Status**: COMPLETE, integrated 2026-06-20
**Project ID**: `75b04c5e-46f9-466e-8123-35fa14651da3`
**Task ID**: `edfab07a-efa1-4977-827d-a67cc2aed70b`
**Submitted**: 2026-06-12
**Submission project**: `AgentTasks/aristotle-submit/checkerboard-wave1-20260612-project`
**Output**: `AgentTasks/aristotle-output/75b04c5e-46f9-466e-8123-35fa14651da3/`
**Integrated file**: `PhysicsSM/Draft/CheckerboardCornerCountAristotle.lean`

Note: `AgentTasks/aristotle-output/checkerboard-corner-count-20260612` was
accidentally used during this integration pass for completed job
`3d60d672-06d8-4534-aa2f-5567f9355267` (spinor-helicity rank-one). Do not
treat that archive as the corner-count result.

Verification run after integration:

```bash
lake build PhysicsSM.Draft.CheckerboardCornerCountAristotle
```
