# Aristotle task: DVT common stabilizer restriction

**Agent**: Aristotle
**Status**: Complete and integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `76122f22-010d-4ab8-a163-363577c0163c`
**Submission project**: `AgentTasks/aristotle-submit/baez-dvt-stabilizer-restriction-20260529-project`
**Output**: `AgentTasks/aristotle-output/baez-dvt-stabilizer-restriction-20260529`
**Extracted output**: `AgentTasks/aristotle-output/baez-dvt-stabilizer-restriction-20260529-extracted`
**Integrated file**: `PhysicsSM/Algebra/Jordan/DVTStabilizerRestriction.lean`
**Type**: Jordan stabilizer restriction / DVT scaffold

## Goal

Build the next DVT-facing theorem layer after
`DVTStabilizerPrelude`: a derivation in the common stabilizer of

```text
A = h_2(O)
B = h_3(C)
```

restricts to an endomorphism of the intersection

```text
A cap B = h_2(C).
```

This is the safe formal shadow of the Baez/Dubois-Violette/Todorov stabilizer
intersection story. It should not assert the final compact group theorem.

## Sources and claim boundary

Source motivation:

- John Baez, "Can We Understand the Standard Model?", 2021.
- Ivan Todorov and Michel Dubois-Violette, "Deducing the symmetry of the
  standard model from the automorphism and structure groups of the exceptional
  Jordan algebra", arXiv:1806.09450.
- Ivan Todorov, "Exceptional quantum algebra for the standard model of particle
  physics", arXiv:1911.13124.

Claim boundary:

- Do not prove `Aut(h_3(O)) = F4`.
- Do not prove `Stab(A) = Spin(9)`.
- Do not prove the final `S(U(2) x U(3))` identification.
- This job should only package restriction-to-intersection facts for existing
  derivation stabilizers.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Jordan/DVTStabilizerRestriction.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTStabilizerRestriction
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Existing inputs

Useful declarations:

```lean
H3O
H3ODerivation
InStandardA
InStandardB
InStandardAInterB
standardAAndB_derivationStabilizer
standardAInterB_derivationStabilizer
standardAAndB_subset_standardAInterB
DerivationStabilizesSet
commutator
```

## Target declarations

Define the subtype of the intersection:

```lean
abbrev StandardAInterBElement := {x : H3O // InStandardAInterB x}
```

For a common-stabilizer derivation, define its restricted action:

```lean
def restrictCommonStabilizerToAInterB
    (D : H3ODerivation)
    (hD : D in standardAAndB_derivationStabilizer) :
    StandardAInterBElement -> StandardAInterBElement :=
  fun x => ...
```

The proof obligation should use
`standardAAndB_subset_standardAInterB hD`.

Prove the coercion/apply theorem:

```lean
@[simp]
theorem restrictCommonStabilizerToAInterB_apply
    (D : H3ODerivation)
    (hD : D in standardAAndB_derivationStabilizer)
    (x : StandardAInterBElement) :
    (restrictCommonStabilizerToAInterB D hD x : H3O) = D x.1
```

If convenient, package this as a linear map on the subtype:

```lean
def restrictCommonStabilizerToAInterBLinear
    (D : H3ODerivation)
    (hD : D in standardAAndB_derivationStabilizer) :
    StandardAInterBElement ->l[Real] StandardAInterBElement
```

If subtype/module instances make this awkward, omit the linear-map package and
prove explicit add/smul compatibility theorems instead:

```lean
theorem restrictCommonStabilizerToAInterB_map_add ...
theorem restrictCommonStabilizerToAInterB_map_smul ...
```

Finally, if feasible, prove commutator compatibility:

```lean
theorem restrict_commutator_apply
    {D1 D2 : H3ODerivation}
    (h1 : D1 in standardAAndB_derivationStabilizer)
    (h2 : D2 in standardAAndB_derivationStabilizer)
    (x : StandardAInterBElement) :
    (restrictCommonStabilizerToAInterB (commutator D1 D2)
        (standardAAndB_derivationStabilizer_commutator_mem h1 h2) x : H3O)
      =
    D1 (D2 x.1) - D2 (D1 x.1)
```

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Keep the module a restriction API only.
- Use existing predicates; do not redefine the standard subalgebras.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTStabilizerRestriction.lean
lake build PhysicsSM.Algebra.Jordan.DVTStabilizerRestriction
lake build PhysicsSM
```

## Deliverable

Return files changed, theorem names proved, whether the file is sorry-free, and
exact verification commands run.

## Integration result

Integrated on 2026-05-29 into trusted code as
`PhysicsSM.Algebra.Jordan.DVTStabilizerRestriction`.

Main declarations added:

- `StandardAInterBElement`
- `restrictCommonStabilizerToAInterB`
- `restrictCommonStabilizerToAInterB_apply`
- `restrictCommonStabilizerToAInterB_add`
- `restrictCommonStabilizerToAInterB_map_add`
- `restrictCommonStabilizerToAInterB_map_smul`
- `restrictCommonStabilizerToAInterB_zero`
- `restrictCommonStabilizerToAInterB_neg`
- `restrict_commutator_apply`

Verification run during integration:

```bash
lake env lean PhysicsSM\Algebra\Jordan\DVTStabilizerRestriction.lean
lake build PhysicsSM.Algebra.Furey.TrialityActionMonoid PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly PhysicsSM.Algebra.Octonion.G2ComplexLine PhysicsSM.Algebra.Jordan.DVTStabilizerRestriction
```

Status: sorry-free trusted integration. The targeted build passed with
pre-existing warnings in older modules. Claim boundary remains: no `F4`,
`Spin(9)`, or `S(U(2) x U(3))` identification is asserted.
