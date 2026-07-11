import PhysicsSM.Draft.JordanCliffordFureyFockBridge
import PhysicsSM.Algebra.Furey.OperatorRepresentations

/-!
# Aristotle target: concrete ladder multiplication preserves the Jbar' span

Close the single proof hole without changing the statement. The proof must use
the imported concrete basis action theorem and linear spanning of `Jbar'`; do
not define preservation by transporting the desired Fock action.
-/

noncomputable section

namespace PhysicsSM.Draft.JordanCliffordFureyFockSpanPreservation

open Matrix
open PhysicsSM.Algebra.Furey
open PhysicsSM.Algebra.Furey.MinimalLeftIdeal
open PhysicsSM.Algebra.Furey.JbarLinearIndependence
open PhysicsSM.Draft.JordanCliffordFureyFockBridge

/-- Every concrete left ladder multiplication preserves the corrected
eight-state span. -/
theorem ladder_mul_mem_Jbar (dagger : Bool) (k : Fin 3) (x : Jbar') :
    ladderOp dagger k * x.1 ∈ Jbar' := by
  sorry

end PhysicsSM.Draft.JordanCliffordFureyFockSpanPreservation
