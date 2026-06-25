import Mathlib

/-!
# NullStrand.BellQFT.BornSafety

Manifest node BELL-002: if a configuration has zero Born weight — i.e. its
(Hermitian) projector annihilates the state, `P ψ = 0` — then every Bell current
term `2·Im⟪ψ, (P·X) ψ⟫` sourced there vanishes, for any operator `X`. This is the
lemma that makes the minimal Bell rates (`current / Born weight`) denominator-safe
without relying on division conventions (improved roadmap §18.1, W11).

Provenance: clean-room statement; proof from Aristotle project
`cdfbad1c-bd1d-44e3-89a5-4ea7c821b29c`, verified `sorry`/`axiom`-free and
statement-identical, integrated 2026-06-25.
-/

namespace PhysicsSM.NullStrand.BellQFT

open Matrix Complex
open scoped BigOperators

/-- BELL-002. If the Hermitian configuration projector `P` annihilates the state
`ψ` (zero Born weight), then the Bell current `2·Im⟪ψ, (P·X) ψ⟫` sourced at that
configuration is zero, for any operator `X`. -/
theorem zeroBornWeight_implies_noOutgoingCurrent {Q : Type*} [Fintype Q]
    (P X : Matrix Q Q ℂ) (ψ : Q → ℂ) (hP : P.IsHermitian) (hborn : P.mulVec ψ = 0) :
    2 * (star ψ ⬝ᵥ (P * X).mulVec ψ).im = 0 := by
  simp_all +decide [Matrix.IsHermitian, dotProduct]
  -- Reduce to the Hermitian identity `⟪ψ, P v⟫ = ⟪P ψ, v⟫`.
  have h_simp : ∀ (v w : Q → ℂ),
      (∑ x, star (w x) * (P *ᵥ v) x) = (∑ x, star ((P *ᵥ w) x) * v x) := by
    simp +decide [Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _, mul_assoc, mul_comm]
    intro v w
    rw [Finset.sum_comm]
    congr; ext i; congr; ext j
    simp +decide [← Matrix.ext_iff] at hP ⊢
    rw [hP]; ring
  convert congr_arg Complex.im (h_simp (X *ᵥ ψ) ψ) using 1
  · simp +decide [Matrix.mulVec_mulVec]
  · aesop

end PhysicsSM.NullStrand.BellQFT
