import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.WilsonWeightPositivity

/-!
# Gate YM3: single-link congruence/compression PSD engine

CORRECTED (2026-07-04, claude) after Aristotle red-team `cb437537`'s
adversarial statement audit, finding 1 (highest-ranked): this module's
original docstring and one theorem name ("Corollary 3b", "the transfer
matrix", "RP-LINK proper") overstated what is indexed. What is actually
here is a SINGLE-LINK PSD congruence/compression engine, abstract over
an arbitrary finite index type `iota` - there is no lattice ensemble, no
tensor-product-of-per-link-kernels `K`, no Gauss projector as an actual
idempotent, and no reflection-positivity inequality anywhere in this
file. Freeze section 5's Corollary 3b (tensor + `V^(1/2)` congruence +
Gauss compression) remains the INTENDED destination once a lattice
module (`G^E`, Wilson action, Gauss projector as a genuine idempotent)
exists to instantiate `K` and `B` correctly - that module is not yet
built (see `idea:rp-link-scope` in the run's DISCUSSION.md). This file
supplies exactly the two citations that assembly will need:

1. `transferMatrix_posSemidef`: for ANY PSD `K` (not necessarily a
   lattice transfer kernel) and any real diagonal weight `v`, the
   diagonal-square-root congruence `diagonal(sqrt v) * K * diagonal(sqrt v)`
   is PSD. Direct corollary of `Matrix.PosSemidef.mul_mul_conjTranspose_same`
   - PSD survives congruence by ANY matrix, so `v`'s sign plays no role
   in this specific proof (see the red-team's finding 3: the auditor
   confirmed the earlier `hv : 0 <= v i` hypothesis was inert - `Real.sqrt`
   of a negative number is `0` in Mathlib, so the diagonal square root is
   well-defined and the congruence argument goes through regardless of
   sign - REMOVED here rather than left as decoration).
2. `compression_posSemidef`: `B * T * Bᴴ` is PSD for PSD `T` and ANY `B`
   (not necessarily idempotent/self-adjoint/the Gauss average) - the
   bare congruence fact a genuine Gauss-projector compression will need
   to cite, once `B` is instantiated at an actual projector elsewhere.

`singleLinkWilsonKernel_diagCongruence_posSemidef` (renamed from
`transferPositivity_wilsonKernel_diag` per the red-team's suggested
name) instantiates (1) at the concrete Wilson-weight kernel from
`WilsonWeightPositivity.lean` - honestly, this is "one temporal link's
Wilson kernel, conjugated by an abstract diagonal, is PSD," not yet
"the lattice transfer operator is PSD."

Draft-trust: kernel-checked, no `s o r r y`, no `n a t i v e _ d e c i d e`.
Axiom footprint `[propext, Classical.choice, Quot.sound]` (verified via
`lean_verify`). Claim label: **finite identity**, single-link scope only.
Prerequisites: Mathlib + `WilsonWeightPositivity.lean`.
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

/-- Diagonal-square-root congruence of a PSD kernel `K` is PSD, for ANY
real diagonal weight `v` (no sign hypothesis: `Real.sqrt` of a negative
number is `0` in Mathlib, so the diagonal square root is well-defined
regardless, and PSD survives congruence by any matrix - confirmed by
Aristotle red-team `cb437537` finding 3, which is why no `hv` hypothesis
appears here). Direct instance of
`Matrix.PosSemidef.mul_mul_conjTranspose_same`. Physical fidelity to "the
diagonal really is `V^(1/2)` for a nonnegative weight `V`" is supplied
separately by `diagonalSqrt_mul_self`, which DOES need `v >= 0`. -/
theorem transferMatrix_posSemidef {ι : Type*} [Fintype ι] [DecidableEq ι]
    {K : Matrix ι ι ℝ} (hK : K.PosSemidef) (v : ι → ℝ) :
    (Matrix.diagonal (fun i => Real.sqrt (v i)) * K
      * (Matrix.diagonal (fun i => Real.sqrt (v i)))ᴴ).PosSemidef :=
  hK.mul_mul_conjTranspose_same _

/-- Any compression `B * T * Bᴴ` of a PSD matrix `T` is PSD, for an
ARBITRARY matrix `B` - this does NOT encode that `B` is a projector
(idempotent, self-adjoint) or the Gauss-average specifically; it is the
bare congruence fact a genuine Gauss-projector compression will cite
once `B` is instantiated at an actual projector elsewhere (per Aristotle
red-team `cb437537` finding on this theorem: flagging the gap between
"arbitrary compression is PSD" and "the Gauss projector yields the
physically correct compressed transfer operator" so it is not
mis-read). -/
theorem compression_posSemidef {ι κ : Type*} [Fintype ι] [Fintype κ]
    {T : Matrix ι ι ℝ} (hT : T.PosSemidef) (B : Matrix κ ι ℝ) :
    (B * T * Bᴴ).PosSemidef :=
  hT.mul_mul_conjTranspose_same B

/-- Instantiating `transferMatrix_posSemidef` at the concrete Wilson-weight
kernel from `WilsonWeightPositivity.lean`: one temporal link's Wilson
kernel, conjugated by an arbitrary diagonal, is PSD. Renamed from
`transferPositivity_wilsonKernel_diag` (Aristotle red-team `cb437537`
finding 1: the old name and docstring implied a lattice transfer matrix;
this is a single-link kernel over `G`, not the C-8 tensor-product
transfer operator). -/
theorem singleLinkWilsonKernel_diagCongruence_posSemidef
    {G : Type*} [Group G] [Fintype G] [DecidableEq G]
    {n : ℕ} (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (v : G → ℝ) :
    (Matrix.diagonal (fun g => Real.sqrt (v g)) * WilsonWeightPositivity.wilsonKernel beta rho
      * (Matrix.diagonal (fun g => Real.sqrt (v g)))ᴴ).PosSemidef :=
  transferMatrix_posSemidef
    (WilsonWeightPositivity.wilsonKernel_posSemidef beta hbeta rho hmul hone hunit) v

end TransferPositivity
end GateYM
end NullEdge
end Draft
end PhysicsSM
