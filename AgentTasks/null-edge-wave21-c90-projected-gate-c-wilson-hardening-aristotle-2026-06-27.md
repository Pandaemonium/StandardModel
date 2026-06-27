# Wave 21 / C90: harden projected Gate C Wilson release API

## Role

You are Aristotle, acting as a Lean proof specialist and adversarial theorem
reviewer for the null-edge / Furey / Standard Model formalization.

## Target

Preferred target module:

```text
PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean
```

If direct modification is risky, create an additive hardening module:

```text
PhysicsSM/Draft/NullEdgeProjectedGateCWilsonReleaseHardened.lean
```

## Context

`NullEdgeProjectedGateCWilsonRelease.lean` is an API-level conditional release
module for a physical projected/species-split/Wilson-regulated operator
`D_phys`.

It is not a bare `D_+` release theorem. It is not a C1 construction. It wraps
existing projected release clauses behind Wilson/regulator predicates.

Claude's adversarial review flagged several semantic risks:

- A bare alias or theorem name containing `GateCReleased` is too easy to
  misread as unconditional Gate C closure.
- `PostGaugeResiduePositive` is likely too weak for the Golterman-Shamir
  ghost-zero warning.
- `WilsonRegulatorAudited` as a black-box predicate does not distinguish fixed,
  constrained, tunable, or new-modulus regulators.
- C0/C1 separation should be enforced in types, not only prose.

## Main question

Can the projected Wilson release API be hardened so downstream users cannot
accidentally cite it as bare or full Gate C release?

## Requested changes

Please make the smallest semantically safe hardening pass:

1. Avoid or deprecate any alias named simply `GateCReleased` if it currently
   means `ProjectedGateCRelease`.
2. Introduce a more explicit name, such as:

```lean
ProjectedWilsonGateCRelease
ProjectedGateCReleaseUnderWilsonAudit
ProjectedC0C1WilsonConditionalRelease
```

3. Strengthen the ghost-safety side by splitting or supplementing the predicate:

```lean
PostGaugeResidueKreinPositive
PostGaugeResidueBRSTSafe
NoGaugeCoupledGhostZeros
```

The exact names may vary, but the API should make clear that scalar positivity
alone is not the full Golterman-Shamir safety condition.

4. Turn `WilsonRegulatorAudited` into a structure, or add an adjacent structure,
   with fields distinguishing:

```lean
regulatorFixedOrCanonical : Prop
noNewFreeModulus : Prop
gaugeCovariantOrLinkDressed : Prop
originIrrelevantOrC1Compatible : Prop
```

5. Add a guardrail theorem:

```lean
projectedWilsonRelease_not_bareGateCRelease
```

or an equivalent statement showing the theorem releases only the named
projected/regulated `D_phys`, not the bare symbol.

## Acceptance criteria

- Do not weaken existing release predicates silently.
- Do not claim the ghost problem is solved by a bare positivity field.
- Do not introduce a theorem implying C1 from C0.
- Preserve compatibility with existing `ProjectedGateCRelease` clauses.
- Prefer additive declarations over breaking rename churn unless the existing
  name is actively dangerous.
- No fake assumptions or hidden axioms.

## Semantic review checklist

When you return, include:

- names of predicates renamed or newly introduced;
- whether existing theorem names were preserved or replaced;
- exact statement of the hardened release theorem;
- exact statement of the "not bare release" or C0/C1 guardrail;
- any still-open clauses that remain merely API assumptions.
