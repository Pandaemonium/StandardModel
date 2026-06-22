import Mathlib

set_option linter.style.longLine false
set_option linter.style.whitespace false

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

/-
The squared Plucker wedge is symmetric in its two spinor arguments.
-/
theorem complexAbsSq_spinorWedge_comm (psi phi : CSpinor) :
    complexAbsSq (spinorWedge psi phi) =
      complexAbsSq (spinorWedge phi psi) := by
  unfold complexAbsSq spinorWedge;
  grind +qlia

set_option linter.flexible false in
/-
The visible pairwise Plucker mass is invariant under any permutation of the
hidden/generation index set.
-/
theorem finPairwisePluckerMass_perm {n : Nat}
    (psi : Fin n -> CSpinor) (e : Equiv.Perm (Fin n)) :
    finPairwisePluckerMass (fun i => psi (e i)) =
      finPairwisePluckerMass psi := by
  -- We need to establish the helper equality: the sum over the unordered-pair set equals half the sum over the full product.
  have h_helper (g : Fin n → Fin n → ℂ) (hg_symm : ∀ i j, g i j = g j i) (hg_diag : ∀ i, g i i = 0) :
      (finPairIndexSet n).sum (fun p => g p.1 p.2) =
        (1 / 2) * ∑ i, ∑ j, g i j := by
          -- By definition of $finPairIndexSet$, we can split the sum into two parts: one over pairs $(i, j)$ with $i < j$ and one over pairs $(i, j)$ with $i > j$.
          have h_split_sum : ∑ i : Fin n, ∑ j : Fin n, g i j = ∑ i : Fin n, ∑ j ∈ Finset.univ.filter (fun j => i < j), g i j + ∑ i : Fin n, ∑ j ∈ Finset.univ.filter (fun j => i > j), g i j := by
            simp +decide only [Finset.sum_filter, ← Finset.sum_add_distrib];
            refine Finset.sum_congr rfl fun i hi => Finset.sum_congr rfl fun j hj => ?_;
            grind;
          -- By definition of $finPairIndexSet$, we can rewrite the sum over pairs $(i, j)$ with $i < j$ as a sum over pairs $(i, j)$ with $i > j$.
          have h_symm_sum : ∑ i : Fin n, ∑ j ∈ Finset.univ.filter (fun j => i > j), g i j = ∑ i : Fin n, ∑ j ∈ Finset.univ.filter (fun j => i < j), g j i := by
            simp +decide only [Finset.sum_filter];
            rw [ Finset.sum_comm ];
          simp_all +decide [ Finset.sum_filter ];
          unfold finPairIndexSet;
          simp +decide only [ Finset.sum_filter ];
          erw [ Finset.sum_product ];
          simp only [ Fin.lt_def ];
          ring;
  convert h_helper ( fun i j => complexAbsSq ( spinorWedge ( psi ( e i ) ) ( psi ( e j ) ) ) ) ( fun i j => ?_ ) ( fun i => ?_ ) using 1;
  · convert h_helper ( fun i j => complexAbsSq ( spinorWedge ( psi i ) ( psi j ) ) ) ( fun i j => ?_ ) ( fun i => ?_ ) using 1;
    · conv_rhs => rw [ ← Equiv.sum_comp e ] ;
      exact congrArg _ ( Finset.sum_congr rfl fun i hi => Equiv.sum_comp ( e ) fun j => complexAbsSq ( spinorWedge ( psi ( e i ) ) ( psi j ) ) );
    · exact complexAbsSq_spinorWedge_comm _ _;
    · unfold complexAbsSq spinorWedge; ring;
  · exact complexAbsSq_spinorWedge_comm _ _;
  · unfold complexAbsSq spinorWedge; ring;

/-
Generation-blindness wrapper: two visible families related by a relabeling of
their hidden indices have the same visible Plucker mass.
-/
theorem visiblePluckerMass_generationBlind {n : Nat}
    (psi phi : Fin n -> CSpinor) (e : Equiv.Perm (Fin n))
    (h : phi = fun i => psi (e i)) :
    finPairwisePluckerMass phi = finPairwisePluckerMass psi := by
  rw [ h, finPairwisePluckerMass_perm ]

end NullEdgeGenerationBlindnessCore

end
