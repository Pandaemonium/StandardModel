import PhysicsSM.Draft.Spin10AnnihilatorIncidence
import PhysicsSM.Draft.Spin10VacuumChartReconstruction

noncomputable section

namespace PhysicsSM.Draft.Spin10AnnihilatorIncidence

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.Spin10StabilizerTransitivity
open PhysicsSM.Draft.Spin10StandardizablePairs

/-- Chevalley incidence with the first spinor fixed to the vacuum and the
second in the normalized affine vacuum chart. -/
theorem annihilatorIntersectionDim_vacuum_eq_three_of_quadric_chart
    (ψ : FockSpinor) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) (h0 : ψ ∅ = 1)
    (horth : OrthogonalPureSpinors vacuumSpinor ψ)
    (hdist : ProjectivelyDistinct vacuumSpinor ψ) :
    annihilatorIntersectionDim vacuumSpinor ψ = 3 := by
  sorry

end PhysicsSM.Draft.Spin10AnnihilatorIncidence
