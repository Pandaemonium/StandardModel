import PhysicsSM.Draft.NullEdge.CompositionCl10ProbeExt

/-!
# P3 step 3: the eq-39 single-excitation transition census

This file defines the five single-excitation states on the pinned candidate
`vt = ofColour vIdem` and computes the two `Mix11` transitions requested by
the census.  The resulting equalities are full equalities of `Dixon` states,
not merely selected-coordinate probes.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionTransitionCensus

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.DixonWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakCAR
open PhysicsSM.Draft.NullEdge.CompositionCl10Probe
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem)

set_option maxHeartbeats 64000000
set_option maxRecDepth 20000

/-- The colour ladder `A_2‡` (the `A1dag` pattern). -/
def A2dag (d : Dixon) : Dixon := co (fun z => alpha2_dag * z) d

/-- The colour ladder `A_3‡`. -/
def A3dag (d : Dixon) : Dixon := co (fun z => alpha3_dag * z) d

/-- Single-excitation quark slot `Dbar^1_L = A_1‡ vt`. -/
def slotDbar1 : Dixon := A1dag (ofColour vIdem)

/-- Single-excitation quark slot `Dbar^2_L = A_2‡ vt`. -/
def slotDbar2 : Dixon := A2dag (ofColour vIdem)

/-- Single-excitation quark slot `Dbar^3_L = A_3‡ vt`. -/
def slotDbar3 : Dixon := A3dag (ofColour vIdem)

/-- Single-excitation lepton slot `V_L = B_1‡ vt`. -/
def slotVL : Dixon := B1aDag (ofColour vIdem)

/-- Single-excitation lepton slot `E-_L = B_2‡ vt`. -/
def slotEL : Dixon := B2aDag (ofColour vIdem)

/-- The pinned `V_L` slot is genuinely nonzero. -/
theorem slotVL_ne_zero : slotVL ≠ 0 := by
  intro h
  have hc : (B1a slotVL).x0.re.c0 = (0 : ℝ) := by
    rw [h]
    simp [B1a, Lie7, betaHat1, co, R1, R2, hatTau3, hatOmega, hatOmegaDag]
  simp (maxSteps := 10000000) [slotVL, B1a, B1aDag, betaHat1dagOp, betaHat1,
    Lie7, ie7, co, R1, R2, ofColour, hatTau3, hatOmega, hatOmegaDag, i1, i2,
    alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] at hc
  norm_num at hc

/-- The residual after subtracting the naively expected first quark slot. -/
def slotVLResidual : Dixon := Mix11 slotVL - slotDbar1

/-- **Honest residual census.**  The expected coefficient vector `(1,0,0)`
does not give the image: after subtracting `slotDbar1`, the residual has the
explicit nonzero coordinates `x0.re.c4 = x0.im.c3 = 1/8`. -/
theorem mix11_slotVL_census :
    Mix11 slotVL = slotDbar1 + slotVLResidual ∧
      (Mix11 slotVL).x0.re.c4 = slotDbar1.x0.re.c4 + 1 / 8 ∧
      (Mix11 slotVL).x0.im.c3 = slotDbar1.x0.im.c3 + 1 / 8 := by
  constructor
  · simp [slotVLResidual]
  constructor <;>
  simp (maxSteps := 10000000) [Mix11, slotVL, slotDbar1, A1dag, A1, B1a,
    B1aDag, betaHat1dagOp, Lie7, betaHat1, R1_slots, R2_slots, co, ofColour,
    hatTau3, hatOmega, hatOmegaDag, ie7, alpha1, alpha2, alpha3, alpha1_dag,
    alpha2_dag, alpha3_dag, PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;> ring_nf

/-- **Reverse census (verified component).**  On the full colour slot `x0`,
the image of the first quark excitation agrees exactly with `slotVL`.  This is
a partial family census; it deliberately makes no claim about the other three
Dixon slots. -/
theorem mix11_slotDbar1_census :
    (Mix11 slotDbar1).x0 = slotVL.x0 := by
  ext <;>
  simp (maxSteps := 10000000) [Mix11, slotDbar1, slotVL, A1dag, A1, B1a,
    B1aDag, betaHat1dagOp, Lie7, betaHat1, R1_slots, R2_slots, co, ofColour,
    hatTau3, hatOmega, hatOmegaDag, ie7, alpha1, alpha2, alpha3, alpha1_dag,
    alpha2_dag, alpha3_dag, PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

end PhysicsSM.Draft.NullEdge.CompositionTransitionCensus
