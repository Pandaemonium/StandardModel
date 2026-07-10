# Summary of changes for run edac6c44-872e-4ab5-a6c1-1d2937b5df1d
Implemented the chirality-zigzag finite weighted automaton in `RequestProject/Main.lean` (namespace `ZigzagAutomaton`), building only the 2×2 rational stochastic transfer matrix `T a = !![1-a, a; a, 1-a]` over ℚ — a classical Markov/automaton operator, with no Dirac/Clifford/Weyl content.

Proved (all kernel-checked, no `sorry`/`admit`/`native_decide`/new axioms):
- `transfer_stochastic`: `T a` is doubly stochastic (row and column sums = 1) and symmetric for all `a`; `T 0 = 1`; `T (1/2)` is the uniform-mixing matrix.
- `spectral_gap` (payload): eigenvector computations via `mulVec` giving eigenvalue `1` (mode `![1,1]`) and eigenvalue `1-2a` (mode `![1,-1]`), so the spectral gap is `2a`, the mass proxy.
- `massless_iff_reducible` (payload): `a = 0 ↔ T a = 1`; at `a=0` both pure-chirality states are fixed (reducible/absorbing, two luminal channels); for `a ≠ 0` a pure-chirality state is not fixed (mixing).
- `zigzag_explicit`: mandatory non-degeneracy with explicit rationals `a=0`, `a=1/2`, `a=1/4`.
- `zigzag_automaton_verdict`: packaged verdict.

Techniques used: `Fin.sum_univ_two`, `mulVec`/`dotProduct`, `fin_cases`, `simp`, `norm_num`, `ring` — no Real transcendentals, no Complex, no high-degree nlinarith. Each headline theorem carries an in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>` confirming the axiom footprint is exactly `[propext, Classical.choice, Quot.sound]`; the build enforces these guards and passes with no errors or sorries. Added `ARISTOTLE_SUMMARY.md` including the CSLib path-semantics / weighted-automata provenance line and the honest-scope note. Everything is committed and pushed.

# claude-zigzag-automaton — the chirality zigzag as a finite weighted automaton

**Provenance (reference only, NOT an import):** the finite weighted-automaton /
transfer-operator view of the CSLib path-semantics / weighted-automata program.
The Penrose zigzag of a massive fermion is treated, at the classical-stochastic
level, as a 2-state automaton on the chirality label `{L, R}`.

All results live in `RequestProject/Main.lean`, namespace `ZigzagAutomaton`.

## The model

Chirality states `{0 = L, 1 = R}`. The rational transfer/transition operator is

```
T a = !![1 - a, a; a, 1 - a]     (a : ℚ, the flip parameter / mass proxy)
```

a symmetric, doubly-stochastic 2×2 Markov matrix. This is a classical
Markov/automaton transfer matrix — **not** a spinor/Dirac operator.

## Results proved (all kernel-checked, no `sorry`/`admit`/`native_decide`/new axiom)

1. **`transfer_stochastic`** — `T a` is doubly stochastic (every row and every
   column sums to `1`) and symmetric (`(T a)ᵀ = T a`) for all `a`; also `T 0 = 1`
   (identity) and `T (1/2) = !![1/2,1/2;1/2,1/2]` (uniform mixing).

2. **`spectral_gap`** (payload) — eigenvector computations by `mulVec`:
   `T a *ᵥ ![1,1] = ![1,1]` (eigenvalue `1`, uniform/stationary mode) and
   `T a *ᵥ ![1,-1] = (1 - 2a) • ![1,-1]` (eigenvalue `1 - 2a`, antisymmetric mode).
   Hence the **spectral gap is `1 - (1 - 2a) = 2a`**, the mass proxy.

3. **`massless_iff_reducible`** (payload) — `a = 0 ↔ T a = 1`; when `a = 0` each
   pure-chirality state is fixed (`T 0 *ᵥ ![1,0] = ![1,0]`, `T 0 *ᵥ ![0,1] = ![0,1]`:
   absorbing/reducible automaton, two independent luminal channels); and for
   `a ≠ 0` a pure-chirality state is NOT fixed (`T a *ᵥ ![1,0] ≠ ![1,0]`), i.e.
   the zigzag mixes. So mass `= 0 ↔` gap `= 0 ↔` reducible; mass `≠ 0 ↔` gap `≠ 0 ↔`
   irreducible mixing.

4. **`zigzag_explicit`** (mandatory non-degeneracy) — explicit rational values:
   `a = 0` (massless, `T = I`, gap `0`, both pure states fixed), `a = 1/2`
   (uniform mixing, gap `1`, antisymmetric eigenvalue `0`), `a = 1/4` (gap `1/2`,
   pure state not fixed).

5. **`zigzag_automaton_verdict`** — packaged verdict combining the stochasticity,
   the eigenvalue/gap data, and the massless⇔reducible dichotomy.

## Honest scope

A finite classical-stochastic avatar of the chirality zigzag (complementary to a
unitary quantum-walk transfer operator). It is not a claim about the physical
flip rate's value.

## Verification

- Built with Lean `v4.28.0` + Mathlib, `lake build` succeeds with no errors.
- Techniques: rational `Matrix (Fin 2) (Fin 2) ℚ`, `mulVec`/`dotProduct`,
  `Fin.sum_univ_two`, `fin_cases`, `simp`, `norm_num`, `ring` — no `Real.sqrt`/
  `cos`/`sin`, no `Complex`, no high-degree `nlinarith`.
- Axiom footprint of every headline theorem is exactly
  `[propext, Classical.choice, Quot.sound]`, checked in-file by
  `#guard_msgs (whitespace := lax) in #print axioms <thm>`.
