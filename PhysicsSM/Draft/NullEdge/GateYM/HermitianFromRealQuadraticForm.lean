import Mathlib

/-!
# Real-diagonal quadratic form implies Hermitian / positive semidefinite

This module supplies the "Q2 bridge" lemma requested for the reflection-
positivity / transfer-Hilbert-space construction (program document section
14, item Q2): given a complex matrix `M` whose associated quadratic form
`star x dotProduct M mulVec x` is REAL for every vector `x`, `M` is
`Matrix.IsHermitian`. Combined with a nonnegativity hypothesis on the real
part, this upgrades to `Matrix.PosSemidef`.

## Why this is needed

Mathlib's `Matrix.PosSemidef` is defined as `IsHermitian /\ (forall x, 0 <=
star x dotProduct M mulVec x)` (`Mathlib/LinearAlgebra/Matrix/PosDef.lean`),
and the constructor `Matrix.PosSemidef.of_dotProduct_mulVec_nonneg` REQUIRES
`IsHermitian` as a separate hypothesis - it is not derivable from the
quadratic-form-nonneg condition alone by that lemma's signature. Mathlib
DOES have the operator-level fact that "quadratic form real for all v"
implies symmetric for a linear map on a COMPLEX inner product space
(`LinearMap.isSymmetric_iff_inner_map_self_real`,
`Mathlib/Analysis/InnerProductSpace/Symmetric.lean`), but no packaged
matrix-level statement. This file fills that gap directly at the matrix
level (no `EuclideanSpace`/`PiLp` plumbing), via the standard polarization
argument specialized to three test vectors `Pi.single i 1`,
`Pi.single i 1 + Pi.single j 1`, `Pi.single i 1 + Pi.single j Complex.I`.

The "over `Complex`, not over `Real`" hypothesis is essential: over `ℝ`
every quadratic form is trivially real, but not every real matrix is
symmetric (e.g. `!![0,1;-1,0]`), so the statement would be false there.

## Provenance

Strategy job requested from and proved by Aristotle (Harmonic), Aristotle
project `72cccd22-43c8-41bc-91af-f67b13521e72`
(`AgentTasks/aristotle-prompts/ym-q2-hermitian-polarization-strategy-20260704.prompt.md`,
report `AgentTasks/aristotle-output/ym-q2-hermitian-polarization-strategy-20260704/.../HERMITIAN_BRIDGE_REPORT.md`,
local-ignored). Verified by this project: `lake env lean` clean on this
file standalone and inside the `GateYM` aggregator, axiom footprint
`[propext, Classical.choice, Quot.sound]` (standard, no
`Lean.ofReduceBool`/`Lean.trustCompiler`), `s o r r y`-free.

Claim label: **finite identity** (pure linear algebra, nothing
physics-specific). Draft-trust: kernel-checked, no `s o r r y`, no
`n a t i v e _ d e c i d e`.
-/

open Matrix
open scoped ComplexOrder

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace HermitianBridge

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Value of the sesquilinear form `star (·) ⬝ᵥ M *ᵥ (·)` on two "single"
basis vectors: `star (Pi.single i a) ⬝ᵥ M *ᵥ (Pi.single j b) = star a * M i j * b`. -/
theorem star_single_dotProduct_mulVec_single (M : Matrix n n ℂ) (i j : n) (a b : ℂ) :
    star (Pi.single i a) ⬝ᵥ M *ᵥ (Pi.single j b) = star a * M i j * b := by
  rw [dotProduct, Finset.sum_eq_single i]
  · simp [Matrix.mulVec_single, mul_assoc]
  · intro k _ hk; simp [Pi.single_eq_of_ne hk]
  · intro h; exact absurd (Finset.mem_univ i) h

omit [DecidableEq n] in
/-- Bilinear expansion of the quadratic form on a sum:
`Q(x + y) = Q(x) + Q(y) + (B(x,y) + B(y,x))`. -/
theorem quadForm_add (M : Matrix n n ℂ) (x y : n → ℂ) :
    star (x + y) ⬝ᵥ M *ᵥ (x + y)
      = star x ⬝ᵥ M *ᵥ x + star y ⬝ᵥ M *ᵥ y
        + (star x ⬝ᵥ M *ᵥ y + star y ⬝ᵥ M *ᵥ x) := by
  simp only [Matrix.mulVec_add, star_add, add_dotProduct, dotProduct_add]; ring

/-- **Polarization / realness implies Hermitian.** If `star x ⬝ᵥ M *ᵥ x` is
real for every `x`, then `M` is Hermitian. This is the converse direction
`Matrix.PosSemidef.of_dotProduct_mulVec_nonneg` does not supply. -/
theorem hermitian_of_forall_dotProduct_real (M : Matrix n n ℂ)
    (hreal : ∀ x : n → ℂ, (star x ⬝ᵥ M *ᵥ x).im = 0) : M.IsHermitian := by
  rw [Matrix.IsHermitian.ext_iff]
  intro i j
  have hii : (M i i).im = 0 := by
    have := hreal (Pi.single i 1); simpa [star_single_dotProduct_mulVec_single] using this
  have hjj : (M j j).im = 0 := by
    have := hreal (Pi.single j 1); simpa [star_single_dotProduct_mulVec_single] using this
  have h1 := hreal (Pi.single i 1 + Pi.single j 1)
  rw [quadForm_add] at h1
  have h2 := hreal (Pi.single i 1 + Pi.single j Complex.I)
  rw [quadForm_add] at h2
  simp only [star_single_dotProduct_mulVec_single, one_mul, mul_one, star_one,
    Complex.add_im, Complex.mul_im, Complex.mul_re, Complex.I_im, Complex.I_re,
    Complex.star_def, Complex.conj_re, Complex.conj_im, hii, hjj] at h1 h2
  apply Complex.ext
  · simp only [Complex.star_def, Complex.conj_re]; linarith
  · simp only [Complex.star_def, Complex.conj_im]; linarith

/-- **Real + nonnegative-real-part quadratic form implies positive
semidefinite.** The Hermitian-ness is DERIVED (not assumed) from realness
via polarization, so a caller need only check `IsReflectionPositive`-style
`0 <= reflectionForm ...` (which bundles both realness and nonnegativity in
`ComplexOrder`), with no separate symmetry hypothesis. -/
theorem posSemidef_of_forall_dotProduct_real_nonneg (M : Matrix n n ℂ)
    (hreal : ∀ x : n → ℂ, (star x ⬝ᵥ M *ᵥ x).im = 0)
    (hnonneg : ∀ x : n → ℂ, 0 ≤ (star x ⬝ᵥ M *ᵥ x).re) : M.PosSemidef := by
  refine Matrix.PosSemidef.of_dotProduct_mulVec_nonneg
    (hermitian_of_forall_dotProduct_real M hreal) (fun x => ?_)
  rw [Complex.le_def]
  exact ⟨by simpa using hnonneg x, by simpa using (hreal x).symm⟩

end HermitianBridge
end GateYM
end NullEdge
end Draft
end PhysicsSM
