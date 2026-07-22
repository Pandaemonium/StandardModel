import PhysicsSM.Draft.NullEdge.HNUMassiveSpectralReciprocity
import PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical

/-!
# Even characteristic determinant of the massive HNU Cayley generator

The live massive HNU update has a reciprocal characteristic determinant.
This module transports that finite symmetry through the inverse Cayley map.
It proves that the characteristic determinant of the resulting Hermitian
generator is even in its spectral parameter:

`det (H - x I) = det (H + x I)`.

The proof does not order eigenvalues.  It first homogenizes the reciprocal
Floquet determinant, including the two zero-coefficient boundary cases, and
then factors both Cayley shifts through the same invertible matrix `U + I`.
This is the exact determinant-level source of opposite Cayley-energy pairs.

This result does not yet identify which pair is physical, prove that the
negative projector has rank two away from rest, establish projector
quasi-locality, remove companion sectors, or control interactions.

Provenance: clean-room finite matrix algebra in the repository's HNU and
inverse-Cayley conventions.  The use of a gapped inverse Cayley transform as a
band selector is informed by C. Bourne, "Index Theory of Chiral Unitaries and
Split-Step Quantum Walks," SIGMA 19 (2023) 053.  The reciprocity input is
`HNUMassiveSpectralReciprocity`.

Draft-trust status: all declarations are kernel-checked.  The dedicated guard
pins their assumption footprints.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap
open PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUCayleyEvenDeterminant

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

open PhysicsSM.Draft.NullEdge.HNUMassiveSpectralReciprocity

/-- The live massive HNU update has determinant one. -/
theorem massiveHNU_det_one (a : Real) (k : Fin 3 -> Real) :
    (massiveHNU (1 : Complex) a k).det = 1 := by
  have h := massiveHNU_general_shifted_det_reduction a k 0
  simpa [PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_det] using h

/-- Homogeneous form of reciprocal characteristic-determinant symmetry.  The
boundary cases use `det U = 1`; the nonzero case is the landed reciprocal
polynomial theorem. -/
theorem massiveHNU_homogeneous_det_swap (a : Real) (k : Fin 3 -> Real)
    (y z : Complex) :
    (y • massiveHNU (1 : Complex) a k - z • (1 : Mat4)).det =
      (z • massiveHNU (1 : Complex) a k - y • (1 : Mat4)).det := by
  let U := massiveHNU (1 : Complex) a k
  by_cases hy : y = 0
  · subst y
    simp [Matrix.det_smul, massiveHNU_det_one]
  by_cases hz : z = 0
  · subst z
    simp [Matrix.det_smul, massiveHNU_det_one]
  have hleft :
      (y • U - z • (1 : Mat4)).det =
        y ^ 4 * (U - (z / y) • (1 : Mat4)).det := by
    rw [show y • U - z • (1 : Mat4) =
        y • (U - (z / y) • (1 : Mat4)) by
      ext i j
      simp [hy]
      field_simp]
    rw [Matrix.det_smul]
    norm_num
  have hright :
      (z • U - y • (1 : Mat4)).det =
        z ^ 4 * (U - (y / z) • (1 : Mat4)).det := by
    rw [show z • U - y • (1 : Mat4) =
        z • (U - (y / z) • (1 : Mat4)) by
      ext i j
      simp [hz]
      field_simp]
    rw [Matrix.det_smul]
    norm_num
  rw [hleft, hright]
  have hrec := massiveHNU_shifted_det_reciprocal a k (z / y)
    (div_ne_zero hz hy)
  change (U - (z / y) • (1 : Mat4)).det =
      (z / y) ^ 4 * (U - (z / y)⁻¹ • (1 : Mat4)).det at hrec
  rw [hrec]
  rw [show (z / y)⁻¹ = y / z by field_simp]
  field_simp

/-- Factor a negative spectral shift of the inverse Cayley generator through
the common nonsingular denominator `U + I`. -/
theorem cayleyGenerator_sub_shift_factor (U : Mat4)
    (hpi : (U + 1).det != 0) (x : Complex) :
    cayleyGenerator U - x • (1 : Mat4) =
      (((Complex.I - x) • U - (Complex.I + x) • (1 : Mat4)) *
        (U + 1)⁻¹) := by
  have hunit : IsUnit (U + 1).det := isUnit_iff_ne_zero.mpr hpi
  have hmul : (U + 1) * (U + 1)⁻¹ = (1 : Mat4) :=
    Matrix.mul_nonsing_inv _ hunit
  unfold cayleyGenerator
  rw [← hmul]
  simp only [Matrix.smul_mul, Matrix.mul_smul]
  noncomm_ring

/-- Factor a positive spectral shift of the inverse Cayley generator through
the common nonsingular denominator `U + I`. -/
theorem cayleyGenerator_add_shift_factor (U : Mat4)
    (hpi : (U + 1).det != 0) (x : Complex) :
    cayleyGenerator U + x • (1 : Mat4) =
      (((Complex.I + x) • U - (Complex.I - x) • (1 : Mat4)) *
        (U + 1)⁻¹) := by
  have hunit : IsUnit (U + 1).det := isUnit_iff_ne_zero.mpr hpi
  have hmul : (U + 1) * (U + 1)⁻¹ = (1 : Mat4) :=
    Matrix.mul_nonsing_inv _ hunit
  unfold cayleyGenerator
  rw [← hmul]
  simp only [Matrix.smul_mul, Matrix.mul_smul]
  noncomm_ring

/-- The exact inverse-Cayley generator has an even shifted determinant over
the complete closed Brillouin cube. -/
theorem hnuCayleyGenerator_shifted_det_even (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) (x : Complex) :
    (hnuCayleyGenerator a k - x • (1 : Mat4)).det =
      (hnuCayleyGenerator a k + x • (1 : Mat4)).det := by
  have hpi :
      (massiveHNU (1 : Complex) a k + 1).det != 0 := by
    simpa only [bne_iff_ne] using
      (massiveHNU_zero_pi_gap a ha0 hapi k hk).2
  unfold hnuCayleyGenerator
  rw [cayleyGenerator_sub_shift_factor _ hpi,
    cayleyGenerator_add_shift_factor _ hpi]
  simp only [Matrix.det_mul]
  rw [massiveHNU_homogeneous_det_swap]

end PhysicsSM.Draft.NullEdge.HNUCayleyEvenDeterminant
