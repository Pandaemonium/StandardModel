# Aristotle task: HNU stay-sector coverage and no-global-stasis theorem

## Scientific question

The exact HNU real-space construction has a stationary complementary sector in
every projector-conditioned substep.  Is this merely finite-depth circuit
scheduling, or is there a nonzero microscopic state that can remain stationary
through the full period?

## Target

Prove all four holes in `HNUStayCoverage/Coverage.lean` without changing the
landed HNU definitions, signs, factor order, or Pauli conventions.

The key payloads are:

1. the eight moving projectors sum exactly to `4 I`;
2. every individual factor has a nonzero stay sector;
3. the intersection of all stay sectors is zero.

If any statement is false, return the smallest explicit complex spinor
counterexample and a corrected theorem.  Do not promote the result to doubler
removal, anomaly cancellation, or a continuum theorem.

## Verification

Run:

```text
lake env lean HNUStayCoverage/Coverage.lean
```

No new assumptions or compiler-trusted decision procedures.  Finish with an
axiom report and a one-paragraph interpretation of whether the stay sector is
substep scheduling or genuine full-period stasis.

## Aristotle metadata

```yaml
aristotle:
  project_id: 09a028fc-585e-4cbf-ab86-f6fbc352bb42
  task_id: 31f1fef7-8537-43a0-843b-9df6039227a9
  target_file: HNUStayCoverage/Coverage.lean
  expected_module: HNUStayCoverage.Coverage
  submission_project: AgentTasks/aristotle-submit/hnu-stay-coverage-20260719-v2-project
  output_dir: AgentTasks/aristotle-output/09a028fc-585e-4cbf-ab86-f6fbc352bb42
  status: integrated
```

Submitted on 2026-07-19. Initial task state: `IN_PROGRESS`.

## Harvest result

Task completed without statement changes. Aristotle proved the exact movement
budget, a nonzero stationary sector for every distinct conditioned Pauli
factor, zero intersection for the full schedule, and the sharper fact that the
opposite `sigma1` factors already force zero. The returned file was downloaded,
reviewed for the original factor order and signs, and integrated as
`PhysicsSM/Draft/NullEdge/HNUStayCoverage.lean`.
