# Aristotle task: invariant weak and color contractions

Date: 2026-07-20
Owner: Codex
Work item: `MASS-ORIGIN-001`

## Scientific target

Prove the actual invariant-tensor classifications in
`InvariantContractions/Core.lean`:

1. an `SU(2)`-invariant complex bilinear form on the fundamental doublet is a
   unique scalar multiple of the alternating tensor;
2. an endomorphism commuting with the fundamental `SU(3)` action is a unique
   scalar multiple of the identity.

These are the missing representation-level complements to the trusted finite
legality classifier in `PhysicsSM/StandardModel/YukawaGauge.lean`.  Together
they would justify the precise statement that gauge symmetry selects the
contraction shape within a legal one-generation channel but leaves an
independent scalar Yukawa coefficient, and in several generations a flavor
matrix, undetermined.

## Requirements

- Keep the universal quantification over the full concrete `SU(2)` and `SU(3)`
  predicates.  Do not replace it with invariance under a supplied finite list
  unless you also prove that list suffices for the original statement.
- Preserve uniqueness, not just existence.
- Include the nonzero controls.
- Small helper lemmas and explicit test matrices are welcome.
- Do not add assumptions, compiler-trust proofs, or placeholder declarations.
- Run `lake env lean InvariantContractions/Core.lean` first.
- If the `SU(3)` result is too large, finish the full `SU(2)` result and return
  the exact remaining `SU(3)` proof state rather than weakening it.

aristotle:
  project_id: 7c70f6e1-5a0f-4d8d-a549-86b3ef4f8a9f
  target_file: InvariantContractions/Core.lean
  expected_module: InvariantContractions.Core
  submission_project: AgentTasks/aristotle-submit/invariant-contractions-20260720-project
  output_dir: AgentTasks/aristotle-output/7c70f6e1-5a0f-4d8d-a549-86b3ef4f8a9f
  status: submitted
