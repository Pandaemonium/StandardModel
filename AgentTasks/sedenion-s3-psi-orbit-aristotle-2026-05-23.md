# Aristotle S8: S3 psi action and sparse plaquette orbit test

Create a draft Lean module:

```text
PhysicsSM/Draft/Sedenions/S3PsiAction.lean
```

## Goal

Test the physics-facing S3 question at the level of finite linear algebra:

```text
Does the order-three Cayley-Dickson S3 automorphism preserve sparse
zero-divisor/stabilizer plaquettes, or does it move them into denser states?
```

The expected answer may be negative for sparse assessor supports.  A checked
negative result would be valuable.

## Suggested model

For each low/high pair `(e_i, e_(i+8))`, the naive order-three action is the
real rotation:

```text
psi(e_i)     = -1/2 e_i - sqrt(3)/2 e_(i+8)
psi(e_(i+8)) =  sqrt(3)/2 e_i - 1/2 e_(i+8)
```

This does not simply permute basis labels.  It should generally send a sparse
assessor vector into a denser vector supported on two vertical pairs.

If real `sqrt` coefficients are cumbersome, use a symbolic coefficient ring
with symbols `a` and `b`, together with relations needed for order three, or
prove support-spreading statements without normalizing the coefficients.

## Suggested theorem targets

- Define the action on basis supports.
- Prove `psi` has order three, if the coefficient model permits it.
- Prove the image of a representative assessor support is not another
  two-point assessor support.
- Prove the image of a representative four-point zero-product plaquette is not
  generally a four-point sparse plaquette.
- Optional: compute whether the image remains a stabilizer state in the Pauli
  model from S6.

## Constraints

- Do not claim the newer `Cl(8)` or `Cl(10)` embedded S3 action is the same as
  this naive Cayley-Dickson action.
- A counterexample is a successful result if it is precise and checked.
- No axioms, opaque constants, unsafe code, or admits.
