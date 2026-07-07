import Mathlib

/-!
# Same-chirality scalar mass-amplitude census

This module records the Q10-L6 finite substitute for the same-chirality scalar
mass-amplitude cut.  It proves two pieces:

* the positive `d = 4` corner: the rank-two antisymmetric form `eps2` is
  invariant under determinant-one `2 x 2` matrices;
* the finite weight-parity obstruction used as a proxy for the `d = 6` and
  `d = 10` same-chirality scalar-amplitude failures.

The bridge lemma `charpoly_negSymmetric_of_invariant_form` is a purely linear
algebraic statement: an invertible bilinear self-duality intertwiner forces the
characteristic polynomial of a generator to be symmetric under negation.

Claim boundary: this file proves the finite substitute and bridge only.  It
does not construct the full Spin/Weyl representation stack or prove a
representation-theoretic `Hom_Spin(S tensor S, 1)` classification.

Provenance: Aristotle project
`7fd8a9bf-39ce-4bb2-a11a-65ea2bdf3ccd`
(`ne-q10-l6-scalar-amplitude-census-20260707`), clean-room formalization of
`AgentTasks/fable_parallel/Q10_answer.md` L6.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.MassAmplitudeCensus

open scoped BigOperators
open Matrix

/-! ## Positive rank-two corner -/

/-- The antisymmetric scalar amplitude on a rank-two module. -/
def eps2 {R : Type*} [CommRing R] (x y : Fin 2 -> R) : R :=
  x 0 * y 1 - x 1 * y 0

/-- The rank-two antisymmetric form is determinant-covariant. -/
theorem eps2_det_covariant {R : Type*} [CommRing R]
    (M : Matrix (Fin 2) (Fin 2) R) (x y : Fin 2 -> R) :
    eps2 (M.mulVec x) (M.mulVec y) = M.det * eps2 x y := by
  simp [eps2, Matrix.mulVec, dotProduct, Fin.sum_univ_two, Matrix.det_fin_two]
  ring

/-- The rank-two antisymmetric form is invariant under determinant-one matrices. -/
theorem eps2_SL2_invariant {R : Type*} [CommRing R]
    (M : Matrix (Fin 2) (Fin 2) R) (hM : M.det = 1) (x y : Fin 2 -> R) :
    eps2 (M.mulVec x) (M.mulVec y) = eps2 x y := by
  rw [eps2_det_covariant, hM, one_mul]

/-! ## Finite weight-parity obstruction -/

/-- Even-parity sign patterns in `n` coordinates. -/
def evenSigns (n : ℕ) : Finset (Fin n -> Bool) :=
  Finset.univ.filter (fun s => (Finset.univ.filter (fun i => s i)).card % 2 = 0)

/-- Twice the weight of a sign pattern under the sum of the `n` plane rotations. -/
def twiceWeight {n : ℕ} (s : Fin n -> Bool) : ℤ :=
  ∑ i, (if s i then (1 : ℤ) else -1)

/-- Weight multiset of the even-chirality Weyl finite avatar, doubled to integers. -/
def weylWeights (n : ℕ) : Multiset ℤ :=
  (evenSigns n).val.map twiceWeight

/-- A multiset is compatible with a self-dual invariant bilinear only if it is
symmetric under negation. -/
def negSymmetric (M : Multiset ℤ) : Prop :=
  M.map (fun x => -x) = M

/-- The `d = 4` (`n = 2`) weight multiset is negation-symmetric. -/
theorem weyl_symmetric_d4 : negSymmetric (weylWeights 2) := by
  unfold negSymmetric weylWeights evenSigns twiceWeight
  decide

/-- The `d = 6` (`n = 3`) weight multiset is not negation-symmetric. -/
theorem weyl_not_symmetric_d6 : ¬ negSymmetric (weylWeights 3) := by
  unfold negSymmetric weylWeights evenSigns twiceWeight
  decide

/-- The `d = 10` (`n = 5`) weight multiset is not negation-symmetric. -/
theorem weyl_not_symmetric_d10 : ¬ negSymmetric (weylWeights 5) := by
  unfold negSymmetric weylWeights evenSigns twiceWeight
  decide

/-! ## Characteristic-polynomial bridge -/

open Polynomial in
/-- If an invertible bilinear intertwiner realizes `M` as infinitesimally
self-dual, then `M.charpoly` is symmetric under negating the variable. -/
theorem charpoly_negSymmetric_of_invariant_form
    (m : ℕ) (M B : Matrix (Fin m) (Fin m) ℂ) (hB : IsUnit B.det)
    (hinv : M.transpose * B + B * M = 0) :
    M.charpoly.comp (-X) = (-1 : ℂ[X]) ^ m * M.charpoly := by
  have h_similar : ∃ B : Matrix (Fin m) (Fin m) ℂ,
      IsUnit B.det ∧ -M = B⁻¹ * M.transpose * B := by
    refine ⟨B, hB, ?_⟩
    simp_all +decide [mul_assoc, add_eq_zero_iff_eq_neg]
  obtain ⟨B, hB_unit, hB_similar⟩ := h_similar
  have h_charpoly_eq : (-M).charpoly = M.charpoly := by
    have h_charpoly_eq : (-M).charpoly = (M.transpose).charpoly := by
      rw [hB_similar, Matrix.charpoly, Matrix.charpoly]
      simp +decide [Matrix.charmatrix]
      have h_det_simplify :
          Matrix.det
              (Matrix.diagonal (fun _ => Polynomial.X) -
                B⁻¹.map (⇑Polynomial.C) * M.transpose.map (⇑Polynomial.C) *
                  B.map (⇑Polynomial.C)) =
            Matrix.det
              (B⁻¹.map (⇑Polynomial.C) *
                (Matrix.diagonal (fun _ => Polynomial.X) -
                  M.transpose.map (⇑Polynomial.C)) * B.map (⇑Polynomial.C)) := by
        simp +decide [mul_sub, sub_mul, mul_assoc]
        simp +decide [← mul_assoc, ← Matrix.smul_eq_diagonal_mul]
        rw [show B⁻¹.map (⇑Polynomial.C) * B.map (⇑Polynomial.C) = 1 from ?_]
        · exact congr_arg Matrix.det (by
            ext i j
            by_cases hi : i = j <;> simp +decide [hi])
        · simp +decide [← Matrix.map_mul]
          rw [Matrix.nonsing_inv_mul _] <;> aesop
      simp_all +decide [Matrix.det_mul]
      rw [mul_right_comm, ← Matrix.det_mul]
      simp +decide [← Matrix.map_mul, hB_unit]
    rw [h_charpoly_eq, Matrix.charpoly_transpose]
  convert congr_arg (Polynomial.comp · (-X)) h_charpoly_eq.symm using 1
  norm_num [Matrix.charpoly, Matrix.det_apply']
  rw [Finset.mul_sum _ _ _]
  refine Finset.sum_congr rfl fun sigma _ => ?_
  simp +decide [Matrix.charmatrix, Polynomial.comp]
  ring
  simp +decide [Polynomial.eval₂_finset_prod, mul_assoc, mul_left_comm]
  rw [mul_left_comm, ← Finset.prod_congr rfl fun _ _ => neg_sub _ _]
  rw [Finset.prod_congr rfl fun _ _ => neg_eq_neg_one_mul _, Finset.prod_mul_distrib]
  norm_num
  ring
  simp +decide [pow_mul', mul_comm]
  exact Finset.prod_congr rfl fun i _ => by
    by_cases hi : sigma i = i <;> simp +decide [hi]
    ring

/-! ## Axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MassAmplitudeCensus.eps2_SL2_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms eps2_SL2_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MassAmplitudeCensus.weyl_symmetric_d4' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weyl_symmetric_d4

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MassAmplitudeCensus.weyl_not_symmetric_d6' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weyl_not_symmetric_d6

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MassAmplitudeCensus.weyl_not_symmetric_d10' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weyl_not_symmetric_d10

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MassAmplitudeCensus.charpoly_negSymmetric_of_invariant_form' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms charpoly_negSymmetric_of_invariant_form

end PhysicsSM.Draft.NullEdge.GateI1.MassAmplitudeCensus
