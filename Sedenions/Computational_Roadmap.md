# Computational Roadmap

This file lists the finite computations needed before any Lean theorem or
physics interpretation should be attempted.

## Phase 0: Conventions

Fix and document:

- basis labels `0..15` as `F_2^4`;
- Cayley-Dickson multiplication convention;
- sign convention for basis products;
- low/high split `a = (h,i)`;
- whether coordinates 0 and 8 are retained or punctured;
- what counts as a primitive signed zero-divisor direction.

Output:

```text
Sedenions/generated/conventions.json
```

Current executable reference:

```text
Scripts/sedenions/explore_zero_divisor_geometry.py
```

## Phase 1: Multiplication and Zero Divisors

Compute:

- full `16 x 16` product table;
- sign table `omega(a,b)`;
- all primitive zero-divisor diagonal combinations;
- 42 assessors;
- seven box-kites if recoverable from the table.

Output:

```text
Sedenions/generated/sedenion_product.json
Sedenions/generated/zero_divisors.json
```

Checks:

```text
number of primitive unit zero-divisor directions = 168
number of assessors = 42
number of box-kites = 7
```

## Phase 2: Affine-Plane Geometry

Compute:

- all affine 2-planes in `F_2^4`;
- all planes avoiding coordinates 0 and 8;
- the 63 mixed same-strut affine supports;
- the 42 mixed supports selected by signed zero-product equations;
- incidence between seed planes, assessors, and box-kites.

Output:

```text
Sedenions/generated/affine_planes.json
```

Checks:

```text
each zero-product support is an affine 2-plane
each zero-product support avoids 0 and 8
zero-product supports are a subset of same-strut supports
```

## Phase 3: Code Span

Build `C_ZD` as the binary span of the signed zero-product support
indicators.  Also compute the span of all 63 same-strut mixed affine supports
as a useful comparison object.

Compute:

- generator matrix;
- row-reduced generator matrix;
- dimension;
- weight enumerator;
- equality test with `{c in RM(2,4) : c_0 = c_8 = 0}`;
- punctured length-14 version and its dual.

Output:

```text
Sedenions/generated/c_zd_code.json
```

Expected checks:

```text
number of signed zero-product supports = 42
number of same-strut mixed affine supports = 63
dim C_ZD = 9
W_CZD(y) = 1 + 77 y^4 + 168 y^6 + 203 y^8 + 56 y^10 + 7 y^12
C_ZD = {c in RM(2,4) : c_0 = c_8 = 0}
span(42 zero-product supports) = span(63 same-strut supports)
```

## Phase 4: Signed Plaquettes

For each seed affine plane:

- compute the Cayley-Dickson signs in every zero-product relation;
- normalize signs up to global phase;
- determine whether the phase is linear/quadratic on the affine plane;
- record gauge transformations between sign conventions.

Output:

```text
Sedenions/generated/signed_plaquettes.json
```

## Phase 5: Stabilizer Tests

For each signed plaquette state:

- build the vector in `C^16`;
- enumerate 4-qubit Pauli stabilizers;
- extract stabilizer generators if present;
- compute Clifford orbit data.

Output:

```text
Sedenions/generated/stabilizer_plaquettes.json
```

## Phase 6: S3 and Group Actions

Implement:

- the naive Cayley-Dickson `S_3` action;
- the `Cl(8)` embedded `S_3` action if explicit formulas are available;
- `GL(3,2)` action on nonzero `F_2^3` struts.

Test preservation of:

- assessors;
- seed planes;
- `C_ZD`;
- signed plaquettes;
- stabilizer states;
- box-kite partition.

Output:

```text
Sedenions/generated/group_actions.json
```

## Phase 7: Lean Candidates

Only after the finite computations stabilize, promote the smallest facts to
Lean.  Good first theorem candidates:

```lean
-- all finite, no analysis
theorem seedPlane_is_affinePlane ...
theorem cZD_dim_eq_nine ...
theorem cZD_weightEnumerator ...
theorem cZD_eq_shortened_RM24 ...
```

Avoid starting with physics statements in Lean.  Formalize the finite algebra
first.

## Current Lean Coverage

The first two Aristotle waves have now moved a substantial part of this roadmap
from oracle-only computation into draft Lean under:

```text
PhysicsSM/Draft/Sedenions/
```

Currently integrated coverage:

- Phase 1: recursive Cayley-Dickson sign tables and basic sedenion identities;
- Phase 2: 42 zero-product supports, 63 same-strut supports, and the 42/21 split;
- Phase 3: `C_ZD`, its dimension, weight enumerator, and equality with the
  retained-coordinate shortening `{c in RM(2,4) : c_0 = c_8 = 0}`;
- Phase 4: cocycle/quadratic-phase separation of zero-product and extra
  same-strut supports;
- Phase 5: stabilizer certificates for all 42 zero-product plaquettes, plus
  the negative result that the naive `psi` action does not create magic in the
  finite support model;
- Phase 6: `GL(3,2)` transitivity, the `42 + 21` orbit split, sedenion sign
  gauge, and the collapse of the 42 plaquettes under `psi` to 7 partner-closed
  8-point supports;
- Phase 8 generation geometry: the cleaned `FanoComplementGeneration` module
  proves the `42 = 7 * 3 * 2` sector/matching picture and the induced full
  `S3` action on the three perfect matchings of a sector.

These modules remain draft-facing.  They are strong finite certificates, but
many use `native_decide`; publication-facing work should next separate
structural arguments from finite enumeration and remove duplicated helper
definitions where practical.

## Phase 8: Physics-Facing Moonshots

The next Aristotle wave is described in:

```text
Sedenions/Physics_Moonshot_Directions_2026-05-23.md
AgentTasks/sedenion-next-moonshots-aristotle-2026-05-23.md
```

The targets are deliberately ambitious.  They should be treated as finite
theorem searches first and as physics interpretations only after the Lean
statements are stable.  In priority order:

- classify the seven `psi`-coarsened Fano-complement sectors and their three
  perfect matchings;
- classify the affine symmetries preserving the zero-product geometry and the
  sign cocycle up to gauge;
- test whether the sign data admits a useful `ZMod 4` quadratic refinement;
- classify any honest CSS or stabilizer-code data extractable from `C_ZD` and
  its relatives;
- test explicit Barnes-Wall lattice candidates instead of assuming one;
- build finite toy charge and coupling classifications inspired by the
  sedenion `S_3` generation literature.

Several completed moonshots are now archived rather than integrated. See:

```text
Sedenions/Moonshot_Triage_2026-05-23.md
```

The two most productive completed jobs are the Fano-complement generation
geometry and the affine symmetry classification.  The generation geometry has
now been cleaned into `PhysicsSM/Draft/Sedenions/FanoComplementGeneration.lean`
and proves the finite sector story:

```text
42 zero-product plaquettes
  = 7 Fano-complement sectors
  * 3 perfect matchings per sector
  * 2 edges per matching
```

The affine symmetry classification still needs cleanup before default import,
but its archived certificate proves:

```text
affine preservers of the 42 zero-product supports: 336
affine preservers of C_ZD: 2688
```

The short version is that the `ZMod 4`/Kerdock, CSS-code extraction,
single-level Barnes-Wall Construction A, COG dynamics, and flavor/Yukawa toy
jobs returned useful finite certificates but mostly negative or noncentral
conclusions. They should guide future work, not inflate the default Lean import
graph.
