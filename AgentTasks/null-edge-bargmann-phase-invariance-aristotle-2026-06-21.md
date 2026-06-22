# Aristotle task: Bargmann phase invariance

Date: 2026-06-21

## Objective

Prove the closed-loop Bargmann/Pancharatnam phase-invariance wrapper over the
new Bargmann phase port. The target is the observable statement that independent
unit complex phase rescalings at the three spinor vertices leave the closed
rank-one projector trace unchanged.

Target file:

```text
NullEdgeBargmannPhaseInvariance/Finite.lean
```

Expected module:

```text
NullEdgeBargmannPhaseInvariance.Finite
```

Context pack:

```text
AgentTasks/context-packs/null-edge-bargmann-phase-invariance-20260621-manual.md
```

## Theorem targets

```lean
spinorInner_smul_smul
rankOneProjector_phase_invariant
bargmannTriple_smul
bargmannTriple_phase_invariant
bargmannTripleTrace_phase_invariant
```

## Why this matters

The null-edge program needs gauge/observable wrappers, not just algebraic
identities. This theorem package says the phase observable extracted from a
closed triangle of rank-one spinor projectors is invariant under local unit
phase choices at each vertex.

## Constraints

- Keep unit-phase hypotheses explicit as `starRingEnd Complex u * u = 1`.
- Preserve the convention that `spinorInner` is conjugate-linear in its first
  argument.
- Do not weaken theorem statements silently.
- Final target file should contain no proof holes or escape-hatch
  declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-bargmann-phase-invariance-20260621/NullEdgeBargmannPhaseInvariance/Finite.lean
```

Result before submission: passed with exactly five intended proof-hole
warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 897ea247-be35-428b-bd33-e4e990a0fe76
  task_id: 69b679ba-6c47-4753-b06d-ac59b0f0b256
  target_file: NullEdgeBargmannPhaseInvariance/Finite.lean
  expected_module: NullEdgeBargmannPhaseInvariance.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-bargmann-phase-invariance-20260621-project
  output_dir: AgentTasks/aristotle-output/897ea247-be35-428b-bd33-e4e990a0fe76
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`897ea247-be35-428b-bd33-e4e990a0fe76`; `aristotle tasks` reported task
`69b679ba-6c47-4753-b06d-ac59b0f0b256` as `QUEUED`.

## Result analysis

Fetched and integrated 2026-06-21. Aristotle proved all five targets:

- `spinorInner_smul_smul`
- `rankOneProjector_phase_invariant`
- `bargmannTriple_smul`
- `bargmannTriple_phase_invariant`
- `bargmannTripleTrace_phase_invariant`

The integrated draft module is:

```text
PhysicsSM/Draft/NullEdgeBargmannPhaseInvariance.lean
```

The main mathematical gain is a genuine observable/gauge wrapper: the closed
Bargmann/Pancharatnam triple product and the corresponding three-projector
trace are invariant under independent unit complex phase choices at the three
spinor vertices.

Local verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeBargmannPhaseInvariance.lean
lake build PhysicsSM.Draft.NullEdgeBargmannPhaseInvariance
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft PhysicsSM/Draft/NullEdgeBargmannPhaseInvariance.lean
```

All passed. A separate `rg` scan of the integrated file found no placeholder or
escape-hatch tokens.
