import Mathlib

/-!
# NullStrand Bell current block-zero support (manifest node BELL-004)

`operatorBlockZero_implies_currentZero`: if the operator block `P q * H * P q'`
between two configurations vanishes, then the finite Bell current sourced by that
block — and hence the minimal positive-part jump rate — is zero. This is the
support-transfer lemma feeding GRAPH-001 (operator support ⇒ current support);
the manifest rates it intentionally simple.

Bell current convention (improved roadmap §18.1): `quantumCurrent B ψ = 2 · Im⟪ψ, B ψ⟫`
for the operator block `B = P q * H * P q'`. Mathlib-only; focused Aristotle target.
-/

namespace NullStrand.BellQFT

open Matrix Complex
open scoped BigOperators

/-- The finite Bell current carried by an operator block `B = P q * H * P q'`. -/
noncomputable def quantumCurrent {Q : Type*} [Fintype Q] (B : Matrix Q Q ℂ) (ψ : Q → ℂ) : ℝ :=
  2 * (star ψ ⬝ᵥ B.mulVec ψ).im

/-- BELL-004. A vanishing operator block carries no Bell current, hence its
positive-part minimal jump rate `max (quantumCurrent …) 0` is also zero. -/
theorem operatorBlockZero_implies_currentZero {Q : Type*} [Fintype Q]
    (Pq H Pq' : Matrix Q Q ℂ) (ψ : Q → ℂ) (hblock : Pq * H * Pq' = 0) :
    quantumCurrent (Pq * H * Pq') ψ = 0 ∧ max (quantumCurrent (Pq * H * Pq') ψ) 0 = 0 := by
  sorry

end NullStrand.BellQFT
