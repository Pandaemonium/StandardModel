import PhysicsSM.Draft.NullEdge.IntrinsicRankFourGeneralPerturbation
import Mathlib.Analysis.Normed.Algebra.Spectrum

/-!
# A resolvent bridge for finite self-adjoint perturbations

This file supplies the analytic step immediately before a Riesz-projector or
Davis--Kahan estimate.  The results are stated first in a Banach algebra, so
in particular apply to continuous endomorphisms of a finite-dimensional real
or complex inner-product space.

If `z` is in the resolvent set of `A` and
`‖(z-A)⁻¹‖ ‖B-A‖ < 1`, then `z` remains in the resolvent set of `B`.
Moreover, the perturbed resolvent and its displacement satisfy explicit
Neumann-series bounds.  These are genuine operator-perturbation conclusions;
no projector-distance hypothesis is assumed.

The final section records that the five-dimensional rational off-diagonal
witness from `GeneralPerturbation` is a symmetric perturbation covered by this
framework.  Constructing and estimating a contour integral of these resolvents
is the remaining step to a full spectral-projector theorem.

Exactly three successor results are indicated by this API:

1. `norm_resolvent_eq_inv_dist_spectrum_of_selfAdjoint`: identify the
   resolvent norm of a finite self-adjoint operator with reciprocal distance
   to its real spectrum;
2. `norm_rieszProjector_sub_le_of_contour`: integrate
   `norm_resolvent_sub_le_of_norm_mul_lt_one` along a separating contour;
3. `rankFour_rieszSector_stable_of_selfAdjoint_norm_lt_gap`: combine that
   contour estimate with
   `rankFour_spectral_sector_stable_of_projector_norm_lt_one`.

Provenance: clean-room Aristotle return
`62b38c16-d555-4aad-a231-b28c137de516` (task
`9f08f2bc-ea45-40a7-8312-6405b0d29539`), locally reviewed and rebuilt under
the pinned project toolchain.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector

open scoped Topology

section BanachAlgebra

variable {𝕜 R : Type*} [NormedField 𝕜] [NormedRing R] [NormOneClass R]
  [NormedAlgebra 𝕜 R] [CompleteSpace R]

/-
The resolvent identity, written in the orientation useful for perturbing
`a` to `b`.
-/
omit [NormOneClass R] [CompleteSpace R] in
theorem resolvent_sub_resolvent_eq
    (a b : R) (z : 𝕜)
    (ha : z ∈ resolventSet 𝕜 a)
    (hb : z ∈ resolventSet 𝕜 b) :
    resolvent b z - resolvent a z =
      resolvent b z * (b - a) * resolvent a z := by
  simp_all +decide [ resolvent, sub_mul, mul_sub ];
  simp_all +decide [ mul_assoc, Ring.inverse ];
  cases ‹IsUnit ( ( algebraMap 𝕜 R ) z - b ) › ; cases ‹IsUnit ( ( algebraMap 𝕜 R ) z - a ) › ; simp_all +decide [ ← mul_assoc ];
  rename_i u hu v hv;
  simp +decide [ show b = ( algebraMap 𝕜 R ) z - u from by rw [ hu, sub_sub_cancel ], show a = ( algebraMap 𝕜 R ) z - v from by rw [ hv, sub_sub_cancel ], mul_sub, sub_mul, mul_assoc ]

/-
A resolvent point survives any perturbation smaller than the reciprocal
of the old resolvent norm.
-/
omit [NormOneClass R] in
theorem mem_resolventSet_of_norm_mul_lt_one
    (a b : R) (z : 𝕜)
    (ha : z ∈ resolventSet 𝕜 a)
    (hsmall : ‖resolvent a z‖ * ‖b - a‖ < 1) :
    z ∈ resolventSet 𝕜 b := by
  have h_unit : IsUnit (1 - resolvent a z * (b - a)) := by
    convert isUnit_one_sub_of_norm_lt_one _;
    · infer_instance;
    · exact lt_of_le_of_lt ( norm_mul_le _ _ ) hsmall;
  have h_unit : IsUnit ((algebraMap 𝕜 R z - a) * (1 - resolvent a z * (b - a))) := by
    exact IsUnit.mul ( by simpa [ resolventSet ] using ha ) h_unit;
  convert h_unit using 1 ; simp +decide [ mul_sub, sub_mul, resolvent ];
  simp +decide [ ← mul_assoc, ← sub_mul ];
  rw [ Ring.mul_inverse_cancel _ ha ] ; simp +decide;
  rfl

/-
Quantitative Neumann bound for the perturbed resolvent.
-/
theorem norm_resolvent_le_of_norm_mul_lt_one
    (a b : R) (z : 𝕜)
    (ha : z ∈ resolventSet 𝕜 a)
    (hsmall : ‖resolvent a z‖ * ‖b - a‖ < 1) :
    ‖resolvent b z‖ ≤
      ‖resolvent a z‖ /
        (1 - ‖resolvent a z‖ * ‖b - a‖) := by
  obtain ⟨ u, hu ⟩ := ha.exists_left_inv;
  have h_inv : (algebraMap 𝕜 R z - b) * (resolvent a z * (∑' n : ℕ, ((b - a) * resolvent a z) ^ n)) = 1 := by
    have h_inv : (1 - (b - a) * resolvent a z) * (∑' n : ℕ, ((b - a) * resolvent a z) ^ n) = 1 := by
      have h_inv : Summable (fun n : ℕ => ((b - a) * resolvent a z) ^ n) := by
        refine' summable_geometric_of_norm_lt_one _;
        exact lt_of_le_of_lt ( norm_mul_le _ _ ) ( by linarith );
      have := h_inv.hasSum.tendsto_sum_nat;
      exact tendsto_nhds_unique ( Filter.Tendsto.mul tendsto_const_nhds this ) ( by simpa [ mul_neg_geom_sum ] using tendsto_const_nhds.sub ( h_inv.tendsto_atTop_zero ) );
    have h_inv : (algebraMap 𝕜 R z - b) * resolvent a z = 1 - (b - a) * resolvent a z := by
      have h_inv : (algebraMap 𝕜 R z - a) * resolvent a z = 1 := by
        simp +decide [ resolvent ];
        grind +suggestions;
      simp +decide [ sub_mul, ← h_inv ];
    simp_all +decide [ ← mul_assoc ];
  have h_inv : resolvent b z = resolvent a z * (∑' n : ℕ, ((b - a) * resolvent a z) ^ n) := by
    have h_inv : IsUnit (algebraMap 𝕜 R z - b) := by
      exact mem_resolventSet_of_norm_mul_lt_one a b z ha hsmall;
    cases' h_inv with u hu;
    simp_all +decide [ resolvent ];
    rw [ ← hu, Ring.inverse_unit ];
    exact u.inv_eq_of_mul_eq_one_right ( by simpa [ hu ] using h_inv );
  rw [ h_inv, div_eq_mul_inv ];
  refine' le_trans ( norm_mul_le _ _ ) ( mul_le_mul_of_nonneg_left _ ( norm_nonneg _ ) );
  have h_sum : ∀ n : ℕ, ‖((b - a) * resolvent a z) ^ n‖ ≤ (‖resolvent a z‖ * ‖b - a‖) ^ n := by
    intro n
    induction' n with n ih;
    · simp +decide [ NormOneClass.norm_one ];
    · simpa only [ pow_succ' ] using le_trans ( norm_mul_le _ _ ) ( mul_le_mul ( norm_mul_le _ _ ) ih ( by positivity ) ( by positivity ) ) |> le_trans <| by ring_nf; norm_num;
  refine' le_trans ( norm_tsum_le_tsum_norm _ ) _;
  · exact Summable.of_nonneg_of_le ( fun n => norm_nonneg _ ) h_sum ( summable_geometric_of_lt_one ( by positivity ) hsmall );
  · exact le_trans ( Summable.tsum_le_tsum h_sum ( by exact Summable.of_nonneg_of_le ( fun n => norm_nonneg _ ) ( fun n => h_sum n ) ( summable_geometric_of_lt_one ( by positivity ) hsmall ) ) ( by exact summable_geometric_of_lt_one ( by positivity ) hsmall ) ) ( by rw [ tsum_geometric_of_lt_one ( by positivity ) hsmall ] )

/-
Quantitative displacement estimate for resolvents under perturbation.
-/
theorem norm_resolvent_sub_le_of_norm_mul_lt_one
    (a b : R) (z : 𝕜)
    (ha : z ∈ resolventSet 𝕜 a)
    (hsmall : ‖resolvent a z‖ * ‖b - a‖ < 1) :
    ‖resolvent b z - resolvent a z‖ ≤
      (‖resolvent a z‖ ^ 2 * ‖b - a‖) /
        (1 - ‖resolvent a z‖ * ‖b - a‖) := by
  have h_perturbation : ‖resolvent b z - resolvent a z‖ ≤ ‖resolvent b z‖ * ‖b - a‖ * ‖resolvent a z‖ := by
    convert norm_mul_le ( resolvent b z * ( b - a ) ) ( resolvent a z ) |> le_trans <| ?_ using 1;
    · rw [ ← resolvent_sub_resolvent_eq a b z ha ( mem_resolventSet_of_norm_mul_lt_one a b z ha hsmall ) ];
    · exact mul_le_mul_of_nonneg_right ( norm_mul_le _ _ ) ( norm_nonneg _ );
  have := norm_resolvent_le_of_norm_mul_lt_one a b z ha hsmall;
  convert h_perturbation.trans ( mul_le_mul_of_nonneg_right ( mul_le_mul_of_nonneg_right this ( norm_nonneg _ ) ) ( norm_nonneg _ ) ) using 1 ; ring

end BanachAlgebra

section RationalWitness

/-- The old diagonal operator plus the explicit rational off-diagonal mixing
from `GeneralPerturbation`. -/
def rationalPerturbedOperator : Module.End Real (Fin 5 → Real) :=
  diagonalOperator counterexampleEigenvalue + rationalMixingPerturbation

/-
The five-dimensional perturbed operator is symmetric for the standard real
inner product.
-/
theorem rationalPerturbedOperator_symmetric (x y : Fin 5 → Real) :
    (∑ i, x i * rationalPerturbedOperator y i) =
      ∑ i, rationalPerturbedOperator x i * y i := by
  unfold rationalPerturbedOperator;
  simp +decide [ diagonalOperator, rationalMixingPerturbation, Fin.sum_univ_succ ] ; ring!

/-
The off-diagonal perturbation has the sharp pointwise Euclidean bound
`‖Ev‖ ≤ (1/10) ‖v‖`.
-/
theorem rationalMixingPerturbation_norm_apply_le (v : EuclideanSpace Real (Fin 5)) :
    ‖rationalMixingPerturbation v‖ ≤ (1 / 10 : Real) * ‖v‖ := by
  norm_num [ EuclideanSpace.norm_eq, rationalMixingPerturbation ];
  rw [ Pi.norm_def ];
  rw [show (Finset.univ : Finset (Fin 5)) = {0, 1, 2, 3, 4} by rfl]
  simp +decide [Finset.sup_insert]
  constructor <;> rw [div_eq_inv_mul] <;> gcongr <;>
    exact Real.abs_le_sqrt <| by nlinarith

end RationalWitness

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.resolvent_sub_resolvent_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms resolvent_sub_resolvent_eq

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.mem_resolventSet_of_norm_mul_lt_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mem_resolventSet_of_norm_mul_lt_one

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.norm_resolvent_le_of_norm_mul_lt_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms norm_resolvent_le_of_norm_mul_lt_one

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.norm_resolvent_sub_le_of_norm_mul_lt_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms norm_resolvent_sub_le_of_norm_mul_lt_one

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.rationalPerturbedOperator_symmetric' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rationalPerturbedOperator_symmetric

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.rationalMixingPerturbation_norm_apply_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rationalMixingPerturbation_norm_apply_le

end PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector
