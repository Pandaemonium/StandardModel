# Summary of changes for run 65880e6a-7e77-4ab8-a7e4-3ab7aceaeaf8
Delivered a complete, kernel-checked finite formalization in `RequestProject/Main.lean` (namespace `CPTAntiparticleZigzag`) plus `ARISTOTLE_SUMMARY.md`.

## Model (explicit 4×4 on ℂ⁴, chiral basis; rational/`Complex.I` constants)
- `gamma5 = diag(+1,+1,-1,-1)` — chirality (`+1` = left Weyl `psiL`, `-1` = right Weyl `psiR`).
- `Rmat = [[0,I₂],[I₂,0]]` — real, orthogonal, involutive block-swap that anticommutes with `gamma5`.
- `Dmat m = [[A, m·I₂],[m·I₂, A]]`, `A = [[0,1],[-1,0]]` — Dirac operator; diagonal blocks are the two null Weyl kinetic pieces, off-diagonal `m·I₂` is the mass coupling. Real for real `m`, hence CPT-even.
- `Theta v = Rmat · (conj v)` — the antiunitary CPT operator.

## Headline theorems (all proved, no `sorry`)
1. `theta_antiunitary` — `Theta` is additive, conjugate-homogeneous (`Theta (c•v) = conj c • Theta v`), and an involution.
2. `theta_swaps_weyl` — `Theta` is chirality-odd (`gamma5 (Theta v) = - Theta (gamma5 v)`), so CPT exchanges the two null pieces; with explicit nonzero witness `e₀=(1,0,0,0)` (chirality +1) → `Theta e₀=(0,0,1,0)` (chirality −1), stated in-theorem.
3. `spectrum_conjugate_paired` — `Dmat m · v = λ v`, `v≠0` ⟹ `Dmat m · (Theta v) = conj λ · (Theta v)` with `Theta v ≠ 0`.
4. `concrete_conjugate_pair` — explicit eigenpair `(1+i,(1,i,1,i))` mirrors to `(1−i,(1,−i,1,−i))`; both nonzero.
5. `antiparticle_verdict` — packages the above: matter/antimatter are the two CPT-orientations of the same null-edge pair; CPT swaps the null pieces and conjugates the spectrum; mass coupling CPT-even (`Θ D Θ = D`, same `m`). Honest scope: a finite one-carrier CPT statement, not a baryogenesis mechanism.

## Verification
- Full project builds successfully (well under 3 min) with no warnings or errors.
- No `sorry`/`admit`/`native_decide`/new `axiom`/`@[implemented_by]`.
- Each headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`.
All work committed and pushed.

# CPT antiparticle as the CPT-mirror zigzag — summary

A self-contained finite matrix-algebra formalization (Mathlib only, kernel-checked) of the claim
that the antiparticle of a massive fermion is its CPT-conjugate zigzag: particle and antiparticle
are the two CPT-orientations of the *same* null-edge (Weyl) pair, with conjugate-paired spectra.

All content is in `RequestProject/Main.lean`, namespace `CPTAntiparticleZigzag`.

## The explicit model (on `ℂ⁴`, chiral basis)

- `gamma5 = diag(+1,+1,-1,-1)` — chirality; `+1`-eigenspace is the left Weyl piece `psiL`,
  `-1`-eigenspace the right Weyl piece `psiR`.
- `Rmat = [[0, I₂],[I₂, 0]]` — real, orthogonal, involutive block-swap; anticommutes with `gamma5`.
- `Dmat m = [[A, m·I₂],[m·I₂, A]]` with `A = [[0,1],[-1,0]]` — the Dirac operator: diagonal blocks
  are the two null Weyl kinetic pieces, the off-diagonal `m·I₂` is the mass coupling of the zigzag.
  For real `m` its entries are real, hence CPT-even.
- `Theta v = Rmat · (conj v)` — the antiunitary CPT operator.

All matrix entries are rational / `Complex.I` constants; every proof reduces to
`fin_cases` + `simp` + `ring` on the four concrete components.

## Results (headline theorems)

1. `theta_antiunitary` — `Theta` is additive, conjugate-homogeneous
   (`Theta (c • v) = conj c • Theta v`), and an involution (`Theta (Theta v) = v`).
2. `theta_swaps_weyl` — `Theta` is chirality-odd: `gamma5 (Theta v) = - Theta (gamma5 v)`, so CPT
   exchanges the two null Weyl pieces. Non-degeneracy witness: the nonzero left vector
   `e₀ = (1,0,0,0)` (chirality `+1`) maps to the nonzero right vector `Theta e₀ = (0,0,1,0)`
   (chirality `-1`).
3. `spectrum_conjugate_paired` — if `Dmat m · v = λ v` with `v ≠ 0`, then
   `Dmat m · (Theta v) = (conj λ) (Theta v)` with `Theta v ≠ 0`. Particle/antiparticle energies
   are conjugate-paired.
4. `concrete_conjugate_pair` — explicit eigenpair `(1+i, (1,i,1,i))` for `m = 1` mirrors to
   `(1-i, (1,-i,1,-i))` via `Theta`; both vectors nonzero.
5. `antiparticle_verdict` — packages the above: matter/antimatter are the two CPT-orientations of
   the same null-edge pair; CPT swaps the two null pieces and conjugates the spectrum; the mass
   coupling is CPT-even (same `m`, `Θ D Θ = D`). Particle vs. antiparticle is the *orientation* of
   the zigzag, so matter–antimatter asymmetry is a state/initial-condition question, not a law
   asymmetry.

## Honest scope

This is a finite one-carrier CPT statement on an explicit `4×4` model — not a baryogenesis mechanism.

## Verification

- Builds under the stated toolchain in well under 3 minutes.
- No `sorry` / `admit` / `native_decide` / new `axiom` / `@[implemented_by]`.
- Each headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` check
  confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`.
