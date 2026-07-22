import Mathlib.Analysis.Calculus.MeanValue

/-!
# Finite-difference bounds for a discrete adiabatic schedule

This focused target isolates the calculus bridge used by quantitative
discrete-time adiabatic theorems. A bounded first derivative gives an `O(h)`
one-step difference, while a bounded second derivative gives an `O(h^2)`
second difference. The final statement specializes to `h = 1 / T`.

The target is generic normed-space analysis. It does not assert a spectral
gap, identify an HNU band, or prove an adiabatic theorem.

Provenance: theorem shape extracted clean-room from the finite-difference
hypotheses in Costa et al., PRX Quantum 3, 040303 (2022), arXiv:2111.08152,
and reduced to Mathlib's vector-valued mean-value API.
-/

open Set

noncomputable section

namespace DiscreteAdiabaticFiniteDifferences

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace Real E]

/-- A uniformly bounded derivative controls one discrete step. -/
theorem first_difference_bound
    (W W1 : Real -> E) (a h C1 : Real)
    (hh : 0 <= h) (hC1 : 0 <= C1)
    (hW : forall x, HasDerivAt W (W1 x) x)
    (hW1 : forall x, x ∈ Set.Icc a (a + h) -> norm (W1 x) <= C1) :
    norm (W (a + h) - W a) <= C1 * h := by
  have h_mean : ∀ x ∈ Set.Icc a (a + h),
      HasDerivWithinAt W (W1 x) (Set.Icc a (a + h)) x := by
    exact fun x _ => (hW x).hasDerivWithinAt
  have h_bound := @Convex.norm_image_sub_le_of_norm_hasDerivWithin_le
  simpa [abs_of_nonneg hh] using
    h_bound h_mean hW1 (convex_Icc _ _)
      (Set.left_mem_Icc.mpr (by linarith))
      (Set.right_mem_Icc.mpr (by linarith))

/-- A uniformly bounded second derivative controls variation of the first
derivative over one step. -/
theorem first_derivative_difference_bound
    (W1 W2 : Real -> E) (a h C2 : Real)
    (hh : 0 <= h) (hC2 : 0 <= C2)
    (hW1 : forall x, HasDerivAt W1 (W2 x) x)
    (hW2 : forall x, x ∈ Set.Icc a (a + h) -> norm (W2 x) <= C2) :
    norm (W1 (a + h) - W1 a) <= C2 * h := by
  convert first_difference_bound W1 W2 a h C2 hh hC2 hW1 hW2

/-- A uniformly bounded second derivative controls the second forward
difference by `C2 * h^2`. -/
theorem second_difference_bound
    (W W1 W2 : Real -> E) (a h C2 : Real)
    (hh : 0 <= h) (hC2 : 0 <= C2)
    (hW : forall x, HasDerivAt W (W1 x) x)
    (hW1 : forall x, HasDerivAt W1 (W2 x) x)
    (hW2 : forall x, x ∈ Set.Icc a (a + 2 * h) -> norm (W2 x) <= C2) :
    norm ((W (a + 2 * h) - W (a + h)) -
      (W (a + h) - W a)) <= C2 * h ^ 2 := by
  set g : ℝ → E := fun x => W (x + h) - W x
  have hg' : ∀ x, HasDerivAt g (W1 (x + h) - W1 x) x := by
    intro x
    exact HasDerivAt.sub
      (by
        simpa using HasDerivAt.scomp x (hW _)
          (HasDerivAt.add (hasDerivAt_id x) (hasDerivAt_const _ _)))
      (hW _)
  have hg'_bound : ∀ x ∈ Set.Icc a (a + h),
      ‖W1 (x + h) - W1 x‖ ≤ C2 * h := by
    intro x hx
    convert first_derivative_difference_bound W1 W2 x h C2 hh hC2 hW1
      (fun y hy => hW2 y ⟨by linarith [hy.1, hx.1], by linarith [hy.2, hx.2]⟩) using 1
  have h_mvt : ‖g (a + h) - g a‖ ≤ (C2 * h) * h := by
    have h_bound := @Convex.norm_image_sub_le_of_norm_hasDerivWithin_le
    convert h_bound
      (fun x _ => (hg' x).hasDerivWithinAt)
      (fun x hx => hg'_bound x hx) (convex_Icc a (a + h))
      (Set.left_mem_Icc.mpr (by linarith))
      (Set.right_mem_Icc.mpr (by linarith)) using 1
    norm_num [abs_of_nonneg, hh]
  grind

/-- The exact `1/T` and `1/T^2` hypotheses needed by a discrete adiabatic
theorem follow from uniform first- and second-derivative bounds. -/
theorem sampled_difference_bounds
    (W W1 W2 : Real -> E) (a C1 C2 : Real) (T : Nat)
    (hT : 0 < T) (hC1 : 0 <= C1) (hC2 : 0 <= C2)
    (hW : forall x, HasDerivAt W (W1 x) x)
    (hW1 : forall x, HasDerivAt W1 (W2 x) x)
    (hW1norm : forall x, x ∈ Set.Icc a (a + 2 / (T : Real)) ->
      norm (W1 x) <= C1)
    (hW2norm : forall x, x ∈ Set.Icc a (a + 2 / (T : Real)) ->
      norm (W2 x) <= C2) :
    norm (W (a + 1 / (T : Real)) - W a) <= C1 / (T : Real) /\
    norm ((W (a + 2 / (T : Real)) - W (a + 1 / (T : Real))) -
      (W (a + 1 / (T : Real)) - W a)) <= C2 / (T : Real) ^ 2 := by
  constructor
  · convert first_difference_bound W W1 a (1 / T : ℝ) C1 (by positivity)
      hC1 hW (fun x hx => hW1norm x <| by
        constructor <;> ring_nf at * <;>
          nlinarith [hx.1, hx.2,
            show (T : ℝ) ≥ 1 by exact Nat.one_le_cast.mpr hT,
            mul_inv_cancel₀ (by positivity : (T : ℝ) ≠ 0)]) using 1
    ring
  · convert second_difference_bound W W1 W2 a (1 / (T : ℝ)) C2
      (by positivity) (by positivity) hW hW1 _ using 1 <;> ring
    exact fun x hx => hW2norm x
      ⟨hx.1, hx.2.trans (by ring_nf; norm_num)⟩

end DiscreteAdiabaticFiniteDifferences
