import HurwitzToolkit.Stage2

namespace HurwitzToolkit

variable {A : Type*} [NonAssocRing A] [Module Real A]
  [SMulCommClass Real A A] [IsScalarTower Real A A] [Nontrivial A]

/-- Corrected signed degree-four associator candidate exposed by the
octonion counterexample to the unsigned predecessor. -/
lemma associator_mul_right_signed
    (Q : QuadraticForm Real A) (hQ : IsCompositionForm Q)
    (x y z : A) :
    ((x * y) * z) * y - (x * y) * (z * y) =
      -((x * (y * z)) * y - x * ((y * z) * y)) := by
  sorry

/-- Right Moufang, proved from the clean composition-form toolkit without
using the false unsigned predecessor. -/
lemma mul_right_moufang_clean
    (Q : QuadraticForm Real A) (hQ : IsCompositionForm Q)
    (u v w : A) : (u * v) * (w * v) = (u * (v * w)) * v := by
  sorry

end HurwitzToolkit
