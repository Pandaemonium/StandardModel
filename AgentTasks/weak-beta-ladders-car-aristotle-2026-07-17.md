<!--
aristotle_job:
  slug: weak-beta-ladders-car-20260717
  project_id: 2f3fd545-2200-4a5d-a90a-61ac3bd1fb52
  submitted_at: 2026-07-17
  status: submitted
  target_file: PhysicsSM/Draft/NullEdge/WeakBetaLaddersFromColor.lean
  check_path: PhysicsSM/Draft/NullEdge/WeakBetaLaddersFromColor.lean
  expected_module: PhysicsSM.Draft.NullEdge.WeakBetaLaddersFromColor
  grade_target: "M [orig formalization; comp Furey 1806.00612 eq 29-31]"
  model: claude
  work_item: GRAV-ORDER-OPERATOR-001
-->

# Aristotle task: the weak beta-ladder CAR relations (item 2, Furey eq 31)

## Narrow build (FIRST)

```
lake build PhysicsSM.Draft.NullEdge.WeakBetaLaddersFromColor
```

Deps: the Furey + Octonion finite-algebra subtree + Mathlib. Do NOT build the
whole repo.

## Context (faithful, from the actual Furey 1806.00612 PDF)

The DEFINITIONS are DONE in `PhysicsSM/Draft/NullEdge/WeakBetaLaddersFromColor.lean`:
`omega = a_1 a_2 a_3`, `omegaDag`, `tau_1,tau_2,tau_3` (eq 29), and the weak
ladders `beta_1 = (1/2)(-e_2 + i e_1 tau_1)`, `beta_2 = omegaDag i e_1` (eq 30),
all as concrete `ComplexOctonion` elements built from the repo's `alpha_i`
(`LadderOperators`). Convention pinned: Furey `e_1 = e001 = c1`, `e_2 = e010 = c2`.

## Goal

Prove the Cl(4) CAR relations of eq 31 for these ladders (the `s o r r y` in
`beta_cars` and its companions you should add):

```
{beta_i, beta_j}   = 0      (like-anticommutation, incl. nilpotency beta_i^2 = 0)
{beta_i, beta_j‡}  = delta_ij  (mixed anticommutation gives the identity)
```

where the dagger `‡` maps `i -> -i`, `e_k -> -e_k` (all octonion units), and
REVERSES multiplication order (the C*-involution; see `LadderOperators` for the
`alpha_i_dag` pattern). Steps:

1. Define `beta_1‡, beta_2‡` (apply `‡` to the eq-30 forms; note `tau_j‡` and
   `e_k‡ = -e_k`).
2. Prove the CAR. These are FINITE octonion-coordinate computations: `ComplexOctonion`
   has `@[simp]` `mul_re/mul_im/add_re/...`; expand to `Octonion` coords via
   `Octonion.mul_c0..c7` and close with `ring`/`norm_num` (heavy - use
   `set_option maxHeartbeats`).
3. IMPORTANT: the eq-30 parenthesization `i e_1 tau_1` and the exact `beta`
   normalizations may need minor adjustment to satisfy the CAR exactly (octonion
   non-associativity + the XOR convention). If so, adjust `beta_1`/`beta_2`
   minimally to a genuine eq-30 form and NOTE the change - do not force a
   false-shape identity.

## Pre-registered kill

If the element-level CAR provably fails (e.g. it holds only for the LEFT-action
OPERATORS `L_beta`, not the raw `ComplexOctonion` products), STOP and report:
which relation fails, and whether the operator-level CAR holds instead. That is a
valuable structural finding (it tells us the weak ladders act by left/right
multiplication, not element product).

## Success

`lake build PhysicsSM.Draft.NullEdge.WeakBetaLaddersFromColor` with no `s o r r y`.
