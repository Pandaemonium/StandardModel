# Aristotle S1: Fano orientations and Hamming flip checks

Create a draft Lean module:

```text
PhysicsSM/Draft/Sedenions/FanoHammingOrientation.lean
```

## Goal

Formalize the finite theorem behind the orientation note:

```text
XOR gives the seven unoriented Fano lines.
A recursive Cayley-Dickson octonion orientation is changed by basis sign
changes exactly along [7,4,3] Hamming codeword flip patterns.
```

Use the reference triples from `Sedenions/CayleyDickson_Convention.md`:

```text
L1 = (001,010,011)
L2 = (001,100,101)
L3 = (001,111,110)
L4 = (010,100,110)
L5 = (010,101,111)
L6 = (011,100,111)
L7 = (011,110,101)
```

For flip bits `b1,...,b7`, prove the Hamming parity checks:

```text
b4 + b5 + b6 + b7 = 0
b2 + b3 + b6 + b7 = 0
b1 + b3 + b5 + b7 = 0
```

over `ZMod 2` or `Bool`/xor.

## Suggested theorem targets

- Define the seven lines and the reference orientation.
- Define the flip pattern induced by a sign assignment
  `eps : Fin 7 -> ZMod 2`, where a line flips by the xor/sum of its three
  endpoint signs.
- Prove every induced flip pattern satisfies the three parity checks.
- Prove every vector satisfying the three parity checks is induced by some
  sign assignment.
- Prove the set of legal flip patterns has cardinality 16.
- Optional: prove the free-coordinate formulas

```text
b5 = b2 + b3 + b4
b6 = b1 + b3 + b4
b7 = b1 + b2 + b4
```

## Constraints

- Keep this convention separate from `PhysicsSM.Algebra.Octonion.Basic`.
- Do not use axioms, opaque constants, unsafe code, or admits.
- If the full iff is hard, return a compiled draft with the forward theorem
  and a clear handoff note for the converse.
