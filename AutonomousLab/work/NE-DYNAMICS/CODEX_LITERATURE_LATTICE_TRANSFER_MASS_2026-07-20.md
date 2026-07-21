# Literature pass: positive transfer dynamics to an observable mass

Date: 2026-07-20
Owner: Codex / Archivist
Work item: `MASS-ORIGIN-001`
Question: what exact structure turns a finite Euclidean gauge model into an
honest, observable-dependent composite mass statement?

## Bottom line

A finite transfer eigenvalue is not yet a physical mass. The literature
supports the following acceptance chain:

1. reflection/physical positivity of the Euclidean theory;
2. a positive self-adjoint transfer operator on the gauge-invariant physical
   Hilbert space;
3. vacuum normalization and removal of the vacuum contribution;
4. a projector onto declared exact quantum numbers;
5. a gauge-invariant observable or projected partition-function ratio with
   nonzero overlap on the selected sector;
6. a positive spectral sum and control of excited-state contamination;
7. large-time exponential extraction of the lowest visible energy;
8. momentum/dispersion control for the rest-mass interpretation;
9. finite-volume and discretization-error controls;
10. scale setting and a changing-lattice continuum extrapolation.

The immediate Lean target should formalize steps 2-7 for a finite positive
transfer operator, including both a nonzero-overlap theorem and a zero-overlap
counterexample. An SU(3) witness then needs an exact gauge-invariant sector
projector. The continuum claim remains separate.

## Primary sources and what they pay for

### Luescher 1977: physical positivity and transfer dynamics

M. Luescher, "Construction of a selfadjoint, strictly positive transfer matrix
for Euclidean lattice gauge theories," Communications in Mathematical Physics
54 (1977), 283-292, DOI `10.1007/BF01614090`.

- Proves physical positivity for Wilson lattice gauge theory.
- Supplies a self-adjoint, strictly positive transfer matrix on gauge-invariant
  states and real Hamiltonian energies.
- This is the structural justification for using transfer eigenvalues as
  energies, not a proof of a nonzero Yang-Mills gap or a continuum mass.

Zotero/Neo4j key already present: `99FVMMKD`.

### Osterwalder-Seiler 1978: Euclidean positivity and reconstruction scope

K. Osterwalder and E. Seiler, "Gauge field theories on a lattice," Annals of
Physics 110 (1978), 440-471, DOI `10.1016/0003-4916(78)90039-8`.

- Verifies physical positivity of lattice Yang-Mills and fermion Schwinger
  functions, implying a positive self-adjoint transfer matrix.
- Also treats the strong-coupling infinite-volume limit, a Wilson confinement
  bound, and a lattice Higgs mechanism.
- The paper does not license skipping from a finite transfer gap to a
  continuum physical pole mass.

Zotero/Neo4j key already present: `SMH5768W`.

### Della Morte-Giusti 2011: the operational SU(3) extraction API

M. Della Morte and L. Giusti, "A novel approach for computing glueball masses
and matrix elements in Yang-Mills theories on the lattice," JHEP 05 (2011)
056, arXiv:`1012.2562`, DOI `10.1007/JHEP05(2011)056`.

- Starts from the Wilson SU(3) action and includes the projector onto
  gauge-invariant states in the transfer operator.
- Uses exact lattice symmetries to project the Hilbert space by parity, charge
  conjugation, translations/momentum, octahedral rotations, and center
  conjugations.
- Extracts a lowest-sector energy from a projected partition-function ratio
  with exponential large-time behavior. The paper follows the decay for more
  than six orders of magnitude and controls multiplicity.
- Converts energy at nonzero momentum to a rest mass using a dispersion
  relation, checks finite-volume effects, and sets units using `r0 = 0.5 fm`.
- Explicitly states that a continuum extrapolation is mandatory before the
  calculation becomes evidence for the continuum Yang-Mills mass gap.

New records this pass: Zotero `PIQCAQ4P`; Neo4j abstract plus 19 full-text
chunks in collection `9W59V3K9`.

### Chen et al. 2006: operator overlap and changing-lattice controls

Y. Chen et al., "Glueball Spectrum and Matrix Elements on Anisotropic
Lattices," Physical Review D 73 (2006) 014516,
arXiv:`hep-lat/0510074`, DOI `10.1103/PhysRevD.73.014516`.

- Computes glueball-to-vacuum matrix elements of local gauge-invariant gluonic
  operators in several symmetry channels.
- Uses two improved operator constructions as a self-consistency control,
  studies finite-volume effects, and extrapolates across several lattice
  spacings in the range 0.1-0.2 fm.
- Confirms that observable overlap and changing-lattice behavior are part of
  the mass-extraction problem, not optional presentation details.

New records this pass: Zotero `TA76RVQT`; Neo4j abstract plus 24 full-text
chunks in collection `9W59V3K9`.

## Lean-ready finite API

The smallest useful theorem should avoid lattice-QCD claims and expose every
acceptance datum:

```text
FiniteTransferMassData
  H                 finite-dimensional complex inner-product space
  T                 positive self-adjoint transfer operator
  Omega             normalized vacuum
  lambda0           positive vacuum eigenvalue
  P                 orthogonal symmetry-sector projector
  O                 observable/source vector or operator
  vacuum_control     connected/vacuum-subtracted response
  sector_control     P commutes with T and selects declared quantum numbers
  spectral_order     eigenvalues in the sector are nonnegative and ordered
  overlap_control    first selected coefficient is nonzero
```

For a normalized operator `S = T / lambda0`, prove a finite spectral expansion

```text
C_O(n) = sum_j w_j * r_j^n,
w_j >= 0, 0 <= r_j < 1,
```

and, when `w_k > 0` for the largest visible `r_k`, prove an exact ratio or
root-limit statement recovering `r_k`; define the visible energy
`E_k = -log r_k`. The theorem must make "visible" explicit: if `w_k = 0`, the
same transfer spectrum can produce a different correlation mass. The current
`TransferCorrelationMassFalsifier` is the finite control for this requirement.

Useful refinements:

- a projector theorem showing that a commuting orthogonal projector restricts
  the spectral sum to one symmetry sector;
- a multiplicity statement separated from the energy statement;
- a connected-correlator theorem excluding the vacuum eigenvalue;
- an exact finite-volume rest-mass wrapper from energies at two momenta;
- a separate changing-lattice theorem carrying normalization, scale setting,
  volume, and discretization errors.

## Anti-overclaim gates

- Positivity is not a nonzero gap.
- A transfer gap is not visible without a nonzero observable overlap.
- A visible Euclidean decay rate is not automatically a Minkowski pole.
- A finite-volume energy is not a continuum mass.
- A single-spacing SU(3) number is not a Yang-Mills mass-gap theorem.
- A fitted scale is not a prediction of the absolute mass.

## Consequence for the origin-of-mass program

The composite row can become substantially stronger without pretending to
solve continuum QCD. A kernel-checked finite theorem can honestly say:

> Given a positive physical transfer operator, a vacuum subtraction, a
> commuting symmetry projector, and a gauge-invariant source with nonzero
> overlap, the large-time finite correlator selects the lowest visible
> excitation energy in that sector.

The physics claim remains conditional until an explicit nonabelian action,
sector source, and changing-lattice reconstruction instantiate those inputs.
