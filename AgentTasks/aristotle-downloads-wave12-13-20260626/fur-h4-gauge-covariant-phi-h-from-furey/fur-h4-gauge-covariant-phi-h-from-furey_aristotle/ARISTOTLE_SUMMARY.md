# Summary of changes for run acd1dc05-df8e-444f-a1ba-eedd2d61240f
## FUR-H4 — Gauge-covariant internal Yukawa map `Φ_H` with `χ_E` oddness

I implemented and proved the requested internal finite spectral-triple half `Φ_H` in the new file `PhysicsSM/Draft/NullEdgeFureyPhiH.lean`. It builds cleanly (no `sorry`, no new axioms — only `propext`/`Classical.choice`/`Quot.sound` — and no linter warnings).

### Inspection (Task step 1)
I read the Furey electroweak/weak-isospin modules (`ElectroweakBridge`, `WeakIsospinDoublets`, `WeakIsospinLadder`, `ElectroweakCompletePackage`, `FureyRealizesOneGeneration`, `MinimalLeftIdeal`, `JbarActionTable`), the null-edge checkerboard/sign/Lichnerowicz/internal-spectrum drafts, and the working plan. Note: the supplied project is an excerpt — most of those files import modules that are not present (e.g. `NullEdgeFiniteTetradPostulate`, `AnomalyPackage`), so only `NullEdgeYukawaCheckerboard.lean` is self-contained and compiles. I therefore made the new file depend only on Mathlib and that checkerboard module, while documenting the conceptual links to the (currently unbuildable) sign-bridge and internal-spectrum files.

### Domain/codomain (Task step 2)
The morally-`J → J*` Yukawa map is realized in the **Dirac `L ⊕ R` basis equivalent**: an off-diagonal chirality-flip block `Φ_H = [[0, M],[Mᴴ, 0]]` on `H_L × H_R`, with the constant block `M : H_R →ₗ[ℂ] H_L` following the checkerboard convention. The docstring states the `J/J*` interpretation and a guardrail keeping this kinetic Dirac basis distinct from the all-left anomaly bookkeeping basis.

### Interface and proofs (Task steps 3–4)
Definitions `chiE`, `phiH M`, `gaugeAct gL gR` on `H_L × H_R`, plus the bundled `structure GaugeCovariantPhiH` (a gauge-intertwining Yukawa datum). Proven theorems:
- **`χ_E` oddness**: `phiH_chiE_odd` (`{χ_E, Φ_H} = 0`) and `chiE_sq` (`χ_E² = 1`).
- **`Γ_s` compatibility / `+Φ_H²` sign**: `phiH_gammaS_even`, the abstract `graded_square_comm`/`graded_square_anticomm`, and `phiH_sign_dichotomy` (pairing with the `Γ_s` restriction gives `+Φ_H²`, pairing with `χ_E` gives `−Φ_H²`), with the non-conflation guardrail `gammaS_internal_ne_chiE`.
- **Gauge covariance**: `phiH_gauge_covariant` (commutes with the gauge action when `M` intertwines the reps) and `chiE_gauge_commutes` (gauge preserves the grading).
- **Legal Yukawa pairing → checkerboard**: `phiH_sq`/`phiH_sq_apply` (`Φ_H² = (M Mᴴ) ⊕ (Mᴴ M)`) and `phiH_sq_nonzero_eigenvalue_correspondence` reusing the checkerboard singular-value theorem.
- **Bundled correctness**: `GaugeCovariantPhiH.isProperPhiH` packages oddness, `Γ_s`-evenness, gauge covariance, and the squared mass block.

### Guardrails honoured
No Yukawa eigenvalues are derived (`M` is arbitrary); the all-left anomaly basis is kept distinct from the physical Dirac `L/R` basis; no axioms or fake assumptions were introduced.
