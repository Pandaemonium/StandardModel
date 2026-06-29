/-
# C201 gamma-free sign stability

Local Draft promotion copied from Aristotle output on 2026-06-28.
Source artifact: AgentTasks/aristotle-output/141aa425-f402-40a3-920b-93d7a8783419/extracted/ba4a4e0e-e185-4e4d-9c6c-a1630fe75e65_aristotle/RequestProject/SignStability.lean

Status: Draft artifact, locally checked and targeted-built on 2026-06-28.
Claim boundary: this is not a proof of full GateC1_NU.
-/

import Mathlib

open scoped BigOperators
open scoped Classical

/-!
# C201 — γ-free sign-pattern stability

This file proves the stability lemma needed for the C170/C181 homotopy budget.

C193 establishes a strictly positive *free reference margin*

```
gamma_free = min(m0, 2 r_W - m0, 16 r_b - m0) > 0.
```

The content of C201 is purely *order-theoretic*: as long as every sector's mass
sits at distance at least `gamma_free` from zero (the physical sector below by
`-gamma_free`, every non-physical sector above by `+gamma_free`) and the
perturbation is strictly smaller than `gamma_free` in size, the sign pattern of
the spectrum is preserved.

We give two variants:

* `scalar_sign_stability` — the pointwise (scalar) statement over a finite
  sector type `S`.
* `operator_sign_stability` — a *certificate interface* for the operator-norm
  homotopy `H_t = H_0 + t E`.  The analytic Weyl/Lipschitz input
  (`|m_t(s) - m_0(s)| ≤ t · ‖E‖`) is taken as a hypothesis so the lemma can be
  reused by any future job that supplies such a perturbation bound.

No `GateC1_NU` claim is made here.
-/

namespace C201

/-! ## Scalar variant -/

/-
**Scalar sign-pattern stability.**

Let `S` be a sector type with a distinguished physical sector `phys`.  Suppose

* the physical sector mass satisfies `m phys ≤ -γ`;
* every non-physical sector satisfies `m s ≥ γ`;
* every perturbation satisfies `|δ s| < γ`;

with `γ > 0`.  Then the perturbed physical sector stays strictly negative and
every perturbed non-physical sector stays strictly positive, i.e. the sign
pattern is preserved.
-/
theorem scalar_sign_stability
    {S : Type*} (phys : S) (m delta : S → ℝ) (gamma : ℝ)
    (hphys : m phys ≤ -gamma)
    (hother : ∀ s, s ≠ phys → gamma ≤ m s)
    (hpert : ∀ s, |delta s| < gamma) :
    m phys + delta phys < 0 ∧ ∀ s, s ≠ phys → 0 < m s + delta s := by
  exact ⟨ by linarith [ abs_lt.mp ( hpert phys ) ], fun s hs => by linarith [ abs_lt.mp ( hpert s ), hother s hs ] ⟩

/-! ## Operator (certificate-interface) variant -/

/-- **Operator-norm sign-pattern stability (certificate interface).**

Model the spectrum of the homotopy `H_t = H_0 + t · E` by a family of sector
masses `mt : S → ℝ → ℝ`, where `mt s t` is the mass of sector `s` in `H_t`.

The single analytic input is the Weyl/Lipschitz perturbation certificate

```
∀ s, ∀ t ∈ [0,1], |mt s t - mt s 0| ≤ t · ‖E‖
```

together with the operator-norm bound `‖E‖ < γ` and `0 ≤ ‖E‖`, and the
isolation of the sectors at `t = 0` (`mt phys 0 ≤ -γ`, `mt s 0 ≥ γ` for
`s ≠ phys`).

Conclusion: along the entire homotopy `t ∈ [0,1]` no sector crosses zero — the
physical sector stays strictly negative and every other sector stays strictly
positive.  This is exactly the "no sign crossing" guarantee consumed by the
homotopy budget.
-/
theorem operator_sign_stability
    {S : Type*} (phys : S) (gamma normE : ℝ)
    (mt : S → ℝ → ℝ)
    (hEnn : 0 ≤ normE) (hE : normE < gamma)
    (hLip : ∀ s, ∀ t ∈ Set.Icc (0 : ℝ) 1, |mt s t - mt s 0| ≤ t * normE)
    (hphys0 : mt phys 0 ≤ -gamma)
    (hother0 : ∀ s, s ≠ phys → gamma ≤ mt s 0) :
    ∀ t ∈ Set.Icc (0 : ℝ) 1,
      mt phys t < 0 ∧ ∀ s, s ≠ phys → 0 < mt s t := by
  exact fun t ht => ⟨ by nlinarith [ abs_le.mp ( hLip phys t ht ), ht.1, ht.2 ], fun s hs => by nlinarith [ abs_le.mp ( hLip s t ht ), hother0 s hs, ht.1, ht.2 ] ⟩

/-! ## Bridge to C193's free reference margin -/

/-- The C193 free reference margin `γ_free = min(m0, 2 r_W - m0, 16 r_b - m0)`. -/
noncomputable def gammaFree (m0 r_W r_b : ℝ) : ℝ :=
  min m0 (min (2 * r_W - m0) (16 * r_b - m0))

/-- **C193 positivity (consumed here).** Under the free-reference inequalities
`0 < m0`, `m0 < 2 r_W`, `m0 < 16 r_b`, the margin `γ_free` is strictly
positive. -/
theorem gammaFree_pos {m0 r_W r_b : ℝ}
    (hm0 : 0 < m0) (hW : m0 < 2 * r_W) (hb : m0 < 16 * r_b) :
    0 < gammaFree m0 r_W r_b := by
  exact lt_min hm0 ( lt_min ( by linarith ) ( by linarith ) )

/-- **C201 specialised to the C193 margin.** Plugging `γ := γ_free` into the
scalar stability theorem: this is the precise statement the κ/α/β homotopy
budget invokes, with the positivity of `γ_free` supplied by C193. -/
theorem scalar_sign_stability_gammaFree
    {S : Type*} (phys : S) (m delta : S → ℝ) {m0 r_W r_b : ℝ}
    (hphys : m phys ≤ -gammaFree m0 r_W r_b)
    (hother : ∀ s, s ≠ phys → gammaFree m0 r_W r_b ≤ m s)
    (hpert : ∀ s, |delta s| < gammaFree m0 r_W r_b) :
    m phys + delta phys < 0 ∧ ∀ s, s ≠ phys → 0 < m s + delta s :=
  scalar_sign_stability phys m delta (gammaFree m0 r_W r_b) hphys hother hpert

end C201
