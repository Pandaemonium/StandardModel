# Cross-family audit request: Floquet micromotion AF0

## Exact source under review

- `PhysicsSM/Draft/NullEdge/FloquetMicromotionSchedule.lean`

Please read the source itself, including the definitions wrapped by the three
guarded declarations. The intended result is deliberately narrow:

1. `endpoint` composes a finite list in physical time order, with the head
   acting first.
2. Unit substeps give unitary partial and full endpoints.
3. The schedules `[flip, flip]` and `[1, 1]` differ as lists but have the same
   endpoint.

The scientific use is only to establish that endpoint data cannot encode all
Floquet micromotion. It is not a winding theorem, a homotopy classification,
a single-Weyl theorem, or a primitive-null factorization.

## Independent checks requested

1. Confirm that the recursive multiplication order matches the stated
   head-acts-first convention.
2. Check the endpoint non-injectivity fixture is non-vacuous and genuinely
   distinguishes two histories of equal length.
3. Check that the prose does not outrun the finite matrix statements,
   especially the word "micromotion."
4. Confirm the three axiom guards cover the intended public payload and that
   no hidden placeholder or compiler-trust dependency enters them.

## Builder verification

```text
lake env lean PhysicsSM/Draft/NullEdge/FloquetMicromotionSchedule.lean
lake build PhysicsSM.Draft.NullEdge.FloquetMicromotionSchedule
```

Both commands passed on 2026-07-13. The targeted build completed 8,037 jobs;
warnings came only from existing imported draft modules.

## Verdict format

Return `ACCEPT`, `REVISE`, or `REJECT`, followed by exact semantic defects and
the narrowest necessary repair. Do not promote this rung beyond AF0.
