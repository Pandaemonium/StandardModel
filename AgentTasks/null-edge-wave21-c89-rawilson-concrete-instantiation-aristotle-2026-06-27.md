# Wave 21 / C89: concrete RA-Wilson C0 instantiation

## Role

You are Aristotle, acting as a Lean proof specialist and adversarial theorem
reviewer for the null-edge / Furey / Standard Model formalization.

## Target

Preferred target module:

```text
PhysicsSM/Draft/NullEdgeRAWilsonConcrete.lean
```

If the concrete null-edge imports are too heavy for the budget, create a smaller
draft module that states the exact interface needed to connect the already
proved C85/C86 schemas to the actual retarded/advanced Wilson construction.

## Context

Recent kernel-checked modules:

- `NullEdgeRAWilsonGap.lean` proves the abstract Hilbert-space fact that an
  anti-Hermitian operator plus a positive scalar mass has a norm lower bound and
  no kernel.
- `NullEdgeGateC0SpeciesHealth.lean` packages the C0 species-health release
  layer and explicitly proves that C0 does not imply C1.
- `NullEdgeRegulatorLegalityAPI.lean` proves that a regulator that is irrelevant
  at the origin cannot repair an origin-balanced chiral kernel.
- `NullEdgeTasteOnlyOriginNoGo.lean` proves that a taste-only scalar involution
  cannot polarize the origin kernel.

Strategic split:

```text
Gate C0 = external species health.
Gate C1 = physical chiral release.
Gate H  = internal spectrum/anomaly/legal finite Dirac structure.
```

C85/C86 are C0 schemas. They do not release C1. They do not prove the concrete
null-edge retarded/advanced Wilson operator satisfies all hypotheses.

Claude's adversarial review flagged the current blocker:

```text
C85 is too abstract unless we instantiate the actual RA-Wilson doubled symbol.
```

## Main question

Can the actual null-edge RA-Wilson construction be connected to the C85/C86
abstract C0 species-health schema without overclaiming C1?

## Requested theorem shape

Please aim for the strongest useful theorem you can prove cleanly:

```lean
theorem concreteRAWilson_to_gateC0SpeciesHealthy :
  ConcreteRAWilsonCertificate D ->
    GateC0SpeciesHealthy D.toGateC0Data
```

The names may change to match existing APIs. The important point is that the
certificate should not be a vacuous restatement; it should explicitly identify
the concrete retarded/advanced doubled block and the positive Wilson mass term
used away from the origin.

## Minimum useful deliverable

If the fully concrete theorem is too expensive, produce a module with:

1. `structure ConcreteRAWilsonData` bundling the actual or intended null-edge
   symbol, the retarded/advanced doubled block, and the Wilson mass function.
2. A theorem that the retarded/advanced doubled block has the anti-Hermitian
   form required by `NullEdgeRAWilsonGap`.
3. A theorem or explicit field showing the Wilson mass is positive on the
   non-origin regulated sector and vanishes at the origin.
4. A bridge from this concrete certificate to `RAWilsonC0Certificate` or
   `GateC0SpeciesHealthy`.
5. A negative guardrail theorem or comment-level theorem statement saying this
   does not imply `GateC1ChiralPhysicalRelease`.

## Acceptance criteria

- Do not claim full Gate C release.
- Do not claim C1 chiral release.
- Do not hide the Wilson mass function as an unconstrained free scalar if a
  momentum-dependent function is needed.
- Address the C64 off-branch zero explicitly:
  either show the concrete Wilson mass lifts it in the C0 sector, show it lies
  outside the intended sector, or record it as an unresolved hypothesis.
- State clearly whether the theorem is Hilbert-norm only or Krein-compatible.
- No new hidden assumptions via fake axioms or opaque placeholders.

## Semantic review checklist

When you return, include:

- exact theorem names proved;
- whether the C85 anti-Hermitian hypothesis is genuinely instantiated;
- whether C64 off-branch zeros are handled or still assumed away;
- whether the result is Hilbert-only or Krein-aware;
- whether the result is C0-only, C1, or conditional full projected release.
