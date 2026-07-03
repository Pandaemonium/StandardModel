import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexEndIntegrality

/-!
# Gate C2: the overlap index counts `+1` eigenspace dimensions

This Draft module gives the physics-transparent form of the operator overlap
index.  The `+1` spectral projector `specProjEnd f = (1 + f)/2` of an involution
`f` projects onto the `+1` eigenspace `ker (f - 1)`
(`specProjEnd_range_eq_eigenspace`), so the integrality result becomes

    overlapIndexEnd f g = dim(+1 eigenspace of f) - dim(+1 eigenspace of g)

(`overlapIndexEnd_eq_eigenspace_dim_sub`).  For a chirality `f = gamma5` and a
sign `g = eps`, this is the signed count of chiral zero-eigenvalue-sign states -
the honest statement of what the finite overlap index counts.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (index = eigenspace-dimension difference).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace OverlapIndexEigenspace

open LinearMap
open PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexEndIntegrality

variable {V : Type*} [AddCommGroup V] [Module ℂ V] [FiniteDimensional ℂ V]

omit [FiniteDimensional ℂ V] in
/-- The range of the `+1` spectral projector of an involution is its `+1`
eigenspace: `range ((1 + f)/2) = ker (f - 1)`. -/
theorem specProjEnd_range_eq_eigenspace (f : Module.End ℂ V) (hf : f * f = 1) :
    LinearMap.range (specProjEnd f) = LinearMap.ker (f - 1) := by
  ext v
  rw [(specProjEnd_isIdempotent f hf).mem_range_iff, LinearMap.mem_ker,
    LinearMap.sub_apply, Module.End.one_apply, sub_eq_zero]
  unfold specProjEnd
  simp only [LinearMap.smul_apply, LinearMap.add_apply, Module.End.one_apply]
  rw [inv_smul_eq_iff₀ (two_ne_zero), two_smul]
  exact add_right_inj v

/-- **The operator overlap index is the difference of `+1` eigenspace
dimensions.**  For involutions `f, g`,
`overlapIndexEnd f g = dim(ker(f-1)) - dim(ker(g-1))` - the signed count of the
`+1` eigenspaces of the chirality and the sign. -/
theorem overlapIndexEnd_eq_eigenspace_dim_sub (f g : Module.End ℂ V)
    (hf : f * f = 1) (hg : g * g = 1) :
    overlapIndexEnd f g
      = (Module.finrank ℂ (LinearMap.ker (f - 1)) : ℂ)
        - (Module.finrank ℂ (LinearMap.ker (g - 1)) : ℂ) := by
  rw [overlapIndexEnd_eq_specProj_sub, specProjEnd_trace_eq_finrank f hf,
    specProjEnd_trace_eq_finrank g hg, specProjEnd_range_eq_eigenspace f hf,
    specProjEnd_range_eq_eigenspace g hg]

end OverlapIndexEigenspace
end GateC2
end NullEdge
end Draft
end PhysicsSM
