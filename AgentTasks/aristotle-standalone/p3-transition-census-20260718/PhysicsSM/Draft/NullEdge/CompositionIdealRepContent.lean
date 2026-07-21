import PhysicsSM.Draft.NullEdge.CompositionSU2
import PhysicsSM.Draft.NullEdge.RankOneCore

/-!
# eq-36 rep content: the leptonic ideal operators under `T_3` (item-2 tail)

**Status: DRAFT / Aristotle handoff - the theorems carry documented
`s o r r y` markers.**

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

set_option maxHeartbeats 1000000

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

/-- **eq-36 singlet (vacuum slot):** `ad_{T_3}(v_w) = 0`. -/
theorem adT3_vwHat (d : Dixon) : adT3 vwHat d = 0 := by
  unfold adT3 vwHat T3 PL betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [coT3_smul, coT3_add, coT3_neg, coT3_R1, coT3_R2,
    coOm_smul, coOm_add, coOm_neg, coOm_R1, coOm_R2,
    coOmD_smul, coOmD_add, coOmD_neg, coOmD_R1, coOmD_R2,
    R1_smul, R2_smul, R1_add, R2_add, R1_neg, R2_neg,
    R3_smul, R3_add, coT3_R3, coOm_R3, coOmD_R3,
    R3_R1_anticomm_comp, R3_R2_anticomm_comp,
    R1_R1, R2_R2, smul_add, smul_neg, I_smul_I, neg_neg,
    coT3_coOm, coT3_coOmD, R2_R1_eq]
  sorry

/-- **eq-36 doublet upper (`V_L`):** `ad_{T_3}(X1) = X1` (up to the pinned
normalization - if the kernel value differs by sign/scale, REPORT it and pin;
do not force). -/
theorem adT3_X1 (d : Dixon) : adT3 X1 d = X1 d := by
  sorry

/-- **eq-36 doublet lower (`E-_L`):** `ad_{T_3}(X2) = -(X2)` (same
normalization caution). -/
theorem adT3_X2 (d : Dixon) : adT3 X2 d = -(X2 d) := by
  sorry

/-- **eq-36 singlet (top slot, `E-_R`):** `ad_{T_3}(X3) = 0`. -/
theorem adT3_X3 (d : Dixon) : adT3 X3 d = 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.CompositionIdealRepContent
