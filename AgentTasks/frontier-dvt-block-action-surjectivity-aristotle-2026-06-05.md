# Aristotle task: DVT quotient to block-action stabilizer bridge

Date: 2026-06-05

## Goal

Build a supporting bridge between the two-sided SU(3) quotient action and the
existing `DVTBlockAction` monoid. This is intended as a stepping stone toward
the full DVT stabilizer characterization.

Primary target file:

```text
PhysicsSM/Algebra/Jordan/DVTQuotientBlockActionBridge.lean
```

Useful existing files:

```text
PhysicsSM/Algebra/Jordan/DVTAction.lean
PhysicsSM/Algebra/Jordan/DVTBlockActionMonoid.lean
PhysicsSM/Algebra/Jordan/DVTTwoSidedSU3QuotientStabilizer.lean
PhysicsSM/Algebra/Jordan/DVTTwoSidedStabilizerMoonshot.lean
PhysicsSM/Algebra/Jordan/DVTTwoSidedImageEquiv.lean
```

## Preferred theorem shape

Define a block-action object induced by a pair in `DVTTwoSidedSU3Pair`, using
the identity action on the `h3(C)` part and the existing two-sided action on
the complement part:

```lean
noncomputable def dvtTwoSidedPairBlockAction
    (p : DVTTwoSidedSU3Pair) : DVTBlockAction := ...
```

Then prove:

```lean
theorem dvtTwoSidedPairBlockAction_actC
    (p : DVTTwoSidedSU3Pair) :
    (dvtTwoSidedPairBlockAction p).actC =
      dvtTwoSidedSU3ActionHom p := ...

noncomputable def dvtTwoSidedPairBlockActionHom :
    DVTTwoSidedSU3Pair ->* DVTBlockAction := ...

theorem dvtTwoSidedPairBlockAction_ker_z3
    ...
```

If feasible, descend this to the quotient:

```lean
noncomputable def dvtQuotientBlockActionHom :
    DVTTwoSidedSU3Quotient ->* DVTBlockAction := ...

theorem dvtQuotientBlockActionHom_injective :
    Function.Injective dvtQuotientBlockActionHom := ...
```

Bundle the result:

```lean
structure DVTQuotientBlockActionBridgePackage where
  quotientToBlockAction : DVTTwoSidedSU3Quotient ->* DVTBlockAction
  quotientToBlockAction_injective : Function.Injective quotientToBlockAction
  actC_agrees :
    forall q, ...
```

## Mathematical intent

The current DVT quotient theorem lands in `AddAut H3OComplement`. A full DVT
stabilizer theorem should ultimately talk about transformations of the
`h3(C) + complement` splitting, not only the complement. This bridge packages
the complement action as a block action on `h3(O)`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change `DVTBlockAction` or the existing quotient/action definitions
  unless a tiny helper lemma is genuinely needed.
- Keep the `h3(C)` action conservative; identity on the standard part is fine
  for this bridge unless the existing API supports a stronger DVT action.

## Verification

Run:

```bash
lake build PhysicsSM.Algebra.Jordan.DVTQuotientBlockActionBridge
```

## Submission

Status: integrated.

Submission project:

```text
AgentTasks/aristotle-submit/frontier-20260605
```

Job ID:

```text
1f1b957f-3d50-4e64-aea6-51c18e87d547
```

## Integration

Integrated on 2026-06-09.

Result status: `COMPLETE`.

Output bundle:

```text
AgentTasks/aristotle-output/1f1b957f-extracted/frontier-20260605_aristotle
```

Integrated Lean file:

```text
PhysicsSM/Algebra/Jordan/DVTQuotientBlockActionBridge.lean
```

Publication hooks added to:

```text
PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean
PhysicsSM/Publication/FureyBaezDVTMainTheorem.lean
PhysicsSM/Publication/FureyBaezDVTExactSynthesis.lean
```
