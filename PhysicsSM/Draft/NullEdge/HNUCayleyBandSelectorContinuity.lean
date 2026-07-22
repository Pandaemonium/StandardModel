import PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical

/-!
# Continuity of the massive HNU inverse-Cayley generator

The canonical Cayley band selector requires more than pointwise existence.  This
module proves the first analytic bridge: the live massive HNU endpoint is a
continuous matrix-valued function of momentum, and its inverse-Cayley Hermitian
generator is continuous on the closed Brillouin cube for every mass angle in
`(0, pi)`.

The proof is finite and direct.  Endpoint continuity is checked entrywise from
the finite product of complex exponentials.  Continuity of matrix inversion is
then applied at the shifted endpoint `U(k) + 1`; the landed global `pi` gap is
exactly the nonzero-determinant hypothesis.

This is not yet continuity of the certified sign or negative-band projector.
That successor additionally needs a uniform spectral-gap functional-calculus or
finite inertia theorem.  Nor does this result prove rank, locality, physical
occupation, or companion removal.

Provenance: clean-room finite-matrix analysis using Mathlib's topology on
matrices and the live HNU exact endpoint.  The Cayley strategy is informed by
C. Bourne, SIGMA 19 (2023) 053, DOI 10.3842/SIGMA.2023.053.

Draft-trust status: every theorem is kernel-checked.  The build-enforced axiom
footprint is pinned in `HNUCayleyBandSelectorContinuityAxiomGuard`.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay
open PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap
open PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorContinuity

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- Matrix inversion composed with a continuous family is continuous at every
point where the determinant is nonzero. -/
theorem continuousAt_matrix_inv_comp {X : Type} [TopologicalSpace X]
    (F : X -> Mat4) (x : X) (hF : ContinuousAt F x)
    (hdet : (F x).det != 0) : ContinuousAt (fun y => (F y)⁻¹) x := by
  have hInv : ContinuousAt (fun M : Mat4 => M⁻¹) (F x) := by
    apply continuousAt_matrix_inv
    rw [show Ring.inverse = (Inv.inv : Complex -> Complex) by
      funext z
      exact Ring.inverse_eq_inv z]
    exact continuousAt_inv₀ (by simpa only [bne_iff_ne] using hdet)
  exact hInv.comp_of_eq hF rfl

set_option maxHeartbeats 2000000 in
/-- The exact massive HNU Bloch endpoint is globally continuous in momentum. -/
theorem massiveHNU_continuous (a : Real) :
    Continuous (fun k : Fin 3 -> Real => massiveHNU (1 : Complex) a k) := by
  apply continuous_matrix
  intro i j
  fin_cases i <;> fin_cases j <;>
    simp [massiveHNU, diracHNU, doubledChiralEndpoint, endpoint, Uplus, Uminus,
      Matrix.mul_apply, Fin.sum_univ_succ] <;>
    fun_prop

/-- At every Brillouin-zone momentum, the inverse-Cayley generator is
continuous relative to the Brillouin cube. -/
theorem hnuCayleyGenerator_continuousWithinAt (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) :
    ContinuousWithinAt (fun q : Fin 3 -> Real => hnuCayleyGenerator a q)
      {q | InBZ q} k := by
  have hU : ContinuousAt
      (fun q : Fin 3 -> Real => massiveHNU (1 : Complex) a q) k :=
    (massiveHNU_continuous a).continuousAt
  have hsum : ContinuousAt
      (fun q : Fin 3 -> Real => massiveHNU (1 : Complex) a q + (1 : Mat4)) k :=
    hU.add continuousAt_const
  have hdet : (massiveHNU (1 : Complex) a k + 1).det != 0 :=
    (massiveHNU_zero_pi_gap a ha0 hapi k hk).2
  have hinv : ContinuousAt
      (fun q : Fin 3 -> Real => (massiveHNU (1 : Complex) a q + 1)⁻¹) k :=
    continuousAt_matrix_inv_comp _ k hsum hdet
  apply ContinuousAt.continuousWithinAt
  unfold hnuCayleyGenerator cayleyGenerator
  fun_prop

/-- The live inverse-Cayley Hermitian generator is continuous on the complete
closed Brillouin cube. -/
theorem hnuCayleyGenerator_continuousOn (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi) :
    ContinuousOn (fun q : Fin 3 -> Real => hnuCayleyGenerator a q)
      {q | InBZ q} := by
  intro k hk
  exact hnuCayleyGenerator_continuousWithinAt a ha0 hapi k hk

end PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorContinuity
