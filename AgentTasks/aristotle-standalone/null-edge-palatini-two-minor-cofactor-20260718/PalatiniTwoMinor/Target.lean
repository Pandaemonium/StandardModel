import Mathlib

noncomputable section

namespace PalatiniTwoMinor

set_option maxHeartbeats 5000000

/-- Four-dimensional alternating symbol with `epsilon 0 1 2 3 = +1`. -/
def spacetimeAlternatingSymbol (a b c d : Fin 4) : Real :=
  (((b : Real) - (a : Real)) * ((c : Real) - (a : Real)) *
      ((d : Real) - (a : Real)) * ((c : Real) - (b : Real)) *
      ((d : Real) - (b : Real)) * ((d : Real) - (c : Real))) / 12

/-- Four-dimensional two-column cofactor identity. Contracting a coframe
two-minor with the spacetime alternating symbol gives the complementary
two-minor of the inverse coframe, multiplied by the determinant. -/
theorem alternating_coframe_two_minor
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1)
    (a b i j : Fin 4) :
    (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        spacetimeAlternatingSymbol c d a b *
          (coframe i c * coframe j d - coframe i d * coframe j c))) =
      coframe.det * Finset.sum Finset.univ (fun k =>
        Finset.sum Finset.univ (fun l =>
          spacetimeAlternatingSymbol i j k l *
            inverseCoframe a k * inverseCoframe b l)) := by
  sorry

end PalatiniTwoMinor
