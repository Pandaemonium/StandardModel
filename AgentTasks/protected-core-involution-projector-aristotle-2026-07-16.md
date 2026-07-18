# Aristotle job: equivariant involution projector

Date: 2026-07-16  
Work item: `GRAV-GROWING-ATLAS-001`

```yaml
aristotle:
  project_id: e7204f14-dcb9-4f2d-b116-f46a250b67d3
  task_id: 47040e53-ccbe-4e18-ad7d-abb94e85481c
  target_file: InvolutionProjector/InvolutionProjector.lean
  expected_module: InvolutionProjector.InvolutionProjector
  submission_project: AgentTasks/aristotle-submit/protected-core-involution-projector-20260716-project
  source_root: AgentTasks/aristotle-standalone/protected-core-involution-projector-20260716
  output_dir: AgentTasks/aristotle-output/e7204f14-dcb9-4f2d-b116-f46a250b67d3
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/EquivariantInvolutionProbeProjector.lean
```

## Exact target

Prove the four displayed theorems without changing any definition or theorem
statement:

1. `(I + J) / 2` is idempotent when `J^2 = I` pointwise;
2. its range is exactly the `+1` eigenspace;
3. an intertwiner of involutions intertwines the positive projectors; and
4. a linear equivalence maps one positive-projector range exactly to the other.

The final rank-four constructor should then elaborate from those proofs. Small
private helper lemmas are welcome.

## Scientific purpose

`ProtectedCoreProbeProjectorTransition.lean` now derives pair transitions on
the actual atlas overlap, but it still takes every local rank-four projector as
input. A graph-native real involution would supply a more structured candidate:
its `+1` sector is selected by an idempotent polynomial in the operator, so no
eigenvector ordering or preferred frame is needed. The exact remaining physics
gate becomes the construction of an equivariant graph involution with a stable
four-dimensional positive eigenspace and Lorentzian form.

This job does not construct that involution, prove rank four on graph data,
derive signature, or establish overlap liftability/injectivity.

## Constraints

- Preserve `Real`, the coefficient `(2 : Real)⁻¹`, pointwise involution and
  intertwining hypotheses, exact range equality, and exact finrank `4`.
- Do not replace range equality by one inclusion.
- Do not add self-adjointness, finite-dimensionality, or spectral assumptions;
  they are unnecessary for these polynomial identities.
- Do not introduce new assumptions or weaken statements.
- Use kernel-checked tactics only; do not use the compiled evaluator.
- Finish with a concise report of solved targets, statement changes, remaining
  proof handoffs, and assumptions used.

## Preflight and context

- Lean Explore found `Module.End.eigenspace` as the standard Mathlib object.
- The semantic context-pack command failed silently after 96.6 seconds and
  produced no artifact. The target is therefore deliberately self-contained
  and Mathlib-only rather than relying on an incomplete context selection.
- Local target elaboration and the focused-package preparation check must pass
  before submission.

## Submission

Submitted project `e7204f14-dcb9-4f2d-b116-f46a250b67d3`, task
`47040e53-ccbe-4e18-ad7d-abb94e85481c`, after the standalone target passed
`lake env lean` with exactly the four intended proof-hole warnings. The CLI's
missing-`.lake` warning is expected for this focused source-only package; its
Mathlib dependency is declared by the generated Lake project.

## Harvest and integration

The returned file preserved every definition and public theorem statement,
contained no proof holes or escape hatches, and passed direct local Lean
verification. Its four proofs were integrated into
`PhysicsSM/Draft/NullEdge/EquivariantInvolutionProbeProjector.lean` under the
project namespace. The integration adds the reverse polynomial identities
`P -> 2P-I -> P` and `J -> (I+J)/2 -> J`, making explicit that an involution
does not supply graph structure for free, plus the carrier-facing rank-four
projector constructor.

Verification:

- `lake env lean PhysicsSM/Draft/NullEdge/EquivariantInvolutionProbeProjector.lean`
- `lake build PhysicsSM.Draft.NullEdge.EquivariantInvolutionProbeProjector`
  (`8038` jobs)
- Lean MCP source/axiom audit on the forward range theorem, range transport,
  reverse involution theorem, and carrier constructor: only `propext`,
  `Classical.choice`, and `Quot.sound`; source scan clean.
- Build-enforced axiom guards pass in the integrated module.

Independent Claude semantic review returned `APPROVED` with no revisions in
`AutonomousLab/reviews/CLAUDE_REVIEW_INVOLUTION_PROBE_PROJECTOR_2026-07-16.md`.
It confirmed signature identity under the disclosed rename, the intentional
carrier-package specialization, both hypothesis-free round trips, and the
claim boundary that no graph involution, gap, inertia, or overlap compatibility
is derived.
