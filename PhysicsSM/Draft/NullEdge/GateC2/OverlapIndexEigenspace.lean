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

omit [FiniteDimensional ℂ V] in
/-- The kernel of the `+1` spectral-projector expression is its `-1`
eigenspace: `ker ((1 + f)/2) = ker (f + 1)`. -/
theorem specProjEnd_ker_eq_eigenspace (f : Module.End ℂ V) :
    LinearMap.ker (specProjEnd f) = LinearMap.ker (f + 1) := by
  ext v
  rw [LinearMap.mem_ker, LinearMap.mem_ker, LinearMap.add_apply, Module.End.one_apply]
  unfold specProjEnd
  simp only [LinearMap.smul_apply, LinearMap.add_apply, Module.End.one_apply,
    smul_eq_zero, inv_eq_zero, OfNat.ofNat_ne_zero, false_or]
  rw [add_comm]

/-- **The `+1` and `-1` eigenspaces of an involution partition the dimension**:
`dim(ker(f-1)) + dim(ker(f+1)) = dim V`.  (The involution `f` is diagonalizable
with eigenvalues `+1` and `-1`.) -/
theorem involution_eigenspace_finrank_add (f : Module.End ℂ V) (hf : f * f = 1) :
    Module.finrank ℂ (LinearMap.ker (f - 1))
        + Module.finrank ℂ (LinearMap.ker (f + 1)) = Module.finrank ℂ V := by
  have hcompl := (specProjEnd_isIdempotent f hf).isCompl
  rw [specProjEnd_range_eq_eigenspace f hf, specProjEnd_ker_eq_eigenspace f] at hcompl
  exact Submodule.finrank_add_eq_of_isCompl hcompl

/-- **The trace of an involution is its signature.**  For `f * f = 1`,
`trace f = dim(ker(f-1)) - dim(ker(f+1)) = n_+ - n_-`.  So the operator index
`overlapIndexEnd f g = (1/2)(sig f - sig g)`, the rigorous form of the controlling
fact "`overlapIndex = -(1/2) sig(eps)`". -/
theorem trace_involution_eq_signature (f : Module.End ℂ V) (hf : f * f = 1) :
    LinearMap.trace ℂ V f
      = (Module.finrank ℂ (LinearMap.ker (f - 1)) : ℂ)
        - (Module.finrank ℂ (LinearMap.ker (f + 1)) : ℂ) := by
  have hfeq : f = (2 : ℂ) • specProjEnd f - 1 := by
    unfold specProjEnd
    rw [smul_smul, show (2 : ℂ) * (2 : ℂ)⁻¹ = 1 from by norm_num, one_smul]
    abel
  have htr : LinearMap.trace ℂ V f
      = (2 : ℂ) * (Module.finrank ℂ (LinearMap.ker (f - 1)) : ℂ)
        - (Module.finrank ℂ V : ℂ) := by
    conv_lhs => rw [hfeq]
    rw [map_sub, map_smul, LinearMap.trace_one, specProjEnd_trace_eq_finrank f hf,
      specProjEnd_range_eq_eigenspace f hf, smul_eq_mul]
  rw [htr, ← involution_eigenspace_finrank_add f hf]
  push_cast
  ring

/-- **The operator index in signature form** (the controlling fact, rigorized):
`overlapIndexEnd f g = (1/2)(sig f - sig g)` where `sig h = dim(ker(h-1)) -
dim(ker(h+1))`.  For a balanced chirality `f` (`sig f = 0`) this is `-(1/2)
sig(g)` - minus half the signature of the sign, exactly as the design brief's
controlling fact states. -/
theorem overlapIndexEnd_eq_half_signature_sub (f g : Module.End ℂ V)
    (hf : f * f = 1) (hg : g * g = 1) :
    overlapIndexEnd f g
      = (2 : ℂ)⁻¹ *
          (((Module.finrank ℂ (LinearMap.ker (f - 1)) : ℂ)
              - (Module.finrank ℂ (LinearMap.ker (f + 1)) : ℂ))
            - ((Module.finrank ℂ (LinearMap.ker (g - 1)) : ℂ)
              - (Module.finrank ℂ (LinearMap.ker (g + 1)) : ℂ))) := by
  unfold overlapIndexEnd
  rw [trace_involution_eq_signature f hf, trace_involution_eq_signature g hg]

end OverlapIndexEigenspace
end GateC2
end NullEdge
end Draft
end PhysicsSM
