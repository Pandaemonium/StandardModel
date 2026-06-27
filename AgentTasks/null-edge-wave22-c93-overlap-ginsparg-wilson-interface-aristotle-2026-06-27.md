# Wave 22 / C93: overlap and Ginsparg-Wilson C1 interface

## Role

You are Aristotle, acting as a Lean proof specialist and adversarial theorem
reviewer for the null-edge / Furey / Standard Model formalization.

## Aristotle metadata

`yaml
aristotle:
  project_id: 6ff32d74-0779-424b-b8a2-9d767251c3ea
  target_file: PhysicsSM/Draft/NullEdgeOverlapC1Interface.lean
  status: submitted
`

## Target

Preferred target module:

```text
PhysicsSM/Draft/NullEdgeOverlapC1Interface.lean
```

If direct connection to existing null-edge operators is too expensive, create a
small abstract API module that states the exact C1 interface a null-edge
operator would need to satisfy.

## Context

The program now explicitly separates:

```text
Gate C0 = external species health / regulator control.
Gate C1 = physical chiral release.
```

Recent results show:

- The bare tetrahedral null-edge symbol has chirality-balanced branch kernels.
- Taste-only scalar origin polarization fails.
- RA-Wilson / regulator work is C0 species-health work, not C1 release.
- C89 and C90 were submitted to instantiate and harden the C0/projected API.

Therefore this job should be a genuine C1-facing interface, not another C0
hardening job.

## Literature anchors

- Luscher `hep-lat/9802011`: the Ginsparg-Wilson relation gives exact lattice
  chiral symmetry without ordinary Nielsen-Ninomiya assumptions.
- Kimura-Creutz-Misumi `1110.2482` / `1011.0761`: overlap/index diagnostics
  with naive and minimally doubled fermion kernels.
- Golterman-Shamir `2311.12790` and `2505.20436`: ghost/propagator-zero and
  generalized no-go cautions.

## Main question

What exact Lean-level interface would a null-edge operator need in order to
support an overlap/Ginsparg-Wilson C1 route?

## Requested theorem/API shape

Please create a small API around a finite-dimensional operator `D`, a chirality
operator `Gamma`, and a scale/mass parameter `mu`.

Possible declarations:

```lean
structure GinspargWilsonData where
  D : E -> E
  Gamma : E -> E
  mu : R
  gamma_sq : Gamma * Gamma = 1
  gw_relation : Gamma * D + D * Gamma = (1 / mu) • (D * Gamma * D)

def ModifiedChirality := Gamma * (1 - (1 / mu) • D)

theorem modifiedChirality_square_on_physicalSector : ...
theorem gwRelation_not_naiveAnticommutation : ...
theorem c1NeedsMoreThanC0SpeciesHealth : ...
```

The exact algebraic setting may be simplified. A matrix/endomorphism API over a
finite type or finite-dimensional module is acceptable.

## Minimum useful deliverable

If a full theorem package is too expensive, return:

1. `structure NullEdgeC1OverlapInterface` or similar, with fields that make the
   missing hypotheses explicit.
2. A theorem saying this interface is logically stronger/different from C0
   species health.
3. A guardrail theorem or docstring saying RA-Wilson C0 does not imply this
   interface.
4. A list of exact fields a future concrete null-edge operator must provide.

## Acceptance criteria

- Do not claim the current null-edge operator satisfies the interface.
- Do not claim C1 release.
- Do not introduce fake assumptions as if proved.
- Do not collapse naive chirality with modified Ginsparg-Wilson chirality.
- The output should make the missing hypotheses precise enough for the next
  concrete job to attack.

## Semantic review checklist

When you return, include:

- exact names introduced;
- whether this is pure API or proves a nontrivial algebraic fact;
- which fields are currently uninstantiated by the null-edge operator;
- how this differs from C0 species health;
- the next concrete theorem needed after this interface.
