# Aristotle task: qubit fixed-energy maximum entropy

## Objective

Close the non-hollow two-level variational core of `DYN-MODULAR-001`: among
all Bloch-ball density matrices with a fixed expectation of the supplied pair
generator, the zero-transverse-coherence state uniquely maximizes entropy.

This is not a commuting-family theorem. The competitors range over all three
Bloch coordinates. It is still a finite supplied-generator result and does not
derive the Pluecker coupling, inverse temperature, or thermalization law.

## Exact target

`AgentTasks/aristotle-standalone/qubit-fixed-energy-maxentropy-20260712/QubitFixedEnergyMaxEntropy.lean`

Run first:

```text
lake env lean QubitFixedEnergyMaxEntropy.lean
```

Prove every existing theorem without changing statements or adding assumptions.
Small named helper lemmas are welcome. In particular, use Mathlib's
`Real.binEntropy_strictAntiOn` on `[1/2, 1]`; do not replace strict uniqueness
with a one-way bound.

## Semantic gates

- `pairBloch_sigmaX_expectation` makes the energy constraint operational.
- `pairEntropy_eq_fixedEnergy_iff` is the decisive uniqueness theorem.
- `transverse_strict_control` prevents a commuting-only or equality-vacuous
  reading.
- The later live-tree integration must separately prove that `pairEntropy`
  equals the spectral von Neumann entropy and identify the optimizer with the
  normalized Gibbs state. Do not claim those bridges in this package.

## Reference audit

- Mathlib: `Real.binEntropy_strictAntiOn` is the main proof API.
- PhysLean: `CanonicalEnsemble.twoState_entropy_eq` was consulted through
  `lean-explore packages=["Physlib"]`; it is an informal declaration in the
  indexed version, so this package does not import or copy it.
- The required Neo4j semantic context-pack preflight was attempted, but the
  local service refused the connection on `127.0.0.1:7687`. The theorem target
  is self-contained; this degraded provenance path and the direct
  Mathlib/PhysLean declaration searches are recorded here instead.

## Status

Local strengthened statement typecheck passed with exactly ten intended proof
holes. After submission, Codex used `continue --mode instruct` to add the exact
`pairBloch_surjective`, `pairBloch_posSemidef`, and
`pairBloch_posSemidef_iff` bridges to Aristotle's copy; these prevent a hidden
nonexhaustive-family, non-density-matrix, or one-way-ball reading.
Focused submission package:
`AgentTasks/aristotle-submit/qubit-fixed-energy-maxentropy-20260712-project`.
Project metadata will be appended after submission.

```yaml
aristotle:
  project_id: 4ef06d09-a371-46bb-a6b5-ffdcf05aba75
  task_id: d7dda3e2-7bd5-4ac5-991e-849b1452113d
  target_file: QubitFixedEnergyMaxEntropy.lean
  expected_module: QubitFixedEnergyMaxEntropy
  submission_project: AgentTasks/aristotle-submit/qubit-fixed-energy-maxentropy-20260712-project
  output_dir: AgentTasks/aristotle-output/4ef06d09-a371-46bb-a6b5-ffdcf05aba75
  status: submitted
```
