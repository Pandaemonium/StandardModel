import PhysicsSM.Draft.NullEdge.FiniteCARFockBasic

/-!
# Determinant-minor second quantization

Focused proof target for the exterior-power lift of a finite one-particle
matrix to the occupation-basis fermionic Fock space.  The key target is
`gamma_create_covariance`; the earlier statements expose its nondegenerate
vacuum and one-particle controls.
-/

noncomputable section

namespace FiniteCARSecondQuantization

open Finset Matrix
open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic

variable {ι : Type*} [Fintype ι] [DecidableEq ι] [LinearOrder ι]

/-- Occupation-basis vector labelled by `S`. -/
def basisVec (S : Finset ι) : Fock ι := fun T => if T = S then 1 else 0

/-- The empty occupation state. -/
def vac : Fock ι := basisVec ∅

/-- The ordered `T`-by-`S` minor of `U`, zero between unequal sectors. -/
def gammaEntry (U : Matrix ι ι Complex) (T S : Finset ι) : Complex :=
  if h : S.card = T.card then
    Matrix.det (Matrix.of fun a b : Fin T.card =>
      U (T.orderEmbOfFin rfl a) (S.orderEmbOfFin h b))
  else 0

/-- The determinant-minor second quantization of `U`. -/
def Gamma (U : Matrix ι ι Complex) (psi : Fock ι) : Fock ι := fun T =>
  ∑ S : Finset ι, gammaEntry U T S * psi S

/-- The empty minor is one. -/
theorem gammaEntry_empty (U : Matrix ι ι Complex) :
    gammaEntry U ∅ ∅ = 1 := by
  sorry

/-- Second quantization fixes the vacuum. -/
theorem Gamma_vac (U : Matrix ι ι Complex) :
    Gamma U vac = vac := by
  sorry

/-- A one-particle minor is the corresponding matrix element. -/
theorem gammaEntry_singleton (U : Matrix ι ι Complex) (j k : ι) :
    gammaEntry U {j} {k} = U j k := by
  sorry

/-- `Gamma U` is additive in the Fock vector. -/
theorem Gamma_add (U : Matrix ι ι Complex) (psi phi : Fock ι) :
    Gamma U (psi + phi) = Gamma U psi + Gamma U phi := by
  sorry

/-- `Gamma U` commutes with complex scalar multiplication. -/
theorem Gamma_smul (U : Matrix ι ι Complex) (c : Complex) (psi : Fock ι) :
    Gamma U (c • psi) = c • Gamma U psi := by
  sorry

/-- Exact agreement with `U` on occupation-basis one-particle states. -/
theorem Gamma_apply_singleton (U : Matrix ι ι Complex) (j k : ι) :
    Gamma U (basisVec {k}) {j} = U j k := by
  sorry

/-- Total particle number in the occupation basis. -/
def totalNumber (psi : Fock ι) : Fock ι := fun S =>
  (S.card : Complex) * psi S

/-- Fermion parity in the occupation basis. -/
def parity (psi : Fock ι) : Fock ι := fun S =>
  (-1 : Complex) ^ S.card * psi S

/-- The minor lift preserves particle number for every matrix `U`. -/
theorem Gamma_number (U : Matrix ι ι Complex) (psi : Fock ι) :
    Gamma U (totalNumber psi) = totalNumber (Gamma U psi) := by
  sorry

/-- The minor lift preserves fermion parity for every matrix `U`. -/
theorem Gamma_parity (U : Matrix ι ι Complex) (psi : Fock ι) :
    Gamma U (parity psi) = parity (Gamma U psi) := by
  sorry

/--
Creation covariance.  This is the key finite Laplace-expansion identity:
the lift replaces an input mode by the corresponding column of `U`.
-/
theorem gamma_create_covariance (U : Matrix ι ι Complex) (i : ι)
    (psi : Fock ι) :
    Gamma U (create i psi) =
      ∑ j : ι, U j i • create j (Gamma U psi) := by
  sorry

end FiniteCARSecondQuantization
