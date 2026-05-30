# Aristotle task: triality linear equivariance

**Agent**: Aristotle
**Status**: Submitted
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `7a798ad3-211d-4c8a-94f4-8e1c00c71048`
**Submission project**: `AgentTasks/aristotle-submit/furey-triality-linear-equivariance-20260529-project`
**Output**: `AgentTasks/aristotle-output/furey-triality-linear-equivariance-20260529`
**Type**: linear-map equivariance / Furey-Hughes triality scaffold

## Goal

Lift the finite `actTriple_permuteRoles` theorem to the linear-map API.

The project already has:

- `TrialityTriple.permute` in
  `PhysicsSM.Algebra.Furey.TrialityRolePermutation`;
- `TrialityActionData.toLinearEnd`, `toLinearEnd_id`, and `toLinearEnd_comp`
  in `PhysicsSM.Algebra.Furey.TrialityTripleModule`;
- `TrialityActionData.permuteRoles` and
  `TrialityActionData.actTriple_permuteRoles` in
  `PhysicsSM.Algebra.Furey.TrialityActionPermutation`.

This job should make the same theorem available in the language of
`Module.End`, so downstream files can treat triality actions as linear
operators.

## Sources and claim boundary

Source motivation:

- Cohl Furey and Mia Hughes, "Three Generations and a Trio of Trialities",
  arXiv:2409.17948.

Claim boundary:

- This is only finite module/action scaffolding.
- Do not claim a `Spin(8)` theorem, a Standard Model group action theorem, or a
  proof of the Furey-Hughes representation theorem.
- A separate job,
  `furey-triality-permutation-linear-aristotle-2026-05-29.md`, is already
  trying to construct full linear equivalences for role permutations. Use that
  file only if it already exists in this submission project; otherwise keep
  this job independent.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Furey/TrialityLinearEquivariance.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.TrialityActionPermutation
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Prove a linear-map-facing apply theorem:

```lean
theorem TrialityActionData.toLinearEnd_permuteRoles_apply
    (e : Equiv.Perm TrialityRole) (rho : TrialityActionData K M)
    (t : TrialityTriple M) :
    (rho.permuteRoles e).toLinearEnd (t.permute e) =
      (rho.toLinearEnd t).permute e
```

Prove the same theorem with the permutation on the other side if useful:

```lean
theorem TrialityActionData.toLinearEnd_permuteRoles_conjugation_apply
    (e : Equiv.Perm TrialityRole) (rho : TrialityActionData K M)
    (t : TrialityTriple M) :
    ((rho.permuteRoles e).toLinearEnd) (t.permute e) =
      ((rho.toLinearEnd t).permute e)
```

If `PhysicsSM.Algebra.Furey.TrialityPermutationLinear` exists in the project,
also prove the stronger conjugation theorem using
`TrialityTriple.permuteLinearEquiv`:

```lean
theorem TrialityActionData.toLinearEnd_permuteRoles_conj
    (e : Equiv.Perm TrialityRole) (rho : TrialityActionData K M) :
    (rho.permuteRoles e).toLinearEnd.comp
        (TrialityTriple.permuteLinearEquiv K e : TrialityTriple M ->l[K] TrialityTriple M)
      =
      (TrialityTriple.permuteLinearEquiv K e : TrialityTriple M ->l[K] TrialityTriple M).comp
        rho.toLinearEnd
```

If coercions make the exact statement awkward, choose the cleanest
kernel-checked statement and document the orientation.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not duplicate the active permutation-linear job.
- Keep proofs by `rw [TrialityActionData.toLinearEnd_apply]`, the existing
  `actTriple_permuteRoles` theorem, and extensionality.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/TrialityLinearEquivariance.lean
lake build PhysicsSM.Algebra.Furey.TrialityLinearEquivariance
lake build PhysicsSM
```

## Deliverable

Return files changed, theorem names proved, whether the file is sorry-free, and
exact verification commands run.
