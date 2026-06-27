import PhysicsSM.Spinor.PluckerMass
import PhysicsSM.Draft.NullEdgeDiracSlashCore

/-!
# Draft.NullEdgeBundleDiracPluckerCore

Finite bridge from the trusted Pluecker mass theorem to the static chiral
Dirac square-root operator.

The trusted theorem
`PhysicsSM.Spinor.PluckerMass.fin_bundle_plucker_mass_identity` proves that
the determinant of the summed visible rank-one spinor momenta is the total
pairwise Pluecker mass.  This draft module extracts Weyl coordinates from that
`2 x 2` matrix and composes the determinant theorem with the finite chiral
Dirac-slash square.

This is still static finite algebra.  It does not assert a continuum Dirac
equation, propagation law, or scattering interpretation.

Provenance: integrated from the focused Aristotle job
`null-edge-bundle-dirac-plucker-core-20260621`, with the Pluecker determinant
step routed through the trusted `PhysicsSM.Spinor.PluckerMass` API.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore

open BigOperators
open Matrix Complex

abbrev CSpinor := PhysicsSM.Spinor.PluckerMass.CSpinor
abbrev ChiralIdx := Sum (Fin 2) (Fin 2)

abbrev minkowskiNorm : (Fin 4 -> Complex) -> Complex :=
  NullEdgeDiracSlashCore.minkowskiNorm

abbrev sigmaMomentum :
    (Fin 4 -> Complex) -> Matrix (Fin 2) (Fin 2) Complex :=
  NullEdgeDiracSlashCore.sigmaMomentum

abbrev barSigmaMomentum :
    (Fin 4 -> Complex) -> Matrix (Fin 2) (Fin 2) Complex :=
  NullEdgeDiracSlashCore.barSigmaMomentum

abbrev chiralDiracSlash :
    (Fin 4 -> Complex) -> Matrix ChiralIdx ChiralIdx Complex :=
  NullEdgeDiracSlashCore.chiralDiracSlash

/-- Pauli/Weyl coordinates of an arbitrary `2 x 2` complex matrix. -/
def matrixWeylCoords (M : Matrix (Fin 2) (Fin 2) Complex) : Fin 4 -> Complex :=
  fun mu =>
    if mu = 0 then (M 0 0 + M 1 1) / 2
    else if mu = 1 then (M 0 1 + M 1 0) / 2
    else if mu = 2 then (M 1 0 - M 0 1) / (2 * Complex.I)
    else (M 0 0 - M 1 1) / 2

/-- Reconstruct a `2 x 2` matrix from its Pauli/Weyl coordinates. -/
theorem sigmaMomentum_matrixWeylCoords_eq
    (M : Matrix (Fin 2) (Fin 2) Complex) :
    sigmaMomentum (matrixWeylCoords M) = M := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [NullEdgeDiracSlashCore.sigmaMomentum, matrixWeylCoords] <;>
      ring_nf <;>
      norm_num [Complex.ext_iff] <;>
      ring_nf <;>
      norm_num

/-- The `(+---)` Minkowski scalar is the determinant of the Weyl block. -/
theorem minkowskiNorm_eq_det_sigmaMomentum (p : Fin 4 -> Complex) :
    minkowskiNorm p = (sigmaMomentum p).det :=
  (NullEdgeDiracSlashCore.sigmaMomentum_det_eq_minkowskiNorm p).symm

/-- The Weyl-coordinate Minkowski scalar of a matrix is its determinant. -/
theorem minkowskiNorm_matrixWeylCoords_eq_det
    (M : Matrix (Fin 2) (Fin 2) Complex) :
    minkowskiNorm (matrixWeylCoords M) = M.det := by
  rw [minkowskiNorm_eq_det_sigmaMomentum, sigmaMomentum_matrixWeylCoords_eq]

/-- First Weyl block in the Dirac-square identity. -/
theorem sigma_mul_barSigma_eq_norm (p : Fin 4 -> Complex) :
    sigmaMomentum p * barSigmaMomentum p =
      minkowskiNorm p • (1 : Matrix (Fin 2) (Fin 2) Complex) :=
  NullEdgeDiracSlashCore.sigma_mul_barSigma_eq_norm p

/-- Second Weyl block in the Dirac-square identity. -/
theorem barSigma_mul_sigma_eq_norm (p : Fin 4 -> Complex) :
    barSigmaMomentum p * sigmaMomentum p =
      minkowskiNorm p • (1 : Matrix (Fin 2) (Fin 2) Complex) :=
  NullEdgeDiracSlashCore.barSigma_mul_sigma_eq_norm p

/-- Static finite Dirac square root of the momentum determinant. -/
theorem chiralDiracSlash_sq_eq_norm (p : Fin 4 -> Complex) :
    chiralDiracSlash p * chiralDiracSlash p =
      minkowskiNorm p • (1 : Matrix ChiralIdx ChiralIdx Complex) :=
  NullEdgeDiracSlashCore.chiralDiracSlash_sq_eq_norm p

/-- Trusted Pluecker determinant theorem, restated in this bridge namespace. -/
theorem finBundleMomentum_det_eq_pairwisePluckerMass {n : Nat}
    (psi : Fin n -> CSpinor) :
    (PhysicsSM.Spinor.PluckerMass.finBundleMomentum psi).det =
      PhysicsSM.Spinor.PluckerMass.finPairwisePluckerMass psi :=
  PhysicsSM.Spinor.PluckerMass.fin_bundle_plucker_mass_identity psi

/-- The Weyl-coordinate Minkowski scalar of the bundle momentum is Pluecker mass. -/
theorem bundleMomentum_minkowskiNorm_eq_pairwisePluckerMass {n : Nat}
    (psi : Fin n -> CSpinor) :
    minkowskiNorm
        (matrixWeylCoords (PhysicsSM.Spinor.PluckerMass.finBundleMomentum psi)) =
      PhysicsSM.Spinor.PluckerMass.finPairwisePluckerMass psi := by
  rw [minkowskiNorm_matrixWeylCoords_eq_det,
    finBundleMomentum_det_eq_pairwisePluckerMass]

/--
The static chiral Dirac slash built from the finite bundle momentum squares to
the trusted pairwise Pluecker mass.
-/
theorem chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass {n : Nat}
    (psi : Fin n -> CSpinor) :
    chiralDiracSlash
        (matrixWeylCoords (PhysicsSM.Spinor.PluckerMass.finBundleMomentum psi)) *
      chiralDiracSlash
        (matrixWeylCoords (PhysicsSM.Spinor.PluckerMass.finBundleMomentum psi)) =
      PhysicsSM.Spinor.PluckerMass.finPairwisePluckerMass psi •
        (1 : Matrix ChiralIdx ChiralIdx Complex) := by
  rw [chiralDiracSlash_sq_eq_norm,
    bundleMomentum_minkowskiNorm_eq_pairwisePluckerMass]

end PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore

end
