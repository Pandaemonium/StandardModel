import PhysicsSM.Draft.NullEdge.CompositionTransitionCensus

/-!
# P3 step 4: the full eq-39/eq-40 transition-census table

Target statements for the Aristotle job `transition-census-ext-20260718`.

Context. `CompositionTransitionCensus` (Aristotle e0376e38, integrated)
established the five single-excitation slots on `vt = ofColour vIdem` and two
census facts: `Mix11 slotVL = slotDbar1 + residual` with explicit nonzero
`1/8` residual coordinates, and `(Mix11 slotDbar1).x0 = slotVL.x0` (colour
slot only).  The S2b design note (CORRECTION 10) demoted the Re7-commutant
route; the slot census is now a primary handle on the eq-40 exclusion layer:
"mixing generators cross the quark/lepton slot partition".

This module states the completion of the census table: nonzero-ness of all
five slots, the full-slot upgrade of the landed partial, the
distinct-colour-action kills, and the sector-rotation comparison between
`MixT11` and `Mix11`.

Pre-registered honesty license: every expected equality below may instead be
returned as an explicit residual decomposition with named nonzero
coordinates, following the `mix11_slotVL_census` pattern.  A refutation with
an exact residual is a success outcome.  Do not weaken definitions.

Every `s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionTransitionCensusExt

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.DixonWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakCAR
open PhysicsSM.Draft.NullEdge.CompositionCl10Probe
open PhysicsSM.Draft.NullEdge.CompositionTransitionCensus
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem)

set_option maxHeartbeats 64000000
set_option maxRecDepth 20000

/-! ## 1. Slot census

The three colour single-excitation definitions unexpectedly vanish exactly.
Thus the requested nonvanishing statements are false; the corrected exact
census entries below replace them.  The lepton excitation remains nonzero. -/

private lemma co_mul_zero (a : ComplexOctonion) :
    co (fun z => a * z) 0 = 0 := by
  ext <;> simp [co, ComplexOctonion.mul_re, ComplexOctonion.mul_im]

private lemma R1_zero_census : R1 0 = 0 := by
  rw [R1_slots]
  ext <;> simp

private lemma R2_zero_census : R2 0 = 0 := by
  rw [R2_slots]
  ext <;> simp

private lemma co_hatTau3_zero : co hatTau3 0 = 0 := by
  ext <;> simp [co, hatTau3, hatOmega_zero, hatOmegaDag_zero]

private lemma betaHat1_zero_census : betaHat1 0 = 0 := by
  rw [betaHat1, R2_zero_census, co_hatTau3_zero, R1_zero_census]
  ext <;> simp

private lemma betaHat1dagOp_zero_census : betaHat1dagOp 0 = 0 := by
  rw [betaHat1dagOp, R2_zero_census, co_hatTau3_zero, R1_zero_census]
  ext <;> simp

private lemma Lie7_zero_census : Lie7 0 = 0 := co_mul_zero ie7
private lemma A1_zero_census : A1 0 = 0 := co_mul_zero alpha1
private lemma A1dag_zero_census : A1dag 0 = 0 := co_mul_zero alpha1_dag
private lemma B1a_zero_census : B1a 0 = 0 := by
  rw [B1a, betaHat1_zero_census, Lie7_zero_census]
private lemma B1aDag_zero_census : B1aDag 0 = 0 := by
  rw [B1aDag, Lie7_zero_census, betaHat1dagOp_zero_census]
private lemma Mix11_zero_census : Mix11 0 = 0 := by
  rw [Mix11, B1a_zero_census, A1_zero_census, A1dag_zero_census,
    B1aDag_zero_census]
  ext <;> simp
private lemma MixT11_zero_census : MixT11 0 = 0 := by
  rw [MixT11, B1a_zero_census, A1_zero_census, A1dag_zero_census,
    B1aDag_zero_census]
  ext <;> simp

/-- Corrected census: the nominal first colour excitation vanishes exactly. -/
theorem slotDbar1_eq_zero : slotDbar1 = 0 := by
  ext <;>
  simp (maxSteps := 10000000) [slotDbar1, A1dag, co, ofColour,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, alpha1_dag,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- Corrected census: the nominal second colour excitation vanishes exactly. -/
theorem slotDbar2_eq_zero : slotDbar2 = 0 := by
  ext <;>
  simp (maxSteps := 10000000) [slotDbar2, A2dag, co, ofColour,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, alpha2_dag,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- Corrected census: the nominal third colour excitation vanishes exactly. -/
theorem slotDbar3_eq_zero : slotDbar3 = 0 := by
  ext <;>
  simp (maxSteps := 10000000) [slotDbar3, A3dag, co, ofColour,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, alpha3_dag,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- The lepton single-excitation slot `E-_L` is nonzero. -/
theorem slotEL_ne_zero : slotEL ≠ 0 := by
  intro h
  have hc : slotEL.x1.re.c0 = (0 : ℝ) := by rw [h]; rfl
  simp (maxSteps := 10000000) [slotEL, B2aDag, betaHat2dag, Lie7, ie7, co,
    R1, ofColour, hatOmega, i1, alpha1, alpha2, alpha3,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] at hc
  norm_num at hc

/-! ## 2. The `Mix11` column -/

/-- Corrected full-slot census for the first nominal colour excitation: its
image is zero.  Since `slotVL ≠ 0`, this refutes the proposed full upgrade. -/
theorem mix11_slotDbar1_full_census : Mix11 slotDbar1 = 0 := by
  rw [slotDbar1_eq_zero, Mix11_zero_census]

/-- The first nominal colour excitation does not map to `slotVL`. -/
theorem mix11_slotDbar1_ne_slotVL : Mix11 slotDbar1 ≠ slotVL := by
  rw [mix11_slotDbar1_full_census]
  exact Ne.symm slotVL_ne_zero

/-- Distinct-colour census entry (vacuous because this slot is zero). -/
theorem mix11_slotDbar2 : Mix11 slotDbar2 = 0 := by
  rw [slotDbar2_eq_zero, Mix11_zero_census]

/-- Distinct-colour census entry (vacuous because this slot is zero). -/
theorem mix11_slotDbar3 : Mix11 slotDbar3 = 0 := by
  rw [slotDbar3_eq_zero, Mix11_zero_census]

/-- Exact residual in the second lepton-slot census. -/
def slotELResidual : Dixon := Mix11 slotEL

/-- Honest partition census: the expected zero is refuted by four explicit
coordinates of the exact residual. -/
theorem mix11_slotEL_census :
    Mix11 slotEL = slotELResidual ∧
      slotELResidual.x0.re.c3 = 1 / 4 ∧
      slotELResidual.x0.im.c4 = 1 / 4 ∧
      slotELResidual.x3.re.c4 = 1 / 4 ∧
      slotELResidual.x3.im.c3 = -1 / 4 := by
  constructor
  · rfl
  repeat' apply And.intro
  all_goals
    simp (maxSteps := 10000000) [slotELResidual, Mix11, slotEL, A1dag, A1,
      B1a, B1aDag, B2aDag, betaHat1dagOp, betaHat2dag, Lie7, ie7, betaHat1,
      R1_slots, R2_slots, co, ofColour, hatTau3, hatOmega, hatOmegaDag,
      alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
      PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im,
      ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;>
    ring

/-! ## 3. The `MixT11` column (sector rotation) -/

private lemma first_mix_term_vt_zero :
    A1dag (B1a (ofColour vIdem)) = 0 := by
  ext <;>
  simp (maxSteps := 10000000) [A1dag, B1a, Lie7, ie7, betaHat1, R1_slots,
    R2_slots, co, ofColour, hatTau3, hatOmega, hatOmegaDag, alpha1, alpha2,
    alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;> ring

/-- Sector-rotation law on the vacuum. -/
theorem mixT11_vt_eq_negI_mix11 :
    MixT11 (ofColour vIdem) = (-Complex.I) • Mix11 (ofColour vIdem) := by
  rw [MixT11, Mix11, first_mix_term_vt_zero]
  ext <;> simp [ComplexOctonion.complex_smul_re,
    ComplexOctonion.complex_smul_im] <;> ring

private lemma first_mix_term_slotVL_zero : A1dag (B1a slotVL) = 0 := by
  ext <;>
  simp (maxSteps := 10000000) [slotVL, A1dag, B1a, B1aDag,
    betaHat1dagOp, Lie7, ie7, betaHat1, R1_slots, R2_slots, co, ofColour,
    hatTau3, hatOmega, hatOmegaDag, alpha1, alpha2, alpha3, alpha1_dag,
    alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;> ring

/-- Sector-rotation law on the upper doublet slot. -/
theorem mixT11_slotVL_eq_negI_mix11 :
    MixT11 slotVL = (-Complex.I) • Mix11 slotVL := by
  rw [MixT11, Mix11, first_mix_term_slotVL_zero]
  ext <;> simp [ComplexOctonion.complex_smul_re,
    ComplexOctonion.complex_smul_im] <;> ring

/-- Sector-rotation law on the first nominal quark slot; both sides vanish. -/
theorem mixT11_slotDbar1_eq_negI_mix11 :
    MixT11 slotDbar1 = (-Complex.I) • Mix11 slotDbar1 := by
  rw [slotDbar1_eq_zero, MixT11_zero_census, Mix11_zero_census]
  ext <;> simp

end PhysicsSM.Draft.NullEdge.CompositionTransitionCensusExt
