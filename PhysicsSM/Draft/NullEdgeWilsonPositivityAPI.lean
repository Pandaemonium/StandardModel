import PhysicsSM.Draft.NullEdgeGateCSplit

/-!
# Wilson positivity API for Gate C0

This draft module records two small, reusable finite-algebra interfaces for the
Gate C0 Wilson strategy.

1. `WilsonQuadraticIdentityData` packages the standard Wilson identity:
   the quadratic form of `2 - T - T^dagger` is a sum of squared edge defects.
   From this, nonnegativity and the zero-mode characterization are immediate.

2. `WilsonC0GapData` packages the real-torus Wilson lower bound:
   if `r > 0` and `W(q) > 0` away from the origin, then the branch mass
   `r * W(q)` is positive away from the origin.

The module is intentionally abstract.  It does not claim that the concrete
link-dressed null-Wilson operator has been fully connected to these predicates;
`NullEdgeNullWilsonGaugeCovariance.lean` supplies the finite transport model,
and a later instantiation should prove the corresponding edge-defect identity
for that model.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdgeWilsonPositivityAPI

open NullEdgeGateCSplit

/--
Abstract data for the Wilson quadratic-form identity.

`wilsonEnergy` is the quadratic form of the Wilson operator on a state.
`defectEnergy` is the sum of squared edge defects.  The data says these are
equal, the defect energy is nonnegative, and its zero locus is the covariantly
constant sector.
-/
structure WilsonQuadraticIdentityData (State : Type*) where
  wilsonEnergy : State -> ℝ
  defectEnergy : State -> ℝ
  covariantlyConstant : State -> Prop
  energy_eq_defect : ∀ psi, wilsonEnergy psi = defectEnergy psi
  defect_nonneg : ∀ psi, 0 <= defectEnergy psi
  defect_zero_iff_covariantlyConstant :
    ∀ psi, defectEnergy psi = 0 <-> covariantlyConstant psi

/-- The Wilson quadratic form is nonnegative whenever it is a defect square. -/
theorem wilsonEnergy_nonneg {State : Type*}
    (D : WilsonQuadraticIdentityData State) (psi : State) :
    0 <= D.wilsonEnergy psi := by
  rw [D.energy_eq_defect psi]
  exact D.defect_nonneg psi

/--
The Wilson zero sector is exactly the covariantly constant sector, provided the
edge-defect identity and zero-defect characterization are known.
-/
theorem wilsonEnergy_zero_iff_covariantlyConstant {State : Type*}
    (D : WilsonQuadraticIdentityData State) (psi : State) :
    D.wilsonEnergy psi = 0 <-> D.covariantlyConstant psi := by
  constructor
  · intro h
    apply (D.defect_zero_iff_covariantlyConstant psi).mp
    rw [← D.energy_eq_defect psi]
    exact h
  · intro h
    rw [D.energy_eq_defect psi]
    exact (D.defect_zero_iff_covariantlyConstant psi).mpr h

/--
Abstract data for the Gate C0 real-torus Wilson lower bound.

`Q` is a branch/momentum domain, `isOrigin` marks the physical origin branch,
`W` is the scalar Wilson profile, and `r` is the Wilson coefficient.
-/
structure WilsonC0GapData (Q : Type*) where
  isOrigin : Q -> Prop
  W : Q -> ℝ
  r : ℝ
  originRetained : Prop
  leadingSymbolUnchanged : Prop
  gapIsMassGap : Prop
  r_pos : 0 < r
  W_pos_away_origin : ∀ q, ¬ isOrigin q -> 0 < W q

namespace WilsonC0GapData

/-- The C0 Wilson branch mass. -/
def branchMass {Q : Type*} (D : WilsonC0GapData Q) (q : Q) : ℝ :=
  D.r * D.W q

/-- Positive Wilson coefficient plus positive Wilson profile gives a gap. -/
theorem branchMass_pos_away_origin {Q : Type*} (D : WilsonC0GapData Q)
    (q : Q) (hq : ¬ D.isOrigin q) :
    0 < D.branchMass q := by
  exact mul_pos D.r_pos (D.W_pos_away_origin q hq)

/-- The away-origin Wilson branch mass is nonzero. -/
theorem branchMass_ne_zero_away_origin {Q : Type*} (D : WilsonC0GapData Q)
    (q : Q) (hq : ¬ D.isOrigin q) :
    D.branchMass q ≠ 0 :=
  ne_of_gt (D.branchMass_pos_away_origin q hq)

/-- Convert the Wilson lower-bound data into the abstract Gate C0 data record. -/
def toGateC0Data {Q : Type*} (D : WilsonC0GapData Q) : GateC0Data where
  originRetained := D.originRetained
  nonOriginGapped := ∀ q, ¬ D.isOrigin q -> 0 < D.branchMass q
  gappedByMassGap := D.gapIsMassGap
  leadingSymbolUnchanged := D.leadingSymbolUnchanged

/--
If the origin is retained, the leading symbol is unchanged, and the Wilson gap
is a genuine mass gap, then positive Wilson mass away from the origin gives the
Gate C0 species-health predicate.
-/
theorem gateC0SpeciesHealthy {Q : Type*} (D : WilsonC0GapData Q)
    (hOrigin : D.originRetained)
    (hMassGap : D.gapIsMassGap)
    (hSymbol : D.leadingSymbolUnchanged) :
    GateC0SpeciesHealthy D.toGateC0Data := by
  refine ⟨hOrigin, ?_, hMassGap, hSymbol⟩
  intro q hq
  exact D.branchMass_pos_away_origin q hq

end WilsonC0GapData

end NullEdgeWilsonPositivityAPI
end Draft
end PhysicsSM
