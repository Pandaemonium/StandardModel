# Aristotle S5: cocycle and quadratic-phase extraction

Create a draft Lean module:

```text
PhysicsSM/Draft/Sedenions/CocycleQuadraticPhase.lean
```

## Goal

Start formalizing the signed layer:

```text
The Cayley-Dickson sign function omega(a,b) restricted to zero-product
affine plaquettes gives the cancellation phases that the binary code forgets.
```

This is the first step toward a possible `Z_4`/quadratic refinement.

## Background

Albuquerque-Majid style twisted-group-algebra language suggests treating:

```text
e_a e_b = omega(a,b) e_(a+b)
```

as the primary object rather than treating the multiplication table as an
unstructured finite lookup.

## Suggested theorem targets

- Define `omega : Fin 16 -> Fin 16 -> Int` or `Bool`, using the recursive
  sign table from S2.
- For each signed zero-product relation from S3, extract the four support
  points and the two cancelling product terms.
- Define a normalized phase assignment on each four-point support.
- Prove for a representative plaquette that the phase assignment is linear or
  quadratic on the affine 2-plane.
- If feasible, prove the same for all 42 zero-product supports.
- If a uniform theorem is too hard, return a data structure that records the
  phase/quadratic certificate for each support, with the strongest checked
  examples possible.

## Constraints

- This is exploratory draft work.
- Do not claim a Kerdock/Barnes-Wall result unless it is actually formalized.
- No axioms, opaque constants, unsafe code, or admits.
- Document any open obstruction clearly.
