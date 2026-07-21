import PhysicsSM.Draft.Spin10VacuumChartQuadrics

noncomputable section

namespace PhysicsSM.Draft.Spin10StandardizablePairs

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.Spin10StabilizerTransitivity

/-- Successor form of the normalized pure-spinor affine-chart theorem. -/
theorem exists_creationRoots_vacuum_eq_of_quadric_chart
    (ψ : FockSpinor) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) (h0 : ψ ∅ = 1) :
    ∃ g : evenCliffordGroup, g.val.val vacuumSpinor = ψ := by
  sorry

end PhysicsSM.Draft.Spin10StandardizablePairs
