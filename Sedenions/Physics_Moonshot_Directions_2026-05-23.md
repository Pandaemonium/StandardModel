# Physics Moonshot Directions - 2026-05-23

This note distills the next research targets after the first two sedenion
Aristotle waves.

The current Lean results support a sharper story than the original proposal:

```text
sedenion zero divisors
  -> signed affine 2-plane plaquettes in F2^4
  -> a shortened RM(2,4) code C_ZD
  -> stabilizer-state certificates
  -> GL(3,2) / PSL(2,7)-equivariant signed geometry
  -> seven psi-coarsened Fano-complement sectors
```

The naive Cayley-Dickson order-three `psi` action does not generate magic in the
finite support model.  It maps the 42 four-point plaquettes to 7 partner-closed
eight-point supports.  That negative result is useful: it moves the next
physics question away from vague magic and toward a concrete finite
generation-sector geometry.

## 1. Fano-Complement Generation Geometry

The most promising immediate theorem target is:

```text
42 zero-product plaquettes
  -> under psi
7 Fano-complement sectors
  each containing 6 plaquettes
```

Each sector is controlled by a 4-point complement of a Fano line.  The 6
plaquettes in the sector should behave like the 6 edges of a tetrahedron on
those 4 points.  The three ways to partition those 6 edges into two disjoint
opposite pairs form a natural 3-element set.

This gives a finite, testable `S3` target:

```text
stabilizer of a Fano-complement sector
  acts on the three perfect matchings of K4
```

If true, this is the cleanest mathematical bridge to generation language:
three generation labels would arise as the three perfect matchings inside each
coarsened sector, rather than from a visual "box-kite has three pairs" analogy.

Triage update: Aristotle job `234f49d7-4495-4257-8419-8f2fe4fa628b` proved
this finite picture, and it has been cleaned into
`PhysicsSM.Draft.Sedenions.FanoComplementGeneration`.  In the canonical sector
the six zero-product plaquettes are the six edges of the four-point Fano
complement, those edges have exactly three perfect matchings, and the
`GL(3,2)` sector stabilizer induces all six permutations of the three
matchings.  This is the strongest current candidate for a finite `S3`
generation geometry.

## 2. Full Finite Symmetry Classification

The current `GL(3,2)` action is natural, but it may not be the full finite
symmetry of the 42-plaquette geometry.

The next finite classification should test affine maps of `F2^4` that preserve:

- the forced coordinates 0 and 8;
- the low/high partner relation;
- the 42 zero-product supports;
- the 63 same-strut supports;
- the sign cocycle up to gauge;
- the code `C_ZD`.

The outcome will tell us whether the `PSL(2,7)` story is the full symmetry or
only a visible subgroup.

Triage update: Aristotle job `054fca4d-e5ed-401e-9ad4-b237b310c2c7` returned
a complete affine classification.  The 42 zero-product supports have 336
affine preservers: the 168 lifted `GL(3,2)` maps and their translates by the
partner swap `x |-> x xor 8`.  The code `C_ZD` has 2688 affine preservers, so
the code symmetry is strictly larger by a factor of 8.

## 3. Z4 / Kerdock Quadratic Refinement

The unsigned code is not enough.  The signs are the real information.

The target is:

```text
Cayley-Dickson signs on plaquettes
  -> Z4-valued quadratic phase
  -> possible Kerdock / Barnes-Wall refinement
```

This is supported by the stabilizer literature: stabilizer states can be written
using affine supports and quadratic phases over binary vector spaces, and
Kerdock codewords can be exponentiated to stabilizer states.  We should test
whether the 168 signed plaquettes are restrictions of a small family of Z4
quadratic forms.

Triage update: Aristotle job `5f9aa81f-2ac7-4939-b95f-eae61d2ed792` returned a
sorry-free finite certificate showing that the raw sign system is too free to
produce a nontrivial Kerdock-style refinement. This is archived in
`Sedenions/Moonshot_Triage_2026-05-23.md`; do not integrate the long-running
module unless a later argument needs a specific theorem from it.

## 4. Quantum Code Extraction

We should not claim `C_ZD` is a quantum code.  The right next theorem is a
classification:

```text
Which CSS or stabilizer-code data can be extracted from C_ZD,
C_ZD^perp, RM(1,4), shortened variants, or punctured variants?
```

The expected result may be negative for `C_ZD` itself, but there may be useful
subcodes or quotient codes.

Triage update: Aristotle job `eb44bb5f-4b80-4a78-b62a-eb452469d219` returned a
sorry-free negative classification for the natural CSS-code family. The result
supports the conservative interpretation that the plaquettes are stabilizer
states, not code checks.

## 5. Barnes-Wall Lattice Construction Attempt

The current Barnes-Wall theorem is a first-shell candidate theorem, not a
lattice construction.  The next attempt should explicitly define one or more
lattice candidates:

- Construction A from `C_ZD`;
- a Construction D proxy from the Reed-Muller chain;
- a signed or Z4-lifted lattice candidate.

Then prove or refute:

- evenness;
- determinant;
- minimum norm;
- membership of the 168 signed plaquettes in the first shell;
- comparison to the standard `Lambda_16` / Barnes-Wall model.

Triage update: Aristotle job `bad19390-88b1-4208-b2b7-01eb4392a2f7`
returned a sorry-free finite certificate ruling out the two simplest
Construction A shortcuts.  Construction A from `C_ZD` has index `128`, and
Construction A from full `RM(2,4)` has index `32`, so neither matches the
naive `BW16` index target `16`.  The plausible positive route is now a genuine
multilevel Construction D formalization, a signed `ZMod 4` lift, or direct
comparison with an explicit Barnes-Wall model.

## 6. Flavor Charge and Yukawa Toy Models

Recent `Cl(10)` work with `S3` family symmetry now includes electroweak charges
and, in a newer 2026 preprint, a Higgs/Yukawa sector organized by `S3` orbits.
Our finite analogue should stay modest:

```text
dual charge space C_ZD^perp
  + GL(3,2) / sector symmetry constraints
  + low/high balance
  -> classified charge bases and toy coupling matrices
```

The goal is not to recover Standard Model hypercharge.  The goal is to test
whether the same finite geometry naturally produces family-universal charges,
family-sector mixing, or Type-II-like channel separation in a toy model.

Triage update: Aristotle job `57a5bceb-a551-4184-9220-71ec8f403909` returned a
sorry-free toy classification, but the conclusion is mainly that the raw finite
symmetry forces democratic couplings rather than flavor hierarchy. This is
useful evidence, but not a default integration target.

## Source Anchors

- de Marrais, `The 42 Assessors and the Box-Kites they fly`,
  arXiv:math/0011260.
- Dehaene and De Moor, `The Clifford group, stabilizer states, and linear and
  quadratic operations over GF(2)`, arXiv:quant-ph/0304125.
- Nebe, Rains, and Sloane, `The invariants of the Clifford groups`,
  arXiv:math/0001038.
- Kliuchnikov and Schoennenbeck, `Stabilizer operators and Barnes-Wall
  lattices`, arXiv:2404.17677.
- Can, Rengaswamy, Calderbank, and Pfister, `Kerdock Codes Determine Unitary
  2-Designs`.
- Gresnigt, Gourlay, and Varma, `Three generations of colored fermions with
  S3 family symmetry from Cayley-Dickson sedenions`, arXiv:2306.13098.
- Gourlay and Gresnigt, `Algebraic realisation of three fermion generations
  with S3 family and unbroken gauge symmetry from C ell(8)`, arXiv:2407.01580.
- Gresnigt, `Electroweak Structure and Three Fermion Generations in Clifford
  Algebra with S3 Family Symmetry`, arXiv:2601.07857.
- Gresnigt, `Higgs Sector and Flavour Structure in an Algebraic
  Three-Generation Model with S3 Family Symmetry`, arXiv:2604.24795.
