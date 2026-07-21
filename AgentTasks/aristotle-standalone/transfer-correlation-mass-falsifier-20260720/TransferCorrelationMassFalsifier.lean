import Mathlib

/-!
# Transfer-matrix pole falsifier: equal spectral gap, inequivalent correlation mass

The Euclidean/transfer-matrix branch of the origin-of-mass gap-to-pole
obstruction (AFPL gate A3/A4). Companion to the landed resolvent-branch fact
`GapPoleResponseObstruction.gap_does_not_fix_pole`.

A composite/binding mass is read off as the exponential decay rate of a
gauge-invariant two-point function `C(n) = ⟨v, T^n v⟩` for a positive transfer
operator `T` and a physical observable `v`. The decay rate is naively the
transfer spectral gap `-log(λ₂/λ₁)`. This module exhibits two transfer matrices
with the IDENTICAL spectrum (hence identical spectral gap) whose physical
correlation functions decay at DIFFERENT rates, because the physical observable
has zero overlap with the slow mode in one case. Hence the transfer spectral gap
does not determine the physical (correlation) mass without the observable-overlap
data.

Intended witnesses (`2 x 2`, real symmetric, both eigenvalues `{2, 1}` so the
spectral gap `log 2` is identical):

- `Tfull = diag(2, 1)` with observable `v = (1, 1)`: `C(n) = 2^n + 1`, leading
  decay governed by the top mode; the ratio `C(n+1)/C(n) → 2` exposes the gap.
- `Tdark = diag(2, 1)` with observable `w = (0, 1)`: `C(n) = 1`, constant — the
  physical channel has ZERO overlap with the `λ = 2` mode, so the correlation
  reveals NONE of the spectral gap. The "correlation mass" of `w` is `0`
  (no decay contrast) while the transfer gap is `log 2`.

More sharply, with a fixed `T = diag(2,1)` two observables give correlation
functions whose decay-rate readout differs, proving the readout is
observable-dependent, not a transfer-spectrum invariant.

Target: a kernel-checked existence theorem of two (transfer, observable) pairs
with equal transfer spectrum but unequal correlation-decay behavior in the
precise sense below. Small explicit real/complex matrices; Mathlib only; report
axioms.
-/

namespace PhysicsSM.Draft.NullEdge.TransferCorrelationMassFalsifier

open Matrix

/-- Two-point correlation of observable `v` under `n` steps of transfer `T`:
`C(n) = ⟨v, Tⁿ v⟩` with the standard real inner product on `Fin 2`. -/
noncomputable def corr (T : Matrix (Fin 2) (Fin 2) ℝ) (v : Fin 2 → ℝ) (n : ℕ) : ℝ :=
  (v ⬝ᵥ (T ^ n).mulVec v)

/-- The transfer operator (both witnesses share it): `diag(2, 1)`, spectrum
`{2, 1}`, spectral gap `log 2`. -/
def Tgap : Matrix (Fin 2) (Fin 2) ℝ := !![(2 : ℝ), 0; 0, 1]

/-- Observable overlapping the slow (fast-growing) mode. -/
def vBright : Fin 2 → ℝ := ![1, 1]

/-- Observable orthogonal to the `λ = 2` mode: sees only the `λ = 1` mode. -/
def vDark : Fin 2 → ℝ := ![0, 1]

/-- **The transfer-gap pole falsifier.**  With one fixed transfer operator of
spectral gap `log 2`, the correlation function of `vBright` grows like `2^n`
(revealing the gap) while the correlation of `vDark` is constant in `n` (blind
to the gap): the physical correlation-mass readout is observable-dependent, not
a transfer-spectrum invariant.  Concretely `corr Tgap vBright n = 2^n + 1` and
`corr Tgap vDark n = 1`, so the two decay/growth behaviors differ for all
`n ≥ 1` although the transfer spectrum is identical. -/
theorem transfer_gap_does_not_fix_correlation_mass :
    (∀ n : ℕ, corr Tgap vBright n = 2 ^ n + 1) ∧
      (∀ n : ℕ, corr Tgap vDark n = 1) ∧
      corr Tgap vBright 1 ≠ corr Tgap vDark 1 := by
  sorry

end PhysicsSM.Draft.NullEdge.TransferCorrelationMassFalsifier
