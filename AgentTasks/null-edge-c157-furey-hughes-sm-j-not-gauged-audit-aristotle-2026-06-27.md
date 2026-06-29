---
project_id: b01927c3-3629-40e6-b186-d9326ee1b09c
task_id: 1752bd20-18b1-4c33-8bbe-df6c6fe7dcc0
status: integrated
created: 2026-06-27
round: gate-c1-reference-match
output_dir: AgentTasks/aristotle-output/b01927c3-3629-40e6-b186-d9326ee1b09c
---

# Aristotle C157: Furey/Hughes/SM J-not-gauged audit

Goal: Apply the C144 gauge-internality condition to the intended Furey/Hughes/Standard Model internal representation.

Context: C144 proves the abstract dichotomy: native Gate C1 works if gauge acts internally and does not gauge branch `J`; it fails if `J` is gauged. The remaining question is whether the intended SM/Furey-Hughes representation satisfies `J_not_gauged`.

Requested deliverables:

1. Identify the project-level intended factors: branch, spin/flavor, Furey/Hughes internal algebra, and SM gauge action.
2. Determine whether branch `J` is outside the gauge representation or could be mixed with internal gauge generators.
3. State a precise checklist/theorem: if SM gauge acts only on the internal/Furey-Hughes factor, then C144 applies.
4. Identify ambiguity or convention risks, especially octonion/convention issues.
5. Recommend what repo docs or Lean modules should record as assumptions before claiming gauge-safe native mode.

Success criterion: reduce the physical SM embedding question to explicit assumptions or a clear no-go.

## Submission status

Submitted on 2026-06-27. Project: b01927c3-3629-40e6-b186-d9326ee1b09c. Task: 1752bd20-18b1-4c33-8bbe-df6c6fe7dcc0.

## Completion summary

Integrated on 2026-06-27.

Aristotle delivered a standalone Lean module and audit document. The audit note
was copied into:

```text
AgentTasks/null-edge-c157-furey-hughes-sm-j-not-gauged-audit-integration-2026-06-27.md
```

The Lean module was preserved in the downloaded artifact but was not copied into
the live source tree in this pass, because it uses a standalone namespace and
should be converted into a project-facing API deliberately.

Core result:

```text
SMActsInternally
  -> every gauge generator has form id_B tensor g_i
  -> every gauge generator commutes with J = J_b tensor id
  -> J_not_gauged
  -> native Gate C1 is gauge-safe under the C144 dichotomy.
```

Main caveat:

This is a reduction to explicit assumptions, not an automatic proof that the
physical Standard Model embedding satisfies them. The dangerous case is
identifying the null-edge branch factor with the chirality factor touched by
`SU(2)_L` or hypercharge. In that case `J` may be gauged and native mode fails.

Assumptions to record before claiming native gauge safety:

- `A1`: the branch factor carrying `J` is disjoint from every factor acted on by
  SM gauge generators.
- `A2`: the null-edge branch grading is not the weak-isospin/hypercharge
  chirality grading.
- `A3`: the Furey/Hughes associative internal action and octonion conventions
  are fixed.
- `A4`: flavor/generation operations do not leak into the branch factor.
