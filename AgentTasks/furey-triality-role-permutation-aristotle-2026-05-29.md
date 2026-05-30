# Aristotle task: Triality role permutation API

**Agent**: Aristotle
**Status**: Complete and integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `98d12a96-312c-4f8f-9d15-df9735d42649`
**Submission project**: `AgentTasks/aristotle-submit/furey-triality-role-permutation-20260529-project`
**Output**: `AgentTasks/aristotle-output/furey-triality-role-permutation-20260529`
**Extracted output**: `AgentTasks/aristotle-output/furey-triality-role-permutation-20260529-extracted`
**Integrated file**: `PhysicsSM/Algebra/Furey/TrialityRolePermutation.lean`
**Type**: finite symmetry scaffold / triality roles

## Goal

Add a small trusted API for permuting the three `TrialityRole` slots and for
applying those permutations to `TrialityTriple`.

This is a finite, sorry-free foundation for later Spin(8) triality work. It
does not define Spin(8), `tri(O)`, or any Standard Model action; it only proves
the combinatorics of the three role labels and their effect on triples.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Furey/TrialityRolePermutation.lean
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.TrialityRolePermutation
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.TrialityTriple
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Existing declarations

Useful names include:

```lean
PhysicsSM.Algebra.Furey.TrialityRole
PhysicsSM.Algebra.Furey.TrialityTriple
PhysicsSM.Algebra.Furey.TrialityTriple.proj
PhysicsSM.Algebra.Furey.TrialityTriple.ofFun
PhysicsSM.Algebra.Furey.TrialityTriple.proj_ofFun
PhysicsSM.Algebra.Furey.TrialityTriple.ofFun_proj
```

The three roles are:

```lean
TrialityRole.spinorPlus
TrialityRole.spinorMinus
TrialityRole.vector
```

## Target statements

Define the cyclic role permutation:

```lean
def TrialityRole.cycle : TrialityRole -> TrialityRole
```

with convention:

```text
spinorPlus -> spinorMinus -> vector -> spinorPlus
```

Define an equivalence/permutation if useful:

```lean
def TrialityRole.cycleEquiv : Equiv.Perm TrialityRole
```

Prove finite facts:

```lean
theorem TrialityRole.cycle_three (r : TrialityRole) :
    TrialityRole.cycle (TrialityRole.cycle (TrialityRole.cycle r)) = r

theorem TrialityRole.cycle_injective :
    Function.Injective TrialityRole.cycle
```

Define permutation of triples by pullback along a role permutation:

```lean
def TrialityTriple.permute (e : Equiv.Perm TrialityRole)
    (t : TrialityTriple A) : TrialityTriple A :=
  TrialityTriple.ofFun (fun r => t.proj (e.symm r))
```

Prove:

```lean
theorem TrialityTriple.proj_permute
    (e : Equiv.Perm TrialityRole) (t : TrialityTriple A) (r : TrialityRole) :
    (t.permute e).proj r = t.proj (e.symm r)

theorem TrialityTriple.permute_refl
    (t : TrialityTriple A) :
    t.permute (Equiv.refl TrialityRole) = t

theorem TrialityTriple.permute_trans
    (e f : Equiv.Perm TrialityRole) (t : TrialityTriple A) :
    (t.permute e).permute f = t.permute (f.trans e)
```

Finally specialize to the triality cycle:

```lean
def TrialityTriple.cycle (t : TrialityTriple A) : TrialityTriple A :=
  t.permute TrialityRole.cycleEquiv

theorem TrialityTriple.cycle_three (t : TrialityTriple A) :
    t.cycle.cycle.cycle = t
```

Adjust theorem statements if Lean's `Equiv.Perm` composition convention makes
another orientation cleaner; document the convention.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- This is a finite role-permutation scaffold only; do not claim Spin(8)
  triality has been formalized.
- Keep proofs by cases/extensionality.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/TrialityRolePermutation.lean
lake env lean PhysicsSM.lean
```

## Deliverable

Return files changed, theorem names proved, whether the output is sorry-free,
and exact verification commands run.

## Integration result

Integrated on 2026-05-29 into trusted code as
`PhysicsSM.Algebra.Furey.TrialityRolePermutation`.

Main declarations added:

- `TrialityRole.cycle`
- `TrialityRole.cycle_three`
- `TrialityRole.cycle_injective`
- `TrialityRole.cycleInv`
- `TrialityRole.cycleInv_cycle`
- `TrialityRole.cycle_cycleInv`
- `TrialityRole.cycleEquiv`
- `TrialityRole.cycleEquiv_apply`
- `TrialityRole.cycleEquiv_symm_apply`
- `TrialityTriple.permute`
- `TrialityTriple.proj_permute`
- `TrialityTriple.permute_refl`
- `TrialityTriple.permute_trans`
- `TrialityTriple.cycle`
- `TrialityTriple.cycle_three`

Verification run during integration:

```bash
lake env lean PhysicsSM\Algebra\Furey\TrialityRolePermutation.lean
lake build PhysicsSM.Algebra.Furey.QopJbarEigenBridge PhysicsSM.Algebra.Furey.TrialityTripleModule PhysicsSM.Algebra.Furey.TrialityRolePermutation
lake build PhysicsSM
```

Status: sorry-free trusted integration. The root build passed with pre-existing
warnings in older modules.
