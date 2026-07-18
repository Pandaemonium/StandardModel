# Aristotle job: fractional atlas packing dual

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`

```yaml
aristotle:
  project_id: 32ac6170-b264-46ca-9165-717d3757a5c9
  task_id: d2308748-c467-4ec1-89bc-6f28a52fd974
  target_file: AtlasFractionalPackingDual/AtlasFractionalPackingDual.lean
  expected_module: AtlasFractionalPackingDual.AtlasFractionalPackingDual
  submission_project: AgentTasks/aristotle-submit/atlas-fractional-packing-dual-20260716-project
  source_root: AgentTasks/aristotle-standalone/atlas-fractional-packing-dual-20260716
  output_dir: AgentTasks/aristotle-output/32ac6170-b264-46ca-9165-717d3757a5c9
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/AtlasFractionalPackingDual.lean
```

## Exact target

Prove all three displayed theorem statements without changing any definition or
statement:

- the weighted chart/event incidence identity;
- the fractional hitting-certificate capacity bound; and
- the common-event unit-certificate boundary case.

Small private helper lemmas are welcome. Keep the package Mathlib-only. Use
kernel-checked tactics and do not use the compiled evaluator.

## Scientific purpose

R4 found that every tested bounded-multiplicity selector stopped at the cap in
a full-intersection regime, but it did not archive the whole candidate-family
intersection or prove the global packing optimum. A future external optimizer
can search for nonnegative rational event weights. This theorem is intended to
let Lean verify the resulting finite dual certificate instead of trusting the
optimizer as proof.

The common-event corollary is a nonvacuity control and recovers the exact
one-event obstruction. These statements do not show that a useful certificate
exists for the R4 candidate family, construct a growing atlas, or open G2.

## Constraints

- Preserve `Real`, all casts, and the eventwise cap exactly.
- Do not replace the selected-family premise by a whole-family premise.
- Do not introduce new assumptions or weaken the certificate condition.
- Finish with a report listing statement changes, assumptions, and any
  remaining proof handoff.

## Preflight

- The exact live and focused source statements pass the pinned repository's
  `lake env lean` check with only the three intentional proof handoff
  warnings.
- The fresh focused package downloaded its Mathlib dependencies but has no
  local compiled Mathlib cache, so its narrow preflight stopped at
  `unknown module prefix 'Mathlib'`. This is a package-cache limitation rather
  than a source diagnostic; Aristotle should run the narrow target command
  first in its prepared environment.
- Submitted as project `32ac6170-b264-46ca-9165-717d3757a5c9`, task
  `d2308748-c467-4ec1-89bc-6f28a52fd974`.

## Integration

- Aristotle returned all three proof bodies with no statement changes and one
  private point-mass helper lemma.
- The dry-run integration helper found no placeholder or escape-hatch tokens.
- The proof bodies were copied into
  `PhysicsSM/Draft/NullEdge/AtlasFractionalPackingDual.lean`; the module
  docstring records the Aristotle project and build-enforced axiom guards pin
  all three public theorems to `propext`, `Classical.choice`, and `Quot.sound`.
- Codex then added the direct subset wrapper
  `candidate_certificate_bounds_every_capacitySelection`: a certificate on
  the complete candidate family bounds every capacity-respecting selected
  subfamily. Its proof is a direct specialization of Aristotle's unchanged
  headline theorem and has the same guarded assumption footprint.
- `lake env lean PhysicsSM/Draft/NullEdge/AtlasFractionalPackingDual.lean`
  passed after the wrapper. The targeted module build also passed. Both report
  only unused-instance linter warnings inherited from the deliberately broad
  finite theorem context.
- The integrated file contains no proof holes and does not use the compiled
  evaluator.
