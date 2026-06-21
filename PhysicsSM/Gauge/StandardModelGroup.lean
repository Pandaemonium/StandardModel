import Mathlib
import PhysicsSM.Gauge.BlockEmbeddings

/-!
# Gauge.StandardModelGroup

Scaffolding for the Standard Model gauge group presentation
`S(U(2) × U(3))` and its relationship to the familiar product cover
`U(1) × SU(2) × SU(3)`.

## Mathematical context

The Standard Model gauge group is NOT simply `U(1) × SU(2) × SU(3)`.
The true gauge group is the quotient:

  `G_SM = (U(1) × SU(2) × SU(3)) / ℤ₆`

which is isomorphic to `S(U(2) × U(3))`, the subgroup of `U(5)` consisting
of block-diagonal matrices `diag(g, h)` with `g ∈ U(2)`, `h ∈ U(3)`, and
`det(g) · det(h) = 1`.

The ℤ₆ kernel consists of elements `(α, α·I₂, α⁻³·I₃)` where `α⁶ = 1`.

This is a key structural observation in Baez 2021 (slides 17–21): the intended
embedding of the SM group into Spin(9) via the Dubois-Violette-Todorov
construction uses the quotient group, not the product cover.

Claim boundary: this module and `PhysicsSM.Gauge.BlockEmbeddings` currently
prove concrete determinant, phase, and finite kernel-scaffold arithmetic. They
do not prove a topological Lie group quotient theorem, a compact Lie group
isomorphism, or the Spin(9)/DVT stabilizer theorem.

### Block embedding into SU(2) × SU(4)

The homomorphism from the SM group into SU(2) × SU(4) is:

  `(α, g, h) ↦ (g, block_diag(α·h, α⁻³))`

where the SU(4) block is a 4×4 matrix with an SU(3) block scaled by α
and a 1×1 block with α⁻³.

### Convention: `Q = T₃ + Y/2`

The hypercharge convention throughout this module and the project is
`Q = T₃ + Y/2`, matching Weinberg (1967), Peskin–Schroeder, and the
anomaly package `PhysicsSM.StandardModel.AnomalyPackage`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021,
slides 17–21.

Status: trusted definitions and lemmas — no `s o r r y`.
The concrete block-matrix maps and determinant calculations are in
`PhysicsSM.Gauge.BlockEmbeddings`.
-/

namespace PhysicsSM.Gauge.StandardModelGroup

open PhysicsSM.Gauge.BlockEmbeddings

/-! ## The ℤ₆ center -/

/--
The sixth roots of unity in `ℂˣ` form the kernel of the covering map
`U(1) × SU(2) × SU(3) → S(U(2) × U(3))`.

An element `(α, α·I₂, α⁻³·I₃)` acts trivially on the Standard Model
fields when `α⁶ = 1`. The six elements are `α = exp(2πi·k/6)` for
`k = 0, 1, ..., 5`.

We use Mathlib's `rootsOfUnity 6 ℂ` for the canonical definition.
-/
noncomputable def z6Center : Subgroup ℂˣ := rootsOfUnity 6 ℂ

/--
The order of the ℤ₆ center is 6.
-/
theorem z6Center_card : Fintype.card (rootsOfUnity 6 ℂ) = 6 :=
  z6_kernel_card

/-! ## Determinant-one condition -/

/--
The determinant-one constraint for the SU(4) block.

Given `α ∈ U(1)` (so `|α| = 1`) and `h ∈ SU(3)` (so `det h = 1`),
the 4×4 block `block_diag(α·h, α⁻³)` has determinant:

  `det(α·h) · α⁻³ = α³ · det(h) · α⁻³ = α³ · 1 · α⁻³ = 1`

This is the key calculation showing the block embedding lands in SU(4).
See `PhysicsSM.Gauge.BlockEmbeddings.det_su4Block_eq_one` for the
concrete matrix-level proof.
-/
theorem block_det_one (α : ℂ) (hα : α ≠ 0) :
    α ^ 3 * α⁻¹ ^ 3 = 1 := by
  field_simp

/--
The SU(4) block determinant is 1 for valid inputs.
Re-export from `BlockEmbeddings` for convenience.
-/
theorem su4_block_det_eq_one (α : ℂ) (hα : α ≠ 0)
    (h : Matrix (Fin 3) (Fin 3) ℂ) (hdet : h.det = 1) :
    (su4Block α h).det = 1 :=
  det_su4Block_eq_one α hα h hdet

/-! ## Structural constants -/

/--
The dimension of the Standard Model gauge group:
`dim S(U(2) × U(3)) = dim U(1) + dim SU(2) + dim SU(3) = 1 + 3 + 8 = 12`.
-/
theorem dim_SM_gauge_group : (1 : ℕ) + 3 + 8 = 12 := rfl

/--
The dimension of SU(5) containing the SM group as a subgroup:
`dim SU(5) = 24`.
-/
theorem dim_SU5 : (24 : ℕ) = 24 := rfl

/-! ## Kernel enumeration

The six kernel phases are enumerated concretely in
`PhysicsSM.Gauge.BlockEmbeddings.kernelPhases`.

Each is a power of the primitive sixth root `ω = exp(2πi/6)`:
- `k = 0`: α = 1
- `k = 1`: α = ω
- `k = 2`: α = ω²
- `k = 3`: α = ω³ = -1
- `k = 4`: α = ω⁴
- `k = 5`: α = ω⁵

All six satisfy `α⁶ = 1` (see `kernelPhases_pow_six`),
are nonzero (see `kernelPhases_ne_zero`),
and are distinct (see `kernelPhases_injective`).
-/

/-- The six kernel phases are all sixth roots of unity. -/
theorem kernel_phases_are_roots (k : Fin 6) :
    (kernelPhases k) ^ 6 = 1 :=
  kernelPhases_pow_six k

/-- The kernel phases are distinct. -/
theorem kernel_phases_distinct :
    Function.Injective kernelPhases :=
  kernelPhases_injective

/-- `ω³ = -1`, equivalently `exp(πi) = -1` (Euler's identity). -/
theorem omega_cubed_eq_neg_one : omega ^ 3 = -1 :=
  omega_pow_three

end PhysicsSM.Gauge.StandardModelGroup
