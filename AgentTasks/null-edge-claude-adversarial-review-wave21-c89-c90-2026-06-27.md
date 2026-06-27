# Claude adversarial review packet: Wave 21 C89/C90

Date: 2026-06-27.

You are Claude Opus acting as an adversarial research reviewer for the
null-edge / Furey / Standard Model formalization. Assume you are coming in
blind: this packet contains the relevant context and the question.

## Project thesis

The program is trying to reconstruct Standard Model mass and chirality
mechanisms from a finite null-edge operator architecture.

Current safe slogan:

```text
Primitive spacetime transport is null. Effective mass appears as a canonical
quadratic obstruction to remaining a single free gapless null mode.
```

Current gate split:

```text
Gate C0 = external species health / regulator control.
Gate C1 = physical chiral release.
Gate H  = internal Furey/Baez/DVT spectrum, anomaly, and legal finite Dirac data.
Gate F  = prediction/codimension, not mere reconstruction.
```

## Current Gate C facts

The bare tetrahedral null-edge symbol does not release Gate C.

Kernel-checked/returned results have established:

- Bare high-momentum branch kernels are chirality-balanced, not scalar ordinary
  chirality sectors.
- Determinant zeros include extended nodal curves and off-branch zeros.
- Taste-only scalar origin polarization does not solve the physical chiral
  release problem.
- A regulator can help external species health, but a C0 regulator result does
  not imply C1 physical chirality.
- Golterman-Shamir-style propagator/ghost zeros are a hard safety condition,
  not optional polish.

Therefore the current strategy is:

```text
First prove C0 species health for a concrete retarded/advanced Wilson-regulated
null-edge operator. Then separately pursue C1 through overlap, domain-wall,
Ginsparg-Wilson, or spinor-line structure.
```

## Recent submitted jobs

### C89: concrete RA-Wilson C0 instantiation

Aristotle project:

```text
f481d8f1-4995-4b05-bfbc-398ca9b6810b
```

Target:

```text
PhysicsSM/Draft/NullEdgeRAWilsonConcrete.lean
```

Purpose:

- Connect the actual null-edge retarded/advanced Wilson construction to the
  abstract C85/C86 C0 species-health schema.
- Explicitly identify the doubled anti-Hermitian block and the positive Wilson
  mass/regulator term.
- Address the C64 off-branch zero either by lifting it in the C0 sector,
  excluding it from the intended sector, or recording it as an unresolved
  hypothesis.
- Preserve C0-not-C1 language.

### C90: projected Gate C Wilson release hardening

Aristotle project:

```text
d53724a6-a0aa-4f8a-9c85-5285177fd16b
```

Target:

```text
PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean
```

or additive module:

```text
PhysicsSM/Draft/NullEdgeProjectedGateCWilsonReleaseHardened.lean
```

Purpose:

- Harden naming so projected/regulated release is not confused with bare Gate C
  release.
- Split ghost-safety predicates beyond scalar residue positivity.
- Distinguish fixed/canonical regulators from tunable/free-modulus regulators.
- Add explicit guardrails that C0 species health does not imply C1 physical
  chiral release.

## Literature anchors

Use these as comparison points:

- Luscher `hep-lat/9802011`: Ginsparg-Wilson exact lattice chiral symmetry.
- Golterman-Shamir `2311.12790`: propagator zeros become gauge-coupled ghost
  states.
- Golterman-Shamir `2505.20436`: SMG/propagator-zero constraints and
  generalized no-go pressure.
- Kimura-Creutz-Misumi `1110.2482` / `1011.0761`: overlap/index diagnostics
  with naive and minimally doubled fermions.
- Single curved surface Weyl/domain-wall `2402.09774`: warning that free
  single-Weyl localization can become vectorlike with gauge topology.

## Question for you

Please attack the current Wave 21 strategy.

1. Are C89 and C90 the right next jobs, or do they still risk optimizing the
   wrong layer?
2. What theorem names, predicates, or release-language choices would still be
   dangerous even if C89/C90 return kernel-checked modules?
3. What should the next Aristotle jobs be after C89/C90 return?
4. What local Lean/docs work should Codex do while waiting?
5. What would count as genuine progress toward C1 rather than just better C0
   packaging?

## Requested output

Please give:

- `Verdict`: continue / pivot / downgrade / cancel route.
- `Main risks`: ordered list.
- `Required wording guardrails`: exact phrases or theorem names to avoid.
- `Next jobs`: 3 to 6 concrete Aristotle/local targets.
- `C1 breakthrough criteria`: what would actually move physical chiral release.
- `Publication posture`: how to describe this safely in the working plan.
