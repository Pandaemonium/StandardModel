# Proof job: compose the polynomial bound with the live massive HNU walk

Work in the supplied PhysicsSM Lean project. Start with the narrow command:

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUMassivePolynomialAdaptiveCost.lean
```

Fill every proof placeholder in that target without adding assumptions,
compiler-trusted evaluation, or fake declarations. The decisive target is
`massive_one_step_polynomial_bound`: it must compare the existing live
`HNUMassiveContinuumReduction.massiveWend` with its existing
`massiveEflow`, not replace either by a parallel toy definition.

Use the exact ingredients already landed:

- `HNUPolynomialAdaptiveCost.skewHermitian_ordered_product_bound`;
- its exact two-component depth-eight HNU exponential word;
- `HNUExactCore.endpoint` and the `Uplus`/`Uminus` projector factors;
- `HNUPlueckerMassiveStay.doubledChiralEndpoint`, `diracBasis`, and
  `massiveHNU`;
- `HNUMassiveContinuumReduction.massCoin4_eq_exp_mass4`, `norm_mass4`,
  `norm_kinetic4_le_qAbs`, exact unitarity, and `massiveEflow_div_pow`.

Likely proof ladder:

1. Prove exact phase-times-Pauli-rotation formulas for `Uplus` and `Uminus`.
2. Prove the live `HNUExactCore.endpoint` equals the landed exact depth-eight
   exponential word; all scalar phases must cancel exactly.
3. Pair the `q` and `-q` factors into four-component block-diagonal
   skew-Hermitian generators, then conjugate by `diracBasis`.
4. Prepend the exact Pluecker mass exponential and identify the generator sum
   with `-I * (kinetic4 q + mass4 z)`.
5. Bound the generator-norm sum. The target permits the conservative
   `2*qAbs q + norm z`; prove the sharper `qAbs q + norm z` if a block-norm
   equality is available, but do not weaken the theorem to an assumed
   one-step estimate.
6. Telescope exact unitaries, prove the compact-envelope theorem, and close
   the explicit schedule arithmetic.

If the displayed one-step statement is false, return an explicit finite
counterexample or the smallest corrected polynomial constant with a precise
explanation. Preserve the nonzero `q=(1,0,0)`, `z=3+4i` control. State all
semantic boundaries: fixed-time approximation cost only, not physical clock
hierarchy or interacting QFT.
