import PhysicsSM.Draft.NullEdge.DynamicalMassCovariance
import PhysicsSM.Draft.NullEdge.PluckerMassDynamics

/-!
# Aristotle target: exact covariance of the discrete Pluecker walk step

The generator-family classification is already landed. This target verifies
that both classified branches act on the actual ordered one-step propagator:
the diagonal branch preserves momentum, while the antidiagonal branch requires
parity. Preserve the exact statements and the order `transport * massCoin`.
-/

noncomputable section

open Matrix Complex
open scoped Matrix ComplexConjugate

namespace PhysicsSM.Draft.NullEdge.DiscreteWalkMassCovariance

open PhysicsSM.Draft.NullEdge.DynamicalMassCovariance

abbrev Mat := Matrix (Fin 2) (Fin 2) Complex

/-- Exact null transport in momentum space. -/
def transportStep (k a : Real) : Mat :=
  !![Complex.exp (-Complex.I * (k * a)), 0;
     0, Complex.exp (Complex.I * (k * a))]

/-- Ordered finite step: null transport followed by the derived Pluecker mass
coin. -/
def walkStep (k : Real) (z : Complex) (a : Real) : Mat :=
  transportStep k a *
    PhysicsSM.Draft.NullEdge.PluckerMassDynamics.massCoin z a

/-- Every classified same-momentum covariance acts exactly on the ordered
finite walk step. -/
theorem chiralPhase_walk_covariance (lam u z : Complex) (k a : Real)
    (hlam : ‖lam‖ = 1) (hu : ‖u‖ = 1) :
    (lam • chiralPhase u) * walkStep k z a * (lam • chiralPhase u)ᴴ =
      walkStep k (u * z) a := by
  sorry

/-- Every classified orientation-reversing covariance acts exactly on the
ordered finite walk only when accompanied by parity `k -> -k`. -/
theorem chiralFlip_walk_parity_covariance (lam u z : Complex) (k a : Real)
    (hlam : ‖lam‖ = 1) (hu : ‖u‖ = 1) :
    (lam • chiralFlip u) * walkStep k z a * (lam • chiralFlip u)ᴴ =
      walkStep (-k) (u * conj z) a := by
  sorry

end PhysicsSM.Draft.NullEdge.DiscreteWalkMassCovariance
