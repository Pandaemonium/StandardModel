import Mathlib

/-!
# Exact checkerboard path sum as a transfer-matrix power

This module proves that the finite sum over all two-direction histories, with
one turn weight and one outgoing phase per step, is exactly the corresponding
matrix element of the transfer operator raised to the history length. The
two-step integer fixture is nonzero and order-sensitive enough to exclude a
straight-only or diagonal-transfer collapse.

This is a finite combinatorial identity. It does not yet identify the transfer
with a unitary Dirac walk, perform a Fourier transform, or prove a continuum
PDE limit.

Provenance: clean-room statement prepared after the 2026-07-10 literature pass
on checkerboard and quantum-walk path sums; proof returned by Aristotle project
`18f119a4-7469-4e93-a592-d3342605e5d4` and locally reviewed.
-/

namespace PhysicsSM.Draft.NullEdge.CheckerboardPathSumTransferPower

inductive Direction where
  | left
  | right
  deriving DecidableEq, Fintype, Repr

open Direction

def turnWeight {R : Type*} [Semiring R] (mu : R) :
    Direction -> Direction -> R
  | left, left => 1
  | left, right => mu
  | right, left => mu
  | right, right => 1

def histories : Nat -> List (List Direction)
  | 0 => [[]]
  | n + 1 =>
      (histories n).map (fun rest => left :: rest) ++
        (histories n).map (fun rest => right :: rest)

def terminalDirection : Direction -> List Direction -> Direction
  | d, [] => d
  | _, e :: rest => terminalDirection e rest

def phasedPathWeight {R : Type*} [Semiring R] (mu : R)
    (phase : Direction -> R) : Direction -> List Direction -> R
  | _, [] => 1
  | d, e :: rest =>
      turnWeight mu d e * phase e * phasedPathWeight mu phase e rest

def directionPathSum {R : Type*} [Semiring R] (mu : R)
    (phase : Direction -> R) (n : Nat) (start finish : Direction) : R :=
  ((histories n).map fun h =>
    if terminalDirection start h = finish then
      phasedPathWeight mu phase start h
    else 0).sum

/-- One-step transfer matrix. Rows are outgoing/final directions and columns
are incoming directions. The phase belongs to the outgoing step. -/
def transfer {R : Type*} [Semiring R] (mu : R)
    (phase : Direction -> R) : Matrix Direction Direction R :=
  fun finish start => turnWeight mu start finish * phase finish

theorem directionPathSum_zero {R : Type*} [Semiring R] (mu : R)
    (phase : Direction -> R) (start finish : Direction) :
    directionPathSum mu phase 0 start finish =
      (1 : Matrix Direction Direction R) finish start := by
  unfold directionPathSum
  cases start <;> cases finish <;>
    simp +decide [phasedPathWeight, histories]

theorem directionPathSum_succ {R : Type*} [CommSemiring R] (mu : R)
    (phase : Direction -> R) (n : Nat) (start finish : Direction) :
    directionPathSum mu phase (n + 1) start finish =
      ∑ middle : Direction,
        directionPathSum mu phase n middle finish *
          transfer mu phase middle start := by
  have hdouble : directionPathSum mu phase (n + 1) start finish =
      turnWeight mu start left * phase left *
          directionPathSum mu phase n left finish +
        turnWeight mu start right * phase right *
          directionPathSum mu phase n right finish := by
    unfold directionPathSum
    simp +decide only [histories, List.map_append, List.sum_append]
    simp +decide [← List.sum_map_mul_left]
    congr! 2
  rw [hdouble,
    show (Finset.univ : Finset Direction) = {left, right} by decide,
    Finset.sum_pair]
  · unfold transfer
    ring
  · decide +revert

/-- **Finite path-sum = transfer-matrix power.** The exact sum over all
direction histories, including every turn and outgoing-step phase, is the
corresponding matrix element of the `n`th transfer power. -/
theorem directionPathSum_eq_transfer_pow {R : Type*} [CommSemiring R]
    (mu : R) (phase : Direction -> R) (n : Nat)
    (start finish : Direction) :
    directionPathSum mu phase n start finish =
      (transfer mu phase ^ n) finish start := by
  induction' n with n ih generalizing start finish
  · convert directionPathSum_zero mu phase start finish using 1
  · convert directionPathSum_succ mu phase n start finish using 1
    simp_all +decide [pow_succ, Matrix.mul_apply]

def witnessPhase : Direction -> ℤ
  | left => 3
  | right => 5

/-- Nondegenerate two-step fixture: both a straight path and a two-turn path
contribute, the transfer is off-diagonal, and the common exact value is `85`. -/
theorem two_step_nontrivial_witness :
    directionPathSum (2 : ℤ) witnessPhase 2 right right = 85 ∧
      (transfer (2 : ℤ) witnessPhase ^ 2) right right = 85 ∧
      transfer (2 : ℤ) witnessPhase left right ≠ 0 ∧
      transfer (2 : ℤ) witnessPhase right left ≠ 0 := by
  decide +revert

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CheckerboardPathSumTransferPower.directionPathSum_eq_transfer_pow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms directionPathSum_eq_transfer_pow

/-- info: 'PhysicsSM.Draft.NullEdge.CheckerboardPathSumTransferPower.two_step_nontrivial_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms two_step_nontrivial_witness

end PhysicsSM.Draft.NullEdge.CheckerboardPathSumTransferPower
