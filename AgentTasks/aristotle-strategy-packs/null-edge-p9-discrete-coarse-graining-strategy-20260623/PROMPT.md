# P9 discrete coarse-graining / renormalized observable strategy job

Date: 2026-06-23.

This is a no-code Aristotle strategy/audit job. Do not build Lean, do not write
Lean proofs, and do not edit files. Return a concise but serious roadmap.

## Research question

The null-edge program's P9 branch asks whether finite causal-diamond
source-visibility can give real leverage on the cosmological-constant problem.
Recent strategy feedback gave a useful gate: P9 must distinguish flat from
de Sitter-like finite diamonds using a metric-dependent harmonic/projected
source observable, rather than only proving generic Hodge algebra.

But one gate needs correction. A fundamentally discrete model does not need
fine-grained continuum-like behavior at every scale. Fine-scale ill-conditioning
is not automatically fatal if a stable large-scale statistic survives after a
specified coarse-graining or renormalization step.

The corrected gate is:

```text
P9 is promising if a geometry-dependent harmonic/source statistic survives
boundary-exact perturbations and has a stable coarse-grained or renormalized
large-scale readout.

P9 should be demoted if every candidate statistic is geometry-blind,
boundary-artifactual, hand-tuned through arbitrary metric weights, unstable
after the stated coarse-graining, or unconnected to a source/curvature response
law.
```

## Current finite theorem spine

The repo has draft modules proving:

- boundary-exact bookkeeping is invisible to closed bulk tests;
- closed tests see residual/visible components and ignore boundary-exact
  perturbations;
- visible Pluecker and closure defects give nonzero toy source observables;
- finite sign residuals can have zero mean but nonzero second moment;
- finite noise kernels are positive, recoverable by delta/pair tests, and obey
  Cauchy-Schwarz;
- uniform and weighted residual suppression laws exist;
- abstract projectors make harmonic/projected tests see only projected sources;
- strict projected kernels and conditioned response bounds rule out hidden
  projected zero modes under explicit finite hypotheses.

Current or pending P9 proof jobs focus on:

- weighted adjoint/codifferential for diagonal finite metrics;
- weighted 1-Laplacian energy splitting;
- harmonic kernel equals closed plus coclosed.

## What I want from Aristotle

Please give a discrete-first strategy for the next P9 step.

Return:

1. Three to five candidate coarse-grained or renormalized P9 observables. For
   each, say what finite data it uses, what gets coarse-grained, what statistic
   survives, and why it is not just generic Hodge vocabulary.
2. Which candidate is most publishable first, and why.
3. The smallest finite theorem package that would support that candidate.
   Prefer Lean-friendly finite algebra statements, but do not write code.
4. A numerical-pilot design for the candidate, including what counts as a
   positive signal and what counts as demotion. The pilot may allow microscopic
   ill-conditioning if the large-scale statistic is stable.
5. A corrected falsification ledger: which failures really kill P9, and which
   only tell us the continuum interpretation should be emergent/coarse-grained
   rather than fine-grained.
6. Literature guardrails and search keywords. Emphasize discrete exterior
   calculus, finite Hodge theory, coarse-graining/renormalization of graph or
   cellular Laplacians, causal-set coarse-graining, and stochastic-gravity noise
   kernels.

Be blunt. The purpose is not to protect P9; it is to find the strongest version
that remains falsifiable and potentially publishable.
