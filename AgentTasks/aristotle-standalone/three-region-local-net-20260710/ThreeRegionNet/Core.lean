import Mathlib

open Matrix

namespace ThreeRegionNet

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
  sorry

theorem left_right_commute (A C : Qubit) : Commute (left A) (right C) := by
  sorry

theorem middle_right_commute (B C : Qubit) : Commute (middle B) (right C) := by
  sorry

def sigmaX : Qubit := !![0, 1; 1, 0]
def sigmaZ : Qubit := !![1, 0; 0, -1]

theorem overlapping_left_noncommutative :
    ¬ Commute (left sigmaX) (left sigmaZ) := by
  sorry

theorem three_region_locality_packet :
    Commute (left sigmaX) (middle sigmaZ) ∧
      Commute (left sigmaX) (right sigmaZ) ∧
      Commute (middle sigmaX) (right sigmaZ) ∧
      ¬ Commute (left sigmaX) (left sigmaZ) := by
  sorry

end ThreeRegionNet
