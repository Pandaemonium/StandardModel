# Aristotle C106a: origin-polarization escape hatch

Date: 2026-06-27
Gate: C1
Dependency class: Independent
Submission style: focused standalone Mathlib package

## Project context

Gate C1 is open. The bare retarded null-edge symbol `D_+` has a
chirality-balanced origin kernel and chirality-balanced nonzero null-branch
kernels. Scalar Wilson lifting supports Gate C0 species health, but cannot
select one Weyl line at the balanced origin.

The current C1 reframing is:

```text
C1 first needs a native, gauge-safe origin polarizer, or a no-go theorem proving
that the native origin algebra cannot contain one.
```

Let:

```text
K0 = ker D_+(0)
Gamma0 = origin chirality on K0
J = balance symmetry with J Gamma0 J^-1 = -Gamma0
P0 = candidate physical origin projector/selector
```

If `P0` commutes with `J`, then its chiral index should vanish:

```text
Tr(Gamma0 P0) = 0.
```

Therefore a C1 origin projector with nonzero target index must escape the
balance commutant.

## Context pack

Generated before submission:

```text
AgentTasks/context-packs/gate-c1-origin-polarization-c106a-20260627-143822.md
```

## Target file

```text
AgentTasks/aristotle-standalone/c106a-origin-polarization-20260627/C106aOriginPolarization/OriginPolarizationEscapeHatch.lean
```

## What to prove

Please repair and prove the standalone Lean file without weakening the intended
mathematical statement.

Primary theorem:

```lean
theorem balance_commutant_zero_chiralIndex
    (Gamma0 J P0 : Matrix n n Complex)
    (hJ2 : J * J = 1)
    (hflip : J * Gamma0 * J = -Gamma0)
    (hcomm : P0 * J = J * P0) :
    ChiralIndex Gamma0 P0 = 0
```

Corollary:

```lean
theorem nonzero_index_requires_balance_escape
    (Gamma0 J P0 : Matrix n n Complex)
    (targetIndex : Complex)
    (hJ2 : J * J = 1)
    (hflip : J * Gamma0 * J = -Gamma0)
    (hindex : ChiralIndex Gamma0 P0 = targetIndex)
    (htarget : targetIndex != 0) :
    P0 * J != J * P0
```

You may adjust the theorem statement only if required by Lean's matrix trace API
or if the current statement is mathematically too weak/strong. If you adjust it,
explain the reason and preserve the intended content:

```text
commuting with a chirality-flipping balance involution forces zero chiral index.
```

## Proof sketch

Use cyclicity of matrix trace:

```text
Tr(Gamma0 P0)
= Tr(J Gamma0 P0 J)
= Tr((J Gamma0 J) (J P0 J))
= Tr((-Gamma0) P0)
= -Tr(Gamma0 P0).
```

Because the scalar field is `Complex`, `x = -x` implies `x = 0`.

## Deliverables

Return:

```text
1. The completed Lean file.
2. A short report stating whether either theorem statement was changed.
3. Any helper lemmas added.
4. Any remaining proof holes or imports required.
5. Whether the final check command passed:
   lake env lean C106aOriginPolarization/OriginPolarizationEscapeHatch.lean
```

## Claim boundary

This does not solve C1. It only proves the finite origin obstruction:

```text
Any native C1 origin selector with nonzero chiral index must escape the balance
commutant.
```

The next project-level theorem would be C106b:

```text
if every native gauge-safe origin endomorphism commutes with J, no native
finite/local C1 release exists under those assumptions.
```
