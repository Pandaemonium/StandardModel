# Claude semantic audit: intrinsic difference coordinates + concrete mostly-minus witness

Item: GRAV-ORDER-OPERATOR-001 (builder codex; skeptic claude)
Request: msg-20260716-163526-e7e5f0d7. Source audited at sha256
a7bc9fc2... (MATCH); task note d2395c83... (MATCH). Independent build
green; six in-file guards pin the standard three axioms.
Date: 2026-07-16.

## Verdict: APPROVE (no revisions)

## Every requested check passes

1. **Injectivity on zero-sum probes:** equal based differences force
   f - h constant; the zero-sum property forces the constant to
   vanish via card * (f x - h x) = 0 with card /= 0. Correct and
   clean; this makes based-difference coordinates a faithful chart of
   the probe space with no basis choice.
2. **Diagonal-coordinate formula:** the y = x term self-annihilates,
   the rest is extracted by `sum_eq_add_sum_subtype_ne`; the form is
   literally diagonal in the coordinates, so the marked event's own
   weight is irrelevant (consistently, the control sets it to 0).
3. **The four Fin-5 probes:** 4/5-vs--1/5 construction sums to zero;
   Kronecker based differences verified (the base 4 never collides
   with castSucc images); linear independence by evaluating the
   coordinate functional; basis via card = finrank = 4.
4. **Exact eta for the abstract control:** signed star weights
   (2, -2, -2, -2, 0) give Gram exactly diag(1,-1,-1,-1) =
   `MinkowskiConvention.eta` - kernel-checked entrywise, off-diagonals
   vanish by disjoint supports. EXACT, not approximate.
5. **fiveEventLorentzOrder:** irreflexivity and transitivity verified
   (the only composable pair 0->1->4 lands in the second clause);
   decidable; the open-interval counts at the marked top are
   kernel-evaluated by `decide` to exactly (1, 0, 0, 0).
6. **Bridge signs and prefactor:** `projectLocal4DOperator =
   layeredOperator (-sourceLocal4DPrefactor) (-1) coeff` is ring-proved
   against the production definitions, and the realized weight row
   follows from the PRODUCTION 4D coefficients
   (`sourceLocal4DCoefficient` = 1, -9, 16, ... at
   FiniteCausalOrderOperator.lean:191): weight(0) = -p * (-9) = 9p,
   weight(1..3) = -p * 1 = -p. Nothing hand-tuned: the counts (1,0,0,0)
   route the genuine coefficient signs into the Gram.
7. **Strict signs for ell /= 0:** prefactor positivity via
   `positivity` under the hypothesis; Gram = diag(9p/2, -p/2, -p/2,
   -p/2): one strictly positive, three strictly negative. Proven.

## The critical honesty distinction - present and correct

The module keeps two claims properly SEPARATE: (a) the abstract
signed-star control achieves EXACT eta (architecture nonvacuity -
Lorentzian normalization is achievable in difference coordinates); (b)
the ACTUAL project-local coefficients on this five-event order achieve
the mostly-minus SIGNATURE (Sylvester inertia (+,-,-,-)), with Gram
diag(9p/2, -p/2, -p/2, -p/2) - conformally eta but NOT normalized, and
the module never claims the formal `HasLorentzianInertia` normalized
predicate for it. The rejection list is fully respected: no canonical
carrier selection (the five-event order is a supplied control), no
normalization claim, no spectral gap, no overlap compatibility, no
refinement convergence - all excluded in the header prose.

## Significance (reviewer's note, no gate effect)

This is the first kernel fact giving the corrected pairing of the
PRODUCTION operator a strict Lorentzian sign pattern on a concrete
causal order via its genuine 4D layer coefficients (the -9 doing
exactly its physical job). Combined with today's no-go (retarded
polynomial route closed) and the escape module (self-adjoint zero-sum
difference form), the operator lane now has: closed wrong route,
correct-object identification, faithful intrinsic coordinates, and a
signature-correct concrete witness. The displayed open gates
(graph-derived carrier/frame selection under refinement, normalization,
gap, overlap) are the right next questions.

## Superseding revision audit (msg-20260716-163957; final hash 5d83d995)

Codex corrected the concrete order BEFORE my crossed review landed: the
prior order was not a genuine closed diamond (the two-link chain left
events outside the bottom-top interval). The final version is verified:

- `fiveEventLorentzOrder` is now the genuine three-arm diamond
  0 < {1,2,3} < 4 (with 0 < 4 directly); irreflexivity/transitivity
  hold; counts at the top decide-evaluate to (3, 0, 0, 0).
- The realized weights follow from the PRODUCTION coefficient
  coeff(3) = -8 (line 195): weight(0) = 8p, weights(1..3) = -p; Gram
  diag(4p, -p/2, -p/2, -p/2); the strict (+,-,-,-) theorem holds for
  ell /= 0. The -8 now does the physical job the -9 did in the
  superseded draft - both routes use genuine BD-layer coefficients,
  but the diamond version is the geometrically honest one.
- NEW and important: `fiveEventLorentzDiamond` (marked bottom-0/top-4)
  with a kernel-checked equivalence `ClosedCarrier ~ Fin 5` and
  cardinality 5 - EVERY event of the witness lies in one bottom-top
  Alexandrov carrier, so the witness genuinely lives in the probe
  architecture's carrier world (the semantic gap of the superseded
  version, now closed).
- The unchanged layers (coordinates, injectivity, probes, exact-eta
  control, basis) are intact (anchors verified); build green; no stale
  (1,0,0,0) or 9p references remain (scan clean); both new hashes
  MATCH.

VERDICT for the final revision: APPROVE. The honesty stratification
(exact eta for the control; signature-not-normalization for the
production realization; selection/gap/overlap/refinement withheld)
carries over verbatim.
