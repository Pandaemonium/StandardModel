# P6 Hurwitz campaign: staged Aristotle formalization (task record)

Plan lane: P6 (`Sources/Null_Edge_Ten_Priorities_Research_Plan_2026-07-18.md`).
Goal: kernel-checked Hurwitz theorem - a finite-dimensional unital composition
algebra over `R` has dimension 1, 2, 4, or 8.

## Stage 1 - toolkit (DONE, verified)

Aristotle job `b1a9e38f` (harvest under
`AgentTasks/aristotle-harvest/b1a9e38f/`, verified verbatim in-session):
15 identities over a `NonAssocRing` + `QuadraticForm R A` carrier with
`IsCompositionForm` (polar identities, conjugation, Kirmse identities; no
`mul_assoc` anywhere). Package:
`AgentTasks/aristotle-standalone/hurwitz-composition-toolkit-20260718/HurwitzToolkit/Target.lean`.

## Stage 2 - doubling (HARVESTED PARTIAL; stage-2b in flight)

Job `d5b0eac8` returned after ~9h (COMPLETE_WITH_ERRORS; harvest archived at
`AgentTasks/aristotle-harvest/d5b0eac8/`): ALL THREE doubling theorems
PROVEN (`doubling_product` with Springer-Veldkamp `lambda = -Q(a)`,
`doubling_closed`, `doubling_norm`) on a ~13-lemma tower (orthogonal
commutation, left+right ALTERNATIVE laws, associator skew, Teichmueller,
reassociation, polar). TWO sorries remain in the Moufang pair
(`associator_mul_right`, `mul_right_moufang`), which feeds the
reassociation lemma - targets inherit `sorryAx` until closed. Stage-2b
job `1b045f4b` (submitted 2026-07-18): close the Moufang pair from the
PROVEN alternative laws (classical Artin linearization). Stage 3 remains
gated on zero-sorry stage-2.

## Stage 3a - the forcing crux (HARVESTED: PROVEN)

Job `c7b3a57b` (2026-07-18, ~3h): `orthogonal_forces_associative` PROVEN
with ZERO sorries in Stage3.lean - if a unital composition subalgebra has an
anisotropic orthogonal direction, it is ASSOCIATIVE (the Hurwitz saturation
engine). The proof does NOT reference the two sorried Stage-2 Moufang
lemmas (no occurrences outside the docstring). COMPLETE_WITH_ERRORS status
= inherited Stage-2 sorry warnings only. Harvest archived at
`AgentTasks/aristotle-harvest/c7b3a57b/`; formal in-repo axiom audit
deferred to the stage-2b merge (Moufang closure in flight, `1b045f4b`).

## Stage 4a - ladder-step structural theorems (HARVESTED: ALL PROVEN,
## 2026-07-19 00:35)

Aristotle `2298aa71` returned in 52 min with ALL SEVEN theorems proven and
NO statement changes. BETTER than the pre-registered split: FIVE of seven
are hole-independent (`doubledSubmodule_mem_iff`, `conj_doubled_mem`,
`exists_orthogonal_ne_zero` as required, PLUS `doubled_inf_map_eq_bot` and
`finrank_doubled` via stage-1 identities + linear algebra only). Only
`doubled_isUnitalSubalgebra` and `ladder_step` inherit the two documented
Moufang holes (through `doubling_closed`). Harvest archived in the
`hurwitz-stage4-ladder-20260718` package dir; formal in-repo axiom audit
deferred to the final merge (stage-3a precedent). Moufang note: the
in-flight `1b045f4b` reported `associator_mul_right` FALSE AS STATED (sign
error; octonion counterexample `e1,e2,e4`); course-corrected via
mode-instruct to prove the sign-corrected intermediate under a new name and
close `mul_right_moufang` unchanged.

## Stage 5 - saturation endgame (SUBMITTED 2026-07-19 00:40)

Aristotle `d315d977` (package
`AgentTasks/aristotle-standalone/hurwitz-stage5-saturation-20260719`:
Target + Stage2 + PROVEN Stage3 (c7b3a57b harvest, zero holes) + harvested
Stage4 + Stage5 targets). Seven-rung ladder to `hurwitz_finrank_mem`
(`finrank A in {1,2,4,8}`), per the pre-drafted design below (associator
witness via `mul_mul_orthogonal_right`; contradiction at the proper
non-associative dim-8 rung via stage-3a + `exists_orthogonal_ne_zero`).

## Stage 4b - saturation assembly (DESIGN pre-drafted 2026-07-19 00:10;
## statements to be FINALIZED against the 2298aa71 + 1b045f4b returns)

Key simplification found while pre-drafting: the non-associativity witness
at dim 8 is nearly free from the STAGE-2 API - no Kirmse table needed:

1. `Q_one : Q 1 = 1` - from `comp` at `x = y = 1` (so `Q 1 in {0,1}`) plus
   anisotropy and `1 /= 0`.
2. Base rung: `Submodule.span R {1}` is a unital subalgebra of finrank 1
   (conj fixes `1` since `polar Q 1 1 = 2`).
3. `doubled_not_commutative`: if some `x in S` has `conj Q x /= x`, the
   double is non-commutative - witness `x * a = ?` vs `a * x`: by
   `mul_orthogonal_commute`, `x * a = a * conj x`... wait, direction:
   `x (w a) = (w a) conj x` with `w = 1` gives `x * a = a * conj Q x`;
   commutativity would force `a * x = a * conj Q x`, i.e.
   `a * (x - conj Q x) = 0`, killed by mulLeft-`a` injectivity
   (`Q (a*z) = Q a * Q z`, anisotropy). Every rung past dim 1 contains
   such an `x` (any basis vector orthogonal to `1`: its conj is `-x`).
4. `doubled_not_associative`: if `x y /= y x` in `S`, the double is
   non-associative - the associator `(x, y, a)` is IMMEDIATE from stage 2:
   `x * (y * a) = (y * x) * a` (`mul_mul_orthogonal_right`) while
   `(x * y) * a` is the other order; their difference is
   `((x*y) - (y*x)) * a /= 0` by mulRight-`a` injectivity.
5. Tower induction with stage-4a `ladder_step`: dims go `1 -> 2 -> 4 -> 8`;
   rung 2 is commutative-with-conj-nontrivial => rung 3 (dim 4)
   non-commutative by (3) => rung 4 (dim 8) non-associative by (4).
6. Saturation: if the dim-8 rung is PROPER, stage-3a
   (`orthogonal_forces_associative`, harvested `c7b3a57b`) plus stage-4a
   `exists_orthogonal_ne_zero` force it associative - contradiction with
   (5). Hence it equals `A` and `finrank A = 8`; the earlier stopping
   cases give `finrank A in {1, 2, 4, 8}` (`hurwitz_dim_mem`).

Statement-freeze checklist for the submission: use the returned stage-4a
names verbatim; carry the `Q_one`/injectivity helpers explicitly; the
non-commutativity of the dim-4 rung needs "rung 2 contains x with
conj x /= x," which follows from finrank 2 (an orthogonal-to-1 basis
vector has `conj x = -x /= x` since char 0 and `x /= 0`).

## Stage 4 - dimension ladder assembly (DESIGN, after 2b+3a merge)

The saturation argument (Baez 2002 sec 2.2 / Conway-Smith ch. 6-8 lineage,
clean-room):

1. `doubling_assoc_iff`: the doubled algebra `B + B i` is ASSOCIATIVE iff `B`
   is commutative and associative; and it is a COMPOSITION algebra iff `B` is
   associative. (The load-bearing Cayley-Dickson lemma; stage-2's laws make
   the statement well-formed.)
2. Tower construction inside any composition algebra `A`: starting from
   `R * 1`, repeatedly double while the current subalgebra is proper:
   `R -> C_like (dim 2) -> H_like (dim 4) -> O_like (dim 8)`. Each step uses
   stage-2 doubling; the next step's LEGALITY uses (1): the dim-8 stage is
   non-associative (kernel witness: the toolkit's Kirmse/associator
   nonvanishing on the doubled basis), so a FOURTH doubling breaks the
   composition law.
3. Saturation: if `dim A > 8` there is a unit vector orthogonal to the dim-8
   subalgebra, forcing a fourth doubling inside `A` - contradiction with (1).
   Hence `dim A in {1, 2, 4, 8}`.

Submission shape: stage-2 harvest file + a Stage3.lean skeleton stating
(1)-(3) with the stage-2 API; proof plans inline. Statements must be
finalized AGAINST the stage-2 return (do not guess the returned API names).

## Provenance

Baez "The Octonions" (math/0105155, holdings WRIM6ZI7) sec 2.2; Conway-Smith
"On Quaternions and Octonions" ch. 6-8; clean-room formalization - the Lean
statements are original to this campaign, no external Lean code consulted.

## Stage 2b Moufang - BUDGET-KILLED at ~11h; decomposition CIRCULAR
## (2026-07-19 harvest verdict, job 1b045f4b)

The service killed the job OUT_OF_BUDGET. The returned Stage2 delta:

- The course-corrected sign identity `associator_mul_right_corrected`
  (with the minus sign forced by alternation) is stated and proven FROM
  two new sorried sub-lemmas, with the octonion counterexample
  (`x = e1, y = e2, z = e4` giving `2 e5` vs `-2 e5`) recorded in the
  docstring - the honest record of the original statement's falsehood.
- `mul_right_moufang` is "closed" by `grind` from the new sub-lemma
  `associator_product_entry_right` - but expanding that sub-lemma shows it
  IS the right Moufang identity restated (subtract-and-rearrange), so the
  decomposition is CIRCULAR: the mathematical content did not shrink.

VERDICT: the genuine Moufang hole SURVIVES; the Hurwitz hole-free merge
(stage-2 closure -> `hurwitz_finrank_mem` with zero holes) remains gated.
No repo apply was made from this return. Next attempt (budget permitting)
should target the Artin linearization route directly: prove left/right
alternativity => the Moufang identity via the standard linearized-
associator computation (Schafer ch. III), NOT via product-entry
reshuffles; a focused package with ONLY the alternative laws + the target
avoids the circular temptation.
