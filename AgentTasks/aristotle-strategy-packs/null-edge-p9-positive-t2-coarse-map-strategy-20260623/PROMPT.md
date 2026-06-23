# P9 positive T2 coarse-map strategy request

We are developing the P9/source-visibility branch of the null-edge causal graph
program. Please do not try to compile Lean for this job. We want a strategy and
theorem-scaffold report.

## Current finite results

The relevant draft modules are:

- `PhysicsSM.Draft.NullEdgeP9IsohistogramSeparation`
  - Cheap sanity witness: separate in-degree, out-degree, and interval-abundance
    histograms do not determine a frozen joint readout.
- `PhysicsSM.Draft.NullEdgeP9DiamondLocalSeparation`
  - Stronger T1 witness: two strict six-point relations match joint
    in/out-degree and global interval-abundance signatures, and the chosen
    diamond has the same cardinality, but a local interval-size signature inside
    that diamond differs.
- `PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail`
  - Negative T2 guardrail: a natural critical-collapse coarse map identifies the
    swapped vertices and erases the T1 separator.
- Active proof job:
  - `NullEdgeP9DiamondLocalityNoiseInvariance` asks for the generic T3 lemma
    that local interval signatures are unchanged when closed-diamond membership
    and relation data internal to that diamond are unchanged.

The corrected research gate is discrete-first: failure to have fine-grained
continuum interpretation is not by itself a failure. The failure mode is lack
of a stable, pre-specified coarse-grained or observer-channel readout.

## What we want from Aristotle

Please design the next positive T2 theorem target. The target should answer:

> Which pre-specified coarse maps preserve the diamond-local T1 readout in a
> non-hand-tuned way, given that the critical-collapse map erases it?

Return:

1. Three candidate admissible coarse-map classes, ranked by scientific value.
2. For each class, a precise finite Lean-style theorem statement or theorem
   cluster.
3. Which assumptions would make the theorem tautological or physically
   uninteresting.
4. How each class relates to causal-set coarse graining, Alexandrov subdiamond
   restriction, or Laplacian/spectral coarse graining.
5. The single best focused Aristotle proof job to submit next, with target
   theorem names and a suggested small finite or generic setup.

## Guardrails

- Do not recommend a preserving map that is chosen after seeing the T1 witness.
- Prefer intrinsic or observer-forced maps: endpoint-preserving subdiamond
  restriction, interval-rank thresholding, spectral/Laplacian projection, or
  quotient maps defined by a named invariant.
- A good theorem can be a no-go or dichotomy theorem if that is the honest
  next step.
- Keep P9 claim boundaries sharp: this is source-visibility scaffolding, not a
  cosmological-constant solution.
