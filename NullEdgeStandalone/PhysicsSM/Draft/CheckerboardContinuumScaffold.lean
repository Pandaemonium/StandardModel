import PhysicsSM.Draft.Checkerboard1D

/-!
# Checkerboard continuum-limit scaffold

This module records Lean-facing setup for the next checkerboard lane after the
finite path-sum theorem.

The content here is deliberately finite or syntactic. It does not prove a
continuum limit. It adds:

* endpoint/displacement bookkeeping for fixed-length direction tuples;
* exact algebra for the unitary isotropic checkerboard step;
* a typed record of scaling data that future analytic statements can use.

Literature orientation is recorded in `docs/CHECKERBOARD_LITERATURE_REVIEW.md`.
-/

noncomputable section

namespace PhysicsSM.Draft.CheckerboardContinuumScaffold

open Matrix
open scoped BigOperators

open PhysicsSM.Draft.Checkerboard1D

/-! ## Endpoint bookkeeping -/

/-- Number of outgoing right-moving edges in a tuple path.

Convention: for the transition from `v i.castSucc` to `v i.succ`, the physical
edge direction is recorded as the outgoing direction `v i.succ`. This convention
is explicit because some checkerboard papers index the first segment
differently. -/
def outgoingRightCount {n : Nat} (v : Fin (n + 1) -> Direction) : Nat :=
  Finset.univ.sum (fun i : Fin n => if v i.succ = 0 then 1 else 0)

/-- Number of outgoing left-moving edges in a tuple path. -/
def outgoingLeftCount {n : Nat} (v : Fin (n + 1) -> Direction) : Nat :=
  Finset.univ.sum (fun i : Fin n => if v i.succ = 1 then 1 else 0)

/-- Every outgoing edge is either right-moving or left-moving. -/
theorem outgoingRightCount_add_outgoingLeftCount {n : Nat}
    (v : Fin (n + 1) -> Direction) :
    outgoingRightCount v + outgoingLeftCount v = n := by
  unfold outgoingRightCount outgoingLeftCount
  rw [<- Finset.sum_add_distrib]
  trans Finset.univ.sum (fun _ : Fin n => 1)
  {
    refine Finset.sum_congr rfl ?_
    intro i _
    by_cases hright : v i.succ = 0
    {
      simp [hright]
    }
    {
      have hleft : v i.succ = 1 := Fin.eq_one_of_ne_zero (v i.succ) hright
      simp [hleft]
    }
  }
  simp

/-- Net spatial displacement in units of the lattice spacing, using the
outgoing-edge convention. -/
def outgoingDisplacement {n : Nat} (v : Fin (n + 1) -> Direction) : Int :=
  (outgoingRightCount v : Int) - (outgoingLeftCount v : Int)

/-! ## Exact algebra of the unitary isotropic step -/

/-- The unitary isotropic checkerboard step. -/
def isotropicStep (theta : Real) : Matrix Direction Direction Complex :=
  checkerStep (Real.cos theta : Complex) (Real.cos theta : Complex)
    (Complex.I * (Real.sin theta : Complex))

/-- The direction-reversal matrix squares to the identity. -/
theorem reversal_sq : reversal * reversal = (1 : Matrix Direction Direction Complex) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [reversal, Matrix.mul_apply, Fin.sum_univ_two]

/-- Infinitesimal generator of the unitary isotropic checkerboard step in the
two-direction finite model. It is `i` times direction reversal. -/
def isotropicGenerator : Matrix Direction Direction Complex :=
  fun i j => Complex.I * reversal i j

/-- The isotropic generator squares to minus the identity. -/
theorem isotropicGenerator_sq :
    isotropicGenerator * isotropicGenerator =
      -(1 : Matrix Direction Direction Complex) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [isotropicGenerator, reversal, Matrix.mul_apply, Fin.sum_univ_two,
      Complex.I_mul_I]

/-- Exact decomposition of the unitary isotropic step into identity plus the
direction-reversal generator. -/
theorem isotropicStep_eq_cos_one_add_i_sin_reversal (theta : Real) :
    isotropicStep theta =
      fun i j =>
        (Real.cos theta : Complex) * (1 : Matrix Direction Direction Complex) i j +
          (Complex.I * (Real.sin theta : Complex)) * reversal i j := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [isotropicStep, checkerStep, nullTransport, massFlip, reversal]

/-- Exact generator form of the unitary isotropic checkerboard step. -/
theorem isotropicStep_eq_cos_smul_one_add_sin_smul_generator (theta : Real) :
    isotropicStep theta =
      (Real.cos theta : Complex) • (1 : Matrix Direction Direction Complex) +
        (Real.sin theta : Complex) • isotropicGenerator := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [isotropicStep, checkerStep, nullTransport, massFlip, reversal,
      isotropicGenerator] <;> ring

/-- Exact finite small-angle decomposition. The linear generator term and the
cosine remainder are separated without asserting an analytic limit. -/
theorem isotropicStep_eq_one_add_sin_generator_add_cos_remainder
    (theta : Real) :
    isotropicStep theta =
      (1 : Matrix Direction Direction Complex) +
        (Real.sin theta : Complex) • isotropicGenerator +
        ((Real.cos theta : Complex) - 1) •
          (1 : Matrix Direction Direction Complex) := by
  rw [isotropicStep_eq_cos_smul_one_add_sin_smul_generator]
  ext i j
  fin_cases i <;> fin_cases j <;> simp [isotropicGenerator] <;> ring

/-- Exact first-order remainder for the zero-angle expansion of
`isotropicStep`.

The two scalar remainders are separated so that later analytic work can bound
`sin theta - theta` and `cos theta - 1` without reopening the finite matrix
algebra. -/
def isotropicStepFirstOrderRemainder (theta : Real) :
    Matrix Direction Direction Complex :=
  ((Real.sin theta : Complex) - (theta : Complex)) • isotropicGenerator +
    ((Real.cos theta : Complex) - 1) •
      (1 : Matrix Direction Direction Complex)

/-- Exact zero-angle first-order expansion of the isotropic step, with the
remainder packaged as `isotropicStepFirstOrderRemainder`. -/
theorem isotropicStep_eq_one_add_theta_generator_add_remainder
    (theta : Real) :
    isotropicStep theta =
      (1 : Matrix Direction Direction Complex) +
        (theta : Complex) • isotropicGenerator +
        isotropicStepFirstOrderRemainder theta := by
  rw [isotropicStep_eq_cos_smul_one_add_sin_smul_generator]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [isotropicStepFirstOrderRemainder, isotropicGenerator] <;> ring

/-- The packaged first-order remainder has zero derivative at zero. This is an
entrywise finite-dimensional calculus statement, not a quantitative bound. -/
theorem isotropicStepFirstOrderRemainder_hasDerivAt_zero :
    HasDerivAt isotropicStepFirstOrderRemainder
      (0 : Matrix Direction Direction Complex) 0 := by
  have hsin : HasDerivAt (fun t : Real => (Real.sin t : Complex)) 1 0 := by
    simpa using (Real.hasDerivAt_sin 0).ofReal_comp
  have hid : HasDerivAt (fun t : Real => (t : Complex)) 1 0 := by
    simpa using (hasDerivAt_id' (x := (0 : Real))).ofReal_comp
  have hsin_sub :
      HasDerivAt
        (fun t : Real => (Real.sin t : Complex) - (t : Complex)) 0 0 := by
    simpa using hsin.sub hid
  have hcos : HasDerivAt (fun t : Real => (Real.cos t : Complex)) 0 0 := by
    simpa using (Real.hasDerivAt_cos 0).ofReal_comp
  have hcos_sub :
      HasDerivAt (fun t : Real => (Real.cos t : Complex) - 1) 0 0 := by
    simpa only [Pi.sub_apply, sub_zero] using
      hcos.sub (hasDerivAt_const (0 : Real) (1 : Complex))
  apply hasDerivAt_pi.2
  intro i
  apply hasDerivAt_pi.2
  intro j
  fin_cases i <;> fin_cases j <;>
    simp [isotropicStepFirstOrderRemainder, isotropicGenerator, reversal]
  · simpa using hcos_sub
  · simpa [mul_comm] using hsin_sub.const_mul Complex.I
  · simpa [mul_comm] using hsin_sub.const_mul Complex.I
  · simpa using hcos_sub

/-! ## Generator expansion (finite calculus)

The unitary isotropic step is a real one-parameter family of finite complex
matrices. Its derivative is proved entrywise via `hasDerivAt_pi`, avoiding any
need to choose a matrix norm at this layer. These are finite calculus facts, not
continuum Dirac-limit theorems. -/

/-- Derivative of the unitary isotropic step at an arbitrary angle. -/
theorem hasDerivAt_isotropicStep (theta : Real) :
    HasDerivAt isotropicStep
      ((-(Real.sin theta) : Complex) •
          (1 : Matrix Direction Direction Complex) +
        (Real.cos theta : Complex) • isotropicGenerator) theta := by
  apply hasDerivAt_pi.2
  intro i
  apply hasDerivAt_pi.2
  intro j
  have hcos : HasDerivAt (fun t : Real => (Real.cos t : Complex))
      (-(Real.sin theta) : Complex) theta := by
    simpa using (Real.hasDerivAt_cos theta).ofReal_comp
  have hsin : HasDerivAt
      (fun t : Real => Complex.I * (Real.sin t : Complex))
      ((Real.cos theta : Complex) * Complex.I) theta := by
    simpa [mul_comm] using
      ((Real.hasDerivAt_sin theta).ofReal_comp).const_mul Complex.I
  fin_cases i <;> fin_cases j <;>
    simp only [isotropicStep, checkerStep, nullTransport, massFlip, reversal,
      isotropicGenerator, Matrix.add_apply, Matrix.smul_apply,
      Matrix.one_apply, Matrix.of_apply, Matrix.cons_val',
      Matrix.cons_val_zero, Matrix.cons_val_one, Fin.isValue, smul_eq_mul,
      Fin.mk_zero, Fin.mk_one]
  · simpa using hcos
  · simpa using hsin
  · simpa using hsin
  · simpa using hcos

/-- The unitary isotropic checkerboard step has infinitesimal generator
`isotropicGenerator` at zero angle.

This is the first analytic bridge from the finite checkerboard matrix to the
usual small-angle generator statement. It is still only a finite-dimensional
calculus identity; it does not assert any spacetime continuum limit. -/
theorem isotropicStep_hasDerivAt_zero :
    HasDerivAt isotropicStep isotropicGenerator 0 := by
  simpa using hasDerivAt_isotropicStep 0

/-- Aristotle-name alias for `isotropicStep_hasDerivAt_zero`. -/
theorem hasDerivAt_isotropicStep_zero :
    HasDerivAt isotropicStep isotropicGenerator 0 :=
  isotropicStep_hasDerivAt_zero

/-- At zero angle the unitary isotropic step is the identity. -/
theorem isotropicStep_zero :
    isotropicStep 0 = (1 : Matrix Direction Direction Complex) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [isotropicStep, checkerStep, nullTransport, massFlip, reversal]

/-- The reversal generator commutes with the isotropic step. -/
theorem reversal_commutes_isotropicStep (theta : Real) :
    reversal * isotropicStep theta = isotropicStep theta * reversal := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [isotropicStep, checkerStep, nullTransport, massFlip, reversal,
      Matrix.mul_apply, Fin.sum_univ_two]

/-- The infinitesimal generator commutes with each unitary isotropic step.

This is a finite two-direction identity, useful for later small-angle product
and exponential comparisons. -/
theorem isotropicGenerator_commutes_isotropicStep (theta : Real) :
    isotropicGenerator * isotropicStep theta =
      isotropicStep theta * isotropicGenerator := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [isotropicGenerator, isotropicStep, checkerStep, nullTransport,
      massFlip, reversal, Matrix.mul_apply, Fin.sum_univ_two] <;> ring

/-! ## Small-angle quotient and little-o estimates

These are quantitative counterparts of the finite calculus identities above.
They are derived from the packaged `HasDerivAt` facts through Mathlib's slope
and little-o APIs, so they state the same first-order expansion with vanishing
linear-order remainder in explicit quotient/asymptotic form. They do not assert
a continuum Dirac limit. -/

open Filter Topology Asymptotics

/-- Scalar quotient estimate: `(sin theta - theta) / theta` tends to zero as
`theta` tends to zero through nonzero reals. -/
theorem sin_sub_id_div_tendsto_zero :
    Filter.Tendsto (fun theta : Real => (Real.sin theta - theta) / theta)
      (nhdsWithin 0 {(0 : Real)}ᶜ) (nhds 0) := by
  simpa [div_eq_inv_mul] using
    HasDerivAt.tendsto_slope_zero
      (HasDerivAt.sub (Real.hasDerivAt_sin 0) (hasDerivAt_id 0))

/-- Scalar quotient estimate: `(cos theta - 1) / theta` tends to zero as
`theta` tends to zero through nonzero reals. -/
theorem cos_sub_one_div_tendsto_zero :
    Filter.Tendsto (fun theta : Real => (Real.cos theta - 1) / theta)
      (nhdsWithin 0 {(0 : Real)}ᶜ) (nhds 0) := by
  simpa [div_eq_inv_mul] using
    HasDerivAt.tendsto_slope_zero (Real.hasDerivAt_cos 0)

/-- Scalar little-o estimate: `sin theta - theta = o(theta)` as `theta` tends
to zero. -/
theorem sin_sub_id_isLittleO :
    (fun theta : Real => Real.sin theta - theta) =o[nhds (0 : Real)]
      (fun theta : Real => theta) := by
  have h := Real.hasDerivAt_sin 0
  rw [hasDerivAt_iff_isLittleO_nhds_zero] at h
  simpa using h

/-- Scalar little-o estimate: `cos theta - 1 = o(theta)` as `theta` tends to
zero. -/
theorem cos_sub_one_isLittleO :
    (fun theta : Real => Real.cos theta - 1) =o[nhds (0 : Real)]
      (fun theta : Real => theta) := by
  convert
    (hasDerivAt_iff_isLittleO_nhds_zero.mp
      (Real.hasDerivAt_cos (0 : Real))) using 1
  norm_num

/-- Entrywise/matrix quotient estimate: the packaged first-order remainder,
divided by `theta`, tends to the zero matrix as `theta` tends to zero through
nonzero reals. This is the matrix-valued form of the two scalar quotient
estimates above. -/
theorem isotropicStepFirstOrderRemainder_div_tendsto_zero :
    Filter.Tendsto
      (fun theta : Real => theta⁻¹ • isotropicStepFirstOrderRemainder theta)
      (nhdsWithin 0 {(0 : Real)}ᶜ) (nhds 0) := by
  have h0 : isotropicStepFirstOrderRemainder 0 =
      (0 : Matrix Direction Direction Complex) := by
    unfold isotropicStepFirstOrderRemainder
    norm_num
  have h := isotropicStepFirstOrderRemainder_hasDerivAt_zero
  rw [hasDerivAt_pi] at h
  simp_all +decide [tendsto_pi_nhds, hasDerivAt_iff_tendsto_slope_zero]
  rw [tendsto_pi_nhds]
  intro x
  fin_cases x <;> simp_all +decide [tendsto_pi_nhds]

/-! ## Explicit entrywise matrix norm and its normed estimate

We introduce an explicit scalar-valued entrywise L1 ("taxicab") norm on
`Matrix Direction Direction Complex`, defined as the sum of the complex moduli
of all entries. This is a concrete function, deliberately *not* a global
`Norm`/`NormedAddCommGroup` typeclass instance, so it cannot surprise any
downstream file relying on Mathlib's default matrix norm conventions.

With it we upgrade the entrywise quotient estimate
`isotropicStepFirstOrderRemainder_div_tendsto_zero` into a genuine scalar norm
statement: the entrywise L1 norm of the first-order remainder, divided by
`|theta|`, tends to zero as `theta` tends to zero through nonzero reals. -/

/-- Explicit entrywise L1 norm on `2x2` complex direction matrices: the sum of
the complex moduli of all entries. Provided as a plain scalar function rather
than a global `Norm` instance to avoid surprising downstream files. -/
def matrixL1Norm (M : Matrix Direction Direction Complex) : Real :=
  ∑ i, ∑ j, ‖M i j‖

/- The entrywise L1 norm is nonnegative. -/
theorem matrixL1Norm_nonneg (M : Matrix Direction Direction Complex) :
    0 ≤ matrixL1Norm M := by
  exact Finset.sum_nonneg fun i _ => Finset.sum_nonneg fun j _ => norm_nonneg _

/- The entrywise L1 norm of the zero matrix is zero. -/
theorem matrixL1Norm_zero :
    matrixL1Norm (0 : Matrix Direction Direction Complex) = 0 := by
  unfold matrixL1Norm
  aesop

/- The entrywise L1 norm is zero exactly on the zero matrix. -/
theorem matrixL1Norm_eq_zero_iff (M : Matrix Direction Direction Complex) :
    matrixL1Norm M = 0 ↔ M = 0 := by
  simp +decide [matrixL1Norm, Fin.sum_univ_succ]
  constructor <;> intro h
  · ext i j
    fin_cases i <;> fin_cases j <;> simp_all +decide
    · exact norm_eq_zero.mp (by
        linarith [norm_nonneg (M 0 0), norm_nonneg (M 0 1), norm_nonneg (M 1 0),
          norm_nonneg (M 1 1)])
    · exact norm_eq_zero.mp (by
        linarith [norm_nonneg (M 0 0), norm_nonneg (M 0 1), norm_nonneg (M 1 0),
          norm_nonneg (M 1 1)])
    · exact norm_eq_zero.mp (by
        linarith [norm_nonneg (M 0 0), norm_nonneg (M 0 1), norm_nonneg (M 1 0),
          norm_nonneg (M 1 1)])
    · exact norm_eq_zero.mp (by
        linarith [norm_nonneg (M 0 0), norm_nonneg (M 0 1), norm_nonneg (M 1 0),
          norm_nonneg (M 1 1)])
  · aesop

/- The entrywise L1 norm is absolutely homogeneous under real scalar multiplication. -/
theorem matrixL1Norm_smul_real (c : Real)
    (M : Matrix Direction Direction Complex) :
    matrixL1Norm (c • M) = |c| * matrixL1Norm M := by
  unfold matrixL1Norm
  simp +decide
  ring

/- The entrywise L1 norm is subadditive (triangle inequality). -/
theorem matrixL1Norm_add_le (M N : Matrix Direction Direction Complex) :
    matrixL1Norm (M + N) ≤ matrixL1Norm M + matrixL1Norm N := by
  unfold matrixL1Norm
  simpa only [← Finset.sum_add_distrib] using
    Finset.sum_le_sum fun i _ => Finset.sum_le_sum fun j _ => norm_add_le _ _

/- The entrywise L1 norm is a continuous scalar function. -/
theorem continuous_matrixL1Norm : Continuous matrixL1Norm := by
  refine' continuous_finset_sum _ fun i _ => continuous_finset_sum _ fun j _ => _
  fun_prop

/- If a matrix-valued function tends to the zero matrix along a filter, then its
entrywise L1 norm tends to zero. -/
theorem matrixL1Norm_tendsto_zero {α : Type*} {l : Filter α}
    {f : α → Matrix Direction Direction Complex}
    (h : Filter.Tendsto f l (nhds 0)) :
    Filter.Tendsto (fun a => matrixL1Norm (f a)) l (nhds 0) := by
  simpa [matrixL1Norm_zero] using
    Filter.Tendsto.comp (continuous_matrixL1Norm.tendsto 0) h

/- Explicit closed form of the entrywise L1 norm of the packaged first-order
remainder: it is `2 * |cos theta - 1| + 2 * |sin theta - theta|`. -/
theorem matrixL1Norm_isotropicStepFirstOrderRemainder (theta : Real) :
    matrixL1Norm (isotropicStepFirstOrderRemainder theta) =
      2 * |Real.cos theta - 1| + 2 * |Real.sin theta - theta| := by
  unfold matrixL1Norm isotropicStepFirstOrderRemainder
  simp +decide [Fin.sum_univ_two, isotropicGenerator]
  norm_num [Complex.normSq, Complex.norm_def, reversal]
  norm_cast
  rw [Real.sqrt_mul_self_eq_abs, Real.sqrt_mul_self_eq_abs]
  ring

/- Scalar normed estimate: the entrywise L1 norm of the first-order remainder,
divided by `|theta|`, tends to zero as `theta` tends to zero through nonzero
reals. This is the scalar-norm upgrade of
`isotropicStepFirstOrderRemainder_div_tendsto_zero`. -/
theorem isotropicStepFirstOrderRemainder_l1Norm_div_tendsto_zero :
    Filter.Tendsto
      (fun theta : Real =>
        matrixL1Norm (isotropicStepFirstOrderRemainder theta) / |theta|)
      (nhdsWithin 0 {(0 : Real)}ᶜ) (nhds 0) := by
  have h_tendsto_zero :
      Filter.Tendsto
        (fun theta : ℝ => matrixL1Norm (theta⁻¹ • isotropicStepFirstOrderRemainder theta))
        (nhdsWithin 0 {(0 : ℝ)}ᶜ) (nhds 0) := by
    convert matrixL1Norm_tendsto_zero _
    convert isotropicStepFirstOrderRemainder_div_tendsto_zero using 1
  convert h_tendsto_zero using 2
  norm_num [div_eq_inv_mul, abs_inv, div_eq_inv_mul, div_eq_mul_inv, matrixL1Norm_smul_real]

/-! ## Quantitative Taylor bounds for the first-order remainder

These are explicit scalar Taylor estimates upgrading the qualitative little-o /
quotient facts above into a clean quantitative L1-norm bound on the packaged
first-order remainder. They are elementary real-analysis inequalities; they do
not assert any continuum limit. -/

/-- Second-order cosine bound: `|cos x - 1| ≤ x^2 / 2` for all real `x`. -/
theorem abs_cos_sub_one_le_half_sq (x : Real) :
    |Real.cos x - 1| ≤ x ^ 2 / 2 := by
  rw [abs_le]
  constructor
  · nlinarith [Real.one_sub_sq_div_two_le_cos (x := x)]
  · nlinarith [Real.cos_le_one x, sq_nonneg x]

/-- Cubic lower bound for sine at nonnegative argument:
`x - x^3 / 6 ≤ sin x` for `0 ≤ x`. Proved via the fundamental theorem of
calculus: the integrand `cos t - 1 + t^2/2` is nonnegative. -/
theorem sin_ge_sub_cube_of_nonneg (x : Real) (hx : 0 ≤ x) :
    x - x ^ 3 / 6 ≤ Real.sin x := by
  -- By the fundamental theorem of calculus the difference equals the integral of
  -- `cos t - 1 + t^2/2`, whose integrand is nonnegative by the second-order
  -- cosine lower bound.
  have h_ftc : ∫ t in (0 : ℝ)..x, (Real.cos t - 1 + t ^ 2 / 2) ≥ 0 := by
    refine intervalIntegral.integral_nonneg hx (fun t ht => ?_)
    nlinarith [Real.one_sub_sq_div_two_le_cos (x := t)]
  norm_num at h_ftc
  linarith

/-- Third-order sine bound: `|sin x - x| ≤ |x|^3 / 6` for all real `x`. -/
theorem abs_sin_sub_le_sixth_cube (x : Real) :
    |Real.sin x - x| ≤ |x| ^ 3 / 6 := by
  have h_sin_ge_sub_cube_of_nonneg :
      ∀ x : ℝ, 0 ≤ x → x - x ^ 3 / 6 ≤ Real.sin x :=
    sin_ge_sub_cube_of_nonneg
  cases abs_cases x <;> cases abs_cases (Real.sin x - x) <;> simp +decide [*]
  · by_contra h_contra
    exact h_contra (by
      linarith [Real.sin_lt <| show 0 < x from
        lt_of_le_of_ne (by linarith) (Ne.symm <| by
          rintro rfl
          norm_num at h_contra)])
  · linarith [h_sin_ge_sub_cube_of_nonneg x (by linarith)]
  · have := h_sin_ge_sub_cube_of_nonneg (-x) (by linarith)
    norm_num at *
    linarith [Real.sin_neg x]
  · linarith [Real.sin_lt (neg_pos.mpr (by linarith : x < 0)), Real.sin_neg x]

/-- Quantitative L1-norm bound on the packaged first-order remainder:
`matrixL1Norm (isotropicStepFirstOrderRemainder x) ≤ x^2 + (1/3)|x|^3`.

This follows from the closed form
`2 * |cos x - 1| + 2 * |sin x - x|` combined with the scalar Taylor bounds
`abs_cos_sub_one_le_half_sq` and `abs_sin_sub_le_sixth_cube`. -/
theorem isotropicStepFirstOrderRemainder_l1Norm_le_sq_add_cube
    (x : Real) :
    matrixL1Norm (isotropicStepFirstOrderRemainder x) ≤
      x ^ 2 + (1 / 3 : Real) * |x| ^ 3 := by
  rw [matrixL1Norm_isotropicStepFirstOrderRemainder]
  have hcos := abs_cos_sub_one_le_half_sq x
  have hsin := abs_sin_sub_le_sixth_cube x
  nlinarith [hcos, hsin]

/-- The L1 norm of the packaged first-order remainder is `O(x^2)` as
`x -> 0`. This is a scalar asymptotic statement about the accumulated angle,
not a continuum Dirac-limit theorem. -/
theorem isotropicStepFirstOrderRemainder_l1Norm_isBigO_sq :
    (fun x : Real => matrixL1Norm (isotropicStepFirstOrderRemainder x))
      =O[nhds (0 : Real)] (fun x : Real => x ^ 2) := by
  rw [Asymptotics.isBigO_iff]
  refine ⟨2, ?_⟩
  filter_upwards [Icc_mem_nhds (show (-1 : Real) < 0 by norm_num)
      (show (0 : Real) < 1 by norm_num)] with x hx
  have hbound := isotropicStepFirstOrderRemainder_l1Norm_le_sq_add_cube x
  have hxabs : |x| ≤ 1 := by
    rw [abs_le]
    exact hx
  have hcube : |x| ^ 3 ≤ x ^ 2 := by
    calc
      |x| ^ 3 = |x| * |x| ^ 2 := by ring
      _ = |x| * x ^ 2 := by rw [sq_abs]
      _ ≤ 1 * x ^ 2 := by
        exact mul_le_mul_of_nonneg_right hxabs (sq_nonneg x)
      _ = x ^ 2 := by ring
  rw [Real.norm_eq_abs, abs_of_nonneg (matrixL1Norm_nonneg _),
    Real.norm_eq_abs, abs_of_nonneg (sq_nonneg x)]
  nlinarith

/-- The square function is little-o of the identity at zero. This helper keeps
the checkerboard remainder little-o proof explicit and local. -/
theorem sq_isLittleO_id_nhds_zero :
    (fun x : Real => x ^ 2) =o[nhds (0 : Real)] (fun x : Real => x) := by
  have hderiv : HasDerivAt (fun x : Real => x ^ 2) 0 0 := by
    simpa using (hasDerivAt_pow 2 (0 : Real))
  simpa using (hasDerivAt_iff_isLittleO_nhds_zero.mp hderiv)

/-- The L1 norm of the packaged first-order remainder is little-o of the
accumulated angle. -/
theorem isotropicStepFirstOrderRemainder_l1Norm_isLittleO_id :
    (fun x : Real => matrixL1Norm (isotropicStepFirstOrderRemainder x))
      =o[nhds (0 : Real)] (fun x : Real => x) :=
  isotropicStepFirstOrderRemainder_l1Norm_isBigO_sq.trans_isLittleO
    sq_isLittleO_id_nhds_zero

/-- Composed-filter form of the first-order remainder little-o estimate. -/
theorem isotropicStepFirstOrderRemainder_l1Norm_isLittleO_comp
    {α : Type*} {l : Filter α} {x : α → Real}
    (hx : Filter.Tendsto x l (nhds 0)) :
    (fun a => matrixL1Norm (isotropicStepFirstOrderRemainder (x a)))
      =o[l] x :=
  isotropicStepFirstOrderRemainder_l1Norm_isLittleO_id.comp_tendsto hx

/-! ## Typed analytic scaffold -/

/-- Scaling data for a future checkerboard-to-Dirac limit statement.

The field `timeStep` is the small checkerboard time spacing. The traditional
Feynman turn weight is proportional to `timeStep * mass * c^2 / hbar`; the
unitary quantum-walk normalization instead often records this through a small
angle. This structure records the common dimensional parameters without
choosing the final analytic theorem. -/
structure CheckerboardContinuumScale where
  timeStep : Nat -> Real
  mass : Real
  lightSpeed : Real
  hbar : Real
  timeStep_pos : forall N, 0 < timeStep N
  lightSpeed_pos : 0 < lightSpeed
  hbar_pos : 0 < hbar
  timeStep_tendsto_zero : Filter.Tendsto timeStep Filter.atTop (nhds 0)

/-- Feynman's infinitesimal turn-amplitude scale, in the common convention
`-i * dt * m * c^2 / hbar`. Sign and phase conventions vary in the literature;
this definition is a named convention, not a theorem. -/
def feynmanTurnAmplitude (S : CheckerboardContinuumScale) (N : Nat) : Complex :=
  -Complex.I *
    (((S.timeStep N * S.mass * S.lightSpeed ^ 2) / S.hbar : Real) : Complex)

/-- Small-angle condition connecting a unitary checkerboard angle to the
mass scale. This is an analytic hypothesis for later work, not a proved fact. -/
def unitaryAngleHasMassScale (S : CheckerboardContinuumScale)
    (theta : Nat -> Real) : Prop :=
  Filter.Tendsto
    (fun N => theta N / S.timeStep N)
    Filter.atTop
    (nhds ((S.mass * S.lightSpeed ^ 2) / S.hbar))

/-- A placeholder-free record of what a future continuum theorem must specify.

This avoids asserting a continuum limit before the required analytic
infrastructure is selected. A later theorem should replace `convergenceClaim`
with an explicit norm/topology statement on lattice-interpolated spinor fields. -/
structure CheckerboardDiracLimitProblem where
  scale : CheckerboardContinuumScale
  theta : Nat -> Real
  angle_has_mass_scale : unitaryAngleHasMassScale scale theta
  convergenceClaim : Prop

end PhysicsSM.Draft.CheckerboardContinuumScaffold
