import Mathlib

/-!
# Flat affine dual-soldered commutator symbol theorem

This file realises task **T13** of the null-edge unified-mass proof chain (the
"missing seam"): the finite, flat/affine commutator and symbol theorem for the
**dual-soldered** null-edge operator.

## Conventions (see `docs/NULLSTRAND.md`, `Sources/..._Working_Plan.md` §17-20)

We work over a field `𝕜`, with `W` a `𝕜`-vector space of positions and `V` a
`𝕜`-vector space of spinor values. A field is a function `ψ : W → V`.

* `Ind` is an abstract finite index type of edge directions `a`.
* `ell a : W` is the primitive **null edge direction** `ℓ_a`.
* `C a : V →ₗ[𝕜] V` models the **dual-soldered** Clifford symbol `c(αᵃ)`.
  It is taken to be an arbitrary endomorphism for the finite commutator
  identity, exactly as recommended by the task statement.
* `h : 𝕜` is the mesh.

The *active dual-soldered architecture* is the operator
`D_h = ∑ₐ c(αᵃ) (T_a - I)/h`, here `nullEdgeOp`, where `T_a ψ (x) = ψ(x + h ℓ_a)`
is edge translation. We deliberately **do not** use the diagonal operator
`∑ₐ c(ℓ_aᵇ) ∇_{ℓ_a}` (the diagonal trace obstruction): the symbol is carried by
the *dual* covectors `αᵃ`, not by the flats `ℓ_aᵇ`.

## Main results

* `nullEdge_commutator` : the exact finite commutator formula
  `[D_h, M_f] ψ (x) = ∑ₐ c(αᵃ) ((f(x + h ℓ_a) - f(x))/h) T_a ψ (x)`.
* `nullEdge_commutator_affine` : if `f` is affine (`f = c₀ + φ`, `φ` linear) and
  transport is trivial (`T_a ψ = ψ`), then `[D_h, M_f] = c(df)`, with the
  Clifford action assembled in the dual frame as `cliffOp`.
* `dual_frame_duality` / `dual_frame_reconstruction` : the dual-solder frame
  relations `αᵃ(ℓ_b) = δᵃ_b` and `df = ∑ₐ df(ℓ_a) αᵃ`, modelling
  `αᵃ = bW.coord a` for a basis `bW` with `bW a = ℓ_a`.
* `clifford_symbol_reconstruction` : for a Clifford soldering map linear in the
  covector with `c(αᵃ) = C a`, one has `c(ξ) = ∑ₐ ξ(ℓ_a) C a`, i.e. the
  dual-frame reconstruction of the symbol underlying `cliffOp`.

This is finite algebra and symbol reconstruction; the smooth continuum limit is
explicitly **not** treated here.
-/

namespace PhysicsSM
namespace Draft

open Finset Module

variable {𝕜 : Type*} [Field 𝕜]
variable {V W : Type*} [AddCommGroup V] [Module 𝕜 V] [AddCommGroup W] [Module 𝕜 W]
variable {Ind : Type*} [Fintype Ind]

/-- Edge translation `T_a ψ (x) = ψ(x + h ℓ_a)` along the null edge `ℓ_a`. -/
def shiftOp (ell : Ind → W) (h : 𝕜) (a : Ind) (psi : W → V) : W → V :=
  fun x => psi (x + h • ell a)

/-- The dual-soldered finite null-edge operator
`D_h ψ (x) = ∑ₐ c(αᵃ) (ψ(x + h ℓ_a) - ψ(x))/h`. -/
noncomputable def nullEdgeOp (C : Ind → (V →ₗ[𝕜] V)) (ell : Ind → W) (h : 𝕜)
    (psi : W → V) : W → V :=
  fun x => ∑ a, h⁻¹ • C a (psi (x + h • ell a) - psi x)

/-- Multiplication by a scalar function, `M_f ψ (x) = f(x) ψ(x)`. -/
def mulOp (f : W → 𝕜) (psi : W → V) : W → V := fun x => f x • psi x

/-- The dual-frame Clifford action of a covector `ξ`, namely
`c(ξ) = ∑ₐ ξ(ℓ_a) c(αᵃ)` acting pointwise. With the dual-solder reconstruction
`ξ = ∑ₐ ξ(ℓ_a) αᵃ` this is exactly the symbol `c(ξ)`. -/
def cliffOp (C : Ind → (V →ₗ[𝕜] V)) (ell : Ind → W) (xi : W →ₗ[𝕜] 𝕜)
    (psi : W → V) : W → V :=
  fun x => ∑ a, xi (ell a) • C a (psi x)

/-- **Exact finite commutator formula** for the dual-soldered null-edge operator.

`[D_h, M_f] ψ (x) = ∑ₐ c(αᵃ) ((f(x + h ℓ_a) - f(x))/h) T_a ψ (x)`,

where `T_a ψ (x) = ψ(x + h ℓ_a)`. Only the linearity of each Clifford symbol
`C a` is used; the edge displacements `ℓ_a` and the mesh `h` are arbitrary. -/
theorem nullEdge_commutator (C : Ind → (V →ₗ[𝕜] V)) (ell : Ind → W) (h : 𝕜)
    (f : W → 𝕜) (psi : W → V) (x : W) :
    nullEdgeOp C ell h (mulOp f psi) x - mulOp f (nullEdgeOp C ell h psi) x
      = ∑ a, (h⁻¹ * (f (x + h • ell a) - f x)) • C a (psi (x + h • ell a)) := by
  simp only [nullEdgeOp, mulOp, Finset.smul_sum]
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro a _
  simp only [map_sub, map_smul]
  module

/-- Function-level (operator) form of `nullEdge_commutator`, phrased with the
translation operator `shiftOp`. -/
theorem nullEdge_commutator_fun (C : Ind → (V →ₗ[𝕜] V)) (ell : Ind → W) (h : 𝕜)
    (f : W → 𝕜) (psi : W → V) :
    (fun x => nullEdgeOp C ell h (mulOp f psi) x - mulOp f (nullEdgeOp C ell h psi) x)
      = fun x => ∑ a, (h⁻¹ * (f (x + h • ell a) - f x)) • C a (shiftOp ell h a psi x) := by
  funext x
  simpa [shiftOp] using nullEdge_commutator C ell h f psi x

/-- **Affine-symbol corollary.** If `f` is affine, `f = c₀ + φ` with `φ` linear
(so `df = φ`), and transport is trivial (`T_a ψ = ψ`), then the commutator equals
the dual-frame Clifford action of the differential:

`[D_h, M_f] = c(df)`,

using `(f(x + h ℓ_a) - f(x))/h = φ(ℓ_a) = df(ℓ_a)`. -/
theorem nullEdge_commutator_affine (C : Ind → (V →ₗ[𝕜] V)) (ell : Ind → W) (h : 𝕜)
    (c0 : 𝕜) (phi : W →ₗ[𝕜] 𝕜) (psi : W → V) (hh : h ≠ 0)
    (htriv : ∀ a x, psi (x + h • ell a) = psi x) (x : W) :
    nullEdgeOp C ell h (mulOp (fun y => c0 + phi y) psi) x
      - mulOp (fun y => c0 + phi y) (nullEdgeOp C ell h psi) x
      = cliffOp C ell phi psi x := by
  rw [nullEdge_commutator]
  simp only [cliffOp]
  apply Finset.sum_congr rfl
  intro a _
  rw [htriv]
  have hc : (c0 + phi (x + h • ell a)) - (c0 + phi x) = h * phi (ell a) := by
    simp only [map_add, map_smul, smul_eq_mul]; ring
  rw [hc, ← mul_assoc, inv_mul_cancel₀ hh, one_mul]

/-- Function-level (operator) form of the affine corollary: `[D_h, M_f] = c(df)`. -/
theorem nullEdge_commutator_affine_fun (C : Ind → (V →ₗ[𝕜] V)) (ell : Ind → W) (h : 𝕜)
    (c0 : 𝕜) (phi : W →ₗ[𝕜] 𝕜) (psi : W → V) (hh : h ≠ 0)
    (htriv : ∀ a x, psi (x + h • ell a) = psi x) :
    (fun x => nullEdgeOp C ell h (mulOp (fun y => c0 + phi y) psi) x
        - mulOp (fun y => c0 + phi y) (nullEdgeOp C ell h psi) x)
      = cliffOp C ell phi psi := by
  funext x
  exact nullEdge_commutator_affine C ell h c0 phi psi hh htriv x

/-! ### Dual-solder frame reconstruction

We model the dual covectors `αᵃ` by `bW.coord a` for a basis `bW` whose vectors
are the null edges, `bW a = ℓ_a`. Then `αᵃ(ℓ_b) = δᵃ_b` and any covector `ξ`
reconstructs as `ξ = ∑ₐ ξ(ℓ_a) αᵃ`. -/

omit [Fintype Ind] in
/-- The dual-solder duality relation `αᵃ(ℓ_b) = δᵃ_b`. -/
theorem dual_frame_duality [DecidableEq Ind] (bW : Basis Ind 𝕜 W) (a b : Ind) :
    bW.coord a (bW b) = if a = b then 1 else 0 := by
  rw [Basis.coord_apply, Basis.repr_self, Finsupp.single_apply]
  simp [eq_comm]

/-- The dual-solder reconstruction of a covector: `df = ∑ₐ df(ℓ_a) αᵃ`, here
`ξ = ∑ₐ ξ(bW a) • bW.coord a`. -/
theorem dual_frame_reconstruction (bW : Basis Ind 𝕜 W) (xi : W →ₗ[𝕜] 𝕜) :
    xi = ∑ a, xi (bW a) • bW.coord a := by
  apply bW.ext
  intro i
  simp

/-- **Symbol reconstruction.** For a Clifford soldering map `cliffSym` that is
linear in the covector and satisfies `c(αᵃ) = C a` on the dual frame, the symbol
of an arbitrary covector reconstructs as `c(ξ) = ∑ₐ ξ(ℓ_a) C a`. Combined with
`nullEdge_commutator_affine`, this exhibits `[D_h, M_f] = c(df)` as the genuine
Clifford symbol of the affine differential. -/
theorem clifford_symbol_reconstruction (C : Ind → (V →ₗ[𝕜] V)) (bW : Basis Ind 𝕜 W)
    (cliffSym : (W →ₗ[𝕜] 𝕜) →ₗ[𝕜] (V →ₗ[𝕜] V))
    (hC : ∀ a, cliffSym (bW.coord a) = C a) (xi : W →ₗ[𝕜] 𝕜) :
    cliffSym xi = ∑ a, xi (bW a) • C a := by
  conv_lhs => rw [dual_frame_reconstruction bW xi]
  rw [map_sum]
  apply Finset.sum_congr rfl
  intro a _
  rw [map_smul, hC]

end Draft
end PhysicsSM
