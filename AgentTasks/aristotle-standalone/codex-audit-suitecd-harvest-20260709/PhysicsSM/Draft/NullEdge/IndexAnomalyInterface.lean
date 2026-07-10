import Mathlib
import PhysicsSM.Draft.NullEdge.WindingLowModes

open scoped BigOperators

set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# C3: a finite signed toy-index interface for the winding anomaly

## Scope and honest disclaimer

This file makes the smallest honest advance toward the physics slogan

`Index(D_K) - Index(D_0) = Wind(K)`

in the finite toy model already built in
`PhysicsSM.Draft.NullEdge.WindingLowModes`. It contains no analytic content:
there is no Fredholm theory, no Atiyah-Singer theorem, no spectral flow, no
heat-kernel/eta-invariant, and no spectral-density claim. Every object here is a
linear map between finite-dimensional complex vector spaces, and every "index"
is finite-dimensional rank-nullity bookkeeping.

The purpose is exactly what the audit asks for:

1. `toyIndex` and `toyIndex_eq_dim_diff` package the signed finite index
   `dim ker - dim coker` and identify it with the topological dimension
   mismatch, separating the proved finite bookkeeping from any analytic claim.
2. `toy_index_anomaly` is the finite-toy anomaly equality
   `toyIndex D_K - toyIndex D_0 = Wind(K)` for the concrete winding operator
   family `Kw`. It is an equality, obtained from exact finite index computations.
3. `windingOne_nonvacuity` is a non-vacuity fixture: at winding one the signed
   index is `1` and there is a genuine nonzero protected kernel mode.
4. `AnalyticIndexReduction` is a hypothesis-bundling interface structure. It
   names an abstract analytic index assignment together with the single
   hypothesis (`reduces`) that would identify it with the finite toy index.
   `analytic_anomaly_of_reduction` then shows that this hypothesis alone reduces
   the analytic anomaly to the finite winding. `toyReduction` witnesses that the
   interface is inhabited, again with no analytic input.

## Sign and grading conventions

* Grading: the source `Fin (N+w) → ℂ` is the `+` chirality, the target
  `Fin N → ℂ` is the `-` chirality. The Dirac-type operator `D` maps `+ → -`.
* Signed index: `Index(D) := dim ker D - dim coker D`, with
  `coker D := (target) ⧸ range D`. Equivalently by finite rank-nullity,
  `Index(D) = dim(source) - dim(target)`. A positive index means the `+`
  chirality carries the excess zero modes.
* Winding: `Wind(Kw N w) := w ≥ 0` is the number of extra `+`-chirality modes
  carried by the winding-`w` background. The reference operator `D_0` is the
  winding-zero operator `Kw N 0`.

With these conventions the finite anomaly reads
`Index(Kw N w) - Index(Kw N 0) = w = Wind(Kw N w)`.
-/

namespace F4Winding

open LinearMap Module Complex

/-! ## 1. The signed finite toy index, grading fixed as source `+`, target `-` -/

/-- Signed finite toy index. For a linear map `L : V →ₗ[ℂ] W` between
finite-dimensional complex spaces, the signed index is `dim ker L - dim coker L`,
where the cokernel is `W ⧸ range L`. This is the finite shadow of an analytic
Dirac index; it carries no analytic content. -/
noncomputable def toyIndex
    {V W : Type*} [AddCommGroup V] [Module ℂ V] [FiniteDimensional ℂ V]
    [AddCommGroup W] [Module ℂ W] [FiniteDimensional ℂ W] (L : V →ₗ[ℂ] W) : ℤ :=
  (Module.finrank ℂ (LinearMap.ker L) : ℤ)
    - (Module.finrank ℂ (W ⧸ LinearMap.range L))

/-- The signed index is the topological dimension mismatch. This is
`finite_index_theorem` restated for `toyIndex`; it isolates the proved finite
bookkeeping content. -/
theorem toyIndex_eq_dim_diff
    {V W : Type*} [AddCommGroup V] [Module ℂ V] [FiniteDimensional ℂ V]
    [AddCommGroup W] [Module ℂ W] [FiniteDimensional ℂ W] (L : V →ₗ[ℂ] W) :
    toyIndex L = (Module.finrank ℂ V : ℤ) - Module.finrank ℂ W := by
  unfold toyIndex
  exact finite_index_theorem L

/-! ## 2. The signed index of the concrete winding operator equals its winding -/

/-- The winding-`w` closure operator has signed index exactly `w`. This is a
thin restatement of `windingDirac_index` in terms of `toyIndex`. -/
theorem toyIndex_windingDirac (N w : ℕ) : toyIndex (Kw N w) = (w : ℤ) := by
  unfold toyIndex
  exact windingDirac_index N w

/-- The reference winding-zero operator `D_0 = Kw N 0` has signed index `0`. -/
theorem toyIndex_windingDirac_zero (N : ℕ) : toyIndex (Kw N 0) = 0 := by
  simpa using toyIndex_windingDirac N 0

/-! ## 3. The finite-toy anomaly equality `Index(D_K) - Index(D_0) = Wind(K)` -/

/-- Finite-toy index anomaly, the C3 finite version.

For the concrete winding operator family, the difference of signed indices
between the winding-`w` background `D_K = Kw N w` and the reference winding-zero
background `D_0 = Kw N 0` equals the winding `w`. -/
theorem toy_index_anomaly (N w : ℕ) :
    toyIndex (Kw N w) - toyIndex (Kw N 0) = (w : ℤ) := by
  rw [toyIndex_windingDirac, toyIndex_windingDirac_zero]
  ring

/-! ## 4. Non-vacuity fixture: winding one carries a genuine protected mode -/

/-- Winding-one non-vacuity fixture. At winding `w = 1` the signed toy index is
`1`, the anomaly difference is `1`, and the protected kernel is genuinely
nonzero, so there is an honest protected zero mode. -/
theorem windingOne_nonvacuity (N : ℕ) :
    toyIndex (Kw N 1) = 1 ∧
    toyIndex (Kw N 1) - toyIndex (Kw N 0) = 1 ∧
    1 ≤ Module.finrank ℂ (LinearMap.ker (Kw N 1)) := by
  refine ⟨by simpa using toyIndex_windingDirac N 1,
    by simpa using toy_index_anomaly N 1, ?_⟩
  have := windingDirac_kernel N 1
  omega

/-! ## 5. The reduction interface: what hypothesis buys the analytic anomaly

We do not prove any analytic index theorem. Instead we name, as an explicit
interface `structure`, the single hypothesis that would be needed to descend
from an abstract analytic index to the finite toy: the analytic index of the
winding-`w` operator coincides with its finite toy index. Given that hypothesis,
the analytic anomaly equals the winding.
-/

/-- Analytic-index reduction interface, a hypothesis bundle.

`analyticIndex N w` is a black-box "analytic index" assigned to the winding-`w`
Dirac operator at lattice size `N`. The field `reduces` is the reduction
hypothesis: it asserts that this analytic index agrees with the proved finite
toy index `toyIndex (Kw N w)`. Constructing a term of this structure is exactly
the analytic work that lies outside the finite toy. -/
structure AnalyticIndexReduction where
  /-- The abstract analytic index of the winding-`w` operator at size `N`. -/
  analyticIndex : ℕ → ℕ → ℤ
  /-- Reduction hypothesis: the analytic index equals the finite toy index. -/
  reduces : ∀ N w : ℕ, analyticIndex N w = toyIndex (Kw N w)

/-- The reduction hypothesis alone yields the analytic anomaly.

Given any `AnalyticIndexReduction R`, the analytic index anomaly between the
winding-`w` background and the winding-zero reference equals the winding `w`.
The proof uses only the reduction hypothesis and the finite result
`toy_index_anomaly`. -/
theorem analytic_anomaly_of_reduction (R : AnalyticIndexReduction) (N w : ℕ) :
    R.analyticIndex N w - R.analyticIndex N 0 = (w : ℤ) := by
  rw [R.reduces N w, R.reduces N 0]
  exact toy_index_anomaly N w

/-- The interface is inhabited. The finite toy index itself is a witness of
`AnalyticIndexReduction`, so the reduction hypothesis is consistent. This is the
honest statement: the finite model realizes the interface, while any genuinely
analytic witness would require analytic index theory not provided here. -/
noncomputable def toyReduction : AnalyticIndexReduction where
  analyticIndex N w := toyIndex (Kw N w)
  reduces _ _ := rfl

/-- Sanity: the canonical `toyReduction` witness gives back the finite anomaly. -/
theorem analytic_anomaly_toyReduction (N w : ℕ) :
    toyReduction.analyticIndex N w - toyReduction.analyticIndex N 0 = (w : ℤ) :=
  analytic_anomaly_of_reduction toyReduction N w

end F4Winding

/-! ## Kernel-footprint guard -/

/-- info: 'F4Winding.toyIndex_eq_dim_diff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms F4Winding.toyIndex_eq_dim_diff

/-- info: 'F4Winding.toyIndex_windingDirac' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms F4Winding.toyIndex_windingDirac

/-- info: 'F4Winding.toy_index_anomaly' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms F4Winding.toy_index_anomaly

/-- info: 'F4Winding.windingOne_nonvacuity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms F4Winding.windingOne_nonvacuity

/-- info: 'F4Winding.analytic_anomaly_of_reduction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms F4Winding.analytic_anomaly_of_reduction

/-- info: 'F4Winding.analytic_anomaly_toyReduction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms F4Winding.analytic_anomaly_toyReduction
