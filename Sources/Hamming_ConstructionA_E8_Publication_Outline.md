# Publication outline: Hamming code to Construction A to E8

## Working title

From the Extended Hamming Code to the E8 Sphere Packing in Lean

Alternative titles:

- A Construction A Bridge to the Formalized E8 Sphere Packing
- Coding Theory as a Front Door to E8 in Lean
- From the [8,4,4] Code to Viazovska's E8 Packing Theorem

## Core thesis

This project can make a publishable contribution by formalizing a clean
coding-theoretic route to the E8 lattice and connecting it to the existing Lean
formalization of the E8 sphere packing theorem.

The published Sphere-Packing-Lean project formalizes the hard analytic endpoint:
Viazovska's proof that the E8 lattice gives the optimal sphere packing in
dimension 8. Our contribution should be complementary. We formalize the
finite/combinatorial entrance to E8:

1. the extended binary Hamming code,
2. Construction A over `ZMod 2`,
3. the resulting integer lattice,
4. its minimum norm and shortest-vector structure,
5. a bridge theorem identifying this Construction A lattice with the E8 lattice
   used by Sphere-Packing-Lean, up to the documented normalization.

The strongest version of the paper would end with a Lean theorem saying that
our code-built lattice is the same object, or isometric to the same object, as
the `E8` lattice whose packing density is proved optimal in Sphere-Packing-Lean.

## Literature review synthesis

The literature supports a strong but carefully bounded paper. The paper should
not be pitched as a new sphere-packing proof. It should be pitched as the
formal coding-theory entrance to the already formalized E8 sphere-packing
story.

### Classical code-to-lattice route

The classical path is well established:

```text
Hamming [7,4,3]
  -> extended Hamming [8,4,4]
  -> Type II binary self-dual code
  -> Construction A lattice
  -> E8
```

The Error Correction Zoo records the extended `[8,4,4]` Hamming code as the
smallest doubly even self-dual code and the unique Type II code of length 8. It
also records the standard fact that this code yields the E8 Gosset lattice via
Construction A.

The Nebe-Sloane Catalogue of Lattices gives a particularly useful formalization
target: an explicit coding-theory version of E8, with a basis and Gram matrix,
and the note "apply Construction A to the [8,4,4] Hamming code." This is exactly
the kind of finite data we can turn into Lean declarations and compare against
our parity-check definition.

For the paper, the classical source backbone should be:

- Hamming, "Error Detecting and Error Correcting Codes" (1950), for the
  historical code family.
- MacWilliams and Sloane, *The Theory of Error-Correcting Codes*, for coding
  theory background.
- Conway and Sloane, *Sphere Packings, Lattices and Groups*, for Construction A
  and the E8 lattice.
- Huffman and Pless, *Fundamentals of Error-Correcting Codes*, for modern code
  notation and self-dual code background.
- The Error Correction Zoo and Nebe-Sloane catalogue as convenient public
  cross-checks for parameters, generator matrices, and the E8 relationship.

### Sphere packing and optimization route

The analytic E8 story has a separate lineage:

```text
Cohn-Elkies linear programming bounds
  -> Viazovska magic function for dimension 8
  -> optimality of the E8 lattice packing
  -> Cohn-Kumar-Miller-Radchenko-Viazovska dimension 24 result
  -> universal optimality of E8 and the Leech lattice
```

Cohn and Elkies developed the linear-programming framework and conjectured that
it could solve dimensions 8 and 24. Viazovska then proved optimality of E8 in
dimension 8 using modular and quasimodular forms. The 24-dimensional Leech
lattice result followed soon after. The later universal optimality theorem
shows that E8 and the Leech lattice minimize a broad class of energies, not just
sphere-packing density.

For our paper, this literature is endpoint context. The formal work we should
claim is not the construction of the magic function. It is the formal bridge
showing that a code-built E8 lattice is the lattice to which the magic-function
theorem applies.

### Formalization landscape

There are now two especially relevant Lean-adjacent results.

First, Sphere-Packing-Lean formalizes Viazovska's dimension-8 theorem in Lean 4.
Its blueprint explicitly separates the E8 lattice, the E8 sphere packing, the
Cohn-Elkies bound, Fourier analysis, and modular forms. The 2026 "Milestone in
Formalization" paper reports that the dimension-8 result was formally verified,
with the final stages completed using Math, Inc.'s Gauss system.

Second, Baek and Kim's 2026 paper formalizes algebraic cores of self-dual code
building-up constructions in Lean 4. This is adjacent rather than identical:
their focus is self-dual code construction machinery, while our proposed paper
is a code-to-lattice bridge ending at E8.

The gap is therefore quite crisp:

```text
mathlib/code infrastructure and self-dual-code formalization
  -> explicit extended binary Hamming code in this repo
  -> Construction A in this repo
  -> E8 lattice equivalence
  -> Sphere-Packing-Lean E8 endpoint
```

This is a meaningful publication niche because it connects independently
formalized finite combinatorics to independently formalized discrete geometry.

### Physics and string-theory motivation

Mizoguchi and Oikawa's 2026 work on error-correcting codes and heterotic Narain
CFTs is useful motivation. They study Construction A code lattices for heterotic
strings and identify binary-code data that produces Narain lattices for both
`E8 x E8` and `Spin(32) / Z2` heterotic theories.

That does not mean our paper should claim a formalized heterotic string. It
does mean a short motivation paragraph can honestly say the Hamming/Construction
A/E8 bridge is not only a lattice-theory curiosity: it is also part of the
modern code-lattice language used around heterotic compactifications.

### Equivalent E8 models worth connecting

The literature gives several equivalent E8 presentations:

- Construction A from the extended Hamming code.
- The half-integer description `Z^8 union (Z + 1/2)^8` with an even-sum
  condition.
- A basis/Gram matrix presentation.
- The 240-root presentation.
- The integral-octonion presentation.
- Tetracode and octacode variants.

The paper becomes much stronger if we connect more than one of these models in
Lean. The most publication-efficient route is:

```text
Construction A Hamming model
  -> explicit basis and Gram matrix
  -> 240-root list
  -> Sphere-Packing-Lean E8 model
```

The integral-octonion root list already in this repository is a major advantage:
it lets the paper say something beyond "we built a lattice." It lets us connect
the code construction to an exceptional-algebraic root enumeration.

## Current kernel-checked island in this repository

The following declarations are already natural anchors for the paper.
The current Lean code should be described as a Construction A theorem island,
not yet as a completed E8 identification.

In `PhysicsSM.Coding.ConstructionA`:

- `BinaryVector`
- `BinaryLinearCode`
- `hammingWeight`
- `IsDoublyEven`
- `reduceModTwo`
- `constructionA`
- `mem_constructionA_iff`
- `even_vector_mem_constructionA`
- `sqNorm`
- `sqNorm_nonneg`
- `sqNorm_eq_zero_iff`
- `sqNorm_ge_weight`
- `sqNorm_ge_four_of_all_even`
- `constructionA_sqNorm_ge_four`

In `PhysicsSM.Coding.HammingE8`:

- `extendedHamming8ParityCheck`
- `extendedHamming8`
- `extendedHamming8_card`
- `extendedHamming8_minWeight`
- `extendedHamming8_doublyEven`
- `hammingConstructionALattice`
- `e8IntLattice` (compatibility abbreviation; not a proved E8 identification)
- `mem_e8IntLattice_iff`
- `mem_e8IntLattice_iff_parityCheck`
- `e8IntLattice_sqNorm_ge_four`
- `e8IntLattice_achieves_sqNorm_four`
- `e8IntLattice_minSqNorm`

In `PhysicsSM.Algebra.Octonion.IntegralOctonion`, especially the
`E8Root` namespace:

- `normSqD`
- `dotD`
- `IsE8RootD`
- `type1Roots`
- `type2Roots`
- `rootList`
- `rootList_length`
- `rootList_nodup`
- `rootList_all_isE8RootD`
- `rootList_complete`
- `normSqD_eq_8`
- `dotD_values_distinct`
- `toOctonion`
- `normSq_toOctonion`

The current strongest local statement is:

```lean
theorem e8IntLattice_minSqNorm :
    -- Schematic ASCII rendering of the proved Lean theorem:
    -- every nonzero v in e8IntLattice has 4 <= sqNorm v,
    -- and some nonzero v in e8IntLattice has sqNorm v = 4.
```

This proves the integer Construction A model has minimum squared norm 4. After
the standard scaling by `1 / sqrt 2`, this corresponds to E8 roots of squared
norm 2. This theorem alone does not identify the subgroup as E8.

## Peer-review guardrails

The current draft should explicitly separate proved facts from E8-facing
targets:

- Proved: the extended Hamming parity-check code has 16 codewords, minimum
  weight at least 4, and is doubly even.
- Proved: Construction A for this code is an additive subgroup of `Z^8`.
- Proved: every nonzero vector in that subgroup has squared norm at least 4,
  and one vector attains squared norm 4.
- Not yet proved: code self-duality.
- Not yet proved: full-rank geometric lattice packaging.
- Not yet proved: evenness/unimodularity after scaling.
- Not yet proved: a Gram matrix comparison with E8.
- Not yet proved: exactly 240 minimal vectors.
- Not yet proved: equivalence with the integral-octonion `E8Root.rootList`.
- Not yet proved: any import-level bridge to Sphere-Packing-Lean.

The paper should not use the phrase "the E8 lattice" for the Construction A
object until one of the bridge theorems is kernel-checked. Safer phrases are:

- "the Hamming Construction A subgroup";
- "the unscaled Construction A model";
- "the standard code-theoretic E8 candidate";
- "the object classically identified with E8 after scaling."

The finite enumeration theorems currently use `native_decide`. This is fine for
small finite searches, but the paper must acknowledge the resulting
`trustCompiler` dependency or replace those proofs with kernel-normalized
certificates.

## Relationship to Sphere-Packing-Lean

The Sphere-Packing-Lean blueprint and repository describe a Lean 4
formalization of the dimension 8 sphere packing theorem. Their theorem states,
in the relevant normalization, that any packing of unit balls in `R^8` has
density at most `pi^4 / 384`, and that equality is attained by the E8 lattice
packing.

For this project, the publication bridge should not attempt to reprove
Viazovska's analytic theorem. Instead, it should show that the E8 lattice built
from the extended Hamming code by Construction A agrees with the E8 lattice used
in Sphere-Packing-Lean. That turns their deep density theorem into an endpoint
for our coding-theoretic construction.

Expected bridge theorem, modulo exact names in Sphere-Packing-Lean:

```lean
theorem e8CodeLattice_equiv_spherePackingE8 :
    IsometryEquiv
      (scaledE8CodeLattice : Submodule Zspan (EuclideanSpace Real (Fin 8)))
      SpherePacking.Submodule.E8
```

The exact type will almost certainly differ. The point is the mathematical
target: an explicitly normalized isometry, equality of submodules after a
coordinate change, or equality of Gram matrices against their `E8Matrix`.

## Proposed paper structure

### 1. Introduction

Motivate the formalization as a bridge between three traditions:

- classical coding theory,
- exceptional lattice theory,
- modern formalized sphere packing.

State the main contribution carefully:

- We do not formalize a new proof of the E8 optimal packing theorem.
- We formalize an independent Construction A route to E8.
- We connect that route to the already formalized E8 lattice used in the
  sphere-packing proof.

### 2. Related work

Separate the related work into four streams:

- coding theory and Construction A;
- E8 lattices, roots, and equivalent models;
- sphere packing and universal optimality;
- Lean formalization of codes and sphere packing.

The key rhetorical move is to say that the paper fills the missing
formalization bridge between the finite-code stream and the E8 formalized
sphere-packing stream.

### 3. Mathematical background

Cover only the ingredients needed by the formalization:

- binary linear codes over `F_2`,
- the extended Hamming `[8,4,4]` code,
- Construction A,
- the standard normalization of the E8 lattice,
- minimum norm, kissing number, unimodularity, and density.

This section should include a normalization table:

| Object | Integer model | Scaled E8 model |
| --- | --- | --- |
| Ambient coordinates | `Z^8` | `R^8` |
| Membership | parity class in Hamming code | scaled image |
| Root squared norm | `4` | `2` |
| Scaling | identity | `1 / sqrt 2` |

### 4. Construction A in Lean

Describe the reusable formalization:

- `BinaryVector n := Fin n -> ZMod 2`
- `BinaryLinearCode n := Submodule (ZMod 2) (BinaryVector n)`
- reduction modulo 2 from integer vectors,
- Construction A as an additive subgroup of integer vectors,
- squared norm as a finite sum of integer squares.

The main reusable theorem should be:

```lean
theorem constructionA_sqNorm_ge_four
```

This is the first general theorem: a nonzero vector in Construction A has
squared norm at least 4 when the code has minimum Hamming weight at least 4 and
all codewords are doubly even.

### 5. The extended Hamming code

Formalize the parity-check matrix and derive:

- cardinality `16`,
- minimum Hamming weight at least `4`,
- doubly evenness,
- self-duality,
- Type II status,
- explicit membership criterion.

The key presentation theorem is:

```lean
theorem e8IntLattice_minSqNorm
```

This is a compact and satisfying kernel-checked theorem: the Hamming code
constructs an integer lattice with minimum squared norm exactly 4.

### 6. Type II to even unimodular Construction A

The literature suggests adding a reusable theorem before specializing fully to
E8:

```lean
theorem constructionA_even_unimodular_of_typeII :
    -- Schematic:
    -- if C is a binary Type II self-dual code, then
    -- the scaled Construction A lattice associated to C is even and unimodular.
```

This theorem is broader than the Hamming code and would make the paper valuable
to formalized coding theory, not just to E8.

For the `[8,4,4]` Hamming code, it specializes to the E8 lattice because there
is only one even unimodular positive-definite lattice of rank 8 up to isometry.
If that uniqueness theorem is unavailable in Lean, the paper should use the
constructive basis/Gram matrix route instead.

### 7. Short vectors and the 240-root theorem

This is the first major upgrade that would make the paper much more impressive.

Target theorem:

```lean
theorem e8IntLattice_shortVectors_card :
    -- Schematic:
    -- exactly 240 integer vectors in e8IntLattice have sqNorm = 4.
```

Likely route:

1. classify the vectors in `Z^8` with squared norm `4`;
2. split into shape `(+/-2,0,...,0)` and shape
   `(+/-1,+/-1,+/-1,+/-1,0,0,0,0)`;
3. impose the extended Hamming parity condition;
4. connect the resulting list to `E8Root.rootList`;
5. reuse `rootList_length`, `rootList_nodup`, and `rootList_complete`.

This theorem would give a kernel-checked Construction A explanation of the
E8 kissing number `240`, before importing any sphere-packing analysis.

### 8. Basis and Gram matrix bridge

This is the most important bridge section for connecting to
Sphere-Packing-Lean.

Target theorem:

```lean
theorem e8CodeLattice_gram_eq_E8Matrix :
    gramMatrix e8CodeLatticeBasis = SpherePacking.E8Matrix
```

or, if the Sphere-Packing-Lean names and normalizations differ:

```lean
theorem e8CodeLattice_gram_eq_cartanE8 :
    gramMatrix e8CodeLatticeBasis = Matrix.E8.cartanGram
```

The proof plan:

1. choose an explicit basis of the Construction A lattice;
2. prove every basis vector is in `e8IntLattice`;
3. prove the basis spans `e8IntLattice`;
4. compute the integer Gram matrix;
5. compare with the E8 matrix used downstream;
6. scale by `1 / sqrt 2` if the target lattice has root norm 2.

This section is the best place to demonstrate proof engineering value: the
paper can show how a finite parity-check definition becomes a lattice basis
recognized by an independent formalization.

### 9. Half-integer E8 bridge

Sphere-Packing-Lean's blueprint describes an E8 definition using integer or
half-integer coordinates with an even-sum condition, as well as a basis
definition. That suggests a second, perhaps easier, bridge theorem:

```lean
theorem scaledE8CodeLattice_eq_halfIntegerE8 :
    -- Schematic:
    -- the scaled Construction A Hamming lattice equals the
    -- half-integer even-sum E8 coordinate set.
```

This may be easier than importing all packing infrastructure. Once this is
proved, a basis comparison can target the exact Sphere-Packing-Lean definition.

### 10. Unimodularity and evenness

Ambitious but valuable theorem package:

```lean
theorem e8CodeLattice_even :
    -- Schematic:
    -- every vector in the scaled lattice has even norm.

theorem e8CodeLattice_unimodular :
    covolume scaledE8CodeLattice = 1
```

If covolume infrastructure is hard, use determinant first:

```lean
theorem e8CodeLattice_gram_det :
    Matrix.det (gramMatrix e8CodeLatticeBasis) = 1
```

Evenness plus unimodularity plus rank 8 is a strong mathematical package and
makes the formalization recognizably about E8, not merely a code with a norm
bound.

### 11. Bridge to the formalized packing theorem

The strongest publication endpoint:

```lean
theorem hammingConstructionA_attains_E8_packing_density :
    packingDensity (packingFromLattice scaledE8CodeLattice) = pi ^ 4 / 384
```

This should be proved by transporting Sphere-Packing-Lean's E8 packing theorem
across the bridge theorem, not by reproving the analytic part.

Possible statement levels:

1. equality of Gram matrices,
2. linear isometry between lattices,
3. equality of lattice-generated packings,
4. equality of packing densities,
5. optimality of the Hamming/Construction A packing.

The paper should present these as a ladder. Even reaching level 2 would be
publishable. Reaching level 5 would be exceptional.

### 12. Lessons for Lean formalization

Discuss:

- how to keep finite coding theory and real Euclidean geometry connected;
- why normalization must be explicit;
- how to reuse major formalized results without duplicating them;
- how local finite calculations feed global geometric theorems;
- how agent-assisted proof work was reviewed through the Lean kernel.

## Additional theorem targets for an impressive publication

### Target triage from expanded peer review

The following target choices keep the paper ambitious without scattering effort
away from the central Hamming -> Construction A -> E8 bridge.

Immediate targets already queued with Aristotle:

- Self-duality and Type II status of the extended Hamming code.
- Scaling the Construction A subgroup to the E8 root norm convention.
- Explicit basis and Gram matrix comparison.
- 240 shortest vectors and the bridge to `E8Root.rootList`.
- Half-integer coordinate bridge toward Sphere-Packing-Lean.
- Evenness/full-rank precursor facts and a `native_decide` certificate audit.

Good new near-term targets:

- Weight enumerator of the extended Hamming code:
  `W(x,y) = x^8 + 14*x^4*y^4 + y^8`.
- A concrete MacWilliams identity check for the extended Hamming code, even if
  the fully general Fourier-transform theorem is postponed.
- Code equivalence/permutation-action API, with `[8,4,4]` uniqueness as an
  ambitious stretch.
- Weyl reflections on the 240-root list, with Weyl group order as a stretch.

Targets to defer until the E8 bridge lands:

- Full Type II code -> even unimodular lattice theorem, unless developed as a
  scaffold around the concrete E8 basis/Gram results.
- Abstract uniqueness of rank-8 even unimodular lattices. The explicit Gram
  matrix bridge is the practical route for this paper.
- Golay -> Leech Construction A. This is an excellent sequel once the E8 case
  is structurally complete.
- Theta-series identity `Theta_E8 = E4` and MacWilliams-theta duality. These
  are landmark long-term targets, but they require modular-forms/theta-series
  infrastructure beyond the current paper's spine.
- Narain lattice physics. Keep as motivation until the finite code/lattice
  results are stable.

### Target A: scaled embedding

```lean
def scaledE8CodeLattice : AddSubgroup (EuclideanSpace Real (Fin 8))

theorem scaledE8CodeLattice_minSqNorm_two :
    -- Schematic:
    -- every nonzero vector has squared norm at least 2,
    -- and some nonzero vector has squared norm exactly 2.
```

Value: closes the normalization gap between the integer code lattice and the
standard E8 root normalization.

### Target B: explicit Construction A basis

```lean
def e8CodeLatticeBasis : Fin 8 -> Fin 8 -> Int

theorem e8CodeLatticeBasis_mem :
    -- Schematic:
    -- every basis vector is a member of e8IntLattice.

theorem e8CodeLatticeBasis_spans :
    AddSubgroup.closure (Set.range e8CodeLatticeBasis) = e8IntLattice
```

Value: turns membership-by-parity into a conventional lattice presentation.

### Target C: Gram matrix comparison

```lean
theorem e8CodeLatticeBasis_gram :
    gramMatrix e8CodeLatticeBasis = expectedE8Gram
```

Value: gives the cleanest bridge to existing E8 lattice formalizations.

### Target D: 240 minimal vectors

```lean
theorem e8CodeLattice_minimalVectors_card :
    Fintype.card (minimalVectors scaledE8CodeLattice) = 240
```

Value: proves the E8 kissing number from the code construction.

### Target E: root list equivalence

```lean
theorem e8CodeLattice_minimalVectors_eq_rootList :
    minimalVectors scaledE8CodeLattice = E8Root.rootListAsEuclideanVectors
```

Value: connects the code lattice to the integral-octonion root list already in
the repository.

### Target F: Sphere-Packing-Lean equivalence

```lean
theorem scaledE8CodeLattice_eq_spherePackingE8 :
    scaledE8CodeLattice = SpherePacking.Submodule.E8
```

or:

```lean
theorem scaledE8CodeLattice_isometric_spherePackingE8 :
    -- Schematic:
    -- there is a real linear isometry between the two lattice models.
```

Value: makes the paper directly interoperable with the formalized sphere
packing theorem.

### Target G: transported density theorem

```lean
theorem hammingConstructionA_density_optimal :
    IsOptimalSpherePacking (packingFromLattice scaledE8CodeLattice)
```

Value: the headline result. The Hamming code, through Construction A, gives the
optimal packing in dimension 8 because it is E8.

### Target H: Type II package

```lean
theorem extendedHamming8_selfDual :
    -- Schematic:
    -- extendedHamming8 is equal to its dual code.

theorem extendedHamming8_typeII :
    -- Schematic:
    -- extendedHamming8 is self-dual and doubly even.

theorem constructionA_of_typeII_even_unimodular :
    -- Schematic:
    -- Construction A sends binary Type II codes to even unimodular lattices.
```

Value: aligns the formalization with the standard coding-theory theorem, and
makes the Hamming result an instance of a reusable theorem.

### Target I: half-integer coordinate equivalence

```lean
theorem scaledE8CodeLattice_eq_halfIntegerEvenSum :
    -- Schematic:
    -- scaled Construction A from extendedHamming8 equals the usual
    -- half-integer/integer even-sum coordinate model of E8.
```

Value: likely the shortest path to Sphere-Packing-Lean, because its blueprint
uses this coordinate model as one of its E8 definitions.

## Aristotle job plan

### Job 1: scaling and minimum norm 2

Goal: define the real/scaled image of `e8IntLattice` and prove the minimum
squared norm becomes 2 after scaling by `1 / sqrt 2`.

Expected output:

- a focused Lean file or patch;
- proof of `scaledE8CodeLattice_minSqNorm_two`;
- comments documenting normalization.

### Job 1b: Hamming self-duality and Type II status

Goal: prove `extendedHamming8_selfDual` and package the already proved
doubly-even theorem into a Type II declaration.

Expected output:

- a code-dual definition compatible with the current `BinaryLinearCode`;
- `extendedHamming8_selfDual`;
- `extendedHamming8_typeII`;
- notes on compatibility with mathlib's Hamming-distance API.

### Job 2: explicit basis and membership

Goal: propose an explicit 8-vector basis for the Construction A lattice and
prove each basis vector lies in `e8IntLattice`.

Expected output:

- `e8CodeLatticeBasis`;
- `e8CodeLatticeBasis_mem`;
- a candidate spanning theorem, even if left as a documented draft proof.

### Job 3: Gram matrix computation

Goal: compute the Gram matrix of the explicit basis and compare it to a local
E8 Gram matrix declaration.

Expected output:

- `expectedE8Gram`;
- `e8CodeLatticeBasis_gram`;
- determinant theorem if feasible.

### Job 4: short-vector classification

Goal: classify all integer vectors in `e8IntLattice` with squared norm 4 and
prove there are 240.

Expected output:

- shape classification lemmas for `sqNorm v = 4`;
- connection to Hamming codewords of weight 4;
- cardinality theorem for shortest vectors.

### Job 5: root-list bridge

Goal: connect the short-vector classification with `E8Root.rootList`.

Expected output:

- conversion between integer-coordinate roots and `E8Root` doubled-coordinate
  representation;
- theorem equating the two enumerations;
- no new trusted axioms or opaque constants.

### Job 6: Sphere-Packing-Lean reconnaissance bridge

Goal: inspect the Sphere-Packing-Lean E8 definitions under the pinned toolchain
and determine the most practical bridge theorem.

Expected output:

- exact imported names for their E8 lattice, matrix, packing, and density
  theorem;
- a small compatibility file;
- the strongest typechecked statement available;
- proof if feasible, otherwise a documented handoff with exact blockers.

### Job 7: half-integer coordinate bridge

Goal: prove that the scaled Hamming Construction A lattice agrees with the
standard half-integer even-sum E8 coordinate definition.

Expected output:

- a local `halfIntegerE8` coordinate definition;
- membership equivalence with `scaledE8CodeLattice`;
- explicit normalization comments;
- a theorem shaped to compare cleanly with Sphere-Packing-Lean.

## Publication strategy

### Minimal solid paper

Submit once we have:

- Construction A formalized;
- extended Hamming `[8,4,4]` formalized;
- minimum squared norm theorem;
- clear documentation of normalization and provenance.

This is a modest but clean formalization note.

### Strong paper

Submit once we add:

- explicit basis;
- Gram matrix theorem;
- 240 shortest vectors;
- comparison to the repository's integral-octonion E8 root list.

This becomes a serious E8 formalization paper.

### Truly impressive paper

Submit once we add:

- bridge to Sphere-Packing-Lean's E8 lattice;
- transported density theorem or optimality corollary;
- explanation of how coding theory, octonionic roots, and formalized sphere
  packing meet in one Lean ecosystem.

This version would have a strong headline:

> The extended Hamming code constructs, in Lean, the E8 lattice whose sphere
> packing is formally proved optimal.

## Risks and honesty requirements

- Do not claim we have formalized the E8 sphere packing theorem ourselves.
  Sphere-Packing-Lean owns that analytic result.
- Do not claim density optimality for the Hamming/Construction A lattice until
  the bridge theorem to their E8 lattice is kernel-checked.
- Keep the integer norm 4 and scaled real norm 2 conventions visibly separate.
- Do not conflate equality of coordinate sets, equality of submodules, linear
  isometry, and equality of generated packings.
- Check toolchain compatibility before importing Sphere-Packing-Lean directly.
- If direct import is too heavy, publish a theorem phrased against a locally
  copied statement of their E8 matrix definition only if licensing and
  provenance are handled cleanly.

## External sources to cite

- Sphere-Packing-Lean blueprint:
  <https://thefundamentaltheor3m.github.io/Sphere-Packing-Lean/>
- Sphere-Packing-Lean blueprint, E8 lattice section:
  <https://thefundamentaltheor3m.github.io/Sphere-Packing-Lean/blueprint/index.html>
- Sphere-Packing-Lean repository:
  <https://github.com/math-inc/Sphere-Packing-Lean>
- "A Milestone in Formalization: The Sphere Packing Problem in Dimension 8":
  <https://arxiv.org/abs/2604.23468>
- Viazovska, "The sphere packing problem in dimension 8":
  <https://arxiv.org/abs/1603.04246>
- Cohn and Elkies, "New upper bounds on sphere packings I":
  <https://arxiv.org/abs/math/0110009>
- Cohn, "A conceptual breakthrough in sphere packing":
  <https://arxiv.org/abs/1611.01685>
- Cohn, Kumar, Miller, Radchenko, and Viazovska,
  "Universal optimality of the E8 and Leech lattices and interpolation formulas":
  <https://arxiv.org/abs/1902.05438>
- Baek and Kim, "Formalizing building-up constructions of self-dual codes
  through isotropic lines in Lean":
  <https://arxiv.org/abs/2604.08485>
- Mizoguchi and Oikawa, "Error correcting codes and heterotic Narain CFTs":
  <https://arxiv.org/abs/2602.16269>
- Error Correction Zoo, E8 lattice:
  <https://errorcorrectionzoo.org/c/eeight>
- Error Correction Zoo, extended Hamming `[8,4,4]` code:
  <https://errorcorrectionzoo.org/c/hamming844>
- Nebe-Sloane Catalogue of Lattices, E8 coding-theory version:
  <https://www.math.rwth-aachen.de/~Gabriele.Nebe/LATTICES/E8_code.html>
- Mathlib Hamming API:
  <https://leanprover-community.github.io/mathlib4_docs/Mathlib/InformationTheory/Hamming.html>
- Hamming, "Error Detecting and Error Correcting Codes", Bell System Technical
  Journal 29 (1950), 147-160.
- MacWilliams and Sloane, *The Theory of Error-Correcting Codes*.
- Huffman and Pless, *Fundamentals of Error-Correcting Codes*.
- Conway and Sloane, *Sphere Packings, Lattices and Groups*.
