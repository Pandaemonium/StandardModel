# Claude semantic review: FourierDiracSchwartzCapstone (job 180406b2)

Item: CONT-FOURIER-001 (owner codex; cross-family semantic review routed to claude)
Job: 180406b2 "Adversarial all-time position Dirac PDE theorem design"
(stall snapshot yielded the capstone; exact live-repo replay by codex 07-13;
this review clears the "cross-family semantic review required" gate noted in
the module docstring.)
Reviewer: interactive Claude / Skeptic. Date: 2026-07-16.

## Verdict: APPROVE (draft-trust integration confirmed)

`PhysicsSM/Draft/NullEdge/FourierDiracSchwartzCapstone.lean` states and proves
the intended mathematics:

- **Statement identity.** `fourier_positionDirac`: for every Schwartz spinor
  `g` and mass `m`, the Fourier transform of
  `positionDirac m g = (-I/(2*pi)) * (alpha . grad g) + m * beta * g`
  equals pointwise multiplication by the repository's canonical free symbol
  `H kx ky kz m = kx*alpha1 + ky*alpha2 + kz*alpha3 + m*beta`
  (checked against BOTH definition sites: `Compact3Plus1DiracRate.H` and
  `Clifford3Plus1WalkSymbol.H`; identical formula, same alpha/beta constants -
  standard Dirac-basis matrices, alpha_j the anti-diagonal/off-diagonal Dirac
  alphas, beta = diag(1,1,-1,-1)).
- **Normalization honesty.** Mathlib's forward transform uses
  `exp(-2*pi*I*<x,w>)`, so the derivative rule contributes `2*pi*I*w_j`; the
  displayed `-I/(2*pi)` prefactor makes the composite coefficient exactly
  `w_j`. The 2*pi convention is explicit in the definition and docstring, as
  the work item requires ("preserve Mathlib's explicit 2*pi convention").
- **Domain honesty.** Everything is on `SchwartzMap FourierMomentum3 Spinor`;
  the docstring states it is a generator-symbol theorem, NOT a closed L2
  generator-domain claim, NOT changing-lattice convergence, NOT a completed
  PDE reconstruction. This matches the item boundary ("open F3 only with a
  displayed Sobolev or Schwartz domain; do not rename unitary L2 transport as
  a PDE theorem").
- **Supporting lemmas sound.** `coordinateDerivative` is the honest
  directional `fderiv` at `EuclideanSpace.single j 1`;
  `fourier_matrixAction` commutes a fixed bounded matrix action through the
  transform with an explicit integrability argument;
  `positionDirac_integrable` derives integrability from the Schwartz
  structure (no hidden hypotheses).
- **Controls.** Zero-spinor boundary control present
  (`fourier_positionDirac_zero`).
- **Axiom footprint.** All four public theorems carry build-enforced
  `#guard_msgs`/`#print axioms` pins to `[propext, Classical.choice,
  Quot.sound]`.

## Verification actually run

```text
lake build PhysicsSM.Draft.NullEdge.FourierDiracSchwartzCapstone
# green (8044 jobs; guards enforced at build), 2026-07-16
```

## Notes (nonblocking)

- N1: the capstone composes cleanly with the F2 multiplier-isometry lane;
  when codex assembles the F1+F2 composition, cite this module for the
  position-side normalization rather than re-deriving it.
- N2: `H` is defined at two sites with the same formula; a future cleanup
  could alias one to the other to prevent silent divergence.

Disposition: job 180406b2 -> integrated (the capstone file is the integrated
payload; the docstring's "cross-family semantic review remains required
before manuscript promotion" is now satisfied for draft-trust; manuscript
promotion still needs the usual claim-calculus pass).
