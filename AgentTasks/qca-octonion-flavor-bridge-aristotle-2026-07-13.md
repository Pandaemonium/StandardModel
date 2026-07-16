# Aristotle task: 3+1 QCA flavor cover to octonion XOR bridge

- Work item: `NE-3PLUS1-FLAVOR-001`
- Role: Builder / Assassin
- Priority: lateral 3+1 architecture
- Target: `QCAOctonionFlavorBridge/Bridge.lean`
- Aristotle project: `52a3a73b-e86e-4d2b-9810-853227487171`
- Submission status: integrated
- Context pack:
  `AgentTasks/context-packs/qca-octonion-flavor-bridge-20260713-20260713-075535.md`

## Objective

Complete every proof hole without changing the definitions, statements,
three-bit order, or octonion convention.  The result should establish the exact
regular `Z2^3` deck action, its equivalence with the project's `Fin 8` XOR
basis, compatibility of octonion multiplication support with deck addition,
and the explicit non-canonicity control.

This is the first gate of a new 3+1 route.  It does not claim that the eight
cover sheets are Standard Model particles.  It asks whether the combinatorial
identification is rigid enough to support that later hypothesis.

## Preferred proof strategy

- Exhaust the finite three-bit functions with kernel reduction, `fin_cases`,
  or small extensionality lemmas.
- For `basisOfFlavor_mul_support`, reduce to the 64 basis pairs and use the
  coordinate simp lemmas in `Octonion.Basic` plus exact arithmetic.
- For regularity, use the unique candidate `flavorAdd b a` and the elementary
  XOR laws.
- For non-canonicity, evaluate the alleged function equality on the sheet with
  first bit true and second bit false.

## Semantic constraints

- Preserve the project basis order: bit weights `1, 2, 4` correspond to labels
  `001, 010, 100`.
- Preserve the project Fano orientation and `lookupSign`; do not silently use a
  Baez or Furey multiplication table.
- Do not infer electric charge, color, chirality, generation number, or a
  physical particle interpretation from the eight-element equivalence.
- The non-canonicity theorem is load-bearing.  Do not remove or weaken it.
- Use no trust-expanding declarations or evaluator shortcuts.

## Verification

Run:

```text
lake env lean QCAOctonionFlavorBridge/Bridge.lean
```

Return the completed target and identify the smallest additional structure
that would make a particle-label identification canonical.

## Submission metadata

```yaml
aristotle:
  project_id: 52a3a73b-e86e-4d2b-9810-853227487171
  task_id: null
  target_file: QCAOctonionFlavorBridge/Bridge.lean
  expected_module: QCAOctonionFlavorBridge.Bridge
  submission_project: AgentTasks/aristotle-submit/afpl-qca-octonion-flavor-bridge-20260713-project
  output_dir: AgentTasks/aristotle-output/52a3a73b-e86e-4d2b-9810-853227487171
  status: integrated
```

## Outcome

Aristotle completed all finite bridge theorems without changing the bit order
or project octonion convention. Interactive Claude Code returned `ACCEPT` after
an independent semantic and trust-footprint review; see
`AutonomousLab/reviews/CLAUDE_REVIEW_QCAOctonionFlavorBridge_2026-07-13.md`.

The production module is
`PhysicsSM/Draft/NullEdge/QCAOctonionFlavorBridge.lean`. Its docstring preserves
the F3 boundary, and in-file guards pin the four load-bearing theorem footprints.
The result is an exact XOR-graded combinatorial/algebraic bridge plus a
noncanonicity witness. It transports no Standard Model charge, color, chirality,
generation, particle identity, or QCA dynamics.
