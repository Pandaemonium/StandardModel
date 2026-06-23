# Aristotle focused job: P9 diamond-locality noise-invariance lemma

```yaml
job_name: null-edge-p9-diamond-locality-noise-invariance-20260623
status: integrated
project_id: 5d92d60b-eeb0-48b2-99ea-642040c54bf9
task_id: b2d5454f-df80-48fc-ae73-5ae30be3d070
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-diamond-locality-noise-invariance-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-diamond-locality-noise-invariance-20260623-project
target_module: NullEdgeP9DiamondLocalityNoiseInvariance.Core
target_file: NullEdgeP9DiamondLocalityNoiseInvariance/Core.lean
expected_check: lake env lean NullEdgeP9DiamondLocalityNoiseInvariance/Core.lean
integrated_module: PhysicsSM.Draft.NullEdgeP9DiamondLocalityNoiseInvariance
integrated_file: PhysicsSM/Draft/NullEdgeP9DiamondLocalityNoiseInvariance.lean
```

## Task

Fill the proof holes in
`NullEdgeP9DiamondLocalityNoiseInvariance/Core.lean` without changing
definitions or theorem statements.

Scientific target: this is the clean T3 locality/noise-invariance spine for
the P9 source-visibility program. If two finite relations have the same closed
diamond and agree on all relation entries among vertices in that diamond, then
the local interval-size signature of the diamond is unchanged. In physics
language, geometry-blind relation noise outside the measured diamond cannot
affect this frozen local observer readout when the diamond membership and
internal relation data are held fixed.

## Targets

```lean
localIntervalCard_eq_of_diamond_local_agreement
localIntervalAbundance_eq_of_diamond_local_agreement
localIntervalSignature_eq_of_diamond_local_agreement
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9DiamondLocalityNoiseInvariance/Core.lean
```

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Submission note

Local preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-diamond-locality-noise-invariance-20260623/NullEdgeP9DiamondLocalityNoiseInvariance/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-diamond-locality-noise-invariance-20260623/NullEdgeP9DiamondLocalityNoiseInvariance/Core.lean
```

The Lean preflight passed with exactly three intended proof-hole warnings and
no errors. Non-ASCII scan was clean.

Prepared focused project:

```text
AgentTasks/aristotle-submit/null-edge-p9-diamond-locality-noise-invariance-20260623-project
```

Submitted as Aristotle project `5d92d60b-eeb0-48b2-99ea-642040c54bf9`.

## Aristotle completion

Aristotle filled all three targets without changing definitions or theorem
statements. It reported no remaining proof holes, no new assumptions, and no
nonstandard constructs. The proof uses filtered-set/cardinality congruence for
the local interval card, then reuses that equality inside the abundance and
signature wrappers.

## Integration note

Integrated as `PhysicsSM.Draft.NullEdgeP9DiamondLocalityNoiseInvariance` and
imported from `PhysicsSMDraft.lean`. The helper hit the known Windows extraction
issue for bundled task notes, so integration used manual diff inspection. The
live module adds local linter silences for the unused section variable warning,
without changing theorem statements.

Scientific significance: this is the clean T3 locality/noise-invariance spine.
It proves that the local interval-size signature is unchanged when closed
diamond membership and all relation entries among diamond vertices agree. In
program language, external relation noise cannot affect the frozen local
observer channel unless it changes the measured diamond or its internal
relation data.
