# Stress-energy full-variation uniqueness: Aristotle semantic audit v2

```yaml
aristotle:
  project_id: 0478b860-0361-49f3-8e19-9691a6a214f6
  task_id: 2dd517a8-c78f-4498-a034-827b9b75ba79
  target_file: PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean
  expected_module: PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls
  submission_project: AgentTasks/aristotle-submit/null-edge-stress-energy-controls-v2-20260714-project
  output_dir: AgentTasks/aristotle-output/0478b860-0361-49f3-8e19-9691a6a214f6
  status: complete and harvested 2026-07-15
```

## Objective

Repeat the G6-G8 audit on the exact live target after addition of the full
symmetric-variation uniqueness theorem and integration of the first audit's
convention corrections. The main question is whether equality of Frobenius
responses on all symmetric probes really identifies two symmetric component
tensors, and exactly how far this advances the physical stress-energy bridge.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-stress-energy-controls-v2-20260714-20260715-000126.md
```

## Locked interpretation

1. The scalar witnesses concern only `T_00` and ordinary matrix trace.
2. `metricVariationPairing` is a finite Frobenius pairing. It is an algebraic
   model of a first variation, not a functional derivative of an action.
3. The uniqueness theorem says that two symmetric matrices with equal response
   on every symmetric matrix variation are equal. It does not construct the
   response, prove locality/covariance, insert a volume density, or derive
   conservation.
4. The weak-field theorem remains an arithmetic normalization control with the
   displayed mostly-minus-compatible assumptions and zero cosmological term.
5. The dust and radiation theorems remain conditional natural-unit continuity
   checks, not derived FLRW dynamics.

## Required audit

1. Run only the focused target command
   `lake env lean PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean`.
2. Verify the symmetric probes, including the doubled diagonal case, and the
   Frobenius extraction formula.
3. Test whether symmetry of both tensors and quantification over all symmetric
   variations are exactly sufficient for uniqueness; identify any redundant or
   missing finite-dimensional assumptions.
4. Audit the updated trace, density, signature, units, and cosmological-term
   prose.
5. Confirm the theorem is a constructive uniqueness statement but not a
   null-edge construction of physical stress-energy.
6. State a precise next theorem interface for first variation of the actual
   null-edge matter action, symmetry, and on-shell covariant conservation.

## Required report

Return command results, assumption footprints, theorem-by-theorem verdicts,
counterexample attempts at weakened hypotheses, exact prose corrections, and a
G6-G8 ledger separating algebraic identification from graph-derived physics.

## Harvested result

The required direct Lean command passed, no broad build was run, and every
definition and theorem statement was preserved. Aristotle confirmed that the
doubled diagonal probe extracts `2 * T i i`, which is harmless over the reals,
and that equality of all symmetric Frobenius responses identifies two symmetric
component matrices. It also supplied explicit skew-matrix counterexamples
showing why the symmetry hypotheses are load-bearing under the current
interface.

The audit emphasized that the pairing is finite and frame-component based. It
contains no functional derivative, integral, volume density, locality,
covariance, metric index convention, or conservation law. The returned prose
corrections making those limits explicit were integrated without altering any
declaration. The GR note was also tightened to distinguish metric,
inverse-metric, and coframe variation.

The next G6 target is a localized, measure-normalized first-variation theorem
for the actual matter action, with pointwise uniqueness obtained from compactly
supported variations and conservation derived from diffeomorphism invariance
plus the on-shell matter equation. The coframe branch additionally needs local
Lorentz invariance or a spin-current improvement.

Full downloaded audit:

```text
AgentTasks/aristotle-output/0478b860-0361-49f3-8e19-9691a6a214f6/extracted/project-files.tar/null-edge-stress-energy-controls-v2-20260714-project_aristotle/AgentTasks/null-edge-stress-energy-controls-v2-audit-report-2026-07-15.md
```
