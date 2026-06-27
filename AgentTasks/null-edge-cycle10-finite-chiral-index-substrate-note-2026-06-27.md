# Cycle 10 note: finite chiral-index substrate while C99 is running

Date: 2026-06-27.

## Status

Cycle 10 found no new returned Aristotle jobs:

- C99 `4fd2e530-eb89-4e94-83c1-dc97b254e0c4`: running.
- C89 `f481d8f1-4995-4b05-bfbc-398ca9b6810b`: running.
- C92 `03c6e63f-3a39-420e-81d3-173f2611b362`: running.
- C93 `6ff32d74-0779-424b-b8a2-9d767251c3ea`: running.
- C82 `893fe869-0e3c-40c5-b0cd-aa302f1a21ea`: running.
- C70 `e3986d7f-4928-4296-a7c8-cb4fb87eefae`: running.

C94 remains hard-dependent on C93. C96 remains hard-dependent on C92 plus C89.

## Literature refresh

Search phrases:

```text
finite-dimensional Ginsparg Wilson relation index theorem trace gamma5 finite matrix
overlap Dirac operator finite lattice index kernel chirality theorem
Ginsparg Wilson index finite lattice chiral zero modes trace gamma5
```

Source anchors:

- Luscher, `arXiv:hep-lat/9802011`, exact chiral symmetry and the
  Ginsparg-Wilson relation.
- Golterman-Shamir, `arXiv:2311.12790`, propagator zeros and lattice chiral gauge
  theories.
- Golterman-Shamir, `arXiv:2505.20436`, constraints on symmetric mass generation
  for lattice chiral gauge theories.

## Analysis

C98 proved the correct planning-level slogan:

```text
interface shape alone does not imply a nonzero chiral-index witness.
```

But it does so with a forgeable toy record:

```lean
structure InterfaceToy where
  hasInterfaceShape : Bool
  plusCount : Nat
  minusCount : Nat
```

C99 is therefore aimed at the right next layer: index must be computed from
finite substrate data, not arbitrary count fields.

The literature suggests two acceptable C99 outcomes:

1. Strong outcome:

   ```text
   finite graded operator D;
   an explicit grading involution Gamma with Gamma^2 = 1;
   plus/minus kernel spaces defined as Gamma eigenspaces, not by fiat;
   D anticommutes with Gamma, or satisfies a stated GW-deformed analogue;
   chiralIndex(D) = dim ker(D|V+) - dim ker(D|V-);
   interface-shape guardrail re-proved with explicit zero-index and nonzero-index examples.
   ```

2. Fallback outcome:

   ```text
   finite branch/state table with actual states and predicates;
   plus/minus counts derived from filtering the finite state set;
   explicit zero-index and nonzero-index examples.
   ```

The strong outcome is preferable, but the fallback is still a real hardening
over C98 because the counts are derived from finite substrate data rather than
user-supplied fields.

## C99 acceptance checklist

Accept C99 as useful if:

- it defines a finite substrate richer than C98's arbitrary `plusCount` /
  `minusCount` fields;
- the index or count is computed from that substrate;
- in the strong operator outcome, the substrate carries an explicit grading
  involution distinct from `D`, with plus/minus sectors derived from that
  grading;
- the zero-index countermodel is explicit;
- the nonzero-index example is explicit;
- the module says it is not C1 release, ghost safety, or regulator-removal
  stability;
- the names avoid generic release-facing terms such as unqualified
  `ChiralIndexWitness`.

Reject or downgrade C99 if:

- it merely repackages arbitrary plus/minus count fields;
- it introduces another Boolean `hasInterfaceShape` without a structural
  predicate;
- it claims or implies C1 release;
- it imports C97's Boolean `GaugeData` scaffold as evidence rather than a
  planning API;
- it uses index language without tying the index to finite data.

## Cycle 10 submission decision

No new Aristotle job should be launched during this cycle unless a completed
return appears. The active queue already contains the right decisive jobs:

- C99 for non-toy chiral-index substrate.
- C93 for overlap/Ginsparg-Wilson interface.
- C92 for ghost-safety API.
- C89 for regulator/removal handle.

Launching another C1-adjacent job before those return risks forking the API
surface again.
