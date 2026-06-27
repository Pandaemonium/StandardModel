# FUR-H7A — `Φ_H` coordinate bridge: report and caveats

## Outcome

`PhysicsSM/Draft/NullEdgeFureyPhiHCoordinateBridge.lean` builds cleanly (no
`sorry`, allowed axioms only) and supplies the requested narrow bridge from the
abstract `Φ_H` interface (`NullEdgeFureyPhiH`) to the coordinate
occupation / internal-spectrum model (`NullEdgeFureyInternalSpectrum`,
`Algebra/Furey/ConjugateIdeal`).

The off-diagonal, `χ_E`-odd, `Γ_s`-even facts and the `±Φ_H²` sign dichotomy are
proved at the coordinate level; full gauge covariance is delivered as a named
conditional bridge (`CoordinateGaugeData` ⇒ `coordinate_conditional_bridge`)
with a concrete non-vacuity witness.

## Caveats

1. **Conditional gauge covariance.** As anticipated by the task, full gauge
   covariance is stated conditionally on the named intertwining hypotheses
   bundled in `CoordinateGaugeData` (the same hypotheses the abstract
   `GaugeCovariantPhiH` requires). The conditional theorem is proved
   unconditionally; only its gauge-representation premises are assumed. A
   concrete inhabitant (`trivialGaugeData`, the identity gauge action) shows the
   premises are satisfiable.

2. **`Mcoord = id` is a placeholder coupling, not a Yukawa derivation.** It is an
   arbitrary nonzero constant chirality-flip block chosen to make the bridge
   concrete and non-vacuous. No singular values / masses are computed. The three
   structural facts (`χ_E`-odd, `Γ_s`-even, sign dichotomy) hold for *any* `M`,
   so nothing depends on this choice.

3. **Basis non-identification.** The left/right coordinate factors are labelled
   by the all-left Furey-`J` / `J*` charge tables (`qJ`, `qJstar`,
   `fureyJChargeMultiset`). These all-left bookkeeping charges are **not**
   identified with the physical Dirac `L ⊕ R` kinetic basis on which `Φ_H`
   acts — the same guardrail already documented in `NullEdgeFureyPhiH` and
   `NullEdgeFureyInternalSpectrum`. The bridge only reuses the finite charge
   tables as coordinate labels and records `q_R = -q_L`.

4. **Octonion / `Jbar` bridge untouched.** Per the task, no `ℂ⊗𝕆` algebra,
   ladder operators, or live `Jbar` coordinate equivalence are used here. This is
   strictly coordinate-level.

5. **Infrastructure fix.** The `SpherePacking` dependency was absent from
   `.lake/packages` and had to be fetched (`lake update SpherePacking`), which
   updated `lake-manifest.json` to the resolved git revision. This was required
   for the Lean toolchain to configure the workspace; it does not affect the
   default `PhysicsSM` target, which is SPL-free.
