# Codex proof job: explicit SU(2) spin-half action

Close every proof in `SU2Spin/Core.lean` without changing definitions,
statements, matrix conventions, or the quarter-turn fixture. Prove closure of
the displayed `SU(2)` predicate, the defining spinor representation law,
Hermitian-inner-product preservation, and the nontrivial quarter-turn witness
whose square is `-I` and fourth power is `I`.

This is the representation rung after the landed determinant-fixed `SU(2)`
factorization fiber. It does not yet prove that the factor fiber acts on a
specific particle cohomology, construct Wigner rotations, or prove
spin-statistics.

PhysLean references from the 00:35 pass: `Fermion.rightHandedRep`,
`Fermion.leftLeftToMatrix_ρ`, and
`StandardModel.HiggsVec.gaugeGroupI_smul_inner`. Consult their convention and
theorem shapes only; this submitted target is a clean-room Mathlib-only file.
Literature orientation: arXiv:2203.08087, sections on massive spinor-helicity,
and arXiv:1709.04891, little-group section.

Run `lake env lean SU2Spin/Core.lean`; return the complete file and any
conjugate-transpose convention issue.

Context pack:
`AgentTasks/context-packs/su2-spin-half-action-20260710-20260710-003855.md`.

```yaml
aristotle:
  project_id: adb502b2-1c4b-4b5b-a2dd-4513c5e2fc4d
  target_file: SU2Spin/Core.lean
  expected_module: SU2Spin.Core
  submission_project: AgentTasks/aristotle-submit/codex-su2-spin-half-action-20260710-project
  output_dir: AgentTasks/aristotle-output/adb502b2-1c4b-4b5b-a2dd-4513c5e2fc4d
  status: running
```
