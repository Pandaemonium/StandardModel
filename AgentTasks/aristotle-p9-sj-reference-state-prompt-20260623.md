# Aristotle strategy/design job: Sorkin-Johnston (SJ) reference state for a finite diamond

```yaml
job_name: null-edge-p9-sj-reference-state-20260623
status: submitted
project_id: bff2387a-31ae-486d-b42a-66d2b76e50c8
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-sj-reference-state-20260623-project
target_file: AgentTasks/aristotle-p9-sj-reference-state-report.md
```

## Context

The P9 cosmological-constant / source-visibility branch uses finite causal diamond observables. One key ingredient is to define a discrete reference vacuum state (analogous to the Sorkin-Johnston vacuum) on the diamond, so that we can formulate data processing, relative entropy, and Bekenstein-bound type inequalities (Pillar 7).

In the continuum/causal-set literature, the Sorkin-Johnston (SJ) state is defined from the Pauli-Jordan function (retarded minus advanced Green's functions) projected onto its positive-spectrum subspace. However, in a finite diamond with causal relations, we need to explicitly write down the matrix definitions and identify the spectral truncation required to avoid infinite-energy or area-law mismatches.

## Assignment

Propose a written design note at:
`AgentTasks/aristotle-p9-sj-reference-state-report.md`

The design note must cover:
1. **Finite Causal Diamond representation:** Explicitly state the finite vertex set `V` and preorder relation `≺` representing the diamond structure.
2. **Pauli-Jordan Operator:** Define the retarded and advanced Green's functions `R` and `A` as matrices over `V`, and define the Pauli-Jordan operator `iΔ = i(R - A)`.
3. **SJ Projection:** Propose the spectral projection method to extract the positive-frequency subspace of the Hermitian matrix `iΔ`, yielding the SJ two-point function `W`.
4. **Spectral Truncation:** Detail Johnston's finite-density or spectral truncation required to obtain well-behaved area laws or physical correlators in the finite causal set.
5. **Entropy & Recoverability connection:** Link the SJ state to a relative-entropy convexity/monotonicity diagnostic along nested sub-diamonds.

Please end with this exact summary shape:

```text
overall assessment:
proposed core definitions:
spectral truncation formulation:
relative entropy / data-processing connection:
ranked next theorem signatures:
likely blockers:
```
