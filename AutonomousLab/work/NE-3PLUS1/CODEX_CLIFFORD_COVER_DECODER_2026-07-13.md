# Clifford-cover decoder: a representation-theoretic 3+1 route

Date: 2026-07-13
Owner: Codex, Visionary / Research Scientist / Skeptic
Status: theorem target prepared; physical intertwiner is the decisive gate

## Executive idea

The eight-sheet flavored-QCA repair should not first be identified with eight
particle species.  Its canonical mathematical home is the eight-dimensional
exterior algebra

```text
Lambda^*(C^3) = span{|S> : S subset {x,y,z}}.
```

The three sheet bits say whether an axis belongs to `S`.  The bare deck flips
toggle those bits and commute.  After inserting the fermionic ordering sign,
signed toggles become creation plus contraction operators

```text
c_j |S> = (-1)^(#{i in S : i < j}) |S symmetric_difference {j}>.
```

They square to one and anticommute for distinct axes.  Thus the regular
`Z2^3` cover admits a projective lift to a complex Clifford module once an
axis order and fermionic grading are supplied.  This is the finite
Dirac-Kahler structure suggested by the cover, not an `8 = 8` coincidence.

The word "projective" is load-bearing.  No fixed basis change turns the bare
commuting flips into anticommuting generators: simultaneous conjugation
preserves commutators.  The signed lift therefore changes the translation
architecture by a fermionic two-cocycle.  Equivalently, two flavor-axis moves
performed in opposite orders differ by a phase `-1`, a discrete pi closure
holonomy.  The route is viable only if that twist can be supplied by the
null-edge closure channel while preserving the intended causal locality and
continuum physics.

## Why this attacks the actual obstruction

The qubitized-Wilson route removes spatial zeros but leaves an ancillary
spectral partner and no demonstrated local physical projector.  The exterior
module has a nontrivial onsite commutant.  If the flavored walk is expressed
through the left Clifford action, primitive idempotents in the commuting
right action give momentum-independent onsite projectors.  Such a projector
would be strictly local and translation invariant by construction.

This does not silently evade Nielsen-Ninomiya.  The full eight-dimensional
register retains balancing sectors, while the projective translation law
explicitly changes a standard hypothesis.  The proposed gain is a local
decoder that can select an invariant continuum sector without deleting the
balancing content from the microscopic theory.  Whether the pi-flux twist
merely moves the doublers is a full-zone spectral question, not settled by
the Clifford relations.

## Theorem ladder

### DK0. Signed-cover Clifford relations

On functions on the eight sheets, define the signed bit flips `c_0,c_1,c_2`.
Prove exactly

```text
c_j^2 = I,
c_i c_j = -c_j c_i  (i != j).
```

Also prove the negative control: the unsigned deck flips commute, so the
fermionic sign is load-bearing.

### DK1. Exterior-basis equivalence

Construct an explicit unitary equivalence between sheet functions and the
occupation basis of `Lambda^*(C^3)`.  Intertwine `c_j` with wedge by `e_j`
plus contraction by `e_j`.  Reuse the sign convention of
`PhysicsSM/Spinor/SpinorTenfoldFock.lean`, specialized from five modes to
three; do not create a second incompatible fermionic convention.

### DK2. Local commutant projector

Construct the commuting right Clifford action.  Exhibit an explicit nonzero,
nonidentity Hermitian idempotent `P` of rank two or four such that

```text
P c_j = c_j P
```

for every spatial generator.  Prove the rank with an explicit rational or
Gaussian-rational basis witness.  This is the first genuinely new resource:
an onsite, momentum-independent candidate physical-sector projector.

### DK3. Actual flavored-walk intertwiner

First prove the no-conjugacy control: the commuting flavored shifts of
Bakircioglu-Arnault-Arrighi cannot become the signed Clifford shifts under one
onsite basis change.  Then define the genuinely cocycle-twisted update and
prove or refute

```text
P U_flavored(k) = U_flavored(k) P
```

for all momenta and masses in the intended regime.  The modified update must
retain exact unitarity and strict locality.  Record explicitly that ordinary
translation symmetry has become projective and identify the plaquette
holonomy.  A claim about the unchanged flavored QCA is forbidden.

### DK4. Reduced-zone spectral census

On `range P`, prove the full reduced-Brillouin-zone determinant census,
including zero and pi quasienergies.  Acceptance requires one intended
continuum sector per declared flavor and no undeclared crossing.  A tangent
calculation at the origin is not enough.

### DK5. Gauge and chirality gate

Test whether color, weak isospin, hypercharge, chirality, and conjugation
preserve `range P`.  The existing
`FlavorCoverChargeObstruction.deckInvariant_forces_constant` proves that the
bare regular deck action cannot itself carry nonconstant Standard Model
charges.  Therefore gauge data must act on an additional factor, twist the
deck action, or break the full deck symmetry.  Any particle interpretation
must state which option it uses.

## Fast kill conditions

1. Kill the decoder if every nontrivial onsite projector fails to commute with
   the cocycle-twisted walk.
2. Kill a single-sector claim if the reduced determinant retains an
   undeclared zero or pi crossing.
3. Kill the particle-multiplet interpretation if charges are assigned directly
   to the regular sheets while all deck translations remain symmetries.
4. Kill any novelty claim that presents the exterior/Dirac-Kahler taste
   interpretation as new; the project-specific question is whether it yields
   a local invariant decoder for this null-edge QCA.
5. Kill any claim that the signed lift is a basis rewrite of the bare deck
   action.  Commuting and anticommuting generator families are not conjugate.

## Relation to the octonion route

The octonion and exterior lifts are different signed refinements of the same
three-bit support law.  The exterior lift is associative and supplies a genuine
Clifford module, so it is the correct first target for dynamics and projectors.
The octonion Fano sign remains a later comparison target for internal particle
structure.  It must not be used to replace the DK3 spectral and intertwiner
tests.

## Closest prior architecture

Watterson's geometric discretization of Dirac-Kahler fermions
(`arXiv:0706.4385`) is much closer to this route than the octonion analogy.
It constructs exact chiral and flavor projections by adding aligned complexes;
simultaneous projection uses eight complexes and leaves one chiral flavor on
each.  Its load-bearing result is also a commutator statement: the discrete
flavor projector commutes with the Dirac-Kahler operator because that operator
maps the aligned complexes in the same way.

This is supporting architecture, not a solved import.  Watterson's complexes,
Hodge maps, and projectors are four-dimensional geometric-discretization
objects.  The present three-bit QCA cover and projective flavor translations
are different data.  DK3 must construct the actual null-edge/QCA operator and
prove its projector commutator directly.  The repository previously parked
the Dirac-Kahler analogy for exactly this reason; the new cover supplies a
concrete eight-component substrate, but not the missing intertwiner for free.

## Provenance boundary

The flavored cover and direct-space bit flips come from Bakircioglu, Arnault,
and Arrighi, arXiv:2505.07900v3, especially Secs. 4.2, 5.2, and 6.  Exact
multi-complex chiral/flavor projection is modeled on Watterson,
arXiv:0706.4385.  The creation-plus-contraction realization is standard
Dirac-Kahler/Chevalley spinor mathematics and is already represented in the
repository's trusted five-mode Fock layer.  The proposed composition into a
projectively translated local null-edge decoder is a project research
hypothesis, not yet a result.
