import PhysicsSM.Spinor.PluckerMass

/-!
# Gram-weighted operator Hermiticity

This draft module proves the finite Hermiticity sanity check for Gram-weighted
visible momentum: Hermitian hidden Gram data induces a Hermitian visible
operator, and therefore its diagonal entries are real.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeGramWeightedHermitian

open BigOperators
open Matrix Complex
open PhysicsSM.Spinor.PluckerMass

/--
Visible momentum obtained by tracing hidden labels with a finite internal Gram
matrix.
-/
def operatorGramWeightedVisibleMomentum {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex)
    (psi : Fin n -> CSpinor) : Matrix (Fin 2) (Fin 2) Complex :=
  fun a b =>
    Finset.univ.sum fun i : Fin n =>
      Finset.univ.sum fun j : Fin n =>
        G i j * psi i a * (starRingEnd Complex) (psi j b)

/-- Hermiticity for a finite complex matrix. -/
def MatrixHermitian {m : Nat}
    (M : Matrix (Fin m) (Fin m) Complex) : Prop :=
  ∀ a b : Fin m, M b a = (starRingEnd Complex) (M a b)

/-- Hermiticity for a finite hidden Gram matrix. -/
def GramHermitian {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex) : Prop :=
  MatrixHermitian G

/-- Hermitian hidden Gram data induces a Hermitian visible momentum operator. -/
theorem operatorGramWeightedVisibleMomentum_hermitian_of_gramHermitian
    {n : Nat} (G : Matrix (Fin n) (Fin n) Complex)
    (psi : Fin n -> CSpinor) (hG : GramHermitian G) :
    MatrixHermitian (operatorGramWeightedVisibleMomentum G psi) := by
  intro a b
  simp only [operatorGramWeightedVisibleMomentum, map_sum, map_mul,
    Complex.conj_conj]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl ?_
  intro i _
  refine Finset.sum_congr rfl ?_
  intro j _
  rw [← hG]
  ring

/-- Diagonal entries of a Hermitian complex matrix have zero imaginary part. -/
theorem matrixHermitian_diag_im_eq_zero
    {m : Nat} (M : Matrix (Fin m) (Fin m) Complex)
    (hM : MatrixHermitian M) (a : Fin m) :
    (M a a).im = 0 := by
  have h := hM a a
  norm_num [Complex.ext_iff] at h
  linarith

/--
Diagonal entries of a visible momentum induced by Hermitian hidden Gram data are
real.
-/
theorem operatorGramWeightedVisibleMomentum_diag_im_eq_zero
    {n : Nat} (G : Matrix (Fin n) (Fin n) Complex)
    (psi : Fin n -> CSpinor) (hG : GramHermitian G) (a : Fin 2) :
    ((operatorGramWeightedVisibleMomentum G psi) a a).im = 0 :=
  matrixHermitian_diag_im_eq_zero _
    (operatorGramWeightedVisibleMomentum_hermitian_of_gramHermitian G psi hG) a

end PhysicsSM.Draft.NullEdgeGramWeightedHermitian

end
