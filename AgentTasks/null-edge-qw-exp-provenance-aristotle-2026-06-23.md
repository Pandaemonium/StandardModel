# Aristotle task: null-step quantum-walk exponential provenance

Target project: `null-edge-qw-exp-provenance-20260623`

Target file:

```text
NullEdgeQWExpProvenance/Core.lean
```

```yaml
aristotle:
  project_id: 0c78bae6-b4b2-4643-907c-a7ec5e4b276d
  target_file: NullEdgeQWExpProvenance/Core.lean
  expected_module: NullEdgeQWExpProvenance.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-qw-exp-provenance-20260623-project
  status: integrated
```

Goal: close the two proof holes in a focused standalone Mathlib package.

Scientific value: the integrated null-step quantum-walk core defines the `Rz`
and `Rx` gates by Euler closed forms. That is enough for the trace, determinant,
quasienergy, and coherence-limit theorems, but publication prose naturally
writes the walk as a product of matrix exponentials. These lemmas certify that
the closed-form gates match that notation.

Requested targets:

```lean
Rz_eq_exp
Rx_eq_exp
```

Downstream theorem:

```lean
Ua_eq_exp_product
```

Allowed imports: `Mathlib`.

Local pre-submit check:

```powershell
lake env lean AgentTasks\aristotle-standalone\null-edge-qw-exp-provenance-20260623\NullEdgeQWExpProvenance\Core.lean
```

Expected warning before Aristotle: two intentional proof-hole warnings.

Required final report:

- solved target names;
- whether any theorem statement or definition changed;
- any remaining proof holes or placeholder constructs;
- exact Lean command run;
- a x i o m profile if available.
