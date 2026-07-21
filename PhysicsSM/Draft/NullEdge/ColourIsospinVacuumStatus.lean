import PhysicsSM.Draft.NullEdge.CompositionTransitionCensus

/-!
# S2b vacuum-annihilation status: the B-ladder vacuum premise is ASYMMETRIC

Kernel findings extracted at the 2026-07-19 budget-kill harvest from the
UNVERIFIED Aristotle draft of job `5a6bb408` (`ColourIsospinFromB` targets;
artifact archived at `AgentTasks/aristotle-output/5a6bb408*`). The draft's
foundational lemma pair claimed both annihilation modes kill the pinned
colour vacuum `vt = ofColour vIdem`. The kernel verdict at this repo's pin
is SPLIT:

* `B2a_vt` (PROVEN): `B2a (ofColour vIdem) = 0` - mode 2 does annihilate
  the vacuum.
* `B1a_vt_ne_zero` (KERNEL REFUTATION): `B1a (ofColour vIdem) ≠ 0` - mode
  1 does NOT; the `x2` Dixon slot carries a nonzero coordinate
  (witnessed at `x2.re.c0`).

Consequences: the seven doublet targets of `ColourIsospinFromB` (T3
eigenvalues, ladder maps, su(2) closure) are built on the false mode-1
premise and remain OPEN as stated; the returned draft proofs are void.
Reading: `ofColour vIdem` is not a Fock vacuum for the mode-1 operator in
the current eq-37 dictionary - consistent with the eq-39/40 finding
(`CompositionTransitionCensusExt`: colour creation slots vanish - wrong
side of the idempotent). The mode-1 chart (betaHat1 / R-slot dictionary)
must be corrected before the doublet computation is re-posed; note the
ASYMMETRY (mode 2 is fine) localizes the defect to the mode-1 half.

Provenance: statements formulated from the archived draft; proofs are
this repo's own (heavy coordinate simp; the refutation inspects one
coordinate). Axioms: standard three.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ColourIsospinVacuumStatus

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

/-- **Kernel refutation.**  Mode 1 does NOT annihilate the pinned colour
vacuum: the `x2.re.c0` coordinate of `B1a (ofColour vIdem)` is nonzero.
Refutes the foundational premise of the archived `5a6bb408` draft. -/
theorem B1a_vt_ne_zero : B1a (ofColour vIdem) ≠ 0 := by
  intro h
  have hc := congrArg (fun d => d.x2.re.c0) h
  simp (maxSteps := 10000000) [B1a, Lie7, betaHat1, R1_slots, R2_slots, co,
    ofColour, hatTau3, hatOmega, hatOmegaDag, ie7, alpha1, alpha2, alpha3,
    alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] at hc

/-- Mode 2 DOES annihilate the pinned colour vacuum. -/
theorem B2a_vt : B2a (ofColour vIdem) = 0 := by
  ext <;>
  simp (maxSteps := 10000000) [B2a, Lie7, betaHat2, R1_slots, R2_slots, co,
    ofColour, hatTau3, hatOmega, hatOmegaDag, ie7, alpha1, alpha2, alpha3,
    alpha1_dag, alpha2_dag, alpha3_dag,
    PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem,
    ComplexOctonion.mul_re, ComplexOctonion.mul_im,
    ComplexOctonion.complex_smul_re, ComplexOctonion.complex_smul_im] <;>
  norm_num

end PhysicsSM.Draft.NullEdge.ColourIsospinVacuumStatus
