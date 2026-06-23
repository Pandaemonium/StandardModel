# P9 intrinsic coarse-map strategy/audit job

Date: 2026-06-23.

This is a no-code Aristotle strategy/audit job. Do not build Lean, do not write
Lean proofs, and do not edit files. Return a concise but serious roadmap.

## Context

The null-edge program's P9 branch asks whether finite causal-diamond
source-visibility can give real leverage on the cosmological-constant problem.
The current finite spine has useful algebra:

- boundary-exact bookkeeping is invisible to closed tests;
- weighted finite Hodge adjoints and Laplacian energy identities are proved;
- harmonic kernel equals closed plus coclosed in a finite weighted toy model;
- coarse positive kernels stay positive under a fixed coarse map;
- a terminating retarded Green series solves `(I - K) y = x` under nilpotence;
- selected-sector trace density is `k / n`, so boundary-sized sectors have
  boundary-over-volume density;
- a block-aliasing guardrail shows a fixed size-4 block average can annihilate
  a nonzero mode purely by alignment.

Numerical pilots currently show that the block-size-4 coarse statistic is
offset-sensitive: one offset gives an impressive flat/deformed separation,
while other offsets destroy it. That should be treated as an artifact warning,
not positive evidence.

Important corrected gate: a fundamentally discrete model does not need
fine-grained continuum behavior. The gate is whether a stable coarse-grained,
renormalized, or observer-channel readout survives without hand-tuned weights,
boundary artifacts, or geometry-blind statistics.

## What I want from Aristotle

Please design the next serious P9 coarse-map strategy.

Return:

1. Three candidate intrinsic or observer-forced coarse maps for finite causal
   diamonds. Examples might include interval/alexandrov blocks, spectral
   coarse modes, Hodge-harmonic projectors, graph-reduction maps with
   spectral/cut guarantees, or Sorkin-Johnston windowed screen algebras.
2. For each candidate, name the finite data required, the statistic to track,
   and the exact artifact it avoids.
3. Pick the most publishable first candidate and give a minimal theorem ladder
   in Lean-friendly finite algebra. Include definitions, hypotheses, and
   expected theorem names.
4. Give a numerical pilot design with pass/fail thresholds. It may allow
   microscopic ill-conditioning if the named large-scale statistic is stable.
5. Explain how to connect the statistic to a source/curvature/noise response
   law, or say bluntly if that connection is still missing.
6. List literature guardrails and search phrases. Prefer causal-set
   coarse-graining, finite Hodge/DEC/FEEC stability, graph reduction with
   spectral guarantees, Sorkin-Johnston entropy/windowing, and stochastic
   gravity noise kernels.

Be adversarial. The goal is not to protect P9; it is to find the strongest
version of P9 that would be publishable if true and focusing if false.
