# Post-mortem: null-edge parallel Aristotle run

Date written: 2026-06-23

Scope:

- Primary scope: the completed 18-cycle autonomous loop recorded in
  `AgentTasks/null-edge-parallel-loop-execution-2026-06-22.md`.
- Steering plan:
  `AgentTasks/null-edge-parallel-aristotle-loop-plan-2026-06-22.md`.
- Main publication target affected:
  `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`, especially P9.
- Out-of-scope tail: the execution ledger now also contains a Cycle 19 and the
  workspace contains many newer Aristotle artifacts from later/parallel work.
  Those should be reconciled separately. This post-mortem is about the 18-cycle
  run that was explicitly completed and verified.

## Executive Summary

The autonomous run succeeded at its most important goal: it produced real,
kernel-checked finite theorem progress and used Aristotle as a proof engine
rather than as a slot-filling activity generator.

The strongest outcome was a sharpened P9 theorem spine for the
cosmological-constant/source-visibility branch:

```text
boundary-exact sources vanish against closed tests
boundary-of-boundary bookkeeping produces no bulk source
visible closure is rest-frame closure, not source invisibility
equal independent residual signs have variance N
weighted residual signs have variance sum_i amp_i^2
uniformly spreading total scale A over N cells gives variance A^2 / N
closed visible fans with nonzero energy have positive source pairing
```

The run did **not** solve the cosmological-constant problem. It did something
more modest and useful: it turned a vague flagship branch into a finite set of
guardrails, no-go statements, and exact fluctuation/suppression identities. The
next required step is geometric: define a real `DiamondSourceVisibility` API
with diamond/screen cells, geometric weights, curvature or holonomy-defect
tests, and an observer projection.

Operationally, the run mostly behaved well: focused packages avoided broad-build
timeouts, Aristotle jobs were integrated through small diffs and targeted Lean
checks, and idle capacity was sometimes left unused rather than filled with weak
targets. The main weakness was boundary control: the ledger numbering has a gap,
the file later acquired a Cycle 19 after the declared 18-cycle goal, and the
workspace now includes many later artifacts that are easy to confuse with the
completed run.

## What Worked

### Publication value became the scheduler

The plan's most important correction was to treat five or six parallel jobs as a
ceiling, not a quota. The run did this well in the P9 lane. In Cycle 8, for
example, it waited for the fluctuation-scaling job instead of submitting a
lower-value filler target merely to keep Aristotle busy.

That was the right behavior. The branch advanced because the loop asked:

```text
Does this target change a publication claim, a gate, or a failure mode?
```

not:

```text
Is every lane active?
```

### Focused packages were the right default

The focused standalone packages were the difference between productive proof
work and burning time on the full `PhysicsSM` import graph. The run repeatedly
used the pattern:

```text
write small Mathlib-only target
check it elaborates with exactly the intended proof holes
prepare focused Aristotle package
fetch Mathlib cache in that package
run package-level `lake env lean`
submit to Aristotle
download, diff, integrate
run targeted repo checks
```

This was especially important after earlier Aristotle failures where jobs spent
their budget building broad project imports.

### Strategy jobs were used at the right moments

The two P9 strategy/audit jobs were useful because they changed decisions.

The first audit pushed the loop away from more hardcoded toy examples and toward
a unified source-visibility core. The second audit, after the suppression
theorems, forced the honest conclusion that P9 still lacks physics leverage
until geometric cell weights and curvature-defect tests are defined.

The post-suppression audit's most useful sentence, paraphrased, was:

```text
The theorem spine is honest finite algebra; it earns the right to state the
gate precisely, but it is not yet a cosmology result.
```

That is exactly the kind of outside pressure this project needs.

### Verification was strong enough for draft integration

For the newly integrated P9 draft modules, the run used a good verification
ladder:

```text
lake env lean <file>
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide <files>
git diff --check
lake build PhysicsSM.Draft.<Module>
lake env lean PhysicsSMDraft.lean
lake build PhysicsSMDraft
pre-commit run --all-files
```

The final `lake build PhysicsSMDraft` passed. It still emitted older unrelated
warnings and informational tactic suggestions, but the new P9 modules passed
their focused checks and the draft root built.

## Scientific Outcomes

### P9 is sharper, but still aspirational

Before the run, P9 was high-leverage but underdefined. After the run, P9 has a
finite theorem spine:

- `PhysicsSM.Draft.NullEdgeP9BoundarySource`
- `PhysicsSM.Draft.NullEdgeP9BFClosure`
- `PhysicsSM.Draft.NullEdgeP9DiamondVisibility`
- `PhysicsSM.Draft.NullEdgeP9MeanZeroFluctuation`
- `PhysicsSM.Draft.NullEdgeP9VisibleClosureSource`
- `PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore`
- `PhysicsSM.Draft.NullEdgeP9FluctuationScaling`
- `PhysicsSM.Draft.NullEdgeP9WeightedFluctuation`
- `PhysicsSM.Draft.NullEdgeP9UniformSuppression`

The most important conceptual result is:

```text
visible closure is a rest-frame condition, not source invisibility
```

The most important scaling result is:

```text
uniformly spread total scale A over N independent sign cells
  -> normalized second moment A^2 / N
```

Together, these are real progress because they prevent two bad moves:

- hiding visible mass-energy behind a closure condition;
- claiming a suppression mechanism without a finite variance identity.

But neither result is yet a physical cosmological-constant mechanism. The
missing bridge is the interpretation of `amp_i`, the cell set, and the test
observable in actual finite diamond geometry.

### The post-suppression audit set the right pass/fail threshold

The audit says P9 should not be promoted from aspirational target to synthesis
paper until three theorem types land over a real diamond/screen/curvature API:

1. A no-go: visible non-collinearity gives nonzero mass/source.
2. A characterization: boundary-exact or BF-closed bookkeeping is exactly what
   is invisible to curvature tests.
3. A quantitative suppression or tension inequality compared parametrically with
   everpresent-Lambda scaling.

This is the right bar. It is concrete enough for theorem proving and harsh
enough to keep the physics honest.

### The run improved publication planning

`Sources/Null_Edge_Causal_Graph_Publication_Plan.md` now records the P9 finite
footholds and keeps P9 classified as aspirational. That is the right balance:
the branch became more credible without being oversold.

## Operational Issues

### Cycle accounting was messy

The ledger jumps from Cycle 2 to Cycle 4. Cycle 3 appears to have been folded
into adjacent entries rather than recorded as its own header. This did not break
the work, but it weakens the audit trail.

The ledger also now contains a Cycle 19 after the 18-cycle closeout. That is
outside the completed goal scope and should be treated as a separate resumed
run. Future loops should explicitly separate:

```text
Completed required loop
Post-loop follow-up
New goal/run
```

### The final summary underreported later workspace state

The final goal summary was accurate for the 18-cycle objective, but the working
tree later contained many additional Aristotle artifacts and new draft modules.
That makes it easy to confuse the completed loop with later work. The post-loop
boundary needs to be more explicit in future final reports:

```text
This summary covers cycles 1-18 only.
There may be later jobs/artifacts outside this completed goal.
```

### Semantic search was attempted but not operational in that shell

The run tried to use `Scripts/lit/neo4j_doc_search.py` and discovered that the
plain shell lacked the required Neo4j environment variables. The tool-env Python
was present, but credentials were not available in that process.

This did not derail the run because the P9 audit and local docs gave enough
direction. But it matters because semantic search should normally be preferred
over keyword search for this repo.

Action item:

```text
Document the exact shell invocation or wrapper that exposes Neo4j credentials
to `neo4j_doc_search.py`, or route semantic doc search through the MCP surface
when available.
```

### P9 APIs became duplicated

The run intentionally integrated several small P9 theorem islands. That was a
good way to bank finite results quickly, but it created repeated definitions:

```text
Cochain
dot
sourcePairing
boundarySource
codiff
BulkClosed
BoundaryExact
unitTest
```

This duplication is now technical debt. The post-suppression audit is right:
before any promotion, these should be consolidated into one reviewed
`DiamondSourceVisibility` API.

### The build output still has unrelated warning noise

`lake build PhysicsSMDraft` passed, but it printed many pre-existing
informational tactic suggestions and older draft warnings in unrelated modules.
The new P9 modules are clean under focused checks, but the aggregate output is
still noisy.

This is a repo-level ergonomics issue. It does not invalidate the run, but it
does make future autonomous integration harder because signal is buried in
unrelated output.

## Aristotle Performance

Aristotle was effective on the finite algebra targets:

- finite sums over `Fin n`;
- sign-flip bijections;
- source-pairing adjointness;
- simple positive-mass corollaries;
- variance and weighted-variance identities.

It was also useful for strategy/audit prompts, even when the task status was
`COMPLETE_WITH_ERRORS` because no code artifact was expected. Those reports were
good enough to steer the next proof batch.

Common integration cleanup remained necessary:

- Aristotle often converted docstrings to plain block comments.
- Some outputs lacked a final newline.
- Some proof scripts had brittle `simp_all` or linter-noisy tactics.
- Standalone statements sometimes used awkward forms that were worth cleaning in
  the repo version, with the semantic change recorded.

Conclusion: Aristotle is very useful for this style of finite theorem work, but
the reviewing agent still has to preserve documentation quality, statement
meaning, and repo API hygiene.

## What I Would Do Differently

1. Add a hard ledger invariant.

   Every cycle should have exactly one numbered header, and the loop should not
   append post-completion cycles to the same run file without an explicit
   "resumed run" section.

2. Consolidate P9 earlier.

   The small theorem islands were useful, but by the time the unified core was
   integrated, some duplicated definitions were already unavoidable. A small
   API consolidation after the first two P9 modules would have reduced later
   cleanup.

3. Run the aggregate draft build earlier once the linter options were fixed.

   The targeted checks were appropriate, but an earlier successful
   `lake build PhysicsSMDraft` would have caught any import-root issue sooner and
   made later confidence less suspenseful.

4. Treat semantic-search availability as a preflight check.

   The loop should start by confirming whether doc semantic search works in the
   current shell. If it does not, the fallback should be recorded once, not
   rediscovered mid-run.

5. Make "no new job in the final cycle" an explicit rule.

   Cycle 18 correctly used aggregate hygiene rather than submitting a new job.
   That should be a standing rule for bounded loops: the last cycle closes the
   loop, it does not create new integration debt.

## Recommended Next Steps

### Immediate Cleanup

1. Reconcile the out-of-scope Cycle 19 and newer Aristotle artifacts separately.
   The current workspace has many untracked post-loop jobs and draft modules.
   They should not be silently folded into the 18-cycle post-mortem.

2. Consolidate P9 definitions into a single draft API:

   ```text
   PhysicsSM.Draft.NullEdgeDiamondSourceVisibility
   ```

   Keep the existing theorem islands as provenance until the API is stable.

3. Add a short index note listing which P9 modules are theorem atoms and which
   are superseded by the consolidated API.

### Next Theorem Targets

The next high-value proof jobs should come from the audit list:

1. `visiblePluckerMass_nonzero_of_noncollinear`
2. `boundaryExact_iff_invisible_to_curvatureDefects`
3. `diamondResidualVariance_scales_with_cellArea`
4. `uniformSuppression_vs_everpresentLambda_tension`
5. `recoverabilityGap_controls_sourceVisibility`

The first is already partially represented by the out-of-scope Cycle 19 job and
should be reconciled before resubmitting anything nearby.

### Publication Direction

P9 should stay "aspirational" in the publication plan for now. The finite theorem
spine is strong enough for a section or technical note, but not yet a
cosmological-constant paper.

The publishable target should be reframed as:

```text
Finite source-visibility guardrails for null-edge diamond models
```

rather than:

```text
A solution to the cosmological-constant problem
```

That framing is honest, useful, and much more likely to survive expert review.

## Final Assessment

This was a successful autonomous run. It did not merely burn Aristotle cycles.
It produced a coherent theorem chain, sharpened a flagship physics branch, and
ended with strong verification.

The main lesson is that autonomy works best here when it is ruthless about
claim boundaries. The most valuable output was not just the theorems; it was the
clarification that P9 now has finite algebraic guardrails, but still lacks the
diamond geometry needed for real cosmological leverage. That is progress in the
right shape: less glitter, more traction.
