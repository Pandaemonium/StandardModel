# claude-kraft-compression-mass — mass is a compression cost: a finite Kraft bound on the null-direction message

## Context (blind to any repo; self-contained finite combinatorics/algebra, Mathlib only)

The program reads mass as the compression cost of a null-direction message. Make this precise with
a finite KRAFT bound (clean-room port of the Kraft inequality / entropy <= expected code length,
in the STYLE of the `kraft` Lean package (github elazarg/kraft) -- reference/provenance, not an
import). A prefix code assigning code-length `l_i` to null-direction symbol `i` obeys the Kraft
inequality `sum 2^{-l_i} <= 1`; the visible direction state's mixedness (linear entropy = mass^2)
lower-bounds the compressibility. Prove the finite Kraft core + the mass reading.

## The model (finite, rational; avoid log -- use dyadic/rational forms)

`n` null-direction symbols with rational weights `p_i >= 0`, `sum p_i = 1`, and integer code
lengths `l : Fin n -> Nat`. Kraft sum `K l = sum_i (1/2)^(l_i)` (rational). Linear entropy of the
weights `Hlin p = 1 - sum p_i^2` (the mass^2 invariant, rational -- NOT the log entropy).

## Targets (rational; no log/transcendentals)

1. `kraft_inequality`: a length assignment `l` is realizable by a prefix code IFF `K l <= 1`
   (state the Kraft direction you can prove finitely: exhibit that any prefix code satisfies
   `K l <= 1` via the disjoint-dyadic-interval packing -- OR, if the full combinatorial proof is
   heavy, prove the KEY finite instance + the converse construction for a concrete `n` and state
   scope honestly). Cite the Kraft package as the reference for the general theorem.
2. `expected_length_bound`: for the uniform-ish dyadic code `l_i = ceil(log2(1/p_i))`-analogue,
   stated RATIONALLY as `l_i` chosen with `(1/2)^(l_i) <= p_i < (1/2)^(l_i - 1)` (Shannon-Fano),
   prove `K l <= 1` (Kraft satisfied) AND the per-symbol bound `p_i (l_i) < p_i (log-analogue + 1)`
   -- the compression cost is controlled by the weight distribution. Keep it rational: use the
   dyadic bracketing, not `Real.log`.
3. `mass_is_compressibility` (payload): tie to mass -- the linear entropy `Hlin p = 1 - sum p_i^2`
   (= normalized mass^2 of the direction register) is `0` iff the message is a single pure direction
   (one symbol, `l = 0`, trivially compressible, MASSLESS) and `> 0` iff mixed (multiple symbols
   needing genuine code length, MASSIVE). Prove `Hlin p = 0 <-> exists i, p_i = 1` (pure/massless)
   and exhibit a mixed witness with `Hlin > 0` needing `>= 2` code symbols. So mass^2 = the
   irreducible mixedness = the compression cost floor of the null-direction message.
4. `compression_verdict`: package -- a massless mode is a single pure direction (zero code length,
   zero mass); a massive mode is a mixed direction message whose linear-entropy compression cost is
   its mass^2. "Mass is the compression cost of the null-direction message." Honest scope: linear
   entropy (rational) not Shannon entropy; a finite Kraft bound, referencing the kraft package.

MANDATORY non-degeneracy: pure witness `p = (1,0,0)` (`Hlin = 0`, massless, `l = (0,..)`); mixed
witness `p = (1/2,1/4,1/4)` (`Hlin = 1 - (1/4+1/16+1/16) = 5/8 > 0`, massive) with a prefix code
`l = (1,2,2)`, `K = 1/2+1/4+1/4 = 1 <= 1` -- all rationals in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (kraft package is a
REFERENCE for provenance, not an import). Footprint exactly [propext, Classical.choice,
Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>` on every headline.
Rational + Nat + Finset.sum; ring/norm_num/decide/fin_cases; NO Real.log/exp (dyadic bracketing
only), NO Complex, NO nlinarith deg>=3. Build under 3 min. Deliver RequestProject/Main.lean
(namespace KraftCompressionMass) + ARISTOTLE_SUMMARY.md WITH the kraft-package provenance line.
