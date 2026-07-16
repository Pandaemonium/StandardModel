# Hermitian local spin-lift boundary: Aristotle semantic audit

```yaml
aristotle:
  project_id: 30765394-dab8-4ab0-82eb-76e8fb02086c
  task_id: b07957e4-b889-4701-a171-b5273006b7d8
  target_file: PhysicsSM/Draft/NullEdge/HermitianSpinLiftBoundary.lean
  expected_module: PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary
  submission_project: AgentTasks/aristotle-submit/null-edge-hermitian-spin-lift-20260714-project
  output_dir: AgentTasks/aristotle-output/30765394-dab8-4ab0-82eb-76e8fb02086c
  status: complete and harvested 2026-07-15
```

## Objective

Audit the exact Hermitian completion of the local spin-sign boundary. The live
target and its focused dependency closure pass local Lean checks. Aristotle
should test the algebra and interpretation, preserve every theorem statement
unless a mathematical defect is found, and identify the precise local/global
spin reconstruction debt.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-hermitian-spin-lift-20260714-20260715-000140.md
```

## Locked interpretation

1. The Minkowski convention is `(+---)`, represented by the determinant of the
   project Pauli/Hermitian lift.
2. The relevant vector action is Hermitian congruence `X -> A X A^dagger`, not
   generic matrix conjugation.
3. For determinant-one two-by-two complex matrices, `A` and `-A` have the same
   Hermitian action and preserve the Pauli determinant, while their spinor
   actions differ whenever `A psi` is nonzero.
4. The headline theorem is a local central-sign boundary. It does not prove
   surjectivity onto `SO+(1,3)`, characterize the entire kernel as a group
   theorem, construct edge/face lifts, or establish a global spin structure.
5. The dependency theorem that determinant equals Minkowski norm is imported
   from the trusted convention module and must be checked for convention
   alignment, not silently replaced.

## Required audit

1. Run only the focused target command
   `lake build PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary`.
2. Verify Hermitian preservation under `A X A^dagger` and equality under
   `A -> -A`.
3. Check determinant preservation, the even-dimensional determinant sign, and
   the `(+---)` Pauli determinant identity used by the target.
4. Check the nonzero-spinor hypothesis and produce boundary examples showing
   why it is needed.
5. Audit every double-cover and kernel phrase for exactly what the declarations
   prove.
6. State the next theorem needed for compatible graph-edge spin lifts and the
   global cocycle obstruction.

## Required report

Return command results, assumption footprints, theorem-by-theorem verdicts,
falsification attempts, any exact prose corrections, and a local-to-global
spin reconstruction ledger.

## Harvested result

The exact focused module build passed over the six-file dependency closure.
Aristotle accepted every declaration without source or theorem-statement
changes. It independently confirmed Hermitian preservation under
`A X A^dagger`, equality of the `A` and `-A` actions, determinant preservation
for determinant-one matrices, and exact alignment of the Pauli determinant
with the `(+---)` Minkowski norm.

The nonzero-image hypothesis is exact for the standalone spinor theorem:
`psi = 0`, or a nonzero `psi` in the kernel of singular `A`, makes the two
spinor actions equal. Under `det A = 1`, this can equivalently be phrased using
a nonzero input spinor, but the reusable theorem correctly keeps the more
general image condition.

The audit confirmed that the module proves only the local central-sign algebra.
The remaining ladder is to define the induced real Lorentz homomorphism, prove
orientation/time-orientation, surjectivity, and full kernel `{+I,-I}`, then
construct edge lifts, face sign defects, their `Z2` cocycle, and the global
vanishing-obstruction theorem. A bare one-dimensional graph has no intrinsic
face-level obstruction; a cell or overlap structure is required.

Full downloaded audit:

```text
AgentTasks/aristotle-output/30765394-dab8-4ab0-82eb-76e8fb02086c/extracted/project-files.tar/null-edge-hermitian-spin-lift-20260714-project_aristotle/AgentTasks/null-edge-hermitian-spin-lift-audit-report-2026-07-15.md
```
