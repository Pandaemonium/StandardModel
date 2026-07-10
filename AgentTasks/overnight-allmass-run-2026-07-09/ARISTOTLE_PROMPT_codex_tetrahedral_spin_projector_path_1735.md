# Codex Aristotle target: ordered 3+1 tetrahedral spin-projector path

Prove every theorem in `TetraSpinPath/OrderedProjectors.lean` without changing
definitions, signs, product order, or hypotheses. Run the narrow command first:

```text
lake env lean TetraSpinPath/OrderedProjectors.lean
```

## Mathematical target

The four vectors `w_i` are the regular-tetrahedron body diagonals. Under the
exact normalization `3*r^2=1`, the Pauli contraction is an involution and

```text
P_i = (1 + r w_i.sigma)/2
```

is a Hermitian rank-one projector. Prove:

1. the exact tetrahedral Gram law;
2. projector idempotence, Hermiticity, trace one, and `sum_i P_i = 2 I`;
3. for `i != j`, `tr(P_i P_j)=1/3` and
   `P_i P_j P_i=(1/3)P_i`;
4. the ordered history concatenation law;
5. the orientation-sensitive three-direction phase
   `tr(P0 P1 P2)=I*r/3` and reverse `=-I*r/3`;
6. the nonzero order-reversal witness and final verdict.

The phase signs and `1/3` coefficient were independently checked by exact
symbolic matrix arithmetic, but that calculation is only an oracle fixture;
the Lean proof is authoritative.

## Scientific boundary

This is the missing order-sensitive spin amplitude above the landed endpoint
kinematics. It does not prove a unitary translation walk, a massive coin, a
propagator recursion, or a continuum limit. Do not add any such prose claim.
Do not collapse the ordered product to a commutative scalar model: the nonreal
three-projector phase is required.

Context pack:
`AgentTasks/context-packs/tetrahedral-spin-projector-path-20260709-20260709-173430.md`.

```yaml
aristotle:
  project_id: 9b4990af-d0bf-4f76-8bd8-ce5cfd12edb5
  target_file: TetraSpinPath/OrderedProjectors.lean
  expected_module: PhysicsSM.Draft.NullEdge.TetrahedralSpinProjectorPath
  status: integrated
```
