import Mathlib
import PhysicsSM.Spinor.Checkerboard

/-!
# Draft.CheckerboardSpinorRecursionAristotle

Aristotle handoff: the directed-recursion package for the finite 1+1D Feynman
checkerboard of the trusted module `PhysicsSM.Spinor.Checkerboard`.

## Mathematical intent

This is item 1, 2, and 4 of the "next theorem sequence" in
`Sources/Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md`
(research program: `Sources/Luminal_Motion_Checkerboard_Research_Program.md`).
The trusted module already proves the *first-step* decomposition
`pathSum_succ`.  This file targets:

1. basic counting facts about `histories n` (duplicate-free, cardinality
   `2 ^ n`);
2. the corner-weight/corner-count bridge
   `pathWeight mu d h = mu ^ turnCount d h`;
3. the **last-step** recursion (the checkerboard evolution as a function of
   the *endpoint*, which is the discrete 1+1D Dirac equation);
4. the packaging of the path sum as the `n`-fold iterate of a one-step
   two-component evolution operator acting on a delta initial condition;
5. the **discrete Klein-Gordon (telegraph) equation**: each directed
   component of the path sum satisfies a second-order recursion in which the
   mass weight enters only through `mu ^ 2`.  This is the finite, exact form
   of "the Dirac equation is the square root of the telegrapher's equation"
   (Gaveau--Jacobson--Kac--Schulman, Phys. Rev. Lett. 53 (1984) 419).

All statements were validated by brute-force enumeration in
`Scripts/oracle/validate_checkerboard.py` (sections "last-step recursion +
discrete Klein-Gordon"); the oracle justifies the statements, not the proofs.

## Conventions

- A history is a `List Direction` of *future* steps; the incoming direction
  is carried separately, and the corner between the incoming direction and
  the first step is counted and weighted (see the trusted module docstring).
- `turnWeight mu d e` is `1` if `e = d` and `mu` otherwise; corner weights
  multiply on the *right* as steps are appended in time order, so in the
  last-step recursion the new factor `mu` sits on the right.  Statements are
  over a general `Semiring` where this matters and over a `CommSemiring`
  where it does not.

## Proof guidance

- `histories_nodup` / `length_histories`: induction on `n`; the two mapped
  copies in `histories_succ` are disjoint because their heads differ
  (`List.Nodup.append`, `List.nodup_map_iff` with injectivity of `cons`).
- `pathWeight_eq_pow_turnCount`: induction on `h` generalizing the incoming
  direction; `turnWeight` and the `if` in `turnCount_cons` match by
  `Direction` case analysis; finish with `pow_add`/`pow_succ`.
- `pathSum_last_step`: induction on `n` generalizing `startX`, `startDir`,
  and `finishX`, using the trusted first-step decomposition `pathSum_succ`
  on both sides; the base case is a finite case check on directions and
  endpoints (`pathSum_zero_same` / `pathSum_zero_ne_pos`).
- `pathSum_eq_iterate_evolve`: induction on `n` from `pathSum_last_step`;
  `Function.iterate_succ_apply'` puts the new `evolve` on the outside.
- `pathSum_klein_gordon`: purely algebraic consequence of
  `pathSum_last_step` applied twice (once at level `n + 2` and once at level
  `n + 1`), together with `pathSum_last_step` at the flipped direction; no
  new induction should be needed.  Note `e.flip.flip = e` (`flip_flip`) and
  `e.flip.step = -e.step` (case check).

Do not change any definition of `PhysicsSM.Spinor.Checkerboard`. Helper
lemmas are welcome. The final state should contain no placeholder proof
commands, no new assumptions, and no forbidden declarations.
-/

namespace PhysicsSM.Draft.CheckerboardSpinorRecursion

open PhysicsSM.Spinor.Checkerboard
open PhysicsSM.Spinor.Checkerboard.Direction

variable {S : Type*}

/-! ## Target 1: counting the histories -/

/-- The list of length-`n` histories has no duplicates. -/
theorem histories_nodup (n : Nat) : (histories n).Nodup := by
  induction n with
  | zero => decide
  | succ n ih =>
    refine List.Nodup.append ?_ ?_ ?_
    · exact ih.map fun x y h => by simpa using h
    · exact ih.map fun x y h => by simpa using h
    · simp +decide [List.disjoint_left]

/-- There are exactly `2 ^ n` histories of length `n`. -/
theorem length_histories (n : Nat) : (histories n).length = 2 ^ n := by
  induction n with
  | zero => rfl
  | succ n ih => simp +arith +decide [pow_succ', histories_succ, ih]

/-! ## Target 2: the corner-count form of the path weight -/

/-- The path weight is the corner weight raised to the number of corners.
This is the bridge between the multiplicative `pathWeight` and the
corner-counting combinatorics of
`PhysicsSM.Draft.CheckerboardCornerCountAristotle`. -/
theorem pathWeight_eq_pow_turnCount [Semiring S] (mu : S)
    (d : Direction) (h : List Direction) :
    pathWeight mu d h = mu ^ turnCount d h := by
  induction h generalizing d with
  | nil => simp
  | cons e rest ih =>
    cases d <;> cases e <;>
      simp [turnWeight, turnCount, ih, pow_add, pow_one]

/-! ## Target 3: the last-step recursion (discrete Dirac equation)

The trusted `pathSum_succ` decomposes by the *first* step (source side).
The discrete Dirac equation is the decomposition by the *last* step
(detector side): a path arriving at `(y, e)` after `n + 1` steps was at
`(y - e.step)` after `n` steps, moving either in direction `e` (weight `1`)
or in direction `e.flip` (corner weight `mu`, multiplied on the right since
it is the most recent corner). -/

/-- **Last-step decomposition** of the finite checkerboard path sum. -/
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

/-! ## Target 4: the path sum as an iterated one-step evolution -/

/-- One step of the directed checkerboard evolution acting on a two-component
lattice wavefunction `psi : Int -> Direction -> S`: the component at `(y, e)`
receives the straight continuation from `(y - e.step, e)` and the reversal
from `(y - e.step, e.flip)` weighted by `mu` on the right. -/
def evolve [Semiring S] (mu : S) (psi : Int -> Direction -> S) :
    Int -> Direction -> S :=
  fun y e => psi (y - e.step) e + psi (y - e.step) e.flip * mu

/-- Delta initial condition concentrated at position `x` with direction `d`. -/
def deltaInit [Semiring S] (x : Int) (d : Direction) : Int -> Direction -> S :=
  fun y e => if y = x ∧ e = d then 1 else 0

/-- The finite checkerboard path sum is the `n`-fold iterate of the one-step
evolution operator applied to the delta initial condition.  This is item 4 of
the publication-advance theorem sequence: the two directed endpoint sums form
a lattice spinor evolved by a fixed local rule. -/
theorem pathSum_eq_iterate_evolve [Semiring S] (mu : S) (x : Int)
    (d : Direction) (n : Nat) (y : Int) (e : Direction) :
    pathSum mu x d n y e = (evolve mu)^[n] (deltaInit x d) y e := by
  induction n generalizing y e with
  | zero =>
    simp only [Function.iterate_zero, id_eq, deltaInit]
    by_cases h : y = x ∧ e = d
    · obtain ⟨hy, he⟩ := h
      subst hy; subst he
      simp [pathSum_zero_same]
    · rw [if_neg h, pathSum_zero_ne_pos]
      tauto
  | succ n ih =>
    rw [Function.iterate_succ_apply', evolve, ← ih, ← ih, pathSum_last_step]

/-! ## Target 5: the discrete Klein-Gordon / telegraph equation -/

/-- **Discrete Klein-Gordon equation.**  Each directed component of the
checkerboard path sum satisfies a second-order recursion in the endpoint in
which the corner weight enters only through `mu ^ 2`:

`psi_{n+2}(y) + psi_n(y) = psi_{n+1}(y - 1) + psi_{n+1}(y + 1) + mu^2 psi_n(y)`

(written additively so that the statement lives in a semiring).  With
`mu = i * eps * m` this is the lattice telegrapher's equation; the analytic
continuation `flip rate <-> i m` is the Gaveau--Jacobson--Kac--Schulman
correspondence.  Validated numerically in
`Scripts/oracle/validate_checkerboard.py`. -/
theorem pathSum_klein_gordon [CommSemiring S] (mu : S) (x : Int)
    (d : Direction) (n : Nat) (y : Int) (e : Direction) :
    pathSum mu x d (n + 2) y e + pathSum mu x d n y e
      =
        pathSum mu x d (n + 1) (y - 1) e
        + pathSum mu x d (n + 1) (y + 1) e
        + mu ^ 2 * pathSum mu x d n y e := by
  cases e <;> simp +decide [pathSum_last_step] <;> ring!

end PhysicsSM.Draft.CheckerboardSpinorRecursion
