import Mathlib
import PhysicsSM.Algebra.Furey.OctonionMassCoupling

/-!
# Algebra.Furey.OctonionMassCouplingFaithful

**Closing the faithfulness gap.** The module `OctonionMassCoupling` proves a
mass/color *coupling* using hand-written `3 × 3` complex matrices
`H23m/H13m/T12m..T31m` that *reconstruct* the color-triplet action table. The
companion module `ColorTripletFundamental` *proves* that same action table for the
genuine octonionic color action on the triplet `{v4, v5, v6}` (a minimal left
ideal inside the complex octonions), using the operators
`H23_op, H13_op, T12_op, …, T32_op` built from octonion left-multiplication.

This file makes the by-construction faithfulness explicit: it shows that the
hand-written matrices ARE the matrix representations, on the ordered triplet basis
`(v4, v5, v6)`, of the genuine octonionic color-action operators, and then
RE-DERIVES the headline coupling theorem (the mass grading is not central /
transforms covariantly) as a statement about the *actual* octonionic action, not
merely about the reconstructed matrices.

## Why the action is taken as a hypothesis bundle

`ColorTripletFundamental` imports `PhysicsSM.Algebra.Furey.ColorRepresentation`
and `…OperatorAlgebra`, i.e. the upstream octonion stack that builds the operators
`H23_op, …, T32_op` and proves the action-table lemmas
(`H23_op_v4`, `H23_op_v5`, …, `T32_op_v6`). That stack is **absent from this
package**, so `ColorTripletFundamental.lean` does not build here (`unknown module
prefix 'PhysicsSM'`).

We therefore package **exactly the action-table lemmas we rely on** as the fields
of `ColorAction`. Each field is verbatim one of the octonionic identities proved
in `ColorTripletFundamental`/`OperatorAlgebra` (with the Cartan values read off
from `cartanEigen_v4/5/6` and the ladder values from `ladder_invariant`):

| structure field | octonionic identity it encodes |
|---|---|
| `H23_v4 : H23 v4 = -v4` | `H23_op v4 = (-1) • v4` (weight `w4.1 = -1`) |
| `H23_v5 : H23 v5 =  v5` | `H23_op v5 = ( 1) • v5` (weight `w5.1 =  1`) |
| `H23_v6 : H23 v6 =  0`  | `H23_op v6 = ( 0) • v6` (weight `w6.1 =  0`) |
| `H13_v4 : H13 v4 = -v4` | `H13_op v4 = (-1) • v4` (weight `w4.2 = -1`) |
| `H13_v5 : H13 v5 =  0`  | `H13_op v5 = ( 0) • v5` (weight `w5.2 =  0`) |
| `H13_v6 : H13 v6 =  v6` | `H13_op v6 = ( 1) • v6` (weight `w6.2 =  1`) |
| `T23_v5 : T23 v5 =  v4` | `T23_op v5 = v4` |
| `T32_v4 : T32 v4 =  v5` | `T32_op v4 = v5` |
| `T12_v6 : T12 v6 =  v5` | `T12_op v6 = v5` |
| `T21_v5 : T21 v5 =  v6` | `T21_op v5 = v6` |
| `T13_v6 : T13 v6 = -v4` | `T13_op v6 = -v4` |
| `T31_v4 : T31 v4 = -v6` | `T31_op v4 = -v6` |
| all other `T·· v· = 0`  | the vanishing ladder actions of the table |

plus `indep : LinearIndependent ℂ ![v4, v5, v6]` — the three triplet states are a
basis of their span (they are distinct Cartan weight vectors, so this holds in the
octonionic model). If/when the upstream stack is present, one instantiates
`ColorAction` with `v4,v5,v6 := ComplexOctonion.v4,v5,v6`,
`H23 := H23_op, …` and discharges each field by the corresponding proven lemma.

That the bundle is **consistent (not vacuous)** is witnessed here by
`stdColorAction`, a concrete `ColorAction (Fin 3 → ℂ)`.

## What is proved

* `faithful_H23, …, faithful_T31` (**faithfulness, headline**): each hand-written
  matrix is the matrix representation of the corresponding octonionic operator on
  the triplet basis, i.e. `IsMatrixRep C H23m C.H23`, etc.
* `IsMatrixRep_comp`, `IsMatrixRep.unique`: the representation is a
  multiplicative, faithful (injective) intertwiner — the bridge that transports
  matrix identities to operator identities and back.
* `octonionic_mass_not_central` (**coupling headline, actual action**): for the
  genuine octonionic ladder `C.T23` and any mass grading `massOp` faithfully
  represented by `massM m0 m1 m2`, if `m0 ≠ m1` then
  `massOp ∘ₗ C.T23 ≠ C.T23 ∘ₗ massOp`. Proof routes through the matrix theorem
  `mass_not_central_of_split` of `OctonionMassCoupling` via the faithfulness
  bridge.
* `octonionic_mass_coupling_on_v5`, `octonionic_mass_covariant`: the commutator of
  the octonionic ladder with the mass grading lands on the corresponding root
  vector with the mass splitting `m1 - m0` as coefficient — SU(3)-covariant, not
  invariant.
* `stdColorAction_mass_not_central`: the concrete corollary on `Fin 3 → ℂ`.

## Axiom footprint

Only Lean/Mathlib standard axioms (`propext`, `Classical.choice`, `Quot.sound`).
No `sorry`, no `axiom`, no `native_decide`. See the `#print axioms` block at the
end.
-/

namespace PhysicsSM.Algebra.Furey.OctonionMassCouplingFaithful

open Matrix
open PhysicsSM.Algebra.Furey.OctonionMassCoupling

/-- The genuine octonionic color action on the triplet, packaged as exactly the
action-table lemmas of `ColorTripletFundamental`/`OperatorAlgebra`. `V` is the
ambient complex vector space (the complex octonions in the intended model); the
operators are the octonionic color generators built from left-multiplication. -/
structure ColorAction (V : Type*) [AddCommGroup V] [Module ℂ V] where
  /-- Triplet state `v4`. -/
  v4 : V
  /-- Triplet state `v5`. -/
  v5 : V
  /-- Triplet state `v6`. -/
  v6 : V
  /-- The three triplet states form a basis of their span. -/
  indep : LinearIndependent ℂ ![v4, v5, v6]
  /-- The two color Cartan generators and the six color ladders. -/
  H23 : V →ₗ[ℂ] V
  H13 : V →ₗ[ℂ] V
  T12 : V →ₗ[ℂ] V
  T21 : V →ₗ[ℂ] V
  T13 : V →ₗ[ℂ] V
  T31 : V →ₗ[ℂ] V
  T23 : V →ₗ[ℂ] V
  T32 : V →ₗ[ℂ] V
  H23_v4 : H23 v4 = -v4
  H23_v5 : H23 v5 = v5
  H23_v6 : H23 v6 = 0
  H13_v4 : H13 v4 = -v4
  H13_v5 : H13 v5 = 0
  H13_v6 : H13 v6 = v6
  T23_v4 : T23 v4 = 0
  T23_v5 : T23 v5 = v4
  T23_v6 : T23 v6 = 0
  T32_v4 : T32 v4 = v5
  T32_v5 : T32 v5 = 0
  T32_v6 : T32 v6 = 0
  T12_v4 : T12 v4 = 0
  T12_v5 : T12 v5 = 0
  T12_v6 : T12 v6 = v5
  T21_v4 : T21 v4 = 0
  T21_v5 : T21 v5 = v6
  T21_v6 : T21 v6 = 0
  T13_v4 : T13 v4 = 0
  T13_v5 : T13 v5 = 0
  T13_v6 : T13 v6 = -v4
  T31_v4 : T31 v4 = -v6
  T31_v5 : T31 v5 = 0
  T31_v6 : T31 v6 = 0

variable {V : Type*} [AddCommGroup V] [Module ℂ V]

/-- The ordered triplet basis `(v4, v5, v6) ↔ (e0, e1, e2)`. -/
def ColorAction.vb (C : ColorAction V) : Fin 3 → V := ![C.v4, C.v5, C.v6]

@[simp] theorem ColorAction.vb_zero (C : ColorAction V) : C.vb 0 = C.v4 := rfl
@[simp] theorem ColorAction.vb_one (C : ColorAction V) : C.vb 1 = C.v5 := rfl
@[simp] theorem ColorAction.vb_two (C : ColorAction V) : C.vb 2 = C.v6 := rfl

/-- `M` is the matrix representation of the operator `O` on the triplet basis:
column `j` of `M` gives the expansion of `O (v_j)` in the basis. Since the
elementary matrix `E_{i,j}` sends `e_j ↦ e_i`, this is `O v_j = ∑ i, M i j • v_i`,
matching the `mulVec` convention of `OctonionMassCoupling`. -/
def IsMatrixRep (C : ColorAction V) (M : Matrix (Fin 3) (Fin 3) ℂ)
    (O : V →ₗ[ℂ] V) : Prop :=
  ∀ j : Fin 3, O (C.vb j) = ∑ i, M i j • C.vb i

/-! ## Faithfulness: the hand-written matrices represent the octonionic operators. -/

theorem faithful_H23 (C : ColorAction V) : IsMatrixRep C H23m C.H23 := by
  intro j
  fin_cases j <;>
    simp [H23m, Fin.sum_univ_three, C.H23_v4, C.H23_v5, C.H23_v6]

theorem faithful_H13 (C : ColorAction V) : IsMatrixRep C H13m C.H13 := by
  intro j
  fin_cases j <;>
    simp [H13m, Fin.sum_univ_three, C.H13_v4, C.H13_v5, C.H13_v6]

theorem faithful_T23 (C : ColorAction V) : IsMatrixRep C T23m C.T23 := by
  intro j
  fin_cases j <;>
    simp [T23m, Fin.sum_univ_three, C.T23_v4, C.T23_v5, C.T23_v6]

theorem faithful_T32 (C : ColorAction V) : IsMatrixRep C T32m C.T32 := by
  intro j
  fin_cases j <;>
    simp [T32m, Fin.sum_univ_three, C.T32_v4, C.T32_v5, C.T32_v6]

theorem faithful_T12 (C : ColorAction V) : IsMatrixRep C T12m C.T12 := by
  intro j
  fin_cases j <;>
    simp [T12m, Fin.sum_univ_three, C.T12_v4, C.T12_v5, C.T12_v6]

theorem faithful_T21 (C : ColorAction V) : IsMatrixRep C T21m C.T21 := by
  intro j
  fin_cases j <;>
    simp [T21m, Fin.sum_univ_three, C.T21_v4, C.T21_v5, C.T21_v6]

theorem faithful_T13 (C : ColorAction V) : IsMatrixRep C T13m C.T13 := by
  intro j
  fin_cases j <;>
    simp [T13m, Fin.sum_univ_three, C.T13_v4, C.T13_v5, C.T13_v6]

theorem faithful_T31 (C : ColorAction V) : IsMatrixRep C T31m C.T31 := by
  intro j
  fin_cases j <;>
    simp [T31m, Fin.sum_univ_three, C.T31_v4, C.T31_v5, C.T31_v6]

/-! ## The representation is a faithful (injective) algebra intertwiner. -/

/-- Composition of operators corresponds to the matrix product. -/
theorem IsMatrixRep_comp (C : ColorAction V) {A B : Matrix (Fin 3) (Fin 3) ℂ}
    {OA OB : V →ₗ[ℂ] V} (hA : IsMatrixRep C A OA) (hB : IsMatrixRep C B OB) :
    IsMatrixRep C (A * B) (OA ∘ₗ OB) := by
  intro j
  simp only [Matrix.mul_apply, Finset.sum_smul]
  rw [LinearMap.comp_apply, hB j, map_sum, Finset.sum_congr rfl fun i _ => map_smul _ _ _]
  rw [Finset.sum_comm, Finset.sum_congr rfl]
  intros
  rw [hA]
  simp +decide [mul_comm, Finset.smul_sum, smul_smul]

/-- The representation is faithful: a matrix is determined by the operator it
represents (uses that the triplet basis is linearly independent). -/
theorem IsMatrixRep.unique (C : ColorAction V) {M M' : Matrix (Fin 3) (Fin 3) ℂ}
    {O : V →ₗ[ℂ] V} (hM : IsMatrixRep C M O) (hM' : IsMatrixRep C M' O) :
    M = M' := by
  -- By definition of matrix multiplication and linearity, we can equate the two expressions for O (C.vb j).
  have h_eq : ∀ j : Fin 3, (∑ i : Fin 3, M i j • C.vb i) = (∑ i : Fin 3, M' i j • C.vb i) := by
    exact fun j => hM j ▸ hM' j ▸ rfl;
  have h_lin_ind : LinearIndependent ℂ C.vb := by
    convert C.indep;
  exact Matrix.ext fun i j => by simpa [ sub_eq_zero ] using Fintype.linearIndependent_iff.mp h_lin_ind ( fun k => M k j - M' k j ) ( by simp +decide [ sub_smul, Finset.sum_sub_distrib, h_eq ] ) i;

/-
Diagonal action of a faithfully represented mass grading on the triplet.
-/
theorem massOp_apply (C : ColorAction V) {m0 m1 m2 : ℂ} {massOp : V →ₗ[ℂ] V}
    (h : IsMatrixRep C (massM m0 m1 m2) massOp) :
    massOp C.v4 = m0 • C.v4 ∧ massOp C.v5 = m1 • C.v5 ∧ massOp C.v6 = m2 • C.v6 := by
  have := h 0; have := h 1; have := h 2; simp_all +decide [ Fin.sum_univ_three, massM ] ;

/-! ## Re-derived coupling: statements about the ACTUAL octonionic color action. -/

/-- **Coupling headline (actual octonionic action).** For the genuine octonionic
color ladder `C.T23` and any mass grading `massOp` faithfully represented by the
matrix `massM m0 m1 m2`, non-degeneracy `m0 ≠ m1` forces the mass grading to fail
to commute with the color ladder: it is not central w.r.t. the octonionic color
action. The proof transports the matrix inequality `mass_not_central_of_split`
across the faithfulness bridge. -/
theorem octonionic_mass_not_central (C : ColorAction V) {m0 m1 m2 : ℂ}
    {massOp : V →ₗ[ℂ] V} (hmass : IsMatrixRep C (massM m0 m1 m2) massOp)
    (h : m0 ≠ m1) :
    massOp ∘ₗ C.T23 ≠ C.T23 ∘ₗ massOp := by
  intro hcomm
  have h1 : IsMatrixRep C (massM m0 m1 m2 * T23m) (massOp ∘ₗ C.T23) :=
    IsMatrixRep_comp C hmass (faithful_T23 C)
  have h2 : IsMatrixRep C (T23m * massM m0 m1 m2) (C.T23 ∘ₗ massOp) :=
    IsMatrixRep_comp C (faithful_T23 C) hmass
  rw [hcomm] at h1
  exact mass_not_central_of_split h (IsMatrixRep.unique C h1 h2)

/-
**Covariance witness (actual octonionic action).** The commutator of the
octonionic ladder with the mass grading, evaluated on the root vector `v5`, equals
the mass splitting `(m1 - m0)` times the target root vector `v4`. Non-zero exactly
when the grading is non-degenerate.
-/
theorem octonionic_mass_coupling_on_v5 (C : ColorAction V) {m0 m1 m2 : ℂ}
    {massOp : V →ₗ[ℂ] V} (hmass : IsMatrixRep C (massM m0 m1 m2) massOp) :
    C.T23 (massOp C.v5) - massOp (C.T23 C.v5) = (m1 - m0) • C.v4 := by
  simp +decide [ sub_smul, C.T23_v5, massOp_apply C hmass ]

/-
**Covariance (actual octonionic action, basis form).** On every triplet basis
vector, `⁅T23, massOp⁆ = (m1 - m0) • T23` — the mass grading transforms as a
definite tensor (covariant), landing on the corresponding root generator with the
mass splitting as coefficient.
-/
theorem octonionic_mass_covariant (C : ColorAction V) {m0 m1 m2 : ℂ}
    {massOp : V →ₗ[ℂ] V} (hmass : IsMatrixRep C (massM m0 m1 m2) massOp) :
    ∀ j : Fin 3,
      (C.T23 ∘ₗ massOp - massOp ∘ₗ C.T23) (C.vb j) = (m1 - m0) • C.T23 (C.vb j) := by
  intro j
  fin_cases j <;> simp [massOp_apply C hmass, ColorAction.vb_zero, ColorAction.vb_one, ColorAction.vb_two];
  · simp +decide [ C.T23_v4 ];
  · have := massOp_apply C hmass; simp_all +decide [ sub_smul ] ;
    rw [ C.T23_v5, this.1 ];
  · simp +decide [ C.T23_v6 ]

/-! ## Non-vacuity: a concrete `ColorAction` on `Fin 3 → ℂ`.

Instantiating the operators as `Matrix.mulVecLin` of the hand-written matrices and
the triplet states as the standard basis exhibits the hypothesis bundle as
consistent, so all the theorems above are non-vacuous. -/

/-- The standard basis vector `e i` of `Fin 3 → ℂ`. -/
noncomputable def e (i : Fin 3) : Fin 3 → ℂ := Pi.single i 1

/-- A concrete color action on `Fin 3 → ℂ`, with the octonionic operators realized
as multiplication by the hand-written matrices and the triplet basis realized as
the standard basis. Witnesses that `ColorAction` is inhabited. -/
noncomputable def stdColorAction : ColorAction (Fin 3 → ℂ) where
  v4 := e 0
  v5 := e 1
  v6 := e 2
  indep := by
    have hb : (![e 0, e 1, e 2] : Fin 3 → (Fin 3 → ℂ)) = Pi.basisFun ℂ (Fin 3) := by
      funext i j; fin_cases i <;> simp [e, Pi.basisFun_apply]
    rw [hb]; exact (Pi.basisFun ℂ (Fin 3)).linearIndependent
  H23 := Matrix.mulVecLin H23m
  H13 := Matrix.mulVecLin H13m
  T12 := Matrix.mulVecLin T12m
  T21 := Matrix.mulVecLin T21m
  T13 := Matrix.mulVecLin T13m
  T31 := Matrix.mulVecLin T31m
  T23 := Matrix.mulVecLin T23m
  T32 := Matrix.mulVecLin T32m
  H23_v4 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, H23m, e, Fin.sum_univ_three]
  H23_v5 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, H23m, e, Fin.sum_univ_three]
  H23_v6 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, H23m, e, Fin.sum_univ_three]
  H13_v4 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, H13m, e, Fin.sum_univ_three]
  H13_v5 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, H13m, e, Fin.sum_univ_three]
  H13_v6 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, H13m, e, Fin.sum_univ_three]
  T23_v4 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T23m, e, Fin.sum_univ_three]
  T23_v5 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T23m, e, Fin.sum_univ_three]
  T23_v6 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T23m, e, Fin.sum_univ_three]
  T32_v4 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T32m, e, Fin.sum_univ_three]
  T32_v5 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T32m, e, Fin.sum_univ_three]
  T32_v6 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T32m, e, Fin.sum_univ_three]
  T12_v4 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T12m, e, Fin.sum_univ_three]
  T12_v5 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T12m, e, Fin.sum_univ_three]
  T12_v6 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T12m, e, Fin.sum_univ_three]
  T21_v4 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T21m, e, Fin.sum_univ_three]
  T21_v5 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T21m, e, Fin.sum_univ_three]
  T21_v6 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T21m, e, Fin.sum_univ_three]
  T13_v4 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T13m, e, Fin.sum_univ_three]
  T13_v5 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T13m, e, Fin.sum_univ_three]
  T13_v6 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T13m, e, Fin.sum_univ_three]
  T31_v4 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T31m, e, Fin.sum_univ_three]
  T31_v5 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T31m, e, Fin.sum_univ_three]
  T31_v6 := by funext i; fin_cases i <;> simp [Matrix.mulVecLin, Matrix.mulVec, dotProduct, T31m, e, Fin.sum_univ_three]

/-- Every matrix is faithfully represented by its `mulVec` action in the standard
color action on `Fin 3 → ℂ`. In particular the mass grading `massM` is. -/
theorem stdColorAction_faithful (M : Matrix (Fin 3) (Fin 3) ℂ) :
    IsMatrixRep stdColorAction M (Matrix.mulVecLin M) := by
  intro j
  fin_cases j <;>
    · funext i
      fin_cases i <;>
        simp [ColorAction.vb, stdColorAction, Matrix.mulVecLin,
          Matrix.mulVec, dotProduct, e, Fin.sum_univ_three, Pi.single_apply]

/-- **Concrete corollary.** In the standard model on `Fin 3 → ℂ`, the mass grading
`diag(1,2,3)` (faithfully represented) fails to commute with the octonionic color
ladder `T23`. -/
theorem stdColorAction_mass_not_central :
    (Matrix.mulVecLin (massM 1 2 3)) ∘ₗ stdColorAction.T23
      ≠ stdColorAction.T23 ∘ₗ (Matrix.mulVecLin (massM 1 2 3)) := by
  exact octonionic_mass_not_central stdColorAction
    (stdColorAction_faithful (massM 1 2 3)) (by norm_num)

/-! ## Build-enforced axiom guard

The faithfulness bridge and the re-derived coupling theorems use only the
standard Lean/Mathlib axioms (`propext`, `Classical.choice`, `Quot.sound`); no
`sorry`, no `axiom`, no `native_decide`. -/

/-- info: 'PhysicsSM.Algebra.Furey.OctonionMassCouplingFaithful.faithful_T23' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms faithful_T23

/-- info: 'PhysicsSM.Algebra.Furey.OctonionMassCouplingFaithful.octonionic_mass_not_central' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms octonionic_mass_not_central

/-- info: 'PhysicsSM.Algebra.Furey.OctonionMassCouplingFaithful.stdColorAction_mass_not_central' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms stdColorAction_mass_not_central

end PhysicsSM.Algebra.Furey.OctonionMassCouplingFaithful
