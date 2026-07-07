import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Q11RealStructure

/-!
# Q11 B-L dictionary and RC0 finite check

This module records the finite arithmetic dictionary from the Q11
real-structure audit.  In the occupation convention
`Lambda(C^5) = Lambda(C^3_color + C^2_weak)`, with color occupation `n_c` and
weak occupation `n_w`, it proves

`B-L = 1 + (4 / 5) Y - (2 / 5) F`,

where `F = n_c + n_w` and `Y = -n_c / 3 + n_w / 2`.  The weak-occupation term
cancels identically, leaving `B-L = 1 - (2 / 3)n_c`.

It also ties the Cartan-level RC0 condition to the already landed
`JR_charge_master`: charge conjugation `J_R Q J_R = -Q` is equivalent to
tracelessness of the real diagonal charge.

Claim boundary: this is a finite Cartan/occupation check.  It does not prove the
group-level determinant cocycle, a full KO architecture, or a physical
unimodularity theorem.

Provenance: `AgentTasks/fable_parallel/Q11_answer.md`; Aristotle project
`e2df3555`, task `d9876e5f`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.Q11BLDictionary

open Finset
open PhysicsSM.Draft.NullEdge.GateI1.Q11RealStructure

/-! ## Occupation dictionary -/

/-- The six Standard Model entries in the `Lambda(C^5)` occupation package. -/
inductive SMEntry
  | nuC
  | Q
  | uC
  | eC
  | L
  | dC
  deriving DecidableEq, Fintype

namespace SMEntry

/-- Color occupation number. -/
def nc : SMEntry -> ℚ
  | nuC => 0
  | Q => 1
  | uC => 2
  | eC => 0
  | L => 3
  | dC => 2

/-- Weak occupation number. -/
def nw : SMEntry -> ℚ
  | nuC => 0
  | Q => 1
  | uC => 0
  | eC => 2
  | L => 1
  | dC => 2

/-- Expected Standard Model hypercharge in the `Q_em = T_3 + Y` convention. -/
def expectedY : SMEntry -> ℚ
  | nuC => 0
  | Q => 1 / 6
  | uC => -2 / 3
  | eC => 1
  | L => -1 / 2
  | dC => 1 / 3

/-- Total exterior degree/number operator value on the entry. -/
def expectedF : SMEntry -> ℚ
  | nuC => 0
  | Q => 2
  | uC => 2
  | eC => 2
  | L => 4
  | dC => 4

/-- Expected `B-L` value in the convention `B-L(nuC)=+1`. -/
def expectedBL : SMEntry -> ℚ
  | nuC => 1
  | Q => 1 / 3
  | uC => -1 / 3
  | eC => 1
  | L => -1
  | dC => -1 / 3

end SMEntry

/-- Total exterior degree/number operator. -/
def Fval (nc nw : ℚ) : ℚ :=
  nc + nw

/-- Hypercharge in the `Q_em = T_3 + Y` convention. -/
def Yval (nc nw : ℚ) : ℚ :=
  -nc / 3 + nw / 2

/-- The affine `B-L` value in the occupation convention. -/
def BLval (nc : ℚ) : ℚ :=
  1 - (2 / 3) * nc

/-- Polynomial dictionary identity for all rational occupation pairs. -/
theorem BL_dictionary (nc nw : ℚ) :
    BLval nc = 1 + (4 / 5) * Yval nc nw - (2 / 5) * Fval nc nw := by
  unfold BLval Yval Fval
  ring

/-- The dictionary specializes to each of the six Standard Model entries. -/
theorem BL_dictionary_entries (e : SMEntry) :
    BLval (SMEntry.nc e) =
      1 + (4 / 5) * Yval (SMEntry.nc e) (SMEntry.nw e)
        - (2 / 5) * Fval (SMEntry.nc e) (SMEntry.nw e) := by
  exact BL_dictionary (SMEntry.nc e) (SMEntry.nw e)

/-- The occupation formulas reproduce the expected `(Y,F,B-L)` table. -/
theorem smValues_correct (e : SMEntry) :
    Yval (SMEntry.nc e) (SMEntry.nw e) = SMEntry.expectedY e ∧
      Fval (SMEntry.nc e) (SMEntry.nw e) = SMEntry.expectedF e ∧
      BLval (SMEntry.nc e) = SMEntry.expectedBL e := by
  cases e <;> norm_num [Yval, Fval, BLval, SMEntry.nc, SMEntry.nw,
    SMEntry.expectedY, SMEntry.expectedF, SMEntry.expectedBL]

/-! ## Cartan RC0 and the freed direction -/

/-- Hypercharge as a real diagonal slot charge on `C^5`. -/
noncomputable def Ycharge : Fin 5 -> ℝ :=
  ![-1 / 3, -1 / 3, -1 / 3, 1 / 2, 1 / 2]

/-- Total-number charge on the five slots. -/
noncomputable def Fcharge : Fin 5 -> ℝ :=
  ![1, 1, 1, 1, 1]

/-- Linear part of `B-L` as a five-slot charge. -/
noncomputable def BLlin : Fin 5 -> ℝ :=
  ![-2 / 3, -2 / 3, -2 / 3, 0, 0]

/--
Cartan-level RC0 is exactly tracelessness of the real diagonal charge.  This is
the finite arithmetic reading of `JR_charge_master`.
-/
theorem RC0_iff_traceless (c : Fin 5 -> ℝ) :
    (∀ (f : Form) (T : Finset (Fin 5)),
        JR (chargeOp c (JR f)) T = -chargeOp c f T) ↔ (∑ i, c i) = 0 := by
  constructor
  · intro h
    let f : Form := fun _ => 1
    have hh := h f ∅
    have hm := JR_charge_master c f ∅
    rw [hm] at hh
    simp [chargeOp, f] at hh
    have hcast : ((∑ i, c i : ℝ) : ℂ) = 0 := by
      simpa using hh
    exact Complex.ofReal_eq_zero.mp hcast
  · intro h f T
    rw [JR_charge_master]
    rw [h]
    simp

/-- Hypercharge is traceless, hence RC0-admissible. -/
theorem Y_traceless : (∑ i, Ycharge i) = 0 := by
  simp [Ycharge, Fin.sum_univ_five]
  norm_num

/-- The total-number direction has trace `5`, so RC0 forbids it. -/
theorem F_trace : (∑ i, Fcharge i) = 5 := by
  simp [Fcharge, Fin.sum_univ_five]
  norm_num

/-- The linear part of `B-L` has trace `-2`, so RC0 forbids it. -/
theorem BLlin_trace : (∑ i, BLlin i) = -2 := by
  simp [BLlin, Fin.sum_univ_five]
  norm_num

/-- Pointwise charge identity `B-L_lin = (4 / 5)Y - (2 / 5)F`. -/
theorem BLlin_eq_charge (i : Fin 5) :
    BLlin i = (4 / 5) * Ycharge i - (2 / 5) * Fcharge i := by
  fin_cases i <;> norm_num [BLlin, Ycharge, Fcharge]

/--
Dropping RC0 frees exactly the total-number direction.  The family
`Y + c F` is RC0-admissible iff `c = 0`.
-/
theorem freed_direction (c : ℝ) :
    (∀ (f : Form) (T : Finset (Fin 5)),
        JR (chargeOp (fun i => Ycharge i + c * Fcharge i) (JR f)) T =
          -chargeOp (fun i => Ycharge i + c * Fcharge i) f T) ↔ c = 0 := by
  rw [RC0_iff_traceless]
  rw [Finset.sum_add_distrib, Y_traceless, zero_add, ← Finset.mul_sum, F_trace]
  constructor
  · intro h
    nlinarith
  · intro h
    rw [h]
    ring

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11BLDictionary.BL_dictionary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms BL_dictionary

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11BLDictionary.smValues_correct' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms smValues_correct

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11BLDictionary.RC0_iff_traceless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms RC0_iff_traceless

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Q11BLDictionary.freed_direction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms freed_direction

end PhysicsSM.Draft.NullEdge.GateI1.Q11BLDictionary
