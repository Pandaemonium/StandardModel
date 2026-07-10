import Mathlib
import PhysicsSM.Draft.NullEdge.KMFlagship
import PhysicsSM.Draft.NullEdge.C3IndexAnomalyCapstone
import PhysicsSM.Draft.NullEdge.ParticleInformationCapstone
import PhysicsSM.Draft.NullEdge.MasslessParticleTableCapstone
import PhysicsSM.Draft.NullEdge.MassFourFaces
import PhysicsSM.Draft.NullEdge.GravityUnificationCapstone
import PhysicsSM.Draft.NullEdge.LambdaEverpresentCapstone
import PhysicsSM.Draft.NullEdge.UnifiedActionCapstone
import PhysicsSM.Draft.NullEdge.MassPhaseRGCapstone
import PhysicsSM.Draft.NullEdge.HolographicResourceCapstone

/-!
# The all-mass master capstone

`PhysicsSM.Draft.NullEdge.AllMassMasterCapstone`

This module is the master finite composition step of the all-mass run.  It
bundles one honest, kernel-checked representative packet from each landed branch
of the program and states a single master verdict that the run carries a finite
theorem mesh with explicit witnesses and guardrails.

## The four packets

* `finite_cp_family_anomaly_packet` — Goal II CP-phase / family-rank / index
  data from `KMFlagship` and `C3IndexAnomalyCapstone`:  the low-`N` KM summary
  (no phase at `N = 2`, one phase at `N = 3` with unitary nonzero-Jarlskog
  witness), the `N = 3` nondegenerate winding/index witness, and the `N = 2`
  zero control.
* `finite_particle_information_packet` — particle-information / DOF-counting /
  four-faces-of-mass data from `ParticleInformationCapstone`,
  `MasslessParticleTableCapstone`, and `MassFourFaces`:  the four faces of finite
  mass, the disagreement-is-mass positive witnesses, the massless/massive
  information bridge, and distinguishability/compression agreement.
* `finite_gravity_resource_packet` — Goal IV / resource / gravity data from
  `GravityUnificationCapstone`, `UnifiedActionCapstone`,
  `HolographicResourceCapstone`, and `MassPhaseRGCapstone`, parametrised by an
  arbitrary channel-blind, stationary source configuration `(hK, hstat)`:  the
  operator field equation `G = K` with the channel-blind trace source, the
  non-vacuous finite unification data, the four-channel phase / RG verdict, the
  positive holographic-boundary bundle, and the finite gravity claim boundary.
* `finite_lambda_packet` — Lambda sequestering / count / frame-blindness data
  from `LambdaEverpresentCapstone`.

## Honest scope / claim boundary

Every conjunct is a re-export of an already-proved, finite, kernel-checked
imported result.  This master capstone is therefore:

* **NOT** a claim about any measured particle mass value;
* **NOT** continuum quantum gravity or a continuum quantum field theory;
* **NOT** a derivation of the observed cosmological constant.

It is precisely the statement that the run's finite avatars — across CP phases,
particle information, resource/gravity, RG / mass-phase, and Lambda branches —
form one kernel-checked theorem mesh with explicit nonzero witnesses and
false-shape guardrails.  Each headline theorem carries an a x i o m-footprint guard
pin below confirming it depends only on the standard Lean/Mathlib axioms
`propext`, `Classical.choice`, `Quot.sound`.
-/

open scoped BigOperators

namespace AllMassMasterCapstone

/-! ## Packet 1 — finite CP / family-rank / anomaly -/

/-- **Finite CP / family-rank / anomaly packet.**  Bundles the Goal II low-`N`
KM summary, the `N = 3` nondegenerate winding/index witness, and the `N = 2`
zero control. -/
theorem finite_cp_family_anomaly_packet :
    (FiniteKM.physicalPhases 2 = 0
        ∧ (∀ V : Matrix (Fin 2) (Fin 2) ℂ, V.conjTranspose * V = 1 →
              ∃ dL dR : Fin 2 → ℂ,
                FiniteKM.IsPhase dL ∧ FiniteKM.IsPhase dR ∧
                  ∀ i j, ((FiniteKM.rephase dL dR V) i j).im = 0)
        ∧ FiniteKM.physicalPhases 3 = 1
        ∧ FiniteKM.Vwitness.conjTranspose * FiniteKM.Vwitness = 1
        ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0)
      ∧ ((FiniteKM.physicalPhases 3 = 1 ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0)
          ∧ (((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) : ℤ)
              - Module.finrank ℂ
                  ((Fin 3 → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac 3 1))
              = (1 : ℤ))
              ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) = 1)
          ∧ ((FiniteKM.physicalPhases 3 : ℤ) - (FiniteKM.physicalPhases 2 : ℤ) = (1 : ℤ))
          ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1))
              = Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac (2 * 3) 1)))
      ∧ (FiniteKM.physicalPhases 2 = 0
          ∧ Module.finrank ℂ (IncidenceCorank.Edge 2 → ℂ)
              - Module.finrank ℂ (LinearMap.range (IncidenceCorank.coboundary ℂ 2)) = 0
          ∧ Module.finrank ℂ
              (LinearMap.ker (LinearMap.id : (Fin 2 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ))) = 0
          ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 2 0)) = 0) :=
  ⟨KMFlagship.goalII_lowN_summary,
    C3IndexAnomalyCapstone.c3_nondegenerate_witness,
    C3IndexAnomalyCapstone.c3_control_zero⟩

/-! ## Packet 2 — finite particle information / DOF counting / four faces -/

/-- **Finite particle-information packet.**  Bundles the four faces of finite
mass, the disagreement-is-mass positive witnesses, the massless/massive
information bridge, and distinguishability/compression agreement. -/
theorem finite_particle_information_packet :
    ((∀ p x : ℚ, MassFourFaces.Slin p x = 2 * MassFourFaces.detR p x)
        ∧ (∀ p : ℚ, MassFourFaces.Hlin p = 2 * MassFourFaces.detR p 0
            ∧ MassFourFaces.Slin p 0 = MassFourFaces.Hlin p)
        ∧ (∀ p q : ℚ, MassFourFaces.TVdiag p q = |p * (1 - q) - (1 - p) * q|)
        ∧ (∀ p : ℚ, MassFourFaces.detR p 0 = 0 ↔ p = 0 ∨ p = 1)
        ∧ (∀ p : ℚ, MassFourFaces.Slin p 0 = 0 ↔ p = 0 ∨ p = 1)
        ∧ (∀ p : ℚ, MassFourFaces.Hlin p = 0 ↔ p = 0 ∨ p = 1)
        ∧ (∀ p q : ℚ, MassFourFaces.TVdiag p q = 0 ↔ p = q))
      ∧ (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
            = 2 * PhotonSingleEdge.mink PhotonSingleEdge.k1 PhotonSingleEdge.k2
          ∧ PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass = 16
          ∧ (0 : ℚ) < PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
          ∧ ((!![(34:ℝ)/25, 12/25; 12/25, 16/25]).PosSemidef
              ∧ (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det = 16/25
              ∧ 0 < (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det
              ∧ (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).rank = 2
              ∧ (!![(34:ℝ)/25, 12/25; 12/25, 16/25])
                  = MasslessEdgeCount.edge ![1, 0] + MasslessEdgeCount.edge ![3/5, 4/5]))
      ∧ ((PhotonSingleEdge.edgesSpin1
              (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 1
            ∧ LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.rho (1 / 2) (1 / 2)) = 0)
          ∧ (PhotonSingleEdge.edgesSpin1
              (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 2
            ∧ 0 < LeanQuantumDPIMass.Slin
                (LeanQuantumDPIMass.Phi 1 (LeanQuantumDPIMass.rho (1 / 2) (1 / 2)))))
      ∧ (0 < TVDistinguishabilityMass.mass (![1, 0] : Fin 2 → ℚ) (![0, 1] : Fin 2 → ℚ)
          ∧ 0 < KraftCompressionMass.Hlin (![1 / 2, 1 / 4, 1 / 4] : Fin 3 → ℚ)) :=
  ⟨MassFourFaces.four_faces_verdict,
    MasslessParticleTableCapstone.disagreement_mass_positive_witnesses,
    ParticleInformationCapstone.massless_vs_massive_information_bridge,
    ParticleInformationCapstone.distinguishability_compression_agree⟩

/-! ## Packet 3 — finite Goal IV / resource / gravity -/

/-- **Finite gravity / resource packet.**  Parametrised (as
`GravityUnificationCapstone.gravity_unification_capstone` is) by an arbitrary
channel-blind, stationary source configuration `(hK, hstat)`.  Bundles the
operator field equation `G = K` with the channel-blind trace source, the
non-vacuous finite-unification data, the four-channel phase / RG verdict, the
positive holographic-boundary bundle, and the finite gravity claim boundary. -/
theorem finite_gravity_resource_packet
    {n : ℕ} {G K : Matrix (Fin n) (Fin n) ℂ} {kappa : ℂ}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hstat : WEPActionBridge.Stationary G K) :
    (G = K ∧ ∀ rho : Matrix (Fin n) (Fin n) ℂ,
          WEPTrace.Source K rho = kappa * rho.trace)
      ∧ ((∃ gM gG : ℚ, gM ≠ 0 ∧ gG ≠ 0
            ∧ ((SpectralActionAvatar.D 2 1 3 5 ^ 2).trace - 6 = gG)
            ∧ ((SpectralActionAvatar.D 2 1 3 5 ^ 4).trace
                  - (SpectralActionAvatar.D 2 0 0 0 ^ 4).trace = gM))
          ∧ (∃ bE : ℚ, bE ≠ 0 ∧ bE = UnifiedMassBudget.bE)
          ∧ (∃ g : ℝ, g ≠ 0 ∧ GravitySourceMatter.solderingCurv 1 = g)
          ∧ (∃ gamma : ℝ × ℝ, JacobsonClausius.FieldEq gamma))
      ∧ ((MassPhase4Channel.Ghost 1 2 0 0 ∧ MassPhase4Channel.Massive 1 2 0 2)
          ∧ (MassPhase4Channel.Ghost 1 2 0 0 ∧ MassPhase4Channel.Massive 3 2 0 0)
          ∧ ((∀ lam kap : ℚ, lam ≠ 0 →
                (RGFixedPointStructure.R2 lam kap = (lam, kap) ↔ kap = 0))
            ∧ (∀ lam : ℚ, lam ≠ 0 →
                RGFixedPointStructure.R2 lam lam = (-lam, -lam)
                  ∧ RGFixedPointStructure.R2 (-lam) (-lam) = (lam, lam)
                  ∧ ((-lam, -lam) : ℚ × ℚ) ≠ (lam, lam))
            ∧ (∀ lam kap : ℚ, lam ≠ 0 → kap ≠ 0 → |kap| < |lam| →
                |(RGFixedPointStructure.R2 lam kap).2| = kap ^ 2 / |lam|
                  ∧ |(RGFixedPointStructure.R2 lam kap).2| < |kap|)))
      ∧ (0 < HolographicEdgeBound.edges
          ∧ 0 < Module.finrank ℚ HolographicEdgeBound.Phys
          ∧ Module.finrank ℚ HolographicEdgeBound.Phys ≤ HolographicEdgeBound.edges)
      ∧ ((MinkowskiConvention.eta 0 0 : ℚ) = 1
          ∧ (MinkowskiConvention.eta 1 1 : ℚ) = -1
          ∧ TeleparallelSoldering.curvatureLoop = 1
          ∧ TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0
          ∧ EinsteinHilbertTerm.Rfin EinsteinHilbertTerm.Estar = -2
          ∧ JacobsonClausius.FieldEq ((1 : ℝ), (1 : ℝ))) :=
  ⟨⟨(WEPActionBridge.stationary_iff_fieldEquation G K).mp hstat,
      fun _ => WEPTrace.wep_trace_identity hK⟩,
    UnifiedActionCapstone.finite_unification_nonvacuous,
    MassPhaseRGCapstone.phase_rg_verdict,
    HolographicResourceCapstone.positive_boundary_nonvacuity_bundle,
    GravityUnificationCapstone.finite_gravity_claim_boundary⟩

/-! ## Packet 4 — finite Lambda sequestering / count / frame-blindness -/

/-- **Finite Lambda packet.**  The Lambda sequestering, count/variance, and
frame-blindness branch statements, re-exported from
`LambdaEverpresentCapstone.lambda_everpresent_sequestering_verdict`. -/
theorem finite_lambda_packet :
    LambdaEverpresentCapstone.seqBranchStmt
      ∧ LambdaEverpresentCapstone.countBranchStmt
      ∧ LambdaEverpresentCapstone.frameBranchStmt :=
  LambdaEverpresentCapstone.lambda_everpresent_sequestering_verdict

/-! ## The master verdict -/

/-- **The all-mass master capstone.**  One kernel-checked finite theorem mesh:
the run carries, with explicit witnesses and false-shape guardrails, the finite
CP / family-rank / anomaly packet, the finite particle-information / DOF /
four-faces packet, the finite gravity / resource packet (for any channel-blind
stationary source `(hK, hstat)`), and the finite Lambda packet.

This is a bundle of finite, kernel-checked results.  It makes **no** claim about
measured particle masses, **no** claim of continuum quantum gravity, and **no**
claim about the observed cosmological constant. -/
theorem allmass_master_capstone
    {n : ℕ} {G K : Matrix (Fin n) (Fin n) ℂ} {kappa : ℂ}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hstat : WEPActionBridge.Stationary G K) :
    -- (1) finite CP / family-rank / anomaly
    ((FiniteKM.physicalPhases 2 = 0
        ∧ (∀ V : Matrix (Fin 2) (Fin 2) ℂ, V.conjTranspose * V = 1 →
              ∃ dL dR : Fin 2 → ℂ,
                FiniteKM.IsPhase dL ∧ FiniteKM.IsPhase dR ∧
                  ∀ i j, ((FiniteKM.rephase dL dR V) i j).im = 0)
        ∧ FiniteKM.physicalPhases 3 = 1
        ∧ FiniteKM.Vwitness.conjTranspose * FiniteKM.Vwitness = 1
        ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0)
      ∧ ((FiniteKM.physicalPhases 3 = 1 ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0)
          ∧ (((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) : ℤ)
              - Module.finrank ℂ
                  ((Fin 3 → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac 3 1))
              = (1 : ℤ))
              ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) = 1)
          ∧ ((FiniteKM.physicalPhases 3 : ℤ) - (FiniteKM.physicalPhases 2 : ℤ) = (1 : ℤ))
          ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1))
              = Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac (2 * 3) 1)))
      ∧ (FiniteKM.physicalPhases 2 = 0
          ∧ Module.finrank ℂ (IncidenceCorank.Edge 2 → ℂ)
              - Module.finrank ℂ (LinearMap.range (IncidenceCorank.coboundary ℂ 2)) = 0
          ∧ Module.finrank ℂ
              (LinearMap.ker (LinearMap.id : (Fin 2 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ))) = 0
          ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 2 0)) = 0)) ∧
    -- (2) finite particle information / DOF / four faces
    (((∀ p x : ℚ, MassFourFaces.Slin p x = 2 * MassFourFaces.detR p x)
        ∧ (∀ p : ℚ, MassFourFaces.Hlin p = 2 * MassFourFaces.detR p 0
            ∧ MassFourFaces.Slin p 0 = MassFourFaces.Hlin p)
        ∧ (∀ p q : ℚ, MassFourFaces.TVdiag p q = |p * (1 - q) - (1 - p) * q|)
        ∧ (∀ p : ℚ, MassFourFaces.detR p 0 = 0 ↔ p = 0 ∨ p = 1)
        ∧ (∀ p : ℚ, MassFourFaces.Slin p 0 = 0 ↔ p = 0 ∨ p = 1)
        ∧ (∀ p : ℚ, MassFourFaces.Hlin p = 0 ↔ p = 0 ∨ p = 1)
        ∧ (∀ p q : ℚ, MassFourFaces.TVdiag p q = 0 ↔ p = q))
      ∧ (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
            = 2 * PhotonSingleEdge.mink PhotonSingleEdge.k1 PhotonSingleEdge.k2
          ∧ PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass = 16
          ∧ (0 : ℚ) < PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
          ∧ ((!![(34:ℝ)/25, 12/25; 12/25, 16/25]).PosSemidef
              ∧ (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det = 16/25
              ∧ 0 < (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det
              ∧ (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).rank = 2
              ∧ (!![(34:ℝ)/25, 12/25; 12/25, 16/25])
                  = MasslessEdgeCount.edge ![1, 0] + MasslessEdgeCount.edge ![3/5, 4/5]))
      ∧ ((PhotonSingleEdge.edgesSpin1
              (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 1
            ∧ LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.rho (1 / 2) (1 / 2)) = 0)
          ∧ (PhotonSingleEdge.edgesSpin1
              (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 2
            ∧ 0 < LeanQuantumDPIMass.Slin
                (LeanQuantumDPIMass.Phi 1 (LeanQuantumDPIMass.rho (1 / 2) (1 / 2)))))
      ∧ (0 < TVDistinguishabilityMass.mass (![1, 0] : Fin 2 → ℚ) (![0, 1] : Fin 2 → ℚ)
          ∧ 0 < KraftCompressionMass.Hlin (![1 / 2, 1 / 4, 1 / 4] : Fin 3 → ℚ))) ∧
    -- (3) finite Goal IV / resource / gravity (for the given channel-blind stationary source)
    ((G = K ∧ ∀ rho : Matrix (Fin n) (Fin n) ℂ,
          WEPTrace.Source K rho = kappa * rho.trace)
      ∧ ((∃ gM gG : ℚ, gM ≠ 0 ∧ gG ≠ 0
            ∧ ((SpectralActionAvatar.D 2 1 3 5 ^ 2).trace - 6 = gG)
            ∧ ((SpectralActionAvatar.D 2 1 3 5 ^ 4).trace
                  - (SpectralActionAvatar.D 2 0 0 0 ^ 4).trace = gM))
          ∧ (∃ bE : ℚ, bE ≠ 0 ∧ bE = UnifiedMassBudget.bE)
          ∧ (∃ g : ℝ, g ≠ 0 ∧ GravitySourceMatter.solderingCurv 1 = g)
          ∧ (∃ gamma : ℝ × ℝ, JacobsonClausius.FieldEq gamma))
      ∧ ((MassPhase4Channel.Ghost 1 2 0 0 ∧ MassPhase4Channel.Massive 1 2 0 2)
          ∧ (MassPhase4Channel.Ghost 1 2 0 0 ∧ MassPhase4Channel.Massive 3 2 0 0)
          ∧ ((∀ lam kap : ℚ, lam ≠ 0 →
                (RGFixedPointStructure.R2 lam kap = (lam, kap) ↔ kap = 0))
            ∧ (∀ lam : ℚ, lam ≠ 0 →
                RGFixedPointStructure.R2 lam lam = (-lam, -lam)
                  ∧ RGFixedPointStructure.R2 (-lam) (-lam) = (lam, lam)
                  ∧ ((-lam, -lam) : ℚ × ℚ) ≠ (lam, lam))
            ∧ (∀ lam kap : ℚ, lam ≠ 0 → kap ≠ 0 → |kap| < |lam| →
                |(RGFixedPointStructure.R2 lam kap).2| = kap ^ 2 / |lam|
                  ∧ |(RGFixedPointStructure.R2 lam kap).2| < |kap|)))
      ∧ (0 < HolographicEdgeBound.edges
          ∧ 0 < Module.finrank ℚ HolographicEdgeBound.Phys
          ∧ Module.finrank ℚ HolographicEdgeBound.Phys ≤ HolographicEdgeBound.edges)
      ∧ ((MinkowskiConvention.eta 0 0 : ℚ) = 1
          ∧ (MinkowskiConvention.eta 1 1 : ℚ) = -1
          ∧ TeleparallelSoldering.curvatureLoop = 1
          ∧ TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0
          ∧ EinsteinHilbertTerm.Rfin EinsteinHilbertTerm.Estar = -2
          ∧ JacobsonClausius.FieldEq ((1 : ℝ), (1 : ℝ)))) ∧
    -- (4) finite Lambda sequestering / count / frame-blindness
    (LambdaEverpresentCapstone.seqBranchStmt
      ∧ LambdaEverpresentCapstone.countBranchStmt
      ∧ LambdaEverpresentCapstone.frameBranchStmt) :=
  ⟨finite_cp_family_anomaly_packet,
    finite_particle_information_packet,
    finite_gravity_resource_packet hK hstat,
    finite_lambda_packet⟩

end AllMassMasterCapstone

/-! ## Axiom-footprint guard pins

Every headline theorem depends only on the standard Lean/Mathlib axioms
`propext`, `Classical.choice`, `Quot.sound`. -/

/-- info: 'AllMassMasterCapstone.finite_cp_family_anomaly_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms AllMassMasterCapstone.finite_cp_family_anomaly_packet

/-- info: 'AllMassMasterCapstone.finite_particle_information_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms AllMassMasterCapstone.finite_particle_information_packet

/-- info: 'AllMassMasterCapstone.finite_gravity_resource_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms AllMassMasterCapstone.finite_gravity_resource_packet

/-- info: 'AllMassMasterCapstone.finite_lambda_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms AllMassMasterCapstone.finite_lambda_packet

/-- info: 'AllMassMasterCapstone.allmass_master_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms AllMassMasterCapstone.allmass_master_capstone
