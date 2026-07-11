import Mathlib
import PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

/-!
# Full-walk controls for the explicit half-winding fixture

This module repairs a semantic gap in `ModeInvariantHalfWinding`: the compressed
zero-wall and four-wall controls there were not themselves statements about the
complete displayed walks.  Here the two full `8 x 8` rational walks are exposed
as literal matrices, and explicit rational left inverses certify that neither
walk has a nonzero eigenvector at `+1` or `-1`.

The inverse entries were generated independently with SymPy 1.14.0 using basis
order `[(x,h) for x in range(4) for h in range(2)]`, then restated below and
checked against the live walk definitions.  The mathematical conclusion is an
exact full-walk no-mode control for these two fixtures.  It is not a theorem
about arbitrary wall counts, perturbations, localization, or a topological
invariant.

Trust: the literal walk equalities and finite inverse products use
`native_decide`, so this draft module has the documented compiler-trusting
footprint `Lean.ofReduceBool` and `Lean.trustCompiler` in addition to the
standard axioms.  The deductions from the inverse certificates are ordinary
kernel-checked matrix algebra.
-/

namespace PhysicsSM.Draft.NullEdge.HalfWindingFullWalkControls

open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

abbrev M8 := Matrix (Fin 8) (Fin 8) ℚ

def e8 : Fin 8 ≃ V8 :=
  (finProdFinEquiv : Fin 4 × Fin 2 ≃ Fin (4 * 2)).symm

def WzeroFin : M8 :=
  !![0, -3 / 5, 0, 0, 4 / 5, 0, 0, 0;
     3 / 5, 0, 0, 0, 0, 4 / 5, 0, 0;
     0, 0, 0, -3 / 5, 0, 0, 4 / 5, 0;
     0, 0, 3 / 5, 0, 0, 0, 0, 4 / 5;
     4 / 5, 0, 0, 0, 0, -3 / 5, 0, 0;
     0, 4 / 5, 0, 0, 3 / 5, 0, 0, 0;
     0, 0, 4 / 5, 0, 0, 0, 0, -3 / 5;
     0, 0, 0, 4 / 5, 0, 0, 3 / 5, 0]

def WfourFin : M8 :=
  !![0, 3 / 5, 0, 0, 4 / 5, 0, 0, 0;
     -3 / 5, 0, 0, 0, 0, 4 / 5, 0, 0;
     0, 0, 0, -3 / 5, 0, 0, 4 / 5, 0;
     0, 0, 3 / 5, 0, 0, 0, 0, 4 / 5;
     4 / 5, 0, 0, 0, 0, 3 / 5, 0, 0;
     0, 4 / 5, 0, 0, -3 / 5, 0, 0, 0;
     0, 0, 4 / 5, 0, 0, 0, 0, -3 / 5;
     0, 0, 0, 4 / 5, 0, 0, 3 / 5, 0]

def liftFin (A : M8) : Matrix V8 V8 ℚ :=
  Matrix.reindexAlgEquiv ℚ ℚ e8 A

def WzeroLit : Matrix V8 V8 ℚ := liftFin WzeroFin
def WfourLit : Matrix V8 V8 ℚ := liftFin WfourFin

theorem Wzero_eq_lit : Wzero = WzeroLit := by native_decide
theorem Wfour_eq_lit : Wfour = WfourLit := by native_decide

/-- The advertised zero-wall compression is an honest invariant block of the
complete zero-wall walk. -/
theorem Wzero_Bfix : Wzero * Bfix = Bfix * Afix0 := by native_decide

/-- The advertised four-wall compression is an honest invariant block of the
complete four-wall walk. -/
theorem Wfour_Bfix : Wfour * Bfix = Bfix * Afix4 := by native_decide

def WzeroAddInvFin : M8 :=
  !![1 / 2, 5 / 6, 0, 0, 0, -2 / 3, 0, 0;
     -5 / 6, 1 / 2, 0, 0, 2 / 3, 0, 0, 0;
     0, 0, 1 / 2, 5 / 6, 0, 0, 0, -2 / 3;
     0, 0, -5 / 6, 1 / 2, 0, 0, 2 / 3, 0;
     0, -2 / 3, 0, 0, 1 / 2, 5 / 6, 0, 0;
     2 / 3, 0, 0, 0, -5 / 6, 1 / 2, 0, 0;
     0, 0, 0, -2 / 3, 0, 0, 1 / 2, 5 / 6;
     0, 0, 2 / 3, 0, 0, 0, -5 / 6, 1 / 2]

def WzeroSubInvFin : M8 :=
  !![-1 / 2, 5 / 6, 0, 0, 0, 2 / 3, 0, 0;
     -5 / 6, -1 / 2, 0, 0, -2 / 3, 0, 0, 0;
     0, 0, -1 / 2, 5 / 6, 0, 0, 0, 2 / 3;
     0, 0, -5 / 6, -1 / 2, 0, 0, -2 / 3, 0;
     0, 2 / 3, 0, 0, -1 / 2, 5 / 6, 0, 0;
     -2 / 3, 0, 0, 0, -5 / 6, -1 / 2, 0, 0;
     0, 0, 0, 2 / 3, 0, 0, -1 / 2, 5 / 6;
     0, 0, -2 / 3, 0, 0, 0, -5 / 6, -1 / 2]

def WfourAddInvFin : M8 :=
  !![1 / 2, -5 / 6, 0, 0, 0, 2 / 3, 0, 0;
     5 / 6, 1 / 2, 0, 0, -2 / 3, 0, 0, 0;
     0, 0, 1 / 2, 5 / 6, 0, 0, 0, -2 / 3;
     0, 0, -5 / 6, 1 / 2, 0, 0, 2 / 3, 0;
     0, 2 / 3, 0, 0, 1 / 2, -5 / 6, 0, 0;
     -2 / 3, 0, 0, 0, 5 / 6, 1 / 2, 0, 0;
     0, 0, 0, -2 / 3, 0, 0, 1 / 2, 5 / 6;
     0, 0, 2 / 3, 0, 0, 0, -5 / 6, 1 / 2]

def WfourSubInvFin : M8 :=
  !![-1 / 2, -5 / 6, 0, 0, 0, -2 / 3, 0, 0;
     5 / 6, -1 / 2, 0, 0, 2 / 3, 0, 0, 0;
     0, 0, -1 / 2, 5 / 6, 0, 0, 0, 2 / 3;
     0, 0, -5 / 6, -1 / 2, 0, 0, -2 / 3, 0;
     0, -2 / 3, 0, 0, -1 / 2, -5 / 6, 0, 0;
     2 / 3, 0, 0, 0, 5 / 6, -1 / 2, 0, 0;
     0, 0, 0, 2 / 3, 0, 0, -1 / 2, 5 / 6;
     0, 0, -2 / 3, 0, 0, 0, -5 / 6, -1 / 2]

theorem Wzero_add_left_inverse :
    liftFin WzeroAddInvFin * (Wzero + 1) = 1 := by
  rw [Wzero_eq_lit]
  native_decide

theorem Wzero_sub_left_inverse :
    liftFin WzeroSubInvFin * (Wzero - 1) = 1 := by
  rw [Wzero_eq_lit]
  native_decide

theorem Wfour_add_left_inverse :
    liftFin WfourAddInvFin * (Wfour + 1) = 1 := by
  rw [Wfour_eq_lit]
  native_decide

theorem Wfour_sub_left_inverse :
    liftFin WfourSubInvFin * (Wfour - 1) = 1 := by
  rw [Wfour_eq_lit]
  native_decide

theorem toC_add_one (A : Matrix V8 V8 ℚ) :
    toC (A + 1) = toC A + 1 := by
  ext i j
  by_cases h : i = j <;>
    simp [toC, Matrix.map_apply, h]

theorem toC_sub_one (A : Matrix V8 V8 ℚ) :
    toC (A - 1) = toC A - 1 := by
  ext i j
  by_cases h : i = j <;>
    simp [toC, Matrix.map_apply, h]

theorem toC_Wzero_add_left_inverse :
    toC (liftFin WzeroAddInvFin) * (toC Wzero + 1) = 1 := by
  rw [← toC_add_one, ← toC_mul, Wzero_add_left_inverse, toC_one]

theorem toC_Wzero_sub_left_inverse :
    toC (liftFin WzeroSubInvFin) * (toC Wzero - 1) = 1 := by
  rw [← toC_sub_one, ← toC_mul, Wzero_sub_left_inverse, toC_one]

theorem toC_Wfour_add_left_inverse :
    toC (liftFin WfourAddInvFin) * (toC Wfour + 1) = 1 := by
  rw [← toC_add_one, ← toC_mul, Wfour_add_left_inverse, toC_one]

theorem toC_Wfour_sub_left_inverse :
    toC (liftFin WfourSubInvFin) * (toC Wfour - 1) = 1 := by
  rw [← toC_sub_one, ← toC_mul, Wfour_sub_left_inverse, toC_one]

/-- The complete zero-wall fixture has no nonzero `-1` eigenvector. -/
theorem Wzero_no_neg_mode {v : V8 → ℚ} (hv : Wzero.mulVec v = -v) : v = 0 := by
  have hker : (Wzero + 1).mulVec v = 0 := by
    rw [Matrix.add_mulVec, hv, Matrix.one_mulVec]
    simp
  have h := congrArg (liftFin WzeroAddInvFin).mulVec hker
  rw [Matrix.mulVec_mulVec, Wzero_add_left_inverse, Matrix.one_mulVec,
    Matrix.mulVec_zero] at h
  exact h

/-- The complete zero-wall fixture has no nonzero `+1` eigenvector. -/
theorem Wzero_no_pos_mode {v : V8 → ℚ} (hv : Wzero.mulVec v = v) : v = 0 := by
  have hker : (Wzero - 1).mulVec v = 0 := by
    rw [Matrix.sub_mulVec, hv, Matrix.one_mulVec]
    simp
  have h := congrArg (liftFin WzeroSubInvFin).mulVec hker
  rw [Matrix.mulVec_mulVec, Wzero_sub_left_inverse, Matrix.one_mulVec,
    Matrix.mulVec_zero] at h
  exact h

/-- The complete four-wall fixture has no nonzero `-1` eigenvector. -/
theorem Wfour_no_neg_mode {v : V8 → ℚ} (hv : Wfour.mulVec v = -v) : v = 0 := by
  have hker : (Wfour + 1).mulVec v = 0 := by
    rw [Matrix.add_mulVec, hv, Matrix.one_mulVec]
    simp
  have h := congrArg (liftFin WfourAddInvFin).mulVec hker
  rw [Matrix.mulVec_mulVec, Wfour_add_left_inverse, Matrix.one_mulVec,
    Matrix.mulVec_zero] at h
  exact h

/-- The complete four-wall fixture has no nonzero `+1` eigenvector. -/
theorem Wfour_no_pos_mode {v : V8 → ℚ} (hv : Wfour.mulVec v = v) : v = 0 := by
  have hker : (Wfour - 1).mulVec v = 0 := by
    rw [Matrix.sub_mulVec, hv, Matrix.one_mulVec]
    simp
  have h := congrArg (liftFin WfourSubInvFin).mulVec hker
  rw [Matrix.mulVec_mulVec, Wfour_sub_left_inverse, Matrix.one_mulVec,
    Matrix.mulVec_zero] at h
  exact h

/-- The complexified complete zero-wall fixture has no nonzero `-1` mode. -/
theorem toC_Wzero_no_neg_mode {v : V8 → ℂ} (hv : (toC Wzero).mulVec v = -v) :
    v = 0 := by
  have hker : (toC Wzero + 1).mulVec v = 0 := by
    rw [Matrix.add_mulVec, hv, Matrix.one_mulVec]
    simp
  have h := congrArg (toC (liftFin WzeroAddInvFin)).mulVec hker
  rw [Matrix.mulVec_mulVec, toC_Wzero_add_left_inverse, Matrix.one_mulVec,
    Matrix.mulVec_zero] at h
  exact h

/-- The complexified complete zero-wall fixture has no nonzero `+1` mode. -/
theorem toC_Wzero_no_pos_mode {v : V8 → ℂ} (hv : (toC Wzero).mulVec v = v) :
    v = 0 := by
  have hker : (toC Wzero - 1).mulVec v = 0 := by
    rw [Matrix.sub_mulVec, hv, Matrix.one_mulVec]
    simp
  have h := congrArg (toC (liftFin WzeroSubInvFin)).mulVec hker
  rw [Matrix.mulVec_mulVec, toC_Wzero_sub_left_inverse, Matrix.one_mulVec,
    Matrix.mulVec_zero] at h
  exact h

/-- The complexified complete four-wall fixture has no nonzero `-1` mode. -/
theorem toC_Wfour_no_neg_mode {v : V8 → ℂ} (hv : (toC Wfour).mulVec v = -v) :
    v = 0 := by
  have hker : (toC Wfour + 1).mulVec v = 0 := by
    rw [Matrix.add_mulVec, hv, Matrix.one_mulVec]
    simp
  have h := congrArg (toC (liftFin WfourAddInvFin)).mulVec hker
  rw [Matrix.mulVec_mulVec, toC_Wfour_add_left_inverse, Matrix.one_mulVec,
    Matrix.mulVec_zero] at h
  exact h

/-- The complexified complete four-wall fixture has no nonzero `+1` mode. -/
theorem toC_Wfour_no_pos_mode {v : V8 → ℂ} (hv : (toC Wfour).mulVec v = v) :
    v = 0 := by
  have hker : (toC Wfour - 1).mulVec v = 0 := by
    rw [Matrix.sub_mulVec, hv, Matrix.one_mulVec]
    simp
  have h := congrArg (toC (liftFin WfourSubInvFin)).mulVec hker
  rw [Matrix.mulVec_mulVec, toC_Wfour_sub_left_inverse, Matrix.one_mulVec,
    Matrix.mulVec_zero] at h
  exact h

end PhysicsSM.Draft.NullEdge.HalfWindingFullWalkControls
