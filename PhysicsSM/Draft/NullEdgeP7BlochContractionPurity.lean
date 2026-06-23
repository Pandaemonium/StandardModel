import Mathlib.Tactic

/-!
# P7 Bloch contraction decreases purity

For a normalized qubit with Bloch radius `r`, purity is `(1+r^2)/2`. A unital
Bloch contraction cannot increase purity, and a genuine contraction of a
nonzero radius strictly decreases it.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP7BlochContractionPurity

def purityFromBlochRadius (r : Real) : Real :=
  (1 + r ^ 2) / 2

theorem blochContraction_purity_antitone
    (a r : Real) (ha0 : 0 <= a) (ha1 : a <= 1) :
    purityFromBlochRadius (a * r) <= purityFromBlochRadius r := by
  exact div_le_div_of_nonneg_right ( by nlinarith [ mul_nonneg ha0 ( sq_nonneg r ), mul_le_mul_of_nonneg_right ha1 ( sq_nonneg r ) ] ) zero_le_two

theorem blochContraction_purity_strict
    (a r : Real) (ha0 : 0 <= a) (ha1 : a < 1) (hr : r ≠ 0) :
    purityFromBlochRadius (a * r) < purityFromBlochRadius r := by
  unfold purityFromBlochRadius
  nlinarith [mul_lt_mul_of_pos_right ha1 (mul_self_pos.2 hr)]

end PhysicsSM.Draft.NullEdgeP7BlochContractionPurity
