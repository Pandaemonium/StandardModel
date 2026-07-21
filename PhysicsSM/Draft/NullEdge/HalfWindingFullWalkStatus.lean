import PhysicsSM.Draft.NullEdge.HalfWindingFieldPositionClassification

/-!
# Paper C gate: full-walk census for the same-winding counterexample

Final determinant census of the uncompressed `8 × 8` rational walks:

| field | mode | determinant census | result |
|---|---:|---:|---|
| two-wall witness `11` | `+1` | `det (Wof 11 - 1) = 0` | has mode |
| two-wall witness `11` | `-1` | `det (Wof 11 + 1) = 0` | has mode |
| same-winding field `2` | `+1` | `det (Wof 2 - 1) = 0` | has mode |
| same-winding field `2` | `-1` | `det (Wof 2 + 1) = 0` | has mode |

Thus both full walks carry both modes.  Since the compressed fixed-leg sector
of field `2` has neither mode, that compression loses both modes.

The computation is kernel-only.  The common denominator `5` is cleared to the
integer twin `walkZ`; explicit integral null vectors establish all four zero
determinants, and the cast and determinant-scaling lemmas transfer the results
to the rational full walks.  The four public census theorems have assumption
footprint exactly `[propext, Classical.choice, Quot.sound]`, enforced below.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HalfWindingFullWalkStatus

open Matrix
open PhysicsSM.Draft.NullEdge.HalfWindingFieldPositionClassification
open ModeInvariantHalfWinding

/-- Integral version of the conditional shift. -/
def shiftZ : Matrix V8 V8 ℤ := Matrix.of fun i j =>
  if i.2 = j.2 then
    (if i.1 = (if j.2 = 0 then (![1,2,3,0] : Fin 4 → Fin 4) j.1
               else (![3,0,1,2] : Fin 4 → Fin 4) j.1) then (1 : ℤ) else 0) else 0

/-- Integral coin obtained by clearing the common denominator `5`. -/
def coinZ (n : Fin 16) : Matrix V8 V8 ℤ := Matrix.of fun i j =>
  if i.1 = j.1 then
    if i.2 = j.2 then 4
    else if i.2 = 0 then -(if n.val.testBit i.1.val then 3 else -3)
    else (if n.val.testBit i.1.val then 3 else -3)
  else 0

/-- Integral twin of the full walk. -/
def walkZ (n : Fin 16) : Matrix V8 V8 ℤ := shiftZ * coinZ n * shiftZ

lemma shiftZ_cast : shiftZ.map (Int.castRingHom ℚ) = shiftQ := by
  decide

lemma coinZ_cast (n : Fin 16) :
    (coinZ n).map (Int.castRingHom ℚ) = (5 : ℚ) • coinQ cW (signField n) := by
  ext ⟨i, a⟩ ⟨j, b⟩
  fin_cases i <;> fin_cases a <;> fin_cases j <;> fin_cases b <;>
    simp [coinZ, coinQ, cW, signField] <;> (try split_ifs) <;> norm_num

lemma walkZ_cast (n : Fin 16) :
    (walkZ n).map (Int.castRingHom ℚ) = (5 : ℚ) • Wof n := by
  rw [walkZ, Matrix.map_mul, Matrix.map_mul, shiftZ_cast, coinZ_cast]
  simp [Wof, walkQ, Matrix.mul_assoc]

lemma walkZ_witness_pos_det : (walkZ 11 - 5 • (1 : Matrix V8 V8 ℤ)).det = 0 := by
  rw [← Matrix.exists_mulVec_eq_zero_iff]
  refine ⟨fun x => ![![0, 0], ![5, -3], ![0, 0], ![4, 0]] x.1 x.2,
    by decide, ?_⟩
  decide

lemma walkZ_witness_neg_det : (walkZ 11 + 5 • (1 : Matrix V8 V8 ℤ)).det = 0 := by
  rw [← Matrix.exists_mulVec_eq_zero_iff]
  refine ⟨fun x => ![![0, 0], ![-5, -3], ![0, 0], ![4, 0]] x.1 x.2,
    by decide, ?_⟩
  decide

lemma walkZ_cex_pos_det : (walkZ 2 - 5 • (1 : Matrix V8 V8 ℤ)).det = 0 := by
  rw [← Matrix.exists_mulVec_eq_zero_iff]
  refine ⟨fun x => ![![5, 3], ![0, 0], ![4, 0], ![0, 0]] x.1 x.2, by decide, ?_⟩
  decide

lemma walkZ_cex_neg_det : (walkZ 2 + 5 • (1 : Matrix V8 V8 ℤ)).det = 0 := by
  rw [← Matrix.exists_mulVec_eq_zero_iff]
  refine ⟨fun x => ![![-5, 3], ![0, 0], ![4, 0], ![0, 0]] x.1 x.2, by decide, ?_⟩
  decide

lemma det_eq_zero_of_scaled_det_eq_zero (A : Matrix V8 V8 ℚ)
    (h : ((5 : ℚ) • A).det = 0) : A.det = 0 := by
  simp_all +decide

lemma five_one_map :
    (5 • (1 : Matrix V8 V8 ℤ)).map (Int.castRingHom ℚ) =
      (5 : ℚ) • (1 : Matrix V8 V8 ℚ) := by
  ext i j
  simp only [Matrix.map_apply, Matrix.smul_apply, Matrix.one_apply]
  split_ifs <;> norm_num

lemma walkZ_sub_map (n : Fin 16) :
    (walkZ n - 5 • (1 : Matrix V8 V8 ℤ)).map (Int.castRingHom ℚ) =
      (5 : ℚ) • (Wof n - 1) := by
  rw [Matrix.map_sub (Int.castRingHom ℚ) (Int.castRingHom ℚ).map_sub,
    walkZ_cast, five_one_map, smul_sub]

lemma walkZ_add_map (n : Fin 16) :
    (walkZ n + 5 • (1 : Matrix V8 V8 ℤ)).map (Int.castRingHom ℚ) =
      (5 : ℚ) • (Wof n + 1) := by
  rw [Matrix.map_add (Int.castRingHom ℚ) (Int.castRingHom ℚ).map_add,
    walkZ_cast, five_one_map, smul_add]

lemma det_eq_zero_of_integral_twin (B : Matrix V8 V8 ℤ) (A : Matrix V8 V8 ℚ)
    (hm : B.map (Int.castRingHom ℚ) = (5 : ℚ) • A) (hB : B.det = 0) :
    A.det = 0 := by
  apply det_eq_zero_of_scaled_det_eq_zero
  rw [← hm]
  rw [← show (Int.castRingHom ℚ).mapMatrix B = B.map (Int.castRingHom ℚ) from rfl,
    ← (Int.castRingHom ℚ).map_det, hB]
  norm_num

/-- The two-wall witness full walk carries a `+1` mode. -/
theorem fullwalk_witness_pos : (Wof 11 - 1).det = 0 :=
  det_eq_zero_of_integral_twin _ _ (walkZ_sub_map 11) walkZ_witness_pos_det

/-- The two-wall witness full walk carries a `-1` mode. -/
theorem fullwalk_witness_neg : (Wof 11 + 1).det = 0 :=
  det_eq_zero_of_integral_twin _ _ (walkZ_add_map 11) walkZ_witness_neg_det

/-- The same-winding counterexample full walk carries a `+1` mode, despite
that mode being absent from its compressed fixed-leg sector. -/
theorem fullwalk_cex_pos : (Wof 2 - 1).det = 0 :=
  det_eq_zero_of_integral_twin _ _ (walkZ_sub_map 2) walkZ_cex_pos_det

/-- The same-winding counterexample full walk carries a `-1` mode, despite
that mode being absent from its compressed fixed-leg sector. -/
theorem fullwalk_cex_neg : (Wof 2 + 1).det = 0 :=
  det_eq_zero_of_integral_twin _ _ (walkZ_add_map 2) walkZ_cex_neg_det

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.HalfWindingFullWalkStatus.fullwalk_witness_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fullwalk_witness_pos

/-- info: 'PhysicsSM.Draft.NullEdge.HalfWindingFullWalkStatus.fullwalk_witness_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fullwalk_witness_neg

/-- info: 'PhysicsSM.Draft.NullEdge.HalfWindingFullWalkStatus.fullwalk_cex_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fullwalk_cex_pos

/-- info: 'PhysicsSM.Draft.NullEdge.HalfWindingFullWalkStatus.fullwalk_cex_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fullwalk_cex_neg

end PhysicsSM.Draft.NullEdge.HalfWindingFullWalkStatus
