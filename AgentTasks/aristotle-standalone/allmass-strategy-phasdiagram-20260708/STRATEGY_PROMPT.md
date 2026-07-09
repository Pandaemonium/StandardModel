# Strategy + proof: the multi-channel mass phase diagram (P-B)

## Context (blind to the wider repo)

A finite null-edge Dirac program proves that a carrier's mass-gap block is
`B(λ,κ) = !![λ, κi, 0; −κi, λ, 0; 0, 0, λ]` (aperture `λ`, closure `κ`), with spectrum
`{λ−κ, λ, λ+κ}` and a **finite three-phase diagram** (already kernel-checked): massive
`|κ| < λ` (positive-definite), critical `|κ| = λ` (singular, massless line), and
over-closure `|κ| > λ` (a negative eigenvalue `λ−κ`, tachyonic/unphysical).

The carrier square has **four** channels, not two: aperture `Q_A` (kinetic,
positive), closure `Q_C` (signed), turn `Q_T = φ²` (Higgs/Yukawa-shaped, a
chirality-flip mass), soldering `E_#` (geometry). The frontier is to promote the
`(λ,κ)` block to a **multi-channel mass phase diagram** and classify its phases.

## Your task

1. **Construct the natural four-parameter Hermitian block** `B₄(λ, κ, τ, ε)`
   extending `B(λ,κ)` with a turn parameter `τ` (a chirality-flip / off-diagonal mass
   coupling — `Q_T = φ²` acts as a positive diagonal mass shift in the flipped basis,
   or an off-diagonal `τ` between chiral partners) and a soldering parameter `ε` (the
   `E_#` coupling). Pick the cleanest faithful form; state it explicitly. (A natural
   choice: a `4×4` or `6×6` Hermitian block that reduces to `B(λ,κ)` at `τ=ε=0` and
   whose diagonal/off-diagonal entries carry the four channel strengths.)
2. **Compute its spectrum / positivity** as a function of `(λ, κ, τ, ε)` — the
   characteristic polynomial or eigenvalues, and the positive-definite region.
3. **Classify the mass phases** as kernel theorems:
   - aperture-dominated **massive** (positive-definite),
   - closure-cancelled **critical** (a boundary surface where the least eigenvalue
     hits 0 — generalize `|κ| = λ`),
   - turn-dominated **massive** (mass from `τ`, positive),
   - **indefinite/unphysical** (a negative eigenvalue, no positive mass sector).
   Prove the phase-boundary surface (the massless critical surface in
   `(λ,κ,τ,ε)`-space) and the positivity criterion (e.g. via Sylvester / leading
   minors, or the eigenvalue formulas).

The prize: **a finite, exactly-solvable four-channel mass phase diagram** — the seed
of "which phase is a particle in, and what protects or destabilizes it."

## Constraints

Kernel-checked only for proofs: no `sorry`/`admit`/`native_decide`/new `axiom`;
footprint `[propext, Classical.choice, Quot.sound]`, guarded with in-file
`#print axioms`. Mathlib only; pinned toolchain you scaffold. Deliver Lean file(s) +
axiom prints + `ARISTOTLE_SUMMARY.md`: the block `B₄`, its spectrum/positivity
criterion, the classified phases with the critical surface, and honestly which
channels you could give a faithful matrix form and which stayed schematic.
