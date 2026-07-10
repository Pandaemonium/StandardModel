# Aristotle task: exact finite Fourier symbol conjugacy

## Scientific target

Close the exact algebraic gap between the finite periodic three-axis local
walk and its ordered matrix symbol.  Prove that every product plane-wave
sector is invariant, that each conjugated conditional shift induces the
declared internal phase block, and that the complete local step induces the
ordered `axis0 * axis1 * axis2 * mass` symbol.  Include the unit-modulus and
nonzero-mode controls unchanged.

This is the missing precursor to composing the compact-momentum walk estimate
with vector-valued Plancherel.  It is finite Fourier conjugacy only: no
infinite-volume or PDE limit is claimed.

## Submission instructions

- Run `lake env lean FiniteFourierSymbolConjugacy/PlaneWaveBridge.lean` first.
- Preserve all ten target statements exactly.
- Helper lemmas are welcome.
- Use only Mathlib and the definitions in the target file.
- Return a precise blocker if a target is malformed; do not weaken it.

## Metadata

```yaml
aristotle:
  project_id: 1d093252-36d7-4326-af4c-f48ffb2ec72a
  task_id: b7337875-8e59-4497-b8fd-770504af7fc0
  target_file: AgentTasks/aristotle-standalone/finite-fourier-symbol-conjugacy-20260710/FiniteFourierSymbolConjugacy/PlaneWaveBridge.lean
  expected_module: FiniteFourierSymbolConjugacy.PlaneWaveBridge
  submission_project: AgentTasks/aristotle-submit/codex-finite-fourier-symbol-conjugacy-20260710-project
  output_dir: AgentTasks/aristotle-output/1d093252-36d7-4326-af4c-f48ffb2ec72a
  status: integrated
```

## Integration

Aristotle returned all ten target proofs with unchanged statements, no proof
placeholders, and the standard assumption footprint.  The returned file passed
the repository toolchain.  Its proof architecture was specialized to the live
position-walk definitions in
`PhysicsSM/Draft/NullEdge/Finite3Plus1FourierBridge.lean`, where
`localStep_mode` proves the actual local operator preserves every product
plane-wave sector and acts by the exact ordered finite-character block.

The positive-exponential convention exposes a momentum-sign conversion before
this block is identified with the analytic `k * eps` symbol.  That conversion
is deliberately left explicit as the next small formal target.
