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
- `minorDet_one`
- `lambdaAction_one`
- `minorDet_card_ne`
- `lambdaAction_eq_sum_filter_card`
- `lambdaAction_preserves_card_support`
- `lambdaAction_add`
- `lambdaAction_smul`
- `lambdaLinearMap`
- `lambdaLinearMap_apply`
- `lambdaLinearMap_one`

The file is imported from the Gate I1 aggregator and footprint-guards the
checked structural theorems.

## Claim Boundary

This is structural exterior-functor data plus the identity action.  It proves
the coefficient formulae, conjugation/factorization identities, identity
minors, and `lambdaAction 1 = id` needed by the Q11 route.

It does not prove:

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

- `ne-next-q11-cauchybinet-lambdaaction-functoriality-proof-20260707`

Target:

1. Prove the finite Cauchy-Binet theorem needed for `minorDet_mul`.
2. Prove `lambdaAction (g * h) = fun f => lambdaAction g (lambdaAction h f)`.
3. Prepare the later `gl_fiber` Jacobi complementary-minor package.

Only after that lands should a separate `gl_fiber` job attack Jacobi
complementary minors and the determinant-cocycle/RC0 theorem.

## Verification So Far

- `lake env lean PhysicsSM/Draft/NullEdge/GateI1/Q11GroupAction.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction`
- `lake env lean PhysicsSM/Draft/NullEdge/GateI1.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateI1`

## Local Follow-Up

After the initial harvest, Codex locally proved the identity-matrix minor and
action theorems, plus the cardinality-support lemmas that shrink the next
Cauchy-Binet target:

- `minorDet_one`
- `lambdaAction_one`
- `minorDet_card_ne`
- `lambdaAction_eq_sum_filter_card`
- `lambdaAction_preserves_card_support`

This closes the identity-action part of the Q11 blocker.  The remaining
algebraic blocker is finite Cauchy-Binet/functoriality for `lambdaAction`;
`gl_fiber`, Jacobi complementary minors, determinant cocycle, and group-level
RC0 remain separate.

Codex also packaged the coefficient formula as the linear endomorphism
`lambdaLinearMap` and proved `lambdaLinearMap_one`.  The intended
functoriality statement should now be phrased as
`lambdaLinearMap (g * h) = (lambdaLinearMap g).comp (lambdaLinearMap h)`, with
Cauchy-Binet supplying the coefficient proof.

Verification:

- `lake env lean PhysicsSM/Draft/NullEdge/GateI1/Q11GroupAction.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction`
- `lake env lean PhysicsSM/Draft/NullEdge/GateI1.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateI1`
