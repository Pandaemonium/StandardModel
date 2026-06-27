# Claude adversarial review packet: cycle 4, C94/C95 scheduling

Date: 2026-06-27
Audience: Claude Opus, blind adversarial reviewer

## Project context

We are developing a Lean-formalized null-edge Standard Model program. Gate C has split into:

- C0: external species health, including branch lifting, regulator legality, Krein-positive physical sector, and ghost-zero safety.
- C1: physical chiral release, requiring an actual protected chiral/index mechanism such as overlap/Ginsparg-Wilson, domain-wall, or a mathematically equivalent finite chiral construction.

Important current facts:

- Bare ordinary chirality at the raw tetrahedral branch kernels failed; branch kernels are chirality-balanced.
- Route B / projected-flavored structure is the active path.
- C0 health is not enough for C1 release.
- Ghost-zero safety is a separate hard gate after Golterman-Shamir-style warnings.
- Krein self-adjointness/positivity is not a substitute for Hilbert-sector stability.

## Active Aristotle jobs

Running:

- C89 `f481d8f1-4995-4b05-bfbc-398ca9b6810b`: concrete RA-Wilson / regulator instantiation.
- C93 `6ff32d74-0779-424b-b8a2-9d767251c3ea`: overlap/Ginsparg-Wilson C1 interface.
- C92 `03c6e63f-3a39-420e-81d3-173f2611b362`: Golterman-Shamir ghost-safety API/countermodels.
- C82 `893fe869-0e3c-40c5-b0cd-aa302f1a21ea`: regulator legality guardrail.
- C70 `e3986d7f-4928-4296-a7c8-cb4fb87eefae`: Wilson-related facts.

Returned/inspected this cycle:

- C90 `d53724a6-a0aa-4f8a-9c85-5285177fd16b`: projected Wilson hardening. The integration helper found only unchanged context copies (`SpinorTenfoldBasisOrbitAristotle.lean`, `WeylCliffordBridgeAristotle.lean`) and no `summary.md`; there was no Lean payload to apply.

## Current plan

We prepared C94 as a hard-dependent packet:

- C94 should wait for C93.
- It should instantiate the C93 overlap/GW interface against C89 RA-Wilson data.
- It should report which fields are proven/assumed/missing/contradicted.
- It must not claim release just because a regulator or modified chirality exists.

We also prepared C95 as an independent job:

- C95 formalizes an anti-vectorialization guardrail in a finite branch-table model.
- It should prove that perfect plus/minus physical pairing gives zero net index.
- It should prove that C0 health does not imply C1 nonzero index, using explicit countermodels.
- It is independent of C93's exact API and can run now.

## Questions for adversarial review

1. Is it correct to hold C94 until C93 returns, or should we submit an abstract instantiation attempt immediately?
2. Is C95 a scientifically useful independent job, or is it too abstract to matter?
3. What is the minimum anti-vectorialization theorem that would actually protect us from accidentally calling a vectorlike overlap construction a C1 release?
4. Did we miss a more urgent independent job while C89/C92/C93 are running?
5. Does the C90 no-payload result change strategy, or should it just be recorded as integrated-by-inspection/no-op?

Please be adversarial. Favor concrete next actions and call out any fake progress.
