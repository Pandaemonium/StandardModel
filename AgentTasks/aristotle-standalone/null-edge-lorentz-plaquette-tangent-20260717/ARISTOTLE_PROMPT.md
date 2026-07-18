# Aristotle target: exact Lorentz plaquette tangent

Run this narrow command first:

```text
lake env lean LorentzPlaquetteTangent/Target.lean
```

Fill the four proof holes in `LorentzPlaquetteTangent/Target.lean` without
changing any theorem statement, definition, matrix ordering, multiplication
order, or sign:

1. `rightTrivializedPlaquetteVariation_eq_adjointSum`;
2. `lorentzAdjoint_mem`;
3. `rightTrivializedPlaquetteVariation_mem`;
4. `rightTrivializedPlaquetteVariation_identity`.

The six-component ordering is `(12,13,23,01,02,03)`, the spacetime metric is
`diag(+1,-1,-1,-1)`, link variations are right-trivialized as
`delta U = U hat(X)`, and plaquette holonomy is `A B^{-1}` for the `a,b` and
`b,a` two-link paths. The right logarithmic tangent is `delta H H^{-1}`.

You may add small helper lemmas. Preserve the use of actual matrix units and
the exact product/inverse rule. Do not replace the nonlinear target with its
identity-link linearization. If a displayed adjoint factor or sign is false,
report the counterexample and exact corrected formula instead of changing the
statement silently.

Finish with a short report listing solved targets, statement changes (expected:
none), remaining proof holes, and any assumptions used.
