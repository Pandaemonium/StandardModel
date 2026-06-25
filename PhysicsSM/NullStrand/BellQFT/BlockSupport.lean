import Mathlib

/-!
# NullStrand.BellQFT.BlockSupport

Manifest node BELL-004: a vanishing operator block `P q * H * P q'` carries no
Bell current, hence its positive-part minimal jump rate is also zero. This is the
support-transfer lemma feeding GRAPH-001 (operator support ⇒ current support); the
manifest rates it intentionally simple.

The current here is the single-block form `2·Im⟪ψ, B ψ⟫` (named `operatorBlockCurrent`
to avoid clashing with `BellQFT.FiniteCurrent.quantumCurrent`, which carries the
configuration indices explicitly).

Provenance: clean-room statement; proof from Aristotle project
`dfb448bb-1610-4ffc-b146-754caf4f6eaa`, verified `sorry`/`axiom`-free, integrated
2026-06-25 (only the local def was renamed; the theorem statement is identical).
-/

namespace PhysicsSM.NullStrand.BellQFT

open Matrix Complex
open scoped BigOperators

/-- The finite Bell current carried by an operator block `B = P q * H * P q'`. -/
noncomputable def operatorBlockCurrent {Q : Type*} [Fintype Q] (B : Matrix Q Q ℂ) (ψ : Q → ℂ) : ℝ :=
  2 * (star ψ ⬝ᵥ B.mulVec ψ).im

/-- BELL-004. A vanishing operator block carries no Bell current, hence its
positive-part minimal jump rate `max (operatorBlockCurrent …) 0` is also zero. -/
theorem operatorBlockZero_implies_currentZero {Q : Type*} [Fintype Q]
    (Pq H Pq' : Matrix Q Q ℂ) (ψ : Q → ℂ) (hblock : Pq * H * Pq' = 0) :
    operatorBlockCurrent (Pq * H * Pq') ψ = 0 ∧
      max (operatorBlockCurrent (Pq * H * Pq') ψ) 0 = 0 := by
  simp [operatorBlockCurrent, hblock]

end PhysicsSM.NullStrand.BellQFT
