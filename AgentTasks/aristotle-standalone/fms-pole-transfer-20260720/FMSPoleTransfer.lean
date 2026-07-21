import Mathlib

/-!
# Conditional finite FMS pole transfer

Focused Aristotle target for the finite spectral step after an exact FMS
observable expansion.  The theorem is intentionally conditional: the leading
field must have nonzero overlap with a simple spectral atom, and the composite
remainder must vanish in that atom.  A one-channel cancellation witness proves
that remainder control is necessary.

Physics scope: finite Kallen-Lehmann algebra only.  No continuum pole, LSZ
statement, perturbative dominance, or observed mass is claimed.
-/

open scoped BigOperators ComplexConjugate
open Filter Matrix Complex Set

set_option relaxedAutoImplicit false
set_option autoImplicit false
set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

namespace FMSPoleTransfer

noncomputable section

/-- Squared overlap carried by one finite spectral channel. -/
def weight {m : ℕ} (v : Fin m → ℂ) (i : Fin m) : ℝ :=
  Complex.normSq (v i)

/-- Finite composite observable vector: leading field plus remainder. -/
def composite {m : ℕ} (c : ℂ) (elementary remainder : Fin m → ℂ) : Fin m → ℂ :=
  c • elementary + remainder

/-- Finite diagonal Kallen-Lehmann sum. -/
def klSum {m : ℕ} (mass : Fin m → ℝ) (v : Fin m → ℂ) (z : ℂ) : ℂ :=
  ∑ i, (weight v i : ℂ) / (z - (mass i : ℂ))

/-- If the remainder misses channel `k`, the composite overlap there is the
leading overlap scaled by `c`. -/
theorem composite_at_of_remainder_zero {m : ℕ}
    (c : ℂ) (elementary remainder : Fin m → ℂ) (k : Fin m)
    (hRemainder : remainder k = 0) :
    composite c elementary remainder k = c * elementary k := by
  sorry

/-- Exact spectral-weight transfer at a channel missed by the remainder. -/
theorem weight_composite_at_of_remainder_zero {m : ℕ}
    (c : ℂ) (elementary remainder : Fin m → ℂ) (k : Fin m)
    (hRemainder : remainder k = 0) :
    weight (composite c elementary remainder) k =
      Complex.normSq c * weight elementary k := by
  sorry

/-- A nonzero leading coefficient preserves positive visibility of the target
spectral atom exactly when the remainder misses that atom. -/
theorem weight_composite_pos_iff {m : ℕ}
    (c : ℂ) (elementary remainder : Fin m → ℂ) (k : Fin m)
    (hc : c ≠ 0) (hRemainder : remainder k = 0) :
    0 < weight (composite c elementary remainder) k ↔
      0 < weight elementary k := by
  sorry

/-- Analytic residue of a finite diagonal Kallen-Lehmann sum at a simple
spectral channel. -/
theorem tendsto_residue_eq_weight {m : ℕ}
    (mass : Fin m → ℝ) (v : Fin m → ℂ) (k : Fin m)
    (hSimple : ∀ i, i ≠ k → mass i ≠ mass k) :
    Tendsto (fun z : ℂ => (z - (mass k : ℂ)) * klSum mass v z)
      (nhdsWithin (mass k : ℂ) ({(mass k : ℂ)} : Set ℂ)ᶜ)
      (nhds (weight v k : ℂ)) := by
  sorry

/-- Conditional finite FMS pole transfer.  At a simple atom untouched by the
remainder, the composite residue is exactly the leading residue multiplied by
the squared magnitude of the FMS coefficient. -/
theorem tendsto_composite_residue {m : ℕ}
    (mass : Fin m → ℝ) (c : ℂ)
    (elementary remainder : Fin m → ℂ) (k : Fin m)
    (hSimple : ∀ i, i ≠ k → mass i ≠ mass k)
    (hRemainder : remainder k = 0) :
    Tendsto
      (fun z : ℂ =>
        (z - (mass k : ℂ)) * klSum mass (composite c elementary remainder) z)
      (nhdsWithin (mass k : ℂ) ({(mass k : ℂ)} : Set ℂ)ᶜ)
      (nhds ((Complex.normSq c * weight elementary k : ℝ) : ℂ)) := by
  sorry

/-- Remainder control is essential: even with nonzero leading coefficient and
positive elementary weight, a remainder can cancel the target atom exactly. -/
theorem remainder_can_cancel_target_atom :
    let elementary : Fin 1 → ℂ := fun _ => 1
    let remainder : Fin 1 → ℂ := fun _ => -1
    let k : Fin 1 := 0
    weight elementary k = 1 ∧
      (1 : ℂ) ≠ 0 ∧
      weight (composite 1 elementary remainder) k = 0 := by
  sorry

end

end FMSPoleTransfer
