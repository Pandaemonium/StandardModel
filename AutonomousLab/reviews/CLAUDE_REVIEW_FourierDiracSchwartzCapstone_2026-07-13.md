# Claude review: FourierDiracSchwartzCapstone (180406b2 focused successor)

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-121832, item CONT-FOURIER-001
- Source: `.../stall-review-20260713-1220/180406b2-extract2/.../
  FourierDiracSchwartzCapstone.lean` (229 lines, 0 sorry), sha256 `b06818f6...`
  verified. (Reviewed the file only; the stale returned aggregate guard was NOT
  reviewed, per instruction.)
- Date: 2026-07-13

## Verdict: ACCEPT

A correct, well-scoped Schwartz-domain generator-symbol theorem: the
`-I/(2*pi)`-normalized position-space free Dirac differential expression
Fourier-transforms exactly to multiplication by the repository momentum symbol
`H`. Convention, scope, topology, and (replayed) axiom footprint all check out.
Two non-blocking notes. No proof or statement change required.

## The four requested checks

### 1. Fourier 2*pi convention - CORRECT (the load-bearing check)

Mathlib's forward transform is `exp(-2*pi*I<x,w>)`, whose derivative identity is
`𝓕(d_j g) = (2*pi*I*w_j) 𝓕 g` (imported `fourier_partial_correspondence`,
confirmed +2*pi*I sign). `positionDirac` carries the compensating normalization
`c = -I/(2*pi)` on the spatial block. The cancellation is exact:
`c * (2*pi*I*w_j) = (-I/(2*pi))(2*pi*I*w_j) = -I^2 w_j = w_j` (proved as `hscal`
via `Complex.I_sq`). Hence the spatial block Fourier-transforms to
`w_0 a1 + w_1 a2 + w_2 a3` applied to `𝓕 g`, and with the `m . beta` mass term
gives exactly `H(w_0,w_1,w_2,m) = w_0 a1 + w_1 a2 + w_2 a3 + m beta`
(Compact3Plus1DiracRate `H`). The index pairing is consistent
(`a1<->w_0<->d_0`, `a2<->w_1<->d_1`, `a3<->w_2<->d_2`). The docstring states the
convention and the `-I/(2*pi)` consequence accurately. No convention error - and
importantly the normalization is the HONEST consequence of mathlib's convention,
not a fudge to force a clean symbol.

### 2. Theorem scope - CORRECT

Explicit scope line (lines 12-14): "a generator-symbol theorem on Schwartz
functions. It is not a claim about the domain of the closed `L2` generator,
changing-lattice convergence, or a completed PDE reconstruction." That is exactly
the right disclaimer set. The headline `fourier_positionDirac` intertwines the
position differential expression with the momentum multiplier `H` on every
Schwartz spinor - a genuine generator-symbol (intertwining) identity, correctly
called a "capstone" because it composes all three derivative coordinates and the
mass term in one theorem (not three separate coordinate lemmas). It does NOT
claim a closed-operator domain, an `L2` Stone generator, a lattice/continuum
limit, or a solved PDE.

### 3. Topology claims (Schwartz is Frechet) - CORRECT

This is the usual trap (SchwartzMap is Frechet, not normable; no `NormedSpace`
instance; `HasDerivAt` cannot be typed for SchwartzMap-valued curves). The module
AVOIDS it cleanly:
- `coordinateDerivative g j x = fderiv Real (fun y => g y) x (single j 1)` -
  differentiates the UNDERLYING FUNCTION `⇑g` (smooth), not a SchwartzMap-valued
  curve. Legitimate.
- Integrability comes from the genuine Schwartz API:
  `SchwartzMap.fderivCLM ℝ ... g |>.integrable` and `g.integrable`
  (`positionDirac_integrable`, and the `hInt`/`hcoord`/`hg` inputs). This uses the
  existing continuous-linear-map-on-Schwartz structure, not a hand-rolled normed
  topology on the Frechet space.
No `NormedSpace`-on-Frechet, no SchwartzMap-valued `HasDerivAt`, no topology
over-claim. `matrixAction A = toEuclideanCLM A` is a bona fide bounded operator,
so `fourier_matrixAction` (Fourier commutes with a fixed bounded action, via
`ContinuousLinearMap.integral_comp_comm`) is correctly typed.

### 4. Standard axiom footprint - PASS (replayed)

Independent replay `lake env lean ... FourierDiracSchwartzCapstone.lean` against
the live repo: **EXITCODE=0** with COMPLETELY CLEAN output (no `sorry` warning, no
`#guard_msgs` mismatch), confirming all four guards matched
`[propext, Classical.choice, Quot.sound]` with no `sorryAx` / `native_decide` /
compiler-trust axiom. Four `#print axioms` guards
(`fourier_matrixAction`, `positionDirac_integrable`, `fourier_positionDirac`,
`fourier_positionDirac_zero`), all pinned to `[propext, Classical.choice,
Quot.sound]`. No `sorry` / `native_decide` / `axiom` / `admit`; proofs use only
kernel-level real-analysis tactics (`funext`/`simp`/`rw`/`integral_*`/`field_simp`/
`ring_nf`/`Complex.I_sq`).

## Non-blocking notes

- `fourier_positionDirac_zero` is a trivial `0 = 0` instance (both sides are `𝓕`
  of the zero function). It is a degenerate sanity control, NOT a nonzero
  non-vacuity witness. It is not needed for non-vacuity, however: the headline
  `fourier_positionDirac` has NO restrictive hypothesis (universally quantified
  over the nonempty Schwartz space), so it already applies to nonzero witnesses
  (e.g. a Gaussian). Optional: replace/augment with a nonzero-witness corollary if
  a concrete instance is wanted.
- Load-bearing import `fourier_partial_correspondence` (already in the tree)
  supplies the `2*pi*I*w_j` derivative identity; its sign is convention-consistent
  with the `-I/(2*pi)` normalization and produces the correct `+H`. Not re-audited
  here (landed project lemma), but flagged as the single external analytic input.

## Semantic alignment

The intended mathematics - the free Dirac operator in position space
Fourier-transforms to its momentum symbol - is faithfully represented. The only
subtlety, handled correctly and disclosed, is that mathlib's `2*pi`-in-exponent
convention forces the `-I/(2*pi)` normalization and evaluates the symbol at the
frequency variable `w` (so `H(w)`, with momentum identified as the mathlib
frequency). This is honest labeling, not a hidden convention swap.

## Narrowest defensible claim

For every Schwartz spinor `g : SchwartzMap FourierMomentum3 Spinor`, the
mathlib-Fourier-normalized position-space free `3+1` Dirac differential expression
`positionDirac m g = (-I/(2*pi))(a1 d_0 + a2 d_1 + a3 d_2)g + m beta g` satisfies
`𝓕(positionDirac m g)(w) = H(w_0,w_1,w_2,m) . 𝓕(g)(w)`, i.e. the Fourier
transform intertwines it exactly with multiplication by the repository free
momentum symbol `H`. This is a generator-symbol identity on the Schwartz domain;
it is NOT a closed-`L2` generator domain, Stone-generator, lattice/continuum
limit, or PDE-reconstruction theorem (all explicitly out of scope).
