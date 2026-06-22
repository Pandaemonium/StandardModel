import Mathlib

/-!
# Bundle Dirac slash and Plucker mass core

Standalone finite algebra for composing the Dirac-slash square root with the
finite Plucker mass theorem.

The main target says: build the `2 x 2` visible momentum from a finite bundle
of null spinors, extract its Pauli/Weyl four-coordinates, and prove that the
chiral Dirac slash squares to the pairwise Plucker mass.
-/

noncomputable section

namespace NullEdgeBundleDiracPluckerCore

open BigOperators
open Matrix Complex

abbrev CSpinor := Fin 2 -> Complex

def complexAbsSq (z : Complex) : Complex :=
  z * starRingEnd Complex z

def spinorWedge (psi phi : CSpinor) : Complex :=
  psi 0 * phi 1 - psi 1 * phi 0

def rankOneHermitian (psi : CSpinor) : Matrix (Fin 2) (Fin 2) Complex :=
  Matrix.vecMulVec psi fun a => starRingEnd Complex (psi a)

def finBundleMomentum {n : Nat} (psi : Fin n -> CSpinor) :
    Matrix (Fin 2) (Fin 2) Complex :=
  Finset.univ.sum fun i : Fin n => rankOneHermitian (psi i)

def finPairIndexSet (n : Nat) : Finset (Prod (Fin n) (Fin n)) :=
  Finset.univ.filter fun p => (p.1 : Nat) < (p.2 : Nat)

def finPairwisePluckerMass {n : Nat} (psi : Fin n -> CSpinor) : Complex :=
  (finPairIndexSet n).sum fun p =>
    complexAbsSq (spinorWedge (psi p.1) (psi p.2))

def minkowskiNorm (p : Fin 4 -> Complex) : Complex :=
  p 0 * p 0 - p 1 * p 1 - p 2 * p 2 - p 3 * p 3

def sigmaMomentum (p : Fin 4 -> Complex) : Matrix (Fin 2) (Fin 2) Complex :=
  fun a b =>
    if a = 0 /\ b = 0 then p 0 + p 3
    else if a = 0 /\ b = 1 then p 1 - Complex.I * p 2
    else if a = 1 /\ b = 0 then p 1 + Complex.I * p 2
    else p 0 - p 3

def barSigmaMomentum (p : Fin 4 -> Complex) : Matrix (Fin 2) (Fin 2) Complex :=
  fun a b =>
    if a = 0 /\ b = 0 then p 0 - p 3
    else if a = 0 /\ b = 1 then -p 1 + Complex.I * p 2
    else if a = 1 /\ b = 0 then -p 1 - Complex.I * p 2
    else p 0 + p 3

def chiralDiracSlash (p : Fin 4 -> Complex) :
    Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex :=
  fun a b =>
    match a, b with
    | Sum.inl _, Sum.inl _ => 0
    | Sum.inl i, Sum.inr j => sigmaMomentum p i j
    | Sum.inr i, Sum.inl j => barSigmaMomentum p i j
    | Sum.inr _, Sum.inr _ => 0

/-- Pauli/Weyl coordinates of an arbitrary `2 x 2` complex matrix. -/
def matrixWeylCoords (M : Matrix (Fin 2) (Fin 2) Complex) : Fin 4 -> Complex :=
  fun mu =>
    if mu = 0 then (M 0 0 + M 1 1) / 2
    else if mu = 1 then (M 0 1 + M 1 0) / 2
    else if mu = 2 then (M 1 0 - M 0 1) / (2 * Complex.I)
    else (M 0 0 - M 1 1) / 2

theorem sigmaMomentum_matrixWeylCoords_eq
    (M : Matrix (Fin 2) (Fin 2) Complex) :
    sigmaMomentum (matrixWeylCoords M) = M := by
  sorry

theorem minkowskiNorm_matrixWeylCoords_eq_det
    (M : Matrix (Fin 2) (Fin 2) Complex) :
    minkowskiNorm (matrixWeylCoords M) = M.det := by
  sorry

theorem sigma_mul_barSigma_eq_norm (p : Fin 4 -> Complex) :
    sigmaMomentum p * barSigmaMomentum p =
      minkowskiNorm p • (1 : Matrix (Fin 2) (Fin 2) Complex) := by
  sorry

theorem barSigma_mul_sigma_eq_norm (p : Fin 4 -> Complex) :
    barSigmaMomentum p * sigmaMomentum p =
      minkowskiNorm p • (1 : Matrix (Fin 2) (Fin 2) Complex) := by
  sorry

theorem chiralDiracSlash_sq_eq_norm (p : Fin 4 -> Complex) :
    chiralDiracSlash p * chiralDiracSlash p =
      minkowskiNorm p •
        (1 : Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex) := by
  sorry

theorem finBundleMomentum_det_eq_pairwisePluckerMass {n : Nat}
    (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = finPairwisePluckerMass psi := by
  sorry

theorem bundleMomentum_minkowskiNorm_eq_pairwisePluckerMass {n : Nat}
    (psi : Fin n -> CSpinor) :
    minkowskiNorm (matrixWeylCoords (finBundleMomentum psi)) =
      finPairwisePluckerMass psi := by
  sorry

theorem chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass {n : Nat}
    (psi : Fin n -> CSpinor) :
    chiralDiracSlash (matrixWeylCoords (finBundleMomentum psi)) *
      chiralDiracSlash (matrixWeylCoords (finBundleMomentum psi)) =
      finPairwisePluckerMass psi •
        (1 : Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex) := by
  sorry

end NullEdgeBundleDiracPluckerCore

end
