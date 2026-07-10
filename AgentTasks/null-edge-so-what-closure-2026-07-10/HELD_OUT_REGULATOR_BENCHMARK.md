# Held-out regulator benchmark

Status: pre-registered, then executed once without parameter changes. PASS.

## Primitive input

- Complex Pluecker coordinate: `z = 3 + 4 i`, fixed by the exact repository
  control and not fitted.
- Walk mass-step parameter: `eps = 0.2`, hence mass angle `eps * |z| = 1`.
- Wilson comparison: massless Hamiltonian with `r = 1`.
- Momentum set: the eight cubic corners `{0, pi}^3` plus the body center
  `(pi/2, pi/2, pi/2)`.

## Theorem chain

1. `Pluecker3Plus1ComplexMass.control_three_four_I` fixes a nonzero complex
   mass operator with square `25 I`.
2. `StrictQCAMinimalArchitecture.live_degree_one_factorized_lower_bound`
   predicts that the three non-origin even-parity corners exactly equal the
   origin after any momentum-independent onsite Pluecker coin.
3. `Finite3Plus1BrillouinAudit.body_center_plus_mode_eigen` and
   `body_center_minus_mode_eigen` predict exact `+1` and `-1` body-center modes.
4. `WilsonDiracRegulator.massless_energy_eq_zero_iff` and
   `pi_x_corner_energy` predict that only the origin is gapless and the
   smallest non-origin cubic-corner energy magnitude is `2 r = 2`.

## Predicted output

- strict-walk non-origin aliases of the origin: exactly `3`;
- maximum even-corner alias residual: below `1e-10`;
- body-center distance to both `+1` and `-1` spectrum: below `1e-10`;
- Wilson non-origin gapless corners: `0`;
- Wilson minimum non-origin corner `|energy|`: at least `2 - 1e-10`;
- unregulated `r=0` negative control: all `8` corners gapless.

## Kill threshold

The benchmark fails if any prediction above fails.  In particular, a free fit
is forbidden: the script accepts no optimizer and does not alter `z`, `eps`,
or `r`.  Numerical success validates the implementation of the theorem chain;
it is not a substitute for the Lean proofs.

## Algorithm

`Scripts/sim/null_edge_regulator_benchmark.py` constructs the exact project
Clifford matrices, ordered walk factors, complex Pluecker mass coin, and Wilson
Hamiltonian in NumPy; evaluates only the pre-registered momenta; records all
residuals and spectra; runs the negative control; and writes a JSON report.

## First held-out result

Executed with:

```text
python Scripts/sim/null_edge_regulator_benchmark.py
```

The generated report is
`Scripts/sim/results/null_edge_regulator_benchmark.json`.  Observed metrics:

- non-origin even aliases: `3`;
- maximum alias residual: `2.298660082789514e-16`;
- body-center `+1` distance: `5.928737959693675e-17`;
- body-center `-1` distance: `2.237206298897719e-16`;
- Wilson non-origin zero corners: `0`;
- Wilson minimum non-origin gap: `2.0`;
- unregulated zero corners: `8`.

All pre-registered checks passed. No parameter was changed after registration.
