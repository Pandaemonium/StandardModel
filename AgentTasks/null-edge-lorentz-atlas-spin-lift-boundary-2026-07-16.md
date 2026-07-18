# Null-edge Lorentz-atlas spin-lift boundary

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Claim grade: `M [orig/comp]` for finite group and Cech algebra only
Status: integrated, built, and independently approved

## Objective

Connect an exact eta-Lorentz Cech atlas and chosen local `SL(2,C)` preimages to
the existing finite central-sign obstruction theory.  The intended boundary is
explicit: Cech compatibility should put each triangle product in the kernel of
the concrete spin-to-Lorentz map, while the exact-kernel theorem should be the
only additional input needed to turn that product into a `ZMod 2` face defect.

## Production module

`PhysicsSM/Draft/NullEdge/LorentzAtlasSpinLiftBoundary.lean`

SHA-256:
`4705b09bc52d11dfd35b3675ccbde8f0dcf725a842f474d31f3c38aafa1f1192`

## Landed finite results

- `IsSpinLiftOn` states exact local projection of chosen `SL(2,C)` overlap
  lifts to eta-Lorentz transitions.
- `HasExactCentralKernel` isolates the statement that the concrete Lorentz
  action has kernel exactly `{+I,-I}`, and `concreteHasExactCentralKernel`
  now discharges it from the production exact-kernel theorem.
- `hasExactCentralKernel_iff_kernelContainedInCentralPair` reduces the abstract
  interface to kernel containment; `concreteHasExactCentralKernel` now
  discharges that condition from the production exact-kernel theorem.
- `sl2ToEtaLorentz_centralSign` and `isSpinLiftOn_reSign` prove that changing
  any local lift by its central sign leaves the Lorentz atlas unchanged.
- `timeCharacter_eq_one_of_spinLift` proves local liftability forces the
  transition into the orthochronous component.
- `diagonalLift_mem_kernel` and `inverseLiftProduct_mem_kernel` prove that
  diagonal normalization and reverse-overlap coherence fail, if at all, only
  by kernel elements; no inverse relation between chosen lifts is assumed.
- `inverseLiftProduct_isCentral` identifies the reverse-overlap mismatch with
  one central sign using the proved concrete exact-kernel theorem.
- `triangleLiftProduct_mem_kernel` is the unconditional Cech-to-kernel bridge:
  the ordered product of chosen lifts around every occupied Cech triangle maps
  to the identity Lorentz transformation.
- `triangleLiftProduct_isCentral` turns that kernel element into `+I` or `-I`
  using the proved concrete exact-kernel theorem.
- `triangleSpinDefect` and `centralSign_triangleSpinDefect` extract and exactly
  reconstruct the corresponding central face-defect bit.

The last two results supply the central face data expected by
`SpinLiftDefectFromTransport.lean` and `FiniteSpinCochainObstruction.lean`.
Those modules already prove re-signing covariance, choice independence of the
quotient class, and vanishing exactly when a global edge-sign correction
exists.

## Semantic boundary

- Local `SL(2,C)` lifts are supplied, not derived from graph data.
- Exact Lorentz Cech compatibility is supplied.
- Exact kernel `{+I,-I}` is now proved for the concrete Hermitian action.
- Surjectivity onto `SO^+(1,3)` remains open, so arbitrary restricted Lorentz
  transitions are not yet known to admit local lifts.
- No theorem proves the resulting obstruction class vanishes.
- Identification with continuum `w2`, refinement stability, curvature
  convergence, and Einstein dynamics remain open.
- Cech spin defects are bundle-gluing data and remain distinct from connection
  holonomy and curvature.

## Verification

- Direct check passed cleanly:
  `lake env lean PhysicsSM/Draft/NullEdge/LorentzAtlasSpinLiftBoundary.lean`.
- Targeted build passed all 8056 jobs:
  `lake build PhysicsSM.Draft.NullEdge.LorentzAtlasSpinLiftBoundary`.
  It replayed only pre-existing lint warnings in
  `AtlasTransitionHolonomy.lean` and `NullStrand.Conventions`; the new module
  was clean.
- Build-enforced axiom guards for the kernel reduction, reverse-overlap sign,
  Cech-to-kernel bridge, and central defect reconstruction report only `propext`,
  `Classical.choice`, and `Quot.sound`.

## Remaining gates

1. Prove surjectivity onto `SO^+(1,3)`.
2. Derive local restricted Lorentz transitions and their lifts from a
   graph-selected rank-four atlas.
3. Prove the finite spin obstruction vanishes under explicit graph-topology
   hypotheses, then establish refinement compatibility with continuum spin
   structure.

## Independent semantic review

Claude independently replayed the pre-discharge kernel check and audited the
Cech structure fields, pair-coverage hypothesis, reverse-edge lift freedom,
displayed exact-kernel gate,
central re-signing, and the distinction from connection holonomy and continuum
`w2`. Verdict: **APPROVED**. No hidden inverse-lift assumption or continuum
identification was found.

Review artifact:
`AutonomousLab/reviews/CLAUDE_REVIEW_SPIN_LIFT_BOUNDARY_2026-07-16.md`.
Claude's addendum independently rebuilt the strengthened modules and verified
that `concreteHasExactCentralKernel` removes every residual kernel hypothesis,
so reverse-overlap centrality, triangle centrality, and defect reconstruction
are unconditional given the displayed Cech data and chosen lifts. Verdict:
**APPROVED** at action SHA-256 `a949e1f5...` and boundary SHA-256
`4705b09b...`; see
`AutonomousLab/reviews/CLAUDE_REVIEW_SL2C_EXACT_KERNEL_2026-07-16.md`.

The optional suggestion of a local trivial-atlas witness is non-blocking; the
surrounding imported obstruction modules already carry explicit finite
witnesses, while this bridge's physical atlas and local lifts remain supplied.
