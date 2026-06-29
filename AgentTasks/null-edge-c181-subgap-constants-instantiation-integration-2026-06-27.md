# Summary of changes for run d404ee07-59e8-4c26-8155-50bed7a78f7c
Designed and formalized the Gate C1 sub-gap constants instantiation plan, compatible with the C170R quantitative certificate `‖H_ne − H_ref‖ ≤ κ+ω+ρ+α+β` and the Gate C1 target `κ+ω+ρ+α+β < γ_ref`. Everything builds with no proof placeholders and uses only the standard kernel dependencies (propext, Classical.choice, Quot.sound).

Files added:
- `RequestProject/GateC1.lean` — the certificate API.
- `RequestProject/CornerModel.lean` — a concrete, computable finite-sector instantiation.
- `GATE_C1_PLAN.md` — the prose design/audit document.
- `RequestProject/Main.lean` now imports both modules so the default target builds them.

Key design choice: the C170R bound is *derived*, not postulated, from a telescoping homotopy chain `H_ne=H₀→H₁→H₂→H₃→H₄→H₅=H_ref` with one intermediate operator per mismatch source. Each constant is exactly an upper bound on one leg's norm, so the bound follows from the triangle inequality (`C170RData.c170r_bound`).

Requested outputs delivered:
1. Each constant's meaning is fixed by which homotopy leg it bounds: κ = kinetic/Dirac symbol (‖H_ne−H₁‖), ω = branch Wilson/flavored-mass (‖H₁−H₂‖), ρ = R,m₀ shift (‖H₂−H₃‖), α = gauge/admissibility (‖H₃−H₄‖), β = branch-frame/tetrad/soldering (‖H₄−H_ref‖). Documented in field docstrings.
2. Computable bounds: `CornerModel.lean` truncates to a finite sector; `scalarCorner` is the 1×1 scalar corner with explicit numbers (κ=ω=ρ=0, α=0.1, β=0.2, total 0.3 < γ_ref 0.5), all norm_num-decidable. A general finite-dimensional corner uses the same constructors over `EuclideanSpace ℝ (Fin n)` or a matrix algebra.
3. Retuning options proved as lemmas: raise the reference gap (`GateC1.of_gap_le`, `scalarCorner_retune_gap`), lower a constant via m₀/r/R/admissibility-window/frame/homotopy (`C170RData.total_mono`, `GateC1.of_le_total`, demo `scalarCorner_retune_beta`), and explicit slack (`GateC1.of_slack`). An honest negative lemma `scalarCorner_fails_small_gap` shows the gate genuinely fails at a too-small gap — the constants are never assumed small without hypotheses.
4. Certificate structures compatible with C170R: `C170RData` (chain + per-leg bounds, with `total` and `c170r_bound`), the `GateC1` predicate with `operator_bound` giving `‖H_ne−H_ref‖ < γ_ref`, and the bundled `GateCertificate` with headline `final_bound`.
5. Zero vs hard: κ, ω, ρ are structurally zero under ideal verbatim CKM/reference import (`idealMatch_kappa/omega/rho`, `ideal_total_zero`), while α (gauge/admissibility) and β (branch-frame/soldering) are the genuinely hard terms and are kept as honest, unbounded-by-default hypotheses.
