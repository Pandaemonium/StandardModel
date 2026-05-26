# Signed Affine Plaquettes from Sedenion Zero Divisors

This is the core mathematical workstream.  It should be completed before the
Barnes-Wall, quantum-information, or physics interpretations are pushed hard.

## Coordinate Convention

Label sedenion basis vectors by:

```text
e_a,  a in F_2^4.
```

Use the Cayley-Dickson split:

```text
a = (h,i),  h in F_2,  i in F_2^3.
```

Coordinates `0 = (0,0)` and `8 = (1,0)` are the two real coordinates in the
`O + O e_8` split.  The primitive zero-divisor geometry lives in the remaining
14 imaginary coordinates.

## Assessor Supports

For nonzero `i,j in F_2^3` with `i != j`, define the mixed support:

```text
A_(i,j) = span_R{ e_(0,i), e_(1,j) }.
```

This is one assessor plane.  There are:

```text
7 * 6 = 42
```

such ordered mixed supports if the low and high halves are distinguished.

## Same-Strut Affine Supports

Primitive zero-divisor products select four indices:

```text
P = { (0,i), (1,j), (0,p), (1,q) }.
```

The key finite-geometry condition is:

```text
i + j = p + q.
```

When this holds, `P` is an affine 2-plane in `F_2^4`.  This is the bridge to
Reed-Muller geometry.

There is a distinction worth preserving:

```text
same-strut mixed affine supports = 63
signed zero-product supports     = 42
```

The current Python exploration finds that the 42 signed zero-product supports
are a subset of the 63 same-strut mixed affine supports, and that both families
span the same shortened RM(2,4) subcode.  The 42-support family is the primary
object because it remembers the actual Cayley-Dickson cancellation equations.

## Signed Plaquette Data

The unsigned support only records the four indices.  The sedenion product also
records signs:

```text
e_a e_b = omega(a,b) e_(a+b),  omega(a,b) in {+1,-1}.
```

A signed plaquette should package:

```text
(P, alpha)
```

where:

- `P` is a four-point affine 2-plane;
- `alpha : P -> {+1,-1}` or `alpha : P -> {+1,-1,+i,-i}` is induced by the
  Cayley-Dickson cancellation rule.

## Theorem Targets

### Target 1: Support Classification

Prove or refute:

```text
Sedenion primitive zero-product supports are exactly the mixed affine
2-planes satisfying the same-strut condition.
```

### Target 2: Code Span

Let `SeedPlanes` be the 42 mixed affine planes selected by signed zero-product
equations.  Define:

```text
C_ZD = span_F2{ indicator(P) : P in SeedPlanes }.
```

Prove or refute:

```text
C_ZD = { c in RM(2,4) : c_0 = 0 and c_8 = 0 }.
```

Expected finite invariants:

```text
number of SeedPlanes = 42
number of same-strut mixed affine supports = 63
dim C_ZD = 9
W_CZD(y) = 1 + 77 y^4 + 168 y^6 + 203 y^8 + 56 y^10 + 7 y^12
span(SeedPlanes) = span(all same-strut mixed affine supports)
```

### Target 3: Cocycle Restriction

Define the Cayley-Dickson sign function:

```text
omega : F_2^4 x F_2^4 -> {+1,-1}.
```

Then compute its restriction to the plaquette complex:

```text
omega | SeedPlanes.
```

Classify whether this sign system is:

- exact;
- gauge-equivalent to a canonical quadratic form;
- a nontrivial cohomology class;
- equivalent to a known `Z_4`/Kerdock/Barnes-Wall phase convention.

## First Script

The first script should produce a machine-readable JSON object containing:

```text
basis labels
omega table
assessors
seed planes
generator matrix for C_ZD
weight enumerator
plane classification
signed zero-product equations
```

This JSON should become the source fixture for later Lean statements.
