# D18 Gate D0 positive DEC/Hodge-Dirac proxy plan -- returned summary

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run d1bf8fcd-e295-4d88-93fd-bc2983a7cc0c
The focused package did not ship the standalone report file; this is the
returned summary, preserved verbatim as the integration record.

---

Completed the D18 strategy / proof-scoping job: "Gate D0 positive DEC/Hodge-Dirac proxy plan". This was an audit/strategy task, so the deliverable is a report plus an optional, building Lean scaffold (no continuum result claimed — only a precise D0 proof contract).

Deliverables added:

1. `AgentTasks/null-edge-d18-d0-positive-dec-proxy-plan.md` — a deep report that:
   - Q1: identifies the cleanest positive-metric proxy operator as the finite Euclidean Hodge-Dirac operator `D_h = d_h + δ_h`, i.e. the b17 null Dirac square specialised to a positive Clifford module (`{C_a,C_b}=+2δ_ab`, positive inner product), so `K_null` collapses to the nonnegative connection Laplacian `∑_a ∇_a*∇_a`.
   - Q2: shows both b17 (`finite_lichnerowicz_square`, `dNsum_sq_decomp`, `..._tetrad`) and d17 (`scalar_null_quadrature`, `gauge_*_reconstruction`, the Euclidean collapse guardrail) are pure ring/bilinear identities that use no positivity or Krein structure and are therefore reusable verbatim; D0 is a strict specialisation/addition. Lists what is genuinely new (mesh family, Whitney/de Rham maps, O(h) estimates).
   - Q3: the minimal positive-definite inner-product / Hodge-star / Gram / Euclidean-Clifford / reconstruction-pair hypotheses for a DEC convergence statement.
   - Q4: recommends the theorem order — scalar inverse-Gram positivity and connection-Laplacian positivity first (both already proven in the scaffold), then the abstract finite-to-continuum contract, then the quadrature rate, with the local commutator symbol theorem `[D_h,M_f]=c(df)+O(h)` as the LAST D0 target rather than the first.
   - Q5: a table of strictly `D0_ONLY` assumptions (positive-definite inner product, positive Hodge star, Euclidean Gram/Clifford, self-adjointness, ellipticity, real spectrum) with their Lorentzian/Krein replacements and an explicit non-inheritance rule.
   - A dependency DAG for the full Gate D sequence (D0 → connection/holonomy → dual-soldered Clifford → Lorentzian/Krein → retarded), with acceptance/failure criteria and allowed-axioms statement.

2. `PhysicsSM/Draft/NullEdgeD0PositiveProxy.lean` — a sorry-free, axiom-clean Lean scaffold (imports only Mathlib so it builds standalone in the focused package; confirmed via `lake build PhysicsSM.Draft.NullEdgeD0PositiveProxy`). It contains two genuinely proven positive-proxy facts — `scalar_inverse_gram_nonneg` (PosSemidef Gram ⇒ nonnegative quadrature, the positive face of d17) and `connection_laplacian_nonneg` / `connection_laplacian_energy_eq` (`∑_a T_a*T_a ≥ 0`, the positive face of b17 `K_null`), plus `euclidean_edge_energy_nonneg` — and the open D0 obligations stated as contract definitions (`D0SymbolData`, `D0SymbolContract` for `[D_h,M_f]=c(df)+O(h)`, and `D0QuadratureContract`). The contracts state the targets without asserting them, so no `sorry` is used. The four proven lemmas depend only on `propext`, `Classical.choice`, `Quot.sound`.

Per the focused-package note, the local dependencies (the b17/d17 modules' own imports and the PhysicsSM prelude) are absent, so the package as a whole does not build; the new scaffold deliberately imports only Mathlib and builds cleanly on its own, ready for integration with the b17/d17 theorems referenced by name. No continuum result, and no Lorentzian/Krein/stability claim, is made.
