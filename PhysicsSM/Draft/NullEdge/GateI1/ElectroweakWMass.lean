import PhysicsSM.Draft.NullEdge.GateI1.ElectroweakRung

/-!
# NE-U6 extension: the `W` mass as a gauge-invariant transfer-spectrum feature

Extends `ElectroweakRung` (the NE-U6 electroweak rung on the `Z2`/finite slab).
This module formalizes the honest finite statement behind "the `W`-mass is a
transfer-spectrum feature of a gauge-invariant composite operator":

* the symmetric `2 x 2` composite transfer operator (reused verbatim as
  `ElectroweakRung.wCompositeTransfer beta = transfer2 (e^beta) (e^{-beta})`) has
  two genuine spectral sectors, realized by explicit eigenvectors:
  - a **neutral/vacuum** sector with top eigenvalue `vacuumEigenvalue beta =
    e^beta + e^{-beta} = 2 cosh beta` (symmetric eigenvector `(1, 1)`), and
  - a **charged (`W`-like)** sector with top eigenvalue `chargedEigenvalue beta =
    e^beta - e^{-beta} = 2 sinh beta` (antisymmetric eigenvector `(1, -1)`);
* the two sectors are **distinct** for every finite `beta > 0`
  (`chargedEigenvalue beta < vacuumEigenvalue beta`, both positive);
* the **`W`-mass gap** is `wMass beta = - log (chargedEigenvalue beta /
  vacuumEigenvalue beta)`, the minus-log ratio of the charged-sector top
  eigenvalue to the vacuum, and it is **strictly positive** for `beta > 0`;
* the gap coincides with the composite channel gap of the rung
  (`wMass beta = ElectroweakRung.wLikeMass beta = z2GlueballMass beta`), so it
  controls the exponential **two-point clustering** of the gauge-invariant
  composite `W` (`wChannel_clustering`, reusing the rung's
  `compositeTwoPoint_decay` / `compositeTwoPoint_total`);
* the charged sector is carried by the **gauge-invariant composite**
  `ElectroweakRung.wComposite`, so the extracted mass is **gauge-invariant**:
  independent of the gauge representative (`wMass_gauge_invariant`,
  `chargedSector_gauge_invariant`, reusing `wComposite_gauge_invariant`).

## Honest labels (HARD BOUNDARY)

Everything here is a **finite transfer-spectrum gap in a charged sector** of the
smallest `Z2` gauge-Higgs toy. It is **NOT** the physical electroweak `W` mass,
**NOT** the Higgs mechanism, and no continuum / numerical `W`-mass value is
asserted. The "charged/`W`-like" and "neutral/vacuum" labels are the two spectral
sectors of a `2 x 2` matrix; the gauge invariance is Elitzur-style closure of the
composite, not spontaneous symmetry breaking. Claim label: finite identity.

All final theorems are `sorry`/`axiom`/`native_decide`-free; the axiom footprint
is the Lean/Mathlib base (`propext`, `Classical.choice`, `Quot.sound`).
-/

open scoped Matrix

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace ElectroweakWMass

open PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass
open PhysicsSM.Draft.NullEdge.GateI1.ElectroweakRung

/-! ## The two spectral sectors of the composite transfer operator -/

/-- Top eigenvalue of the **neutral/vacuum** sector of the composite transfer
operator: `vacuumEigenvalue beta = e^beta + e^{-beta} = 2 cosh beta`, the
eigenvalue of the symmetric eigenvector `(1, 1)`. -/
noncomputable def vacuumEigenvalue (β : ℝ) : ℝ := Real.exp β + Real.exp (-β)

/-- Top eigenvalue of the **charged (`W`-like)** sector of the composite transfer
operator: `chargedEigenvalue beta = e^beta - e^{-beta} = 2 sinh beta`, the
eigenvalue of the antisymmetric eigenvector `(1, -1)`. -/
noncomputable def chargedEigenvalue (β : ℝ) : ℝ := Real.exp β - Real.exp (-β)

/-- The symmetric vector `(1, 1)` is an eigenvector of `transfer2 a b` with
eigenvalue `a + b` (the vacuum/neutral sector). -/
theorem transfer2_eigen_sym (a b : ℝ) :
    (transfer2 a b).mulVec ![1, 1] = (a + b) • (![1, 1] : Fin 2 → ℝ) := by
  funext i
  fin_cases i <;> simp [transfer2, Matrix.mulVec, dotProduct, add_comm]

/-- The antisymmetric vector `(1, -1)` is an eigenvector of `transfer2 a b` with
eigenvalue `a - b` (the charged/`W`-like sector). -/
theorem transfer2_eigen_antisym (a b : ℝ) :
    (transfer2 a b).mulVec ![1, -1] = (a - b) • (![1, -1] : Fin 2 → ℝ) := by
  funext i
  fin_cases i <;> simp [transfer2, Matrix.mulVec, dotProduct, sub_eq_add_neg]

/-- The vacuum eigenvalue is genuinely an eigenvalue of the composite transfer
operator `wCompositeTransfer beta`, via the symmetric eigenvector `(1, 1)`. -/
theorem vacuum_is_eigenvalue (β : ℝ) :
    (wCompositeTransfer β).mulVec ![1, 1] = vacuumEigenvalue β • (![1, 1] : Fin 2 → ℝ) := by
  rw [wCompositeTransfer_eq]
  exact transfer2_eigen_sym _ _

/-- The charged (`W`-like) eigenvalue is genuinely an eigenvalue of the composite
transfer operator `wCompositeTransfer beta`, via the antisymmetric eigenvector
`(1, -1)`. -/
theorem charged_is_eigenvalue (β : ℝ) :
    (wCompositeTransfer β).mulVec ![1, -1] = chargedEigenvalue β • (![1, -1] : Fin 2 → ℝ) := by
  rw [wCompositeTransfer_eq]
  exact transfer2_eigen_antisym _ _

/-! ## Positivity and distinctness of the two sectors -/

/-- The vacuum eigenvalue is strictly positive. -/
theorem vacuumEigenvalue_pos (β : ℝ) : 0 < vacuumEigenvalue β := by
  have := Real.exp_pos β
  have := Real.exp_pos (-β)
  simp only [vacuumEigenvalue]; linarith

/-- The charged eigenvalue is strictly positive for every finite `beta > 0`. -/
theorem chargedEigenvalue_pos {β : ℝ} (hβ : 0 < β) : 0 < chargedEigenvalue β := by
  have : Real.exp (-β) < Real.exp β := Real.exp_lt_exp.mpr (by linarith)
  simp only [chargedEigenvalue]; linarith

/-- **The two sectors are distinct.** The charged (`W`-like) top eigenvalue is
strictly below the vacuum top eigenvalue for every `beta` - the `W`-like sector
is a genuinely different spectral sector from the vacuum. (The strict separation
holds for all `beta`, since `vacuum - charged = 2 e^{-beta} > 0`; no `beta > 0`
hypothesis is needed.) -/
theorem charged_lt_vacuum (β : ℝ) :
    chargedEigenvalue β < vacuumEigenvalue β := by
  have := Real.exp_pos (-β)
  simp only [chargedEigenvalue, vacuumEigenvalue]; linarith

/-! ## The W-mass gap: minus-log ratio of charged to vacuum -/

/-- The **`W`-mass gap**: minus the log of the ratio of the charged-sector top
eigenvalue to the vacuum top eigenvalue,
`wMass beta = - log (chargedEigenvalue beta / vacuumEigenvalue beta)`. -/
noncomputable def wMass (β : ℝ) : ℝ :=
  - Real.log (chargedEigenvalue β / vacuumEigenvalue β)

/-- The `W`-mass gap equals the composite-channel gap of the rung,
`wMass beta = gap2 (e^beta) (e^{-beta})`: the minus-log ratio of charged to
vacuum is the log ratio of vacuum to charged. -/
theorem wMass_eq_gap2 (β : ℝ) :
    wMass β = gap2 (Real.exp β) (Real.exp (-β)) := by
  unfold wMass gap2 chargedEigenvalue vacuumEigenvalue
  rw [← Real.log_inv, inv_div]

/-- The `W`-mass gap is exactly the rung's `wLikeMass` (and hence the NE-U5
glueball gap): the same finite composite-channel transfer gap. -/
theorem wMass_eq_wLikeMass (β : ℝ) : wMass β = wLikeMass β := by
  rw [wMass_eq_gap2]; rfl

/-- The `W`-mass gap equals the NE-U5 `Z2` glueball gap - the shared
mechanism-SHAPE identity of the rung, restated for the `W`-mass gap. -/
theorem wMass_eq_glueballMass (β : ℝ) : wMass β = z2GlueballMass β := by
  rw [wMass_eq_gap2]; rfl

/-- **Headline positivity.** The charged (`W`-like) sector carries a STRICTLY
POSITIVE spectral gap for every finite `beta > 0`: a strictly positive `W`-like
mass as a transfer-spectrum feature, with zero primitive mass input. -/
theorem wMass_pos {β : ℝ} (hβ : 0 < β) : 0 < wMass β := by
  rw [wMass_eq_wLikeMass]; exact wLikeMass_pos hβ

/-! ## Two-point clustering of the gauge-invariant composite at rate `wMass` -/

/-- **Charged-channel clustering.** The normalized composite two-point
correlation at separation `n` decays exactly as `exp (- n * wMass beta)`:
`((T^n)_00 - (T^n)_01) / ((T^n)_00 + (T^n)_01) = exp (- n * wMass beta)`, where
`T = wCompositeTransfer beta`. The `W`-mass gap is the exponential clustering
rate of the gauge-invariant composite `W`. Reuses the rung's
`compositeTwoPoint_decay` and `compositeTwoPoint_total`. -/
theorem wChannel_clustering {β : ℝ} (hβ : 0 < β) (n : ℕ) :
    (((wCompositeTransfer β) ^ n) 0 0 - ((wCompositeTransfer β) ^ n) 0 1)
      / (((wCompositeTransfer β) ^ n) 0 0 + ((wCompositeTransfer β) ^ n) 0 1)
      = Real.exp (- (n : ℝ) * wMass β) := by
  rw [Frozen.compositeTwoPoint_decay hβ n, Frozen.compositeTwoPoint_total hβ n]
  have hlt : Real.exp (-β) < Real.exp β := Real.exp_lt_exp.mpr (by linarith)
  have hnum : 0 < Real.exp β - Real.exp (-β) := by linarith
  have hr : 0 < (Real.exp β - Real.exp (-β)) / (Real.exp β + Real.exp (-β)) := by positivity
  have hexp : - (n : ℝ) * wMass β
      = (n : ℝ) * Real.log ((Real.exp β - Real.exp (-β)) / (Real.exp β + Real.exp (-β))) := by
    simp only [wMass, chargedEigenvalue, vacuumEigenvalue]; ring
  rw [hexp, Real.exp_nat_mul, Real.exp_log hr, div_pow]

/-! ## Gauge invariance: the charged sector is carried by the composite -/

/-- The **charged-sector observable** attached to a configuration: the value of
the gauge-invariant composite `wComposite` (which labels the charged vs neutral
content) paired with the extracted `W`-mass gap. -/
noncomputable def chargedSector (φ : Fin 2 → Bool) (U : Bool) (β : ℝ) : Bool × ℝ :=
  (wComposite φ U, wMass β)

/-- **Gauge invariance of the charged sector.** For every gauge transformation
`g`, every configuration `(phi, U)`, and every `beta`, the charged-sector
observable is unchanged: the charged content is carried by the gauge-invariant
composite `wComposite`, so both the sector label and the extracted `W`-mass are
independent of the gauge representative. Reuses
`ElectroweakRung.wComposite_gauge_invariant`. -/
theorem chargedSector_gauge_invariant (β : ℝ) (g φ : Fin 2 → Bool) (U : Bool) :
    chargedSector (gaugeHiggs g φ) (gaugeLink g U) β = chargedSector φ U β := by
  simp only [chargedSector, wComposite_gauge_invariant]

/-- **Gauge invariance of the `W`-mass.** The extracted `W`-mass gap is a
gauge-invariant spectral feature: it does not depend on the gauge representative
of the underlying configuration. (Immediate here since `wMass` is a function of
the coupling only, but stated at the config level, and tied to the composite
sector by `chargedSector_gauge_invariant`.) -/
theorem wMass_gauge_invariant (β : ℝ) (g φ : Fin 2 → Bool) (U : Bool) :
    (chargedSector (gaugeHiggs g φ) (gaugeLink g U) β).2 = wMass β := by
  rw [chargedSector_gauge_invariant]; rfl

/-! ## Bundled headline -/

/-- **NE-U6 `W`-mass headline (extension of the electroweak rung).** In the
smallest finite `Z2` gauge-Higgs toy, at any coupling `beta > 0`:

1. the composite transfer operator has two genuine spectral sectors realized by
   explicit eigenvectors - a neutral/vacuum sector (top eigenvalue
   `vacuumEigenvalue beta`, eigenvector `(1,1)`) and a charged `W`-like sector
   (top eigenvalue `chargedEigenvalue beta`, eigenvector `(1,-1)`);
2. the two sectors are distinct: `chargedEigenvalue beta < vacuumEigenvalue beta`;
3. the `W`-mass gap `wMass beta = - log (charged / vacuum)` is STRICTLY POSITIVE;
4. it equals the rung's composite-channel gap `wLikeMass beta`, hence controls the
   two-point clustering of the gauge-invariant composite `W`;
5. the charged sector - carried by the gauge-invariant composite `wComposite` -
   and the extracted `W`-mass are GAUGE-INVARIANT.

Honest label: a finite transfer-spectrum gap in a charged sector, NOT the
physical electroweak `W` mass or the Higgs mechanism. -/
theorem electroweakWMass {β : ℝ} (hβ : 0 < β) :
    (wCompositeTransfer β).mulVec ![1, 1] = vacuumEigenvalue β • (![1, 1] : Fin 2 → ℝ) ∧
      (wCompositeTransfer β).mulVec ![1, -1]
        = chargedEigenvalue β • (![1, -1] : Fin 2 → ℝ) ∧
      chargedEigenvalue β < vacuumEigenvalue β ∧
      0 < wMass β ∧
      wMass β = wLikeMass β ∧
      (∀ g φ U, chargedSector (gaugeHiggs g φ) (gaugeLink g U) β = chargedSector φ U β) :=
  ⟨vacuum_is_eigenvalue β, charged_is_eigenvalue β, charged_lt_vacuum β, wMass_pos hβ,
    wMass_eq_wLikeMass β, fun g φ U => chargedSector_gauge_invariant β g φ U⟩

end ElectroweakWMass
end PhysicsSM.Draft.NullEdge.GateI1
