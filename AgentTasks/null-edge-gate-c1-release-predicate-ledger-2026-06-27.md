# Gate C1 release-predicate ledger

Date: 2026-06-27
Status: live planning ledger for C93/C94/C95/C96 integration

## Purpose

This ledger records the minimum data that must be present before the null-edge program may call any projected/regulated construction a Gate C1 release.

It exists because several useful C0 facts can look deceptively close to C1:

```text
branch lifting;
Wilson/regulator legality;
Krein-positive selected branches;
ghost-zero safety;
modified chirality operators;
overlap/Ginsparg-Wilson relation shape.
```

None of these is C1 release by itself. C1 requires a protected non-vectorlike chiral witness in the physical/limiting sector.

## C0 versus C1

C0 means external species health:

```text
regulated determinant branches controlled;
projectors well-defined;
unwanted branches lifted, discarded, or interpreted;
Krein-positive physical sector identified;
Golterman-Shamir ghost-zero hazards excluded;
regulator/counterterm/moduli clauses audited.
```

C1 means physical chiral release:

```text
a non-vectorlike / nonzero-index chiral witness exists for the physical sector,
and this witness survives the regulator-removal or physical limiting map.
```

C0 is necessary hygiene. C1 is the chiral content gate.

## Minimum C1 release fields

A future `GateC1Release` predicate should expose fields equivalent to the following.

```text
C0Healthy D_phys
```

Role: all external species-health clauses are satisfied. This should import or mirror C90/C92/Krein/Wilson safety predicates.

Supplier candidates:

- C89 for concrete RA-Wilson / regulator instantiation.
- C90 for hardened projected Wilson release API.
- C92 for ghost-zero safety and concrete non-implication witnesses.
- C82/C70 for regulator/Wilson support facts.

```text
OverlapOrDomainWallInterface D_phys
```

Role: the candidate has a real protected chiral mechanism shape, such as a Ginsparg-Wilson, overlap, domain-wall, or equivalent finite interface. This is not release by itself.

Supplier candidates:

- C93 for overlap/Ginsparg-Wilson C1 interface.
- C94 after C93 returns, to instantiate the interface against C89.

```text
AntiVectorlikeWitness D_phys
```

Role: the projected physical branch/mode table is not secretly vectorlike. The witness should be data-carrying, not a bare opaque proposition: for example an offending charge, count mismatch, nonzero index, or trace/index value.

Supplier candidates:

- C95 anti-vectorialization guardrail.

Required guardrail:

```text
C0Healthy does not imply AntiVectorlikeWitness.
```

C95 must provide a concrete C0-healthy vectorlike countermodel.

```text
RegulatorRemovalC1Stable D_reg D_limit
```

Role: the anti-vectorlike witness survives the regulator-removal / continuum / physical-sector limiting map. This cannot be a theorem that reduces to `(P -> Q) -> P -> Q`.

Supplier candidates:

- C96, but only after C92/C95 provide concrete finite table APIs.

Required guardrails:

```text
finite-regulator C0 health does not imply limit C1;
finite-regulator anti-vectorlike appearance does not imply limit anti-vectorlike witness;
limit failure must be positive, e.g. VectorlikeSpectrum limit, not merely not AntiVectorlikeWitness limit.
```

```text
GhostAndKreinPhysicalSafety D_phys
```

Role: the C1 witness is not carried by ghost-like, wrong-Krein, or gauge-coupled pathological modes.

Supplier candidates:

- C92 for ghost-zero API/countermodels.
- K2/C90 for Krein-positive physical-sector packaging.

```text
ModuliAndCountertermAudit D_phys
```

Role: regulator, Wilson, splitting, projector, or counterterm choices are either fixed/canonical, symmetry-forced, or explicitly counted as free moduli. This controls prediction language.

Supplier candidates:

- C90 hardened Wilson regulator moduli audit.
- C82/C70 regulator legality support.

## Provisional release schematic

The intended future theorem shape is:

```text
C0Healthy D_phys ->
OverlapOrDomainWallInterface D_phys ->
AntiVectorlikeWitness D_phys ->
RegulatorRemovalC1Stable D_reg D_limit ->
GhostAndKreinPhysicalSafety D_phys ->
ModuliAndCountertermAudit D_phys ->
GateC1Release D_limit
```

This is intentionally stronger than C0. It should be impossible to inhabit by proving only branch health or Wilson residue positivity.

## Non-release statements to preserve

Future modules should include or reuse the following non-implication guardrails:

```text
C0Healthy does not imply AntiVectorlikeWitness.
C0Healthy does not imply GateC1Release.
PostGaugeResidueKreinPositive does not imply NoGaugeCoupledGhostZeros.
ProjectedWilsonGateCRelease does not release the bare symbol.
Overlap/GW interface shape does not imply nonzero index.
AntiVectorlikeWitness at finite regulator does not imply limit AntiVectorlikeWitness.
RegulatorRemovalC1Stable without finite AntiVectorlikeWitness is vacuous.
```

## Active job map

```text
C89: concrete RA-Wilson / regulator instantiation.
C90: hardened projected Wilson release API; integrated by task-summary reconstruction, awaiting C97 repair/validation.
C92: Golterman-Shamir ghost-safety API/countermodels.
C93: overlap/Ginsparg-Wilson C1 interface.
C94: held; instantiate C93 against C89 after C93 returns.
C95: anti-vectorialization guardrail.
C96: held; regulator-removal stability, only after concrete C92/C95 table APIs.
C97: repair/validate reconstructed C90 hardening.
```

## Literature anchors

- Luescher, exact chiral symmetry and the Ginsparg-Wilson relation, arXiv:hep-lat/9802011.
- Nielsen-Ninomiya extension, arXiv:hep-lat/9803002.
- Golterman-Shamir propagator-zero ghost warning, arXiv:2311.12790.
- Golterman-Shamir SMG/lattice chiral gauge constraints, arXiv:2505.20436.
- Reduced Kahler-Dirac mirror/measure warning, arXiv:2311.02487.
- Minimally doubled counterterm warnings, arXiv:0910.2597 and arXiv:1006.2009.

## Current operational rule

Do not submit a C1 release or regulator-removal theorem whose positive result is just modus ponens over opaque predicates. Require concrete finite data, data-carrying witnesses, and positive countermodels.
## Cycle 6 correction: release predicate shape

Claude review on 2026-06-27 flagged that the provisional schematic above should not be read as a chain of implications over freely varying witnesses. The release predicate must be a conjunction over one shared regulated/physical/limit package.

Preferred shape:

```text
structure GateC1Package where
  D_reg   : RegulatedData
  D_phys  : ProjectedPhysicalData
  D_limit : LimitData
  same_operator_lineage : D_phys = projectedGatedWilson D_reg  -- or equivalent lineage field
  regulator_family : RegulatorFamily D_reg D_limit
  c0_health : C0Healthy D_phys
  interface : OverlapOrDomainWallInterface D_phys
  finite_index : ChiralIndexWitness D_phys
  finite_antivectorlike : AntiVectorlikeWitness D_phys
  limit_index : ChiralIndexWitness D_limit
  limit_antivectorlike : AntiVectorlikeWitness D_limit
  regulator_removal_stable : RegulatorRemovalC1Stable D_reg D_limit
  locality_bound : RegulatorLocalityBound D_reg
  witness_gauge_equivariant : GaugeEquivariantWitness finite_antivectorlike
  ghost_safety : GhostZeroSafety D_limit
  krein_positive : KreinPositivePhysicalSector D_limit
  brst_safe : BRSTSafe D_limit
  moduli_audit : ModuliAudit D_limit
  counterterm_audit : CountertermAudit D_limit
```

The final release theorem should consume one `GateC1Package`, not independently supplied fields that might refer to different operators.

Additional non-release guardrails added by the review:

```text
Interface shape does not imply ChiralIndexWitness.
Interface shape may be satisfied by a zero-index or trivial model.
Finite AntiVectorlikeWitness alone does not imply limit AntiVectorlikeWitness.
Krein positivity, ghost safety, and BRST/gauge safety should stay separate fields.
Moduli audit and counterterm audit should stay separate fields.
All C1 fields must be tied to the same operator lineage; no witness mixing.
```

Immediate follow-up job:

```text
C98: finite ChiralIndexWitness guardrail, proving an interface-shaped toy object can have zero index and therefore interface shape alone is not release.
```
