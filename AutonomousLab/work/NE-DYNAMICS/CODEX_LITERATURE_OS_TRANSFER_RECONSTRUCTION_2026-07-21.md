# Literature pass: reflection positivity to transfer dynamics

Date: 2026-07-21

## Question

What is the smallest honest bridge from the finite Pluecker positive-energy
decay mode to reflection-positive Euclidean data, and what remains before one
can claim an interacting mass pole?

## Primary anchors

1. M. Luescher, *Construction of a selfadjoint, strictly positive transfer
   matrix for Euclidean lattice gauge theories*, Communications in
   Mathematical Physics 54 (1977), 283-292,
   DOI `10.1007/BF01614090`.
2. K. Osterwalder and E. Seiler, *Gauge Field Theories on a Lattice*, Annals of
   Physics 110 (1978), 440-471,
   DOI `10.1016/0003-4916(78)90039-8`.
3. K. Usui, *A Note on Reflection Positivity and the
   Umezawa-Kamefuchi-Kallen-Lehmann Representation of Two Point Correlation
   Functions*, arXiv:`1201.3415`.
4. T. Lang, K. Liegener, and T. Thiemann, *Hamiltonian Renormalisation I:
   Derivation from Osterwalder-Schrader Reconstruction*, arXiv:`1711.05685`.

The Neo4j full-text search ranked Usui's setup and conclusion first.  Its
load-bearing assumptions are Hermiticity, time-translation invariance, link
reflection positivity, and polynomial boundedness.  Under these assumptions a
lattice two-point function has a positive Euclidean Kallen-Lehmann spectral
measure.  A positive matrix by itself is not a substitute for this package.

## Consequence for the current formalization

The recently landed modules now separate four statements that must not be
collapsed:

1. `FiniteHamiltonianTransferPole`: a supplied finite positive Hamiltonian
   gives a positive contractive transfer operator, exact exponential decay,
   ordinary orbit-Gram positivity, and a denominator-normalized visible
   weight.
2. `PlueckerPositiveEnergyTransfer`: the primitive wedge supplies an explicit
   positive rest eigenmode with energy `|z|`; its Euclidean factor decays.
   The negative rest branch grows, so the unprojected `B_z` is not positive.
3. `FiniteOSReflectionPositivity`: a genuine finite reflected-time pairing,
   plus reflection compatibility, gives a positive-semidefinite reflected
   block and a quotient inner-product space.  Ordinary matrix
   positive-definiteness and reflection positivity imply neither one another.
4. `ObservableGapLinkage`: the transfer gap is reported by a correlator only
   when the observable has nonzero overlap with the relevant excitation.

The cheapest new composition is therefore not a claim about an interacting
measure.  It is the exact one-mode reflected Hankel kernel

`K(i,j) = exp(-a |z| (i+j))`.

Its quadratic form is one square, hence it is reflection positive as a finite
positive-time block.  It is also rank one, with an explicit nonzero null vector
for two time samples.  That null direction is scientifically useful: the
one-mode theorem supplies one positive spectral atom but cannot manufacture a
vacuum-plus-excitation spectrum, strict positivity, an interacting transfer
gap, or LSZ.

## Submitted theorem target

Aristotle project `de164bed-3ccc-4934-8263-6e511988015e` targets:

- outer-product factorization of the decay Hankel kernel;
- exact square formula for the reflected quadratic form;
- positive semidefiniteness for the Pluecker decay factor;
- explicit two-time null-vector control;
- an exact `3-4-5` nonzero Pluecker witness.

## Remaining physical bridge

To reach a genuinely interacting mass claim, a future theorem must start from
a local Euclidean action or measure and prove:

1. reflection positivity for the positive-time observable algebra;
2. time-translation structure and a positive self-adjoint transfer operator;
3. a nondegenerate spectral gap rather than positivity alone;
4. nonzero overlap of a gauge-invariant observable with the first excitation;
5. regulator and volume limits preserving the preceding data.

The literature search also surfaced several very recent, extraordinary
Yang-Mills mass-gap claims.  They were not used: search-result abstracts are
not adequate evidence for results of that magnitude, and the established
primary reconstruction sources above already determine the local theorem
shape needed here.
