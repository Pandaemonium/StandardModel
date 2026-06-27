# Claude adversarial review packet: cycle 7, C95 integrated

Date: 2026-06-27
Audience: Claude Opus, blind adversarial reviewer

## Context

We are running an autonomous loop for a Lean-formalized null-edge Standard Model
program. Gate C has split into C0 external species health and C1 physical
chiral release.

Current active jobs after C95 integration:

- C89: concrete RA-Wilson / regulator instantiation, running.
- C92: Golterman-Shamir ghost-safety API/countermodels, running.
- C93: overlap/Ginsparg-Wilson C1 interface, running.
- C97: repair/validate reconstructed C90 Wilson-release hardening, running.
- C98: interface-shape does not imply chiral index witness, running.
- C82/C70: regulator/Wilson support, running.

C94 remains hard-dependent on C93. C96 regulator-removal stability was held
because the first draft was too abstract.

## C95 result integrated this cycle

Aristotle project `406dd6b0-7866-419b-8dbc-e29c758fe5e9` returned a module,
manually extracted from the archive and imported into `PhysicsSMDraft.lean`:

```text
PhysicsSM/Draft/NullEdgeAntiVectorializationGuardrail.lean
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

Important details:

- `VectorlikeSpectrum` is a real finite pairing/involution condition, not just
  `plusCount = minusCount`.
- `C0Healthy` is deliberately weak and does not mention index.
- `AntiVectorlikeWitness` is `NetIndex != 0`.

Theorems:

```text
vectorlike_implies_zero_index
nonzero_index_forbids_vectorlike
c0_health_does_not_forbid_vectorlike
exists_c0_healthy_antivectorlike
c0_cannot_decide_c1
```

Concrete examples:

- `B0`: C0-healthy vectorlike spectrum with one +1 and one -1 physical healthy
  mode.
- `B1`: C0-healthy anti-vectorlike spectrum with one +1 physical healthy mode
  and `NetIndex = 1`.

## Questions

1. Does C95 satisfy the anti-vectorialization guardrail strongly enough for C1
   planning?
2. Is C95's `AntiVectorlikeWitness := NetIndex != 0` sufficient, or do we
   still need a data-carrying witness such as an offending charge/count mismatch
   before using it in C1 release predicates?
3. Does C95 alone unblock a revised C96 regulator-removal stability job, or
   should C96 still wait for C92 ghost/safety APIs to avoid forking the table
   model?
4. What exact theorem should C96 ask for if it uses C95's `Spectrum` API?
5. Should the next cycle prioritize integrating returns only, given the active
   queue is near the concurrency target, or launch a C96 follow-up immediately?

Please be adversarial and concrete. In particular, call out any way C95 could
still support fake C1 progress.
