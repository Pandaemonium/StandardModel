import CodeLatticeE8.Code.Dual
import CodeLatticeE8.Code.Hamming844Uniqueness
import CodeLatticeE8.ConstructionA.TypeII
import CodeLatticeE8.E8.Basis
import CodeLatticeE8.E8.Gram
import CodeLatticeE8.E8.Determinant
import CodeLatticeE8.E8.HammingConstruction
import CodeLatticeE8.E8.Minimum
import CodeLatticeE8.E8.Span
import CodeLatticeE8.E8.ShortVectors
import CodeLatticeE8.E8.Roots
import CodeLatticeE8.E8.RootBridge
import CodeLatticeE8.E8.CartanBridge
import CodeLatticeE8.E8.WeylReflections
import CodeLatticeE8.E8.ThetaCoefficients
import CodeLatticeE8.E8.ThetaSeries
import CodeLatticeE8.Octonion.Octavian

/-!
# Theorem index

This module is the index for declarations currently promoted
to the standalone `CodeLatticeE8` root.

For the prose audit trail, see:

- `Sources/CodeLatticeE8_Publication_Theorem_Map.md`;
- `Sources/CodeLatticeE8_Trust_Report.md`.

## Trust profile

The root-list enumeration/completeness facts, the short-vector count, the
root-bridge permutation chain, the Cartan determinant,
`gramCartan_congruence`, `e8SimpleRoots_gram`, small theta arithmetic, the
Construction A theta convolution theorem, and the Weyl reflection closure
theorems are now proved without compiler-trusted native evaluation.  The theta
material in this root is finite/combinatorial; it is not the unbounded analytic
theta theorem.

## Coding-theory layer

Foundational definitions:

- `CodeLatticeE8.Code.BinaryVector`
- `CodeLatticeE8.Code.BinaryLinearCode`
- `CodeLatticeE8.Code.hammingWeight`
- `CodeLatticeE8.Code.IsLinearCode`
- `CodeLatticeE8.Code.CodeEquivalent`

Concrete extended Hamming code:

- `CodeLatticeE8.Code.extendedHamming8ParityCheck`
- `CodeLatticeE8.Code.extendedHamming8`
- `CodeLatticeE8.Code.extendedHamming8WeightDist`

Weight distribution and parameters:

- `CodeLatticeE8.Code.extendedHamming8_weight_zero_count`
- `CodeLatticeE8.Code.extendedHamming8_weight_four_count`
- `CodeLatticeE8.Code.extendedHamming8_weight_eight_count`
- `CodeLatticeE8.Code.extendedHamming8_weight_distribution`
- `CodeLatticeE8.Code.extendedHamming8_finrank`
- `CodeLatticeE8.Code.extendedHamming8_minWeight`
- `CodeLatticeE8.Code.extendedHamming8_doublyEven`
- `CodeLatticeE8.Code.extendedHamming8_isLinearCode_4_4`
- `CodeLatticeE8.Code.dualCode`
- `CodeLatticeE8.Code.IsSelfDual`
- `CodeLatticeE8.Code.IsTypeII`
- `CodeLatticeE8.Code.extendedHamming8_selfDual`
- `CodeLatticeE8.Code.extendedHamming8_typeII`

Uniqueness:

- `CodeLatticeE8.Code.extendedHamming8_unique_up_to_equivalence`

Construction A:

- `CodeLatticeE8.ConstructionA.reduceModTwo`
- `CodeLatticeE8.ConstructionA.lattice`
- `CodeLatticeE8.ConstructionA.sqNorm`
- `CodeLatticeE8.ConstructionA.lattice_sqNorm_ge_four`
- `CodeLatticeE8.ConstructionA.sqNorm_mod_four_eq_hammingWeight_mod_four`
- `CodeLatticeE8.ConstructionA.sqNorm_dvd_four_of_doublyEven`
- `CodeLatticeE8.ConstructionA.intDot`
- `CodeLatticeE8.ConstructionA.binaryLift`
- `CodeLatticeE8.ConstructionA.scaledDualInt`
- `CodeLatticeE8.ConstructionA.scaledDualInt_eq_lattice_of_selfDual`
- `CodeLatticeE8.ConstructionA.typeII_integer_package`
- `CodeLatticeE8.ConstructionA.scaledReal`
- `CodeLatticeE8.ConstructionA.scaledReal_even_of_doublyEven`
- `CodeLatticeE8.ConstructionA.scaledRealDual_eq_self_of_selfDual`

Hamming Construction A integer lattice:

- `CodeLatticeE8.E8.hammingConstructionA`
- `CodeLatticeE8.E8.mem_hammingConstructionA_iff`
- `CodeLatticeE8.E8.hammingConstructionA_sqNorm_ge_four`
- `CodeLatticeE8.E8.hammingConstructionA_sqNorm_dvd_four`
- `CodeLatticeE8.E8.hammingConstructionA_minSqNorm`
- `CodeLatticeE8.E8.hammingConstructionBasis`
- `CodeLatticeE8.E8.hammingConstructionBasisMatrix`
- `CodeLatticeE8.E8.hammingConstructionBasisMatrix_det`
- `CodeLatticeE8.E8.hammingConstructionBasis_mem`
- `CodeLatticeE8.E8.hammingConstructionGram`
- `CodeLatticeE8.E8.hammingConstructionGram_eq`
- `CodeLatticeE8.E8.hammingConstructionGram_eq_basisMatrix_mul_transpose`
- `CodeLatticeE8.E8.hammingConstructionGram_det`
- `CodeLatticeE8.E8.intDot`
- `CodeLatticeE8.E8.intDot_basis_eq_gram`
- `CodeLatticeE8.E8.hammingConstructionASubmodule`
- `CodeLatticeE8.E8.hammingConstructionBasisCoeffs`
- `CodeLatticeE8.E8.hammingConstructionBasis_reconstruction`
- `CodeLatticeE8.E8.hammingConstructionBasis_spans`
- `CodeLatticeE8.E8.hammingConstructionASubmodule_eq_span`
- `CodeLatticeE8.E8.hammingConstructionScaledGram`
- `CodeLatticeE8.E8.hammingConstructionScaledGram_diag`
- `CodeLatticeE8.E8.hammingConstructionScaledGram_int_valued`
- `CodeLatticeE8.E8.hammingConstructionScaledGram_eq_smul_map`
- `CodeLatticeE8.E8.hammingConstructionScaledGram_det`
- `CodeLatticeE8.E8.scaledSqNorm_basis`
- `CodeLatticeE8.E8.hammingConstructionA_scaledSqNorm_ge_two`
- `CodeLatticeE8.E8.hammingConstructionA_scaledMinSqNorm`

Short vectors (E8 root count):

- `CodeLatticeE8.E8.hammingE8ShortShell` — the set of Hamming Construction A
  vectors with unscaled squared norm four; these are the E8 roots under `1/√2`
  scaling.
- `CodeLatticeE8.E8.coordinate_abs_le_two_of_short` — every coordinate of a
  short vector lies in `{-2,-1,0,1,2}`.
- `CodeLatticeE8.E8.not_short_of_weight8` — the all-ones Hamming codeword
  contributes no short vectors (structural proof: eight odd coordinates force
  `sqNorm ≥ 8 > 4`).
- `CodeLatticeE8.E8.hammingConstructionA_short_vector_count` — the short shell
  has exactly **240** elements (the E8 kissing number), via private finite
  parametrizations of the weight-0 and weight-4 classes.

E8 root system in doubled coordinates:

- `CodeLatticeE8.E8.Roots.normSq` — doubled squared norm `∑ (v i)^2` (equals 8 for E8 roots).
- `CodeLatticeE8.E8.Roots.dot` — doubled inner product `∑ v i * w i`.
- `CodeLatticeE8.E8.Roots.IsE8Root` — semantic root predicate: `normSq = 8`, uniform parity,
  coordinate sum divisible by 4.
- `CodeLatticeE8.E8.Roots.type1Roots` — the 112 type-1 roots (two entries `±2`, rest `0`).
- `CodeLatticeE8.E8.Roots.type2Roots` — the 128 type-2 roots
  (all entries `±1`, even number of `-1`).
- `CodeLatticeE8.E8.Roots.rootList` — the complete 240-element root list.
- `CodeLatticeE8.E8.Roots.rootList_length` — `rootList.length = 240`.
- `CodeLatticeE8.E8.Roots.rootList_nodup` — no duplicate entries.
- `CodeLatticeE8.E8.Roots.coordinate_abs_le_two_of_normSq8` — structural proof that any
  root has coordinates bounded by `2` in absolute value.
- `CodeLatticeE8.E8.Roots.isE8Root_of_mem` — every list element satisfies `IsE8Root`.
- `CodeLatticeE8.E8.Roots.rootList_complete` — every `IsE8Root` vector appears in the list.
- `CodeLatticeE8.E8.Roots.mem_rootList_iff_isE8Root` — biconditional: the list exactly
  characterises the semantic root predicate.
- `CodeLatticeE8.E8.Roots.neg_mem_rootList` — the root list is closed under negation.

Bridge between the Construction A short shell and the E8 root list:

- `CodeLatticeE8.E8.RootBridge.hadamardBridgeMatrix` — the Sylvester-Hadamard
  matrix used by the coordinate bridge.
- `CodeLatticeE8.E8.RootBridge.hadamardBridgeMatrix_self_mul` — orthogonality
  of the bridge matrix up to the scalar factor `8`.
- `CodeLatticeE8.E8.RootBridge.hadamardBridgeMatrix_symmetric` — symmetry of
  the bridge matrix.
- `CodeLatticeE8.E8.RootBridge.hadamard_sqNorm_scale` — algebraic norm-scaling
  identity `||H z||^2 = 8 ||z||^2` for the bridge matrix.
- `CodeLatticeE8.E8.RootBridge.shortShellVectorList` — explicit list of the
  240 Construction A short vectors.
- `CodeLatticeE8.E8.RootBridge.shortVectorToRootCoords` — coordinate map from
  Construction A short vectors to doubled-coordinate E8 roots.
- `CodeLatticeE8.E8.RootBridge.shortShell_mem_shortShellVectorList` — every
  semantic short-shell vector appears in the explicit list.
- `CodeLatticeE8.E8.RootBridge.shortVectorToRootCoords_mem_rootList` — every
  Construction A short shell vector maps into `Roots.rootList` under the bridge map.
- `CodeLatticeE8.E8.RootBridge.rootList_preimage_in_shortShell` — every root in
  `Roots.rootList` has a preimage in `hammingE8ShortShell`.
- `CodeLatticeE8.E8.RootBridge.shortShell_perm_rootList` — **main bijection**: the
  bridge map sends the 240 short shell vectors to a permutation of `Roots.rootList`,
  witnessing a complete bijection between the two coordinate models of the E8 root system.
  This now follows from nodup, subset, and length lemmas rather than from a
  monolithic 240-by-240 list comparison.
- `CodeLatticeE8.E8.RootBridge.shortVectorToRootCoords_normSq` — norm preservation:
  short shell vectors with unscaled `sqNorm = 4` map to doubled-coordinate roots with
  `normSq = 8` (both encode the same E8 root squared norm `2`).

Cayley-Dickson octonion layer:

- `CodeLatticeE8.Octonion.fanoTriples` -- the seven positive triples fixing
  the package Cayley-Dickson convention.
- `CodeLatticeE8.Octonion.xorIndex` -- bitwise XOR on the three-bit basis
  labels.
- `CodeLatticeE8.Octonion.sign` -- the basis-product sign table.
- `CodeLatticeE8.Octonion.mulInt` -- integer-coordinate octonion
  multiplication.
- `CodeLatticeE8.Octonion.normSqInt_mulInt` -- norm multiplicativity for the
  Cayley-Dickson product.
- `CodeLatticeE8.Octonion.octavianUnitMul` -- normalized product on doubled
  coordinates for the Construction A short shell.
- `CodeLatticeE8.Octonion.two_dvd_mulInt_of_hammingConstructionA` -- the
  Cayley-Dickson product of two Hamming Construction A vectors has even
  integer coordinates, proved by bilinearity and the explicit Construction A
  basis.
- `CodeLatticeE8.Octonion.two_mul_octavianUnitMul_eq_mulInt` -- exactness of
  the coordinatewise division by two in the normalized product.
- `CodeLatticeE8.Octonion.octavianUnitMul_mem_hammingConstructionA` -- the
  normalized product closes on the full Hamming Construction A octavian order.
- `CodeLatticeE8.Octonion.octavianUnitMul_sqNorm` -- product of two short-shell
  vectors has unscaled squared norm four.
- `CodeLatticeE8.Octonion.octavianUnitMul_mem_shortShell` -- the 240 octavian
  units are closed under normalized Cayley-Dickson multiplication.
- `CodeLatticeE8.Octonion.octavianUnitMul_mem_shortShell_of_mem_coordinateShortVectorList`
  -- closure of the normalized product on the 16 coordinate units, retained as
  an independent coordinate-unit certificate.

Gram-Cartan bridge (E8 root system structure):

- `CodeLatticeE8.E8.e8CartanMatrix` — the E8 Cartan matrix in Bourbaki labelling;
  diagonal entries `2`, adjacent-node entries `−1`, all others `0`.
- `CodeLatticeE8.E8.e8CartanMatrix_diag` — diagonal entries equal `2`.
- `CodeLatticeE8.E8.e8CartanMatrix_offDiag` — off-diagonal entries in `{0, −1}`.
- `CodeLatticeE8.E8.e8CartanMatrix_symm` — the Cartan matrix is symmetric.
- `CodeLatticeE8.E8.e8CartanMatrix_det` — determinant equals `1` (E8 unimodularity),
  proved by nested cofactor expansion reducing to four 6×6 kernel checks.
- `CodeLatticeE8.E8.e8BasisChangeMatrix` — the unimodular change-of-basis matrix `P`
  expressing E8 simple roots as ℤ-linear combinations of the Construction A basis.
- `CodeLatticeE8.E8.gramCartan_congruence` — **main bridge**: `Pᵀ G P = 2 · Cartan`
  (ordinary `decide` over 64 integer matrix entries).
- `CodeLatticeE8.E8.e8BasisChangeMatrix_det_sq` — algebraic unimodularity: `det(P)² = 1`,
  derived from the bridge and the Gram determinant without direct 8×8 computation.
- `CodeLatticeE8.E8.e8BasisChangeMatrix_isUnit` — `P` is invertible over ℤ.
- `CodeLatticeE8.E8.e8SimpleRoots` — the 8 E8 simple roots in Construction A coordinates.
- `CodeLatticeE8.E8.e8SimpleRoots_mem` — each simple root belongs to `hammingConstructionA`.
- `CodeLatticeE8.E8.e8SimpleRoots_gram` — inner products reproduce the E8 Dynkin diagram:
  `intDot (e8SimpleRoots i) (e8SimpleRoots j) = 2 · e8CartanMatrix i j`.
- `CodeLatticeE8.E8.e8SimpleRoots_sqNorm` — each simple root has unscaled squared norm `4`.

Weyl reflections:

- `CodeLatticeE8.E8.WeylReflections.reflectionCoeff` — the integral coefficient
  `Roots.dot v r / 4` in the doubled-coordinate reflection formula.
- `CodeLatticeE8.E8.WeylReflections.reflect` — Weyl reflection through a root:
  `v - (Roots.dot v r / 4) * r`.
- `CodeLatticeE8.E8.WeylReflections.dot_div_four_of_isE8Root` — semantic
  divisibility theorem: two vectors satisfying `Roots.IsE8Root` have doubled
  inner product divisible by `4`.
- `CodeLatticeE8.E8.WeylReflections.reflect_preserves_IsE8Root` — semantic
  closure of the E8 root predicate under reflection.
- `CodeLatticeE8.E8.WeylReflections.reflect_involutive_of_isE8Root` — semantic
  involutivity of reflection through an E8 root.
- `CodeLatticeE8.E8.WeylReflections.dot_mod_four_eq_zero_of_mem` — for root
  pairs, the doubled inner product is divisible by `4`, so the reflection
  coefficient is exact.
- `CodeLatticeE8.E8.WeylReflections.reflect_mem_rootList` — the 240 E8 roots
  are closed under reflections through roots.
- `CodeLatticeE8.E8.WeylReflections.reflect_reflect_of_mem` — reflection through
  a root is involutive on the root list.
- `CodeLatticeE8.E8.WeylReflections.reflect_self_eq_neg_of_normSq` — structural
  self-reflection theorem from the doubled norm hypothesis alone.
- `CodeLatticeE8.E8.WeylReflections.reflect_self_eq_neg` — reflecting a root
  through itself gives its negative.
- `CodeLatticeE8.E8.WeylReflections.normSq_reflect_of_mem` — Weyl reflections
  preserve doubled squared norm `8` on roots.

Theta coefficients and contribution table:

- `CodeLatticeE8.Theta.sigma3` — sum of cubes of divisors.
- `CodeLatticeE8.Theta.e4Coeff` — normalized `E4` coefficient function,
  including the constant term.
- `CodeLatticeE8.E8.hammingE8Shell` — semantic unscaled Construction A shell.
- `CodeLatticeE8.E8.hammingE8Shell_zero_ncard` — the zero shell has one vector.
- `CodeLatticeE8.E8.hammingE8Shell_four_ncard` — the unscaled norm-four shell
  has 240 vectors.
- `CodeLatticeE8.constructionAShellSet` — semantic Construction A shell at a
  natural unscaled squared norm.
- `CodeLatticeE8.weightContribConvolution` — canonical one-weight lift count
  used in the Construction A convolution.
- `CodeLatticeE8.constructionAShellCount_eq_weight_distribution_convolution`
  — all-shell Construction A convolution theorem for the extended Hamming code.
- `CodeLatticeE8.E8.semanticThetaCoeff_eq_e4Coeff_zero` — semantic `q^0`
  coefficient agrees with `E4`.
- `CodeLatticeE8.E8.semanticThetaCoeff_eq_e4Coeff_one` — semantic `q^1`
  coefficient agrees with `E4`.
- `CodeLatticeE8.E8.weightContribRange9` — finite Hamming weight-contribution
  table through unscaled shell `24`.
- `CodeLatticeE8.E8.hammingThetaTableCoeff` — contribution-table
  coefficient using the proved Hamming weight distribution.
- `CodeLatticeE8.E8.thetaTableCoeff_eq_e4Coeff_of_le_six` — the finite
  Hamming contribution table agrees with `E4` through `q^6`.
- `CodeLatticeE8.E8.thetaShellCount_eq_convolution` — E8-facing re-export of
  the all-shell Construction A convolution theorem.

This theorem index is a summary only; see the module docstrings for convention
and finite-computation notes.
-/

/-!
The private declarations below are compile-time guards for the prose index
above.  They make this file fail to build if a listed declaration is renamed,
removed, or no longer imported by the reviewer-facing root.
-/

noncomputable section

private noncomputable abbrev theoremIndexGuard_binaryVector :=
  CodeLatticeE8.Code.BinaryVector
private noncomputable abbrev theoremIndexGuard_binaryLinearCode :=
  CodeLatticeE8.Code.BinaryLinearCode
private noncomputable abbrev theoremIndexGuard_hammingWeight :=
  @CodeLatticeE8.Code.hammingWeight
private noncomputable abbrev theoremIndexGuard_extendedHamming8 :=
  CodeLatticeE8.Code.extendedHamming8
private noncomputable abbrev theoremIndexGuard_extendedHamming8_weight_distribution :=
  CodeLatticeE8.Code.extendedHamming8_weight_distribution
private noncomputable abbrev theoremIndexGuard_extendedHamming8_selfDual :=
  CodeLatticeE8.Code.extendedHamming8_selfDual
private noncomputable abbrev theoremIndexGuard_extendedHamming8_typeII :=
  CodeLatticeE8.Code.extendedHamming8_typeII
private noncomputable abbrev theoremIndexGuard_hamming_unique :=
  CodeLatticeE8.Code.extendedHamming8_unique_up_to_equivalence

private noncomputable abbrev theoremIndexGuard_reduceModTwo :=
  @CodeLatticeE8.ConstructionA.reduceModTwo
private noncomputable abbrev theoremIndexGuard_constructionA_lattice :=
  @CodeLatticeE8.ConstructionA.lattice
private noncomputable abbrev theoremIndexGuard_sqNorm :=
  @CodeLatticeE8.ConstructionA.sqNorm
private noncomputable abbrev theoremIndexGuard_sqNorm_mod_four :=
  @CodeLatticeE8.ConstructionA.sqNorm_mod_four_eq_hammingWeight_mod_four
private noncomputable abbrev theoremIndexGuard_sqNorm_dvd_four :=
  @CodeLatticeE8.ConstructionA.sqNorm_dvd_four_of_doublyEven
private noncomputable abbrev theoremIndexGuard_constructionA_intDot :=
  @CodeLatticeE8.ConstructionA.intDot
private noncomputable abbrev theoremIndexGuard_binaryLift :=
  @CodeLatticeE8.ConstructionA.binaryLift
private noncomputable abbrev theoremIndexGuard_scaledDualInt :=
  @CodeLatticeE8.ConstructionA.scaledDualInt
private noncomputable abbrev theoremIndexGuard_scaledDualInt_eq_lattice :=
  @CodeLatticeE8.ConstructionA.scaledDualInt_eq_lattice_of_selfDual
private noncomputable abbrev theoremIndexGuard_typeII_integer_package :=
  @CodeLatticeE8.ConstructionA.typeII_integer_package
private noncomputable abbrev theoremIndexGuard_scaledReal :=
  @CodeLatticeE8.ConstructionA.scaledReal
private noncomputable abbrev theoremIndexGuard_scaledReal_even :=
  @CodeLatticeE8.ConstructionA.scaledReal_even_of_doublyEven
private noncomputable abbrev theoremIndexGuard_scaledRealDual_eq_self :=
  @CodeLatticeE8.ConstructionA.scaledRealDual_eq_self_of_selfDual

private noncomputable abbrev theoremIndexGuard_hammingConstructionA :=
  CodeLatticeE8.E8.hammingConstructionA
private noncomputable abbrev theoremIndexGuard_hammingConstructionBasis :=
  CodeLatticeE8.E8.hammingConstructionBasis
private noncomputable abbrev theoremIndexGuard_hammingConstructionGram :=
  CodeLatticeE8.E8.hammingConstructionGram
private noncomputable abbrev theoremIndexGuard_basisMatrix_det :=
  CodeLatticeE8.E8.hammingConstructionBasisMatrix_det
private noncomputable abbrev theoremIndexGuard_gram_det :=
  CodeLatticeE8.E8.hammingConstructionGram_det
private noncomputable abbrev theoremIndexGuard_scaledGram_det :=
  CodeLatticeE8.E8.hammingConstructionScaledGram_det
private noncomputable abbrev theoremIndexGuard_scaledMinSqNorm :=
  CodeLatticeE8.E8.hammingConstructionA_scaledMinSqNorm

private noncomputable abbrev theoremIndexGuard_shortShell :=
  CodeLatticeE8.E8.hammingE8ShortShell
private noncomputable abbrev theoremIndexGuard_shortVectorCount :=
  CodeLatticeE8.E8.hammingConstructionA_short_vector_count
private noncomputable abbrev theoremIndexGuard_rootList :=
  CodeLatticeE8.E8.Roots.rootList
private noncomputable abbrev theoremIndexGuard_mem_rootList_iff :=
  CodeLatticeE8.E8.Roots.mem_rootList_iff_isE8Root
private noncomputable abbrev theoremIndexGuard_shortShell_perm_rootList :=
  CodeLatticeE8.E8.RootBridge.shortShell_perm_rootList
private noncomputable abbrev theoremIndexGuard_hadamard_sqNorm_scale :=
  CodeLatticeE8.E8.RootBridge.hadamard_sqNorm_scale

private noncomputable abbrev theoremIndexGuard_octavianUnitMul :=
  CodeLatticeE8.Octonion.octavianUnitMul
private noncomputable abbrev theoremIndexGuard_octavian_even_product :=
  @CodeLatticeE8.Octonion.two_dvd_mulInt_of_hammingConstructionA
private noncomputable abbrev theoremIndexGuard_octavian_exact_division :=
  @CodeLatticeE8.Octonion.two_mul_octavianUnitMul_eq_mulInt
private noncomputable abbrev theoremIndexGuard_octavian_order_closure :=
  @CodeLatticeE8.Octonion.octavianUnitMul_mem_hammingConstructionA
private noncomputable abbrev theoremIndexGuard_octavian_sqNorm :=
  @CodeLatticeE8.Octonion.octavianUnitMul_sqNorm
private noncomputable abbrev theoremIndexGuard_octavian_shortShell :=
  @CodeLatticeE8.Octonion.octavianUnitMul_mem_shortShell

private noncomputable abbrev theoremIndexGuard_e8CartanMatrix :=
  CodeLatticeE8.E8.e8CartanMatrix
private noncomputable abbrev theoremIndexGuard_e8CartanMatrix_det :=
  CodeLatticeE8.E8.e8CartanMatrix_det
private noncomputable abbrev theoremIndexGuard_gramCartan_congruence :=
  CodeLatticeE8.E8.gramCartan_congruence
private noncomputable abbrev theoremIndexGuard_e8BasisChangeMatrix_isUnit :=
  CodeLatticeE8.E8.e8BasisChangeMatrix_isUnit
private noncomputable abbrev theoremIndexGuard_e8SimpleRoots_gram :=
  CodeLatticeE8.E8.e8SimpleRoots_gram

private noncomputable abbrev theoremIndexGuard_reflect :=
  CodeLatticeE8.E8.WeylReflections.reflect
private noncomputable abbrev theoremIndexGuard_reflect_preserves :=
  @CodeLatticeE8.E8.WeylReflections.reflect_preserves_IsE8Root
private noncomputable abbrev theoremIndexGuard_reflect_mem :=
  @CodeLatticeE8.E8.WeylReflections.reflect_mem_rootList
private noncomputable abbrev theoremIndexGuard_reflect_involutive :=
  @CodeLatticeE8.E8.WeylReflections.reflect_reflect_of_mem

private noncomputable abbrev theoremIndexGuard_sigma3 :=
  CodeLatticeE8.Theta.sigma3
private noncomputable abbrev theoremIndexGuard_e4Coeff :=
  CodeLatticeE8.Theta.e4Coeff
private noncomputable abbrev theoremIndexGuard_constructionAShellSet :=
  CodeLatticeE8.constructionAShellSet
private noncomputable abbrev theoremIndexGuard_weightContribConvolution :=
  CodeLatticeE8.weightContribConvolution
private noncomputable abbrev theoremIndexGuard_constructionAConvolution :=
  CodeLatticeE8.constructionAShellCount_eq_weight_distribution_convolution
private noncomputable abbrev theoremIndexGuard_hammingThetaTableCoeff :=
  CodeLatticeE8.E8.hammingThetaTableCoeff
private noncomputable abbrev theoremIndexGuard_thetaTable :=
  CodeLatticeE8.E8.thetaTableCoeff_eq_e4Coeff_of_le_six
private noncomputable abbrev theoremIndexGuard_thetaShellCount :=
  CodeLatticeE8.E8.thetaShellCount_eq_convolution

end
