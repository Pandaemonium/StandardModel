# claude-zigzag-automaton — the chirality zigzag as a finite weighted automaton; mass = spectral gap = flip rate (CSLib path-semantics port)

## CRITICAL SCOPE GUARD (read first)
This job is NOT about Weyl/Dirac gamma-matrix operators. Do NOT build `gamma5`, `Dkin`, `Dmass`,
`chiralFlip`, Weyl symbols, or any 4x4 Dirac operator, and do NOT use the namespace `ZigzagWeyl` or the
theorem names `massless_decouples`/`mass_couples`/`zigzag_verdict`. Build ONLY the finite 2x2 STOCHASTIC
TRANSFER MATRIX `T a = !![1-a, a; a, 1-a]` described below (a classical Markov/automaton, NOT a spinor
operator). Namespace MUST be `ZigzagAutomaton`. The payloads are `spectral_gap` and
`massless_iff_reducible` on `T a` — nothing about Clifford algebra.

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

Port the finite weighted-automaton / transfer-operator view (as in the CSLib automata / path-semantics
program) -- reference/provenance, NOT an import (version-pinned). The Penrose zigzag of a massive
fermion is, at the classical-stochastic level, a 2-STATE automaton on the chirality label {L, R}: mass
is the chirality-FLIP transition, massless is the absorbing/reducible case where L and R never mix (two
independent luminal channels). Prove the finite, RATIONAL transfer-matrix version: mass = the spectral
gap of the transfer operator = the flip rate; massless <=> zero gap <=> reducible.

## The model (finite, rational; 2x2 transfer/transition operator)

Chirality states `{0=L, 1=R}`. Transfer operator `T a = !![1 - a, a; a, 1 - a]` for `a : Q` (the
flip parameter, `0 <= a <= 1`; `a` is the mass proxy -- the per-step chirality-flip weight). `T` is
symmetric, row-stochastic (`(1-a)+a=1`), and doubly stochastic.

## Targets (rational; ring/norm_num/decide/fin_cases; NO Real transcendental, NO Complex, NO nlinarith deg>=3)

1. `transfer_stochastic`: `T a` is doubly stochastic (each row and column sums to `1`) and symmetric,
   for any `a`. And `T 0 = 1` (identity), `T a` at `a=1/2` is the uniform-mixing `!![1/2,1/2;1/2,1/2]`.
   By `Fin.sum_univ_two`/`decide`/`ring`.
2. `spectral_gap` (payload): the eigenvalues of `T a` are `1` (eigenvector `![1,1]`, the stationary/
   uniform mode) and `1 - 2a` (eigenvector `![1,-1]`, the chirality-antisymmetric mode). Prove by
   `mulVec` on the explicit eigenvectors (`T a *v ![1,1] = ![1,1]`, `T a *v ![1,-1] = (1-2a) . ![1,-1]`).
   The SPECTRAL GAP is `1 - (1 - 2a) = 2a` -- the mass proxy.
3. `massless_iff_reducible` (payload): `a = 0 <-> T a = 1 <-> the two chiralities never mix`
   (`(T 0) *v ![1,0] = ![1,0]` and `(T 0) *v ![0,1] = ![0,1]`: each pure-chirality state is a fixed
   point -- an ABSORBING/reducible automaton, two independent luminal channels); and for `a > 0` the
   off-diagonal is nonzero so a pure-chirality state is NOT fixed (`(T a) *v ![1,0] != ![1,0]`) -- the
   zigzag mixes. So `mass = 0 <-> gap = 0 <-> reducible`, `mass > 0 <-> gap > 0 <-> irreducible mixing`.
4. `zigzag_automaton_verdict`: package -- the massive fermion's chirality dynamics is a finite weighted
   automaton whose transfer operator `T a` has spectral gap `2a` = the mass proxy; massless is the
   reducible fixed-point case (two luminal channels that never talk), massive is the mixing case (the
   zigzag). Honest scope: a finite classical-stochastic avatar of the chirality zigzag (complementary to
   the unitary quantum-walk transfer operator elsewhere); provenance = CSLib path semantics / weighted
   automata. Not a claim about the physical flip rate's value.

MANDATORY non-degeneracy: explicit rational `a` values -- `a=0` (massless, `T=I`, gap 0, both pure
states fixed), `a=1/2` (uniform mixing, gap 1), `a=1/4` (gap 1/2, pure state NOT fixed); the eigenvector
computations as explicit rationals. All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (CSLib is a REFERENCE, not an
import). Footprint exactly [propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace :=
lax) in #print axioms <thm>` on every headline. Rational `2x2` `Matrix` + `mulVec` + `Fin.sum_univ_two`;
ring/norm_num/decide/fin_cases; NO Real.sqrt/cos/sin, NO Complex, NO nlinarith deg>=3. Build under 3 min.
Deliver RequestProject/Main.lean (namespace ZigzagAutomaton) + ARISTOTLE_SUMMARY.md WITH the CSLib
provenance line.
