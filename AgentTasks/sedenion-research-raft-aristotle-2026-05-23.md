# Sedenion research raft for Aristotle - 2026-05-23

Purpose: launch a first wave of ambitious but finite Lean tasks around
sedenion zero divisors, affine-plane supports, Reed-Muller geometry,
stabilizer plaquettes, and the physics-facing S3 question.

The working convention is documented in:

```text
Sedenions/CayleyDickson_Convention.md
```

The current oracle script is:

```text
Scripts/sedenions/explore_zero_divisor_geometry.py
```

Current oracle output:

```text
Fano sign-change flip patterns = 16
all Fano sign-change flip patterns satisfy the [7,4,3] Hamming checks

signed zero-product ordered pairs = 336
distinct four-point supports from signed zero products = 42

all same-strut mixed affine supports = 63
zero-product supports are a subset of same-strut supports
extra same-strut supports not selected by signs = 21

span(42 zero-product supports) has rank 9 and size 512
span(42 zero-product supports) = {c in RM(2,4) : c_0 = c_8 = 0}
weight enumerator = 1 + 77 y^4 + 168 y^6 + 203 y^8 + 56 y^10 + 7 y^12

span(63 same-strut supports) gives the same code
```

Important convention warning:

- This sedenion branch uses the recursive Cayley-Dickson convention with
  labels `abcd <-> i^d j^c ell^b m^a`.
- The existing trusted octonion convention in `PhysicsSM.Algebra.Octonion.Basic`
  is different.
- Do not silently identify the two conventions.  If a bridge is needed, state
  it explicitly and prove the relabeling/sign correction.

Expected output policy:

- Put new Lean code under `PhysicsSM/Draft/Sedenions/`.
- Draft files may contain documented `sorry` if a target is too hard.
- Do not add `axiom`, `opaque`, `unsafe`, or `admit`.
- Prefer small theorem clusters that compile.
- Return the strongest sorry-free finite results possible.

## Job Table

| Job | Task note | Aristotle ID | Status |
| --- | --- | --- | --- |
| S1 | `AgentTasks/sedenion-fano-hamming-orientation-aristotle-2026-05-23.md` | `1b1fa812-8553-4686-9a5d-11ff7d5e025d` | submitted |
| S2 | `AgentTasks/sedenion-cayley-dickson-sign-table-aristotle-2026-05-23.md` | `43f8ae22-6ed1-4e6d-9788-d2b28db11d76` | submitted |
| S3 | `AgentTasks/sedenion-zero-product-supports-aristotle-2026-05-23.md` | `cc929ce0-5bff-4249-bd3d-31e8df687703` | submitted |
| S4 | `AgentTasks/sedenion-rm24-code-aristotle-2026-05-23.md` | `b4f27cbf-c55a-4da4-99dc-c831e8acef6a` | submitted |
| S5 | `AgentTasks/sedenion-cocycle-quadratic-phase-aristotle-2026-05-23.md` | `b7038d93-c3d8-4f24-9434-7a186cec6095` | submitted |
| S6 | `AgentTasks/sedenion-stabilizer-plaquette-aristotle-2026-05-23.md` | `fba64f64-4ae7-4bd2-ad89-7c7c4e0a354f` | submitted |
| S7 | `AgentTasks/sedenion-gl32-signed-action-aristotle-2026-05-23.md` | `6ea402f7-f0a4-4e72-920d-673f877dbc0f` | submitted |
| S8 | `AgentTasks/sedenion-s3-psi-orbit-aristotle-2026-05-23.md` | `335665ea-3b18-4187-b79f-b8f40a37d88d` | submitted after one SSL retry |

## Integration Notes - 2026-05-23

Most completed jobs returned useful draft Lean modules, though the observed
output labels were shifted relative to the original prompts.  The following
files were integrated into the live repository under `PhysicsSM/Draft/Sedenions/`
and imported from `PhysicsSMDraft.lean`:

```text
PhysicsSM/Draft/Sedenions/CayleyDicksonSignTable.lean
PhysicsSM/Draft/Sedenions/ReedMullerCode.lean
PhysicsSM/Draft/Sedenions/CocycleQuadraticPhase.lean
PhysicsSM/Draft/Sedenions/StabilizerPlaquettes.lean
PhysicsSM/Draft/Sedenions/GL32Action.lean
PhysicsSM/Draft/Sedenions/S3PsiAction.lean
PhysicsSM/Draft/Sedenions/S3PsiActionAbstract.lean
```

Each integrated file is sorry-free in the live checkout and passed a targeted
`lake env lean` check.  These remain draft-facing: several theorems use
finite `native_decide`, and the convention is intentionally separate from the
trusted octonion convention.

The job `43f8ae22-6ed1-4e6d-9788-d2b28db11d76` is still in progress at the
time of this integration.  It may contain the missing Fano-Hamming orientation
module when it completes.

## Submission Package

Prepared with:

```text
powershell -ExecutionPolicy Bypass -File Scripts/prepare_aristotle_submission.ps1 -JobName sedenion-research-raft-20260523 -TaskNote <task-note-list> -ExtraPath "Sedenions,Scripts/sedenions"
```

Submit each job separately with a short prompt pointing to its task note.
