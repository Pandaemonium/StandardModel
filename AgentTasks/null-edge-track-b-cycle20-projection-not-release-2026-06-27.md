# Track B cycle 20: projection is not physical release

Date: 2026-06-27
Cycle: 20
Track: B - information/generalization guardrail

## Trigger

The cycle 20 literature search surfaced reduced/Kahler-Dirac fermion and lattice chiral-fermion material alongside Ginsparg-Wilson and no-go hits. The lateral lesson is that projection/reduction can be a useful representation move, but it is not automatically a physical release of unwanted charged branches.

## Named failure mode

**Projection-as-release fallacy.** A projector, reduced description, observer channel, or quotient removes a branch from the visible bookkeeping, and the project then treats that as if the mirror sector had acquired a true inverse-propagator gap with anomaly, locality, and ghost audits passed.

## Finite theorem target

State a toy projection API with visible and hidden branch predicates:

```lean
structure BranchProjectionToy where
  branch : Type
  visible : branch -> Bool
  charged : branch -> Bool
  gapped : branch -> Bool
  ghostSafe : branch -> Bool
```

Target counterexample:

```lean
theorem projection_not_release :
    exists d,
      (exists b, d.visible b = false /\ d.charged b = true) /\
      not (forall b, d.charged b = true -> d.gapped b = true /\ d.ghostSafe b = true)
```

This is deliberately elementary: it prevents Track B observer/projection language from substituting for the Gate C mirror-sector audit.

## Claim boundary

Projection can define a candidate physical sector or an observer-conditioned diagnostic. It cannot by itself certify physical chiral release.
