# From the Extended Hamming Code to the E8 Lattice in Lean

Status: polished manuscript revision draft, prepared from the current repository
state.

This revision is written as a clean paper draft.  It presents the current
formal development directly, with conventions and implementation details moved
to appendices.  Exact page and theorem citations should be filled in during the
final bibliography pass using `Sources/Hamming_E8_Zotero_Source_Map.md`.

## Abstract

We formalize in Lean 4 the classical construction of the E8 lattice from the
extended binary Hamming code.  Starting from an explicit parity-check matrix
for the `[8,4,4]` code, we prove that the code is Type II and unique among
binary linear `[8,4,4]` codes up to coordinate permutation.  We then apply
Construction A, exhibit an explicit integer basis, compute its Gram form, and
prove that the scaled lattice is even and unimodular.  The same concrete model
also gives the standard E8 metric data: minimum squared norm `2`, exactly
`240` minimal vectors, an explicit bridge to an independently formalized E8
root list, and a Cartan-matrix comparison.

The formalization also connects the coding-theoretic model to two analytic
descriptions of E8.  First, it proves the theta-series coefficient formula

```text
Theta_E8(q) = E4(q) = 1 + 240 * sum_{n > 0} sigma_3(n) q^n
```

by transporting Construction A shell counts to the rank-eight theta modular
form and comparing with the normalized Eisenstein series `E4`.  Second, it
compares the local Construction A basis with the E8 basis used by
Sphere-Packing-Lean, the Lean formalization of Viazovska's dimension-eight
sphere-packing theorem.  The result is a verified bridge from a finite
coding-theoretic object to the E8 lattice appearing at the analytic endpoint of
the formalized sphere-packing proof.

## 1. Introduction

The E8 lattice admits many classical descriptions.  It can be introduced as
the unique even unimodular positive-definite lattice of rank eight, as the root
lattice of the exceptional root system E8, as a half-integer lattice in
`R^8`, or as the Construction A lattice attached to the extended binary
Hamming code.  These descriptions are equivalent in the mathematical
literature, but a formal proof assistant asks for explicit maps, explicit
normalizations, and kernel-checked statements connecting them.

This paper formalizes the coding-theoretic route:

```text
extended binary Hamming code [8,4,4]
  -> Construction A integer lattice
  -> scaled even unimodular rank-eight lattice
  -> 240 minimal vectors
  -> E8 root and Cartan data
  -> theta-series identity Theta_E8 = E4
  -> Sphere-Packing-Lean E8 basis comparison
```

The contribution is complementary to Sphere-Packing-Lean.  Sphere-Packing-Lean
formalizes the analytic proof that the E8 sphere packing is optimal in
dimension eight.  The present development supplies a finite and combinatorial
entrance to the same E8 object: it starts from the extended Hamming code, builds
the lattice by Construction A, and identifies the resulting object with the
standard E8 data used elsewhere in the Lean ecosystem.

The main Lean-facing theorem index for the local Hamming-to-E8 development is:

```text
CodeLatticeE8.Publication.TheoremIndex
```

The older `PhysicsSM.Coding.HammingConstructionAE8Final` file remains useful as
a research-workbench index while the polished package is being extracted.  The
theta-series comparison is currently organized through:

```text
PhysicsSM.Draft.E8ThetaCoeffGapAristotle
PhysicsSM.Draft.E8ThetaMFBridgeAristotle
PhysicsSM.Draft.E8ThetaDim8MF
```

Some of these files remain in `Draft` because they import or adapt
Sphere-Packing-Lean modules and are still being organized for eventual
promotion.  The theorems cited below are named explicitly so that their status
can be checked directly in Lean.

### Contributions

The formalization proves the following.

1. The explicitly defined extended binary Hamming code is Type II: it is
   self-dual and doubly even.

2. Every binary linear `[8,4,4]` code is equivalent to the extended Hamming
   code under a coordinate permutation.

3. The Construction A lattice has an explicit integer basis, and its scaled
   Gram determinant is `1`.

4. Every lattice vector has the parity and norm divisibility expected of the
   E8 normalization; in particular, the scaled lattice is even.

5. The scaled minimum squared norm is `2`.

6. The list of minimal vectors has exactly `240` elements and is complete.

7. These `240` minimal vectors map to the repository's independently
   formalized E8 root list.

8. An explicit unimodular change of basis relates the Construction A Gram
   matrix to the E8 Cartan matrix.

9. The theta series of the Construction A E8 lattice has coefficients
   `1` for `n = 0` and `240 * sigma_3(n)` for `n > 0`, hence agrees with the
   normalized Eisenstein series `E4`.

10. The local basis model is compared with the E8 model used by
    Sphere-Packing-Lean, giving a formal bridge from the code-built lattice to
    the analytic sphere-packing endpoint.

### Scope

We do not reprove Viazovska's analytic sphere-packing theorem.  We also do not
use the abstract classification theorem saying that there is a unique even
unimodular positive-definite lattice of rank eight.  Instead, the development
works concretely: basis matrices, Gram matrices, explicit shell counts,
explicit roots, and explicit transition maps carry the construction from the
code to E8.

This concrete approach has two advantages.  First, it gives a small,
reviewable formal proof of the code-to-lattice route.  Second, it makes all
normalization choices visible, which is essential when comparing Construction
A, root-system, theta-series, and Sphere-Packing-Lean conventions.

## 2. Mathematical Background

### 2.1 The Extended Hamming Code

Let `C` be the extended binary Hamming code of length eight.  Classically, this
is the unique Type II binary code of length eight.  It has parameters
`[8,4,4]`: length eight, dimension four, and minimum distance four.  Its weight
enumerator is

```text
W_C(x,y) = x^8 + 14 x^4 y^4 + y^8.
```

In Lean, `C` is not introduced merely by name.  It is defined by an explicit
parity-check matrix over `ZMod 2`, and the code properties are proved from that
definition.  The formalization records the column ordering of the matrix, since
many classical parity-check matrices for the same code differ by coordinate
permutation.

The promoted code-theoretic Lean declarations are:

```text
CodeLatticeE8.Code.extendedHamming8_isLinearCode_4_4
CodeLatticeE8.Code.extendedHamming8_doublyEven_mem
CodeLatticeE8.Code.extendedHamming8_selfDual
CodeLatticeE8.Code.extendedHamming8_typeII
CodeLatticeE8.Code.extendedHamming8_unique_up_to_equivalence
```

The first packages the `[8,4,4]` parameters, the second records the
doubly-even property used by Construction A, the next two prove self-duality
and Type II status, and the final theorem states that any binary linear
`[8,4,4]` code is coordinate-permutation equivalent to the chosen extended
Hamming code.

### 2.2 Construction A

For a binary code `C <= (ZMod 2)^n`, Construction A defines a subgroup of
integer vectors:

```text
A(C) = { z in Z^n : z mod 2 is in C }.
```

For the extended Hamming code, this produces an integer lattice in `Z^8`.  The
unscaled integer model has minimal squared norm `4`.  The usual E8
normalization divides the quadratic form by `2`, equivalently scaling all
coordinates by `1 / sqrt(2)`, so the standard E8 minimal squared norm is `2`.

The formalization uses the unscaled integer model for the direct Construction A
definition and then records the scaled form explicitly.  This avoids hiding the
factor of two that appears in theta coefficients, shell counts, and Gram
determinants.

### 2.3 E8 Metric and Root Data

The standard E8 root system has `240` roots, each of squared norm `2`.  In the
Construction A integer coordinates, these correspond to vectors of unscaled
squared norm `4`.  The formalization proves both the minimum norm statement and
the exact cardinality of the short-vector shell.

It then relates the short-vector shell to an independent root-list model in
the repository.  This gives a second confirmation that the code-built lattice
has the expected E8 root structure, beyond its determinant and parity
properties.

### 2.4 Theta Series and E4

The theta series of E8 is the generating function for shell counts:

```text
Theta_E8(q) = sum_{v in E8} q^{||v||^2 / 2}.
```

For the standard E8 lattice, the classical formula is:

```text
Theta_E8(q) = E4(q)
            = 1 + 240 * sum_{n > 0} sigma_3(n) q^n.
```

In the Construction A integer coordinates, coefficient `n` corresponds to the
unscaled shell condition `sqNorm z = 4 * n`.  The Lean proof keeps this
conversion explicit.  It first identifies the Construction A coefficient with
a Hamming weight-enumerator convolution, then transports shell counts to the E8
theta modular form, and finally compares that modular form with `E4`.

## 3. Formalization Architecture

The development is organized around a small number of interfaces.

### 3.1 Code and Construction A Layer

The generic binary-code and Construction A definitions live in:

```text
CodeLatticeE8/Code/Binary.lean
CodeLatticeE8/Code/Equivalence.lean
CodeLatticeE8/Code/LinearCode.lean
CodeLatticeE8/Code/Hamming844Basic.lean
CodeLatticeE8/Code/Hamming844WeightEnumerator.lean
CodeLatticeE8/Code/Hamming844.lean
CodeLatticeE8/Code/Hamming844Uniqueness.lean
CodeLatticeE8/ConstructionA/Basic.lean
CodeLatticeE8/ConstructionA/Norm.lean
CodeLatticeE8/ConstructionA/Even.lean
```

These files define binary vectors, Hamming weight, reduction mod `2`, the
extended Hamming code, weight distribution, the `[8,4,4]` parameter package,
Construction A as an integer subgroup, mod-four norm divisibility for
doubly-even codes, and uniqueness up to code equivalence.

### 3.2 Lattice and Root Layer

The Construction A lattice, its explicit basis, and its E8 root data are
organized through:

```text
CodeLatticeE8/E8/HammingConstruction.lean
CodeLatticeE8/E8/Basis.lean
CodeLatticeE8/E8/Span.lean
CodeLatticeE8/E8/Gram.lean
CodeLatticeE8/E8/Determinant.lean
```

The root-list, short-vector, Cartan-bridge, and Sphere-Packing-Lean comparison
files are still being promoted out of the research namespace.  The
citation-facing clean theorem index is:

```text
CodeLatticeE8/Publication/TheoremIndex.lean
```

### 3.3 Theta-Series Layer

The theta-series proof uses three linked ingredients.

First, `ConstructionAThetaConvolution.lean` proves that Construction A shell
counts can be computed from the Hamming weight distribution and the
one-dimensional even/odd lift coefficients.

Second, `E8ThetaDim8MF.lean` constructs the rank-eight E8 theta modular form
and proves its equality with `E4`:

```text
PhysicsSM.Coding.E8ThetaDim8.thetaE8_MF_eq_E4
```

Third, `E8ThetaMFBridgeAristotle.lean` identifies the q-expansion coefficients
of that modular form with the project-side Construction A shell counts:

```text
PhysicsSM.Coding.E8ThetaMFBridge
  .thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff
```

The final coefficient theorem is:

```text
PhysicsSM.Coding.E8ThetaSPLBridge
  .hammingThetaConvolutionCoeff_eq_e4Coeff
```

and the corresponding formal power-series equality is:

```text
PhysicsSM.Coding.E8ThetaSPLBridge
  .thetaSeries_eq_e4Series_from_hammingThetaConvolutionCoeff
```

### 3.4 Sphere-Packing-Lean Bridge

The bridge to Sphere-Packing-Lean uses explicit matrices and linear maps rather
than an abstract uniqueness theorem.  The local development reproduces the E8
basis matrix and compares Gram forms.  The imported bridge then gives a
coordinate map from the local Construction A model to `Submodule.E8 R`.

This layer matters because Sphere-Packing-Lean's analytic result is stated for
its own E8 object.  The present formalization provides the code-to-lattice
identification needed to view the extended Hamming code as a finite entrance to
that endpoint.

## 4. Main Formal Results

### 4.1 The Hamming Code Is the Type II Code of Length Eight

The Lean theorem

```text
theorem extendedHamming8_typeII :
    IsTypeII extendedHamming8
```

states that the explicitly defined code is self-dual and doubly even.  The
parameter theorem is:

```text
theorem extendedHamming8_isLinearCode_4_4 :
    IsLinearCode extendedHamming8 4 4
```

and the promoted doubly-even theorem used directly by Construction A is:

```text
theorem extendedHamming8_doublyEven_mem
    (v : BinaryVector 8) (hv : v in extendedHamming8) :
    4 divides hammingWeight v
```

This is the code-theoretic parity condition that makes the Construction A norm
divisible by four.

The uniqueness theorem is:

```text
theorem extendedHamming8_unique_up_to_equivalence
    (C : BinaryLinearCode 8) (hC : IsLinearCode C 4 4) :
    CodeEquivalent C extendedHamming8
```

This says that the chosen parity-check representation is not an arbitrary
example: it represents, up to coordinate permutation, the unique binary linear
code with parameters `[8,4,4]`.

### 4.2 The Construction A Lattice Has the E8 Gram Data

The Construction A subgroup comes with an explicit integer basis
`hammingConstructionBasis`.  The promoted spanning theorem is:

```text
theorem hammingConstructionASubmodule_eq_span :
    hammingConstructionASubmodule =
      Submodule.span Z (Set.range hammingConstructionBasis)
```

It states that the Construction A lattice is exactly the `Z`-span of this
basis.  The displayed Gram matrix is named `hammingConstructionGram`, and its
entrywise correctness theorem is:

```text
theorem hammingConstructionGram_eq :
    forall i j : Fin 8,
      hammingConstructionGram i j =
        sum k, hammingConstructionBasis i k * hammingConstructionBasis j k
```

Since the E8 normalization divides the quadratic form by `2`, the scaled Gram
matrix is:

```text
def hammingConstructionScaledGram : Matrix (Fin 8) (Fin 8) Q
```

with diagonal theorem:

```text
theorem hammingConstructionScaledGram_diag (i : Fin 8) :
    hammingConstructionScaledGram i i = 2
```

The determinant computation is now also in the clean package:

```text
theorem hammingConstructionGram_det :
    hammingConstructionGram.det = 256

theorem hammingConstructionScaledGram_det :
    hammingConstructionScaledGram.det = 1
```

These are proved through the explicit basis matrix rather than by expanding
the full `8 x 8` determinant directly: the basis matrix is block upper
triangular with a `4 x 4` determinant `-1` block and a `2 I_4` block, so its
determinant is `-16`; the raw Gram determinant is its square, and the scaled
Gram determinant is obtained by `Matrix.det_smul`.

Together with the divisibility theorem

```text
theorem hammingConstructionA_sqNorm_dvd_four
    (z : Fin 8 -> Z) (hz : z in hammingConstructionA) :
    (4 : Z) divides sqNorm z
```

these results give the clean integral basis, Gram, determinant, and evenness
package.

### 4.3 Minimum Norm and Kissing Number

The scaled minimum norm theorem is:

```text
theorem hammingConstructionA_scaledMinSqNorm :
    (forall z, z in hammingConstructionA -> z != 0 -> 2 <= scaledSqNorm z) and
    (exists z, z in hammingConstructionA and z != 0 and scaledSqNorm z = 2)
```

The exact short-vector count is:

```text
theorem short_vector_count :
    shortHammingE8VectorList.length = 240
```

Completeness is supplied by:

```text
theorem short_vector_list_complete
    (z : Fin 8 -> Z) (hz : isShortHammingE8Vector z) :
    z in shortHammingE8VectorList
```

Thus the Construction A lattice has the E8 kissing number.  In unscaled
coordinates, the short shell is `sqNorm z = 4`; in the scaled E8 normalization,
this is squared norm `2`.

### 4.4 The Root and Cartan Bridges

The short-vector shell is compared to an independently defined E8 root list.
The paper-facing permutation theorem is:

```text
theorem bridge_perm :
    (shortHammingE8VectorList.map E8RootBridge.shortVectorToDoubledRoot).Perm
      E8Root.rootList
```

This theorem says that the Construction A short vectors, after the explicit
doubled-coordinate bridge map, are precisely the root-list model.

The Cartan bridge is:

```text
theorem gram_cartan_bridge :
    ...
```

It states that an explicit unimodular transition matrix carries the
Construction A Gram matrix to the standard E8 Cartan form.  This provides a
matrix-level identification of the code-built lattice with the root-system
presentation.

### 4.5 Theta_E8 = E4

Let `hammingThetaConvolutionCoeff n` be the Construction A coefficient at
theta index `n`; by convention, this counts the unscaled shell
`sqNorm z = 4 * n` after grouping by Hamming codeword weight.  The formal
coefficient theorem is:

```text
theorem hammingThetaConvolutionCoeff_eq_e4Coeff (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n
```

This is the all-coefficient E8 representation-number formula in the project's
normalization.  The formal power-series conclusion is:

```text
theorem thetaSeries_eq_e4Series_from_hammingThetaConvolutionCoeff :
    E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series
```

The proof factors through the modular-form theorem:

```text
theorem thetaE8_MF_eq_E4 : thetaE8_MF = E4
```

and the q-expansion bridge:

```text
theorem thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff
    (n : Nat) :
    (qExpansion 1 thetaE8_MF).coeff n =
      (hammingThetaConvolutionCoeff n : C)
```

The mathematical content of the bridge is that the Fourier coefficient of the
rank-eight theta modular form is the cardinality of the E8 shell of squared
norm `2n`, and that this shell is bijective with the Construction A shell
`sqNorm z = 4n`.

### 4.6 Bridge to Sphere-Packing-Lean

Sphere-Packing-Lean uses its own E8 basis and lattice object.  The local
formalization compares the Construction A basis to that object by explicit
linear algebra.

The key point is not merely that both lattices have the same determinant or
the same number of roots.  The bridge supplies concrete maps between coordinate
models and proves the corresponding inner-product formula.  Thus the Hamming
Construction A lattice is connected directly to the E8 object used by the
formalized analytic sphere-packing proof.

## 5. Proof Ideas

### 5.1 From the Code to the Lattice

The Construction A proof is deliberately concrete.  Membership in the lattice
is defined by reduction mod `2` into the Hamming code.  The explicit basis is
then shown to span exactly this subgroup.  The Gram matrix is computed from
the basis, and the determinant and divisibility properties are proved from the
matrix and code equations.

This avoids invoking a broad theorem saying that Type II codes always give
even unimodular lattices.  Such a theorem would be elegant, and would be a good
future abstraction, but for this paper the explicit rank-eight proof gives a
smaller and more auditable formal object.

### 5.2 The Short-Vector Shell

The short vectors split into the two familiar E8 families.  In Construction A
integer coordinates, vectors of squared norm `4` arise from:

1. coordinate spikes `(+/- 2)` in one coordinate, reducing to the zero
   codeword; and

2. sign choices on four coordinates supported on a weight-four Hamming
   codeword.

The weight distribution `(1, 14, 1)` explains the cardinality:

```text
16 + 14 * 16 = 240.
```

The Lean proof packages this as an explicit finite list and proves both
soundness and completeness for the short-vector predicate.

### 5.3 The Theta-Series Proof

The coefficient proof follows the classical theta-series route, but each
normalization step is explicit.

The Construction A side first proves a convolution theorem.  Fixing a binary
residue word, the number of integer lifts with a given squared norm is a
product of one-dimensional even or odd lift counts.  Summing over Hamming
codewords and grouping by weight gives the function
`hammingThetaConvolutionCoeff`.

The analytic side constructs a rank-eight theta modular form, proves its
equality with `E4`, and extracts q-expansion coefficients as shell counts.
The final bridge proves that the analytic E8 shell and the Construction A shell
are in bijection with the correct factor of two in the norm:

```text
sqNorm_ConstructionA(z) = 4n
    <-> ||phi(z)||^2 = 2n.
```

Combining these facts yields the coefficient formula
`1` at `n = 0` and `240 * sigma3 n` for `n > 0`.

### 5.4 Why an Explicit SPL Bridge Matters

The theorem `Theta_E8 = E4` identifies the theta series abstractly, but the
sphere-packing endpoint is phrased for the E8 model used inside
Sphere-Packing-Lean.  The explicit matrix and lattice bridges ensure that the
code-built lattice and the SPL lattice are not merely isomorphic in principle;
they are connected by named Lean maps and inner-product statements.

This is the central formalization lesson of the paper.  In ordinary
mathematical prose, one often moves freely among equivalent E8 presentations.
In Lean, every such move becomes a theorem.  The benefit is that the final
statement carries no hidden convention shift.

## 6. Verification and Trust Boundary

The repository is pinned to Lean 4.28.0.  The main theorem statements cited in
this paper should be checked by building the relevant Lean modules under the
pinned toolchain.

Minimal checks for the local theorem index:

```text
lake build CodeLatticeE8
```

Checks for the theta-series route:

```text
lake build PhysicsSM.Draft.E8ThetaDim8MF
lake build PhysicsSM.Draft.E8ThetaMFBridgeAristotle
lake build PhysicsSM.Draft.E8ThetaCoeffGapAristotle
```

Checks for the full draft aggregation:

```text
lake build PhysicsSMDraft
```

Appendix B lists the theorem names and files used in the paper.  Appendix H
records the intended final verification checklist, including axiom reports for
the theorem declarations that form the paper spine.

## 7. Related Work

The classical mathematical background is the code-lattice theory developed in
MacWilliams and Sloane, Conway and Sloane, and later lattice and coding-theory
texts.  The extended Hamming code is the smallest Type II binary code, and
Construction A applied to it is the standard coding-theoretic construction of
E8.

Sphere-Packing-Lean formalizes the analytic endpoint of the dimension-eight
sphere-packing theorem, following the Cohn-Elkies linear-programming method and
Viazovska's construction.  The present work is not a replacement for that
analytic formalization.  Instead, it supplies a formal combinatorial bridge to
the E8 object used there.

Recent Lean formalizations of coding theory, self-dual codes, and related
algebraic constructions provide adjacent infrastructure.  This paper differs
in focus: it follows one specific code all the way to the exceptional lattice
and then connects the result to root-system, theta-series, and sphere-packing
models.

## 8. Conclusion

The extended Hamming code is a compact finite object.  In this formalization it
serves as a front door to E8: from a parity-check matrix over `ZMod 2`, Lean
constructs a lattice, computes its Gram form, proves its minimal-vector
structure, identifies its root data, proves its theta-series formula, and
bridges it to the E8 lattice used by Sphere-Packing-Lean.

The result is a verified path through several classical E8 presentations.  It
also provides reusable infrastructure for future work: Golay-to-Leech
Construction A, theta-series identities for other lattices, and physics-facing
code-lattice constructions such as `E8 x E8` models.

# Appendix A. Conventions and Normalizations

The paper uses the following models.

| Model | Ambient type | Short squared norm | Role |
|-------|--------------|--------------------|------|
| Construction A integer model | `Fin 8 -> Z` | `4` | Direct output of Construction A |
| Scaled E8 model | same basis, form divided by `2` | `2` | Standard E8 normalization |
| Doubled root model | `Fin 8 -> Z` | `8` in doubled coordinates | Root-list bridge |
| SPL model | `EuclideanSpace R (Fin 8)` / `Submodule.E8 R` | `2` | Sphere-Packing-Lean convention |

The theta coefficient indexed by `n` counts the unscaled Construction A shell

```text
sqNorm z = 4 * n.
```

Under the bridge to the standard E8 normalization, this becomes

```text
||phi(z)||^2 = 2 * n.
```

This is the most important normalization in the theta-series proof.

# Appendix B. Lean Theorem Index

The following table gives the primary theorem names for the paper.

| Mathematical claim | Lean declaration | File |
|--------------------|------------------|------|
| Extended Hamming code has parameters `[8,4,4]` | `CodeLatticeE8.Code.extendedHamming8_isLinearCode_4_4` | `CodeLatticeE8/Code/Hamming844.lean` |
| Extended Hamming code is doubly even | `CodeLatticeE8.Code.extendedHamming8_doublyEven_mem` | `CodeLatticeE8/Code/Hamming844.lean` |
| Extended Hamming code is self-dual | `CodeLatticeE8.Code.extendedHamming8_selfDual` | `CodeLatticeE8/Code/Dual.lean` |
| Extended Hamming code is Type II | `CodeLatticeE8.Code.extendedHamming8_typeII` | `CodeLatticeE8/Code/Dual.lean` |
| `[8,4,4]` uniqueness | `CodeLatticeE8.Code.extendedHamming8_unique_up_to_equivalence` | `CodeLatticeE8/Code/Hamming844Uniqueness.lean` |
| Construction A minimum unscaled norm `4` | `CodeLatticeE8.E8.hammingConstructionA_minSqNorm` | `CodeLatticeE8/E8/HammingConstruction.lean` |
| Construction A norm divisibility | `CodeLatticeE8.E8.hammingConstructionA_sqNorm_dvd_four` | `CodeLatticeE8/E8/HammingConstruction.lean` |
| Explicit basis membership | `CodeLatticeE8.E8.hammingConstructionBasis_mem` | `CodeLatticeE8/E8/Basis.lean` |
| Explicit basis spans the lattice | `CodeLatticeE8.E8.hammingConstructionASubmodule_eq_span` | `CodeLatticeE8/E8/Span.lean` |
| Unscaled Gram matrix entries | `CodeLatticeE8.E8.hammingConstructionGram_eq` | `CodeLatticeE8/E8/Basis.lean` |
| Scaled Gram diagonal has root norm `2` | `CodeLatticeE8.E8.hammingConstructionScaledGram_diag` | `CodeLatticeE8/E8/Gram.lean` |
| Scaled Gram entries are integral | `CodeLatticeE8.E8.hammingConstructionScaledGram_int_valued` | `CodeLatticeE8/E8/Gram.lean` |
| Minimum squared norm `2` | `CodeLatticeE8.E8.hammingConstructionA_scaledMinSqNorm` | `CodeLatticeE8/E8/Minimum.lean` |
| Unscaled Gram determinant | `CodeLatticeE8.E8.hammingConstructionGram_det` | `CodeLatticeE8/E8/Determinant.lean` |
| Scaled Gram determinant | `CodeLatticeE8.E8.hammingConstructionScaledGram_det` | `CodeLatticeE8/E8/Determinant.lean` |
| Even/unimodular package | `HammingConstructionAE8Final.property_package` | `PhysicsSM/Coding/HammingConstructionAE8Final.lean` |
| Kissing number `240` | `HammingConstructionAE8Final.short_vector_count` | `PhysicsSM/Coding/HammingConstructionAE8Final.lean` |
| Short-vector completeness | `HammingConstructionAE8Final.short_vector_list_complete` | `PhysicsSM/Coding/HammingConstructionAE8Final.lean` |
| Root-list bridge | `HammingConstructionAE8Final.bridge_perm` | `PhysicsSM/Coding/HammingConstructionAE8Final.lean` |
| Cartan bridge | `HammingConstructionAE8Final.gram_cartan_bridge` | `PhysicsSM/Coding/HammingConstructionAE8Final.lean` |
| E8 theta modular form equals `E4` | `E8ThetaDim8.thetaE8_MF_eq_E4` | `PhysicsSM/Draft/E8ThetaDim8MF.lean` |
| Construction A shell to E8 shell | `E8ThetaMFBridge.constructionAShellSet_ncard_eq_e8Shell` | `PhysicsSM/Draft/E8ThetaMFBridgeAristotle.lean` |
| q-expansion coefficient extraction | `E8ThetaMFBridge.thetaE8_MF_qExpansion_coeff_eq_e8Shell` | `PhysicsSM/Draft/E8ThetaMFBridgeAristotle.lean` |
| q-expansion to Hamming coefficient | `E8ThetaMFBridge.thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff` | `PhysicsSM/Draft/E8ThetaMFBridgeAristotle.lean` |
| E8 representation formula | `E8ThetaSPLBridge.hammingThetaConvolutionCoeff_eq_e4Coeff` | `PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean` |
| Formal theta series equals formal `E4` | `E8ThetaSPLBridge.thetaSeries_eq_e4Series_from_hammingThetaConvolutionCoeff` | `PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean` |

# Appendix C. Hamming Code Details

The extended Hamming code is defined by an explicit parity-check matrix over
`ZMod 2`.  Four parity equations determine a four-dimensional subspace of
`(ZMod 2)^8`.  The formal development proves:

1. the code has `16` codewords;
2. the minimum nonzero Hamming weight is `4`;
3. every codeword has weight divisible by `4`;
4. the code is self-dual;
5. the weight distribution is `(1, 14, 1)`;
6. every binary linear `[8,4,4]` code is equivalent to it.

The weight enumerator is:

```text
W_C(x,y) = x^8 + 14 x^4 y^4 + y^8.
```

This polynomial is the finite combinatorial input for the Construction A
theta-series computation.

# Appendix D. Construction A Basis and Gram Data

The Construction A lattice is

```text
{ z in Z^8 : z mod 2 in extendedHamming8 }.
```

The clean formalization gives an explicit basis `hammingConstructionBasis`.
The theorem `hammingConstructionASubmodule_eq_span` proves that this basis spans
the Construction A submodule.  From this basis it computes the Gram matrix
`hammingConstructionGram` and proves:

```text
hammingConstructionGram i j =
  sum k, hammingConstructionBasis i k * hammingConstructionBasis j k.
```

Because the E8 normalization divides the quadratic form by `2`, the clean
package defines the rational scaled Gram matrix `hammingConstructionScaledGram`
and proves:

```text
hammingConstructionScaledGram i i = 2.
```

The determinant proof is also cleanly packaged.  The basis matrix determinant
is proved by a block-upper-triangular decomposition, and the resulting Gram
determinant theorems are:

```text
hammingConstructionGram.det = 256
hammingConstructionScaledGram.det = 1.
```

The same basis supports the Cartan comparison.  An explicit unimodular
transition matrix carries the Construction A Gram form to the standard E8
Cartan form, which gives a basis-level root-system identification.

# Appendix E. Short Vectors and Roots

In unscaled Construction A coordinates, the short shell is:

```text
{ z in A(C) : sqNorm z = 4 }.
```

The formal proof classifies this shell by Hamming residue.

The zero residue contributes the coordinate spikes:

```text
(0, ..., +/-2, ..., 0),
```

giving `16` vectors.

Each weight-four codeword contributes sign choices on its support:

```text
(+/-1, +/-1, +/-1, +/-1)
```

with `16` choices per support.  Since there are `14` weight-four codewords,
this contributes `14 * 16 = 224` vectors.  Hence the total is:

```text
16 + 224 = 240.
```

The Lean development proves not only this count, but also that the explicit
short-vector list is complete and maps to the repository's E8 root list.

# Appendix F. Theta-Series Details

The Construction A theta coefficient at index `n` is the cardinality of:

```text
{ z in A(C) : sqNorm z = 4 * n }.
```

The formal convolution theorem decomposes this shell count by binary residue.
For a fixed residue, every coordinate contributes either an even lift count or
an odd lift count.  Multiplying across coordinates and summing over all
partitions of the norm gives `weightContribConvolution`.  Grouping codewords
by Hamming weight gives:

```text
hammingThetaConvolutionCoeff n =
  A_0 * weightContribConvolution 0 (4*n)
  + A_4 * weightContribConvolution 4 (4*n)
  + A_8 * weightContribConvolution 8 (4*n),
```

where

```text
A_0 = 1,  A_4 = 14,  A_8 = 1.
```

The analytic comparison uses the E8 theta modular form `thetaE8_MF`.  Its
q-expansion coefficient at `n` is identified with the standard E8 shell
`||v||^2 = 2n`.  The shell bridge identifies this with the Construction A
shell `sqNorm z = 4n`.

Finally, the modular-form theorem proves:

```text
thetaE8_MF = E4.
```

The q-expansion of `E4` gives the coefficient formula:

```text
coeff_0 = 1,
coeff_n = 240 * sigma_3(n) for n > 0.
```

# Appendix G. Sphere-Packing-Lean Bridge

The local code-built lattice and the Sphere-Packing-Lean E8 lattice use
different coordinate models.  The formal bridge records:

1. a local reproduction of the relevant SPL-shaped E8 basis matrix;
2. Gram matrix comparison with the local Construction A scaled Gram form;
3. a coordinate transition map;
4. a lattice equivalence with `Submodule.E8 R`;
5. an inner-product preservation formula.

This bridge is what allows the manuscript to say that the extended Hamming code
constructs the E8 lattice used at the formalized sphere-packing endpoint.

# Appendix H. Verification Checklist

Before submission, run:

```text
lake build CodeLatticeE8
lake build CodeLatticeE8SPL
lake build CodeLatticeE8Draft
lake build PhysicsSM.Draft.E8ThetaDim8MF
lake build PhysicsSM.Draft.E8ThetaMFBridgeAristotle
lake build PhysicsSM.Draft.E8ThetaCoeffGapAristotle
lake build PhysicsSMDraft
```

For each theorem cited in Appendix B, record:

1. the Lean declaration name;
2. the file;
3. whether the containing module builds under the pinned toolchain;
4. the axiom report;
5. whether the theorem is intended for trusted code or remains in a
   draft-facing bridge module.

The final paper should include only claims backed by checked theorem
declarations and should keep convention-sensitive statements tied to their
Lean names.

# Appendix I. Bibliography Checklist

The bibliography should include at least:

- Hamming, "Error Detecting and Error Correcting Codes", 1950.
- MacWilliams and Sloane, *The Theory of Error-Correcting Codes*, 1977.
- Huffman and Pless, *Fundamentals of Error-Correcting Codes*, 2003.
- Conway and Sloane, *Sphere Packings, Lattices and Groups*.
- Bourbaki, chapters on root systems and E8.
- Cohn and Elkies, "New upper bounds on sphere packings I".
- Viazovska, "The sphere packing problem in dimension 8".
- The Sphere-Packing-Lean blueprint and formalization report.
- Error Correction Zoo and Nebe-Sloane catalogue entries as public
  cross-checks for the code-lattice construction.

Exact page, chapter, theorem, and blueprint-section references should be filled
in from `Sources/Hamming_E8_Zotero_Source_Map.md` before submission.
