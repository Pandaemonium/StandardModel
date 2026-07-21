# Task: the exterior-power action on the Fock model (S2 prerequisites 1-2)

Project: Lean 4 (v4.28.0) + Mathlib. Spin(10) Selector chain. Tiny
three-file package (the trusted Fock/purity layer + target). The
predecessor S2 audit decomposed the block-homomorphism problem into three
prerequisites; this job is the first two - and per this run's discipline,
NONVACUITY IS A MANDATORY TARGET, not a stretch.

## Target

`PhysicsSM/Draft/Spin10FockExteriorAction.lean` - six theorems ending in
a hole:

1. `extAction_one` - identity compound acts as identity (the minor of the
   identity on `S, T` is `δ_{S,T}`).
2. `extAction_mul` - **Cauchy-Binet functoriality (the crux)**: the
   compound of a product is the product of compounds. Mathlib's
   `Matrix.det_mul` generalization for minors / Cauchy-Binet
   (`Matrix.det_mul_of...`/compound identities) may help; a direct proof
   sums over intermediate column sets. This is the mathematically real
   content - budget accordingly.
3. `extAction_vacuum` - the empty minor is `1`, all other row-∅ entries
   vanish.
4. `extAction_diagPhase3_weak` - MANDATORY nonvacuity: the phase-3
   diagonal unit multiplies the `{3,4}` weak spinor by exactly `c`
   (diagonal minors are products of diagonal entries over the set).
5. `extAction_diagPhase3_control` - the same unit FIXES the pure-colour
   `{0,1}` spinor - the action distinguishes weak content.

## Success gating (pre-registered, strict)

Targets 4-5 (the nonvacuity payloads) are REQUIRED for any success claim;
a return proving only the algebra without them is a partial at best.
If a sign convention in the ordered-minor definition must be fixed for
multiplicativity, fix it ONCE in `compoundEntry`, record prominently, and
keep the payloads exact.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Do not modify the two trusted included modules.
- Verify with `lake env lean PhysicsSM/Draft/Spin10FockExteriorAction.lean`.

## Success criteria

All six proven with the nonvacuity payloads intact = full success;
Cauchy-Binet resisting -> prove 1, 3, 4, 5 + a precise decomposition
report for 2. Completion report: convention choices, axioms.

## RESTART ADDENDUM (2026-07-19 08:20)

The target file now carries the FIRST HARVEST: `extAction_one`,
`compoundEntry_diagonal`, `extAction_basisSpinor`, and BOTH nonvacuity
payloads are already PROVEN - do not re-prove or modify them. EXACTLY TWO
holes remain and are the entire job: `extAction_mul` (Cauchy-Binet, the
crux - the telescoping route in the file docstring stands) and
`extAction_vacuum` (easy: row-`∅` compound entries vanish except `T = ∅`).
All other instructions unchanged.
