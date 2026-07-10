import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
import PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo

/-!
# Stationary-amplitude no-go for the live 3+1 axis generators

This module composes the abstract degree-one Laurent no-go with the actual
`alpha1`, `alpha2`, and `alpha3` matrices used by the paper's ordered `3+1`
walk.  It removes a prose-level specialization: every live axis generator is
already proved Hermitian and involutory, so a normalized, exactly unitary
degree-one factor with that tangent must have zero stationary coefficient.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeLiveAxisNoGo

open Matrix Complex

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

theorem alpha1_stationary_forces_zero (A B C : Mat4)
    (hU : PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.UnitaryAllMomenta
      (PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.laurentStep A B C))
    (hT : PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.HasRegulatedTangent
      (PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.laurentStep A B C)
      PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.alpha1) :
    B = 0 := by
  rcases PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.generators_hermitian_square_one with
    ⟨h1, _, _, _, hs1, _, _, _⟩
  exact PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.stationary_forces_zero
    A B C PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.alpha1 h1.eq hs1 hU hT

theorem alpha2_stationary_forces_zero (A B C : Mat4)
    (hU : PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.UnitaryAllMomenta
      (PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.laurentStep A B C))
    (hT : PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.HasRegulatedTangent
      (PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.laurentStep A B C)
      PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.alpha2) :
    B = 0 := by
  rcases PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.generators_hermitian_square_one with
    ⟨_, h2, _, _, _, hs2, _, _⟩
  exact PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.stationary_forces_zero
    A B C PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.alpha2 h2.eq hs2 hU hT

theorem alpha3_stationary_forces_zero (A B C : Mat4)
    (hU : PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.UnitaryAllMomenta
      (PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.laurentStep A B C))
    (hT : PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.HasRegulatedTangent
      (PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.laurentStep A B C)
      PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.alpha3) :
    B = 0 := by
  rcases PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.generators_hermitian_square_one with
    ⟨_, _, h3, _, _, _, hs3, _⟩
  exact PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.stationary_forces_zero
    A B C PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.alpha3 h3.eq hs3 hU hT

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeLiveAxisNoGo.alpha1_stationary_forces_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms alpha1_stationary_forces_zero

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeLiveAxisNoGo.alpha2_stationary_forces_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms alpha2_stationary_forces_zero

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeLiveAxisNoGo.alpha3_stationary_forces_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms alpha3_stationary_forces_zero

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeLiveAxisNoGo
