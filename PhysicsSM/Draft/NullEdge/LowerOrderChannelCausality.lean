import Mathlib

/-!
# Null characteristics are unchanged by lower-order channel mixing

This module states the precise universal replacement for the slogan that every
particle or channel has microscopic velocity c. Velocity operators are
representation-specific, and internal interaction channels do not themselves
carry a velocity. The common relativistic statement is instead about the
principal symbol: wavefronts propagate on the null characteristic cone.

For a finite multiplet with wave principal symbol

  q(omega,k) I,  q(omega,k) = omega^2 - |k|^2,

an arbitrary matrix of zero-order mass, turn, closure, or internal mixing
appears with two powers of the short-distance scale and disappears from the
principal symbol. The determinant of the principal symbol is q^d, so for every
nonempty multiplet its characteristic locus is exactly q = 0. A separate
counterexample shows that a channel entering at principal order can change the
characteristic set; the lower-order hypothesis is therefore load-bearing.

The same module records the massive drift identity

  |v_g|^2 = |k|^2 / E^2 = 1 - m^2 / E^2 < 1

on a rational mass shell. Thus null front velocity and subluminal massive group
velocity are compatible statements at different scales.

This is finite symbol algebra. Instantiating it as a theorem about a particular
scalar, spinor, vector, or geometric field still requires proving that field's
equation has the displayed principal symbol and that its extra channels are
lower order.
-/

open scoped BigOperators
open Matrix

namespace PhysicsSM.Draft.NullEdge.LowerOrderChannelCausality

/-- Rational spatial three-momentum. -/
abbrev Momentum3 := Fin 3 -> ℚ

/-- Euclidean spatial momentum norm squared. -/
def spatialNormSq (k : Momentum3) : ℚ :=
  ∑ i, (k i) ^ 2

/-- Mostly-minus wave symbol. Its zero locus is the null cone. -/
def waveQ (omega : ℚ) (k : Momentum3) : ℚ :=
  omega ^ 2 - spatialNormSq k

/-- Wave principal symbol on a d-component finite multiplet. -/
def principalWaveSymbol (d : ℕ) (omega : ℚ) (k : Momentum3) :
    Matrix (Fin d) (Fin d) ℚ :=
  waveQ omega k • 1

/-- Exact determinant of the scalar wave principal symbol. -/
theorem principalWaveSymbol_det (d : ℕ) (omega : ℚ) (k : Momentum3) :
    (principalWaveSymbol d omega k).det = waveQ omega k ^ d := by
  simp [principalWaveSymbol]

/-- Every nonempty finite multiplet has exactly the null characteristic cone. -/
theorem principal_characteristic_iff_null
    (d : ℕ) (omega : ℚ) (k : Momentum3) :
    (principalWaveSymbol (d + 1) omega k).det = 0 ↔ waveQ omega k = 0 := by
  rw [principalWaveSymbol_det]
  simp

/-- Short-distance rescaling of a second-order wave symbol with arbitrary
zero-order channel mixing B. -/
def scaledSecondOrderSymbol
    (d : ℕ) (eps omega : ℚ) (k : Momentum3)
    (B : Matrix (Fin d) (Fin d) ℚ) :
    Matrix (Fin d) (Fin d) ℚ :=
  principalWaveSymbol d omega k + eps ^ 2 • B

/-- Every zero-order channel disappears exactly at principal scale. -/
theorem zeroOrderChannel_vanishes_at_principal_scale
    (d : ℕ) (omega : ℚ) (k : Momentum3)
    (B : Matrix (Fin d) (Fin d) ℚ) :
    scaledSecondOrderSymbol d 0 omega k B =
      principalWaveSymbol d omega k := by
  simp [scaledSecondOrderSymbol]

/-- Four arbitrary lower-order channel matrices still leave the principal
symbol unchanged. -/
theorem four_lowerOrder_channels_preserve_principal_symbol
    (d : ℕ) (omega : ℚ) (k : Momentum3)
    (A C T E : Matrix (Fin d) (Fin d) ℚ) :
    scaledSecondOrderSymbol d 0 omega k (A + C + T + E) =
      principalWaveSymbol d omega k := by
  exact zeroOrderChannel_vanishes_at_principal_scale d omega k (A + C + T + E)

/-- First-order version: an arbitrary zero-order matrix B disappears after
the corresponding one-power rescaling. -/
def scaledFirstOrderSymbol
    (d : ℕ) (eps : ℚ)
    (P B : Matrix (Fin d) (Fin d) ℚ) :
    Matrix (Fin d) (Fin d) ℚ :=
  P + eps • B

theorem firstOrderChannel_vanishes_at_principal_scale
    (d : ℕ) (P B : Matrix (Fin d) (Fin d) ℚ) :
    scaledFirstOrderSymbol d 0 P B = P := by
  simp [scaledFirstOrderSymbol]

/-- Load-bearing negative control: a channel added at principal order can
change the characteristic determinant. -/
theorem principalOrder_channel_can_change_characteristic :
    (0 : Matrix (Fin 1) (Fin 1) ℚ).det = 0
      ∧ (1 : Matrix (Fin 1) (Fin 1) ℚ).det = 1 := by
  simp

/-! ## Massive group drift versus null front propagation -/

/-- On the relativistic mass shell, group-speed squared is the complement of
the invariant mass fraction. -/
theorem groupSpeedSq_eq_one_sub_massRatio
    (omega m : ℚ) (k : Momentum3) (homega : omega ≠ 0)
    (hshell : spatialNormSq k + m ^ 2 = omega ^ 2) :
    spatialNormSq k / omega ^ 2 = 1 - m ^ 2 / omega ^ 2 := by
  field_simp
  linear_combination hshell

/-- A nonzero mass gives strictly subluminal group drift on the displayed
mass shell. -/
theorem massive_groupSpeedSq_lt_one
    (omega m : ℚ) (k : Momentum3)
    (homega : omega ≠ 0) (hm : m ≠ 0)
    (hshell : spatialNormSq k + m ^ 2 = omega ^ 2) :
    spatialNormSq k / omega ^ 2 < 1 := by
  rw [groupSpeedSq_eq_one_sub_massRatio omega m k homega hshell]
  have hm2 : 0 < m ^ 2 := sq_pos_of_ne_zero hm
  have he2 : 0 < omega ^ 2 := sq_pos_of_ne_zero homega
  have hratio : 0 < m ^ 2 / omega ^ 2 := div_pos hm2 he2
  linarith

/-- Nondegenerate 3-4-5 drift witness. -/
def k345 : Momentum3 :=
  fun i => if i = 0 then 3 else 0

theorem three_four_five_drift_witness :
    spatialNormSq k345 + 4 ^ 2 = 5 ^ 2
      ∧ spatialNormSq k345 / 5 ^ 2 = 9 / 25
      ∧ spatialNormSq k345 / 5 ^ 2 < 1 := by
  norm_num (config := { decide := true })
    [spatialNormSq, k345, Fin.sum_univ_three]

/-- Compact verdict: lower-order channel mixing preserves the null principal
cone, while massive on-shell drift remains strictly subluminal. -/
theorem lowerOrder_channel_causality_verdict :
    (∀ d : ℕ, ∀ omega : ℚ, ∀ k : Momentum3,
      (principalWaveSymbol (d + 1) omega k).det = 0 ↔ waveQ omega k = 0)
      ∧ (∀ d : ℕ, ∀ omega : ℚ, ∀ k : Momentum3,
        ∀ A C T E : Matrix (Fin d) (Fin d) ℚ,
        scaledSecondOrderSymbol d 0 omega k (A + C + T + E) =
          principalWaveSymbol d omega k)
      ∧ spatialNormSq k345 / 5 ^ 2 < 1 := by
  constructor
  · exact principal_characteristic_iff_null
  constructor
  · exact four_lowerOrder_channels_preserve_principal_symbol
  · exact three_four_five_drift_witness.2.2

end PhysicsSM.Draft.NullEdge.LowerOrderChannelCausality

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.LowerOrderChannelCausality.principal_characteristic_iff_null' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LowerOrderChannelCausality.principal_characteristic_iff_null

/-- info: 'PhysicsSM.Draft.NullEdge.LowerOrderChannelCausality.massive_groupSpeedSq_lt_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LowerOrderChannelCausality.massive_groupSpeedSq_lt_one

/-- info: 'PhysicsSM.Draft.NullEdge.LowerOrderChannelCausality.lowerOrder_channel_causality_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LowerOrderChannelCausality.lowerOrder_channel_causality_verdict
