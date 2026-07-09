import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# Suite D rung D1 — the mass resource theory (free states, invariance, creation)

A finite null-edge program reads `mass² = det P`, where `P` is a REAL symmetric PSD
`2×2` direction Gram (rational entries).  This file develops the **resource-theory core**
of that reading:

* **Free states** are the rank-one (null, `det = 0`) Grams — the single-null-direction
  Grams.
* **Free operations** are common rotations (orthogonal congruence) and relabelings.
* **Mass** (`det`) is the resource monotone.

We prove the three structural laws and package them.

Everything lives over `ℝ` (the direction Gram is a real symmetric matrix); all concrete
witnesses use rational entries.  We deliberately avoid `Real.sqrt`: the free-state
characterisation is phrased with a nonnegative scalar `r` multiplying an outer product
`v vᵀ`, which is the sqrt-free way to say "rank ≤ 1 and PSD" (absorbing `√r` into `v`
would reintroduce a square root).
-/

namespace SuiteD_ResourceCore

open Matrix

/-- The rank-one Gram (outer product) `v vᵀ` for the vector `v = (v0, v1)`. -/
def outer (v0 v1 : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![v0 * v0, v0 * v1; v0 * v1, v1 * v1]

/-- A generic real symmetric `2×2` matrix `!![a, b; b, c]`. -/
def gram (a b c : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![a, b; b, c]

@[simp] theorem det_outer (v0 v1 : ℝ) : Matrix.det (outer v0 v1) = 0 := by
  simp only [outer, Matrix.det_fin_two_of]; ring

@[simp] theorem det_gram (a b c : ℝ) : Matrix.det (gram a b c) = a * c - b * b := by
  simp only [gram, Matrix.det_fin_two_of]

/-!
## Target 1 — free states are exactly the rank-one Grams

For a symmetric PSD `2×2` Gram `P = !![a, b; b, c]` (`0 ≤ a`, `0 ≤ c`), `det P = 0`
iff `P = r • (v vᵀ)` for some nonnegative scalar `r` and vector `v`.  This is the
sqrt-free rendering of "the free states are exactly the single-null-direction Grams":
the outer product `v vᵀ` carries the null direction, the scalar `r ≥ 0` its magnitude.
-/

/-- **Free-state characterization.**  For a PSD symmetric `2×2` Gram, `det = 0` iff it is
a nonnegative multiple of a rank-one outer product `v vᵀ`.  Constructive and sqrt-free:
the witness `v` is read directly off the entries (`(a,b)` when `a ≠ 0`, `(0,1)` scaled by
`c` otherwise). -/
theorem free_states_characterized (a b c : ℝ) (ha : 0 ≤ a) (hc : 0 ≤ c) :
    Matrix.det (gram a b c) = 0 ↔
      ∃ (r v0 v1 : ℝ), 0 ≤ r ∧ gram a b c = r • outer v0 v1 := by
  constructor
  · intro hdet
    rw [det_gram] at hdet
    by_cases haa : a = 0
    · subst haa
      have hb : b = 0 := by nlinarith [sq_nonneg b]
      subst hb
      refine ⟨c, 0, 1, hc, ?_⟩
      ext i j; fin_cases i <;> fin_cases j <;>
        simp [gram, outer, Matrix.smul_apply]
    · have hane : a ≠ 0 := haa
      refine ⟨1 / a, a, b, by positivity, ?_⟩
      ext i j; fin_cases i <;> fin_cases j <;>
        simp [gram, outer, Matrix.smul_apply] <;> field_simp <;> linear_combination hdet
  · rintro ⟨r, v0, v1, -, hP⟩
    rw [hP, Matrix.det_smul, det_outer]
    simp

/-!
## Target 2 — free operations create no mass (orthogonal invariance)

For any orthogonal `O` (`Oᵀ O = 1`), congruence by `O` preserves `det`.  Common rotations
create no mass.
-/

/-- **No free lunch.**  Orthogonal congruence `P ↦ O P Oᵀ` preserves `det` (the mass): free
operations cannot create resource. -/
theorem free_ops_preserve {n : ℕ} (O P : Matrix (Fin n) (Fin n) ℝ) (hO : Oᵀ * O = 1) :
    Matrix.det (O * P * Oᵀ) = Matrix.det P := by
  have h1 : Matrix.det O * Matrix.det O = 1 := by
    have h := congrArg Matrix.det hO
    rw [Matrix.det_mul, Matrix.det_transpose, Matrix.det_one] at h
    exact h
  rw [Matrix.det_mul, Matrix.det_mul, Matrix.det_transpose]
  calc Matrix.det O * Matrix.det P * Matrix.det O
      = (Matrix.det O * Matrix.det O) * Matrix.det P := by ring
    _ = Matrix.det P := by rw [h1, one_mul]

/-- The rational 3-4-5 rotation is orthogonal. -/
theorem rot345_orthogonal :
    (!![(3 : ℝ) / 5, -4 / 5; 4 / 5, 3 / 5])ᵀ * !![(3 : ℝ) / 5, -4 / 5; 4 / 5, 3 / 5] = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two] <;> norm_num

/-- Instantiation of `free_ops_preserve` with the rational 3-4-5 rotation: it preserves the
mass of every Gram. -/
theorem free_ops_preserve_rot345 (P : Matrix (Fin 2) (Fin 2) ℝ) :
    Matrix.det (!![(3 : ℝ) / 5, -4 / 5; 4 / 5, 3 / 5] * P
        * (!![(3 : ℝ) / 5, -4 / 5; 4 / 5, 3 / 5])ᵀ) = Matrix.det P :=
  free_ops_preserve _ P rot345_orthogonal

/-!
## Target 3 — mixing distinct free states creates mass (the payload)

Mixing two distinct free states `u uᵀ` and `w wᵀ` with weight `t` produces the Gram
`P = t • (u uᵀ) + (1-t) • (w wᵀ)`.  Its mass is the exact `t(1-t)`-weighted squared wedge
(Plücker disagreement) of the two null directions.
-/

/-- **Mixing creates mass (closed form).**  The mass of the mixture is exactly
`t(1-t)(u0 w1 − u1 w0)²`, the `t(1-t)`-weighted squared wedge of the two directions. -/
theorem mixing_creates (t u0 u1 w0 w1 : ℝ) :
    Matrix.det (t • outer u0 u1 + (1 - t) • outer w0 w1)
      = t * (1 - t) * (u0 * w1 - u1 * w0) ^ 2 := by
  simp only [outer, Matrix.det_fin_two, Matrix.add_apply, Matrix.smul_apply,
    Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.empty_val', Matrix.cons_val_fin_one, smul_eq_mul, Fin.isValue]
  ring

/-- **Mixing creates mass (positivity).**  For `t ∈ (0,1)` and non-collinear directions
(`u0 w1 − u1 w0 ≠ 0`), the created mass is strictly positive. -/
theorem mixing_creates_pos (t u0 u1 w0 w1 : ℝ) (ht0 : 0 < t) (ht1 : t < 1)
    (hwedge : u0 * w1 - u1 * w0 ≠ 0) :
    0 < Matrix.det (t • outer u0 u1 + (1 - t) • outer w0 w1) := by
  rw [mixing_creates]
  have h1 : 0 < 1 - t := by linarith
  have hsq : 0 < (u0 * w1 - u1 * w0) ^ 2 := by positivity
  positivity

/-- **Mandatory non-degeneracy instantiation.**  Mixing `u = (1,0)` and `w = (3/5, 4/5)`
with weight `t = 1/2` creates mass exactly `4/25 = (1/4)·(4/5)²`. -/
theorem mixing_creates_345 :
    Matrix.det ((1 / 2 : ℝ) • outer 1 0 + (1 - 1 / 2 : ℝ) • outer (3 / 5) (4 / 5)) = 4 / 25 := by
  rw [mixing_creates]; norm_num

/-!
## Target 4 — the resource ordering (packaging 1–3)

We package the three laws: free operations fix the zero-mass (free-state) set and preserve
`det`, while mixing distinct null directions creates mass in the exact Plücker amount.
-/

/-- **Resource-theory core.**  Bundles the three structural laws:

* `.1` free operations preserve the mass (`det`);
* `.2.1` free operations fix the free-state (zero-mass) set;
* `.2.2` mixing distinct free states creates the exact `t(1-t)`-weighted squared-wedge mass,
  which is strictly positive when the directions are non-collinear and `t ∈ (0,1)`.
-/
theorem resource_ordering :
    (∀ (O P : Matrix (Fin 2) (Fin 2) ℝ), Oᵀ * O = 1 →
        Matrix.det (O * P * Oᵀ) = Matrix.det P) ∧
    (∀ (O P : Matrix (Fin 2) (Fin 2) ℝ), Oᵀ * O = 1 →
        (Matrix.det (O * P * Oᵀ) = 0 ↔ Matrix.det P = 0)) ∧
    (∀ (t u0 u1 w0 w1 : ℝ),
        Matrix.det (t • outer u0 u1 + (1 - t) • outer w0 w1)
          = t * (1 - t) * (u0 * w1 - u1 * w0) ^ 2 ∧
        (0 < t → t < 1 → u0 * w1 - u1 * w0 ≠ 0 →
          0 < Matrix.det (t • outer u0 u1 + (1 - t) • outer w0 w1))) := by
  refine ⟨fun O P hO => free_ops_preserve O P hO, ?_, ?_⟩
  · intro O P hO
    rw [free_ops_preserve O P hO]
  · intro t u0 u1 w0 w1
    exact ⟨mixing_creates t u0 u1 w0 w1,
      fun ht0 ht1 hw => mixing_creates_pos t u0 u1 w0 w1 ht0 ht1 hw⟩

/-! ## Axiom footprint audits (kernel-checked, footprint `[propext, Classical.choice, Quot.sound]`) -/

/-- info: 'SuiteD_ResourceCore.free_states_characterized' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms free_states_characterized

/-- info: 'SuiteD_ResourceCore.free_ops_preserve' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms free_ops_preserve

/-- info: 'SuiteD_ResourceCore.free_ops_preserve_rot345' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms free_ops_preserve_rot345

/-- info: 'SuiteD_ResourceCore.mixing_creates' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mixing_creates

/-- info: 'SuiteD_ResourceCore.mixing_creates_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mixing_creates_pos

/-- info: 'SuiteD_ResourceCore.mixing_creates_345' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mixing_creates_345

/-- info: 'SuiteD_ResourceCore.resource_ordering' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms resource_ordering

end SuiteD_ResourceCore
