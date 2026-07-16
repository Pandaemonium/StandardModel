# Graph spin-lift cocycle: Aristotle semantic audit

```yaml
aristotle:
  project_id: 9f169640-568e-4053-97cb-5ae6308123e5
  task_id: d79e690e-09d1-4d70-86ac-4ede8e756a2a
  target_file: PhysicsSM/Draft/NullEdge/GraphSpinLiftCocycle.lean
  expected_module: PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle
  submission_project: AgentTasks/aristotle-submit/null-edge-graph-spin-lift-cocycle-20260715-project
  output_dir: AgentTasks/aristotle-output/9f169640-568e-4053-97cb-5ae6308123e5
  status: complete, harvested, and reviewed 2026-07-15
```

## Objective

Audit the first graph-global central-sign layer for local `SL(2,C)` spin lifts.
Check the path trivialization, square gauge-orbit classification, prescribed
face-defect correction, and connection to the existing Hermitian Minkowski and
spinor actions. Preserve declarations unless a genuine mathematical or
semantic defect is found.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-graph-spin-lift-cocycle-20260715-20260715-041835.md
```

## Locked interpretation

1. Local Lorentz transports and local `SL(2,C)` lifts are supplied. This module
   studies only their residual central `+/-` choices.
2. `PathEdgeSigns` is the oriented three-edge path. The theorem that every
   assignment is vertex-gauge trivial is the expected tree control.
3. `SquareEdgeSigns` is first the oriented boundary cycle. Its `ZMod 2` edge
   sum is invariant under source/target vertex signs, and two assignments are
   gauge equivalent exactly when their cycle sums agree.
4. Therefore the square boundary has two gauge sectors. This must not be
   described as two spin structures on a filled disk.
5. `SquareFaceCompatible defect s` then treats the square as one filled face
   with a supplied central defect from the base local lifts. Every defect has a
   correction on an isolated face, and all corrections of that same defect
   form one vertex-gauge class.
6. The live module now includes the minimal simultaneous-face control: two
   square disks glued along one common boundary admit one shared correction
   exactly when their supplied defects agree, equivalently when the sum of the
   two defects vanishes. The mismatch `(0,1)` is an exact obstruction witness.
   The graph-cocycle module itself stops there. Its checked successor
   `FiniteSpinCochainObstruction.lean` treats every supplied finite face-edge
   matrix and proves that a defect is correctable exactly when every closed
   face cycle pairs with it to zero. Neither module derives that matrix and
   defect from graph Lorentz data or identifies the obstruction with `w2`.
7. The module does not establish orientability or time-orientability, prove
   lift existence, or construct a continuum spin bundle.
8. `signedSpinLift` maps parity zero to `A` and parity one to `-A`. The two
   boundary sectors are invisible to `A M A^dagger` and determinant, but are
   visible on spinors with nonzero image.

## Required audit

1. Run the narrow target only.
2. Independently verify the path gauge, square parity cancellation, explicit
   reconstructed square gauge, and the iff classification.
3. Check that the classification really has exactly two nonempty inequivalent
   sectors over `ZMod 2` and that no orientation sign has been mishandled.
4. Audit the boundary-cycle versus filled-face distinction. Check that
   prescribed face compatibility is nonempty and unique only up to vertex
   gauge on one isolated square.
5. Audit the glued two-face theorem: existence iff the face defects agree,
   equivalence with vanishing `front+back`, uniqueness up to vertex gauge, and
   the explicit obstructed mismatch. Check the minimal sphere interpretation.
6. Verify the Hermitian action, determinant-one, and spinor-action statements,
   including the exact identity-lift/nonzero-spinor witness.
7. Audit the added proof that `SquareGaugeEquivalent` is an equivalence
   relation.
8. Check every sentence against vacuity, false shape, imported-versus-derived
   confusion, and overclaiming of a spin structure from a bare graph.
9. Recommend the strongest next theorem toward a general finite cochain
   obstruction
   and, separately, toward graph-derived gauge-relative tetrads.

## Required report

Return command results, independent algebra, declaration-by-declaration
verdicts, assumption footprints, exact corrections, and a remaining-obligations
ledger. Finish with statement changes, proof holes, axioms, and all supplied
geometric/topological assumptions.

## Submission record

- Submitted project: `9f169640-568e-4053-97cb-5ae6308123e5`.
- Submitted task: `d79e690e-09d1-4d70-86ac-4ede8e756a2a`.
- Initial task state: `QUEUED`.
- Focused package contains exactly the seven Lean modules in the target's
  import closure, this task note, the semantic context pack, and Mathlib
  metadata. No `.lake` cache was submitted.
- After submission, `--mode instruct` notified Aristotle of the locally checked
  reflexivity, symmetry, transitivity, and `Equivalence` declarations added for
  `SquareGaugeEquivalent`; the audit must include them rather than reporting
  their earlier absence as a remaining defect.
- A second `--mode instruct` message supplied the locally checked glued
  two-face obstruction theorems and requested a semantic audit of the minimal
  sphere interpretation and the explicit refusal to call the obstruction
  `w2`.
- A third `--mode instruct` message supplied the checked successor module's
  arbitrary finite face-edge matrix obstruction theorem and exact glued-square
  specialization. Aristotle was asked to confirm that it proves only the
  necessary closed-cycle pairing criterion, not converse sufficiency or an
  identification with `w2`.
- A fourth `--mode instruct` message corrected that superseded scope after the
  successor gained the finite annihilator converse. It supplied the exact
  separating-functional and `dotProductEquiv` proof architecture, the two iff
  theorem names, passing local verification, and the remaining limits: supplied
  incidence/defect data, no `w2` identification, and no refinement or continuum
  theorem.
- The live check after that message reported project state `RUNNING` and task
  state `IN_PROGRESS`. Because this audit did not receive the successor's
  source, a separate focused semantic audit of the generic converse was also
  submitted as project `1107f829-a038-4e6a-8a82-926ce6fb6734`.

## Harvest record

- Aristotle found the path, square, filled-face, double-square, Hermitian,
  determinant, and nonzero-spinor declarations mathematically and semantically
  sound at their stated finite scope.
- It confirmed that the two sectors classify the square boundary, not two spin
  structures on a disk, and that the sphere wording requires the supplied
  complete-boundary gluing interpretation.
- Its returned Lean candidate was based on the earlier submitted snapshot and
  changed declaration names relative to the stronger live module, so it was
  reviewed but deliberately not copied over the live file.
- Detailed report:
  `AgentTasks/aristotle-output/9f169640-568e-4053-97cb-5ae6308123e5/extracted/project-files.tar/null-edge-graph-spin-lift-cocycle-20260715-project_aristotle/SEMANTIC_AUDIT.md`.
- Aristotle summary:
  `AgentTasks/aristotle-output/9f169640-568e-4053-97cb-5ae6308123e5/extracted/project-files.tar/null-edge-graph-spin-lift-cocycle-20260715-project_aristotle/ARISTOTLE_SUMMARY.md`.
