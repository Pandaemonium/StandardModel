# Active 30-cycle run: cycle 5 C107b/C110b progress

Date: 2026-06-27

## Summary

Cycle 5 advanced both finite projector algebra and path-sum kernel control.

## C107b completed and preserved

Project:

```text
96cce035-7b33-4df7-9b83-64e97bb67554
```

Task:

```text
1a01a781-2dc7-42e5-9c5e-42ce9eba65ba
```

Recovered file:

```text
AgentTasks/aristotle-standalone/c107b-polynomial-projector-idempotence-20260627/C107bPolynomialProjector/PolynomialProjector.lean
```

Preserved theorem stack:

- `polynomial_projector_idempotent`
- `polynomial_projector_idempotent_of_aeval_mul_eq`

Status:

```text
recovered_source_preserved_not_locally_verified
```

## C110b submitted

Project:

```text
9650d454-c348-4c88-86ce-f4e99196518e
```

Task:

```text
c03a6d2c-0853-4125-836b-851c86d8152e
```

Target:

```text
AgentTasks/aristotle-standalone/c110b-normed-path-shell-kernel-bridge-20260627/C110bPathShellKernel/NormedPathShell.lean
```

Purpose:

- Prove the normed finite path-shell kernel bridge:
  per-path norm bound plus shell cardinality bound implies a norm bound on the
  finite shell amplitude sum.

Claude review:

```text
AgentTasks/model-calls/claude/2026-06-27-153535-cycle5-c110b-normed-shell-review.md
```

Verdict:

- Accept with caveats.
- `SeminormedAddCommGroup E` is the right abstraction.
- The immediate successor after C110b should be a Banach-valued summability
  bridge over length-indexed shells.

## Literature search

Query/source:

```text
neo4j_paper_search.py --chunks --query
"finite polynomial spectral projector idempotent matrix polynomial functional calculus gauge covariance chiral lattice"
```

Useful hits:

- Causal-set functional-calculus chunks support the general spectral/functional
  calculus direction, though not directly the finite matrix theorem.
- Nielsen-Ninomiya extension chunks reinforce why projector/gauge covariance
  must not be overclaimed as C1 release.
- Luescher/Ginsparg-Wilson chunks remain the main comparison class for exact
  lattice chiral symmetry and non-ultralocal operators.

Plan impact:

- No change to the plan. C107b remains the right finite algebra theorem before
  projector covariance assembly.

## Tool friction

`aristotle show` hit a Windows `cp1252` Unicode encoding crash when the output
contained Lean symbols. Mitigation:

```powershell
$env:PYTHONIOENCODING='utf-8'; aristotle show <project> --limit 100
```
