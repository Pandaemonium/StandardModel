# Claude cross-family review: FourierPartialCorrespondence (7be67a65)

- Reviewer: interactive Claude Code (claude family)
- Builder: Codex (Aristotle 7be67a65, Mathlib-only, alias-adapted)
- Work item: `CONT-FOURIER-001`
- Source: `PhysicsSM/Draft/NullEdge/FourierPartialCorrespondence.lean` (81 lines),
  sha256 96a686c5... verified
- Date: 2026-07-13

## Verdict: ACCEPT

## Item-by-item

- **Mathlib forward-transform convention.** Uses `𝓕` (`FourierTransform`,
  kernel `exp(-2*pi*I*<x,w>)`) and proves via `Real.fourier_fderiv` +
  `VectorFourier.fourierSMulRight_apply`. Correct forward-transform API.
- **Positive sign + explicit 2*pi.** The stated symbol is
  `2 * pi * I * w_j` (positive). For the forward transform this is correct:
  integration by parts gives `𝓕(d_j f)(w) = -∫ f d_j(e^{-2*pi*i<x,w>})
  = +2*pi*i*w_j * 𝓕(f)(w)` (the two minus signs cancel). The proof carries the
  intermediate `ContinuousLinearMap.neg_apply` from `fourierSMulRight` and
  reconciles to the positive symbol via `push_cast; ring_nf`; the kernel accepts
  the positive-sign statement, which is the authority on the convention.
- **Coordinate inner-product order.** Direction `EuclideanSpace.single j 1`,
  component `w j`; `EuclideanSpace.inner_single_right` + `RCLike.conj_to_real`
  reduce `<w, e_j>` to `w_j` (real, conjugation trivial). Order correct.
- **Alias adaptation.** Stated over `SchwartzMap FourierMomentum3 Spinor`;
  `SchwartzMap.fderivCLM`, `g.integrable`, `g.differentiable` valid on the
  aliases. Definitional adaptation from the Mathlib-only package, no statement
  change.
- **Zero control.** `fourier_partial_correspondence_zero = ... 0 j` specializes
  to the zero Schwartz map coherently.
- **Prose does not claim the PDE composition.** Docstring: "It does not by
  itself prove that the live walk converges to a position-space PDE; that
  conclusion still requires composition with the multiplier limit on a displayed
  function domain." Correctly scoped.

## Overclaim tests

Vacuity: none (genuine Schwartz Fourier identity + zero control). Hollow: none
(real convention-pinning content). Docstring overreach: none (explicitly a
Schwartz identity, PDE deferred). False shape: none (Fourier-of-derivative
symbol is the correct shape).

## Independent verification

- `lake build PhysicsSM.Draft.NullEdge.FourierPartialCorrespondence`: Build
  completed successfully (8043 jobs), exit 0. The two in-file `#guard_msgs`
  blocks fired and passed, so the axiom footprint is
  `[propext, Classical.choice, Quot.sound]`, build-enforced.

## Narrowest defensible claim

Under Mathlib's forward Fourier transform (kernel `exp(-2*pi*I*<x,w>)`), for a
Schwartz map on `FourierMomentum3` valued in `Spinor`, the transform of the
`j`-th coordinate derivative equals multiplication by the positive symbol
`2*pi*I*w_j`. This is a Schwartz-space convention identity; it does not prove the
position-space PDE, which still requires composition with the multiplier limit
on a displayed function domain.
