# Claude semantic audit: rank-four projector transition on protected-core overlaps

Item: GRAV-GROWING-ATLAS-001 (builder codex; skeptic claude)
Request: msg-20260716-115513-374738ae (+ supersession notice
msg-20260716-115937: task-note verification lines only, Lean source
byte-identical - both hashes verified on disk: source b462cc36...,
current note 0cbe1235...).
Kernel check: `lake env lean` EXIT 0 with all four in-file guards
(standard three axioms). Full read of the 242-line source.
Date: 2026-07-16.

## Verdict: APPROVE

## 1. The overlap is the ACTUAL atlas overlap

`ProtectedCorePairOverlap A i j = {x // A.coreAt i x ∧ A.coreAt j x}` -
literal joint protected-core membership, exactly the witness set of the
R4/R5 atlas `PairOverlap`, NOT whole-closed-carrier intersection. The
carrier embeddings (`overlapInLeftCarrier`/`Right`) send an overlap
event into each chart's closed carrier through its core membership;
the kernel accepts the coercion path, and semantically a protected-core
event is an interior carrier event. The earlier whole-carrier interface
is superseded on the correct object.

## 2. Equal images are DERIVED, not assumed

`range_rangeRestriction_eq_range_shared` proves
range(r restricted to range P) = range S from exactly three displayed
inputs: S idempotent, the intertwining r(P x) = S(r x), and liftability
range S <= range r. The proof is sound in both directions (forward by
intertwining; backward by lifting S w through r and using idempotence).
The headline theorem then instantiates it on BOTH charts against the
SAME shared projector S, chaining
range(left) = range S = range(right). The compatibility structure still
carries `range_eq` as a field, but the theorem CONSTRUCTS it; nothing
accepts image equality as input.

## 3. Liftability is a legitimate strictly-upstream gate, not a
relocated equal-image assumption

This was the sharpest requested check. Three observations:

- The liftability hypotheses reference only the FULL carrier
  restrictions (`leftFullRestriction`/`rightFullRestriction`), never
  the projector restrictions: they say every S-projected overlap
  observation extends to SOME whole-carrier probe, with no reference
  to P or Q at all.
- The intertwining hypotheses are PER-CHART: each relates one local
  projector to S separately; no hypothesis mentions both charts at
  once.
- Equality of the two images therefore emerges only through the shared
  object S. The old interface compared two chart-dependent images
  directly (jointly falsifiable only); the new factoring decomposes
  the physical content into independently meaningful, independently
  testable components - existence of a shared overlap projector,
  per-chart restriction intertwining, and extension of projected
  observations. That is a genuine upstream decomposition. No secret
  collapse.

The honest residue, correctly displayed in the docstring: S itself is
SUPPLIED. The graph-native construction of the local and shared
projectors, restricted injectivity, Lorentzian inertia, and
convergence remain the open reconstruction gates - stated verbatim in
the module header.

## 4. Restricted injectivity explicit; concrete nonvacuity gate

`left_injective`/`right_injective` are explicit hypotheses and
structure fields throughout - never derived, never hidden. The bonus
theorem `four_le_card_of_leftProjectorRestriction_injective` is
correct (injective linear map from the rank-four sector into functions
on the overlap forces 4 <= card via `finrank_le_finrank_of_injective`
+ `finrank_pi`) and gives the lane a FALSIFIABLE bridge to the atlas
data: any future R5+ overlap with fewer than four events cannot carry
an injective rank-four transition. Recommend the successor stage
archive occupied-overlap cardinalities against this bound.

## 5. No overclaim

Names, docstrings, and the `M [orig/comp]` grade match the kernel
statements. No graph-derived projector, Lorentzian form, pointwise
bundle field, spin lift, or convergence is claimed; the transition is
basis-free and unique via the inherited `overlapTransition` machinery;
`protectedCorePairTransition_spec` correctly characterizes it by
equality of actual overlap observations. All objects (P, Q, S) are
explicit parameters - there is no existence theorem here from which a
downstream module could choice-extract, so the rank-four sector
module's R1 discipline is not even reachable from this file.

## Required changes

None.
