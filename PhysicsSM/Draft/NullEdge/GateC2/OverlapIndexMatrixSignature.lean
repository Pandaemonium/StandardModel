import Mathlib
import PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexEigenspace

/-!
# Gate C2: the controlling fact at the concrete matrix level

The endomorphism-level `trace_involution_eq_signature` (`OverlapIndexEigenspace`)
is transported to the concrete `Matrix` level via the `Matrix.toLin'` bridge, so
the "index = signature" controlling fact applies directly to the explicit matrix
witnesses (the winding witness, the diagonal `HU`, the non-diagonal `HU2`) and to
any explicit gauge Wilson matrix.

* `matrixTraceSignature M := dim(ker(toLin' M - 1)) - dim(ker(toLin' M + 1))` -
  the signature `n_+ - n_-` of a matrix involution.
* `matrix_trace_eq_signature`: `M.trace = matrixTraceSignature M` for `M * M = 1`.
* `overlapIndex_eq_half_signature`: `overlapIndex gamma5 eps =
  (1/2)(sig gamma5 - sig eps)` - the design brief's controlling fact, kernel-
  checked at the matrix level.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (matrix index = signature).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace OverlapIndexMatrixSignature

open PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
open PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexEigenspace

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- The signature `n_+ - n_-` of a matrix, as the eigenspace-dimension difference
of its associated linear map. -/
def matrixTraceSignature (M : Matrix n n ℂ) : ℂ :=
  (Module.finrank ℂ (LinearMap.ker (Matrix.toLin' M - 1)) : ℂ)
    - (Module.finrank ℂ (LinearMap.ker (Matrix.toLin' M + 1)) : ℂ)

/-- The linear map of a matrix involution is an involution. -/
theorem toLin'_involution (eps : Matrix n n ℂ) (heps : eps * eps = 1) :
    Matrix.toLin' eps * Matrix.toLin' eps = 1 := by
  rw [Module.End.mul_eq_comp, ← Matrix.toLin'_mul, heps, Matrix.toLin'_one]
  ext v i
  rfl

/-- **The trace of a matrix involution is its signature.**
`M.trace = dim(ker(toLin' M - 1)) - dim(ker(toLin' M + 1)) = n_+ - n_-`. -/
theorem matrix_trace_eq_signature (eps : Matrix n n ℂ) (heps : eps * eps = 1) :
    eps.trace = matrixTraceSignature eps := by
  rw [matrixTraceSignature, ← Matrix.trace_toLin'_eq eps,
    trace_involution_eq_signature (Matrix.toLin' eps) (toLin'_involution eps heps)]

/-- **The overlap index in signature form (matrix level).**
`overlapIndex gamma5 eps = (1/2)(sig gamma5 - sig eps)`.  This is the design
brief's controlling fact `overlapIndex = -(1/2) sig(eps)` (for balanced `gamma5`),
kernel-checked at the concrete matrix level and applicable to every explicit
witness and gauge operator. -/
theorem overlapIndex_eq_half_signature (gamma5 eps : Matrix n n ℂ)
    (hg5 : gamma5 * gamma5 = 1) (heps : eps * eps = 1) :
    overlapIndex gamma5 eps
      = (2 : ℂ)⁻¹ * (matrixTraceSignature gamma5 - matrixTraceSignature eps) := by
  rw [overlapIndex_eq gamma5 eps hg5, matrix_trace_eq_signature gamma5 hg5,
    matrix_trace_eq_signature eps heps]
  norm_num

end OverlapIndexMatrixSignature
end GateC2
end NullEdge
end Draft
end PhysicsSM
