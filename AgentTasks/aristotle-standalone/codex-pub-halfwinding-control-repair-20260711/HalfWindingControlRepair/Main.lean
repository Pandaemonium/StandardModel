import Mathlib
import PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

open Polynomial

namespace PhysicsSM.Draft.NullEdge.HalfWindingControlRepair

open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

set_option maxHeartbeats 8000000
set_option maxRecDepth 10000

/-- The advertised zero-wall compressed block is the actual fixed-leg
compression of the displayed zero-wall walk. -/
theorem Wzero_Bfix : Wzero * Bfix = Bfix * Afix0 := by
  sorry

/-- The advertised four-wall compressed block is the actual fixed-leg
compression of the displayed four-wall walk. -/
theorem Wfour_Bfix : Wfour * Bfix = Bfix * Afix4 := by
  sorry

/-- The complete zero-wall walk has no `-1` eigenvalue. -/
theorem Wzero_det_add_one : (Wzero + 1).det = 1296 / 625 := by
  sorry

/-- The complete zero-wall walk has no `+1` eigenvalue. -/
theorem Wzero_det_sub_one : (Wzero - 1).det = 1296 / 625 := by
  sorry

/-- The complete four-wall walk has no `-1` eigenvalue. -/
theorem Wfour_det_add_one : (Wfour + 1).det = 1296 / 625 := by
  sorry

/-- The complete four-wall walk has no `+1` eigenvalue. -/
theorem Wfour_det_sub_one : (Wfour - 1).det = 1296 / 625 := by
  sorry

/-- Exact characteristic-polynomial factorization of the two-wall walk. The
two linear factors show algebraic multiplicity two at each pinned sign. -/
theorem Wwall_charpoly_factorization :
    Wwall.charpoly =
      (X - C 1) ^ 2 * (X + C 1) ^ 2 *
        (X ^ 2 - C (8 / 5) * X + C 1) *
        (X ^ 2 + C (8 / 5) * X + C 1) := by
  sorry

end PhysicsSM.Draft.NullEdge.HalfWindingControlRepair
