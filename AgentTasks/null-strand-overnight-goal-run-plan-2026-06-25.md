# NullStrand Overnight Goal Run Plan

Date: 2026-06-25

## Goal

Run Claude overnight as the coordinator for a large Aristotle wave aimed at
finishing as much of `Sources/NullStrand_Lean_Roadmap_Improved.md` as is achievable.
The run should maximize kernel-checked finite theorem progress, clean draft
handoffs, and strategy reports that clarify claim boundaries.

Claude should not treat throughput as success. The desired output is a reviewed
ledger of useful theorem islands, failed or refuted targets, and next actions.
Trusted code may be promoted only after semantic review and normal Lean
verification.

## Operating Rules

1. Reconcile existing Aristotle state first:

   ```powershell
   aristotle list --limit 50
   ```

2. Avoid duplicate submissions for nearby running or completed jobs.
3. Submit jobs one at a time, but keep 20+ active jobs when Aristotle capacity
   allows and the jobs are genuinely independent.
4. Prefer focused standalone packages for finite algebra, stochastic matrices,
   finite graphs, and support lemmas.
5. Use full-repo packages only when the target genuinely needs the `PhysicsSM`
   import graph.
6. Poll every 30-45 minutes, not constantly.
7. Integrate nothing automatically into trusted code.
8. Update one overnight ledger with every project ID, task ID, target, status,
   result, verification command, and next action.

## Initial Job Wave

Aim for 24-30 jobs in the initial wave, with at least 20 submitted early if 
preflight checks are clean.

Strategy and audit jobs:

- global roadmap dependency audit;
- finite complete-model endpoint strategy;
- continuum gate strategy;
- graph/super-Dirac gate strategy.

Null fiber and finite design:

- `nullFiber_equiv_restSphere`;
- `restToNull_isFutureNull`;
- `nullToRest_tangent`;
- `octaDirection_sum_eq_zero`;
- `octaNull_mean_eq_timelike`.

Zig-zag and rates:

- `minimalRates_nonneg`;
- `minimalRates_netTransfer`;
- `minimalRates_masterEquation`;
- `entropicTraffic_product_eq_referenceSq`.

Finite null lift:

- `residualCurrent_antisymm`;
- `residualCurrent_divergence_eq`;
- `minimalAngularRates_masterEquation`;
- `finiteNullLift_equivariant`.

Ergodic refresh chain:

- `refreshKernel_invariant`;
- `refreshKernel_reversible`;
- `refreshKernel_eigen_on_meanZero`;
- `refreshKernel_spectralGap_eq_r`.

Bell/QFT and support:

- `quantumCurrent_antisymm`;
- `minimalBellRate_nonneg`;
- `minimalBellRate_masterEquation`;
- `operatorSupport_implies_bellCurrentSupport`.

Entanglement and synchronization:

- `productPureProjectorMixture_isSeparable`;
- finite `productDirectionRepresentation_iff_separable` audit;
- `synchronizationDiamondDefect_eq_zero_iff_orderIndependent`.

## Claude's Role

Claude is the coordinator and reviewer, not the main proof-search engine.

Claude should:

- prepare clean theorem statements and focused handoff files;
- add documented draft placeholders only in appropriate draft or handoff files;
- generate context packs for nontrivial jobs;
- submit the Aristotle wave;
- monitor and download completed projects;
- inspect diffs and helper reports before reading whole output trees;
- verify statement identity and convention alignment;
- run targeted Lean checks on candidate files;
- classify each roadmap target as `BANKED`, `READY`, `CONDITIONAL`, `OPEN`, or
  `NO-GO` after review.

## Integration Rule

For each completed Aristotle project:

1. Run the dry-run integration helper or inspect the returned diff.
2. Scan executable Lean for forbidden placeholder or escape-hatch tokens.
3. Run the smallest relevant check, usually:

   ```powershell
   lake env lean PhysicsSM/Path/To/File.lean
   lake build PhysicsSM.Path.To.Module
   ```

4. Keep the result in draft unless trusted promotion is explicitly reviewed.
5. Record any new assumptions, convention changes, failed targets, or proof
   holes in the ledger.

## Stop Conditions

Pause broad submission and report if:

- two jobs in the same lane fail because definitions are malformed;
- a proof needs assumptions that change the physics content;
- Aristotle weakens a theorem statement;
- a convention mismatch appears in signs, metric signature, basis order,
  chirality, or normalization;
- jobs repeatedly spend their budget on broad builds;
- completed outputs pile up faster than Claude can triage them;
- the roadmap classification changes materially.

## Final Handoff

Claude should finish with:

```text
Summary:
- jobs submitted:
- jobs completed:
- jobs integrated or staged:
- strongest theorem progress:
- strongest strategy/audit result:

Files changed:
- ...

Verification:
- targeted checks run:
- full build/pre-commit status:

Provenance:
- Aristotle project IDs:
- context packs:

Remaining issues:
- failed/refuted targets:
- next highest-value jobs:
```

The guiding principle is: large Aristotle wave, conservative trusted claims.

## Agreed run configuration (2026-06-25, post-review)

These decisions refine the plan above and take precedence where they differ.

### Phase 0 — resume state (current session, do/verify FIRST)

**Source of truth.** The improved planning pack in `Sources/`
(`NullStrand_Lean_Theorem_Manifest_Improved.csv`/`.json`, `..._PR_Backlog.csv`,
`..._Roadmap_Improved.md`, `..._Blueprint_DAG.dot`, `..._Charter.md`,
`..._Claim_Traceability.csv`) **supersedes the legacy "Initial Job Wave" list
above (lines ~37-89)**. Use the manifest node IDs + per-node
`statement`/`assumptions`/`dependencies`/`proof_strategy`/`mathlib_gap` and the
`PR00-PR28` backlog (`parallel_track` column = independent lanes) as the wave
source. Do not submit jobs under the old legacy declaration names.

**Aristotle key: FIXED.** The stale key was an `env` block in
`.claude/settings.local.json` (removed). Bare `aristotle list` now authenticates;
no `--api-key` needed. Helper scripts read the env correctly now.

**Already harvested.** `736a0429` (roadmap-improve) output == the new `Sources/`
pack above (integrated by the user). `81428b35` (finite-core proof) inspected:
~10 finite targets proved, but it is a standalone snapshot that gutted
`Conventions.lean`; port only theorem-level fixes, prune the duplicates listed in
step 1 below. Do NOT overwrite live `Conventions.lean`/`FiniteCore.lean`.

**Green-tree progress (G0/AUD-001), live `PhysicsSM/NullStrand/`:**
- green: `ZigZag.ChiralCurrent` (`Complex.normSq_pos` + `nlinarith`).
- patched, pending final build: `ZigZag.QuantumWalk` (added `open Filter` +
  `open scoped Topology`), `Master.FiniteModel`, `Master.FoliatedManyParticle`
  (proof-carrying witness fields), `Entanglement.ProductNullRepresentation`
  (`lambda`->`w`, `Type*`->`Type`).
- `Clock.InternalHolonomy`: `internalHolonomy_gaugeCovariant` fixed
  (unitarity telescoping). REMAINING real work = HOL-002 matrix-exp gap: the
  `internalSegment` def must use `NormedSpace.exp ℂ` (not bare `exp`, which
  resolves to `Complex.exp`), and `internalSegment_unitary_of_hermitian` /
  `internalHolonomy_unitary_of_hermitian` need the skew-adjoint->unitary glue
  (`NormedSpace.exp_mem_unitary_of_mem_skewAdjoint` exists; membership proof is
  nontrivial). -> hand to Aristotle (PR15/HOL); leave a documented handoff
  `sorry` meanwhile so the tree builds.

**Immediate task queue (carried from this session's todos):**
1. Finish greening the tree: confirm `QuantumWalk` builds; settle
   `InternalHolonomy` (def fix + unitary handoff); then full
   `lake build PhysicsSM.NullStrand`.
2. Freeze the foundation layer (`Conventions`/`FiniteCore`); confirm the manifest
   primitives exist or record gaps: `Minkowski4`, `minkowskiInner`, `IsFutureNull`,
   `NullFiber`, PMF-based `FiniteNullResolution`, `expectation`.
3. Create one canonical frozen-foundations file shipped into every focused package
   (the parallelism enabler: identical defs across parallel jobs, cheap builds).
4. Build the wave from the manifest: map nodes->jobs by `parallel_track` lane;
   PR00/PR01/PR02 (foundations) gate the rest and freeze first; then fan out the
   independent lanes. Dedupe vs `81428b35`.
5. Create the ledger; validate the pipeline on one focused package; submit the wave.

**Integration safety (re-add):** during integration, explicitly verify each
returned theorem's statement was NOT weakened/renamed before accepting (compare
signatures against the manifest); a silent weakening is a named stop condition.

### Launch sequence (do in order)

1. **Harvest the two finished jobs first** (they reshape the wave):
   - `736a0429` null-strand-roadmap-improve -> corrected roadmap + review.
     Build the wave on the corrected statements/classifications, not the
     originals (the original roadmap contains false/vacuous/underspecified
     statements).
   - `81428b35` null-strand-finite-core-proof -> already proved ~10 finite
     targets. PRUNE these from the wave: `quantumCurrent_antisymm`,
     `minimalBellRate_masterEquation`, `operatorSupport_implies_bellCurrentSupport`,
     `productDirectionRepresentation_iff_separable`, plus the FockCutoff /
     MinimalJumpRates / SeparabilityObstruction / Master fixes.
2. **Green the live tree** before relying on `lake build` for integration checks.
   Still-broken modules: `NullStrand.ZigZag.QuantumWalk`,
   `NullStrand.ZigZag.ChiralCurrent`, `NullStrand.Clock.InternalHolonomy`.
   (`Master.FiniteModel`, `Master.FoliatedManyParticle`,
   `Entanglement.ProductNullRepresentation` already patched this session,
   pending a build.)
3. **Submit the wave (go big, 20-30)** on vetted, typechecking statements only,
   with duplicates pruned. Statement quality gates throughput, not Aristotle
   capacity: do not fire half-specified `...` sketches.

### Execution mechanics

- **Self-pace with `ScheduleWakeup`** (~40-min cadence) to poll/triage/submit
  across the night. Sleep longer (1200s+) when idle to stay cache-friendly.
- **Auxiliary models** (every output kernel-checked with `lake env lean`, never
  trusted raw; no promotion without semantic review):
  - DeepSeek-Prover-V2-7B (`ollama run hf.co/mradermacher/DeepSeek-Prover-V2-7B-GGUF:Q6_K`)
    = cheap first pass on small finite goals before spending Aristotle budget.
  - gemini-3.1-pro (`gemini -p`, model `gemini-3.1-pro-preview`) = parallel
    statement drafting + independent convention/sign reviewer. Not usable as a
    Claude subagent.
- **Ledger:** `AgentTasks/null-strand-overnight-ledger-2026-06-25.md` (create at
  run start; one row per project: id, task id, target, status, result,
  verification command, next action).

### Added stop conditions

- Aristotle auth/key failure (stop, do not burn the night retrying).
- Time/budget cap reached.
- The `736a0429` review reclassifies a queued target as false/OPEN -> drop it.
