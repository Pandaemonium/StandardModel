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

set_option grind.warning false

/-!
# Zitterbewegung averaging: the subluminal drift is the mass-weighted mean of ±c luminal motion

This file formalizes a finite, sqrt-free, purely (rational/real) algebraic model that
reconciles two facts about a single Dirac momentum mode:

* **A chosen Dirac velocity component has ±c spectral support.** The
  corresponding finite operator has eigenvalues ±1. We model those two
  outcomes as right- and left-moving luminal sectors.
* **The observable drift is subluminal**, with speed-squared `‖v‖² = 1 - m²/E²`.

The bridge is *Zitterbewegung*: the drift is the time-average (convex combination) of the
±c luminal motion, and the mass sets the mixing weights.

## The model

A stationary state at momentum `p`, energy `E` occupies the two luminal channels with
weights `w₊, w₋` satisfying `w₊ + w₋ = 1`, `w₊, w₋ ≥ 0`.  The **mean (drift) velocity** is
`vbar = w₊·(+1) + w₋·(-1) = w₊ - w₋`.

To stay `sqrt`-free we parametrize by *rational* `p, E` on a Pythagorean shell
`p² + m² = E²` (so `(m, p, E)` is a rational triple such as `(3,4,5)`), and *define* the
occupation imbalance by the physical Dirac value `w₊ - w₋ = p/E`.  Together with
`w₊ + w₋ = 1` this fixes `w₊ = (1 + p/E)/2` and `w₋ = (1 - p/E)/2`.

## Scope / honesty

This is a **finite 2-channel algebraic model**, not a derivation from the Dirac
equation or a classical microscopic trajectory. It ties componentwise `±c`
spectral support to subluminal drift through one convex-averaging identity.
No `Real.sqrt`, no `Complex`; all statements are exact rational identities and
inequalities.
-/

namespace ZitterbewegungAverage

/-- Weight of the right-moving (`+1`) luminal channel, fixed by
`w₊ - w₋ = p/E` and `w₊ + w₋ = 1`. -/
def wPlus (p E : ℚ) : ℚ := (1 + p / E) / 2

/-- Weight of the left-moving (`-1`) luminal channel. -/
def wMinus (p E : ℚ) : ℚ := (1 - p / E) / 2

/-- Mean (drift) velocity `vbar = w₊·(+1) + w₋·(-1) = w₊ - w₋`. -/
def meanVelocity (p E : ℚ) : ℚ := wPlus p E - wMinus p E

/-- The two channel weights are a genuine probability distribution: they sum to `1`. -/
theorem weights_sum_one (p E : ℚ) : wPlus p E + wMinus p E = 1 := by
  simp only [wPlus, wMinus]; ring

/-- **Target 1.** With the Dirac imbalance `w₊ - w₋ = p/E` (and `w₊ + w₋ = 1`), the mean
velocity is exactly `p/E`, and for `|p| ≤ E` the weights `w₊, w₋` lie in `[0,1]`, i.e. they
are valid convex weights. -/
theorem mean_velocity_eq_p_over_E (p E : ℚ) (hE : 0 < E) (hp : |p| ≤ E) :
    meanVelocity p E = p / E ∧
      (0 ≤ wPlus p E ∧ wPlus p E ≤ 1) ∧ (0 ≤ wMinus p E ∧ wMinus p E ≤ 1) := by
  rw [abs_le] at hp
  have hlo : -1 ≤ p / E := by rw [le_div_iff₀ hE]; linarith [hp.1]
  have hhi : p / E ≤ 1 := by rw [div_le_one hE]; linarith [hp.2]
  refine ⟨by simp only [meanVelocity, wPlus, wMinus]; ring, ⟨?_, ?_⟩, ⟨?_, ?_⟩⟩
  · simp only [wPlus]; linarith
  · simp only [wPlus]; linarith
  · simp only [wMinus]; linarith
  · simp only [wMinus]; linarith

/-- **Target 2 (payload).** On the Pythagorean shell `p² + m² = E²` the drift
speed-squared equals `(p/E)²` and hence exactly `1 - m²/E²`.  So the subluminal drift is
literally the square of a convex average of `±1`. -/
theorem drift_subluminal_from_average (p E m : ℚ) (hE : E ≠ 0)
    (hshell : p ^ 2 + m ^ 2 = E ^ 2) :
    (meanVelocity p E) ^ 2 = (p / E) ^ 2 ∧ (meanVelocity p E) ^ 2 = 1 - m ^ 2 / E ^ 2 := by
  have hmv : meanVelocity p E = p / E := by simp only [meanVelocity, wPlus, wMinus]; ring
  refine ⟨by rw [hmv], ?_⟩
  rw [hmv, div_pow]
  field_simp
  linear_combination hshell

/-- **Target 3 (massless limit).** On the massless shell (`m = 0`, so `p = E`) the
left-moving channel is empty (`w₋ = 0`) and the drift is exactly `c`: a massless fermion is
a single luminal channel, moving at `c` with no zigzag. -/
theorem massless_limit (E : ℚ) (hE : 0 < E) :
    wMinus E E = 0 ∧ wPlus E E = 1 ∧ meanVelocity E E = 1 := by
  have hE' : E ≠ 0 := ne_of_gt hE
  refine ⟨?_, ?_, ?_⟩
  · simp only [wMinus, div_self hE']; norm_num
  · simp only [wPlus, div_self hE']; norm_num
  · simp only [meanVelocity, wPlus, wMinus, div_self hE']; norm_num

/-- **Target 3 (rest limit).** At rest (`p = 0`, i.e. `m = E`) the two luminal channels are
occupied equally (`w₊ = w₋ = 1/2`) and the drift vanishes: rest is a maximal `±c` zigzag
averaging to zero drift. -/
theorem rest_limit (E : ℚ) :
    wPlus 0 E = 1 / 2 ∧ wMinus 0 E = 1 / 2 ∧ meanVelocity 0 E = 0 := by
  refine ⟨?_, ?_, ?_⟩ <;> norm_num [wPlus, wMinus, meanVelocity]

/-- **Target 4 (verdict).** Package: on any rational Pythagorean shell `p² + m² = E²` with
`0 < E` and `|p| ≤ E`,

* `w₊, w₋` form a valid convex distribution (`w₊ + w₋ = 1`, both in `[0,1]`);
* the observable drift `vbar` is the convex average `w₊·(+1) + w₋·(-1) = p/E`;
* its speed-squared is exactly `1 - m²/E²` (subluminal for `m ≠ 0`).

Together with `massless_limit` and `rest_limit` this says: the observable velocity is always
a convex average of the instantaneous `±c`, the mass fraction sets the imbalance, rest is a
`50/50` luminal zigzag, and massless is a single luminal channel.  Instantaneous-luminal and
drift-subluminal are the same fact at two timescales. -/
theorem zitterbewegung_verdict (p E m : ℚ) (hE : 0 < E) (hp : |p| ≤ E)
    (hshell : p ^ 2 + m ^ 2 = E ^ 2) :
    (wPlus p E + wMinus p E = 1) ∧
      (0 ≤ wPlus p E ∧ wPlus p E ≤ 1) ∧ (0 ≤ wMinus p E ∧ wMinus p E ≤ 1) ∧
        meanVelocity p E = p / E ∧
          (meanVelocity p E) ^ 2 = 1 - m ^ 2 / E ^ 2 := by
  obtain ⟨hmv, hwp, hwm⟩ := mean_velocity_eq_p_over_E p E hE hp
  obtain ⟨_, hsq⟩ := drift_subluminal_from_average p E m (ne_of_gt hE) hshell
  exact ⟨weights_sum_one p E, hwp, hwm, hmv, hsq⟩

/-- **Mandatory non-degeneracy instance** `(m, p, E) = (3, 4, 5)`: all explicit rationals,
`w₊ = 9/10`, `w₋ = 1/10`, `vbar = 4/5`, `vbar² = 16/25 = 1 - 9/25`. -/
theorem instance_345 :
    wPlus 4 5 = 9 / 10 ∧ wMinus 4 5 = 1 / 10 ∧ meanVelocity 4 5 = 4 / 5 ∧
      (meanVelocity 4 5) ^ 2 = 16 / 25 ∧ (16 : ℚ) / 25 = 1 - 9 / 25 ∧
        (4 : ℚ) ^ 2 + 3 ^ 2 = 5 ^ 2 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> norm_num [wPlus, wMinus, meanVelocity]

/-! ## Axiom footprint (kernel-checked): exactly `[propext, Classical.choice, Quot.sound]`. -/

/-- info: 'ZitterbewegungAverage.mean_velocity_eq_p_over_E' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mean_velocity_eq_p_over_E

/-- info: 'ZitterbewegungAverage.drift_subluminal_from_average' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms drift_subluminal_from_average

/-- info: 'ZitterbewegungAverage.massless_limit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_limit

/-- info: 'ZitterbewegungAverage.rest_limit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rest_limit

/-- info: 'ZitterbewegungAverage.zitterbewegung_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zitterbewegung_verdict

/-- info: 'ZitterbewegungAverage.instance_345' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms instance_345

end ZitterbewegungAverage
