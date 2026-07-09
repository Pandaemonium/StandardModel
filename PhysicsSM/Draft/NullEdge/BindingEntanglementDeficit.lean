/-
# Binding defect = entanglement deficit

In the null-edge program the mass-gap block is `B(λ,κ) = !![λ, κi, 0; -κi, λ, 0;
0, 0, λ]` (aperture `λ`, closure/coupling `κ`), spectrum `{λ−κ, λ, λ+κ}`, gap
`λ − κ`. The **binding defect** is the mass the coupling *removes*: `Δ = (λ) − (λ−κ)
= κ` — binding lowers the ground mass by `κ` without any diagonal mass term, purely
through the off-diagonal coherence.

Separately, mass is the null bundle's **concurrence** (`det P = (C/2)²` at two
edges; `det P = (G/n)ⁿ` at `n`). This file targets the identification the program
pre-registers as grade **C**: **the binding defect equals an entanglement deficit**
— the mass lost to binding is exactly the (concurrence-type) entanglement created
between the coupled modes.

## The coupled 2-level core

The binding lives in the `2×2` coupled block `Bc(λ,κ) = !![λ, κi; −κi, λ]`
(eigenvalues `λ ± κ`; the third mode `λ` is a spectator). Its off-diagonal coherence
`κ` is a **concurrence-type entanglement** of the coupled subspace.

## Exact entanglement measure used

For the normalized coupled density `ρ = Bc / tr Bc` (a genuine `2×2` density matrix
for `0 ≤ κ ≤ λ`, `0 < λ`) we use the **`ℓ₁` off-diagonal coherence**
`C(ρ) := 2‖ρ₀₁‖` (the concurrence-type / coherence measure of the coupled block).
We prove:

* `binding_defect_eq_coupling`: `spectrum ℂ (Bc λ κ) = {λ−κ, λ+κ}`, the least
  eigenvalue is `λ−κ`, hence `Δ = λ − (λ−κ) = κ`.
* `binding_defect_eq_concurrence` (the prize): the **exact** identity
  `κ = C(ρ)·λ` (equivalently `Δ = C(ρ)·(tr Bc)/2`), so the mass lost to binding
  equals the coherence/concurrence of the coupled block times the aperture.
* `binding_below_threshold_iff_entangled`: `Δ ≠ 0 ↔ C(ρ) ≠ 0` (binds strictly
  below the constituent sum iff the coupled block is entangled, `κ ≠ 0`).
-/

import Mathlib

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.BindingEntanglementDeficit

/-- The coupled 2-level binding block `Bc(λ,κ) = !![λ, κi; −κi, λ]`. -/
def Bc (lam kap : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(lam : ℂ), kap * Complex.I; -(kap * Complex.I), (lam : ℂ)]

/-- The normalized coupled density `ρ = Bc / tr Bc`. -/
noncomputable def coupledDensity (lam kap : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  ((Bc lam kap).trace)⁻¹ • Bc lam kap

/-- The `ℓ₁` off-diagonal coherence (concurrence-type entanglement measure) of the
normalized coupled density: `C(ρ) := 2‖ρ₀₁‖`. -/
noncomputable def concurrence (lam kap : ℝ) : ℝ :=
  2 * ‖coupledDensity lam kap 0 1‖

/-
**The binding defect is the coupling (TARGET).** The spectrum of `Bc(λ,κ)` is
`{λ−κ, λ+κ}`, its least eigenvalue is `λ−κ` (for `0 ≤ κ ≤ λ`), so the binding defect
`Δ = λ − (λ−κ) = κ`.
-/
theorem binding_defect_eq_coupling (lam kap : ℝ) (h : 0 ≤ kap) (hle : kap ≤ lam) :
    spectrum ℂ (Bc lam kap) = {(↑(lam - kap)), (↑(lam + kap))}
      ∧ IsLeast {lam - kap, lam + kap} (lam - kap)
      ∧ lam - (lam - kap) = kap := by
  refine' ⟨ _, _, _ ⟩ <;> norm_num [ IsLeast, mem_lowerBounds ];
  · ext m; simp [Bc];
    rw [ spectrum.mem_iff ];
    norm_num [ Matrix.isUnit_iff_isUnit_det, Matrix.det_fin_two ];
    norm_num [ Algebra.algebraMap_eq_smul_one ];
    exact ⟨ fun hm => or_iff_not_imp_left.mpr fun hnm => mul_left_cancel₀ ( sub_ne_zero_of_ne hnm ) <| by ring_nf; norm_num [ Complex.ext_iff, sq ] at hm ⊢; constructor <;> linarith, fun hm => by rcases hm with ( rfl | rfl ) <;> ring_nf <;> norm_num [ Complex.ext_iff, sq ] ⟩;
  · linarith

/-
**Binding defect = entanglement deficit (TARGET, the prize).** The exact
identity: the binding defect `κ` equals the off-diagonal coherence / concurrence
`C(ρ)` of the normalized coupled density times the aperture `λ`:
`κ = C(ρ)·λ`. Since `C(ρ) = κ/λ` and `tr Bc = 2λ`, this is `Δ = C(ρ)·(tr Bc)/2`.
-/
theorem binding_defect_eq_concurrence (lam kap : ℝ) (h : 0 ≤ kap) (hlt : 0 < lam)
    (hle : kap ≤ lam) :
    kap = concurrence lam kap * lam := by
  unfold concurrence; norm_num [ Bc, coupledDensity ] ; ring;
  norm_num [ abs_of_nonneg h, hlt.ne', Complex.norm_def, Complex.normSq ] ; ring;
  rw [ abs_of_pos hlt, inv_mul_eq_div, div_mul_cancel₀ _ hlt.ne' ]

/-
The coherence has the clean closed form `C(ρ) = κ/λ`.
-/
theorem concurrence_eq (lam kap : ℝ) (h : 0 ≤ kap) (hlt : 0 < lam) :
    concurrence lam kap = kap / lam := by
  unfold concurrence coupledDensity Bc; norm_num [ div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm, h, hlt.ne', abs_of_nonneg, hlt.le ] ; ring;
  norm_num [ Norm.norm, hlt.ne' ];
  exact Or.inl ( by rw [ Real.sqrt_mul_self hlt.le ] ; ring )

/-
**Binds below threshold iff entangled (optional).** The binding defect is
nonzero iff the coupled block is entangled (`κ ≠ 0`), iff the coherence is nonzero.
-/
theorem binding_below_threshold_iff_entangled (lam kap : ℝ) (h : 0 ≤ kap)
    (hlt : 0 < lam) (hle : kap ≤ lam) :
    (lam - (lam - kap) ≠ 0) ↔ concurrence lam kap ≠ 0 := by
  grind +suggestions

-- Axiom footprint checks: each should report only
-- [propext, Classical.choice, Quot.sound].
#print axioms binding_defect_eq_coupling
#print axioms binding_defect_eq_concurrence
#print axioms concurrence_eq
#print axioms binding_below_threshold_iff_entangled

end PhysicsSM.Draft.NullEdge.BindingEntanglementDeficit
