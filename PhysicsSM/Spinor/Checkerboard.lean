import Mathlib.Algebra.BigOperators.Ring.List
import Mathlib.Data.Int.Basic

/-!
# Spinor.Checkerboard

Finite combinatorics for the `1+1`-dimensional Feynman checkerboard.

This module is the first trusted Lean foothold for the research program in
`Sources/Luminal_Motion_Checkerboard_Research_Program.md`.  It formalizes only
the finite, pre-analytic part: a path is a finite list of lightlike left/right
steps, each corner receives a scalar weight `mu`, and the finite path sum
decomposes exactly by the first step.

The continuum limit to Bessel functions, the retarded Dirac propagator, and
the comparison with Skopenkov--Ustinov are intentionally not asserted here.

Sources:
- R. P. Feynman and A. R. Hibbs, "Quantum Mechanics and Path Integrals",
  Problem 2-6.
- M. Skopenkov and A. Ustinov, "Feynman checkers: towards algorithmic quantum
  theory", Russian Math. Surveys 77:3 (2022), 73-160; arXiv:2007.12879.

Provenance: clean-room formalization of the elementary finite path bookkeeping.

Status: trusted, no `s o r r y`.
-/

namespace PhysicsSM.Spinor.Checkerboard

/-! ## Directions and elementary path data -/

/-- A checkerboard step direction.  `right` has displacement `+1`, and `left`
has displacement `-1`. -/
inductive Direction where
  | left
  | right
  deriving DecidableEq, Repr

namespace Direction

/-- The opposite lightlike direction. -/
def flip : Direction -> Direction
  | left => right
  | right => left

@[simp] theorem flip_left : flip left = right := rfl
@[simp] theorem flip_right : flip right = left := rfl

@[simp] theorem flip_flip (d : Direction) : flip (flip d) = d := by
  cases d <;> rfl

/-- Spatial displacement of a unit time step. -/
def step : Direction -> Int
  | left => -1
  | right => 1

@[simp] theorem step_left : step left = -1 := rfl
@[simp] theorem step_right : step right = 1 := rfl

end Direction

open Direction

variable {R : Type u} [Semiring R]

/-- Corner weight for passing from one direction to the next.  Continuing
straight has weight `1`; reversing direction has weight `mu`.  In the physical
checkerboard one later specializes `mu = i epsilon m`. -/
def turnWeight (mu : R) : Direction -> Direction -> R
  | left, left => 1
  | left, right => mu
  | right, left => mu
  | right, right => 1

@[simp] theorem turnWeight_same (mu : R) (d : Direction) :
    turnWeight mu d d = 1 := by
  cases d <;> rfl

@[simp] theorem turnWeight_flip (mu : R) (d : Direction) :
    turnWeight mu d d.flip = mu := by
  cases d <;> rfl

/-- The terminal direction after following a list of future steps from an
initial direction.  With no future step, the terminal direction is the initial
one. -/
def terminalDirection : Direction -> List Direction -> Direction
  | d, [] => d
  | _, e :: rest => terminalDirection e rest

@[simp] theorem terminalDirection_nil (d : Direction) :
    terminalDirection d [] = d := rfl

@[simp] theorem terminalDirection_cons (d e : Direction) (rest : List Direction) :
    terminalDirection d (e :: rest) = terminalDirection e rest := rfl

/-- The spatial endpoint after following a list of future steps from a starting
position.  The initial direction is carried only so that this function has the
same argument shape as `pathWeight` and `terminalDirection`. -/
def endpoint : Int -> Direction -> List Direction -> Int
  | x, _, [] => x
  | x, _, e :: rest => endpoint (x + e.step) e rest

@[simp] theorem endpoint_nil (x : Int) (d : Direction) :
    endpoint x d [] = x := rfl

@[simp] theorem endpoint_cons (x : Int) (d e : Direction) (rest : List Direction) :
    endpoint x d (e :: rest) = endpoint (x + e.step) e rest := rfl

/-- Number of corners (direction reversals) along a finite future history,
counting the corner between the incoming direction and the first step.  The
corner-count refinement of `pathWeight`: see
`PhysicsSM.Draft.CheckerboardSpinorRecursionAristotle.pathWeight_eq_pow_turnCount`
for the statement `pathWeight mu d h = mu ^ turnCount d h`. -/
def turnCount : Direction -> List Direction -> Nat
  | _, [] => 0
  | d, e :: rest => (if e = d then 0 else 1) + turnCount e rest

@[simp] theorem turnCount_nil (d : Direction) : turnCount d [] = 0 := rfl

theorem turnCount_cons (d e : Direction) (rest : List Direction) :
    turnCount d (e :: rest) = (if e = d then 0 else 1) + turnCount e rest := rfl

/-- Product of corner weights along a finite future history. -/
def pathWeight (mu : R) : Direction -> List Direction -> R
  | _, [] => 1
  | d, e :: rest => turnWeight mu d e * pathWeight mu e rest

@[simp] theorem pathWeight_nil (mu : R) (d : Direction) :
    pathWeight mu d [] = 1 := rfl

@[simp] theorem pathWeight_cons (mu : R) (d e : Direction) (rest : List Direction) :
    pathWeight mu d (e :: rest) = turnWeight mu d e * pathWeight mu e rest := rfl

/-! ## Finite histories and finite path sums -/

/-- All left/right histories of length `n`, represented as lists of future
directions in chronological order. -/
def histories : Nat -> List (List Direction)
  | 0 => [[]]
  | n + 1 =>
      (histories n).map (fun rest => left :: rest)
        ++ (histories n).map (fun rest => right :: rest)

@[simp] theorem histories_zero : histories 0 = [[]] := rfl

@[simp] theorem histories_succ (n : Nat) :
    histories (n + 1) =
      (histories n).map (fun rest => left :: rest)
        ++ (histories n).map (fun rest => right :: rest) := rfl

/-- Every listed history has the advertised length. -/
theorem mem_histories_length {n : Nat} {h : List Direction} :
    h ∈ histories n -> h.length = n := by
  induction n generalizing h with
  | zero =>
      intro hh
      simp at hh
      subst h
      rfl
  | succ n ih =>
      intro hh
      have hh' :
          h ∈ (histories n).map (fun rest => left :: rest)
            ∨ h ∈ (histories n).map (fun rest => right :: rest) := by
        simpa only [histories_succ, List.mem_append] using hh
      rcases hh' with hhLeft | hhRight
      · rcases List.mem_map.mp hhLeft with ⟨rest, hrest, hEq⟩
        rw [← hEq]
        simp [ih hrest]
      · rcases List.mem_map.mp hhRight with ⟨rest, hrest, hEq⟩
        rw [← hEq]
        simp [ih hrest]

/-- Finite checkerboard path sum from `(startX, startDir)` to
`(finishX, finishDir)` in exactly `n` future steps. -/
def pathSum (mu : R) (startX : Int) (startDir : Direction)
    (n : Nat) (finishX : Int) (finishDir : Direction) : R :=
  ((histories n).map fun h =>
    if endpoint startX startDir h = finishX
        ∧ terminalDirection startDir h = finishDir then
      pathWeight mu startDir h
    else
      0).sum

@[simp] theorem pathSum_zero_same (mu : R) (x : Int) (d : Direction) :
    pathSum mu x d 0 x d = 1 := by
  simp [pathSum]

@[simp] theorem pathSum_zero_ne_pos (mu : R) {x y : Int} {d e : Direction}
    (h : ¬ (x = y ∧ d = e)) :
    pathSum mu x d 0 y e = 0 := by
  simp [pathSum, h]

/-- **First-step decomposition.**  The exact finite checkerboard path sum is
obtained by choosing the first lightlike step, multiplying by its corner
weight, and summing the remaining path sums.  This is the kernel-checked finite
version of the checkerboard one-step recursion; no continuum limit is involved.
-/
theorem pathSum_succ (mu : R) (startX : Int) (startDir : Direction)
    (n : Nat) (finishX : Int) (finishDir : Direction) :
    pathSum mu startX startDir (n + 1) finishX finishDir
      =
        turnWeight mu startDir left
          * pathSum mu (startX + left.step) left n finishX finishDir
        +
        turnWeight mu startDir right
          * pathSum mu (startX + right.step) right n finishX finishDir := by
  let F : List Direction -> R := fun h =>
    if endpoint startX startDir h = finishX
        ∧ terminalDirection startDir h = finishDir then
      pathWeight mu startDir h
    else
      0
  let FL : List Direction -> R := fun rest =>
    if endpoint (startX + left.step) left rest = finishX
        ∧ terminalDirection left rest = finishDir then
      pathWeight mu left rest
    else
      0
  let FR : List Direction -> R := fun rest =>
    if endpoint (startX + right.step) right rest = finishX
        ∧ terminalDirection right rest = finishDir then
      pathWeight mu right rest
    else
      0
  have hLeftEval (rest : List Direction) :
      F (left :: rest) = turnWeight mu startDir left * FL rest := by
    simp only [F, FL, endpoint_cons, terminalDirection_cons, pathWeight_cons]
    by_cases h :
        endpoint (startX + left.step) left rest = finishX
          ∧ terminalDirection left rest = finishDir
    · rw [if_pos h, if_pos h]
    · rw [if_neg h, if_neg h, mul_zero]
  have hRightEval (rest : List Direction) :
      F (right :: rest) = turnWeight mu startDir right * FR rest := by
    simp only [F, FR, endpoint_cons, terminalDirection_cons, pathWeight_cons]
    by_cases h :
        endpoint (startX + right.step) right rest = finishX
          ∧ terminalDirection right rest = finishDir
    · rw [if_pos h, if_pos h]
    · rw [if_neg h, if_neg h, mul_zero]
  have hLeftSum :
      ∀ rests : List (List Direction),
        (rests.map fun rest => F (left :: rest)).sum
          =
            (rests.map fun rest => turnWeight mu startDir left * FL rest).sum := by
    intro rests
    induction rests with
    | nil =>
        simp
    | cons rest rests ih =>
        simp [hLeftEval rest, ih]
  have hRightSum :
      ∀ rests : List (List Direction),
        (rests.map fun rest => F (right :: rest)).sum
          =
            (rests.map fun rest => turnWeight mu startDir right * FR rest).sum := by
    intro rests
    induction rests with
    | nil =>
        simp
    | cons rest rests ih =>
        simp [hRightEval rest, ih]
  have hsplit :
      (((histories n).map (fun rest => left :: rest)
          ++ (histories n).map (fun rest => right :: rest)).map F).sum
        =
          ((histories n).map fun rest => turnWeight mu startDir left * FL rest).sum
          +
          ((histories n).map fun rest => turnWeight mu startDir right * FR rest).sum := by
    simp only [List.map_append, List.sum_append, List.map_map]
    change ((histories n).map fun rest => F (left :: rest)).sum
        + ((histories n).map fun rest => F (right :: rest)).sum
      =
        ((histories n).map fun rest => turnWeight mu startDir left * FL rest).sum
        +
        ((histories n).map fun rest => turnWeight mu startDir right * FR rest).sum
    rw [hLeftSum, hRightSum]
  change (((histories (n + 1)).map F).sum)
      =
        turnWeight mu startDir left * ((histories n).map FL).sum
        +
        turnWeight mu startDir right * ((histories n).map FR).sum
  rw [histories_succ, hsplit]
  rw [List.sum_map_mul_left, List.sum_map_mul_left]

end PhysicsSM.Spinor.Checkerboard
