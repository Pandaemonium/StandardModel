# Claude call: round 022 adversarial next target

Date: 2026-06-24.

## Metadata

```text
provider: Claude
model_requested: opus
model_used: opus
role: adversarial review of next target
exit_status: 0
context_pack: AgentTasks/model-calls/context-packs/2026-06-24-round-022-context.md
```

## Prompt

The prompt sent was the full contents of
`AgentTasks/model-calls/context-packs/2026-06-24-round-022-context.md`,
followed by a short summary of Gemini's recommendation and this task:

```text
Adversarial task:
Attack the proposed next Aristotle job. Is the branch-reflection Mandelstam instantiation too trivial, too hard, duplicated, or not publication-worthy? If it is still the right move, give a sharper theorem statement and the minimal proof strategy. If it is the wrong move, propose exactly one better finite target and explain why. Be concrete enough that Codex can stage one Lean theorem.
```

Command shape:

```text
claude -p --bare --tools "" --model opus --output-format text <prompt>
```

## Raw Response

Note: the response below is normalized only for repository scan hygiene; raw
Lean placeholder-token spellings in markdown are not preserved.

# Adversarial review: P2 branch-reflection Mandelstam instantiation

## Verdict

The proposed instantiation, *as currently scoped*, is **too thin to publish and
creates load-bearing technical debt**. It is, however, on the right lane: the
fix is to widen the single Aristotle job, not to switch lanes.

## What's wrong with the proposal as written

1. **It is a one-line corollary once the bridge exists.** If
   `branchReflection h p m E` is shown to equal `tracelessMat a b c` for some
   `a`, `b`, `c`, the four-reflection identity reduces to
   `exact trace2_mul_four_traceless_mandelstam _ _ _ _` modulo `simp [bridge]`.

2. **The bridge lemma is doing all the real work and is being hidden.** The
   interesting content is the explicit coordinates. Without those written down,
   the corollary asserts that the four-trace is a polynomial in pairwise traces
   but does not let a reader compute the polynomial.

3. **The Gemini failure-mode warning understates the problem.** Coordinate
   mismatch is not just a `simp` nuisance. If signs or scalings hide a
   mass-shell hypothesis, that hypothesis must be surfaced now.

4. **Duplication risk with `trace2_branchReflection_sq_eq_two_on_massShell`.**
   If the new pairwise formula does not specialize to the existing on-shell
   lemma cleanly, the module has convention drift.

## Sharper single Aristotle job

Replace the proposed corollary with one bundled theorem package whose stated
goal is the explicit pairwise trace polynomial, with the Mandelstam corollary
as a consequence:

```text
branchReflection_as_tracelessMat
trace2_mul_two_branchReflections_poly
trace2_mul_four_branchReflections_mandelstam
on-shell consistency audit against trace2_branchReflection_sq_eq_two_on_massShell
```

The coordinates should be defined explicitly, not hidden behind existential
witnesses.

## Minimal proof strategy

1. Prove the coordinate bridge by unfolding `branchReflection`,
   `chiralHamiltonian`, and `tracelessMat`, then using finite matrix extensionality
   or direct simplification.
2. Prove the pairwise trace closed form by direct expansion or by using the
   existing two-reflection trace formula.
3. Prove the four-reflection Mandelstam specialization by rewriting each
   `branchReflection` through the coordinate bridge and applying the new
   general theorem.
4. Add an on-shell audit lemma so this package agrees with
   `trace2_branchReflection_sq_eq_two_on_massShell`.

## Why this is the right move

- It is more publication-worthy than a bare corollary because it gives a
  closed-form polynomial parameterization of two- and four-reflection traces.
- It reduces technical debt by forcing the coordinate and on-shell conventions
  into the same job.
- It sets up the later one-diamond curvature/super-Dirac bridge: any such
  bridge must either factor through these explicit coordinates or introduce a
  named geometric substitution map.

Recommendation: submit the bundled coordinate/pairwise/four-trace/on-shell
audit job, not the bare corollary, and do not pivot to P9/P1/P7 this round.

## Summary

Claude agrees with staying on P2 but recommends widening the job from a bare
Mandelstam instantiation to a coordinate-explicit branch-reflection package.

## Later Usefulness Rating

Pending proof work.
