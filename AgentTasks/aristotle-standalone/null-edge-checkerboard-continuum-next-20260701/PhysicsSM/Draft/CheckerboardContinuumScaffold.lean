import PhysicsSM.Draft.Checkerboard1D

/-!
# Checkerboard continuum-limit scaffold

This module records Lean-facing setup for the next checkerboard lane after the
finite path-sum theorem.

The content here is deliberately finite or syntactic. It does not prove a
continuum limit. It adds:

* endpoint/displacement bookkeeping for fixed-length direction tuples;
* exact algebra for the unitary isotropic checkerboard step;
* a typed record of scaling data that future analytic statements can use.

Literature orientation is recorded in `docs/CHECKERBOARD_LITERATURE_REVIEW.md`.
-/

noncomputable section

namespace PhysicsSM.Draft.CheckerboardContinuumScaffold

open Matrix
open scoped BigOperators

open PhysicsSM.Draft.Checkerboard1D

/-! ## Endpoint bookkeeping -/

/-- Number of outgoing right-moving edges in a tuple path.

Convention: for the transition from `v i.castSucc` to `v i.succ`, the physical
edge direction is recorded as the outgoing direction `v i.succ`. This convention
is explicit because some checkerboard papers index the first segment
differently. -/
def outgoingRightCount {n : Nat} (v : Fin (n + 1) -> Direction) : Nat :=
  Finset.univ.sum (fun i : Fin n => if v i.succ = 0 then 1 else 0)

/-- Number of outgoing left-moving edges in a tuple path. -/
def outgoingLeftCount {n : Nat} (v : Fin (n + 1) -> Direction) : Nat :=
  Finset.univ.sum (fun i : Fin n => if v i.succ = 1 then 1 else 0)

/-- Every outgoing edge is either right-moving or left-moving. -/
theorem outgoingRightCount_add_outgoingLeftCount {n : Nat}
    (v : Fin (n + 1) -> Direction) :
    outgoingRightCount v + outgoingLeftCount v = n := by
  unfold outgoingRightCount outgoingLeftCount
  rw [<- Finset.sum_add_distrib]
  trans Finset.univ.sum (fun _ : Fin n => 1)
  {
    refine Finset.sum_congr rfl ?_
    intro i _
    by_cases hright : v i.succ = 0
    {
      simp [hright]
    }
    {
      have hleft : v i.succ = 1 := Fin.eq_one_of_ne_zero (v i.succ) hright
      simp [hleft]
    }
  }
  simp

/-- Net spatial displacement in units of the lattice spacing, using the
outgoing-edge convention. -/
def outgoingDisplacement {n : Nat} (v : Fin (n + 1) -> Direction) : Int :=
  (outgoingRightCount v : Int) - (outgoingLeftCount v : Int)

/-! ## Exact algebra of the unitary isotropic step -/

/-- The unitary isotropic checkerboard step. -/
def isotropicStep (theta : Real) : Matrix Direction Direction Complex :=
  checkerStep (Real.cos theta : Complex) (Real.cos theta : Complex)
    (Complex.I * (Real.sin theta : Complex))

/-- The direction-reversal matrix squares to the identity. -/
theorem reversal_sq : reversal * reversal = (1 : Matrix Direction Direction Complex) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [reversal, Matrix.mul_apply, Fin.sum_univ_two]

/-- Exact decomposition of the unitary isotropic step into identity plus the
direction-reversal generator. -/
theorem isotropicStep_eq_cos_one_add_i_sin_reversal (theta : Real) :
    isotropicStep theta =
      fun i j =>
        (Real.cos theta : Complex) * (1 : Matrix Direction Direction Complex) i j +
          (Complex.I * (Real.sin theta : Complex)) * reversal i j := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [isotropicStep, checkerStep, nullTransport, massFlip, reversal]

/-- At zero angle the unitary isotropic step is the identity. -/
theorem isotropicStep_zero :
    isotropicStep 0 = (1 : Matrix Direction Direction Complex) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [isotropicStep, checkerStep, nullTransport, massFlip, reversal]

/-- The reversal generator commutes with the isotropic step. -/
theorem reversal_commutes_isotropicStep (theta : Real) :
    reversal * isotropicStep theta = isotropicStep theta * reversal := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [isotropicStep, checkerStep, nullTransport, massFlip, reversal,
      Matrix.mul_apply, Fin.sum_univ_two]

/-! ## Typed analytic scaffold -/

/-- Scaling data for a future checkerboard-to-Dirac limit statement.

The field `timeStep` is the small checkerboard time spacing. The traditional
Feynman turn weight is proportional to `timeStep * mass * c^2 / hbar`; the
unitary quantum-walk normalization instead often records this through a small
angle. This structure records the common dimensional parameters without
choosing the final analytic theorem. -/
structure CheckerboardContinuumScale where
  timeStep : Nat -> Real
  mass : Real
  lightSpeed : Real
  hbar : Real
  timeStep_pos : forall N, 0 < timeStep N
  lightSpeed_pos : 0 < lightSpeed
  hbar_pos : 0 < hbar
  timeStep_tendsto_zero : Filter.Tendsto timeStep Filter.atTop (nhds 0)

/-- Feynman's infinitesimal turn-amplitude scale, in the common convention
`-i * dt * m * c^2 / hbar`. Sign and phase conventions vary in the literature;
this definition is a named convention, not a theorem. -/
def feynmanTurnAmplitude (S : CheckerboardContinuumScale) (N : Nat) : Complex :=
  -Complex.I *
    (((S.timeStep N * S.mass * S.lightSpeed ^ 2) / S.hbar : Real) : Complex)

/-- Small-angle condition connecting a unitary checkerboard angle to the
mass scale. This is an analytic hypothesis for later work, not a proved fact. -/
def unitaryAngleHasMassScale (S : CheckerboardContinuumScale)
    (theta : Nat -> Real) : Prop :=
  Filter.Tendsto
    (fun N => theta N / S.timeStep N)
    Filter.atTop
    (nhds ((S.mass * S.lightSpeed ^ 2) / S.hbar))

/-- A placeholder-free record of what a future continuum theorem must specify.

This avoids asserting a continuum limit before the required analytic
infrastructure is selected. A later theorem should replace `convergenceClaim`
with an explicit norm/topology statement on lattice-interpolated spinor fields. -/
structure CheckerboardDiracLimitProblem where
  scale : CheckerboardContinuumScale
  theta : Nat -> Real
  angle_has_mass_scale : unitaryAngleHasMassScale scale theta
  convergenceClaim : Prop

end PhysicsSM.Draft.CheckerboardContinuumScaffold
