# Sedenion Research Status - 2026-05-23

This note records the current state of the sedenion zero-divisor program after
the first convention pass and finite computation.

## Convention Choice

The sedenion branch uses the recursive Cayley-Dickson convention documented in
`CayleyDickson_Convention.md`.

This is intentionally separate from the existing project octonion convention in
`PhysicsSM.Algebra.Octonion.Basic`.  The recursive convention is a better fit
for the sedenion research branch because the new `m` bit is added by the same
doubling rule that constructs:

```text
R -> C -> H -> O -> S.
```

Any future bridge to existing trusted octonion code must explicitly relabel
and sign-correct the basis.

## Verified by the Current Oracle Script

The executable reference is:

```text
python Scripts/sedenions/explore_zero_divisor_geometry.py
```

Current output supports the following finite claims:

```text
Fano sign-change flip patterns = 16
all Fano sign-change flip patterns satisfy the [7,4,3] Hamming checks

signed zero-product ordered pairs = 336
distinct four-point supports from signed zero products = 42

all same-strut mixed affine supports = 63
zero-product supports are a subset of same-strut supports
extra same-strut supports not selected by signs = 21

span(42 zero-product supports) has rank 9 and size 512
span(42 zero-product supports) = {c in RM(2,4) : c_0 = c_8 = 0}
weight enumerator = 1 + 77 y^4 + 168 y^6 + 203 y^8 + 56 y^10 + 7 y^12

span(63 same-strut supports) gives the same code
```

These are oracle computations only.  They are good Lean theorem targets but
not proofs.

## Interpretation

The core mathematical object is not merely a binary code.  The binary support
geometry forgets the Cayley-Dickson signs.  The signed structure should be
treated as a finite affine-plane system with a twisting cochain:

```text
e_a e_b = omega(a,b) e_(a+b),  omega(a,b) in {+1,-1}.
```

The unsigned code result gives the Reed-Muller/Barnes-Wall-adjacent shadow.
The signed cocycle is the part that may connect to quadratic phases, Kerdock
data, stabilizer states, and possible physics applications.

## Aristotle Wave

The next proof-agent wave should aim for draft Lean modules, not trusted
publication modules.  Each job should keep the new convention separate from
the existing octonion convention and should return the strongest sorry-free
finite theorem cluster it can.

Priority targets:

1. Fano orientations and Hamming flip checks.
2. Recursive Cayley-Dickson bit-sign table.
3. Signed zero-product support classification.
4. Reed-Muller code equality and weight enumerator.
5. Cocycle/quadratic-phase extraction.
6. Stabilizer plaquette tests.
7. GL(3,2)/PSL(2,7) action on supports and signs.
8. S3 generation-action orbit tests.

The last three are intentionally ambitious and may return partial scaffolds or
counterexamples.  That would still be useful.

## Integrated Aristotle Results

The first completed Aristotle wave has been integrated into draft Lean modules:

```text
PhysicsSM/Draft/Sedenions/CayleyDicksonSignTable.lean
PhysicsSM/Draft/Sedenions/ReedMullerCode.lean
PhysicsSM/Draft/Sedenions/CocycleQuadraticPhase.lean
PhysicsSM/Draft/Sedenions/StabilizerPlaquettes.lean
PhysicsSM/Draft/Sedenions/GL32Action.lean
PhysicsSM/Draft/Sedenions/S3PsiAction.lean
PhysicsSM/Draft/Sedenions/S3PsiActionAbstract.lean
```

These modules currently establish:

- the recursive Cayley-Dickson sign table and basic dimension-16 identities;
- the equality `C_ZD = {c in RM(2,4) : c_0 = c_8 = 0}`;
- the 9-dimensional span and weight enumerator;
- the 42/63/21 split between zero-product, same-strut, and extra supports;
- a finite cocycle obstruction separating zero-product plaquettes from the
  extra same-strut plaquettes;
- one representative signed plaquette as a 4-qubit stabilizer state;
- the GL(3,2) support action and sign-gauge tests returned by Aristotle;
- support-spreading results for the naive order-three S3 action.

They are intentionally imported through `PhysicsSMDraft.lean`, not the trusted
root.  The results are sorry-free but many are finite `native_decide`
certificates, so the next polishing step is to identify which claims deserve
structural proofs before any publication-facing Lean package is created.

## Integrated Physics-Moonshot Results

A second Aristotle wave has also been partially integrated.  The following
draft modules are now present:

```text
PhysicsSM/Draft/Sedenions/StabilizerMagicMoonshot.lean
PhysicsSM/Draft/Sedenions/GenerationCancellationGeometry.lean
PhysicsSM/Draft/Sedenions/PSL27FlavorGeometry.lean
PhysicsSM/Draft/Sedenions/FanoComplementGeneration.lean
PhysicsSM/Draft/Sedenions/AnomalyCancellationAnalogue.lean
PhysicsSM/Draft/Sedenions/BarnesWallFirstShell.lean
```

The most important mathematical updates are:

- all 42 zero-product plaquettes now have finite stabilizer certificates;
- the naive order-three `psi` action does not generate magic in this finite
  model: it maps 4-point affine stabilizer plaquettes to 8-point affine
  stabilizer-like supports;
- those 42 supports collapse under `psi` into exactly 7 partner-closed supports,
  each containing 6 of the original zero-product supports;
- the seven partner-closed sectors carry a clean matching geometry:
  `42 = 7 * 3 * 2`, with three perfect matchings per sector and an induced
  full `S3` action on those matchings;
- `GL(3,2)` is transitive on the 42 zero-product supports and splits the 63
  same-strut supports into the `42 + 21` zero-product/sign-obstructed orbits;
- the sign cocycle is not globally fixed, but is preserved up to a
  sedenion-level gauge;
- the finite anomaly analogue identifies the dual charge space as
  `C_ZD^perp = RM(1,4) + span(e0,e8)`;
- the Barnes-Wall result is currently a first-shell candidate theorem in the
  Reed-Muller coding ecosystem, not a full Barnes-Wall lattice construction.

These results sharpen the physics story.  The naive `psi -> magic` hypothesis
is false in the current finite support model, but the replacement structure is
cleaner than expected: `psi` coarsens the 42 plaquettes into a 7-fold
Fano-complement geometry, and each sector has a canonical three-matching
structure that supplies a finite candidate generation geometry.
