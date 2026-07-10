import Mathlib.Analysis.Normed.Group.Tannery
import Mathlib.Analysis.SpecificLimits.Basic

/-!
# Countable L2 wave-packet convergence by Tannery domination

Finite Plancherel controls a periodic momentum grid.  This module supplies the
countable successor: if every mode error tends to zero and its squared norm is
bounded by one summable envelope, then the total squared spectral error tends
to zero.

This is the dominated-convergence step needed for an infinite-mode wave
packet.  A walk-specific application must still prove pointwise convergence,
a global square-summable envelope for the chosen initial data, and a Fourier
isometry identifying the limiting multiplier with the Dirac PDE propagator.

Provenance: theorem shape follows Mathlib's direct Tannery theorem
`tendsto_tsum_of_dominated_convergence`; clean-room project specialization,
2026-07-10.
-/

noncomputable section

open Filter Topology

namespace PhysicsSM.Draft.NullEdge.CountableL2WavepacketConvergence

variable {Mode E : Type*} [NormedAddCommGroup E]

/-- Pointwise mode convergence plus a summable squared-error envelope implies
convergence of the total countable squared error. -/
theorem countable_l2_error_tendsto
    (err : Nat -> Mode -> E) (bound : Mode -> Real)
    (hbound : Summable bound)
    (hpoint : forall k, Tendsto (fun n => err n k) atTop (nhds 0))
    (hdom : forall n k, ‖err n k‖ ^ 2 <= bound k) :
    Tendsto (fun n => ∑' k, ‖err n k‖ ^ 2) atTop (nhds 0) := by
  have hterm : forall k,
      Tendsto (fun n => ‖err n k‖ ^ 2) atTop (nhds 0) := by
    intro k
    have hnorm := tendsto_norm.comp (hpoint k)
    simpa using hnorm.pow 2
  have hdomEventually : ∀ᶠ n in atTop,
      forall k, ‖(‖err n k‖ ^ 2 : Real)‖ <= bound k := by
    exact Eventually.of_forall fun n k => by
      rw [Real.norm_of_nonneg (sq_nonneg _)]
      exact hdom n k
  simpa using
    (tendsto_tsum_of_dominated_convergence hbound hterm hdomEventually)

/-- A direct wave-packet form: a square-summable mode envelope dominating the
norm error yields countable `L2` convergence. -/
theorem countable_l2_wavepacket_tendsto
    (approx : Nat -> Mode -> E) (exact : Mode -> E)
    (envelope : Mode -> Real)
    (henvelope : Summable fun k => envelope k ^ 2)
    (hpoint : forall k,
      Tendsto (fun n => approx n k) atTop (nhds (exact k)))
    (hdom : forall n k, ‖approx n k - exact k‖ <= envelope k) :
    Tendsto
      (fun n => ∑' k, ‖approx n k - exact k‖ ^ 2)
      atTop (nhds 0) := by
  apply countable_l2_error_tendsto
    (fun n k => approx n k - exact k) (fun k => envelope k ^ 2)
    henvelope
  · intro k
    simpa using (hpoint k).sub_const (exact k)
  · intro n k
    exact pow_le_pow_left₀ (norm_nonneg _) (hdom n k) 2

/-- The theorem is nonvacuous: one decaying mode and zero elsewhere gives a
genuine countable family with vanishing total squared error. -/
theorem single_mode_control :
    Tendsto
      (fun n : Nat =>
        ∑' k : Nat, ‖(if k = 0 then (1 / (n + 1 : Real)) else 0)‖ ^ 2)
      atTop (nhds 0) := by
  have hpoint : forall k : Nat,
      Tendsto (fun n : Nat => if k = 0 then (1 / (n + 1 : Real)) else 0)
        atTop (nhds 0) := by
    intro k
    by_cases hk : k = 0
    · subst k
      simp only [↓reduceIte]
      exact tendsto_one_div_add_atTop_nhds_zero_nat
    · simp [hk]
  have hsum : Summable (fun k : Nat => (if k = 0 then 1 else 0 : Real)) := by
    simpa using (hasSum_ite_eq (0 : Nat) (1 : Real)).summable
  apply countable_l2_error_tendsto
    (fun n k => if k = 0 then (1 / (n + 1 : Real)) else 0)
    (fun k => if k = 0 then 1 else 0) hsum hpoint
  intro n k
  by_cases hk : k = 0
  · subst k
    simp only [↓reduceIte]
    have hn : (1 : Real) <= n + 1 := by
      exact_mod_cast Nat.succ_le_succ (Nat.zero_le n)
    have hdenom : (0 : Real) < n + 1 := lt_of_lt_of_le zero_lt_one hn
    have hnonneg : (0 : Real) <= 1 / (n + 1 : Real) :=
      div_nonneg zero_le_one hdenom.le
    have hle : (1 / (n + 1 : Real)) <= 1 := by
      exact (div_le_one hdenom).mpr hn
    rw [Real.norm_of_nonneg hnonneg]
    nlinarith [sq_nonneg (1 - 1 / (n + 1 : Real))]
  · simp [hk]

end PhysicsSM.Draft.NullEdge.CountableL2WavepacketConvergence

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CountableL2WavepacketConvergence.countable_l2_error_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CountableL2WavepacketConvergence.countable_l2_error_tendsto

/-- info: 'PhysicsSM.Draft.NullEdge.CountableL2WavepacketConvergence.countable_l2_wavepacket_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CountableL2WavepacketConvergence.countable_l2_wavepacket_tendsto

/-- info: 'PhysicsSM.Draft.NullEdge.CountableL2WavepacketConvergence.single_mode_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CountableL2WavepacketConvergence.single_mode_control
