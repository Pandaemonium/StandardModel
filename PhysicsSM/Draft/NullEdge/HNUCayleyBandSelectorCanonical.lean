import PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector

/-!
# Canonicality and rest-frame control for the massive HNU Cayley selector

`HNUCayleyBandSelector` constructs a certified sign and its negative-sign
projector pointwise from the live massive HNU endpoint. This successor asks for
the two finite algebraic facts needed before that projector can be used as a
physical-band candidate:

1. a certified sign of the inverse Cayley generator commutes with the original
   unitary endpoint, not merely with the transformed Hermitian matrix; and
2. at zero momentum, the negative-sign projector is exactly
   `(1 - beta) / 2` for every mass angle in `(0, pi)`.

The rest identity is a kill test for the Cayley branch and sign convention. It
does not prove that this rank-two band is the complete physical sector, remove
the opposite-chirality companion, establish continuity or quasi-locality, or
show stability under interactions.

Provenance: clean-room finite-matrix continuation of the Cayley/projection
strategy discussed in C. Bourne, SIGMA 19 (2023) 053,
DOI 10.3842/SIGMA.2023.053. The inverse-Cayley commutation algebra and exact
rest formula were completed in focused Aristotle project
`9006d3df-ecea-499c-b996-5b08b948f312`; the live wrappers, positivity
certificate, and uniqueness assembly were integrated locally.

Draft-trust status: every statement below is kernel-checked, with no proof
handoffs or compiled-evaluator shortcut. The dedicated axiom-guard module pins
the dependency footprint. The physical-sector, continuity, and locality gates
listed above remain open.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay
open PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap
open PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate
open scoped ComplexOrder

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical

open PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- A sign certificate for the inverse Cayley generator commutes with the
unitary from which the generator was formed. The excluded `-1` eigenvalue is
the load-bearing inverse-Cayley hypothesis. -/
theorem certifiedSign_commutes_cayleyUnitary (U eps : Mat4)
    (_hU : U ∈ Matrix.unitaryGroup (Fin 4) Complex)
    (hpi : (U + 1).det ≠ 0)
    (hcert : SignCertificate (cayleyGenerator U) eps) :
    eps * U = U * eps := by
  have hExpand : eps * (U - 1) * (U + 1)⁻¹ =
      (U - 1) * (U + 1)⁻¹ * eps := by
    have hc := congrArg (fun M : Mat4 => (-Complex.I) • M) hcert.commute
    simpa [cayleyGenerator, Matrix.smul_mul, Matrix.mul_smul, smul_smul,
      mul_assoc] using hc
  have hRightMul : eps * (U - 1) = (U - 1) * eps := by
    apply_fun (fun x => x * (U + 1)) at hExpand
    simp_all +decide [Matrix.mul_assoc, isUnit_iff_ne_zero]
    have hComm : U * (U + 1) = (U + 1) * U := by
      simp +decide [mul_add, add_mul]
    have hCommInv : U * (U + 1)⁻¹ = (U + 1)⁻¹ * U := by
      have hInv : (U + 1) * U * (U + 1)⁻¹ = U := by
        simp +decide [← hComm, hpi, isUnit_iff_ne_zero]
      apply_fun (fun x => (U + 1)⁻¹ * x) at hInv
      simp_all +decide [Matrix.mul_assoc, isUnit_iff_ne_zero]
    have hCommEps : U * eps = eps * U := by
      simp_all +decide [mul_sub, sub_mul, ← mul_assoc]
      apply_fun (fun x => (U + 1) * x) at hExpand
      simp_all +decide [Matrix.mul_assoc, isUnit_iff_ne_zero]
      simp_all +decide [mul_sub, ← mul_assoc]
      simp_all +decide [mul_add, add_mul, Matrix.mul_assoc]
      exact eq_of_sub_eq_zero (by
        ext i j
        have hij := congr_fun (congr_fun hExpand i) j
        norm_num at *
        linear_combination' hij.symm / 2)
    simp_all +decide [Matrix.mul_assoc, Matrix.mul_add, Matrix.add_mul]
    simp_all +decide [Matrix.mul_assoc, Matrix.mul_sub, Matrix.sub_mul]
  have hRearrange : eps * U = U * eps := by
    simp_all +decide [mul_sub, sub_mul]
  exact hRearrange

/-- Live HNU wrapper for endpoint commutation of every certified Cayley sign. -/
theorem hnuCayley_certifiedSign_commutes_endpoint (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) (eps : Mat4)
    (hcert : SignCertificate (hnuCayleyGenerator a k) eps) :
    eps * massiveHNU (1 : Complex) a k =
      massiveHNU (1 : Complex) a k * eps := by
  apply certifiedSign_commutes_cayleyUnitary _ eps
  · exact massiveHNU_unitary (1 : Complex) (by norm_num) a k
  · simpa only [bne_iff_ne] using
      (massiveHNU_zero_pi_gap a ha0 hapi k hk).2
  · exact hcert

set_option maxHeartbeats 800000 in
/-- At rest, the inverse Cayley generator is the positive half-angle tangent
times the live Dirac `beta` matrix. -/
theorem hnuCayleyGenerator_rest (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi) :
    hnuCayleyGenerator a 0 =
      (Real.tan (a / 2) : Complex) • beta := by
  unfold hnuCayleyGenerator cayleyGenerator
  rw [massiveHNU_rest]
  unfold massCoin4 mass4 beta5 beta gamma5
  rw [Matrix.inv_eq_right_inv]
  rotate_right
  exact Matrix.diagonal (fun i =>
    if i.val < 2 then
      (Complex.cos a - Complex.I * Complex.sin a + 1)⁻¹
    else
      (Complex.cos a + Complex.I * Complex.sin a + 1)⁻¹)
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Complex.tan_eq_sin_div_cos, Complex.sin, Complex.cos] <;> ring
    · norm_num [Complex.exp_neg, Complex.exp_add]
      ring
      field_simp
      rw [← Complex.exp_nat_mul]
      ring
    · norm_num [Complex.exp_neg, Complex.exp_add]
      ring
      field_simp
      rw [← Complex.exp_nat_mul]
      ring
    · norm_num [pow_three]
      ring
      rw [show (1 + Complex.exp (I * a)) =
          (Complex.exp (I * a * (-1 / 2)) * (1 / 2) +
            Complex.exp (I * a * (1 / 2)) * (1 / 2)) *
            (Complex.exp (I * a * (1 / 2)) * 2) by
        ring_nf
        norm_num [← Complex.exp_nat_mul, ← Complex.exp_add]
        ring]
      norm_num
      ring
      norm_num [mul_assoc, ← Complex.exp_add, ← Complex.exp_neg]
      ring
      grind
    · field_simp
      rw [div_eq_div_iff] <;> ring <;> norm_num [Complex.exp_ne_zero]
      · norm_num [← Complex.exp_add]
        ring
      · norm_num [Complex.ext_iff, Complex.exp_re, Complex.exp_im]
        exact fun _ => ne_of_gt (Real.sin_pos_of_pos_of_lt_pi ha0 hapi)
      · norm_num [Complex.ext_iff, Complex.exp_re, Complex.exp_im]
        exact ne_of_gt
          (Real.cos_pos_of_mem_Ioo ⟨by linarith, by linarith⟩)
  · ext i j
    fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply]
    all_goals
      simp +decide [Fin.sum_univ_succ, Matrix.one_apply,
        Matrix.diagonal_apply]
    · rw [mul_inv_cancel₀]
      norm_num [Complex.ext_iff]
      exact fun h => absurd h (by
        norm_cast
        nlinarith [Real.sin_sq_add_cos_sq a,
          Real.sin_pos_of_pos_of_lt_pi ha0 hapi])
    · rw [mul_inv_cancel₀]
      norm_num [Complex.ext_iff]
      exact fun h => absurd h (by
        norm_cast
        nlinarith [Real.sin_sq_add_cos_sq a,
          Real.sin_pos_of_pos_of_lt_pi ha0 hapi])
    · rw [mul_inv_cancel₀]
      norm_num [Complex.ext_iff]
      exact fun h => absurd h (by
        norm_cast
        nlinarith [Real.sin_sq_add_cos_sq a,
          Real.sin_pos_of_pos_of_lt_pi ha0 hapi])
    · rw [mul_inv_cancel₀]
      norm_num [Complex.ext_iff]
      exact fun h => absurd h (by
        norm_cast
        nlinarith [Real.sin_sq_add_cos_sq a,
          Real.sin_pos_of_pos_of_lt_pi ha0 hapi])

/-- The live `beta` matrix is the certified sign of the rest-frame Cayley
generator on the principal mass-angle interval. -/
theorem beta_signCertificate_rest (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi) :
    SignCertificate (hnuCayleyGenerator a 0) beta := by
  rw [hnuCayleyGenerator_rest a ha0 hapi]
  have hbetaSq : beta * beta = (1 : Mat4) :=
    mass_generators_clifford.2.2.1
  refine ⟨hbetaSq, ?_, ?_⟩
  · simp [Matrix.mul_smul, Matrix.smul_mul, hbetaSq]
  · rw [Matrix.mul_smul, hbetaSq]
    apply Matrix.PosSemidef.one.smul
    exact_mod_cast
      (Real.tan_pos_of_pos_of_lt_pi_div_two
        (by positivity : 0 < a / 2) (by linarith : a / 2 < Real.pi / 2)).le

/-- Certified-sign uniqueness fixes every rest-frame sign to `beta`. -/
theorem hnuCayley_certifiedSign_rest_unique (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi) (eps : Mat4)
    (hcert : SignCertificate (hnuCayleyGenerator a 0) eps) :
    eps = beta := by
  have hk0 : InBZ (0 : Fin 3 -> Real) := by
    intro i
    change -Real.pi <= 0 ∧ 0 <= Real.pi
    exact ⟨by linarith [Real.pi_pos], Real.pi_pos.le⟩
  have hunit := hnuCayleyGenerator_isUnit a ha0 hapi 0 hk0
  rw [Matrix.isUnit_iff_isUnit_det] at hunit
  letI : Invertible (hnuCayleyGenerator a 0) :=
    (hnuCayleyGenerator a 0).invertibleOfIsUnitDet hunit
  exact certifiedSign_unique _ eps beta
    (hnuCayleyGenerator_isHermitian a ha0 hapi 0 hk0)
    hcert (beta_signCertificate_rest a ha0 hapi)

/-- The negative Cayley-sign projector passes the exact rest-frame kill test.
This fixes the convention; it is not a companion-removal theorem. -/
theorem hnuCayley_negativeProjector_rest (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi) (eps P : Mat4)
    (hcert : SignCertificate (hnuCayleyGenerator a 0) eps)
    (hP : P = (2 : Complex)⁻¹ • (1 - eps)) :
    P = (2 : Complex)⁻¹ • (1 - beta) := by
  rw [hP, hnuCayley_certifiedSign_rest_unique a ha0 hapi eps hcert]

end PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical
