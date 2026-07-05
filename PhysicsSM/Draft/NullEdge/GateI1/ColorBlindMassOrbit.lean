import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111SpecialUnitaryGroup

/-!
# Color-blind mass on the whole fundamental rep (every SU(3) orbit)

This strengthens `GateI1/ColorBlindMass` from the three concrete color-triplet
basis states (`v4, v5, v6` have equal octonion norm) to the ABSTRACT statement on
the entire `ℂ³` fundamental representation: the norm-weighted colored mass is
constant on EVERY `SU(3)` orbit, not just the basis.

The color `SU(3)` here is the octonion-derived one: by step 1a
(`Octonion.G2FixingE111SpecialUnitaryGroup`,
`mem_su3Submonoid_iff_specialUnitaryGroup`) the octonion `su3Submonoid` IS
`Matrix.specialUnitaryGroup (Fin 3) ℂ`, so the invariance below is invariance
under exactly the group the octonions produce.

## What is proved

* `hermSq x := star x ⬝ᵥ x` - the `SU(3)`-invariant Hermitian color norm on `ℂ³`
  (`= Σ |xᵢ|²`).
* `hermSq_unitary_invariant` / `hermSq_su3_invariant`: `hermSq (U *ᵥ x) = hermSq x`
  for any unitary / special-unitary `U` - a purely algebraic consequence of
  `Uᴴ U = 1`.
* `coloredMassC x m := hermSq x * m` and `coloredMassC_su3_blind`: for ANY mass
  scalar `m`, the colored mass is constant on every `SU(3)` orbit `{U *ᵥ x}`.
* `coloredMassC_octonionSU3_blind`: the same, stated with membership in the
  OCTONION `su3Submonoid` (via 1a) - so it is the octonion-derived `SU(3)` that
  leaves the color mass invariant.

## Claim discipline (careful, per the 1b-correction lesson)

This is the abstract, whole-rep version of the red-team audit's decisive
"colored mass" test, and it comes out on the CO-LOCATION side: the octonion
(color) factor can enter a mass only through the `SU(3)`-invariant `hermSq`, so
the mass is color-BLIND on the entire fundamental rep - never a per-color/charge
distinction. It does NOT construct a mass form on `J (x) CSpinor` coupling
`Q_op` charge to null-edge mass; a genuine charge -> mass coupling
(flavor/generation-dependent mass) is the Higgs/Yukawa, absent here. So this
CONFIRMS "co-location, not coupling" at the level of the whole rep, strengthening
the three-basis-state result of `ColorBlindMass`.

Claim label: **finite identity / consistency check**. Draft-trust,
kernel-checked, `s o r r y`-free. Prerequisites:
`Octonion.G2FixingE111SpecialUnitaryGroup` (1a).
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.ColorBlindMassOrbit

open scoped Matrix
open PhysicsSM.Algebra.Octonion.G2ComplexLine

/-- The `SU(3)`-invariant Hermitian color norm on `ℂ³`: `star x ⬝ᵥ x = Σ |xᵢ|²`.
This is the only octonion-color datum a mass may depend on. -/
noncomputable def hermSq (x : Fin 3 → ℂ) : ℂ := star x ⬝ᵥ x

/-- `hermSq` is invariant under the unitary group: `star (U *ᵥ x) ⬝ᵥ (U *ᵥ x)`
folds via `star_mulVec` and `dotProduct_mulVec` to `star x ⬝ᵥ (Uᴴ U *ᵥ x)`, and
`Uᴴ U = 1`. Purely algebraic - no analysis. -/
theorem hermSq_unitary_invariant
    (U : Matrix (Fin 3) (Fin 3) ℂ) (hU : U ∈ Matrix.unitaryGroup (Fin 3) ℂ)
    (x : Fin 3 → ℂ) : hermSq (U *ᵥ x) = hermSq x := by
  unfold hermSq
  rw [Matrix.star_mulVec, ← Matrix.dotProduct_mulVec, Matrix.mulVec_mulVec]
  have hUU : U.conjTranspose * U = 1 := by
    have := (Matrix.mem_unitaryGroup_iff' (n := Fin 3) (α := ℂ)).1 hU
    simpa [Matrix.star_eq_conjTranspose] using this
  rw [hUU, Matrix.one_mulVec]

/-- `hermSq` is invariant under `SU(3)` (special-unitary is unitary). -/
theorem hermSq_su3_invariant
    (U : Matrix (Fin 3) (Fin 3) ℂ)
    (hU : U ∈ Matrix.specialUnitaryGroup (Fin 3) ℂ) (x : Fin 3 → ℂ) :
    hermSq (U *ᵥ x) = hermSq x :=
  hermSq_unitary_invariant U (Matrix.specialUnitaryGroup_le_unitaryGroup hU) x

/-- The norm-weighted colored mass on `ℂ³`: the `SU(3)`-invariant color norm
times a mass scalar `m`. The only way the octonion color factor enters. -/
noncomputable def coloredMassC (x : Fin 3 → ℂ) (m : ℂ) : ℂ := hermSq x * m

/-- **Color-blind mass on the whole fundamental rep.** For ANY mass scalar `m`,
the colored mass is constant on every `SU(3)` orbit `{U *ᵥ x}` - the abstract,
whole-`ℂ³` version of `ColorBlindMass.coloredMass_color_blind` (which covered only
the three basis states). Co-location, not coupling, on the entire rep. -/
theorem coloredMassC_su3_blind
    (U : Matrix (Fin 3) (Fin 3) ℂ)
    (hU : U ∈ Matrix.specialUnitaryGroup (Fin 3) ℂ) (x : Fin 3 → ℂ) (m : ℂ) :
    coloredMassC (U *ᵥ x) m = coloredMassC x m := by
  unfold coloredMassC; rw [hermSq_su3_invariant U hU]

/-- **The OCTONION `SU(3)` leaves the color mass invariant.** Same statement,
but the group element is drawn from the octonion `su3Submonoid`; by 1a
(`mem_su3Submonoid_iff_specialUnitaryGroup`) that is exactly
`Matrix.specialUnitaryGroup (Fin 3) ℂ`. So it is the octonion-derived color group
that renders the mass color-blind on the whole fundamental rep. -/
theorem coloredMassC_octonionSU3_blind
    (U : Matrix (Fin 3) (Fin 3) ℂ) (hU : U ∈ su3Submonoid)
    (x : Fin 3 → ℂ) (m : ℂ) : coloredMassC (U *ᵥ x) m = coloredMassC x m :=
  coloredMassC_su3_blind U ((mem_su3Submonoid_iff_specialUnitaryGroup U).1 hU) x m

end PhysicsSM.Draft.NullEdge.GateI1.ColorBlindMassOrbit
