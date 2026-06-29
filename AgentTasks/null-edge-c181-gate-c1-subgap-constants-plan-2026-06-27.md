# Gate C1 — Sub-gap constants instantiation plan & audit

Formalized in `RequestProject/GateC1.lean` (certificate API) and
`RequestProject/CornerModel.lean` (computable corner instantiation). All theorems build with
no proof placeholders and depend only on the standard kernel dependencies (`propext`, `Classical.choice`, `Quot.sound`).

## Design: telescoping homotopy

The C170R bound `‖H_ne − H_ref‖ ≤ κ+ω+ρ+α+β` is **derived**, not postulated, from a finite
homotopy chain with one intermediate operator per mismatch source:

```
H_ne = H₀ ─κ→ H₁ ─ω→ H₂ ─ρ→ H₃ ─α→ H₄ ─β→ H₅ = H_ref
       kinetic  Wilson  R,m₀   gauge/   frame/
       /Dirac   /mass   shift  admiss.  tetrad
```

Each constant is **exactly** an upper bound on one leg's operator norm. The triangle
inequality (`C170RData.c170r_bound`) yields the C170R bound automatically.

## 1. What each constant measures

| const | leg | meaning |
|-------|-----|---------|
| κ kappa | ‖H_ne − H₁‖ | kinetic / Dirac principal-symbol mismatch |
| ω omega | ‖H₁ − H₂‖   | branch Wilson / flavored-mass (doubler-lifting) mismatch |
| ρ rho   | ‖H₂ − H₃‖   | Wilson radius `R` and bare mass `m₀` retuning shift |
| α alpha | ‖H₃ − H₄‖   | gauge transport / admissibility-window perturbation |
| β beta  | ‖H₄ − H_ref‖ | branch-frame / tetrad / soldering misalignment |

## 2. Computable / finite-sector bounds

`CornerModel.lean` truncates to a finite sector where every constant is a concrete number.
`scalarCorner` is the 1×1 (scalar) corner: operator space `ℝ`, each constant a `norm_num`-
decidable real norm. A genuine finite-dimensional corner uses `EuclideanSpace ℝ (Fin n)` or a
matrix algebra with the same constructors; only the numeric norm evaluation changes.

Worked numbers (ideal CKM import): κ=ω=ρ=0, α=0.1, β=0.2, total=0.3, γ_ref=0.5 ⇒ gate holds
(`scalarCorner_gate`, `scalarCorner_final`).

## 3. Retuning options (if the inequality fails)

Honest negative result first: `scalarCorner_fails_small_gap` shows the gate genuinely fails at
γ_ref=0.25 (total 0.3 ⊀ 0.25). We never assume the constants small for free.

Retuning lemmas:
- raise the reference gap — `GateC1.of_gap_le`, demo `scalarCorner_retune_gap`;
- lower a constant (better m₀/r/R, admissibility window, frame alignment, or intermediate
  homotopy) — `C170RData.total_mono`, `GateC1.of_le_total`; demo `scalarCorner_retune_beta`
  (shrink β via better tetrad/soldering, budget drops to 0.15, clears γ_ref=0.25);
- use explicit slack — `GateC1.of_slack`.

## 4. Lean / API certificate structures (compatible with C170R)

- `C170RData E` — bundled telescoping certificate (chain + per-leg bounds); `total`,
  `c170r_bound` (the C170R inequality), `total_nonneg`.
- `GateC1 c γ_ref` — the gate predicate `c.total < γ_ref`; `operator_bound` gives
  `‖H_ne − H_ref‖ < γ_ref`.
- `GateCertificate E` — bundles a C170R certificate + discharged gate; `final_bound` is the
  headline conclusion.

## 5. Which constants are zero vs. genuinely hard

- **Structurally zero in ideal matching:** κ, ω, ρ. When the principal symbol, Wilson term and
  `R,m₀` shift are imported verbatim, those legs vanish exactly (`idealMatch_kappa`,
  `idealMatch_omega`, `idealMatch_rho`; collapse via `ideal_total_zero`).
- **Genuinely hard:** α (gauge/admissibility perturbation) and β (branch-frame / soldering
  mismatch). These generally cannot be made to vanish and carry the real content of the gate;
  they are kept as honest hypotheses, never assumed small.
