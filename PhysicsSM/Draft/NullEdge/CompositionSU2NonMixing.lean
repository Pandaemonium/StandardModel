import PhysicsSM.Draft.NullEdge.CompositionSU2

/-!
# eq-42 non-mixing su(2) closure on the Dixon carrier (P3 step 2, su(2) half)

**Status: DRAFT.** Furey 1806.00612 eq 42 lists the NON-mixing electroweak
generators `I|T_1, I|T_2, I|T_3` - on the Dixon carrier these are the landed
Fig-4 operators `T_j = co hatTau_j o PL` (`CompositionSU2`). The exclusion
theorem's "non-mixing" half needs their su(2) BRACKET CLOSURE. This module
proves it on the probe state used throughout the Cl(10) layer
(`ofColour vIdem`), by the structural route:

1. `co` lifts commute with `R3` (hence with `PL`) for negation-respecting
   maps, and compose slotwise by `rfl`;
2. `PL` is idempotent (landed), so
   `T_i (T_j d) = co (hatTau_i o hatTau_j) (PL d)`;
3. the bracket therefore reduces slotwise to the LANDED mode-plane tau
   brackets (`tau12_bracket_on_vIdem` etc.), applied to the two slots of
   `PL (ofColour vIdem)`.

The result: `[T_1, T_2] = -(2i) T_3` (and cyclic) on the probe state - the
su(2) closure of the non-mixing set, complementing the landed mixing-side
witnesses (`Mix11`/`MixT11` nonzero, colour-supported, H-slot-crossing).
Contrast pair for the exclusion theorem substrate.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionSU2NonMixing

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.DixonWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakCAR
open PhysicsSM.Draft.NullEdge.CompositionSU2
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem)

set_option maxHeartbeats 64000000
set_option maxRecDepth 20000

/-! ## 1. `R3`/`PL` commutation for colour lifts -/

/-- A colour lift commutes with `R3` provided the colour map respects
negation (mirror of the landed `co_comm_R1`/`co_comm_R2`). -/
theorem co_comm_R3 (g : ComplexOctonion → ComplexOctonion)
    (hneg : ∀ x, g (-x) = -g x) (d : Dixon) :
    co g (R3 d) = R3 (co g d) := by
  rw [R3_slots, R3_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> simp [co, hneg]

/-- A colour lift commutes with the chiral projector `PL` provided the
colour map is additive, negation-respecting, and `C`-homogeneous. -/
theorem co_comm_PL (g : ComplexOctonion → ComplexOctonion)
    (hadd : ∀ x y, g (x + y) = g x + g y)
    (hneg : ∀ x, g (-x) = -g x)
    (hsmul : ∀ (c : ℂ) x, g (c • x) = c • g x) (d : Dixon) :
    co g (PL d) = PL (co g d) := by
  unfold PL
  rw [co_smul g hsmul, co_add g hadd, co_smul g hsmul, co_comm_R3 g hneg]

/-! ## 2. `hatTau1`/`hatTau2` respect the module operations -/

theorem hatTau1_add (x y : ComplexOctonion) :
    hatTau1 (x + y) = hatTau1 x + hatTau1 y := by
  unfold hatTau1
  rw [hatOmega_add, hatOmegaDag_add]
  abel

theorem hatTau1_neg (x : ComplexOctonion) : hatTau1 (-x) = -hatTau1 x := by
  unfold hatTau1
  rw [hatOmega_neg, hatOmegaDag_neg]
  abel

theorem hatTau1_smul (c : ℂ) (x : ComplexOctonion) :
    hatTau1 (c • x) = c • hatTau1 x := by
  unfold hatTau1
  rw [hatOmega_smul, hatOmegaDag_smul, smul_add]

theorem hatTau2_add (x y : ComplexOctonion) :
    hatTau2 (x + y) = hatTau2 x + hatTau2 y := by
  unfold hatTau2
  rw [hatOmega_add, hatOmegaDag_add]
  simp only [smul_add]
  abel

theorem hatTau2_neg (x : ComplexOctonion) : hatTau2 (-x) = -hatTau2 x := by
  unfold hatTau2
  rw [hatOmega_neg, hatOmegaDag_neg]
  simp only [smul_neg]
  abel

theorem hatTau2_smul (c : ℂ) (x : ComplexOctonion) :
    hatTau2 (c • x) = c • hatTau2 x := by
  unfold hatTau2
  rw [hatOmega_smul, hatOmegaDag_smul, smul_add, smul_neg, smul_comm c
    Complex.I (hatOmega x), smul_comm c Complex.I (hatOmegaDag x)]

theorem hatTau3_add' (x y : ComplexOctonion) :
    hatTau3 (x + y) = hatTau3 x + hatTau3 y := by
  unfold hatTau3
  rw [hatOmegaDag_add, hatOmega_add, hatOmega_add, hatOmegaDag_add]
  abel

theorem hatTau3_neg' (x : ComplexOctonion) : hatTau3 (-x) = -hatTau3 x :=
  hatTau3_neg x

theorem hatTau3_smul' (c : ℂ) (x : ComplexOctonion) :
    hatTau3 (c • x) = c • hatTau3 x := by
  unfold hatTau3
  rw [hatOmegaDag_smul, hatOmega_smul, hatOmega_smul, hatOmegaDag_smul,
    smul_add, smul_neg]

/-! ## 3. Composite form of the `T`-operators -/

/-- `T_i o T_j` collapses to a single colour lift of the tau composite on
one `PL` (commutation + idempotence). -/
theorem T_comp_eq (gi gj : ComplexOctonion → ComplexOctonion)
    (hadd : ∀ x y, gj (x + y) = gj x + gj y)
    (hneg : ∀ x, gj (-x) = -gj x)
    (hsmul : ∀ (c : ℂ) x, gj (c • x) = c • gj x) (d : Dixon) :
    co gi (PL (co gj (PL d))) = co (fun z => gi (gj z)) (PL d) := by
  rw [← co_comm_PL gj hadd hneg hsmul (PL d), PL_idempotent]
  rfl

/-! ## 4. The su(2) bracket closure on the probe state -/

theorem hatTau1_zero : hatTau1 0 = 0 := by
  simpa using hatTau1_smul 0 0

theorem hatTau2_zero : hatTau2 0 = 0 := by
  simpa using hatTau2_smul 0 0

theorem hatTau3_zero : hatTau3 0 = 0 := by
  simpa using hatTau3_smul' 0 0

/-- The chiral projector on the probe state, computed once at slot level:
`PL (ofColour vIdem) = <(1/2) v, 0, 0, ((1/2) i) v>`. -/
theorem PL_ofColour_vIdem :
    PL (ofColour vIdem)
      = ⟨(1 / 2 : ℂ) • vIdem, 0, 0, ((1 / 2 : ℂ) * Complex.I) • vIdem⟩ := by
  unfold PL ofColour
  rw [R3_slots]
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp [smul_smul]

/-- **eq-42 non-mixing closure, bracket (1,2):**
`[T_1, T_2] = -(2i) T_3` on the Cl(10) probe state. Structural proof: the
`T`-composites collapse to colour lifts on ONE `PL` (section 3), the probe
state's `PL` image has only two nonzero slots (both multiples of `vIdem`),
and each slot reduces by `tau`-linearity to the LANDED mode-plane bracket
`tau12_bracket_on_vIdem` - no coordinate expansion. -/
theorem T12_bracket_on_probe :
    T1 (T2 (ofColour vIdem)) - T2 (T1 (ofColour vIdem))
      = (-(2 * Complex.I)) • T3 (ofColour vIdem) := by
  unfold T1 T2 T3
  rw [T_comp_eq hatTau1 hatTau2 hatTau2_add hatTau2_neg hatTau2_smul,
    T_comp_eq hatTau2 hatTau1 hatTau1_add hatTau1_neg hatTau1_smul,
    PL_ofColour_vIdem, sub_eq_add_neg]
  have hb := tau12_bracket_on_vIdem
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp only [co_x0, co_x1, co_x2, co_x3, add_x0, add_x1, add_x2, add_x3,
      neg_x0, neg_x1, neg_x2, neg_x3, smul_x0, smul_x1, smul_x2, smul_x3]
  · rw [hatTau2_smul, hatTau1_smul, hatTau1_smul, hatTau2_smul,
      hatTau3_smul']
    have h2 : (1 / 2 : ℂ) • hatTau1 (hatTau2 vIdem)
        + (-((1 / 2 : ℂ) • hatTau2 (hatTau1 vIdem)))
        = (1 / 2 : ℂ) • (hatTau1 (hatTau2 vIdem)
            - hatTau2 (hatTau1 vIdem)) := by
      module
    rw [h2, hb]
    module
  · simp [hatTau1_zero, hatTau2_zero, hatTau3_zero]
  · simp [hatTau1_zero, hatTau2_zero, hatTau3_zero]
  · rw [hatTau2_smul, hatTau1_smul, hatTau1_smul, hatTau2_smul,
      hatTau3_smul']
    have h2 : ((1 / 2 : ℂ) * Complex.I) • hatTau1 (hatTau2 vIdem)
        + (-(((1 / 2 : ℂ) * Complex.I) • hatTau2 (hatTau1 vIdem)))
        = ((1 / 2 : ℂ) * Complex.I) • (hatTau1 (hatTau2 vIdem)
            - hatTau2 (hatTau1 vIdem)) := by
      module
    rw [h2, hb]
    module

/-- **eq-42 closure, bracket (2,3):** `[T_2, T_3] = -(2i) T_1` on the probe
state (same structural route). -/
theorem T23_bracket_on_probe :
    T2 (T3 (ofColour vIdem)) - T3 (T2 (ofColour vIdem))
      = (-(2 * Complex.I)) • T1 (ofColour vIdem) := by
  unfold T1 T2 T3
  rw [T_comp_eq hatTau2 hatTau3 hatTau3_add' hatTau3_neg' hatTau3_smul',
    T_comp_eq hatTau3 hatTau2 hatTau2_add hatTau2_neg hatTau2_smul,
    PL_ofColour_vIdem, sub_eq_add_neg]
  have hb := tau23_bracket_on_vIdem
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp only [co_x0, co_x1, co_x2, co_x3, add_x0, add_x1, add_x2, add_x3,
      neg_x0, neg_x1, neg_x2, neg_x3, smul_x0, smul_x1, smul_x2, smul_x3]
  · rw [hatTau3_smul', hatTau2_smul, hatTau2_smul, hatTau3_smul',
      hatTau1_smul]
    have h2 : (1 / 2 : ℂ) • hatTau2 (hatTau3 vIdem)
        + (-((1 / 2 : ℂ) • hatTau3 (hatTau2 vIdem)))
        = (1 / 2 : ℂ) • (hatTau2 (hatTau3 vIdem)
            - hatTau3 (hatTau2 vIdem)) := by
      module
    rw [h2, hb]
    module
  · simp [hatTau1_zero, hatTau2_zero, hatTau3_zero]
  · simp [hatTau1_zero, hatTau2_zero, hatTau3_zero]
  · rw [hatTau3_smul', hatTau2_smul, hatTau2_smul, hatTau3_smul',
      hatTau1_smul]
    have h2 : ((1 / 2 : ℂ) * Complex.I) • hatTau2 (hatTau3 vIdem)
        + (-(((1 / 2 : ℂ) * Complex.I) • hatTau3 (hatTau2 vIdem)))
        = ((1 / 2 : ℂ) * Complex.I) • (hatTau2 (hatTau3 vIdem)
            - hatTau3 (hatTau2 vIdem)) := by
      module
    rw [h2, hb]
    module

/-- **eq-42 closure, bracket (3,1):** `[T_3, T_1] = -(2i) T_2`. -/
theorem T31_bracket_on_probe :
    T3 (T1 (ofColour vIdem)) - T1 (T3 (ofColour vIdem))
      = (-(2 * Complex.I)) • T2 (ofColour vIdem) := by
  unfold T1 T2 T3
  rw [T_comp_eq hatTau3 hatTau1 hatTau1_add hatTau1_neg hatTau1_smul,
    T_comp_eq hatTau1 hatTau3 hatTau3_add' hatTau3_neg' hatTau3_smul',
    PL_ofColour_vIdem, sub_eq_add_neg]
  have hb := tau31_bracket_on_vIdem
  refine Dixon.ext ?_ ?_ ?_ ?_ <;>
    simp only [co_x0, co_x1, co_x2, co_x3, add_x0, add_x1, add_x2, add_x3,
      neg_x0, neg_x1, neg_x2, neg_x3, smul_x0, smul_x1, smul_x2, smul_x3]
  · rw [hatTau1_smul, hatTau3_smul', hatTau3_smul', hatTau1_smul,
      hatTau2_smul]
    have h2 : (1 / 2 : ℂ) • hatTau3 (hatTau1 vIdem)
        + (-((1 / 2 : ℂ) • hatTau1 (hatTau3 vIdem)))
        = (1 / 2 : ℂ) • (hatTau3 (hatTau1 vIdem)
            - hatTau1 (hatTau3 vIdem)) := by
      module
    rw [h2, hb]
    module
  · simp [hatTau1_zero, hatTau2_zero, hatTau3_zero]
  · simp [hatTau1_zero, hatTau2_zero, hatTau3_zero]
  · rw [hatTau1_smul, hatTau3_smul', hatTau3_smul', hatTau1_smul,
      hatTau2_smul]
    have h2 : ((1 / 2 : ℂ) * Complex.I) • hatTau3 (hatTau1 vIdem)
        + (-(((1 / 2 : ℂ) * Complex.I) • hatTau1 (hatTau3 vIdem)))
        = ((1 / 2 : ℂ) * Complex.I) • (hatTau3 (hatTau1 vIdem)
            - hatTau1 (hatTau3 vIdem)) := by
      module
    rw [h2, hb]
    module

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionSU2NonMixing.T12_bracket_on_probe' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionSU2NonMixing.T12_bracket_on_probe

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionSU2NonMixing.T23_bracket_on_probe' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionSU2NonMixing.T23_bracket_on_probe

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionSU2NonMixing.T31_bracket_on_probe' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionSU2NonMixing.T31_bracket_on_probe

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionSU2NonMixing.co_comm_PL' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionSU2NonMixing.co_comm_PL

end PhysicsSM.Draft.NullEdge.CompositionSU2NonMixing
