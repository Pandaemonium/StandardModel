import Mathlib

open Matrix

namespace QuartetPositive

abbrev Quartet := Fin 4 -> ℝ

def B (x y : Quartet) : ℝ :=
  x 0 * y 1 + x 1 * y 0 + x 2 * y 2 - x 3 * y 3

def Q (x : Quartet) : Quartet := ![x 1, 0, 0, 0]

noncomputable def S (x : Quartet) : Quartet := ![0, 0, (4 / 25 : ℝ) * x 2, 0]

def e0 : Quartet := ![1, 0, 0, 0]
def e1 : Quartet := ![0, 1, 0, 0]
def e2 : Quartet := ![0, 0, 1, 0]
def e3 : Quartet := ![0, 0, 0, 1]

theorem Q_sq (x : Quartet) : Q (Q x) = 0 := by
  sorry

theorem B_left_nondegenerate :
    ∀ x : Quartet, (∀ y : Quartet, B x y = 0) -> x = 0 := by
  sorry

theorem exact_pairs_nonclosed :
    B e0 e1 = 1 ∧ Q e1 = e0 ∧ Q e0 = 0 := by
  sorry

/-- The decoder pairing is globally positive semidefinite even though the
underlying Krein form is indefinite. -/
theorem decoder_pairing_formula (x : Quartet) :
    B x (S x) = (4 / 25 : ℝ) * (x 2) ^ 2 := by
  sorry

theorem decoder_pairing_nonneg (x : Quartet) : 0 ≤ B x (S x) := by
  sorry

/-- Every normalized eigenvector of the quartet decoder has nonnegative
eigenvalue; closedness is retained to expose the intended physical sector. -/
theorem normalized_closed_eigen_mass_nonneg (x : Quartet) (mu2 : ℝ)
    (hclosed : Q x = 0) (heig : S x = mu2 • x) (hnorm : B x x = 1) :
    0 ≤ mu2 := by
  sorry

theorem controlled_quartet_fixture :
    Q e1 = e0 ∧ Q e0 = 0 ∧
      B e0 e1 = 1 ∧ B e2 e2 = 1 ∧ B e3 e3 = -1 ∧
      S e2 = (4 / 25 : ℝ) • e2 ∧ B e2 (S e2) = 4 / 25 := by
  sorry

end QuartetPositive
