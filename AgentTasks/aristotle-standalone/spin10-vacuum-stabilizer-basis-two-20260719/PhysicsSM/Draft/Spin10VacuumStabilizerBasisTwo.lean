import PhysicsSM.Draft.Spin10VacuumFiberTransitivity

noncomputable section

namespace PhysicsSM.Draft.Spin10VacuumFiberTransitivity

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.Spin10StabilizerTransitivity
open PhysicsSM.Draft.Spin10StandardizablePairs

/-- Every non-vacuum point on every basis-two affine chart is carried to the
standard weak line by an element fixing the vacuum exactly. -/
theorem exists_vacuumStabilizer_affine_basisTwo_to_weak
    (T : Finset (Fin 5)) (hT : T.card = 2)
    (a b : ℂ) (hb : b ≠ 0) :
    ∃ g : evenCliffordGroup, g ∈ vacuumStabilizer ∧
      ∃ c : ℂ, c ≠ 0 ∧
        g.val.val (a • vacuumSpinor + b • basisSpinor T) = c • weakSpinor := by
  sorry

end PhysicsSM.Draft.Spin10VacuumFiberTransitivity
