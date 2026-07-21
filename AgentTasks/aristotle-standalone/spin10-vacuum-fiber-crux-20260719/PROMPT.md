# Task: marked transitivity on the vacuum fiber (Selector step 3)

Project: Lean 4 (v4.28.0) + Mathlib. Package: nine landed modules + the
target. One included module (`Spin10AnnihilatorIncidence`) carries ONE
documented hole in an out-of-scope theorem - do NOT touch it; every other
included module is hole-free. Do not modify any included module; add
helpers in the target file only.

## Target

`PhysicsSM/Draft/Spin10VacuumFiberTransitivity.lean` - three theorems:

1. `inVacuumThreeFiber_of_stabilizer_smul` (warmup) - the `d = 3` fiber
   is invariant under the vacuum stabilizer. Compose the landed
   two-argument equivariance `annihilatorIntersectionDim_smul` with the
   stabilizer's exact vacuum fixing (`g.val.val vacuumSpinor =
   vacuumSpinor` is the membership predicate).
2. `fiber_transitivity_weakSpinor` (kernel sanity anchor) - the weak
   partner is reached trivially (`g = 1`, `c = 1` should close it).
3. `exists_vacuumStabilizer_smul_eq_scalar_weak` - **THE crux**: every
   member of the vacuum's `d = 3` fiber is carried to a nonzero multiple
   of `weakSpinor` by a vacuum-stabilizer element.

## Route notes for the crux

`InVacuumThreeFiber ψ` = purity + `dim(annihilator vacuumSpinor ⊓
annihilator ψ) = 3`. The vacuum's annihilator is spanned by the five
contraction directions (see `mem_annihilator_basisSpinor_iff` at `S = ∅`
in the incidence module). A `d = 3` partner shares a 3-dimensional space
of contractions with the vacuum: classically one chooses a basis adapted
to the intersection, uses vacuum-stabilizer elements (products of an even
number of Clifford units built from creation/contraction pairs that fix
the vacuum - check which landed `flipUnit` products stabilize the vacuum,
and note diagonal/scaling elements in the stabilizer) to rotate the
2-dimensional complement onto modes `{3, 4}`, then normalizes as in the
basis-orbit machinery (`exists_evenCliffordGroup_smul_basisSpinor`).
The classical fact is Witt-type extension: pairs at fixed relative
position form one orbit, so the point stabilizer is transitive on the
fiber. If the full crux resists, prove targets 1-2 plus the LARGEST
provable special case of 3 (e.g. `ψ` a scalar multiple of an even basis
monomial in the fiber) and report the precise remaining gap (<= 3
follow-up lemma statements).

A KERNEL COUNTEREXAMPLE to target 3 (a fiber member provably not reachable)
is a first-class outcome - report it prominently if found.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]) on
  everything you prove; do not route proofs through the one documented
  hole in the incidence module (its `sorryAx` must not leak into your
  targets - target 1 must use only the PROVEN equivariance theorems).
- Do not change the three target statements; the scalar form IS the
  intended statement (pre-registered).
- Verify with
  `lake env lean PhysicsSM/Draft/Spin10VacuumFiberTransitivity.lean`.

## Success criteria

All three proven with standard axioms = full success. Targets 1-2 +
special case + precise gap report = honest partial. Completion report:
convention choices, axioms per theorem, which stabilizer generators were
used.
