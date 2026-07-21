import PhysicsSM.Draft.NullEdge.HNUCompactMomentumContinuum
import PhysicsSM.Draft.NullEdge.ChangingCellFourierL2
import PhysicsSM.Draft.NullEdge.HNUChangingCellProjectionL2

/-!
# HNU changing-cell live error in position-space L2

This module closes the first term in the HNU changing-cell continuum
decomposition. At every refinement level, the live HNU endpoint is evaluated
at each physical cell center with one common adaptive microscopic step count.
The coefficients are the actual normalized cell averages of a supplied
two-component `L2` field.

The live-versus-exact center error is bounded in momentum-space `L2`, bundled
as an actual quotient-space element, and transported to position space by
Mathlib's vector-valued inverse Fourier isometry.

This module controls only the first term. It does not include exact-flow
variation inside a cell, projection of the input field, or identification of
the limiting position-space Weyl generator.

Provenance: clean-room composition of `HNUCompactMomentumContinuum`, the
changing-cell coefficient/isometry modules, and Mathlib Plancherel. The target
shape was independently explored by Aristotle project
`da35eb2a-1150-47f9-8b67-bce8c90f8e86`, July 20, 2026.
-/

noncomputable section

open scoped BigOperators ENNReal Matrix.Norms.L2Operator
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.HNUChangingCellL2

open HNUManyStepContinuum
open HNUCompactMomentumContinuum
open ChangingMomentumCellIsometry
open ChangingMomentumCellCoefficientBridge
open ChangingMomentumCellProjectionStrongScaffold
open ChangingCellScaledLiveWalk
open ScaledChangingMomentumWalk
open HNUChangingCellProjectionL2

/-- The two-component Weyl spinor acted on by the live HNU endpoint. -/
abbrev Spinor2 := WeylSpinor

/-- Actual normalized two-spinor coefficient extracted componentwise from a
momentum cell. -/
def spinor2CellCoefficient (N : Nat) (F : Momentum3 -> Spinor2)
    (k : Mode3) : Spinor2 :=
  (EuclideanSpace.equiv (Fin 2) Complex).symm
    (fun j => cellCoefficient (physicalSpacing N) k (fun x => F x j))

/-- Euclidean two-spinor energy is the sum of coordinate energies. -/
theorem spinor2_norm_sq_eq_sum (v : Spinor2) :
    ‖v‖ ^ 2 = ∑ j : Fin 2, ‖v j‖ ^ 2 := by
  rw [EuclideanSpace.norm_eq]
  exact Real.sq_sqrt (Finset.sum_nonneg fun _ _ => sq_nonneg _)

/-- Exact componentwise coefficient-energy identity. -/
theorem spinor2CellCoefficient_norm_sq (N : Nat)
    (F : Momentum3 -> Spinor2) (k : Mode3) :
    ‖spinor2CellCoefficient N F k‖ ^ 2 =
      ∑ j : Fin 2,
        ‖cellCoefficient (physicalSpacing N) k (fun x => F x j)‖ ^ 2 := by
  rw [spinor2_norm_sq_eq_sum]
  rfl

/-- The scheduled actual coefficients contract the input-field energy. -/
theorem spinor2CellCoefficient_energy_le
    (N : Nat) (F : Momentum3 -> Spinor2)
    (hF : forall j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    (∑ k ∈ scheduledModes N, ‖spinor2CellCoefficient N F k‖ ^ 2) <=
      ∑ j : Fin 2, ∫ x, ‖F x j‖ ^ 2 := by
  calc
    (∑ k ∈ scheduledModes N, ‖spinor2CellCoefficient N F k‖ ^ 2) =
        ∑ k ∈ scheduledModes N, ∑ j : Fin 2,
          ‖cellCoefficient (physicalSpacing N) k (fun x => F x j)‖ ^ 2 := by
      apply Finset.sum_congr rfl
      intro k hk
      exact spinor2CellCoefficient_norm_sq N F k
    _ = ∑ j : Fin 2, ∑ k ∈ scheduledModes N,
          ‖cellCoefficient (physicalSpacing N) k (fun x => F x j)‖ ^ 2 := by
      rw [Finset.sum_comm]
    _ <= ∑ j : Fin 2, ∫ x, ‖F x j‖ ^ 2 := by
      apply Finset.sum_le_sum
      intro j hj
      exact coefficient_energy_le_input (physicalSpacing_pos N)
        (scheduledModes N) (fun x => F x j)
        (fun k hk => memLp_two_integrableOn_momentumCell
          (hF j) (physicalSpacing N) k)
        (memLp_two_integrable_norm_sq (hF j))

/-- Physical center of the normalized momentum cell labelled by `k`. -/
def qCenter (N : Nat) (k : Mode3) : Fin 3 -> Real :=
  fun i => physicalSpacing N * (k i : Real)

/-- Scheduled integer coordinates obey the concrete cutoff in `natAbs`. -/
lemma scheduled_coord_natAbs_le (N : Nat) (k : Mode3)
    (hk : k ∈ scheduledModes N) (i : Fin 3) :
    (k i).natAbs <= physicalCutoff N := by
  have hi := (mem_scheduledModes_iff N k).1 hk i
  rcases hi with ⟨hi1, hi2⟩
  cases abs_cases (k i) <;> omega

/-- Every scheduled physical center lies in the explicit `qAbs` ball used by
the common adaptive HNU schedule. -/
theorem qAbs_qCenter_le (N : Nat) (k : Mode3)
    (hk : k ∈ scheduledModes N) :
    qAbs (qCenter N k) <= 3 * (N + 1 : Real) := by
  have h0 := ScaledChangingMomentumWalk.abs_scaled_coord_le_level N (k 0)
    (scheduled_coord_natAbs_le N k hk 0)
  have h1 := ScaledChangingMomentumWalk.abs_scaled_coord_le_level N (k 1)
    (scheduled_coord_natAbs_le N k hk 1)
  have h2 := ScaledChangingMomentumWalk.abs_scaled_coord_le_level N (k 2)
    (scheduled_coord_natAbs_le N k hk 2)
  unfold qAbs qCenter
  linarith

/-- The zero mode is present at every refinement level. -/
theorem zeroMode_mem_scheduledModes (N : Nat) :
    (fun _ : Fin 3 => (0 : Int)) ∈ scheduledModes N := by
  unfold scheduledModes
  simp +decide
  exact ⟨fun _ => neg_nonpos.mpr (Nat.cast_nonneg _),
    fun _ => Nat.cast_nonneg _⟩

/-- One common microscopic step count for every cell at level `N`. -/
def commonSteps (t : Real) (N : Nat) : Nat :=
  adaptiveSteps (3 * (N + 1 : Real)) t N

/-- Live HNU-versus-exact error applied to the actual normalized cell-derived
coefficient. -/
def cellModeError (t : Real) (N : Nat) (F : Momentum3 -> Spinor2)
    (k : Mode3) : Spinor2 :=
  let A := (Wend (qCenter N k) (t / (commonSteps t N : Real))) ^
    commonSteps t N
  let B := Eflow (qCenter N k) t
  (EuclideanSpace.equiv (Fin 2) Complex).symm
    ((A - B).mulVec (spinor2CellCoefficient N F k))

/-- Every scheduled actual coefficient error obeys the same explicit rate,
which is at most `1/(N+1)`. -/
theorem cellModeError_norm_le
    (t : Real) (N : Nat) (F : Momentum3 -> Spinor2)
    (k : Mode3) (hk : k ∈ scheduledModes N) :
    ‖cellModeError t N F k‖ <=
      (1 / (N + 1 : Real)) * ‖spinor2CellCoefficient N F k‖ := by
  have hop := Matrix.l2_opNorm_mulVec
    ((Wend (qCenter N k) (t / (commonSteps t N : Real))) ^
        commonSteps t N - Eflow (qCenter N k) t)
    (spinor2CellCoefficient N F k)
  have hmatrix :
      norm ((Wend (qCenter N k) (t / (commonSteps t N : Real))) ^
          commonSteps t N - Eflow (qCenter N k) t) <=
        1 / (N + 1 : Real) := by
    exact le_trans
      (many_step_bound_on_ball (qCenter N k) (3 * (N + 1 : Real)) t
        (commonSteps t N) (by positivity) (qAbs_qCenter_le N k hk)
        (adaptiveSteps_pos _ _ _) (adaptiveSteps_small _ _ _))
      (adaptive_rate_le (3 * (N + 1 : Real)) t N (by positivity))
  exact le_trans (by simpa [cellModeError] using hop)
    (mul_le_mul_of_nonneg_right hmatrix (norm_nonneg _))

/-- Sum of squared live HNU cell errors, bounded by the squared common rate
times the energy of the supplied field. -/
theorem cellModeError_energy_le
    (t : Real) (N : Nat) (F : Momentum3 -> Spinor2)
    (hF : forall j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    (∑ k ∈ scheduledModes N, ‖cellModeError t N F k‖ ^ 2) <=
      (1 / (N + 1 : Real)) ^ 2 *
        (∑ j : Fin 2, ∫ x, ‖F x j‖ ^ 2) := by
  calc
    (∑ k ∈ scheduledModes N, ‖cellModeError t N F k‖ ^ 2) <=
        ∑ k ∈ scheduledModes N,
          ((1 / (N + 1 : Real)) *
            ‖spinor2CellCoefficient N F k‖) ^ 2 := by
      apply Finset.sum_le_sum
      intro k hk
      exact pow_le_pow_left₀ (norm_nonneg _)
        (cellModeError_norm_le t N F k hk) 2
    _ = (1 / (N + 1 : Real)) ^ 2 *
        (∑ k ∈ scheduledModes N,
          ‖spinor2CellCoefficient N F k‖ ^ 2) := by
      simp_rw [mul_pow, Finset.mul_sum]
    _ <= (1 / (N + 1 : Real)) ^ 2 *
        (∑ j : Fin 2, ∫ x, ‖F x j‖ ^ 2) := by
      exact mul_le_mul_of_nonneg_left
        (spinor2CellCoefficient_energy_le N F hF) (sq_nonneg _)

/-- The total coefficient error tends to zero. -/
theorem cellModeError_energy_tendsto_zero
    (t : Real) (F : Momentum3 -> Spinor2)
    (hF : forall j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    Tendsto (fun N => ∑ k ∈ scheduledModes N,
      ‖cellModeError t N F k‖ ^ 2) atTop (nhds 0) := by
  let C : Real := ∑ j : Fin 2, ∫ x, ‖F x j‖ ^ 2
  refine squeeze_zero
    (fun N => Finset.sum_nonneg fun _ _ => sq_nonneg _)
    (fun N => cellModeError_energy_le t N F hF) ?_
  have hrate : Tendsto (fun N : Nat => 1 / (N + 1 : Real)) atTop (nhds 0) := by
    exact tendsto_one_div_add_atTop_nhds_zero_nat
  simpa [C] using (hrate.pow 2).mul_const C

/-- Re-embed one error component into the same normalized cells. -/
def embeddedErrorComponent (t : Real) (N : Nat)
    (F : Momentum3 -> Spinor2) (j : Fin 2) : Momentum3 -> Complex :=
  embedFinite (physicalSpacing N) (scheduledModes N)
    (fun k => cellModeError t N F k j)

/-- Bundle the two representatives into an actual momentum-space spinor. -/
def embeddedErrorSpinor (t : Real) (N : Nat)
    (F : Momentum3 -> Spinor2) : Momentum3 -> Spinor2 :=
  fun x => (EuclideanSpace.equiv (Fin 2) Complex).symm
    (fun j => embeddedErrorComponent t N F j x)

/-- The bundled live error has the expected pointwise Euclidean energy. -/
theorem embeddedErrorSpinor_norm_sq (t : Real) (N : Nat)
    (F : Momentum3 -> Spinor2) (x : Momentum3) :
    ‖embeddedErrorSpinor t N F x‖ ^ 2 =
      ∑ j : Fin 2, ‖embeddedErrorComponent t N F j x‖ ^ 2 := by
  rw [spinor2_norm_sq_eq_sum]
  rfl

/-- The actual bundled representative is square-integrable. -/
theorem embeddedErrorSpinor_memLp (t : Real) (N : Nat)
    (F : Momentum3 -> Spinor2) :
    MemLp (embeddedErrorSpinor t N F) 2 volume := by
  apply MemLp.of_eval_piLp
  intro j
  simpa [embeddedErrorSpinor, embeddedErrorComponent] using
    ChangingCellFourierL2.embedFinite_memLp
      (physicalSpacing N) (scheduledModes N)
      (fun k => cellModeError t N F k j)

/-- Exact representative-level energy identity. -/
theorem embeddedErrorSpinor_energy_eq (t : Real) (N : Nat)
    (F : Momentum3 -> Spinor2) :
    (∫ x, ‖embeddedErrorSpinor t N F x‖ ^ 2) =
      ∑ k ∈ scheduledModes N, ‖cellModeError t N F k‖ ^ 2 := by
  calc
    (∫ x, ‖embeddedErrorSpinor t N F x‖ ^ 2) =
        ∑ j : Fin 2,
          ∫ x, ‖embeddedErrorComponent t N F j x‖ ^ 2 := by
      rw [integral_congr_ae (Filter.Eventually.of_forall fun x =>
        embeddedErrorSpinor_norm_sq t N F x)]
      rw [integral_finset_sum]
      intro j hj
      exact (ChangingCellFourierL2.embedFinite_memLp
        (physicalSpacing N) (scheduledModes N)
        (fun k => cellModeError t N F k j)).integrable_norm_pow
          (by norm_num)
    _ = ∑ k ∈ scheduledModes N, ‖cellModeError t N F k‖ ^ 2 := by
      simp_rw [embeddedErrorComponent,
        embedFinite_isometry (physicalSpacing_pos N)]
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro k hk
      exact (spinor2_norm_sq_eq_sum (cellModeError t N F k)).symm

/-- Momentum-space `L2` class of the actual changing-cell live error. -/
def embeddedErrorLp (t : Real) (N : Nat) (F : Momentum3 -> Spinor2) :
    Lp Spinor2 2 (volume : Measure Momentum3) :=
  (embeddedErrorSpinor_memLp t N F).toLp (embeddedErrorSpinor t N F)

/-- Its quotient-space norm has exactly the representative energy. -/
theorem embeddedErrorLp_norm_sq_eq (t : Real) (N : Nat)
    (F : Momentum3 -> Spinor2) :
    ‖embeddedErrorLp t N F‖ ^ 2 =
      ∑ k ∈ scheduledModes N, ‖cellModeError t N F k‖ ^ 2 := by
  rw [← embeddedErrorSpinor_energy_eq]
  let hf := embeddedErrorSpinor_memLp t N F
  rw [show embeddedErrorLp t N F =
      hf.toLp (embeddedErrorSpinor t N F) by rfl]
  rw [Lp.norm_toLp]
  rw [hf.eLpNorm_eq_integral_rpow_norm (by norm_num) (by norm_num)]
  simp only [ENNReal.toReal_ofNat]
  have henergy : 0 <= ∫ x, ‖embeddedErrorSpinor t N F x‖ ^ 2 :=
    integral_nonneg fun x => sq_nonneg _
  rw [ENNReal.toReal_ofReal']
  rw [max_eq_left (by positivity)]
  have hrpow_energy :
      (∫ x, ‖embeddedErrorSpinor t N F x‖ ^ (2 : Real)) =
        ∫ x, ‖embeddedErrorSpinor t N F x‖ ^ (2 : Nat) := by
    apply integral_congr_ae
    exact Filter.Eventually.of_forall fun x => Real.rpow_two _
  rw [hrpow_energy]
  exact Real.rpow_inv_natCast_pow (n := 2)
    henergy (by norm_num)

/-- Genuine vector-valued momentum-space strong `L2` convergence. -/
theorem embeddedErrorLp_norm_tendsto_zero
    (t : Real) (F : Momentum3 -> Spinor2)
    (hF : forall j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    Tendsto (fun N => ‖embeddedErrorLp t N F‖) atTop (nhds 0) := by
  have hsq : Tendsto (fun N => ‖embeddedErrorLp t N F‖ ^ 2)
      atTop (nhds 0) := by
    apply (cellModeError_energy_tendsto_zero t F hF).congr'
    exact Filter.Eventually.of_forall fun N =>
      (embeddedErrorLp_norm_sq_eq t N F).symm
  have hsqrt := hsq.sqrt
  simpa [Real.sqrt_sq_eq_abs, abs_of_nonneg] using hsqrt

/-- Euclidean momentum coordinates required by Mathlib Fourier theory. -/
abbrev FourierMomentum3 := EuclideanSpace Real (Fin 3)

/-- Explicit measure-preserving coordinate bridge. -/
def euclideanErrorLp (t : Real) (N : Nat) (F : Momentum3 -> Spinor2) :
    Lp Spinor2 2 (volume : Measure FourierMomentum3) :=
  MeasureTheory.Lp.compMeasurePreserving
    (fun x : FourierMomentum3 => WithLp.ofLp x)
    (PiLp.volume_preserving_ofLp (ι := Fin 3))
    (embeddedErrorLp t N F)

/-- The coordinate bridge preserves the `L2` norm. -/
theorem euclideanErrorLp_norm_eq (t : Real) (N : Nat)
    (F : Momentum3 -> Spinor2) :
    ‖euclideanErrorLp t N F‖ = ‖embeddedErrorLp t N F‖ := by
  exact Lp.norm_compMeasurePreserving _ _

/-- Inverse-Fourier reconstruction of the changing-cell live error. -/
def positionErrorLp (t : Real) (N : Nat) (F : Momentum3 -> Spinor2) :
    Lp Spinor2 2 (volume : Measure FourierMomentum3) :=
  (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor2).symm
    (euclideanErrorLp t N F)

/-- Plancherel preserves the reconstruction-error norm. -/
theorem positionErrorLp_norm_eq (t : Real) (N : Nat)
    (F : Momentum3 -> Spinor2) :
    ‖positionErrorLp t N F‖ = ‖euclideanErrorLp t N F‖ := by
  exact
    (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor2).symm.norm_map
      (euclideanErrorLp t N F)

/-- **HNU changing-cell live-term capstone.** The inverse-Fourier
reconstruction of the live-versus-exact cell-center error converges strongly
to zero in position-space `L2` for every componentwise `L2` two-spinor field. -/
theorem positionErrorLp_norm_tendsto_zero
    (t : Real) (F : Momentum3 -> Spinor2)
    (hF : forall j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    Tendsto (fun N => ‖positionErrorLp t N F‖) atTop (nhds 0) := by
  apply (embeddedErrorLp_norm_tendsto_zero t F hF).congr'
  exact Filter.Eventually.of_forall fun N =>
    ((positionErrorLp_norm_eq t N F).trans
      (euclideanErrorLp_norm_eq t N F)).symm

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUChangingCellL2.qAbs_qCenter_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms qAbs_qCenter_le

/-- info: 'PhysicsSM.Draft.NullEdge.HNUChangingCellL2.positionErrorLp_norm_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positionErrorLp_norm_tendsto_zero

end PhysicsSM.Draft.NullEdge.HNUChangingCellL2
