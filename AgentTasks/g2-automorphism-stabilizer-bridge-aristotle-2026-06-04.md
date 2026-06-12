# Aristotle task: bridge FixingE111MulLinear to actual octonion automorphisms

Date: 2026-06-04

## Goal

Upgrade the Baez-style `FixingE111MulLinear` scaffold toward the actual
stabilizer of `e111` inside octonion multiplicative linear automorphisms.

Target module:

```text
PhysicsSM/Algebra/Octonion/G2AutomorphismStabilizerBridge.lean
```

## Context

Relevant modules:

- `PhysicsSM.Algebra.Octonion.Basic`
- `PhysicsSM.Algebra.Octonion.G2ComplexLine`
- `PhysicsSM.Algebra.Octonion.G2HermitianPreservation`
- `PhysicsSM.Algebra.Octonion.G2FixingE111GroupEquiv`
- `PhysicsSM.Algebra.Octonion.G2FixingE111SU3Equiv`

Existing scaffold:

- `FixingE111MulLinear`
- `fixingE111MulLinear_actsAsSU3`
- `fixingE111MulLinearEquivSU3`

## Preferred outcome

Define a structure for octonion multiplicative linear equivalences fixing
`e111`, or reuse an existing one if present. Then prove a `MulEquiv` or at
least mutually inverse maps between this actual automorphism stabilizer and
`FixingE111MulLinear`.

Good names:

```lean
structure OctonionMulAutFixingE111 where ...

noncomputable def octonionMulAutFixingE111EquivFixingE111MulLinear :
    OctonionMulAutFixingE111 ~=* FixingE111MulLinear
```

Use the correct Lean equivalence type available in the surrounding code
(`Equiv`, `MulEquiv`, or a subtype equivalence).

## Fallback

If an automorphism structure is too expensive, prove one direction:

```lean
def OctonionMulAutFixingE111.toFixingE111MulLinear :
    OctonionMulAutFixingE111 -> FixingE111MulLinear
```

and prove it preserves composition and the induced `C^3` matrix action.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2AutomorphismStabilizerBridge.lean
```

## Submission

Status: submitted.

Submission project: `AgentTasks/aristotle-submit/paper-wave8-20260604`

Job ID: `8bf6d9d1-ac14-4f20-be27-ddb82fee4c9b`
