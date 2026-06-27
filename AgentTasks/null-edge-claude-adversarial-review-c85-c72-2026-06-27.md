# Claude adversarial review packet: C85/C72 Gate C0 and projected Wilson release - 2026-06-27

## Role

You are an adversarial reviewer for the null-edge / Furey / Standard Model
formalization program. Your job is to find semantic mismatches, overclaims,
missing hypotheses, and better theorem splits. Be direct. Do not be polite at
the expense of accuracy.

## Current objective

Review the integration and strategic meaning of two newly integrated Aristotle
results:

- C85: `PhysicsSM/Draft/NullEdgeRAWilsonGap.lean`
- C72: `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean`

The key risk is overclaiming Gate C. The project currently splits Gate C into:

- Gate C0: external species health.
- Gate C1: physical chiral release.

Gate H/Furey is internal spectrum, anomaly, and legal finite Dirac structure. It
does not solve external branch control.

## Current project state

Known facts before C85/C72:

- Bare `D_+` does not release Gate C.
- C21 showed the actual four-component tetrahedral Clifford symbol has a
  two-dimensional, chiral-balanced branch kernel at each nonzero null branch.
- C43/C44 showed exact determinant-zero branch-line nodal curves.
- C64 showed an off-branch determinant zero not controlled by the simple
  `g5/T_lin` splitting term.
- C22/K2 showed chirality and Krein positivity can pull apart.
- C88 showed a taste-only scalar regulator cannot polarize the origin kernel.
- Current strategic expectation: RA-Wilson can plausibly release C0, but C1
  likely needs a Weyl/domain-wall/overlap/spinor-line auxiliary mechanism.

## Newly integrated results

### C85: RA-Wilson accretive gap

Target:

```text
PhysicsSM/Draft/NullEdgeRAWilsonGap.lean
```

Aristotle summary:

- Defines an anti-Hermitian predicate for complex inner-product-space
  endomorphisms.
- Proves the norm lower bound:

```text
m^2 ||v||^2 <= ||(A + m I) v||^2
```

for anti-Hermitian `A`.

- Proves injectivity and zero-kernel for `A + m I` when `m > 0`.
- Proves a concrete retarded/advanced block

```text
[[0, B], [-B^dagger, 0]]
```

is anti-Hermitian.

- Packages this as `RAWilson_gap_schema`.

Important guardrail:

```text
C85 is abstract Gate C0 species-health linear algebra.
It does not prove the concrete null-edge operator satisfies the anti-Hermitian
hypothesis.
It does not release C1.
```

### C72: Projected Gate C Wilson release API

Target:

```text
PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean
```

Aristotle summary:

- Defines `NullWilsonRegulatedNodalControl D_phys`.
- Defines `PostGaugeResiduePositive D_phys`.
- Defines `WilsonRegulatorAudited R_W D_phys`.
- Proves `projectedGateCRelease_from_wilson_residue`.
- Wraps the existing projected Gate C release predicate for a physical
  projected/species-split/Wilson-regulated operator `D_phys`.
- Explicitly records that the theorem releases `D_phys`, not bare `D_+`.

Important guardrail:

```text
C72 is an API-level conditional release theorem.
It depends on projected branch, chirality, Krein, ghost-safety, nodal-control,
and regulator-audit clauses.
It is not an unconditional construction of those clauses.
```

## Assumptions to attack

- That C85 plus C72 should be described as closing Gate C0.
- That the current C0/C1 split is sharp enough.
- That C72's `GateCReleased := ProjectedGateCRelease` naming is not too easy to
  misread as full/bare Gate C release.
- That the anti-Hermitian hypothesis in C85 is the right abstraction for the
  concrete RA-Wilson double.
- That `PostGaugeResiduePositive` is strong enough to represent the
  Golterman-Shamir ghost-zero warning.
- That `WilsonRegulatorAudited` adequately records whether the regulator is
  fixed, constrained, or a new modulus.
- That the next jobs should focus on instantiating C85 against C73/C86, rather
  than jumping to C1 overlap/domain-wall structure.

## Specific questions

1. What is the strongest honest claim after C85/C72?
2. Which theorem statements are most likely too weak, vacuous, or dangerously
   named?
3. What exact next Lean theorem would best convert C85 from abstract C0 algebra
   into concrete null-edge C0 evidence?
4. What exact next Lean or strategy job would best attack C1 after C88's
   taste-only no-go?
5. Should the plan rename any C72-facing predicate to avoid overclaiming?
6. What should be sent to Pro next, if anything?

## Required output format

```text
Findings:
- severity, issue, why it matters, suggested fix

Missed blockers:
- ...

Overclaim risks:
- ...

Recommended next Aristotle jobs:
- title, target, acceptance criteria

Publication language warnings:
- ...

Bottom-line verdict:
- continue | pivot | downgrade | kill route | ask Pro
```
