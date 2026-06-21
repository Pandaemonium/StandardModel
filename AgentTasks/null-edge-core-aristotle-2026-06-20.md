# Aristotle task: null-edge causal graph finite core

Date: 2026-06-20

## Goal

Fill the eight documented `sorry`s in:

```text
PhysicsSM/Draft/NullEdgeCoreAristotle.lean
```

This is a single finite theorem package for the null-edge causal graph
program.  It deliberately avoids continuum limits, stochastic causal-set
analysis, and full twistor geometry.  The point is to close the smallest
kernel-checkable algebraic/combinatorial targets that move the program most.

## Why these targets

The strengthened program identifies several possible extensions.  The
highest-leverage Lean targets are the ones that are finite, convention-light,
and reusable:

1. **Pluecker mass of null spinor bundles.**  This is the keystone theorem:
   mass is the determinant / pairwise spread of a bundle of null edges, not a
   property of one edge.
2. **Causal-diamond Abelian holonomy.**  This is the minimal gauge-curvature
   toy model for a causal DAG, replacing plaquette loops by comparison of two
   paths through a causal diamond.
3. **Order-complex boundary squared.**  This is the finite cochain seed for a
   graph-native Kahler-Dirac branch.

Targets deliberately not included in this first project:

- twistor mass matching, because no twistor/incidence API exists yet;
- Higgs/Yukawa chirality flips, because the representation bookkeeping needs
  a separate Standard Model convention pass;
- gravity/null-horizon thermodynamics, because it is not yet a finite Lean
  theorem.

## Target theorems

Pluecker mass:

```lean
det_rankOneHermitian_eq_zero
two_edge_plucker_mass_identity
complexAbsSq_eq_zero_iff
two_edge_mass_zero_iff_wedge_zero
spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero
```

Causal-diamond holonomy:

```lean
diamondDefect_gauge_invariant
```

Order-complex boundary:

```lean
chainBoundary_simplexBoundary_eq_zero
chainBoundary_comp_self_eq_zero
```

## Constraints

- Do not change theorem statements unless a statement is false or
  underspecified; report any such issue clearly.
- No new `axiom`, `opaque`, `unsafe`, or non-draft assumptions.
- The final target file should contain no proof-command `sorry`/`admit`.
- Helper lemmas are welcome in the same file.
- Keep the module in `PhysicsSM.Draft`; this is not trusted code until a
  human review checks statement alignment and proof hygiene.

## Verification

Run:

```bash
lake env lean PhysicsSM/Draft/NullEdgeCoreAristotle.lean
lake build PhysicsSM.Draft.NullEdgeCoreAristotle
```

Then scan:

```bash
grep -n "sorry\|admit\|axiom\|opaque\|unsafe\|native_decide" \
  PhysicsSM/Draft/NullEdgeCoreAristotle.lean
```

## Submission

```yaml
aristotle:
  project_id: 3b32b0fb-525d-47bf-b818-1980d1fad98d
  task_id: e23c5c10-f257-485a-80e6-4e5d5a879f14
  target_file: PhysicsSM/Draft/NullEdgeCoreAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgeCoreAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-core-20260620-project
  output_dir: AgentTasks/aristotle-output/3b32b0fb-525d-47bf-b818-1980d1fad98d
  status: integrated
```

## Integration

Round 1 was integrated locally from the Aristotle output and then superseded
by the SPL-free round-2 package, which preserved these proofs and added the
three-edge theorem.

Verification after local integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeCoreAristotle.lean
lake build PhysicsSM.Draft.NullEdgeCoreAristotle
```

The target file has no proof-command `sorry`, `admit`, `axiom`, `opaque`,
`unsafe`, or `native_decide` hits.
