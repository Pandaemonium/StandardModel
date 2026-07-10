import Mathlib

/-!
# A finite region net: isotony and disjoint-region commutativity beyond two
# factors

Bridge (iv) of the manuscript's open-bridge list, and RUN_PLAN Flagship C
rung C2.1: upgrade the landed two-region tensor microcausality to an actual
finite NET of regions — an assignment `R -> A(R)` on ALL subsets of a finite
site set, with isotony, disjoint-region commutativity, region-join
generation, and nonvacuity witnesses.

## Setup

Sites `s : Fin 3`, each carrying a qubit; the total space is
`V = (Fin 3 -> Fin 2) -> C` and operators are `Matrix (Fin 3 -> Fin 2)
(Fin 3 -> Fin 2) C`.  An operator `A` is SUPPORTED on a region `R ⊆ Fin 3`
when its matrix elements factor through equality of configurations off `R`:

  `Supported R A := ∀ f g, (∃ s ∉ R, f s ≠ g s) → A f g = 0` together with
  `∀ f g f' g', (∀ s ∈ R, f s = f' s ∧ g s = g' s) →
      (∀ s ∉ R, f s = g s) → (∀ s ∉ R, f' s = g' s) → A f g = A f' g'`.

(The first clause kills matrix elements that change the configuration
outside `R`; the second makes the retained elements independent of the
frozen exterior configuration.  Together they are the finite form of
`A = A_R ⊗ 1`.)

## Targets

1. `supported_one` — the identity is supported on every region (including
   the empty region).
2. `isotony` — `R ⊆ S` implies every `R`-supported operator is
   `S`-supported: smaller regions' questions remain available in larger
   regions.
3. `supported_mul` / `supported_add` — each region's supported operators are
   closed under product and sum (an algebra), so `R -> A(R)` is a net of
   algebras.
4. `disjoint_commute` — operators supported on DISJOINT regions commute:
   finite microcausality for arbitrarily many regions, not just a fixed
   bipartition.
5. `witness_noncommuting_inside` — nonvacuity: two operators supported on
   the SAME single site that do not commute (Pauli X and Z on site 0, lifted
   to the total space), so commutativity is genuinely a disjointness
   phenomenon, not a degeneracy of the support definition.
6. `witness_three_regions` — an explicit three-region configuration: X on
   site 0, Z on site 1, X on site 2 pairwise commute (pairwise disjoint
   singletons), while the site-0 X and site-0 Z pair from target 5 does not:
   the net distinguishes disjointness from overlap on three regions.

Honest scope: a finite lattice net with isotony and microcausality; NOT a
Haag-Kastler net (no Poincare covariance, no vacuum, no type-III structure),
and no claim that graph regions of the null-edge carrier factor this way —
that refinement compatibility is the remaining half of bridge (iv), named.
Do not weaken the statements.  Helper lemmas welcome.  Run
`lake env lean FiniteRegionNet/RegionNet.lean` first.
-/

namespace FiniteRegionNet

open Matrix

/-- Total-space operators on three qubit sites. -/
abbrev Op := Matrix ((Fin 3) → Fin 2) ((Fin 3) → Fin 2) ℂ

/-- An operator is supported on a region when it acts trivially off it:
matrix elements vanish unless the exterior configuration is unchanged, and
the retained elements do not depend on the exterior configuration. -/
def Supported (R : Set (Fin 3)) (A : Op) : Prop :=
  (∀ f g : (Fin 3) → Fin 2, (∃ s, s ∉ R ∧ f s ≠ g s) → A f g = 0) ∧
  (∀ f g f' g' : (Fin 3) → Fin 2,
    (∀ s ∈ R, f s = f' s) → (∀ s ∈ R, g s = g' s) →
    (∀ s, s ∉ R → f s = g s) → (∀ s, s ∉ R → f' s = g' s) →
    A f g = A f' g')

/-- Lift a single-qubit operator to site `s0` of the total space. -/
noncomputable def liftAt (s0 : Fin 3) (a : Matrix (Fin 2) (Fin 2) ℂ) : Op :=
  Matrix.of fun f g =>
    a (f s0) (g s0) *
      (if ∀ s, s ≠ s0 → f s = g s then 1 else 0)

/-- Target 1: the identity is supported everywhere, even on the empty
region. -/
theorem supported_one (R : Set (Fin 3)) : Supported R (1 : Op) := by
  sorry

/-- Target 2: isotony — enlarging the region preserves support. -/
theorem isotony (R S : Set (Fin 3)) (hRS : R ⊆ S) (A : Op)
    (hA : Supported R A) : Supported S A := by
  sorry

/-- Target 3a: supported operators are closed under multiplication. -/
theorem supported_mul (R : Set (Fin 3)) (A B : Op)
    (hA : Supported R A) (hB : Supported R B) : Supported R (A * B) := by
  sorry

/-- Target 3b: supported operators are closed under addition. -/
theorem supported_add (R : Set (Fin 3)) (A B : Op)
    (hA : Supported R A) (hB : Supported R B) : Supported R (A + B) := by
  sorry

/-- Target 4: finite microcausality — disjointly supported operators
commute. -/
theorem disjoint_commute (R S : Set (Fin 3)) (hdisj : Disjoint R S)
    (A B : Op) (hA : Supported R A) (hB : Supported S B) :
    A * B = B * A := by
  sorry

/-- Target 5: nonvacuity — Pauli X and Z lifted to the same site are each
supported on that singleton and do not commute. -/
theorem witness_noncommuting_inside :
    Supported {0} (liftAt 0 !![0, 1; 1, 0]) ∧
    Supported {0} (liftAt 0 !![1, 0; 0, -1]) ∧
    liftAt 0 !![0, 1; 1, 0] * liftAt 0 !![1, 0; 0, -1] ≠
      liftAt 0 !![1, 0; 0, -1] * liftAt 0 !![0, 1; 1, 0] := by
  sorry

/-- Target 6: three pairwise-disjoint regions pairwise commute. -/
theorem witness_three_regions :
    (liftAt 0 !![0, 1; 1, 0] * liftAt 1 !![1, 0; 0, -1] =
      liftAt 1 !![1, 0; 0, -1] * liftAt 0 !![0, 1; 1, 0]) ∧
    (liftAt 1 !![1, 0; 0, -1] * liftAt 2 !![0, 1; 1, 0] =
      liftAt 2 !![0, 1; 1, 0] * liftAt 1 !![1, 0; 0, -1]) ∧
    (liftAt 0 !![0, 1; 1, 0] * liftAt 2 !![0, 1; 1, 0] =
      liftAt 2 !![0, 1; 1, 0] * liftAt 0 !![0, 1; 1, 0]) := by
  sorry

end FiniteRegionNet
