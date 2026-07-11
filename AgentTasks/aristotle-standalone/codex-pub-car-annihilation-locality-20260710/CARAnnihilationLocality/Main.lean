import PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization

/-!
# Annihilation covariance and finite support locality

This target closes the operator-adjoint half of the generic finite exterior
lift and packages the exact one-particle support relation inherited by creation
and annihilation operators.  It does not claim a Lieb-Robinson estimate or an
interacting quantum field theory.
-/

noncomputable section

open Matrix Complex
open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.CARAnnihilationLocality

open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
open PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization

variable {ι : Type*} [Fintype ι] [LinearOrder ι] [DecidableEq ι]

theorem fockInner_create_left (i : ι) (psi phi : Fock ι) :
    fockInner (create i psi) phi = fockInner psi (annihilate i phi) := by
  sorry

theorem fockInner_annihilate_left (i : ι) (psi phi : Fock ι) :
    fockInner (annihilate i psi) phi = fockInner psi (create i phi) := by
  sorry

theorem gamma_annihilate_covariance (U : Matrix ι ι Complex)
    (hleft : Uᴴ * U = 1) (hright : U * Uᴴ = 1)
    (j : ι) (psi : Fock ι) :
    annihilate j (Gamma U psi) =
      ∑ i : ι, U j i • Gamma U (annihilate i psi) := by
  sorry

theorem gamma_create_covariance_restrict
    (U : Matrix ι ι Complex) (R : ι -> ι -> Prop) [DecidableRel R]
    (i : ι) (psi : Fock ι)
    (hlocal : ∀ j, ¬ R j i -> U j i = 0) :
    Gamma U (create i psi) =
      ∑ j ∈ Finset.univ.filter (fun j => R j i),
        U j i • create j (Gamma U psi) := by
  sorry

theorem gamma_annihilate_covariance_restrict
    (U : Matrix ι ι Complex) (R : ι -> ι -> Prop) [DecidableRel R]
    (hleft : Uᴴ * U = 1) (hright : U * Uᴴ = 1)
    (j : ι) (psi : Fock ι)
    (hlocal : ∀ i, ¬ R j i -> U j i = 0) :
    annihilate j (Gamma U psi) =
      ∑ i ∈ Finset.univ.filter (fun i => R j i),
        U j i • Gamma U (annihilate i psi) := by
  sorry

theorem swap_annihilation_control :
    let U : Matrix (Fin 2) (Fin 2) Complex := !![0, 1; 1, 0]
    let psi := basisVec ({0} : Finset (Fin 2))
    annihilate 1 (Gamma U psi) = vac ∧
      annihilate 0 (Gamma U psi) = 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.CARAnnihilationLocality
