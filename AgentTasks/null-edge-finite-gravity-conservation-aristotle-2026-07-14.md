# Null-edge finite gravity conservation: Aristotle proof and semantic audit

```yaml
aristotle:
  project_id: 9c1961de-9fc1-4fe9-a4e3-9d911a8d4fb5
  task_id: 0b77f3e2-5d51-4dca-a9c3-5d579d18f6c8
  target_file: PhysicsSM/Draft/NullEdge/FiniteGravityConservation.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteGravityConservation
  submission_project: AgentTasks/aristotle-submit/null-edge-finite-gravity-conservation-20260714-project
  output_dir: AgentTasks/aristotle-output/9c1961de-9fc1-4fe9-a4e3-9d911a8d4fb5
  status: integrated 2026-07-14
```

## Context

The target isolates one exact implication used after the contracted Bianchi
identity in general relativity. In an arbitrary ring, it proves that

```text
G = kappa * T,
[nabla, kappa] = 0,
kappaLeftInv * kappa = 1,
[nabla, G] = 0
```

imply `[nabla, T] = 0`. A concrete nonzero `2 x 2` rational matrix witness
shows that all hypotheses, including nonzero source and coupling, are jointly
satisfiable in a noncommutative ambient algebra.

The live target passes:

```text
lake env lean PhysicsSM/Draft/NullEdge/FiniteGravityConservation.lean
```

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-finite-gravity-conservation-20260714-211333.md
```

Related reconstruction note:

```text
Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md
```

## Aristotle mission

Act as both a Lean proof reviewer and a hostile general-relativity semantic
reviewer.

1. Run the narrow target first:

   ```text
   lake env lean PhysicsSM/Draft/NullEdge/FiniteGravityConservation.lean
   ```

2. Verify `source_conserved_of_fieldEquation_bianchi` without changing or
   weakening its statement. Check multiplication order and every use of
   associativity in the noncommutative ring.

3. Verify that `nonzero_matrix_conservation_witness` establishes every listed
   conjunct and that neither the source nor coupling is zero.

4. If sound, add the sharp reusable adjoint Leibniz identity

   ```text
   [nabla, coupling * source]
     = [nabla, coupling] * source + coupling * [nabla, source]
   ```

   and refactor or supplement the conservation bridge as appropriate. Preserve
   the existing public theorem statement. Do not assume commutativity.

5. Determine whether left invertibility is the weakest convenient hypothesis.
   It is acceptable to add a separate theorem using an explicit left-cancellation
   hypothesis, but do not silently strengthen or weaken the existing theorem.

6. Audit the names and prose. This module does not define an Einstein tensor,
   derive a geometric or contracted Bianchi identity, construct stress-energy,
   or establish universal gravitational coupling. The word `source` must remain
   algebraic unless those structures are supplied elsewhere.

7. Preserve or strengthen the build-enforced assumption-footprint guards. Do
   not add fake declarations, proof escape hatches, or assumptions solely to
   make a theorem pass.

## Required report

Return the exact theorem names checked or added, the narrow command and result,
assumption footprints, any semantic wording corrections, and the precise
boundary between the proved conditional source-conservation implication and
the still-open null-edge derivation of continuum stress-energy conservation.

## Live status notes

- **2026-07-14, 22-minute in-progress snapshot:** the remote target still
  matched the submitted left-inverse theorem. Independently, the live target
  now factors the argument through the exact noncommutative adjoint Leibniz
  rule and proves a sharper theorem requiring only left cancellation by the
  coupling; the original public left-inverse theorem remains as a corollary.
  The live matrix witness was also strengthened from a diagonal commuting
  sector to mutually noncommuting source and coupling matrices. Both new
  declarations and all guards pass the narrow Lean check. The final Aristotle
  harvest must compare these strengthenings rather than overwrite them.
- **2026-07-14, final harvest:** task `0b77f3e2-5d51-4dca-a9c3-5d579d18f6c8`
  independently derived the adjoint Leibniz rule and left-cancellation bridge,
  confirmed all multiplication orders, and enforced the same GR semantic
  boundary. Integrated Aristotle's clearer theorem name and lower-footprint
  proof bodies. The live left-cancellation theorem and its left-inverse
  corollary now have no logical dependencies reported by Lean; the Leibniz rule
  reports `[propext]`. Retained the stronger live matrix witness with mutually
  noncommuting source and coupling instead of the returned diagonal witness.
