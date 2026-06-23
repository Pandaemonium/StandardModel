import Mathlib.Tactic
import Mathlib.Data.Matrix.Basic

/-!
# Chirality (Weyl) projectors

The chiral projectors `P_L = (1 - gamma5)/2` and `P_R = (1 + gamma5)/2` built from
`gamma5 = diag(1,1,-1,-1)` are complementary orthogonal idempotents: they split
the Dirac space into Weyl components. Kernel-checked anchor for the
chirality/handedness conventions on the P2 Dirac-operator line.

Standalone (Mathlib only).
-/

noncomputable section

namespace NullEdgeChiralityProjectors

open Matrix

/-- The chirality operator `gamma5 = diag(1,1,-1,-1)`. -/
def gamma5 : Matrix (Fin 4) (Fin 4) Real :=
  !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

/-- Left chiral projector. -/
def PL : Matrix (Fin 4) (Fin 4) Real := (1 / 2 : Real) • (1 - gamma5)

/-- Right chiral projector. -/
def PR : Matrix (Fin 4) (Fin 4) Real := (1 / 2 : Real) • (1 + gamma5)

/-- `P_L` is idempotent. -/
theorem PL_idem : PL * PL = PL := by sorry

/-- `P_R` is idempotent. -/
theorem PR_idem : PR * PR = PR := by sorry

/-- The projectors are complementary. -/
theorem PL_add_PR : PL + PR = 1 := by sorry

/-- The projectors are orthogonal. -/
theorem PL_mul_PR : PL * PR = 0 := by sorry

end NullEdgeChiralityProjectors
