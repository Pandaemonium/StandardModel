# Summary of changes for run f2ff61ca-b293-4283-952e-7a5e2bdf5946
Delivered a structured red-team audit as `REDTEAM_detP_mass.md` (no Lean needed for this strategy/audit task). It addresses each requested point with an explicit verdict and specific reasoning:

1. **Counterexamples to universality — BREAKS as a mechanism.** The core distinction: `m² = det P` is a *kinematic identity* (any timelike p splits into two null momenta with `m² = 2 p1·p2`), so "all mass from massless edges" is universal only because it is empty as a statement of origin. (a) The Higgs: the det-P *number* still holds kinematically, but there is no chiral L/R doubling to hang mass on, so holding it "outside" is honest bookkeeping that exposes the mechanism's non-universality. (b) Composite/QCD mass: det P re-labels but does not capture confinement (that's the trace anomaly). (c) Spin-3/2: the rank-2 `2×2` det formula breaks; the `edges = pol−1` count fits bosons but not fermions. (d) Off-shell: inapplicable, showing it is on-shell kinematics.

2. **det-P shape — PARTIALLY.** `det P = |m|²` is the right non-negative magnitude (`|det M|²`), but it discards the physical mass *phase* (CP/Majorana/θ). Metric/symplectic/determinant coincide only at rank 2.

3. **Convention pitfalls — REAL HAZARD.** Load-bearing choice of which P: little-group spinor `2×2` gives `m²`, but the Lorentzian 4-vector Gram gives `−m⁴/4` (wrong sign and dimension); PSD ⇔ same null-cone sheet is a physical hypothesis; a single minor is frame-dependent; factor-of-2 lives in `p1·p2` vs symmetrized wedge.

4. **Strongest kill-test.** The rank-3 / massive spin-3/2 test: form the `3×3` edge-Gram the program's own `edges = 2s` rule demands and check `m² = det P3`. Expected if the claim holds: uniform `m² = det P3`. Kill: fails by dimension (`[mass]⁶ ≠ [mass]²`), by structure (true `m²` is pairwise `p_i·p_j`), and by rank-3 Plücker branching — forcing the claim back to rank-2 states, i.e., surrendering universality. Runner-ups: Lorentz-invariance probe and mass-phase probe.

5. **Originality honesty — PARTIALLY FAIR.** The det-P/Plücker mass identification is standard (massive spinor-helicity Arkani-Hamed–Huang–Huang; Penrose zigzag) and should itself be [import], not just the KK/Bars/twistor lineage. What is legitimately [orig] is the *packaging*: the decidable finite avatar and the T/M/C grading discipline — not the physics identity.

The document ends with the ranked top-3 threats (mechanism/identity conflation → vacuous universality; rank-2 ceiling → higher-spin breakdown; load-bearing conventions → silent sign/factor/dimension corruption) and the single best kill-test spelled out. Committed and pushed to the `main` branch.
