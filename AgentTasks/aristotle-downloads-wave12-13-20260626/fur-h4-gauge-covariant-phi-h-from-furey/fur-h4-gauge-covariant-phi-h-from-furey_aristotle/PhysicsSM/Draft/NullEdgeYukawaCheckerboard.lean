import Mathlib

/-!
# Finite chiral checkerboard square with a constant Yukawa mass block

Aristotle draft target for the null-edge unified mass first wave (proof-chain
entries **T5** and **T6**; grand-strategy Sections A, C, D, E; Working Plan
Sections 6.1, 17-19).

This file formalizes the *finite* (purely linear-algebraic) content of the
Yukawa checkerboard mechanism:

* `H_L`, `H_R` are finite-dimensional complex inner-product spaces (the left and
  right chiral carriers).
* `M : H_R →ₗ[ℂ] H_L` is the constant chirality-flip ("Yukawa") block, with
  Hermitian adjoint `Mᴴ := LinearMap.adjoint M : H_L →ₗ[ℂ] H_R`.
* `∇₊`, `∇₋` are the commuting null finite-difference operators.  Because `M` is
  *constant* it commutes with the finite differences; this is the only
  structural input used by the square.

## Conventions and guardrails

* This is **reconstruction**, not prediction: nothing here predicts the entries
  of `M`.  `M` is an arbitrary linear map.
* Sign convention is aligned with `D² = -K + Φ²`, so on shell `K = Φ²`.  Here
  `K_L = -∇₋∇₊`, `K_R = -∇₊∇₋`, and the squared (on-shell) equations read
  `K_L ψ_L = M Mᴴ ψ_L` and `K_R ψ_R = Mᴴ M ψ_R`, i.e. `K = Φ²` with the
  Hermitian mass block `Φ² = M Mᴴ` (resp. `Mᴴ M`).
* No fake assumptions or placeholder tokens are used in the trusted statements.

## Main results

* `yukawa_checkerboard_square` — the chiral square identity (**T5**).
* `nonzero_eigenvalue_swap` — the general "nonzero eigenvalues of `A∘B` and
  `B∘A` coincide" lemma (the rectangular singular-value correspondence, **T6**).
* `yukawa_nonzero_eigenvalue_correspondence` — its specialization to
  `M Mᴴ` and `Mᴴ M`.
* `yukawa_ker_self` / `yukawa_ker_adjoint` — the zero-mode (kernel) description.
-/

namespace PhysicsSM
namespace Draft

open scoped ComplexConjugate

section Checkerboard

variable {H_L H_R : Type*}
  [NormedAddCommGroup H_L] [InnerProductSpace ℂ H_L] [FiniteDimensional ℂ H_L]
  [NormedAddCommGroup H_R] [InnerProductSpace ℂ H_R] [FiniteDimensional ℂ H_R]

/-
**T5 — Finite Yukawa checkerboard square.**

Null left/right propagation through a constant chirality-flip block `M` produces
massive Dirac dispersion.  From the first-order (on-shell) equations

* `i ∇₊ ψ_L = M ψ_R`,
* `i ∇₋ ψ_R = Mᴴ ψ_L`,

with `K_L = -∇₋∇₊` and `K_R = -∇₊∇₋`, one obtains the squared equations

* `K_L ψ_L = M Mᴴ ψ_L`,
* `K_R ψ_R = Mᴴ M ψ_R`.

The only structural hypotheses are that the (constant) block `M` commutes with
the finite differences (`hcommM`, `hcommMadj`).  The mutual commutation of
`∇₊` and `∇₋` (the "commuting null" property of a flat lattice) is *not* needed
for the square identity and is therefore omitted from the hypotheses.
-/
theorem yukawa_checkerboard_square
    (M : H_R →ₗ[ℂ] H_L)
    (DpL DmL : H_L →ₗ[ℂ] H_L) (DpR DmR : H_R →ₗ[ℂ] H_R)
    (psiL : H_L) (psiR : H_R)
    (hcommM : DmL ∘ₗ M = M ∘ₗ DmR)
    (hcommMadj : DpR ∘ₗ (LinearMap.adjoint M) = (LinearMap.adjoint M) ∘ₗ DpL)
    (eq1 : (Complex.I) • DpL psiL = M psiR)
    (eq2 : (Complex.I) • DmR psiR = (LinearMap.adjoint M) psiL) :
    (-(DmL ∘ₗ DpL)) psiL = (M ∘ₗ LinearMap.adjoint M) psiL
    ∧ (-(DpR ∘ₗ DmR)) psiR = (LinearMap.adjoint M ∘ₗ M) psiR := by
  simp_all +decide [ LinearMap.ext_iff ];
  simp +decide [ ← eq1, ← eq2, ← hcommM, ← hcommMadj, smul_smul, Complex.I_mul_I ]

end Checkerboard

section SingularValues

variable {V W : Type*} [AddCommGroup V] [Module ℂ V] [AddCommGroup W] [Module ℂ W]

/--
**T6 (core) — nonzero eigenvalues of `A ∘ B` and `B ∘ A` coincide.**

For linear maps `A : V → W` and `B : W → V` and a nonzero scalar `μ`, `μ` is an
eigenvalue of `A ∘ B` (on `W`) iff it is an eigenvalue of `B ∘ A` (on `V`).  The
witness map is `B` (resp. `A`): if `(A∘B) w = μ w` with `w ≠ 0` then `B w` is a
`μ`-eigenvector of `B∘A`, and `B w ≠ 0` since otherwise `μ • w = 0`.
-/
theorem nonzero_eigenvalue_swap
    (A : V →ₗ[ℂ] W) (B : W →ₗ[ℂ] V) {μ : ℂ} (hμ : μ ≠ 0) :
    (∃ w : W, w ≠ 0 ∧ (A ∘ₗ B) w = μ • w) ↔
      (∃ v : V, v ≠ 0 ∧ (B ∘ₗ A) v = μ • v) := by
  constructor <;> intro h;
  · obtain ⟨ w, hw, hw' ⟩ := h;
    refine' ⟨ B w, _, _ ⟩ <;> simp_all +decide;
    intro h; simp_all +decide ;
    rw [ eq_comm, smul_eq_zero ] at hw' ; aesop;
  · obtain ⟨ v, hv, hv' ⟩ := h; use A v; simp_all +decide ;
    intro h; simp_all +decide ;
    rw [ eq_comm, smul_eq_zero ] at hv' ; aesop

end SingularValues

section YukawaSpectrum

variable {H_L H_R : Type*}
  [NormedAddCommGroup H_L] [InnerProductSpace ℂ H_L] [FiniteDimensional ℂ H_L]
  [NormedAddCommGroup H_R] [InnerProductSpace ℂ H_R] [FiniteDimensional ℂ H_R]

/--
**T6 — rectangular Yukawa singular-value correspondence.**

The nonzero (hence, since `M Mᴴ` and `Mᴴ M` are positive semidefinite, positive)
eigenvalues of `M Mᴴ` and `Mᴴ M` coincide.  These are the squared singular
values of `M`, i.e. the squared Dirac masses of the checkerboard.
-/
theorem yukawa_nonzero_eigenvalue_correspondence
    (M : H_R →ₗ[ℂ] H_L) {μ : ℂ} (hμ : μ ≠ 0) :
    (∃ x : H_L, x ≠ 0 ∧ (M ∘ₗ LinearMap.adjoint M) x = μ • x) ↔
      (∃ y : H_R, y ≠ 0 ∧ (LinearMap.adjoint M ∘ₗ M) y = μ • y) := by
  convert nonzero_eigenvalue_swap M ( LinearMap.adjoint M ) hμ using 1

/--
Zero modes of the right mass block `Mᴴ M` are exactly the kernel of `M`:
`Mᴴ M y = 0 ↔ M y = 0`, since `⟪Mᴴ M y, y⟫ = ‖M y‖²`.
-/
theorem yukawa_ker_self (M : H_R →ₗ[ℂ] H_L) :
    LinearMap.ker (LinearMap.adjoint M ∘ₗ M) = LinearMap.ker M := by
  refine' le_antisymm _ _ <;> intro x hx <;> simp_all +decide [ LinearMap.mem_ker ];
  have := LinearMap.adjoint_inner_right M x ( M x ) ; simp_all +decide [ inner_self_eq_norm_sq_to_K ] ;
  simpa using this.symm

/--
Zero modes of the left mass block `M Mᴴ` are exactly the kernel of `Mᴴ`.
-/
theorem yukawa_ker_adjoint (M : H_R →ₗ[ℂ] H_L) :
    LinearMap.ker (M ∘ₗ LinearMap.adjoint M) = LinearMap.ker (LinearMap.adjoint M) := by
  convert yukawa_ker_self ( LinearMap.adjoint M ) using 1;
  rw [ LinearMap.adjoint_adjoint ]

end YukawaSpectrum

end Draft
end PhysicsSM
