# C95 integration note: anti-vectorialization finite guardrail

Date: 2026-06-27
Project: `406dd6b0-7866-419b-8dbc-e29c758fe5e9`
Integrated module: `PhysicsSM/Draft/NullEdgeAntiVectorializationGuardrail.lean`

## Result

C95 returned a concrete finite anti-vectorialization API and was integrated into
the repo.

New draft module:

```text
PhysicsSM.Draft.NullEdgeAntiVectorializationGuardrail
```

It defines:

```text
Mode
Spectrum
physical
NetIndex
plusCount
minusCount
netIndexNonzero
VectorlikeSpectrum
C0Healthy
AntiVectorlikeWitness
```

The important design choices are:

- `VectorlikeSpectrum` is not merely `plusCount = minusCount`; it asks for an
  involution pairing physical modes, preserving multiplicity and swapping
  chirality.
- `C0Healthy` is deliberately weak toy external health and does not include
  index/non-vectorlike content.
- `AntiVectorlikeWitness` is the C1 discriminator: `NetIndex B != 0`.

## Headline theorems

```text
vectorlike_implies_zero_index
nonzero_index_forbids_vectorlike
c0_health_does_not_forbid_vectorlike
exists_c0_healthy_antivectorlike
c0_cannot_decide_c1
```

Concrete witnesses:

```text
B0: one +1 and one -1 physical healthy mode, vectorlike and C0-healthy.
B1: one +1 physical healthy mode, C0-healthy with NetIndex = 1.
```

## Scientific meaning

C95 proves the key C1 guardrail:

```text
C0 health is compatible with both vectorlike and non-vectorlike finite spectra.
```

Therefore C0 health cannot decide C1 release. Any future Gate C1 release
predicate must demand a separate `AntiVectorlikeWitness` or equivalent
nonzero-index datum.

## Integration caveat

The integration helper did not discover the module automatically because the
archive path shape was:

```text
dcadb19a-7e13-45e0-b2e1-43071e47c691_aristotle/PhysicsSM/Draft/NullEdgeAntiVectorializationGuardrail.lean
```

The module was extracted manually and `PhysicsSMDraft.lean` was updated to
import it. No validation was run in this cycle.

## C96 impact

C95 supplies a concrete finite `Spectrum`/`AntiVectorlikeWitness` API. It may
unblock a revised C96 regulator-removal stability job if C96 can be scoped
purely to survival of the `AntiVectorlikeWitness` across a computed finite limit
map.

However, C92 is still running and may supply canonical ghost/safety table
concepts. The current conservative stance is: do not submit C96 until
Claude/next-cycle review decides whether C95 alone is enough or whether C92 is
needed to avoid an API fork.
