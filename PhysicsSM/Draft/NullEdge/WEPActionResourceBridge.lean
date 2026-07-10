import Mathlib
import PhysicsSM.Draft.NullEdge.WEPTrace
import PhysicsSM.Draft.NullEdge.WEPActionBridge
import PhysicsSM.Draft.NullEdge.GateI1.MassEntropyDictionary
import PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone

/-!
# Goal IV: WEP action / mass-entropy resource bridge

This draft module composes the Goal IV WEP trace/action lane
(`WEPTrace`, `WEPActionBridge`) with the Gate I1.8 mass-entropy resource measure
(`GateI1.MassEntropyDictionary`, `GateI1.MassEntropyMonotone`). It is a small
finite bridge module: it repackages results already proved in those files into
a handful of composed statements useful for Goal IV, and does not duplicate the
`Goal4FieldEquation` job.

## What is proved here, and only this

* `stationary_channelBlind_total_budget`: a stationary sourced action with a
  channel-blind coupling has its response side equal to `kappa * Tr rho` on
  every budget `rho` (the total-budget source). This is the source-side half of
  `WEPActionBridge.stationary_channelBlind_source`, re-exported as the exact
  Goal IV packaging.

* `massEntropyMonotone_free_iff`: the mass-entropy resource measure is faithful
  on free states: `free P ↔ value P = 0`, unfolded directly from the bundled
  `massEntropyMonotone` structure.

* `massEntropyMonotone_nonvacuous`: the resource measure is genuinely
  non-trivial: there is a future-cone momentum with zero resource value (a
  null/massless momentum) and one with strictly positive resource value (a
  massive momentum at rest).

## Claim discipline

This module is a finite source/resource bridge. It does not claim any
Clausius/Jacobson entropy-to-Einstein result, nor the full E-slot / Einstein
field equation. In particular:

* the WEP side gives only the trace-level total-budget source, not an
  operator-level gravitational dynamics (see the `NextTargets` block in
  `WEPActionBridge`);
* the resource side is the observer-conditioned von Neumann entropy of the
  normalized visible-momentum block; nothing here couples the two sides
  dynamically.

Missing hypotheses/API needed to promote this to the next step (a genuine
entropy-sourced field equation) are exactly those recorded in
`WEPActionBridge.NextTargets`: a Frobenius/Hilbert-Schmidt inner-product
instance on `Matrix (Fin n) (Fin n) ℂ`, a quadratic geometric action whose
Euler operator is the `CarrierRigidity` response, and a sourced first-variation
lemma. Additionally, tying the WEP total-budget source to the mass-entropy
resource value would require a dictionary lemma expressing `Tr rho` (or the
source `Tr(K rho)`) in terms of `vonNeumannEntropy`, which does not yet exist.
-/

open Matrix
open PhysicsSM.Draft.NullEdge
open PhysicsSM.Draft.NullEdge.GateI1

namespace WEPActionResourceBridge

/-- **WEP stationarity packaged with the total-budget source.** If the coupling
`K` is channel-blind with scalar `kappa` and the sourced action is stationary,
then the response pairing `Tr(G rho)` equals `kappa` times the total budget
`Tr rho` for every budget operator `rho`. This is the source-side half of
`WEPActionBridge.stationary_channelBlind_source`, re-exported in the exact Goal
IV form. -/
theorem stationary_channelBlind_total_budget
    {n : ℕ} {G K : Matrix (Fin n) (Fin n) ℂ} {kappa : ℂ}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hstat : WEPActionBridge.Stationary G K) :
    ∀ rho : Matrix (Fin n) (Fin n) ℂ,
      WEPActionBridge.traceForm G rho = kappa * rho.trace :=
  (WEPActionBridge.stationary_channelBlind_source hK hstat).2

/-- **Faithfulness of the mass-entropy resource measure on free states.** A
future-cone momentum is a free state of `massEntropyMonotone` exactly when its
resource value (the von Neumann entropy of the normalized block) vanishes. This
is the `free_iff_value_zero` field of the bundled measure, restated. -/
theorem massEntropyMonotone_free_iff
    (P : MassEntropyMonotone.FutureConeMomentum) :
    MassEntropyMonotone.massEntropyMonotone.free P ↔
      MassEntropyMonotone.massEntropyMonotone.value P = 0 :=
  MassEntropyMonotone.massEntropyMonotone.free_iff_value_zero P

/-- **Non-vacuity of the mass-entropy resource measure.** There is a future-cone
momentum whose resource value is zero (a null/massless momentum, a free state)
and one whose resource value is strictly positive (a massive momentum at rest),
so the measure genuinely separates free from resourceful states. -/
theorem massEntropyMonotone_nonvacuous :
    (∃ P : MassEntropyMonotone.FutureConeMomentum,
        MassEntropyMonotone.massEntropyMonotone.value P = 0) ∧
    (∃ P : MassEntropyMonotone.FutureConeMomentum,
        0 < MassEntropyMonotone.massEntropyMonotone.value P) := by
  constructor
  · -- Null momentum p = (1, 1, 0, 0): E = 1 > 0, |p|^2 = 1 <= E^2, m^2 = 0.
    refine ⟨⟨![1, 1, 0, 0], by norm_num, ?_⟩, ?_⟩
    · simp [spatialNormSq]
    · rw [← massEntropyMonotone_free_iff]
      show minkowskiSq ![1, 1, 0, 0] = 0
      simp [minkowskiSq]
  · -- At-rest momentum p = (2, 0, 0, 0): E = 2 > 0, |p|^2 = 0 <= E^2, m^2 = 4.
    refine ⟨⟨![2, 0, 0, 0], by norm_num, ?_⟩, ?_⟩
    · simp [spatialNormSq]
    · show 0 < MassEntropyDictionary.vonNeumannEntropy ![2, 0, 0, 0]
      apply MassEntropyDictionary.vonNeumannEntropy_pos_of_timelike
      · norm_num
      · simp [spatialNormSq]
      · simp [minkowskiSq]

end WEPActionResourceBridge

/-! ## Kernel-footprint guard pins -/

/-- info: 'WEPActionResourceBridge.stationary_channelBlind_total_budget' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPActionResourceBridge.stationary_channelBlind_total_budget

/-- info: 'WEPActionResourceBridge.massEntropyMonotone_free_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPActionResourceBridge.massEntropyMonotone_free_iff

/-- info: 'WEPActionResourceBridge.massEntropyMonotone_nonvacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPActionResourceBridge.massEntropyMonotone_nonvacuous
