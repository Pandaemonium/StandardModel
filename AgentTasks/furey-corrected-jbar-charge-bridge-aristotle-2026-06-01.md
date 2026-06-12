# Aristotle task: corrected Furey Jbar charge bridge

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Paper-critical
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `3e904bd7-caf0-4ad2-85ab-4a30f18a517b`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave9-20260601-project`
**Output**:
**Integrated**:
**Type**: Furey corrected minimal-left-ideal charge theorem

## Goal

Build the corrected `Jbar` charge bridge using the primed basis states from
`PhysicsSM.Algebra.Furey.JbarLinearIndependence`.

The earlier unprimed `vbar1`, ..., `vbar6`, `nu_bar` definitions are zero
because they use annihilation operators on the empty vacuum. The corrected
states use creation operators `alpha*_dag` on `omega_bar`. This task should
prove the `Q_op` eigenvalue table for those corrected states and package it
for the formalization paper.

## Requested file

Create:

```text
PhysicsSM/Algebra/Furey/CorrectedJbarChargeBridge.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.JbarLinearIndependence
import PhysicsSM.Algebra.Furey.QopJbarEigenBridge
import PhysicsSM.Algebra.Furey.ElectroweakBridge
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.CorrectedJbarChargeBridge
```

Do not edit `PhysicsSM.lean`; Codex will add imports during integration.

## Target declarations

Define a corrected raw charge table aligned with the primed basis:

```lean
noncomputable def correctedJbarBasisState :
    PhysicsSM.Algebra.Furey.ElectroweakBridge.JbarState ->
      PhysicsSM.Algebra.Octonion.ComplexOctonion := ...

def correctedRawQop (s : JbarState) : Rat := ...

noncomputable def correctedRawQopComplex (s : JbarState) : Complex :=
  Rat.cast (correctedRawQop s)
```

The table should be:

```text
omega_bar      -> 0
vbar1'..vbar3' -> -1/3
vbar4'..vbar6' -> -2/3
nu_bar'        -> -1
```

Prove:

```lean
theorem correctedJbar_Q_op_eigenvalue
    (s : JbarState) :
    Q_op (correctedJbarBasisState s) =
      correctedRawQopComplex s • correctedJbarBasisState s := ...
```

Also add discoverable point lemmas if helpful:

```lean
theorem Q_op_vbar1_prime : Q_op vbar1' = (-1 / 3 : Complex) • vbar1' := ...
...
theorem Q_op_nu_bar_prime : Q_op nu_bar' = (-1 : Complex) • nu_bar' := ...
```

## Package

Add:

```lean
structure FureyCorrectedJbarChargePackage where
  linear_independent :
    LinearIndependent Complex JbarBasisState'
  qop_eigenvalue :
    forall s : JbarState,
      Q_op (correctedJbarBasisState s) =
        correctedRawQopComplex s • correctedJbarBasisState s
  nonzero :
    forall s : JbarState, correctedJbarBasisState s != 0

noncomputable def fureyCorrectedJbarChargePackage :
    FureyCorrectedJbarChargePackage := ...
```

Use Lean's `ne`/`!=` notation as appropriate; avoid changing existing
definitions.

## Suggested proof strategy

Most point lemmas should be direct coordinate proofs by unfolding:

```lean
unfold Q_op Ntot_op N1_op N2_op N3_op
unfold vbar1' alpha1_dag omega_bar
ext <;> simp [ComplexOctonion.ext_iff, Octonion.ext_iff] <;> ring
```

If a direct proof is too slow, prove reusable number-operator eigenvalue lemmas
for each corrected state first.

## Claim boundary

This proves a corrected charge table for explicit Furey states. It does not
derive weak isospin from the algebra, prove a full Standard Model
representation theorem, or resolve the physical interpretation of handedness.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted output.
- Do not edit existing Furey definitions.
- Do not edit `PhysicsSM.lean`.
- If a theorem seems false because of convention or sign issues, report it
  rather than weakening the statement.

## Verification

Run:

```bash
lake build PhysicsSM.Algebra.Furey.CorrectedJbarChargeBridge
```
