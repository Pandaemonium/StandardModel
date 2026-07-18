# Proper Lorentz exponential target

Run this narrow command first:

```text
lake env lean ProperLorentzExponential/Target.lean
```

Fill the two proof holes in `ProperLorentzExponential/Target.lean` without
changing any definitions, theorem statements, the mostly-minus metric, or the
determinant `+1` conclusion. Small helper lemmas are welcome. Do not replace a
proof with a new assumption or weaken properness to determinant squared equal
to one.

The first target should follow from the Lie-algebra equation, `eta_sq`, matrix
exponential transpose/conjugation identities, and `Matrix.exp_neg`. The second
target is deliberately ambitious: Mathlib currently notes that the general
identity `det(exp A)=exp(trace A)` is missing. Viable alternatives include
proving the needed four-dimensional special case or using the continuous path
`s -> exp(s • generator)`: eta-Lorentz covariance forces determinant squared
to one, while continuity and the value at zero should select the `+1`
component.

If the determinant theorem cannot be completed, return the complete
eta-Lorentz proof, the exact remaining Lean goal, all useful helper lemmas, and
a precise assessment of the missing Mathlib API. Do not silently alter the
target.

Project conventions:

- metric signature: `(+---)`;
- basis order: `(0,1,2,3)`;
- `IsEtaLorentz M` means `M^T eta M = eta`;
- `IsLorentzLieAlgebra X` means `X^T eta + eta X = 0`;
- properness means determinant exactly `+1`.

The semantic context pack included with the submission is
`null-edge-proper-lorentz-exponential-20260717-20260717-221202.md`.
