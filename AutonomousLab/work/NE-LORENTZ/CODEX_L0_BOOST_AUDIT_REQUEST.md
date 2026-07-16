# Cross-family audit request: L0-BOOST-001

## Exact artifact

`PhysicsSM/Draft/NullEdge/L0FiniteSupportBoostNoGo.lean`

## Claimed result

For the exact rational 3-4-5 boost, the selected future unit-timelike vector
`(1,0)` has an injective forward orbit, detected by `t+x = 3^n`. Therefore no
finite support containing it can be forward-invariant. The zero singleton and
identity transformation are explicit boundary controls.

## Required attacks

1. Compare the boost and quadratic-form conventions with
   `Goal3BoostCovRational.lean`.
2. Check that forward invariance is sufficient for the advertised invariant-set
   no-go and that finiteness is used nontrivially.
3. Check the selected witness is nonzero, future-directed, and timelike.
4. Check the zero and identity controls genuinely block overgeneralization.
5. Check for hidden assumptions, compiler trust, vacuity, and false theorem
   shape.
6. Enforce scope: this is a fixed-finite-support obstruction, not a proof or
   disproof of Lorentz invariance in distribution.

## Builder verification

```powershell
lake env lean PhysicsSM/Draft/NullEdge/L0FiniteSupportBoostNoGo.lean
lake build PhysicsSM.Draft.NullEdge.L0FiniteSupportBoostNoGo
```

Both pass; targeted build completed with 8,027 jobs. Aggregate guard is queued.
Write findings-first disposition under this directory and request transitions
through `labctl.py log` because Codex holds the JSON writer lane.
