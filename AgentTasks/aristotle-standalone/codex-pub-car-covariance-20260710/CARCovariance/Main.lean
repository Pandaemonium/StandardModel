import PhysicsSM.Draft.NullEdge.CARAnnihilationLocality

/-!
# Focused annihilation covariance target

The occupation-basis adjoint identities, creation covariance, exterior-lift
adjoint law, and unitary inverse are already kernel-checked. This target derives
the annihilation half without reopening the determinant-minor proof.
-/

noncomputable section

open Matrix Complex
open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.CARAnnihilationLocality

open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
open PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization

variable {ι : Type*} [Fintype ι] [LinearOrder ι] [DecidableEq ι]

theorem gamma_annihilate_covariance_target (U : Matrix ι ι Complex)
    (hleft : Uᴴ * U = 1) (hright : U * Uᴴ = 1)
    (j : ι) (psi : Fock ι) :
    annihilate j (Gamma U psi) =
      ∑ i : ι, U j i • Gamma U (annihilate i psi) := by
  sorry

end PhysicsSM.Draft.NullEdge.CARAnnihilationLocality
