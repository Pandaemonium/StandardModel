# Memo: exact 4×4 Plücker phase-defect spectral theorem (free carrier)

File: `RequestProject/Main.lean`
Namespace: `PhysicsSM.Draft.NullEdge.PlueckerPhaseDefectSpectrum`
Mathlib-only, kernel-only (every theorem depends solely on
`propext, Classical.choice, Quot.sound`; no `native_decide`, no `sorry`,
no added axioms or `@[implemented_by]`).

## Objects

* `Bmat z = !![0, z; conj z, 0]`, `Sig = !![1,0;0,-1]`,
  `Dg w = !![w,0;0,conj w]`, `Tcoup t w = (t:ℂ) • (Sig * Dg w)`.
* `Hmat zL zR t w` : 4×4 Hamiltonian, block form `[[B zL, T],[Tᴴ, B zR]]`,
  written entrywise as
  `!![0, zL, t·w, 0; conj zL, 0, 0, -t·conj w; t·conj w, 0, 0, zR; 0, -t·w, conj zR, 0]`.
* `aObs zL t = zL·conj zL + (t:ℂ)²`  (= |zL|² + t²).
* `Delta zL zR w = zR - (conj w)²·zL`  (transported mismatch, `(conj w)² = e^{-iχ}`).
* `gSq zL zR w t = normSq zL + t² - t·‖Δ‖`  (preregistered gap observable).
  NOTE: this Mathlib version has removed `Complex.abs`, so the norm `‖·‖` is
  used in place of `Complex.abs`.

## What landed (all proved, verified identities)

* **T1** `Bz_sq` : `B z · B z = (z·conj z) • 1`.
* **T2** `sigma_anticomm` : `Σ · B z = -(B z · Σ)`.
* **T3** `H_hermitian` : `Hᴴ = H` (no `|w|=1` needed).
* **T4 (MAIN)** `phaseDefect_polynomial` : under `hw : w·conj w = 1` and
  `hmod : zL·conj zL = zR·conj zR`,
  `(H² − a·1)² = (t²·Δ·conj Δ) • 1`.
* **T5 (CONTROL)** `phaseDefect_needs_equal_moduli` : at
  `zL=1, zR=2, t=1, w=1` the two sides of T4 differ (the (3,3) entry differs
  by 9). The equal-modulus hypothesis is load-bearing.
* **T6** `phaseDefect_spectrum` : for any eigenpair `H·v = μ·v`, `v ≠ 0`,
  `(μ² − a)² = t²·Δ·conj Δ`  (squared form; `μ² = a ± t‖Δ‖`).
* **T7** `trace_Hsq` : `trace H² = 2|zL|² + 2|zR|² + 4t²` (needs `|w|=1`);
  corollary `trace_Hsq_eq_four_a` : `trace H² = 4a` under equal moduli.
* **T8** `gap_zero_of` (⇐) and `gap_zero_forward` (⇒), combined in
  `gap_zero_iff` : for `t ≥ 0` and equal moduli,
  `gSq = 0 ↔ (t = ‖zL‖ ∧ zR = -(conj w)²·zL)`.
  Forward direction uses `norm_add_le`, the triangle-equality/`SameRay`
  criterion `sameRay_iff_norm_add`, and `SameRay.exists_nonneg_left`.
* **T9** `Vmat_unitary` : `V = diag(b, conj b, b, conj b)` is unitary
  (`Vᴴ V = 1`); `common_phase_conjugacy` :
  `V · H(zL,zR) · Vᴴ = H(b²·zL, b²·zR)`. Common phase `b²` is removable;
  the observable depends only on the transported relative phase.

## Independent numerical confirmation

Before proving, the T4 identity `(H²−a)² = (t²Δ conjΔ)·1` was checked over
`ℤ[i]` (computable) and evaluated to the zero matrix for many equal-modulus
inputs with nontrivial units `w ∈ {±1, ±i}`; the same computation gives a
nonzero matrix at `zL=1, zR=2, t=1, w=1`, matching T5.

## Physics framing (memo only)

This is the free-carrier one-particle avatar of "the Plücker phase is
physical": two sites with EQUAL |z| but different transported relative phase
have different spectra, with preregistered gap observable `gSq` and exact
zero-mode locus `t = |zL|`, `zR = -e^{-iχ} zL`. Finite and self-contained
(Jackiw–Rossi / GW-adjacent). This is **not** a topological-protection
statement.
