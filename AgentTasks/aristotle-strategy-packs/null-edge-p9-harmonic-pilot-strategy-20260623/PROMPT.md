# P9 harmonic-projector / numerical-pilot strategy job

Date: 2026-06-23.

This is a no-code Aristotle strategy/audit job. Do not build Lean, do not write
Lean proofs, and do not edit files. Return a concise but serious roadmap.

## Research question

The null-edge program's P9 branch asks whether finite causal-diamond
source-visibility can give real leverage on the cosmological-constant problem.
The current risk is that our finite theorems are only generic cochain algebra:
boundary-exact bookkeeping is invisible to closed tests, mean-zero residuals
can have nonzero variance, and finite noise kernels are positive.

The next gate is to make the branch depend on finite causal-diamond structure:
an explicit metric/codifferential, harmonic projector, noise spectrum, and
response law or numerical pilot.

## Current finite theorem spine

The repo already has draft modules proving:

- boundary-exact bookkeeping is invisible to closed bulk tests;
- boundary-exact perturbations do not change closed-test response/noise;
- visible Pluecker and closure defects give nonzero toy source observables;
- finite sign residuals have zero mean but nonzero second moment;
- finite noise kernels are positive, recoverable by delta/pair tests, and obey
  Cauchy-Schwarz;
- uniform and weighted residual suppression laws exist, but only as finite
  algebra;
- visible closure can be a rest-frame mass condition, not source invisibility.

Important modules include:

- `PhysicsSM.Draft.NullEdgeP9BoundaryExact`
- `PhysicsSM.Draft.NullEdgeP9BFClosure`
- `PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore`
- `PhysicsSM.Draft.NullEdgeP9BoundaryExactPerturbationInvariant`
- `PhysicsSM.Draft.NullEdgeP9BoundaryExactNoiseInvisible`
- `PhysicsSM.Draft.NullEdgeP9NoiseResponseNonneg`
- `PhysicsSM.Draft.NullEdgeP9NoiseCauchySchwarz`
- `PhysicsSM.Draft.NullEdgeP9NoiseKernelEntryRecovery`
- `PhysicsSM.Draft.NullEdgeP9ResponseCharacterization`
- `PhysicsSM.Draft.NullEdgeP9VisiblePluckerSourceAPI`
- `PhysicsSM.Draft.NullEdgeP9ClosureDefect`
- `PhysicsSM.Draft.NullEdgeP9ClosureVisibleSource`
- `PhysicsSM.Draft.NullEdgeP9GravInvisibleAPI`

## Jobs currently running

The following proof jobs are already queued; do not duplicate them:

- closed-test nonzero pairing witnesses bulk visibility and rules out
  boundary-exactness;
- boundary-visible decomposition: adding a boundary-exact perturbation does not
  change closed-test source pairings or invisibility;
- weighted noise bound: bounded observer tests plus max-weight cell suppression
  imply a weighted diagonal noise-response bound;
- harmonic-projector response: harmonic tests see only projected source, and
  boundary sources vanish if the projector annihilates them;
- projected noise-kernel positivity: positive kernels remain positive after
  projection.

## External critique already received

Claude warned that P9 remains vocabulary unless it proves something about:

- explicit harmonic projection from a finite metric/Gram matrix;
- rank-nullity / Betti-number separation;
- positive definiteness or condition-number control of the projected noise
  kernel on the harmonic subspace;
- numerical pilots comparing flat and de Sitter-like finite diamonds;
- a response law connecting source tests to curvature or expansion.

Spark/Newton proposed a one-week Python pilot:

- build small hand-made causal diamonds and a lightweight sprinkled variant;
- construct chain maps `D0`, `D1`, metric blocks `W0`, `W1`, `W2`;
- compute a Hodge-style projector `Pi_H` by eigendecomposition of a finite
  Laplacian;
- compute Betti number by SVD rank;
- build a finite noise kernel from source ensembles and project it to
  `K_H = Pi_H K Pi_H`;
- report eigenvalues, trace, smallest positive eigenvalue, and condition
  number;
- verify boundary-exact perturbation invariance numerically;
- test Pluecker/closure-defect witnesses.

## What I want from Aristotle

Please return:

1. The smallest coherent finite `DiamondSourceVisibility` / harmonic-projector
   API that would stop P9 from being merely generic cochain vocabulary.
2. Five to eight theorem targets, ranked by scientific leverage and ease of
   formalization. For each, state the needed definitions, the likely proof
   method, and whether it is already covered by the running jobs.
3. A numerical-pilot specification precise enough for a Python script, including
   the finite matrices, tolerances, output metrics, and pass/fail criteria.
4. The strongest demotion criteria: what results would show that P9 has no real
   cosmological-constant leverage.
5. Literature guardrails that must be checked before any P9 publication claim.

Be blunt. Mark any item that is only vocabulary. Prefer finite algebra and
computable pilots over grand physical claims.
