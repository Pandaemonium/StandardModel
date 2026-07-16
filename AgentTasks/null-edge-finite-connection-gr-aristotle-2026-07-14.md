# Null-edge finite connection geometry: Aristotle proof and semantic audit

```yaml
aristotle:
  project_id: 28c86a6c-69b2-48bb-87ac-eae445abb533
  task_id: 9acd4e43-1bc2-4e57-8723-f5c68816e87d
  target_file: PhysicsSM/Draft/NullEdge/FiniteConnectionGeometry.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry
  submission_project: AgentTasks/aristotle-submit/null-edge-finite-connection-gr-20260714-project
  output_dir: AgentTasks/aristotle-output/28c86a6c-69b2-48bb-87ac-eae445abb533
  status: integrated 2026-07-14
```

## Context

The null-edge general-relativity lane now has a locally compiling finite
connection module.  It composes the already-landed finite tetrad-postulate and
finite Lichnerowicz modules with three exact identities:

1. the commutator/Jacobi covariant Bianchi identity;
2. compatibility of the Clifford anticommutator with the finite tetrad
   postulate;
3. compatibility of commutator curvature with fixed Clifford generators.

The live file passes:

```text
lake env lean PhysicsSM/Draft/NullEdge/FiniteConnectionGeometry.lean
```

Its capstone assumption audit is pinned to `propext`, `Classical.choice`, and
`Quot.sound`.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-finite-connection-gr-20260714-204018.md
```

GR reconstruction note:

```text
Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md
```

## Aristotle mission

Act as both Lean proof agent and hostile semantic reviewer.

1. Run the narrow target first:

   ```text
   lake env lean PhysicsSM/Draft/NullEdge/FiniteConnectionGeometry.lean
   ```

2. Review every definition and theorem in the target against the imported APIs
   `NullEdgeFiniteTetradPostulate` and `NullEdgeFiniteLichnerowiczBridge`.
   Confirm that no theorem silently changes signs, index order, the
   dual-soldering convention, or the finite tetrad-postulate hypothesis.

3. Audit the prose names and interpretations.  In particular:

   - `covariant_bianchi_commutator` is the Jacobi identity for adjoint
     commutators.  It is not yet the torsional first Bianchi identity
     `d_U T = F wedge e`, a contracted Bianchi identity, or stress-energy
     conservation.
   - `metric_compatibility_from_tetrad` concerns the
     Clifford-anticommutator metric proxy with globally fixed labels.  It is
     not yet a theorem about a reconstructed continuum metric.
   - `curvature_clifford_compatible_of_tetrad` is an integrability consequence
     of the strong finite commutation hypothesis.  Check whether the current
     wording says exactly that.

4. If the existing statements and proofs are sound, strengthen the same target
   file with the sharpest assumption-minimal conjugation-covariance layer you
   can prove.  Preferred targets, adapted to the live API:

   ```lean
   theorem commutator_conjugation_covariant ... :
     commutator (g * x * gInv) (g * y * gInv) =
       g * commutator x y * gInv := ...

   theorem anticommutator_conjugation_covariant ... :
     anticommutator (g * x * gInv) (g * y * gInv) =
       g * anticommutator x y * gInv := ...

   theorem curvature_conjugation_covariant ... :
     curvature (fun i => g * nab i * gInv) a b =
       g * curvature nab a b * gInv := ...
   ```

   Use the weakest correct inverse hypothesis.  Do not assume commutativity.
   If left- and right-inverse hypotheses differ by target, make that explicit.

5. If useful and true, extend `finite_connection_dirac_chain` or add a second
   capstone that includes curvature conjugation covariance.  Do not make the
   original theorem harder to use merely to enlarge a conjunction.

6. Preserve the build-enforced assumption-footprint guard. Do not introduce
   new assumptions, fake declarations, or Lean escape hatches. Do not weaken
   any theorem.

## Required report

Return:

- exact theorem names proved or changed;
- whether the original four-part chain is semantically aligned;
- any wording corrections required in the GR note;
- the precise boundary between the algebraic Bianchi identity proved here and
  the still-missing geometric/contracted Bianchi theorems;
- the narrow Lean command run and its result;
- the assumption footprint of each headline theorem.

## Live status notes

- **2026-07-14, mode `ask`:** requested a concise, non-directive report on
  target compilation, semantic alignment, and the conjugation-covariance
  targets. The CLI wait timed out without a response while the task remained
  `IN_PROGRESS`. No instruction or course change was sent; keep the proof job
  running and harvest it when complete.
- **2026-07-14, 40-minute in-progress snapshot:** downloaded and reviewed the
  current target. Aristotle had added kernel-checkable covariance theorems for
  commutators, anticommutators, and curvature under `gInv * g = 1`. Their proof
  bodies were integrated locally with all pre-existing guards retained and new
  guards added. The prose was tightened to avoid calling a one-sided transform
  a group action or algebra automorphism. The live target passes
  `lake env lean PhysicsSM/Draft/NullEdge/FiniteConnectionGeometry.lean`; the
  remote task remains active for its final semantic report.
- **2026-07-14, final harvest:** task `9acd4e43-1bc2-4e57-8723-f5c68816e87d`
  completed. The final report confirmed the three added covariance theorem
  statements and proofs, all original signs and index orders, the dual-soldered
  reading of `C a`, and the exact tetrad-specialized Lichnerowicz expression.
  It also confirmed that the Jacobi identity is not a geometric, differential,
  or contracted Bianchi theorem. No additional proof body was selected over the
  locally integrated version because the live file retains stronger guard
  coverage and a stricter one-sided-transform caveat. Axiom/source scans and
  the draft umbrella build pass.
