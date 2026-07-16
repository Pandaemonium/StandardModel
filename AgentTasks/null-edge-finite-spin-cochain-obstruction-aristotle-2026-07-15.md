# Finite spin-cochain obstruction: Aristotle semantic audit

```yaml
aristotle:
  project_id: 1107f829-a038-4e6a-8a82-926ce6fb6734
  task_id: d68e781f-b48a-4e05-ad6a-0dc7b85693c7
  target_file: PhysicsSM/Draft/NullEdge/FiniteSpinCochainObstruction.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteSpinCochainObstruction
  submission_project: AgentTasks/aristotle-submit/finite-spin-cochain-obstruction-20260715-project
  output_dir: AgentTasks/aristotle-output/1107f829-a038-4e6a-8a82-926ce6fb6734
  status: complete, harvested, and reviewed 2026-07-15
```

## Objective

Audit the complete finite `ZMod 2` obstruction criterion for correcting
residual central signs of supplied local spin lifts. Check the
separating-functional converse carefully and enforce the distinction between
finite cochain linear algebra and a graph-derived spin structure.

Semantic context pack:

```text
AgentTasks/context-packs/finite-spin-cochain-obstruction-20260715-20260715-050823.md
```

## Locked interpretation

1. `FaceBoundary Face Edge` is an arbitrary supplied finite matrix over
   `ZMod 2`. The module does not construct faces, edges, incidence data, or a
   chain complex from a bare graph.
2. `defect` is a supplied face cochain. The module does not derive it from
   Lorentz transition maps or chosen local `SL(2,C)` lifts.
3. `Correctable boundary defect` means exactly that `defect` lies in the range
   of the displayed edge-to-face linear map `boundary.mulVecLin`.
4. `IsClosedFaceCycle boundary z` means exactly `z vecMul boundary = 0`.
   No homology, manifold, orientation, or Poincare-duality assumption is used.
5. The forward implication is matrix associativity: closed cycles annihilate
   every coboundary.
6. The converse is finite-dimensional linear algebra over the field `ZMod 2`:
   a defect outside the range admits a separating linear functional; the
   dot-product equivalence represents it by a closed face vector with nonzero
   pairing against the defect.
7. Therefore correctability is equivalent to vanishing against every closed
   face cycle, and equivalently to absence of a detected nonzero pairing.
8. The glued two-square witness is nonvacuous but is not, by itself, a theorem
   identifying the obstruction with the second Stiefel--Whitney class.
9. Nothing here proves graph-derived local lift existence, orientability,
   time-orientability, refinement compatibility, or continuum spin-bundle
   convergence.

## Required audit

1. Run only
   `lake env lean FiniteSpinCochainObstructionAudit/FiniteSpinCochainObstruction.lean`.
2. Independently audit the range-membership conversion in
   `correctable_of_forall_closedCycle_pairing_eq_zero`.
3. Check the use and orientation of
   `Submodule.exists_le_ker_of_notMem`, especially which value is proved
   nonzero and why the range is contained in the kernel.
4. Check that `dotProductEquiv` represents the separating functional with the
   same argument order as `defectPairing z defect`.
5. Check the proof that the represented vector is closed by testing the
   functional on every matrix column via `Pi.single edge 1`.
6. Audit both iff theorems, including the constructive content hidden by
   classical finite-dimensional separation.
7. Verify the exact glued-square cycle, mismatch pairing, and no-correction
   witness.
8. Report the precise assumptions needed for the converse and whether any
   theorem would fail for infinite face type, non-field coefficients, or a
   different pairing convention.
9. Check every claim against vacuity, false shape, imported-versus-derived
   confusion, and overclaiming of `w2` or a spin structure.
10. Recommend the strongest next theorem connecting supplied face defects to
    graph Lorentz/spin transport data without presupposing the desired
    topology.

## Required report

Return command results, an independent proof sketch, declaration-by-declaration
verdicts, assumption footprints, exact corrections, and a remaining-obligations
ledger. Finish with statement changes, proof holes, axioms, and every supplied
geometric or topological input.

## Submission record

- Focused standalone source differs from the live source only in replacing its
  project import with `import Mathlib`.
- The standalone source and packaged narrow target both passed before the
  dependency cache was removed from the upload package.
- Submitted project: `1107f829-a038-4e6a-8a82-926ce6fb6734`.
- Submitted task: `d68e781f-b48a-4e05-ad6a-0dc7b85693c7`.
- Initial task state: `QUEUED`.

## Harvest record

- Aristotle returned a full pass with no statement or proof correction.
- It independently confirmed the range conversion, separation orientation,
  `dotProductEquiv` argument order, column test, final contradiction, both iff
  theorems, and the exact glued-square witness.
- It emphasized that the converse is classical finite-dimensional existence,
  not an executable correction algorithm.
- Its strongest recommended successor was to derive the incidence matrix and
  defect from supplied ordered lift products and prove edge re-signing acts by
  the matrix coboundary. That successor is now implemented locally in
  `PhysicsSM/Draft/NullEdge/SpinLiftDefectFromTransport.lean`.
- Detailed report:
  `AgentTasks/aristotle-output/1107f829-a038-4e6a-8a82-926ce6fb6734/extracted/project-files.tar/finite-spin-cochain-obstruction-20260715-project_aristotle/SEMANTIC_AUDIT.md`.
- Aristotle summary:
  `AgentTasks/aristotle-output/1107f829-a038-4e6a-8a82-926ce6fb6734/extracted/project-files.tar/finite-spin-cochain-obstruction-20260715-project_aristotle/ARISTOTLE_SUMMARY.md`.
