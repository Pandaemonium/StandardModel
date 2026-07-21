import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldCliffordGroup
import PhysicsSM.Spinor.SpinorTenfoldCliffordConj
import PhysicsSM.Spinor.SpinorTenfoldBasisOrbit
import PhysicsSM.Draft.SpinorTenfoldHyperchargeOpAristotle
import PhysicsSM.Draft.ExceptionalJordanProjectiveGeometry

/-!
# Draft.Spin10StabilizerIsomorphism

Formalizes the isomorphism between the joint mixed marked/projective stabilizer subgroup
of the standard collinear pair `(vacuumSpinor, weakSpinor)` and the Standard Model gauge group.

Status: Draft (s o r r y target for Aristotle)
-/

noncomputable section

namespace PhysicsSM.Draft.Spin10StabilizerIsomorphism

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.SpinorTenfoldHyperchargeOp
open PhysicsSM.Draft.ExceptionalJordanProjectiveGeometry

/-- The stabilizer subgroup of `evenCliffordGroup` fixing `ψ` nonprojectively. -/
def StabilizerSubgroup (ψ : FockSpinor) : Subgroup evenCliffordGroup where
  carrier := {g | g.val.val ψ = ψ}
  one_mem' := by simp
  mul_mem' := by
    intro a b ha hb
    change (a * b).val.val ψ = ψ
    simp only [Subgroup.coe_mul, Units.val_mul, Module.End.mul_apply]
    rw [hb, ha]
  inv_mem' := by
    intro a (ha : a.val.val ψ = ψ)
    change a⁻¹.val.val ψ = ψ
    have h_inv : (a⁻¹ * a).val.val ψ = ψ := by
      rw [inv_mul_cancel]
      rfl
    change a⁻¹.val.val (a.val.val ψ) = ψ at h_inv
    rw [ha] at h_inv
    exact h_inv

/-- The projective stabilizer subgroup of `evenCliffordGroup` fixing `ψ` up to scale. -/
def ProjectiveStabilizerSubgroup (ψ : FockSpinor) : Subgroup evenCliffordGroup where
  carrier := {g | ∃ c : ℂ, g.val.val ψ = c • ψ}
  one_mem' := ⟨1, by simp⟩
  mul_mem' := by
    intro a b ⟨ca, ha⟩ ⟨cb, hb⟩
    refine ⟨ca * cb, ?_⟩
    change (a * b).val.val ψ = (ca * cb) • ψ
    change a.val.val (b.val.val ψ) = (ca * cb) • ψ
    rw [hb, LinearMap.map_smul, ha, smul_smul, mul_comm]
  inv_mem' := by
    intro a ⟨c, hc⟩
    by_cases hc0 : c = 0
    · refine ⟨0, ?_⟩
      subst hc0
      rw [zero_smul] at hc
      have h_zero : (a⁻¹ * a).val.val ψ = 0 := by
        change a⁻¹.val.val (a.val.val ψ) = 0
        rw [hc]
        simp
      rw [inv_mul_cancel] at h_zero
      change ψ = 0 at h_zero
      rw [h_zero]
      simp
    · refine ⟨c⁻¹, ?_⟩
      have h1 : a⁻¹.val.val (a.val.val ψ) = a⁻¹.val.val (c • ψ) := congr_arg a⁻¹.val.val hc
      have h_id : a⁻¹.val.val (a.val.val ψ) = ψ := by
        change (a⁻¹ * a).val.val ψ = ψ
        rw [inv_mul_cancel]
        rfl
      rw [h_id] at h1
      rw [LinearMap.map_smul] at h1
      have h2 : c⁻¹ • ψ = a⁻¹.val.val ψ := by
        calc c⁻¹ • ψ = c⁻¹ • (c • a⁻¹.val.val ψ) := congr_arg (c⁻¹ • ·) h1
        _ = (c⁻¹ * c) • a⁻¹.val.val ψ := by rw [smul_smul]
        _ = (1 : ℂ) • a⁻¹.val.val ψ := by rw [inv_mul_cancel₀ hc0]
        _ = a⁻¹.val.val ψ := by rw [one_smul]
      exact h2.symm

/-- The joint mixed marked/projective stabilizer of a pair of spinors. -/
def MixedPairStabilizerSubgroup (ψ₁ ψ₂ : FockSpinor) : Subgroup evenCliffordGroup :=
  StabilizerSubgroup ψ₁ ⊓ ProjectiveStabilizerSubgroup ψ₂

/--
**Lemma S2 (Normal-form stabilizer)**: The joint mixed stabilizer of the standard
collinear pair is isomorphic to `StandardModelGaugeGroup` (i.e., `S(U(2) × U(3))`).

Aristotle Handoff target.
-/
def standard_pair_stabilizer_isomorphic_to_sm :
    MixedPairStabilizerSubgroup vacuumSpinor weakSpinor ≃* StandardModelGaugeGroup := by
  sorry

end PhysicsSM.Draft.Spin10StabilizerIsomorphism

end
