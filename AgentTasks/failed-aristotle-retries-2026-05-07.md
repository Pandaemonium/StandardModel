# Failed Aristotle retries - 2026-05-07

Status: submitted 2026-05-07.

Purpose: resubmit the three Aristotle jobs that failed with Harmonic internal
errors and did not return Lean output. Each retry is deliberately narrower than
the original job.

Original failed jobs:

| Original job | Original task | Failure observed |
|--------------|---------------|------------------|
| `17399d3d-bff5-4abb-a864-b29f2e661cef` | Conway-Smith/Yokota triality-shadow companion maps | Aristotle internal error; no Lean output |
| `a231c951-a861-4a12-a1dd-a3884a7da01f` | Hurwitz-Clifford precursor | Aristotle internal error; no Lean output |
| `ce91075d-58ce-4049-87b2-9eb0492d76a8` | Furey weak-isospin and hypercharge bridge | Aristotle internal error; no Lean output |

Submission project:

```text
AgentTasks/aristotle-submit/failed-retries-20260507-project
```

## Submitted retries

| Retry | Output directory | Aristotle ID | Status |
|-------|------------------|--------------|--------|
| R1: left/right octonion companion identities | `AgentTasks/aristotle-output/retry-triality-left-right-companions` | `7c770eef-3d9b-4835-b9be-8d86e7e70a64` | queued |
| R2: composition-algebra record and basic API | `AgentTasks/aristotle-output/retry-composition-algebra-record` | `609b7470-5252-4553-88c3-61cf6b170d5a` | queued |
| R3: finite electroweak charge table | `AgentTasks/aristotle-output/retry-furey-electroweak-charge-table` | `25fb4e87-dc7b-491a-9782-f6df659404d5` | queued |

Submission check:

- `lake env lean PhysicsSM/Algebra/Octonion/TrialityCompanions.lean` passed in
  the live repo.
- `lake env lean PhysicsSM/Algebra/Furey/AnomalyBridge.lean` passed in the
  live repo with existing warnings only.
- `lake env lean PhysicsSM/Algebra/Division/CayleyDickson.lean` passed in the
  live repo with existing warnings only.
- `lake env lean PhysicsSM.lean` passed in the live repo.
- `lake build PhysicsSM.Algebra.Octonion.TrialityCompanions
  PhysicsSM.Algebra.Furey.AnomalyBridge
  PhysicsSM.Algebra.Division.CayleyDickson` passed in the slim submission
  project before the temporary `.lake` cache was removed for upload size.

## General constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Do not introduce axioms, `opaque`, `unsafe`, `admit`, or trusted `sorry`.
- Trusted modules must be sorry-free.
- If a retry cannot finish the full target, return a smaller trusted theorem
  and a documented draft handoff.
- Respect the project XOR octonion convention.
- Do not silently import all of Mathlib into a new file unless the file needs
  broad search and the module docstring explains why.
- Run `lake env lean <file>` for every touched Lean file before returning.

## Retry R1: left/right octonion companion identities

Original failed job:

- `17399d3d-bff5-4abb-a864-b29f2e661cef`

Original task:

- publication-frontier P1, Conway-Smith/Yokota triality-shadow companion maps.

Write scope:

- `PhysicsSM/Algebra/Octonion/TrialityShadow.lean`
- optional tiny additions to
  `PhysicsSM/Algebra/Octonion/TrialityCompanions.lean` only for reusable
  helper lemmas.

Goal:

Prove the first concrete left/right multiplication companion identities for
unit octonions. Do not attempt the full Conway-Smith/Yokota converse in this
retry.

Existing context:

- `PhysicsSM.Algebra.Octonion.TrialityCompanions`
- `conjBy`
- `cube`
- companion-map predicates already defined in that file
- trusted Moufang/norm/conjugation lemmas

Target declarations:

- a theorem for left multiplication by a unit octonion with explicit
  parenthesization;
- a theorem for right multiplication by a unit octonion with explicit
  parenthesization;
- optional helper lemmas showing the needed `conj`/inverse identities for a
  unit octonion.

Minimum useful result:

- A trusted file with at least one sorry-free companion identity for left or
  right multiplication and a module docstring explaining the convention.

Claim boundary:

- Do not claim the full triality-shadow criterion.
- Do not claim a compact Lie group theorem.

## Retry R2: composition-algebra record and basic API

Original failed job:

- `a231c951-a861-4a12-a1dd-a3884a7da01f`

Original task:

- gap-closure G6, Hurwitz-Clifford precursor.

Write scope:

- `PhysicsSM/Algebra/Division/CompositionAlgebra.lean`
- optional import addition in `PhysicsSM.lean` only if the file is trusted and
  sorry-free.

Goal:

Start the Hurwitz-classification route with a small reusable composition
algebra interface. Do not attempt the Clifford relation in this retry unless
the record/API layer is already complete.

Target declarations:

- `EuclideanCompositionAlgebra` or a similarly named structure;
- fields for carrier, real vector-space structure, multiplication, unit,
  conjugation or inner product, and a norm-composition axiom;
- `normSq` helper notation or projection;
- basic consequences that follow directly from the record fields;
- a documented placeholder section explaining how a later Clifford-relation
  job should use the interface.

Minimum useful result:

- A trusted Lean module defining the record and proving at least two small
  API lemmas with no sorry.

Claim boundary:

- This retry does not prove Hurwitz classification.
- This retry does not prove that the sedenion counterexample is an upper bound.
- It only prepares the algebraic interface needed for a real proof route.

## Retry R3: finite electroweak charge table

Original failed job:

- `ce91075d-58ce-4049-87b2-9eb0492d76a8`

Original task:

- next-wave-2 Job E, Furey weak-isospin and hypercharge bridge.

Write scope:

- `PhysicsSM/Algebra/Furey/HyperchargeBridge.lean`
- optional imports from:
  - `PhysicsSM/Algebra/Furey/AnomalyBridge.lean`
  - `PhysicsSM/Algebra/Furey/OperatorRepresentations.lean`
  - `PhysicsSM/StandardModel/AnomalyPackage.lean`

Goal:

Create a finite table of conventional electroweak assignments and prove the
identity `Q = T3 + Y / 2` on the table. Do not try to derive `T3` from Furey's
full operator algebra in this retry.

Target declarations:

- an indexed finite state type or `Fin 8` table for one convenient Furey sector;
- rational-valued `QValue`, `T3Value`, and `YValue`;
- theorem `Q_eq_T3_add_halfY` for every index in the table;
- comments explaining that this is a conventional table bridge, not yet a
  derivation of weak isospin from the octonionic ladder operators.

Minimum useful result:

- A trusted finite arithmetic theorem proving `Q = T3 + Y / 2` by `native_decide`
  or exact rational simplification.

Claim boundary:

- Do not claim the full Standard Model fermion sector is derived from Furey
  operators.
- Do not alter existing `Q_op` eigenvalue theorems.
