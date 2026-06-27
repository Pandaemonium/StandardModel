# Claude adversarial review packet: C92 ghost-safety API

Date: 2026-06-27.

You are Claude Opus acting as an adversarial reviewer. This is a blind one-shot
packet.

## Project state

Gate C is split into:

```text
C0 = external species health / regulator control.
C1 = physical chiral release.
```

Submitted jobs now include:

- C89: concrete RA-Wilson C0 instantiation.
- C90: projected Wilson release hardening.
- C93: overlap/Ginsparg-Wilson C1 interface.
- C92: Golterman-Shamir ghost-safety API.

## C92 task

C92 asks Aristotle for a Lean API that prevents future code from treating scalar
residue positivity, Krein positivity, or C0 species health as full ghost safety.
It requests predicates/structures such as:

```text
noGaugeCoupledGhostZeros
brstOrCohomologicalSafe
kreinPhysicalSectorPositive
scalarResiduePositive
interpolatingFieldBasisComplete
GoltermanShamirSafe
```

and non-implication guardrails such as:

```text
scalarResiduePositive_not_ghostSafety
kreinPositive_not_ghostSafety
c0SpeciesHealth_not_ghostSafety
ghostSafety_requires_noGaugeCoupledGhostZeros
```

## Literature anchors

- Golterman-Shamir `2311.12790`: propagator zeros can become gauge-coupled ghost states.
- Golterman-Shamir `2505.20436`: propagator zeros may require enlarged elementary-plus-composite interpolating bases.
- Luscher `hep-lat/9802011`: exact chiral symmetry does not equal ghost safety.

## Question

Attack C92.

1. Is a Prop-level ghost-safety API worthwhile, or does it risk becoming empty
   packaging?
2. What fields/theorems make C92 non-vacuous?
3. What names must be avoided so future users do not cite scalar residue or
   Krein positivity as ghost safety?
4. What should Codex do locally while waiting for C92?

## Requested output

- Verdict.
- Failure modes.
- Minimum useful predicate fields.
- Required non-implication theorems.
- Next local/Aristotle job recommendation.
