import PhysicsSM.Draft.NullEdge.CompositionCl10Probe

/-!
# P4/P3 step 2: the `j = 2` Cl(10) block and the eq-40 twisted partner

**Status: DRAFT probe extension** of `CompositionCl10Probe` (working ordering
(a), `B_j = L_{i e_7} o betaHat_j`).

Contents:
1. `B2a = L_{i e_7} o betaHat_2` and its dagger, extending the validated
   `j = 1` block to `j = 2` (`betaHat_2 = omega‡ i i_1` per the landed
   `CompositionWeakCAR` convention).
2. CAR probes on the mode-plane state `ofColour vIdem`: like-anticommutator
   `{A_1, B_2a} = 0`, mixed diagonal `{B_2a, B_2a‡} = delta_22 = 1`
   (identity action: the probe coordinate returns the state's own value
   `1/2`), and the mixed OFF-diagonal `{B_1a, B_2a‡} = delta_12 = 0`.
3. The eq-40 i-twisted mixing partner
   `MixT11 = i A_1‡ B_1 - i B_1‡ A_1` - the second generator of the
   proton-decay pair at `j = k = 1`. KERNEL RESULT: nonzero and
   colour-supported, witness `x2.re.c3 = 1/4`, `x2.im.c4 = -1/4` - the
   twisted colour value is `-i` times the `Mix11` value (the pair spans the
   real 2-plane of sector rotations).

Probe discipline: statements are candidate values; a kernel refutation
displays the true value, which is then landed verbatim (values in docstrings
below record what the kernel confirmed).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionCl10Probe

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.DixonWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakCAR
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem)

set_option maxHeartbeats 64000000
set_option maxRecDepth 20000

/-- Ordering (a) for the second internal slot: `B_2 = L_{i e_7} o betaHat_2`. -/
def B2a (d : Dixon) : Dixon := Lie7 (betaHat2 d)

/-- Dagger of `B_2` in ordering (a): `betaHat_2‡` then the reversed colour
factor (mirroring the landed `B1aDag` pattern). -/
def B2aDag (d : Dixon) : Dixon := betaHat2dag (Lie7 d)

/-- **Probe: like-CAR `{A_1, B_2a}` on the mode-plane state, `x0.re.c0`.** -/
theorem probe_A1_B2a_on_vIdem_c0 :
    (A1 (B2a (ofColour vIdem)) + B2a (A1 (ofColour vIdem))).x0.re.c0 = 0 := by
  simp (maxSteps := 10000000) [A1, B2a, Lie7, ie7, betaHat2, co, R1, R2, Idix,
    ofColour, hatTau3, hatOmega, hatOmegaDag, i1, i2, i3, alpha1, alpha2,
    alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

/-- **Probe: mixed diagonal `{B_2a, B_2a‡}` = `delta_22` identity action** -
the probe coordinate should return the state's own value `1/2`. -/
theorem probe_mixed_B2a_c0 :
    (B2a (B2aDag (ofColour vIdem)) + B2aDag (B2a (ofColour vIdem))).x0.re.c0
      = 1 / 2 := by
  simp (maxSteps := 10000000) [B2a, B2aDag, Lie7, ie7, betaHat2, betaHat2dag,
    co, R1, R2, Idix, ofColour, hatTau3, hatOmega, hatOmegaDag, i1, i2, i3,
    alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]
  ring_nf

/-- **Probe: mixed off-diagonal `{B_1a, B_2a‡}` = `delta_12 = 0`.** -/
theorem probe_cross_B1a_B2aDag_c0 :
    (B1a (B2aDag (ofColour vIdem)) + B2aDag (B1a (ofColour vIdem))).x0.re.c0
      = 0 := by
  simp (maxSteps := 10000000) [B1a, B2aDag, Lie7, ie7, betaHat1, betaHat2dag,
    co, R1, R2, Idix, ofColour, hatTau3, hatOmega, hatOmegaDag, i1, i2, i3,
    alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

/-- The eq-40 i-twisted mixing partner
`MixT_11 = i A_1‡ B_1 - i B_1‡ A_1` (proton-decay generator pair, second
member, `j = k = 1`, working ordering (a)). -/
def MixT11 (d : Dixon) : Dixon :=
  Complex.I • A1dag (B1a d) + (-(Complex.I • B1aDag (A1 d)))

/-- **KERNEL WITNESS: `MixT11` maps the mode-plane state into the `i_2`
`H`-slot with colour coordinate `e_3` value `1/4`** - the i-twisted partner
is nonzero and colour-supported, like `Mix11`. -/
theorem MixT11_witness_x2rec3 : (MixT11 (ofColour vIdem)).x2.re.c3 = 1 / 4 := by
  simp (maxSteps := 10000000) [MixT11, A1dag, A1, B1a, B1aDag, betaHat1dagOp,
    Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour, hatTau3, hatOmega,
    hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag,
    alpha3_dag, PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]
  ring_nf

/-- **KERNEL WITNESS: `x2.im.c4 = -1/4`.** Together with `x2.re.c3 = 1/4`
the twisted colour value is `(e_3 - i e_4)/4 = -i (e_4 + i e_3)/4` - exactly
`-i` times the landed `Mix11` value: the eq-40 pair spans the real 2-plane of
sector rotations, as the `sigma_1`/`sigma_2` structure requires. -/
theorem MixT11_witness_x2imc4 : (MixT11 (ofColour vIdem)).x2.im.c4 = -1 / 4 := by
  simp (maxSteps := 10000000) [MixT11, A1dag, A1, B1a, B1aDag, betaHat1dagOp,
    Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour, hatTau3, hatOmega,
    hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag,
    alpha3_dag, PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]
  ring_nf

/-- Kernel-zero coordinate `x2.re.c4` (`Mix11`'s real witness slot; the
twist rotates it away). -/
theorem MixT11_scan_x2rec4 : (MixT11 (ofColour vIdem)).x2.re.c4 = 0 := by
  simp (maxSteps := 10000000) [MixT11, A1dag, A1, B1a, B1aDag, betaHat1dagOp,
    Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour, hatTau3, hatOmega,
    hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag,
    alpha3_dag, PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

/-- Kernel-zero coordinate `x2.im.c3` (the twist moved the witness off the
`Mix11` coordinates and onto the `c3`-real / `c4`-imaginary pair). -/
theorem MixT11_scan_x2imc3 : (MixT11 (ofColour vIdem)).x2.im.c3 = 0 := by
  simp (maxSteps := 10000000) [MixT11, A1dag, A1, B1a, B1aDag, betaHat1dagOp,
    Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour, hatTau3, hatOmega,
    hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag,
    alpha3_dag, PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

/-- The twisted mixing generator is not the zero operator (from the witness). -/
theorem MixT11_ne_zero : MixT11 (ofColour vIdem) ≠ 0 := by
  intro h
  have hc : (MixT11 (ofColour vIdem)).x2.re.c3 = (0 : ℝ) := by
    rw [h]; rfl
  rw [MixT11_witness_x2rec3] at hc
  norm_num at hc

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionCl10Probe.probe_mixed_B2a_c0' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionCl10Probe.probe_mixed_B2a_c0

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionCl10Probe.probe_cross_B1a_B2aDag_c0' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionCl10Probe.probe_cross_B1a_B2aDag_c0

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionCl10Probe.MixT11_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionCl10Probe.MixT11_ne_zero

end PhysicsSM.Draft.NullEdge.CompositionCl10Probe
