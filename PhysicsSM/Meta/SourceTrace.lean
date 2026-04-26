/-!
# Meta.SourceTrace

Provenance metadata support for PhysicsSM declarations.

Provides structures for recording source references, license origin, convention
choices, and oracle backends associated with definitions and theorems.

Status: stub — metadata structures to be defined.
-/

namespace PhysicsSM.Meta.SourceTrace

/-- Source reference kinds used in provenance metadata. -/
inductive SourceKind
  | paper      -- journal or preprint
  | book       -- textbook or monograph
  | repo       -- external code repository
  | oracle     -- CAS or computational backend output
  | cleanroom  -- clean-room formalization from mathematical definitions

end PhysicsSM.Meta.SourceTrace
