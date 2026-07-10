import PhysicsSM.Draft.NullEdge.CheckerboardPathSumTransferPower
import PhysicsSM.Draft.NullEdge.PluckerMassDynamics

/-!
# Direct complex Pluecker checkerboard path sum

The earlier checkerboard theorem factors every turn through one common scalar.
That form cannot literally distinguish the two oriented entries `z` and
`conj z` of the Pluecker mass coin.  Here each directed edge receives its own
matrix entry.  The resulting finite sum over all direction histories is proved
equal to the corresponding power of the *actual complex Pluecker coin*.

Thus the orientation product is no longer imported from a separate spectral
conjugacy: it occurs directly in every history weight.  The theorem is finite
and algebraic.  It does not yet include position-dependent `z`, spatial
translation phases, a continuum limit, or an interacting path integral.

Provenance: clean-room extension of `CheckerboardPathSumTransferPower`, using
the kernel-checked coin in `PluckerMassDynamics`.  Lean 4.28.0.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.ComplexPlueckerCheckerboardPathSum

open PhysicsSM.Draft.NullEdge.CheckerboardPathSumTransferPower
open PhysicsSM.Draft.NullEdge.CheckerboardPathSumTransferPower.Direction
open PhysicsSM.Draft.NullEdge.PluckerMassDynamics

/-- Product of fully oriented edge amplitudes along one direction history. -/
def edgePathWeight {R : Type*} [Semiring R]
    (T : Matrix Direction Direction R) : Direction -> List Direction -> R
  | _, [] => 1
  | d, e :: rest => T e d * edgePathWeight T e rest

/-- Sum over all direction histories of fixed length and endpoints. -/
def edgePathSum {R : Type*} [Semiring R]
    (T : Matrix Direction Direction R) (n : Nat)
    (start finish : Direction) : R :=
  ((histories n).map fun h =>
    if terminalDirection start h = finish then edgePathWeight T start h
    else 0).sum

theorem edgePathSum_zero {R : Type*} [Semiring R]
    (T : Matrix Direction Direction R) (start finish : Direction) :
    edgePathSum T 0 start finish = (1 : Matrix Direction Direction R) finish start := by
  unfold edgePathSum
  cases start <;> cases finish <;>
    simp +decide [edgePathWeight, histories]

theorem edgePathSum_succ {R : Type*} [CommSemiring R]
    (T : Matrix Direction Direction R) (n : Nat)
    (start finish : Direction) :
    edgePathSum T (n + 1) start finish =
      ∑ middle : Direction, edgePathSum T n middle finish * T middle start := by
  have hdouble : edgePathSum T (n + 1) start finish =
      T left start * edgePathSum T n left finish +
        T right start * edgePathSum T n right finish := by
    unfold edgePathSum
    simp +decide only [histories, List.map_append, List.sum_append]
    simp +decide [<- List.sum_map_mul_left]
    congr! 2
  rw [hdouble,
    show (Finset.univ : Finset Direction) = {left, right} by decide,
    Finset.sum_pair]
  · ring
  · decide +revert

/-- **Direct oriented path sum = transfer power.** -/
theorem edgePathSum_eq_pow {R : Type*} [CommSemiring R]
    (T : Matrix Direction Direction R) (n : Nat)
    (start finish : Direction) :
    edgePathSum T n start finish = (T ^ n) finish start := by
  induction' n with n ih generalizing start finish
  · convert edgePathSum_zero T start finish using 1
  · convert edgePathSum_succ T n start finish using 1
    simp_all +decide [pow_succ, Matrix.mul_apply]

/-- Direction labels reindex the two components of the Pluecker coin. -/
def directionIndex : Direction -> Fin 2
  | left => 0
  | right => 1

/-- The exact complex Pluecker mass coin as a direction transfer matrix. -/
def plueckerTransfer (z : Complex) (a : Real) :
    Matrix Direction Direction Complex :=
  fun finish start => massCoin z a (directionIndex finish) (directionIndex start)

/-- The two turn orientations retain `z` and `conj z` separately. -/
theorem plueckerTransfer_turn_entries (z : Complex) (a : Real) :
    plueckerTransfer z a left right =
        -(I * Complex.sin (a * ‖z‖) / (‖z‖ : Complex)) * z ∧
      plueckerTransfer z a right left =
        -(I * Complex.sin (a * ‖z‖) / (‖z‖ : Complex)) *
          (starRingEnd Complex) z := by
  constructor <;>
    simp [plueckerTransfer, directionIndex, massCoin,
      PhysicsSM.Draft.NullEdge.PluckerMassOperator.massOperator]

/-- The direct complex history sum is exactly the power of the actual
Pluecker-derived transfer matrix. -/
theorem complexPlueckerPathSum_eq_transfer_pow
    (z : Complex) (a : Real) (n : Nat)
    (start finish : Direction) :
    edgePathSum (plueckerTransfer z a) n start finish =
      (plueckerTransfer z a ^ n) finish start := by
  exact edgePathSum_eq_pow _ _ _ _

/-- Nondegenerate orientation control: at the rational `3+4i` Pluecker point,
the two normalized directed turn factors are nonzero and unequal. -/
theorem three_four_orientation_control :
    (3 + 4 * I : Complex) / 5 ≠ 0 ∧
      (starRingEnd Complex (3 + 4 * I : Complex)) / 5 ≠ 0 ∧
      (3 + 4 * I : Complex) / 5 ≠
        (starRingEnd Complex (3 + 4 * I : Complex)) / 5 := by
  norm_num [Complex.ext_iff]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ComplexPlueckerCheckerboardPathSum.complexPlueckerPathSum_eq_transfer_pow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms complexPlueckerPathSum_eq_transfer_pow

/-- info: 'PhysicsSM.Draft.NullEdge.ComplexPlueckerCheckerboardPathSum.three_four_orientation_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms three_four_orientation_control

end PhysicsSM.Draft.NullEdge.ComplexPlueckerCheckerboardPathSum
