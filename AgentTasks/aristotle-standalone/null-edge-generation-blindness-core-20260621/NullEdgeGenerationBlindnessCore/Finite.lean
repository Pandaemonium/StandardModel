import Mathlib

/-!
# Generation-blindness core

Standalone finite algebra for the claim that the visible Plucker mass
functional is blind to internal generation relabeling.

The theorem is deliberately narrow: if the visible spinor family is only
reindexed by a permutation of the hidden/generation labels, the pairwise
Plucker mass is unchanged.  This supports the program's claim that generations
must live in hidden Gram/Yukawa data rather than in the visible rank-two null
geometry itself.
-/

noncomputable section

namespace NullEdgeGenerationBlindnessCore

open BigOperators
open Matrix Complex

abbrev CSpinor := Fin 2 -> Complex

def complexAbsSq (z : Complex) : Complex :=
  z * starRingEnd Complex z

def spinorWedge (psi phi : CSpinor) : Complex :=
  psi 0 * phi 1 - psi 1 * phi 0

def finPairIndexSet (n : Nat) : Finset (Fin n × Fin n) :=
  Finset.univ.filter fun p => (p.1 : Nat) < (p.2 : Nat)

def finPairwisePluckerMass {n : Nat} (psi : Fin n -> CSpinor) : Complex :=
  (finPairIndexSet n).sum fun p =>
    complexAbsSq (spinorWedge (psi p.1) (psi p.2))

/-- The squared Plucker wedge is symmetric in its two spinor arguments. -/
theorem complexAbsSq_spinorWedge_comm (psi phi : CSpinor) :
    complexAbsSq (spinorWedge psi phi) =
      complexAbsSq (spinorWedge phi psi) := by
  sorry

/--
The visible pairwise Plucker mass is invariant under any permutation of the
hidden/generation index set.
-/
theorem finPairwisePluckerMass_perm {n : Nat}
    (psi : Fin n -> CSpinor) (e : Equiv.Perm (Fin n)) :
    finPairwisePluckerMass (fun i => psi (e i)) =
      finPairwisePluckerMass psi := by
  sorry

/--
Generation-blindness wrapper: two visible families related by a relabeling of
their hidden indices have the same visible Plucker mass.
-/
theorem visiblePluckerMass_generationBlind {n : Nat}
    (psi phi : Fin n -> CSpinor) (e : Equiv.Perm (Fin n))
    (h : phi = fun i => psi (e i)) :
    finPairwisePluckerMass phi = finPairwisePluckerMass psi := by
  sorry

end NullEdgeGenerationBlindnessCore

end
