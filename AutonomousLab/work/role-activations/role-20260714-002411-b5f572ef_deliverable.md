# Phenomenologist observable card - half-space boundary-defect charge (Class 3 benchmark)

- Model/role: claude / Phenomenologist (solo mode, active=claude)
- Extends: `CLAUDE_PHENOMENOLOGIST_ANOMALOUS_FLOQUET_2026-07-13.md` (Class 3 -
  boundary anomaly-inflow) with a concrete finite benchmark card for the
  landed `HalfSpaceDefectIndex` result. Does not duplicate the Pluecker-phase card.
- Contract: observable/benchmark map with fitted vs held-out inputs, units,
  sensitivity, and a concrete falsifier.

## Executive verdict

The landed finite result (`stabilizedIndex = +1`, window-stable, channel-additive)
is a rigorous **benchmark value** for the Class-3 boundary observable: the charge
localized in a near-boundary window of a driven half-space per period. It is a
zero-free-parameter integer prediction with a sharp falsifier (size-dependence or
non-additivity). It is NOT yet tied to the HNU walk - that binding is the held-out
test that would upgrade it from benchmark to prediction.

## Observable card

### Observable
`Q_window(K, N)` = trace of the boundary-defect operator `SᴴS - SSᴴ` summed over a
fixed near-boundary window `sites 0..K` of a half-space of size `N+1`, under one
application of the drive (here the unilateral shift `S`). Physically: the net
charge pumped into / localized at the edge region per drive period.

### Predicted value (from the theorem)
`Q_window(K, N) = +1` for every cutoff `N > K` (`localized_window_trace_stabilizes`);
`= +m` for `m` internal channels (`stabilizedIndex_additive`); `= 0` for a
bilateral/permutation drive (`permMatrix_no_defect`); orientation reversal gives
`-1` (`stabilizedIndex_add_reversed_eq_zero`). Integer, quantized, size-independent.

### Units dictionary
- `Q_window`: dimensionless (charge in units of the pumped quantum e; an integer).
- `K` (window radius), `N` (system size): lattice sites (dimensionless counts).
- Drive period `T`: seconds; the observable is per-period, so a *rate* form is
  `Q_window / T` with units `s^-1` if realized in a physical Floquet drive
  (e.g. driven optical lattice, `T ~ microseconds`; photonic mesh lattice,
  `T ~ ns`). The integer is the physical content; `T` only sets the cadence.
- Channel count `m`: dimensionless (internal/spin/color multiplicity).

### Input classification (fitted vs held-out)
- **Fixed by construction (not fitted):** the drive is the bare shift `S`; the
  window `K`; the cutoff `N`. No continuous parameter is tuned to hit `+1`.
- **Held out for a valid benchmark of the HNU claim:** replace `S` by the actual
  HNU half-line boundary evolution and recompute `Q_window` from an INDEPENDENT
  finite construction. If it returns `+1` with the same window-stability and
  channel-additivity WITHOUT importing the shift model, that is a genuine held-out
  confirmation the HNU edge wears this index. Currently un-done (Gate-1 step).
- **Conventional-baseline input:** the AFAI edge pumped charge (Rudner et al.,
  `1212.3324`) and the unilateral-shift Fredholm index `ind(S) = -1` - both give
  the same integer; the benchmark must beat "we reproduced a known index," not
  merely match it.

### Sensitivity / error model
- Finite-size: the prediction is EXACT for all `N > K` (no `1/N` tail) - the
  compensating `-1` sits precisely on site `N` and never enters the window. So
  sensitivity to `N` is ZERO above threshold; the only requirement is `N > K`.
  This exactness is the sharp, testable fingerprint (contrast: a trivial local
  quantity would drift with `N`).
- Channel linearity: `dQ/dm = 1` exactly. Any sublinear/superlinear scaling
  falsifies the additive-index reading.
- Numerical: exact-arithmetic (`Rat`) - no floating error; a physical realization
  inherits its own readout noise `sigma_Q`; resolve the integer if `sigma_Q < 0.5`.

### Concrete falsifier
The Class-3 index reading is FALSE if any of:
1. `Q_window(K, N)` depends on `N` for `N > K` (defect does not stabilize -> no
   localized index; it was a finite-size artifact).
2. `Q_window` is non-integer or `dQ/dm != 1` (no additive index structure).
3. The HNU held-out recomputation returns `0` (or a paired `+1,-1` in the same
   window) instead of a lone stabilized `+1` -> the HNU edge does NOT carry a
   single unremovable defect, and the single-Weyl-at-the-edge route dies here
   (this is the decisive Gate-1 kill).

### Claim ceiling
This card licenses: "a finite half-space drive carries a quantized, size-stable,
additive boundary defect `+1`." It does NOT license: a physical edge mode, a
Fredholm index on `l^2(N)`, a bulk-edge correspondence, or (yet) any statement
about the HNU walk. Those are the held-out / open items.

## Benchmark map (where this sits)

| Observable class (dictionary) | Benchmark quantity | Value | Status |
| --- | --- | --- | --- |
| Class 1 endpoint spectrum | 0/pi crossing census | both populated | landed (HNUGlobalZeroPiChargeLedger) |
| Class 2 micromotion winding | schedule holonomy `-1` invariant | passive/no-escape | landed (ScheduleIndexedTransportCore) |
| **Class 3 boundary anomaly-inflow** | **`Q_window = +1`, size-stable, additive** | **this card** | **landed precursor (HalfSpaceDefectIndex)** |
| Class 4 compact-interior exhaustion | interior-decoupling | open | Gate-1 held-out |

## Next simulation gate (cheap, before Aristotle)

Emit a deterministic exact-arithmetic benchmark script that computes `Q_window(K,N)`
for `S` = shift AND `S` = a finite HNU half-line boundary evolution, printing the
window trace for `N in {K+1, 2K, 10K}` and `m in {1,2,3}`. If the HNU column
returns a stabilized `+1` additive in `m`, that is the held-out Class-3 confirmation
and the concrete first rung of Gate 1; if it returns `0` or a paired defect, the
single-edge-Weyl route is falsified there. This is the highest-information cheap
phenomenology test in the portfolio right now.
