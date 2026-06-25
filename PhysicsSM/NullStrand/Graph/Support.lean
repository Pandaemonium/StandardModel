import Mathlib

/-!
# NullStrand.Graph.Support

Manifest node GRAPH-002: the support of `D²` lies in the two-step relational
closure of the support of `D`. This corrects the misconception that a first-order
null-local operator has a nearest-neighbour square (improved roadmap §6.5, W12).

Provenance: clean-room statement; proof from Aristotle project
`d9e2e308-9492-4421-b68b-28c88e5eed68`, verified `sorry`/`axiom`-free and
statement-identical, integrated 2026-06-25.
-/

namespace PhysicsSM.NullStrand.Graph

open Matrix Finset
open scoped BigOperators

/-- A finite matrix is supported on `R` when every entry off `R` vanishes. -/
def SupportedOn {Q : Type*} [Fintype Q] (R : Q → Q → Prop) (D : Matrix Q Q ℂ) : Prop :=
  ∀ q q', ¬ R q q' → D q q' = 0

/-- GRAPH-002. The support of `D * D` is contained in the two-step relational
closure of the support of `D`: a nonzero `(D * D) q q'` entry forces an
intermediate `m` with `R q m` and `R m q'`. -/
theorem support_square_subset_relComp {Q : Type*} [Fintype Q]
    (R : Q → Q → Prop) (D : Matrix Q Q ℂ) (hD : SupportedOn R D)
    (q q' : Q) (h : (D * D) q q' ≠ 0) :
    ∃ m, R q m ∧ R m q' := by
  contrapose! h
  exact Finset.sum_eq_zero fun m _ => by by_cases hm : R q m <;> aesop

end PhysicsSM.NullStrand.Graph
