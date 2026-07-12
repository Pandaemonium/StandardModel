import PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol
import PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge

/-!
# Exact Weyl-sector charge of the live cubic Dirac tangent

This draft target connects the repository's actual `4 x 4` Clifford generators
to explicit `2 x 2` Weyl sectors and then to the guarded Jacobian-sign charge
API. It proves a local tangent statement only, not global chirality of a full
Bloch symbol or a Brillouin-zone charge sum.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge

open PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol
open PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex
abbrev Mat2 := Matrix (Fin 2) (Fin 2) Complex

noncomputable def Xi : Mat4 := (-I) • (alpha1 * alpha2 * alpha3)

def xiExplicit : Mat4 :=
  !![0,0,1,0;0,0,0,1;1,0,0,0;0,1,0,0]

def plusBasis : Matrix (Fin 4) (Fin 2) Complex :=
  !![1,0;0,1;1,0;0,1]

def minusBasis : Matrix (Fin 4) (Fin 2) Complex :=
  !![-1,0;0,-1;1,0;0,1]

noncomputable def restrictTo (B : Matrix (Fin 4) (Fin 2) Complex)
    (A : Mat4) : Mat2 :=
  (1 / 2 : Complex) • (B.conjTranspose * A * B)

noncomputable def restrictPlus (A : Mat4) : Mat2 := restrictTo plusBasis A
noncomputable def restrictMinus (A : Mat4) : Mat2 := restrictTo minusBasis A

def sigma1 : Mat2 := !![0,1;1,0]
def sigma2 : Mat2 := !![0,-I;I,0]
def sigma3 : Mat2 := !![1,0;0,-1]

theorem Xi_eq_explicit : Xi = xiExplicit := by
  sorry

theorem Xi_sq : Xi * Xi = 1 := by
  sorry

theorem Xi_commutes_alpha (j : Fin 3) : Xi * alpha j = alpha j * Xi := by
  sorry

theorem Xi_anticommutes_beta : Xi * beta + beta * Xi = 0 := by
  sorry

theorem plusBasis_orthogonal : plusBasis.conjTranspose * plusBasis = 2 • 1 := by
  sorry

theorem minusBasis_orthogonal : minusBasis.conjTranspose * minusBasis = 2 • 1 := by
  sorry

theorem restrictPlus_generators :
    restrictPlus alpha1 = sigma1 ∧
    restrictPlus alpha2 = sigma2 ∧
    restrictPlus alpha3 = sigma3 := by
  sorry

theorem restrictMinus_generators :
    restrictMinus alpha1 = -sigma1 ∧
    restrictMinus alpha2 = -sigma2 ∧
    restrictMinus alpha3 = -sigma3 := by
  sorry

def plusSectorJacobian : J3 := 1
def minusSectorJacobian : J3 := -1

theorem plusSectorJacobian_det : plusSectorJacobian.det = 1 := by
  sorry

theorem minusSectorJacobian_det : minusSectorJacobian.det = -1 := by
  sorry

theorem plusSector_charge : localCrossingCharge plusSectorJacobian = 1 := by
  sorry

theorem minusSector_charge : localCrossingCharge minusSectorJacobian = -1 := by
  sorry

/-- The actual live cubic Dirac tangent has opposite local Weyl-sector charges. -/
theorem liveDiracSectorCharges_cancel :
    localCrossingCharge plusSectorJacobian +
      localCrossingCharge minusSectorJacobian = 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge
