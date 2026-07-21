# Task: the SM block-action homomorphism into the even Clifford group (S2 brick 1)

Project: Lean 4 (v4.28.0) + Mathlib. Spin(10) Selector chain, S2 section.
Self-contained package (21 modules). The S2 proof plan from the
predecessor audit is included as S2_PROOF_PLAN.md - its S2 section lists
the five sub-results; this job takes the first three.

## Target

`PhysicsSM/Draft/Spin10BlockHomomorphism.lean`:

1. `smBlockHom` (DEF, currently a hole) - construct the concrete monoid
   homomorphism `StandardModelGaugeGroup →* evenCliffordGroup`.
   `StandardModelGaugeGroup = SMBlockUnitsSubgroup` (block-unitary
   `2 ⊕ 3` matrices, in the included Gauge tree). Route guidance: a block
   unit acts on the five annihilator modes (colour `{0,1,2}`, weak
   `{3,4}`) as a `U(5)` element; the Fock action is the exterior-power
   action on `Finset (Fin 5) → ℂ`; land it inside `evenCliffordGroup`
   using the included Clifford group API (`scalarUnit_mem`, gamma-pair
   products, the `SpinorTenfoldSO10Action` infinitesimal layer as a
   guide). ANY construction is acceptable as long as it is a genuine
   `MonoidHom` and the image-fixing theorems below hold - record the
   construction choice prominently.
2. `smBlockHom_fixes_vacuum` - the image fixes `vacuumSpinor` (the empty
   subset is fixed by the exterior-power action of any block unit).
3. `smBlockHom_proj_fixes_weak` - the image fixes `weakSpinor`
   projectively (the weak spinor's subset is preserved up to the weak
   block's determinant scalar).
4. `smBlockHom_injective` (stretch) - with the honest central-kernel
   correction if the true kernel is a finite center (rename and state the
   corrected computation; do not force injectivity if false).

## Pre-registered honesty license

If the natural construction fixes the vacuum only up to a scalar, prove
the projective version and rename. If sub-result 3 fails as stated,
compute the kernel honestly. The DEF plus theorem 2 is already partial
success; report precisely at the first genuine obstruction with a
decomposition into <= 3 follow-up lemmas.

## Constraints

- Do not modify included modules. No new axioms/escapes; standard axioms
  only ([propext, Classical.choice, Quot.sound]).
- Verify with `lake env lean PhysicsSM/Draft/Spin10BlockHomomorphism.lean`.

## Success criteria

Def constructed + theorems 2-3 proven is full success for this brick;
each further sub-result is bonus. Completion report: construction chosen,
statement changes, remaining holes, axioms.
