# P9 defect/coarse-stability strategy job

Date: 2026-06-23.

```yaml
aristotle:
  project_id: cd647147-43b7-4ca2-a5ef-bc8e88b535c9
  task_id: 9ddbb804-85ba-47f4-b6f2-793ddfaa9560
  target_file: PROMPT.md
  expected_module: none
  submission_project: AgentTasks/aristotle-strategy-packs/null-edge-p9-defect-coarse-stability-strategy-20260623
  output_dir: AgentTasks/aristotle-output/cd647147-43b7-4ca2-a5ef-bc8e88b535c9
  status: strategy-reviewed
```

## Purpose

No-code Aristotle strategy/audit job for the P9 source-visibility branch.

The job asks Aristotle to design a Lean-friendly theorem and numerical target
ladder for three publishability gates:

- defect/curvature sensitivity;
- covariant coarse-graining stability;
- Sorkin-style fluctuation scaling from intrinsic graph/spectral data.

The prompt explicitly uses the corrected discrete-first gate: lack of a
pointwise microscopic continuum interpretation is not failure by itself.
Failure means the absence of a stable pre-specified coarse-grained,
renormalized, or observer-channel readout, or a readout that survives only by
hand-tuned weights, boundary artifacts, or geometry-blind statistics.

## Submission

Prompt:

- `AgentTasks/aristotle-strategy-packs/null-edge-p9-defect-coarse-stability-strategy-20260623/PROMPT.md`

Submitted Aristotle project:

- `cd647147-43b7-4ca2-a5ef-bc8e88b535c9`
  (`task_id: 9ddbb804-85ba-47f4-b6f2-793ddfaa9560`)

## Result note

Aristotle returned a useful no-code strategy. The main framing is that P9
should be treated as a kinematic filter that suppresses geometry-blind bulk
noise in an observer channel, not as a solved cosmological-constant problem.

The strongest near-term target it identified is:

> Find two finite causal sets with identical out-degree and interval-abundance
> histograms, separated by a frozen projected observer readout, and prove that
> the separation is invariant under order isomorphism and stable under a
> pre-specified Alexandrov or spectral coarse map with an explicit
> `N`-independent bound.

Key gates:

- defect/curvature sensitivity must perturb the causal relation or intrinsic
  order data, not only matrix weights;
- coarse-graining must use pre-specified maps such as Alexandrov interval
  blocks, spectral projectors, or graph reductions with cut/spectral
  guarantees;
- the Sorkin-style pilot should test `Delta R / mean(R) ~ 1 / sqrt(N)` against
  iso-histogram, random-weight, and boundary-stripped null controls;
- demote P9 if the readout requires observer tuning, depends on block/grid
  alignment, reduces to degree or interval histograms, leaks weight units, or
  has only a vacuous non-uniform coarse-stability bound.

This strategy sharpens the next proof batch: after the small
`NullEdgeP9DefectSensitivityBenchmark`, the publishable target should be an
iso-histogram separation or a frozen-observer coarse-stability theorem, not
more generic projector algebra.
