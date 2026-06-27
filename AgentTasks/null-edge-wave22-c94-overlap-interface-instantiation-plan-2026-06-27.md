# C94 plan: instantiate C93 overlap/Ginsparg-Wilson C1 interface against C89 RA-Wilson data

Date: 2026-06-27
Status: hard-dependent packet; do not submit until C93 returns.

## Purpose

C94 should be launched only after Aristotle job C93 returns an actual interface/API for an overlap or Ginsparg-Wilson-style C1 release predicate.

The job should attempt to populate that interface using the concrete RA-Wilson / regulator data from C89, then report the first missing field, contradiction, or extra hypothesis. It must not claim Gate C1 release unless every field is populated with a real theorem and the non-release guardrails are satisfied.

## Dependencies

Hard dependencies:

- C93 `6ff32d74-0779-424b-b8a2-9d767251c3ea`: overlap/Ginsparg-Wilson C1 interface.
- C89 `f481d8f1-4995-4b05-bfbc-398ca9b6810b`: concrete RA-Wilson / regulator instantiation data, if returned before C94 is launched.

Soft dependencies:

- C92 `03c6e63f-3a39-420e-81d3-173f2611b362`: ghost-safety API and countermodel guardrails.
- C82/C70 regulator legality and Wilson facts.

## Required audit fields

C94 should classify each C93 field as one of:

```text
Proven from C89/C70/C82 data.
Assumed explicitly and recorded as a hypothesis.
Missing because no current theorem supplies it.
Contradicted by current branch/nodal/ghost facts.
Not applicable because C93's interface changed the target.
```

Expected fields to check:

```text
D_phys / candidate physical operator.
Regulator or Wilson kernel.
Kernel gap / admissibility condition.
Ginsparg-Wilson relation or overlap chirality relation.
Modified chirality operator.
Index / nontriviality witness.
No vectorlike cancellation / anti-vectorialization side condition.
C0 species-health separation from C1 chirality release.
Ghost-zero safety handoff to C92.
Krein-positive physical-sector handoff.
```

## Non-release guardrails

C94 must explicitly preserve these statements:

```text
C0 species health is not C1 chiral release.
A regulator that gaps doublers is not automatically an index theorem.
A formal modified chirality is not automatically a nonzero chiral spectrum.
A projected physical sector is not released until ghost-zero and Krein clauses are discharged.
```

## Desired output

A report or Lean module that says exactly where the C93 interface can and cannot be populated. The highest-value successful outcome is not necessarily release; a precise first missing field is useful progress.
