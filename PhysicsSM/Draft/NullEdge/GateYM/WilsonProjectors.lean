import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.EuclideanGamma

/-!
# QMF5 Deliverable-1 foundation: the Wilson spin projectors `P+- = (1 -+ gamma_mu)/2`

The concrete algebraic heart of the finite fermionic reflection-positivity (RP-F)
crux (node N5 of the QMF5 design DAG,
`AgentTasks/fourday-ym-run-2026-07-05/QMF5_DESIGN_HARVEST.md`, Aristotle job
`d1e7bece`). At Wilson parameter `r = 1` the temporal hopping term across the
reflection plane uses the spin operators

    P_plus  = (1 - gamma_mu) / 2 ,     P_minus = (1 + gamma_mu) / 2 ,

for the reflection-direction gamma matrix `gamma_mu`. Because `gamma_mu` is
Hermitian and squares to `1` (both proved in `EuclideanGamma`), `P_plus` and
`P_minus` are complementary ORTHOGONAL PROJECTORS. This projector structure is
exactly what turns the reflected cross-mirror coupling
`-1/2 [psibar_1 (1 - gamma_mu) U psi_0 + psibar_0 (1 + gamma_mu) U^dagger psi_1]`
into a Gram (`M^dagger M`) form, giving positive semidefiniteness of the
reflected Wilson-Dirac boundary block - the single hard step of fermionic RP.

This module proves that projector algebra, for the general direction `mu`
(temporal reflection takes `mu` = the time direction; kept general so the file is
convention-agnostic). It is a self-contained, kernel-checked DOWN-PAYMENT on the
RP-F crux: it does not build the reflection unitary, the positive-half selection,
or the Berezin/measure wrap (the remaining RP-F nodes), which need further finite
lattice scaffolding.

## Claim discipline

Claim label: **finite identity** (pure spin-algebra; no lattice, no analysis).
Convention: Euclidean gamma matrices (`EuclideanGamma`; Hermitian `gamma_mu`),
the oracle-pinned Wilson-Dirac convention. Draft-trust, kernel-checked,
`s o r r y`-free. Prerequisites: `EuclideanGamma`. Successor: the RP-F reflected
block factorization (`reflectedWilsonBlock_eq_gram`, still to formalize) uses
these projectors.
-/

open scoped Matrix ComplexOrder

namespace PhysicsSM.Draft.NullEdge.GateYM
namespace WilsonProjectors

open PhysicsSM.Draft.NullEdge.GateYM.EuclideanGamma

/-- The forward Wilson spin projector `P_plus = (1 - gamma_mu)/2` (the
positive-chirality / forward-hop projector at `r = 1`). -/
noncomputable def projPlus (μ : Fin 4) : Matrix (Fin 4) (Fin 4) ℂ :=
  (1 / 2 : ℂ) • (1 - γ μ)

/-- The backward Wilson spin projector `P_minus = (1 + gamma_mu)/2` (the
negative-chirality / backward-hop projector at `r = 1`). -/
noncomputable def projMinus (μ : Fin 4) : Matrix (Fin 4) (Fin 4) ℂ :=
  (1 / 2 : ℂ) • (1 + γ μ)

/-- `P_plus` is idempotent: `P_plus^2 = P_plus` (uses `gamma_mu^2 = 1`). -/
theorem projPlus_idem (μ : Fin 4) : projPlus μ * projPlus μ = projPlus μ := by
  simp only [projPlus, Matrix.smul_mul, Matrix.mul_smul, mul_sub, sub_mul, mul_one, one_mul]
  rw [γ_sq]
  module

/-- `P_minus` is idempotent: `P_minus^2 = P_minus`. -/
theorem projMinus_idem (μ : Fin 4) : projMinus μ * projMinus μ = projMinus μ := by
  simp only [projMinus, Matrix.smul_mul, Matrix.mul_smul, mul_add, add_mul, mul_one, one_mul]
  rw [γ_sq]
  module

/-- The two Wilson projectors are orthogonal: `P_plus P_minus = 0`. -/
theorem projPlus_mul_projMinus (μ : Fin 4) : projPlus μ * projMinus μ = 0 := by
  simp only [projPlus, projMinus, Matrix.smul_mul, Matrix.mul_smul, mul_add, sub_mul,
    mul_one, one_mul]
  rw [γ_sq]
  module

/-- The two Wilson projectors are orthogonal: `P_minus P_plus = 0`. -/
theorem projMinus_mul_projPlus (μ : Fin 4) : projMinus μ * projPlus μ = 0 := by
  simp only [projPlus, projMinus, Matrix.smul_mul, Matrix.mul_smul, mul_sub, add_mul,
    mul_one, one_mul]
  rw [γ_sq]
  module

/-- The Wilson projectors are complete: `P_plus + P_minus = 1`. -/
theorem projPlus_add_projMinus (μ : Fin 4) : projPlus μ + projMinus μ = 1 := by
  simp only [projPlus, projMinus]
  module

/-- `P_plus` is Hermitian: `P_plus^dagger = P_plus` (uses `gamma_mu` Hermitian). -/
theorem projPlus_herm (μ : Fin 4) : (projPlus μ)ᴴ = projPlus μ := by
  simp only [projPlus, Matrix.conjTranspose_smul, Matrix.conjTranspose_sub,
    Matrix.conjTranspose_one, γ_herm]
  norm_num

/-- `P_minus` is Hermitian: `P_minus^dagger = P_minus`. -/
theorem projMinus_herm (μ : Fin 4) : (projMinus μ)ᴴ = projMinus μ := by
  simp only [projMinus, Matrix.conjTranspose_add, Matrix.conjTranspose_smul,
    Matrix.conjTranspose_one, γ_herm]
  norm_num

/-! ### The projector-Gram PSD lemma (the linear-algebra conclusion of RP-F node N5)

A Hermitian idempotent `P` sandwiched as `A^dagger P A` is positive semidefinite,
because `A^dagger P A = (P A)^dagger (P A)`. Specialized to the Wilson projectors
`P+-`, this is exactly the statement that the reflected cross-mirror Wilson block
is PSD - the Gram (`M^dagger M`) form that the QMF5 design (`d1e7bece`) isolated
as the single hard node N5 of finite fermionic reflection positivity. Here it is
proved in the ABSTRACT projector form and specialized; wiring it to the concrete
reflected lattice block (with the actual link field `U` and the reflection
geometry) is the remaining lattice-scaffolding step. -/

/-- **Projector-Gram positive semidefiniteness.** For a Hermitian idempotent
`P` (orthogonal projector) and any `A`, the sandwiched block `A^dagger P A` is
positive semidefinite. Proof: `A^dagger P A = (P A)^dagger (P A)` using
`P = P^dagger P`. -/
theorem conj_projector_posSemidef {n k : Type*} [Fintype n] [Fintype k] [DecidableEq n]
    (P : Matrix n n ℂ) (hherm : Pᴴ = P) (hidem : P * P = P) (A : Matrix n k ℂ) :
    (Aᴴ * P * A).PosSemidef := by
  have hgram : (P * A)ᴴ * (P * A) = Aᴴ * P * A := by
    rw [Matrix.conjTranspose_mul, hherm, Matrix.mul_assoc, ← Matrix.mul_assoc P P A,
      hidem, ← Matrix.mul_assoc]
  rw [← hgram]
  exact Matrix.posSemidef_conjTranspose_mul_self _

/-- The forward-projector reflected block `A^dagger P_plus A` is PSD. -/
theorem conj_projPlus_posSemidef {k : Type*} [Fintype k] (μ : Fin 4)
    (A : Matrix (Fin 4) k ℂ) : (Aᴴ * projPlus μ * A).PosSemidef :=
  conj_projector_posSemidef _ (projPlus_herm μ) (projPlus_idem μ) A

/-- The backward-projector reflected block `A^dagger P_minus A` is PSD. -/
theorem conj_projMinus_posSemidef {k : Type*} [Fintype k] (μ : Fin 4)
    (A : Matrix (Fin 4) k ℂ) : (Aᴴ * projMinus μ * A).PosSemidef :=
  conj_projector_posSemidef _ (projMinus_herm μ) (projMinus_idem μ) A

end WilsonProjectors
end PhysicsSM.Draft.NullEdge.GateYM
