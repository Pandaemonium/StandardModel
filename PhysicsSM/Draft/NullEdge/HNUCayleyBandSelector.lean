import PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignHermitian

/-!
# Cayley reduction of the gapped massive HNU walk to a Hermitian band selector

The massive HNU walk is an exactly unitary `4 x 4` Bloch family. For every
fixed mass angle strictly between zero and pi, the landed global-gap theorem
excludes both Floquet eigenvalues `+1` and `-1` on the closed Brillouin cube.
Those are precisely the two hypotheses needed for the inverse Cayley transform

`A(U) = i (U - 1) (U + 1)^-1`.

The `-1` gap makes `A(U)` a finite Hermitian matrix. The additional `+1` gap
makes it invertible. The existing certified-sign API can then produce the
unique self-adjoint involution `sign(A(U))`, and hence an orthogonal projector
onto one Cayley-sign sector.

This is a band-selection bridge, not a locality theorem. The matrix inverse is
pointwise in momentum and can be nonlocal in position space. Quasi-locality or
decay of the resulting projector requires a separate analytic theorem.

Provenance:
- C. Bourne, "Index Theory of Chiral Unitaries and Split-Step Quantum Walks,"
  SIGMA 19 (2023) 053, DOI 10.3842/SIGMA.2023.053. Consulted for the use of
  Cayley transforms and projection indices for gapped chiral unitaries.
- The finite matrix algebra below is a clean-room formalization in the
  repository's HNU and matrix conventions.

Draft-trust status: every theorem below is kernel-checked and has a dedicated
assumption-footprint guard. The physical-sector, continuity, rank, and locality
claims named above remain separate open gates.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay
open PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignExistence
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignHermitian

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- Inverse Cayley transform with branch cut at Floquet eigenvalue `-1`. -/
def cayleyGenerator (U : Mat4) : Mat4 :=
  Complex.I • (U - 1) * (U + 1)⁻¹

/-- A unitary matrix with no `-1` eigenvalue has a Hermitian inverse Cayley
transform. -/
theorem cayleyGenerator_isHermitian (U : Mat4)
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) Complex)
    (hpi : (U + 1).det ≠ 0) :
    (cayleyGenerator U).IsHermitian := by
  have h_comm : U * (U + 1)⁻¹ = (U + 1)⁻¹ * U := by
    have h_comm : (U + 1) * U = U * (U + 1) := by
      simp +decide [mul_add, add_mul]
    apply_fun (fun x => (U + 1)⁻¹ * x * (U + 1)⁻¹) at h_comm
    simp_all +decide [mul_assoc]
  simp_all +decide [IsHermitian, cayleyGenerator]
  simp_all +decide [mul_sub, sub_mul, Matrix.conjTranspose_nonsing_inv]
  rw [show Uᴴ = U⁻¹ from ?_]
  · rw [show U⁻¹ + 1 = U⁻¹ * (U + 1) by
          simp +decide [mul_add]
          rw [Matrix.nonsing_inv_mul _]
          · exact add_comm _ _
          · exact isUnit_iff_ne_zero.mpr <| by
              intro h
              simpa [h] using congr_arg Matrix.det hU.2]
    simp_all +decide [Matrix.mul_inv_rev, Matrix.mul_assoc]
    rw [Matrix.nonsing_inv_nonsing_inv]
    · rw [Matrix.mul_nonsing_inv _]
      · norm_num [sub_eq_neg_add]
      · exact isUnit_iff_ne_zero.mpr <| by
          intro h
          simpa [h] using congr_arg Matrix.det hU.2
    · exact isUnit_iff_ne_zero.mpr <| by
        intro h
        simpa [h] using congr_arg Matrix.det hU.2
  · rw [Matrix.inv_eq_left_inv]
    exact hU.1

/-- If the unitary also has no `+1` eigenvalue, its inverse Cayley transform is
invertible. -/
theorem cayleyGenerator_isUnit (U : Mat4)
    (h0 : (U - 1).det ≠ 0) (hpi : (U + 1).det ≠ 0) :
    IsUnit (cayleyGenerator U) := by
  rw [Matrix.isUnit_iff_isUnit_det]
  simp +decide [cayleyGenerator, h0, hpi]

/-- The Hermitian generator obtained from the live massive HNU fiber. -/
def hnuCayleyGenerator (a : Real) (k : Fin 3 -> Real) : Mat4 :=
  cayleyGenerator (massiveHNU (1 : Complex) a k)

/-- The live massive HNU Cayley generator is Hermitian throughout the closed
Brillouin cube at every nontrivial mass angle. -/
theorem hnuCayleyGenerator_isHermitian (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) :
    (hnuCayleyGenerator a k).IsHermitian := by
  unfold hnuCayleyGenerator
  exact cayleyGenerator_isHermitian _
    (massiveHNU_unitary (1 : Complex) (by norm_num) a k)
    (by simpa only [bne_iff_ne] using
      (massiveHNU_zero_pi_gap a ha0 hapi k hk).2)

/-- The same generator is invertible: the `+1` Floquet gap becomes the zero
gap of the Hermitian Cayley generator. -/
theorem hnuCayleyGenerator_isUnit (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) :
    IsUnit (hnuCayleyGenerator a k) := by
  unfold hnuCayleyGenerator
  exact cayleyGenerator_isUnit _
    (by simpa only [bne_iff_ne] using
      (massiveHNU_zero_pi_gap a ha0 hapi k hk).1)
    (by simpa only [bne_iff_ne] using
      (massiveHNU_zero_pi_gap a ha0 hapi k hk).2)

/-- The gapped live HNU fiber admits a certified Hermitian sign. This is an
existence statement for a finite spectral-sector classifier, not yet a choice
of a physical occupied sector. -/
theorem hnuCayley_certifiedSign_exists (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) :
    ∃ eps : Mat4,
      SignCertificate (hnuCayleyGenerator a k) eps ∧ eps.IsHermitian := by
  have hunit := hnuCayleyGenerator_isUnit a ha0 hapi k hk
  rw [Matrix.isUnit_iff_isUnit_det] at hunit
  letI : Invertible (hnuCayleyGenerator a k) :=
    (hnuCayleyGenerator a k).invertibleOfIsUnitDet hunit
  let eps := epsCFC (hnuCayleyGenerator a k)
  have hherm := hnuCayleyGenerator_isHermitian a ha0 hapi k hk
  have hcert : SignCertificate (hnuCayleyGenerator a k) eps :=
    certifiedSign_exists _ hherm
  exact ⟨eps, hcert, signCertificate_isHermitian _ _ hherm hcert⟩

/-- The certified sign supplies an orthogonal finite band projector. The
choice `(1 - eps)/2` selects the negative Cayley-sign sector. -/
theorem hnuCayley_negativeProjector_exists (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) :
    ∃ eps P : Mat4,
      SignCertificate (hnuCayleyGenerator a k) eps ∧
      eps.IsHermitian ∧
      P = (2 : Complex)⁻¹ • (1 - eps) ∧
      P * P = P ∧ P.IsHermitian := by
  obtain ⟨eps, hcert, heps⟩ := hnuCayley_certifiedSign_exists a ha0 hapi k hk
  let P : Mat4 := (2 : Complex)⁻¹ • (1 - eps)
  refine ⟨eps, P, hcert, heps, rfl, ?_, ?_⟩
  · unfold P
    rw [Matrix.smul_mul, Matrix.mul_smul, smul_smul]
    have hexp : ((1 : Mat4) - eps) * (1 - eps) =
        (2 : Complex) • ((1 : Mat4) - eps) := by
      have h : ((1 : Mat4) - eps) * (1 - eps) = 1 - eps - eps + eps * eps := by
        noncomm_ring
      rw [h, hcert.involution]
      module
    rw [hexp, smul_smul,
      show (2 : Complex)⁻¹ * (2 : Complex)⁻¹ * (2 : Complex) =
        (2 : Complex)⁻¹ from by norm_num]
  · unfold P Matrix.IsHermitian
    simp [heps.eq]

end PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector
