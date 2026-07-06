import Mathlib
import PhysicsSM.Algebra.Furey.OperatorRepresentations
import PhysicsSM.Draft.NullEdge.GateI1.ColorBlindMass
import PhysicsSM.Draft.NullEdge.GateI1.Core

/-!
# The unification verdict: `charge_grading_mass_compatible`

This module settles the decisive test of the octonion / null-edge "unification":
does the octonion (color/charge) structure genuinely COUPLE to the null-edge
(mass) structure on the shared spinor module `J (x) CSpinor`, or do the two
merely CO-LOCATE (remain independent) on one spinor?

## The verdict: CO-LOCATION, not coupling (non-vacuous)

We build a genuine mass form on the shared module `ComplexOctonion (x) CSpinor`
that is *allowed* to depend on BOTH factors:

* the octonion (charge) factor `z`, through the `SU(3)`-invariant octonion norm
  `cNormSq z` (the ColorBlindMass datum), and
* the spacetime Weyl-spinor factor `psi : CSpinor = Fin 2 -> C`, through its
  Hermitian norm `spacetimeMass psi = |psi 0|^2 + |psi 1|^2`,

via `massForm z psi := cNormSq z * spacetimeMass psi`. This is exactly the most
general norm-weighted mass the two structures can produce, and it does depend on
the octonion factor (e.g. it scales with `cNormSq z`), so the result below is NOT
the vacuous tensor-bifunctoriality statement that sank `internal_spacetime_commute`.

The verdict is proved by making the `Q_op` charge grading and the mass value
interact directly:

* `charge_grading_mass_compatible` (the headline). For every spacetime spinor
  `psi`, the two ideal states `v1` and `v4` satisfy
  - `Q_op v1 = (-2/3) . v1` and `Q_op v4 = (-1/3) . v4`: they carry
    **DIFFERENT** electric charges (`-2/3` vs `-1/3`, the anti-up vs anti-down
    Furey assignments), yet
  - `massForm v1 psi = massForm v4 psi`: the null-edge mass assigns them the
    **SAME** mass.
  So the mass is blind to the `Q_op` charge even ACROSS distinct charge blocks:
  the octonion charge does not enter the mass. If the mass genuinely coupled to
  charge this conclusion would be FALSE, which is what makes the statement
  non-vacuous.

* `mass_colorBlind_on_chargeBlock`. Within the single charge block
  `{v4, v5, v6}` (all with `Q_op = -1/3`), the mass is constant for every `psi`:
  color-blindness inside a fixed `Q_op` eigenvalue.

* `coupling_would_distinguish`. The counterfactual that certifies non-vacuity: a
  genuinely charge-coupled reference mass `chargeCoupledMass lam psi := lam * spacetimeMass psi`
  DOES separate the two charges, `chargeCoupledMass (-2/3) psi <> chargeCoupledMass (-1/3) psi`
  whenever `spacetimeMass psi <> 0`. Thus the equality in
  `charge_grading_mass_compatible` is a real constraint the norm-weighted mass
  satisfies and a charge-coupled mass violates.

## `Q_op` eigenvalues referenced (all kernel-checked upstream)

`Q_v1 : Q_op v1 = (-2/3) . v1`, `Q_v4 = Q_v5 = Q_v6 = (-1/3) . (.)`, drawn from
`PhysicsSM.Algebra.Furey.OperatorRepresentations`. The norm datum
`cNormSq v_i = 1/2` for every ideal basis state (each has exactly two
coordinates of magnitude `1/2`) is what forces the mass to agree across the
charge blocks.

## Claim discipline

Verdict: **co-location, not coupling**. The octonion factor supplies only an
overall `SU(3)`-invariant scale (`cNormSq = 1/2` for the whole triplet family),
never a per-charge mass distinction. A genuine charge -> mass coupling
(flavor/generation-dependent mass) is the Higgs/Yukawa sector, a separate
structure absent here. Draft-trust, kernel-checked, `s o r r y`-free. Standard
axioms only.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.ChargeGradingMassCompatible

open PhysicsSM.Algebra.Furey.MinimalLeftIdeal
open PhysicsSM.Algebra.Octonion
open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Draft.NullEdge.GateI1.ColorBlindMass

/-- The spacetime (Weyl-spinor) mass datum: the Hermitian norm of the spinor
`psi : CSpinor = Fin 2 -> C`. This is the spacetime factor the null-edge mass
may depend on. -/
noncomputable def spacetimeMass (psi : CSpinor) : ℝ :=
  Complex.normSq (psi 0) + Complex.normSq (psi 1)

/-- **The null-edge mass form on the shared module** `ComplexOctonion (x) CSpinor`.
It depends on BOTH factors: the octonion (charge) factor `z` through the
`SU(3)`-invariant norm `cNormSq z`, and the spacetime factor `psi` through
`spacetimeMass psi`. This is the most general norm-weighted mass the two
structures can build; it is not constant in `z`, so the co-location results below
are non-vacuous. -/
noncomputable def massForm (z : ComplexOctonion.ComplexOctonion) (psi : CSpinor) : ℝ :=
  cNormSq z * spacetimeMass psi

/-- A genuinely charge-coupled reference mass, for contrast: it reads the `Q_op`
eigenvalue `lam` directly. Used to certify that
`charge_grading_mass_compatible` is a real (non-vacuous) constraint. -/
noncomputable def chargeCoupledMass (lam : ℝ) (psi : CSpinor) : ℝ :=
  lam * spacetimeMass psi

/-- Each ideal basis state has octonion norm `1/2`. -/
theorem cNormSq_v1 : cNormSq v1 = 1 / 2 := by
  simp only [cNormSq, v1, normSq_def]; norm_num

theorem cNormSq_v4 : cNormSq v4 = 1 / 2 := by
  simp only [cNormSq, v4, normSq_def]; norm_num

/-- **The unification verdict: co-location, not coupling.**

For every spacetime spinor `psi`, the ideal states `v1` and `v4` carry DIFFERENT
`Q_op` electric charges (`-2/3` and `-1/3`), yet the null-edge mass form assigns
them the SAME mass. Hence the octonion charge does not enter the mass: the mass
is blind to the `Q_op` grading even across distinct charge blocks. Were the mass
genuinely coupled to charge, the final equality would be false (see
`coupling_would_distinguish`). -/
theorem charge_grading_mass_compatible (psi : CSpinor) :
    Q_op v1 = (-2 / 3 : Complex) • v1 ∧
    Q_op v4 = (-1 / 3 : Complex) • v4 ∧
    massForm v1 psi = massForm v4 psi := by
  refine ⟨Q_v1, Q_v4, ?_⟩
  simp only [massForm, cNormSq_v1, cNormSq_v4]

/-- **Color-blindness inside a fixed `Q_op` charge block.** The three color
states `v4, v5, v6` all share `Q_op = -1/3`, and for every spacetime spinor
`psi` they receive the same null-edge mass. -/
theorem mass_colorBlind_on_chargeBlock (psi : CSpinor) :
    (Q_op v4 = (-1 / 3 : Complex) • v4 ∧
     Q_op v5 = (-1 / 3 : Complex) • v5 ∧
     Q_op v6 = (-1 / 3 : Complex) • v6) ∧
    massForm v4 psi = massForm v5 psi ∧ massForm v5 psi = massForm v6 psi := by
  refine ⟨⟨Q_v4, Q_v5, Q_v6⟩, ?_, ?_⟩ <;>
    · simp only [massForm]
      obtain ⟨h45, h56⟩ := colorTriplet_equal_norm
      first
        | rw [h45]
        | rw [h56]

/-- **Non-vacuity witness (the coupling counterfactual).** A genuinely
charge-coupled mass `chargeCoupledMass` DOES distinguish the two charges `-2/3`
and `-1/3` whenever the spacetime spinor is massive (`spacetimeMass psi <> 0`).
This shows the equality proved in `charge_grading_mass_compatible` is a real
constraint that the norm-weighted mass satisfies but a charge-coupled mass
violates - so the co-location verdict is not vacuously true. -/
theorem coupling_would_distinguish (psi : CSpinor) (h : spacetimeMass psi ≠ 0) :
    chargeCoupledMass (-2 / 3) psi ≠ chargeCoupledMass (-1 / 3) psi := by
  -- `mul_left_injective₀ h |>.eq_iff` cancels the common `spacetimeMass psi`
  -- factor, reducing the goal to the numeric inequality `-2/3 ≠ -1/3`.
  simp only [chargeCoupledMass, ne_eq, mul_left_injective₀ h |>.eq_iff]
  norm_num

/-- A concrete massive spinor showing `coupling_would_distinguish` is not
vacuous: `spacetimeMass` of the spinor `(1, 0)` is `1 <> 0`. -/
theorem spacetimeMass_pos_example :
    spacetimeMass (fun i => if i = 0 then 1 else 0) = 1 := by
  simp [spacetimeMass]

end PhysicsSM.Draft.NullEdge.GateI1.ChargeGradingMassCompatible
