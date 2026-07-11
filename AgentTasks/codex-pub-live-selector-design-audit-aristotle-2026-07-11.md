# Aristotle design audit: live carrier-word selectors for Paper F

Name this project `codex-pub-live-selector-design-audit-20260711`.

Perform a hostile, source-grounded design audit. Do not edit files. The generic
torsor, selector-rigidity/no-go, and descent theorems are already landed. The
missing scientific step is a selector defined from the live carrier's primitive
word presentation rather than from aperture/closure/turn/solder coordinates.

Using the exact `CarrierRigidity.lean` formulas:

1. Define the smallest finite source alphabet from primitive letters/words
   (`c1`, `c2`, their adjoints, `g1`, `g2`, their adjoints, `Gamma`, `phi`) whose
   linear evaluation expands the complete displayed square. Channel names may
   appear only after the selector eigenspaces are derived, never as source
   generators.
2. Enumerate a finite generating set for the evaluation kernel under the live
   carrier relations. Separate universal noncommutative-ring/additivity
   relations from carrier axioms and concrete-witness coincidences.
3. Define source solder/word degree and edge-exchange operators intrinsically.
4. Determine whether each selector preserves the actual relation kernel. If
   yes, give a typechecking Lean theorem package that composes with
   `ChannelSelectorDescent.existsUnique_descended_iff`, supplies nonzero words
   in distinct sectors, and includes a deliberately non-homogeneous selector
   control. If no, give an explicit `x` suitable for
   `no_descent_of_relation_witness` with `eval x = 0` and `eval (P x) != 0`.
5. Audit circularity: reject any construction equivalent to the concrete
   coordinate readers or one that assigns labels only after naming the desired
   channel.
6. State whether the resulting selectors, together with chirality, have the
   separated joint spectrum needed by
   `two_sign_gradings_decomposition_unique`.

Return exact proposed definitions and theorem signatures, a relation table,
positive and negative witnesses, likely Lean blockers, and a verdict:
`POSITIVE LIVE SELECTOR`, `CARRIER-SPECIFIC KILL`, or `STILL GENERIC`.
Mathematical falsehood is a successful outcome; hidden channel coordinates are
not.

```yaml
aristotle:
  project_id: a4862d7d-2283-4f2f-a608-ebd721a482c3
  target_file: review-only
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-live-selector-design-audit-20260711-project
  output_dir: AgentTasks/aristotle-output/a4862d7d-2283-4f2f-a608-ebd721a482c3
  status: harvested/verdict-contested
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Disposition

Preserved the returned design as `LIVE_SELECTOR_DESIGN_AUDIT_2026-07-11.md`.
Accepted the primitive-letter presentation, the word-length negative-control
idea, and the warning that simple edge swap does not separate the displayed
channels. Contested the headline `POSITIVE LIVE SELECTOR`: the report leaves
`kernel_solder_homogeneous` and surjectivity/corestriction as proof holes and
does not prove that its homogeneous relation list generates the full evaluation
kernel. Representation-specific identities cannot be excluded from the kernel
of the concrete matrix evaluation. Submitted counter-audit `6833acfa` before
any promotion.
