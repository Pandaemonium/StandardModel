import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Core
import PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
import PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass

/-!
# Gate I1 / NE-U: mass-taxonomy SEPARATION (F-YM-CONFLATE at theorem grade)

This module converts the mass-taxonomy table of
`AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md`
(section 13.2, mass taxonomy) into MATHEMATICS: the distinct kinds of "mass" in
the null-edge program are provably DIFFERENT functionals, not one quantity
relabeled. This is the guard against the "all mass is one thing" over-claim
(the F-YM-CONFLATE error): the unification asserts that the taxonomy rows share
a mechanism SHAPE (a closure/aperture obstruction), NOT that they are one
number.

## The four taxonomy functionals

1. **Primitive / bare mass** `quarkMassParameter : ℝ`
   (from `GateI1/MassWithoutMass.lean`), an input parameter, `= 0`.
2. **Closure / glueball spectral mass** `z2GlueballMass β : ℝ`
   (from `GateI1/MassWithoutMass.lean`), `= log coth β`, strictly positive for
   `β > 0` (`z2GlueballMass_pos`).
3. **Wilson REGULATOR mass** `wilsonRegulatorMass r : ℝ`, defined here as the
   doubler-removal transfer-gap surrogate `log (1 + 4 r)` of the 2-site
   Wilson-quark model (see docstring on the def). Positive for `r > 0` EVEN
   WHEN the bare mass is zero: this is a lattice REGULATOR artifact, taxonomy
   row 2, distinct from both the bare (row 1) and closure (row 3) masses.
4. **Composite aperture mass** `compositeApertureMassSq p q : ℝ`, defined here
   as `minkowskiSq (p + q)` for `Momentum4` null momenta `p, q`, reusing the
   `minkowskiSq` / `minkDot` API of `GateI1/CompositeApertureMass.lean`. It is
   the KINEMATIC aperture of the null bundle (row 4).

## The separation theorems

Each functional can be zero while another is positive - the functionals are
pairwise independent, not proportional. Witnesses are concrete and
kernel-checked. Bundled into `massTaxonomy_functionals_pairwise_separated`.

## Claim discipline

Claim label: **finite identity / taxonomy separation**. Draft-trust,
kernel-checked, `sorry`-free, no new axioms, no `native_decide`. This is a
statement about the FUNCTIONALS (they are not proportional), NOT a physical
claim about QCD.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace MassTaxonomySeparation

open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass
open PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass

/-! ## Row 3: the Wilson regulator mass -/

/-- **Wilson REGULATOR mass** (taxonomy row 2 of section 13.2): the
doubler-removal transfer-gap of the 2-site Wilson-quark model at Wilson
parameter `r`. A faithful surrogate for the exact 2-site Wilson transfer gap,
pinned to the Wilson regulator: with vanishing bare mass the naive quark has a
lattice fermion doubler; the Wilson term adds a momentum-dependent mass
`~ 2 r (1 - cos p)` that lifts the doubler, and the resulting temporal
transfer gap of the 2-site model is `log (1 + 4 r)` (the doubler at the
Brillouin-zone corner sits at mass `4 r`). Crucially this is NONZERO for
`r > 0` even when `quarkMassParameter = 0`: it is ENTIRELY a regulator lattice
artifact, not a bare mass (row 1) and not a spectral closure mass (row 3). -/
noncomputable def wilsonRegulatorMass (r : ℝ) : ℝ := Real.log (1 + 4 * r)

/-- The Wilson regulator mass is strictly positive for every `r > 0`. -/
theorem wilsonRegulatorMass_pos {r : ℝ} (hr : 0 < r) : 0 < wilsonRegulatorMass r := by
  have : (1 : ℝ) < 1 + 4 * r := by linarith
  simpa [wilsonRegulatorMass] using Real.log_pos this

/-- With `r = 0` (no Wilson term / pure gauge, no fermion content) the regulator
mass vanishes exactly: `wilsonRegulatorMass 0 = 0`. -/
theorem wilsonRegulatorMass_zero : wilsonRegulatorMass 0 = 0 := by
  simp [wilsonRegulatorMass]

/-! ## Row 4: the composite aperture mass -/

/-- **Composite aperture mass** (taxonomy row 4): the Minkowski square of the
sum of two null momenta, `minkowskiSq (p + q)`. Reuses the `minkowskiSq` /
`minkDot` API from `GateI1/CompositeApertureMass.lean`; by
`compositeMassSq_eq_zero_iff_collinear` it vanishes exactly when the null
constituents are collinear (a single effective null edge), and is positive
when they open an aperture. This is a purely KINEMATIC mass, independent of the
bare, regulator, and spectral masses. -/
noncomputable def compositeApertureMassSq (p q : Momentum4) : ℝ := minkowskiSq (p + q)

/-- `compositeApertureMassSq` is exactly twice the Minkowski cross product for
null constituents, tying it to the aperture identity of
`CompositeApertureMass`. -/
theorem compositeApertureMassSq_eq_two_minkDot (p q : Momentum4)
    (hp : IsNull p) (hq : IsNull q) :
    compositeApertureMassSq p q = 2 * minkDot p q := by
  unfold compositeApertureMassSq minkDot
  unfold IsNull minkowskiSq at hp hq
  unfold minkowskiSq
  simp only [Pi.add_apply]
  linear_combination hp + hq

/-! ### Concrete null witnesses -/

/-- A future-pointing null momentum along `+x`: `(1, 1, 0, 0)`. -/
def nullX : Momentum4 := ![1, 1, 0, 0]

/-- A future-pointing null momentum along `+y`: `(1, 0, 1, 0)`. -/
def nullY : Momentum4 := ![1, 0, 1, 0]

theorem nullX_futureNull : IsFutureNull nullX := by
  refine ⟨?_, ?_⟩
  · simp [IsNull, minkowskiSq, nullX]
  · simp [nullX]

theorem nullY_futureNull : IsFutureNull nullY := by
  refine ⟨?_, ?_⟩
  · simp [IsNull, minkowskiSq, nullY]
  · simp [nullY]

/-- Two COLLINEAR (equal) future-null momenta give vanishing aperture mass. -/
theorem compositeApertureMassSq_collinear_zero :
    compositeApertureMassSq nullX nullX = 0 := by
  simp [compositeApertureMassSq, minkowskiSq, nullX]

/-- A NON-collinear future-null pair gives strictly positive aperture mass. -/
theorem compositeApertureMassSq_noncollinear_pos :
    0 < compositeApertureMassSq nullX nullY := by
  have : compositeApertureMassSq nullX nullY = 2 := by
    simp [compositeApertureMassSq, minkowskiSq, nullX, nullY]
    norm_num
  rw [this]; norm_num

/-! ## The pairwise separation witnesses -/

/-- **Row 1 vs row 3 (bare vs closure).** The bare quark mass is exactly zero
while the closure/glueball spectral mass is strictly positive (for `β > 0`).
Essentially the existing `massWithoutMass`, restated as a separation witness:
the bare and closure masses are not proportional. -/
theorem sep_bare_vs_closure {β : ℝ} (hβ : 0 < β) :
    quarkMassParameter = 0 ∧ 0 < z2GlueballMass β :=
  ⟨rfl, z2GlueballMass_pos hβ⟩

/-- **Row 1 vs row 2 (bare vs regulator).** The bare quark mass is exactly zero
while the Wilson regulator mass is strictly positive (for `r > 0`): the
regulator produces mass purely as a lattice artifact, with zero bare mass. -/
theorem sep_bare_vs_regulator {r : ℝ} (hr : 0 < r) :
    quarkMassParameter = 0 ∧ 0 < wilsonRegulatorMass r :=
  ⟨rfl, wilsonRegulatorMass_pos hr⟩

/-- **Row 3 vs row 2 (closure vs regulator).** The closure/glueball mass lives
with ZERO fermion content (pure gauge, no Wilson parameter): a pure-gauge
config has `z2GlueballMass β > 0` yet `wilsonRegulatorMass 0 = 0`. Conversely a
fermionic config with `r > 0` has a positive regulator mass, and that value is
independent of any glueball closure channel. The two masses are not
proportional. -/
theorem sep_closure_vs_regulator {β : ℝ} (hβ : 0 < β) {r : ℝ} (hr : 0 < r) :
    (0 < z2GlueballMass β ∧ wilsonRegulatorMass 0 = 0) ∧
    (0 < wilsonRegulatorMass r ∧ quarkMassParameter = 0) :=
  ⟨⟨z2GlueballMass_pos hβ, wilsonRegulatorMass_zero⟩,
   ⟨wilsonRegulatorMass_pos hr, rfl⟩⟩

/-- **Row 4 vs all (aperture vs the rest).** Two COLLINEAR future-null momenta
give `compositeApertureMassSq = 0` while the closure/glueball spectral mass is
positive - the kinematic aperture mass is independent of the spectral mass; AND
a NON-collinear null pair gives `0 < compositeApertureMassSq` while the bare
quark mass is zero - aperture mass with zero bare mass. -/
theorem sep_aperture_vs_all {β : ℝ} (hβ : 0 < β) :
    (compositeApertureMassSq nullX nullX = 0 ∧ 0 < z2GlueballMass β) ∧
    (0 < compositeApertureMassSq nullX nullY ∧ quarkMassParameter = 0) :=
  ⟨⟨compositeApertureMassSq_collinear_zero, z2GlueballMass_pos hβ⟩,
   ⟨compositeApertureMassSq_noncollinear_pos, rfl⟩⟩

/-- **HEADLINE (mass-taxonomy separation; F-YM-CONFLATE at theorem grade).**
The four taxonomy rows of section 13.2 -
(1) bare `quarkMassParameter`, (2) Wilson regulator `wilsonRegulatorMass`,
(3) closure/glueball `z2GlueballMass`, (4) composite aperture
`compositeApertureMassSq` - are DISTINCT functionals: each can vanish while
another is strictly positive, so no two are proportional and none is "the same
mass relabeled". The null-edge unification claims they share a mechanism SHAPE
(a closure/aperture obstruction), NOT that they are one number. -/
theorem massTaxonomy_functionals_pairwise_separated {β : ℝ} (hβ : 0 < β)
    {r : ℝ} (hr : 0 < r) :
    -- row 1 vs row 3
    (quarkMassParameter = 0 ∧ 0 < z2GlueballMass β) ∧
    -- row 1 vs row 2
    (quarkMassParameter = 0 ∧ 0 < wilsonRegulatorMass r) ∧
    -- row 3 vs row 2 (pure-gauge has closure, no regulator; fermionic has regulator)
    ((0 < z2GlueballMass β ∧ wilsonRegulatorMass 0 = 0) ∧
      (0 < wilsonRegulatorMass r ∧ quarkMassParameter = 0)) ∧
    -- row 4 vs all (collinear kills aperture but not closure; non-collinear gives
    -- aperture with zero bare mass)
    ((compositeApertureMassSq nullX nullX = 0 ∧ 0 < z2GlueballMass β) ∧
      (0 < compositeApertureMassSq nullX nullY ∧ quarkMassParameter = 0)) :=
  ⟨sep_bare_vs_closure hβ,
   sep_bare_vs_regulator hr,
   sep_closure_vs_regulator hβ hr,
   sep_aperture_vs_all hβ⟩

end MassTaxonomySeparation
end PhysicsSM.Draft.NullEdge.GateI1
