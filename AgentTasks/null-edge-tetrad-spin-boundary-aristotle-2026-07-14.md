# Tetrad and spin reconstruction boundary: Aristotle semantic audit

```yaml
aristotle:
  project_id: 2b29e038-c6a8-4663-b1f1-426d53018a5b
  task_id: 64bc2167-e152-42ca-a86f-2d85dc2fd146
  target_file: PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean
  expected_module: PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary
  submission_project: AgentTasks/aristotle-submit/null-edge-tetrad-spin-boundary-20260714-project
  output_dir: AgentTasks/aristotle-output/2b29e038-c6a8-4663-b1f1-426d53018a5b
  status: complete and harvested 2026-07-14
```

## Objective

Audit the local algebraic boundary between metric reconstruction, coframe
reconstruction, and spin reconstruction. The live and focused targets already
pass narrow Lean checks. Aristotle should independently test the theorem
shapes, identify any overclaim, and preserve all locked statements unless a
mathematical error is found.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-tetrad-spin-boundary-20260714-20260714-230016.md
```

## Locked interpretation

1. `eta4` uses the mostly-minus signature `diag(1, -1, -1, -1)`.
2. `metric_does_not_fix_coframe_witness` is a local nonuniqueness witness. It
   proves that a metric does not canonically select a coframe because a
   nonidentity eta-orthogonal frame change preserves the induced metric.
3. The coframe theorem does not deny existence of tetrads and does not prove
   that a graph supplies a Lorentz-gauge class.
4. `vectorConjugation_neg` is an algebraic identity for a matrix and paired
   inverse candidate. The explicit `spinLift_sign_witness` uses determinant-one
   inverse matrices, equal conjugation actions, and unequal actions on a
   nonzero two-component spinor.
5. The spin theorem is only the local sign ambiguity associated with the
   double cover. It does not construct the Lorentz-to-spin covering map, prove
   global lift consistency, or discharge topological spin obstructions.
6. These results complement the scale theorem: density calibration can fix a
   positive Weyl factor relative to a supplied conformal coframe, but it does
   not select the coframe gauge or spin lift.

## Required audit

1. Check the rational boost inverse, Lorentz identity, nonidentity proof, and
   nondegeneracy proof.
2. Check that the coframe witness is nonvacuous and supports only the stated
   gauge-nonuniqueness interpretation.
3. Check determinant-one, inverse, conjugation, and spinor-action claims for
   the explicit sign witness.
4. Decide whether the spin witness needs an explicit Hermitian-vector subspace
   restriction before it may be described as the local double-cover sign
   ambiguity. Distinguish a theorem defect from a prose qualification.
5. List exactly what additional local and global data are needed to pass from
   Lorentz transport to a spin connection on a graph or continuum bundle.
6. Run only the narrow focused command. Do not launch a broad build.

## Success and failure criteria

Success requires a theorem-by-theorem semantic verdict, the narrow Lean result,
and precise corrected wording for any overclaim. If any statement is false,
return an exact counterexample. Do not weaken the formal statements merely to
make the interpretation easier.

## Required report

Return the command and result, assumption footprints, semantic verdicts,
counterexample attempts, and a concise reconstruction ledger separating
metric/coframe gauge, local spin-lift sign, global spin structure, and derived
graph data.

## Harvested result

Aristotle found no false formal statement and preserved every theorem and
proof. The narrow command passed. The rational boost, coframe nonuniqueness,
determinant-one sign pair, inverse relations, equal matrix conjugation, and
unequal nonzero-spinor actions were all verified.

The audit identified one necessary prose qualification. Generic
`S X SInv` with `SInv = S^{-1}` is matrix conjugation and need not preserve the
Hermitian matrix subspace. It is not by itself the standard Lorentz action on
Minkowski vectors. Calling the explicit central `+/- I` pair a spin-lift sign
ambiguity requires a separate Hermitian-matrix model and the standard
`SL(2, C) -> SO+(1,3)` covering map. The live module docstrings were tightened
accordingly.

The remaining reconstruction data include local Lorentz-to-spin lifts, edge
and face compatibility, a graph cocycle, a global spin-structure obstruction
analysis, continuum patch compatibility, and a compatible spin connection.

Full downloaded audit:

```text
AgentTasks/aristotle-output/2b29e038-c6a8-4663-b1f1-426d53018a5b/extracted/project-files.tar/null-edge-tetrad-spin-boundary-20260714-project_aristotle/AgentTasks/null-edge-tetrad-spin-boundary-audit-report-2026-07-15.md
```
