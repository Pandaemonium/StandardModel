import PhysicsSM.Draft.NullEdge.AtlasComponentCharacter
import PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition

/-!
# Concrete Lorentz component characters

This module proves that the two discrete signs isolated by
`CarrierProbeRestrictedLorentzTransition.lean` are multiplicative under
matrix composition:

* `timeSign` records the sign sector of the time-time entry;
* `determinantSign` records the determinant sector.

The difficult time-sign proof derives both first-row and first-column
hyperboloid identities from `transpose M * eta * M = eta`, applies an explicit
three-dimensional Cauchy--Schwarz bound, and closes all four sign cases.  It is
the concrete input needed to use `AtlasComponentCharacter.lean` for time
orientability and orientability obstructions.

Provenance: proofs returned by Aristotle project
`f3a64d3b-b82b-42c9-8bce-715a9a5f4447`, reviewed without statement changes,
and adapted only to reuse this project's existing eta and Lorentz predicates.
PhysLean convention alignment is documented in the predecessor module.

Claim grade: `M [comp]`, finite matrix algebra only.
-/

namespace PhysicsSM.Draft.NullEdge.LorentzComponentCharacter

open Matrix
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition

noncomputable section

/-- Local abbreviation for the project's mostly-minus metric. -/
abbrev eta : Matrix (Fin 4) (Fin 4) Real :=
  MinkowskiConvention.eta

/-- Bit zero is future preserving; bit one is time reversing. -/
def timeSign (M : Matrix (Fin 4) (Fin 4) Real) : ZMod 2 :=
  if 0 <= M 0 0 then 0 else 1

/-- Bit zero is proper; bit one is orientation reversing. -/
def determinantSign (M : Matrix (Fin 4) (Fin 4) Real) : ZMod 2 :=
  if 0 <= M.det then 0 else 1

/-- Eta-Lorentz matrices are closed under multiplication. -/
theorem isEtaLorentz_mul
    (M N : Matrix (Fin 4) (Fin 4) Real)
    (hM : IsEtaLorentz M) (hN : IsEtaLorentz N) :
    IsEtaLorentz (M * N) := by
  unfold IsEtaLorentz at *
  simp_all +decide [Matrix.mul_assoc]
  simp_all +decide [<- Matrix.mul_assoc]

/-- The time-time entry of an eta-Lorentz matrix has absolute value at least
one. -/
theorem one_le_abs_timeTime
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M) :
    1 <= |M 0 0| := by
  have := congr_fun (congr_fun hM 0) 0
  norm_num [IsEtaLorentz] at this
  norm_num [Fin.sum_univ_succ, Matrix.mul_apply, eta,
    MinkowskiConvention.eta] at this
  cases abs_cases (M 0 0) <;> nlinarith!

/-- The time-orientation component is multiplicative, written additively in
`ZMod 2`. -/
theorem timeSign_mul
    (M N : Matrix (Fin 4) (Fin 4) Real)
    (hM : IsEtaLorentz M) (hN : IsEtaLorentz N) :
    timeSign (M * N) = timeSign M + timeSign N := by
  set a := M 0 0
  set b := N 0 0
  set c := (M * N) 0 0
  have hb_sq : b^2 - ∑ i ∈ Finset.univ.erase 0, (N i 0)^2 = 1 := by
    have := congr_fun (congr_fun hN 0) 0
    norm_num [Fin.sum_univ_succ, Matrix.mul_apply, eta,
      MinkowskiConvention.eta] at this ⊢
    linarith!
  have ha_sq : a^2 - ∑ j ∈ Finset.univ.erase 0, (M 0 j)^2 = 1 := by
    have ha_sq : M * eta * M.transpose = eta := by
      have h_inv : M * eta * M.transpose * eta = 1 := by
        have h_inv : eta * M.transpose * eta * M = 1 := by
          convert congr_arg (fun x => eta * x) hM using 1 <;>
            norm_num [Matrix.mul_assoc]
          ext i j
          fin_cases i <;> fin_cases j <;>
            norm_num [eta, MinkowskiConvention.eta]
        convert mul_eq_one_comm.mp h_inv using 1
        norm_num [Matrix.mul_assoc]
      rw [<- Matrix.inv_eq_left_inv h_inv]
      rw [Matrix.inv_eq_left_inv]
      ext i j
      fin_cases i <;> fin_cases j <;>
        norm_num [eta, MinkowskiConvention.eta]
    convert congr_arg
      (fun m : Matrix (Fin 4) (Fin 4) Real => m 0 0) ha_sq using 1
    norm_num [Matrix.mul_apply, Fin.sum_univ_succ]
    ring_nf!
    unfold eta
    norm_num [MinkowskiConvention.eta, Fin.ext_iff]
    ring_nf!
  have h_cauchy_schwarz : (c - a * b)^2 <= (a^2 - 1) * (b^2 - 1) := by
    have h_cauchy_schwarz :
        (c - a * b)^2 <=
          (∑ j ∈ Finset.univ.erase 0, (M 0 j)^2) *
            (∑ i ∈ Finset.univ.erase 0, (N i 0)^2) := by
      have h_cauchy_schwarz : forall (u v : Fin 3 -> Real),
          (∑ i, u i * v i)^2 <= (∑ i, u i^2) * (∑ i, v i^2) := by
        exact fun u v => by
          norm_num only [Fin.sum_univ_three]
          linarith [sq_nonneg (u 0 * v 1 - u 1 * v 0),
            sq_nonneg (u 0 * v 2 - u 2 * v 0),
            sq_nonneg (u 1 * v 2 - u 2 * v 1)]
      convert h_cauchy_schwarz
        (fun i => M 0 (Fin.succ i)) (fun i => N (Fin.succ i) 0) using 1
      norm_num [Fin.sum_univ_succ]
      ring_nf!
      norm_num [Fin.sum_univ_succ, Matrix.mul_apply]
      ring_nf!
    convert h_cauchy_schwarz using 2 <;> linarith
  have ha_sq_ge_one : a^2 >= 1 := by
    linarith [show 0 <= ∑ j ∈ Finset.univ.erase 0, M 0 j ^ 2 by
      exact Finset.sum_nonneg fun _ _ => sq_nonneg _]
  have hb_sq_ge_one : b^2 >= 1 := by
    linarith [show 0 <= ∑ i ∈ Finset.univ.erase 0, N i 0 ^ 2 by
      exact Finset.sum_nonneg fun _ _ => sq_nonneg _]
  unfold timeSign
  split_ifs <;> norm_num
  · nlinarith [mul_le_mul_of_nonneg_left
      (le_of_not_ge ‹Not (0 <= N 0 0)›) ‹0 <= M 0 0›]
  · nlinarith [mul_le_mul_of_nonneg_left
      (le_of_not_ge ‹Not (0 <= M 0 0)›) ‹0 <= N 0 0›]
  · grind
  · nlinarith [show 0 <= a * b by positivity]
  · nlinarith [mul_pos
      (neg_pos.mpr (lt_of_not_ge ‹Not (0 <= M 0 0)›))
      (neg_pos.mpr (lt_of_not_ge ‹Not (0 <= N 0 0)›))]

/-- The determinant-orientation component is multiplicative, written
additively in `ZMod 2`. -/
theorem determinantSign_mul
    (M N : Matrix (Fin 4) (Fin 4) Real)
    (hM : IsEtaLorentz M) (hN : IsEtaLorentz N) :
    determinantSign (M * N) = determinantSign M + determinantSign N := by
  have h_det : M.det ^ 2 = 1 ∧ N.det ^ 2 = 1 := by
    have h_det : M.det ^ 2 = (Matrix.transpose M * eta * M).det / eta.det := by
      rw [eq_div_iff] <;>
        norm_num [eta, MinkowskiConvention.eta]
      ring
      norm_num [Fin.sum_univ_succ, Matrix.det_succ_row_zero]
      repeat erw [Matrix.cons_val_succ']
      norm_num
    have h_det_N : N.det ^ 2 =
        (Matrix.transpose N * eta * N).det / eta.det := by
      rw [eq_div_iff] <;>
        norm_num [Matrix.det_mul, Matrix.det_transpose]
      ring
      norm_num [Matrix.det_succ_row_zero, eta, MinkowskiConvention.eta]
      simp +decide [Fin.sum_univ_succ, Fin.succAbove]
    simp_all +decide [IsEtaLorentz]
    norm_num [MinkowskiConvention.eta, Matrix.det_succ_row_zero]
    simp +decide [Fin.sum_univ_succ, Fin.succAbove]
  unfold determinantSign
  aesop

/-- The identity lies in the proper, orthochronous component. -/
theorem componentSigns_one :
    timeSign (1 : Matrix (Fin 4) (Fin 4) Real) = 0 /\
      determinantSign (1 : Matrix (Fin 4) (Fin 4) Real) = 0 := by
  unfold timeSign determinantSign
  aesop

end

end PhysicsSM.Draft.NullEdge.LorentzComponentCharacter

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzComponentCharacter.timeSign_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LorentzComponentCharacter.timeSign_mul

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzComponentCharacter.determinantSign_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LorentzComponentCharacter.determinantSign_mul
