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

/-! ## Definite forms have no nonzero null vectors -/

/-- Real vectors in a Euclidean coordinate space. -/
abbrev EuclideanVec (n : Nat) := Fin n -> ℝ

/-- The positive-definite coordinate quadratic form. -/
def euclideanQ {n : Nat} (x : EuclideanVec n) : ℝ :=
  ∑ i : Fin n, x i ^ 2

/-- The Euclidean coordinate quadratic form vanishes only on the zero vector.

This is the finite Q10-L1 obstruction: a positive-definite signature cannot
support a nonzero null covector. -/
theorem euclideanQ_eq_zero_iff {n : Nat} (x : EuclideanVec n) :
    euclideanQ x = 0 ↔ x = 0 := by
  constructor
  · intro hx
    funext i
    have hterm : x i ^ 2 = 0 := by
      have h_nonneg : ∀ j ∈ (Finset.univ : Finset (Fin n)), 0 <= x j ^ 2 := by
        intro j _
        exact sq_nonneg (x j)
      exact (Finset.sum_eq_zero_iff_of_nonneg h_nonneg).mp hx i (Finset.mem_univ i)
    exact sq_eq_zero_iff.mp hterm
  · intro hx
    simp [euclideanQ, hx]

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

/-- A fourth split-null vector used for the null-orthogonality rigidity failure. -/
def split22D : Split22
  | ⟨0, _⟩ => 0
  | ⟨1, _⟩ => 1
  | ⟨2, _⟩ => 0
  | ⟨3, _⟩ => 1

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

/-! ## Split-signature null-orthogonality rigidity failure -/

/-- In split signature there are nonzero orthogonal null vectors that are not
forced onto the same ray.  This is the finite counterexample seed for Q10-L4. -/
theorem split22_orthogonal_null_pair :
    split22Q split22A = 0 ∧
      split22Q split22D = 0 ∧
      split22Dot split22A split22D = 0 := by
  norm_num [split22Q, split22Dot, split22A, split22D]

/-- The orthogonal split-null pair is not collinear, even after scalar extension
from integers to rationals. -/
theorem split22_orthogonal_null_pair_not_rat_collinear :
    (¬ ∃ k : ℚ,
      (fun i : Fin 4 => (split22D i : ℚ)) =
        fun i : Fin 4 => k * (split22A i : ℚ)) ∧
    (¬ ∃ k : ℚ,
      (fun i : Fin 4 => (split22A i : ℚ)) =
        fun i : Fin 4 => k * (split22D i : ℚ)) := by
  constructor
  · intro h
    rcases h with ⟨k, hk⟩
    have hcoord := congr_fun hk (1 : Fin 4)
    norm_num [split22A, split22D] at hcoord
  · intro h
    rcases h with ⟨k, hk⟩
    have hcoord := congr_fun hk (0 : Fin 4)
    norm_num [split22A, split22D] at hcoord

/-! ## Split-signature tachyonic rank-one sum witness -/

/-- Real two-component spinors for the split-signature rank-one model. -/
abbrev RSpinor2 := Fin 2 -> ℝ

/-- Real `2 x 2` matrices. -/
abbrev Mat2R := Matrix (Fin 2) (Fin 2) ℝ

/-- The `2 x 2` determinant over the reals. -/
def mat2Det (M : Mat2R) : ℝ :=
  M 0 0 * M 1 1 - M 0 1 * M 1 0

/-- Split-signature soldering as an unconjugated rank-one matrix `psi chi^T`. -/
def splitRankOne (psi chi : RSpinor2) : Mat2R :=
  fun i j => psi i * chi j

/-- First left spinor in the tachyonic witness. -/
def splitPsi1 : RSpinor2
  | ⟨0, _⟩ => 1
  | ⟨1, _⟩ => 0

/-- First right spinor in the tachyonic witness. -/
def splitChi1 : RSpinor2
  | ⟨0, _⟩ => 0
  | ⟨1, _⟩ => 1

/-- Second left spinor in the tachyonic witness. -/
def splitPsi2 : RSpinor2
  | ⟨0, _⟩ => 0
  | ⟨1, _⟩ => 1

/-- Second right spinor in the tachyonic witness. -/
def splitChi2 : RSpinor2
  | ⟨0, _⟩ => 1
  | ⟨1, _⟩ => 0

/-- Each rank-one constituent in the split-signature witness is null. -/
theorem split_tachyonic_witness_constituents_null :
    mat2Det (splitRankOne splitPsi1 splitChi1) = 0 ∧
      mat2Det (splitRankOne splitPsi2 splitChi2) = 0 := by
  norm_num [mat2Det, splitRankOne, splitPsi1, splitChi1, splitPsi2, splitChi2]

/-- The sum of the two null split-signature constituents has negative determinant.

This is the Q10-L5 finite tachyonic witness: in the real-split soldering model,
mass positivity fails because the left and right wedges are independent. -/
theorem split_tachyonic_witness_det_negative :
    mat2Det
      (splitRankOne splitPsi1 splitChi1 + splitRankOne splitPsi2 splitChi2) = -1 := by
  norm_num [mat2Det, splitRankOne, splitPsi1, splitChi1, splitPsi2, splitChi2,
    Matrix.add_apply]

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

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SignatureSelection.split22_orthogonal_null_pair_not_rat_collinear' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms split22_orthogonal_null_pair_not_rat_collinear

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SignatureSelection.euclideanQ_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms euclideanQ_eq_zero_iff

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SignatureSelection.split_tachyonic_witness_constituents_null' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms split_tachyonic_witness_constituents_null

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SignatureSelection.split_tachyonic_witness_det_negative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms split_tachyonic_witness_det_negative

end PhysicsSM.Draft.NullEdge.GateI1.SignatureSelection
