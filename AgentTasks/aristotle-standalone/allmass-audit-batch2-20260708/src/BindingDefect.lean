/-
# The Δ binding-energy invariant (T3b): closure lowers the ground mass by exactly κ

DRAFT (kernel-clean; no `s o r r y`). Promotes the T3b/0b-b binding defect from a
numeric-oracle observation (`Scripts/oracle/probe_bridge_binding_energy.py`,
`DELTA_BINDING_ENERGY_FINDING.md`) to a **kernel theorem at the block level**.

The §3↔§4 bridge splits: the *free* half (0b-a) is proved
(`FreeMassBridge.free_mass_operator_eq_plucker` — the free operator mass IS the
kinematic Plücker mass `det P`); the *interacting* half fails by a binding defect
`Δ`. On the carrier sector mass block `MassGapWitness.B λ κ` (aperture `λ`, closure
`κ`), the binding defect is exactly

  `Δ_block(λ,κ) = (block ground mass) − (free baseline) = (λ − κ) − λ = −κ`,

for `0 ≤ κ ≤ λ`. So closure **lowers** the ground mass by exactly its strength — a
genuine *binding* sign (Δ ≤ 0), *closure-controlled* (unit slope in κ), and
**off-diagonal** (`B(λ,κ) − B(λ,0)` has zero diagonal, so the naive additive
estimate is 0 while Δ = −κ). This is the finite shadow of "a bound state's mass is
not naively assembled from its constituents", and exactly why the naive additive
bridge `0b` fails. The pre-registered kill (`Δ > 0`) is impossible on the physical
branch (it would force `κ < 0`, anti-binding).

## Scope / honest risk

`Δ = −κ` is airtight at the block level. The reading "`Δ` is *the* physical binding
energy of the carrier" rests on the general-`(λ,κ)` reduction of the carrier to
`B(λ,κ) ⊕ B(λ,−κ)`, which is kernel-checked only at `(2,1)`
(`MassGapWitness.M6_topBlock_eq_B`) and oracle-grade off it. That reduction, not
the sign, is the biggest risk (grade **C** for the physical identification).

## Provenance

All-mass solo run 2026-07-08 [orig]. Statements/design by the reviewing agent;
the Δ-layer proofs are from Aristotle (standalone package
`AgentTasks/aristotle-standalone/allmass-strategy-binding-20260708`), reviewed for
semantic alignment and adopted here, re-based onto the kernel-checked
`MassGapWitness.B` (the package reproduced `B` + its spectral lemmas because it
could not import the project). Builds on `MassGapWitness`.
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness

namespace PhysicsSM.Draft.NullEdge.Carrier.BindingDefect

open Matrix Complex
open scoped ComplexOrder
open PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness

/-- The **block ground mass**: the least eigenvalue of the sector mass block
`B(λ,κ)`, i.e. the squared ground mass of the block. On the physical branch
`0 ≤ κ ≤ λ` this equals `λ − κ` (`blockGroundMass_eq`). -/
noncomputable def blockGroundMass (lam kappa : ℝ) : ℝ :=
  sInf (Set.range (B_isHermitian lam kappa).eigenvalues)

/-- On the physical branch `0 ≤ κ ≤ λ` the block ground mass is `λ − κ`. -/
theorem blockGroundMass_eq (lam kappa : ℝ) (h0 : 0 ≤ kappa) (hlk : kappa ≤ lam) :
    blockGroundMass lam kappa = lam - kappa :=
  (B_least_eigenvalue lam kappa h0 hlk).csInf_eq

/-- The **free/kinematic baseline**: closure off. `blockGroundMass λ 0 = λ` (the
least eigenvalue of `B(λ,0) = λ•1`), which in the free case equals the kinematic
Plücker mass `det P` (`FreeMassBridge.free_mass_operator_eq_plucker`). -/
theorem blockGroundMass_free (lam : ℝ) (hlam : 0 ≤ lam) :
    blockGroundMass lam 0 = lam := by
  simpa using blockGroundMass_eq lam 0 le_rfl hlam

/-- **The Δ binding-defect invariant** (block level): the interacting ground mass
minus the free/kinematic baseline — the block analog of the finding's
`Δ := min spec(D#D|P) − det P`. -/
noncomputable def blockBindingDefect (lam kappa : ℝ) : ℝ :=
  blockGroundMass lam kappa - blockGroundMass lam 0

/-- **THE MAIN IDENTITY: `Δ_block(λ,κ) = −κ`.** For `0 ≤ κ ≤ λ` the binding defect
equals *minus the closure strength* — reproducing the numeric `Δ = −t`. Negative
(binding), closure-controlled (unit slope in κ), and zero in the free case. -/
theorem blockBindingDefect_eq_neg_kappa (lam kappa : ℝ) (h0 : 0 ≤ kappa)
    (hlk : kappa ≤ lam) : blockBindingDefect lam kappa = -kappa := by
  unfold blockBindingDefect
  rw [blockGroundMass_eq lam kappa h0 hlk, blockGroundMass_free lam (le_trans h0 hlk)]
  ring

/-- **Binding sign.** `Δ ≤ 0`: closure *lowers* the ground mass — the sign of a
binding energy, not an additive constituent mass. -/
theorem blockBindingDefect_nonpos (lam kappa : ℝ) (h0 : 0 ≤ kappa)
    (hlk : kappa ≤ lam) : blockBindingDefect lam kappa ≤ 0 := by
  rw [blockBindingDefect_eq_neg_kappa lam kappa h0 hlk]; linarith

/-- **Strict binding** whenever closure is genuinely on (`κ > 0`). -/
theorem blockBindingDefect_neg (lam kappa : ℝ) (h0 : 0 < kappa)
    (hlk : kappa ≤ lam) : blockBindingDefect lam kappa < 0 := by
  rw [blockBindingDefect_eq_neg_kappa lam kappa h0.le hlk]; linarith

/-- **Closure control (exact linearity).** The binding defect has unit slope in
the closure strength: increasing closure by `Δκ` lowers the ground mass by exactly
`Δκ` — the sharp form of "`Δ` is governed by the closure sector." -/
theorem blockBindingDefect_closure_controlled (lam kappa₁ kappa₂ : ℝ)
    (h1 : 0 ≤ kappa₁) (hlk1 : kappa₁ ≤ lam) (h2 : 0 ≤ kappa₂) (hlk2 : kappa₂ ≤ lam) :
    blockBindingDefect lam kappa₂ - blockBindingDefect lam kappa₁ = -(kappa₂ - kappa₁) := by
  rw [blockBindingDefect_eq_neg_kappa lam kappa₂ h2 hlk2,
      blockBindingDefect_eq_neg_kappa lam kappa₁ h1 hlk1]; ring

/-- **Kill-condition boundary.** On the physical branch `κ ≥ 0` the pre-registered
kill `Δ_block > 0` is *impossible*: a positive binding defect forces `κ < 0`
(anti-binding closure). So the binding-energy reading is safe on the physical
branch; the only way to break it is to flip the sign of the closure coupling. -/
theorem blockBindingDefect_pos_imp_neg_kappa (lam kappa : ℝ) (hlk : kappa ≤ lam)
    (h : 0 < blockBindingDefect lam kappa) : kappa < 0 := by
  by_contra hc
  push_neg at hc
  linarith [blockBindingDefect_nonpos lam kappa hc hlk]

/-- **Off-diagonal binding.** The closure perturbation `B(λ,κ) − B(λ,0)` has *zero
diagonal*: the naive constituent (first-order diagonal) estimate of the ground
-mass shift is `0` in every standard basis direction, yet the true `Δ = −κ`. The
finite shadow of "binding lives off-diagonal in the free basis" — exactly why the
naive additive bridge `0b` fails. -/
theorem closurePerturbation_offDiagonal (lam kappa : ℝ) (i : Fin 3) :
    (B lam kappa - B lam 0) i i = 0 := by
  fin_cases i <;> simp [B]

/-- **Massless critical line.** The block ground mass vanishes exactly when closure
equals aperture, `κ = λ` (a massless bound state), for `0 ≤ κ ≤ λ`. -/
theorem blockGroundMass_massless_line (lam kappa : ℝ) (h0 : 0 ≤ kappa)
    (hlk : kappa ≤ lam) : blockGroundMass lam kappa = 0 ↔ kappa = lam := by
  rw [blockGroundMass_eq lam kappa h0 hlk]
  constructor <;> intro h <;> linarith

end PhysicsSM.Draft.NullEdge.Carrier.BindingDefect
