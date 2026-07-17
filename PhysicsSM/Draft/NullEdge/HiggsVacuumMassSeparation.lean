import PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional
import PhysicsSM.Draft.NullEdgeYukawaMassOperator

/-!
# Parallel Higgs vacuum versus local Yukawa mass

This module isolates the finite distinction needed when asking whether the
Higgs "moves" along null edges. A Higgs field is vertex-local data whose
gauge-covariant variation is sampled across edges. Consequently a parallel
vacuum section has zero edge kinetic cost. The same nonzero vacuum value can
nevertheless enter a local odd Yukawa operator and produce a nonzero squared
mass block.

The result is an exact separation theorem, not a dynamical derivation of the
electroweak vacuum, Yukawa couplings, particle masses, or a continuum Higgs
propagator. The scalar coupling and vacuum value are supplied. Claim grade:
`M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsVacuumMassSeparation

open PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional
open PhysicsSM.Draft.NullEdgeYukawaMassOperator

/-- The local Yukawa mass amplitude induced by a real vacuum value and a
complex Yukawa coupling. -/
def inducedYukawaMass (y : Complex) (vacuum : Real) : Complex :=
  y * (vacuum : Complex)

/-- A nonzero coupling and nonzero vacuum value induce a nonzero local mass
amplitude. -/
theorem inducedYukawaMass_ne_zero
    {y : Complex} {vacuum : Real} (hy : y ≠ 0) (hVacuum : vacuum ≠ 0) :
    inducedYukawaMass y vacuum ≠ 0 := by
  exact mul_ne_zero hy (Complex.ofReal_ne_zero.mpr hVacuum)

variable {X : Type*} [DecidableEq X] [Nonempty X]

/-- On a nonempty finite carrier, a nonzero scalar Yukawa amplitude gives a
nonzero chirality-flip operator. -/
theorem scalarYukawaFlipOperator_ne_zero
    {m : Complex} (hm : m ≠ 0) :
    scalarYukawaFlipOperator (X := X) m ≠ 0 := by
  classical
  obtain ⟨x⟩ := ‹Nonempty X›
  intro hZero
  have hEntry := congrArg
    (fun M : Matrix (Sum X X) (Sum X X) Complex =>
      M (Sum.inl x) (Sum.inr x)) hZero
  apply hm
  simpa [scalarYukawaFlipOperator, offDiagonal, Matrix.one_apply] using hEntry

/-- A covariantly constant frozen-modulus Higgs vacuum can have zero finite
edge kinetic cost while inducing a nonzero local Yukawa mass operator whose
square is the displayed scalar mass block. This is the exact finite content of
"the vacuum does not propagate, but it changes fermion propagation." -/
theorem parallelVacuum_zero_cost_and_nonzero_localYukawa
    {V E : Type*} [Fintype V] [Fintype E] [Fintype X]
    (s t : E -> V) (edgeWeight : E -> Real) (vertexWeight : V -> Real)
    (lam vacuum : Real) (sigma : V -> Circle) (y : Complex)
    (hy : y ≠ 0) (hVacuum : vacuum ≠ 0) :
    weightedHiggsFunctional s t edgeWeight vertexWeight lam vacuum
        (fun x => (vacuum : Complex) * (sigma x : Complex))
        (fun e => sigma (s e) * (sigma (t e))⁻¹) = 0 /\
      scalarYukawaFlipOperator (X := X) (inducedYukawaMass y vacuum) *
          scalarYukawaFlipOperator (X := X) (inducedYukawaMass y vacuum) =
        (inducedYukawaMass y vacuum * inducedYukawaMass y vacuum) •
          (1 : Matrix (Sum X X) (Sum X X) Complex) /\
      scalarYukawaFlipOperator (X := X) (inducedYukawaMass y vacuum) ≠ 0 := by
  have hm : inducedYukawaMass y vacuum ≠ 0 :=
    inducedYukawaMass_ne_zero hy hVacuum
  exact ⟨weightedHiggsFunctional_parallel_vacuum_zero
      s t edgeWeight vertexWeight lam vacuum sigma,
    scalarYukawaFlipOperator_sq_eq_massSq (X := X)
      (inducedYukawaMass y vacuum),
    scalarYukawaFlipOperator_ne_zero hm⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsVacuumMassSeparation.inducedYukawaMass_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms inducedYukawaMass_ne_zero

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsVacuumMassSeparation.scalarYukawaFlipOperator_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms scalarYukawaFlipOperator_ne_zero

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsVacuumMassSeparation.parallelVacuum_zero_cost_and_nonzero_localYukawa' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parallelVacuum_zero_cost_and_nonzero_localYukawa

end PhysicsSM.Draft.NullEdge.HiggsVacuumMassSeparation

end
