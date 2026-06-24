# Aristotle Task: P1 Zero-Edge Collinearity Equivalence
2: 
3: This is a proof-completion job for the P1 zero-edge collinearity theorem, solved locally.
4: 
5: ```yaml
6: aristotle:
7:   project_id: null
8:   task_id: null
9:   target_file: AgentTasks/aristotle-standalone/null-edge-zero-edge-collinearity-20260621/NullEdgeZeroEdgeCollinearity/Finite.lean
10:   expected_module: NullEdgeZeroEdgeCollinearity.Finite
11:   source_staged_from: AgentTasks/aristotle-standalone/null-edge-zero-edge-collinearity-20260621
12:   status: integrated
13:   integrated_at: 2026-06-24T04:52:00Z
14:   verification:
15:     - lake env lean AgentTasks/aristotle-standalone/null-edge-zero-edge-collinearity-20260621/NullEdgeZeroEdgeCollinearity/Finite.lean
16: ```
17: 
18: ## Context
19: 
20: The finite bundle determinant vanishes exactly when the visible spinors are all zero or share a common nonzero projective direction.
21: 
22: ## Target
23: 
24: Solve:
25: ```lean
26: theorem pairwise_wedge_zero_iff_all_zero_or_common_direction {n : Nat} (psi : Fin n -> CSpinor) : PairwiseWedgeZero psi ↔ AllZero psi ∨ HasNonzeroCommonDirection psi
27: theorem fin_bundle_mass_zero_iff_all_zero_or_common_direction {n : Nat} (psi : Fin n -> CSpinor) : (finBundleMomentum psi).det = 0 ↔ AllZero psi ∨ HasNonzeroCommonDirection psi
28: ```
29: 
30: ## Verification
31: 
32: Proved locally:
33: - `pairwise_wedge_zero_iff_all_zero_or_common_direction` by case split on `AllZero psi` and applying `pairwise_wedge_zero_iff_common_direction`.
34: - `fin_bundle_mass_zero_iff_all_zero_or_common_direction` by rewriting via `fin_bundle_plucker_mass_identity`, `finPairwisePluckerMass_eq_zero_iff_pair_terms_zero`, and `pair_terms_zero_iff_pairwise`.
