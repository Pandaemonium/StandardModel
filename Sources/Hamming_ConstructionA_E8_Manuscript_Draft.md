# From the Extended Hamming Code to the E8 Sphere Packing in Lean

Status: first manuscript draft, 2026-05-07.

Tag policy: claims marked `[confirm]` are intended manuscript claims that still
need a final build check, citation check, imported Sphere-Packing-Lean check, or
Zotero metadata check before submission. Untagged formal claims should be
backed by the local Lean theorem index
`PhysicsSM.Coding.HammingConstructionAE8Final`.

## Draft Abstract

We formalize a coding-theoretic construction of the E8 lattice in Lean 4. The
construction starts from the extended binary Hamming code of parameters
`[8,4,4]`, proves that this code is Type II, proves uniqueness of binary
linear `[8,4,4]` codes up to coordinate permutation, applies Construction A,
and identifies the resulting lattice with the standard E8 lattice after the
usual `1/sqrt(2)` scaling. The formal development proves an explicit
full-rank basis, computes the Gram determinant, establishes evenness and
unimodularity after scaling, proves that the minimum squared norm is `2`, and
enumerates exactly `240` minimal vectors. It also constructs an explicit bridge
from these minimal vectors to an independently formalized octonionic E8 root
list, and proves a Cartan-matrix comparison identifying the lattice with the
Bourbaki E8 root system. Finally, we compare the construction with the E8 basis
matrix used by Sphere-Packing-Lean, the Lean formalization of Viazovska's
solution of the
eight-dimensional sphere-packing problem. The dependency-free bridge proves
congruence of the local Construction A Gram matrix and the reproduced
Sphere-Packing-Lean E8 Gram matrix. The imported bridge further proves that the
local rational basis matrix is identical to Sphere-Packing-Lean's `E8Matrix Q`,
that its row span is `Submodule.E8 Q`, and that the Sphere-Packing-Lean density
theorem can be cited with this matrix-equality provenance. The imported bridge
now packages the coefficient map as a full `Z`-linear equivalence with
`Submodule.E8 R` and proves the corresponding inner-product formula. `[confirm
platform/import status]`

The result is not a new proof of the analytic sphere-packing bound. Rather, it
is a kernel-checked formal bridge from a finite coding-theory object to the E8
lattice used at the analytic endpoint. This gives a small, reviewable path from
the extended Hamming code to the formalized E8 sphere packing theorem, and it
also records the conventions and finite-computation trust boundary needed for
such a bridge.

## 1. Introduction

The E8 lattice has many classical descriptions. It appears as an even
unimodular rank-eight lattice, as a root lattice, as a half-integer lattice in
`R^8`, as a set of `240` roots, and as a lattice obtained from the extended
binary Hamming code by Construction A. These descriptions are equivalent in the
mathematical literature, but a formal proof assistant requires each equivalence
to be represented by explicit definitions and checked theorems.

This paper formalizes the route

```text
extended binary Hamming code [8,4,4]
  -> uniqueness among binary linear [8,4,4] codes
  -> Type II binary code
  -> Construction A lattice
  -> scaled even unimodular rank-8 lattice
  -> 240 minimal vectors
  -> E8 root system
  -> Sphere-Packing-Lean E8 basis model [confirm]
```

in Lean 4. The contribution is intentionally complementary to
Sphere-Packing-Lean. Sphere-Packing-Lean formalizes the analytic machinery
behind Viazovska's proof of the optimality of the E8 sphere packing. Our
formalization supplies a finite and combinatorial entrance to the same E8
object.

The verified theorem index for the local development is:

```lean
PhysicsSM.Coding.HammingConstructionAE8Final
```

That file re-exports the main theorem chain and gives citation-friendly names
for the manuscript. The strongest local result is that the Hamming
Construction A lattice has the expected E8 metric and root data: after
`1/sqrt(2)` scaling it is even and unimodular, its minimum squared norm is `2`,
it has exactly `240` minimal vectors, those vectors biject with the repository's
octonionic E8 root list, and an explicit unimodular change of basis carries its
Gram matrix to the E8 Cartan matrix.

The `[8,4,4]` uniqueness theorem is currently a companion result rather than a
re-exported theorem in this index: the public statement lives in
`PhysicsSM/Draft/Hamming844Uniqueness.lean` and delegates to trusted proof
machinery under `PhysicsSM/Coding/`. `[confirm final theorem-index placement]`

### Contributions

The main contributions are:

1. A Lean formalization of the extended `[8,4,4]` Hamming code as a Type II
   binary code, including self-duality and doubly-evenness.
2. A kernel-checked uniqueness theorem: every binary linear `[8,4,4]` code is
   equivalent to `extendedHamming8` under a coordinate permutation. `[confirm
   final theorem-index placement]`
3. A concrete Construction A lattice over integer vectors, with membership
   lemmas and norm bounds.
4. An explicit basis for the Hamming Construction A lattice, together with a
   Gram determinant calculation showing unimodularity after `1/sqrt(2)`
   scaling.
5. A proof that the scaled lattice has minimum squared norm `2`.
6. A complete enumeration of the `240` minimal vectors.
7. A formal bridge between those `240` vectors and an independently formalized
   octonionic doubled-coordinate E8 root list.
8. A Cartan-matrix bridge showing that the Construction A Gram matrix is
   congruent to the standard E8 Cartan matrix by an explicit unimodular
   transition matrix.
9. A dependency-free local reproduction of the Sphere-Packing-Lean E8 basis
   matrix over `Q`, with verified Gram matrix, determinant, and a three-way
   Cartan congruence connecting both basis models to the standard E8 Cartan
   matrix. `[confirm imported endpoint]`
10. An imported Sphere-Packing-Lean bridge proving a full `Z`-linear equivalence
    from coefficient coordinates to `Submodule.E8 R`, together with a
    manuscript-facing inner-product theorem.
11. A finite theta-series check proving the first six coefficients
    `1, 240, 2160, 6720, 17520, 30240` of the Construction A E8 theta series,
    matching the Eisenstein series `E4(q)` through `O(q^6)`.
12. A structural theta-series bridge deriving the first shell counts from the
    Hamming weight distribution `(1, 14, 1)`, plus an API bridge identifying
    the local `sigma3` with Mathlib's `ArithmeticFunction.sigma 3`.

### What We Do Not Claim

We do not reprove Viazovska's analytic sphere-packing theorem. We also do not
formalize the abstract classification theorem saying that the rank-eight even
unimodular positive-definite lattice is unique. Instead, we use explicit finite
data: basis matrices, Gram matrices, short-vector lists, and root-list
permutations. This is a better fit for the current formalization because it
keeps the proof small, computational, and directly comparable to
Sphere-Packing-Lean's basis model.

## 2. Mathematical Background

### 2.1 The Extended Hamming Code

Let `C` be the extended binary Hamming code of length `8`. Classically, this is
the unique Type II binary code of length `8`: it is self-dual and every codeword
has weight divisible by `4`. Its weight distribution is

```text
1 codeword of weight 0,
14 codewords of weight 4,
1 codeword of weight 8.
```

In Lean, the code is defined by an explicit parity-check matrix over `ZMod 2`.
The module documents the column ordering, since different Hamming parity-check
matrices are permutation-equivalent but not literally identical.

The weight-enumerator file also proves the MacWilliams self-dual identity for
the explicit polynomial

```text
W(a,b) = a^8 + 14 a^4 b^4 + b^8.
```

The theorem

```lean
extendedHamming8_macwilliams_selfdual_general
```

proves the corresponding identity over any commutative ring by `ring`, without
`native_decide`. This gives an algebraic cross-check of the self-dual weight
enumerator, separate from the finite code enumeration.

Key Lean files:

- `PhysicsSM/Coding/HammingE8.lean`
- `PhysicsSM/Coding/HammingSelfDual.lean`
- `PhysicsSM/Coding/HammingWeightEnumerator.lean`
- `PhysicsSM/Coding/CodeEquivalence.lean`
- `PhysicsSM/Coding/Hamming844Classification.lean`
- `PhysicsSM/Coding/Hamming844UniquenessBasic.lean`

Key theorem:

```lean
PhysicsSM.Coding.HammingConstructionAE8Final.code_is_typeII
PhysicsSM.Coding.extendedHamming8_unique_up_to_equivalence
```

### 2.2 Construction A

For a binary code `C <= (ZMod 2)^n`, Construction A defines a subgroup of
integer vectors

```text
A(C) = { z in Z^n : z mod 2 in C }.
```

For the extended Hamming code, the unscaled integer model has minimum squared
norm `4`. The E8 normalization divides the quadratic form by `2`, equivalently
scaling coordinates by `1/sqrt(2)`, so the scaled minimum squared norm is `2`.

Key Lean files:

- `PhysicsSM/Coding/ConstructionA.lean`
- `PhysicsSM/Coding/ConstructionALatticeProperties.lean`
- `PhysicsSM/Coding/E8Scaled.lean`

Key theorem:

```lean
PhysicsSM.Coding.HammingConstructionAE8Final.scaled_minimum_norm_two
```

### 2.3 Normalizations

The formalization uses several coordinate models. The manuscript should keep
the following table near the beginning, because many apparent discrepancies
are just normalization differences.

| Model | Ambient type | Short-vector squared norm | Role |
|-------|--------------|---------------------------|------|
| Construction A integer model | `Fin 8 -> Z` | `4` | Direct output of Construction A |
| Scaled E8 lattice | same basis, form divided by `2` | `2` | Standard E8 lattice normalization |
| Doubled root model | `Fin 8 -> Z` | `8` in doubled coordinates | Octonionic root-list comparison |
| SPL half-integer model | `Fin 8 -> Q` or `Fin 8 -> R` | `2` | Sphere-Packing-Lean basis convention |

The bridge theorems make these conversions explicit instead of treating them
as informal identifications.

### 2.4 E8 Roots and Cartan Matrix

The standard E8 root system has `240` roots, each of squared norm `2` in the
usual normalization. The project also contains an octonionic doubled-coordinate
root list whose squared norm convention is doubled. A central theorem in this
paper proves that the `240` short vectors from Construction A map to a
permutation of that octonionic root list.

Key Lean files:

- `PhysicsSM/Coding/E8ShortVectors.lean`
- `PhysicsSM/Coding/E8RootBridge.lean`
- `PhysicsSM/Algebra/Octonion/IntegralOctonion.lean`
- `PhysicsSM/Algebra/Octonion/E8RootCompleteness.lean`

Key theorems:

```lean
PhysicsSM.Coding.HammingConstructionAE8Final.short_vector_count
PhysicsSM.Coding.HammingConstructionAE8Final.bridge_perm
```

## 3. Formalization Architecture

The formal development is organized around small, theorem-oriented modules.
Each module either defines one mathematical object or proves one bridge between
two existing objects.

| Module | Purpose |
|--------|---------|
| `ConstructionA.lean` | Generic binary vectors, Hamming weight, reduction mod `2`, Construction A subgroup, norm lemmas |
| `HammingE8.lean` | Concrete extended Hamming code and initial norm facts |
| `HammingSelfDual.lean` | Dual code, self-duality, Type II property |
| `HammingWeightEnumerator.lean` | Weight distribution and MacWilliams-style finite identity |
| `CodeEquivalence.lean` | Coordinate-permutation equivalence of binary codes |
| `Hamming844UniquenessBasic.lean` | Parameter preservation and infrastructure for `[8,4,4]` uniqueness |
| `Hamming844Classification.lean` | Finite systematic-generator classification proving `[8,4,4]` uniqueness |
| `ConstructionALatticeProperties.lean` | Divisibility and full-rank precursors |
| `E8Scaled.lean` | Scaled quadratic form and minimum norm `2` |
| `E8Basis.lean` | Explicit basis and Gram determinant |
| `E8ShortVectors.lean` | Complete list of `240` short vectors |
| `E8RootBridge.lean` | Bridge from short vectors to octonionic E8 roots |
| `E8RootBridgeIsometry.lean` | Hadamard half-step norm and inner-product bridge |
| `E8SpherePackingShape.lean` | Cartan bridge for the Construction A basis |
| `E8SpherePackingMatrixBridge.lean` | Dependency-free comparison with the SPL E8 basis matrix |
| `E8ThetaSeries.lean` | Theta coefficients through `q^4` and comparison with `E4` |
| `E8ThetaSigmaBridge.lean` | Compatibility between local `sigma3` and Mathlib's arithmetic-function `sigma` |
| `E8ThetaSeriesQ5.lean` | `q^5` coefficient by inner-shell plus spike decomposition |
| `ConstructionAThetaWeightBridge.lean` | First shell counts derived from the Hamming weight distribution |
| `Draft/E8SpherePackingIsometryHelper.lean` | SPL-free bilinear-form lemmas for the imported isometry bridge |
| `Draft/E8EvenUnimodularUniqueness.lean` | Draft scaffold for abstract rank-8 even unimodular uniqueness |
| `E8WeylPermutations.lean` | Simple reflections packaged as permutations of the root subtype |
| `E8WeylOrbitConvergence.lean` | Constructive orbit convergence from one root to all `240` roots |
| `HammingConstructionAE8Final.lean` | Citation-friendly theorem index |

Draft or platform-dependent bridge files live under `PhysicsSM/Draft/`.
In particular, the direct Sphere-Packing-Lean import file is intentionally not
part of the default Windows build until the external dependency naming issue is
resolved upstream or through the local fork. `[confirm]`

## 4. Main Formal Results

### 4.1 The Code Is Type II

The first theorem proves that the explicitly defined extended Hamming code is
Type II.

```lean
theorem code_is_typeII : IsTypeII extendedHamming8
```

This packages two facts: self-duality and doubly-evenness. The proof is finite,
using the explicit parity-check definition and finite enumeration over
`(ZMod 2)^8`.

This theorem removes a common informal gap. It is not enough to say that the
code is "the extended Hamming code" by name; the Lean development proves the
properties that Construction A needs.

The formalization also proves the uniqueness statement for these parameters:

```lean
theorem extendedHamming8_unique_up_to_equivalence
    (C : BinaryLinearCode 8) (hC : IsLinearCode C 4 4) :
    CodeEquivalent C extendedHamming8
```

The proof combines an information-set argument, reduction to systematic
generator matrices, and a finite classification over all `2^16 = 65,536`
possible systematic `4 x 4` binary matrices. The theorem
`CodeEquivalent.isLinearCode` records that coordinate-permutation equivalence
preserves the relevant code parameters. The public wrapper currently lives in
`PhysicsSM/Draft/Hamming844Uniqueness.lean`; the proof machinery is in
`PhysicsSM/Coding/Hamming844Classification.lean` and
`PhysicsSM/Coding/Hamming844UniquenessBasic.lean`. `[confirm final placement
before submission]`

Finally, `HammingWeightEnumerator.lean` proves the MacWilliams self-dual
identity

```lean
theorem extendedHamming8_macwilliams_selfdual_general {R : Type*}
    [CommRing R] (a b : R) : ...
```

by a pure `ring` calculation. This gives a second, algebraic check that the
weight enumerator has the self-dual form expected of the extended Hamming code.

### 4.2 Full Rank, Evenness, and Unimodularity

The Construction A subgroup comes with an explicit integer basis. The
formalization proves that this basis spans the subgroup, computes its Gram
matrix, and verifies the determinant.

Representative theorem names:

```lean
theorem lattice_fullRank : ...
theorem gram_det_eq : ...
theorem scaled_gram_det_one : ...
theorem property_package : ...
```

The unscaled Gram determinant is `256`. After dividing the quadratic form by
`2` in dimension `8`, the determinant becomes

```text
256 / 2^8 = 1.
```

This is the concrete unimodularity calculation for the scaled E8 lattice. The
same theorem package also records the divisibility/evenness information coming
from the doubly-even code.

### 4.3 Minimum Norm and Kissing Number

The scaled lattice has minimum squared norm `2`.

```lean
theorem scaled_minimum_norm_two : ...
```

The short-vector enumeration proves that there are exactly `240` vectors of
unscaled squared norm `4`, equivalently scaled squared norm `2`.

```lean
theorem short_vector_count : shortHammingE8VectorList.length = 240
theorem short_vector_list_complete : ...
theorem short_vector_list_sqNorm : ...
```

Mathematically, the list consists of the familiar two families:

1. Family A: the `16` vectors of the form `+/- 2 e_i`;
2. Family B: the `224` vectors with four nonzero entries
   `( +/- 1, +/- 1, +/- 1, +/- 1 )` supported on a weight-4 Hamming codeword.

The arithmetic is explicit: there are `8 * 2 = 16` Family A vectors, and
there are `14` weight-4 codeword supports, each with `2^4 = 16` sign patterns,
giving `14 * 16 = 224` Family B vectors. Thus `16 + 224 = 240`.

The completeness proof includes the necessary coordinate bound: a vector of
unscaled squared norm `4` has every coordinate in `{ -2, -1, 0, 1, 2 }`.
This keeps the finite enumeration honest and avoids relying on an unstated
range restriction.

### 4.4 Bridge to the Octonionic Root List

The project had an independent doubled-coordinate E8 root list coming from the
octonionic side of the repository. The bridge theorem proves that the
Construction A short vectors and the octonionic root list are the same finite
root system under an explicit map.

```lean
theorem bridge_mem_rootList : ...
theorem bridge_nodup : ...
theorem bridge_perm :
    (shortHammingE8VectorList.map E8RootBridge.shortVectorToDoubledRoot).Perm
      rootList
```

This is one of the most distinctive pieces of the paper. It is not merely a
classical E8 fact restated in Lean; it connects two independently developed
models in the same repository:

```text
coding theory / Construction A
  <-> octonionic doubled-coordinate roots
```

### 4.5 Cartan Matrix Bridge

The file `E8SpherePackingShape.lean` proves that an explicit unimodular change
of basis carries the Construction A Gram matrix to the E8 Cartan matrix.

```lean
theorem basis_change_det : ...
theorem gram_cartan_bridge : ...
```

In prose, the theorem says:

```text
P^T * G * P = 2 * Cartan(E8)
```

for the unscaled integer Gram matrix `G`. After the `1/sqrt(2)` scaling, this
becomes the standard E8 Cartan Gram matrix. This is the cleanest local
identification of the Construction A lattice with the E8 root lattice: it is
explicit, finite, and avoids relying on an unformalized classification theorem.

### 4.6 Dependency-Free Sphere-Packing-Lean Matrix Comparison

The file `E8SpherePackingMatrixBridge.lean` reproduces the E8 basis matrix from
Sphere-Packing-Lean over `Q`, proves its determinant is `1`, computes its Gram
matrix, and proves that this Gram matrix is congruent to the E8 Cartan matrix.
It also proves that the scaled Construction A Gram matrix is congruent to the
same Cartan matrix.

Representative theorem names:

```lean
theorem splE8BasisQ_det : ...
theorem splE8GramQ_eq : ...
theorem splGram_to_cartan : ...
theorem constructionA_scaledGram_to_cartan : ...
theorem spl_gram_congruent_to_scaled_constructionA : ...
theorem gram_determinants_match : ...
```

This gives a dependency-free comparison with the lattice model used by
Sphere-Packing-Lean. The imported bridge to the actual SPL declarations is
kept in a draft file because the upstream repository currently contains file
names `Aux.lean`; `Aux` is a reserved device name on Windows filesystems.
`[confirm upstream or fork status]`

### 4.7 Imported Sphere-Packing-Lean Endpoint

The imported file

```lean
PhysicsSM/Draft/E8SpherePackingImported.lean
```

directly imports:

```lean
SpherePacking.Dim8.E8.Basic
SpherePacking.Dim8.E8.Packing
```

and confirms the key declarations needed for the final endpoint:

```lean
Submodule.E8
E8Matrix
E8Matrix_unimodular
span_E8Matrix
E8Lattice
E8Packing
E8Packing_density
```

The strongest new bridge theorems are:

```lean
theorem local_splE8BasisQ_eq_imported_E8Matrix_Q : ...
theorem local_splE8BasisQ_span_eq_imported_E8_Q : ...
theorem splE8GramQ_eq_imported : ...
theorem constructionA_to_E8_full_bridge : ...
theorem e8_packing_density_from_spl : ...
theorem e8_density_with_bridge_documentation : ...
```

Together these prove that the local rational reproduction of SPL's basis is
literally the imported `E8Matrix Q`, that its row span is `Submodule.E8 Q`,
that the local Gram matrix is the imported SPL Gram matrix, and that the
Construction A and SPL Gram matrices both pass through the same Cartan
comparison chain. The theorem `e8_density_with_bridge_documentation` bundles
the SPL density statement with the matrix and span equalities that document why
the density theorem is being cited in the same coordinate story.

The imported bridge now also contains an explicit transition matrix and
coefficient-level embedding:

```lean
def constructionAToSPLTransition : Matrix (Fin 8) (Fin 8) Z
theorem constructionAToSPLTransition_det : ...
theorem constructionAToSPLTransition_gram : ...
noncomputable def constructionAToE8 : (Fin 8 -> Z) -> (Fin 8 -> R)
theorem constructionAToE8_mem_E8 : ...
theorem constructionAToE8_injective : ...
noncomputable def constructionAToE8Equiv :
    (Fin 8 -> Z) ~=_Z Submodule.E8 R
theorem constructionAToE8_inner : ...
theorem constructionAToE8_norm_sq_even : ...
```

Here `constructionAToSPLTransition` is the composite integer transition from
Construction A basis coordinates to SPL basis coordinates. Its Gram theorem
records the scaled inner-product compatibility, while `constructionAToE8`
sends integer coefficient vectors to integer linear combinations of imported
`E8Matrix R` rows. The map lands in `Submodule.E8 R`; it is injective and
surjective, and is packaged as `constructionAToE8Equiv`. The theorem
`constructionAToE8_inner` states that the Euclidean inner product of two images
is exactly the scaled Construction A Gram form on the two coefficient vectors.
This is the imported SPL bridge's strongest current isometry theorem.

It also proves concrete membership lemmas for both branches of SPL's E8
definition:

```lean
theorem intVec_even_sum_mem_E8 : ...
theorem halfIntVec_even_sum_mem_E8 : ...
```

These show that integer vectors with even coordinate sum and half-integer
vectors with even coordinate sum lie in `Submodule.E8 R` in the imported SPL
model. They are the direct interface between the Construction A parity data and
SPL's half-integer/integer even-sum predicate.

The remaining formal endpoint is no longer the lattice equivalence itself, but
the packing-level packaging:

```text
transport or restate the SPL packing/density theorem through
constructionAToE8Equiv without overclaiming beyond the imported SPL result.
```

### 4.8 Theta-Series Coefficients

The theta-series files add finite coefficient checks and a first structural
weight-enumerator bridge for the same Construction A model. They use the
convention

```text
Q(z) = sqNorm(z) / 4,
```

so unscaled Construction A shell `sqNorm z = 4n` contributes to the coefficient
of `q^n`. The trusted coefficient files prove:

```lean
theorem e8ShellCount_zero : ...
theorem e8ShellCount_four : ...
theorem e8ShellCount_eight : ...
theorem e8ShellCount_twelve : ...
theorem e8ShellCount_sixteen : ...
theorem e8ShellCount_twenty : ...
```

These prove the shell counts `1`, `240`, `2160`, `6720`, `17520`, and `30240`.
The base theta file defines the divisor-sum function `sigma3`, the
Eisenstein-series coefficient function `e4Coeff n = 240 * sigma3 n`, and the
bridge file proves that this local definition agrees with Mathlib's canonical
arithmetic-function API:

```lean
theorem sigma3_eq_mathlib_sigma (n : Nat) :
    sigma3 n = (ArithmeticFunction.sigma 3) n
```

The coefficient comparison theorems are:

```lean
theorem thetaCoeff_eq_e4Coeff_one : ...
theorem thetaCoeff_eq_e4Coeff_two : ...
theorem thetaCoeff_eq_e4Coeff_three : ...
theorem thetaCoeff_eq_e4Coeff_four : ...
theorem thetaCoeff_eq_e4Coeff_five : ...
```

Thus the formalized coefficient data matches

```text
Theta_E8(q) = 1 + 240 q + 2160 q^2 + 6720 q^3
                + 17520 q^4 + 30240 q^5 + O(q^6)
E4(q)       = 1 + 240 q + 2160 q^2 + 6720 q^3
                + 17520 q^4 + 30240 q^5 + O(q^6).
```

The `q^4` and `q^5` coefficients use a decomposition rather than a direct
search over `{-4, ..., 4}^8`. For `q^4`, the proof counts the inner shell
with all coordinates of absolute value at most `3`, then adds the `16` spike
vectors `+/-4 e_i`. For `q^5`, the proof again counts the inner shell and then
adds `2016` spike vectors with exactly one coordinate of absolute value `4`.
The decomposition is complete because two coordinates of absolute value at
least `4` would already contribute squared norm at least `32`, larger than
the `sqNorm = 20` shell.

The file `ConstructionAThetaWeightBridge.lean` gives a complementary
explanation for the early coefficients. It partitions Construction A shell
counts by the binary residue `reduceModTwo z` and proves that, for the first
small shells, the contribution of a residue class depends only on its Hamming
weight. Combining the Hamming weight distribution `(1, 14, 1)` with the
per-weight lift counts gives:

```text
theta(0) = 1 * 1   + 14 * 0   + 1 * 0   = 1
theta(1) = 1 * 16  + 14 * 16  + 1 * 0   = 240
theta(2) = 1 * 112 + 14 * 128 + 1 * 256 = 2160.
```

The key trusted results include:

```lean
theorem residueShellCount5_eq_weightContrib_s4 : ...
theorem residueShellCount5_eq_weightContrib_s8 : ...
theorem shellCount_eq_sum_residueShellCount5_s4 : ...
theorem shellCount_eq_sum_residueShellCount5_s8 : ...
theorem theta1_bridge_eq_e4 : ...
theorem theta2_bridge_eq_e4 : ...
```

This does not yet prove the full MacWilliams-theta product formula, but it
turns the theta section from a pure point-counting calculation into a first
formal connection between the Hamming weight enumerator and the E8 theta
series.

This is not yet a proof of the full identity `Theta_E8 = E4`; it is a
kernel-checked finite initial segment plus a structural bridge for the first
coefficients, with the same finite-enumeration trust boundary as the
short-vector theorem.

## 5. Verification and Trust Boundary

### 5.1 Kernel-Checked Code

Trusted Lean files used by the manuscript should contain no `sorry`, `admit`,
new axioms, or unsafe placeholders. The manuscript theorem index is intended
to be a stable entry point for reviewers:

```lean
import PhysicsSM.Coding.HammingConstructionAE8Final
```

The final paper should report the exact Lean version, mathlib revision, and
repository commit. `[confirm]`

### 5.2 Finite Computation and `native_decide`

Several theorems are finite computations over small explicit data: codeword
enumerations, `8 x 8` matrix identities, determinant calculations, and list
permutation checks. Some are proved using `native_decide`. In Lean 4,
`native_decide` depends on the native compiler trust boundary, so
`#print axioms` reports `Lean.trustCompiler`.

The paper should state this explicitly. The relevant computations are finite
and small:

- the ambient binary space has `2^8 = 256` vectors;
- the Hamming code has `16` codewords;
- the short-vector/root lists have length `240`;
- the first theta-shell enumerations search finite boxes large enough to be
  complete by proved coordinate-bound lemmas;
- the matrix identities are over explicit `8 x 8` integer or rational
  matrices.

Not every finite computation has the same trust level. Some results use
ordinary `decide`, which reduces inside the Lean kernel and does not introduce
`Lean.trustCompiler`. The Weyl word-table theorems are the key example:

```lean
rootWordTable_correct
rootWordTable_length_le
```

These check that the BFS-computed words carry the first root to each of the
`240` roots, and that every word has length at most `39`, using kernel
reduction. By contrast, the larger short-vector enumerations and many explicit
matrix equalities use `native_decide`, trading full kernel reduction for the
native compiler trust boundary. The manuscript should report which theorem
families fall on each side of this line.

This is an appropriate use of native finite computation, but it should not be
hidden from readers.

### 5.3 External Dependency Boundary

The local theorem spine does not require Sphere-Packing-Lean. The direct SPL
import bridge does. The manuscript should distinguish three layers:

1. local trusted Construction A/E8 formalization;
2. local clean-room matrix comparison with the SPL E8 basis matrix;
3. direct imported SPL theorem transport. `[confirm]`

This distinction lets the paper remain publishable even if platform-specific
SPL dependency issues delay the final imported theorem.

## 6. Related Work

### Classical Coding Theory and Lattices

The extended Hamming code and Construction A are standard objects in coding
theory and lattice theory. The intended core references are Hamming's original
paper on error-correcting codes, MacWilliams and Sloane's textbook, Huffman and
Pless's textbook, and Conway and Sloane's lattice reference. `[confirm exact
bibliographic metadata and chapter/page references]`

The Error Correction Zoo and the Nebe-Sloane Catalogue of Lattices provide
useful public cross-checks for the statement that the extended `[8,4,4]`
Hamming code yields the E8 lattice by Construction A. They should be cited as
secondary cross-checks rather than as the primary source for the theorem.
`[confirm citation policy]`

### Sphere Packing

Cohn and Elkies developed the linear-programming framework for upper bounds on
sphere packings. Viazovska solved the sphere-packing problem in dimension `8`
by constructing the required magic function, proving the optimality of the E8
lattice packing. Cohn, Kumar, Miller, Radchenko, and Viazovska later solved the
dimension `24` Leech lattice case and proved universal optimality results for
E8 and the Leech lattice, including the Annals paper "Universal optimality of
the E8 and Leech lattices and interpolation formulas", Annals of Mathematics
196 (2022), 983-1082. `[confirm exact citations]`

Sphere-Packing-Lean formalizes the dimension-8 theorem in Lean. The project
blueprint credits Christopher Birkbeck, Sidharth Hariharan, Seewoo Lee,
Ho Kiu Gareth Ma, Bhavik Mehta, and Maryna Viazovska. The 2026 arXiv report
"A Milestone in Formalization: The Sphere Packing Problem in Dimension 8",
arXiv:2604.23468, lists Sidharth Hariharan, Christopher Birkbeck, Seewoo Lee,
Ho Kiu Gareth Ma, Bhavik Mehta, Auguste Poiroux, and Maryna Viazovska as
authors. This paper is designed to connect to that formalization by identifying
a code-built E8 lattice with the E8 lattice model used there. `[confirm final
SPL bibliography key]`

### Formal Coding Theory

Recent Lean work on self-dual codes and building-up constructions is adjacent
to this project. Our focus is different: instead of developing general
self-dual-code construction theory, we formalize a concrete code-to-lattice
bridge ending at E8. `[confirm Baek-Kim citation and relationship]`

### Physics Motivation

Code-lattice correspondences also appear in the physics literature around
conformal field theory and heterotic/Narain compactifications. This provides
motivation for the larger repository, but the present manuscript should keep
the physics discussion short and non-essential. `[confirm whether to include
Dymarsky-Shapere and Mizoguchi-Oikawa citations]`

## 7. Discussion

### Why Use an Explicit Bridge Instead of E8 Uniqueness?

Classically, one can identify the lattice by showing it is even, unimodular,
positive-definite, and rank `8`, then invoking the uniqueness of E8 in rank
`8`. That route is elegant on paper but would require formalizing a nontrivial
classification theorem or importing one that does not currently exist in
mathlib. The manuscript should cite a standard source for this classification,
for example Conway and Sloane's discussion of even unimodular lattices in rank
`8`; the exact historical attribution should be checked before submission.
`[confirm classification citation]`

The repository now includes a draft scaffold for this alternative route:

```lean
PhysicsSM/Draft/E8EvenUnimodularUniqueness.lean
```

It defines reusable Gram-matrix predicates such as `IsEvenGram`,
`IsUnimodularGram`, `IsPosDef_over_reals`, and `IntCongruent`, and proves basic
precursor lemmas for the E8 Gram matrix and congruence preservation. It also
states the abstract uniqueness theorem as a documented draft theorem. Two
proofs remain intentionally open there: positive-definiteness of the E8 Gram
matrix, currently blocked on a convenient Sylvester/eigenvalue API, and the
full rank-8 even unimodular uniqueness theorem, which would require a
substantial classification argument. The manuscript should present this as a
future route, not as part of the trusted proof chain.

Our route is more concrete. We prove an explicit basis, compute its Gram
matrix, prove determinant and parity properties, enumerate its minimal vectors,
and compare it to the E8 Cartan matrix and root list. This is enough for the
paper's main formal goal and is better aligned with the finite data already
available in Lean.

### Why Include the Octonionic Root Bridge?

The octonionic root bridge demonstrates that two independent E8 models in the
repository agree. It also makes the paper more than a reproduction of a
textbook construction. The formal theorem

```lean
HammingConstructionAE8Final.bridge_perm
```

is a compact certificate that the Construction A short-vector enumeration and
the octonionic doubled-coordinate root enumeration are the same `240`-element
root system under an explicit map.

### Weyl Group Material

The repository now contains additional Weyl reflection and orbit results:

- simple reflections act as permutations of the root subtype;
- each simple reflection has order `2`;
- the E8 Cartan matrix is verified from the simple roots;
- iterated closure from one root reaches the full `240`-root list.

The strongest result here is the constructive orbit-convergence theorem in
`E8WeylOrbitConvergence.lean`:

```lean
rootWordTable_correct
rootWordTable_length_le
simpleClosure_from_firstRoot_covers_rootList
```

The file contains a BFS-computed word table giving a word in the eight simple
reflections from one fixed root to each of the `240` roots. The theorem
`rootWordTable_correct` verifies the endpoint of every word by kernel
`decide`, and `rootWordTable_length_le` verifies that each word has length at
most `39`. The convergence theorem then proves that `39` iterations of the
simple-reflection closure step from one root cover the whole root list. This is
a compact constructive irreducibility certificate for the E8 root system.

These results are not necessary for the minimal Hamming-to-E8 bridge, but they
are strong enough to deserve either an appendix or a short "root-system
verification" subsection. `[confirm final inclusion]`

## 8. Limitations and Future Work

1. The paper does not formalize the abstract classification of rank-eight even
   unimodular lattices. The identification is explicit and finite.
2. The default local build does not import `E8SpherePackingImported.lean`,
   because the direct SPL bridge is platform/dependency-sensitive. The
   SPL-free helper file `E8SpherePackingIsometryHelper.lean` does build in the
   default project. `[confirm final status]`
3. The paper proves the first six coefficients of `Theta_E8 = E4`, through
   `q^5`, and proves a first weight-enumerator bridge for the early shells.
   It does not yet prove the full theta-series identity or the general
   MacWilliams-theta product formula. Those remain natural sequel targets.
4. The paper does not include the Leech lattice or the Golay code. A future
   paper could generalize the same Construction A machinery to the
   `[24,12,8]` Golay code and the Leech lattice.
5. The paper does not rely on Standard Model anomaly-cancellation results.
   Those belong in a separate manuscript with its own physics conventions.

## 9. Proposed Paper Structure

1. Introduction
2. Mathematical background
   - extended Hamming code;
   - Construction A;
   - E8 normalizations;
   - Sphere-Packing-Lean endpoint.
3. Lean formalization architecture
   - trusted theorem index;
   - module map;
   - finite computation trust boundary.
4. The Hamming code, uniqueness, Type II properties, and weight enumerator
5. Construction A lattice and scaled E8 metric
6. Short vectors and the kissing number `240`
7. Bridge to octonionic E8 roots
8. Cartan and Sphere-Packing-Lean matrix bridge
9. Initial theta-series coefficients and the weight-enumerator bridge
10. Verification, provenance, and limitations
11. Conclusion
12. Appendix: Weyl reflections and orbit closure `[confirm]`

## 10. Draft Conclusion

We have formalized a complete finite route from the extended Hamming code to
the E8 lattice in Lean. The development proves both the Type II property of
the code and the uniqueness of the binary linear `[8,4,4]` code up to
coordinate permutation. It constructs the corresponding Construction A lattice,
verifies its full-rank basis and scaled even unimodular Gram data, proves the
minimum norm and the `240`-vector kissing configuration, and connects the
resulting root system to both an octonionic root list and a Cartan-matrix
presentation of E8. The dependency-free matrix comparison places this lattice
in the same concrete coordinate family as the E8 basis used by
Sphere-Packing-Lean, and the imported bridge proves literal equality between
the local rational basis and Sphere-Packing-Lean's `E8Matrix Q`, plus the
corresponding span equality with `Submodule.E8 Q`; it also constructs a full
`Z`-linear equivalence with `Submodule.E8 R` and proves the matching inner
product formula. The theta-series modules verify the first six coefficients
`1`, `240`, `2160`, `6720`, `17520`, and `30240`, matching the Eisenstein
series `E4` through `O(q^6)`. They also connect the local divisor-sum function
to Mathlib's `ArithmeticFunction.sigma 3` and derive the first shell counts
from the Hamming weight distribution `(1, 14, 1)`. The code-built lattice is
therefore a formal front door to the E8 lattice object used in
Sphere-Packing-Lean. What remains is packing-level transport/provenance
wording, not the lattice equivalence itself. `[confirm]`

The main lesson is methodological as much as mathematical: for highly
classical equivalences among codes, lattices, and root systems, a proof
assistant benefits from explicit finite bridges. Instead of relying on names
such as "the E8 lattice", the formalization records basis matrices, determinant
checks, list bijections, normalization maps, and trust boundaries. This turns a
well-known informal chain into a reviewable kernel-checked artifact.

## 11. `[confirm]` Checklist Before Submission

- `[confirm]` Run final `lake build` on the default repository target.
- `[confirm]` Run the no-sorry/trusted-code check and record expected draft
  exceptions, if any.
- `[confirm]` Record exact Lean, mathlib, and repository commit hashes.
- `[confirm]` Decide whether to move/import the `[8,4,4]` uniqueness theorem
  from `PhysicsSM/Draft/Hamming844Uniqueness.lean` into the citation-friendly
  theorem index.
- `[confirm]` Decide whether the direct Sphere-Packing-Lean import bridge is a
  theorem in the paper body, an appendix, or a documented external endpoint.
- `[confirm]` Verify the Windows-safe SPL fork or upstream rename status.
- `[confirm]` Decide whether `constructionA_to_E8_full_bridge` and
  `e8_density_with_bridge_documentation` should remain in a platform-specific
  draft file or be mirrored in a paper appendix as Linux/macOS-checked results.
- `[confirm]` Decide how to present `constructionAToE8Equiv` and
  `constructionAToE8_inner`: paper body, appendix, or platform-specific
  imported bridge section.
- `[confirm]` Add a conservative packing-level transport/provenance theorem if
  M2 produced one; otherwise describe the SPL density endpoint without
  overclaiming.
- `[confirm]` Add or update Zotero records for Hamming, MacWilliams-Sloane,
  Huffman-Pless, Cohn-Elkies, Viazovska, Sphere-Packing-Lean, and any formal
  coding-theory comparison paper.
- `[confirm]` Replace all citation placeholders with exact bibliography keys,
  page ranges, theorem numbers, or chapter references.
- `[confirm]` Decide whether to include the Weyl orbit results in the main text
  or appendix.
- `[confirm]` Add a final trust-boundary table distinguishing `decide`,
  `native_decide`, and ordinary tactic proofs.
- `[confirm]` Decide whether to mention physics motivation, and if so keep it
  clearly separated from the formal theorem claims.

## Draft Bibliography Notes

These are not final bibliography entries. They are a working checklist for
Zotero cleanup and citation insertion.

- `Hamming1950` `[confirm]`: Richard W. Hamming, "Error Detecting and Error
  Correcting Codes", Bell System Technical Journal 29 (1950), 147-160.
- `MacWilliamsSloane1977` `[confirm]`: F. J. MacWilliams and N. J. A. Sloane,
  The Theory of Error-Correcting Codes, North-Holland, 1977.
- `HuffmanPless2003` `[confirm]`: W. Cary Huffman and Vera Pless,
  Fundamentals of Error-Correcting Codes, Cambridge University Press, 2003.
- `ConwaySloane1999`: J. H. Conway and N. J. A. Sloane, Sphere Packings,
  Lattices and Groups, third edition, Springer, 1999.
- `CohnElkies2003` `[confirm]`: Henry Cohn and Noam Elkies, "New upper bounds
  on sphere packings I", Annals of Mathematics 157 (2003), 689-714.
- `Viazovska2017` `[confirm metadata]`: Maryna Viazovska, "The sphere packing
  problem in dimension 8", Annals of Mathematics 185 (2017), 991-1015.
- `CKMRV2022UniversalOptimality` `[confirm metadata]`: Henry Cohn, Abhinav
  Kumar, Stephen D. Miller, Danylo Radchenko, and Maryna Viazovska,
  "Universal optimality of the E8 and Leech lattices and interpolation
  formulas", Annals of Mathematics 196 (2022), 983-1082.
- `SpherePackingLeanPaper2026` `[confirm Zotero]`: Sidharth Hariharan,
  Christopher Birkbeck, Seewoo Lee, Ho Kiu Gareth Ma, Bhavik Mehta, Auguste
  Poiroux, and Maryna Viazovska, "A Milestone in Formalization: The Sphere
  Packing Problem in Dimension 8", arXiv:2604.23468.
- `SpherePackingLeanBlueprint` `[confirm]`: Sphere-Packing-Lean repository and
  blueprint, by Christopher Birkbeck, Sidharth Hariharan, Seewoo Lee, Gareth
  Ma, Bhavik Mehta, and Maryna Viazovska.
- `EvenUnimodularRank8Classification` `[confirm exact source]`: standard
  reference for uniqueness of the rank-8 even unimodular lattice, likely
  Conway-Sloane Ch. 15 or another reviewed classification source.
- `BaekKim2026` `[confirm]`: Jae-Hyun Baek and Jon-Lark Kim, formalization work
  on self-dual code building-up constructions in Lean.
- `ErrorCorrectionZooHamming844` `[confirm]`: Error Correction Zoo entry for
  the extended `[8,4,4]` Hamming code.
- `NebeSloaneE8Code` `[confirm]`: Nebe-Sloane Catalogue of Lattices entry for
  the E8 coding-theory construction.
- `DymarskyShapere2021` `[optional]`: Dymarsky and Shapere on quantum
  stabilizer codes, lattices, and CFTs.
- `MizoguchiOikawa2026` `[optional confirm]`: error-correcting codes and
  heterotic Narain CFTs.
