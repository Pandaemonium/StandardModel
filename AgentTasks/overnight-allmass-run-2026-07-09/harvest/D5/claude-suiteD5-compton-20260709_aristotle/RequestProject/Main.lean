import Mathlib
import seeds.SuiteAOp2Geom

/-!
# Suite D rung D5 — a finite Compton bound: the mass gap is a length floor

We work on the two–point Krein carrier of `seeds/SuiteAOp2Geom.lean`
(`namespace SuiteA_Op2Geom`), whose fundamental symmetry is `J = σₓ` and whose
Krein-self-adjoint Dirac operator `D m` has causal spectral distance
`dCausal m 0 1 = 1/m` (the intrinsic Compton length of the carrier).

## The localization width

The two carrier points sit, in the intrinsic (Connes) metric, at coordinates
`x 0 = 0` and `x 1 = dCausal m 0 1 = 1/m`, with geometric midpoint
`c = 1/(2m)`.  For a codeword `ψ : Fin 2 → ℂ` we read localization as the spread
of the position observable `X = diag x` about the midpoint, i.e. the genuine
positive-semidefinite quadratic form

`width(ψ)² = ⟨ψ| (X - c·I)² |ψ⟩ = Σᵢ |ψ i|² · (x i - c)²`.

## The `J`-positive normalized sector

Physical one-particle codewords live in the positive sector of the indefinite
Krein metric and are normalized there:

`⟨ψ|J ψ⟩ = 1`, i.e. `kreinForm ψ = 1`  (`JNormalized ψ`).

This is `> 0` (positive sector) and unit (normalized).  Note that a state sharply
localized at a single point (`ψ = e₀` or `ψ = e₁`) has `⟨ψ|Jψ⟩ = 0`, so it is
*isotropic*, not `J`-positive: it never satisfies `JNormalized`.

## Results

* `compton_floor` : `width m ψ ≥ c/m` with explicit constant `c = 1/2`, for every
  `J`-positive normalized `ψ`.
* `compton_floor_tight` : the optimizer `ψ⋆ = (1/√2, 1/√2)` saturates it,
  `width m ψ⋆ = c/m`, with the mandatory non-degeneracy fixture `width 3 ψ⋆ = 1/6`.
* `compton_scale_eq_spectral_distance` : the achieved floor equals
  `(1/2)·dCausal m 0 1`, so the localization floor *is* the Connes distance
  (exact, up to the explicit constant `c = 1/2`).
* Kills: no `J`-positive normalized state beats the floor, and the floor is a
  strictly positive, mass-dependent length.

All headline theorems are kernel-checked with axiom footprint
`[propext, Classical.choice, Quot.sound]`, verified in-file.
-/

open scoped ComplexOrder Matrix

namespace SuiteD_Compton

/-! ## The Krein form and the `J`-positive normalized sector -/

/-- The Krein form `⟨ψ|J ψ⟩` for `J = σₓ` on the two–point carrier. -/
noncomputable def kreinForm (ψ : Fin 2 → ℂ) : ℂ :=
  star (ψ 0) * ψ 1 + star (ψ 1) * ψ 0

/-- The Krein form is the genuine `J`-inner product `⟨ψ, J ψ⟩` of the seed's `J`. -/
theorem kreinForm_eq_Jc (ψ : Fin 2 → ℂ) :
    kreinForm ψ = star ψ ⬝ᵥ (SuiteA_Op2Geom.Jc *ᵥ ψ) := by
  unfold SuiteA_Op2Geom.Jc kreinForm
  norm_num [Fin.sum_univ_succ, Matrix.mulVec]
  ring_nf
  rfl

/-- Membership in the normalized `J`-positive sector: `⟨ψ|J ψ⟩ = 1`. -/
def JNormalized (ψ : Fin 2 → ℂ) : Prop := kreinForm ψ = 1

/-! ## The position observable and the localization width -/

/-- Intrinsic coordinates of the two carrier points: `x 0 = 0`, `x 1 = 1/m`
(`= dCausal m 0 1`). -/
noncomputable def xcoord (m : ℝ) : Fin 2 → ℝ := ![0, 1 / m]

/-- Geometric midpoint of the two carrier points. -/
noncomputable def xcenter (m : ℝ) : ℝ := 1 / (2 * m)

/-- The localization width squared: the spread of the position observable about the
midpoint, a genuine positive-semidefinite quadratic form
`Σᵢ |ψ i|² · (x i - c)²`. -/
noncomputable def widthSq (m : ℝ) (ψ : Fin 2 → ℂ) : ℝ :=
  ∑ i, Complex.normSq (ψ i) * (xcoord m i - xcenter m) ^ 2

/-- The localization width. -/
noncomputable def width (m : ℝ) (ψ : Fin 2 → ℂ) : ℝ := Real.sqrt (widthSq m ψ)

/-- `widthSq` in closed form: the position spread collapses to the scalar
`1/(4m²)` times the (Hilbert) norm² — the midpoint is the unique center for which
the position spread is bounded below on the Krein sphere. -/
theorem widthSq_eq (m : ℝ) (ψ : Fin 2 → ℂ) :
    widthSq m ψ = (Complex.normSq (ψ 0) + Complex.normSq (ψ 1)) / (4 * m ^ 2) := by
  unfold widthSq xcoord xcenter
  norm_num [Fin.sum_univ_two]
  ring

/-! ## The core uncertainty bound -/

/-- On the normalized `J`-positive sector the Hilbert norm² is at least `1`
(the Krein-positive unit hyperboloid stays outside the Hilbert unit ball). -/
theorem normSq_sum_ge_one {ψ : Fin 2 → ℂ} (h : JNormalized ψ) :
    (1 : ℝ) ≤ Complex.normSq (ψ 0) + Complex.normSq (ψ 1) := by
  unfold JNormalized kreinForm at h
  norm_num [Complex.ext_iff] at h
  norm_num [Complex.normSq, Complex.sq_norm] at *
  nlinarith [sq_nonneg ((ψ 0).re - (ψ 1).re), sq_nonneg ((ψ 0).im - (ψ 1).im)]

/-! ## Target 1 — the Compton floor -/

/-- **Compton floor (Target 1).** Every `J`-positive normalized codeword `ψ` has
localization width at least `c/m` with the explicit constant `c = 1/2`:
`width m ψ ≥ (1/2)/m`.  The mass gap is a hard floor on localization length. -/
theorem compton_floor (m : ℝ) (hm : 0 < m) {ψ : Fin 2 → ℂ} (h : JNormalized ψ) :
    (1 / 2) / m ≤ width m ψ := by
  refine Real.le_sqrt_of_sq_le ?_
  rw [widthSq_eq m ψ]
  ring_nf
  norm_num [hm.le]
  nlinarith [inv_pos.mpr (sq_pos_of_pos hm), normSq_sum_ge_one h]

/-! ## Target 2 — the floor is saturated -/

/-- The explicit optimizer `ψ⋆ = (1/√2, 1/√2)`. -/
noncomputable def psiStar : Fin 2 → ℂ := ![1 / Real.sqrt 2, 1 / Real.sqrt 2]

/-- The optimizer lies in the normalized `J`-positive sector. -/
theorem psiStar_JNormalized : JNormalized psiStar := by
  unfold JNormalized
  unfold kreinForm psiStar
  norm_num [Complex.ext_iff]
  ring_nf
  norm_num

/-- **Compton floor is tight (Target 2).** The optimizer saturates the floor:
`width m ψ⋆ = (1/2)/m`. -/
theorem compton_floor_tight (m : ℝ) (hm : 0 < m) :
    width m psiStar = (1 / 2) / m := by
  convert congr_arg Real.sqrt (widthSq_eq m psiStar) using 1
  norm_num [psiStar]
  ring_nf
  rw [Real.sqrt_sq hm.le]

/-- **Mandatory non-degeneracy fixture at `m = 3`.** The optimizer is `J`-positive
normalized and its width is the specific nonzero rational `1/6 = c/3`. -/
theorem compton_fixture_m3 :
    JNormalized psiStar ∧ width 3 psiStar = 1 / 6 :=
  ⟨psiStar_JNormalized, by rw [compton_floor_tight 3 (by norm_num)]; norm_num⟩

/-! ## Target 3 — the floor is the Connes distance -/

/-- **Floor = Connes distance (Target 3).** The achieved localization floor equals
`(1/2)·dCausal m 0 1`.  Since `dCausal m 0 1 = 1/m`, "mass gap = length floor" and
"mass = 1/distance" are the same statement — exact, up to the explicit constant
`c = 1/2`. -/
theorem compton_scale_eq_spectral_distance (m : ℝ) (hm : 0 < m) :
    width m psiStar = (1 / 2) * SuiteA_Op2Geom.dCausal m 0 1 := by
  rw [compton_floor_tight m hm, SuiteA_Op2Geom.dCausal_01 m hm]
  ring

/-! ## Kills -/

/-- **Kill avoided — no sub-Compton localization.** There is no `J`-positive
normalized codeword with width strictly below the floor `c/m`. -/
theorem no_sub_compton (m : ℝ) (hm : 0 < m) :
    ¬ ∃ ψ : Fin 2 → ℂ, JNormalized ψ ∧ width m ψ < (1 / 2) / m :=
  fun ⟨_, hψ₁, hψ₂⟩ => hψ₂.not_ge <| compton_floor m hm hψ₁

/-- **Kill avoided — the floor is a strictly positive length.** -/
theorem compton_floor_pos (m : ℝ) (hm : 0 < m) : 0 < (1 / 2) / m := by
  positivity

/-- **Kill avoided — the floor is genuinely mass-dependent** (the gap sets a
length): the floor at `m = 3` differs from the floor at `m = 1`. -/
theorem compton_floor_mass_dependent :
    width 3 psiStar ≠ width 1 psiStar := by
  rw [compton_floor_tight 3 (by norm_num), compton_floor_tight 1 (by norm_num)]
  norm_num

end SuiteD_Compton

/-! ## Axiom-footprint guards

Each headline result depends only on `[propext, Classical.choice, Quot.sound]`. -/

/-- info: 'SuiteD_Compton.compton_floor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteD_Compton.compton_floor

/-- info: 'SuiteD_Compton.compton_floor_tight' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteD_Compton.compton_floor_tight

/-- info: 'SuiteD_Compton.compton_fixture_m3' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteD_Compton.compton_fixture_m3

/-- info: 'SuiteD_Compton.compton_scale_eq_spectral_distance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteD_Compton.compton_scale_eq_spectral_distance

/-- info: 'SuiteD_Compton.no_sub_compton' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteD_Compton.no_sub_compton

/-- info: 'SuiteD_Compton.compton_floor_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteD_Compton.compton_floor_pos

/-- info: 'SuiteD_Compton.compton_floor_mass_dependent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteD_Compton.compton_floor_mass_dependent
