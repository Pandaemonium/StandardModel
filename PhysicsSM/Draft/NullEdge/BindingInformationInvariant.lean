import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.BindingDefect
import PhysicsSM.Draft.NullEdge.BindingEntanglementDeficit

/-!
# Binding gain as one closure/coherence invariant

Two existing modules use opposite but compatible sign conventions:

* `Carrier.BindingDefect.blockBindingDefect` is interacting minus free mass, so
  it equals `-kappa` on the physical branch;
* `BindingEntanglementDeficit` uses the positive mass removed by binding, so it
  equals `kappa = concurrence * lambda`.

This module joins them. The positive binding gain is exactly

```text
free ground mass - interacting ground mass
  = kappa
  = concurrence(lambda,kappa) * lambda.
```

The result is exact for the finite carrier block `B(lambda,kappa)`. It does not
derive the block from a continuum QCD Hamiltonian or identify its coherence with
an experimental entanglement measure.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.BindingInformationInvariant

open PhysicsSM.Draft.NullEdge.Carrier
open PhysicsSM.Draft.NullEdge.Carrier.BindingDefect
open PhysicsSM.Draft.NullEdge.BindingEntanglementDeficit

/-- Positive mass removed by closure: free ground mass minus interacting ground
mass. This is the negative of the signed block binding defect. -/
def bindingGain (lam kappa : ℝ) : ℝ :=
  blockGroundMass lam 0 - blockGroundMass lam kappa

/-- Positive binding gain and signed binding defect differ only by sign. -/
theorem bindingGain_eq_neg_bindingDefect (lam kappa : ℝ) :
    bindingGain lam kappa = -blockBindingDefect lam kappa := by
  simp [bindingGain, blockBindingDefect]

/-- On the physical branch, closure removes exactly `kappa` from the free
ground mass. -/
theorem bindingGain_eq_kappa (lam kappa : ℝ)
    (h0 : 0 ≤ kappa) (hlk : kappa ≤ lam) :
    bindingGain lam kappa = kappa := by
  rw [bindingGain, blockGroundMass_free lam (h0.trans hlk),
    blockGroundMass_eq lam kappa h0 hlk]
  ring

/-- **Binding-information identity.** The positive binding gain equals the
off-diagonal coherence of the normalized coupled block times the aperture. -/
theorem bindingGain_eq_concurrence_mul_aperture
    (lam kappa : ℝ) (h0 : 0 ≤ kappa) (hlam : 0 < lam)
    (hlk : kappa ≤ lam) :
    bindingGain lam kappa = concurrence lam kappa * lam := by
  rw [bindingGain_eq_kappa lam kappa h0 hlk]
  exact binding_defect_eq_concurrence lam kappa h0 hlam hlk

/-- The signed defect is the negative coherence-aperture product. -/
theorem signedBindingDefect_eq_neg_concurrence_mul_aperture
    (lam kappa : ℝ) (h0 : 0 ≤ kappa) (hlam : 0 < lam)
    (hlk : kappa ≤ lam) :
    blockBindingDefect lam kappa = -(concurrence lam kappa * lam) := by
  rw [blockBindingDefect_eq_neg_kappa lam kappa h0 hlk]
  exact congrArg Neg.neg (binding_defect_eq_concurrence lam kappa h0 hlam hlk)

/-- The interacting ground mass is the free ground mass minus the information
carried by the coupled block's off-diagonal coherence. -/
theorem groundMass_eq_free_sub_concurrence_mul_aperture
    (lam kappa : ℝ) (h0 : 0 ≤ kappa) (hlam : 0 < lam)
    (hlk : kappa ≤ lam) :
    blockGroundMass lam kappa =
      blockGroundMass lam 0 - concurrence lam kappa * lam := by
  rw [blockGroundMass_eq lam kappa h0 hlk,
    blockGroundMass_free lam hlam.le,
    ← binding_defect_eq_concurrence lam kappa h0 hlam hlk]

/-- On the physical branch, strict lowering of the block ground mass occurs
exactly when the normalized coupled block has nonzero coherence. -/
theorem strict_binding_iff_nonzero_concurrence
    (lam kappa : ℝ) (h0 : 0 ≤ kappa) (hlam : 0 < lam)
    (hlk : kappa ≤ lam) :
    blockGroundMass lam kappa < blockGroundMass lam 0 ↔
      concurrence lam kappa ≠ 0 := by
  rw [blockGroundMass_eq lam kappa h0 hlk,
    blockGroundMass_free lam hlam.le,
    concurrence_eq lam kappa h0 hlam]
  constructor
  · intro h
    exact div_ne_zero (by linarith) hlam.ne'
  · intro h
    have hk : kappa ≠ 0 := by
      intro hk
      apply h
      simp [hk]
    have hkpos : 0 < kappa := lt_of_le_of_ne h0 (Ne.symm hk)
    linarith

/-! ## Exact nondegenerate carrier witness -/

/-- At the carrier witness `(lambda,kappa)=(2,1)`, one unit of mass is removed,
the normalized coherence is `1/2`, and the interacting ground mass is `1`. -/
theorem witness_binding_information :
    bindingGain 2 1 = 1 ∧
      concurrence 2 1 = 1 / 2 ∧
      blockBindingDefect 2 1 = -1 ∧
      blockGroundMass 2 1 = 1 := by
  constructor
  · rw [bindingGain_eq_kappa 2 1] <;> norm_num
  constructor
  · rw [concurrence_eq 2 1] <;> norm_num
  constructor
  · rw [blockBindingDefect_eq_neg_kappa 2 1] <;> norm_num
  · rw [blockGroundMass_eq 2 1] <;> norm_num

/-! ## Kernel-footprint guard pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.BindingInformationInvariant.bindingGain_eq_concurrence_mul_aperture' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bindingGain_eq_concurrence_mul_aperture

/-- info: 'PhysicsSM.Draft.NullEdge.BindingInformationInvariant.strict_binding_iff_nonzero_concurrence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms strict_binding_iff_nonzero_concurrence

/-- info: 'PhysicsSM.Draft.NullEdge.BindingInformationInvariant.witness_binding_information' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_binding_information

end PhysicsSM.Draft.NullEdge.BindingInformationInvariant
