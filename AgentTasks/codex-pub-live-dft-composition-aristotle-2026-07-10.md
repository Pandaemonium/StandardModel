# Aristotle proof task: live DFT composition after orthogonality

Prove every theorem in `LiveDFTComposition/Main.lean` without changing any
statement.  The exact product-character core is already complete and immutable;
use its row/column orthogonality and normalization instead of reproving them.

Priority order:

1. both transform round trips;
2. exact Parseval;
3. complete finite mode expansion;
4. operator-level `fourier_localStep` for the actual local walk;
5. both nonzero controls.

Run `lake env lean LiveDFTComposition/Main.lean` first.  Preserve the positive
plane-wave convention, normalization, arbitrary finite fields, and exact live
operator.  Do not replace operator conjugacy by the existing single-mode
invariance theorem.  No compiler-trusting evaluation or added assumptions.
Return the largest proof-complete prefix if a later composition target blocks.

Success closes finite-torus DFT conjugacy only.  It does not establish physical
momentum scaling, a changing-lattice PDE limit, or continuum Lorentz invariance.

```yaml
aristotle:
  project_id: 6ac7ec5e-743b-4c1e-b536-bd6cf61a1355
  target_file: LiveDFTComposition/Main.lean
  expected_module: LiveDFTComposition.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-live-dft-composition-20260710-project
  output_dir: AgentTasks/aristotle-output/6ac7ec5e-743b-4c1e-b536-bd6cf61a1355
  status: two-hour-snapshot-harvested/capstone-integrated-locally
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Codex prefix disposition

The active snapshot contained three proof-complete unchanged statements:
`inverseFourier_fourier`, `fourier_inverseFourier`, and `fourier_modeState`.
Codex extracted the snapshot without relying on the failed long-path helper,
reviewed the exact source, and integrated the prefix as
`PhysicsSM/Draft/NullEdge/LiveDFTComposition.lean` with axiom guards.

At the two-hour stall boundary, a second snapshot supplied proof-complete
Parseval, finite-sum linearity, local-step linearity, and complete mode
expansion. Codex integrated and compiled them, then proved live local-step
Fourier conjugacy by composing mode reconstruction, the existing single-mode
action, and exact normalization. The constant/delta controls remain optional;
physical scaling, interpolation, and continuum PDE convergence remain open.
