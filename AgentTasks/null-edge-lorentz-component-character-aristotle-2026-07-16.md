# Aristotle job: Lorentz component characters

Date: 2026-07-16

```yaml
aristotle:
  project_id: f3a64d3b-b82b-42c9-8bce-715a9a5f4447
  task_id: b2d30a9c-00da-463d-abb7-2a45cdf6b020
  target_file: LorentzComponentCharacter/Core.lean
  expected_module: LorentzComponentCharacter.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-lorentz-component-character-20260716-project
  source_root: AgentTasks/aristotle-standalone/null-edge-lorentz-component-character-20260716
  context_pack: AgentTasks/context-packs/lorentz-component-character-20260716-20260716-112728.md
  output_dir: AgentTasks/aristotle-output/f3a64d3b-b82b-42c9-8bce-715a9a5f4447
  status: integrated
```

## Goal

Close all five proof holes in the focused Mathlib-only file without changing
any definition or theorem statement.  The primary theorem is `timeSign_mul`:
the sign of the time-time component of a mostly-minus Lorentz matrix must be a
homomorphism to `ZMod 2`.  The determinant analogue and closure theorem provide
the parallel spatial-orientation character.

Semantic context pack:
`AgentTasks/context-packs/lorentz-component-character-20260716-20260716-112728.md`.

Run this narrow command first:

```text
lake env lean LorentzComponentCharacter/Core.lean
```

## Mathematical conventions

- `eta = diag(1,-1,-1,-1)`.
- `IsEtaLorentz M` means `transpose M * eta * M = eta`.
- `timeSign M = 0` exactly when `0 <= M[0,0]`; otherwise it is one.
- `determinantSign M = 0` exactly when `0 <= det M`; otherwise it is one.
- Eta-orthogonality forces both `|M[0,0]| >= 1` and `det M = +/-1`, so neither
  sign definition encounters a zero boundary on its intended domain.

For `timeSign_mul`, a robust informal route is to prove that every Lorentz
matrix maps the future timelike cone either wholly to the future cone or
wholly to the past cone.  Equivalently, use the first-column norm identities
and show that the sign of `(M*N)[0,0]` is the product of the two time signs.
Small helper lemmas are welcome.

## Success criteria

- All five statements compile under Lean 4.28.0 and Mathlib.
- No statement or definition changes.
- No new assumptions or escape hatches.
- Return the complete target file and a short report naming any helper lemmas.

## Semantic warning

Do not replace `timeSign_mul` by a theorem that assumes both matrices are
already orthochronous.  The content is the full two-component multiplication
law, including one and two time reversals.

## Result

The task reported `COMPLETE_WITH_ERRORS` because of an operational finalization
step, but the downloaded target contained all five proofs, no proof holes, and
no definition or theorem-statement changes.  Local `lake env lean` verification
passed.  The proofs were adapted to the project module
`PhysicsSM/Draft/NullEdge/LorentzComponentCharacter.lean`, which then passed its
targeted project build.
