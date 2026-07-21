import PhysicsSM.Draft.NullEdge.CompositionSU2

/-!
# P4 step 1: the Cl(10) `B_j` composition-order probe (eq 37)

**Status: DRAFT probe.** Furey 1806.00612 eq 37 defines the Cl(10) ladder
operators `A_i = a_i|I` (colour ladders; on the Dixon algebra these are the
slot-lifted composition operators, whose operator CAR is landed in
`CompositionColorCAR`) and `B_j = i e_7|beta_j` - a bar operator whose LEFT
slot is the colour element `i e_7` and whose RIGHT slot is the weak `beta_j`.

The PRE-REGISTERED question (plan P4, recorded 2026-07-18): in composition
semantics the element `beta_j` is unfaithful (anti-Fock), so `B_j` must be a
COMPOSITION of the `i e_7` left-multiplication with the operator `betaHat_j` -
in WHICH order? The bar form `(x|y) z = x z y` suggests LEFT-mult-then-right-
side-beta, i.e. `B_j = L_{i e_7} o betaHat_j` (apply the weak operator, then
left-multiply by `i e_7`), but the alternative order must be kernel-tested,
not assumed.

This module defines BOTH candidates and probes the cheapest discriminating
Cl(10) relation: `{A_1, B_1} = 0` (A- and B-type ladders anticommute, eq 37ff
"trivial to confirm" - verify, do not trust) evaluated on the concrete
mode-plane state `ofColour vIdem`. A kernel refutation of one (or both)
orderings is the discriminator; refutation of BOTH triggers the pre-registered
re-derivation kill condition.
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

/-- The colour element `i e_7` (`e_7 = e_111 = c7` in the XOR basis). -/
def ie7 : ComplexOctonion := ⟨⟨0,0,0,0,0,0,0,0⟩, ⟨0,0,0,0,0,0,0,1⟩⟩

/-- Left multiplication by `i e_7`, slot-lifted to the Dixon algebra. -/
def Lie7 (d : Dixon) : Dixon := co (fun z => ie7 * z) d

/-- The colour ladder `A_1 = a_1|I` slot-lifted (left multiplication by
`alpha_1`). -/
def A1 (d : Dixon) : Dixon := co (fun z => alpha1 * z) d

/-- **Candidate ordering (a):** `B_1 = L_{i e_7} o betaHat_1`. -/
def B1a (d : Dixon) : Dixon := Lie7 (betaHat1 d)

/-- **Candidate ordering (b):** `B_1 = betaHat_1 o L_{i e_7}`. -/
def B1b (d : Dixon) : Dixon := betaHat1 (Lie7 d)

/-- **Probe (a):** does `{A_1, B_1a}` vanish on the mode-plane state? A
refutation kills ordering (a) on this slot. -/
theorem probe_A1_B1a_on_vIdem_c0 :
    (A1 (B1a (ofColour vIdem)) + B1a (A1 (ofColour vIdem))).x0.re.c0 = 0 := by
  simp [A1, B1a, Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour,
    hatTau3, hatOmega, hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3, alpha1_dag,
    alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

/-- **Probe (b):** the mirror ordering. -/
theorem probe_A1_B1b_on_vIdem_c0 :
    (A1 (B1b (ofColour vIdem)) + B1b (A1 (ofColour vIdem))).x0.re.c0 = 0 := by
  simp [A1, B1b, Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour,
    hatTau3, hatOmega, hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3, alpha1_dag,
    alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

/-! ## The mixed-CAR discriminator: `{B_1, B_1‡}` on the probe coordinate

The like-anticommutator `{A_1, B_1} = 0` passed for BOTH orderings (kernel,
above) - the ordering question moves to the mixed CAR. The `‡` of the
composite: `B_1‡ = (L_{i e_7} o betaHat_1)‡ = betaHat_1‡ o L_{(i e_7)‡}` with
`(i e_7)‡ = (-i)(-e_7) = i e_7` (self-daggered), so the candidates are

  (a‡) `B1aDag = betaHat1dag-op o L_{i e_7}`  (dagger of ordering (a))
  (b‡) `B1bDag = L_{i e_7} o betaHat1dag-op`  (dagger of ordering (b))

where `betaHat1dag-op d = (1/2)((R2 d) + I (R1 (co hatTau3 d)))` (the operator
mirror of `betaHat1` with the `‡` signs, per the landed `betaHat1dag`
convention in `CompositionWeakCAR`). Probe: the mixed anticommutator's
x0-coordinate on the mode-plane state; `delta_11 = 1`-behaviour would give a
nonzero value tied to the state's norm, and the two orderings may now differ. -/

/-- The operator mirror of `betaHat1dag`. -/
def betaHat1dagOp (d : Dixon) : Dixon :=
  (1 / 2 : ℂ) • (R2 d + Complex.I • R1 (co hatTau3 d))

/-- Dagger candidate for ordering (a). -/
def B1aDag (d : Dixon) : Dixon := betaHat1dagOp (Lie7 d)

/-- Dagger candidate for ordering (b). -/
def B1bDag (d : Dixon) : Dixon := Lie7 (betaHat1dagOp d)

/-- **Mixed CAR (kernel, ordering (a)): `{B1a, B1aDag}` acts as the IDENTITY
on the probe coordinate** - the value is `1/2 = (ofColour vIdem).x0.re.c0`,
i.e. `delta_11 = 1` behaviour. Together with the like-CAR probe this makes
ordering (a) a viable eq-37 realization on the probed slots. -/
theorem probe_mixed_B1a_c0 :
    (B1a (B1aDag (ofColour vIdem)) + B1aDag (B1a (ofColour vIdem))).x0.re.c0
      = 1 / 2 := by
  simp (maxSteps := 10000000) [B1a, B1aDag, betaHat1dagOp, Lie7, ie7, betaHat1, co, R1, R2, Idix,
    ofColour, hatTau3, hatOmega, hatOmegaDag, i1, i2, i3, alpha1, alpha2,
    alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]
  ring_nf

/-- **Mixed CAR (kernel, ordering (b)): also `delta_11 = 1` behaviour**
(`1/2` = the state coordinate). BOTH orderings satisfy the probed like AND
mixed CAR slots - the eq-37 composition order is NOT discriminated by the
CAR at this level (recorded finding; ordering (a), the bar-form-natural
`L_{i e_7} o betaHat`, is the working convention). -/
theorem probe_mixed_B1b_c0 :
    (B1b (B1bDag (ofColour vIdem)) + B1bDag (B1b (ofColour vIdem))).x0.re.c0
      = 1 / 2 := by
  simp (maxSteps := 10000000) [B1b, B1bDag, betaHat1dagOp, Lie7, ie7, betaHat1, co, R1, R2, Idix,
    ofColour, hatTau3, hatOmega, hatOmegaDag, i1, i2, i3, alpha1, alpha2,
    alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]
  ring_nf

/-! ## The P3 opening atom: the eq-40 mixing generator exists (nonvacuity)

Eq 40's proton-decay generators mix A- and B-type ladders:
`A_1‡ B_1 + B_1‡ A_1` (+ the `i`-twisted partner). The future exclusion
theorem ("distinct actions do not mix" removes exactly these) needs a
NONVACUITY witness first: the mixing generator is NOT the zero operator on
the probed sector. `A_1‡` = the slot-lifted daggered colour ladder. -/

/-- The daggered colour ladder `A_1‡` slot-lifted. -/
def A1dag (d : Dixon) : Dixon := co (fun z => alpha1_dag * z) d

/-- The eq-40 mixing generator `M_11 = A_1‡ B_1 + B_1‡ A_1` (working ordering
(a)). -/
def Mix11 (d : Dixon) : Dixon := A1dag (B1a d) + B1aDag (A1 d)

/-- Coordinate scan for the nonvacuity witness (batch; refuted rows display
the true values). x1.re.c1 is kernel-zero (first probe). -/
theorem Mix11_scan_x1rec0 : (Mix11 (ofColour vIdem)).x1.re.c0 = 0 := by
  simp (maxSteps := 10000000) [Mix11, A1dag, A1, B1a, B1aDag, betaHat1dagOp,
    Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour, hatTau3, hatOmega,
    hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag,
    alpha3_dag, PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

theorem Mix11_scan_x1imc0 : (Mix11 (ofColour vIdem)).x1.im.c0 = 0 := by
  simp (maxSteps := 10000000) [Mix11, A1dag, A1, B1a, B1aDag, betaHat1dagOp,
    Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour, hatTau3, hatOmega,
    hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag,
    alpha3_dag, PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

theorem Mix11_scan_x1imc7 : (Mix11 (ofColour vIdem)).x1.im.c7 = 0 := by
  simp (maxSteps := 10000000) [Mix11, A1dag, A1, B1a, B1aDag, betaHat1dagOp,
    Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour, hatTau3, hatOmega,
    hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag,
    alpha3_dag, PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

theorem Mix11_scan_x0imc7 : (Mix11 (ofColour vIdem)).x0.im.c7 = 0 := by
  simp (maxSteps := 10000000) [Mix11, A1dag, A1, B1a, B1aDag, betaHat1dagOp,
    Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour, hatTau3, hatOmega,
    hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag,
    alpha3_dag, PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]

/-- **The nonvacuity witness (kernel):** the mixing generator maps the
mode-plane state into the `i_2` `H`-slot with nonzero colour content -
`(Mix11 v-state).x2.re.c4 = 1/4` (full scan: the x0/x1 slots vanish; the
value lives at `x2` with colour direction `(e_4 + i e_3)/4`). The eq-40
generator provably MIXES sectors - the substrate fact the exclusion
theorem ("distinct actions do not mix" removes exactly these) builds on. -/
theorem Mix11_witness :
    (Mix11 (ofColour vIdem)).x2.re.c4 = 1 / 4 := by
  simp (maxSteps := 10000000) [Mix11, A1dag, A1, B1a, B1aDag,
    betaHat1dagOp, Lie7, ie7, betaHat1, co, R1, R2, Idix, ofColour,
    hatTau3, hatOmega, hatOmegaDag, i1, i2, i3, alpha1, alpha2, alpha3,
    alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem, mul,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im]
  ring_nf

/-- The mixing generator is not the zero operator (from the witness). -/
theorem Mix11_ne_zero : Mix11 (ofColour vIdem) ≠ 0 := by
  intro h
  have hc : (Mix11 (ofColour vIdem)).x2.re.c4 = (0 : ℝ) := by
    rw [h]; rfl
  rw [Mix11_witness] at hc
  norm_num at hc

end PhysicsSM.Draft.NullEdge.CompositionCl10Probe

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionCl10Probe.probe_A1_B1a_on_vIdem_c0' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionCl10Probe.probe_A1_B1a_on_vIdem_c0

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionCl10Probe.probe_mixed_B1a_c0' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionCl10Probe.probe_mixed_B1a_c0

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionCl10Probe.Mix11_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionCl10Probe.Mix11_ne_zero
