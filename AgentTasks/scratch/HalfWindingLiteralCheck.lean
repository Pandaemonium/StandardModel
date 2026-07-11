import Mathlib
import PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

open Polynomial

namespace PhysicsSM.Draft.NullEdge.HalfWindingLiteralCheck

open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

set_option maxHeartbeats 8000000
set_option maxRecDepth 10000

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

def WwallFin : M8 :=
  !![0, -3 / 5, 0, 0, 4 / 5, 0, 0, 0;
     3 / 5, 0, 0, 0, 0, 4 / 5, 0, 0;
     0, 0, 0, -3 / 5, 0, 0, 4 / 5, 0;
     0, 0, -3 / 5, 0, 0, 0, 0, 4 / 5;
     4 / 5, 0, 0, 0, 0, -3 / 5, 0, 0;
     0, 4 / 5, 0, 0, 3 / 5, 0, 0, 0;
     0, 0, 4 / 5, 0, 0, 0, 0, 3 / 5;
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

def WzeroLit : Matrix V8 V8 ℚ :=
  Matrix.reindexAlgEquiv ℚ ℚ e8 WzeroFin

def WwallLit : Matrix V8 V8 ℚ :=
  Matrix.reindexAlgEquiv ℚ ℚ e8 WwallFin

def WfourLit : Matrix V8 V8 ℚ :=
  Matrix.reindexAlgEquiv ℚ ℚ e8 WfourFin

theorem Wzero_eq_lit : Wzero = WzeroLit := by native_decide
theorem Wwall_eq_lit : Wwall = WwallLit := by native_decide
theorem Wfour_eq_lit : Wfour = WfourLit := by native_decide

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

def liftFin (A : M8) : Matrix V8 V8 ℚ :=
  Matrix.reindexAlgEquiv ℚ ℚ e8 A

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

theorem Wzero_no_neg_mode {v : V8 → ℚ} (hv : Wzero.mulVec v = -v) : v = 0 := by
  have hker : (Wzero + 1).mulVec v = 0 := by
    rw [Matrix.add_mulVec, hv, Matrix.one_mulVec]
    simp
  have h := congrArg (liftFin WzeroAddInvFin).mulVec hker
  rw [Matrix.mulVec_mulVec, Wzero_add_left_inverse, Matrix.one_mulVec,
    Matrix.mulVec_zero] at h
  exact h

theorem Wzero_no_pos_mode {v : V8 → ℚ} (hv : Wzero.mulVec v = v) : v = 0 := by
  have hker : (Wzero - 1).mulVec v = 0 := by
    rw [Matrix.sub_mulVec, hv, Matrix.one_mulVec]
    simp
  have h := congrArg (liftFin WzeroSubInvFin).mulVec hker
  rw [Matrix.mulVec_mulVec, Wzero_sub_left_inverse, Matrix.one_mulVec,
    Matrix.mulVec_zero] at h
  exact h

theorem Wfour_no_neg_mode {v : V8 → ℚ} (hv : Wfour.mulVec v = -v) : v = 0 := by
  have hker : (Wfour + 1).mulVec v = 0 := by
    rw [Matrix.add_mulVec, hv, Matrix.one_mulVec]
    simp
  have h := congrArg (liftFin WfourAddInvFin).mulVec hker
  rw [Matrix.mulVec_mulVec, Wfour_add_left_inverse, Matrix.one_mulVec,
    Matrix.mulVec_zero] at h
  exact h

theorem Wfour_no_pos_mode {v : V8 → ℚ} (hv : Wfour.mulVec v = v) : v = 0 := by
  have hker : (Wfour - 1).mulVec v = 0 := by
    rw [Matrix.sub_mulVec, hv, Matrix.one_mulVec]
    simp
  have h := congrArg (liftFin WfourSubInvFin).mulVec hker
  rw [Matrix.mulVec_mulVec, Wfour_sub_left_inverse, Matrix.one_mulVec,
    Matrix.mulVec_zero] at h
  exact h

end PhysicsSM.Draft.NullEdge.HalfWindingLiteralCheck
