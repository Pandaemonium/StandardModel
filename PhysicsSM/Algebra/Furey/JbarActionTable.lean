import Mathlib
import PhysicsSM.Algebra.Furey.JbarLinearIndependence

/-!
# Cl(6) action table on the corrected Jbar basis

This module proves the complete action of the six ladder operators
`alpha1`, `alpha2`, `alpha3`, `alpha1_dag`, `alpha2_dag`, `alpha3_dag`
on each of the eight corrected Jbar basis states `JbarBasisState'`.

## Occupancy picture

The corrected Jbar basis (`JbarBasisState'`) uses creation operators
`alpha_k_dag` on the empty vacuum `omega_bar`:

| Index | State      | Occupancy | Particle     |
|-------|------------|-----------|--------------|
| 0     | omega_bar  | \|000⟩    | neutrino νₑ  |
| 1     | vbar1'     | \|100⟩    | down quark d₁|
| 2     | vbar2'     | \|010⟩    | down quark d₂|
| 3     | vbar3'     | \|001⟩    | down quark d₃|
| 4     | vbar4'     | \|110⟩    | up quark u₁  |
| 5     | vbar5'     | \|101⟩    | up quark u₂  |
| 6     | vbar6'     | \|011⟩    | up quark u₃  |
| 7     | nu_bar'    | \|111⟩    | electron e⁻  |

## Annihilation operators (alpha_k)

Each `alpha_k` removes occupation of mode `k`. When the mode is already
unoccupied the result is zero. Signs arise from the fermionic
anticommutation implemented by the non-associative octonionic product.

## Creation operators (alpha_k_dag)

Each `alpha_k_dag` adds occupation of mode `k`. When the mode is already
occupied the result is zero. Same sign conventions.

## Sign summary

The signs follow fermionic ordering conventions:
- `alpha1` and `alpha1_dag`: no sign flips (mode 1 is leftmost).
- `alpha2` and `alpha2_dag`: sign flip when passing through an
  occupied mode 1 (states 4 = \|110⟩, 5 = \|101⟩, 7 = \|111⟩).
- `alpha3` and `alpha3_dag`: sign flip when passing through an
  occupied mode 1 or 2 (states 5 = \|101⟩, 6 = \|011⟩; signs
  cancel for state 7 = \|111⟩).

## Proof method

All theorems are finite-coordinate computations:
`ext <;> simp [defs...] <;> ring`.

## Status

Trusted module: no `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
-/

namespace PhysicsSM.Algebra.Furey
namespace MinimalLeftIdeal

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Furey.MinimalLeftIdeal
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Algebra.Furey.JbarLinearIndependence

-- ============================================================================
-- § 1  alpha1 (annihilation of mode 1)
-- ============================================================================

/-- `alpha1` annihilates the empty vacuum. -/
theorem act_a1_omega_bar : alpha1 * omega_bar = 0 := by
  ext <;> simp [alpha1, omega_bar]

/-- `alpha1` removes mode 1 from `vbar1'` (\|100⟩ → \|000⟩). -/
theorem act_a1_vbar1' : alpha1 * vbar1' = omega_bar := by
  ext <;> simp [alpha1, vbar1', alpha1_dag, omega_bar] <;> ring

/-- `alpha1` annihilates `vbar2'` (\|010⟩, mode 1 empty). -/
theorem act_a1_vbar2' : alpha1 * vbar2' = 0 := by
  ext <;> simp [alpha1, vbar2', alpha2_dag, omega_bar]

/-- `alpha1` annihilates `vbar3'` (\|001⟩, mode 1 empty). -/
theorem act_a1_vbar3' : alpha1 * vbar3' = 0 := by
  ext <;> simp [alpha1, vbar3', alpha3_dag, omega_bar]

/-- `alpha1` removes mode 1 from `vbar4'` (\|110⟩ → \|010⟩). -/
theorem act_a1_vbar4' : alpha1 * vbar4' = vbar2' := by
  ext <;> simp [alpha1, vbar4', vbar2', alpha1_dag, alpha2_dag, omega_bar] <;> ring

/-- `alpha1` removes mode 1 from `vbar5'` (\|101⟩ → \|001⟩). -/
theorem act_a1_vbar5' : alpha1 * vbar5' = vbar3' := by
  ext <;> simp [alpha1, vbar5', vbar3', alpha1_dag, alpha3_dag, omega_bar] <;> ring

/-- `alpha1` annihilates `vbar6'` (\|011⟩, mode 1 empty). -/
theorem act_a1_vbar6' : alpha1 * vbar6' = 0 := by
  ext <;> simp [alpha1, vbar6', alpha2_dag, alpha3_dag, omega_bar] <;> ring

/-- `alpha1` removes mode 1 from `nu_bar'` (\|111⟩ → \|011⟩). -/
theorem act_a1_nu_bar' : alpha1 * nu_bar' = vbar6' := by
  ext <;> simp [alpha1, nu_bar', vbar6', alpha1_dag, alpha2_dag, alpha3_dag, omega_bar] <;> ring

-- ============================================================================
-- § 2  alpha2 (annihilation of mode 2)
-- ============================================================================

/-- `alpha2` annihilates the empty vacuum. -/
theorem act_a2_omega_bar : alpha2 * omega_bar = 0 := by
  ext <;> simp [alpha2, omega_bar] <;> ring

/-- `alpha2` annihilates `vbar1'` (\|100⟩, mode 2 empty). -/
theorem act_a2_vbar1' : alpha2 * vbar1' = 0 := by
  ext <;> simp [alpha2, vbar1', alpha1_dag, omega_bar] <;> ring

/-- `alpha2` removes mode 2 from `vbar2'` (\|010⟩ → \|000⟩). -/
theorem act_a2_vbar2' : alpha2 * vbar2' = omega_bar := by
  ext <;> simp [alpha2, vbar2', alpha2_dag, omega_bar] <;> ring

/-- `alpha2` annihilates `vbar3'` (\|001⟩, mode 2 empty). -/
theorem act_a2_vbar3' : alpha2 * vbar3' = 0 := by
  ext <;> simp [alpha2, vbar3', alpha3_dag, omega_bar] <;> ring

/-- `alpha2` removes mode 2 from `vbar4'` (\|110⟩ → −\|100⟩).
Fermionic sign from passing through occupied mode 1. -/
theorem act_a2_vbar4' : alpha2 * vbar4' = -vbar1' := by
  ext <;> simp [alpha2, vbar4', vbar1', alpha1_dag, alpha2_dag, omega_bar] <;> ring

/-- `alpha2` annihilates `vbar5'` (\|101⟩, mode 2 empty). -/
theorem act_a2_vbar5' : alpha2 * vbar5' = 0 := by
  ext <;> simp [alpha2, vbar5', alpha1_dag, alpha3_dag, omega_bar] <;> ring

/-- `alpha2` removes mode 2 from `vbar6'` (\|011⟩ → \|001⟩). -/
theorem act_a2_vbar6' : alpha2 * vbar6' = vbar3' := by
  ext <;> simp [alpha2, vbar6', vbar3', alpha2_dag, alpha3_dag, omega_bar] <;> ring

/-- `alpha2` removes mode 2 from `nu_bar'` (\|111⟩ → −\|101⟩).
Fermionic sign from passing through occupied mode 1. -/
theorem act_a2_nu_bar' : alpha2 * nu_bar' = -vbar5' := by
  ext <;> simp [alpha2, nu_bar', vbar5', alpha1_dag, alpha2_dag, alpha3_dag, omega_bar] <;> ring

-- ============================================================================
-- § 3  alpha3 (annihilation of mode 3)
-- ============================================================================

/-- `alpha3` annihilates the empty vacuum. -/
theorem act_a3_omega_bar : alpha3 * omega_bar = 0 := by
  ext <;> simp [alpha3, omega_bar] <;> ring

/-- `alpha3` annihilates `vbar1'` (\|100⟩, mode 3 empty). -/
theorem act_a3_vbar1' : alpha3 * vbar1' = 0 := by
  ext <;> simp [alpha3, vbar1', alpha1_dag, omega_bar] <;> ring

/-- `alpha3` annihilates `vbar2'` (\|010⟩, mode 3 empty). -/
theorem act_a3_vbar2' : alpha3 * vbar2' = 0 := by
  ext <;> simp [alpha3, vbar2', alpha2_dag, omega_bar] <;> ring

/-- `alpha3` removes mode 3 from `vbar3'` (\|001⟩ → \|000⟩). -/
theorem act_a3_vbar3' : alpha3 * vbar3' = omega_bar := by
  ext <;> simp [alpha3, vbar3', alpha3_dag, omega_bar] <;> ring

/-- `alpha3` annihilates `vbar4'` (\|110⟩, mode 3 empty). -/
theorem act_a3_vbar4' : alpha3 * vbar4' = 0 := by
  ext <;> simp [alpha3, vbar4', alpha1_dag, alpha2_dag, omega_bar] <;> ring

/-- `alpha3` removes mode 3 from `vbar5'` (\|101⟩ → −\|100⟩).
Fermionic sign from passing through occupied mode 1. -/
theorem act_a3_vbar5' : alpha3 * vbar5' = -vbar1' := by
  ext <;> simp [alpha3, vbar5', vbar1', alpha1_dag, alpha3_dag, omega_bar] <;> ring

/-- `alpha3` removes mode 3 from `vbar6'` (\|011⟩ → −\|010⟩).
Fermionic sign from passing through occupied mode 2. -/
theorem act_a3_vbar6' : alpha3 * vbar6' = -vbar2' := by
  ext <;> simp [alpha3, vbar6', vbar2', alpha2_dag, alpha3_dag, omega_bar] <;> ring

set_option maxHeartbeats 800000 in
-- Four-level product expansion needs extra heartbeats.
/-- `alpha3` removes mode 3 from `nu_bar'` (\|111⟩ → \|110⟩).
Signs from modes 1 and 2 cancel. -/
theorem act_a3_nu_bar' : alpha3 * nu_bar' = vbar4' := by
  ext <;> simp [alpha3, nu_bar', vbar4', alpha1_dag, alpha2_dag, alpha3_dag, omega_bar] <;> ring

-- ============================================================================
-- § 4  alpha1_dag (creation of mode 1)
-- ============================================================================

/-- `alpha1_dag` creates mode 1 in the empty vacuum (\|000⟩ → \|100⟩). -/
theorem act_a1d_omega_bar : alpha1_dag * omega_bar = vbar1' := by
  ext <;> simp [alpha1_dag, omega_bar, vbar1']

/-- `alpha1_dag` annihilates `vbar1'` (mode 1 already occupied). -/
theorem act_a1d_vbar1' : alpha1_dag * vbar1' = 0 := by
  ext <;> simp [alpha1_dag, vbar1', omega_bar] <;> ring

/-- `alpha1_dag` creates mode 1 in `vbar2'` (\|010⟩ → \|110⟩). -/
theorem act_a1d_vbar2' : alpha1_dag * vbar2' = vbar4' := by
  ext <;> simp [alpha1_dag, vbar2', vbar4', alpha2_dag, omega_bar]

/-- `alpha1_dag` creates mode 1 in `vbar3'` (\|001⟩ → \|101⟩). -/
theorem act_a1d_vbar3' : alpha1_dag * vbar3' = vbar5' := by
  ext <;> simp [alpha1_dag, vbar3', vbar5', alpha3_dag, omega_bar]

/-- `alpha1_dag` annihilates `vbar4'` (mode 1 already occupied). -/
theorem act_a1d_vbar4' : alpha1_dag * vbar4' = 0 := by
  ext <;> simp [alpha1_dag, vbar4', alpha2_dag, omega_bar] <;> ring

/-- `alpha1_dag` annihilates `vbar5'` (mode 1 already occupied). -/
theorem act_a1d_vbar5' : alpha1_dag * vbar5' = 0 := by
  ext <;> simp [alpha1_dag, vbar5', alpha3_dag, omega_bar] <;> ring

/-- `alpha1_dag` creates mode 1 in `vbar6'` (\|011⟩ → \|111⟩). -/
theorem act_a1d_vbar6' : alpha1_dag * vbar6' = nu_bar' := by
  ext <;> simp [alpha1_dag, vbar6', nu_bar', alpha2_dag, alpha3_dag, omega_bar]

/-- `alpha1_dag` annihilates `nu_bar'` (mode 1 already occupied). -/
theorem act_a1d_nu_bar' : alpha1_dag * nu_bar' = 0 := by
  ext <;> simp [alpha1_dag, nu_bar', alpha2_dag, alpha3_dag, omega_bar] <;> ring

-- ============================================================================
-- § 5  alpha2_dag (creation of mode 2)
-- ============================================================================

/-- `alpha2_dag` creates mode 2 in the empty vacuum (\|000⟩ → \|010⟩). -/
theorem act_a2d_omega_bar : alpha2_dag * omega_bar = vbar2' := by
  ext <;> simp [alpha2_dag, omega_bar, vbar2']

/-- `alpha2_dag` creates mode 2 in `vbar1'` (\|100⟩ → −\|110⟩).
Fermionic sign from passing through occupied mode 1. -/
theorem act_a2d_vbar1' : alpha2_dag * vbar1' = -vbar4' := by
  ext <;> simp [alpha2_dag, vbar1', vbar4', alpha1_dag, omega_bar] <;> ring

/-- `alpha2_dag` annihilates `vbar2'` (mode 2 already occupied). -/
theorem act_a2d_vbar2' : alpha2_dag * vbar2' = 0 := by
  ext <;> simp [alpha2_dag, vbar2', omega_bar]

/-- `alpha2_dag` creates mode 2 in `vbar3'` (\|001⟩ → \|011⟩). -/
theorem act_a2d_vbar3' : alpha2_dag * vbar3' = vbar6' := by
  ext <;> simp [alpha2_dag, vbar3', vbar6', alpha3_dag, omega_bar]

/-- `alpha2_dag` annihilates `vbar4'` (mode 2 already occupied). -/
theorem act_a2d_vbar4' : alpha2_dag * vbar4' = 0 := by
  ext <;> simp [alpha2_dag, vbar4', alpha1_dag, omega_bar] <;> ring

/-- `alpha2_dag` creates mode 2 in `vbar5'` (\|101⟩ → −\|111⟩).
Fermionic sign from passing through occupied mode 1. -/
theorem act_a2d_vbar5' : alpha2_dag * vbar5' = -nu_bar' := by
  ext <;> simp [alpha2_dag, vbar5', nu_bar', alpha1_dag, alpha3_dag, omega_bar] <;> ring

/-- `alpha2_dag` annihilates `vbar6'` (mode 2 already occupied). -/
theorem act_a2d_vbar6' : alpha2_dag * vbar6' = 0 := by
  ext <;> simp [alpha2_dag, vbar6', alpha3_dag, omega_bar] <;> ring

/-- `alpha2_dag` annihilates `nu_bar'` (mode 2 already occupied). -/
theorem act_a2d_nu_bar' : alpha2_dag * nu_bar' = 0 := by
  ext <;> simp [alpha2_dag, nu_bar', alpha1_dag, alpha3_dag, omega_bar] <;> ring

-- ============================================================================
-- § 6  alpha3_dag (creation of mode 3)
-- ============================================================================

/-- `alpha3_dag` creates mode 3 in the empty vacuum (\|000⟩ → \|001⟩). -/
theorem act_a3d_omega_bar : alpha3_dag * omega_bar = vbar3' := by
  ext <;> simp [alpha3_dag, omega_bar, vbar3']

/-- `alpha3_dag` creates mode 3 in `vbar1'` (\|100⟩ → −\|101⟩).
Fermionic sign from passing through occupied mode 1. -/
theorem act_a3d_vbar1' : alpha3_dag * vbar1' = -vbar5' := by
  ext <;> simp [alpha3_dag, vbar1', vbar5', alpha1_dag, omega_bar] <;> ring

/-- `alpha3_dag` creates mode 3 in `vbar2'` (\|010⟩ → −\|011⟩).
Fermionic sign from passing through occupied mode 2. -/
theorem act_a3d_vbar2' : alpha3_dag * vbar2' = -vbar6' := by
  ext <;> simp [alpha3_dag, vbar2', vbar6', alpha2_dag, omega_bar]

/-- `alpha3_dag` annihilates `vbar3'` (mode 3 already occupied). -/
theorem act_a3d_vbar3' : alpha3_dag * vbar3' = 0 := by
  ext <;> simp [alpha3_dag, vbar3', omega_bar]

set_option maxHeartbeats 800000 in
-- Four-level product expansion needs extra heartbeats.
/-- `alpha3_dag` creates mode 3 in `vbar4'` (\|110⟩ → \|111⟩).
Signs from modes 1 and 2 cancel. -/
theorem act_a3d_vbar4' : alpha3_dag * vbar4' = nu_bar' := by
  ext <;> simp [alpha3_dag, vbar4', nu_bar', alpha1_dag, alpha2_dag, omega_bar] <;> ring

/-- `alpha3_dag` annihilates `vbar5'` (mode 3 already occupied). -/
theorem act_a3d_vbar5' : alpha3_dag * vbar5' = 0 := by
  ext <;> simp [alpha3_dag, vbar5', alpha1_dag, omega_bar]

/-- `alpha3_dag` annihilates `vbar6'` (mode 3 already occupied). -/
theorem act_a3d_vbar6' : alpha3_dag * vbar6' = 0 := by
  ext <;> simp [alpha3_dag, vbar6', alpha2_dag, omega_bar] <;> ring

set_option maxHeartbeats 800000 in
-- Four-level product expansion needs extra heartbeats.
/-- `alpha3_dag` annihilates `nu_bar'` (mode 3 already occupied). -/
theorem act_a3d_nu_bar' : alpha3_dag * nu_bar' = 0 := by
  ext <;> simp [alpha3_dag, nu_bar', alpha1_dag, alpha2_dag, omega_bar] <;> ring

-- ============================================================================
-- § 7  Indexed action function and uniform theorem
-- ============================================================================

/-- The six ladder operators indexed by `(dagger : Bool) × (k : Fin 3)`.
`dagger = false` gives `alpha_k` (annihilation),
`dagger = true` gives `alpha_k_dag` (creation). -/
noncomputable def ladderOp (dagger : Bool) (k : Fin 3) : ComplexOctonion :=
  match dagger, k with
  | false, 0 => alpha1
  | false, 1 => alpha2
  | false, 2 => alpha3
  | true, 0 => alpha1_dag
  | true, 1 => alpha2_dag
  | true, 2 => alpha3_dag

/-- The result of applying a ladder operator to a basis state:
`none` means the result is zero,
`some (c, t)` means the result is `c • JbarBasisState' t`.

The coefficient `c` is always `1` or `-1` in this table. -/
def jbarAlphaAction (dagger : Bool) (k : Fin 3) (s : Fin 8) :
    Option (ℂ × Fin 8) :=
  match dagger, k, s with
  -- alpha1 (annihilation, mode 1)
  | false, 0, 0 => none         -- omega_bar → 0
  | false, 0, 1 => some (1, 0)  -- vbar1' → omega_bar
  | false, 0, 2 => none         -- vbar2' → 0
  | false, 0, 3 => none         -- vbar3' → 0
  | false, 0, 4 => some (1, 2)  -- vbar4' → vbar2'
  | false, 0, 5 => some (1, 3)  -- vbar5' → vbar3'
  | false, 0, 6 => none         -- vbar6' → 0
  | false, 0, 7 => some (1, 6)  -- nu_bar' → vbar6'
  -- alpha2 (annihilation, mode 2)
  | false, 1, 0 => none         -- omega_bar → 0
  | false, 1, 1 => none         -- vbar1' → 0
  | false, 1, 2 => some (1, 0)  -- vbar2' → omega_bar
  | false, 1, 3 => none         -- vbar3' → 0
  | false, 1, 4 => some (-1, 1) -- vbar4' → -vbar1'
  | false, 1, 5 => none         -- vbar5' → 0
  | false, 1, 6 => some (1, 3)  -- vbar6' → vbar3'
  | false, 1, 7 => some (-1, 5) -- nu_bar' → -vbar5'
  -- alpha3 (annihilation, mode 3)
  | false, 2, 0 => none         -- omega_bar → 0
  | false, 2, 1 => none         -- vbar1' → 0
  | false, 2, 2 => none         -- vbar2' → 0
  | false, 2, 3 => some (1, 0)  -- vbar3' → omega_bar
  | false, 2, 4 => none         -- vbar4' → 0
  | false, 2, 5 => some (-1, 1) -- vbar5' → -vbar1'
  | false, 2, 6 => some (-1, 2) -- vbar6' → -vbar2'
  | false, 2, 7 => some (1, 4)  -- nu_bar' → vbar4'
  -- alpha1_dag (creation, mode 1)
  | true, 0, 0 => some (1, 1)   -- omega_bar → vbar1'
  | true, 0, 1 => none          -- vbar1' → 0
  | true, 0, 2 => some (1, 4)   -- vbar2' → vbar4'
  | true, 0, 3 => some (1, 5)   -- vbar3' → vbar5'
  | true, 0, 4 => none          -- vbar4' → 0
  | true, 0, 5 => none          -- vbar5' → 0
  | true, 0, 6 => some (1, 7)   -- vbar6' → nu_bar'
  | true, 0, 7 => none          -- nu_bar' → 0
  -- alpha2_dag (creation, mode 2)
  | true, 1, 0 => some (1, 2)   -- omega_bar → vbar2'
  | true, 1, 1 => some (-1, 4)  -- vbar1' → -vbar4'
  | true, 1, 2 => none          -- vbar2' → 0
  | true, 1, 3 => some (1, 6)   -- vbar3' → vbar6'
  | true, 1, 4 => none          -- vbar4' → 0
  | true, 1, 5 => some (-1, 7)  -- vbar5' → -nu_bar'
  | true, 1, 6 => none          -- vbar6' → 0
  | true, 1, 7 => none          -- nu_bar' → 0
  -- alpha3_dag (creation, mode 3)
  | true, 2, 0 => some (1, 3)   -- omega_bar → vbar3'
  | true, 2, 1 => some (-1, 5)  -- vbar1' → -vbar5'
  | true, 2, 2 => some (-1, 6)  -- vbar2' → -vbar6'
  | true, 2, 3 => none          -- vbar3' → 0
  | true, 2, 4 => some (1, 7)   -- vbar4' → nu_bar'
  | true, 2, 5 => none          -- vbar5' → 0
  | true, 2, 6 => none          -- vbar6' → 0
  | true, 2, 7 => none          -- nu_bar' → 0

set_option maxHeartbeats 3200000 in
-- 48-way case split over `Bool × Fin 3 × Fin 8` needs extra heartbeats.
/-- The uniform action theorem: for each ladder operator and basis state,
the product equals zero (when `jbarAlphaAction` returns `none`) or
`c • JbarBasisState' t` (when it returns `some (c, t)`). -/
theorem alpha_mul_JbarBasisState'_eq_action
    (dagger : Bool) (k : Fin 3) (s : Fin 8) :
    ladderOp dagger k * JbarBasisState' s =
      match jbarAlphaAction dagger k s with
      | none => 0
      | some (c, t) => c • JbarBasisState' t := by
  fin_cases dagger <;> fin_cases k <;> fin_cases s <;>
    simp only [ladderOp, jbarAlphaAction, JbarBasisState', one_smul, neg_one_smul,
      Fin.isValue] <;>
    first
    | exact act_a1_omega_bar
    | exact act_a1_vbar2'
    | exact act_a1_vbar3'
    | exact act_a1_vbar6'
    | exact act_a2_omega_bar
    | exact act_a2_vbar1'
    | exact act_a2_vbar3'
    | exact act_a2_vbar5'
    | exact act_a3_omega_bar
    | exact act_a3_vbar1'
    | exact act_a3_vbar2'
    | exact act_a3_vbar4'
    | exact act_a1d_vbar1'
    | exact act_a1d_vbar4'
    | exact act_a1d_vbar5'
    | exact act_a1d_nu_bar'
    | exact act_a2d_vbar2'
    | exact act_a2d_vbar4'
    | exact act_a2d_vbar6'
    | exact act_a2d_nu_bar'
    | exact act_a3d_vbar3'
    | exact act_a3d_vbar5'
    | exact act_a3d_vbar6'
    | exact act_a3d_nu_bar'
    | exact act_a1_vbar1'
    | exact act_a1_vbar4'
    | exact act_a1_vbar5'
    | exact act_a1_nu_bar'
    | exact act_a2_vbar2'
    | exact act_a2_vbar4'
    | exact act_a2_vbar6'
    | exact act_a2_nu_bar'
    | exact act_a3_vbar3'
    | exact act_a3_vbar5'
    | exact act_a3_vbar6'
    | exact act_a3_nu_bar'
    | exact act_a1d_omega_bar
    | exact act_a1d_vbar2'
    | exact act_a1d_vbar3'
    | exact act_a1d_vbar6'
    | exact act_a2d_omega_bar
    | exact act_a2d_vbar1'
    | exact act_a2d_vbar3'
    | exact act_a2d_vbar5'
    | exact act_a3d_omega_bar
    | exact act_a3d_vbar1'
    | exact act_a3d_vbar2'
    | exact act_a3d_vbar4'

-- ============================================================================
-- § 8  Package
-- ============================================================================

/-- Package collecting the Jbar action table lemmas for downstream use. -/
structure JbarActionTablePackage where
  /-- Annihilation operator `alpha1` on each basis state. -/
  a1_omega_bar : alpha1 * omega_bar = 0
  a1_vbar1'    : alpha1 * vbar1' = omega_bar
  a1_vbar2'    : alpha1 * vbar2' = 0
  a1_vbar3'    : alpha1 * vbar3' = 0
  a1_vbar4'    : alpha1 * vbar4' = vbar2'
  a1_vbar5'    : alpha1 * vbar5' = vbar3'
  a1_vbar6'    : alpha1 * vbar6' = 0
  a1_nu_bar'   : alpha1 * nu_bar' = vbar6'
  /-- Annihilation operator `alpha2` on each basis state. -/
  a2_omega_bar : alpha2 * omega_bar = 0
  a2_vbar1'    : alpha2 * vbar1' = 0
  a2_vbar2'    : alpha2 * vbar2' = omega_bar
  a2_vbar3'    : alpha2 * vbar3' = 0
  a2_vbar4'    : alpha2 * vbar4' = -vbar1'
  a2_vbar5'    : alpha2 * vbar5' = 0
  a2_vbar6'    : alpha2 * vbar6' = vbar3'
  a2_nu_bar'   : alpha2 * nu_bar' = -vbar5'
  /-- Annihilation operator `alpha3` on each basis state. -/
  a3_omega_bar : alpha3 * omega_bar = 0
  a3_vbar1'    : alpha3 * vbar1' = 0
  a3_vbar2'    : alpha3 * vbar2' = 0
  a3_vbar3'    : alpha3 * vbar3' = omega_bar
  a3_vbar4'    : alpha3 * vbar4' = 0
  a3_vbar5'    : alpha3 * vbar5' = -vbar1'
  a3_vbar6'    : alpha3 * vbar6' = -vbar2'
  a3_nu_bar'   : alpha3 * nu_bar' = vbar4'
  /-- Creation operator `alpha1_dag` on each basis state. -/
  a1d_omega_bar : alpha1_dag * omega_bar = vbar1'
  a1d_vbar1'    : alpha1_dag * vbar1' = 0
  a1d_vbar2'    : alpha1_dag * vbar2' = vbar4'
  a1d_vbar3'    : alpha1_dag * vbar3' = vbar5'
  a1d_vbar4'    : alpha1_dag * vbar4' = 0
  a1d_vbar5'    : alpha1_dag * vbar5' = 0
  a1d_vbar6'    : alpha1_dag * vbar6' = nu_bar'
  a1d_nu_bar'   : alpha1_dag * nu_bar' = 0
  /-- Creation operator `alpha2_dag` on each basis state. -/
  a2d_omega_bar : alpha2_dag * omega_bar = vbar2'
  a2d_vbar1'    : alpha2_dag * vbar1' = -vbar4'
  a2d_vbar2'    : alpha2_dag * vbar2' = 0
  a2d_vbar3'    : alpha2_dag * vbar3' = vbar6'
  a2d_vbar4'    : alpha2_dag * vbar4' = 0
  a2d_vbar5'    : alpha2_dag * vbar5' = -nu_bar'
  a2d_vbar6'    : alpha2_dag * vbar6' = 0
  a2d_nu_bar'   : alpha2_dag * nu_bar' = 0
  /-- Creation operator `alpha3_dag` on each basis state. -/
  a3d_omega_bar : alpha3_dag * omega_bar = vbar3'
  a3d_vbar1'    : alpha3_dag * vbar1' = -vbar5'
  a3d_vbar2'    : alpha3_dag * vbar2' = -vbar6'
  a3d_vbar3'    : alpha3_dag * vbar3' = 0
  a3d_vbar4'    : alpha3_dag * vbar4' = nu_bar'
  a3d_vbar5'    : alpha3_dag * vbar5' = 0
  a3d_vbar6'    : alpha3_dag * vbar6' = 0
  a3d_nu_bar'   : alpha3_dag * nu_bar' = 0

/-- The concrete package instance with all 48 action table entries proved. -/
noncomputable def jbarActionTablePackage : JbarActionTablePackage where
  a1_omega_bar := act_a1_omega_bar
  a1_vbar1'    := act_a1_vbar1'
  a1_vbar2'    := act_a1_vbar2'
  a1_vbar3'    := act_a1_vbar3'
  a1_vbar4'    := act_a1_vbar4'
  a1_vbar5'    := act_a1_vbar5'
  a1_vbar6'    := act_a1_vbar6'
  a1_nu_bar'   := act_a1_nu_bar'
  a2_omega_bar := act_a2_omega_bar
  a2_vbar1'    := act_a2_vbar1'
  a2_vbar2'    := act_a2_vbar2'
  a2_vbar3'    := act_a2_vbar3'
  a2_vbar4'    := act_a2_vbar4'
  a2_vbar5'    := act_a2_vbar5'
  a2_vbar6'    := act_a2_vbar6'
  a2_nu_bar'   := act_a2_nu_bar'
  a3_omega_bar := act_a3_omega_bar
  a3_vbar1'    := act_a3_vbar1'
  a3_vbar2'    := act_a3_vbar2'
  a3_vbar3'    := act_a3_vbar3'
  a3_vbar4'    := act_a3_vbar4'
  a3_vbar5'    := act_a3_vbar5'
  a3_vbar6'    := act_a3_vbar6'
  a3_nu_bar'   := act_a3_nu_bar'
  a1d_omega_bar := act_a1d_omega_bar
  a1d_vbar1'    := act_a1d_vbar1'
  a1d_vbar2'    := act_a1d_vbar2'
  a1d_vbar3'    := act_a1d_vbar3'
  a1d_vbar4'    := act_a1d_vbar4'
  a1d_vbar5'    := act_a1d_vbar5'
  a1d_vbar6'    := act_a1d_vbar6'
  a1d_nu_bar'   := act_a1d_nu_bar'
  a2d_omega_bar := act_a2d_omega_bar
  a2d_vbar1'    := act_a2d_vbar1'
  a2d_vbar2'    := act_a2d_vbar2'
  a2d_vbar3'    := act_a2d_vbar3'
  a2d_vbar4'    := act_a2d_vbar4'
  a2d_vbar5'    := act_a2d_vbar5'
  a2d_vbar6'    := act_a2d_vbar6'
  a2d_nu_bar'   := act_a2d_nu_bar'
  a3d_omega_bar := act_a3d_omega_bar
  a3d_vbar1'    := act_a3d_vbar1'
  a3d_vbar2'    := act_a3d_vbar2'
  a3d_vbar3'    := act_a3d_vbar3'
  a3d_vbar4'    := act_a3d_vbar4'
  a3d_vbar5'    := act_a3d_vbar5'
  a3d_vbar6'    := act_a3d_vbar6'
  a3d_nu_bar'   := act_a3d_nu_bar'

end MinimalLeftIdeal
end PhysicsSM.Algebra.Furey
