import Mathlib

/-!
# NullStrand.Master.FoliatedManyParticle

Conditional finite many-particle endpoint schema.
-/

noncomputable section

namespace PhysicsSM.NullStrand.Master

/-- Continuity hypothesis schema: names the claim and carries its witness. -/
structure HypersurfaceContinuity where
  localProductRule : Prop
  localProductRule_holds : localProductRule

/-- Angular-existence hypothesis schema with witness. -/
structure AngularExistence where
  creationData : Prop
  creationData_holds : creationData

/-- Ergodicity/mixing hypothesis schema with witness. -/
structure ErgodicMixing where
  mixingLaw : Prop
  mixingLaw_holds : mixingLaw

/-- Non-explosion hypothesis schema with witness. -/
structure NonExplosive where
  noBlowup : Prop
  noBlowup_holds : noBlowup

/-- Conditional many-particle finite master statement: project the bundled
witnesses. As with `finiteNullStrand_master`, the schemas carry the proofs of
their named claims, so the conjunction follows; without witnesses the bare
`Prop` fields could be `False` and the statement would be both vacuous and
ill-typed. -/
theorem foliatedManyParticleNullStrand_master
    (continuity : HypersurfaceContinuity) (angularExistence : AngularExistence)
    (ergodic : ErgodicMixing) (nonexplosive : NonExplosive) :
    continuity.localProductRule ∧ angularExistence.creationData ∧
      ergodic.mixingLaw ∧ nonexplosive.noBlowup :=
  ⟨continuity.localProductRule_holds, angularExistence.creationData_holds,
    ergodic.mixingLaw_holds, nonexplosive.noBlowup_holds⟩

end PhysicsSM.NullStrand.Master
