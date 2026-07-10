import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Core
import PhysicsSM.Draft.NullEdge.GateI1.MassEntropyDictionary

/-!
# Gate I1.8: the mass-to-entropy monotone

`MassEntropyDictionary` pins the two endpoints of the mass-to-von-Neumann
entropy dictionary: null/massless momenta are pure (`S = 0`,
`vonNeumannEntropy_eq_zero_iff_null`) and at-rest momenta are maximally mixed
(`S = log 2`). This module supplies the order structure between the endpoints
and packages it as a finite resource-theory interface.

## What is new here

* `binEnt`: the binary entropy
  `H(s) = negMulLog((1+s)/2) + negMulLog((1-s)/2)`, as a function of the single
  speed parameter `s = |v| ∈ [0,1]`, together with
  `vonNeumannEntropy_eq_binEnt` identifying `S(ρ(p)) = binEnt (speed p)`.
* `binEnt_antitoneOn`: `H` is antitone on `[0,1]`; increasing the speed, i.e.
  decreasing the invariant mass ratio `m/E`, never increases the entropy.
* `vonNeumannEntropy_antitone_speed`: the momentum-level corollary.
* `vonNeumannEntropy_monotone_massRatio`: entropy is monotone in the mass ratio:
  a larger invariant ratio `m^2/E^2` forces at least as much visible entropy.
* `ResourceMonotone` / `massEntropyMonotone`: a clean finite resource interface
  with null momenta as free states and von Neumann entropy as the monotone.

## Claim discipline

Reconstruction / finite identity, not new physics. As in the dictionary, the
entropy value is observer-conditioned through `E = p 0`; the comparison
`S(ρ(p)) ≤ S(ρ(q))` is between two blocks evaluated in the same frame, and the
free-state characterization `S = 0 ↔ m = 0` is frame-invariant.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace MassEntropyMonotone

open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Draft.NullEdge.GateI1.MassEntropyDictionary

/-- The binary entropy as a function of the speed parameter `s = |v|`:
`H(s) = negMulLog((1+s)/2) + negMulLog((1-s)/2)`. -/
noncomputable def binEnt (s : ℝ) : ℝ :=
  Real.negMulLog ((1 + s) / 2) + Real.negMulLog ((1 - s) / 2)

/-- The von Neumann entropy of the normalized block is the binary entropy of the
speed. -/
theorem vonNeumannEntropy_eq_binEnt (p : Momentum4) :
    vonNeumannEntropy p = binEnt (speed p) := by
  rfl

/-- The derivative of the binary entropy in the speed on the open interval
`(-1, 1)`: `H'(s) = 1/2 * log((1 - s)/(1 + s))`. -/
theorem hasDerivAt_binEnt (s : ℝ) (h1 : -1 < s) (h2 : s < 1) :
    HasDerivAt binEnt ((1 / 2) * Real.log ((1 - s) / (1 + s))) s := by
  convert HasDerivAt.add
    (HasDerivAt.comp s (Real.hasDerivAt_negMulLog ?_)
      (HasDerivAt.div_const (hasDerivAt_id' s |> HasDerivAt.const_add 1) _))
    (HasDerivAt.comp s (Real.hasDerivAt_negMulLog ?_)
      (HasDerivAt.div_const (hasDerivAt_id' s |> HasDerivAt.const_sub 1) _)) using 1 <;>
    norm_num
  · rw [Real.log_div, Real.log_div, Real.log_div] <;> linarith
  · linarith
  · linarith

/-- The binary entropy is antitone on `[0,1]`. Increasing the speed never
increases the entropy. -/
theorem binEnt_antitoneOn : AntitoneOn binEnt (Set.Icc (0 : ℝ) 1) := by
  apply_rules [antitoneOn_of_deriv_nonpos, convex_Icc]
  · exact Continuous.continuousOn (by
      exact Continuous.add
        (Real.continuous_negMulLog.comp (by continuity))
        (Real.continuous_negMulLog.comp (by continuity)))
  · norm_num at *
    exact fun x hx =>
      (hasDerivAt_binEnt x (by linarith [hx.1]) (by linarith [hx.2])
        |> HasDerivAt.differentiableAt |> DifferentiableAt.differentiableWithinAt)
  · simp +zetaDelta at *
    intro x hx₁ hx₂
    rw [hasDerivAt_binEnt x (by linarith) (by linarith) |> HasDerivAt.deriv]
    exact mul_nonpos_of_nonneg_of_nonpos (by norm_num)
      (Real.log_nonpos
        (by rw [le_div_iff₀] <;> linarith)
        (by rw [div_le_iff₀] <;> linarith))

/-- Entropy is antitone in speed. For future-cone momenta, a larger speed yields
no more visible von Neumann entropy. -/
theorem vonNeumannEntropy_antitone_speed
    (p q : Momentum4) (hp0 : 0 < p 0) (hpc : spatialNormSq p ≤ (p 0) ^ 2)
    (hq0 : 0 < q 0) (hqc : spatialNormSq q ≤ (q 0) ^ 2)
    (hpq : speed p ≤ speed q) :
    vonNeumannEntropy q ≤ vonNeumannEntropy p := by
  rw [vonNeumannEntropy_eq_binEnt, vonNeumannEntropy_eq_binEnt]
  exact binEnt_antitoneOn
    ⟨speed_nonneg p, speed_le_one p hp0 hpc⟩
    ⟨speed_nonneg q, speed_le_one q hq0 hqc⟩ hpq

/-- Entropy is monotone in the invariant mass ratio. Since
`speed^2 = 1 - m^2/E^2`, a larger ratio `m^2/E^2` gives a smaller speed and
hence at least as much visible entropy. -/
theorem vonNeumannEntropy_monotone_massRatio
    (p q : Momentum4) (hp0 : 0 < p 0) (hpc : spatialNormSq p ≤ (p 0) ^ 2)
    (hq0 : 0 < q 0) (hqc : spatialNormSq q ≤ (q 0) ^ 2)
    (hmr : minkowskiSq p / (p 0) ^ 2 ≤ minkowskiSq q / (q 0) ^ 2) :
    vonNeumannEntropy p ≤ vonNeumannEntropy q := by
  have hvp := velocityNormSq_eq_one_sub_massRatio p hp0
  have hvq := velocityNormSq_eq_one_sub_massRatio q hq0
  have hv : velocityNormSq q ≤ velocityNormSq p := by
    rw [hvp, hvq]
    linarith
  have hspeed : speed q ≤ speed p := Real.sqrt_le_sqrt hv
  exact vonNeumannEntropy_antitone_speed q p hq0 hqc hp0 hpc hspeed

/-! ## A finite resource-monotone interface -/

/-- A finite resource monotone: a nonnegative real functional `value` on a state
space `S`, faithful on a designated predicate `free` of free states. -/
structure ResourceMonotone (S : Type*) where
  /-- The monotone functional. -/
  value : S → ℝ
  /-- The designated free states. -/
  free : S → Prop
  /-- The monotone is nonnegative. -/
  value_nonneg : ∀ s, 0 ≤ value s
  /-- Faithfulness: the monotone vanishes exactly on the free states. -/
  free_iff_value_zero : ∀ s, free s ↔ value s = 0

/-- A bundled future-cone 4-momentum: energy positive and inside the cone. -/
structure FutureConeMomentum where
  /-- The underlying 4-momentum. -/
  p : Momentum4
  /-- Positive energy. -/
  energy_pos : 0 < p 0
  /-- Inside the future cone. -/
  in_cone : spatialNormSq p ≤ (p 0) ^ 2

/-- The mass-entropy resource monotone. On future-cone momenta the von Neumann
entropy is a faithful resource monotone whose free states are exactly the null
massless momenta: `S(ρ(p)) = 0 ↔ minkowskiSq p = 0`. -/
noncomputable def massEntropyMonotone : ResourceMonotone FutureConeMomentum where
  value P := vonNeumannEntropy P.p
  free P := minkowskiSq P.p = 0
  value_nonneg P := vonNeumannEntropy_nonneg P.p P.energy_pos P.in_cone
  free_iff_value_zero P :=
    (vonNeumannEntropy_eq_zero_iff_null P.p P.energy_pos P.in_cone).symm

end MassEntropyMonotone
end PhysicsSM.Draft.NullEdge.GateI1

/-! ## Kernel-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone.binEnt_antitoneOn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (info, whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone.binEnt_antitoneOn

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone.vonNeumannEntropy_antitone_speed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (info, whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone.vonNeumannEntropy_antitone_speed

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone.vonNeumannEntropy_monotone_massRatio' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (info, whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone.vonNeumannEntropy_monotone_massRatio

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone.massEntropyMonotone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (info, whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone.massEntropyMonotone
