# Aristotle S7: GL(3,2) / PSL(2,7) action on supports and signs

Create a draft Lean module:

```text
PhysicsSM/Draft/Sedenions/GL32Action.lean
```

## Goal

Begin the finite group-action layer:

```text
GL(3,2) acts on the nonzero F_2^3 strut labels, hence on assessors and
mixed affine supports.  The interesting question is whether the signed
Cayley-Dickson cocycle is preserved exactly, up to gauge, or not at all.
```

## Suggested theorem targets

- Define `F_2^3` labels as `Fin 8` or bitvectors.
- Define invertible linear maps on `F_2^3`; prove/cardinality-check that there
  are 168 of them if feasible.
- Define the action on assessor pairs `(i,j)` with `i,j != 0`, `i != j`.
- Prove the action preserves the 42 assessor supports.
- Prove the action preserves the 63 same-strut mixed affine support family.
- Test whether it preserves the 42 signed zero-product support family.
- For signs, compute whether `omega(g a, g b)` agrees with `omega(a,b)`
  exactly, or whether there is a gauge function `eta_g(a)` such that:

```text
omega(g a, g b) = eta_g(a) eta_g(b) eta_g(a+b) omega(a,b)
```

at least on the zero-product plaquette complex.

## Constraints

- The signed preservation question may be false.  If so, return a concrete
  counterexample with a checked theorem.
- No axioms, opaque constants, unsafe code, or admits.
