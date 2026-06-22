import PhysicsSM.Spinor.PluckerMass

/-!
# Generation-blindness port

This focused target ports the already-proved standalone generation-blindness
theorem to the canonical trusted Pluecker definitions in
`PhysicsSM.Spinor.PluckerMass`.

The mathematical claim is deliberately narrow: relabeling the finite visible
spinor family by a permutation does not change the visible pairwise Pluecker
mass. This does not assert anything about nonorthogonal hidden Gram data.
-/

noncomputable section

namespace NullEdgeGenerationBlindnessPort

open BigOperators
open PhysicsSM.Spinor.PluckerMass

/-- The squared Pluecker wedge is symmetric in its two spinor arguments. -/
theorem complexAbsSq_spinorWedge_comm (psi phi : CSpinor) :
    complexAbsSq (spinorWedge psi phi) =
      complexAbsSq (spinorWedge phi psi) := by
  sorry

/--
The canonical visible pairwise Pluecker mass is invariant under any permutation
of the hidden/generation index set.
-/
theorem finPairwisePluckerMass_perm {n : Nat}
    (psi : Fin n -> CSpinor) (e : Equiv.Perm (Fin n)) :
    finPairwisePluckerMass (fun i => psi (e i)) =
      finPairwisePluckerMass psi := by
  sorry

/--
Generation-blindness wrapper for the canonical trusted Pluecker mass.
-/
theorem visiblePluckerMass_generationBlind {n : Nat}
    (psi phi : Fin n -> CSpinor) (e : Equiv.Perm (Fin n))
    (h : phi = fun i => psi (e i)) :
    finPairwisePluckerMass phi = finPairwisePluckerMass psi := by
  sorry

end NullEdgeGenerationBlindnessPort

end
