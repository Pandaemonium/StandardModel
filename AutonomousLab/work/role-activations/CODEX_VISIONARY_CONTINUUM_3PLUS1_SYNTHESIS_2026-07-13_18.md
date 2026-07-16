# Visionary synthesis: make 3+1 feed the continuum theorem

Date: 2026-07-13  
Role activation: `role-20260713-182530-7a8ceba2`  
Work item: `QCA-3PLUS1-001` with `CONT-FOURIER-001`

## Executive judgment

The highest-value program is no longer "find a pretty 3+1 walk" and separately
"prove an abstract continuum flow." The program should prove one end-to-end
statement:

> A strictly local finite HNU-type evolution has a selected low-energy sector
> whose changing-lattice dynamics converges to the exact continuum Dirac flow,
> while every ultraviolet zero- and pi-quasienergy sector is retained in an
> explicit anomaly ledger rather than projected away.

The current ingredients make this a serious theorem program rather than a
slogan:

- the HNU endpoint, exact real-space schedule, and momentum-space bridge are
  kernel-checked;
- the zero sector now has a genuine nonzero `+1` eigenvector census;
- a returned companion gives the genuine `-1` eigenspace form of the pi census;
- changing-cell `L2` convergence, exact multiplier flow, Fourier transport,
  Schwartz generator, and compact-support generator prerequisites are landed;
- only one dominated-convergence theorem remains in the compact-support strong
  derivative capstone;
- untwisted compact dilation has been proved to preserve the decoded endpoint,
  and is therefore a factorization rather than a copy-removal mechanism;
- the antiperiodic dilation audit finds an ordered central `-I` holonomy: it
  moves the HNU origin from zero to pi rather than preserving the target while
  eliminating the complement.

This last negative result is structurally informative. The obstruction is not
merely a bad scalar phase. The HNU schedule changes spin projectors by axis, and
their reflections do not commute. A fixed transverse selector cannot follow
that schedule. The natural successor is a transported projector frame or a
bulk-boundary inflow construction, not another fixed-register cancellation.

## What is closed

1. **Pure out-and-back dilation as a 3+1 solution.** It reproduces the same
   decoded operator and therefore the same topological and spectral ledger.
2. **Uniform antiperiodic twisting of every held branch.** It gives honest
   all-moving fine ticks but inserts a central reflection holonomy. At the
   origin the endpoint moves from `+1` to `-1`; the node is relocated, not
   removed.
3. **A free complement unitary as an explanation.** The controlled-sector API
   is useful, and `V = -1` is a clean spectral control, but locality,
   primitive-null support, and anomaly accounting are still supplied rather
   than derived.
4. **Projection as anomaly cancellation.** A sector discarded by a decoder
   still exists in the full microscopic spectrum. The full zero/pi census is
   the acceptance object.

## Flagship theorem ladder

### Bridge A: finish the continuum generator

**A1. Compact-support slope convergence.** Prove `orbit_slope_tendsto` by the
existing pointwise derivative and an explicit bounded-support `L2` dominator.

**A2. Strong derivative.** The final `HasDerivAt` theorem is already reduced to
an exact wrapper around A1; activate its standard-three guard after A1 lands.

**A3. Position-space transport.** Conjugate the strong derivative through the
unitary Fourier transform on the displayed compact-support/Schwartz domain.
Do not claim a bounded generator on all `L2`.

### Bridge B: HNU infrared tangent and quantitative scaling

**B1. Exact tangent.** Compute the derivative of the corrected depth-eight HNU
endpoint at the origin and identify the resulting Pauli/Weyl symbol, including
sign, axis order, and time normalization.

**B2. Uniform one-step error.** On a compact momentum ball, prove an explicit
operator-norm bound between the rescaled HNU endpoint and the exact continuum
Weyl/Dirac exponential. The coefficient must be displayed, not hidden behind
big-O notation.

**B3. Many-step compact-momentum limit.** Telescope B2 using exact unitarity to
obtain a fixed-time error that vanishes with lattice spacing.

**B4. Changing-lattice `L2` limit.** Compose B3 with the accepted bulk/tail and
Fourier transport machinery. State the sampling/interpolation maps and retain
the ultraviolet tail hypothesis.

### Bridge C: full zero/pi and anomaly ledger

**C1. State-level census.** Integrate the `+1` and `-1` nonzero-eigenvector
censuses so zero and pi sectors are statements about actual states, not only
matrix equalities.

**C2. Transported selector.** Replace the fixed projector by a schedule-indexed
family `P_j` with explicit inter-step frame transports `G_j`. Prove the exact
telescoping condition for the selected sector and compute the complement
holonomy.

**C3. Central-holonomy classification.** Classify when the ordered complement
holonomy is `+1`, `-1`, or noncentral for the depth-eight schedule. The
antiperiodic result is the nontrivial `-1` witness.

**C4. Inflow or minimality.** Either construct a finite local parent/boundary
system whose opposite charge resides in a proved bulk, mirror, or pi sector,
or prove the minimum additional register/range needed. A lone projected Weyl
sector is not success.

### Bridge D: physical discriminator

After A-C, compute one quantity not fixed by matching the infrared Dirac
symbol alone: a boundary transport index, defect response, phase-sensitive
two-particle amplitude, or regulator correction with a preregistered continuum
limit. This is the gate from reconstruction to new physics.

## Cheap tests before large proofs

1. Symbolically differentiate the exact HNU endpoint at `k = 0` and compare its
   Pauli coefficients with the live continuum generator conventions.
2. Enumerate the ordered projector-frame holonomy for the eight substeps and
   test whether any schedule-local conjugation makes it trivial without
   restoring a held branch.
3. Numerically sample the smallest nonzero singular value away from the known
   zero/pi loci before formalizing a global spectral-gap statement.
4. Test a two-cell or half-space parent whose boundary restriction is the HNU
   schedule and whose full finite charge ledger cancels.

## Resource recommendation

- 3 Aristotle lanes: A1 and B1-B3 continuum/infrared bridge.
- 3 Aristotle lanes: C2-C4 transported-frame, holonomy, and inflow/minimality.
- 1 Aristotle lane: standing adversarial audit of full zero/pi spectrum.
- 1 lane: opportunistic proof harvest or broad strategy, never filler.

Codex should own the exact API composition and Lean integration. Claude should
own the independent semantic/topological audit and nearest-literature check.
The Phenomenologist should define the first observable only after B and C expose
the full microscopic sector ledger.

## Kill conditions and pivots

- If the HNU tangent has the wrong sign, anisotropy, or normalization and no
  convention bridge repairs it, use HNU only as a topological control, not the
  physical continuum walk.
- If every transported selector preserving locality leaves an uncancelled
  central holonomy, pivot explicitly to a bulk-boundary or mirror completion.
- If the changing-lattice limit requires removing precisely the modes carrying
  compensating charge, the proposed physical decoder fails.
- If all observables after the limit depend only on fitted Dirac parameters,
  the construction is a reconstruction result, not a new theory of mass.

## Conventional control

Run the same A-D ladder for a conventional Wilson/domain-wall or known Floquet
regularization. The null-edge program earns explanatory leverage only if its
primitive-null and Pluecker structure fixes something the control leaves free,
or proves a sharper impossibility boundary.

## Immediate next three actions

1. Close A1 and activate the final compact-support derivative guard.
2. State B1 against the exact live HNU endpoint and continuum Pauli convention;
   submit it as a focused proof plus an independent sign audit.
3. State C2-C3 as a finite matrix/projector classification before funding a
   larger 4+1 parent construction.

## Same-cycle theorem update

Bridge C1 is now landed at state level. The live `+1` census proves that the
HNU endpoint has a nonzero fixed vector only at the origin; the live `-1`
census proves that a nonzero pi eigenvector exists exactly on a boundary face
of the closed Brillouin cube. The controlled transverse composite places the
exact HNU endpoint on the selected line and a spectrally explicit `-1` sector
on the complement, with full finite-matrix unitarity and no complement `+1`
state. This remains a spectral control, not a local null completion.

The antiperiodic route also has a decisive exact disposition. Its two-site
auxiliary shift is all-moving and satisfies `T^2 = -I`, but uniform insertion
across the depth-eight HNU schedule produces an ordered reflection holonomy of
`-I`. It relocates the origin from the zero sector to the pi sector. This
closes the global-uniform twist and sharpens C2-C3: any surviving construction
must use schedule-transported selectors, a nontrivial parent/boundary inflow
mechanism, or both.

A newly harvested gamma-coupled transverse construction strengthens that
pivot. It has exact Clifford cancellation, a strict complement gap, and exact
restriction to a massless tangent on the transverse kernel, but the tangent
splits into paired opposite-chirality Weyl sectors. Pending independent review,
this suggests the finite gamma parent is a promising anomaly-balanced bulk or
control architecture, while isolating one physical Weyl sector remains the
true decoding/inflow problem.
