import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldCliffordGroup
import PhysicsSM.Spinor.SpinorTenfoldCliffordConj
import PhysicsSM.Spinor.SpinorTenfoldBasisOrbit
import PhysicsSM.Draft.Spin10StabilizerTransitivity
import PhysicsSM.Draft.Spin10StabilizerIsomorphism
import PhysicsSM.Draft.ExceptionalJordanProjectiveGeometry

/-!
# Draft.Spin10StabilizerSelector

Formalizes the Selector Theorem: the physical embedding class of `S(U(2) × U(3))` is the unique
conjugacy class in the even Clifford group stabilizing a Krasnov pair of pure spinors.

Status: Draft (s o r r y target for Aristotle)
-/

noncomputable section

namespace PhysicsSM.Draft.Spin10StabilizerSelector

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.Spin10StabilizerTransitivity
open PhysicsSM.Draft.Spin10StabilizerIsomorphism
open PhysicsSM.Draft.ExceptionalJordanProjectiveGeometry

/--
**Corollary S4 (Selector Theorem)**: The physical embedding class is the unique conjugacy class
stabilizing a Krasnov pair of pure spinors.

Aristotle Handoff target.
-/
theorem physical_embedding_selected_by_krasnov_pair
    (H : Subgroup evenCliffordGroup)
    (h_iso : H ≃* StandardModelGaugeGroup) :
    (∃ (ψ₁ ψ₂ : FockSpinor) (hψ₁ : IsPureSpinor ψ₁) (hψ₂ : IsPureSpinor ψ₂)
       (h_coll : OrthogonalPureSpinors ψ₁ ψ₂),
       MixedPairStabilizerSubgroup ψ₁ ψ₂ = H)
      ↔ ∃ g : evenCliffordGroup,
          H = Subgroup.map (MulEquiv.toMonoidHom (MulAut.conj g))
            (MixedPairStabilizerSubgroup vacuumSpinor weakSpinor) := by
  sorry

end PhysicsSM.Draft.Spin10StabilizerSelector

end
