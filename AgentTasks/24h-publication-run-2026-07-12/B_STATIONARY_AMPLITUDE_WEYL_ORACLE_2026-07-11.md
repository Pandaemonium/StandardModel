# Stationary-amplitude Weyl full-zone oracle

## Scope

This memo audits the explicit symbol in
`PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylTangent.lean`. The exact
coefficient calculation is reproducible with:

```powershell
python Scripts/oracle/analyze_stationary_amplitude_weyl.py
```

The script uses the proved range-one Laurent expansion for each axis, not the
factorized phase product with an unreduced `z * conjugate(z)` term.

## Exact structure

For each axis, with `c^2+s^2=1`, the determinant is

```text
9(c^2+s^2)/25 + 16/25 = 1.
```

Therefore the ordered three-axis symbol is exactly `SU(2)` on the torus.
The script derives exact rational trigonometric polynomials for the scalar
coefficient `u0` and three real Pauli coefficients `wx,wy,wz`; all four
imaginary parts simplify identically to zero. Crossings are therefore exactly
the common zeros of `wx,wy,wz`, with `u0=+1` or `u0=-1`.

## Numerical census and exact kill

A deterministic seven-point grid plus 5,000 seeded random starts repeatedly
finds four zero-gap roots and no pi-gap root:

```text
q / pi approximately (-1,          0,         -1)
q / pi approximately (-0.570446575, 0.570446575, 0)
q / pi approximately (-0.441334330,-0.522325560, 0.624904120)
q / pi =             (0,           0,          0)
```

All have `u0=+1` to numerical precision. The first non-origin root is exact:

```text
U(-1, 1, -1) = I.
```

This identity and phase distinctness are now kernel-checked in
`StationaryAmplitudeWeylAlias.corner_alias` and
`exists_distinct_identity_alias`. Thus the construction is definitively not a
unique-cone walk. The two off-corner roots remain oracle candidates until an
exact algebraic certificate is derived.

## Scientific conclusion

The construction proves that strict range-one locality, exact unitarity,
nonzero onsite amplitude, and an isotropic Weyl first moment can coexist. The
exact corner alias proves those local conditions do not control the global
Brillouin torus. The next worthwhile theorem is a complete root census or a
minimal-doubling classification, not another proof of the already-landed local
properties.
