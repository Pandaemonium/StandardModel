import Mathlib

open scoped BigOperators
open scoped Classical
open Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

namespace MassGradientMorse

/-!
# Masslessness is the critical manifold of the disagreement functional

A finite, real, 2-parameter rational avatar of the variational-calculus / gradient+Hessian
view (as in the SciLean differentiable-programming program: gradients, adjoints, Hessians,
variational derivatives).  Reference/provenance only -- **not** an import.

Two null edges given by celestial slopes `s, t : ℝ` (edge_i = `(1, s)`, `(1, t)`).  The
mass² / disagreement functional is `g s t = (t - s)²`, the squared wedge `(1)(t) - (s)(1)`.
-/

/-- The mass² / disagreement functional of two celestial slopes. -/
def g (s t : ℝ) : ℝ := (t - s) ^ 2

/-- The gradient `(∂g/∂s, ∂g/∂t)`. -/
def grad (s t : ℝ) : ℝ × ℝ := (-2 * (t - s), 2 * (t - s))

/-- The (constant) Hessian matrix `!![2,-2;-2,2]`. -/
def H : Matrix (Fin 2) (Fin 2) ℝ := !![(2 : ℝ), -2; -2, 2]

/-! ## 1. Partial derivatives (gradient) via `HasDerivAt`. -/

/-- The first partials: `∂g/∂s = -2(t-s)` (t fixed) and `∂g/∂t = 2(t-s)` (s fixed);
together `grad = (-2(t-s), 2(t-s))`. -/
theorem partials (s t : ℝ) :
    HasDerivAt (fun s => g s t) (-2 * (t - s)) s ∧
    HasDerivAt (fun t => g s t) (2 * (t - s)) t ∧
    grad s t = (-2 * (t - s), 2 * (t - s)) := by
  refine ⟨?_, ?_, rfl⟩
  · have h : HasDerivAt (fun s : ℝ => (t - s) ^ 2) (2 * (t - s) ^ (2 - 1) * (0 - 1)) s := by
      apply HasDerivAt.pow
      exact (hasDerivAt_const s t).sub (hasDerivAt_id s)
    convert h using 1
    ring
  · have h : HasDerivAt (fun t : ℝ => (t - s) ^ 2) (2 * (t - s) ^ (2 - 1) * (1 - 0)) t := by
      apply HasDerivAt.pow
      exact (hasDerivAt_id t).sub (hasDerivAt_const t s)
    convert h using 1
    ring

/-! ## 2. Critical manifold = masslessness. -/

/-- The gradient vanishes IFF the edges are collinear IFF the state is massless. -/
theorem critical_iff_massless (s t : ℝ) :
    (grad s t = (0, 0) ↔ s = t) ∧ (s = t ↔ g s t = 0) := by
  constructor
  · unfold grad
    constructor
    · intro h
      have hpair := (Prod.mk.injEq _ _ _ _).mp h
      have h2 : t - s = 0 := by linarith [hpair.1]
      linarith
    · intro h; subst h; simp
  · unfold g
    constructor
    · intro h; subst h; simp
    · intro h
      have : t - s = 0 := by nlinarith [sq_nonneg (t - s)]
      linarith

/-! ## 3. The Hessian: PSD, flat direction `![1,1]`, mass direction `![1,-1]`. -/

/-- Second partials producing the constant Hessian, via `HasDerivAt` of the first partials. -/
theorem second_partials (s t : ℝ) :
    HasDerivAt (fun s => -2 * (t - s)) (H 0 0) s ∧
    HasDerivAt (fun t => -2 * (t - s)) (H 0 1) t ∧
    HasDerivAt (fun s => 2 * (t - s)) (H 1 0) s ∧
    HasDerivAt (fun t => 2 * (t - s)) (H 1 1) t := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · have h : HasDerivAt (fun s : ℝ => -2 * (t - s)) (-2 * (0 - 1)) s :=
      ((hasDerivAt_const s t).sub (hasDerivAt_id s)).const_mul (-2)
    simpa [H] using (by convert h using 1; ring : HasDerivAt (fun s : ℝ => -2 * (t - s)) 2 s)
  · have h : HasDerivAt (fun t : ℝ => -2 * (t - s)) (-2 * (1 - 0)) t :=
      ((hasDerivAt_id t).sub (hasDerivAt_const t s)).const_mul (-2)
    simpa [H] using (by convert h using 1; ring : HasDerivAt (fun t : ℝ => -2 * (t - s)) (-2) t)
  · have h : HasDerivAt (fun s : ℝ => 2 * (t - s)) (2 * (0 - 1)) s :=
      ((hasDerivAt_const s t).sub (hasDerivAt_id s)).const_mul 2
    simpa [H] using (by convert h using 1; ring : HasDerivAt (fun s : ℝ => 2 * (t - s)) (-2) s)
  · have h : HasDerivAt (fun t : ℝ => 2 * (t - s)) (2 * (1 - 0)) t :=
      ((hasDerivAt_id t).sub (hasDerivAt_const t s)).const_mul 2
    simpa [H] using (by convert h using 1; ring : HasDerivAt (fun t : ℝ => 2 * (t - s)) 2 t)

/-- The Hessian is positive semidefinite; its kernel is the diagonal (common-rotation, flat)
direction `![1,1]`, and it is strictly positive on the antidiagonal (relative-motion,
mass-generating) direction `![1,-1]`. -/
theorem hessian_psd_mass_direction :
    (∀ v : Fin 2 → ℝ, 0 ≤ v ⬝ᵥ (H *ᵥ v)) ∧
    (H *ᵥ ![1, 1] = ![0, 0]) ∧
    (![1, -1] ⬝ᵥ (H *ᵥ ![1, -1]) = 8) := by
  refine ⟨?_, ?_, ?_⟩
  · intro v
    simp [H, dotProduct, Matrix.mulVec, Fin.sum_univ_two]
    nlinarith [sq_nonneg (v 0 - v 1)]
  · funext i
    fin_cases i <;> simp [H, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  · simp [H, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
    norm_num

/-! ## 4. Morse verdict + non-degeneracy checks. -/

/-- Package: mass² is a variational disagreement functional whose critical manifold is exactly
masslessness (`grad = 0 ↔ collinear`), a degenerate minimum along the common-rotation direction
(Hessian kernel `![1,1]`) and a strict minimum along the relative-motion direction (Hessian
positive on `![1,-1]`); mass grows quadratically in the relative celestial displacement.

Honest scope: a finite 2-parameter rational avatar; the Hessian is constant (the functional is
exactly quadratic here); provenance = SciLean gradient/Hessian variational calculus.  Not a claim
about physical mass values. -/
theorem morse_mass_verdict :
    -- critical manifold = masslessness
    (∀ s t : ℝ, grad s t = (0, 0) ↔ s = t) ∧
    (∀ s t : ℝ, s = t ↔ g s t = 0) ∧
    -- Hessian PSD, flat + mass directions
    (∀ v : Fin 2 → ℝ, 0 ≤ v ⬝ᵥ (H *ᵥ v)) ∧
    (H *ᵥ ![1, 1] = ![0, 0]) ∧
    (![1, -1] ⬝ᵥ (H *ᵥ ![1, -1]) = 8) ∧
    -- non-degeneracy: massless vs massive samples
    (grad 3 3 = (0, 0)) ∧
    (grad 1 4 = (-6, 6)) ∧
    (grad 1 4 ≠ (0, 0)) ∧
    (g 1 4 = 9) := by
  refine ⟨fun s t => (critical_iff_massless s t).1, fun s t => (critical_iff_massless s t).2,
    hessian_psd_mass_direction.1, hessian_psd_mass_direction.2.1,
    hessian_psd_mass_direction.2.2, ?_, ?_, ?_, ?_⟩
  · simp [grad]
  · norm_num [grad]
  · simp [grad, Prod.ext_iff]; norm_num
  · norm_num [g]

/-! ## Axiom audit (headlines). -/

/-- info: 'MassGradientMorse.partials' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms partials

/-- info: 'MassGradientMorse.critical_iff_massless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms critical_iff_massless

/-- info: 'MassGradientMorse.hessian_psd_mass_direction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hessian_psd_mass_direction

/-- info: 'MassGradientMorse.morse_mass_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms morse_mass_verdict

end MassGradientMorse
