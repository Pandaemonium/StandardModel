import Mathlib

/-!
# Draft.NullEdgeScalarOriginBalancedKernelNoGo

Aristotle task C103: scalar-on-origin balanced-kernel no-go.

## Statement in words

This generalizes the scalar Wilson no-go. Consider the balanced two-line origin
kernel: a pair of lines `L`, `R` carrying opposite chirality charges
`γ(L) = +1`, `γ(R) = −1`, both lying in the kernel of the origin Dirac operator
`D0`. We ask whether adding a deformation that acts as a single *scalar* `s • I`
on this kernel can turn it into a single Weyl line (only `L` or only `R`).

The answer is no, and the dichotomy is sharp:

* If the scalar **vanishes at the origin** (`s = 0`), the deformed operator equals
  `D0` on the kernel, so the kernel is preserved *entirely* — both `L` and `R`
  survive. It therefore never selects a single Weyl line.
* If the scalar is **nonzero** (`s ≠ 0`), the operator `s • I` has trivial
  kernel: it removes / masses *both* origin lines, including the intended
  physical origin mode. Again no single Weyl line is released.

Either way a scalar-on-origin deformation cannot release one Weyl branch.

## Finite model

A two-dimensional complex space `Fin 2 → ℂ` with the balanced basis lines

```text
L = ![1, 0]      (γ(L) = +1)
R = ![0, 1]      (γ(R) = −1)
```

graded by `γ = diag(1, -1)` (vanishing trace = balanced). The origin Dirac
operator `D0` is kept abstract subject only to the balanced-kernel hypotheses
`D0 *ᵥ L = 0`, `D0 *ᵥ R = 0`. A scalar-on-origin deformation is `s • I`, and the
deformed operator is `D0 + s • I`.

## Theorem package

* `gammaGrading_balanced` — the grading is balanced: `γ` acts as `+1` on `L`,
  `−1` on `R`, with vanishing trace.
* `origin_vanishing_scalar_preserves_kernel` — `D0 *ᵥ L = 0`, `D0 *ᵥ R = 0`,
  `s = 0` ⟹ both `L` and `R` lie in `ker (D0 + s • I)` (the kernel is preserved).
* `balanced_kernel_not_one_weyl_line_after_scalar_zero` — under the same
  hypotheses the deformation does *not* select a single Weyl line.
* `nonzero_scalar_removes_origin_kernel` — `s ≠ 0` ⟹ `ker (s • I) = {0}`.
* `scalar_deformation_never_releases_weyl_line` — main no-go: for *every* scalar
  `s`, the pure scalar-on-origin operator `s • I` fails to select a single Weyl
  line.
* `deformed_scalar_on_origin_never_selects_weyl_line` — D0-aware no-go: if
  `D0` vanishes on both balanced origin lines, then `D0 + s • I` never selects
  exactly one of them.

## Scope and escape hatch

This is a finite, honest no-go about **scalar-on-origin** deformations only
(operators acting as `s • I` on the balanced origin kernel). It does not claim to
classify all analytic deformations. The explicit escape hatch it points to:

```text
C1 needs a non-scalar spinor-line / branch-line mechanism or a physical
projection / domain-wall construction.
```

i.e. releasing one Weyl branch requires an operator that acts *relatively* on the
two spinor lines (a Weyl / chirality projector, a domain wall, an overlap /
branch-line construction) — precisely not a scalar on the origin kernel.
-/

namespace PhysicsSM.Draft.NullEdgeScalarOriginBalancedKernelNoGo

open Matrix

/-- The `+` chirality origin line `L`. -/
def L : Fin 2 → ℂ := ![1, 0]

/-- The `−` chirality origin line `R`. -/
def R : Fin 2 → ℂ := ![0, 1]

/-- The chirality grading `γ = diag(1, -1)` on the two origin lines. -/
noncomputable def gammaGrading : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- A scalar-on-origin deformation acts as `s • I` on the origin kernel. -/
noncomputable def scalarOp (s : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  s • (1 : Matrix (Fin 2) (Fin 2) ℂ)

/-- The deformed origin operator `D0 + s • I`. -/
noncomputable def deformed (D0 : Matrix (Fin 2) (Fin 2) ℂ) (s : ℂ) :
    Matrix (Fin 2) (Fin 2) ℂ := D0 + scalarOp s

/-- Membership of a vector in the kernel of an operator. -/
def InKernel (M : Matrix (Fin 2) (Fin 2) ℂ) (v : Fin 2 → ℂ) : Prop := M *ᵥ v = 0

/-- An operator `M` **selects a single Weyl line** if exactly one of the two
balanced origin lines survives in its kernel. -/
def SelectsOneWeylLine (M : Matrix (Fin 2) (Fin 2) ℂ) : Prop :=
  (InKernel M L ∧ ¬ InKernel M R) ∨ (InKernel M R ∧ ¬ InKernel M L)

/-- The scalar operator acts as scalar multiplication: `(s • I) *ᵥ v = s • v`. -/
theorem scalarOp_mulVec (s : ℂ) (v : Fin 2 → ℂ) : scalarOp s *ᵥ v = s • v := by
  rw [scalarOp, Matrix.smul_mulVec, Matrix.one_mulVec]

/-- The two origin lines are nonzero. -/
theorem L_ne_zero : L ≠ 0 := by
  intro h; have := congrFun h 0; simp [L] at this

theorem R_ne_zero : R ≠ 0 := by
  intro h; have := congrFun h 1; simp [R] at this

/--
**Balanced grading.** `γ` acts as `+1` on `L` and `−1` on `R`, with vanishing
trace: the origin kernel is a balanced `{+, −}` pair.
-/
theorem gammaGrading_balanced :
    gammaGrading *ᵥ L = (1 : ℂ) • L ∧
    gammaGrading *ᵥ R = (-1 : ℂ) • R ∧
    Matrix.trace gammaGrading = 0 := by
  refine ⟨?_, ?_, ?_⟩
  · funext i; fin_cases i <;>
      simp [gammaGrading, L, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  · funext i; fin_cases i <;>
      simp [gammaGrading, R, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  · simp [gammaGrading, Matrix.trace, Matrix.diag, Fin.sum_univ_two]

/--
**Origin-vanishing scalar preserves the kernel.** If `D0` vanishes on the
balanced origin kernel (`D0 *ᵥ L = 0` and `D0 *ᵥ R = 0`) and the scalar vanishes
at the origin (`s = 0`), then both origin lines remain in the kernel of the
deformed operator `D0 + s • I`. The intended physical origin kernel is preserved
in full.
-/
theorem origin_vanishing_scalar_preserves_kernel
    (D0 : Matrix (Fin 2) (Fin 2) ℂ) (s : ℂ)
    (hL : D0 *ᵥ L = 0) (hR : D0 *ᵥ R = 0) (hs : s = 0) :
    InKernel (deformed D0 s) L ∧ InKernel (deformed D0 s) R := by
  subst hs
  refine ⟨?_, ?_⟩ <;>
    simp [InKernel, deformed, Matrix.add_mulVec, scalarOp_mulVec, hL, hR]

/--
**Balanced kernel is not turned into one Weyl line by a vanishing scalar.** With
`D0` vanishing on the kernel and `s = 0`, the deformed operator keeps *both*
origin lines, so it cannot select a single Weyl line.
-/
theorem balanced_kernel_not_one_weyl_line_after_scalar_zero
    (D0 : Matrix (Fin 2) (Fin 2) ℂ) (s : ℂ)
    (hL : D0 *ᵥ L = 0) (hR : D0 *ᵥ R = 0) (hs : s = 0) :
    ¬ SelectsOneWeylLine (deformed D0 s) := by
  obtain ⟨kL, kR⟩ := origin_vanishing_scalar_preserves_kernel D0 s hL hR hs
  rintro (⟨_, hnR⟩ | ⟨_, hnL⟩)
  · exact hnR kR
  · exact hnL kL

/--
**Nonzero scalar removes the origin kernel.** A nonzero scalar-on-origin
deformation `s • I` (`s ≠ 0`) has trivial kernel: the only vector it annihilates
is `0`. So both origin lines (in particular the intended physical origin mode)
are removed / massed rather than a Weyl branch being released.
-/
theorem nonzero_scalar_removes_origin_kernel (s : ℂ) (hs : s ≠ 0)
    (v : Fin 2 → ℂ) (hv : InKernel (scalarOp s) v) : v = 0 := by
  rw [InKernel, scalarOp_mulVec] at hv
  exact (smul_eq_zero.mp hv).resolve_left hs

/--
**Main no-go.** For *every* scalar `s`, the pure scalar-on-origin operator
`s • I` fails to select a single Weyl line:

* if `s = 0`, both balanced lines survive (kernel preserved), so neither line is
  singled out;
* if `s ≠ 0`, neither balanced line survives (kernel removed), so again neither
  is singled out.

Hence a scalar-on-origin deformation can never release one Weyl branch.
Releasing a single Weyl branch requires a non-scalar spinor-line / branch-line
mechanism or a physical projection / domain-wall construction.
-/
theorem scalar_deformation_never_releases_weyl_line (s : ℂ) :
    ¬ SelectsOneWeylLine (scalarOp s) := by
  rintro (⟨hL, hnR⟩ | ⟨hR, hnL⟩)
  · by_cases hs : s = 0
    · -- s = 0: R is also in the kernel, contradicting hnR
      exact hnR (by simp [InKernel, scalarOp_mulVec, hs])
    · -- s ≠ 0: L is not in the kernel, contradicting hL
      rw [InKernel, scalarOp_mulVec] at hL
      have := congrFun hL 0
      simp [L, smul_eq_mul] at this
      exact hs this
  · by_cases hs : s = 0
    · exact hnL (by simp [InKernel, scalarOp_mulVec, hs])
    · rw [InKernel, scalarOp_mulVec] at hR
      have := congrFun hR 1
      simp [R, smul_eq_mul] at this
      exact hs this

/--
**D0-aware scalar-on-origin no-go.** If the origin operator `D0` vanishes on
both balanced origin lines `L` and `R`, then the deformed operator
`D0 + s • I` never selects exactly one of them:

* when `s = 0`, both lines remain in the kernel;
* when `s ≠ 0`, neither line remains in the kernel.

This is the finite version of the scalar-on-origin obstruction used as a Gate C1
guardrail. It still does not classify non-scalar spinor-line, branch-line,
projected-overlap, or domain-wall mechanisms.
-/
theorem deformed_scalar_on_origin_never_selects_weyl_line
    (D0 : Matrix (Fin 2) (Fin 2) ℂ) (s : ℂ)
    (hL : D0 *ᵥ L = 0) (hR : D0 *ᵥ R = 0) :
    ¬ SelectsOneWeylLine (deformed D0 s) := by
  by_cases hs : s = 0
  · exact balanced_kernel_not_one_weyl_line_after_scalar_zero D0 s hL hR hs
  · have notL : ¬ InKernel (deformed D0 s) L := by
      intro h
      rw [InKernel, deformed, Matrix.add_mulVec, hL, scalarOp_mulVec] at h
      have hcoord := congrFun h 0
      simp [L, smul_eq_mul] at hcoord
      exact hs hcoord
    have notR : ¬ InKernel (deformed D0 s) R := by
      intro h
      rw [InKernel, deformed, Matrix.add_mulVec, hR, scalarOp_mulVec] at h
      have hcoord := congrFun h 1
      simp [R, smul_eq_mul] at hcoord
      exact hs hcoord
    rintro (⟨kL, _⟩ | ⟨kR, _⟩)
    · exact notL kL
    · exact notR kR

end PhysicsSM.Draft.NullEdgeScalarOriginBalancedKernelNoGo
