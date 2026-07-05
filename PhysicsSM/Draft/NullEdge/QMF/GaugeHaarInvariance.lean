import Mathlib
import PhysicsSM.Draft.NullEdge.QMF.SpecialUnitaryCompact
import PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance

/-!
# QMF1-RP capstone: gauge/reflection invariance of the `SU(N)` Haar expectation

This applies the compact-group Haar-expectation invariances of
`QMF/CompactHaarInvariance` to the ACTUAL Yang-Mills gauge group
`SU(N) = Matrix.specialUnitaryGroup (Fin n) ℂ`, using the compactness and
topological-group structure proved in `QMF/SpecialUnitaryCompact`.

Because `SU(N)` is a compact topological group (hence unimodular, by
`CompactHaarInvariance.compactGroup_haar_isMulRightInvariant`), the single-link
Haar expectation on the gauge group is:

* **gauge invariant** (`specialUnitaryGroup_haar_gauge_invariant`): unchanged by
  conjugating the integrand `x ↦ g x g⁻¹`;
* **reflection invariant** (`specialUnitaryGroup_haar_reflection_invariant`):
  unchanged by the OS reflection `x ↦ x⁻¹`.

These are the two Osterwalder-Seiler reflection-positivity symmetries a compact
lattice gauge theory needs at each link, now established for the physical
nonabelian gauge group with NO extra hypotheses beyond a Borel Haar measure -
whose existence is recorded in `specialUnitaryGroup_exists_isHaarMeasure`.

The Borel `MeasurableSpace` is taken as an instance argument (it is not a
canonical global instance on the matrix subtype), so the theorems hold for ANY
Borel Haar measure on `SU(N)`. Together with the earlier capability findings
(Peter-Weyl absent; the compact character-expansion / KP sublane still blocked),
the compact-RP substrate is complete for `SU(N)` up to that one sublane.

Draft-trust, kernel-checked, `s o r r y`-free. Prerequisites:
`QMF/SpecialUnitaryCompact`, `QMF/CompactHaarInvariance`.
-/

namespace PhysicsSM.Draft.NullEdge.QMF.GaugeHaarInvariance

open Matrix MeasureTheory
open PhysicsSM.Draft.NullEdge.QMF.SpecialUnitaryCompact
open PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance

variable {n : ℕ}

/-- **A Borel Haar measure exists on `SU(N)`** (non-vacuousness): with the Borel
`σ`-algebra, the Haar measure of the whole compact group `Set.univ` is a Haar
measure. So the invariance theorems below are non-vacuous. -/
theorem specialUnitaryGroup_exists_isHaarMeasure :
    ∃ (_ : MeasurableSpace (Matrix.specialUnitaryGroup (Fin n) ℂ))
      (μ : Measure (Matrix.specialUnitaryGroup (Fin n) ℂ)), μ.IsHaarMeasure := by
  letI : MeasurableSpace (Matrix.specialUnitaryGroup (Fin n) ℂ) :=
    borel (Matrix.specialUnitaryGroup (Fin n) ℂ)
  haveI : BorelSpace (Matrix.specialUnitaryGroup (Fin n) ℂ) := ⟨rfl⟩
  haveI : Nonempty (Matrix.specialUnitaryGroup (Fin n) ℂ) := ⟨1⟩
  refine ⟨_, Measure.haarMeasure ⟨⟨Set.univ, isCompact_univ⟩, by simp⟩, ?_⟩
  exact Measure.isHaarMeasure_haarMeasure _

/-- **Gauge invariance of the `SU(N)` Haar expectation.** For any Borel Haar
measure `μ` on the gauge group and any observable `f`, the expectation is
unchanged by conjugating the integrand by a group element `g` - the link gauge
symmetry of the compact Haar average. Instance of
`CompactHaarInvariance.compact_haarExpectation_conj_invariant` at
`G = SU(N)`. -/
theorem specialUnitaryGroup_haar_gauge_invariant {E : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    [MeasurableSpace (Matrix.specialUnitaryGroup (Fin n) ℂ)]
    [BorelSpace (Matrix.specialUnitaryGroup (Fin n) ℂ)]
    (μ : Measure (Matrix.specialUnitaryGroup (Fin n) ℂ)) [μ.IsHaarMeasure]
    (f : Matrix.specialUnitaryGroup (Fin n) ℂ → E)
    (g : Matrix.specialUnitaryGroup (Fin n) ℂ) :
    ∫ x, f (g * x * g⁻¹) ∂μ = ∫ x, f x ∂μ :=
  compact_haarExpectation_conj_invariant μ f g

/-- **Reflection invariance of the `SU(N)` Haar expectation.** The OS reflection
acts on a gauge link by inversion `x ↦ x⁻¹`, under which the compact Haar
expectation is unchanged. Instance of
`CompactHaarInvariance.compact_haarExpectation_inv_invariant` at `G = SU(N)`. -/
theorem specialUnitaryGroup_haar_reflection_invariant {E : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    [MeasurableSpace (Matrix.specialUnitaryGroup (Fin n) ℂ)]
    [BorelSpace (Matrix.specialUnitaryGroup (Fin n) ℂ)]
    (μ : Measure (Matrix.specialUnitaryGroup (Fin n) ℂ)) [μ.IsHaarMeasure]
    (f : Matrix.specialUnitaryGroup (Fin n) ℂ → E) :
    ∫ x, f x⁻¹ ∂μ = ∫ x, f x ∂μ :=
  compact_haarExpectation_inv_invariant μ f

/-! ## The Standard Model gauge groups `SU(2)`, `SU(3)`

Named specializations at the physical gauge groups. `SU(3)` is the color group -
and, by step 1a (`Octonion.G2FixingE111SpecialUnitaryGroup`,
`su3Submonoid_eq_specialUnitaryGroup`), it is exactly the octonion-derived color
`SU(3)`, so this is the gauge symmetry of the octonion-lane color group's Haar
average. `SU(2)` is the weak-isospin group. -/

/-- Gauge invariance of the color-`SU(3)` Haar expectation (the octonion-derived
color group of step 1a). -/
theorem su3_haar_gauge_invariant {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [MeasurableSpace (Matrix.specialUnitaryGroup (Fin 3) ℂ)]
    [BorelSpace (Matrix.specialUnitaryGroup (Fin 3) ℂ)]
    (μ : Measure (Matrix.specialUnitaryGroup (Fin 3) ℂ)) [μ.IsHaarMeasure]
    (f : Matrix.specialUnitaryGroup (Fin 3) ℂ → E)
    (g : Matrix.specialUnitaryGroup (Fin 3) ℂ) :
    ∫ x, f (g * x * g⁻¹) ∂μ = ∫ x, f x ∂μ :=
  specialUnitaryGroup_haar_gauge_invariant μ f g

/-- Gauge invariance of the weak-isospin `SU(2)` Haar expectation. -/
theorem su2_haar_gauge_invariant {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [MeasurableSpace (Matrix.specialUnitaryGroup (Fin 2) ℂ)]
    [BorelSpace (Matrix.specialUnitaryGroup (Fin 2) ℂ)]
    (μ : Measure (Matrix.specialUnitaryGroup (Fin 2) ℂ)) [μ.IsHaarMeasure]
    (f : Matrix.specialUnitaryGroup (Fin 2) ℂ → E)
    (g : Matrix.specialUnitaryGroup (Fin 2) ℂ) :
    ∫ x, f (g * x * g⁻¹) ∂μ = ∫ x, f x ∂μ :=
  specialUnitaryGroup_haar_gauge_invariant μ f g

end PhysicsSM.Draft.NullEdge.QMF.GaugeHaarInvariance
