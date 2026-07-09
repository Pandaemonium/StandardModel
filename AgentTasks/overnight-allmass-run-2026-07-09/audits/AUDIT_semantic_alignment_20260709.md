# Semantic-alignment audit: do the Lean *statements* encode their claimed physics?

**Scope.** This is the complementary check the kernel does not do. The kernel certifies that
each proof is correct; it does *not* certify that the *statement* is the intended mathematics.
For each of the six kernel-checked (0-sorry) statements I assess two residual failure modes:

- **VACUITY** — are the hypotheses satisfiable / the existentials witnessed by explicit
  non-degenerate data, or could the theorem be trivially / near-trivially true?
- **READING-OUTRUNS-STATEMENT** — does the manuscript's one-line reading claim *more* than the
  Lean literally says (false-shape / over-generalization / smuggled-in-by-definition)?

**Caveat on visibility.** The statements were reviewed as quoted; the underlying *definitions*
(`edge`, `Qform`, `sym`, `Hmass`, `Podd`, the vector `v`, `budget`, `detP`, `massPair`, `detG`,
`lamExp`) are not in the repository under `RequestProject/`. Where a verdict hinges on a definition
I cannot see, that dependency is stated explicitly. This is itself an audit finding: **several of the
readings are load-bearing on definitions, not on the proved proposition** — which is exactly the
place a false-shape hides from a prose red-team.

---

## (1) `det_P_eq_massSq`

`(P p0 p1 p2 p3).det = ((p0^2 - p1^2 - p2^2 - p3^2 : R) : C)`, `P = p0 σ0 + p1 σ1 + p2 σ2 + p3 σ3`.

- **Vacuity: WITNESSED / non-degenerate.** This is a universally-quantified *polynomial identity*
  over all `p0..p3`, not a hypothesis-gated claim, so there is nothing to satisfy and nothing to
  degenerate. It is substantive at generic points (e.g. `p = (1,0,0,0)` gives `det = 1`, timelike;
  `p = (1,1,0,0)` gives `det = 0`, null), so it does not collapse on a measure-zero set. The
  arithmetic is genuine: `P = [[p0+p3, p1-i p2],[p1+i p2, p0-p3]]`, and
  `det = (p0²-p3²) - (p1²+p2²) = p0²-p1²-p2²-p3²`. Correct.
- **Reading: FAITHFUL (with a terminology overreach).** The determinant *is* the Minkowski square
  `m²`, and this is genuinely the `2×2` Hermitian (Pauli) representation of the momentum, whose
  determinant is the mass-shell invariant — **not** the `4×4` metric-contraction "Gram" object.
  So "the correct P (not the 4-vector Gram)" is fair. The one soft overreach is the phrase
  **"little-group spinor matrix"**: the Lean says nothing about the little group (stabilizer of `p`)
  or its representation theory; it proves one determinant identity at one parametrization. The
  *mathematical* content ("det = m²") is exactly stated; only the little-group *label* outruns.

---

## (2) `detP_unique`

`(co : Fin 6 → R) (hnull : ∀ v, Qform co (edge v) = 0) (_hinv : … det = 1 → invariance) :
 ∃ k, ∀ a b c, Qform co (sym a b c) = k * det (sym a b c)`.

- **Vacuity: NON-DEGENERATE, but with two caveats.**
  (a) The hypothesis `hnull` is satisfiable by *non-trivial* data — `co = ` coefficients of `det`
  satisfies it (det vanishes on null/rank-deficient symmetric matrices), yielding `k = 1`. So the
  quantified class is non-empty and the conclusion is not vacuously about `co = 0` only.
  (b) The conclusion is an *existential over `k`*; for `co = 0` it is satisfied by `k = 0`. That is
  fine — the substantive content is **uniqueness up to scale** (the space of quadratics vanishing
  on the null set is 1-dimensional, spanned by `det`), and `∃k, Qform = k·det` is precisely that.
  (c) **Dependency I cannot see:** whether `edge : Fin n → …` enumerates *enough* null directions.
  If `edge` ranges over a finite set, `hnull` is finitely many linear conditions on the 6-vector
  `co`; the theorem being 0-sorry means that finite set *is* a determining test set, but the
  strength of "vanishing on null edges ⇒ ∝ det" is only as strong as that set's spanning property.
  This is not a vacuity defect (det always witnesses `hnull`), but it is where the word "the null
  edges" is doing quiet work.
  **The `_hinv` underscore is a genuine, honest signal:** SL2-invariance is declared and *unused*,
  which literally certifies the reading's claim "null-vanishing ALONE forces it (SL2-inv unused)".
- **Reading: FAITHFUL only if the word "quadratic" is retained.** The Lean establishes uniqueness
  **within quadratic forms** (`Qform`, 6 coefficients). It says *nothing* about degree-4 or higher
  invariants. The quoted reading correctly says "the UNIQUE **quadratic** vanishing on null edges,"
  so as quoted it is faithful. The risk is downstream: if the manuscript ever drops "quadratic" and
  reads this as "det is *the* unique invariant / canonical object," that is a false-shape — the
  theorem cannot exclude, e.g., independent quartic invariants. Flag: **keep "quadratic" in every
  restatement.**

---

## (3) `rank3_det_ne_pairwise`

`(massPair 1 1 1 ≠ detG 1 1 1) ∧ (massPair 1 1 0 ≠ detG 1 1 0) ∧ (massPair 1 1 0 ≠ 0 ∧ detG 1 1 0 = 0)`.

- **Vacuity: WITNESSED (explicit numerals), non-degenerate.** These are decidable ground facts at
  concrete points. The third conjunct is the sharpest and most useful: at `(1,1,0)` the naive `detG`
  *vanishes* while `massPair` does **not**, so `detG` cannot be the pairwise mass — that is a clean
  falsification, not a coincidence at a degenerate point.
- **Reading: SLIGHT-OVERREACH (interpretive tail).** "detG is a DIFFERENT function from massPair"
  is rigorously supported: two functions differing at even one point are different, and here we have
  explicit disagreement (plus a zero/non-zero split). But **"the det reading is intrinsically
  rank-2"** is an *interpretation layered on two data points*. The Lean exhibits disagreement at
  specific rank-3 configurations; it does **not** prove "`detG = massPair` on all rank-≤2 configs and
  fails on all rank-≥3 configs." So "different function" = faithful; "intrinsically rank-2" =
  interpretive over-generalization from finitely many witnesses. Honest restatement: *"at these
  rank-3 points the naive det disagrees with (indeed vanishes against a non-zero) pairwise mass,
  refuting `detG = massPair` as an identity."*

---

## (4) `family_fails`

`budget 2 2 0 ≠ (10/3) * detP 2 2 0`, together with `witness_match : budget 2 2 1 = (10/3) * detP 2 2 1`.

- **Vacuity: WITNESSED, and genuinely needs BOTH configs.** One config alone is insufficient by
  construction: any single `(budget, detP)` pair with `detP ≠ 0` can be matched by *choosing* the
  constant, so a lone equality/inequality proves nothing about a "family." The pair here does the
  right thing: `witness_match` fixes `c = 10/3` at `(2,2,1)`; `family_fails` shows that same `c`
  breaks at `(2,2,0)`. Whether `detP 2 2 0 = 0` or `≠ 0`, the two together force
  `budget/detP` to be non-constant across the family, i.e. **no single constant `c` makes
  `budget = c·detP`**. So the two witnesses are neither redundant nor cherry-picked to hide an
  identity of the *proportional* form — they collectively kill it. Non-degenerate.
- **Reading: FAITHFUL within the `c·detP` scope; overreach if generalized to "any det-like law."**
  "`totalBudget = c·detP` is witness-fitted, not a family identity — same c fails at another config"
  is exactly what is proved. The gap is one the audit itself flags: the Lean refutes *proportionality
  to `detP`*, not "budget is not any invariant." A **different functional form** (a rescaled `detP`
  with an additive offset, or `a²+b²+2x²`, etc.) is not touched by this statement. So "not a family
  identity" is fair for `c·detP`; it must **not** be read as "no closed-form family law exists."

---

## (5) `even_gaps`

`(hm : m ≠ 0) : (Hmass m).det = m^4 ∧ (Hmass m).det ≠ 0`, with `odd_preserves : (A + Podd s).mulVec v = 0`.

- **Vacuity: MIXED — `even_gaps` witnessed, `odd_preserves` AT-RISK.**
  `even_gaps`: `m ≠ 0` is satisfiable (`m = 1`), and `det = m⁴` is a real computation showing the
  even-mass matrix is non-singular (the zero mode is lifted). Non-degenerate. Good.
  `odd_preserves`: **this is the vacuity hazard.** `(A + Podd s).mulVec v = 0` is *trivially true if
  `v = 0`* (the zero vector is annihilated by every matrix). The reading "odd perturbation preserves
  the *zero mode*" requires `v` to be an explicit **non-zero** kernel vector (and, ideally, `v` to be
  a kernel vector of `A` itself so that "preserves" is meaningful). As quoted, no `v ≠ 0` (nor
  `A.mulVec v = 0`) hypothesis/witness is visible. **Unless the surrounding development pins `v` to a
  specific non-zero eigenvector, `odd_preserves` is at risk of being vacuously true** and the
  "protection" reading unsupported. This is the single most important thing to check against the
  source.
- **Reading: SLIGHT-OVERREACH → potential false-shape.** Even granting a non-zero `v`, "chiral
  protection is CONDITIONAL" is a *general principle* extrapolated from **one matrix family** `Hmass`
  and **one** odd perturbation `Podd s`. The Lean gives an existence pair (one perturbation preserves,
  one gaps); it does **not** classify perturbations by chirality and prove all odd ones preserve /
  all even ones gap. So "conditional protection" is an illustrative example promoted to a law.

---

## (6) `fork_iff`

`(alpha : Q) : lamExp alpha = -1/2 ↔ alpha = 1`, where `lamExp alpha = alpha/2 - 1`.

- **Vacuity: NON-VACUOUS but trivial.** The biconditional is a correct linear solve:
  `alpha/2 - 1 = -1/2 ⟺ alpha/2 = 1/2 ⟺ alpha = 1`. Both sides are realizable over `ℚ`, so it is not
  vacuous; but it is *arithmetically trivial* (a one-line equation solve).
- **Reading: FALSE-SHAPE (physics is entirely in the definitions, not the theorem).** This is the
  clearest reading-outruns case. The Lean content is pure arithmetic. **Every physical claim** —
  that `lamExp = alpha/2 - 1` is the correct "Lambda exponent," that `-1/2` is the "everpresent-Λ"
  threshold, and that `alpha` is a "count-variance exponent" — lives in the *definitions and the
  chosen constants*, none of which the theorem derives or justifies. So "everpresent-Λ survives iff
  alpha = 1" is not *proved* by the fork; the fork only re-encodes the definition `lamExp := α/2 − 1`
  evaluated at a threshold. "Sharp decidable fork" is true but tautological. If the derivation
  `lamExp = α/2 − 1` and the threshold `−1/2` are argued elsewhere (prose), fine — but the Lean
  certificate here adds essentially nothing beyond `α/2 − 1 = −1/2 ↔ α = 1`.

---

## Ranked: TOP 3 readings most at risk of outrunning the Lean

1. **(6) `fork_iff` — FALSE-SHAPE (highest risk).**
   Gap: the theorem is a trivial linear-equation solve over `ℚ`; *all* physics ("everpresent-Λ,"
   "count-variance exponent," the threshold `−1/2`, the exponent form `α/2 − 1`) is smuggled into the
   definitions and constants, which the theorem neither derives nor constrains. The Lean certifies
   arithmetic, the reading advertises a physical selection principle. Anything the reader believes
   about *why* `lamExp = α/2 − 1` is unsupported by this statement.

2. **(5) `even_gaps` / `odd_preserves` — VACUITY + SINGLE-EXAMPLE GENERALIZATION.**
   Gap: `odd_preserves : (A + Podd s).mulVec v = 0` is vacuously true if `v = 0`; no visible
   `v ≠ 0` (or `A.mulVec v = 0`) makes "preserves the zero mode" substantive — must be confirmed in
   source. Even with a non-zero `v`, "chiral protection is *conditional*" is a general law
   extrapolated from a single matrix family and a single perturbation, whereas the Lean only exhibits
   one preserve/one gap instance.

3. **(3) `rank3_det_ne_pairwise` — OVER-GENERALIZATION FROM WITNESSES.**
   Gap: the Lean proves disagreement (indeed a zero-vs-nonzero split) at specific rank-3 points,
   which correctly refutes "`detG = massPair`." But "the det reading is **intrinsically rank-2**"
   is an interpretive universal ("works exactly at rank ≤ 2, fails at rank ≥ 3") that the finite
   witnesses do not establish.

**Runners-up (lower risk, but flag on restatement).**
- **(4) `family_fails`:** faithful for `budget = c·detP`; do not let it be read as "no family law of
  any functional form exists" — a rescaled/offset or different-shape law is untouched.
- **(2) `detP_unique`:** faithful *iff* "quadratic" is retained; "canonical/unique invariant" without
  "quadratic" would overclaim past what a quadratic-form uniqueness result can say (higher-degree
  invariants are out of scope). The `_hinv` underscore is a genuine positive: SL2-invariance is
  provably unused.

**Lowest risk.** (1) `det_P_eq_massSq` is a faithful, non-degenerate polynomial identity; only the
"little-group" label reaches slightly past the proved determinant fact.

---

### One-line meta-finding
The two places a prose red-team and the kernel both miss are **(6)**, where the proposition is a
tautology and the physics is definitional (false-shape), and **(5) `odd_preserves`**, where a missing
`v ≠ 0` can make the "protection" clause vacuous. Both should be checked directly against the source
definitions; the other four are faithful within an explicitly-scoped reading.
