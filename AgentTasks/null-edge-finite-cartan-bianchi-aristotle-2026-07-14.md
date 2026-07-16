# Null-edge finite Cartan-Bianchi: Aristotle proof and semantic audit

```yaml
aristotle:
  project_id: e34ca0e7-3e5a-426f-a6e9-22691e9588a3
  task_id: 72c4453e-6fa9-4d5b-8be6-47d45928803f
  target_file: PhysicsSM/Draft/NullEdge/FiniteCartanBianchi.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteCartanBianchi
  submission_project: AgentTasks/aristotle-submit/null-edge-finite-cartan-bianchi-20260714-project
  output_dir: AgentTasks/aristotle-output/e34ca0e7-3e5a-426f-a6e9-22691e9588a3
  status: harvested 2026-07-14; remote task canceled after useful proof snapshot
```

## Context

The live target adds a torsionful finite connection identity above
`FiniteConnectionGeometry.lean`. For connection operators `nab a` and coframe
operators `E a`, it defines

```text
T_ab = [nab_a, E_b] - [nab_b, E_a]
```

and proves

```text
D_a T_bc + D_b T_ca + D_c T_ab
  = [F_ab, E_c] + [F_bc, E_a] + [F_ca, E_b].
```

It also proves the adjoint-curvature identity, torsion antisymmetry, the
torsion-free cyclic-curvature corollary, and a paired first/second algebraic
Bianchi theorem. The live file passes:

```text
lake env lean PhysicsSM/Draft/NullEdge/FiniteCartanBianchi.lean
```

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-finite-cartan-bianchi-20260714-210258.md
```

Related GR note:

```text
Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md
```

## Aristotle mission

Act as Lean proof reviewer and adversarial differential-geometric reviewer.

1. Run the narrow target first:

   ```text
   lake env lean PhysicsSM/Draft/NullEdge/FiniteCartanBianchi.lean
   ```

2. Verify the signs and cyclic ordering of
   `adjoint_derivative_commutator`, `cartan_first_bianchi`,
   `curvature_frame_cyclic_zero_of_torsion_free`, and
   `finite_cartan_bianchi_pair`. Do not weaken any statement.

3. Decide whether the names and module prose are semantically exact. The
   intended scope is an associative-ring, fixed-label Cartan identity. It is
   not yet a cellular covariant-coboundary theorem, does not include
   anholonomic structure coefficients, and does not identify the operators
   with a continuum affine/spin connection.

4. State precisely what must be added for the identity to become the geometric
   first Bianchi identity `D T = F wedge e` on a null-edge complex. Separate:

   - a globally fixed coordinate-like label frame;
   - local label rotations and spin transport;
   - anholonomic frame brackets or structure coefficients;
   - a genuine graded cochain/wedge product;
   - the 3-cell or integrated-cycle content needed for nonvacuity.

5. If sound and assumption-minimal, add a conjugation-covariance layer to the
   same target. Preferred target shapes are covariance of `cartanTorsion` when
   both `nab` and `E` are conjugated, and covariance of each side of
   `cartan_first_bianchi`. Use the weakest correct inverse hypothesis and do
   not assume ring commutativity.

6. Preserve or strengthen the build-enforced assumption-footprint guards. Do
   not add fake declarations, new assumptions solely to ease proofs, or Lean
   escape hatches.

## Required report

Return exact theorem names, targeted commands, assumption footprints, semantic
corrections, and a crisp boundary between the proved fixed-label identity and
the still-open geometric/cochain Bianchi reconstruction.

## Live status notes

- **2026-07-14, 28-minute in-progress snapshot:** Aristotle had designed the
  fixed-sandwich covariance API and completed
  `covariantDerivative_conjugateFamily`, while four requested proof bodies were
  still unfinished. Using the already reviewed connection-covariance lemmas,
  the live target now kernel-checks `curvature_conjugateFamily`,
  `cartanTorsion_conjugateFamily`,
  `cartan_first_bianchi_lhs_conjugateFamily`, and
  `cartan_first_bianchi_rhs_conjugateFamily`. New assumption-footprint guards
  pin each headline covariance theorem to `[propext]`. The remote task remains
  active as an independent proof and semantic audit.
- **2026-07-14, mode `instruct`:** the 38-minute snapshot had completed every
  covariance proof except the right-hand cyclic curvature-action theorem. Sent
  the exact rewrite strategy through the already proved connection covariance
  lemmas and asked Aristotle to finish without changing statements, then
  prioritize the sign/index and geometric-boundary report.
- **2026-07-14, second mode `instruct`:** the 57-minute snapshot contained no
  remaining proof holes and had completed the right-hand covariance theorem.
  Asked Aristotle to stop any broad build wait, perform only the narrow target
  check if available, write the requested semantic audit, and package the
  result immediately.
- **2026-07-14, one-hour downloadable snapshot:** the remote covariance layer
  is proof-complete, but it duplicates the imported commutator-covariance
  lemma, uses less readable generated proofs, and omits the live file's three
  headline assumption-footprint guards. The live implementation remains the
  integration candidate; the remote semantic report is still pending. The
  extracted remote target independently passed `lake env lean` against the
  pinned local project.
- **2026-07-14, final mode `instruct`:** after the independent local kernel
  check, told the worker not to continue the broad repository build and to
  package the completed target plus semantic report immediately.
- **2026-07-14, disposition:** the remote worker remained in a failed/redundant
  build state after the proof snapshot had been downloaded and independently
  kernel-checked. Canceled the task to release Aristotle capacity. No remote
  code was copied; the cleaner live covariance implementation and its guards
  are retained.
