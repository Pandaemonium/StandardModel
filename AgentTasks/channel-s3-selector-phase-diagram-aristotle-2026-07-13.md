# Aristotle proof job: exhaustive S3 quadratic-selector phase diagram

- Work item: `LAB-BOOTSTRAP-001`
- Role: Builder / Registrar
- Date: 2026-07-13
- Target: `AgentTasks/aristotle-targets/afpl_s3_selector_phase_diagram.lean`
- Aristotle project: `81bc8433-2f6a-4c6f-a39e-66588595d2a0`

## Mission

Prove exactly the three target holes without changing imports, definitions,
theorem statements, namespace, or semantic scope.

The landed candidate `S3QuadraticSelectorClassification` proves that full
permutation symmetry leaves two coefficients and that `d < a` gives a unique
equal-third minimizer on a fixed-total fibre. Complete the remaining
classification:

1. exact cost along the transverse ray `(t,-t,s)`;
2. unbounded-below cost when `a < d`;
3. one capstone that registers all three regimes.

For the unboundedness proof, use an Archimedean or square-growth witness that
works for every real threshold `B`; do not hide the result behind a supplied
large-`t` assumption.

## Boundaries

- Do not infer that physics or information theory selects a metric.
- Do not add nonnegativity constraints on channel coordinates; this theorem is
  the unconstrained affine fixed-total classification.
- Do not weaken unbounded-below to one negative witness.
- No trust expansion.

## Acceptance

`lake env lean AgentTasks/aristotle-targets/afpl_s3_selector_phase_diagram.lean`
must pass with no remaining proof holes. Report the proof route and why each
sign regime is exhaustive.
