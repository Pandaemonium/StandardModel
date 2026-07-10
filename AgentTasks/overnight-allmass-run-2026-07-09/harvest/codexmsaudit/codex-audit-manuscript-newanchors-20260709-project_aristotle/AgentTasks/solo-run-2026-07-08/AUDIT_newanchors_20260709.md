# Audit — new manuscript anchor rows (codex-audit-manuscript-newanchors-20260709)

Scope: source-grounded audit of six new anchor modules and their manuscript /
future-directions / harvest prose, checking for false shape, vacuity, docstring
outrunning the kernel, hidden hypotheses, and convention drift.

Modules audited (all under `PhysicsSM/Draft/NullEdge/`):
`FiniteKMCP.lean`, `KMPhaseCounting.lean`, `WEPTrace.lean`,
`MassResourceModularAudit.lean`, `Goal3ExactRG.lean`, `SuiteAOp2Geom.lean`.

## Global verification

* `lake build` of the whole project is green (8033 jobs, 0 errors), so every
  in-file `#guard_msgs … #print axioms` pin is enforced and holds. The claimed
  footprint `[propext, Classical.choice, Quot.sound]` (and the choice-free
  `[propext, Quot.sound]` for `modular_generator_eq_adB`) is exactly what the
  kernel reports.
* No `sorry` / `admit` / `native_decide` / new `axiom` occurs in any of the six
  files (the only textual matches are prose in the two headers of `Goal3ExactRG`
  and `SuiteAOp2Geom` asserting their absence).
* Every declaration name cited in the manuscript §3–9 table rows (1704–1709) and
  in `Null_Edge_Future_Directions.md` exists in the claimed file with the stated
  shape.

Bottom line: **no false-shape, vacuity, or hidden-hypothesis defect was found in
any flagship claim.** The flagship statements are faithful and honestly scoped.
The findings below are all low-severity (thin/interpretive prose) or residual
scope caveats. No Lean correction is required.

## Per-module spot checks (all confirmed sound)

* **FiniteKMCP** — `plaquette V 0 1 0 1 = Im(V₀₀V₁₁ V₀₁* V₁₀*)` matches the
  standard Jarlskog convention; `plaquette_rephase`/`jarlskog_rephase` are
  general (no unitarity needed); `jarlskog_two_eq_zero` and
  `exists_real_rephasing_two` carry the genuine unitarity hypothesis
  `Vᴴ*V = 1`; `Vwitness_unitary` + `jarlskog_Vwitness = 6912/78125` + `≠ 0`
  give a real nonzero N=3 witness (1/(5⁵)·6912). `physicalPhases_eq` is a
  correctly-guarded ℕ identity, honestly labelled an arithmetic count with the
  corank theorem left open.
* **KMPhaseCounting** — `ckm_param_split` (N²=angles+removable+physCP, N≥1) and
  `cp_possible_iff` (0<physCP ↔ 3≤N) both check out arithmetically over ℕ.
* **WEPTrace** — `wep_trace_identity`/`wep_universality` are correct; the
  non-vacuity fixture uses distinct equal-trace `diag[1,0]`, `diag[0,1]`
  (genuinely `≠`), and the channel-stress control gives sources `1 ≠ 0`.
* **MassResourceModularAudit** — `modular_generator_eq_adB` (central `z`
  cancels), matrix specialization, and the false-shape guard
  `∃ B, c•1+B ≠ B` (existence, witnessed at `B=0`) are all correct; the module
  is honestly a guardrail, not a theory.
* **Goal3ExactRG** — Schur derivation of `R(λ,κ)=(λ−2κ²/λ, −κ²/λ)`, massless
  line `|κ|=|λ| ↦ (−λ,−λ)`, the four `HasDerivAt` partials giving
  `Jac=[[3,−4],[1,−2]]`, and eigen/trace/det (`(4,1)↦2·, (1,1)↦−1·, tr=1,
  det=−2`) all verify.
* **SuiteAOp2Geom** — `diracCommutator = m(f₁−f₀)·σₓ`, `isCausal_iff`,
  `steep_bound`, `dCausal_isGreatest_01 ⇒ dCausal m 0 1 = 1/m`, `dCausal m 1 0
  = 0`, `CausalLE` partial order, mass-independence, and `Eslot m m' = m'/m`
  all check out. `dCausal` is a genuine `sSup` construction; results are
  attained (`IsGreatest`), so no empty-sup / degenerate-sup artefact.

## Findings (severity-ranked)

### F1 — LOW (thin conjunct / prose outruns kernel)
`Goal3ExactRG.conical_dispersion_z_eq_one` (file `Goal3ExactRG.lean`,
theorem near L228; docstring L214–224 and manuscript §9 row).
The second conjunct
`(1 − (cos k · cos 0)²) − (sin k · cos 0)² = 0`
has `cos 0` hard-coded, so it reduces to `sin²k + cos²k = 1` — the Pythagorean
identity, true for every `k` independent of the model. It therefore carries no
model-specific "light-cone saturation / v_g²=1" content; the substantive result
is the first conjunct `(k•σz)² = k²•1`. The claim is not false, but the
docstring/manuscript reading "group velocity saturates the light cone (v_g²=1)"
outruns what this conjunct independently establishes.

### F2 — LOW (interpretive step, not a proven `ν`)
`Goal3ExactRG.linearized_mass_eigenvalue_eq_two` (file `Goal3ExactRG.lean`).
Lean proves the eigenvalue relations, `trace=1`, `det=−2`, and
`Real.logb 2 2 = 1`. The manuscript/docstring "relevant eigenvalue exactly 2 ⇒
ν=1" is a correct *interpretation* using the external identification `b=2`
(block-doubling under decimation) and `ν = 1/y_t`, but no `ν` object is defined
or proved equal to `1` in Lean. Consistent with the row's "honest scope"; noted
so the reader does not treat `ν=1` as kernel-checked.

### F3 — CAVEAT (two different "removable phase" counts across the KM modules)
`KMPhaseCounting.ckmRemovable N = 2N−1` vs the `numEdges N − (N−1)` spanning-tree
subtraction inside `FiniteKMCP.physicalPhases_eq`. These count different things
(quark-field rephasings modulo a common phase vs. spanning-tree gauge of the
phase incidence graph); both are internally correct and both land at
`physCP = (N−1)(N−2)/2`. No error, but a reader could conflate the two "N−1 vs
2N−1" subtractions.

### F4 — CAVEAT (grand framing on a 2-point toy)
`SuiteAOp2Geom` invokes "finite Malament split" / "Franco–Eckstein
causal-spectral-triple recipe". The construction and theorems are correct and
the row already states "Honest scope: 2-point Krein carrier"; the causal-order-
fixes-conformal-class reading is a faithful toy instance, not the general
theorem. No overstatement in the row itself; flagged as residual scope.

## Residual scope caveats (unchanged from the modules' own honest-scope notes)
* FiniteKMCP / KMPhaseCounting: general-N incidence/corank theorem still open.
* WEPTrace: E-slot field equation and Clausius/Jacobson rung not attempted.
* MassResourceModularAudit: false-shape guard only, not a mass-resource theory.
* Goal3ExactRG: finite *rational* RG, not a continuum limit; critical *line*
  (period-2 under sign), not a strict fixed point (this is stated in the row).
* SuiteAOp2Geom: 2-point carrier only.

## Verification note
This is a text- and elaboration-grounded audit: existence and axiom footprints
are backed by the green `lake build` and the enforced in-file guard pins, not by
grep alone.
