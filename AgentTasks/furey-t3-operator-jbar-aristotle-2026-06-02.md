# Aristotle task: Furey T₃ weak-isospin operator on the Jbar sector

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `390253ed-2e9e-4114-8e05-570378146f00`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave5-20260602`
**Output**: `AgentTasks/aristotle-output/furey-t3-operator-jbar-20260602`
**Type**: Electroweak bridge — T₃ operator completing the weak isospin picture

## Goal

Create a new trusted file:

```text
PhysicsSM/Algebra/Furey/T3OpJbar.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.QopJbarEigenBridge
import PhysicsSM.Algebra.Furey.HyperchargeBridge
import PhysicsSM.Algebra.Furey.AnomalyBridge
```

and namespace:

```lean
namespace PhysicsSM.Algebra.Furey.T3OpJbar
```

## Mathematical context

The `HyperchargeBridge.lean` file records the full Standard Model electroweak
table for the Jbar sector (8 fermion states), including explicit `T₃` and `Y`
values for every basis state. The `QopJbarEigenBridge.lean` proves that
`Q_op` has the correct eigenvalues on those states.

The remaining gap: formalize `T₃` as an actual linear operator on the
`JbarWavefunction` space and prove it has the correct eigenvalues from the
table in `HyperchargeBridge.lean`.

## Existing infrastructure

From `HyperchargeBridge.lean`:

```lean
-- The T₃ table (already trusted):
-- JbarState 0 (neutrino)  : T₃ = +1/2
-- JbarState 1-3 (d quarks): T₃ = -1/2
-- JbarState 4-6 (u quarks): T₃ = +1/2
-- JbarState 7 (electron)  : T₃ = -1/2
def rawT3 : JbarState → ℚ

-- The Gell-Mann-Nishijima relation is already proved for every entry.
```

From `OperatorElectroweakIdentity.lean`:

```lean
-- Already proved:
theorem physicalQEnd_eq_targetT3End_add_half_targetYEnd :
    physicalQEnd = targetT3End + (1/2 : ℂ) • targetYEnd

-- Types available:
abbrev JbarWavefunction := ElectroweakBridge.JbarState → ℂ
noncomputable def diagonalEnd (f : JbarState → ℂ) : JbarWavefunction →L[ℂ] JbarWavefunction
noncomputable def physicalQEnd : JbarWavefunction →L[ℂ] JbarWavefunction
noncomputable def targetT3End : JbarWavefunction →L[ℂ] JbarWavefunction
noncomputable def targetYEnd  : JbarWavefunction →L[ℂ] JbarWavefunction
```

From `QopJbarEigenBridge.lean`:

```lean
-- Already proved:
theorem Q_op_eigenvalue_matches_electroweak_raw_table
    (s : JbarState) :
    Q_op (JbarBasisState s) = rawQopComplex s • JbarBasisState s
```

## Target declarations

### T₃ operator definition

```lean
/-- The T₃ weak-isospin operator on `JbarWavefunction`, as the diagonal
    continuous-linear endomorphism whose eigenvalue on `JbarBasisState s`
    is `rawT3 s`. -/
noncomputable def T3End :
    JbarWavefunction →L[ℂ] JbarWavefunction :=
  diagonalEnd (fun s => (rawT3 s : ℂ))
```

### Eigenvalue theorem

```lean
/-- T₃ acts on `JbarBasisState s` with eigenvalue `rawT3 s`. -/
theorem T3End_eigenvalue (s : JbarState) :
    T3End (JbarBasisState s) = (rawT3 s : ℚ) • JbarBasisState s
```

### Gell-Mann–Nishijima relation at operator level

```lean
/-- The operator-level GMN relation: `Q_op = T3End + (1/2) • YEnd`. -/
theorem T3End_add_half_YEnd_eq_QEnd :
    T3End + (1/2 : ℂ) • targetYEnd = physicalQEnd
```

This should follow directly from the existing
`physicalQEnd_eq_targetT3End_add_half_targetYEnd` by checking that
`T3End = targetT3End`. Prove:

```lean
theorem T3End_eq_targetT3End : T3End = targetT3End
```

### Weak isospin doublet structure

Prove that the neutrino and electron form an SU(2)_L doublet in the sense
that they share the same hypercharge but opposite T₃:

```lean
/-- The neutrino state (index 0) has T₃ = +1/2. -/
theorem T3End_neutrino :
    T3End (JbarBasisState ⟨0, by norm_num⟩) =
      (1/2 : ℂ) • JbarBasisState ⟨0, by norm_num⟩

/-- The electron state (index 7) has T₃ = -1/2. -/
theorem T3End_electron :
    T3End (JbarBasisState ⟨7, by norm_num⟩) =
      (-1/2 : ℂ) • JbarBasisState ⟨7, by norm_num⟩

/-- The up-quark states (indices 4-6) have T₃ = +1/2. -/
theorem T3End_uQuark (k : Fin 3) :
    T3End (JbarBasisState ⟨4 + k.val, by omega⟩) =
      (1/2 : ℂ) • JbarBasisState ⟨4 + k.val, by omega⟩

/-- The down-quark states (indices 1-3) have T₃ = -1/2. -/
theorem T3End_dQuark (k : Fin 3) :
    T3End (JbarBasisState ⟨1 + k.val, by omega⟩) =
      (-1/2 : ℂ) • JbarBasisState ⟨1 + k.val, by omega⟩
```

### Package

```lean
structure T3OpJbarPackage where
  /-- T₃ is the diagonal operator with eigenvalues from the charge table. -/
  T3_def : T3End = targetT3End
  /-- T₃ eigenvalue on each Jbar basis state. -/
  T3_eigenvalue : ∀ s : JbarState,
      T3End (JbarBasisState s) = (rawT3 s : ℚ) • JbarBasisState s
  /-- The operator-level Gell-Mann–Nishijima relation. -/
  gmn_operator : T3End + (1/2 : ℂ) • targetYEnd = physicalQEnd

noncomputable def t3OpJbarPackage : T3OpJbarPackage
```

## Claim boundary

This file formalizes the weak isospin T₃ operator for the Jbar sector. It
does **not** derive T₃ from the octonionic ladder algebra — the table values
are taken from the Standard Model literature. A future derivation from the
division-algebra structure would be a separate result.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Add to `PhysicsSM.lean` if sorry-free.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Furey/T3OpJbar.lean
lake build PhysicsSM.Algebra.Furey.T3OpJbar
```
