# Finite diagonal causal support Aristotle task

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: submitted

## Target

Prove that a finite massive scattering response built from a massless kernel
`G0 = b * I + N`, with strict-past-supported `N`, has a local diagonal contact
coefficient and a strict-past-supported remainder. This is the exact finite
support decomposition needed for kernels such as a truncated `exp(L)`.

The public statements are in:

`AgentTasks/aristotle-standalone/finite-diagonal-causal-support-20260717/FiniteDiagonalCausalSupport/DiagonalSupport.lean`

The semantic context pack is:

`AgentTasks/context-packs/finite-diagonal-causal-support-20260717-20260717-060913.md`

## Statement lock

Aristotle may add local helper lemmas but must not weaken or change the public
definitions or theorem statements. In particular:

- matrix rows remain targets and columns remain sources;
- the contact coefficient remains `b / (1 + c * b)`;
- the off-diagonal remainder must use the supplied transitive strict past;
- no positivity assumption may be added;
- the theorem must not reinterpret the diagonal contact term as propagation.

## Mathematical sketch

For positive `H`, split the finite geometric inverse into its `k = 0` term
`a^-1 * I` and positive powers of `N`. Every positive power of a
strict-past-supported matrix remains supported in the same strict past. Expand

```text
(b I + N)(a^-1 I + R)
```

with `a = 1 + c b`. The diagonal term is `b a^-1 I`; all other terms contain
at least one strict-past-supported factor. Irreflexivity then gives the exact
diagonal value, while identity-matrix off-diagonal entries vanish.

## Literature context

Hinrichsen and Kastrati, arXiv:2604.24812, propose a normalized `exp(L)` as a
link-based massless retarded kernel in `1+1` dimensions. Its identity term is a
contact contribution. This task proves only the finite support split and does
not prove their continuum normalization or transfer it to four dimensions.

## Verification contract

Run first:

```text
lake env lean FiniteDiagonalCausalSupport/DiagonalSupport.lean
```

Return the completed target file and a short report listing solved targets,
any statement changes, remaining proof holes, and assumptions used.

## Aristotle metadata

```yaml
aristotle:
  project_id: e96fbff2-66b7-4319-943f-07f09f5bd64d
  task_id: b222c27f-8679-4a55-ad6b-82edd8299397
  target_file: FiniteDiagonalCausalSupport/DiagonalSupport.lean
  expected_module: FiniteDiagonalCausalSupport.DiagonalSupport
  submission_project: AgentTasks/aristotle-submit/finite-diagonal-causal-support-20260717-project
  output_dir: AgentTasks/aristotle-output/e96fbff2-66b7-4319-943f-07f09f5bd64d
  status: submitted
```
