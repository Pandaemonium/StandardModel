import Mathlib

/-!
# Gate C2: operator (endomorphism)-level overlap index integrality

This Draft module lifts the matrix-level index integrality
(`OverlapIndexIntegrality.overlapIndex_isInteger`) to the level of finite-
dimensional `ℂ`-linear ENDOMORPHISMS, so it applies directly to operators
(e.g. the flagship `sign(Hfree)` / `Gamma5op` on the finite field space) without
first choosing a matrix representation.

For involutions `f, g : Module.End ℂ V` (`f * f = 1`, `g * g = 1`) on a finite-
dimensional complex vector space `V`, the operator overlap index

    overlapIndexEnd f g := (1/2) (trace f - trace g)

is an **integer** (`overlapIndexEnd_isInteger`): it equals the difference of the
ranks of the two `+1` spectral projectors `specProjEnd f = (1 + f)/2` (each an
idempotent endomorphism whose trace is the natural-number `finrank` of its range,
via `LinearMap.IsProj.trace`).  As at the matrix level, this needs only the
involution property, not self-adjointness.  This is the `End`-native form of the
integrality theorem; it is cleaner than the matrix version (no
`Matrix.toLin'` bridge) and is the reusable interface for operator indices.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (finite endomorphism index integrality).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace OverlapIndexEndIntegrality

open LinearMap

variable {V : Type*} [AddCommGroup V] [Module ℂ V] [FiniteDimensional ℂ V]

/-- The `+1` spectral projector of an endomorphism, `(1 + f)/2`. -/
def specProjEnd (f : Module.End ℂ V) : Module.End ℂ V :=
  (2 : ℂ)⁻¹ • (1 + f)

/-- The operator overlap index `(1/2)(trace f - trace g)`. -/
def overlapIndexEnd (f g : Module.End ℂ V) : ℂ :=
  (2 : ℂ)⁻¹ * (LinearMap.trace ℂ V f - LinearMap.trace ℂ V g)

omit [FiniteDimensional ℂ V] in
/-- **The operator index is the trace of the Luscher modified chirality.**  For
a chirality involution `f` (`f * f = 1`) and any `g`, the endomorphism-level
Luscher chirality `Ghat = f (1 - (1/2) Dov)` with `Dov = 1 + f g` has trace equal
to `overlapIndexEnd f g` - so the definition above is the honest `End`-level
counterpart of `OverlapIndexToy.overlapIndex` (a theorem, not a convention). -/
theorem trace_ghatEnd (f g : Module.End ℂ V) (hf : f * f = 1) :
    LinearMap.trace ℂ V (f * (1 - (2 : ℂ)⁻¹ • (1 + f * g)))
      = overlapIndexEnd f g := by
  have hghat : f * (1 - (2 : ℂ)⁻¹ • (1 + f * g))
      = (2 : ℂ)⁻¹ • f - (2 : ℂ)⁻¹ • g := by
    have hexp : f * (1 + f * g) = f + g := by
      rw [mul_add, mul_one, ← mul_assoc, hf, one_mul]
    rw [mul_sub, mul_one, mul_smul_comm, hexp]
    module
  rw [hghat, map_sub, map_smul, map_smul]
  unfold overlapIndexEnd
  simp only [smul_eq_mul]
  ring

omit [FiniteDimensional ℂ V] in
/-- For an involution `f`, the spectral projector `(1 + f)/2` is idempotent. -/
theorem specProjEnd_isIdempotent (f : Module.End ℂ V) (hf : f * f = 1) :
    IsIdempotentElem (specProjEnd f) := by
  show specProjEnd f * specProjEnd f = specProjEnd f
  unfold specProjEnd
  rw [smul_mul_assoc, mul_smul_comm, smul_smul]
  have hexp : (1 + f) * (1 + f) = (2 : ℂ) • (1 + f) := by
    have h : (1 + f) * (1 + f) = 1 + f + f + f * f := by noncomm_ring
    rw [h, hf]; module
  rw [hexp, smul_smul,
    show (2 : ℂ)⁻¹ * (2 : ℂ)⁻¹ * (2 : ℂ) = (2 : ℂ)⁻¹ from by norm_num]

/-- The trace of the spectral projector of an involution is a natural number (the
`finrank` of its range): trace-of-idempotent = rank over the char-0 field `ℂ`. -/
theorem specProjEnd_trace_eq_finrank (f : Module.End ℂ V) (hf : f * f = 1) :
    LinearMap.trace ℂ V (specProjEnd f)
      = (Module.finrank ℂ (LinearMap.range (specProjEnd f)) : ℂ) :=
  (specProjEnd_isIdempotent f hf).isProj_range.trace

omit [FiniteDimensional ℂ V] in
/-- Index as a difference of eigenprojector traces (pure trace linearity: the
`trace 1` contributions cancel). -/
theorem overlapIndexEnd_eq_specProj_sub (f g : Module.End ℂ V) :
    overlapIndexEnd f g
      = LinearMap.trace ℂ V (specProjEnd f) - LinearMap.trace ℂ V (specProjEnd g) := by
  unfold overlapIndexEnd specProjEnd
  rw [map_smul, map_smul, map_add, map_add]
  simp only [smul_eq_mul]
  ring

/-- **Integrality of the operator overlap index.**  For involutions `f, g` on a
finite-dimensional complex space, `overlapIndexEnd f g` is an integer - the
difference of the ranks of the two `+1` spectral projectors. -/
theorem overlapIndexEnd_isInteger (f g : Module.End ℂ V)
    (hf : f * f = 1) (hg : g * g = 1) :
    ∃ k : ℤ, overlapIndexEnd f g = (k : ℂ) := by
  refine ⟨(Module.finrank ℂ (LinearMap.range (specProjEnd f)) : ℤ)
      - (Module.finrank ℂ (LinearMap.range (specProjEnd g)) : ℤ), ?_⟩
  rw [overlapIndexEnd_eq_specProj_sub, specProjEnd_trace_eq_finrank f hf,
    specProjEnd_trace_eq_finrank g hg]
  push_cast
  ring

end OverlapIndexEndIntegrality
end GateC2
end NullEdge
end Draft
end PhysicsSM
