# Summary of changes for run 6e956959-96b0-4ad3-bb82-8c4c5155cdc9
Delivered the T3b Δ binding-energy strategy + design, with a landed kernel-clean result.

## What I found first
The two existing files (`src/FreeMassBridge.lean`, `src/MassGapWitness.lean`) do not build in this handoff: they import external modules `PhysicsSM.Spinor.PluckerMass` and `PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness` that were not included. I left them untouched (they presumably build in the full program). The `B(λ,κ)` spectral theory inside `MassGapWitness.lean` is, however, Mathlib-only and self-contained, so I built the Δ layer on a reproduced copy of it.

## New self-contained, kernel-clean file: `src/DeltaBindingEnergy.lean`
Imports only Mathlib, no `sorry`, standard axioms only (`propext, Classical.choice, Quot.sound`).

- **Δ definition.** `blockGroundMass λ κ := sInf (range eigenvalues of B(λ,κ))` (the squared ground mass / least eigenvalue), and `blockBindingDefect λ κ := blockGroundMass λ κ − blockGroundMass λ 0` — the interacting ground mass minus the free/kinematic baseline. This mirrors exactly what the probe measures (`min spec(interacting) − min spec(free)`); the free baseline is the block-level `det P` via the proved free bridge 0b(a).
- **Headline identity (the quick win): `blockBindingDefect_eq_neg_kappa`** — for `0 ≤ κ ≤ λ`, `Δ_block(λ,κ) = −κ`. Reproduces the numeric `Δ = −t` in the kernel.
- **Corollaries, all proved:** `blockBindingDefect_nonpos` (Δ ≤ 0, binding sign), `blockBindingDefect_neg` (strict for κ>0), `blockBindingDefect_closure_controlled` (exact unit slope in the closure strength — the sharp "governed by closure" claim), `closurePerturbation_offDiagonal` (the closure perturbation `B(λ,κ)−B(λ,0)` has zero diagonal, so the naive constituent estimate is 0 while true Δ=−κ — the off-diagonal-binding fact), `blockGroundMass_massless_line` (ground mass = 0 ↔ κ = λ, the massless critical line), and `blockBindingDefect_pos_imp_neg_kappa` (the kill `Δ>0` forces κ<0).
- Supporting `B`-spectral lemmas (`B_isHermitian`, `B_det`, `B_shift_posSemidef`, `B_shift_det`, `B_least_eigenvalue`) reproduced from the kernel-checked source.

## Strategy document: `src/DELTA_BINDING_ENERGY_STRATEGY.md`
Precise Lean-statable Δ definition with rationale (incl. the general-carrier `Δ(H,P) := λ_min(PᴴHᴬᶜP) − λ_min(PᴴHᴬP)` form); the recommended headline theorem; resolution of "what is det P at the block level" (it is the free ground mass λ, not `det B = λ(λ²−κ²)`, so Δ = (λ−κ)−λ = −κ); a ranked proof plan to lift Δ from the block to the full sector form M6 and to general coupling; and the no-go/kill analysis. Key honest risk identified: the sign result is airtight, but the "Δ is THE physical binding energy" reading rests on the general-(λ,κ) carrier reduction to `B(λ,κ)⊕B(λ,−κ)`, which is kernel-proved only at the fixed point (2,1) and is oracle-grade elsewhere — that reduction, not the sign, is the biggest risk.
