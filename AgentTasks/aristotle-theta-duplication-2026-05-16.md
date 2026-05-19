# Aristotle task: Jacobi theta duplication identities for Theta2 and Theta4

Status: completed and integrated 2026-05-16
Lean toolchain: v4.28.0
Project: c:/Projects/StandardModel

## Goal

Prove the two classical theta-constant duplication (Landen transformation) identities
inside `PhysicsSM/Draft/E8ThetaDuplicationAristotle.lean`, using Sphere-Packing-Lean's
theta-function definitions for Θ₂, Θ₃, Θ₄.

The two identities are:

```lean
theorem theta2_sq_duplication (tau : UpperHalfPlane) :
    (Θ₂ tau) ^ 2 = (2 : Complex) * Θ₂ (twoTau tau) * Θ₃ (twoTau tau)

theorem theta4_sq_duplication (tau : UpperHalfPlane) :
    (Θ₄ tau) ^ 2 = (Θ₃ (twoTau tau)) ^ 2 - (Θ₂ (twoTau tau)) ^ 2
```

## Why these matter

Once proved, `hammingThetaConstantPolynomial_eq_thetaE4_from_duplication` in the
same file (already proved conditionally) gives the function equality
`hammingThetaConstantPolynomial = thetaE4`, which together with
`hammingThetaConstantPolynomial_qExpansion_coeff_of_duplication_and_repr`
in `E8ThetaQExpansionBridgeAristotle.lean` closes the main theta bridge theorem.

## Key file to read first

`PhysicsSM/Draft/E8ThetaDuplicationAristotle.lean` — the target theorems are at the
bottom with `sorry` placeholders. The file already imports all needed context via
`PhysicsSM.Draft.E8ThetaWeightEnumeratorBridgeAristotle`.

## SPL facts to search

SPL (`SpherePacking.ModularForms`) should have:
- `Θ₂_as_jacobiTheta₂`, `Θ₃_as_jacobiTheta₂`, `Θ₄_as_jacobiTheta₂`
- `jacobiTheta₂_functional_equation`
- `H₂`, `H₃`, `H₄` and their S/T modular transformation actions
- `jacobi_identity` (the quartic identity θ₂⁴ + θ₄⁴ = θ₃⁴)
- `twoTau` definition (doubling the argument)

## Mathematical routes

Route A (series expansion): Both theta functions can be expressed as series using
`jacobiTheta₂`. Write each side as a series sum and manipulate.

Route B (product formula): Use the infinite product representation and the duplication
formula for sine functions.

Route C (modular action): Express via the S and T transformations. The identity
`θ₂(τ)² = 2θ₂(2τ)θ₃(2τ)` is equivalent to a modular transformation statement.

Route D (SPL combination): If SPL proves `E₄ = thetaE4` and also has `H₂ = Θ₂^4`,
there may be coefficient extraction routes.

## Constraints

- Do not introduce new axioms, `opaque`, or `unsafe`.
- If the full identity is out of reach, a useful partial result is either identity
  proved on the imaginary axis `τ = it` for `t > 0`, or a precise restatement in
  terms of `jacobiTheta₂` series.
- Helper lemmas may be added to the same file.
- Do not weaken the statements.

## Result and integration

Aristotle job:

```text
58dd34f0-c61e-401b-8e76-0296e03996b4 COMPLETE
```

Downloaded archive:

```text
AgentTasks/aristotle-output/hamming-e8-theta-duplication-20260516
```

Extracted archive:

```text
AgentTasks/aristotle-output/hamming-e8-theta-duplication-20260516-extracted
```

Integrated files:

```text
PhysicsSM/Draft/ThetaDuplicationProof.lean
PhysicsSM/Draft/E8ThetaDuplicationAristotle.lean
```

The integration adds a Mathlib-only helper proof file and replaces both
duplication `sorry`s in `E8ThetaDuplicationAristotle.lean` with kernel-checked
proofs. The downstream theorem
`hammingThetaConstantPolynomial_eq_thetaE4_from_duplication` is now also
sorry-free.

Local verification:

```text
lake env lean PhysicsSM/Draft/ThetaDuplicationProof.lean
lake build PhysicsSM.Draft.E8ThetaDuplicationAristotle
```

Both commands completed successfully. Existing unrelated draft warnings remain
in imported files for the coefficient and SPL bridge gaps.
