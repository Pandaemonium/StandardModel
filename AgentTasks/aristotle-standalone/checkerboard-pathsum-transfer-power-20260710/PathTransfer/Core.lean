import Mathlib

namespace PathTransfer

inductive Direction where
  | left
  | right
  deriving DecidableEq, Fintype, Repr

open Direction

def turnWeight {R : Type*} [Semiring R] (mu : R) :
    Direction → Direction → R
  | left, left => 1
  | left, right => mu
  | right, left => mu
  | right, right => 1

def histories : Nat → List (List Direction)
  | 0 => [[]]
  | n + 1 =>
      (histories n).map (fun rest => left :: rest) ++
        (histories n).map (fun rest => right :: rest)

def terminalDirection : Direction → List Direction → Direction
  | d, [] => d
  | _, e :: rest => terminalDirection e rest

def phasedPathWeight {R : Type*} [Semiring R] (mu : R)
    (phase : Direction → R) : Direction → List Direction → R
  | _, [] => 1
  | d, e :: rest =>
      turnWeight mu d e * phase e * phasedPathWeight mu phase e rest

def directionPathSum {R : Type*} [Semiring R] (mu : R)
    (phase : Direction → R) (n : Nat) (start finish : Direction) : R :=
  ((histories n).map fun h =>
    if terminalDirection start h = finish then
      phasedPathWeight mu phase start h
    else 0).sum

/-- One-step transfer matrix. Rows are outgoing/final directions and columns
are incoming directions. The phase belongs to the outgoing step. -/
def transfer {R : Type*} [Semiring R] (mu : R)
    (phase : Direction → R) : Matrix Direction Direction R :=
  fun finish start => turnWeight mu start finish * phase finish

theorem directionPathSum_zero {R : Type*} [Semiring R] (mu : R)
    (phase : Direction → R) (start finish : Direction) :
    directionPathSum mu phase 0 start finish =
      (1 : Matrix Direction Direction R) finish start := by
  sorry

theorem directionPathSum_succ {R : Type*} [CommSemiring R] (mu : R)
    (phase : Direction → R) (n : Nat) (start finish : Direction) :
    directionPathSum mu phase (n + 1) start finish =
      ∑ middle : Direction,
        directionPathSum mu phase n middle finish *
          transfer mu phase middle start := by
  sorry

/-- **Finite path-sum = transfer-matrix power.** The exact sum over all
direction histories, including every turn and outgoing-step phase, is the
corresponding matrix element of the `n`th transfer power. -/
theorem directionPathSum_eq_transfer_pow {R : Type*} [CommSemiring R]
    (mu : R) (phase : Direction → R) (n : Nat)
    (start finish : Direction) :
    directionPathSum mu phase n start finish =
      (transfer mu phase ^ n) finish start := by
  sorry

def witnessPhase : Direction → ℤ
  | left => 3
  | right => 5

/-- Nondegenerate two-step fixture: both a straight path and a two-turn path
contribute, the transfer is off-diagonal, and the common exact value is `85`. -/
theorem two_step_nontrivial_witness :
    directionPathSum (2 : ℤ) witnessPhase 2 right right = 85 ∧
      (transfer (2 : ℤ) witnessPhase ^ 2) right right = 85 ∧
      transfer (2 : ℤ) witnessPhase left right ≠ 0 ∧
      transfer (2 : ℤ) witnessPhase right left ≠ 0 := by
  sorry

end PathTransfer
