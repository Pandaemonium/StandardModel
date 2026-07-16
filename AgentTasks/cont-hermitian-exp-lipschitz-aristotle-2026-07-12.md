# Aristotle task: sharp Hermitian exponential Lipschitz bound

## Scientific role

This target supplies the missing analytic core between the integrated
cell-center live-walk convergence theorem and continuum momentum-space Dirac
evolution. The active momentum window grows, so a generic exponential bound in
the generator norms is not sufficient; the requested estimate uses unitarity
to obtain the sharp factor `|t|`.

## Exact target

Prove `HermitianExpLipschitz.hermitian_exp_lipschitz` without changing its
statement or adding assumptions. Small local helper lemmas are allowed.

## Preflight

- Standalone source:
  `AgentTasks/aristotle-standalone/hermitian-exp-lipschitz-20260712/HermitianExpLipschitz.lean`
- Semantic context:
  `AgentTasks/context-packs/hermitian-exp-lipschitz-20260712-172228.md`
- Local typecheck: passed under the pinned Lean 4.28.0 toolchain with only the
  intended proof-hole warning.

## Scope boundary

This target is finite-dimensional operator analysis. It does not itself prove
the changing-cell integral limit, inverse Fourier reconstruction,
position-space PDE convergence, or Lorentz restoration.
