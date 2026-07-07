import Mathlib

/-!
# Gate I1 signature-selection finite obstruction

This draft module records the smallest kernel-checked seed from the Q10
signature-selection memo: in split signature `(+,+,-,-)` there is an explicit
integer triple of null vectors whose pairings form a signed triangle that cannot
be assigned a consistent retarded/advanced two-coloring.

What is proved here is only the finite obstruction.  The stronger Q10 thesis
that stable retardation selects Lorentzian signature still requires the
Lorentzian transitivity theorem and the embedding of this `(2,2)` witness into
the multi-time cases.

Provenance: `AgentTasks/fable_parallel/Q10_answer.md`, section 1a and
formalization ladder L2.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.SignatureSelection

/-! ## Split `(2,2)` integer form -/

/-- Integer vectors in four coordinates. -/
abbrev Split22 := Fin 4 -> Int

/-- The split-signature bilinear form with diagonal `(+,+,-,-)`. -/
def split22Dot (x y : Split22) : Int :=
  x 0 * y 0 + x 1 * y 1 - x 2 * y 2 - x 3 * y 3

/-- The associated quadratic form. -/
def split22Q (x : Split22) : Int :=
  split22Dot x x

/-- First vector in the Q10 frustrated triangle. -/
def split22A : Split22
  | ⟨0, _⟩ => 1
  | ⟨1, _⟩ => 0
  | ⟨2, _⟩ => 1
  | ⟨3, _⟩ => 0

/-- Second vector in the Q10 frustrated triangle. -/
def split22B : Split22
  | ⟨0, _⟩ => 3
  | ⟨1, _⟩ => 4
  | ⟨2, _⟩ => 0
  | ⟨3, _⟩ => 5

/-- Third vector in the Q10 frustrated triangle. -/
def split22C : Split22
  | ⟨0, _⟩ => 0
  | ⟨1, _⟩ => 1
  | ⟨2, _⟩ => 1
  | ⟨3, _⟩ => 0

/-- The three displayed vectors are null for the `(+,+,-,-)` form. -/
theorem split22_frustrated_triple_null :
    split22Q split22A = 0 ∧ split22Q split22B = 0 ∧ split22Q split22C = 0 := by
  norm_num [split22Q, split22Dot, split22A, split22B, split22C]

/-- The signed pairings of the Q10 frustrated triangle. -/
theorem split22_frustrated_triple_pairings :
    split22Dot split22A split22B = 3 ∧
      split22Dot split22B split22C = 4 ∧
      split22Dot split22A split22C = -1 := by
  norm_num [split22Dot, split22A, split22B, split22C]

/-! ## Retarded/advanced coloring obstruction -/

/-- A pair is sign-consistent with a two-coloring when same-color pairings are
nonnegative and opposite-color pairings are nonpositive. -/
def signColorOK (ca cb : Bool) (pairing : Int) : Prop :=
  if ca = cb then 0 <= pairing else pairing <= 0

/-- The three pair constraints for the Q10 frustrated triangle. -/
def frustratedColoringOK (color : Fin 3 -> Bool) : Prop :=
  signColorOK (color 0) (color 1) (split22Dot split22A split22B) ∧
    signColorOK (color 1) (color 2) (split22Dot split22B split22C) ∧
    signColorOK (color 0) (color 2) (split22Dot split22A split22C)

private theorem signColorOK_pos_forces_same {ca cb : Bool} {pairing : Int}
    (hp : 0 < pairing) (h : signColorOK ca cb pairing) : ca = cb := by
  by_contra hne
  have hp_le : pairing <= 0 := by
    simpa [signColorOK, hne] using h
  omega

private theorem signColorOK_neg_forces_ne {ca cb : Bool} {pairing : Int}
    (hp : pairing < 0) (h : signColorOK ca cb pairing) : ca ≠ cb := by
  intro heq
  have h_nonneg : 0 <= pairing := by
    simpa [signColorOK, heq] using h
  omega

/-- The Q10 signed triangle admits no retarded/advanced two-coloring. -/
theorem split22_frustrated_triple_no_coloring (color : Fin 3 -> Bool) :
    ¬ frustratedColoringOK color := by
  intro h
  rcases h with ⟨habOK, hbcOK, hacOK⟩
  have hab : color 0 = color 1 :=
    signColorOK_pos_forces_same
      (pairing := split22Dot split22A split22B)
      (by norm_num [split22Dot, split22A, split22B]) habOK
  have hbc : color 1 = color 2 :=
    signColorOK_pos_forces_same
      (pairing := split22Dot split22B split22C)
      (by norm_num [split22Dot, split22B, split22C]) hbcOK
  have hne_ac : color 0 ≠ color 2 :=
    signColorOK_neg_forces_ne
      (pairing := split22Dot split22A split22C)
      (by norm_num [split22Dot, split22A, split22C]) hacOK
  exact hne_ac (hab.trans hbc)

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SignatureSelection.split22_frustrated_triple_no_coloring' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms split22_frustrated_triple_no_coloring

end PhysicsSM.Draft.NullEdge.GateI1.SignatureSelection
