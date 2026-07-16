import PhysicsSM.Draft.NullEdge.CommutatorMixedDerivative

/-!
# Iterated, diagonal, and joint curvature limits of the trigonometric commutator

This draft module turns the existing mixed Frechet-derivative calculation for
the exact trigonometric matrix commutator into a difference-quotient limit.
For Hermitian involutions `A` and `G`, every finite regulator is unitary and
the `p = 0` axis is exactly the identity.  At fixed `q`, the normalized
`p`-displacement therefore converges to the `p`-jet.  Dividing that jet by `q`
and sending `q` to zero recovers the Lie coefficient `G * A - A * G`.

The order of limits is part of the first theorem: first `p -> 0`, then
`q -> 0`.  A separate exact noncommutative expansion proves the synchronized
diagonal limit `p = q = h` under both involution hypotheses.  Finally, an exact
two-variable factorization extracts `sin(p) * sin(q)` from the full regulator
displacement.  The remaining factor is continuous, and the continuous sinc
extension proves the unrestricted joint limit as `(p,q) -> (0,0)` through
nonzero products, with no relation between the two rates.

These are finite matrix-regulator theorems, not graph refinement theorems or
identifications with a continuum Riemann tensor.

Provenance: clean-room composition of the project regulator and mixed-derivative
modules with Mathlib's derivative-as-slope theorem.  The diagonal expansion
and limit were proved and semantically audited by Aristotle, project
`2a2b0773-3428-4a29-a11f-e2076212ac15`; see the associated task report. Claim
grade: `M [comp]`.
-/

open Filter Matrix Topology
open scoped Topology

noncomputable section

namespace PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit

open PhysicsSM.Draft.NullEdge.CommutatorRegulator
open PhysicsSM.Draft.NullEdge.CommutatorMixedDerivative

abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

/-- The `p`-direction Frechet jet of the regulator along the line `(0,q)`. -/
noncomputable def pJet (A G : M4) (q : Real) : M4 :=
  fderiv Real (trigRegulator A G) (0, q) eP

/-- Difference quotient in the first edge parameter at fixed second parameter. -/
noncomputable def firstEdgeSlope (A G : M4) (q p : Real) : M4 :=
  p⁻¹ • (trigRegulator A G (p, q) - trigRegulator A G (0, q))

/-- Difference quotient of the first edge jet in the second edge parameter. -/
noncomputable def mixedJetSlope (A G : M4) (q : Real) : M4 :=
  q⁻¹ • (pJet A G q - pJet A G 0)

/-- The first edge jet vanishes when the second edge parameter is zero. -/
theorem pJet_zero (A G : M4) : pJet A G 0 = 0 := by
  unfold pJet
  have hzero := trigRegulator_fderiv_origin A G
  rw [hzero]
  rfl

/-- For fixed `q`, the first normalized edge displacement converges to the
`p`-direction jet. -/
theorem firstEdgeSlope_tendsto (A G : M4) (q : Real) :
    Tendsto (firstEdgeSlope A G q) (nhdsWithin 0 {0}ᶜ)
      (nhds (pJet A G q)) := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace Real M4 := Matrix.linftyOpNormedSpace
  have hslice : DifferentiableAt Real
      (fun p : Real => trigRegulator A G (p, q)) 0 := by
    have hpair : HasFDerivAt (fun p : Real => (p, q))
        (ContinuousLinearMap.inl Real Real Real) 0 := by
      simpa using
        ((hasFDerivAt_id (x := (0 : Real))).prodMk
          (hasFDerivAt_const (x := (0 : Real)) q))
    exact (differentiableAt_trigRegulator A G (0, q)).comp 0
      hpair.differentiableAt
  have hderiv : HasDerivAt
      (fun p : Real => trigRegulator A G (p, q)) (pJet A G q) 0 := by
    have h := hslice.hasDerivAt
    have hcoord := fderiv_apply_eP (trigRegulator A G) (0, q)
      (differentiableAt_trigRegulator A G (0, q))
    change pJet A G q =
      deriv (fun p : Real => trigRegulator A G (p, q)) 0 at hcoord
    rw [← hcoord] at h
    exact h
  simpa [firstEdgeSlope, add_zero] using hderiv.tendsto_slope_zero

/-- The second normalized limit of the first edge jet is the Lie commutator
coefficient computed by the mixed Frechet derivative. -/
theorem mixedJetSlope_tendsto (A G : M4) :
    Tendsto (mixedJetSlope A G) (nhdsWithin 0 {0}ᶜ)
      (nhds (lieCoefficient A G)) := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace Real M4 := Matrix.linftyOpNormedSpace
  have hpJet (q : Real) : pJet A G q = Pexpl A G (0, q) := by
    exact fderiv_eP_eq A G (0, q)
  have hslice : DifferentiableAt Real (fun q : Real => Pexpl A G (0, q)) 0 := by
    have hpair : HasFDerivAt (fun q : Real => (0, q))
        (ContinuousLinearMap.inr Real Real Real) 0 := by
      simpa using
        ((hasFDerivAt_const (x := (0 : Real)) (0 : Real)).prodMk
          (hasFDerivAt_id (x := (0 : Real))))
    exact (differentiableAt_Pexpl A G (0, 0)).comp 0
      hpair.differentiableAt
  have hderiv : HasDerivAt (fun q : Real => Pexpl A G (0, q))
      (lieCoefficient A G) 0 := by
    have h := hslice.hasDerivAt
    rw [mixed_deriv_eq] at h
    exact h
  have hfun : mixedJetSlope A G =
      fun q : Real => q⁻¹ • (Pexpl A G (0, q) - Pexpl A G (0, 0)) := by
    funext q
    simp only [mixedJetSlope, hpJet]
  rw [hfun]
  simpa [add_zero] using hderiv.tendsto_slope_zero

/-! ## From a punctured mesh limit to a refinement sequence -/

/-- A punctured real limit can be sampled along any everywhere-nonzero
refinement mesh tending to zero. -/
theorem puncturedLimit_comp_refinement
    {E : Type*} [TopologicalSpace E]
    {f : Real -> E} {target : E} {h : Nat -> Real}
    (hf : Tendsto f (nhdsWithin 0 {0}ᶜ) (nhds target))
    (hh : Tendsto h atTop (nhds 0))
    (hne : ∀ n, h n ≠ 0) :
    Tendsto (fun n => f (h n)) atTop (nhds target) := by
  apply hf.comp
  exact tendsto_nhdsWithin_iff.mpr
    ⟨hh, Filter.Eventually.of_forall fun n => hne n⟩

/-- The `p = 0` axis is exactly the identity when `G` is an involution. -/
theorem trigRegulator_first_axis_identity
    (A G : M4) (hG : G * G = 1) (q : Real) :
    trigRegulator A G (0, q) = 1 := by
  unfold trigRegulator
  simpa using
    regulator_first_axis_zero (Real.cos q) (Real.sin q) A G hG
      (Real.cos_sq_add_sin_sq q)

/-- The `q = 0` axis is exactly the identity when `A` is an involution. -/
theorem trigRegulator_second_axis_identity
    (A G : M4) (hA : A * A = 1) (p : Real) :
    trigRegulator A G (p, 0) = 1 := by
  unfold trigRegulator
  simpa using
    regulator_second_axis_zero (Real.cos p) (Real.sin p) A G hA
      (Real.cos_sq_add_sin_sq p)

/-- Hermitian involutive generators make the complete two-parameter regulator
unitary at every finite parameter value. -/
theorem trigRegulator_unitary
    (A G : M4)
    (hAHerm : A.conjTranspose = A) (hGHerm : G.conjTranspose = G)
    (hA : A * A = 1) (hG : G * G = 1) (p q : Real) :
    IsUnitary (trigRegulator A G (p, q)) := by
  unfold trigRegulator
  exact regulator_unitary (Real.cos p) (Real.sin p)
    (Real.cos q) (Real.sin q) A G hAHerm hGHerm hA hG
    (Real.cos_sq_add_sin_sq p) (Real.cos_sq_add_sin_sq q)

/-- **Iterated area-normalized holonomy limit.** If the second generator is an
involution, the first-edge quotient is based at the identity. Its limit is the
first jet, and the second normalized jet limit is the Lie coefficient. -/
theorem iteratedAreaNormalizedHolonomyLimit
    (A G : M4) (hG : G * G = 1) :
    (∀ q : Real,
      Tendsto
        (fun p : Real => p⁻¹ • (trigRegulator A G (p, q) - 1))
        (nhdsWithin 0 {0}ᶜ) (nhds (pJet A G q))) ∧
      Tendsto (fun q : Real => q⁻¹ • pJet A G q)
        (nhdsWithin 0 {0}ᶜ) (nhds (lieCoefficient A G)) := by
  constructor
  · intro q
    have hfun :
        (fun p : Real => p⁻¹ • (trigRegulator A G (p, q) - 1)) =
          firstEdgeSlope A G q := by
      funext p
      unfold firstEdgeSlope
      rw [trigRegulator_first_axis_identity A G hG q]
    rw [hfun]
    exact firstEdgeSlope_tendsto A G q
  · have hfun : (fun q : Real => q⁻¹ • pJet A G q) = mixedJetSlope A G := by
      funext q
      unfold mixedJetSlope
      rw [pJet_zero, sub_zero]
    rw [hfun]
    exact mixedJetSlope_tendsto A G

/-! ## Exact unrestricted joint limit -/

/-- Parameter pairs on which the oriented product-area quotient is nonzero. -/
def nonzeroProductParameters : Set (Real × Real) :=
  {z | z.1 * z.2 ≠ 0}

/-- Continuous matrix factor left after extracting `sin(p) * sin(q)` from the
involutive regulator displacement. -/
noncomputable def jointBracket (A G : M4) (z : Real × Real) : M4 :=
  ((Real.cos z.1 : Complex) * (Real.cos z.2 : Complex)) •
      lieCoefficient A G +
    (Complex.I * (Real.cos z.2 : Complex) * (Real.sin z.1 : Complex)) •
      (G - A * G * A) +
    (Complex.I * (Real.cos z.1 : Complex) * (Real.sin z.2 : Complex)) •
      (G * A * G - A) +
    ((Real.sin z.1 : Complex) * (Real.sin z.2 : Complex)) •
      (A * G * A * G - 1)

/-- Exact noncommutative two-variable expansion before imposing the
involutions. -/
lemma trigRegulator_joint_expansion (A G : M4) (p q : Real) :
    trigRegulator A G (p, q) =
      ((Real.cos p : Complex) ^ 2 * (Real.cos q : Complex) ^ 2) • (1 : M4) +
      ((Real.cos p : Complex) ^ 2 * (Real.sin q : Complex) ^ 2) • (G * G) +
      ((Real.cos q : Complex) ^ 2 * (Real.sin p : Complex) ^ 2) • (A * A) +
      ((Real.cos p : Complex) * (Real.cos q : Complex) *
          (Real.sin p : Complex) * (Real.sin q : Complex)) •
        (G * A - A * G) +
      (Complex.I * (Real.cos p : Complex) * (Real.sin p : Complex) *
          (Real.sin q : Complex) ^ 2) •
        (G * A * G - A * G * G) +
      (Complex.I * (Real.cos q : Complex) * (Real.sin p : Complex) ^ 2 *
          (Real.sin q : Complex)) •
        (A * A * G - A * G * A) +
      ((Real.sin p : Complex) ^ 2 * (Real.sin q : Complex) ^ 2) •
        (A * G * A * G) := by
  rw [trigRegulator_eq]
  unfold pfac nfac
  simp +decide [mul_assoc]
  all_goals ring
  norm_num [mul_add, add_mul, mul_assoc, sub_mul, mul_sub, smul_smul]
  ring
  ext i j
  norm_num
  ring
  norm_num [pow_three]
  ring

/-- Under both involution hypotheses, the full regulator displacement has the
exact product factor `sin(p) * sin(q)`. -/
lemma trigRegulator_joint_involutive_factorization
    (A G : M4) (hA : A * A = 1) (hG : G * G = 1) (p q : Real) :
    trigRegulator A G (p, q) - 1 =
      ((Real.sin p : Complex) * (Real.sin q : Complex)) •
        jointBracket A G (p, q) := by
  rw [trigRegulator_joint_expansion]
  unfold jointBracket lieCoefficient
  simp [mul_assoc, hA, hG]
  have hp : Complex.cos (p : Complex) ^ 2 =
      1 - Complex.sin (p : Complex) ^ 2 := by
    linear_combination Complex.cos_sq_add_sin_sq (x := (p : Complex))
  have hq : Complex.cos (q : Complex) ^ 2 =
      1 - Complex.sin (q : Complex) ^ 2 := by
    linear_combination Complex.cos_sq_add_sin_sq (x := (q : Complex))
  rw [hp, hq]
  ring
  ext i j
  norm_num
  ring

/-- Continuous extension of the product-area quotient across both axes. -/
noncomputable def jointAreaExtension (A G : M4) (z : Real × Real) : M4 :=
  (Real.sinc z.1 * Real.sinc z.2) • jointBracket A G z

/-- **Joint area-normalized holonomy limit.** Both parameters may approach
zero at arbitrary unequal rates.  Restricting to nonzero products only removes
the points where the original oriented-area quotient is undefined. -/
theorem jointAreaNormalizedHolonomyLimit
    (A G : M4) (hA : A * A = 1) (hG : G * G = 1) :
    Tendsto
      (fun z : Real × Real =>
        (z.1 * z.2)⁻¹ • (trigRegulator A G z - 1))
      (nhdsWithin (0, 0) nonzeroProductParameters)
      (nhds (lieCoefficient A G)) := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace Real M4 := Matrix.linftyOpNormedSpace
  have hcontinuous : Continuous (jointAreaExtension A G) := by
    unfold jointAreaExtension jointBracket
    fun_prop
  have horigin : jointAreaExtension A G (0, 0) = lieCoefficient A G := by
    simp [jointAreaExtension, jointBracket]
  have heq :
      (fun z : Real × Real =>
        (z.1 * z.2)⁻¹ • (trigRegulator A G z - 1)) =ᶠ[
          nhdsWithin (0, 0) nonzeroProductParameters]
        jointAreaExtension A G := by
    filter_upwards [self_mem_nhdsWithin] with z hz
    have hp : z.1 ≠ 0 := by
      exact fun hp => hz (by simp [hp])
    have hq : z.2 ≠ 0 := by
      exact fun hq => hz (by simp [hq])
    rw [trigRegulator_joint_involutive_factorization A G hA hG]
    unfold jointAreaExtension
    rw [Real.sinc_of_ne_zero hp, Real.sinc_of_ne_zero hq]
    ext i j
    norm_num
    field_simp [hp, hq]
  apply Tendsto.congr' heq.symm
  rw [← horigin]
  exact hcontinuous.continuousAt.tendsto.mono_left nhdsWithin_le_nhds

/-- The joint limit may be sampled along any refinement sequence whose two
parameters tend jointly to zero and have nonzero product at every stage. -/
theorem jointLimit_comp_refinement
    (A G : M4) (hA : A * A = 1) (hG : G * G = 1)
    (mesh : Nat → Real × Real)
    (hmesh : Tendsto mesh atTop (nhds (0, 0)))
    (hne : ∀ n, (mesh n).1 * (mesh n).2 ≠ 0) :
    Tendsto
      (fun n =>
        ((mesh n).1 * (mesh n).2)⁻¹ •
          (trigRegulator A G (mesh n) - 1))
      atTop (nhds (lieCoefficient A G)) := by
  apply (jointAreaNormalizedHolonomyLimit A G hA hG).comp
  exact tendsto_nhdsWithin_iff.mpr
    ⟨hmesh, Filter.Eventually.of_forall fun n => hne n⟩

/-! ## Exact synchronized diagonal limit -/

/-- Exact noncommutative expansion of the ordered regulator on the diagonal
`p = q = h`.  Before imposing involutions, the quadratic matrix coefficient
contains the commutator and both pure-square terms. -/
lemma trigRegulator_diagonal_expansion (A G : M4) (h : Real) :
    trigRegulator A G (h, h) =
      ((Real.cos h : Complex) ^ 4) • (1 : M4) +
      ((Real.cos h : Complex) ^ 2 * (Real.sin h : Complex) ^ 2) •
        (A * A + G * G + G * A - A * G) +
      (Complex.I * (Real.cos h : Complex) * (Real.sin h : Complex) ^ 3) •
        (-A * G * A - A * G * G + A * A * G + G * A * G) +
      ((Real.sin h : Complex) ^ 4) • (A * G * A * G) := by
  rw [trigRegulator_eq]
  unfold pfac nfac
  simp +decide [mul_assoc]
  all_goals ring
  norm_num [mul_add, add_mul, mul_assoc, sub_mul, mul_sub, smul_smul]
  ring
  ext i j
  norm_num
  ring
  norm_num [pow_three]
  ring

/-- Under both involution hypotheses, the pure quadratic terms cancel and the
coefficient of `cos(h)^2 sin(h)^2` is exactly `G*A-A*G`. -/
lemma trigRegulator_diagonal_involutive_expansion
    (A G : M4) (hA : A * A = 1) (hG : G * G = 1) (h : Real) :
    trigRegulator A G (h, h) - 1 =
      ((Real.cos h : Complex) ^ 2 * (Real.sin h : Complex) ^ 2) •
        lieCoefficient A G +
      ((Real.sin h : Complex) ^ 4) • (A * G * A * G - 1) +
      (Complex.I * (Real.cos h : Complex) * (Real.sin h : Complex) ^ 3) •
        (-A * G * A - A * G * G + A * A * G + G * A * G) := by
  convert congrArg (fun x : M4 => x - 1)
    (trigRegulator_diagonal_expansion A G h) using 1
  all_goals ring
  rw [show (Real.cos h : Complex) ^ 4 = (Real.cos h ^ 2) ^ 2 by ring,
    show (Real.cos h : Complex) ^ 2 = 1 - (Real.sin h : Complex) ^ 2 by
      norm_cast
      rw [Real.cos_sq']]
  ring
  ext
  norm_num [hA, hG, lieCoefficient]
  ring
  erw [show (2 : M4) = 2 • 1 by norm_num]
  norm_num
  ring

/-- **Diagonal area-normalized holonomy limit.** Along the synchronized path
`p = q = h`, both involution hypotheses cancel the pure quadratic terms and
the area-normalized regulator converges to `G*A-A*G` with coefficient one. -/
theorem diagonalAreaNormalizedHolonomyLimit
    (A G : M4) (hA : A * A = 1) (hG : G * G = 1) :
    Tendsto
      (fun h : Real =>
        (h ^ 2)⁻¹ • (trigRegulator A G (h, h) - 1))
      (nhdsWithin 0 {0}ᶜ) (nhds (lieCoefficient A G)) := by
  have h_expand : ∀ h : Real,
      (h ^ 2)⁻¹ • (trigRegulator A G (h, h) - 1) =
        ((Real.cos h : Complex) ^ 2 * (Real.sin h : Complex) ^ 2 / h ^ 2) •
            lieCoefficient A G +
        ((Real.sin h : Complex) ^ 4 / h ^ 2) • (A * G * A * G - 1) +
        (Complex.I * (Real.cos h : Complex) *
            (Real.sin h : Complex) ^ 3 / h ^ 2) •
          (-A * G * A - A * G * G + A * A * G + G * A * G) := by
    intro h
    rw [trigRegulator_diagonal_involutive_expansion A G hA hG h]
    ext i j
    norm_num
    ring
  have h_tendsto :
      Tendsto
          (fun h : Real =>
            (Real.cos h : Complex) ^ 2 * (Real.sin h : Complex) ^ 2 / h ^ 2)
          (nhdsWithin 0 {0}ᶜ) (nhds 1) ∧
        Tendsto
          (fun h : Real => (Real.sin h : Complex) ^ 4 / h ^ 2)
          (nhdsWithin 0 {0}ᶜ) (nhds 0) ∧
        Tendsto
          (fun h : Real =>
            Complex.I * (Real.cos h : Complex) *
              (Real.sin h : Complex) ^ 3 / h ^ 2)
          (nhdsWithin 0 {0}ᶜ) (nhds 0) := by
    have hsin : Tendsto (fun h : Real => (Real.sin h : Complex) / h)
        (nhdsWithin 0 {0}ᶜ) (nhds 1) := by
      have hderiv := Real.hasDerivAt_sin 0
      simp_all +decide [hasDerivAt_iff_tendsto_slope_zero]
      convert Complex.continuous_ofReal.continuousAt.tendsto.comp hderiv using 2
      norm_num [div_eq_inv_mul]
    refine ⟨?_, ?_, ?_⟩
    · convert Tendsto.mul
        ((Complex.continuous_ofReal.continuousAt.tendsto.comp
          (Real.continuous_cos.continuousAt.pow 2)).mono_left
            nhdsWithin_le_nhds)
        (hsin.pow 2) using 2 <;> norm_num
      ring
    · convert hsin.pow 2 |>.mul
        (Continuous.continuousWithinAt
          (show Continuous (fun h : Real => (Real.sin h : Complex) ^ 2) by
            continuity)) using 2 <;> ring
      norm_num
    · convert Tendsto.mul
        (Tendsto.mul tendsto_const_nhds
          ((Complex.continuous_ofReal.continuousAt.tendsto.comp
            (Real.continuous_cos.tendsto 0)).mono_left nhdsWithin_le_nhds))
        (hsin.pow 2 |>.mul
          ((Complex.continuous_ofReal.continuousAt.tendsto.comp
            (Real.continuous_sin.tendsto 0)).mono_left nhdsWithin_le_nhds)) using 2
      norm_num
      ring
      norm_num
  convert Tendsto.add
      (Tendsto.add
        (h_tendsto.1.smul_const (lieCoefficient A G))
        (h_tendsto.2.1.smul_const (A * G * A * G - 1)))
      (h_tendsto.2.2.smul_const
        (-A * G * A - A * G * G + A * A * G + G * A * G)) using 2 <;>
    aesop

/-- Generic unitary, nonzero version of the iterated curvature packet. -/
theorem nonzero_unitary_iterated_curvature_limit
    (A G : M4)
    (hAHerm : A.conjTranspose = A) (hGHerm : G.conjTranspose = G)
    (hA : A * A = 1) (hG : G * G = 1)
    (hcurv : lieCoefficient A G ≠ 0) :
    (∀ p q : Real, IsUnitary (trigRegulator A G (p, q))) ∧
      lieCoefficient A G ≠ 0 ∧
      (∀ q : Real,
        Tendsto
          (fun p : Real => p⁻¹ • (trigRegulator A G (p, q) - 1))
          (nhdsWithin 0 {0}ᶜ) (nhds (pJet A G q))) ∧
      Tendsto (fun q : Real => q⁻¹ • pJet A G q)
        (nhdsWithin 0 {0}ᶜ) (nhds (lieCoefficient A G)) := by
  refine ⟨trigRegulator_unitary A G hAHerm hGHerm hA hG, hcurv, ?_⟩
  exact iteratedAreaNormalizedHolonomyLimit A G hG

/-- Generic unitary, nonzero version of the synchronized diagonal curvature
packet.  Hermiticity is needed for finite-regulator unitarity, not for the
analytic diagonal limit itself. -/
theorem nonzero_unitary_diagonal_curvature_limit
    (A G : M4)
    (hAHerm : A.conjTranspose = A) (hGHerm : G.conjTranspose = G)
    (hA : A * A = 1) (hG : G * G = 1)
    (hcurv : lieCoefficient A G ≠ 0) :
    (∀ p q : Real, IsUnitary (trigRegulator A G (p, q))) ∧
      lieCoefficient A G ≠ 0 ∧
      Tendsto
        (fun h : Real => (h ^ 2)⁻¹ • (trigRegulator A G (h, h) - 1))
        (nhdsWithin 0 {0}ᶜ) (nhds (lieCoefficient A G)) := by
  exact ⟨trigRegulator_unitary A G hAHerm hGHerm hA hG, hcurv,
    diagonalAreaNormalizedHolonomyLimit A G hA hG⟩

/-- Generic unitary, nonzero version of the unrestricted joint curvature
packet. Hermiticity supplies finite-regulator unitarity but is not used in the
joint analytic limit. -/
theorem nonzero_unitary_joint_curvature_limit
    (A G : M4)
    (hAHerm : A.conjTranspose = A) (hGHerm : G.conjTranspose = G)
    (hA : A * A = 1) (hG : G * G = 1)
    (hcurv : lieCoefficient A G ≠ 0) :
    (∀ p q : Real, IsUnitary (trigRegulator A G (p, q))) ∧
      lieCoefficient A G ≠ 0 ∧
      Tendsto
        (fun z : Real × Real =>
          (z.1 * z.2)⁻¹ • (trigRegulator A G z - 1))
        (nhdsWithin (0, 0) nonzeroProductParameters)
        (nhds (lieCoefficient A G)) := by
  exact ⟨trigRegulator_unitary A G hAHerm hGHerm hA hG, hcurv,
    jointAreaNormalizedHolonomyLimit A G hA hG⟩

/-! ## Nonzero live Clifford realization -/

/-- The live velocity generator is Hermitian. -/
theorem liveA_hermitian : liveA.conjTranspose = liveA := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [liveA,
      PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.alpha1,
      Matrix.conjTranspose]

/-- The live mass-turn generator is Hermitian. -/
theorem liveG_hermitian : liveG.conjTranspose = liveG := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [liveG,
      PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.beta,
      Matrix.conjTranspose]

/-- The live velocity generator is an involution. -/
theorem liveA_sq : liveA * liveA = 1 := by
  simpa [liveA, PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.alpha] using
    PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.alpha_sq (0 : Fin 3)

/-- The live mass-turn generator is an involution. -/
theorem liveG_sq : liveG * liveG = 1 := by
  simpa [liveG] using
    PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.beta_sq

/-- The live Lie coefficient is genuinely nonzero. -/
theorem live_lieCoefficient_ne_zero : lieCoefficient liveA liveG ≠ 0 := by
  simpa only [trigRegulator_mixed_fderiv_origin] using
    live_mixed_fderiv_ne_zero

/-- **Live nonvacuous iterated curvature packet.** The concrete Clifford
velocity/mass pair gives unitary finite holonomies and a nonzero iterated
area coefficient. -/
theorem live_nonzero_unitary_iterated_curvature_limit :
    (∀ p q : Real, IsUnitary (trigRegulator liveA liveG (p, q))) ∧
      lieCoefficient liveA liveG ≠ 0 ∧
      (∀ q : Real,
        Tendsto
          (fun p : Real =>
            p⁻¹ • (trigRegulator liveA liveG (p, q) - 1))
          (nhdsWithin 0 {0}ᶜ) (nhds (pJet liveA liveG q))) ∧
      Tendsto (fun q : Real => q⁻¹ • pJet liveA liveG q)
        (nhdsWithin 0 {0}ᶜ) (nhds (lieCoefficient liveA liveG)) := by
  exact nonzero_unitary_iterated_curvature_limit liveA liveG
    liveA_hermitian liveG_hermitian liveA_sq liveG_sq
    live_lieCoefficient_ne_zero

/-- **Live nonvacuous diagonal curvature packet.** The concrete Clifford pair
has unitary finite regulators and a nonzero synchronized area coefficient. -/
theorem live_nonzero_unitary_diagonal_curvature_limit :
    (∀ p q : Real, IsUnitary (trigRegulator liveA liveG (p, q))) ∧
      lieCoefficient liveA liveG ≠ 0 ∧
      Tendsto
        (fun h : Real =>
          (h ^ 2)⁻¹ • (trigRegulator liveA liveG (h, h) - 1))
        (nhdsWithin 0 {0}ᶜ) (nhds (lieCoefficient liveA liveG)) := by
  exact nonzero_unitary_diagonal_curvature_limit liveA liveG
    liveA_hermitian liveG_hermitian liveA_sq liveG_sq
    live_lieCoefficient_ne_zero

/-- **Live nonvacuous joint curvature packet.** The concrete Clifford pair
has unitary finite regulators and a nonzero area coefficient for unrestricted
joint approaches through nonzero products. -/
theorem live_nonzero_unitary_joint_curvature_limit :
    (∀ p q : Real, IsUnitary (trigRegulator liveA liveG (p, q))) ∧
      lieCoefficient liveA liveG ≠ 0 ∧
      Tendsto
        (fun z : Real × Real =>
          (z.1 * z.2)⁻¹ • (trigRegulator liveA liveG z - 1))
        (nhdsWithin (0, 0) nonzeroProductParameters)
        (nhds (lieCoefficient liveA liveG)) := by
  exact nonzero_unitary_joint_curvature_limit liveA liveG
    liveA_hermitian liveG_hermitian liveA_sq liveG_sq
    live_lieCoefficient_ne_zero

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.iteratedAreaNormalizedHolonomyLimit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.iteratedAreaNormalizedHolonomyLimit

/-- info: 'PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.nonzero_unitary_iterated_curvature_limit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.nonzero_unitary_iterated_curvature_limit

/-- info: 'PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.live_nonzero_unitary_iterated_curvature_limit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.live_nonzero_unitary_iterated_curvature_limit

/-- info: 'PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.diagonalAreaNormalizedHolonomyLimit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.diagonalAreaNormalizedHolonomyLimit

/-- info: 'PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.live_nonzero_unitary_diagonal_curvature_limit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.live_nonzero_unitary_diagonal_curvature_limit

/-- info: 'PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.jointAreaNormalizedHolonomyLimit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.jointAreaNormalizedHolonomyLimit

/-- info: 'PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.live_nonzero_unitary_joint_curvature_limit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit.live_nonzero_unitary_joint_curvature_limit

end PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit
