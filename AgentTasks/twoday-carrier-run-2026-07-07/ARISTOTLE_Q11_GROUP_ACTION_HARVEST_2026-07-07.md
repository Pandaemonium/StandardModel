# Aristotle Q11 Group-Action Harvest - 2026-07-07

Source project:

- `aa4e48f6-2581-4276-a5ae-db77c7660cd6`
- `ne-q11-jacobi-minor-cauchybinet-rc0-proof-20260707`

## Integrated Payload

Integrated a kernel-clean structural subset as:

- `PhysicsSM/Draft/NullEdge/GateI1/Q11GroupAction.lean`

New declarations:

- `Form`
- `minorDet`
- `lambdaAction`
- `Kmap`
- `Cmap`
- `JR_eq_Cmap_Kmap`
- `Kmap_involutive`
- `Cmap_involutive`
- `Kmap_Cmap_comm`
- `minorDet_conj`
- `lambdaAction_conj`
- `minorDet_empty`

The file is imported from the Gate I1 aggregator and footprint-guards the
checked structural theorems.

## Claim Boundary

This is structural exterior-functor data only.  It proves the coefficient
formulae and conjugation/factorization identities needed by the Q11 route.

It does not prove:

- identity action for `lambdaAction`;
- finite Cauchy-Binet / functoriality for `lambdaAction`;
- minor orthogonality for `g * g^-1`;
- Jacobi complementary-minor identity;
- determinant cocycle;
- group-level RC0/unimodularity equivalence.

The returned Aristotle payload is still useful, but the larger Cauchy-Binet
chain was not imported because it did not check cleanly in the live repo
without broadening the trust footprint.  The later Jacobi tail also still needs
the `gl_fiber` interleaving-sign factorization.

## Next Proof Job

Best next name:

- `ne-next-q11-identityminor-cauchybinet-lambdaaction-proof-20260707`

Target:

1. Prove the identity-minor Kronecker theorem for `minorDet`.
2. Prove the finite Cauchy-Binet theorem needed for `minorDet_mul`.
3. Prove `lambdaAction (g * h) = fun f => lambdaAction g (lambdaAction h f)`.

Only after that lands should a separate `gl_fiber` job attack Jacobi
complementary minors and the determinant-cocycle/RC0 theorem.

## Verification So Far

- `lake env lean PhysicsSM/Draft/NullEdge/GateI1/Q11GroupAction.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction`
- `lake env lean PhysicsSM/Draft/NullEdge/GateI1.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateI1`
