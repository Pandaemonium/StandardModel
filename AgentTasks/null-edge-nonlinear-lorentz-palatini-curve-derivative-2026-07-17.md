# Nonlinear Lorentz Palatini curve derivative

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-007`
Status: completed locally

## Result

`PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCurveDerivative.lean`
turns the exact product/inverse response into an ordinary derivative theorem.
For any curve of invertible link matrices based at a supplied connection, if
each underlying matrix has tangent `U * hat(delta A)` at zero, then the
plaquette derivative is exactly `plaquetteMatrixVariation` and the derivative
of the full concrete coframe action is exactly
`nonlinearCoframePlaquetteFirstResponse`.

The module also constructs the canonical linkwise curve
`U exp(t hat(delta A))`. Matrix-exponential invertibility makes this a global
`GL4` curve, and Mathlib's exponential derivative proves it realizes every
six-component variation. Formal connection stationarity is therefore
equivalent to ordinary derivative stationarity along all canonical curves.
The successor `ProperLorentzExponential.lean` proves that the exponential
factor is eta-Lorentz with determinant `+1`; consequently, a pointwise proper
eta-Lorentz base connection remains in that subgroup along the full curve.

`NonlinearLorentzPalatiniEuler` composes this with the local reorganization:
derivative stationarity is equivalent to vanishing of all six explicit local
nonidentity Euler coefficients.

## Trust and scope

All headline theorems have build-enforced standard-three axiom guards. There
are no proof placeholders or native evaluator shortcuts in the live module.
The scoped Frobenius norm supplies finite-dimensional matrix calculus only; it
does not change any algebraic formula. Metric dual-cell weighting,
the separate orthochronous sign, and Levi-Civita selection remain separate
gates.

## Verification

```text
lake env lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCurveDerivative.lean
lake env lean PhysicsSM/Draft/NullEdge/ProperLorentzExponential.lean
lake env lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEuler.lean
lake build PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative PhysicsSM.Draft.NullEdge.GRFoundations
```
