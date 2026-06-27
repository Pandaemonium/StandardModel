# Aristotle C96: regulator-removal stability guardrail for Gate C1

Date: 2026-06-27
Type: independent finite Lean/audit job
Dependency class: independent / soft-dependent. This job does not need C89/C93/C95 to return.

## Background

The null-edge Gate C program now separates:

- C0: external species health, regulator legality, branch lifting, Krein/ghost hygiene.
- C1: physical chiral release, requiring a protected non-vectorlike/index witness.

Recent work:

- C90 hardened the projected Wilson release API so ghost-zero safety and regulator-moduli clauses are explicit.
- C95 asks for an anti-vectorialization guardrail: C0 health does not imply nonzero index or non-vectorlike spectrum.
- C93 is running as an overlap/Ginsparg-Wilson C1 interface.
- C94 is held until C93 returns; it should instantiate the C93 interface against C89 RA-Wilson data.

The missing independent guardrail is regulator-removal consistency. A regulator may make C0 look healthy at finite cutoff while the non-vectorlike chiral witness disappears when the regulator is removed or the limiting physical sector is taken.

This job should prevent the loop from recording:

```text
finite-regulator C0 health
```

as:

```text
C1 chiral release
```

unless a surviving anti-vectorlike/index witness is part of the data.

## Literature anchors

Use these as conceptual anchors, not as imported Lean assumptions:

- Luescher, exact chiral symmetry and Ginsparg-Wilson relation, arXiv:hep-lat/9802011.
- Golterman-Shamir propagator zeros and lattice chiral gauge theories, arXiv:2311.12790.
- Golterman-Shamir constraints on SMG/lattice chiral gauge theories, arXiv:2505.20436.
- Nielsen-Ninomiya extension, arXiv:hep-lat/9803002.
- Minimally doubled counterterm/renormalization warnings, arXiv:0910.2597 and arXiv:1006.2009.

## Task

Create a small finite theorem package or Lean-ready report for a regulator-removal C1 stability guardrail.

Preferred Lean module:

```text
PhysicsSM/Draft/NullEdgeRegulatorRemovalC1Stability.lean
```

If a Lean module is feasible, keep it independent of the full null-edge operator and use finite branch/mode tables. If not, return precise Lean-ready definitions and theorem statements.

## Suggested finite API

Use an abstract finite branch/mode table similar to C95:

```text
BranchTable
C0Healthy : BranchTable -> Prop
AntiVectorlikeWitness : BranchTable -> Prop
VectorlikeSpectrum : BranchTable -> Prop
```

Then define a regulated pair or family:

```text
structure RegulatorRemovalScenario where
  regulated : BranchTable
  limit : BranchTable
```

or, if more useful:

```text
stage : Nat -> BranchTable
limit : BranchTable
```

Define:

```text
RegulatedC0Healthy scenario := C0Healthy scenario.regulated
LimitC1Witness scenario := AntiVectorlikeWitness scenario.limit
C1StableUnderRegulatorRemoval scenario :=
  AntiVectorlikeWitness scenario.regulated -> AntiVectorlikeWitness scenario.limit
```

The exact shape may vary, but the logic must distinguish finite-regulator health from surviving C1 chirality.

## Required theorems / countermodels

Prove concrete finite statements, preferably with explicit tables:

```text
finite_regulator_c0_not_limit_c1:
  exists S,
    C0Healthy S.regulated and
    AntiVectorlikeWitness S.regulated and
    not AntiVectorlikeWitness S.limit.
```

This is the essential guardrail: even finite-regulator anti-vectorlike appearance does not prove the limiting physical sector is C1 unless stability is supplied.

Also prove:

```text
c0_health_not_regulator_removal_stability:
  exists S,
    C0Healthy S.regulated and
    C0Healthy S.limit and
    not C1StableUnderRegulatorRemoval S.
```

If direct implication definitions make this awkward, use a concrete statement showing the regulated table is non-vectorlike and the limit table is vectorlike.

Then prove a positive packaging theorem:

```text
stable_witness_gives_limit_c1:
  AntiVectorlikeWitness S.regulated ->
  C1StableUnderRegulatorRemoval S ->
  AntiVectorlikeWitness S.limit.
```

This theorem is intentionally simple but important as API discipline.

## Optional useful theorem

If C95-style `VectorlikeSpectrum` is included, prove:

```text
limit_vectorlike_blocks_c1_release:
  VectorlikeSpectrum S.limit -> not AntiVectorlikeWitness S.limit.
```

or the equivalent using zero index.

## Scientific role

This should become a C1 release-predicate field:

```text
RegulatorRemovalC1Stable
```

so future Gate C accounting cannot say:

```text
regulator controlled the branches, therefore C1 released.
```

The intended release logic is instead:

```text
C0 health
+ overlap/GW or domain-wall interface
+ anti-vectorialization/nonzero-index witness
+ regulator-removal stability of that witness
+ ghost/Krein safety
=> candidate C1 release.
```

## Constraints

- Do not claim a real continuum limit theorem.
- Keep this finite and explicit.
- Do not bake C1 into the definition of C0 health.
- Include at least one explicit countermodel, not just abstract non-implication prose.
- If using Lean, avoid placeholder proofs in headline theorems.
- If using arbitrary predicates makes the result tautological, instantiate enough concrete branch tables to make the countermodel meaningful.

## Desired output summary

At the end, state whether the output provides:

```text
A finite regulator-removal stability API.
A concrete countermodel showing finite-regulator C0/C1-looking data can lose C1 in the limit.
A positive packaging theorem saying stability plus finite witness gives limit witness.
A recommendation for how C93/C94 should import or mirror the stability field.
```
## Cycle 5 hold note

Claude reviewed this packet on 2026-06-27 and correctly flagged the current draft as too abstract if submitted immediately. Hold C96 until C92/C95 return with concrete ghost/vectorlike table APIs, or revise it so:

- `BranchTable` has decidable finite content;
- `AntiVectorlikeWitness` carries data, ideally the offending charge or count mismatch;
- the limit table is computed from an explicit decoupling/removal map, not stipulated freely;
- the limit failure clause is positive (`VectorlikeSpectrum limit`), not just `not AntiVectorlikeWitness limit`;
- the positive theorem is an anomaly/count conservation lemma, not `(P -> Q) -> P -> Q`.

Fake-progress traps to avoid:

```text
C96-FP1: modus-ponens guardrail.
C96-FP2: negation-loophole limit.
C96-FP3: normalizing archive-missing reconstruction into trusted code without follow-up repair/validation.
```
