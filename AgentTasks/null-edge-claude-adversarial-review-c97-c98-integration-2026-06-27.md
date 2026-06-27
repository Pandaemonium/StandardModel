# Claude adversarial review request: C97/C98 Gate C guardrail integration

Date: 2026-06-27.

You are reviewing two newly integrated Aristotle returns in the null-edge Gate C
program. Please be adversarial and concrete. The actual Lean source files are
attached separately by the caller; do not rely only on this prose summary.

## Project context

The null-edge program is currently trying to separate:

- Gate C0: external species health / regulator legality.
- Gate C1: physical chiral release.
- Gate H: internal Furey/Baez/DVT spectrum, anomaly, and legal finite Dirac
  structure.

The recurring failure mode is fake C1 progress:

- C0 health or Wilson/regulator hygiene is accidentally stated as C1 release.
- An overlap/Ginsparg-Wilson/domain-wall interface shape is accidentally stated
  as nonzero chiral index.
- Residue/Krein positivity is accidentally stated as ghost-zero safety.
- A toy finite table is accidentally promoted into a physical release predicate.

Recent durable decisions:

- C96 regulator-removal stability is held until C92 returns concrete ghost
  safety and C89 returns a regulator/removal handle.
- C95 anti-vectorialization is only a planning guardrail until hardened.
- C94 is hard-dependent on C93.

## Files under review

1. `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean`

This is the C97 return. It replaces the earlier hand-reconstructed C90 module
with a self-contained kernel-checked C90 hardening API over finite `GaugeData`.
Intended meaning:

- `ProjectedWilsonGateCRelease` is the preferred name.
- `GateCReleased` remains only as deprecated compatibility shim.
- `PostGaugeResidueKreinPositive` is positivity only and must not imply ghost
  zero safety.
- `PostGaugeGoltermanShamirSafe` should bundle residue positivity, no ghost
  zeros, and explicit BRST.
- `WilsonRegulatorModuliAudit` should expose moduli-policy obligations.
- The file should not derive C1 release from C0 species/regulator health alone.

2. `PhysicsSM/Draft/NullEdgeChiralIndexWitnessGuardrail.lean`

This is the C98 return. Intended meaning:

- Interface shape alone does not imply nonzero chiral index.
- There is a concrete interface-shaped zero-index countermodel.
- There is a concrete interface-shaped nonzero-index witness for non-vacuity.
- A zero index blocks a chiral index witness.
- The file is a planning guardrail only; it is not a C1 release substrate.

## Questions

1. Are these files semantically aligned with the intended readings above?
2. Does C97 still allow any fake inference from residue/Krein positivity,
   Wilson/regulator audit, or deprecated `GateCReleased` into full C1 release?
3. Does C98 adequately protect against interface-shape-as-index overclaim, or is
   its `InterfaceToy` too weak / forgeable in a way that should be hardened
   before downstream use?
4. Should C97/C98 be used as imports in later C1 release predicates, or should
   they remain planning-only guardrails?
5. What exact next Aristotle job should be launched if we want the highest-value
   safe follow-up that is independent of still-running C89/C92/C93?

Please produce:

- A verdict for C97.
- A verdict for C98.
- Any theorem/API names that are dangerous or misleading.
- A short "safe to use as..." classification for each file.
- The recommended next job, with dependency class:
  `Independent`, `Soft-dependent`, or `Hard-dependent`.
