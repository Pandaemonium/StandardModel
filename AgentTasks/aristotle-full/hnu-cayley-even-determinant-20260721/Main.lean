import PhysicsSM.Draft.NullEdge.HNUMassiveSpectralReciprocity
import PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical

/-!
# Even characteristic determinant of the HNU inverse-Cayley generator

The live massive HNU update has a reciprocal characteristic polynomial:
every nonzero Floquet root `lambda` is accompanied by `lambda^-1`.  The inverse
Cayley map sends reciprocal roots to opposite real generator energies.  This
file isolates the determinant-level bridge, avoiding ordered-eigenvalue API
until the final finite sorting corollary.

Preserve the theorem statement exactly.  Use the landed reciprocal determinant
theorem and the zero/pi gap rather than expanding the full inverse matrix unless
that is genuinely shorter.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap
open PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUCayleyEvenDeterminant

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- The exact inverse-Cayley generator has an even shifted determinant over
the complete closed Brillouin cube. -/
theorem hnuCayleyGenerator_shifted_det_even (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) (x : Complex) :
    (hnuCayleyGenerator a k - x • (1 : Mat4)).det =
      (hnuCayleyGenerator a k + x • (1 : Mat4)).det := by
  sorry

end PhysicsSM.Draft.NullEdge.HNUCayleyEvenDeterminant
