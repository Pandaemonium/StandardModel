import Mathlib
import PhysicsSM.NullStrand.Conventions

/-!
# NullStrand.Clock.InternalHolonomy

Finite ordered-products and unitarity lemmas for internal holonomy.

This module provides a small Lean kernel-checked version of the stage 11
"internal holonomy" goals in `Sources/NullStrand_Lean_Roadmap.md`.
-/

noncomputable section

namespace PhysicsSM.NullStrand.Clock

open Matrix Complex
open scoped BigOperators

/-- Noncommutative ordered product of finite matrix factors, in list order. -/
def internalHolonomy {d : Type*} [Fintype d] [DecidableEq d]
    (segments : List (Matrix d d ℂ)) : Matrix d d ℂ :=
  segments.prod

/-- Single holonomy step from a real duration and Hermitian generator. -/
def internalSegment {d : Type*} [Fintype d] [DecidableEq d] (Δs : ℝ)
    (M : Matrix d d ℂ) : Matrix d d ℂ :=
  NormedSpace.exp (-(Complex.I : ℂ) • (Complex.ofReal Δs • M))

/-- Unitary one-step holonomy for Hermitian generator. -/
theorem internalSegment_unitary_of_hermitian {d : Type*} [Fintype d] [DecidableEq d]
    (Δs : ℝ) (M : Matrix d d ℂ) (hHermitian : M.IsHermitian) :
    internalSegment Δs M ∈ Matrix.unitaryGroup d ℂ := by
  -- Aristotle handoff (HOL-002, manifest node HOL-002): mathematically this is
  --   `NormedSpace.exp_mem_unitary_of_mem_skewAdjoint hSkew`
  -- with `hSkew : (-I) • (ofReal Δs • M) ∈ skewAdjoint (Matrix d d ℂ)` obtained from
  --   `hMi.smul_mem_skewAdjoint hI`,  `hMi : IsSelfAdjoint (ofReal Δs • M)`,
  --   `hI : (-I) ∈ skewAdjoint ℂ`,
  -- then bridged to `Matrix.unitaryGroup d ℂ` via `Matrix.mem_unitaryGroup_iff`.
  -- BLOCKER: synthesizing `NormedSpace.exp` / `NormedAlgebra` on `Matrix d d ℂ`
  -- loops on an instance diamond (cf. `selfAdjoint.expUnitary`, which inserts
  -- `let +nondep : NormedAlgebra ℚ A := .restrictScalars ℚ ℂ A` to converge),
  -- giving a `whnf` heartbeat timeout. Needs the right scalar-tower setup.
  sorry

/-- Ordered holonomy for a finite `Fin`-indexed path. -/
def internalHolonomyPath {N : ℕ} {d : Type*} [Fintype d] [DecidableEq d]
    (Δs : Fin (N + 1) → ℝ) (M : Fin (N + 1) → Matrix d d ℂ) : Matrix d d ℂ :=
  internalHolonomy (List.ofFn fun i => internalSegment (Δs i) (M i))

/-- Internal holonomy is multiplicative under concatenation of ordered products. -/
theorem internalHolonomy_concat {d : Type*} [Fintype d] [DecidableEq d]
    (left right : List (Matrix d d ℂ)) :
    internalHolonomy (left ++ right) = internalHolonomy left * internalHolonomy right := by
  simp [internalHolonomy, List.prod_append]

/-- If each step is `exp (-I * Δs * H)` with Hermitian `H`, the finite holonomy is unitary. -/
theorem internalHolonomy_unitary_of_hermitian {N : ℕ} {d : Type*}
    [Fintype d] [DecidableEq d] (Δs : Fin (N + 1) → ℝ)
    (M : Fin (N + 1) → Matrix d d ℂ)
    (hHermitian : ∀ i : Fin (N + 1), (M i).IsHermitian) :
    internalHolonomyPath Δs M ∈ Matrix.unitaryGroup d ℂ := by
  have hStep :
      ∀ i : Fin (N + 1), internalSegment (Δs i) (M i) ∈ Matrix.unitaryGroup d ℂ := by
    intro i
    exact internalSegment_unitary_of_hermitian (d := d) (Δs i) (M i) (hHermitian i)
  have hList :
      ∀ x ∈ List.ofFn (fun i : Fin (N + 1) => internalSegment (Δs i) (M i)),
        x ∈ Matrix.unitaryGroup d ℂ := by
    intro x hx
    obtain ⟨i, rfl⟩ := List.mem_ofFn.mp hx
    exact hStep i
  have hprod := list_prod_mem (S := Matrix.unitaryGroup d ℂ) hList
  simpa only [internalHolonomyPath, internalHolonomy] using hprod

/-- Conjugating each segment by a fixed unitary gives a conjugated holonomy. -/
theorem internalHolonomy_gaugeCovariant {d : Type*} [Fintype d] [DecidableEq d]
    (U : Matrix.unitaryGroup d ℂ) (segments : List (Matrix d d ℂ)) :
    internalHolonomy (segments.map (fun M => (U : Matrix d d ℂ) * M * ((U : Matrix d d ℂ))⁻¹)) =
      (U : Matrix d d ℂ) * internalHolonomy segments * ((U : Matrix d d ℂ))⁻¹ := by
  -- Telescoping conjugation needs `U⁻¹ * U = 1`, which holds because `U` is unitary.
  have hUinv : ((U : Matrix d d ℂ) : Matrix d d ℂ)⁻¹ * ((U : Matrix d d ℂ) : Matrix d d ℂ) = 1 := by
    have hstar : star ((U : Matrix d d ℂ) : Matrix d d ℂ) * ((U : Matrix d d ℂ) : Matrix d d ℂ) = 1 :=
      (Matrix.mem_unitaryGroup_iff').1 U.property
    have hinv : ((U : Matrix d d ℂ) : Matrix d d ℂ)⁻¹ = star ((U : Matrix d d ℂ) : Matrix d d ℂ) :=
      Matrix.inv_eq_left_inv hstar
    rw [hinv]; exact hstar
  have hUinv' : ((U : Matrix d d ℂ) : Matrix d d ℂ) * ((U : Matrix d d ℂ) : Matrix d d ℂ)⁻¹ = 1 := by
    have hstar : ((U : Matrix d d ℂ) : Matrix d d ℂ) * star ((U : Matrix d d ℂ) : Matrix d d ℂ) = 1 :=
      (Matrix.mem_unitaryGroup_iff).1 U.property
    have hinv : ((U : Matrix d d ℂ) : Matrix d d ℂ)⁻¹ = star ((U : Matrix d d ℂ) : Matrix d d ℂ) :=
      Matrix.inv_eq_left_inv ((Matrix.mem_unitaryGroup_iff').1 U.property)
    rw [hinv]; exact hstar
  induction segments with
  | nil =>
      simp [internalHolonomy, hUinv']
  | cons a segs ih =>
      simp only [List.map_cons, internalHolonomy, List.prod_cons] at ih ⊢
      rw [ih]
      have key : (((U : Matrix d d ℂ) : Matrix d d ℂ) * a * ((U : Matrix d d ℂ))⁻¹) * (((U : Matrix d d ℂ)) * segs.prod * ((U : Matrix d d ℂ))⁻¹)
          = ((U : Matrix d d ℂ)) * a * (((U : Matrix d d ℂ))⁻¹ * ((U : Matrix d d ℂ))) * segs.prod * ((U : Matrix d d ℂ))⁻¹ := by
        simp only [mul_assoc]
      rw [key, hUinv]
      simp only [mul_assoc, mul_one]

/-- Path-level gauge covariance follows by unfolding `internalHolonomyPath`. -/
theorem internalHolonomy_gaugeCovariant_path {N : ℕ} {d : Type*}
    [Fintype d] [DecidableEq d] (U : Matrix.unitaryGroup d ℂ) (Δs : Fin (N + 1) → ℝ)
    (M : Fin (N + 1) → Matrix d d ℂ) :
    internalHolonomyPath Δs (fun i => (U : Matrix d d ℂ) * M i * ((U : Matrix d d ℂ))⁻¹) =
      (U : Matrix d d ℂ) * internalHolonomyPath Δs M * ((U : Matrix d d ℂ))⁻¹ := by
  -- Aristotle handoff (HOL-003, manifest node HOL-003): reduce via
  -- `internalHolonomy_gaugeCovariant` once the matrix-exponential conjugation
  -- identity `internalSegment Δs (U * M * U⁻¹) = U * internalSegment Δs M * U⁻¹`
  -- (i.e. `NormedSpace.exp (U * X * U⁻¹) = U * NormedSpace.exp X * U⁻¹` for unitary
  -- `U`) is available. That conjugation/naturality step on `Matrix d d ℂ` is the
  -- open part; the manifest flags the gauge action on Yukawa blocks as
  -- underspecified, so the representation must be pinned before closing this.
  sorry

end PhysicsSM.NullStrand.Clock
