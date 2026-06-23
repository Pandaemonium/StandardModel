import Mathlib.Tactic

/-!
# P7 strict Bloch contraction mixedness target

The non-strict theorem says a Bloch-radius contraction cannot decrease
observer-channel mixedness. This strict form says a genuine contraction of a
nonzero Bloch radius strictly increases the normalized mass-ratio-square
functional.
-/

namespace NullEdgeP7BlochContractionStrict

def massRatioSqFromBlochRadius (r : Real) : Real :=
  1 - r ^ 2

theorem blochContraction_massRatioSq_strict
    (a r : Real) (ha0 : 0 <= a) (ha1 : a < 1) (hr : r ≠ 0) :
    massRatioSqFromBlochRadius r < massRatioSqFromBlochRadius (a * r) := by
  sorry

end NullEdgeP7BlochContractionStrict
