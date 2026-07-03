# Gate C2 next frontier: the even-lattice / 2D Wilson-Dirac zero-to-nonzero flux index

Status: design + oracle-validated plan, 2026-07-03 (overnight run, claude). Written
after both C2 Aristotle harvests landed (flux triangle `FluxOverlapIndex`; inertia
bridge `epsCFC_trace_eq_inertia`). This note sharpens the "even-lattice / 2D-torus
flux index" frontier stated in
`Sources/Null_Edge_Gate_C2_Index_And_Certified_Sign.md` section 4, with a validated
concrete target. Draft/design only - no Lean added.

## The problem with the triangle (why a new construction is needed)

The `pi`-flux triangle (`FluxOverlapIndex`) is a genuine gauge flux, but its index
is nonzero at EVERY flux value (an odd 3-cycle carries index `+1` at zero flux and
`-1` at `pi`-flux). So it does not exhibit a flux-driven ZERO-to-nonzero jump; the
sharp statement there is only the `Delta = -2` change.

## Design insight (oracle-validated)

In the certified-sign framework the index against a traceless chirality reduces to
the inertia (eigenvalue-sign imbalance) of the gapped Hermitian gauge operator
`H_U` (now a THEOREM: `epsCFC_trace_eq_inertia`,
`overlapIndex = -(1/2)(n_+ - n_-)` for balanced `gamma5`). So a zero-to-nonzero
flux index requires an `H_U` whose inertia is BALANCED (`n_+ = n_-`) at zero flux
and IMBALANCED with flux.

Key obstruction: any pure hopping graph that is BIPARTITE has a chiral symmetry
`Gamma H Gamma = -H` (`Gamma = +-1` on the two parts), forcing a symmetric
spectrum `{+lambda, -lambda}` and hence inertia `0` - for ANY link phases (flux).
So flux alone cannot imbalance a bipartite hopping graph. (Non-bipartite odd
cycles like the triangle are imbalanced, but at every flux.)

Oracle check (`scratchpad/flux2d_probe.py`, numpy eigvalsh):
- even cycles `n = 4, 6` with link phase `+1`, `-1`, or a generic `e^{0.7 i}`:
  inertia `= 0` in every case (balanced, as predicted);
- triangle `n = 3`: inertia `-1` (flux `+1`) and `+1` (flux `-1`) - nonzero always.

Conclusion: a genuine zero-to-nonzero flux index needs a term that BREAKS the
bipartite/chiral symmetry - i.e. a WILSON MASS term `r (2 - sum_mu cos p_mu)` added
to the naive Dirac hopping, exactly the standard lattice mechanism by which the
2D Wilson-Dirac index equals the topological charge.

## Validated concrete target (oracle)

2D Wilson-Dirac on an `L x L` torus, `H = sx (x) Dx + sy (x) Dy + sz (x) (m + W)`
with `Dmu = (Tmu - Tmu^dag)/2i`, `W = r(2 - (Tx+Tx^dag)/2 - (Ty+Ty^dag)/2)`,
`r = 1`, magnetic flux `Q` quanta via Landau-gauge phase `exp(i (2 pi Q / L) y)` on
the x-hops. Oracle index `= -(1/2) inertia(H)`:

| L | m    | Q=0 | Q=1        | Q=2 |
|---|------|-----|------------|-----|
| 3 | -1   | 0   | 0          | 0   |
| 4 | -1   | **0** | **4** (gap 0.19) | 0 |
| 5 | -1   | **0** | **5** (gap 0.35) | 0 |

So `L = 4, m = -1, Q: 0 -> 1` gives a genuine ZERO-to-nonzero index (`0 -> 4`),
gapped. (Index `= L` at `Q = 1` is a lattice artifact of this crude operator; a
sharper Wilson-Dirac would give the continuum `Q`. For a first FINITE witness the
milestone is the `0 -> nonzero` jump, which this delivers. `m = +-0.5` give `0` -
the mass must sit in the topological Wilson window.)

**Codex review note, 2026-07-03 07:30 PDT.** The phase convention above needs
one normalization caveat before it becomes a paper claim: with
`U_x(y)=exp(i (2 pi Q / L) y)` and the periodic boundary link handled by the same
formula, each plaquette has holonomy `exp(-2 pi i Q / L)`, so the whole `L x L`
torus carries `L*Q` flux quanta (modulo orientation), not one continuum unit.
Thus the oracle's `Q = 1` / index `L` result is best read as a validated
zero-to-nonzero finite witness with total flux `L`, not as a unit-flux continuum
normalization. A true one-flux-quantum Wilson-Dirac target should use the
standard `2 pi Q / L^2` plaquette normalization plus the necessary boundary twist
or an equivalent magnetic-translation gauge.

### Why `L = 4` is the tractable entry point

For `L = 4` the flux phases are 4th roots of unity `{1, i, -1, -i}`, so every
`cos(2 pi y / 4) in {1, 0, -1}` and `sin(2 pi y / 4) in {0, 1, 0, -1}`. The naive
Dirac and Wilson terms carry a factor `1/2`, so `H_U` has HALF-INTEGER
(Gaussian-rational, denominator 2) entries; `2 H_U` is an EXACT Gaussian-INTEGER
Hermitian `32 x 32` matrix (`L^2 = 16` sites x 2 spin), and
`inertia(H_U) = inertia(2 H_U)`. So the signature is over an explicit integer
matrix - NO surds in the entries (unlike the generic even lattice, whose
`+-sqrt 2` spectra force irrational signs). Oracle-confirmed (`flux2d_verify.py`,
`L=4, m=-1`): `H_U` gapped (`det H_U = 81 != 0`, `min|lambda| = 0.19`), inertia
`n_+ - n_- = 12 - 20 = -8` at `Q=1` giving index `-(-8)/2 = 4`, versus balanced
`16 - 16 = 0` (index `0`) at `Q=0`. The chirality is the traceless
`gamma5U = 1_16 (x) sz`; `H_U` is the full Wilson-Dirac (the interface needs only a
traceless `gamma5U` and a gapped Hermitian `H_U`, not `[gamma5U, H_U] = 0`), so
`overlapIndex gamma5U (sign H_U) = -(1/2) inertia(H_U)`.

## Formalization path (for the next session / an Aristotle job)

With `epsCFC_trace_eq_inertia` and `certifiedSign_exists` BOTH proved, the target
no longer needs an explicit rational sign. The remaining content is a finite
SIGNATURE computation:

1. Define the explicit `32 x 32` integer Hermitian `H_U` (`L=4, m=-1, Q=1`) and its
   zero-flux counterpart `H_0` (`Q=0`).
2. Prove both are invertible (gapped): the gap is `~0.19`, so `det != 0` - a finite
   integer determinant check, or an explicit inverse.
3. Compute the inertia `n_+ - n_-` of each: `0` for `H_0`, nonzero for `H_U`. This
   is the hard finite step - a `32 x 32` signature. Candidate routes:
   - Sylvester's law via an explicit rational `L D L^dag` (congruence) factorization
     - the signs of the diagonal `D` give the inertia, kernel-checkable without
     eigenvalues or surds;
   - or a Sturm/characteristic-polynomial sign-change count;
   - **RECOMMENDED - block-diagonalize by the PLAIN x-translation `T_x`.** In
     Landau gauge the x-hop phase depends on `y` only, so nothing depends on `x`:
     ordinary x-translation is a symmetry and splits `H_U` into `L` x-momentum
     blocks of size `2L x 2L`. ORACLE-VERIFIED (`flux2d_block.py`, `L=4`): the
     plain-`T_x` Fourier transform block-diagonalizes the `32 x 32` into 4 blocks
     of `8 x 8` (off-block `< 3e-16`), each with inertia `-2`, summing to `-8`
     (index 4). Each `8 x 8` block is a small fixed-`k_x` Gaussian-rational
     Hermitian matrix (no surds), whose signature is very tractable. This turns one
     hard `32 x 32` signature into `L` easy `2L x 2L` ones. (NB: the COVARIANT
     phase-carrying shift `T_x` from `torus_shifts` does NOT commute; the PLAIN
     shift is the symmetry. The `T_y` translations do not commute in this gauge.)
4. Conclude `overlapIndex gamma5U (epsCFC H_U) != 0 = overlapIndex gamma5U
   (epsCFC H_0)` via `gaugeOverlap_index_eigenvalue_count_form` - a genuine
   flux-driven ZERO-to-nonzero index on an even 2D lattice.

Suggested first Aristotle job: now that the plain-`T_x` block reduction is
oracle-verified (4 blocks of `8 x 8`, each inertia `-2`, index 4), a focused
CONSTRUCTION job is viable - define the `L=4` blocks (or the full `H_U` + the
plain-`T_x` block-diagonalization), prove each `8 x 8` block's signature (Sturm on
its rational characteristic polynomial, or a PIVOTED symmetric congruence - see the
exact-arithmetic check below; the block eigenvalues are cubic-irrational, do NOT use
them), and sum to the flux index, contrasted with the balanced `Q=0` case. Keep it
a standalone Mathlib package; the per-block `8 x 8` signature is the load-bearing
lemma and is reusable. Prerequisite in-repo lemma already available:
`gaugeOverlap_index_eigenvalue_count_form`.

### Exact-arithmetic method check (claude, 2026-07-03)

sympy EXACT arithmetic on the `L=4, m=-1, Q=1` operator
(`scratchpad/flux2d_exact*.py`) confirms and sharpens the route:
- the `8 x 8` `k_x=0` block has EXACT Gaussian-rational entries (verified) and
  inertia `-2` - exact eigenvalues `-1, 1-sqrt2, 1+sqrt2, -sqrt3, sqrt3` plus three
  roots of an irreducible cubic: `3` positive, `5` negative;
- the EIGENVALUE route is hopeless - three block eigenvalues are cubic irrationals
  (casus irreducibilis, `sqrt(111)` discriminant + complex cube roots);
- the surd-free route is STURM on the RATIONAL characteristic polynomial (degree 8,
  rational coeffs; count positive vs negative real roots) OR a PIVOTED symmetric
  congruence. WARNING: the naive leading-principal-minor (Jacobi) count FAILS - the
  natural basis has a zero leading minor `D_1 = block[0,0] = 0`, so a symmetric
  permutation / pivoting is REQUIRED; the unpermuted sign-change count returns a
  wrong `0`.

So the crisp Aristotle target is: `inertia(block) = -2` via a Sturm/pivoted-
congruence argument on its rational characteristic polynomial, times `L=4` blocks
`= -8` (index `4`), versus balanced `0` at `Q=0`.

## Provenance

Oracle: `scratchpad/flux2d_probe.py` + `scratchpad/flux2d_verify.py`, numpy
`linalg.eigvalsh`, 2026-07-03,
exploratory (validates the design claims; NOT a trusted proof and NOT a CI
fixture). Framework: the certified-sign interface + `epsCFC_trace_eq_inertia`
(`GateC2/GaugeIndexInertiaForm.lean`). Convention: `H_U` Hermitian, index
`= -(1/2)(n_+ - n_-)` against traceless `gamma5U = 1 (x) sz`, matching
`FluxOverlapIndex`.
