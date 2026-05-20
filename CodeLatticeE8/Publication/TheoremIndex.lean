import CodeLatticeE8.Code.Dual
import CodeLatticeE8.Code.Hamming844Uniqueness
import CodeLatticeE8.E8.Basis
import CodeLatticeE8.E8.Gram
import CodeLatticeE8.E8.Determinant
import CodeLatticeE8.E8.HammingConstruction
import CodeLatticeE8.E8.Minimum
import CodeLatticeE8.E8.Span

/-!
# Theorem index

This module is the reviewer-facing index for declarations currently promoted
to the standalone `CodeLatticeE8` root.

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

All declarations reachable from this index are intended to be standalone:
they depend on Mathlib and `CodeLatticeE8.*`.
-/
