import Mathlib.Tactic

/-!
# P2 dephased chiral projector determinant equals mass ratio

This target combines the chirality-coherence and dephasing determinant bridges.
On the scalar mass shell `E^2 = p^2 + m^2`, dephasing the positive-energy
two-level chiral projector gives determinant `m^2 / (4 E^2)`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP2ProjectorDephasedDetMassRatio

def chiralWeight (E p : Real) : Real :=
  (E + p) / (2 * E)

def dephasedDet (q : Real) : Real :=
  q * (1 - q)

theorem dephasedDet_chiralWeight_eq_mass_ratio_sq
    (m p E : Real) (hE : E ≠ 0) (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    dephasedDet (chiralWeight E p) = m ^ 2 / (4 * E ^ 2) := by
  unfold chiralWeight dephasedDet
  grind

end PhysicsSM.Draft.NullEdgeP2ProjectorDephasedDetMassRatio
