import PhysicsSM.Draft.NullEdge.Compact3Plus1GrowingWindowRate
import PhysicsSM.Draft.NullEdge.SobolevTailRate
import PhysicsSM.Draft.NullEdge.CountableL2WavepacketConvergence

/-!
# Weighted countable mode aggregation for the growing-window limit

This module supplies a countable monotone-comparison rung after the modewise
`3+1` quartic growing-window estimate. A modewise error with a vanishing scalar
rate and one common summable Sobolev-weighted envelope has vanishing total
squared coefficient error. Pointwise convergence is not an additional
hypothesis: it follows from the same rate bound.

Claim boundary: this is a countable coefficient-space theorem. It does not by
itself perform the operator-to-coefficient reduction, control a high-radius
tail not covered by the supplied envelope, define sampling or interpolation on
changing physical lattices, prove a Fourier isometry to `L2(R^3)`, or identify
the limiting multiplier with the position-space Dirac PDE propagator. Those
maps and identifications remain the next Paper D composition gate.

Provenance: the main theorem was returned in the in-progress snapshot of
Aristotle project `37c30afc-8b04-4eb5-b1da-ebe7b195a675` and independently
compiled against the live project before integration. The nonzero control was
added locally. No compiled evaluator is used.
-/

noncomputable section

open Filter Topology

namespace PhysicsSM.Draft.NullEdge.WeightedGrowingWindowModeSum

open ChangingModeEmbedding SobolevTailRate

/-- A modewise error with a vanishing scalar rate and a common
Sobolev-weighted envelope has vanishing total squared coefficient error. -/
theorem growingWindow_countableWeightedL2_tendsto_zero
    {E : Type*} [NormedAddCommGroup E]
    (r : Nat -> Real)
    (hr : Tendsto r atTop (nhds 0))
    (err : Nat -> Mode -> E)
    (f : Mode -> E)
    (s : Nat)
    (hSob : Summable
      (fun k => ((1 + modeRadius k : Nat) ^ s : Real) * ‖f k‖ ^ 2))
    (hdom : forall n k,
      ‖err n k‖ ^ 2 <=
        r n * (((1 + modeRadius k : Nat) ^ s : Real) * ‖f k‖ ^ 2)) :
    Tendsto (fun n => ∑' k, ‖err n k‖ ^ 2) atTop (nhds 0) := by
  set bound : Mode -> Real :=
    fun k => ((1 + modeRadius k : Nat) ^ s : Real) * ‖f k‖ ^ 2 with hbounddef
  have hbound_nonneg : forall k, (0 : Real) <= bound k := by
    intro k
    rw [hbounddef]
    positivity
  have hpt : forall k,
      Tendsto (fun n => ‖err n k‖ ^ 2) atTop (nhds (0 : Real)) := by
    intro k
    apply squeeze_zero
    · exact fun _ => sq_nonneg _
    · exact fun n => hdom n k
    · change Tendsto (fun n => r n * bound k) atTop (nhds 0)
      simpa using hr.mul_const (bound k)
  have hr1 : ∀ᶠ n in atTop, r n <= 1 :=
    hr.eventually_le_const (by norm_num)
  have hdomev : ∀ᶠ n in atTop, forall k, ‖‖err n k‖ ^ 2‖ <= bound k := by
    filter_upwards [hr1] with n hn k
    have hnn := hbound_nonneg k
    have hdk := hdom n k
    rw [Real.norm_of_nonneg (by positivity)]
    calc
      ‖err n k‖ ^ 2 <= r n * bound k := hdk
      _ <= 1 * bound k := by nlinarith [hnn]
      _ = bound k := by ring
  have hmain :=
    tendsto_tsum_of_dominated_convergence (f := fun n k => ‖err n k‖ ^ 2)
      (g := fun _ => (0 : Real)) (bound := bound) hSob hpt hdomev
  simpa using hmain

/-- Nonzero control: a single occupied nonzero-radius mode with reciprocal
decay satisfies the weighted theorem, exercises the Sobolev weight, and has
nonzero error at every finite step. -/
theorem weighted_single_mode_control :
    Tendsto
      (fun n : Nat =>
        ∑' k : Mode,
          ‖(if k = (((1 : Int), 0), 0) then
              (1 / (n + 1 : Real)) else 0)‖ ^ 2)
      atTop (nhds 0) := by
  apply growingWindow_countableWeightedL2_tendsto_zero
    (r := fun n : Nat => (1 / (n + 1 : Real)) ^ 2)
    (err := fun n k => if k = (((1 : Int), 0), 0) then
      (1 / (n + 1 : Real)) else 0)
    (f := fun k : Mode => if k = (((1 : Int), 0), 0) then
      (1 / 2 : Real) else 0)
    (s := 2)
  · simpa using
      ((tendsto_one_div_add_atTop_nhds_zero_nat :
        Tendsto (fun n : Nat => (1 / (n + 1 : Real))) atTop (nhds 0)).pow 2)
  · have hsum : Summable
        (fun k : Mode => if k = (((1 : Int), 0), 0) then
          (1 : Real) else 0) := by
      simpa using
        (hasSum_ite_eq ((((1 : Int), 0), 0) : Mode) (1 : Real)).summable
    have hterms :
        (fun k : Mode =>
          ((1 + modeRadius k : Nat) ^ 2 : Real) *
            ‖(if k = (((1 : Int), 0), 0) then
              (1 / 2 : Real) else 0)‖ ^ 2) =
          (fun k : Mode => if k = (((1 : Int), 0), 0) then
            (1 : Real) else 0) := by
      funext k
      by_cases hk : k = (((1 : Int), 0), 0)
      · subst k
        norm_num [modeRadius]
      · simp [hk]
    rw [hterms]
    exact hsum
  · intro n k
    by_cases hk : k = (((1 : Int), 0), 0)
    · subst k
      norm_num [modeRadius]
    · simp [hk]

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.WeightedGrowingWindowModeSum.growingWindow_countableWeightedL2_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms growingWindow_countableWeightedL2_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.WeightedGrowingWindowModeSum.weighted_single_mode_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weighted_single_mode_control

end PhysicsSM.Draft.NullEdge.WeightedGrowingWindowModeSum
