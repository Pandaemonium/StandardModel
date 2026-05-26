# Aristotle S4: Reed-Muller code equality and weight enumerator

Create a draft Lean module:

```text
PhysicsSM/Draft/Sedenions/ReedMullerCode.lean
```

## Goal

Formalize the finite code theorem suggested by the oracle script:

```text
C_ZD = span of the 42 signed zero-product support indicators
     = {c in RM(2,4) : c_0 = 0 and c_8 = 0}.
```

Expected invariants:

```text
dim C_ZD = 9
|C_ZD| = 512
W_CZD(y) = 1 + 77 y^4 + 168 y^6 + 203 y^8 + 56 y^10 + 7 y^12
```

The broader 63 same-strut mixed affine supports should span the same code:

```text
span(42 zero-product supports) = span(63 same-strut supports).
```

## Suggested definitions

- Represent a length-16 binary word as `Fin 16 -> ZMod 2`, or as a finite
  vector over `ZMod 2`.
- Define degree `<= 2` Boolean polynomial evaluations on `F_2^4`.
- Define `RM24`.
- Define the shortened subcode:

```text
ShortRM24 = {c in RM24 | c 0 = 0 and c 8 = 0}
```

- Import or locally duplicate the 42 support list from S3 if needed.

## Suggested theorem targets

- `cZD_card = 512`
- `cZD_rank = 9` or an equivalent basis/cardinality theorem.
- `cZD_eq_shortenedRM24`
- `cZD_weightEnumerator`
- `sameStrutSpan_eq_cZD`

## Constraints

- Keep this finite and combinatorial.
- Native finite evaluation is acceptable in draft if isolated and documented,
  but try to expose a small basis or row-reduction certificate rather than a
  monolithic proof.
- No axioms, opaque constants, unsafe code, or admits.
