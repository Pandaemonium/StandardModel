# Aristotle task: chiral Dirac mass-shell projectors

Date: 2026-06-21

## Objective

Prove the finite mass-shell projector algebra for the chiral Dirac slash.

Target file:

```text
NullEdgeDiracMassShellCore/Projectors.lean
```

Expected module:

```text
NullEdgeDiracMassShellCore.Projectors
```

## Theorem targets

```lean
chiralDiracSlash_sq_eq_norm
chiralDiracSlash_sq_eq_massSq_of_massShell
chiralPlusProjector_idempotent
chiralMinusProjector_idempotent
chiralProjectors_orthogonal
chiralDirac_acts_on_plusProjector
chiralDirac_acts_on_minusProjector
```

## Why this matters

The previous two-sheet theorem proves the branch projectors for an abstract
operator satisfying `D^2=m^2 I`.  This target specializes that algebra to the
actual chiral Dirac slash on a finite mass shell, giving a concrete branch
decomposition for the null-edge square-root operator.

## Constraints

- Keep this package standalone: no `PhysicsSM` imports.
- Do not weaken theorem statements silently.
- Final target file should contain no proof holes or escape-hatch declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-dirac-mass-shell-projectors-core-20260621/NullEdgeDiracMassShellCore/Projectors.lean
```

Result before submission: passed with exactly seven intended proof-hole warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 11e02213-1e41-45c0-80b2-56087d5d4892
  task_id: 7f47a361-d1fa-4438-8d4f-382d763ecec1
  target_file: NullEdgeDiracMassShellCore/Projectors.lean
  expected_module: NullEdgeDiracMassShellCore.Projectors
  submission_project: AgentTasks/aristotle-submit/null-edge-dirac-mass-shell-projectors-core-20260621-project
  output_dir: AgentTasks/aristotle-output/11e02213-1e41-45c0-80b2-56087d5d4892
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`11e02213-1e41-45c0-80b2-56087d5d4892`; `aristotle tasks` reported task
`7f47a361-d1fa-4438-8d4f-382d763ecec1` as `QUEUED`.

## Integration

Integrated 2026-06-21 as:

```text
PhysicsSM/Draft/NullEdgeDiracMassShellProjectorsCore.lean
```

The repo-native module imports the existing draft Dirac slash and abstract
two-sheet projector cores, then specializes the projectors to the concrete
chiral slash on the mass shell instead of duplicating the standalone
definitions.

Verification:

```text
lake env lean PhysicsSM\Draft\NullEdgeDiracMassShellProjectorsCore.lean
lake build PhysicsSM.Draft.NullEdgeDiracMassShellProjectorsCore
lake env lean PhysicsSMDraft.lean
python Scripts\check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM\Draft\NullEdgeDiracMassShellProjectorsCore.lean
git diff --check -- PhysicsSM\Draft\NullEdgeDiracMassShellProjectorsCore.lean PhysicsSMDraft.lean
```
