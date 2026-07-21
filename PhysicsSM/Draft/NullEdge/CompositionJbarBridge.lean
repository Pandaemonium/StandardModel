import PhysicsSM.Draft.NullEdge.CompositionWeakLaddersRight
import PhysicsSM.Algebra.Furey.AnomalyBridge

/-!
# The Jbar bridge atoms: the right-action ladder on the conjugate-ideal states

**Status: KERNEL NO-GO RECORDED (item-2 closure step 1 result).** The probe
battery ran and ALL SIX atoms are ZERO: the right-composition omega-nests
(`hatOmegaRb`, `hatOmegaRbDag`) ANNIHILATE the excited conjugate-ideal states
(`vbar1`, `vbar4`, `nu_bar`) - mirroring the left tower's annihilation of the
colour triplets. CONSEQUENCE (honest): `TPlusEnd`'s table (`7 -> 0`,
`1,2,3 -> 4,5,6`) is NOT realized by pure one-sided omega-mode composition
nests on the repo's single-ideal Jbar packaging. The right tower's isospin
lives on the IDEMPOTENT plane `{v, v*}` (the `Su <-> Sd` sector story); the
Jbar quark-doublet operator needs a DIFFERENT ansatz - most plausibly the
paper's doubled `Su (+) Sd` packaging (u-type and d-type in SEPARATE ideals
with the right action mapping between them), not the mode-counting
single-ideal packaging. This is a design question for the next block /
an Aristotle strategy job, pre-registered in the S2b design note. The zero
atoms below are the kernel record of the no-go.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionJbarBridge

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Algebra.Furey.MinimalLeftIdeal (omega_bar vbar1 vbar4 nu_bar)
open PhysicsSM.Draft.NullEdge.CompositionWeakLaddersRight

set_option maxHeartbeats 64000000
set_option maxRecDepth 20000

/-- Probe: `Rb` on the single-mode state `vbar1 = alpha1 omega_bar`. -/
theorem probe_Rb_vbar1 : hatOmegaRb vbar1 = 0 := by
  unfold hatOmegaRb
  ext <;>
    simp [PhysicsSM.Algebra.Furey.MinimalLeftIdeal.vbar1,
      PhysicsSM.Algebra.Furey.MinimalLeftIdeal.omega_bar,
      alpha1, alpha2, alpha3, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- Probe: `RbDag` on `vbar1`. -/
theorem probe_RbDag_vbar1 : hatOmegaRbDag vbar1 = 0 := by
  unfold hatOmegaRbDag
  ext <;>
    simp [PhysicsSM.Algebra.Furey.MinimalLeftIdeal.vbar1,
      PhysicsSM.Algebra.Furey.MinimalLeftIdeal.omega_bar,
      alpha1, alpha1_dag, alpha2_dag, alpha3_dag, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- Probe: `Rb` on the double-mode state `vbar4`. -/
theorem probe_Rb_vbar4 : hatOmegaRb vbar4 = 0 := by
  unfold hatOmegaRb
  ext <;>
    simp [PhysicsSM.Algebra.Furey.MinimalLeftIdeal.vbar4,
      PhysicsSM.Algebra.Furey.MinimalLeftIdeal.vbar1,
      PhysicsSM.Algebra.Furey.MinimalLeftIdeal.omega_bar,
      alpha1, alpha2, alpha3, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- Probe: `RbDag` on `vbar4`. -/
theorem probe_RbDag_vbar4 : hatOmegaRbDag vbar4 = 0 := by
  unfold hatOmegaRbDag
  ext <;>
    simp [PhysicsSM.Algebra.Furey.MinimalLeftIdeal.vbar4,
      PhysicsSM.Algebra.Furey.MinimalLeftIdeal.vbar1,
      PhysicsSM.Algebra.Furey.MinimalLeftIdeal.omega_bar,
      alpha1, alpha2, alpha1_dag, alpha2_dag, alpha3_dag,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- Probe: `Rb` on the triple `nu_bar` (the `TPlusEnd 7 -> 0` move should
live here or in the dagger). -/
theorem probe_Rb_nubar : hatOmegaRb nu_bar = 0 := by
  unfold hatOmegaRb
  ext <;>
    simp [PhysicsSM.Algebra.Furey.MinimalLeftIdeal.nu_bar,
      PhysicsSM.Algebra.Furey.MinimalLeftIdeal.omega_bar,
      alpha1, alpha2, alpha3, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- Probe: `RbDag` on `nu_bar`. -/
theorem probe_RbDag_nubar : hatOmegaRbDag nu_bar = 0 := by
  unfold hatOmegaRbDag
  ext <;>
    simp [PhysicsSM.Algebra.Furey.MinimalLeftIdeal.nu_bar,
      PhysicsSM.Algebra.Furey.MinimalLeftIdeal.omega_bar,
      alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

end PhysicsSM.Draft.NullEdge.CompositionJbarBridge
