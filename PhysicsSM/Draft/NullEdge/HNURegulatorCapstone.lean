import PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge
import PhysicsSM.Draft.NullEdge.HNURealSpaceBridge
import PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy
import PhysicsSM.Draft.NullEdge.HNUQuantitativeGlobalGap

/-!
# Exact finite HNU regulator certificates

This module packages the principal finite HNU results without expanding their
physical interpretation. The massless certificate records exact momentum-space
unitarity, determinant, complete zero/pi census, the infrared Weyl tangent,
and local orientation. The real-space certificate records exact symbol
intertwining and inner-product preservation. The massive certificate records
full-zone unitarity and uniform shifted-determinant margins.

These are certificates for an exact free Floquet regulator. They do not claim
that every substep is a primitive null move, that the changing-lattice
position-space continuum theorem is complete, or that interactions preserve a
selected physical sector. Claim grade `M`, `[comp]`.
-/

open Matrix Complex

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNURegulatorCapstone

open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge
open PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay
open PhysicsSM.Draft.NullEdge.WeylSphereChargeBridge (weylHam chirality)

/-- Exact momentum-space certificate for the massless HNU endpoint. -/
structure FiniteMasslessCertificate : Prop where
  endpointUnitary : ∀ k : Fin 3 -> Real,
    endpoint k ∈ unitary HNUExactCore.M2
  endpointDetOne : ∀ k : Fin 3 -> Real, (endpoint k).det = 1
  zeroCensus : ∀ k : Fin 3 -> Real,
    (∀ i, k i ∈ Set.Icc (-Real.pi) Real.pi) ->
      (endpoint k = 1 ↔ ∀ i, k i = 0)
  piCensus : ∀ k : Fin 3 -> Real,
    (∀ i, k i ∈ Set.Icc (-Real.pi) Real.pi) ->
      (endpoint k = -1 ↔ ∃ i, k i = Real.pi ∨ k i = -Real.pi)
  infraredTangent : ∀ q : Fin 3 -> Real,
    HasDerivAt (fun t : Real => endpoint (fun i => t * q i))
      ((-Complex.I) • weylHam weylJacobian q) 0
  localOrientation : chirality weylJacobian = 1
  nonzeroAxisWitness : weylHam weylJacobian ![1, 0, 0] ≠ 0

/-- The exact HNU endpoint supplies the complete finite massless certificate. -/
theorem finiteMasslessCertificate : FiniteMasslessCertificate where
  endpointUnitary := endpoint_unitary
  endpointDetOne := endpoint_det
  zeroCensus := fun k hk => HNUExactCore.zero_census k hk
  piCensus := fun k hk => HNUExactCore.pi_census k hk
  infraredTangent := endpoint_ir_tangent_weyl
  localOrientation := local_chirality_one
  nonzeroAxisWitness := linearized_node_axis0_ne_zero

/-- On every finite periodic lattice of side at least two, the local
depth-eight schedule preserves the exact inner product and acts on every plane
wave by the certified HNU endpoint symbol. -/
theorem realSpace_schedule_certificate {L : Nat} [NeZero L] (hL : 2 <= L) :
    (∀ psi phi : PhysicsSM.Draft.NullEdge.HNURealSpace.State L,
      PhysicsSM.Draft.NullEdge.HNURealSpace.gInner
          (PhysicsSM.Draft.NullEdge.HNURealSpace.schedule psi)
          (PhysicsSM.Draft.NullEdge.HNURealSpace.schedule phi) =
        PhysicsSM.Draft.NullEdge.HNURealSpace.gInner psi phi) ∧
    (∀ k : PhysicsSM.Draft.NullEdge.HNURealSpace.Site L,
      ∀ v : Fin 2 -> Complex,
        PhysicsSM.Draft.NullEdge.HNURealSpace.schedule
            (PhysicsSM.Draft.NullEdge.HNURealSpace.planeWave
              (PhysicsSM.Draft.NullEdge.HNURealSpace.char k) v) =
          PhysicsSM.Draft.NullEdge.HNURealSpace.planeWave
            (PhysicsSM.Draft.NullEdge.HNURealSpace.char k)
            (endpoint (PhysicsSM.Draft.NullEdge.HNURealSpace.kR k) *ᵥ v)) := by
  exact ⟨PhysicsSM.Draft.NullEdge.HNURealSpace.schedule_gInner,
    fun k v => PhysicsSM.Draft.NullEdge.HNURealSpace.schedule_symbol hL k v⟩

/-- For a fixed nontrivial Pluecker mass angle, the massive HNU family is
unitary throughout the closed Brillouin cube and has one uniform positive
margin for both shifted determinant norms. -/
theorem massive_full_zone_certificate (a : Real) (ha0 : 0 < a)
    (hapi : a < Real.pi) :
    (∀ k : Fin 3 -> Real, InBZ k ->
      massiveHNU 1 a k ∈ Matrix.unitaryGroup (Fin 4) Complex) ∧
    (∃ delta : Real, 0 < delta ∧
      ∀ k : Fin 3 -> Real, InBZ k ->
        delta <= norm ((massiveHNU (1 : Complex) a k - 1).det) ∧
        delta <= norm ((massiveHNU (1 : Complex) a k + 1).det)) := by
  refine ⟨fun k _ => massiveHNU_unitary 1 (by norm_num) a k, ?_⟩
  exact PhysicsSM.Draft.NullEdge.HNUQuantitativeGlobalGap.massiveHNU_quantitative_zero_pi_gap
    a ha0 hapi

/-- All positive nontrivial mass angles are connected inside the exact massive
HNU family by a continuous path that keeps both shifted determinant gaps open. -/
theorem massive_internal_gapped_connected (a0 a1 : Real)
    (ha0 : 0 < a0) (ha0pi : a0 < Real.pi)
    (ha1 : 0 < a1) (ha1pi : a1 < Real.pi) :
    (∀ t ∈ Set.Icc (0 : Real) 1,
      0 < PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.massAnglePath a0 a1 t ∧
      PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.massAnglePath a0 a1 t < Real.pi) ∧
    Continuous (fun t : Real =>
      PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.massiveHNUAngleHomotopy a0 a1 t) ∧
    PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.massiveHNUAngleHomotopy a0 a1 0 =
      massiveHNU 1 a0 ∧
    PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.massiveHNUAngleHomotopy a0 a1 1 =
      massiveHNU 1 a1 ∧
    (∀ t ∈ Set.Icc (0 : Real) 1, ∀ k, InBZ k ->
      PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.massiveHNUAngleHomotopy a0 a1 t k ∈
          Matrix.unitaryGroup (Fin 4) Complex ∧
        (PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.massiveHNUAngleHomotopy
            a0 a1 t k - 1).det != 0 ∧
        (PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.massiveHNUAngleHomotopy
            a0 a1 t k + 1).det != 0) := by
  exact PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.positive_nontrivial_mass_angles_same_internal_gapped_homotopy
    a0 a1 ha0 ha0pi ha1 ha1pi

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNURegulatorCapstone.finiteMasslessCertificate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finiteMasslessCertificate

/-- info: 'PhysicsSM.Draft.NullEdge.HNURegulatorCapstone.realSpace_schedule_certificate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms realSpace_schedule_certificate

/-- info: 'PhysicsSM.Draft.NullEdge.HNURegulatorCapstone.massive_full_zone_certificate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massive_full_zone_certificate

/-- info: 'PhysicsSM.Draft.NullEdge.HNURegulatorCapstone.massive_internal_gapped_connected' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massive_internal_gapped_connected

end PhysicsSM.Draft.NullEdge.HNURegulatorCapstone
