import Mathlib
import PhysicsSM.Draft.NullEdge.UnifiedMassBudget
import PhysicsSM.Draft.NullEdge.CarrierRigidity
import PhysicsSM.Draft.NullEdge.GradedDecompUniqueness

/-!
# Four-channel rigidity capstone for the landed carrier mass square

This file proves the strongest *honest* concrete rigidity statement about the landed
four-channel decomposition of the finite Dirac carrier square
`4 D#D = Q_A + Q_C + Q_T + E_sold` (see `UnifiedMassBudget.square_splits`).

The key idea is to work with the *explicit rational witness* matrices
`UnifiedMassBudget.QA`, `QC`, `QT`, `Es`.  These four channels have pairwise disjoint
supports, so a handful of rational coordinate functionals reads off the coefficient of
each channel:

* `readA` — entry `(0,0)` (normalized by `8`, the value `QA 0 0`);
* `readC` — entry `(1,1)` (normalized by `20`, the value `QC 1 1`);
* `readT` — entry `(3,3)` (normalized by `40`, the value `QT 3 3`);
* `readE` — entry `(0,2)` (normalized by `12`, the value `Es 0 2`).

## Payload

1. `channel_coordinates_recover` — each coordinate reader recovers its coefficient from
   `channelCombination a c t e`.
2. `channelCombination_injective` / `four_channels_linearIndependent` — the four explicit
   channel matrices are linearly independent over `ℚ`.
3. `four_channel_coefficients_unique` — any two four-channel presentations of the same
   matrix have identical coefficients.
4. `carrier_square_coefficients_recovered` — specializing to `square_splits`, the concrete
   coefficients `(1,1,1,1)` are recovered from the carrier square `4 D#D` itself.
5. `four_channel_rigidity_with_boundary` — the positive rigidity result bundled with the
   honest negative boundary: concrete coordinate/support data make *this* split rigid,
   while chirality/Krein `(Γ,#)`-type alone (`CarrierRigidity.Concrete.shared_type_but_distinct`)
   and the mere block count (`NullEdgeCloser.split_not_forced`) do **not** force any split.

## Honest scope

This is a rigidity statement about the **explicit rational witness** plus the added
support/coordinate selectors.  It does *not* claim an abstract canonical four-channel split
for every carrier; the negative boundary results are included precisely to delimit that.
-/

open Matrix
open scoped BigOperators

namespace FourChannelRigidity

open UnifiedMassBudget

/-- The four-channel combination of the explicit rational channel matrices with rational
coefficients. -/
def channelCombination (a c t e : ℚ) : Matrix (Fin 4) (Fin 4) ℚ :=
  a • QA + c • QC + t • QT + e • Es

/-- Coordinate reader for the aperture coefficient: entry `(0,0)` normalized by `QA 0 0 = 8`. -/
def readA (M : Matrix (Fin 4) (Fin 4) ℚ) : ℚ := M 0 0 / 8

/-- Coordinate reader for the closure coefficient: entry `(1,1)` normalized by `QC 1 1 = 20`. -/
def readC (M : Matrix (Fin 4) (Fin 4) ℚ) : ℚ := M 1 1 / 20

/-- Coordinate reader for the turn coefficient: entry `(3,3)` normalized by `QT 3 3 = 40`. -/
def readT (M : Matrix (Fin 4) (Fin 4) ℚ) : ℚ := M 3 3 / 40

/-- Coordinate reader for the soldering (gravity) coefficient: entry `(0,2)` normalized by
`Es 0 2 = 12`. -/
def readE (M : Matrix (Fin 4) (Fin 4) ℚ) : ℚ := M 0 2 / 12

/-- **Payload 1.** Each coordinate reader recovers its coefficient from
`channelCombination`. -/
theorem channel_coordinates_recover (a c t e : ℚ) :
    readA (channelCombination a c t e) = a ∧
    readC (channelCombination a c t e) = c ∧
    readT (channelCombination a c t e) = t ∧
    readE (channelCombination a c t e) = e := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals
    simp +decide [readA, readC, readT, readE, channelCombination, QA, QC, QT, Es,
      Matrix.add_apply, Matrix.smul_apply, smul_eq_mul]

/-- **Payload 3.** Any two four-channel presentations of the same matrix have identical
coefficients. -/
theorem four_channel_coefficients_unique (a c t e a' c' t' e' : ℚ)
    (h : channelCombination a c t e = channelCombination a' c' t' e') :
    a = a' ∧ c = c' ∧ t = t' ∧ e = e' := by
  obtain ⟨hA, hC, hT, hE⟩ := channel_coordinates_recover a c t e
  obtain ⟨hA', hC', hT', hE'⟩ := channel_coordinates_recover a' c' t' e'
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [← hA, ← hA', h]
  · rw [← hC, ← hC', h]
  · rw [← hT, ← hT', h]
  · rw [← hE, ← hE', h]

/-- **Payload 2 (injectivity form).** The four explicit channel matrices are linearly
independent, phrased as injectivity of `channelCombination` in its coefficient tuple. -/
theorem channelCombination_injective :
    Function.Injective
      (fun v : ℚ × ℚ × ℚ × ℚ => channelCombination v.1 v.2.1 v.2.2.1 v.2.2.2) := by
  rintro ⟨a, c, t, e⟩ ⟨a', c', t', e'⟩ h
  obtain ⟨rfl, rfl, rfl, rfl⟩ := four_channel_coefficients_unique a c t e a' c' t' e' h
  rfl

/-- **Payload 2 (`LinearIndependent` form).** The four explicit channel matrices `QA, QC,
QT, Es` are linearly independent over `ℚ`. -/
theorem four_channels_linearIndependent :
    LinearIndependent ℚ ![QA, QC, QT, Es] := by
  rw [Fintype.linearIndependent_iff]
  intro g hg i
  -- `hg : ∑ i, g i • (![QA,QC,QT,Es] i) = 0`, which is `channelCombination (g 0) (g 1) (g 2) (g 3) = 0`.
  have hcomb : channelCombination (g 0) (g 1) (g 2) (g 3) = 0 := by
    rw [channelCombination]
    simpa [Fin.sum_univ_four] using hg
  have h0 : channelCombination (g 0) (g 1) (g 2) (g 3) = channelCombination 0 0 0 0 := by
    rw [hcomb, channelCombination]; simp
  obtain ⟨h1, h2, h3, h4⟩ :=
    four_channel_coefficients_unique (g 0) (g 1) (g 2) (g 3) 0 0 0 0 h0
  fin_cases i <;> assumption

/-- **Payload 4.** Specializing uniqueness to `UnifiedMassBudget.square_splits`: the carrier
square `4 D#D` is `channelCombination 1 1 1 1`, and its four concrete coefficients are read
back off the carrier square itself as `(1,1,1,1)`. -/
theorem carrier_square_coefficients_recovered :
    readA ((4 : ℚ) • (Dᵀ * D)) = 1 ∧
    readC ((4 : ℚ) • (Dᵀ * D)) = 1 ∧
    readT ((4 : ℚ) • (Dᵀ * D)) = 1 ∧
    readE ((4 : ℚ) • (Dᵀ * D)) = 1 := by
  have hsq : (4 : ℚ) • (Dᵀ * D) = channelCombination 1 1 1 1 := by
    rw [UnifiedMassBudget.square_splits, channelCombination]; simp
  rw [hsq]
  exact channel_coordinates_recover 1 1 1 1

/-- **Payload 5.** The full rigidity verdict with its honest boundary.

Positive (rigidity of the explicit witness under coordinate/support selectors):

* the coordinate readers recover the coefficients (`channel_coordinates_recover`);
* the coefficient tuple is uniquely determined (`four_channel_coefficients_unique`), i.e.
  `channelCombination` is injective;
* the four channels are linearly independent over `ℚ`;
* the carrier square `4 D#D` recovers its concrete coefficients `(1,1,1,1)`.

Negative boundary (chirality/Krein type alone does not force a split):

* three channels of the abstract carrier share the same `(Γ,#)`-type yet are distinct
  (`CarrierRigidity.Concrete.shared_type_but_distinct`);
* the mere block count leaves the split under-determined
  (`NullEdgeCloser.split_not_forced`). -/
theorem four_channel_rigidity_with_boundary :
    -- positive: coordinate readers recover the coefficients
    (∀ a c t e : ℚ,
      readA (channelCombination a c t e) = a ∧
      readC (channelCombination a c t e) = c ∧
      readT (channelCombination a c t e) = t ∧
      readE (channelCombination a c t e) = e) ∧
    -- positive: coefficients are unique
    (∀ a c t e a' c' t' e' : ℚ,
      channelCombination a c t e = channelCombination a' c' t' e' →
        a = a' ∧ c = c' ∧ t = t' ∧ e = e') ∧
    -- positive: the four channels are linearly independent over ℚ
    LinearIndependent ℚ ![QA, QC, QT, Es] ∧
    -- positive: the carrier square recovers its concrete coefficients (1,1,1,1)
    (readA ((4 : ℚ) • (Dᵀ * D)) = 1 ∧
      readC ((4 : ℚ) • (Dᵀ * D)) = 1 ∧
      readT ((4 : ℚ) • (Dᵀ * D)) = 1 ∧
      readE ((4 : ℚ) • (Dᵀ * D)) = 1) ∧
    -- negative boundary: (Γ,#)-type is shared by distinct channels
    ((CarrierRigidity.Concrete.kadj CarrierRigidity.Concrete.apertureC
        = CarrierRigidity.Concrete.apertureC ∧
        CarrierRigidity.Concrete.Gam * CarrierRigidity.Concrete.apertureC
          = CarrierRigidity.Concrete.apertureC * CarrierRigidity.Concrete.Gam) ∧
      (CarrierRigidity.Concrete.kadj CarrierRigidity.Concrete.closureC
        = CarrierRigidity.Concrete.closureC ∧
        CarrierRigidity.Concrete.Gam * CarrierRigidity.Concrete.closureC
          = CarrierRigidity.Concrete.closureC * CarrierRigidity.Concrete.Gam) ∧
      (CarrierRigidity.Concrete.kadj CarrierRigidity.Concrete.turnC
        = CarrierRigidity.Concrete.turnC ∧
        CarrierRigidity.Concrete.Gam * CarrierRigidity.Concrete.turnC
          = CarrierRigidity.Concrete.turnC * CarrierRigidity.Concrete.Gam) ∧
      CarrierRigidity.Concrete.apertureC ≠ CarrierRigidity.Concrete.closureC ∧
      CarrierRigidity.Concrete.apertureC ≠ CarrierRigidity.Concrete.turnC ∧
      CarrierRigidity.Concrete.closureC ≠ CarrierRigidity.Concrete.turnC) ∧
    -- negative boundary: block count does not force the split
    (∃ A B B' : Submodule ℝ (Fin 2 → ℝ), IsCompl A B ∧ IsCompl A B' ∧ B ≠ B') := by
  refine ⟨channel_coordinates_recover, four_channel_coefficients_unique,
    four_channels_linearIndependent, carrier_square_coefficients_recovered,
    CarrierRigidity.Concrete.shared_type_but_distinct, NullEdgeCloser.split_not_forced⟩

/-! ## Axiom footprint pins -/

/-- info: 'FourChannelRigidity.channel_coordinates_recover' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms channel_coordinates_recover
/-- info: 'FourChannelRigidity.four_channel_coefficients_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms four_channel_coefficients_unique
/-- info: 'FourChannelRigidity.channelCombination_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms channelCombination_injective
/-- info: 'FourChannelRigidity.four_channels_linearIndependent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms four_channels_linearIndependent
/-- info: 'FourChannelRigidity.carrier_square_coefficients_recovered' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms carrier_square_coefficients_recovered
/-- info: 'FourChannelRigidity.four_channel_rigidity_with_boundary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms four_channel_rigidity_with_boundary

end FourChannelRigidity
