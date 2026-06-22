# Context pack: spinor-network closure

Date: 2026-06-21

Target:

```text
AgentTasks/aristotle-standalone/null-edge-spinor-network-closure-20260621/NullEdgeSpinorNetworkClosure/Finite.lean
```

Research role:

- The strengthened program now treats spinor-network closure as the actionable
  bridge between celestial Pluecker mass and source visibility.
- Visible null edges have weights `w_i` and celestial directions `u_i`.
- Energy is `E = sum_i w_i`; closure / spatial momentum is
  `C = sum_i w_i u_i`.
- The finite identity to prove is
  `sum_{i<j} w_i w_j (1 - u_i dot u_j) / 2 = (E^2 - |C|^2) / 4`
  under the unit-direction hypothesis `|u_i|^2 = 1`.
- The closed fan corollary says `C = 0` gives the rest-frame value `E^2 / 4`.

Claim boundary:

- This is finite Euclidean three-vector algebra.
- It does not prove BF closure, spin-foam volume simplicity, or cosmological
  source invisibility.
- It is intended to bank the moment-map identity before those stronger
  interpretations are attempted.

Relevant program sections:

- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`, sections
  `0a. Spinor irrep table and Bivector/BF wrapper`, `1. Mass as Pluecker spread
  of null spinors`, and the spinor-network closure rows in Stage 2.
- `AgentTasks/null-edge-autonomous-aristotle-loop-plan-2026-06-21.md`, rows
  `spinor-network-closure` and definition item `SpinorNetworkClosure`.
