---
project_id: 64c63643-d56a-4bd8-b8a9-63607dda516c
task_id: 23a19849-2a9a-4d41-9cc3-54689431fc76
status: integrated
created: 2026-06-27
round: gate-c1-breakthrough-round-3
output_dir: AgentTasks/aristotle-output/64c63643-d56a-4bd8-b8a9-63607dda516c
---

# Aristotle C148: finite seed to near-origin branch-line theorem

Goal: Bridge the finite origin/qutrit seed to the branch-line topology formulation of Gate C1.

Context: The finite seed passes the algebraic origin audit, but Gate C1 is a branch-line selection problem over a branch locus. We need to connect finite origin data to a stable near-origin branch projector and Weyl tangent behavior.

Requested deliverables:

1. State a theorem from finite origin sign-kernel data plus spectral-island/gap hypotheses to a stable near-origin projector.
2. Use C121-style Riesz/projector stability where appropriate.
3. Include conditions for a physical Weyl line/tangent residue and a true inverse-propagator gap on the complement.
4. Identify counterexamples where origin trace is nonzero but no stable branch projector exists.
5. Separate finite algebra, analytic branch-regularity assumptions, and physics interpretation.

Success criterion: a precise bridge theorem from C141-style finite seed to Gate C1 branch-line language.

## Submission status

Submitted on 2026-06-27. Project: 64c63643-d56a-4bd8-b8a9-63607dda516c. Task: 23a19849-2a9a-4d41-9cc3-54689431fc76.

## Completion summary

Integrated on 2026-06-27.

Aristotle delivered a standalone Lean artifact in `RequestProject/Main.lean`.
The reported artifact builds in the Aristotle environment, has no proof
placeholders, and its main theorems depend only on the standard Lean axioms
reported by Aristotle: `propext`, `Classical.choice`, and `Quot.sound`.

Downloaded archive:

```text
AgentTasks/aristotle-output/64c63643-d56a-4bd8-b8a9-63607dda516c/project.zip
```

Key reported declarations and concepts:

- `SignKernel`: finite origin sign-kernel package for `S = sign(H_ne)`.
- `BranchInvolution`: branch-reflection package for `J`.
- Branch projector `P = (1 - S) / 2` and complement `Q = (1 + S) / 2`.
- `InversePropagatorGap`: quantitative true inverse-propagator gap.
- `gap_persists`: sub-gap perturbations preserve invertibility.
- `finite_seed_to_branch_projector`: finite seed plus sign-kernel selection
  invariant plus true gap gives a stable branch projector.
- `witnessSeed`: non-vacuous two-dimensional witness.
- `counterexample_no_stable_projector`: nonzero origin trace without an
  inverse-propagator gap does not give stable branch selection.
- `counterexample_trace_without_selection`: ordinary trace is not the branch
  selection invariant; the relevant invariant is `J`-graded.

## Integration interpretation

C148 materially improves the Gate C1 bridge story. It shows that the finite
seed can be promoted to a stable branch-projector certificate if it is packaged
with a true inverse-propagator gap and a nonzero `J`-graded sign-kernel
selection invariant.

The result does not by itself close physical Gate C1. The identifications of
the `J`-graded trace with the intended null-edge branch invariant, and of the
persisting finite gap with a physical Weyl tangent/residue statement, remain
theorem-design/physics interpretation layers. They must be connected to the
reference-kernel import package, branch-line analytic hypotheses, SM gauge
internality, bad-sector overlap gap, anomaly/index import, and non-ultralocal
control certificates.

## Status after integration

This job is integrated into the documentation/status layer. The Lean artifact
has not been promoted into the live `PhysicsSM` source tree.
