import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# Suite D rung D5 — Compton length floor via the SQUARED width (`widthSq`)

Re-derivation of the finite Compton bound stated **entirely rationally** through the
*squared* localization width `widthSq`.  No `Real.sqrt`, no `Complex`, no
transcendentals appear anywhere: every object lives in `ℚ` and every proof is
`ring` / `norm_num` / `nlinarith` / `positivity` over the rationals.

## Set-up

A two-point Connes carrier with mass `m > 0` has its points at Connes coordinates
`x0 = 0` and `x1 = 1/m`, with midpoint `midc = 1/(2 m)`; the causal (Connes)
distance between the two points is `dCausal m = 1/m`.

A state is described by its **probabilities** `p : Fin 2 → ℚ`, where `p i = ψ i ^ 2`
is the squared amplitude of the `i`-th point.  Working with the squared amplitudes
(rather than the amplitudes `ψ`) is exactly what keeps everything rational: the
optimizer, whose amplitudes are the irrational `(1/√2, 1/√2)`, has the perfectly
rational probability vector `p = (1/2, 1/2)`.

The squared localization width is the rational quadratic form
`widthSq m p = p 0 * (x0 - midc)^2 + p 1 * (x1 - midc)^2 = (p 0 + p 1) / (4 m^2)`.

The `J`-positive unit sector is cut out by the **squared** Krein / `σ_x` condition
`kreinFormSq p = 4 * p 0 * p 1 = 1`, which is `(2 ψ₀ ψ₁)^2 = 1`, together with the
positivity `0 ≤ p 0`, `0 ≤ p 1` of the probabilities.  Single-point states have
`kreinFormSq = 0` and are excluded.
-/

namespace SuiteD_ComptonSq

/-- Connes coordinate of point `0`. -/
def x0 : ℚ := 0

/-- Connes coordinate of point `1`, at spectral distance `1/m` from point `0`. -/
def x1 (m : ℚ) : ℚ := 1 / m

/-- Midpoint of the two Connes coordinates. -/
def midc (m : ℚ) : ℚ := 1 / (2 * m)

/-- Causal (Connes) distance between the two points. -/
def dCausal (m : ℚ) : ℚ := 1 / m

/-- The squared real Krein / `σ_x` form `(2 ψ₀ ψ₁)^2 = 4 p₀ p₁`, written in terms of
the probabilities `pᵢ = ψᵢ²`. -/
def kreinFormSq (p : Fin 2 → ℚ) : ℚ := 4 * p 0 * p 1

/-- The squared localization width of a probability state `p` (with `pᵢ = ψᵢ²`). -/
def widthSq (m : ℚ) (p : Fin 2 → ℚ) : ℚ :=
  p 0 * (x0 - midc m) ^ 2 + p 1 * (x1 m - midc m) ^ 2

/-- The `J`-positive unit sector: nonnegative probabilities with squared Krein form `1`. -/
def UnitSector (p : Fin 2 → ℚ) : Prop :=
  0 ≤ p 0 ∧ 0 ≤ p 1 ∧ kreinFormSq p = 1

/-- The optimizer, stated rationally through its probabilities `p₀ = p₁ = 1/2`
(the amplitudes are the irrational `(1/√2, 1/√2)`). -/
def psiStar : Fin 2 → ℚ := ![1/2, 1/2]

/-- Closed form of the squared width: `widthSq m p = (p₀ + p₁) / (4 m²)`. -/
lemma widthSq_eq (m : ℚ) (hm : m ≠ 0) (p : Fin 2 → ℚ) :
    widthSq m p = (p 0 + p 1) / (4 * m ^ 2) := by
  unfold widthSq x0 x1 midc
  field_simp
  ring

/-- **Target 1.** On the Krein-positive unit sector, the squared norms sum to at
least one: `p₀ + p₁ ≥ 1` (`= ψ₀² + ψ₁² ≥ 1`), by AM–GM `sq_nonneg (p₀ - p₁)`. -/
theorem normSq_sum_ge_one (p : Fin 2 → ℚ) (h : UnitSector p) :
    1 ≤ p 0 + p 1 := by
  obtain ⟨h0, h1, hk⟩ := h
  unfold kreinFormSq at hk
  nlinarith [sq_nonneg (p 0 - p 1), h0, h1, hk]

/-- **Target 2 (Compton length floor).** Every unit-sector state has squared width
at least `1/(4 m²)`, i.e. `width ≥ (1/2)/m` — the mass gap is a length floor. -/
theorem compton_floor_sq (m : ℚ) (hm : 0 < m) (p : Fin 2 → ℚ)
    (h : UnitSector p) : 1 / (4 * m ^ 2) ≤ widthSq m p := by
  rw [widthSq_eq m (ne_of_gt hm) p]
  have hs : (1 : ℚ) ≤ p 0 + p 1 := normSq_sum_ge_one p h
  gcongr

/-- The optimizer lies in the unit sector: `4 * (1/2) * (1/2) = 1`. -/
theorem psiStar_unitSector : UnitSector psiStar := by
  refine ⟨?_, ?_, ?_⟩ <;> norm_num [psiStar, kreinFormSq]

/-- **Target 3 (tightness of the floor).** The optimizer `p₀ = p₁ = 1/2` saturates
the floor: `widthSq m psiStar = 1/(4 m²)`. -/
theorem compton_floor_tight_sq (m : ℚ) (hm : m ≠ 0) :
    widthSq m psiStar = 1 / (4 * m ^ 2) := by
  rw [widthSq_eq m hm psiStar]
  norm_num [psiStar]

/-- **Mandatory fixture.** A specific nonzero rational value: `widthSq 3 psiStar = 1/36`. -/
theorem widthSq_three_psiStar : widthSq 3 psiStar = 1 / 36 := by
  rw [compton_floor_tight_sq 3 (by norm_num)]
  norm_num

/-- **Target 4.** The squared localization floor is a quarter of the squared Connes
distance: `widthSq m psiStar = (1/4) * (1/m)² = (1/4) * dCausal m ²`.  The `1/2`
structural constant appears squared. -/
theorem compton_scale_eq_spectral_distance_sq (m : ℚ) (hm : m ≠ 0) :
    widthSq m psiStar = (1 / 4) * (dCausal m) ^ 2 := by
  rw [compton_floor_tight_sq m hm, dCausal]
  field_simp

/-- **Kill target.** No unit-sector state undercuts the squared Compton floor: there
is no `p` in the unit sector with `widthSq m p < 1/(4 m²)`. -/
theorem no_sub_compton_sq (m : ℚ) (hm : 0 < m) :
    ¬ ∃ p : Fin 2 → ℚ, UnitSector p ∧ widthSq m p < 1 / (4 * m ^ 2) := by
  rintro ⟨p, hsec, hlt⟩
  exact absurd (compton_floor_sq m hm p hsec) (not_le.mpr hlt)

/-! ## Axiom footprint audits -/

/-- info: 'SuiteD_ComptonSq.normSq_sum_ge_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normSq_sum_ge_one

/-- info: 'SuiteD_ComptonSq.compton_floor_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms compton_floor_sq

/-- info: 'SuiteD_ComptonSq.compton_floor_tight_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms compton_floor_tight_sq

/-- info: 'SuiteD_ComptonSq.widthSq_three_psiStar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms widthSq_three_psiStar

/-- info: 'SuiteD_ComptonSq.compton_scale_eq_spectral_distance_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms compton_scale_eq_spectral_distance_sq

/-- info: 'SuiteD_ComptonSq.no_sub_compton_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_sub_compton_sq

end SuiteD_ComptonSq
