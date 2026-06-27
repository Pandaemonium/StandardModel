# Claude adversarial review packet: cycle 5, C96 regulator-removal stability

Date: 2026-06-27
Audience: Claude Opus, blind adversarial reviewer

## Project context

We are running an autonomous loop for a Lean-formalized null-edge Standard Model program.

Gate C has split into:

- C0: external species health: Wilson/regulator legality, branch lifting, Krein/ghost hygiene.
- C1: physical chiral release: a protected non-vectorlike/index mechanism, likely via overlap/Ginsparg-Wilson/domain-wall or equivalent finite chiral construction.

Current active jobs:

- C89: concrete RA-Wilson / regulator instantiation.
- C92: Golterman-Shamir ghost-safety API/countermodels.
- C93: overlap/Ginsparg-Wilson C1 interface.
- C95: anti-vectorialization finite guardrail with explicit C0-healthy vectorlike countermodel.
- C82/C70: regulator and Wilson support jobs.

C90 returned and had to be reconstructed from raw task summary because the downloadable archive omitted its claimed changed file. It hardened `NullEdgeProjectedGateCWilsonRelease.lean` with explicit ghost-safety and regulator-moduli clauses.

## Literature pass this cycle

The required literature search surfaced:

- Luescher, exact lattice chiral symmetry and GW relation, arXiv:hep-lat/9802011.
- Kähler-Dirac / mirror decoupling warnings, arXiv:2311.02487.
- Golterman-Shamir propagator-zero ghost warning, arXiv:2311.12790.
- Golterman-Shamir SMG constraints, arXiv:2505.20436.
- Nielsen-Ninomiya extension, arXiv:hep-lat/9803002.
- Minimally doubled counterterm warnings, arXiv:0910.2597 and arXiv:1006.2009.

## Proposed next job: C96

C96 would be an independent finite guardrail for regulator-removal stability. The purpose is to prevent the loop from treating finite-regulator C0 health, or even finite-regulator anti-vectorlike appearance, as C1 release unless the anti-vectorlike/index witness survives regulator removal or the limiting physical-sector map.

The proposed C96 finite API uses:

```text
BranchTable
C0Healthy : BranchTable -> Prop
AntiVectorlikeWitness : BranchTable -> Prop
VectorlikeSpectrum : BranchTable -> Prop
RegulatorRemovalScenario with regulated : BranchTable and limit : BranchTable
C1StableUnderRegulatorRemoval scenario :=
  AntiVectorlikeWitness scenario.regulated -> AntiVectorlikeWitness scenario.limit
```

Required theorem/countermodel:

```text
exists S,
  C0Healthy S.regulated and
  AntiVectorlikeWitness S.regulated and
  not AntiVectorlikeWitness S.limit
```

Positive packaging theorem:

```text
AntiVectorlikeWitness S.regulated ->
C1StableUnderRegulatorRemoval S ->
AntiVectorlikeWitness S.limit
```

## Questions

1. Is C96 genuinely useful, or is it too abstract / tautological given C95 already exists?
2. What finite theorem statement would make C96 non-vacuous and worth an Aristotle slot?
3. Should C96 be submitted now while C89/C92/C93/C95 are running, or held until C95 returns?
4. Should the C1 release predicate eventually require both `AntiVectorlikeWitness` and `RegulatorRemovalC1Stable`, or is one redundant?
5. What fake-progress trap should this cycle explicitly log?

Please be adversarial and concrete.
