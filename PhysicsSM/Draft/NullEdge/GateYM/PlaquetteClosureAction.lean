/-
# The Wilson plaquette action is a squared closure defect

DRAFT (kernel-clean; no `s o r r y`). Module 1 of the QCD-roadmap
amendment-A sequence
(`Sources/Null_Edge_QCD_Mass_Roadmap_2026-07-07.md`, sec 3a):
BEFORE identifying the carrier's nonabelian `Q_C`, prove that the
STANDARD lattice gauge action is itself a squared closure defect.

For any unitary `U` (in application: the holonomy `H_f` of a face),

  `Tr((1 - U)^dag (1 - U)) = 2 N - (Tr U + conj (Tr U)) = 2N - 2 Re Tr U`,

so the Wilson plaquette weight `N - Re Tr U` is EXACTLY half the
Hilbert-Schmidt norm-square of the closure defect `1 - U`, and the full
Wilson action is `S_W = (beta / 2N) * sum_f |1 - H_f|_HS^2`. The thesis
sentence this underwrites: QCD mass is the transfer-matrix energy cost of
non-closing color-null transport - the gauge action penalizes exactly the
failure of parallel transport to close around faces.

## Claim boundary

Finite matrix-trace algebra for a single unitary; no ensemble, no
positivity-of-measure claim, no continuum statement. The face-holonomy
product structure and the sum over faces are downstream modules
(`ClosureTensionDerivative` per the roadmap sequence).

## Provenance

Wilson (1974) `[import]` for the action; the closure-defect rewriting is
elementary and standard; adopted into the program via the 2026-07-07
external-review memo (roadmap amendment A0), identities hand-verified
before formalization - [comp].
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.GateYM.PlaquetteClosureAction

open Matrix

open scoped ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **Closure-defect trace identity.** For a unitary matrix `U`
(`Uᴴ * U = 1`), the Hilbert-Schmidt square of the closure defect `1 - U`
is `2 N - (Tr U + Tr Uᴴ)`. -/
theorem closure_defect_trace_eq (U : Matrix n n ℂ) (hU : Uᴴ * U = 1) :
    ((1 - U)ᴴ * (1 - U)).trace
      = 2 * (Fintype.card n : ℂ) - (U.trace + Uᴴ.trace) := by
  have expand : (1 - U)ᴴ * (1 - U) = 1 - U - Uᴴ + Uᴴ * U := by
    rw [conjTranspose_sub, conjTranspose_one]
    noncomm_ring
  rw [expand, hU, trace_add, trace_sub, trace_sub, trace_one]
  ring

/-- Real form: `|1 - U|_HS^2 = 2 N - 2 Re Tr U` for unitary `U`. -/
theorem closure_defect_trace_re (U : Matrix n n ℂ) (hU : Uᴴ * U = 1) :
    (((1 - U)ᴴ * (1 - U)).trace).re
      = 2 * (Fintype.card n : ℝ) - 2 * (U.trace).re := by
  rw [closure_defect_trace_eq U hU, trace_conjTranspose]
  simp
  ring

/-- **The Wilson plaquette weight is half the squared closure defect**:
`N - Re Tr U = (1/2) |1 - U|_HS^2`. Summed over faces with holonomies
`H_f`, this is exactly `S_W = (beta / 2N) sum_f |1 - H_f|_HS^2`. -/
theorem wilson_plaquette_eq_half_closure_defect
    (U : Matrix n n ℂ) (hU : Uᴴ * U = 1) :
    (Fintype.card n : ℝ) - (U.trace).re
      = (1 / 2) * (((1 - U)ᴴ * (1 - U)).trace).re := by
  rw [closure_defect_trace_re U hU]
  ring

/-- The closure defect vanishes iff the holonomy is trivial: the
plaquette weight is zero exactly on closing (flat) transport. (Stated
for ANY matrix - unitarity is not needed for the vanishing criterion;
the unitary holonomy is the application.) -/
theorem closure_defect_trace_eq_zero_iff (U : Matrix n n ℂ) :
    ((1 - U)ᴴ * (1 - U)).trace = 0 ↔ U = 1 := by
  constructor
  · intro h
    have hposdef := Matrix.posSemidef_conjTranspose_mul_self (1 - U)
    have hzero : (1 - U)ᴴ * (1 - U) = 0 :=
      hposdef.trace_eq_zero_iff.mp h
    have hdefect : (1 : Matrix n n ℂ) - U = 0 :=
      conjTranspose_mul_self_eq_zero.mp hzero
    have := sub_eq_zero.mp hdefect
    exact this.symm
  · intro h
    simp [h]

end PhysicsSM.Draft.NullEdge.GateYM.PlaquetteClosureAction
