import PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization

/-!
# Functorial and unitary finite second quantization

Publication target for Paper E.  Keep the determinant-minor definition of
`Gamma` unchanged and prove that it is the exterior-power functor.  Creation
covariance is already proved in the imported module; the targets below close
composition and inner-product preservation.
-/

noncomputable section

namespace FiniteCARFunctorial

open Matrix Finset
open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
open PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization

variable {ι : Type*} [Fintype ι] [DecidableEq ι] [LinearOrder ι]

/-- The minors of the identity are the occupation-basis Kronecker delta. -/
theorem gammaEntry_one (T S : Finset ι) :
    gammaEntry (1 : Matrix ι ι Complex) T S = if T = S then 1 else 0 := by
  sorry

/-- The exterior lift sends the one-particle identity to the Fock identity. -/
theorem Gamma_one (psi : Fock ι) :
    Gamma (1 : Matrix ι ι Complex) psi = psi := by
  sorry

/-- Cauchy-Binet in the exact ordered-minor convention used by `Gamma`. -/
theorem gammaEntry_mul (U V : Matrix ι ι Complex) (T S : Finset ι) :
    gammaEntry (U * V) T S =
      ∑ A : Finset ι, gammaEntry U T A * gammaEntry V A S := by
  sorry

/-- Functoriality of finite second quantization. -/
theorem Gamma_mul (U V : Matrix ι ι Complex) (psi : Fock ι) :
    Gamma (U * V) psi = Gamma U (Gamma V psi) := by
  sorry

/-- Conjugate transpose reverses the ordered minor. -/
theorem gammaEntry_conjTranspose (U : Matrix ι ι Complex) (T S : Finset ι) :
    gammaEntry Uᴴ T S = star (gammaEntry U S T) := by
  sorry

/-- Finite occupation-basis Hermitian inner product. -/
def fockInner (psi phi : Fock ι) : Complex :=
  ∑ S : Finset ι, star (psi S) * phi S

/-- A unitary one-particle matrix lifts to an inner-product-preserving Fock
operator. -/
theorem Gamma_preserves_fockInner (U : Matrix ι ι Complex)
    (hleft : Uᴴ * U = 1) (hright : U * Uᴴ = 1)
    (psi phi : Fock ι) :
    fockInner (Gamma U psi) (Gamma U phi) = fockInner psi phi := by
  sorry

/-- The lift of a unitary has the lift of its conjugate transpose as a
two-sided inverse. -/
theorem Gamma_unitary_inverse (U : Matrix ι ι Complex)
    (hleft : Uᴴ * U = 1) (hright : U * Uᴴ = 1) (psi : Fock ι) :
    Gamma Uᴴ (Gamma U psi) = psi ∧ Gamma U (Gamma Uᴴ psi) = psi := by
  sorry

/-- Nondegenerate control: the identity lift fixes an occupied one-particle
state, not only the vacuum. -/
theorem finTwo_identity_oneParticle_control :
    Gamma (1 : Matrix (Fin 2) (Fin 2) Complex) (basisVec {0}) = basisVec {0} := by
  simpa using Gamma_one (ι := Fin 2) (basisVec {0})

end FiniteCARFunctorial
