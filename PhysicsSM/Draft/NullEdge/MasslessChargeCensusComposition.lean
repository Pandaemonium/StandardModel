import PhysicsSM.Draft.NullEdge.MasslessWeylChargeCensus
import PhysicsSM.Draft.NullEdge.ChargeBalanceForcesPartner

/-!
# Finite composition of the massless Weyl charge census

This target packages the sixteen designated principal-torus nodes as two
explicit finite types, evaluates the repository's integer Jacobian-sign charge
API on each, proves separate zero/pi cancellation, and instantiates the finite
partner theorem. Completeness of these node lists as the live crossing set is a
separate theorem.

Provenance: internal composition of the live census and finite charge-balance
API; all proof bodies were completed by Aristotle project
`34371f9c-bed4-411d-a81a-62d7131daae7` on 2026-07-11.
-/

namespace PhysicsSM.Draft.NullEdge.MasslessChargeCensusComposition

open scoped BigOperators
open MasslessWeylChargeCensus
open SU2LocalCrossingCharge
open ChargeBalanceForcesPartner

inductive ZeroNode where
  | c0 | c1 | c2 | c3 | b0 | b1 | b2 | b3
  deriving DecidableEq, Fintype

inductive PiNode where
  | p0 | p1 | p2 | p3 | q0 | q1 | q2 | q3
  deriving DecidableEq, Fintype

noncomputable def zeroCoords : ZeroNode -> Fin 3 -> Real
  | .c0 => ![0, 0, 0]
  | .c1 => ![0, Real.pi, Real.pi]
  | .c2 => ![Real.pi, 0, Real.pi]
  | .c3 => ![Real.pi, Real.pi, 0]
  | .b0 => ![Real.pi / 2, Real.pi / 2, -(Real.pi / 2)]
  | .b1 => ![Real.pi / 2, -(Real.pi / 2), Real.pi / 2]
  | .b2 => ![-(Real.pi / 2), Real.pi / 2, Real.pi / 2]
  | .b3 => ![-(Real.pi / 2), -(Real.pi / 2), -(Real.pi / 2)]

noncomputable def piCoords : PiNode -> Fin 3 -> Real
  | .p0 => ![0, 0, Real.pi]
  | .p1 => ![0, Real.pi, 0]
  | .p2 => ![Real.pi, 0, 0]
  | .p3 => ![Real.pi, Real.pi, Real.pi]
  | .q0 => ![Real.pi / 2, Real.pi / 2, Real.pi / 2]
  | .q1 => ![Real.pi / 2, -(Real.pi / 2), -(Real.pi / 2)]
  | .q2 => ![-(Real.pi / 2), Real.pi / 2, -(Real.pi / 2)]
  | .q3 => ![-(Real.pi / 2), -(Real.pi / 2), Real.pi / 2]

noncomputable def zeroJ (n : ZeroNode) : J3 :=
  Jm (zeroCoords n 0) (zeroCoords n 1) (zeroCoords n 2)

noncomputable def piJ (n : PiNode) : J3 :=
  Jm (piCoords n 0) (piCoords n 1) (piCoords n 2)

noncomputable def zeroCharge (n : ZeroNode) : Int :=
  localCrossingCharge (zeroJ n)

noncomputable def piCharge (n : PiNode) : Int :=
  localCrossingCharge (piJ n)

theorem zeroJ_det_ne_zero (n : ZeroNode) : (zeroJ n).det ≠ 0 := by
  cases n <;>
    simp only [zeroJ, zeroCoords, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons]
  · rw [det_c0]; norm_num
  · rw [det_c1]; norm_num
  · rw [det_c2]; norm_num
  · rw [det_c3]; norm_num
  · rw [det_b0]; norm_num
  · rw [det_b1]; norm_num
  · rw [det_b2]; norm_num
  · rw [det_b3]; norm_num

theorem piJ_det_ne_zero (n : PiNode) : (piJ n).det ≠ 0 := by
  cases n <;>
    simp only [piJ, piCoords, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons]
  · rw [det_p0]; norm_num
  · rw [det_p1]; norm_num
  · rw [det_p2]; norm_num
  · rw [det_p3]; norm_num
  · rw [det_q0]; norm_num
  · rw [det_q1]; norm_num
  · rw [det_q2]; norm_num
  · rw [det_q3]; norm_num

theorem zeroCharge_c0 : zeroCharge .c0 = 1 := by
  simp only [zeroCharge, zeroJ, zeroCoords, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons]
  rw [localCrossingCharge_eq_one _ (by rw [det_c0]; norm_num)]

theorem zeroCharge_sum : (∑ n : ZeroNode, zeroCharge n) = 0 := by
  rw [show (Finset.univ : Finset ZeroNode) =
    {ZeroNode.c0, .c1, .c2, .c3, .b0, .b1, .b2, .b3} from rfl]
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_singleton]
  simp only [zeroCharge, zeroJ, zeroCoords, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons]
  rw [localCrossingCharge_eq_one _ (by rw [det_c0]; norm_num),
      localCrossingCharge_eq_one _ (by rw [det_c1]; norm_num),
      localCrossingCharge_eq_one _ (by rw [det_c2]; norm_num),
      localCrossingCharge_eq_one _ (by rw [det_c3]; norm_num),
      localCrossingCharge_eq_neg_one _ (by rw [det_b0]; norm_num),
      localCrossingCharge_eq_neg_one _ (by rw [det_b1]; norm_num),
      localCrossingCharge_eq_neg_one _ (by rw [det_b2]; norm_num),
      localCrossingCharge_eq_neg_one _ (by rw [det_b3]; norm_num)]
  decide

theorem piCharge_sum : (∑ n : PiNode, piCharge n) = 0 := by
  rw [show (Finset.univ : Finset PiNode) =
    {PiNode.p0, .p1, .p2, .p3, .q0, .q1, .q2, .q3} from rfl]
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_singleton]
  simp only [piCharge, piJ, piCoords, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons]
  rw [localCrossingCharge_eq_neg_one _ (by rw [det_p0]; norm_num),
      localCrossingCharge_eq_neg_one _ (by rw [det_p1]; norm_num),
      localCrossingCharge_eq_neg_one _ (by rw [det_p2]; norm_num),
      localCrossingCharge_eq_neg_one _ (by rw [det_p3]; norm_num),
      localCrossingCharge_eq_one _ (by rw [det_q0]; norm_num),
      localCrossingCharge_eq_one _ (by rw [det_q1]; norm_num),
      localCrossingCharge_eq_one _ (by rw [det_q2]; norm_num),
      localCrossingCharge_eq_one _ (by rw [det_q3]; norm_num)]
  decide

/-- Every designated zero-quasienergy node has a distinct nondegenerate partner
inside the exact finite census. -/
theorem zeroNode_has_partner (n : ZeroNode) :
    ∃ m ∈ (Finset.univ : Finset ZeroNode), m ≠ n ∧ (zeroJ m).det ≠ 0 := by
  apply exists_second_nondegenerate_of_total_charge_zero
    (Finset.univ : Finset ZeroNode) zeroJ n (Finset.mem_univ n) (zeroJ_det_ne_zero n)
  simpa [zeroCharge] using zeroCharge_sum

/-- Every designated pi-quasienergy node has a distinct nondegenerate partner
inside the exact finite census. -/
theorem piNode_has_partner (n : PiNode) :
    ∃ m ∈ (Finset.univ : Finset PiNode), m ≠ n ∧ (piJ m).det ≠ 0 := by
  apply exists_second_nondegenerate_of_total_charge_zero
    (Finset.univ : Finset PiNode) piJ n (Finset.mem_univ n) (piJ_det_ne_zero n)
  simpa [piCharge] using piCharge_sum

/-- Negative control: one designated nonzero-charge node cannot by itself
satisfy the zero-total premise. -/
theorem zero_singleton_charge_ne_zero :
    ∑ n ∈ ({ZeroNode.c0} : Finset ZeroNode), zeroCharge n ≠ 0 := by
  exact singleton_nonzero_charge_sum_ne_zero zeroCharge ZeroNode.c0
    (by rw [zeroCharge_c0]; norm_num)

end PhysicsSM.Draft.NullEdge.MasslessChargeCensusComposition
