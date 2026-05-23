# CodeLatticeE8 Publication Theorem Map

Date: 2026-05-21

This document maps the manuscript-level mathematical claims to the new
reviewer-facing Lean package.  Its purpose is to make the package easy to
audit without asking a reader to reconstruct the development history from the
older `PhysicsSM` namespace.

Status labels:

- Core: in the standalone `CodeLatticeE8` package, Mathlib-only, kernel-checked.
- SPL: in the optional `CodeLatticeE8SPL` root, kernel-checked with
  Sphere-Packing-Lean available.

## Main Theorem Route

| Paper claim | Lean declaration | File | Status |
| --- | --- | --- | --- |
| Concrete extended Hamming `[8,4,4]` code | `CodeLatticeE8.Code.extendedHamming8_isLinearCode_4_4` | `CodeLatticeE8/Code/Hamming844.lean` | Core |
| Hamming self-duality | `CodeLatticeE8.Code.extendedHamming8_selfDual` | `CodeLatticeE8/Code/Dual.lean` | Core |
| Hamming Type II status | `CodeLatticeE8.Code.extendedHamming8_typeII` | `CodeLatticeE8/Code/Dual.lean` | Core |
| Uniqueness of binary `[8,4,4]` codes up to equivalence | `CodeLatticeE8.Code.extendedHamming8_unique_up_to_equivalence` | `CodeLatticeE8/Code/Hamming844Uniqueness.lean` | Core |
| Construction A integer lattice | `CodeLatticeE8.ConstructionA.lattice` | `CodeLatticeE8/ConstructionA/Basic.lean` | Core |
| Generic doubly-even norm divisibility | `CodeLatticeE8.ConstructionA.sqNorm_dvd_four_of_doublyEven` | `CodeLatticeE8/ConstructionA/Even.lean` | Core |
| Generic Type II integer package | `CodeLatticeE8.ConstructionA.typeII_integer_package` | `CodeLatticeE8/ConstructionA/TypeII.lean` | Core |
| Generic scaled real evenness | `CodeLatticeE8.ConstructionA.scaledReal_even_of_doublyEven` | `CodeLatticeE8/ConstructionA/TypeII.lean` | Core |
| Generic scaled real self-duality | `CodeLatticeE8.ConstructionA.scaledRealDual_eq_self_of_selfDual` | `CodeLatticeE8/ConstructionA/TypeII.lean` | Core |
| Hamming Construction A minimum shell | `CodeLatticeE8.E8.hammingConstructionA_minSqNorm` | `CodeLatticeE8/E8/HammingConstruction.lean` | Core |
| Explicit E8 basis spans the Construction A lattice | `CodeLatticeE8.E8.hammingConstructionASubmodule_eq_span` | `CodeLatticeE8/E8/Span.lean` | Core |
| Unscaled Gram determinant `256` | `CodeLatticeE8.E8.hammingConstructionGram_det` | `CodeLatticeE8/E8/Determinant.lean` | Core |
| Scaled E8 Gram determinant `1` | `CodeLatticeE8.E8.hammingConstructionScaledGram_det` | `CodeLatticeE8/E8/Determinant.lean` | Core |
| Scaled minimum squared norm `2` | `CodeLatticeE8.E8.hammingConstructionA_scaledMinSqNorm` | `CodeLatticeE8/E8/Minimum.lean` | Core |
| E8 short-vector count `240` | `CodeLatticeE8.E8.hammingConstructionA_short_vector_count` | `CodeLatticeE8/E8/ShortVectors.lean` | Core |
| Semantic doubled-coordinate E8 root list | `CodeLatticeE8.E8.Roots.mem_rootList_iff_isE8Root` | `CodeLatticeE8/E8/Roots.lean` | Core |
| Short shell to root-list bridge | `CodeLatticeE8.E8.RootBridge.shortShell_perm_rootList` | `CodeLatticeE8/E8/RootBridge.lean` | Core |
| Cartan matrix determinant | `CodeLatticeE8.E8.e8CartanMatrix_det` | `CodeLatticeE8/E8/CartanBridge.lean` | Core |
| Gram-Cartan congruence | `CodeLatticeE8.E8.gramCartan_congruence` | `CodeLatticeE8/E8/CartanBridge.lean` | Core |
| Simple roots reproduce the E8 Dynkin diagram | `CodeLatticeE8.E8.e8SimpleRoots_gram` | `CodeLatticeE8/E8/CartanBridge.lean` | Core |
| Weyl reflection preserves semantic E8 roots | `CodeLatticeE8.E8.WeylReflections.reflect_preserves_IsE8Root` | `CodeLatticeE8/E8/WeylReflections.lean` | Core |
| Weyl reflection preserves the 240-root list | `CodeLatticeE8.E8.WeylReflections.reflect_mem_rootList` | `CodeLatticeE8/E8/WeylReflections.lean` | Core |
| Theta constant coefficient | `CodeLatticeE8.E8.semanticThetaCoeff_eq_e4Coeff_zero` | `CodeLatticeE8/E8/ThetaCoefficients.lean` | Core |
| Theta short-shell coefficient | `CodeLatticeE8.E8.semanticThetaCoeff_eq_e4Coeff_one` | `CodeLatticeE8/E8/ThetaCoefficients.lean` | Core |
| Finite Hamming table/E4 comparison through `q^6` | `CodeLatticeE8.E8.thetaTableCoeff_eq_e4Coeff_of_le_six` | `CodeLatticeE8/E8/ThetaSeries.lean` | Core table check |
| All-shell Construction A convolution | `CodeLatticeE8.E8.thetaShellCount_eq_convolution` | `CodeLatticeE8/E8/ThetaSeries.lean` | Core |

## Optional Full Theta Bridge

The standalone root intentionally stops at finite, algebraic theta
coefficients and the semantic all-shell convolution theorem.  The
all-coefficient analytic theorem lives behind an explicit SPL boundary.  The
optional root `CodeLatticeE8SPL.lean` imports
`CodeLatticeE8.SPL.TheoremIndex`, which lists the completed SPL-facing
coefficient facts, shell-transport theorem, and formal power-series identity.

| Target claim | Intended declaration | Intended file | Status |
| --- | --- | --- | --- |
| E8 theta modular form equals `E4` using SPL dimension theory | `CodeLatticeE8.SPL.thetaE8_MF_eq_E4` | `CodeLatticeE8/SPL/E8ThetaModular.lean` | SPL |
| Q-expansion coefficients of the analytic theta form match the Hamming convolution coefficients | `CodeLatticeE8.SPL.thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff` | `CodeLatticeE8/SPL/CoefficientBridge.lean` | SPL |
| All Hamming theta convolution coefficients equal normalized `E4` coefficients | `CodeLatticeE8.SPL.hammingThetaConvolutionCoeff_eq_e4Coeff` | `CodeLatticeE8/SPL/CoefficientBridge.lean` | SPL |
| Formal power-series identity `Theta_E8 = E4` | `CodeLatticeE8.SPL.thetaSeries_hammingE8_eq_e4Series` | `CodeLatticeE8/SPL/CoefficientBridge.lean` | SPL |

## Citation Rule

The paper should cite declarations in `CodeLatticeE8.*` for the standalone
package.  Older `PhysicsSM.*` files may be cited only as draft provenance or
historical development notes, not as the reviewer-facing artifact.
