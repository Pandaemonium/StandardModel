import PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay

/-!
# Global zero/pi gap target for the massive HNU walk

This draft isolates the strongest immediate consequence suggested by the exact
HNU census and the newly integrated Pluecker mass composition. The headline
claim is deliberately global over the closed Brillouin cube. It is not implied
by exact unitarity or by the infrared Dirac tangent alone.

The parity-census lemma is the expected hard trigonometric core. Numerical and
symbolic oracles suggest the statements below, but those calculations are not
proof. This file is an Aristotle handoff and remains draft while its proof holes
are present.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap

/-- Closed first Brillouin cube in the conventions of `HNUExactCore`. -/
def InBZ (k : Fin 3 -> Real) : Prop :=
  forall i, Set.Icc (-Real.pi) Real.pi (k i)

/-- Boundary of the chosen closed Brillouin cube. -/
def OnBZBoundary (k : Fin 3 -> Real) : Prop :=
  Exists fun i => k i = Real.pi ∨ k i = -Real.pi

/-- Hard parity census: the endpoint agrees with its momentum-reversed copy
only at the origin or on the exact pi boundary. -/
theorem endpoint_eq_momentumReverse_iff (k : Fin 3 -> Real) (hk : InBZ k) :
    endpoint k = endpoint (fun i => -k i) <->
      (forall i, k i = 0) ∨ OnBZBoundary k := by
  sorry

/-- A nontrivial real Pluecker mass angle removes both zero and pi
quasienergy crossings over the complete Brillouin cube. -/
theorem massiveHNU_zero_pi_gap (a : Real) (ha0 : 0 < a)
    (hapi : a < Real.pi) (k : Fin 3 -> Real) (hk : InBZ k) :
    (massiveHNU (1 : Complex) a k - 1).det != 0 /\
      (massiveHNU (1 : Complex) a k + 1).det != 0 := by
  sorry

/-- The origin is a nonvacuous control: the massive update is the exact local
mass coin, while the global gap theorem still excludes eigenvalues `+1` and
`-1` for a nontrivial angle. -/
theorem massiveHNU_origin_zero_pi_gap (a : Real) (ha0 : 0 < a)
    (hapi : a < Real.pi) :
    massiveHNU (1 : Complex) a 0 =
        PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.massCoin4 1 a /\
      (massiveHNU (1 : Complex) a 0 - 1).det != 0 /\
      (massiveHNU (1 : Complex) a 0 + 1).det != 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap
