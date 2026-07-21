# Aristotle task: classify covariant flavor-cover selectors

## Goal

Complete every proof in
`FlavorCoverCharacterSelector/Basic.lean` without changing or weakening any
statement. This is a focused finite theorem package over Mathlib.

The mathematical target is the regular additive action of `(ZMod 2)^3` on its
eight flavor sheets. Prove that its Fourier-character states form the exact
orthogonal decomposition, that their normalized rank-one projectors commute
with every deck translation, that every common eigenspace with the displayed
sign character is one-dimensional, and that a static bare-sheet projector does
not commute with any generator.

## Scientific use

Bakircioglu, Arnault, and Arrighi, arXiv:2505.07900v3, reinterpret the eight
`3+1` QCA solutions as a `Z2^3` flavor cover. Their local translations flip
flavor bits. The project has already proved that a bare single-sheet projector
is incompatible with those translations. This job should classify the positive
translation-compatible alternative: character sectors.

Success does not prove that one character sector is dynamically selected in
nature. It proves only the exact finite representation-theoretic selector
space. Interaction invariance and physical nonpopulation remain separate
gates.

## Semantic gates

- Preserve the explicit orthogonality value `8`.
- Preserve exact equality in the completeness theorem.
- Preserve the one-dimensional common-eigenspace conclusion.
- Preserve the explicit bare-sheet noncommutation theorem for every `f,j`.
- Do not introduce new assumptions or use external evaluators.
- If any statement is false, return an exact counterexample instead of
  weakening it.

## Context

- `AgentTasks/context-packs/flavor-cover-character-selector-20260720-20260720-091106.md`
- `PhysicsSM/Draft/NullEdge/CliffordCoverDecoder.lean`
- `PhysicsSM/Draft/NullEdge/FlavorCoverSingleSheetNoGo.lean`
- `PhysicsSM/Draft/NullEdge/FlavorCoverChargeObstruction.lean`

## Expected verification

```text
lake env lean FlavorCoverCharacterSelector/Basic.lean
```

Finish with a compact report naming solved declarations, any statement changes
(expected: none), assumptions used, and any remaining holes.

## Aristotle metadata

```yaml
aristotle:
  project_id: 0db23b28-bd0f-4d08-8c0c-b0256466bc6d
  target_file: FlavorCoverCharacterSelector/Basic.lean
  expected_module: FlavorCoverCharacterSelector.Basic
  submission_project: AgentTasks/aristotle-submit/flavor-cover-character-selector-20260720-project
  output_dir: AgentTasks/aristotle-output/0db23b28-bd0f-4d08-8c0c-b0256466bc6d
  status: submitted
```
