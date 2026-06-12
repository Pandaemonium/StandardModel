# Aristotle task: Furey SU(2)_L doublet coherence package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `b5a77ce2-7fe2-4ae4-aeef-d7311966d920`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave6-20260602`
**Output**: `AgentTasks/aristotle-output/furey-su2l-doublets-20260602`
**Type**: Furey electroweak completeness — SU(2)_L doublet structure

## Goal

Create a new trusted file:

```text
PhysicsSM/Algebra/Furey/WeakIsospinDoublets.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.T3OpJbar
import PhysicsSM.Algebra.Furey.HyperchargeBridge
```

and namespace:

```lean
namespace PhysicsSM.Algebra.Furey.WeakIsospinDoublets
```

## Mathematical context

Furey's construction produces a one-generation Standard Model sector (the Jbar
ideal) with 8 basis states. These states organize into **SU(2)_L doublets**:
pairs of states with the same hypercharge Y but opposite weak isospin T₃ = ±1/2,
related by the SU(2)_L raising/lowering action.

With `T3OpJbar` now formalized (T₃ eigenvalues for all 8 states), this file
proves the doublet structure explicitly: the four doublets are
`(ν, e)`, `(u_r, d_r)`, `(u_g, d_g)`, `(u_b, d_b)`.

## Existing infrastructure

From `T3OpJbar.lean`:
```lean
-- T₃ eigenvalues: index 0 (ν) = +1/2, index 7 (e) = -1/2
-- indices 4,5,6 (u quarks) = +1/2, indices 1,2,3 (d quarks) = -1/2
theorem T3End_neutrino, T3End_electron, T3End_uQuark, T3End_dQuark
```

From `HyperchargeBridge.lean`:
```lean
-- targetHypercharge : JbarState → ℚ
-- targetT3 : JbarState → ℚ
-- targetQ : JbarState → ℚ (defined as T3 + Y/2)
-- All values are rational numbers from the explicit table.
```

## Target declarations

### Doublet hypercharge equality

```lean
/-- The neutrino (index 0) and electron (index 7) have equal hypercharge Y = -1. -/
theorem lepton_doublet_same_hypercharge :
    targetHypercharge ⟨0, by norm_num⟩ = targetHypercharge ⟨7, by norm_num⟩

/-- Up and down quarks of each color have equal hypercharge Y = 1/3. -/
theorem quark_doublet_same_hypercharge (k : Fin 3) :
    targetHypercharge ⟨4 + k.val, by omega⟩ =
    targetHypercharge ⟨1 + k.val, by omega⟩
```

### Doublet T₃ opposition

```lean
/-- The neutrino and electron have opposite T₃. -/
theorem lepton_doublet_opposite_T3 :
    targetT3 ⟨0, by norm_num⟩ = -targetT3 ⟨7, by norm_num⟩

/-- Up and down quarks of each color have opposite T₃. -/
theorem quark_doublet_opposite_T3 (k : Fin 3) :
    targetT3 ⟨4 + k.val, by omega⟩ =
    -targetT3 ⟨1 + k.val, by omega⟩
```

### Doublet charge difference = 1

```lean
/-- The neutrino has charge 1 more than the electron: Q(ν) - Q(e) = 1. -/
theorem lepton_doublet_charge_difference :
    targetQ ⟨0, by norm_num⟩ - targetQ ⟨7, by norm_num⟩ = 1

/-- Each up quark has charge 1 more than the corresponding down quark. -/
theorem quark_doublet_charge_difference (k : Fin 3) :
    targetQ ⟨4 + k.val, by omega⟩ - targetQ ⟨1 + k.val, by omega⟩ = 1
```

### Operator-level doublet structure

Using T3End from `T3OpJbar`:

```lean
open T3OpJbar in
/-- The neutrino and electron T₃ eigenvalues are opposite as operators. -/
theorem T3_lepton_opposite :
    T3End (JbarBasisState ⟨0, by norm_num⟩) =
    -(T3End (JbarBasisState ⟨7, by norm_num⟩))

open T3OpJbar in
/-- The quark T₃ eigenvalues are opposite as operators. -/
theorem T3_quark_opposite (k : Fin 3) :
    T3End (JbarBasisState ⟨4 + k.val, by omega⟩) =
    -(T3End (JbarBasisState ⟨1 + k.val, by omega⟩))
```

### Bundled package

```lean
/-- The complete SU(2)_L doublet structure of Furey's one-generation Jbar sector. -/
structure FureySU2LDoubletPackage where
  /-- The lepton doublet (ν, e) has equal hypercharge. -/
  lepton_hyp : lepton_doublet_same_hypercharge
  /-- The lepton doublet has opposite T₃. -/
  lepton_T3 : lepton_doublet_opposite_T3
  /-- The lepton doublet has charge difference 1. -/
  lepton_dQ : lepton_doublet_charge_difference
  /-- Each quark doublet (u_k, d_k) has equal hypercharge. -/
  quark_hyp : ∀ k : Fin 3, quark_doublet_same_hypercharge k
  /-- Each quark doublet has opposite T₃. -/
  quark_T3 : ∀ k : Fin 3, quark_doublet_opposite_T3 k
  /-- Each quark doublet has charge difference 1. -/
  quark_dQ : ∀ k : Fin 3, quark_doublet_charge_difference k

noncomputable def fureySU2LDoubletPackage : FureySU2LDoubletPackage
```

## Proof strategy

All theorems are simple `norm_num` computations on the explicit rational
values in `HyperchargeBridge.lean`. The key tables are:

| Index | State | Q | T₃ | Y |
|-------|-------|---|-----|---|
| 0 | ν | 0 | +1/2 | -1 |
| 1-3 | d quarks | -1/3 | -1/2 | +1/3 |
| 4-6 | u quarks | +2/3 | +1/2 | +1/3 |
| 7 | e | -1 | -1/2 | -1 |

For the operator-level theorems, use `T3End_neutrino`, `T3End_electron`,
`T3End_uQuark`, `T3End_dQuark` from `T3OpJbar.lean` together with
`neg_smul` and `smul_neg` to relate the signs.

## Claim boundary

This file proves doublet structure of the Jbar sector as a **table theorem**:
the charge assignments satisfy the doublet conditions. It does **not**:
- Define W⁺ or W⁻ raising/lowering operators (which would mix J and Jbar).
- Derive the doublet structure from the octonionic algebra.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Proofs should be short: `norm_num` or `decide` on explicit rational values.
- Add to `PhysicsSM.lean` if sorry-free.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Furey/WeakIsospinDoublets.lean
lake build PhysicsSM.Algebra.Furey.WeakIsospinDoublets
```
