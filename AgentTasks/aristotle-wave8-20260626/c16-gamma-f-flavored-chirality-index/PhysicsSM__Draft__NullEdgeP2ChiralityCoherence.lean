import Mathlib.Tactic

/-!
# P2 chirality coherence in a two-level Dirac/Yukawa block

This module records a small finite algebraic bridge for the Higgs/Yukawa
interpretation. The off-diagonal mass entry of the positive-energy chiral
projector has l1 chirality coherence `m / E`.

Physics interpretation boundary: the theorem says the mass coupling creates
left/right coherence in the chiral block. Visible mixedness appears only after
an explicit observer channel, dephasing, or partial trace; it should not be
double-counted as an additional independent mass mechanism.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP2ChiralityCoherence

/-- Off-diagonal left/right entry of the positive-energy chiral projector. -/
def positiveProjectorLR (m E : Real) : Real :=
  m / (2 * E)

/-- The l1 chirality coherence of a two-level chiral projector. -/
def chiralityCoherence (offdiag : Real) : Real :=
  2 * |offdiag|

/--
For the two-level Dirac/Yukawa block, the positive-energy projector has
chirality coherence `m / E` when `m >= 0` and `E > 0`.
-/
theorem chiralityCoherence_positiveProjectorLR_eq_mass_over_energy
    (m E : Real) (hm : 0 <= m) (hE : 0 < E) :
    chiralityCoherence (positiveProjectorLR m E) = m / E := by
  unfold chiralityCoherence positiveProjectorLR
  rw [abs_of_nonneg (by positivity)]
  field_simp

end PhysicsSM.Draft.NullEdgeP2ChiralityCoherence
