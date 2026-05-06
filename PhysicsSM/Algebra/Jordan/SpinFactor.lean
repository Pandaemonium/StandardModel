import Mathlib
import PhysicsSM.Algebra.Jordan.Basic

/-!
# Algebra.Jordan.SpinFactor

The spin factor Jordan algebra `ℝ ⊕ ℝⁿ` and its determinant/trace.

## Mathematical context

The spin factor `V_{n+1}` is the Euclidean Jordan algebra on `ℝ × ℝⁿ` with
Jordan product:

  `(t, x) ∘ (t', x') = (t·t' + ⟨x, x'⟩, t·x' + t'·x)`

Key properties (slides 7–11 of Baez 2021):
- Determinant: `det(t, x) = t² − ‖x‖²` (Minkowski quadratic form)
- Trace: `tr(t, x) = 2t`
- Trace-one projections satisfy `t = 1/2` and `‖x‖ = 1/2`

The spin factors `V_3, V_4, V_6, V_{10}` are isomorphic to `h₂(ℝ)`,
`h₂(ℂ)`, `h₂(ℍ)`, `h₂(𝕆)` respectively.

This file works with a concrete 1-dimensional "scalar + vector" model
rather than with `EuclideanSpace`. The concrete `H2O` model in `H2O.lean`
uses the project octonion coordinates directly.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021,
slides 7–11.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Algebra.Jordan.SpinFactor

/-! ## Concrete spin factor type with inner product -/

/--
A spin factor element: a real scalar `t` and a "vector" `x` with squared
norm `xNormSq`. We package the squared norm as data to avoid depending on
a specific vector-space dimension.

This is a lightweight concrete model. For the full `h₂(𝕆)` model, see
`PhysicsSM.Algebra.Jordan.H2O`, which uses octonionic coordinates directly.
-/
structure SpinFactorElem where
  /-- The scalar (half-trace) component. -/
  t : ℝ
  /-- The squared norm of the vector component. -/
  xNormSq : ℝ
  /-- The vector squared norm is nonnegative. -/
  xNormSq_nonneg : 0 ≤ xNormSq


/--
The determinant of a spin factor element: `t² − ‖x‖²`.

This is the Minkowski quadratic form. An element is positive (in the Jordan
order) when `det > 0` and `t > 0`.
-/
def spinDet (a : SpinFactorElem) : ℝ :=
  a.t ^ 2 - a.xNormSq

/--
The trace of a spin factor element: `2t`.

The trace is the sum of eigenvalues `t + ‖x‖` and `t - ‖x‖`.
-/
def spinTrace (a : SpinFactorElem) : ℝ :=
  2 * a.t

/--
The half-trace-square Euclidean form: `(1/2) · tr(a ∘ a) = t² + ‖x‖²`.

This is the positive-definite inner product on the spin factor used to
define the Euclidean norm. It differs from the Minkowski determinant by
the sign of the `‖x‖²` term.
-/
def spinEuclideanNormSq (a : SpinFactorElem) : ℝ :=
  a.t ^ 2 + a.xNormSq

/-- The Euclidean norm squared is nonnegative. -/
theorem spinEuclideanNormSq_nonneg (a : SpinFactorElem) :
    0 ≤ spinEuclideanNormSq a := by
  unfold spinEuclideanNormSq
  have := a.xNormSq_nonneg
  positivity

/-! ## Projection equations -/

/--
For a spin factor idempotent (satisfying `(t,x) ∘ (t,x) = (t,x)` with
`t² + ‖x‖² = t` and `2t·x = x`), either:
- `t = 0` and `‖x‖ = 0` (the zero element), or
- `t = 1` and `‖x‖ = 0` (the identity), or
- `t = 1/2` and `‖x‖² = 1/4` (a nontrivial projection).

This theorem states the trace-one projection case: if `tr = 1` (meaning
`t = 1/2`) and the idempotent equation `t² + ‖x‖² = t` holds, then
`‖x‖² = 1/4`.
-/
theorem traceOne_projection_normSq
    (t xNormSq : ℝ)
    (h_trace : 2 * t = 1)
    (h_idemp : t ^ 2 + xNormSq = t) :
    xNormSq = 1 / 4 := by
  have ht : t = 1 / 2 := by linarith
  nlinarith [sq_abs t]

end PhysicsSM.Algebra.Jordan.SpinFactor
