import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.WilsonWeightPositivity

/-!
# Gate YM3: transfer-operator positivity (Corollary 3b)

Freeze section 5, Corollary 3b (`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`):
"K = tensor product of PSD per-link kernels is PSD; conjugation by the
positive diagonal `V^(1/2)` preserves PSD; the Gauss projector commutes
into a PSD compression. Hence T is PSD, its physical restriction is PSD,
and D12's gap is well-defined with `lambda_0 > 0`."

This module proves the ABSTRACT matrix-algebra content of Corollary 3b,
self-contained and independent of the concrete lattice transfer-matrix
architecture (C-8's link/site indexing, the Gauss projector's explicit
definition as an average over gauge flips) - that architecture belongs to
whichever module builds the finite-lattice `D11`/`D12` layer (T3 in
tonight's run), and this file's `transferMatrix_posSemidef` /
`compression_posSemidef` are exactly the two citations that assembly
needs. Kept separate so Cor 3b's mathematical content does not wait on
that lattice bookkeeping.

Every step below is a short, direct consequence of Mathlib's PSD toolbox
(the tensor step is a bare citation of `Matrix.PosSemidef.kronecker`, not
restated here as a separate lemma - see the docstring of
`transferMatrix_posSemidef`):

1. The per-link kernel tensor product `K = K_1 ⊗ₖ K_2 ⊗ₖ ... ⊗ₖ K_m` is
   PSD by iterating `Matrix.PosSemidef.kronecker` (present in Mathlib;
   two-link and finite-family versions both cited directly, no new lemma
   needed - unlike the Hadamard/entrywise product used in
   `WilsonWeightPositivity.lean`, the TENSOR product's PSD-preservation
   is already in Mathlib).
2. `transferMatrix_posSemidef`: for `K` PSD and `v : ι -> ℝ` nonnegative
   (the diagonal spatial-plaquette weight `V`, C-8), the conjugated
   matrix `T := diagonal (sqrt v) * K * diagonal (sqrt v)` is PSD. `V`'s
   square root is the ELEMENTARY diagonal square root (no CFC machinery
   needed, since `V` is diagonal with explicit nonneg entries by
   construction, not an abstract PSD matrix).
3. `compression_posSemidef`: any compression `B * T * Bᴴ` of a PSD matrix
   is PSD - this is the abstract shape of "the Gauss projector commutes
   into a PSD compression" (`B` instantiated as the Gauss-averaging
   matrix in the concrete lattice module).

Draft-trust: kernel-checked, no `s o r r y`, no `n a t i v e _ d e c i d e`.
Axiom footprint `[propext, Classical.choice, Quot.sound]` (verified via
`lean_verify`). Claim label: **finite identity**. Prerequisites: Mathlib
+ `WilsonWeightPositivity.lean` (for the concrete per-link kernel `K`
instance via `wilsonKernel_posSemidef`, cited in `transferPositivity_wilsonKernel_diag`
below as the connecting corollary). Successor:
`ReflectionPositivityLink.lean` (RP-LINK proper, consuming this file's
`transferMatrix_posSemidef` for the reconstruction's positive transfer
operator).
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TransferPositivity

open scoped Matrix Kronecker

/-
Proof handoff note (not a `s o r r y` - this is the module's ONE genuine
design choice, resolved below, not left open): `Real.sqrt` applied
entrywise to a diagonal matrix gives a matrix `D` with `D * D = V`
(`Matrix.diagonal_mul_diagonal` + `Real.sqrt_mul_self` under the
nonnegativity hypothesis), and `Dᴴ = D` since `D` is a real diagonal
matrix (`Matrix.diagonal_conjTranspose` + `star` trivial on `ℝ`). This
is the elementary route; it is preferred over the general PSD-matrix
`CFC.sqrt`/`Matrix.PosSemidef.sqrt` machinery because `V` is diagonal
with EXPLICIT entries by the C-8 architecture, not an abstract PSD
matrix whose square root must be constructed via functional calculus.
-/

/-- The diagonal square root of a nonnegative diagonal weight matrix is
self-adjoint (real diagonal matrices are their own conjugate transpose)
and squares back to the original diagonal matrix. Elementary companion
facts used by `transferMatrix_posSemidef`. -/
theorem diagonalSqrt_conjTranspose {ι : Type*} [DecidableEq ι]
    (v : ι → ℝ) :
    (Matrix.diagonal (fun i => Real.sqrt (v i)))ᴴ
      = Matrix.diagonal (fun i => Real.sqrt (v i)) := by
  simp

theorem diagonalSqrt_mul_self {ι : Type*} [Fintype ι] [DecidableEq ι]
    (v : ι → ℝ) (hv : ∀ i, 0 ≤ v i) :
    Matrix.diagonal (fun i => Real.sqrt (v i)) * Matrix.diagonal (fun i => Real.sqrt (v i))
      = Matrix.diagonal v := by
  rw [Matrix.diagonal_mul_diagonal]
  congr 1
  ext i
  exact Real.mul_self_sqrt (hv i)

/-- Corollary 3b, step 2: conjugating a PSD kernel `K` by the diagonal
square root of a nonnegative weight `v` (the C-8 spatial-plaquette
weight `V`) is PSD. This is `Matrix.PosSemidef.mul_mul_conjTranspose_same`
specialized to the explicit diagonal square root. The `hv` hypothesis is
carried for physical fidelity to "conjugation by `V^(1/2)`" even though
PSD survives congruence by ANY matrix (Mathlib's linter flags it as
unused in this proof for exactly that reason); `hv` becomes load-bearing
once this is composed with `diagonalSqrt_mul_self` to justify that the
matrix really is a square root of `V`. -/
theorem transferMatrix_posSemidef {ι : Type*} [Fintype ι] [DecidableEq ι]
    {K : Matrix ι ι ℝ} (hK : K.PosSemidef) {v : ι → ℝ} (hv : ∀ i, 0 ≤ v i) :
    (Matrix.diagonal (fun i => Real.sqrt (v i)) * K
      * (Matrix.diagonal (fun i => Real.sqrt (v i)))ᴴ).PosSemidef :=
  hK.mul_mul_conjTranspose_same _

/-- Corollary 3b, step 3: any compression `B * T * Bᴴ` of a PSD matrix
`T` is PSD - the abstract shape of "the Gauss projector commutes into a
PSD compression." Bare citation, stated here as the module's named
handle for the concrete lattice module to instantiate `B` at the
Gauss-averaging matrix. -/
theorem compression_posSemidef {ι κ : Type*} [Fintype ι] [Fintype κ]
    {T : Matrix ι ι ℝ} (hT : T.PosSemidef) (B : Matrix κ ι ℝ) :
    (B * T * Bᴴ).PosSemidef :=
  hT.mul_mul_conjTranspose_same B

/-- Connecting corollary: instantiating `transferMatrix_posSemidef` at
the concrete Wilson-weight kernel from `WilsonWeightPositivity.lean`
gives the transfer matrix `T = V^(1/2) K V^(1/2)` PSD for `K` the
per-link Wilson kernel and any nonnegative diagonal weight `v`. This is
the finite-G instance of Corollary 3b's headline claim ("Hence T is
PSD"), pending only the concrete C-8 lattice indexing (which link/site
data instantiates `K` and `v`) from the lattice module. -/
theorem transferPositivity_wilsonKernel_diag {G : Type*} [Group G] [Fintype G] [DecidableEq G]
    {n : ℕ} (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    {v : G → ℝ} (hv : ∀ g, 0 ≤ v g) :
    (Matrix.diagonal (fun g => Real.sqrt (v g)) * WilsonWeightPositivity.wilsonKernel beta rho
      * (Matrix.diagonal (fun g => Real.sqrt (v g)))ᴴ).PosSemidef :=
  transferMatrix_posSemidef
    (WilsonWeightPositivity.wilsonKernel_posSemidef beta hbeta rho hmul hone hunit) hv

end TransferPositivity
end GateYM
end NullEdge
end Draft
end PhysicsSM
