import Mathlib.Tactic

/-!
# P7 Bloch contraction decreases purity

For a normalized qubit with Bloch radius `r`, purity is `(1+r^2)/2`. A unital
Bloch contraction cannot increase purity, and a genuine contraction of a
nonzero radius strictly decreases it.
-/

noncomputable section

namespace NullEdgeP7BlochContractionPurity

def purityFromBlochRadius (r : Real) : Real :=
  (1 + r ^ 2) / 2

theorem blochContraction_purity_antitone
    (a r : Real) (ha0 : 0 <= a) (ha1 : a <= 1) :
    purityFromBlochRadius (a * r) <= purityFromBlochRadius r := by
  sorry

theorem blochContraction_purity_strict
    (a r : Real) (ha0 : 0 <= a) (ha1 : a < 1) (hr : r ≠ 0) :
    purityFromBlochRadius (a * r) < purityFromBlochRadius r := by
  sorry

end NullEdgeP7BlochContractionPurity
