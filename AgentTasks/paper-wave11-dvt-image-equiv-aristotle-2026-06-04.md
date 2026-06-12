# Aristotle task: DVT quotient image equivalence

Date: 2026-06-04

## Goal

Turn the new faithful DVT quotient action into a cleaner citation theorem:
the quotient `(SU(3) x SU(3)^op) / Z3` is multiplicatively equivalent to its
image inside `AddAut H3OComplement`.

Primary target file:

```text
PhysicsSM/Algebra/Jordan/DVTTwoSidedImageEquiv.lean
```

Useful imports:

```text
PhysicsSM.Algebra.Jordan.DVTTwoSidedStabilizerMoonshot
PhysicsSM.Algebra.Jordan.DVTTwoSidedSU3QuotientStabilizer
PhysicsSM.Algebra.Jordan.DVTTwoSidedActionKernelZ3Iff
```

## Preferred theorem shape

Please create a new trusted module, with no placeholders, proving a package
like:

```lean
structure DVTTwoSidedImageEquivPackage where
  imageSubgroup : Subgroup (AddAut H3OComplement)
  quotientEquivImage :
    DVTTwoSidedSU3Quotient ~=* imageSubgroup
  quotientEquivImage_apply :
    forall x : DVTTwoSidedSU3Quotient,
      ((quotientEquivImage x : AddAut H3OComplement) =
        dvtQuotientStabilizerHom x)
  image_membership :
    forall f : AddAut H3OComplement,
      f in imageSubgroup <->
        exists x : DVTTwoSidedSU3Quotient,
          dvtQuotientStabilizerHom x = f
```

Use the actual Lean spelling for `MulEquiv` and subgroup coercions. If the
exact structure above is awkward, prove the same content with the closest
Mathlib API, e.g. a `MulEquiv` from the quotient to
`MonoidHom.range dvtQuotientStabilizerHom`.

## Stretch target

Also prove that the pair-level image has identity fiber exactly the central
`DVTZ3CentralScalar`, restating the existing `identityFiber_z3` theorem in a
form that composes cleanly with the image equivalence.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not weaken any DVT definitions.
- This is only an algebraic image theorem; do not claim topology, smoothness,
  or the full exceptional Jordan stabilizer theorem.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTTwoSidedImageEquiv.lean
lake build PhysicsSM.Algebra.Jordan.DVTTwoSidedImageEquiv
```

## Submission

Status: integrated.

Submission project:

```text
AgentTasks/aristotle-submit/paper-wave11-20260604
```

Job ID:

```text
76b49ac6-9089-4b7e-bcaa-d981645b4dca
```

Integrated result:

```text
PhysicsSM/Algebra/Jordan/DVTTwoSidedImageEquiv.lean
```

Verification run after integration:

```bash
lake build PhysicsSM.Algebra.Jordan.DVTTwoSidedImageEquiv
```
