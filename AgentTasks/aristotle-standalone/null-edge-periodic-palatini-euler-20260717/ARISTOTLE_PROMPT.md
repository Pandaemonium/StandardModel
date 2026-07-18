# Aristotle target: periodic finite Palatini Euler coefficient

Prove `connectionEulerCoefficient_eq_explicit` in
`PeriodicPalatiniEuler.lean` without changing any definition or theorem
statement.

Run this narrow check first:

```text
lake env lean PeriodicPalatiniEuler.lean
```

The target is an exact finite algebra identity. The carrier is finite, each
directed shift is an equivalence, and the connection is unrestricted: do not
assume torsion-freeness, metric symmetry, connection symmetry, or continuum
limits. You may add small helper lemmas for periodic summation by parts and
finite-sum/index rearrangement. Do not introduce assumptions or use `axiom`,
`unsafe`, `native_decide`, or unresolved proof placeholders.

The intended coefficient of `H^a_bc(x)` is:

```text
D^-_a P_cb
- delta_ab sum_r D^-_r P_cr
+ delta_ab sum_lr P_lr Gamma^c_rl
+ P_cb sum_u Gamma^u_ua
- sum_l P_lb Gamma^c_al
- sum_r P_cr Gamma^b_ra,
```

where `P_lr = volume * inverseMetric_lr`. Please preserve this index order.
