---
project_id: 33efa8c6-2015-49d8-8c70-a5487e766ee8
task_id: 973d1a78-e278-40c3-b661-425285cc6f8c
status: integrated
created: 2026-06-27
round: gate-c1-reference-match
---

# Aristotle C155: point-splitting/flavored-mass dictionary for null-edge branches

Goal: Translate point-splitting flavored mass constructions from naive/minimally doubled overlap literature into null-edge branch projector language.

Key references from Neo4j:
- `Index Theorem and Overlap Formalism with Naive and Minimally Doubled Fermions`, arXiv `1110.2482`, Zotero `QB6UXK3U`.
- JHEP/preprint duplicate/theme, arXiv `1011.0761`, Zotero `72HIN3TA`.

Requested deliverables:

1. Explain how point-splitting implements flavored mass terms and species selection in the reference literature.
2. Map point-split species/taste projectors to null-edge branch/flavor projectors.
3. Compare this to the C145 branch-Pauli seed and the C138 anticommutation/sign-straddling condition.
4. State a Lean-friendly interface for a null-edge point-split flavored mass term.
5. Identify whether this gives a better `W_branch` construction than the current abstract branch-Pauli insertion.

Success criterion: a concrete dictionary that can guide the actual operator construction rather than just the finite toy seed.

## Submission status

Submitted on 2026-06-27. Project: 33efa8c6-2015-49d8-8c70-a5487e766ee8. Task: 973d1a78-e278-40c3-b661-425285cc6f8c.

Integrated on 2026-06-27.

Aristotle delivered:

```text
C155_PointSplit_Dictionary.md
RequestProject/C155.lean
```

The dictionary document was copied into:

```text
AgentTasks/null-edge-c155-pointsplit-dictionary-integration-2026-06-27.md
```

The Lean artifact was preserved in the downloaded Aristotle archive:

```text
AgentTasks/aristotle-output/33efa8c6-2015-49d8-8c70-a5487e766ee8/project.zip
```

Key result:

```text
point-split flavored mass
  = product over branch Pauli signs
  = concrete W_branch candidate
  = automatic C138 sign-straddling seed.
```

This makes point-splitting/flavored mass the preferred concrete construction
for `W_branch`, rather than an abstract branch-Pauli insertion.
