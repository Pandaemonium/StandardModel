# Aristotle task: triality action monoid

**Agent**: Aristotle
**Status**: Complete and integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `2e21e22b-6e6d-4c48-9222-172a4fef0bca`
**Submission project**: `AgentTasks/aristotle-submit/furey-triality-action-monoid-20260529-project`
**Output**: `AgentTasks/aristotle-output/furey-triality-action-monoid-20260529`
**Extracted output**: `AgentTasks/aristotle-output/furey-triality-action-monoid-20260529-extracted`
**Integrated file**: `PhysicsSM/Algebra/Furey/TrialityActionMonoid.lean`
**Type**: algebraic packaging / triality action data

## Goal

Package `TrialityActionData` as a monoid under componentwise composition and
prove that `toLinearEnd` is a monoid homomorphism into linear endomorphisms of
`TrialityTriple M`.

This gives the Furey-Hughes triality scaffold a reusable algebraic API: action
data can be composed abstractly, and the corresponding linear operators compose
as expected.

## Sources and claim boundary

Source motivation:

- Cohl Furey and Mia Hughes, "Three Generations and a Trio of Trialities",
  arXiv:2409.17948.

Claim boundary:

- This is a formal API theorem about the project scaffold.
- Do not claim these actions are the full `tri(C) + tri(H) + tri(O)` Lie
  algebra or the Standard Model internal symmetry action.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Furey/TrialityActionMonoid.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.TrialityTripleModule
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Existing inputs

Useful declarations:

```lean
TrialityActionData.id
TrialityActionData.comp
TrialityActionData.toLinearEnd
TrialityActionData.toLinearEnd_id
TrialityActionData.toLinearEnd_comp
TrialityActionData.ext'
```

## Target declarations

Define:

```lean
instance instOneTrialityActionData :
    One (TrialityActionData K M)

instance instMulTrialityActionData :
    Mul (TrialityActionData K M)
```

with:

- `1 = TrialityActionData.id`
- `rho * sigma = rho.comp sigma`

Then prove simp lemmas:

```lean
@[simp] theorem TrialityActionData.one_def :
    (1 : TrialityActionData K M) = TrialityActionData.id

@[simp] theorem TrialityActionData.mul_def
    (rho sigma : TrialityActionData K M) :
    rho * sigma = rho.comp sigma
```

Add:

```lean
instance instMonoidTrialityActionData :
    Monoid (TrialityActionData K M)
```

Use extensionality over the three component endomorphisms.

Finally define:

```lean
def TrialityActionData.toLinearEndMonoidHom :
    TrialityActionData K M ->* Module.End K (TrialityTriple M)
```

Use `TrialityActionData.toLinearEnd_id` and
`TrialityActionData.toLinearEnd_comp`. Be careful about multiplication
orientation in `Module.End`; if `rho * sigma = rho.comp sigma`, then the
linear-endomorphism multiplication orientation should match. If it does not,
adjust the theorem statement or the multiplication convention and document it.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not weaken existing definitions.
- Keep proof terms small and readable.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/TrialityActionMonoid.lean
lake build PhysicsSM.Algebra.Furey.TrialityActionMonoid
lake build PhysicsSM
```

## Deliverable

Return files changed, theorem names proved, whether the file is sorry-free, and
exact verification commands run.

## Integration result

Integrated on 2026-05-29 into trusted code as
`PhysicsSM.Algebra.Furey.TrialityActionMonoid`.

Main declarations added:

- `instOneTrialityActionData`
- `instMulTrialityActionData`
- `TrialityActionData.one_def`
- `TrialityActionData.mul_def`
- `instMonoidTrialityActionData`
- `TrialityActionData.toLinearEndMonoidHom`

Verification run during integration:

```bash
lake env lean PhysicsSM\Algebra\Furey\TrialityActionMonoid.lean
lake build PhysicsSM.Algebra.Furey.TrialityActionMonoid PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly PhysicsSM.Algebra.Octonion.G2ComplexLine PhysicsSM.Algebra.Jordan.DVTStabilizerRestriction
```

Status: sorry-free trusted integration. The targeted build passed with
pre-existing warnings in older modules.
