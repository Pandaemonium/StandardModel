import PhysicsSM.Spinor.SpinorTenfoldWeakQuotientSO10Generator

/-!
# Aristotle target: exact two-coordinate matrix of the weak raising generator

Close the proof holes without changing any statement. The main theorem should
compute the already-landed nonidentity quotient action in the proved
coordinate equivalence. The controls prevent a sign or basis-order repair.

Claim boundary: this is the coordinate matrix of one infinitesimal complex
`so(10)` generator. It is not yet an `sl(2)` triple, compact `su(2)`, a group
representation, or physical `SU(2)_L`.
-/

noncomputable section

namespace PhysicsSM.Spinor.SpinorTenfold

/-- In coordinates `(w_3,w_4)`, the generator `e_3 wedge f_4` sends
`(w_3,w_4)` to `(0,-w_3)`. -/
theorem weakCoordinateAction_raising_formula (w : Fin 2 -> Complex) :
    weakCoordinateAction weakRaisingGenerator
        weakRaisingGenerator_preserves_color w =
      fun j => if j = (0 : Fin 2) then 0 else -w 0 := by
  sorry

/-- The first coordinate basis vector is moved to minus the second. -/
theorem weakCoordinateAction_raising_basis0 :
    weakCoordinateAction weakRaisingGenerator
        weakRaisingGenerator_preserves_color (Pi.single 0 1) =
      -(Pi.single 1 1) := by
  sorry

/-- The second coordinate basis vector is killed. -/
theorem weakCoordinateAction_raising_basis1 :
    weakCoordinateAction weakRaisingGenerator
        weakRaisingGenerator_preserves_color (Pi.single 1 1) = 0 := by
  sorry

end PhysicsSM.Spinor.SpinorTenfold
