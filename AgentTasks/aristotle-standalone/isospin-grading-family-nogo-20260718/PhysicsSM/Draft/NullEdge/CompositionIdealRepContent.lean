import PhysicsSM.Draft.NullEdge.CompositionSU2
import PhysicsSM.Draft.NullEdge.RankOneCore

/-!
# eq-36 rep content: the leptonic ideal operators under `T_3` (item-2 tail)

**Status: PROVEN.** The rank-one computation verifies the vacuum and `X1`
gradings as stated, and exposes normalization mismatches for `X2` and `X3`
(see the corrected theorem docstrings below).

Furey 1806.00612 eq 32/36: the leptonic minimal right ideal
`L = v_w Cl(4) ~ 1 (+) 2 (+) 1` under su(2)_L. In the faithful COMPOSITION
semantics the ideal's four basis objects are OPERATORS on the Dixon algebra -
`v_w`-compositions with `beta-dag` strings:

  `X0 = vwHat`               (the vacuum projector-string; `V_R` slot)
  `X1 = vwHat o betaHat1dag` (`V_L` slot)
  `X2 = vwHat o betaHat2dag` (`E-_L` slot)
  `X3 = vwHat o betaHat1dag o betaHat2dag` (`E-_R` slot)

with `vwHat = betaHat1dag o betaHat2dag o betaHat2 o betaHat1` (eq 32's
`v_w = beta_1‡ beta_2‡ beta_2 beta_1`, all products = compositions).

The eq-36 content: under the ADJOINT `T_3` action
`ad(X) = T3 o X - X o T3` the four operators carry the `1 (+) 2 (+) 1`
grading - the two end slots are annihilated (singlets), the middle two are
`+-`-graded (the doublet). This module states that grading; the computations
reduce by the LANDED toolkit:

* `CompositionWeakCAR`: the eq-31 CAR relations (cross global, diagonal =
  lifted mode anticommutator), the slot-lift `co`, `R1/R2` algebra, the
  normalization lemmas;
* `CompositionSU2`: `T3 = co hatTau3 o PL`, the projector algebra
  (`PL_idempotent`, `PL_kills_RH`, `PL_fixes_LH`, `R3` slot form), the
  mode-plane grading (`hatTau3_on_vIdem/nuState`);
* `CompositionWeakLadders`: the operator-Fock cores.

NO coordinate expansion should be needed (and depth-12+ would defeat the
elaborator - see the anti-Fock module's history); everything is operator
rewriting. The definitions below typecheck; the sorried statements are the
handoff.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionIdealRepContent

open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.CompositionWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakCAR
open PhysicsSM.Draft.NullEdge.CompositionSU2

set_option maxHeartbeats 64000000

/-- The weak vacuum as a COMPOSITION operator (eq 32's
`v_w = beta_1‡ beta_2‡ beta_2 beta_1`). -/
def vwHat (d : Dixon) : Dixon :=
  betaHat1dag (betaHat2dag (betaHat2 (betaHat1 d)))

/-- Ideal basis operator `X1 = vwHat o betaHat1dag` (`V_L`). -/
def X1 (d : Dixon) : Dixon := vwHat (betaHat1dag d)
/-- Ideal basis operator `X2 = vwHat o betaHat2dag` (`E-_L`). -/
def X2 (d : Dixon) : Dixon := vwHat (betaHat2dag d)
/-- Ideal basis operator `X3 = vwHat o betaHat1dag o betaHat2dag` (`E-_R`). -/
def X3 (d : Dixon) : Dixon := vwHat (betaHat1dag (betaHat2dag d))

/-- The adjoint `T_3` action on an operator. -/
def adT3 (X : Dixon → Dixon) (d : Dixon) : Dixon := T3 (X d) - X (T3 d)

/-- `R3` anticommutes with `R1`. -/
lemma R3_R1_anticomm_comp (d : Dixon) : R3 (R1 d) = -(R1 (R3 d)) := by
  rw [R3_slots, R1_slots, R1_slots, R3_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp

/-- `R3` anticommutes with `R2`. -/
lemma R3_R2_anticomm_comp (d : Dixon) : R3 (R2 d) = -(R2 (R3 d)) := by
  rw [R3_slots, R2_slots, R2_slots, R3_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp

/-- `R3` respects negation. -/
lemma R3_neg_comp (d : Dixon) : R3 (-d) = -(R3 d) := by
  rw [R3_slots, R3_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp

/-- The lifted colour grading commutes with `R3`. -/
lemma coT3_R3 (d : Dixon) : co hatTau3 (R3 d) = R3 (co hatTau3 d) := by
  rw [R3_slots, R3_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp [co]
  · exact CompositionWeakCAR.hatTau3_neg _
  · exact CompositionWeakCAR.hatTau3_neg _

/-- The lifted lowering core commutes with `R3`. -/
lemma coOmD_R3 (d : Dixon) : co hatOmegaDag (R3 d) = R3 (co hatOmegaDag d) := by
  rw [R3_slots, R3_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp [co]
  · exact CompositionWeakCAR.hatOmegaDag_neg _
  · exact CompositionWeakCAR.hatOmegaDag_neg _

/-- The lifted raising core commutes with `R3`. -/
lemma coOm_R3 (d : Dixon) : co hatOmega (R3 d) = R3 (co hatOmega d) := by
  rw [R3_slots, R3_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp [co]
  · exact CompositionWeakCAR.hatOmega_neg _
  · exact CompositionWeakCAR.hatOmega_neg _

/-- Oriented lifted anticommutation of `hatTau3` and `hatOmega`. -/
lemma coT3_coOm (d : Dixon) :
    co hatTau3 (co hatOmega d) = -(co hatOmega (co hatTau3 d)) :=
  eq_neg_of_add_eq_zero_left (co_tau3_omega_anticomm d)

/-- Oriented lifted anticommutation of `hatTau3` and `hatOmegaDag`. -/
lemma coT3_coOmD (d : Dixon) :
    co hatTau3 (co hatOmegaDag d) = -(co hatOmegaDag (co hatTau3 d)) :=
  eq_neg_of_add_eq_zero_left (co_tau3_omegaDag_anticomm d)

/-- Oriented anticommutation of the first two quaternionic right actions. -/
lemma R2_R1_eq (d : Dixon) : R2 (R1 d) = -(R1 (R2 d)) :=
  eq_neg_of_add_eq_zero_right (R1_R2_anticomm d)

open PhysicsSM.Draft.NullEdge.RankOneCore
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem vIdemStar)
open PhysicsSM.Algebra.Octonion.ComplexOctonion

lemma I_pow_reduce_local (n : ℕ) : Complex.I ^ (n + 2) = -(Complex.I ^ n) := by
  rw [pow_add, pow_two, Complex.I_mul_I, mul_neg, mul_one]

@[simp] lemma I_pow_2_local : Complex.I ^ 2 = -1 := by
  exact Complex.I_sq

@[simp] lemma I_pow_3_local : Complex.I ^ 3 = -Complex.I := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_4_local : Complex.I ^ 4 = 1 := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_5_local : Complex.I ^ 5 = Complex.I := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_6_local : Complex.I ^ 6 = -1 := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_7_local : Complex.I ^ 7 = -Complex.I := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_8_local : Complex.I ^ 8 = 1 := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_9_local : Complex.I ^ 9 = Complex.I := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_10_local : Complex.I ^ 10 = -1 := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_11_local : Complex.I ^ 11 = -Complex.I := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_12_local : Complex.I ^ 12 = 1 := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_13_local : Complex.I ^ 13 = Complex.I := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_14_local : Complex.I ^ 14 = -1 := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_15_local : Complex.I ^ 15 = -Complex.I := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_16_local : Complex.I ^ 16 = 1 := by
  norm_num [pow_succ, Complex.I_sq]
@[simp] lemma I_pow_17_local : Complex.I ^ 17 = Complex.I := by
  norm_num [pow_succ, Complex.I_sq]

lemma phi_add_local
    (x y : PhysicsSM.Algebra.Octonion.ComplexOctonion.ComplexOctonion) :
    phi (x + y) = phi x + phi y := by
  unfold phi
  apply Complex.ext <;> simp <;> ring

lemma psi_add_local
    (x y : PhysicsSM.Algebra.Octonion.ComplexOctonion.ComplexOctonion) :
    psi (x + y) = psi x + psi y := by
  unfold psi
  apply Complex.ext <;> simp <;> ring

lemma phi_neg_local
    (x : PhysicsSM.Algebra.Octonion.ComplexOctonion.ComplexOctonion) :
    phi (-x) = -phi x := by
  unfold phi
  apply Complex.ext <;> simp <;> ring

lemma psi_neg_local
    (x : PhysicsSM.Algebra.Octonion.ComplexOctonion.ComplexOctonion) :
    psi (-x) = -psi x := by
  unfold psi
  apply Complex.ext <;> simp <;> ring

lemma phi_smul_local (c : ℂ)
    (z : PhysicsSM.Algebra.Octonion.ComplexOctonion.ComplexOctonion) :
    phi (c • z) = c * phi z := by
  unfold phi
  apply Complex.ext <;>
    simp [ComplexOctonion.complex_smul_re,
      ComplexOctonion.complex_smul_im] <;> ring

lemma psi_smul_local (c : ℂ)
    (z : PhysicsSM.Algebra.Octonion.ComplexOctonion.ComplexOctonion) :
    psi (c • z) = c * psi z := by
  unfold psi
  apply Complex.ext <;>
    simp [ComplexOctonion.complex_smul_re,
      ComplexOctonion.complex_smul_im] <;> ring

lemma phi_vIdem_local : phi vIdem = Complex.I := by
  apply Complex.ext <;> norm_num [phi, vIdem, Complex.I]

lemma phi_vIdemStar_local : phi vIdemStar = 0 := by
  apply Complex.ext <;> norm_num [phi, vIdemStar]

lemma psi_vIdem_local : psi vIdem = 0 := by
  apply Complex.ext <;> norm_num [psi, vIdem]

lemma psi_vIdemStar_local : psi vIdemStar = -Complex.I := by
  apply Complex.ext <;> norm_num [psi, vIdemStar, Complex.I]

lemma hatTau3_rank_one_local
    (z : PhysicsSM.Algebra.Octonion.ComplexOctonion.ComplexOctonion) :
    hatTau3 z = (Complex.I * psi z) • vIdemStar +
      (Complex.I * phi z) • vIdem := by
  unfold hatTau3
  rw [hatOmega_rank_one, hatOmegaDag_rank_one,
    hatOmega_rank_one, hatOmegaDag_rank_one,
    phi_smul_local, psi_smul_local, phi_vIdem_local,
    psi_vIdemStar_local]
  module

/-- **eq-36 singlet (vacuum slot):** `ad_{T_3}(v_w) = 0`. -/
theorem adT3_vwHat (d : Dixon) : adT3 vwHat d = 0 := by
  unfold adT3 vwHat T3 PL betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;>
    change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local,
      phi_vIdemStar_local, psi_vIdem_local, psi_vIdemStar_local] <;>
    module <;> simp_all <;> module

/-- **eq-36 doublet upper (`V_L`):** `ad_{T_3}(X1) = X1` (up to the pinned
normalization - if the kernel value differs by sign/scale, REPORT it and pin;
do not force). -/
theorem adT3_X1 (d : Dixon) : adT3 X1 d = X1 d := by
  unfold adT3 X1 vwHat T3 PL betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;>
    change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local,
      phi_vIdemStar_local, psi_vIdem_local, psi_vIdemStar_local]
  all_goals match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num
  all_goals ring

/-- **Normalization mismatch (kernel-verified correction):** the requested
`ad_{T_3}(X2) = -X2` is false for the definitions in this file. The rank-one
closed-form computation gives `ad_{T_3}(X2) = X2`; thus `X1` and `X2` have the
same `+1` grading under the pinned composition conventions. -/
theorem adT3_X2_corrected (d : Dixon) : adT3 X2 d = X2 d := by
  unfold adT3 X2 vwHat T3 PL betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;>
    change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local,
      phi_vIdemStar_local, psi_vIdem_local, psi_vIdemStar_local]
  all_goals match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num
  all_goals ring

/-- **Normalization mismatch (kernel-verified correction):** the requested
singlet equation `ad_{T_3}(X3) = 0` is false for the definitions in this file.
The actual closed-form value is `ad_{T_3}(X3) = 2 • X3`. -/
theorem adT3_X3_corrected (d : Dixon) : adT3 X3 d = (2 : ℂ) • X3 d := by
  unfold adT3 X3 vwHat T3 PL betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;>
    change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local,
      phi_vIdemStar_local, psi_vIdem_local, psi_vIdemStar_local]
  all_goals match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num
  all_goals ring

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionIdealRepContent.adT3_vwHat' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionIdealRepContent.adT3_vwHat

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionIdealRepContent.adT3_X1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionIdealRepContent.adT3_X1

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionIdealRepContent.adT3_X2_corrected' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionIdealRepContent.adT3_X2_corrected

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionIdealRepContent.adT3_X3_corrected' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionIdealRepContent.adT3_X3_corrected

end PhysicsSM.Draft.NullEdge.CompositionIdealRepContent
