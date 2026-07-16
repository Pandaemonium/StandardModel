# Lateral 3+1 route: turn the eight-cover into internal particle structure

## Executive idea

The current strict-local program asks for one microscopic Dirac point and no
other zero- or pi-quasienergy crossings.  That target repeatedly collides with
the topology and periodicity of finite-range translation-invariant unitaries.

A different question is available.  Bakircioglu, Arnault, and Arrighi show
that the discrete-time 3+1 Dirac QCA admits an eight-sheet Brillouin-zone cover.
Their flavoring construction keeps the eight solutions but converts each from
a spurious alias into a continuum flavor on one of eight translated
sublattices.  Spatial and temporal translations act on a three-qubit flavor
register by bit flips.  Primary source: arXiv:2505.07900v3, especially their
Eqs. (4.9)-(4.13) and Sec. 5.2.

The StandardModel repository independently uses three-bit XOR labels for the
eight octonion basis elements.  This suggests a new architecture:

```text
QCA covering sheet  <->  three-bit flavor  <->  octonion XOR basis label
```

The proposal is not that equal cardinalities explain particle physics.  It is
that the unavoidable cover register may be the microscopic internal register
from which a one-generation particle multiplet is decoded.  Doubling then
becomes an internal-state theorem rather than a failed single-particle
discretization.

## Why this is genuinely lateral

The prior routes modify a Laurent word until every unwanted crossing is
globally gapped, or use interactions to remove mirror content.  This route
changes the success criterion:

- the microscopic walk is allowed to have eight cover sheets;
- all eight must have a controlled continuum interpretation;
- translation must act equivariantly on a finite internal register;
- interactions and gauge charges must distinguish the register in exactly the
  observed way; and
- the decoded spectrum must contain no additional states beyond the intended
  multiplet.

Nielsen-Ninomiya is respected because the larger Hilbert space still balances
chirality.  The scientific burden moves from impossible root deletion to a
representation-theoretic reconstruction problem.

## Theorem ladder

### F0. Exact cover/octet bridge

Prove a regular `Z2^3` action on the eight sheets and an equivariant
equivalence with the project `Fin 8` octonion labels.  Prove that octonion basis
multiplication lands on the XOR-summed sheet up to the existing Fano sign.

Status: focused Aristotle target prepared in
`AgentTasks/qca-octonion-flavor-bridge-aristotle-2026-07-13.md`.

### F1. Non-canonicity kill

Prove explicit nonidentity automorphisms of the unanchored cover.  Therefore
the group structure alone cannot select a particle dictionary.  Name the
extra data that removes the ambiguity: oriented Fano multiplication, a chosen
complex direction, gauge-charge operators, and chirality.

### F2. Translation/intertwiner theorem

Formalize the paper's flavored shifts

```text
Sx tensor X00,  Sy tensor 0X0,  Sz tensor 00X,
T tensor XXX
```

and prove exact unitarity, strict locality, the regular flavor permutation,
and the determinant multiplicity law.  Then transport those bit flips through
F0 to permutations of octonion basis labels.

### F3. Standard Model representation gate

Construct the actual charge, color, weak-isospin, chirality, and conjugation
operators on the eight-sheet register.  Compare them with the landed
Furey/Baez left-action-algebra representation.  Required outcomes are one of:

1. an exact intertwiner with the intended one-generation module;
2. a sharpened missing datum; or
3. a counterexample proving the numerical match `8 = 8` is accidental.

The gate fails immediately if color, hypercharge, or chirality cannot be made
equivariant with the flavored translations and local interactions.

#### F3a. Translation-charge commutant obstruction

There is a cheap and decisive first test.  The deck translations act regularly
on `Z2^3`: for any two sheets, one deck element carries the first to the
second.  Consequently every scalar charge assignment invariant under the full
regular deck action is constant on all eight sheets.

The landed one-generation reference table is not constant on the eight
left-handed doublet states.  It contains six quark-doublet Weyl states with
hypercharge `1/3` and two lepton-doublet Weyl states with hypercharge `-1`.
Therefore a bare identification in which physical translations act only by the
regular sheet permutations cannot also make hypercharge an internal conserved
operator.

This is a productive obstruction rather than an automatic rejection.  It
forces one of three explicit architectures:

1. **Gauge-twisted translation:** spatial translation is accompanied by a
   compensating internal parallel transport, so the local charge table is
   covariant rather than invariant under the naked deck permutation.
2. **Decoded charge:** physical charge acts on a quotient, boundary, or
   momentum-sheet combination rather than on the eight sheet labels alone.
3. **Broken deck symmetry:** the octonionic/Fano decoration physically selects
   quark and lepton orbits, so the full regular deck action is not a symmetry of
   the interacting theory.

The corresponding Lean kill theorem should state both sides: regular-action
invariance forces a constant function, and the explicit `6 + 2` Standard Model
hypercharge witness is nonconstant.  No claim of a successful flavor bridge is
allowed until one of the three escape architectures is stated and checked for
locality, unitarity, and translation covariance.

### F4. Dynamics and splitting

The bare cover makes eight degenerate continuum flavors.  A physical theory
must explain which symmetries retain degeneracy and which interactions split
it.  Couple the flavor register to the Pluecker turn field and closure
holonomies.  Prove locality and exact probability preservation before studying
mass splitting.

#### F4a. Momentum-independent projector no-go

A projector that is onsite and independent of momentum acts in the same way at
every cover crossing.  It may reduce the internal rank uniformly, but it cannot
select one momentum sheet while removing the others.  Thus a constant
Clifford/taste idempotent is not a doubler decoder, even when it commutes with
the flavored walk.

This kills the naive reading of a Dirac--Kahler/Watterson-style projector as a
solution.  Such projectors preserve chirality or a taste subspace uniformly
over all complexes; they do not remove the unwanted momentum copies.

#### F4b. Position-dependent pi-cocycle escape

The one remaining local escape is a projector that is onsite only in a twisted
frame.  A genuinely position-dependent fermionic two-cocycle can turn that
projector into a momentum-dependent operator in the physical frame.  The
minimal seed is the magnetic-translation relation

```text
T_x T_y = - T_y T_x,
```

where the sign is a nontrivial plaquette closure holonomy, not a global phase.
The focused Aristotle target `550cdd51` has now formalized this seed on a
finite periodic cell. The guard-pinned result proves a nonconstant x-dependent
phase, exact magnetic anticommutation, bijectivity, and a nonvacuous obstruction
to replacing the pair by commuting global-sign translations. Independent
Claude review accepted this exact scope. If the phase reduces to a
position-independent sign, the route is still killed immediately by F4a.

Even a successful pi-cocycle seed is insufficient.  The completed construction
must exhibit a nonzero, nonidentity Hermitian idempotent commuting with the
twisted walk and then prove a full reduced-zone zero- and pi-quasienergy census
with exactly the declared crossings and no others.

Aristotle project `cdcc00ba` completed the first decisive gate.  On the explicit
eight-site pi-flux cell, any operator commuting with two anticommuting magnetic
translations has every nonzero eigenspace at least two-dimensional.  This is a
finite-cell spectral theorem, not an infinite-lattice Brillouin-zone census.
It kills the exact-symmetry version of F4b: pi flux enforces a same-eigenvalue
partner rather than deleting it.  The project is continuing with the smallest
remaining escape, a gauge-covariant intertwiner that breaks naked translation
commutation while preserving a combined physical translation.

### F4c. Covering-map flavor reconstruction

The July 2026 revision of Bakircioglu, Arnault, and Arrighi,
arXiv:2505.07900v3, sharpens a route that should be treated on its own terms.
Their construction does not erase the cover: it turns the copies into an
explicit three-bit flavor register and lets spacetime translations act on that
register.  For this program, success would therefore mean reconstructing a
physical flavor multiplet with local interactions and the correct charge
commutant, not claiming a lone microscopic species.  The landed charge
obstruction shows that a naked regular deck action is insufficient; the next
gate is an explicit gauge-twisted charge intertwiner or a proof that none can
preserve the required locality and spectrum.

### F5. Decoder completeness

Prove that every microscopic crossing belongs to exactly one intended flavor,
that the continuum map is uniform on all eight sheets, and that no ninth
low-energy sector survives.  This replaces the old single-root certificate.

## Second lateral route: null microsteps, longer effective hops

The strict range-one obstruction constrains the **one-period Laurent symbol**.
It does not require us to abandon the ontological requirement that every
elementary propagation step be null.  A finite-depth circuit can be assembled
entirely from conditional nearest-neighbor null shifts and onsite unitary coins,
while its full-period effective operator contains degree-two and mixed-axis
Laurent words.  In spacetime language, no primitive hop exceeds the light cone;
in lattice-action language, the stroboscopic operator has the non-nearest-site
terms that may be needed to obtain the correct Dirac poles.

This is motivated by Kimura and Misumi, arXiv:0907.1371, whose hyperdiamond
analysis identifies non-nearest-site hopping as essential for Lorentz-covariant
minimal-doubling excitations.  It also respects the negative lesson of Bedaque,
Buchoff, Tiburzi, and Walker-Loud, arXiv:0804.1145: high lattice symmetry and
minimal doubling compete, so the symmetry and tuning cost must be recorded
rather than hidden.

The construction ladder is:

1. **N0, microcausality:** define a depth-two or depth-four circuit from exact
   null conditional shifts and onsite coins; prove each substep and the complete
   period unitary, and prove the depth-bounded causal cone.
2. **N1, escape witness:** expand the complete-period Fourier symbol and exhibit
   a nonzero mixed Laurent coefficient such as `exp(i(q_x+q_y))`.  This proves
   that the circuit genuinely leaves the degree-one factorized no-go class.
3. **N2, tangent gate:** solve the exact first-order conditions for one
   Lorentz-normalized Dirac tangent, including the correct Clifford
   anticommutators and mass channel.
4. **N2a, universal-gate audit:** instantiate every field of the repaired
   `AdmissibleWalk` interface. Extra range escapes the scoped factorized corner
   theorem but not a degree-agnostic topological balance theorem. If the
   complete-period walk remains admissible, predict that the partner is
   relocated rather than removed.
5. **N3, global census:** classify every solution of both
   `det(U(q)-I)=0` and `det(U(q)+I)=0` on the full Brillouin torus.  A sampled
   plot is not evidence; the target is an exact trigonometric/Laurent
   factorization or interval certificate.
6. **N4, naturalness audit:** identify every symmetry broken by the chosen
   coefficients and every counterterm allowed by the residual symmetry.  A
   finely tuned minimal pair is a construction result, not yet a natural
   microscopic law.

The key conceptual distinction is therefore:

```text
primitive locality = nearest-neighbor null support at every substep
effective range     = the larger Laurent support of one complete period
```

Conflating those two notions made the earlier search space unnecessarily small.
This route can be combined with F4b: a pi-flux cocycle may be inserted between
null substeps, giving mixed-axis effective words and a magnetic unit cell at the
same time.  The decisive near-term target is an explicit circuit that passes N0
and N1; only then are the N2a admissibility test and global N3 census worth the
cost.

## Parallel backup: boundary/cohomology decoder

If F3 fails, retain the broader lesson but change the decoder.  A strictly
local walk in an enlarged register can support a domain-wall or constrained
boundary sector whose effective 3+1 operator is not itself an unconstrained
finite Laurent symbol.  Quantum-walk domain-wall confinement in 3+1 has prior
art (Marquez-Martin, Di Molfetta, and Perez, arXiv:1612.08027).  The honest
cost is an auxiliary synthetic direction or a nonlocal physical projection.
That route should be pursued only with an explicit locality ledger separating
microscopic locality from decoded effective locality.

Recent curved-domain-wall work gives this backup a sharper interpretation.
Aoki, Fukaya, and Kan (arXiv:2402.09774 and arXiv:2502.03045) obtain a single
boundary Weyl sector in the free theory, but nontrivial gauge topology can
create an opposite-chirality mode in the bulk.  This is not a loophole that
deletes topological balance; it relocates the compensating content into anomaly
inflow.  A null-edge version would need an explicit synthetic direction,
boundary localization theorem, and bulk-plus-boundary charge audit.  It is a
promising resolution only if the ontology permits primitive null propagation
in the enlarged space and the observed `3+1` theory is a decoded boundary.

## Claim boundary

At present these are research routes, not a resolution.  F0 establishes a
nontrivial exact combinatorial bridge.  Only F3-F5, or an N0-N4 construction,
could justify saying that
3+1 doubling has been converted into physical particle content.  Until then,
the match between the eight cover sheets and eight octonion labels is a
high-value conjectural alignment with a pre-registered kill test.
