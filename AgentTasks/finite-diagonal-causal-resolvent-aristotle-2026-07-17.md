# Finite diagonal causal resolvent Aristotle task

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: integrated

## Target

Prove the exact finite inverse and two-sided massive-scattering resolvent for a
massless kernel `G0 = b * I + N`, where `N` is nilpotent. Then close the explicit
three-event witness in which `G0` is the cube-zero truncated link exponential.

The public statements are in:

`AgentTasks/aristotle-standalone/finite-diagonal-causal-resolvent-20260717/FiniteDiagonalCausalResolvent/DiagonalResolvent.lean`

The semantic context pack is:

`AgentTasks/context-packs/finite-diagonal-causal-resolvent-20260717-20260717-054055.md`

## Statement lock

Aristotle may add local helper lemmas but must not weaken or change the public
definitions or theorem statements. In particular:

- both left and right resolvent identities must remain;
- the only invertibility hypothesis is `1 + c * b != 0`;
- nilpotence is stated for the off-diagonal remainder `N`;
- the three-event witness retains endpoint values `0`, `1/2`, and `-1/54`;
- matrix rows remain targets and columns remain sources.

## Mathematical sketch

For `a != 0`, factor

```text
a I + N = a (I + a^{-1} N).
```

The displayed `nilpotentInverse` is the terminating geometric series. Its left
and right products telescope to `I - (-a^{-1})^H N^H`, which is the identity
under the supplied nilpotence hypothesis. Expand

```text
I + c (b I + N) = (1 + c b) I + c N
```

and use `(c N)^H = c^H N^H = 0`. The explicit witness is a direct `Fin 3`
matrix calculation.

## Literature context

Hinrichsen and Kastrati, arXiv:2604.24812, propose the normalized `exp(L)` as a
link-based massless retarded kernel in `1+1` dimensions and then apply the usual
mass-scattering resolvent. This task proves only the finite
diagonal-plus-nilpotent algebra needed to represent that shape. It does not
prove their asymptotic analysis or transfer their normalization to four
dimensions.

## Verification contract

Run first:

```text
lake env lean FiniteDiagonalCausalResolvent/DiagonalResolvent.lean
```

Return the completed target file and a short report listing solved targets,
any statement changes, remaining proof holes, and assumptions used.

## Harvest and integration

Aristotle completed all five targets. An in-progress snapshot already contained
the final proof bodies; the completed-project dry-run scan subsequently found
no executable placeholders. The proofs were reviewed and ported without public
statement changes to:

`PhysicsSM/Draft/NullEdge/FiniteDiagonalCausalResolvent.lean`

The production module adds project provenance, clarifies that the identity term
is a contact convention rather than positive-length propagation, and carries
build-enforced axiom guards. It contains no proof holes. Focused verification
passed:

```text
lake env lean PhysicsSM/Draft/NullEdge/FiniteDiagonalCausalResolvent.lean
lake build PhysicsSM.Draft.NullEdge.FiniteDiagonalCausalResolvent
```

## Aristotle metadata

```yaml
aristotle:
  project_id: 18ad01bc-dd21-4cbe-9424-81ff8451d03f
  task_id: ca59452b-df79-423b-8a40-e8a673568d57
  target_file: FiniteDiagonalCausalResolvent/DiagonalResolvent.lean
  expected_module: FiniteDiagonalCausalResolvent.DiagonalResolvent
  submission_project: AgentTasks/aristotle-submit/finite-diagonal-causal-resolvent-20260717-project
  output_dir: AgentTasks/aristotle-output/18ad01bc-dd21-4cbe-9424-81ff8451d03f
  status: integrated
```
