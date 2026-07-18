# Aristotle task: Palatini coframe response to mixed Einstein equation

Work only in `PalatiniCoframeEinstein/Target.lean`. Run this narrow check first:

```text
lake env lean PalatiniCoframeEinstein/Target.lean
```

Prove `palatiniDensityFirstVariation_eq_det_mul_mixedEinstein` without changing
its statement, definitions, signs, normalizations, basis order, or hypotheses.
Do not introduce new assumptions or escape hatches.

## Mathematical reading

- `coframe I a` is an oriented tetrad with internal row `I` and spacetime
  column `a`.
- `inverseCoframe a I` is its two-sided inverse.
- Bivector coordinates are ordered `(12,13,23,01,02,03)`.
- The internal Krein signs are `(+,+,+,-,-,-)` and orientation is `0123`.
- `curvature a b` is antisymmetric in the ordered spacetime face and its
  `curvatureMatrix` is antisymmetric in internal indices by construction.
- The target is the exact first tetrad variation of the ordered Palatini
  density. The right side is `det(e)` times the coframe-index form of
  `2 Ric^d_c - delta^d_c R`, paired with an arbitrary tetrad variation.

An independent exact-rational non-diagonal test gave both sides the value
`546`; this calibrates the displayed positive sign and factor `2` but is not a
proof.

Prefer a robust finite-dimensional proof. Explicit `Fin 4`/`Fin 6` expansion,
cofactor identities, polynomial normalization, and consequences of the two
inverse hypotheses are all acceptable. You may add proved helper lemmas in
the same file. Keep the target signature unchanged.

Finish with a short report listing the solved theorem, any helper lemmas,
whether the target statement changed, remaining proof holes, and assumptions
or nonstandard axioms used.
