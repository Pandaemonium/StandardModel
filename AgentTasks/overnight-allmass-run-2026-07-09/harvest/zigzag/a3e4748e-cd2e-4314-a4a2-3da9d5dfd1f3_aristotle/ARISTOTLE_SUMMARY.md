# Summary of changes for run a3e4748e-cd2e-4314-a4a2-3da9d5dfd1f3
Delivered `RequestProject/Main.lean` (namespace `ZigzagAutomaton`) and `ARISTOTLE_SUMMARY.md` with the CSLib provenance line. The file builds cleanly under Mathlib only, with no `sorry`/`admit`/`native_decide`/new axioms, in well under 3 minutes.

The chirality zigzag is modeled as a 2-state finite weighted automaton on `{0=L, 1=R}` with the rational transfer operator `T a = !![1-a, a; a, 1-a]` (`a : ℚ` the flip/mass proxy). Proved:

1. `transfer_stochastic` — `T a` is doubly stochastic (rows and columns sum to 1) and symmetric; plus `T_zero : T 0 = 1` and `T_half : T (1/2) = !![1/2,1/2;1/2,1/2]`.
2. `spectral_gap` (payload) — eigenvalue 1 on `![1,1]` (`eig_sym`) and eigenvalue `1-2a` on `![1,-1]` (`eig_asym`), via explicit `mulVec`; the spectral gap `spectralGap a = 1-(1-2a) = 2a`, the mass proxy.
3. `massless_iff_reducible` (payload) — `a=0 ↔ T a = 1`; at `a=0` both pure states are fixed (`T_zero_fix_L`, `T_zero_fix_R`) with gap 0 (reducible / two luminal channels), while for `a≠0` the pure-L state is not fixed (`T_pos_not_fix_L`).
4. `zigzag_automaton_verdict` — packages stochasticity+symmetry, the eigen-decomposition with gap `2a`, and massless↔reducible / massive↔mixing.

Mandatory non-degeneracy checks with explicit rationals: `check_massless` (a=0), `check_half` (a=1/2, gap 1), `check_quarter` (a=1/4, gap 1/2, pure state not fixed).

All proofs use ring/norm_num/fin_cases/simp over rational 2×2 matrices with `mulVec` and `Fin.sum_univ_two`; no Real/Complex/transcendental functions and no high-degree nlinarith. Every headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`. The summary documents the honest scope (a finite classical-stochastic avatar of the chirality zigzag, not a claim about the physical flip rate) and the CSLib provenance. All committed and pushed.

# claude-zigzag-automaton — the chirality zigzag as a finite weighted automaton

**Provenance (reference, version-pinned; NOT an import):** CSLib path semantics /
weighted automata program. This file is a self-contained Mathlib-only port of the
finite weighted-automaton / transfer-operator view of the Penrose zigzag of a
massive fermion; CSLib is cited for provenance only and is never imported.

## What is proved (`RequestProject/Main.lean`, namespace `ZigzagAutomaton`)

The chirality zigzag is modeled as a 2-state automaton on `{0 = L, 1 = R}` with
rational transfer operator `T a = !![1 - a, a; a, 1 - a]`, where `a : ℚ` is the
flip parameter (the mass proxy).

1. **`transfer_stochastic`** — `T a` is doubly stochastic (every row and column
   sums to `1`) and symmetric (`(T a)ᵀ = T a`), for every `a`. Special values:
   `T_zero : T 0 = 1` (identity) and `T_half : T (1/2) = !![1/2,1/2;1/2,1/2]`
   (uniform mixing).

2. **`spectral_gap`** (payload) — eigenvalues of `T a` are `1` with eigenvector
   `![1,1]` (the stationary/uniform mode, `eig_sym`) and `1 - 2a` with eigenvector
   `![1,-1]` (the chirality-antisymmetric mode, `eig_asym`). The spectral gap
   `spectralGap a = 1 - (1 - 2a) = 2a` — the mass proxy.

3. **`massless_iff_reducible`** (payload) — `a = 0 ↔ T a = 1`; at `a = 0` each
   pure-chirality state is fixed (`T_zero_fix_L`, `T_zero_fix_R`) with gap `0`
   (absorbing/reducible: two independent luminal channels); for `a ≠ 0` the
   pure-`L` state is not fixed (`T_pos_not_fix_L`) — the zigzag mixes.

4. **`zigzag_automaton_verdict`** — packages the above: doubly-stochastic +
   symmetric transfer operator, eigen-decomposition with gap `2a`, and
   massless ↔ reducible / massive ↔ mixing.

**Non-degeneracy (explicit rationals):** `check_massless` (`a=0`: `T=I`, gap `0`,
both pure states fixed), `check_half` (`a=1/2`: uniform mixing, gap `1`),
`check_quarter` (`a=1/4`: gap `1/2`, pure-`L` state not fixed).

## Honest scope

This is a finite classical-stochastic avatar of the chirality zigzag,
complementary to a unitary quantum-walk transfer operator. It is **not** a claim
about the physical flip rate's numerical value.

## Verification

Kernel-checked, Mathlib-only, no `sorry`/`admit`/`native_decide`/new axiom; all
proofs by `ring`/`norm_num`/`fin_cases`/`simp` over rational `2×2` matrices with
`mulVec` and `Fin.sum_univ_two`. Each headline carries an in-file
`#guard_msgs (whitespace := lax) in #print axioms …` pinning the footprint to
exactly `[propext, Classical.choice, Quot.sound]`.
