import PhysicsSM.NullStrand.Conventions
import PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore

/-!
# NullStrand.FiniteCore

Static finite entry point for the null-strand stack, assembling the trusted
bridge from finite Plucker mass to the finite chiral Dirac square-root identity.

Provenance:
- `PhysicsSM.Draft.NullEdgeDiracSlashCore`
- `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`
- `PhysicsSM.Spinor.PluckerMass`
-/

noncomputable section

namespace PhysicsSM.NullStrand

open Matrix Complex
open PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore

abbrev ChiralIdx := Sum (Fin 2) (Fin 2)

/-- Finite momentum in Weyl coordinates from a finite Weyl-spinor bundle. -/
def bundleMomentum {n : Nat} (psi : Fin n -> WeylSpinor) : Fin 4 -> Complex :=
  matrixWeylCoords (PhysicsSM.Spinor.PluckerMass.finBundleMomentum psi)

/--
Static finite mass-square-root theorem for the finite momentum block.

This is the trusted finite algebraic bridge used by the roadmap as the first
entry point to the model stack.
-/
theorem finiteCore_staticMassSquareRoot {n : Nat} (psi : Fin n -> WeylSpinor) :
    chiralDiracSlash (bundleMomentum psi) *
        chiralDiracSlash (bundleMomentum psi) =
      SMul.smul (PhysicsSM.Spinor.PluckerMass.finPairwisePluckerMass psi)
        (1 : Matrix ChiralIdx ChiralIdx Complex) := by
  simpa [bundleMomentum] using chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass (psi := psi)

end PhysicsSM.NullStrand
