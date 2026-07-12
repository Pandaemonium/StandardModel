# Stationary-Weyl tangent-chart elimination certificate

Date: 2026-07-12
Owner: Codex
Status: external exact oracle; the fourth-root witness is in Aristotle, while
the complete census is not yet a kernel theorem.

## Provenance and conventions

- Source symbol:
  `PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylTangent.lean`.
- External oracle: Python 3.12.10, SymPy 1.14.0.
- Phase convention: `z_j = exp(i q_j)` and tangent-half-angle coordinate
  `t_j = tan(q_j/2)`, so
  `z_j = (1-t_j^2 + 2 i t_j)/(1+t_j^2)`.
- The tangent chart omits `q_j = pi`; those boundary charts must be handled
  separately in any complete torus census.
- The CAS output is a discovery/certificate source, not a trusted proof.

## Exact Pauli numerator system

After cancelling the positive real denominators
`(1+t_x^2)(1+t_y^2)(1+t_z^2)`, the three Pauli coefficients vanish exactly
when the following integer polynomials vanish:

The overall sign of each numerator is immaterial. The reproducible script's
primitive normalization prints the negatives of the displayed `F_x` and
`F_z`; both conventions generate the same zero ideal.

```text
F_x =
  2108 tx^2 ty^2 tz^2 - 840 tx^2 ty^2 tz - 700 tx^2 ty^2
  + 1050 tx^2 ty tz - 3000 tx^2 tz - 245 tx ty^2 tz^2
  - 875 tx ty^2 + 3600 tx ty tz^2 - 875 tx tz^2 - 3125 tx
  - 700 ty^2 tz^2 - 2500 ty^2 + 3750 ty tz

F_y =
  168 tx^2 ty^2 tz - 140 tx^2 ty^2 + 625 tx^2 ty tz^2
  + 175 tx^2 ty - 500 tx^2 - 576 tx ty^2 tz^2
  + 210 tx ty^2 tz + 750 tx tz + 140 ty^2 tz^2
  + 600 ty^2 tz + 175 ty tz^2 + 625 ty + 500 tz^2

F_z =
  1344 tx^2 ty^2 tz^2 - 245 tx^2 ty^2 tz + 2400 tx^2 ty^2
  - 3600 tx^2 ty tz - 875 tx^2 tz + 840 tx ty^2 tz^2
  + 3600 tx ty^2 tz + 1050 tx ty tz^2 + 3750 tx ty
  + 3000 tx tz^2 + 2400 ty^2 tz^2 - 875 ty^2 tz - 3125 tz
```

These are the exact numerators obtained from the matrix fixture; they should be
reproved by entrywise normalization before being used in a kernel census.

## Lexicographic elimination

A lexicographic Groebner basis for `<F_x,F_y,F_z>` contains the univariate
factor

```text
tz * (480 tz^5 - 575 tz^4 - 1026 tz^2 + 1440 tz - 575)
   * (16384 tz^6 + 11040 tz^5 + 56375 tz^4 + 48000 tz^3
      + 44050 tz^2 + 19680 tz + 5175).
```

SymPy exact root counting reports one real root for the quintic and no real
root for the sextic. This root-count result is not yet Lean-checked.

On the quintic branch, recomputing the Groebner basis with the quintic adjoined
gives a compact triangular certificate:

```text
430976 tx
  = 1061280 tz^4 - 462525 tz^3 - 644875 tz^2
    - 2634243 tz + 1258155

820352 ty
  = 574560 tz^4 - 959475 tz^3 - 575125 tz^2
    - 958797 tz + 2176245

480 tz^5 - 575 tz^4 - 1026 tz^2 + 1440 tz - 575 = 0.
```

The quintic changes sign exactly at the rational controls used in the proof
target:

```text
p(149/100) = -8099334899 / 500000000 < 0
p(3/2)     = 169 / 16 > 0.
```

Its real root is approximately `1.49611792480646`; the reconstruction gives

```text
tx approximately -0.8308084839900073
ty approximately -1.0727177638585432
tz approximately  1.49611792480646
q/pi approximately (-0.4413343333, -0.5223255611, 0.6249041192),
```

matching the deterministic matrix oracle.

## Proof program

1. Prove the rational sign controls and obtain a root by the intermediate
   value theorem.
2. Prove the triangular polynomial identities imply `F_x=F_y=F_z=0` by exact
   ring normalization modulo the quintic.
3. Reconstruct the three unit phases and prove the actual live matrix equals
   identity. This is Aristotle project `5c45a7f6`.
4. Prove the quintic has exactly one real root and the sextic has none, using a
   kernel-checkable Sturm sequence or explicit positivity certificate.
5. Classify the `tz=0` branch exactly.
6. Audit all omitted tangent-chart boundaries `q_j=pi` and combine the charts.

Only after steps 4--6 may the manuscript promote the numerical four-root
census to a complete exact theorem.
