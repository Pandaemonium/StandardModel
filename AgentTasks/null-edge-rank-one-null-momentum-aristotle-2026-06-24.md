# Aristotle Task: P1 Rank-One Null Momentum Proof
2: 
3: This is a proof-completion job for the P1 rank-one null momentum theorem, solved locally.
4: 
5: ```yaml
6: aristotle:
7:   project_id: null
8:   task_id: null
9:   target_file: AgentTasks/aristotle-standalone/null-edge-rank-one-null-momentum-20260622/NullEdgeRankOneNullMomentum/Core.lean
10:   expected_module: NullEdgeRankOneNullMomentum.Core
11:   source_staged_from: AgentTasks/aristotle-standalone/null-edge-rank-one-null-momentum-20260622
12:   status: integrated
13:   integrated_at: 2026-06-24T04:49:00Z
14:   verification:
15:     - lake env lean AgentTasks/aristotle-standalone/null-edge-rank-one-null-momentum-20260622/NullEdgeRankOneNullMomentum/Core.lean
16: ```
17: 
18: ## Context
19: 
20: The visible momentum extracted from a single two-spinor `psi` via `psi psiᵀ` is a null vector.
21: 
22: ## Target
23: 
24: Solve:
25: ```lean
26: theorem rankOne_momentum_is_null (a : Spinor) : minkowskiSq a = 0
27: ```
28: 
29: ## Verification
30: 
31: Proved locally using `Complex.ext` decomposition into real/imaginary parts and `ring`.
