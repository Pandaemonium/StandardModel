# Aristotle strategy job: P9 positive T2 coarse-map classes

```yaml
job_name: null-edge-p9-positive-t2-coarse-map-strategy-20260623
status: strategy-reviewed
project_id: 412b3682-fc82-47fb-abaf-fe5465a3d201
task_id: e005b18e-1c9e-448c-bafa-5cdc56075a00
source_staged_from: AgentTasks/aristotle-strategy-packs/null-edge-p9-positive-t2-coarse-map-strategy-20260623
target_file: PROMPT.md
expected_check: no Lean build requested
```

## Task

Ask Aristotle for a no-code theorem-scaffold strategy for the next positive T2
coarse-map target in P9/source visibility.

Context: T1 is now banked as a diamond-local separator, and the negative T2
guardrail is banked as a critical-collapse map that erases that separator. The
next question is which pre-specified coarse-map classes preserve the T1 readout
without being hand-tuned.

## Submission note

Prompt staged at:

```text
AgentTasks/aristotle-strategy-packs/null-edge-p9-positive-t2-coarse-map-strategy-20260623/PROMPT.md
```

Submitted as Aristotle project `412b3682-fc82-47fb-abaf-fe5465a3d201`.

## Completion review

Aristotle returned a useful no-code strategy report:

```text
AgentTasks/aristotle-output/412b3682-fc82-47fb-abaf-fe5465a3d201/extracted-strategy/null-edge-p9-positive-t2-coarse-map-strategy-20260623_aristotle/P9_PositiveT2_CoarseMap_Strategy.md
```

The report ranks three admissible positive-T2 coarse-map classes:

1. **Class A: Alexandrov endpoint-preserving subdiamond restriction.**
   Choose endpoints by a fixed intrinsic/order-isomorphism-invariant rule and
   restrict to the closed diamond. This is the most physical and most direct
   positive companion to the critical-collapse erasure guardrail.
2. **Class B: interval-rank threshold filtration.** Use a pre-specified
   monotone threshold family and prove a scale-window dichotomy.
3. **Class C: spectral/Laplacian projection.** Treat unweighted spectral
   coarse graining as a likely no-go or dichotomy, with weighted/local-interval
   variants as possible rescues.

## Selected next target

Use Class A first. The next focused proof package should be:

```text
NullEdgeP9SubdiamondRestrictionPreservesLocalReadout
```

Primary generic lemmas:

- `subdiamond_convex`
- `subdiamond_restriction_preserves_ic`
- `subdiamond_restriction_preserves_localIntervalSignature`

Follow-up finite witness corollary:

- `NullEdgeP9SubdiamondRestrictionSeparatesWitness`

Acceptance criteria:

- the endpoint-selection rule must be fixed before comparing the T1 pair;
- the rule should be intrinsic/order-isomorphism-invariant or explicitly
  observer-forced;
- the result should contrast with the banked critical-collapse erasure theorem,
  showing why one admissible map preserves what another natural map erases;
- the claim remains finite source-visibility scaffolding, not a
  cosmological-constant solution.

## Review notes

- No Lean build was requested or expected.
- The extracted report contains non-ASCII typography and Lean-style proof-hole
  sketches. Reuse the mathematical content, but normalize any copied text before
  putting it into permanent repo docs.
- The definitions of restriction, endpoint selection, and spectral readout must
  be pinned in the next proof job; the strategy report is intentionally a
  scaffold, not a compiling module.
