# Aristotle Task: P1 Two Massless Momenta Combine Into Massive System
2: 
3: This is a proof-completion job for the P1 two null massive theorem, solved locally.
4: 
5: ```yaml
6: aristotle:
7:   project_id: null
8:   task_id: null
9:   target_file: AgentTasks/aristotle-standalone/null-edge-two-null-massive-20260622/NullEdgeTwoNullMassive/Core.lean
10:   expected_module: NullEdgeTwoNullMassive.Core
11:   source_staged_from: AgentTasks/aristotle-standalone/null-edge-two-null-massive-20260622
12:   status: integrated
13:   integrated_at: 2026-06-24T04:50:00Z
14:   verification:
15:     - lake env lean AgentTasks/aristotle-standalone/null-edge-two-null-massive-20260622/NullEdgeTwoNullMassive/Core.lean
16: ```
17: 
18: ## Context
19: 
20: Two future-pointing null momenta with positive energy sum to a timelike (massive) total momentum.
21: 
22: ## Target
23: 
24: Solve:
25: ```lean
26: theorem two_null_sum_massSq (p q : Four) (hp : massSq p = 0) (hq : massSq q = 0) : massSq (fun i => p i + q i) = 2 * mink p q
27: theorem mink_two_null_nonneg (p q : Four) (hp : p 0 ^ 2 = spaceNormSq p) (hq : q 0 ^ 2 = spaceNormSq q) (hpe : 0 ≤ p 0) (hqe : 0 ≤ q 0) : 0 ≤ mink p q
28: ```
29: 
30: ## Verification
31: 
32: Proved locally:
33: - `two_null_sum_massSq` using `linear_combination hp + hq`.
34: - `mink_two_null_nonneg` using Cauchy-Schwarz sum of squares polynomial decomposition in 3 dimensions and bounds manipulation.
