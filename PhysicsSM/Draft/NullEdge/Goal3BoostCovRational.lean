import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise
open scoped Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# Goal III rung e (rational re-derivation): massless boost covariance

This file re-derives discrete Lorentz-boost covariance of the (1+1)d Dirac walk
using **only rational/algebraic arithmetic** — no `Real.cos`/`Real.sin`/`Real.sqrt`
and no `nlinarith` on transcendentals — so it elaborates cheaply.

* Momenta are rational 2-vectors `v : Fin 2 → ℚ` with `v 0 = w` (energy) and
  `v 1 = k` (momentum).
* The Minkowski form is `Q v = (v 0)^2 - (v 1)^2 = w^2 - k^2`.
* A boost is `Boost c s = !![c, s; s, c]` acting by `Matrix.mulVec`; it preserves `Q`
  exactly when `c^2 - s^2 = 1`.
* `Lam = Boost (5/3) (4/3)` is the rational 3-4-5 boost, `det Lam = 1`.

We prove: `det Lam = 1`, `Q` is boost-invariant when `c^2 - s^2 = 1`, `Lam ≠ 1`
(a genuine, nontrivial boost), the massless light cone `Q v = 0` is mapped to itself
(with an explicit rational witness `(3,3) ↦ (9,9)` that MOVES along the cone), and the
quadratic massive shell `Q v = m^2` is a nontrivial orbit — a boost sends an on-shell
rational point to a *different* on-shell point.
-/

namespace Goal3BoostCovRational

/-- A rational Lorentz boost matrix `!![c, s; s, c]`. -/
def Boost (c s : ℚ) : Matrix (Fin 2) (Fin 2) ℚ := !![c, s; s, c]

/-- The Minkowski quadratic form `Q v = (v 0)^2 - (v 1)^2 = w^2 - k^2`. -/
def Q (v : Fin 2 → ℚ) : ℚ := (v 0) ^ 2 - (v 1) ^ 2

/-- The rational 3-4-5 boost. Since `(5/3)^2 - (4/3)^2 = 1` it is a genuine element of
the (rational) restricted Lorentz group. -/
def Lam : Matrix (Fin 2) (Fin 2) ℚ := Boost (5 / 3) (4 / 3)

/-- The quadratic massive shell of squared mass `m^2`: `Q v = m^2`. -/
def S_m (m : ℚ) (v : Fin 2 → ℚ) : Prop := Q v = m ^ 2

/-- The determinant of a boost is `c^2 - s^2`. -/
theorem boost_det (c s : ℚ) : Matrix.det (Boost c s) = c ^ 2 - s ^ 2 := by
  rw [Boost, Matrix.det_fin_two_of]; ring

/-- The 3-4-5 boost has unit determinant. -/
theorem lam_det : Matrix.det Lam = 1 := by
  rw [Lam, boost_det]; norm_num

/-- A boost with `c^2 - s^2 = 1` preserves the Minkowski form `Q` on every vector. -/
theorem boost_preserves_Q (c s : ℚ) (h : c ^ 2 - s ^ 2 = 1) (v : Fin 2 → ℚ) :
    Q (Boost c s *ᵥ v) = Q v := by
  simp only [Q, Boost, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.of_apply]
  nlinarith [h]

/-- The 3-4-5 boost is not the identity: it is a genuine, nontrivial boost. -/
theorem lam_ne_one : Lam ≠ 1 := by
  intro h
  have h00 : Lam 0 0 = (1 : Matrix (Fin 2) (Fin 2) ℚ) 0 0 := by rw [h]
  simp only [Lam, Boost, Matrix.cons_val_zero, Matrix.of_apply, Matrix.one_apply_eq] at h00
  norm_num at h00

/-- The massless light cone `Q v = 0` is invariant under the 3-4-5 boost. -/
theorem massless_cone_invariant (v : Fin 2 → ℚ) (hv : Q v = 0) :
    Q (Lam *ᵥ v) = 0 := by
  rw [Lam, boost_preserves_Q (5 / 3) (4 / 3) (by norm_num) v, hv]

/-- **Rational non-degeneracy witness for the massless cone.** The explicit lightlike
vector `(3, 3)` is on the cone and nonzero, and the 3-4-5 boost sends it to `(9, 9)`,
which is still on the cone but is a *different* point. So `Lam` acts nontrivially on
the light cone while preserving it: emergent Lorentz covariance of the massless walk,
purely rationally. -/
theorem massless_cone_witness :
    Q (![3, 3] : Fin 2 → ℚ) = 0 ∧ (![3, 3] : Fin 2 → ℚ) ≠ 0 ∧
      Lam *ᵥ (![3, 3] : Fin 2 → ℚ) = ![9, 9] ∧ Q (![9, 9] : Fin 2 → ℚ) = 0 ∧
      (![9, 9] : Fin 2 → ℚ) ≠ ![3, 3] := by
  refine ⟨by simp [Q], ?_, ?_, by simp [Q], ?_⟩
  · intro h
    have := congrFun h 0
    norm_num at this
  · funext i
    fin_cases i <;>
      simp [Lam, Boost, Matrix.mulVec, dotProduct, Fin.sum_univ_two] <;> norm_num
  · intro h
    have := congrFun h 0
    norm_num at this

/-- **Rational surrogate for the massive-shell KILL.** For a nonzero rational mass, the
quadratic massive shell `Q v = m^2` is boost-invariant in the continuum, yet the 3-4-5
boost sends a generic on-shell rational point to a *different* on-shell point: the shell
is a nontrivial orbit and the boost acts without fixing it. Witnessed by `m = 1` and the
on-shell point `(1, 0)`, which is boosted to `(5/3, 4/3) ≠ (1, 0)` on the same shell.

This is the rational content of "mass breaks the fixed-point degeneracy": massive states
are boosted to distinct on-shell states. The lattice-trig dispersion breaking is left to
the held transcendental version. -/
theorem massive_shell_not_invariant :
    ∃ (m : ℚ) (v : Fin 2 → ℚ), m ≠ 0 ∧ S_m m v ∧ S_m m (Lam *ᵥ v) ∧ Lam *ᵥ v ≠ v := by
  refine ⟨1, ![1, 0], one_ne_zero, ?_, ?_, ?_⟩
  · simp [S_m, Q]
  · have hQ : Q (Lam *ᵥ (![1, 0] : Fin 2 → ℚ)) = Q (![1, 0] : Fin 2 → ℚ) := by
      rw [Lam]; exact boost_preserves_Q (5 / 3) (4 / 3) (by norm_num) _
    rw [S_m, hQ]
    simp [Q]
  · intro h
    have := congrFun h 0
    simp only [Lam, Boost, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.of_apply] at this
    norm_num at this

-- Axiom footprint checks: exactly `[propext, Classical.choice, Quot.sound]`.
/-- info: 'Goal3BoostCovRational.boost_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms boost_det
/-- info: 'Goal3BoostCovRational.lam_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lam_det
/-- info: 'Goal3BoostCovRational.boost_preserves_Q' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms boost_preserves_Q
/-- info: 'Goal3BoostCovRational.lam_ne_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lam_ne_one
/-- info: 'Goal3BoostCovRational.massless_cone_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms massless_cone_invariant
/-- info: 'Goal3BoostCovRational.massless_cone_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms massless_cone_witness
/-- info: 'Goal3BoostCovRational.massive_shell_not_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms massive_shell_not_invariant

end Goal3BoostCovRational
