/-
# CP phase as projective null-ray holonomy

The mass invariant `|ψᵢ ∧ ψⱼ|²` forgets phases. But the spinor brackets
`⟨ij⟩ := ψᵢ ∧ ψⱼ = det [ψᵢ | ψⱼ]` retain phase, and a closed triple product

    J(ψ₁,ψ₂,ψ₃) := ⟨12⟩⟨23⟩⟨31⟩

is a **Bargmann-type holonomy** of three null rays: its magnitude contributes to
disagreement (mass), its phase is a geometric/CP invariant. The proposal: mixing
matrices are overlap maps between coherence bases, and the physical CP phase is the
gauge-invariant phase of such a triple/quadruple null-ray holonomy — CP-odd because
conjugation reverses the loop.

## Targets

- `triple_SL2_invariant`: `J` is invariant under a common `SL(2,ℂ)` transformation
  `ψᵢ ↦ g ψᵢ` with `det g = 1` (each bracket picks up `det g`, the product picks up
  `(det g)³ = 1`). So `J` is a genuine invariant of the null-ray configuration modulo
  the Lorentz/`SL(2,ℂ)` action.
- `triple_CP_odd`: under CP-conjugation `ψᵢ ↦ conj ψᵢ` (componentwise complex
  conjugation), `J ↦ conj J`, so `arg J ↦ −arg J` — the holonomy **phase flips sign**.
  A configuration with `J` not real (nonzero `Im J`) is genuinely CP-violating; a
  gaugeable-away phase has `Im J = 0`.
- `triple_mass_magnitude`: `|J| = |⟨12⟩|·|⟨23⟩|·|⟨31⟩|` ties the magnitude to the
  pairwise disagreements (masses), so a nonzero CP phase requires all three pairs to
  disagree (`⟨ij⟩ ≠ 0`) — CP violation needs genuine three-way non-collinearity.
-/

import Mathlib

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.CPHolonomy

/-- Spinor bracket `⟨ψ,φ⟩ = ψ ∧ φ = det [ψ | φ]` for two `2`-spinors. -/
def bracket (psi phi : Fin 2 → ℂ) : ℂ := psi 0 * phi 1 - psi 1 * phi 0

/-- The closed triple holonomy `J = ⟨12⟩⟨23⟩⟨31⟩`. -/
def tripleJ (p1 p2 p3 : Fin 2 → ℂ) : ℂ :=
  bracket p1 p2 * bracket p2 p3 * bracket p3 p1

/-- **`SL(2,ℂ)`-invariance (TARGET).** Under a common `g` with `det g = 1`,
`tripleJ (g·p1) (g·p2) (g·p3) = tripleJ p1 p2 p3`. (Each bracket scales by `det g`;
the product by `(det g)³ = 1`.) -/
theorem triple_SL2_invariant (g : Matrix (Fin 2) (Fin 2) ℂ) (hg : g.det = 1)
    (p1 p2 p3 : Fin 2 → ℂ) :
    tripleJ (g.mulVec p1) (g.mulVec p2) (g.mulVec p3) = tripleJ p1 p2 p3 := by
  sorry

/-- **CP-oddness (TARGET).** Under componentwise conjugation, `tripleJ` conjugates,
so its phase flips: `tripleJ (conj p1) (conj p2) (conj p3) = conj (tripleJ p1 p2 p3)`.
Hence `Im (tripleJ) ≠ 0` is a genuine, non-gaugeable CP-violating invariant. -/
theorem triple_CP_odd (p1 p2 p3 : Fin 2 → ℂ) :
    tripleJ (fun i => conj (p1 i)) (fun i => conj (p2 i)) (fun i => conj (p3 i))
      = conj (tripleJ p1 p2 p3) := by
  sorry

/-- **Magnitude ties to pairwise disagreement (TARGET).**
`‖tripleJ‖ = ‖⟨12⟩‖ · ‖⟨23⟩‖ · ‖⟨31⟩‖`, so a nonzero CP holonomy requires all three
pairs to be non-collinear (`bracket ≠ 0`). -/
theorem triple_mass_magnitude (p1 p2 p3 : Fin 2 → ℂ) :
    ‖tripleJ p1 p2 p3‖ = ‖bracket p1 p2‖ * ‖bracket p2 p3‖ * ‖bracket p3 p1‖ := by
  sorry

end PhysicsSM.Draft.NullEdge.CPHolonomy
