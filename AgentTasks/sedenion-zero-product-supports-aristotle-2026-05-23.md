# Aristotle S3: signed zero-product support classification

Create a draft Lean module:

```text
PhysicsSM/Draft/Sedenions/ZeroProductSupports.lean
```

## Goal

Formalize the first real sedenion zero-divisor theorem:

```text
signed primitive assessor zero products select exactly 42 four-point
mixed affine supports in F_2^4.
```

This should use the recursive Cayley-Dickson convention from
`Sedenions/CayleyDickson_Convention.md` and the finite oracle script
`Scripts/sedenions/explore_zero_divisor_geometry.py`.

## Definitions

Use labels:

```text
low i  = i       for i in {1,...,7}
high j = 8 + j   for j in {1,...,7}
```

An assessor support is:

```text
A(i,j) = {low i, high j},  i != j.
```

A signed assessor vector is:

```text
v(i,j,sigma) = e_(low i) + sigma e_(high j),  sigma in {+1,-1}.
```

## Suggested theorem targets

- Define all 42 assessor supports.
- Define all 84 signed assessor vectors.
- Define multiplication of sparse signed two-term vectors using the sign table
  from S2, or locally duplicate the finite sign function if needed.
- Prove/count:

```text
number of ordered signed zero-product pairs = 336
number of distinct four-point supports from those zero products = 42
```

- Prove every zero-product support is a mixed affine 2-plane in `F_2^4` and
  avoids coordinates 0 and 8.
- Prove every zero-product support satisfies the same-strut condition.
- Optional: prove the 42 supports are a subset of the 63 same-strut mixed
  affine supports.

## Constraints

- No trusted code changes.
- No axioms, opaque constants, unsafe code, or admits.
- If complete structural proofs are too large, return compiled finite
  definitions plus the strongest cardinality/classification lemmas possible.
