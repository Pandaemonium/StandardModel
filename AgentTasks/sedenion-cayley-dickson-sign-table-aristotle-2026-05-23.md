# Aristotle S2: recursive Cayley-Dickson sign table

Create a draft Lean module:

```text
PhysicsSM/Draft/Sedenions/CayleyDicksonSignTable.lean
```

## Goal

Formalize the finite recursive bit-sign convention used by the sedenion
research branch.

The convention is documented in:

```text
Sedenions/CayleyDickson_Convention.md
```

The Python reference is:

```text
Scripts/sedenions/explore_zero_divisor_geometry.py
```

## Mathematical content

Basis labels use four bits:

```text
abcd <-> i^d j^c ell^b m^a
```

Product indices obey:

```text
e_a * e_b = omega(a,b) e_(a xor b)
```

where the sign `omega(a,b)` is computed recursively by the Cayley-Dickson
pair rule:

```text
(a,b)(c,d) = (a c - conjugate(d) b, d a + b conjugate(c)).
```

## Suggested theorem targets

- Define a finite sign function for dimension `2^n`, at least for `n <= 4`.
- Prove for all `a b : Fin 16` that the product index is bitwise xor.
- Prove the seven reference octonion triples are positive in dimension 8:

```text
001 * 010 = +011
001 * 100 = +101
001 * 111 = +110
010 * 100 = +110
010 * 101 = +111
011 * 100 = +111
011 * 110 = +101
```

- Prove representative old/new rules in dimension 16, for octonion labels
  `q r : Fin 8`:

```text
q * (r m) has old part r*q and high bit set
(q m) * r has old part q*conj(r) and high bit set
(q m) * (r m) has old part -conj(r)*q and high bit unset
```

## Constraints

- This is a draft convention module, not a bridge to the existing octonion
  convention.
- Do not use axioms, opaque constants, unsafe code, or admits.
- Native finite evaluation is acceptable in draft if isolated and documented,
  but structural recursive lemmas are preferred.
