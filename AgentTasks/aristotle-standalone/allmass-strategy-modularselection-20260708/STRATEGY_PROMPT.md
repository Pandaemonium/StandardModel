# Strategy + proof: modular selection — derive the D2 generator instead of positing it (Conjecture J)

## Context (blind to the wider repo)

A finite null-edge program's dynamics layer D2 takes the sector mass form `B` as the
generator of `exp(-i t B)` — flagged as a *posit* (caveat i). Connes–Rovelli thermal
time on a FINITE space makes this computable: the max-entropy (Gibbs) state at fixed
budget expectation `⟨B⟩` is `ρ ∝ exp(-β B)`, and its **modular flow is exactly the
`exp(-i t B)` flow**. So the generator is selected by the state, and the state by the
program's own relative-entropy/DPI layer — not posited.

## Targets

1. **`modular_flow_of_gibbs` (the core M-target).** For a finite Gibbs state
   `ρ = exp(-β B)/Z` with `B` Hermitian, the Tomita–Takesaki / modular automorphism
   group is `σ_t(X) = ρ^{it} X ρ^{-it} = exp(itB) X exp(-itB)` (up to the `β`
   rescaling of time). Prove the finite statement: the modular flow of the Gibbs
   state in `B` **is** the `B`-generated Heisenberg flow. This *derives* the D2
   generator from the state.
2. **Channel-GGE / equipartition (the new well-posed question).** Fixing the four
   channel shares `⟨Q_A⟩, ⟨Q_C⟩, ⟨Q_T⟩, ⟨E⟩` separately yields a generalized Gibbs
   ensemble `ρ ∝ exp(-(λ_A Q_A + λ_C Q_C + λ_T Q_T + λ_E E))` with channel chemical
   potentials. Prove: the modular flow is `B`-generated **iff** the channels
   equilibrate to one common inverse temperature (`λ_A = λ_C = λ_T = λ_E = β`, so the
   GGE collapses to `exp(-βB)` when `B = Q_A+Q_C+Q_T+E`). "Do the four channels
   thermalize to a common β?" is a new finite, well-posed dynamics question.

**Kill (Conjecture J):** the KMS-selected generator on the T2 sector is provably NOT
proportional to `B` under any channel-share constraint.

## Constraints

Kernel-checked only for proofs: no `sorry`/`admit`/`native_decide`/new `axiom`;
footprint `[propext, Classical.choice, Quot.sound]`, guarded with in-file
`#print axioms`. Mathlib only; small finite matrices. Deliver Lean file(s) +
`ARISTOTLE_SUMMARY.md`: the modular-flow-of-Gibbs theorem, the channel-GGE
equipartition criterion, and an honest boundary (this selects the generator finitely;
the continuum thermal-time hypothesis stays [import]).
