import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongScaffold

/-!
# Three-term estimate for changing momentum-cell projections

This module proves the quantitative approximation inequality used to pass from
compact smooth Lipschitz fields to arbitrary `L2` fields. The constants are
kept explicit: two contraction-controlled errors contribute `6`, and the
smooth-field projection error contributes `3`.

The proof was produced by Aristotle task
`8c72c544-703d-464e-a18b-c0503868136d` and reviewed locally without changing
the target statement.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionThreeTerm

open ChangingMomentumCellIsometry
open ChangingMomentumCellProjectionStrongScaffold

/-- Pointwise three-term squared-norm estimate. -/
lemma three_term_norm_sq (a b c : Complex) :
    ‖a + b + c‖ ^ 2 <= 3 * (‖a‖ ^ 2 + ‖b‖ ^ 2 + ‖c‖ ^ 2) := by
  norm_num [Complex.normSq, Complex.sq_norm]
  linarith [sq_nonneg (a.re - b.re), sq_nonneg (a.re - c.re),
    sq_nonneg (b.re - c.re), sq_nonneg (a.im - b.im),
    sq_nonneg (a.im - c.im), sq_nonneg (b.im - c.im)]

/-- The squared norm of the projection of an `L2` difference is integrable. -/
lemma projectAt_diff_norm_sq_integrable (N : Nat) (f g : Momentum3 -> Complex) :
    Integrable (fun x => ‖projectAt N (f - g) x‖ ^ 2) := by
  exact memLp_two_integrable_norm_sq (projectAt_memLp N (f - g))

/-- The squared norm of an `L2` difference is integrable. -/
lemma diff_norm_sq_integrable (f g : Momentum3 -> Complex)
    (hf : MemLp f 2 volume) (hg : MemLp g 2 volume) :
    Integrable (fun x => ‖f x - g x‖ ^ 2) := by
  have hfg : MemLp (f - g) 2 volume := hf.sub hg
  have h := memLp_two_integrable_norm_sq hfg
  simpa [Pi.sub_apply] using h

/-- Quantitative three-term control of the cell-projection error through an
arbitrary `L2` approximant `g`. -/
theorem projectAt_sq_error_le_of_approx (N : Nat)
    (f g : Momentum3 -> Complex)
    (hf : MemLp f 2 volume) (hg : MemLp g 2 volume) :
    ∫ x, ‖projectAt N f x - f x‖ ^ 2 <=
      6 * (∫ x, ‖f x - g x‖ ^ 2) +
        3 * (∫ x, ‖projectAt N g x - g x‖ ^ 2) := by
  have hStep1 :
      ∫ x, ‖projectAt N f x - f x‖ ^ 2 <=
        3 * (∫ x, ‖projectAt N (f - g) x‖ ^ 2) +
        3 * (∫ x, ‖projectAt N g x - g x‖ ^ 2) +
        3 * (∫ x, ‖g x - f x‖ ^ 2) := by
    rw [← MeasureTheory.integral_const_mul,
      ← MeasureTheory.integral_const_mul,
      ← MeasureTheory.integral_const_mul,
      ← MeasureTheory.integral_add, ← MeasureTheory.integral_add]
    · refine MeasureTheory.integral_mono_of_nonneg ?_ ?_ ?_
      · exact Filter.Eventually.of_forall fun x => sq_nonneg _
      · exact MeasureTheory.Integrable.add
          (MeasureTheory.Integrable.add
            (MeasureTheory.Integrable.const_mul
              (projectAt_diff_norm_sq_integrable N f g) _)
            (MeasureTheory.Integrable.const_mul
              (projectAt_sub_sq_integrable N g hg) _))
          (MeasureTheory.Integrable.const_mul
            (diff_norm_sq_integrable g f hg hf) _)
      · filter_upwards with x
        have hThreeTerm :
            ‖projectAt N f x - f x‖ ^ 2 <=
              3 * (‖projectAt N (f - g) x‖ ^ 2 +
                ‖projectAt N g x - g x‖ ^ 2 + ‖g x - f x‖ ^ 2) := by
          have hDecomp :
              projectAt N f x - f x =
                projectAt N (f - g) x + (projectAt N g x - g x) +
                  (g x - f x) := by
            rw [projectAt_sub N f g hf hg]
            simp only [Pi.sub_apply]
            ring
          convert three_term_norm_sq (projectAt N (f - g) x)
            (projectAt N g x - g x) (g x - f x) using 1
          norm_num [hDecomp]
        linarith
    · exact MeasureTheory.Integrable.add
        (MeasureTheory.Integrable.const_mul
          (projectAt_diff_norm_sq_integrable N f g) _)
        (MeasureTheory.Integrable.const_mul
          (projectAt_sub_sq_integrable N g hg) _)
    · exact MeasureTheory.Integrable.const_mul
        (diff_norm_sq_integrable g f hg hf) _
    · exact MeasureTheory.Integrable.const_mul
        (projectAt_diff_norm_sq_integrable N f g) _
    · exact MeasureTheory.Integrable.const_mul
        (projectAt_sub_sq_integrable N g hg) _
  have hStep2 :
      ∫ x, ‖projectAt N (f - g) x‖ ^ 2 <=
        ∫ x, ‖f x - g x‖ ^ 2 := by
    apply projectAt_L2_contraction N (f - g) (hf.sub hg)
  linarith [show ∫ x, ‖g x - f x‖ ^ 2 = ∫ x, ‖f x - g x‖ ^ 2 by
    congr
    ext
    rw [← norm_neg, neg_sub]]

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionThreeTerm
