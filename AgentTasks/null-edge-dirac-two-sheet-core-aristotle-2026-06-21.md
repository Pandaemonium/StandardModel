# Aristotle task: Dirac two-sheet projector core

Date: 2026-06-21

## Objective

Prove the finite branch-projector algebra forced by a Dirac square root:
if `D^2 = m^2 I`, then `(1/2)(I +/- m^{-1}D)` are complementary projectors
and `D` acts on them with eigenvalues `+m` and `-m`.

Target file:

```text
NullEdgeDiracTwoSheetCore/Projectors.lean
```

Expected module:

```text
NullEdgeDiracTwoSheetCore.Projectors
```

## Theorem targets

```lean
plusProjector_add_minusProjector
plusProjector_sub_minusProjector
plusProjector_idempotent_of_sq
minusProjector_idempotent_of_sq
plus_minus_orthogonal_of_sq
dirac_acts_on_plusProjector
dirac_acts_on_minusProjector
```

## Why this matters

This is the finite algebra behind the two-sheet branch structure highlighted
by the Dirac feedback.  It does not by itself prove a CPT/scattering model, but
it proves that once the finite Dirac square root exists, the branch projectors
are forced by algebra.

## Proof guidance

- Work in matrix algebra over `Complex`.
- Use the hypothesis `D * D = (m * m) • 1` and `hm : m != 0`.
- Useful identities include `inv_mul_cancel₀`, scalar multiplication
  distributivity over matrix multiplication, and ring normalization after
  expanding projector definitions.
- Entrywise proofs are acceptable if global matrix algebra rewriting is
  stubborn.

## Constraints

- Keep this package standalone: no `PhysicsSM` imports.
- Do not weaken theorem statements silently.
- Final target file should contain no proof holes or escape-hatch declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-dirac-two-sheet-core-20260621/NullEdgeDiracTwoSheetCore/Projectors.lean
```

Result before submission: passed with exactly seven intended proof-hole warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 7d6f82de-f6d8-4ee3-b5de-df961a632b48
  task_id: 6425e8d8-46ff-4bc5-9a76-d7a921c74246
  target_file: NullEdgeDiracTwoSheetCore/Projectors.lean
  expected_module: NullEdgeDiracTwoSheetCore.Projectors
  submission_project: AgentTasks/aristotle-submit/null-edge-dirac-two-sheet-core-20260621-project
  output_dir: AgentTasks/aristotle-output/7d6f82de-f6d8-4ee3-b5de-df961a632b48
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`7d6f82de-f6d8-4ee3-b5de-df961a632b48`; `aristotle tasks` reported task
`6425e8d8-46ff-4bc5-9a76-d7a921c74246` as `QUEUED`.

Integrated 2026-06-21 after `aristotle tasks` reported task
`6425e8d8-46ff-4bc5-9a76-d7a921c74246` as `COMPLETE`.
Fetched output to
`AgentTasks/aristotle-output/7d6f82de-f6d8-4ee3-b5de-df961a632b48`.

Aristotle proved all seven finite two-sheet projector targets. The result was
ported into:

```text
PhysicsSM/Draft/NullEdgeDiracTwoSheetCore.lean
```

and imported by `PhysicsSMDraft.lean`.

Post-integration checks:

```text
lake env lean PhysicsSM/Draft/NullEdgeDiracTwoSheetCore.lean
lake build PhysicsSM.Draft.NullEdgeDiracTwoSheetCore
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeDiracTwoSheetCore.lean
```
