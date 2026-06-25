import Mathlib

/-!
# NullStrand graph operator: square support (manifest node GRAPH-002)

`support_square_subset_relComp`: if a finite matrix `D` is supported on a relation
`R` (entries off `R` vanish), then the support of `D * D` lies in the two-step
relational closure `R ∘ R`. This corrects the misconception that a first-order
null-local operator has a nearest-neighbour square (improved roadmap §6.5, W12).

Mathlib-only; intended as a focused Aristotle target.
-/

namespace NullStrand.Graph

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
  sorry

end NullStrand.Graph
