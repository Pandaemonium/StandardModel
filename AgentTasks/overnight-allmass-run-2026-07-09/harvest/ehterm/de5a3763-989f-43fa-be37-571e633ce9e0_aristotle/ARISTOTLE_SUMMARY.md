# Summary of changes for run de5a3763-989f-43fa-be37-571e633ce9e0
Delivered `RequestProject/Main.lean` (namespace `EinsteinHilbertTerm`) plus `ARISTOTLE_SUMMARY.md`, building cleanly with Mathlib (no sorry/admit/native_decide, no new axioms).

The file formalizes the finite matrix avatar of the spectral action's order-2 (Einstein–Hilbert / curvature) term for a soldered Dirac carrier `D(E) = Dkin + E • Dsold` with explicit rational matrices `Dkin = !![1,2;0,-1]`, `Dsold = !![0,1;1,0]` (traces `tr(Dkin²)=tr(Dkin·Dsold)=tr(Dsold²)=2 ≠ 0`).

Targets:
1. `order2_is_curvature` — `tr(D²) = tr(Dkin²) + 2E·tr(Dkin·Dsold) + E²·tr(Dsold²)`, a closed rational quadratic (via generic `trace_sq_expand`). The finite curvature/E-H functional `Rfin E = 2E·tr(Dkin·Dsold) + E²·tr(Dsold²) = 4E + 2E²` is exhibited (`Rfin_explicit`, `order2_split`, `order2_explicit`: `tr(D²) = 2 + 4E + 2E²`).
2. `einstein_equation` — via `HasDerivAt` the derivative is `2·tr(Dkin·Dsold) + 2E·tr(Dsold²) = 4 + 4E`; stationarity gives the vacuum `E⋆ = -tr(Dkin·Dsold)/tr(Dsold²) = -1` (`Estar_formula`, `einstein_vacuum`). The sourced version `einstein_sourced` yields `d/dE[tr(D²)] = μ` with explicit solution; `einstein_control` gives the control `E=0 ≠ E⋆` where the derivative is `4 ≠ 0`.
3. `curvature_sign` — `tr(Dsold²) = 2 > 0` (the E²-coefficient), so the functional is convex and `E⋆` is a genuine minimum.
4. `eh_verdict` — packages the split, explicit `Rfin`, vacuum stationarity, the `E⋆` formula, and positivity.

Honest scope is stated: a finite rational-polynomial avatar, not the heat-kernel a₂ coefficient of a genuine spectral triple. Each headline (`order2_is_curvature`, `einstein_equation`, `curvature_sign`, `eh_verdict`) carries an in-file `#guard_msgs (whitespace := lax) in #print axioms` check confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`. All committed and pushed.

# EinsteinHilbertTerm — the spectral action's order-2 term is the finite curvature (Einstein–Hilbert)

A self-contained finite matrix avatar (Mathlib only, kernel-checked) showing that the
order-2 term `tr(D²)` of the spectral action, for a soldered Dirac carrier
`D(E) = Dkin + E • Dsold`, is a finite **curvature functional** of the soldering
(E-slot) data, and that its stationarity is a finite Einstein–Hilbert field equation.

All results live in `RequestProject/Main.lean`, namespace `EinsteinHilbertTerm`.

## The explicit model (real rational matrices)

* `Dkin = !![1,2; 0,-1]` — kinetic part.
* `Dsold = !![0,1; 1,0]` — soldering generator (off-diagonal E-slot block).
* `D E = Dkin + E • Dsold`.

Concrete traces: `tr(Dkin²) = 2`, `tr(Dkin·Dsold) = 2`, `tr(Dsold²) = 2` (all `≠ 0`).

## Targets delivered

1. **`order2_is_curvature`** — `tr(D²) = tr(Dkin²) + 2E·tr(Dkin·Dsold) + E²·tr(Dsold²)`,
   a closed rational quadratic in `E` (proved via the generic `trace_sq_expand`:
   trace linearity + `tr(AB)=tr(BA)`). The E-dependent part is the finite
   Einstein–Hilbert functional `Rfin E = 2E·tr(Dkin·Dsold) + E²·tr(Dsold²)`,
   exhibited explicitly as `Rfin E = 4E + 2E²` (`Rfin_explicit`), with
   `order2_split` / `order2_explicit` giving `tr(D²) = tr(Dkin²) + Rfin E = 2 + 4E + 2E²`.

2. **`einstein_equation`** — via `HasDerivAt`, the derivative of the order-2 term is
   `2·tr(Dkin·Dsold) + 2E·tr(Dsold²) = 4 + 4E`. Stationarity `= 0` gives the vacuum
   configuration `E⋆ = -tr(Dkin·Dsold)/tr(Dsold²) = -1` (`Estar`, `Estar_formula`,
   `einstein_vacuum`). The sourced version (`einstein_sourced`) shows that with a
   matter source `μ` the equation becomes `d/dE[tr(D²)] = μ`, solved by the explicit
   rational `Eμ = (μ - 2·tr(Dkin·Dsold))/(2·tr(Dsold²))`. A control point
   `E = 0 ≠ E⋆` where the derivative is `4 ≠ 0` (`einstein_control`) confirms
   stationarity genuinely fails away from `E⋆`.

3. **`curvature_sign`** — the `E²`-coefficient `tr(Dsold²) = 2 > 0` (Krein grading of
   the soldering block) is positive, so the curvature functional is convex and `E⋆`
   is a genuine minimum, not a saddle.

4. **`eh_verdict`** — packages the split, the explicit `Rfin`, vacuum stationarity at
   `E⋆`, the `E⋆` formula, and the positivity of the curvature coefficient. One
   functional carries order-0 (Λ / volume), order-2 (Einstein–Hilbert, here), and
   order-4 (matter).

## Honest scope

This is a finite rational-polynomial avatar of the order-2 spectral-action term. It is
**not** the heat-kernel `a₂` coefficient of a genuine (infinite-dimensional) spectral
triple; it captures the algebraic structure "order-2 term = curvature quadratic in the
soldering, stationarity = Einstein equation, source = matter" in a fully explicit,
kernel-checked finite setting.

## Verification

* Builds with Mathlib in under 3 minutes; no `sorry`/`admit`/`native_decide`, no new axioms.
* Proofs use only `ring`/`norm_num`/`simp`/`HasDerivAt` lemmas; no `Complex`,
  no `Real.sqrt`/`cos`/`sin`, no high-degree `nlinarith`.
* Each headline (`order2_is_curvature`, `einstein_equation`, `curvature_sign`,
  `eh_verdict`) carries an in-file `#guard_msgs (whitespace := lax) in #print axioms`
  check confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`.
