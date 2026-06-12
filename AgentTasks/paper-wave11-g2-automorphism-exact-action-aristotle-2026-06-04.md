# Aristotle task: exact G2 automorphism SU3 action theorem

Date: 2026-06-04

## Goal

Strengthen the Baez theorem island from a bundled equivalence to exact
homomorphism/range/kernel statements for the action of octonion automorphisms
fixing `e111` on the complementary `C^3`.

Primary target file:

```text
PhysicsSM/Algebra/Octonion/G2AutomorphismSU3Exactness.lean
```

Useful imports:

```text
PhysicsSM.Algebra.Octonion.G2AutomorphismSU3ActionPackage
PhysicsSM.Algebra.Octonion.G2AutomorphismStabilizerBridge
PhysicsSM.Algebra.Octonion.G2FixingE111GroupEquiv
PhysicsSM.Algebra.Octonion.G2FixingE111SU3Equiv
```

## Preferred theorem shape

Create a trusted package collecting exactness statements around
`octonionMulAutFixingE111MulEquivSU3`:

```lean
structure G2AutomorphismSU3ExactnessPackage where
  toSU3Hom : OctonionMulAutFixingE111 ->* su3Submonoid
  toSU3Hom_bijective : Function.Bijective toSU3Hom
  toSU3Hom_kernel_trivial :
    forall f : OctonionMulAutFixingE111,
      toSU3Hom f = 1 -> f = 1
  toSU3Hom_surjective :
    forall M : su3Submonoid,
      exists f : OctonionMulAutFixingE111, toSU3Hom f = M
  matrix_action_ext :
    forall f g : OctonionMulAutFixingE111,
      f.onComplexVecMatrix = g.onComplexVecMatrix -> f = g
```

Use the actual project names and Mathlib APIs. It is fine if `toSU3Hom` is
implemented directly from the existing `MulEquiv.toMonoidHom`.

## Stretch target

Prove inverse-action formulas:

```lean
(f^-1).onComplexVecMatrix = (f.onComplexVecMatrix)^-1
```

or an equivalent statement using the `su3Submonoid` coercion. If matrix inverse
notation is painful, state it as compatibility with `OctonionMulAutFixingE111`
group inverse under `toSU3Hom`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Preserve the project XOR/Fano octonion convention.
- Do not claim the topological Lie group `G2`; this is the project algebraic
  automorphism/fixing structure.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2AutomorphismSU3Exactness.lean
lake build PhysicsSM.Algebra.Octonion.G2AutomorphismSU3Exactness
```

## Submission

Status: integrated.

Submission project:

```text
AgentTasks/aristotle-submit/paper-wave11-20260604
```

Job ID:

```text
e5645cec-1999-4e2d-a159-bc7ab323153d
```

Integrated result:

```text
PhysicsSM/Algebra/Octonion/G2AutomorphismSU3Exactness.lean
```

Verification run after integration:

```bash
lake build PhysicsSM.Algebra.Octonion.G2AutomorphismSU3Exactness
```
