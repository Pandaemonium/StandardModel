import PhysicsSM.NullStrand.NullFiber.Basic

/-!
# Draft.NullStrandNullFiber

Compatibility re-export for the null-fiber geometry, now housed in the trusted
`PhysicsSM.NullStrand.NullFiber.Basic` module.
-/

noncomputable section

namespace PhysicsSM.Draft.NullStrandNullFiber

abbrev NullFiber := PhysicsSM.NullStrand.NullFiber.NullFiber
abbrev RestSphere := PhysicsSM.NullStrand.NullFiber.RestSphere
abbrev restToNull := PhysicsSM.NullStrand.NullFiber.restToNull
abbrev nullToRest := PhysicsSM.NullStrand.NullFiber.nullToRest
abbrev restToNull_isFutureNull := PhysicsSM.NullStrand.NullFiber.restToNull_isFutureNull
abbrev nullFiber_equiv_restSphere := PhysicsSM.NullStrand.NullFiber.nullFiber_equiv_restSphere
abbrev nullToRest_tangent := PhysicsSM.NullStrand.NullFiber.nullToRest_tangent
abbrev nullFiber_nonempty := PhysicsSM.NullStrand.NullFiber.nullFiber_nonempty

end PhysicsSM.Draft.NullStrandNullFiber
