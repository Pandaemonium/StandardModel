# P9 defect sensitivity and coarse-stability strategy/audit job

Date: 2026-06-23.

This is a no-code Aristotle strategy/audit job. Do not build Lean, do not write
Lean proofs, and do not edit files. Return a concise but serious roadmap.

## Context

The null-edge program's P9 branch asks whether finite causal-diamond
source-visibility can give real leverage on the cosmological-constant problem.
The corrected gate is discrete-first: lack of pointwise microscopic continuum
behavior is not fatal. The real gate is whether a pre-specified coarse-grained,
renormalized, or observer-channel readout is stable without hand-tuned weights,
boundary artifacts, or geometry-blind statistics.

Recent formal spine:

- boundary-exact sources vanish against closed/bulk tests;
- weighted finite Hodge: `codiff` is the weighted adjoint, weighted
  1-Laplacian energy is a sum of down/up squares, and harmonic equals closed
  and coclosed;
- newly integrated: the explicit weighted 1-Laplacian is self-adjoint for the
  weighted degree-1 pairing;
- newly integrated: a weighted self-adjoint idempotent projector makes
  projected observer tests see only the projected source, and the residual is
  weighted-orthogonal to all projected tests;
- running: a weighted Pythagorean projected/residual norm split;
- newly integrated: interval abundance and out-degree histograms are invariant
  under finite relabeling, motivated by causal-set graph-observable literature
  such as Eichhorn-Mack-Le-Wagner `RC5XF8RD`;
- negative guardrails: fixed block averages can alias high-frequency modes, and
  offset sweeps destroy a naive block-size-4 flat/deformed signal.

Gemini's current critique is that the P9 theorem stack is formally clean but
risks remaining generic finite linear algebra unless it couples to causal-order
geometry. The suggested next publishability gates are:

1. defect/curvature sensitivity;
2. covariant coarse-graining stability;
3. Sorkin-style fluctuation scaling from intrinsic graph/spectral data.

## Request

Please design the next theorem and numerical target ladder for P9.

Return:

1. A Lean-friendly finite definition package for a defect/curvature sensitivity
   benchmark. It should specify what changes in the finite causal relation,
   Hodge metric, Laplacian, source cochain, or response kernel, and what
   readout should change.
2. A Lean-friendly finite theorem ladder for coarse-graining stability. Prefer
   pre-specified maps such as Alexandrov/interval blocks, spectral projectors,
   or graph-reduction maps with spectral/cut guarantees. Avoid hand-tuned
   projectors.
3. A numerical pilot design for Sorkin-style fluctuation scaling. Specify what
   should scale like volume, boundary area, `sqrt(N)`, or `1/sqrt(N)`, and what
   would count as a failure.
4. The strongest near-term theorem target that would make P9 more than generic
   finite Hodge linear algebra.
5. Failure modes and demotion criteria, especially observer tuning,
   boundary-artifact dominance, and graph-theoretic degeneracy/isohistogram
   blindness.

Frame the output as a kinematic filtering mechanism for bulk noise, not as a
solution of the cosmological-constant problem. Be adversarial and concrete.
