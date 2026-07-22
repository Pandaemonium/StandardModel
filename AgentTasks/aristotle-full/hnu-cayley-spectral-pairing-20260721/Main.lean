import PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical
import PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorContinuity

/-!
# Exact spectral pairing and rank-two HNU Cayley band

The live massive HNU inverse-Cayley generator is Hermitian and invertible on
the closed Brillouin cube for every mass angle in `(0, pi)`. At rest its sign
is the Dirac `beta` matrix. Numerical exact-form probes strongly indicate that
the four ordered real eigenvalues occur in opposite pairs at every momentum.

The targets below ask for that exact finite theorem and its rank-two projector
consequence. Preserve every statement. If the final projector theorem is too
large, return the pairing and inertia theorems whole and report the precise
missing matrix-sign lemma.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay
open PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate
open PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUCayleySpectralPairing

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- The ordered real eigenvalues of the exact HNU inverse-Cayley generator
occur in opposite pairs throughout the closed Brillouin cube. -/
theorem hnuCayleyGenerator_eigenvalue_pairing (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) :
    let hA := hnuCayleyGenerator_isHermitian a ha0 hapi k hk
    hA.eigenvalues 0 = -hA.eigenvalues 3 ∧
      hA.eigenvalues 1 = -hA.eigenvalues 2 := by
  sorry

/-- The global zero gap upgrades opposite pairing to exact `2+2` inertia. -/
theorem hnuCayleyGenerator_two_positive_two_negative (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) :
    let hA := hnuCayleyGenerator_isHermitian a ha0 hapi k hk
    0 < hA.eigenvalues 0 ∧ 0 < hA.eigenvalues 1 ∧
      hA.eigenvalues 2 < 0 ∧ hA.eigenvalues 3 < 0 := by
  sorry

/-- Every certified negative Cayley-sign projector has rank exactly two. -/
theorem hnuCayley_negativeProjector_rank_two (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k)
    (eps P : Mat4)
    (hcert : SignCertificate (hnuCayleyGenerator a k) eps)
    (hP : P = (2 : Complex)⁻¹ • (1 - eps)) :
    Matrix.rank P = 2 := by
  sorry

end PhysicsSM.Draft.NullEdge.HNUCayleySpectralPairing
