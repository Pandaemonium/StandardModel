# HNU Cayley spectral pairing Aristotle task

## Objective

Close the rank-two physical-band gate for the live massive 3+1 HNU walk. The
inverse-Cayley generator is already kernel-proved Hermitian, invertible, and
continuous on the closed Brillouin cube, and its certified sign is uniquely
`beta` at rest. Exact numerical probes show ordered eigenvalues in opposite
pairs at generic momenta.

## Targets

1. Prove exact opposite pairing of ordered Hermitian eigenvalues.
2. Use invertibility and ordering to prove exactly two are positive and two
   negative.
3. Prove the negative certified-sign projector has matrix rank two.

Do not weaken statements or add assumptions. Preserve the live HNU, Cayley,
Brillouin-zone, and matrix-sign conventions. If target 3 blocks, return targets
1 and 2 complete and identify the exact missing spectral/sign-certificate
lemma.

## Semantic checks

- This is finite Bloch-band rank, not companion removal or physical occupation.
- Pointwise inverse Cayley remains potentially nonlocal in position space.
- Ordered eigenvalues are Mathlib's decreasing Hermitian eigenvalues.
- The global `+1` Floquet gap supplies invertibility of the Cayley generator.

## Verification

Semantic context pack:
`AgentTasks/context-packs/hnu-cayley-spectral-pairing-20260721-20260721-152617.md`.

Run the narrow command first:

```text
lake env lean AgentTasks/aristotle-full/hnu-cayley-spectral-pairing-20260721/Main.lean
```

Return solved targets, statement changes (expected none), remaining proof
handoffs, declarations used, and the axiom footprint.

## Aristotle metadata

```yaml
aristotle:
  project_id: d2f492c2-6a8c-4dff-b3da-11a35d5dccae
  task_id: 04d4565d-e5e4-4a92-8119-3c225c8e3ce7
  target_file: AgentTasks/aristotle-full/hnu-cayley-spectral-pairing-20260721/Main.lean
  expected_module: Main
  submission_project: AgentTasks/aristotle-submit/hnu-cayley-spectral-pairing-20260721-project
  output_dir: AgentTasks/aristotle-output/d2f492c2-6a8c-4dff-b3da-11a35d5dccae
  status: submitted
```
