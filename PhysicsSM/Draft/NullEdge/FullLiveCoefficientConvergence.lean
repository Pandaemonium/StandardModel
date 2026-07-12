import PhysicsSM.Draft.NullEdge.LiveWeighted3Plus1Walk
import PhysicsSM.Draft.NullEdge.CountableL2WavepacketConvergence

/-!
# Full coefficient-space convergence, including the ultraviolet tail

`LiveWeighted3Plus1Walk` proves convergence of the actual dynamic error inside
an expanding momentum box. This module defines the full approximation in the
common countable coefficient space: retained modes use the live split walk and
omitted modes are zero. Consequently, the full error outside the box is minus
the exact evolved coefficient.

Exact-flow unitarity bounds every omitted coefficient by its input norm.
Eventual box inclusion supplies pointwise convergence, while one global
square-summable envelope permits Tannery aggregation. The resulting theorem
controls the complete countable coefficient error, not only a pre-truncated
bulk.

Claim boundary: this is the complete common coefficient-space theorem. It is
not a changing-lattice Fourier isometry, a sampling/interpolation theorem on
physical space, or the position-space Dirac PDE limit.

Provenance: clean-room local composition of the live bulk result, Mathlib's L2
operator norm, exact-flow unitarity, and the landed countable Tannery theorem.
No compiled evaluator is used.
-/

noncomputable section

open Filter Topology
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.FullLiveCoefficientConvergence

open ChangingModeEmbedding
open Compact3Plus1DiracRate
open CountableL2WavepacketConvergence
open LiveWeighted3Plus1Walk
open SobolevTailRate

/-- Exact evolved four-spinor coefficient at one momentum. -/
def exactModeEvolved (m t : Real) (f : Mode -> ModeSpinor) (k : Mode) :
    ModeSpinor :=
  (EuclideanSpace.equiv (Fin 4) Complex).symm <|
    (exactFlow (k.1.1 : Real) (k.1.2 : Real) (k.2 : Real) m t).mulVec (f k)

/-- Exact flow does not increase a mode coefficient's norm. -/
theorem exactModeEvolved_norm_le (m t : Real) (f : Mode -> ModeSpinor)
    (k : Mode) : ‖exactModeEvolved m t f k‖ <= ‖f k‖ := by
  have h := Matrix.l2_opNorm_mulVec
    (exactFlow (k.1.1 : Real) (k.1.2 : Real) (k.2 : Real) m t) (f k)
  rw [CStarRing.norm_of_mem_unitary
    (exactFlow_mem_unitary (k.1.1 : Real) (k.1.2 : Real) (k.2 : Real) m t),
    one_mul] at h
  simpa [exactModeEvolved] using h

/-- Full approximation error in the common countable coefficient space. Inside
the box this is the live split-versus-exact error; outside it is minus the
exact evolved coefficient because the finite approximation is zero there. -/
def fullModeError (m t : Real) (M N : Nat)
    (f : Mode -> ModeSpinor) (k : Mode) : ModeSpinor :=
  if k ∈ modeBox N then liveModeError m t M N f k
  else -exactModeEvolved m t f k

/-- One global square-summable envelope valid before and after a mode enters
the growing box. -/
def fullErrorEnvelope (t : Real) (f : Mode -> ModeSpinor) (k : Mode) : Real :=
  (2 * t ^ 2 * Real.exp |t| + 1) * ‖f k‖

theorem bulkRate_le_full_constant (t : Real) (M N : Nat) :
    bulkRate t M N <= 2 * t ^ 2 * Real.exp |t| := by
  have hden : (1 : Real) <= (refinementRadius M N : Real) := by
    exact_mod_cast (show 1 <= refinementRadius M N by
      unfold refinementRadius
      omega)
  have hpos : (0 : Real) < (refinementRadius M N : Real) :=
    lt_of_lt_of_le zero_lt_one hden
  rw [bulkRate, div_le_iff₀ hpos]
  exact le_mul_of_one_le_right (by positivity) hden

theorem fullModeError_norm_le_envelope
    (m t : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (f : Mode -> ModeSpinor) (k : Mode) :
    ‖fullModeError m t M N f k‖ <= fullErrorEnvelope t f k := by
  by_cases hk : k ∈ modeBox N
  · rw [fullModeError, if_pos hk]
    calc
      ‖liveModeError m t M N f k‖ <=
          walkErrorEnvelope m t M N f k :=
        liveModeError_norm_le_envelope m t M N f k
      _ <= bulkRate t M N * ‖f k‖ :=
        walkErrorEnvelope_le_bulkRate m t M N hm f k
      _ <= (2 * t ^ 2 * Real.exp |t|) * ‖f k‖ :=
        mul_le_mul_of_nonneg_right (bulkRate_le_full_constant t M N)
          (norm_nonneg _)
      _ <= fullErrorEnvelope t f k := by
        unfold fullErrorEnvelope
        nlinarith [norm_nonneg (f k)]
  · rw [fullModeError, if_neg hk, norm_neg]
    calc
      ‖exactModeEvolved m t f k‖ <= ‖f k‖ :=
        exactModeEvolved_norm_le m t f k
      _ <= fullErrorEnvelope t f k := by
        unfold fullErrorEnvelope
        have hc : 0 <= 2 * t ^ 2 * Real.exp |t| := by positivity
        nlinarith [norm_nonneg (f k)]

theorem fullModeError_pointwise_tendsto_zero
    (m t : Real) (M : Nat) (hm : |m| <= (M : Real))
    (f : Mode -> ModeSpinor) (k : Mode) :
    Tendsto (fun N : Nat => fullModeError m t M N f k) atTop (nhds 0) := by
  have hlive : Tendsto (fun N : Nat => liveModeError m t M N f k)
      atTop (nhds 0) := by
    rw [tendsto_zero_iff_norm_tendsto_zero]
    refine squeeze_zero
      (g := fun N : Nat => bulkRate t M N * ‖f k‖)
      (fun _ => norm_nonneg _) (fun N => ?_) ?_
    · exact (liveModeError_norm_le_envelope m t M N f k).trans
        (walkErrorEnvelope_le_bulkRate m t M N hm f k)
    · simpa using (bulkRate_tendsto_zero t M).mul_const ‖f k‖
  apply hlive.congr'
  filter_upwards [eventually_ge_atTop (modeRadius k)] with N hN
  have hk : k ∈ modeBox N := (mem_modeBox_iff_radius_le k N).2 hN
  simp [fullModeError, liveModeError, hk]

/-- The complete coefficient error, including the ultraviolet tail, converges
strongly for every square-summable four-spinor profile. -/
theorem fullModeError_tendsto_zero
    (m t : Real) (M : Nat) (hm : |m| <= (M : Real))
    (f : Mode -> ModeSpinor) (hf : Summable (fun k => ‖f k‖ ^ 2)) :
    Tendsto (fun N : Nat => ∑' k : Mode, ‖fullModeError m t M N f k‖ ^ 2)
      atTop (nhds 0) := by
  apply countable_l2_error_tendsto
    (err := fun N k => fullModeError m t M N f k)
    (bound := fun k => (fullErrorEnvelope t f k) ^ 2)
  · have hscaled := hf.mul_left ((2 * t ^ 2 * Real.exp |t| + 1) ^ 2)
    convert hscaled using 1
    funext k
    simp [fullErrorEnvelope, mul_pow]
  · exact fun k => fullModeError_pointwise_tendsto_zero m t M hm f k
  · intro N k
    exact pow_le_pow_left₀ (norm_nonneg _)
      (fullModeError_norm_le_envelope m t M N hm f k) 2

/-- Nonzero omitted-mode control: before a mode enters the box, its full error
is exactly minus its exact evolved coefficient. -/
theorem fullModeError_outside_control
    (m t : Real) (M N : Nat) (f : Mode -> ModeSpinor) (k : Mode)
    (hk : k ∉ modeBox N) :
    fullModeError m t M N f k = -exactModeEvolved m t f k := by
  simp [fullModeError, hk]

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.FullLiveCoefficientConvergence.fullModeError_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fullModeError_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.FullLiveCoefficientConvergence.fullModeError_outside_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fullModeError_outside_control

end PhysicsSM.Draft.NullEdge.FullLiveCoefficientConvergence
