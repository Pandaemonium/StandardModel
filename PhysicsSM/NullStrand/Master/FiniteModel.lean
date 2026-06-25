import Mathlib

/-!
# NullStrand.Master.FiniteModel

Finite-model wrapper theorem for the first complete NullStrand endpoint target.
-/

noncomputable section

namespace PhysicsSM.NullStrand.Master

/-- Abstract finite model interface used as a clean endpoint statement package.

The three `Prop` fields name the endpoint claims; the corresponding `_holds`
fields carry their proofs, so a value of this structure is a finite model in which
all three endpoint properties actually hold. Without the witness fields the
conjunction is not derivable (a bare `Prop` field is data naming a proposition,
not evidence that it is true), so the earlier witness-free version was both
vacuous and ill-typed. -/
structure FiniteNullStrandModel where
  Configuration : Type*
  [instFintype : Fintype Configuration]
  eachContinuousStepIsNull : Prop
  positionMarginalIsBorn : Prop
  empiricalVelocityConvergesToBaseCurrent : Prop
  eachContinuousStepIsNull_holds : eachContinuousStepIsNull
  positionMarginalIsBorn_holds : positionMarginalIsBorn
  empiricalVelocityConvergesToBaseCurrent_holds : empiricalVelocityConvergesToBaseCurrent

attribute [instance] FiniteNullStrandModel.instFintype

/-- Master finite model statement: project the bundled endpoint witnesses. -/
theorem finiteNullStrand_master
    (M : FiniteNullStrandModel) :
    M.eachContinuousStepIsNull ∧
      M.positionMarginalIsBorn ∧
      M.empiricalVelocityConvergesToBaseCurrent :=
  ⟨M.eachContinuousStepIsNull_holds,
    M.positionMarginalIsBorn_holds,
    M.empiricalVelocityConvergesToBaseCurrent_holds⟩

end PhysicsSM.NullStrand.Master
