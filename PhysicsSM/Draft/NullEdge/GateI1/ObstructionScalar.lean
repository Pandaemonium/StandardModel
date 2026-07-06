import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Core
import PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
import PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass

/-!
# Gate I1: the THIRD cross-mode binding attempt - a shared `ObstructionScalar`

The strategic frontier of the null-edge mass thesis is whether the three
obstruction modes - **turn** (T), **aperture** (A), **closure** (C) - can be
made to share a *quantity*, not merely a prose analogy. Two of them are already
bound on a shared carrier:

* (A=T) `ApertureEqualsTurn.apertureEqualsTurn_onShell` and
  `CompositeApertureMass.compositeMassSq_eq_zero_iff_collinear` put the aperture
  mass `2 * minkDot kPlus kMinus = m^2` and the chirality-even turn coefficient
  on ONE on-shell `Momentum4`.

The closure mode (C) lives in a DIFFERENT model:

* (C) `MassWithoutMass.z2GlueballMass beta = -log (tanh beta) = log (coth beta)`,
  `SlabTransferGap.neU4_closure_gap_pos` - a Z2 transfer-eigenvalue-ratio gap
  with NO `Momentum4` at all.

The honest baseline verdict (strategy `97a015dd`, kill-test note) is that (C) and
(A) currently share NO model: `z2GlueballMass` has no `Momentum4`, so the most
one could claim by prose was "shared SHAPE, not shared quantity."

## What this module proves (the strongest HONEST form)

We upgrade "shared shape" from prose to a Lean structure that BOTH rows provably
instantiate. `ObstructionScalar` bundles:

* a `domain` of admissible **return ratios** with `1` a member (full return),
* a return ratio `ret <= 1`,
* an obstruction functional `f` that is **strictly antitone** on the domain and
  **vanishes at full return** (`f 1 = 0`).

Its `value := f ret` then satisfies, by TWO structural theorems proved once for
all instances:

* `value_nonneg` : the obstruction is nonnegative;
* `value_eq_zero_iff_full_return` : **massless iff degenerate** -
  `value = 0 <-> ret = 1`.

Both physical rows are genuine instances:

* `closure_isObstructionScalar` : with return ratio `ret = tanh beta`
  (`= lambdaFlux / lambda0`, the excited/vacuum Z2 transfer-eigenvalue ratio) and
  functional `f rho = -log rho`, the value is exactly `z2GlueballMass beta`. Full
  return `ret -> 1` is the `beta -> infinity` decoupling degeneracy.
* `aperture_isObstructionScalar` : with return ratio
  `ret = spatialDot kPlus kMinus / (kPlus 0 * kMinus 0)` (the future-cone spatial
  overlap `cos theta`) and functional `f rho = (2 * kPlus 0 * kMinus 0) * (1 - rho)`,
  the value is exactly `2 * minkDot kPlus kMinus`, which on shell is `m^2`. Full
  return `ret = 1` is the collinear degeneracy (`minkDot = 0`, one null edge).

## KILL CONDITION and how it is enforced (read carefully)

The task's kill condition forbids a vacuous / definitional identification. This
module is scrupulous about what is and is NOT claimed:

* **NOT the same number.** The two instances use genuinely DIFFERENT functionals
  (`f rho = -log rho` for closure; the affine `f rho = scale * (1 - rho)` for
  aperture) on DIFFERENT domains and DIFFERENT carriers (a Z2 eigenvalue ratio vs
  a kinematic cosine). We never assert `z2GlueballMass beta = 2 * minkDot ...`.
* **No hidden cross-model map.** There is NO `Momentum4 -> Z2` or `Z2 ->
  Momentum4` map anywhere; the two `ret`s are built independently from each
  model's own data.
* **Non-definitional / non-vacuous.** `shared_property_needs_monotonicity` is the
  non-vacuity witness (in the style of
  `ChargeGradingMassCompatible.coupling_would_distinguish`): a generic candidate
  (`f = 0` constant, `ret = 1/2`) satisfies EVERY field of `ObstructionScalar`
  EXCEPT strict antitonicity, and for it "massless iff degenerate" FAILS
  (`value = 0` at `ret = 1/2 <> 1`). Hence the strict-antitone field is
  load-bearing: membership in `ObstructionScalar` is a real constraint, and the
  two instantiations carry content.

## HONEST VERDICT

This is a genuine shared STRUCTURE (a nonnegative, strictly-antitone-in-return,
vanishing-at-full-return obstruction functional) that both C and A provably
realize, upgrading the prose analogy to a single Lean definition with a single
proved "massless iff degenerate" law. It is **NOT** a shared quantity: the
functionals and carriers differ and no common `Momentum4`/`Z2` model exists. So
the strongest defensible claim remains **shared shape, now formalized and proved,
not shared quantity** - a documented, honest partial result.

## Claim discipline

Claim label: **reconstruction / speculative binding (draft-trust)**. No new
axioms, no `native_decide`, no statement weakening. Reuses `z2GlueballMass`,
`minkDot`, `minkowskiSq`, `spatialDot`, and the aperture/closure API. `s o r r y`-free.
Prerequisites: `GateI1.Core`, `GateI1.CompositeApertureMass`,
`GateI1.MassWithoutMass`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace ObstructionScalar

open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
open PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass

/-! ## 1. The abstract obstruction scalar and its two structural laws -/

/-- **The shared obstruction structure.** An obstruction scalar is a strictly
antitone functional `f` of a *return ratio* on a domain that contains the
full-return point `1`, together with a distinguished return ratio `ret <= 1`,
such that the obstruction vanishes exactly at full return (`f 1 = 0`).

The physical reading: `ret` measures how close the configuration is to the
degenerate "no obstruction" limit (full return `= 1`); `f` turns the return
deficit into the obstruction magnitude. The two structural theorems below then
give nonnegativity and "massless iff degenerate" once and for all. -/
structure _root_.PhysicsSM.Draft.NullEdge.GateI1.ObstructionScalar where
  /-- The domain of admissible return ratios. -/
  domain : Set ℝ
  /-- The obstruction functional (return ratio ↦ obstruction magnitude). -/
  f : ℝ → ℝ
  /-- The physical return ratio of this configuration. -/
  ret : ℝ
  /-- Full return `1` is admissible (it is the degeneracy point). -/
  one_mem : (1 : ℝ) ∈ domain
  /-- The physical return ratio is admissible. -/
  ret_mem : ret ∈ domain
  /-- The return ratio never exceeds full return. -/
  ret_le_one : ret ≤ 1
  /-- The obstruction vanishes at full return. -/
  f_one : f 1 = 0
  /-- More return means strictly less obstruction. -/
  f_strictAnti : StrictAntiOn f domain

/-- The obstruction value carried by an `ObstructionScalar`. -/
def value (O : ObstructionScalar) : ℝ := O.f O.ret

/-- **Structural law 1 (nonnegativity).** Every obstruction scalar is `>= 0`. -/
theorem value_nonneg (O : ObstructionScalar) : 0 ≤ O.value := by
  rcases eq_or_lt_of_le O.ret_le_one with h | h
  · simp [value, h, O.f_one]
  · have := O.f_strictAnti O.ret_mem O.one_mem h
    rw [O.f_one] at this
    exact le_of_lt this

/-- **Structural law 2 ("massless iff degenerate").** An obstruction scalar
vanishes exactly at full return. This is the single definition-level statement of
the "mass = relational obstruction" reading that BOTH the closure gap and the
aperture mass satisfy. -/
theorem value_eq_zero_iff_full_return (O : ObstructionScalar) :
    O.value = 0 ↔ O.ret = 1 := by
  constructor
  · intro hv
    by_contra hne
    have hlt : O.ret < 1 := lt_of_le_of_ne O.ret_le_one hne
    have := O.f_strictAnti O.ret_mem O.one_mem hlt
    rw [O.f_one] at this
    simp only [value] at hv
    linarith
  · intro h; simp [value, h, O.f_one]

/-! ## 2. The closure instance (C): the Z2 glueball gap -/

/-- `z2GlueballMass beta = -log (tanh beta)`: the closure gap written as the
`-log` of the excited/vacuum Z2 transfer-eigenvalue ratio `tanh beta =
lambdaFlux / lambda0`. -/
theorem z2GlueballMass_eq_neg_log_tanh (β : ℝ) :
    z2GlueballMass β = -Real.log (Real.tanh β) := by
  unfold z2GlueballMass gap2
  have htanh : Real.tanh β
      = (Real.exp β - Real.exp (-β)) / (Real.exp β + Real.exp (-β)) := by
    rw [Real.tanh_eq_sinh_div_cosh, Real.sinh_eq, Real.cosh_eq]
    rw [div_div_div_cancel_right₀]
    · norm_num
  rw [htanh, ← Real.log_inv, inv_div]

/-- The closure gap as an `ObstructionScalar`: return ratio `tanh beta`
(excited/vacuum Z2 transfer-eigenvalue ratio), functional `f rho = -log rho`. -/
def closureObstruction (β : ℝ) (hβ : 0 < β) : ObstructionScalar where
  domain := Set.Ioc 0 1
  f := fun ρ => -Real.log ρ
  ret := Real.tanh β
  one_mem := by constructor <;> norm_num
  ret_mem := by
    refine ⟨?_, (Real.tanh_lt_one β).le⟩
    rw [Real.tanh_eq_sinh_div_cosh]
    exact div_pos (Real.sinh_pos_iff.mpr hβ) (Real.cosh_pos _)
  ret_le_one := (Real.tanh_lt_one β).le
  f_one := by simp
  f_strictAnti := by
    intro x hx y _ hxy
    simp only
    have := Real.log_lt_log hx.1 hxy
    linarith

/-- **`closure_isObstructionScalar`.** The Z2 glueball closure gap is genuinely an
obstruction scalar: its `value` is exactly `z2GlueballMass beta` and its return
ratio is the excited/vacuum transfer-eigenvalue ratio `tanh beta`. -/
theorem closure_isObstructionScalar (β : ℝ) (hβ : 0 < β) :
    (closureObstruction β hβ).value = z2GlueballMass β
      ∧ (closureObstruction β hβ).ret = Real.tanh β := by
  refine ⟨?_, rfl⟩
  simp only [value, closureObstruction]
  rw [z2GlueballMass_eq_neg_log_tanh]

/-- Consistency check: the two structural laws specialize to the known closure
facts - the gap is nonnegative, and it vanishes iff the return ratio is `1`
(the `beta -> infinity` decoupling degeneracy). -/
theorem closure_value_nonneg (β : ℝ) (hβ : 0 < β) : 0 ≤ z2GlueballMass β := by
  have h := value_nonneg (closureObstruction β hβ)
  rwa [(closure_isObstructionScalar β hβ).1] at h

/-! ## 3. The aperture instance (A): the two-null composite mass -/

/-- On the future light cone a nonzero null momentum has strictly positive
energy (`k 0 > 0`). -/
theorem futureNull_energy_pos {k : Momentum4} (hk : IsFutureNull k) (hne : k ≠ 0) :
    0 < k 0 := by
  obtain ⟨hnull, h0⟩ := hk
  unfold IsNull minkowskiSq at hnull
  rcases h0.lt_or_eq with h | h
  · exact h
  · exfalso; apply hne
    have hk00 : k 0 = 0 := h.symm
    rw [hk00] at hnull
    have hk1 : k 1 = 0 := by nlinarith [sq_nonneg (k 1), sq_nonneg (k 2), sq_nonneg (k 3)]
    have hk2 : k 2 = 0 := by nlinarith [sq_nonneg (k 1), sq_nonneg (k 2), sq_nonneg (k 3)]
    have hk3 : k 3 = 0 := by nlinarith [sq_nonneg (k 1), sq_nonneg (k 2), sq_nonneg (k 3)]
    funext i; fin_cases i <;> simp [hk00, hk1, hk2, hk3]

/-- The two-null composite mass as an `ObstructionScalar`: return ratio the
future-cone spatial overlap `cos theta = spatialDot / (kPlus 0 * kMinus 0)`,
functional the affine `f rho = (2 * kPlus 0 * kMinus 0) * (1 - rho)`. Full return
`ret = 1` is the collinear degeneracy. -/
def apertureObstruction (kPlus kMinus : Momentum4)
    (hkp : IsFutureNull kPlus) (hkm : IsFutureNull kMinus)
    (hkpne : kPlus ≠ 0) (hkmne : kMinus ≠ 0) : ObstructionScalar where
  domain := Set.Iic 1
  f := fun ρ => (2 * kPlus 0 * kMinus 0) * (1 - ρ)
  ret := spatialDot kPlus kMinus / (kPlus 0 * kMinus 0)
  one_mem := by norm_num
  ret_mem := by
    have hp0 : 0 < kPlus 0 := futureNull_energy_pos hkp hkpne
    have hm0 : 0 < kMinus 0 := futureNull_energy_pos hkm hkmne
    have hden : 0 < kPlus 0 * kMinus 0 := mul_pos hp0 hm0
    have hmd : 0 ≤ minkDot kPlus kMinus := minkDot_nonneg_of_futureNull _ _ hkp hkm
    have hle : spatialDot kPlus kMinus ≤ kPlus 0 * kMinus 0 := by
      unfold minkDot at hmd; unfold spatialDot; linarith
    simp only [Set.mem_Iic]
    exact (div_le_one hden).mpr hle
  ret_le_one := by
    have hp0 : 0 < kPlus 0 := futureNull_energy_pos hkp hkpne
    have hm0 : 0 < kMinus 0 := futureNull_energy_pos hkm hkmne
    have hden : 0 < kPlus 0 * kMinus 0 := mul_pos hp0 hm0
    have hmd : 0 ≤ minkDot kPlus kMinus := minkDot_nonneg_of_futureNull _ _ hkp hkm
    have hle : spatialDot kPlus kMinus ≤ kPlus 0 * kMinus 0 := by
      unfold minkDot at hmd; unfold spatialDot; linarith
    exact (div_le_one hden).mpr hle
  f_one := by ring
  f_strictAnti := by
    have hp0 : 0 < kPlus 0 := futureNull_energy_pos hkp hkpne
    have hm0 : 0 < kMinus 0 := futureNull_energy_pos hkm hkmne
    have hscale : 0 < 2 * kPlus 0 * kMinus 0 := by positivity
    intro x _ y _ hxy
    simp only
    nlinarith [hscale, hxy]

/-- The aperture obstruction's `value` is exactly the two-null composite mass
`2 * minkDot kPlus kMinus`. -/
theorem apertureObstruction_value (kPlus kMinus : Momentum4)
    (hkp : IsFutureNull kPlus) (hkm : IsFutureNull kMinus)
    (hkpne : kPlus ≠ 0) (hkmne : kMinus ≠ 0) :
    (apertureObstruction kPlus kMinus hkp hkm hkpne hkmne).value
      = 2 * minkDot kPlus kMinus := by
  have hp0 : 0 < kPlus 0 := futureNull_energy_pos hkp hkpne
  have hm0 : 0 < kMinus 0 := futureNull_energy_pos hkm hkmne
  have hne : kPlus 0 * kMinus 0 ≠ 0 := by positivity
  simp only [value, apertureObstruction]
  unfold minkDot spatialDot
  field_simp
  ring

/-- **`aperture_isObstructionScalar`.** For an on-shell timelike momentum
`p = kPlus + kMinus` with `minkowskiSq p = m^2` and future-null, nonzero
constituents, the two-null composite mass is genuinely an obstruction scalar:
its `value` is exactly the on-shell mass `m^2`, with return ratio the future-cone
spatial overlap and full-return (`ret = 1`) the collinear degeneracy. -/
theorem aperture_isObstructionScalar (p kPlus kMinus : Momentum4) (m : ℝ)
    (hkp : IsFutureNull kPlus) (hkm : IsFutureNull kMinus)
    (hkpne : kPlus ≠ 0) (hkmne : kMinus ≠ 0)
    (hres : p = kPlus + kMinus) (hp : minkowskiSq p = m ^ 2) :
    (apertureObstruction kPlus kMinus hkp hkm hkpne hkmne).value = m ^ 2
      ∧ (apertureObstruction kPlus kMinus hkp hkm hkpne hkmne).ret
          = spatialDot kPlus kMinus / (kPlus 0 * kMinus 0) := by
  refine ⟨?_, rfl⟩
  rw [apertureObstruction_value]
  have hpn : minkowskiSq kPlus = 0 := hkp.1
  have hqn : minkowskiSq kMinus = 0 := hkm.1
  have h1 : minkowskiSq (kPlus + kMinus) = 2 * minkDot kPlus kMinus := by
    rw [CompositeApertureMass.minkowskiSq_add, hpn, hqn]; ring
  rw [← h1, ← hres, hp]

/-- Consistency check: the aperture composite mass is nonnegative, recovered as an
instance of the shared `value_nonneg` law. -/
theorem aperture_value_nonneg (kPlus kMinus : Momentum4)
    (hkp : IsFutureNull kPlus) (hkm : IsFutureNull kMinus)
    (hkpne : kPlus ≠ 0) (hkmne : kMinus ≠ 0) :
    0 ≤ 2 * minkDot kPlus kMinus := by
  have h := value_nonneg (apertureObstruction kPlus kMinus hkp hkm hkpne hkmne)
  rwa [apertureObstruction_value] at h

/-! ## 4. Non-vacuity witness (the kill-condition enforcement) -/

/-- **Non-vacuity witness.** In the style of
`ChargeGradingMassCompatible.coupling_would_distinguish`: strict antitonicity is
LOAD-BEARING for the shared "massless iff degenerate" law. There is a generic
candidate - the constant-zero functional at return ratio `1/2` - that satisfies
EVERY field of `ObstructionScalar` (admissible domain with `1` and `ret`, `ret <=
1`, `f 1 = 0`) EXCEPT strict antitonicity, and for which the conclusion of
`value_eq_zero_iff_full_return` is FALSE: its obstruction is `0` at the
NON-degenerate `ret = 1/2 <> 1`.

Hence membership in `ObstructionScalar` (in particular the strict-antitone
requirement, which BOTH physical rows genuinely verify) is a real constraint, not
a vacuous repackaging: without it, "mass = obstruction that vanishes iff
degenerate" would be false. This certifies the closure and aperture
instantiations carry content. -/
theorem shared_property_needs_monotonicity :
    ∃ (dom : Set ℝ) (g : ℝ → ℝ) (r : ℝ),
      (1 : ℝ) ∈ dom ∧ r ∈ dom ∧ r ≤ 1 ∧ g 1 = 0
      ∧ r ≠ 1 ∧ g r = 0 ∧ ¬ StrictAntiOn g dom := by
  refine ⟨Set.Icc 0 1, fun _ => 0, 1 / 2, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · constructor <;> norm_num
  · constructor <;> norm_num
  · norm_num
  · rfl
  · norm_num
  · rfl
  · intro hanti
    have h0 : (0 : ℝ) ∈ Set.Icc (0 : ℝ) 1 := by constructor <;> norm_num
    have h1 : (1 : ℝ) ∈ Set.Icc (0 : ℝ) 1 := by constructor <;> norm_num
    have := hanti h0 h1 (by norm_num)
    simp at this

end ObstructionScalar
end PhysicsSM.Draft.NullEdge.GateI1
