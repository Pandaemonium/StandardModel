import Mathlib

/-!
# Three-region tensor microcausality fixture

Three supplied qubit tensor factors commute pairwise across distinct regions,
while overlapping Pauli observables on the same factor do not commute. This is
an exact finite three-region extension of `TwoRegionTensorMicrocausality`.

The tensor factorization is supplied. No graph-separation theorem, continuum
Haag-Kastler net, split property, or Lorentzian locality is asserted.

Provenance: completed by Aristotle project
`3f1b0a0c-45d8-4993-bc44-05b1f256c573`, then independently checked and
integrated by Codex under the pinned toolchain.
-/

open Matrix

namespace PhysicsSM.Draft.NullEdge.ThreeRegionTensorMicrocausality

abbrev Qubit := Matrix (Fin 2) (Fin 2) ℂ
abbrev Site3 := (Fin 2 × Fin 2) × Fin 2
abbrev Obs3 := Matrix Site3 Site3 ℂ

def left (A : Qubit) : Obs3 :=
  Matrix.kronecker (Matrix.kronecker A (1 : Qubit)) (1 : Qubit)

def middle (B : Qubit) : Obs3 :=
  Matrix.kronecker (Matrix.kronecker (1 : Qubit) B) (1 : Qubit)

def right (C : Qubit) : Obs3 :=
  Matrix.kronecker (Matrix.kronecker (1 : Qubit) (1 : Qubit)) C

theorem left_middle_commute (A B : Qubit) : Commute (left A) (middle B) := by
  ext ⟨x, y⟩ z;
  simp +decide [ left, middle, Matrix.mul_apply ];
  simp +decide [ Matrix.one_apply, mul_comm ];
  rw [ Finset.sum_eq_single ( ( z.1.1, x.2 ), z.2 ), Finset.sum_eq_single ( ( x.1, z.1.2 ), z.2 ) ] <;> aesop

theorem left_right_commute (A C : Qubit) : Commute (left A) (right C) := by
  ext ⟨x, y⟩ z;
  simp +decide [ left, right, Matrix.mul_apply ];
  simp +decide [ Matrix.one_apply, mul_comm ];
  rw [ Finset.sum_eq_single ( ( z.1, y ) ), Finset.sum_eq_single ( ( x, z.2 ) ) ] <;> aesop

theorem middle_right_commute (B C : Qubit) : Commute (middle B) (right C) := by
  ext ⟨ x, y ⟩ ⟨ u, v ⟩;
  fin_cases x <;> fin_cases u <;> simp +decide [ Matrix.mul_apply ];
  all_goals unfold middle right; simp +decide [ Matrix.one_apply ] ;
  all_goals erw [ Finset.sum_product, Finset.sum_product ] ; simp +decide ;
  all_goals erw [ Finset.sum_product ] ; simp +decide ;
  all_goals erw [ Finset.sum_product ] ; simp +decide [ Fin.sum_univ_succ ] ;
  all_goals ring;

def sigmaX : Qubit := !![0, 1; 1, 0]
def sigmaZ : Qubit := !![1, 0; 0, -1]

theorem overlapping_left_noncommutative :
    ¬ Commute (left sigmaX) (left sigmaZ) := by
  unfold Commute;
  unfold SemiconjBy left; norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] ;
  intro h; have := congr_fun ( congr_fun h ( ( 0, 0 ), 1 ) ) ( ( 1, 0 ), 1 ) ; norm_num [ Matrix.mul_apply, sigmaX, sigmaZ ] at this;
  erw [ Finset.sum_eq_single ( ( 1, 0 ), 1 ), Finset.sum_eq_single ( ( 0, 0 ), 0 ) ] at this <;> simp_all +decide;
  erw [ Finset.sum_eq_single ( ( 0, 0 ), 1 ) ] at this <;> simp_all +decide [ Matrix.one_apply ];
  norm_num at this

theorem three_region_locality_packet :
    Commute (left sigmaX) (middle sigmaZ) ∧
      Commute (left sigmaX) (right sigmaZ) ∧
      Commute (middle sigmaX) (right sigmaZ) ∧
      ¬ Commute (left sigmaX) (left sigmaZ) := by
  exact ⟨left_middle_commute _ _, left_right_commute _ _,
    middle_right_commute _ _, overlapping_left_noncommutative⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ThreeRegionTensorMicrocausality.three_region_locality_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms three_region_locality_packet

end PhysicsSM.Draft.NullEdge.ThreeRegionTensorMicrocausality
