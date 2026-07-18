# Aristotle job: finite greedy maximum-coverage core

Date: 2026-07-16  
Status: INTEGRATED  
Work item: `GRAV-ATLAS-PACKING-001`

```yaml
aristotle:
  project_id: 393284aa-586d-4bcd-ad15-f03d63a1131f
  task_id: TBD
  target_file: GreedyCoverage/GreedyCoverage.lean
  expected_module: GreedyCoverage.GreedyCoverage
  submission_project: AgentTasks/aristotle-submit/greedy-coverage-20260716-project
  source_root: AgentTasks/aristotle-standalone/greedy-coverage-20260716
  output_dir: AgentTasks/aristotle-output/393284aa-586d-4bcd-ad15-f03d63a1131f
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/GreedyAtlasCoverage.lean
```

## Motivation and boundary

The frozen A3f-R1 uniform outer atlas had abundant candidates and correctly
calibrated individual protected-core sizes, but almost every pair of sampled
cores overlapped. A separately preregistered successor may therefore select an
atlas by order-only marginal coverage of an independently defined order bulk.

The proof target is generic finite combinatorics. It does not assert that a
causal candidate family contains a good cover, does not choose a physical
metric, and does not open the source/operator or G2 gates.

## Exact targets

Do not weaken or alter these statements:

1. `exists_marginal_card_mul_ge_uncovered`: for every nonempty benchmark
   family, one member's marginal gain times the benchmark cardinality is at
   least the benchmark union still uncovered.
2. `greedy_marginal_card_mul_ge_uncovered`: any marginal maximizer over a
   larger available family obeys the benchmark bound.
3. `residual_contract`: the average-gain inequality implies one-step
   contraction by `1-1/k` over the rationals.

The file already proves the union/difference identity, geometric iteration,
event-relabeling preservation of marginal gain, and a singleton anti-vacuity
control. Aristotle may add small helper lemmas but must preserve all public
signatures.

## Headline composition check

The separate Mathlib-only companion
`GreedyCoverage/GreedyCoverageHeadline.lean` now kernel-checks two additional
statements without proof holes:

- `geometric_residual_bound_upto`, which needs the contraction hypothesis only
  through the displayed finite horizon; and
- `finite_greedy_coverage_factor`, which derives
  `(1 - (1 - 1/k)^k) * optimum <= covered k` from the preregistered one-step
  contraction and zero initial coverage.

Verified locally with:

```text
lake env lean AgentTasks/aristotle-standalone/greedy-coverage-20260716/GreedyCoverage/GreedyCoverageHeadline.lean
```

`lean_verify` reports the standard Mathlib footprint
`[propext, Classical.choice, Quot.sound]` for both companion theorems and no
source-scan warnings.

This composition uses total covered cardinality. A parked alternative based on
intersection with the benchmark union is rejected: for `K=2`, family
`{{0},{1,2}}`, first greedy pick `{1,2}`, and benchmark `{{0}}`, the proposed
intersection deficit remains one and would require `2 <= 1`.

## Suggested proof architecture

- Rewrite the uncovered benchmark union using
  `coveredBy_sdiff_eq_biUnion_sdiff`.
- Bound the cardinality of the finite union by the sum of marginal
  cardinalities (`Finset.card_biUnion_le` or a direct induction).
- Use a finite average/pigeonhole argument: if every summand were too small,
  their sum would be too small.
- Derive the greedy theorem from the witness and `hmax`.
- Clear the positive rational denominator in `residual_contract` and finish by
  ordered-ring arithmetic.

## Preflight

Run the narrow command first:

```text
lake env lean GreedyCoverage/GreedyCoverage.lean
```

The submission is Mathlib-only and intentionally self-contained, so a semantic
context pack is unnecessary. Completion report must list solved targets,
statement changes (expected: none), remaining proof holes, and axiom footprint.

## Submission record

Submitted as Aristotle project
`393284aa-586d-4bcd-ad15-f03d63a1131f` from
`AgentTasks/aristotle-submit/greedy-coverage-20260716-project`. The AFPL
registry records it as running under `GRAV-ATLAS-COVERAGE-001`.

## Local kernel closure while Aristotle is queued

At 2026-07-16 08:18 PDT, a concurrent Codex worker filled the three live
standalone proof bodies without changing any public signature or modifying the
frozen submission copy. Codex then independently ran:

```text
lake env lean AgentTasks/aristotle-standalone/greedy-coverage-20260716/GreedyCoverage/GreedyCoverage.lean
```

The file typechecks without proof gaps. A source scan found no placeholder or
trust-expanding constructs. Lean MCP verification reports exactly
`[propext, Classical.choice, Quot.sound]` for the three target theorems, the
geometric iteration theorem, and the event-relabeling theorem. The finite
maximum-coverage composition using total covered cardinality is separately
kernel-checked in `GreedyTotalResidual.lean`.

At the time of that local closure, project
`393284aa-586d-4bcd-ad15-f03d63a1131f` remained queued as an independent proof
replay. The subsequent harvest is recorded below; the local closure is not
being mislabeled as an Aristotle result.

## Aristotle harvest and integration

The project became `IDLE` with its sole task labeled `CANCELED`, but the
downloadable archive nevertheless contained a complete
`GreedyCoverage/GreedyCoverage.lean` with all three frozen proof targets filled.
The returned file:

- has no changed theorem or definition signature;
- has no remaining proof placeholder or trust-expanding declaration;
- passes `lake env lean` locally; and
- reports exactly `[propext, Classical.choice, Quot.sound]` for all three
  returned target theorems under Lean MCP verification.

The returned proof bodies differ from the independently obtained local proofs.
The cleaner local versions, together with the independently checked finite-
horizon headline theorem, were integrated as:

```text
PhysicsSM/Draft/NullEdge/GreedyAtlasCoverage.lean
```

The integration is build-pinned with four `#guard_msgs` axiom-footprint blocks.
Verification actually run:

```text
lake env lean PhysicsSM/Draft/NullEdge/GreedyAtlasCoverage.lean
lake build PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage
```

The targeted build completed all `8026` jobs. It emits only existing-style
unused-decidability lint warnings inherited from the frozen generic signatures;
there are no errors.
