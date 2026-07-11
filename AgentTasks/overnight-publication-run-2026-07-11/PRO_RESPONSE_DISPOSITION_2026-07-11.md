# Pro blocker response: theorem disposition and build order

Date: 2026-07-11

This note records the actionable mathematical content of Pro's response to
`HELP_NEEDED_2026-07-11.md`.  It is a triage and implementation record, not a
claim that the proposed paper proofs or cited literature have been verified.
Every promoted result still requires a semantically aligned Lean statement,
kernel acceptance, build-enforced guards, a nonzero witness, and a negative or
boundary control.

## H1: physical channel equivalence by endomorphism cohomology

The strongest new idea was to stop searching for a preferred scalar selector
and first quotient channel representatives by constraint-exact changes.  The
finite algebraic core has now landed in
`PhysicsSM/Draft/NullEdge/ChannelPhysicalCohomology.lean`.  For a finite graded
carrier with `Q^2 = 0`, define the endomorphism differential

```text
delta_Q(X) = Q X - (-1)^|X| X Q.
```

The candidate physical operator algebra is

```text
H^0(End K, delta_Q) = {X | QX = XQ} / {QH + HQ}.
```

Given explicit contraction data `i`, `p`, and `s` with
`p i = 1`, `Q i = 0`, `p Q = 0`, and `Q s + s Q = 1 - i p`, the finite target
is the constructive equivalence

```text
p X i = 0  <->  exists H, X = Q H + H Q
```

for a chain map `X`.  The landed constructive witness is
`H = sX + (ip)Xs`.  Surjectivity sends a physical operator `f` to `i f p`.
Together these theorems identify the finite chain-map quotient with
endomorphisms of the supplied physical retract.  An exact rational `Fin 3`
witness and a control showing that the chain-map hypothesis is load-bearing
are included.

This resolves the abstract mathematical quotient only after a carrier
constraint `Q` and contraction are supplied.  The existing positive
Ward/descent witness now supplies one exact finite realization in
`Carrier/WardPhysicalCohomology.lean`: its `Qmat`, reverse-arrow contraction,
and physical line satisfy the packet.  Deriving those data from the full live
carrier, the physically retained automorphism group, and the finite-range
condition on homotopies remain open.  The live
positive-complement disk should then be tested after physical compression:
varying compressed trace or spectrum proves inequivalence; simultaneous
conjugacy gives an equivalence candidate; equality without a bounded-range
homotopy leaves microscopic inequivalence open.

## H2 and H5: handed to Fable's claimed lanes

Pro supplied a two-site free-carrier phase-defect polynomial and a
reflection-resolved chiral pinning index.  These directly sharpen Fable's
already active H2 and H5 jobs, so Codex will not duplicate them.

The H2 preregistered identity is

```text
(H^2 - (m^2+t^2) I)^2 = t^2 |z_L-z_R|^2 I
```

with a gauge-covariant successor using
`|z_R - exp(-i chi) z_L|`.  The exact zero condition is proposed as `t=m` and
transported antipodal phases.  This is a finite free-spectrum discriminator,
not topological protection.

The H5 candidate keeps separate `+1` and `-1` quasienergy sectors and further
resolves them by reflection.  Before transcription, the live reflection must
be checked against chirality: commuting and anticommuting conventions require
different index definitions.

## H6: from sequential gates to circuit layers

The first graph-metric gate has now landed in `PlueckerGeometricCone.lean`:
sequential `BlockLocal` gates obey an iterated-neighborhood support bound.  Pro
identifies the next exact strengthening.  A layer is a finite family of
pairwise-disjoint even local gates, each of graph diameter at most `r`.
Conjugating an observable supported in `X` by one layer should place it in
`N_r(X)`; a depth-`T` schedule should place it in `N_{Tr}(X)` or the iterated
varying-radius neighborhood.

The outside-cone corollary must use graded commutation for odd-odd observables;
ordinary commutation is available when at least one observable is even.  The
required negative control is a distant two-mode hopping gate that is even but
fails the finite-range premise and transports an annihilation operator to the
distant site immediately.

Primary-source metadata supports the locality warning: Piroli, Turzillo,
Shukla, and Cirac, arXiv:2007.11905, show that generic fermionic matrix-product
unitaries need not have a strict causal cone and characterize a generalized
locality-preserving class.  This motivates explicit support hypotheses; it is
not imported as a proof of the finite theorem.

## H4: low/high-frequency synthesis

The live changing-mode embedding, Sobolev coefficient tail, exact finite DFT,
and bounded-box walk estimates should be composed by splitting the state into
low and high Fourier modes.  The target estimate has the shape

```text
error(a,t,psi) <= C_T a (1+K)^p ||psi||_2
                  + 2 K^(-s) ||psi||_(H^s).
```

The exponent must be derived from the actual growth of the live bounded-box
constant.  If the first term is exactly `a K^p`, balancing gives
`K = a^(-1/(p+s))` and rate `a^(s/(p+s))`.  Different existing powers or a
time-rounding term change that exponent; no rate will be copied from prose
before the constants are inspected.  Literal point sampling also needs a
separate aliasing theorem, typically above the three-dimensional Sobolev
embedding threshold.

## H7: finite scale-selection boundary

Pro proposes a general homogeneous-action theorem: a differentiable positive
action satisfying `S(r x) = r^p S(x)` with `p>0` has radial derivative
`dS_x[x] = p S(x)`, so no nonzero point is stationary.  At degree zero the
radial direction is flat and cannot select an isolated scale.  This would
generalize the current quartic Pluecker scale-collapse result.

The live three-channel RG map was checked first because a marginal eigenvalue
`-1` suggested a possible doubled-map cubic drift.  The exact result is the
opposite: `(g,g,0)` is a period-two line, so this proposed transmutation route
is dead on the live map.  A viable scale mechanism therefore needs a refining
family with running dimensionless couplings and a matched physical observable,
not another fixed finite homogeneous potential.

## H3: resource theorem, not another corner audit

The next finite-algebra rung is to classify units of the Laurent-polynomial
ring: an invertible finite Laurent polynomial over a field is a nonzero scalar
times one monomial.  Applied to the determinant of a strict translation-
invariant finite-range walk, this isolates a monomial flow/index obstruction.
The exact corollary to alias removal still needs to be stated carefully; the
ring theorem alone is not a Nielsen--Ninomiya theorem.

The publication-grade target is a resource lower bound that names the first
necessary escape: larger cell, additional memory/substeps, non-onsite symmetry,
larger coin dimension, or longer range.  The recent-paper claims have now been
verified at primary-abstract level.  Gupta and Short, arXiv:2601.15885,
construct doubler/pseudo-doubler-free Dirac-walk families but retain additional
low-energy non-Dirac solutions.  Beenakker, Sanchez Fernan, and Tworzydlo,
arXiv:2607.05112v2, show that a two-dimensional unpaired cone can rely on
nonsymmorphic half-translation symmetries that generic inhomogeneity breaks.
These papers motivate the resource theorem; their theorem bodies must still be
read before any load-bearing manuscript comparison.

## Build order

1. H1 finite contraction/cohomology theorem plus live-carrier instantiation.
2. H6 pairwise-disjoint layer and depth cone over the landed sequential core.
3. H4 exact low/high synthesis with the live constant growth audited.
4. H3 Laurent-unit classification and the narrow determinant corollary.
5. H7 general homogeneous-action no-go; seek scale generation only after H4
   and local many-body/RG dynamics exist.

Fable proceeds independently on H2 and H5.
