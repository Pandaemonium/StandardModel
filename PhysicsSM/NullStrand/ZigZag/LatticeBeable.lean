import Mathlib
import PhysicsSM.NullStrand.Conventions

/-!
# NullStrand.ZigZag.LatticeBeable

Finite algebraic layer for the lattice beable step used by the exact finite
checkerboard model. This module is intentionally finite-dimensional and keeps the
implementation close to the roadmap READY goals.
-/

noncomputable section

namespace PhysicsSM.NullStrand.ZigZag

open scoped BigOperators
open Finset

-- Two chiral branches.
abbrev Chiral := Bool

-- Density over positions and chirality.
abbrev LatticeDensity (L : Type*) [Fintype L] := L → Chiral → ℝ

-- Total mass of a lattice density.
def latticeBornMass {L : Type*} [Fintype L] (rho : LatticeDensity L) : ℝ :=
  ∑ x : L, ∑ c : Chiral, rho x c

-- Local coin kernel used by the one-step transport.
structure CoinKernel where
  kernel : Matrix Chiral Chiral ℝ
  nonneg : ∀ c c', 0 ≤ kernel c c'
  rowSum : ∀ c, (∑ c' : Chiral, kernel c c') = 1

-- Null-step bookkeeping for each chirality branch.
--
-- The record now carries *genuine Minkowski nullity* (`null`) in addition to the
-- time-component normalization (`timeComponent`).  Concretely, each chirality
-- branch shift is a null 4-vector in the `(+---)` convention
-- (`minkowskiSq (step c) = 0`), i.e. its time component squared equals the
-- squared norm of its spatial part.  This is the full physical content of a
-- "null shift"; the older version only recorded `step c 0 = lightSpeed`, which
-- by itself does not pin down the spatial magnitude.
structure NullShift where
  step : Chiral → Minkowski4
  lightSpeed : ℝ
  timeComponent : ∀ c, step c 0 = lightSpeed
  /-- Genuine Minkowski nullity: each chirality branch shift is a null 4-vector
  in the `(+---)` convention. -/
  null : ∀ c, PhysicsSM.NullStrand.minkowskiSq (step c) = 0

-- Minimal finite model data for one-step lattice beable transport.
structure LatticeBeable (L : Type*) [Fintype L] where
  coin : CoinKernel
  shift : NullShift

-- Born transport through one local coin application.
def coinBornTransport {L : Type*} [Fintype L] (M : LatticeBeable L)
    (rho : LatticeDensity L) : LatticeDensity L :=
  fun x c' => ∑ c : Chiral, rho x c * M.coin.kernel c c'

-- Alias used by the finite-step API.
def oneStep {L : Type*} [Fintype L] (M : LatticeBeable L) :
    LatticeDensity L → LatticeDensity L :=
  coinBornTransport M

/-- The one-step coin map preserves nonnegativity and local mass when the input is
nonnegative. -/
theorem coinBornTransport_isStochastic {L : Type*} [Fintype L]
    (M : LatticeBeable L) (rho : LatticeDensity L)
    (hRho : ∀ x c, 0 ≤ rho x c) :
    (∀ x c', 0 ≤ coinBornTransport M rho x c') ∧
      (∀ x, ∑ c' : Chiral, coinBornTransport M rho x c' = ∑ c : Chiral, rho x c) := by
  constructor
  · intro x c'
    unfold coinBornTransport
    refine Finset.sum_nonneg ?_
    intro c hc
    exact mul_nonneg (hRho x c) (M.coin.nonneg c c')
  · intro x
    -- Swap the finite sums, then use row sums of the coin.
    unfold coinBornTransport
    rw [Finset.sum_comm]
    calc
      ∑ c : Chiral, ∑ c' : Chiral, rho x c * M.coin.kernel c c'
          = ∑ c : Chiral, rho x c * (∑ c' : Chiral, M.coin.kernel c c') := by
            refine Finset.sum_congr rfl ?_
            intro c _hc
            rw [← Finset.mul_sum]
      _ = ∑ c : Chiral, rho x c * 1 := by
            refine Finset.sum_congr rfl ?_
            intro c _hc
            rw [M.coin.rowSum c]
      _ = ∑ c : Chiral, rho x c := by simp

/-- Source-position marginal is preserved by the local coin map at each site.

This is the READY-step statement for the shift-free part of the lattice beable
transport: for every position, total chirality mass is unchanged.
-/
theorem coinBornTransport_sourceMarginal {L : Type*} [Fintype L]
    (M : LatticeBeable L) (rho : LatticeDensity L) (x : L) :
    ∑ c : Chiral, coinBornTransport M rho x c = ∑ c : Chiral, rho x c := by
  unfold coinBornTransport
  rw [Finset.sum_comm]
  calc
    ∑ c : Chiral, ∑ c' : Chiral, rho x c * M.coin.kernel c c'
        = ∑ c : Chiral, rho x c * (∑ c' : Chiral, M.coin.kernel c c') := by
          refine Finset.sum_congr rfl ?_
          intro c _hc
          rw [← Finset.mul_sum]
    _ = ∑ c : Chiral, rho x c * 1 := by
          refine Finset.sum_congr rfl ?_
          intro c _hc
          rw [M.coin.rowSum c]
    _ = ∑ c : Chiral, rho x c := by simp

/-- Target-position marginal in this abstract model matches the source marginal.

With the minimal finite API (coin before any geometric step), this is identical to
`coinBornTransport_sourceMarginal`.
-/
theorem coinBornTransport_targetMarginal {L : Type*} [Fintype L]
    (M : LatticeBeable L) (rho : LatticeDensity L) (x : L) :
    ∑ c : Chiral, coinBornTransport M rho x c = ∑ c : Chiral, rho x c := by
  simpa using coinBornTransport_sourceMarginal (M := M) rho x

/-- Total Born mass is preserved by one coin step.

No geometric assumptions are needed; this is purely finite-algebraic.
-/
theorem latticeBeable_oneStep_equivariant {L : Type*} [Fintype L]
    (M : LatticeBeable L) (rho : LatticeDensity L) :
    latticeBornMass (oneStep M rho) = latticeBornMass rho := by
  unfold latticeBornMass oneStep
  refine Finset.sum_congr rfl ?_
  intro x hx
  exact coinBornTransport_sourceMarginal (M := M) rho x

/-- Finite-iterate mass conservation for the lattice beable one-step map. -/
theorem latticeBeable_nStep_equivariant {L : Type*} [Fintype L]
    (M : LatticeBeable L) (rho : LatticeDensity L) (n : ℕ) :
    latticeBornMass ((oneStep M)^[n] rho) = latticeBornMass rho := by
  induction n with
  | zero =>
      simp
  | succ n ih =>
      simpa [Function.iterate_succ_apply', ih] using
        latticeBeable_oneStep_equivariant (M := M)
          (rho := (oneStep M)^[n] rho)

/-- Null-step kinematics in this finite abstraction.

The model records a common time component `lightSpeed` for each chirality branch.
-/
theorem actualShift_speed_eq_c {L : Type*} [Fintype L] (M : LatticeBeable L) (c : Chiral) :
    M.shift.step c 0 = M.shift.lightSpeed := by
  exact M.shift.timeComponent c

/-- Genuine Minkowski nullity of the per-branch shift in this finite abstraction.

Each chirality branch shift is a null 4-vector in the `(+---)` convention:
`minkowskiSq (step c) = 0`, i.e. the squared time component equals the squared
spatial norm.  Unlike `actualShift_speed_eq_c` (which only fixes the time
component), this is the full Minkowski-nullity statement and is the datum now
recorded by `NullShift.null`. -/
theorem actualShift_isNull {L : Type*} [Fintype L] (M : LatticeBeable L) (c : Chiral) :
    PhysicsSM.NullStrand.minkowskiSq (M.shift.step c) = 0 :=
  M.shift.null c

end PhysicsSM.NullStrand.ZigZag
