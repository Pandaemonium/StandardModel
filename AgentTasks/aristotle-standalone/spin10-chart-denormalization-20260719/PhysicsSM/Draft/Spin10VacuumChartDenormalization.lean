import PhysicsSM.Draft.Spin10VacuumChartReconstruction

noncomputable section

namespace PhysicsSM.Draft.Spin10StandardizablePairs

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.Spin10StabilizerTransitivity

/-- A nonzero vacuum coordinate can be normalized, reconstructed by creation
roots, and restored by an algebraic scalar unit. -/
theorem exists_evenCliffordGroup_vacuum_eq_of_nonzero_quadric_chart
    (ψ : FockSpinor) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) (h0 : ψ ∅ ≠ 0) :
    ∃ g : evenCliffordGroup, g.val.val vacuumSpinor = ψ := by
  sorry

end PhysicsSM.Draft.Spin10StandardizablePairs
