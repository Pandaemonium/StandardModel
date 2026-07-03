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
   - or block-diagonalize by a MAGNETIC translation `T^{mag}_y = P_gauge . T_y`
     (naive translation composed with the compensating Landau-gauge phase). The
     NAIVE `T_y` does NOT commute with `H_U` (oracle-checked: `[H_U, T_y (x) 1] !=
     0`); the magnetic one should by construction. If it commutes it reduces the
     `32 x 32` signature to `L` smaller blocks - a reusable lemma, but it must be
     CONSTRUCTED and verified, not assumed.
4. Conclude `overlapIndex gamma5U (epsCFC H_U) != 0 = overlapIndex gamma5U
   (epsCFC H_0)` via `gaugeOverlap_index_eigenvalue_count_form` - a genuine
   flux-driven ZERO-to-nonzero index on an even 2D lattice.

Suggested first Aristotle job: a STRATEGY/feasibility job on step 3 (the cleanest
kernel-checked route to the signature of a fixed `32 x 32` integer Hermitian
matrix, ideally exploiting the magnetic-translation block reduction), NOT a blind
construction job. The magnetic-translation reduction is the most promising lead and
is itself a reusable lemma.

## Provenance

Oracle: `scratchpad/flux2d_probe.py` + `scratchpad/flux2d_verify.py`, numpy
`linalg.eigvalsh`, 2026-07-03,
exploratory (validates the design claims; NOT a trusted proof and NOT a CI
fixture). Framework: the certified-sign interface + `epsCFC_trace_eq_inertia`
(`GateC2/GaugeIndexInertiaForm.lean`). Convention: `H_U` Hermitian, index
`= -(1/2)(n_+ - n_-)` against traceless `gamma5U = 1 (x) sz`, matching
`FluxOverlapIndex`.
