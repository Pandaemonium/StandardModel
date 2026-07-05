import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Core

/-!
# Gate I1.8: the mass -> von Neumann entropy dictionary ("null edges do not age")

This module extends the I1.8 normalized-determinant dictionary in
`GateI1/Core.lean` with the **binary / von Neumann entropy** package that the
NERD roadmap (`docs/NERD_ROADMAP.md`, I1.8 row) flags as still open. The
linear-entropy identity `2 (1 - Tr rho^2) = m^2 / E^2`
(`Core.linearEntropy_normalizedMinkHerm`) is already proved; here we go to the
full Shannon/von Neumann entropy of the normalized visible-momentum block
`rho = P / Tr P` and prove its distinctive interpretive statement.

## The dictionary

For a future-cone momentum `p` (energy `E = p 0 > 0`, spatial norm `|p| <= E`)
the normalized block `rho = normalizedMinkHerm p` is a trace-one `2 x 2` density
with eigenvalues

    lambda_+ = (1 + |v|) / 2 ,   lambda_- = (1 - |v|) / 2 ,   |v| = |p| / E ,

so its von Neumann entropy is the binary entropy
`S(rho) = negMulLog lambda_+ + negMulLog lambda_-`. The headline result:

    S(rho) = 0   iff   minkowskiSq p = 0   (the momentum is null / massless),

i.e. **null edges carry zero visible entropy - they "do not age" - while any
positive mass forces strictly positive mixedness.** At the opposite extreme a
momentum at spatial rest (`|v| = 0`, `lambda_+ = lambda_- = 1/2`) is maximally
mixed, `S = log 2`.

## Claim discipline (NULLSTRAND / NERD)

Claim label: **reconstruction / finite identity** - NOT new physics. CRITICAL
frame caveat (roadmap "unnormalized vs normalized" guardrail): the entropy here
is **observer-conditioned**. It is a property of the NORMALIZED block `rho`,
which depends on the timelike frame through `E = p 0`; the FRAME-INVARIANT mass
statement is `det P = minkowskiSq p = m^2` on the unnormalized block `P`
(`Core.det_minkHerm_eq_minkowskiSq`), and nothing here claims frame invariance
for `S(rho)` or `det rho`. What IS frame-invariant is the equivalence
`S(rho) = 0 <-> m = 0` (both sides are frame-invariant conditions even though
the entropy value is not).

Draft-trust: kernel-checked, no `s o r r y`. Prerequisites: `GateI1.Core`.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace MassEntropyDictionary

open PhysicsSM.Draft.NullEdge.GateI1

/-- The spatial speed `|v| = |p| / E`, i.e. `sqrt(velocityNormSq)`. -/
noncomputable def speed (p : Momentum4) : ℝ := Real.sqrt (velocityNormSq p)

/-- The larger eigenvalue `lambda_+ = (1 + |v|) / 2` of the normalized block. -/
noncomputable def evPlus (p : Momentum4) : ℝ := (1 + speed p) / 2

/-- The smaller eigenvalue `lambda_- = (1 - |v|) / 2` of the normalized block. -/
noncomputable def evMinus (p : Momentum4) : ℝ := (1 - speed p) / 2

/-- The speed is nonnegative. -/
theorem speed_nonneg (p : Momentum4) : 0 ≤ speed p := Real.sqrt_nonneg _

/-- Inside the future cone the speed is at most one (`|p| <= E`). -/
theorem speed_le_one (p : Momentum4) (hp0 : 0 < p 0)
    (hcone : spatialNormSq p ≤ (p 0) ^ 2) : speed p ≤ 1 := by
  unfold speed velocityNormSq
  rw [show (1 : ℝ) = Real.sqrt 1 by simp]
  apply Real.sqrt_le_sqrt
  rw [div_le_one (by positivity)]
  exact hcone

/-- `speed p = 1` exactly at null momenta (`minkowskiSq p = 0`), given `E > 0`. -/
theorem speed_eq_one_iff_null (p : Momentum4) (hp0 : 0 < p 0)
    (hcone : spatialNormSq p ≤ (p 0) ^ 2) :
    speed p = 1 ↔ minkowskiSq p = 0 := by
  have hE : (p 0) ^ 2 ≠ 0 := pow_ne_zero 2 (ne_of_gt hp0)
  have hvnn : 0 ≤ velocityNormSq p := velocityNormSq_nonneg p
  unfold speed
  rw [show (1 : ℝ) = Real.sqrt 1 by simp]
  rw [Real.sqrt_inj hvnn (by norm_num)]
  unfold velocityNormSq
  rw [div_eq_one_iff_eq hE]
  constructor
  · intro h
    -- minkowskiSq = E^2 - |p|^2 ; spatialNormSq = |p|^2
    have : minkowskiSq p = (p 0) ^ 2 - spatialNormSq p := by
      unfold minkowskiSq spatialNormSq; ring
    rw [this, h]; ring
  · intro h
    have : spatialNormSq p = (p 0) ^ 2 := by
      have hm : minkowskiSq p = (p 0) ^ 2 - spatialNormSq p := by
        unfold minkowskiSq spatialNormSq; ring
      rw [hm] at h; linarith
    exact this

/-- The eigenvalues sum to one (trace-one normalization). -/
theorem evPlus_add_evMinus (p : Momentum4) : evPlus p + evMinus p = 1 := by
  unfold evPlus evMinus; ring

/-- The smaller eigenvalue is nonnegative inside the future cone. -/
theorem evMinus_nonneg (p : Momentum4) (hp0 : 0 < p 0)
    (hcone : spatialNormSq p ≤ (p 0) ^ 2) : 0 ≤ evMinus p := by
  unfold evMinus
  have := speed_le_one p hp0 hcone
  linarith

/-- The larger eigenvalue is at most one inside the future cone
(`|v| <= 1`). -/
theorem evPlus_le_one (p : Momentum4) (hp0 : 0 < p 0)
    (hcone : spatialNormSq p ≤ (p 0) ^ 2) : evPlus p ≤ 1 := by
  unfold evPlus
  have := speed_le_one p hp0 hcone
  linarith

/-- The larger eigenvalue is nonnegative. -/
theorem evPlus_nonneg (p : Momentum4) : 0 ≤ evPlus p := by
  unfold evPlus; have := speed_nonneg p; linarith

/-- The smaller eigenvalue is at most one. -/
theorem evMinus_le_one (p : Momentum4) (hp0 : 0 < p 0)
    (hcone : spatialNormSq p ≤ (p 0) ^ 2) : evMinus p ≤ 1 := by
  have hsum := evPlus_add_evMinus p
  have hpos := evPlus_nonneg p
  linarith

/-- The product of the eigenvalues is the normalized determinant
`det rho = (1 - |v|^2)/4`. -/
theorem evPlus_mul_evMinus (p : Momentum4) (hp0 : 0 < p 0)
    (hcone : spatialNormSq p ≤ (p 0) ^ 2) :
    evPlus p * evMinus p = (1 - velocityNormSq p) / 4 := by
  unfold evPlus evMinus speed
  have hsq : Real.sqrt (velocityNormSq p) ^ 2 = velocityNormSq p :=
    Real.sq_sqrt (velocityNormSq_nonneg p)
  nlinarith [hsq]

/-- **The von Neumann (binary) entropy of the normalized visible-momentum
block.** `S(rho) = negMulLog lambda_+ + negMulLog lambda_-`. -/
noncomputable def vonNeumannEntropy (p : Momentum4) : ℝ :=
  Real.negMulLog (evPlus p) + Real.negMulLog (evMinus p)

/-- The entropy is nonnegative inside the future cone. -/
theorem vonNeumannEntropy_nonneg (p : Momentum4) (hp0 : 0 < p 0)
    (hcone : spatialNormSq p ≤ (p 0) ^ 2) : 0 ≤ vonNeumannEntropy p := by
  unfold vonNeumannEntropy
  have h1 := Real.negMulLog_nonneg (evPlus_nonneg p) (evPlus_le_one p hp0 hcone)
  have h2 := Real.negMulLog_nonneg (evMinus_nonneg p hp0 hcone)
    (evMinus_le_one p hp0 hcone)
  linarith

/-- `negMulLog x = 0` for `x >= 0` exactly at `x = 0` or `x = 1`. -/
theorem negMulLog_eq_zero_iff {x : ℝ} (hx : 0 ≤ x) :
    Real.negMulLog x = 0 ↔ x = 0 ∨ x = 1 := by
  unfold Real.negMulLog
  rw [neg_mul, neg_eq_zero, mul_eq_zero]
  constructor
  · rintro (h | h)
    · exact Or.inl h
    · rcases Real.log_eq_zero.mp h with h0 | h1 | hneg
      · exact Or.inl h0
      · exact Or.inr h1
      · exact absurd hneg (by linarith)
  · rintro (h | h)
    · exact Or.inl h
    · exact Or.inr (by rw [h]; simp)

/-- **"Null edges do not age" (I1.8 headline).** For a future-cone momentum the
von Neumann entropy of the normalized visible-momentum block vanishes exactly
when the momentum is null (massless): `S(rho) = 0 <-> minkowskiSq p = 0`.

Reconstruction / finite identity. The entropy value is observer-conditioned
(it is a property of the normalized `rho`, frame-dependent through `E = p 0`);
the equivalence itself is frame-invariant. -/
theorem vonNeumannEntropy_eq_zero_iff_null (p : Momentum4) (hp0 : 0 < p 0)
    (hcone : spatialNormSq p ≤ (p 0) ^ 2) :
    vonNeumannEntropy p = 0 ↔ minkowskiSq p = 0 := by
  have hsp1 := speed_le_one p hp0 hcone
  have hsp0 := speed_nonneg p
  have hplus_nn := evPlus_nonneg p
  have hplus_le := evPlus_le_one p hp0 hcone
  have hminus_nn := evMinus_nonneg p hp0 hcone
  have hminus_le := evMinus_le_one p hp0 hcone
  constructor
  · intro hS
    -- both nonneg terms sum to 0 => each is 0
    have h1 := Real.negMulLog_nonneg hplus_nn hplus_le
    have h2 := Real.negMulLog_nonneg hminus_nn hminus_le
    have hp_zero : Real.negMulLog (evPlus p) = 0 := by
      unfold vonNeumannEntropy at hS; linarith
    -- evPlus in {0,1}; evPlus >= 1/2 so evPlus = 1, hence speed = 1
    rcases (negMulLog_eq_zero_iff hplus_nn).mp hp_zero with h0 | h1'
    · -- evPlus = 0 impossible since evPlus >= 1/2
      exfalso; unfold evPlus at h0; nlinarith
    · -- evPlus = 1 => speed = 1 => null
      have hspeed : speed p = 1 := by unfold evPlus at h1'; linarith
      exact (speed_eq_one_iff_null p hp0 hcone).mp hspeed
  · intro hnull
    have hspeed : speed p = 1 := (speed_eq_one_iff_null p hp0 hcone).mpr hnull
    have hp1 : evPlus p = 1 := by unfold evPlus; rw [hspeed]; ring
    have hm0 : evMinus p = 0 := by unfold evMinus; rw [hspeed]; ring
    unfold vonNeumannEntropy
    rw [hp1, hm0]
    simp [Real.negMulLog]

/-- **Massive momenta carry strictly positive visible entropy** (the contrapositive
"anything with mass ages"): for future-TIMELIKE `p` (`minkowskiSq p > 0`),
`0 < S(rho)`. -/
theorem vonNeumannEntropy_pos_of_timelike (p : Momentum4) (hp0 : 0 < p 0)
    (hcone : spatialNormSq p ≤ (p 0) ^ 2) (hmass : 0 < minkowskiSq p) :
    0 < vonNeumannEntropy p := by
  rcases lt_or_eq_of_le (vonNeumannEntropy_nonneg p hp0 hcone) with h | h
  · exact h
  · exfalso
    have : minkowskiSq p = 0 :=
      (vonNeumannEntropy_eq_zero_iff_null p hp0 hcone).mp h.symm
    linarith

/-- At spatial rest (`|p| = 0`, `|v| = 0`) the speed vanishes. -/
theorem speed_eq_zero_of_rest (p : Momentum4) (hp0 : 0 < p 0)
    (hrest : spatialNormSq p = 0) : speed p = 0 := by
  unfold speed velocityNormSq
  rw [hrest, zero_div, Real.sqrt_zero]

/-- **The other endpoint: at rest the block is maximally mixed.** A momentum at
spatial rest (`spatialNormSq p = 0`) has both eigenvalues `1/2`, so the visible
von Neumann entropy is `log 2` - the maximum for a two-level block. Together
with `vonNeumannEntropy_eq_zero_iff_null` this pins the two endpoints of the
mass -> entropy dictionary: massless/null <-> pure (`S = 0`), fully massive/at
rest <-> maximally mixed (`S = log 2`). Observer-conditioned (rest is a frame
choice); reconstruction / finite identity. -/
theorem vonNeumannEntropy_rest_eq_log_two (p : Momentum4) (hp0 : 0 < p 0)
    (hrest : spatialNormSq p = 0) :
    vonNeumannEntropy p = Real.log 2 := by
  have hspeed : speed p = 0 := speed_eq_zero_of_rest p hp0 hrest
  have hp : evPlus p = 1 / 2 := by unfold evPlus; rw [hspeed]; ring
  have hm : evMinus p = 1 / 2 := by unfold evMinus; rw [hspeed]; ring
  unfold vonNeumannEntropy
  rw [hp, hm]
  unfold Real.negMulLog
  rw [Real.log_div (by norm_num) (by norm_num), Real.log_one]
  ring

end MassEntropyDictionary
end PhysicsSM.Draft.NullEdge.GateI1
