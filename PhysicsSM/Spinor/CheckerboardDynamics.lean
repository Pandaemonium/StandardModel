import Mathlib.Tactic
import PhysicsSM.Spinor.Checkerboard

/-!
# Spinor.CheckerboardDynamics

Trusted finite dynamics for the `1+1`-dimensional Feynman checkerboard.

`PhysicsSM.Spinor.Checkerboard` defines finite lightlike histories and proves
the first-step path-sum decomposition.  This module adds the endpoint-side
recursion: the path sum is an iterated two-component lattice evolution, and
each directed component satisfies a second-order discrete Klein-Gordon /
telegraph recursion in which the corner weight enters through `mu ^ 2`.

This is still a finite theorem package.  It does not assert a continuum limit,
Bessel-function formula, or equality with the analytic Dirac propagator.

Sources:
- R. P. Feynman and A. R. Hibbs, "Quantum Mechanics and Path Integrals",
  Problem 2-6.
- B. Gaveau, T. Jacobson, M. Kac, and L. S. Schulman, "Relativistic
  Extension of the Analogy between Quantum Mechanics and Brownian Motion",
  Phys. Rev. Lett. 53 (1984), 419-422.
- M. Skopenkov and A. Ustinov, "Feynman checkers: towards algorithmic quantum
  theory", Russian Math. Surveys 77:3 (2022), 73-160; arXiv:2007.12879.

Provenance: promoted from the no-s o r r y draft theorem island
`PhysicsSM.Draft.CheckerboardSpinorRecursionAristotle`.

Status: trusted, no `s o r r y`.
-/

namespace PhysicsSM.Spinor.Checkerboard

open Direction

variable {S : Type*}

/-! ## Counting and corner weights -/

/-- The list of length-`n` histories has no duplicates. -/
theorem histories_nodup (n : Nat) : (histories n).Nodup := by
  induction n with
  | zero => decide
  | succ n ih =>
      refine List.Nodup.append ?_ ?_ ?_
      · exact ih.map fun _ _ h => by simpa using h
      · exact ih.map fun _ _ h => by simpa using h
      · simp +decide [List.disjoint_left]

/-- There are exactly `2 ^ n` histories of length `n`. -/
theorem length_histories (n : Nat) : (histories n).length = 2 ^ n := by
  induction n with
  | zero => rfl
  | succ n ih => simp +arith +decide [pow_succ', histories_succ, ih]

/-- The path weight is the corner weight raised to the number of corners. -/
theorem pathWeight_eq_pow_turnCount [Semiring S] (mu : S)
    (d : Direction) (h : List Direction) :
    pathWeight mu d h = mu ^ turnCount d h := by
  induction h generalizing d with
  | nil => simp
  | cons e rest ih =>
      cases d <;> cases e <;>
        simp [turnWeight, turnCount, ih, pow_add, pow_one]

/-! ## Endpoint-side recursion -/

/--
Last-step decomposition of the finite checkerboard path sum.

A path arriving at `(finishX, finishDir)` after `n + 1` steps was previously at
`finishX - finishDir.step`, either already moving in `finishDir` or moving in
the flipped direction and paying one final corner weight.
-/
theorem pathSum_last_step [Semiring S] (mu : S) (startX : Int)
    (startDir : Direction) (n : Nat) (finishX : Int) (finishDir : Direction) :
    pathSum mu startX startDir (n + 1) finishX finishDir
      =
        pathSum mu startX startDir n (finishX - finishDir.step) finishDir
        +
        pathSum mu startX startDir n (finishX - finishDir.step) finishDir.flip
          * mu := by
  induction n generalizing startX startDir finishX with
  | zero =>
      cases startDir <;> cases finishDir <;>
        simp +decide [pathSum, turnWeight] <;> grind
  | succ n ih =>
      rw [pathSum_succ, ih, ih, pathSum_succ, pathSum_succ]
      simp only [mul_add, add_mul, mul_assoc]
      abel

/--
One step of the directed checkerboard evolution acting on a two-component
lattice wavefunction.
-/
def evolve [Semiring S] (mu : S) (psi : Int -> Direction -> S) :
    Int -> Direction -> S :=
  fun y e => psi (y - e.step) e + psi (y - e.step) e.flip * mu

/-- Delta initial condition concentrated at position `x` with direction `d`. -/
def deltaInit [Semiring S] (x : Int) (d : Direction) : Int -> Direction -> S :=
  fun y e => if y = x ∧ e = d then 1 else 0

/--
The finite checkerboard path sum is the `n`-fold iterate of the local
two-component evolution rule applied to a delta initial condition.
-/
theorem pathSum_eq_iterate_evolve [Semiring S] (mu : S) (x : Int)
    (d : Direction) (n : Nat) (y : Int) (e : Direction) :
    pathSum mu x d n y e = (evolve mu)^[n] (deltaInit x d) y e := by
  induction n generalizing y e with
  | zero =>
      simp only [Function.iterate_zero, id_eq, deltaInit]
      by_cases h : y = x ∧ e = d
      · obtain ⟨hy, he⟩ := h
        subst hy
        subst he
        simp [pathSum_zero_same]
      · rw [if_neg h, pathSum_zero_ne_pos]
        tauto
  | succ n ih =>
      rw [Function.iterate_succ_apply', evolve, ← ih, ← ih, pathSum_last_step]

/-! ## Discrete Klein-Gordon / telegraph recursion -/

/--
Discrete Klein-Gordon / telegraph equation for each directed checkerboard
component.

Written additively, the finite identity is

```text
psi_{n+2}(y) + psi_n(y)
  = psi_{n+1}(y - 1) + psi_{n+1}(y + 1) + mu^2 psi_n(y).
```

Thus the first-order directed checkerboard recursion squares to a second-order
recursion in which the corner/chirality-flip weight appears only through
`mu ^ 2`.
-/
theorem pathSum_klein_gordon [CommSemiring S] (mu : S) (x : Int)
    (d : Direction) (n : Nat) (y : Int) (e : Direction) :
    pathSum mu x d (n + 2) y e + pathSum mu x d n y e
      =
        pathSum mu x d (n + 1) (y - 1) e
        + pathSum mu x d (n + 1) (y + 1) e
        + mu ^ 2 * pathSum mu x d n y e := by
  cases e <;> simp +decide [pathSum_last_step] <;> ring!

/-! ## Physical complex corner weight -/

/-- The usual complex checkerboard corner weight `mu = i epsilon m`. -/
def physicalCornerWeight (epsilon mass : ℂ) : ℂ :=
  Complex.I * epsilon * mass

/--
The square of the physical corner weight is the negative mass-squared lattice
coefficient.
-/
theorem physicalCornerWeight_sq (epsilon mass : ℂ) :
    physicalCornerWeight epsilon mass ^ 2 = - (epsilon ^ 2 * mass ^ 2) := by
  unfold physicalCornerWeight
  calc
    (Complex.I * epsilon * mass) ^ 2
        = (Complex.I * Complex.I) * (epsilon * epsilon) * (mass * mass) := by
          ring
    _ = - (epsilon ^ 2 * mass ^ 2) := by
          rw [Complex.I_mul_I]
          ring

/--
Physical specialization of the finite telegraph recursion.  With
`mu = i epsilon m`, the second-order checkerboard recursion carries the
coefficient `-epsilon^2 m^2`.
-/
theorem pathSum_klein_gordon_physical_corner
    (epsilon mass : ℂ) (x : Int) (d : Direction)
    (n : Nat) (y : Int) (e : Direction) :
    pathSum (physicalCornerWeight epsilon mass) x d (n + 2) y e
        + pathSum (physicalCornerWeight epsilon mass) x d n y e
      =
        pathSum (physicalCornerWeight epsilon mass) x d (n + 1) (y - 1) e
        + pathSum (physicalCornerWeight epsilon mass) x d (n + 1) (y + 1) e
        + (-(epsilon ^ 2 * mass ^ 2))
          * pathSum (physicalCornerWeight epsilon mass) x d n y e := by
  simpa [physicalCornerWeight_sq] using
    pathSum_klein_gordon (mu := physicalCornerWeight epsilon mass)
      (x := x) (d := d) (n := n) (y := y) (e := e)

end PhysicsSM.Spinor.Checkerboard
