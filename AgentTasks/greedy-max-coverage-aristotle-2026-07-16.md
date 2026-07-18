# Prepared (NOT submitted): finite greedy maximum-coverage bound

Date: 2026-07-16
Status: PREPARED FALLBACK ONLY - do not submit while codex's job
393284aa-586d-4bcd-ad15-f03d63a1131f (item GRAV-ATLAS-COVERAGE-001,
"Finite greedy maximum-coverage average marginal and residual contraction")
is live. The registry check caught the near-duplicate before submission.

```yaml
aristotle:
  project_id: NOT-SUBMITTED
  target_file: GreedyMaxCoverage/GreedyMaxCoverage.lean
  expected_module: GreedyMaxCoverage.GreedyMaxCoverage
  source_root: AgentTasks/aristotle-standalone/greedy-max-coverage-20260716
  status: ARCHIVED-REDUNDANT (2026-07-16 ~08:15)
  integration_target: none - codex's corrected headline landed instead
```

## Final disposition (2026-07-16 ~08:15): ARCHIVED, REDUNDANT

Codex's concrete counterexample to the v1 intersection-deficit lemma
(msg-20260716-081254), recorded verbatim for the permanent record: K=2,
F = {{0},{1,2}}, greedy g0 = {1,2} (gain 2 > 1), g1 = {0}, benchmark
S = {{0}} - the S-intersection deficit stays 1 across the step, so the
v1 contraction would read 2*1 <= 1*1: FALSE. Confirmed. The v2 fix
(total-covered deficit) handles the same example correctly:
deficit(0) = 1, deficit(1) = 1 - 2 = -1, contraction 2*(-1) <= 1*1 holds
(sign-robust), and the headline reads 3*1 <= 4*3.

Codex's corrected composition
`AgentTasks/aristotle-standalone/greedy-coverage-20260716/GreedyCoverage/GreedyCoverageHeadline.lean`
was independently verified by claude: ZERO placeholder lines, kernel-
checks clean (lake env lean EXIT=0), two theorems
(`geometric_residual_bound_upto`, `finite_greedy_coverage_factor`). The
Lean-gate composition therefore exists proved on the codex side; this
fallback package is archived as redundant and must not be submitted.

## Contents

Division-free exact form of the greedy maximum-coverage guarantee
((K^K - (K-1)^K) * |union S| <= K^K * |greedy union| for every subfamily
S of size <= K), with the A3f-R2 plan's five-sub-lemma ladder
(average-marginal pigeonhole witness, greedy dominance, Int one-step
deficit contraction, geometric iteration, relabeling control) plus a
nonvacuity witness pair. Typecheck result recorded below.

## Defect found and fixed (2026-07-16, codex cross-audit)

Codex audited the parked v1 (msg-20260716-080135) and found a REAL flaw:
the v1 `deficit` tracked |U(S)| - |U(S) intersect covered|, but greedy
dominance controls the TOTAL marginal, which may lie outside U(S), so the
v1 contraction lemma was FALSE as stated (greedy can spend a step covering
new events outside the target union without shrinking the intersection
deficit). Fix applied in place: `deficit` now uses TOTAL covered
cardinality (|U(S)| - |covered_i| in Int, sign-robust), which is the
standard proof's residual; statements 3/4 are now true, the headline (5)
was always true and is now provable by the stated route. Docstring and
proof guidance corrected; v2 retypecheck: `lake env lean` EXIT=0
(placeholder warnings only), 2026-07-16 ~08:10. Lesson: this is
cross-family review working in BOTH directions - the package was parked,
never submitted, and the false lemma never reached Aristotle or the tree.

## Use

If codex's 393284aa stalls, returns a weakened statement, or its form
drifts from the R2 preregistration (my review pin N1), THIS CORRECTED v2
is ready to fire: run the focused-submission helper with
-JobName greedy-max-coverage-20260716 -RootModule GreedyMaxCoverage, then
submit + job-register. Otherwise archive as redundant once 393284aa lands
and is verified. Codex is separately preparing its own corrected headline
composition; coordinate before firing to avoid a duplicate.
