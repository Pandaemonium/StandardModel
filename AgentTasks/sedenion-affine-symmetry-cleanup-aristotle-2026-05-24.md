# Aristotle cleanup: affine symmetry classification

Goal: clean the positive N2 affine-symmetry result into a reusable draft module.

Submission:

```text
Aristotle ID: a492ee01-669d-4eef-ae90-ed37fe3ceea1
Submission package:
AgentTasks/aristotle-submit/sedenion-affine-symmetry-cleanup-20260524-project
Status at submission: created
```

Prior Aristotle result:

```text
Job: 054fca4d-e5ed-401e-9ad4-b237b310c2c7
Raw returned module:
AgentTasks/aristotle-output/054fca4d-e5ed-401e-9ad4-b237b310c2c7-extracted/
  sedenion-next-moonshots-20260523-project_aristotle/
    PhysicsSM/Draft/Sedenions/AffineSymmetryClassificationMoonshot.lean
```

The raw module typechecks against the live checkout, but it is too much of an
artifact to import directly.  It is a heavy finite enumeration with large
heartbeat budgets and duplicated helper definitions.

## Desired output

Create:

```text
PhysicsSM/Draft/Sedenions/AffineSymmetryClassification.lean
```

Import and reuse the existing modules where possible:

```lean
import PhysicsSM.Draft.Sedenions.GL32Action
import PhysicsSM.Draft.Sedenions.PSL27FlavorGeometry
import PhysicsSM.Draft.Sedenions.ReedMullerCode
import PhysicsSM.Draft.Sedenions.CocycleQuadraticPhase
```

Do not import the raw `AffineSymmetryClassificationMoonshot` file.  Do not add
the new file to `PhysicsSMDraft.lean` unless the resulting module is reasonably
clean and builds without excessive runtime.

## Target theorem cluster

Try to preserve the main results from the raw module, with names close to:

```lean
theorem affine_preservers_zp_supports_card :
    countZPPreservers = 336 := ...

theorem zpPreservers_fix_v8 :
    allZPPreserversFixV8 = true := ...

theorem zpPreservers_translation_in_0_8 :
    allZPPreserversTranslation08 = true := ...

theorem zpPreservers_b0_card :
    countZPPreserversB0 = 168 := ...

theorem zpPreservers_b8_card :
    countZPPreserversB8 = 168 := ...

theorem partner_forced_preservers_eq_gl32_lift :
    allB0PreserversAreGL32Lift = true := ...

theorem translation_by_8_preserves_zpSupports :
    preservesZP 1 2 4 8 8 = true := ...

theorem cZD_preserver_card :
    countCZDPreservers = 2688 := ...

theorem cZD_strictly_larger :
    countZPPreservers < countCZDPreservers := ...

theorem cZD_vs_zp_ratio :
    countCZDPreservers / countZPPreservers = 8 := ...
```

It is acceptable to keep `native_decide` for the cardinality certificates, but
please try to:

- remove duplicated definitions already available in the imported modules;
- avoid `import Mathlib`;
- keep helper definitions documented and local;
- split the enumeration into readable pieces;
- add a module docstring explaining that this is a finite draft certificate;
- avoid `sorry`, `admit`, `axiom`, `opaque`, and `unsafe`.

## Semantic constraints

Use the recursive Cayley-Dickson convention from the sedenion draft modules.
Do not identify it with the trusted project octonion convention.

The theorem should say exactly what was proved by N2:

```text
affine preservers of the 42 zero-product supports: 336
affine preservers of C_ZD: 2688
```

The interpretation is finite combinatorics only.  Do not claim this is a
physical flavor group.
