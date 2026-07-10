import Mathlib

open Matrix Complex
open scoped BigOperators ComplexConjugate

namespace TetrahedralSpinProjectorPath

abbrev Dir := Fin 4
abbrev Spatial := Fin 3 → ℝ
abbrev SpinMat := Matrix (Fin 2) (Fin 2) ℂ

/-- Unnormalized regular-tetrahedron directions. -/
def w : Dir → Spatial :=
  ![![1, 1, 1], ![1, -1, -1], ![-1, 1, -1], ![-1, -1, 1]]

def sigmaX : SpinMat := !![0, 1; 1, 0]
def sigmaY : SpinMat := !![0, -I; I, 0]
def sigmaZ : SpinMat := !![1, 0; 0, -1]

/-- Pauli contraction with the normalized tetrahedral direction `r * w_i`.
The intended exact normalization hypothesis is `3*r^2=1`. -/
def spinDirection (r : ℝ) (i : Dir) : SpinMat :=
  (r : ℂ) •
    ((w i 0 : ℂ) • sigmaX + (w i 1 : ℂ) • sigmaY +
      (w i 2 : ℂ) • sigmaZ)

/-- Rank-one Weyl spin projector in tetrahedral direction `i`. -/
noncomputable def projector (r : ℝ) (i : Dir) : SpinMat :=
  (1 / 2 : ℂ) • (1 + spinDirection r i)

/-- Chronological histories multiply projectors in operator-composition order. -/
noncomputable def pathProjector (r : ℝ) : List Dir → SpinMat
  | [] => 1
  | i :: is => pathProjector r is * projector r i

/-- The exact regular-tetrahedron Gram law before normalization. -/
theorem w_dot (i j : Dir) :
    (∑ a, w i a * w j a) = if i = j then 3 else -1 := by
  sorry

/-- The Pauli contraction is an involution after exact normalization. -/
theorem spinDirection_sq (r : ℝ) (hr : 3 * r ^ 2 = 1) (i : Dir) :
    spinDirection r i * spinDirection r i = 1 := by
  sorry

/-- Each tetrahedral Weyl projector is idempotent. -/
theorem projector_idempotent (r : ℝ) (hr : 3 * r ^ 2 = 1) (i : Dir) :
    projector r i * projector r i = projector r i := by
  sorry

/-- Each tetrahedral Weyl projector is Hermitian. -/
theorem projector_hermitian (r : ℝ) (i : Dir) :
    (projector r i)ᴴ = projector r i := by
  sorry

/-- Each projector has trace one. -/
theorem projector_trace (r : ℝ) (i : Dir) :
    (projector r i).trace = 1 := by
  sorry

/-- The four projectors resolve twice the identity. -/
theorem projector_resolution (r : ℝ) :
    ∑ i : Dir, projector r i = (2 : ℂ) • (1 : SpinMat) := by
  sorry

/-- Distinct tetrahedral projectors have exact overlap `1/3`. -/
theorem projector_pair_trace
    (r : ℝ) (hr : 3 * r ^ 2 = 1) (i j : Dir) (hij : i ≠ j) :
    (projector r i * projector r j).trace = 1 / 3 := by
  sorry

/-- The local bend law: a direction change attenuates a rank-one projector by
exactly one third when sandwiched between equal endpoint directions. -/
theorem projector_bend_sandwich
    (r : ℝ) (hr : 3 * r ^ 2 = 1) (i j : Dir) (hij : i ≠ j) :
    projector r i * projector r j * projector r i =
      (1 / 3 : ℂ) • projector r i := by
  sorry

/-- Concatenating histories composes their ordered projector amplitudes. -/
theorem pathProjector_append (r : ℝ) (xs ys : List Dir) :
    pathProjector r (xs ++ ys) = pathProjector r ys * pathProjector r xs := by
  sorry

/-- A three-direction ordered history carries a nonzero imaginary spin phase. -/
theorem ordered_three_phase
    (r : ℝ) (hr : 3 * r ^ 2 = 1) :
    (projector r 0 * projector r 1 * projector r 2).trace = I * r / 3
      ∧ (projector r 2 * projector r 1 * projector r 0).trace = -I * r / 3 := by
  sorry

/-- Reversing the three-direction order changes the amplitude whenever the
normalization is nonzero. -/
theorem ordered_three_ne_reverse
    (r : ℝ) (hr : 3 * r ^ 2 = 1) (hr0 : r ≠ 0) :
    (projector r 0 * projector r 1 * projector r 2).trace ≠
      (projector r 2 * projector r 1 * projector r 0).trace := by
  sorry

/-- Compact exact ordered-projector verdict for the first 3+1 spin path rung. -/
theorem tetrahedral_spin_projector_path_verdict
    (r : ℝ) (hr : 3 * r ^ 2 = 1) (hr0 : r ≠ 0) :
    (∀ i : Dir, projector r i * projector r i = projector r i)
      ∧ (∑ i : Dir, projector r i = (2 : ℂ) • (1 : SpinMat))
      ∧ (∀ i j : Dir, i ≠ j →
          projector r i * projector r j * projector r i =
            (1 / 3 : ℂ) • projector r i)
      ∧ (projector r 0 * projector r 1 * projector r 2).trace = I * r / 3
      ∧ (projector r 0 * projector r 1 * projector r 2).trace ≠
          (projector r 2 * projector r 1 * projector r 0).trace
      ∧ (∀ xs ys : List Dir,
          pathProjector r (xs ++ ys) =
            pathProjector r ys * pathProjector r xs) := by
  sorry

end TetrahedralSpinProjectorPath
