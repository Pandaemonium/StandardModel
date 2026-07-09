# claude-einstein-hilbert-term — the spectral action's order-2 term IS the finite curvature (Einstein-Hilbert)

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

In the spectral action `Tr f(D/Lambda)`, the order-2 heat-kernel term is the Einstein-Hilbert
gravity term (`~ integral R`, the scalar curvature). The finite avatar `SpectralActionAvatar`
landed the split `S(D) = a0 tr(1) + a2 tr(D^2) + a4 tr(D^4)` (order-0 = Lambda/volume, order-2 =
gravity, order-4 = matter). Deepen the order-2 term: show `tr(D^2)` for the soldered carrier is a
finite CURVATURE functional of the soldering (E-slot) data, and its stationarity gives a finite
Einstein-tensor equation. Composes with TeleparallelSoldering (torsion) and GravitySourceMatter.

## The model (explicit rational matrices)

Carrier `D = Dkin + E * Dsold` with an explicit rational kinetic part and the soldering generator
`Dsold` scaled by the E-slot decoration `E`. Compute `tr(D^2)` in closed form as a quadratic in
the soldering data.

## Targets

1. `order2_is_curvature`: `tr(D^2) = tr(Dkin^2) + 2 E tr(Dkin Dsold) + E^2 tr(Dsold^2)` -- a closed
   rational quadratic in `E`; identify the `E`-dependent part `R_fin(E) := 2 E tr(Dkin Dsold) +
   E^2 tr(Dsold^2)` as the finite curvature/Einstein-Hilbert functional of the soldering (the
   order-2 gravity term). Exhibit it explicitly.
2. `einstein_equation` (payload): stationarity of the order-2 term under the soldering variation
   `d/dE [tr(D^2)] = 0` gives the finite field equation `2 tr(Dkin Dsold) + 2 E tr(Dsold^2) = 0`,
   i.e. `E* = - tr(Dkin Dsold)/tr(Dsold^2)` -- the finite "Einstein tensor = 0" (vacuum) soldering
   configuration; with a matter source `mu` added, `... = mu` (the sourced version). Prove via
   HasDerivAt, with the explicit rational `E*`.
3. `curvature_sign` (a physical readable): `tr(Dsold^2)` is the coefficient of `E^2` -- its SIGN
   (from the Krein grading of the soldering block) determines whether the curvature functional is
   convex (a genuine minimum `E*`) or a saddle. Exhibit the sign on the explicit witness.
4. `eh_verdict`: package -- the spectral action's order-2 term is a finite curvature functional of
   the soldering (E-slot); its stationarity is a finite Einstein-Hilbert field equation for the
   geometry; matter enters as the source (tie to GravitySourceMatter). One functional: order-0
   Lambda (LambdaUnimodular), order-2 Einstein-Hilbert (here), order-4 matter. Honest scope: a
   finite polynomial avatar, not the heat-kernel a2 coefficient of a real spectral triple.

MANDATORY non-degeneracy: fully explicit rational `Dkin, Dsold` with `tr(Dsold^2) != 0`; compute
`E*` a specific nonzero rational; a control `E != E*` where stationarity fails. All in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL rational matrices (small, traces of powers); ring/norm_num/decide/
fin_cases + HasDerivAt; NO Complex, NO Real.sqrt/cos/sin, NO nlinarith deg>=3. Build under 3 min.
Deliver RequestProject/Main.lean (namespace EinsteinHilbertTerm) + ARISTOTLE_SUMMARY.md.
