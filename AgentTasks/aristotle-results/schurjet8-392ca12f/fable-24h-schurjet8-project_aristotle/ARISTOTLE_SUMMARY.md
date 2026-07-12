# Summary of changes for run 20de389b-673d-42ad-b666-9e58bce52689
Created `SplitStepSchurJetAllNodes.lean`, a self-contained (imports nothing project-local; definitions copied verbatim from the two context modules) kernel-only extension of the central-node Schur-jet derivation to ALL EIGHT crossing nodes q_j ∈ {π/2, 3π/2}³ of the null-edge split-step walk. The file builds cleanly and every new theorem was checked to use only the standard kernel axioms (`propext`, `Classical.choice`, `Quot.sound`) — no `sorry`, no `native_decide`, no added axioms.

Key algebraic observation driving the derivation: at a node coordinate sitting at 3π/2, the walk factor is `E(α, 3π/2) = -(I·α)`, i.e. a sign flip relative to π/2. Since these signs are scalars, the whole node symbol collapses to `U_n = (-1)^{parity(n)} • U0`, and likewise every directional derivative to `D_{n,j} = (-1)^{parity(n)} • D_j`. This makes the kernel bases, compressions, Jacobians, and charges transport from the central node with explicit signs, mirroring the landed pattern with no analysis.

Delivered, quantified over the 8-element node set `n : Fin 3 → Bool` (with `nodeParity` the 3-bit XOR of which coordinates sit at 3π/2):

1. Node structure and jets: `E_node`, `E_node_shift`, `walkNodeAll` (`U` at the node equals `(-1)^{parity} • U0`), and the three exact node jets `jetNode_q1/q2/q3`.
2. Kernel dimensions: `kerDimNode_gap0` and `kerDimNode_gapPi` — `dim ker (U_n ∓ 1) = 2` at both gaps for every node.
3. Jacobians: `walkJac0_eq` gives the gap-0 crossing Jacobian `= (-1)^{parity(n)} • (4/5)diag(1,-1,1)`; `walkJacPi_eq` gives the gap-π Jacobian, and `walkJac_gap_flip` shows it is the negation of gap 0 (the load-bearing gap-orientation factor s).
4. Tie to the landed census: `census_gap0_derived` and `census_gapPi_derived` prove `census n g = -(walkJac n g)` for every node and gap — i.e. the context module's census assignment is DERIVED from the walk symbol via the documented `J_recorded = -J_here` bridge. The consequences match the landed census EXACTLY: the same parity rule (`census_chargeOf_gap0`, `census_chargeOf_gapPi`), per-node Floquet opposition (`walk_floquet_opposition`), and sum-zero over the eight nodes at each gap (`walk_sum_zero_gap0`, `walk_sum_zero_gapPi`).

No node's computed Jacobian contradicted the parity rule: the walk-derived census is fully consistent with the landed census (up to the already-documented global `J_recorded = -J_here` sign convention), so no correction notice is needed.
