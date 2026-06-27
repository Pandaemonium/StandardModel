# Aristotle job packet template

## Job title

...

## Target

```text
Module: PhysicsSM/Draft/...
Expected file: PhysicsSM/Draft/....lean
```

## Context

...

## Imports allowed

```lean
import Mathlib
-- or exact project imports
```

## Required theorem statements

```lean
-- theorem names and intended shapes
```

## Semantic acceptance criteria

- ...

## Forbidden weakenings

- Do not change signs, branch labels, metric convention, or grading convention.
- Do not replace the intended theorem with a vacuous data-field projection.
- Do not add new assumptions unless explicitly packaged as named hypotheses.

## Known related modules

- ...

## Verification expected from Aristotle

```text
lake build PhysicsSMDraft
#print axioms for headline theorems
placeholder scan where relevant
```

## Integration notes requested

- Files changed.
- Theorems proved.
- Any declarations relying on classical choice or quotient soundness.
- Any semantic caveats.
