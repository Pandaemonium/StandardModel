# Aristotle prompt: P9 DiamondSourceVisibility geometric API (design)

This is a roadmap/scaffold job, not a proof-completion job. Do not build the
whole repo. The deliverable is a minimal Lean module API proposal: definitions,
theorem statements, proof sketches, dependencies, and likely blockers. You may
include Lean-like skeletons, but label every unfinished point as a handoff and do
not claim kernel proof.

## Context

The P9 cosmological-constant / source-visibility branch has a finite theorem
spine (boundary-exact invisibility, chain-complex no-bulk-source, mean-zero
cancellation, closed-visible-fan rest energy, equal/weighted/uniform fluctuation
scaling). Both audits conclude the bottleneck is now a *geometric* definition
layer. The current `PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore` uses
abstract cochains, an abstract `unitTest`, and abstract amplitudes `amp_i`.

## Assignment

Propose ONE coherent `DiamondSourceVisibility` API that replaces the duplicated
toy definitions and makes the amplitudes and tests geometric:

1. a finite diamond / screen with incidence data (faces, cells, boundary);
2. geometric cell weights identifying `amp_i` with an area / volume / chosen
   diamond measure, rather than an abstract real;
3. a curvature or holonomy-defect cochain replacing `unitTest`, so a "visible"
   source is one that pairs nontrivially with a curvature defect;
4. an observer / coarse-graining projection so that invisibility means lying in
   the kernel of the observer map, not merely ignored data;
5. the bridge maps showing the existing finite theorems (boundary-exact
   invisibility, closed-fan rest energy, variance scaling) are special cases of
   the new geometric API.

Then state, as handoff theorem signatures (not proofs), the next 5-8 theorems the
API should make provable, ranked by physics value, including at least:
`boundaryExact_iff_invisible_to_curvatureDefects`,
`diamondResidualVariance_scales_with_cellArea`, and
`recoverabilityGap_controls_sourceVisibility`.

Please end with this exact summary shape:

```text
overall assessment:
proposed core definitions:
bridge lemmas to existing theorems:
ranked next theorem signatures:
likely blockers:
integration notes:
```
