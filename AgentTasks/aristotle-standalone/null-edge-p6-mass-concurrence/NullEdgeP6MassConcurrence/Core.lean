import Mathlib.Tactic
import Mathlib.Data.Matrix.Basic

namespace NullEdgeP6MassConcurrence

open Matrix

def rho (a b c d : Real) : Matrix (Fin 2) (Fin 2) Real :=
  !![a^2 + b^2, a * c + b * d;
     a * c + b * d, c^2 + d^2]

def concurrence (a b c d : Real) : Real :=
  2 * |a * d - b * c|

theorem concurrence_sq_eq_four_mul_det (a b c d : Real) :
    concurrence a b c d ^ 2 = 4 * (rho a b c d).det := by
  unfold concurrence rho
  rw [mul_pow, sq_abs]
  simp [Matrix.det_fin_two]
  ring


end NullEdgeP6MassConcurrence
