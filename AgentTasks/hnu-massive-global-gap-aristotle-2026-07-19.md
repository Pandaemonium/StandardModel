# Aristotle construction-or-counterexample: massive HNU global zero/pi gap

## Objective

Close the decisive global spectral gate for the exact massive HNU walk. The
finite update, exact unitarity, rest identity, and combined Dirac tangent are
already proved. The remaining question is whether a nontrivial real Pluecker
mass angle removes every `+1` and `-1` quasienergy crossing on the complete
closed Brillouin cube.

## Target

Fill the proof holes in
`PhysicsSM/Draft/NullEdge/HNUMassiveGlobalGap.lean` without weakening the
headline determinant statement. The expected hard core is
`endpoint_eq_momentumReverse_iff`.

A useful clean-room route is:

1. Work in the doubled chiral basis before the fixed Hadamard rotation.
2. Reduce `det(massiveHNU - lambda)` for `lambda = +/-1` to a `2x2` SU(2)
   expression involving `endpoint k` and `endpoint (-k)`.
3. Use equal traces of the momentum-reversed endpoints and the SU(2)
   coefficient constraints to prove equality can occur only when the two
   endpoints coincide.
4. Prove the parity coincidence census directly from the exact HNU factors or
   trigonometric entries.
5. Use the existing origin and pi-boundary censuses to exclude both crossings
   when `0 < a < pi`.

If the theorem is false, do not weaken it. Return an exact momentum and mass
angle counterexample, preferably algebraic or a formally checkable trigonometric
fixture, and state the sharp corrected theorem.

## Scientific boundaries

- A global zero/pi gap is a spectral theorem, not anomaly cancellation.
- The local mass coin is onsite internal evolution.
- Do not replace the full cube by an infrared neighborhood.
- Do not infer continuum convergence from the gap.
- Use no new assumptions or compiler-trusted decision procedures.

Verify only the target module with `lake env lean` and report its assumption
footprint.

## Aristotle metadata

```yaml
aristotle:
  project_id: 081bd1d6-d82e-4a13-b215-c319775a5aac
  target_file: PhysicsSM/Draft/NullEdge/HNUMassiveGlobalGap.lean
  expected_module: PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap
  submission_project: AgentTasks/aristotle-submit/codex-hnu-massive-global-gap-20260719-project
  output_dir: AgentTasks/aristotle-output/081bd1d6-d82e-4a13-b215-c319775a5aac
  status: submitted
  owner: Codex
```

Submitted on 2026-07-19.
