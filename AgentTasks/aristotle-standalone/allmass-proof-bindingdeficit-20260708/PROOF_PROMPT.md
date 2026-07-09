# Proof/strategy: binding defect = entanglement deficit (F8)

## Context (blind to the wider repo)

A finite null-edge program has proved: (i) the mass-gap block `B(λ,κ)` has spectrum
`{λ−κ, λ, λ+κ}`, so binding (the off-diagonal coupling `κ`) lowers the ground mass
by a **binding defect** `Δ = λ − (λ−κ) = κ` with *no* diagonal mass term; and (ii)
mass IS the null bundle's **concurrence** (`det P = (C/2)²` two-edge; `det P =
(G/n)ⁿ` n-edge, Gour G-concurrence). This job targets the identification the program
pre-registers as grade **C**: **the binding defect equals an entanglement deficit** —
the mass removed by binding equals the concurrence-type entanglement created between
the coupled modes.

## Targets (`src/BindingEntanglementDeficit.lean`)

Binding lives in the coupled `2×2` block `Bc(λ,κ) = !![λ, κi; −κi, λ]` (eigenvalues
`λ ± κ`).

1. `binding_defect_eq_coupling`: prove the binding defect is `κ` — the least
   eigenvalue of `Bc(λ,κ)` is `λ − κ` for `0 ≤ κ ≤ λ`, so `Δ = λ − (λ−κ) = κ`.
   (Replace the `True` placeholder with the exact `IsHermitian.eigenvalues` / spectral
   statement.)
2. `binding_defect_eq_concurrence` (the prize): find and prove the exact identity
   `Δ = (entanglement measure of the coupled block)`. The natural measure is the
   **concurrence / off-diagonal coherence** of the normalized coupled density
   `ρ = Bc / tr Bc`: `2|ρ₀₁| = κ/λ`, so `Δ = κ = (κ/λ)·λ = 2|ρ₀₁|·(tr Bc)/2`.
   Determine the cleanest exact normalization and prove it. The point: the mass lost
   to binding (`κ`) is *exactly* the entanglement (concurrence-type coherence) gained
   between the coupled modes.
3. Optional: binds-below-threshold **iff** entangled (`κ ≠ 0`).

You have latitude to restate the "entanglement measure" in whatever standard form
(Wootters concurrence of the associated two-qubit state, linear entropy / tangle
`4 det ρ`, or off-diagonal coherence) makes the identity cleanest and true — but
STATE it explicitly and make the claim exact, not approximate.

## Constraints

Kernel-checked only: no `sorry`/`admit`/`native_decide`/new `axiom`; footprint
`[propext, Classical.choice, Quot.sound]`, guarded with in-file `#print axioms`.
Mathlib only. Deliver the file + axiom prints + `ARISTOTLE_SUMMARY.md` stating the
exact entanglement measure used, the final identity, and honestly whether "binding
defect = entanglement deficit" holds as a clean equality or only up to a stated
normalization / under an extra hypothesis.
