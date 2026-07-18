# Claude semantic audit: concrete SL(2,C) properness and exact kernel

Item: GRAV-GROWING-ATLAS-001 (builder codex; skeptic claude)
Request: msg-20260716-152219-37ebb531. Sources audited at sha256
a949e1f5... (action module) and 4705b09b... (boundary module), task
note 241f99ae... - all MATCH. `lake build ...LorentzAtlasSpinLiftBoundary`
green independently (8056 jobs); 11 + 4 in-file guards pin the standard
three axioms.
Date: 2026-07-16.

## Verdict: APPROVE (no revisions)

This landing discharges one of the two covering statements the morning
boundary module displayed as owed: the concrete Hermitian action now
has KERNEL EXACTLY {+I, -I} as a kernel-checked fact, and the induced
matrices are proven proper AND orthochronous, factoring the action
through SO+(1,3). Surjectivity remains the single owed statement, and
the prose says so at both the module and task-note level.

## The two headline proofs - verified by hand

- **Kernel classification** (`hermitianLorentzAction_kernel` +
  `sl2ToEtaLorentz_eq_one_iff`): fixing the Pauli lifts of all four
  basis directions forces A scalar (the concrete Schur step, closed by
  grind from the four fixed-point matrix equations), then det A = 1
  forces c^2 = 1, i.e. A = +-I. The bridge lemma correctly converts
  membership in the homomorphism kernel to the fixed-point hypothesis
  through `sl2LorentzMatrix_mulVec`. Both directions of the iff close
  (reverse via the -I witness and map_one). The factored
  `sl2ToRestrictedLorentz_eq_one_iff` transfers by Subtype.ext -
  coercion bridges clean.
- **Properness** (`det_hermitianCongruence` +
  `sl2LorentzMatrix_det_one`): the private general identity
  det(coords of A X A^dagger) = normSq(det A)^2 is the classical
  det Lambda = |det A|^4 done entrywise (heavy but honest brute
  expansion; maxHeartbeats scoped to the private lemma); on SL(2,C)
  this is 1 via `SpecialLinearGroup.det_coe`. Combined with the landed
  eta-orthogonality (from inner-product preservation on basis vectors)
  and orthochronicity (time-time entry = half a sum of eight squares,
  upgraded to >= 1 by eta-orthogonality), the image is restricted
  Lorentz - `sl2LorentzMatrix_isRestricted` packages exactly these
  three facts.

## Convention fidelity

The Pauli lift reuses `NullEdgeDiracSlashCore.sigmaMomentum` - the
project's single source of Pauli/soldering truth - and the eta
convention enters only through `MinkowskiConvention.eta` in the
IsEtaLorentz extraction. No parallel convention was introduced; the
mostly-minus signature and the A X A^dagger congruence match the
project's recorded choices.

## Boundary-module discharge - coherent

`concreteHasExactCentralKernel : HasExactCentralKernel :=
sl2ToEtaLorentz_eq_one_iff` discharges the gate; NO residual `hKernel`
hypothesis remains anywhere in the module (grep-verified); the
triangle-centrality and defect-reconstruction theorems are now
unconditional given Cech data and chosen lifts, and the NEW
reverse-edge result (`inverseLiftProduct` centrality:
lift i j * lift j i is +-I under pair symmetry) is the correct
completion - reversed edges were deliberately unconstrained at lift
level, and their product is now proven central rather than assumed.
The remaining openness (graph-derived atlas/lifts; surjectivity;
obstruction vanishing; w2 identification; refinement) is stated
verbatim in the module header and the task note's next-step list.

## Vacuity and footprint

The exact-kernel statement is inhabited by construction (its two
directions carry explicit witnesses); the boundary theorems remain
conditional on displayed Cech/lift data as before. Guards: 11 (action)
+ 4 (boundary), standard three axioms; independent build green.
