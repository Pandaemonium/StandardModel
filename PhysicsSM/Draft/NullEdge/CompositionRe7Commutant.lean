import PhysicsSM.Draft.NullEdge.CompositionCl10Probe

/-!
# The `R_{e7}` commutant selection (P3 H-upgrade, step 1 probes)

**Status: DRAFT probe battery (pre-registered in the S2b design note,
lit cycle 3).** Furey-Hughes 2210.10126 (full text, chunk 5): commutation
with the RIGHT multiplication `R_{e7}` is equivalent to grade-involution
invariance and SELECTS the `u(3) = su(3)_C + u(1)_{B-L}` subalgebra inside
the `su(4)` of colour bilinears. If the same selection separates our landed
colour bilinears (commute) from the eq-40 mixing generators (do not), the
exclusion theorem's hypothesis H upgrades from interpretive prose to an
algebraic characterization: the SM-preserved subalgebra is the
`R_{e7}`-commutant.

KERNEL RESULTS (free-variable probes, this file):

1. ALL probed colour bilinears lie in the `R_{e7}` commutant GLOBALLY:
   diagonal `a_1‡ a_1`, bare off-diagonal `a_1‡ a_2`, and both eq-41
   Gell-Mann combinations `lambda_1`, `lambda_2`.
2. The SINGLE ladder `a_1` is in NEITHER the commutant nor the
   anticommutant: its grading is ASSOCIATOR-SPLIT (commutes on the
   `{c0, c3, c4, c7}` coordinate planes, anticommutes on
   `{c1, c2, c5, c6}`). The naive grade-involution reading is not literal
   for composition operators; the SELECTION nevertheless works at the
   gauge-generator (bilinear) level, which is what the physics uses.
3. RESOLVED (kernel, this file): the eq-40 mixing generator `Mix11`
   COMMUTES with `co R_{e7}` on the probe state (full-element probe green) -
   the Re7/grade-involution selection does NOT exclude the mixing
   generators. See `MixComm_full_on_probe` for the precise finding and its
   consequence for the exclusion-theorem design.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionRe7Commutant

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

/-- The REAL octonion unit `e7 = e111` as a complex octonion (no `i`). -/
def e7c : ComplexOctonion := ⟨⟨0,0,0,0,0,0,0,1⟩, ⟨0,0,0,0,0,0,0,0⟩⟩

/-- Right multiplication by `e7` (the grade-involution implementer). -/
def Re7 (z : ComplexOctonion) : ComplexOctonion := z * e7c

/-- **Probe 1 (free z): the diagonal colour bilinear commutes with `R_{e7}`.** -/
theorem probe_lam11_Re7_comm (z : ComplexOctonion) :
    Re7 (alpha1_dag * (alpha1 * z)) = alpha1_dag * (alpha1 * Re7 z) := by
  unfold Re7 e7c
  ext <;>
    simp [alpha1, alpha1_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- **KERNEL FACT: the bare off-diagonal bilinear commutes too.** -/
theorem probe_lam12_Re7_comm (z : ComplexOctonion) :
    Re7 (alpha1_dag * (alpha2 * z)) = alpha1_dag * (alpha2 * Re7 z) := by
  unfold Re7 e7c
  ext <;>
    simp [alpha1_dag, alpha2, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- **KERNEL FACT: the eq-41 Gell-Mann combination
`lambda_1 = -a_2‡ a_1 - a_1‡ a_2` commutes with `R_{e7}` globally.** -/
theorem probe_lamGM1_Re7_comm (z : ComplexOctonion) :
    Re7 (-(alpha2_dag * (alpha1 * z)) + (-(alpha1_dag * (alpha2 * z))))
      = -(alpha2_dag * (alpha1 * Re7 z))
        + (-(alpha1_dag * (alpha2 * Re7 z))) := by
  unfold Re7 e7c
  ext <;>
    simp [alpha1, alpha2, alpha1_dag, alpha2_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- **KERNEL FACT: the i-twisted partner
`lambda_2 = i a_2‡ a_1 - i a_1‡ a_2` commutes with `R_{e7}` globally.** -/
theorem probe_lamGM2_Re7_comm (z : ComplexOctonion) :
    Re7 (Complex.I • (alpha2_dag * (alpha1 * z))
          + (-(Complex.I • (alpha1_dag * (alpha2 * z)))))
      = Complex.I • (alpha2_dag * (alpha1 * Re7 z))
        + (-(Complex.I • (alpha1_dag * (alpha2 * Re7 z)))) := by
  unfold Re7 e7c
  ext <;>
    simp [alpha1, alpha2, alpha1_dag, alpha2_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im, ComplexOctonion.complex_smul_re,
      ComplexOctonion.complex_smul_im] <;> ring

/-- **KERNEL NO-GO: the single ladder is in NEITHER the commutant nor the
anticommutant.** Free-z probes refuted BOTH `Re7 (a1 z) = a1 (Re7 z)`
(residues on the `{c1, c2, c5, c6}` planes) and
`Re7 (a1 z) = -(a1 (Re7 z))` (residues on the `{c0, c3, c4, c7}` planes):
the composition operator `L_{a1}` has ASSOCIATOR-SPLIT grading - it
commutes with `R_{e7}` on half the coordinate planes and anticommutes on
the other half. (The naive "odd grade anticommutes" reading is NOT literal
for composition operators on the octonions.) Concrete witness below: at
`z = 1` the commutator is nonzero. -/
theorem alpha1_not_in_Re7_commutant :
    ∃ z : ComplexOctonion, Re7 (alpha1 * z) ≠ alpha1 * Re7 z := by
  refine ⟨⟨⟨0,0,1,0,0,0,0,0⟩,⟨0,0,0,0,0,0,0,0⟩⟩, fun h => ?_⟩
  have hc : (Re7 (alpha1 * ⟨⟨0,0,1,0,0,0,0,0⟩,⟨0,0,0,0,0,0,0,0⟩⟩)).re.c1
      = (alpha1 * Re7 ⟨⟨0,0,1,0,0,0,0,0⟩,⟨0,0,0,0,0,0,0,0⟩⟩).re.c1 := by
    rw [h]
  simp [Re7, e7c, alpha1, ComplexOctonion.mul_re,
    ComplexOctonion.mul_im] at hc
  norm_num at hc

theorem alpha1_not_in_Re7_anticommutant :
    ∃ z : ComplexOctonion, Re7 (alpha1 * z) ≠ -(alpha1 * Re7 z) := by
  refine ⟨⟨⟨0,0,0,1,0,0,0,0⟩,⟨0,0,0,0,0,0,0,0⟩⟩, fun h => ?_⟩
  have hc : (Re7 (alpha1 * ⟨⟨0,0,0,1,0,0,0,0⟩,⟨0,0,0,0,0,0,0,0⟩⟩)).re.c0
      = (-(alpha1 * Re7 ⟨⟨0,0,0,1,0,0,0,0⟩,⟨0,0,0,0,0,0,0,0⟩⟩)).re.c0 := by
    rw [h]
  simp [Re7, e7c, alpha1, ComplexOctonion.mul_re,
    ComplexOctonion.mul_im] at hc
  norm_num at hc

/-! ## Dixon-level contrast: the eq-40 mixing generator vs the commutant

The colour-slot lift of `R_{e7}` acts slotwise; the commutator with the
landed mixing generator `Mix11` is probed on the witness state at the
`x2`-slot colour coordinates (where `Mix11`'s value lives). Discovery
probes: `= 0` candidates; refutations display the true commutator values. -/

/-- The colour-slot lift of `R_{e7}` to the Dixon carrier. -/
def coRe7 (d : Dixon) : Dixon := co Re7 d

/-- Kernel-zero: the commutator `[coRe7, Mix11]` vanishes at the witness
coordinate `x2.re.c3` (the `Mix11` value plane is commutator-silent). -/
theorem MixComm_scan_x2rec3 :
    (coRe7 (Mix11 (ofColour vIdem))
      + (-(Mix11 (coRe7 (ofColour vIdem))))).x2.re.c3 = 0 := by
  simp (maxSteps := 10000000) [coRe7, Re7, e7c, Mix11, A1dag, A1, B1a,
    B1aDag, betaHat1dagOp, Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour,
    hatTau3, hatOmega, hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3,
    alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]
  ring_nf

/-- Kernel-zero: `x2.re.c4` (same). -/
theorem MixComm_scan_x2rec4 :
    (coRe7 (Mix11 (ofColour vIdem))
      + (-(Mix11 (coRe7 (ofColour vIdem))))).x2.re.c4 = 0 := by
  simp (maxSteps := 10000000) [coRe7, Re7, e7c, Mix11, A1dag, A1, B1a,
    B1aDag, betaHat1dagOp, Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour,
    hatTau3, hatOmega, hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3,
    alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

/-- Discovery probe: split-plane coordinate `x2.re.c1`. -/
theorem MixComm_scan_x2rec1 :
    (coRe7 (Mix11 (ofColour vIdem))
      + (-(Mix11 (coRe7 (ofColour vIdem))))).x2.re.c1 = 0 := by
  simp (maxSteps := 10000000) [coRe7, Re7, e7c, Mix11, A1dag, A1, B1a,
    B1aDag, betaHat1dagOp, Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour,
    hatTau3, hatOmega, hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3,
    alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

/-- Discovery probe: split-plane coordinate `x2.im.c6`. -/
theorem MixComm_scan_x2imc6 :
    (coRe7 (Mix11 (ofColour vIdem))
      + (-(Mix11 (coRe7 (ofColour vIdem))))).x2.im.c6 = 0 := by
  simp (maxSteps := 10000000) [coRe7, Re7, e7c, Mix11, A1dag, A1, B1a,
    B1aDag, betaHat1dagOp, Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour,
    hatTau3, hatOmega, hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3,
    alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

/-- **KERNEL FINDING (honest negative for the naive H-upgrade design):
the eq-40 mixing generator `Mix11` COMMUTES with the `R_{e7}` lift on the
probe state** - the full 64-coordinate commutator vanishes. The
grade-involution/`R_{e7}` selection therefore does NOT separate the
mixing generators from the non-mixing set at composition level: it selects
`u(3)` within the colour sector (the paper's actual claim, kernel-validated
above), but the exclusion of the eq-40 proton-decay directions needs a
FINER principle (S3-commutant, or the slot census). The extrapolation
"Re7-commutant = the full SM-preserved subalgebra" was OUR design
hypothesis, not the paper's, and the kernel refutes it. -/
theorem MixComm_full_on_probe :
    coRe7 (Mix11 (ofColour vIdem))
      + (-(Mix11 (coRe7 (ofColour vIdem)))) = 0 := by
  refine Dixon.ext ?_ ?_ ?_ ?_ <;> ext <;>
    simp (maxSteps := 10000000) [coRe7, Re7, e7c, Mix11, A1dag, A1, B1a,
      B1aDag, betaHat1dagOp, Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour,
      hatTau3, hatOmega, hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3,
      alpha1_dag, alpha2_dag, alpha3_dag,
      PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im,
      ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;>
    ring_nf

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionRe7Commutant.MixComm_full_on_probe' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionRe7Commutant.MixComm_full_on_probe

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionRe7Commutant.probe_lam11_Re7_comm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionRe7Commutant.probe_lam11_Re7_comm

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionRe7Commutant.probe_lamGM1_Re7_comm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionRe7Commutant.probe_lamGM1_Re7_comm

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionRe7Commutant.probe_lamGM2_Re7_comm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionRe7Commutant.probe_lamGM2_Re7_comm

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionRe7Commutant.alpha1_not_in_Re7_commutant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionRe7Commutant.alpha1_not_in_Re7_commutant

end PhysicsSM.Draft.NullEdge.CompositionRe7Commutant
