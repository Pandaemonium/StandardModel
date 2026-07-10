/-
# Carrier dynamics / RG / information capstone (finite lane)

DRAFT (kernel-clean). This module is the top composition capstone tying together
three already-kernelized lanes of the finite null-edge program:

* the **finite dynamics** lane (D1 finite action ⇒ Euler equations, D2/D3
  unitary/Krein transfer ⇒ conserved finite evolution, D4 finite RG ⇒ propagated
  one-step invariants, D5 finite canonical ensemble ⇒ normalized probabilities),
  bundled in
  `PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone.carrier_dynamics_capstone`;

* the **finite mass-phase / RG** lane, bundled in `MassPhaseRGCapstone`
  (`phase_rg_verdict`, `exact_rg_capstone`);

* the **finite information / resource / thermodynamics** lane, bundled in
  `InformationResourceBridge.information_resource_bridge`, `MassThermo`, and
  `ModularSelection`.

The module introduces no new mathematics: it re-exports the imported headlines as
three packet theorems and one capstone conjunction, so downstream work can cite a
single statement for the whole finite dynamics / RG / information program.

**Semantic caveat (read before citing).** Every statement below is a theorem of
*finite* linear algebra / finite probability / rational arithmetic. This is a
finite dynamics layer, **not** a continuum field theory: there is no spacetime,
no field measure, no thermodynamic or continuum limit, and no derivation of a
physical Hamiltonian or QCD statement. The "energy", "temperature", "phase", and
"information" naming is decorative avatar language for the finite constructions.
PhysLean's variational-calculus, classical-mechanics, RG, and canonical-ensemble
APIs were consulted only as clean-room shape references; there is no PhysLean
build dependency.
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone
import PhysicsSM.Draft.NullEdge.MassPhaseRGCapstone
import PhysicsSM.Draft.NullEdge.InformationResourceBridge
import PhysicsSM.Draft.NullEdge.ParticleInformationCapstone
import PhysicsSM.Draft.NullEdge.MassThermodynamics
import PhysicsSM.Draft.NullEdge.ModularSelection
import PhysicsSM.Draft.NullEdge.LeanQuantumDPIMass
import PhysicsSM.Draft.NullEdge.KraftCompressionMass

namespace CarrierDynamicsRGInformationCapstone

open Matrix Complex Topology
open PhysicsSM.Draft.NullEdge.Carrier

/-! ## Packet 1 — finite dynamics + finite RG structure

`dynamics_rg_packet` bundles the finite dynamics capstone (D1–D5) with the finite
mass-phase / RG headlines. The first conjunct is the full
`carrier_dynamics_capstone` conclusion; the second and third are the phase / RG
verdicts. -/

/-- **Dynamics / RG packet.**  The finite dynamics capstone (D1 finite
action/EOM, D2/D3 conserved finite evolution, D4 finite RG invariant
propagation, D5 finite canonical normalization) together with the finite
mass-phase verdict and the exact-RG capstone.

This is a composition theorem, not new mathematics.  See the module docstring for
the standing finite-scope caveat. -/
theorem dynamics_rg_packet
    {V W : Type*} [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    [NormedAddCommGroup W] [InnerProductSpace ℂ W]
    [CompleteSpace V] [CompleteSpace W]
    (D : V →L[ℂ] W) (psi : V) (chi : W)
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]
    (A : H →L[ℂ] H) (hA : IsSelfAdjoint A)
    (U : H ≃ₗᵢ[ℂ] H) (hUA : FiniteQuadraticAction.CommutesWithSymmetry U A)
    {K : Type*} [NormedAddCommGroup K] [InnerProductSpace ℂ K]
    {State Value : Type*}
    {PVal : Type*} [Preorder PVal]
    {α : Type*} [Fintype α] [Nonempty α] :
    -- D1–D5: the finite dynamics capstone
    (((FiniteCarrierAction.stationaryPair D psi chi
            ↔ D psi = 0 ∧ ContinuousLinearMap.adjoint D chi = 0) ∧
        (∀ w : H, FiniteQuadraticAction.quadraticStationary A w ↔ A w = 0) ∧
        (∀ (m2 : ℝ) (w : H),
            FiniteQuadraticAction.massShellStationary A m2 w ↔ A w = (m2 : ℂ) • w) ∧
        (∀ (m2 : ℝ) (w : H),
            A w = (m2 : ℂ) • w → A (U w) = (m2 : ℂ) • U w)) ∧
      ((∀ (U' : K ≃ₗᵢ[ℂ] K) (v : K) (n : ℕ),
            ‖FiniteUnitaryEvolution.orbit U' v n‖ = ‖v‖) ∧
        (∀ (U' : K ≃ₗᵢ[ℂ] K) (E : K →L[ℂ] K),
            FiniteUnitaryEvolution.CommutesWithStep U' E → ∀ (v : K) (n : ℕ),
            FiniteUnitaryEvolution.observableEnergy E (FiniteUnitaryEvolution.orbit U' v n)
              = FiniteUnitaryEvolution.observableEnergy E v) ∧
        (∀ lam kappa t : ℝ,
            NormedSpace.exp ((-(t : ℂ)) • (Complex.I • MassGapWitness.B lam kappa))
              ∈ Matrix.unitaryGroup (Fin 3) ℂ) ∧
        (∀ (lam kappa t : ℝ) (v : EuclideanSpace ℂ (Fin 3)) (n : ℕ),
            ‖FiniteUnitaryEvolution.orbit
                (CarrierUnitaryFlow.carrierFlowStep lam kappa t) v n‖ = ‖v‖) ∧
        (∀ (lam kappa t : ℝ)
            (E : EuclideanSpace ℂ (Fin 3) →L[ℂ] EuclideanSpace ℂ (Fin 3)),
            FiniteUnitaryEvolution.CommutesWithStep
                (CarrierUnitaryFlow.carrierFlowStep lam kappa t) E →
            ∀ (v : EuclideanSpace ℂ (Fin 3)) (n : ℕ),
            FiniteUnitaryEvolution.observableEnergy E
                (FiniteUnitaryEvolution.orbit
                  (CarrierUnitaryFlow.carrierFlowStep lam kappa t) v n)
              = FiniteUnitaryEvolution.observableEnergy E v) ∧
        (∀ t : ℝ,
            (NormedSpace.exp ((-(t : ℂ)) • (Complex.I • SectorGroundMassWitness.HAC)))ᴴ
                * SectorGroundMassWitness.Jmet
                * (NormedSpace.exp ((-(t : ℂ)) • (Complex.I • SectorGroundMassWitness.HAC)))
              = SectorGroundMassWitness.Jmet)) ∧
      ((∀ (step : State → State) (P : State → Prop),
            FiniteRGFlow.StepPreserves step P → ∀ (x : State), P x → ∀ n : ℕ,
            P (FiniteRGFlow.orbit step x n)) ∧
        (∀ (step : State → State) (obs : State → Value),
            FiniteRGFlow.ObservableInvariant step obs → ∀ (x : State) (n : ℕ),
            obs (FiniteRGFlow.orbit step x n) = obs x) ∧
        (∀ (step : State → State) (obs : State → PVal),
            FiniteRGFlow.ObservableAntitone step obs → ∀ (x : State) (n : ℕ),
            obs (FiniteRGFlow.orbit step x n) ≤ obs x) ∧
        (∀ (beta : ℝ) (energy : α → ℝ),
            ∑ i : α, FiniteCanonicalEnsemble.probability beta energy i = 1) ∧
        (∀ (beta : ℝ) (energy : α → ℝ),
            0 ≤ FiniteCanonicalEnsemble.energyVariance beta energy))) ∧
    -- finite mass-phase verdict
    ((MassPhase4Channel.Ghost 1 2 0 0 ∧ MassPhase4Channel.Massive 1 2 0 2)
        ∧ (MassPhase4Channel.Ghost 1 2 0 0 ∧ MassPhase4Channel.Massive 3 2 0 0)
        ∧ ((∀ lam kap : ℚ, lam ≠ 0 →
              (RGFixedPointStructure.R2 lam kap = (lam, kap) ↔ kap = 0))
          ∧ (∀ lam : ℚ, lam ≠ 0 →
              RGFixedPointStructure.R2 lam lam = (-lam, -lam)
                ∧ RGFixedPointStructure.R2 (-lam) (-lam) = (lam, lam)
                ∧ ((-lam, -lam) : ℚ × ℚ) ≠ (lam, lam))
          ∧ (∀ lam kap : ℚ, lam ≠ 0 → kap ≠ 0 → |kap| < |lam| →
              |(RGFixedPointStructure.R2 lam kap).2| = kap ^ 2 / |lam|
                ∧ |(RGFixedPointStructure.R2 lam kap).2| < |kap|))) ∧
    -- exact-RG capstone
    (((∀ lam kap : ℚ, lam ≠ 0 → |kap| = |lam| →
          |Goal3ExactRG.Rkap lam kap| = |Goal3ExactRG.Rlam lam kap|
            ∧ Goal3ExactRG.R (lam, kap) = (-lam, -lam))
        ∧ Goal3ExactRG.R (1, 1 / 2) = (1 / 2, -1 / 4)
        ∧ Goal3ExactRG.R (1, 1 / 2) ≠ (1, 1 / 2))
        ∧ (Goal3ExactRG.Jac.mulVec ![4, 1] = (2 : ℝ) • ![4, 1]
            ∧ Goal3ExactRG.Jac.mulVec ![1, 1] = (-1 : ℝ) • ![1, 1]
            ∧ Goal3ExactRG.Jac.trace = 1
            ∧ Goal3ExactRG.Jac.det = -2
            ∧ Real.logb 2 2 = 1)
        ∧ (Goal3ChannelRG4.classify Goal3ChannelRG4.solderingEigenvalue
              = Goal3ChannelRG4.RGClass.relevant
            ∧ 1 < |Goal3ChannelRG4.solderingEigenvalue|)) :=
  ⟨CarrierDynamicsCapstone.carrier_dynamics_capstone D psi chi A hA U hUA,
    MassPhaseRGCapstone.phase_rg_verdict,
    MassPhaseRGCapstone.exact_rg_capstone⟩

/-! ## Packet 2 — finite information / resource / thermodynamics

`information_thermo_packet` bundles the finite information / resource bridge
(particle-information avatars, compression / DPI / distinguishability, and the
resource guardrails) with the finite mass-thermodynamics budget and critical
divergence, and the finite modular-selection equipartition / kill headlines. -/

/-- **Information / thermodynamics packet.**  The finite information / resource
bridge, the finite mass-thermodynamics budget and critical-divergence
susceptibility, and the finite modular-selection equipartition criterion and
Conjecture-J kill.

This is a composition theorem, not new mathematics.  See the module docstring for
the standing finite-scope caveat. -/
theorem information_thermo_packet :
    -- finite information / resource bridge
    (InformationResourceBridge.ParticleInfoPacketProp ∧
        InformationResourceBridge.CompressionDPIDistinguishabilityPacketProp ∧
        InformationResourceBridge.ResourceGuardrailPacketProp) ∧
    -- finite mass-thermodynamics: channel-share budget identity
    (∀ l k : ℝ, MassThermo.bA l k + MassThermo.bC l k + MassThermo.bT l k = 1) ∧
    -- finite mass-thermodynamics: closure susceptibility diverges on the critical line
    (∀ l : ℝ, 0 < l →
        Filter.Tendsto (fun k => deriv (fun k => MassThermo.bC l k) k)
          (𝓝[≠] l) Filter.atTop) ∧
    -- finite modular selection: equipartition ⇔ GGE generator is a shifted `B`
    (∀ lA lC lT lE : ℂ,
        (∃ ν d : ℂ, ModularSelection.ggeGen lA lC lT lE
            = ν • ModularSelection.Bsum + d • (1 : Matrix (Fin 5) (Fin 5) ℂ))
          ↔ (lA = lC ∧ lC = lT ∧ lT = lE)) ∧
    -- finite modular selection: Conjecture-J kill on genuinely distinct channels
    (¬ ∃ ν d : ℂ, ModularSelection.ggeGen 1 2 3 4
        = ν • ModularSelection.Bsum + d • (1 : Matrix (Fin 5) (Fin 5) ℂ)) :=
  ⟨InformationResourceBridge.information_resource_bridge,
    MassThermo.budget,
    MassThermo.critical_divergence,
    ModularSelection.equipartition_generator,
    ModularSelection.conjectureJ_kill⟩

/-! ## Capstone: the whole finite dynamics / RG / information program -/

/-- **Carrier dynamics / RG / information capstone (finite lane).**  One
conjunction gathering the two packets: the finite dynamics + RG structure
(`dynamics_rg_packet`) and the finite information / resource / thermodynamics
structure (`information_thermo_packet`).

This is a composition theorem, not new mathematics.  See the module docstring for
the standing semantic caveat: this is a *finite* dynamics / RG / information
layer, not a continuum field theory. -/
theorem carrier_dynamics_rg_information_capstone
    {V W : Type*} [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    [NormedAddCommGroup W] [InnerProductSpace ℂ W]
    [CompleteSpace V] [CompleteSpace W]
    (D : V →L[ℂ] W) (psi : V) (chi : W)
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]
    (A : H →L[ℂ] H) (hA : IsSelfAdjoint A)
    (U : H ≃ₗᵢ[ℂ] H) (hUA : FiniteQuadraticAction.CommutesWithSymmetry U A)
    {K : Type*} [NormedAddCommGroup K] [InnerProductSpace ℂ K]
    {State Value : Type*}
    {PVal : Type*} [Preorder PVal]
    {α : Type*} [Fintype α] [Nonempty α] :
    -- Packet 1: finite dynamics + finite RG structure
    ((((FiniteCarrierAction.stationaryPair D psi chi
            ↔ D psi = 0 ∧ ContinuousLinearMap.adjoint D chi = 0) ∧
        (∀ w : H, FiniteQuadraticAction.quadraticStationary A w ↔ A w = 0) ∧
        (∀ (m2 : ℝ) (w : H),
            FiniteQuadraticAction.massShellStationary A m2 w ↔ A w = (m2 : ℂ) • w) ∧
        (∀ (m2 : ℝ) (w : H),
            A w = (m2 : ℂ) • w → A (U w) = (m2 : ℂ) • U w)) ∧
      ((∀ (U' : K ≃ₗᵢ[ℂ] K) (v : K) (n : ℕ),
            ‖FiniteUnitaryEvolution.orbit U' v n‖ = ‖v‖) ∧
        (∀ (U' : K ≃ₗᵢ[ℂ] K) (E : K →L[ℂ] K),
            FiniteUnitaryEvolution.CommutesWithStep U' E → ∀ (v : K) (n : ℕ),
            FiniteUnitaryEvolution.observableEnergy E (FiniteUnitaryEvolution.orbit U' v n)
              = FiniteUnitaryEvolution.observableEnergy E v) ∧
        (∀ lam kappa t : ℝ,
            NormedSpace.exp ((-(t : ℂ)) • (Complex.I • MassGapWitness.B lam kappa))
              ∈ Matrix.unitaryGroup (Fin 3) ℂ) ∧
        (∀ (lam kappa t : ℝ) (v : EuclideanSpace ℂ (Fin 3)) (n : ℕ),
            ‖FiniteUnitaryEvolution.orbit
                (CarrierUnitaryFlow.carrierFlowStep lam kappa t) v n‖ = ‖v‖) ∧
        (∀ (lam kappa t : ℝ)
            (E : EuclideanSpace ℂ (Fin 3) →L[ℂ] EuclideanSpace ℂ (Fin 3)),
            FiniteUnitaryEvolution.CommutesWithStep
                (CarrierUnitaryFlow.carrierFlowStep lam kappa t) E →
            ∀ (v : EuclideanSpace ℂ (Fin 3)) (n : ℕ),
            FiniteUnitaryEvolution.observableEnergy E
                (FiniteUnitaryEvolution.orbit
                  (CarrierUnitaryFlow.carrierFlowStep lam kappa t) v n)
              = FiniteUnitaryEvolution.observableEnergy E v) ∧
        (∀ t : ℝ,
            (NormedSpace.exp ((-(t : ℂ)) • (Complex.I • SectorGroundMassWitness.HAC)))ᴴ
                * SectorGroundMassWitness.Jmet
                * (NormedSpace.exp ((-(t : ℂ)) • (Complex.I • SectorGroundMassWitness.HAC)))
              = SectorGroundMassWitness.Jmet)) ∧
      ((∀ (step : State → State) (P : State → Prop),
            FiniteRGFlow.StepPreserves step P → ∀ (x : State), P x → ∀ n : ℕ,
            P (FiniteRGFlow.orbit step x n)) ∧
        (∀ (step : State → State) (obs : State → Value),
            FiniteRGFlow.ObservableInvariant step obs → ∀ (x : State) (n : ℕ),
            obs (FiniteRGFlow.orbit step x n) = obs x) ∧
        (∀ (step : State → State) (obs : State → PVal),
            FiniteRGFlow.ObservableAntitone step obs → ∀ (x : State) (n : ℕ),
            obs (FiniteRGFlow.orbit step x n) ≤ obs x) ∧
        (∀ (beta : ℝ) (energy : α → ℝ),
            ∑ i : α, FiniteCanonicalEnsemble.probability beta energy i = 1) ∧
        (∀ (beta : ℝ) (energy : α → ℝ),
            0 ≤ FiniteCanonicalEnsemble.energyVariance beta energy))) ∧
    ((MassPhase4Channel.Ghost 1 2 0 0 ∧ MassPhase4Channel.Massive 1 2 0 2)
        ∧ (MassPhase4Channel.Ghost 1 2 0 0 ∧ MassPhase4Channel.Massive 3 2 0 0)
        ∧ ((∀ lam kap : ℚ, lam ≠ 0 →
              (RGFixedPointStructure.R2 lam kap = (lam, kap) ↔ kap = 0))
          ∧ (∀ lam : ℚ, lam ≠ 0 →
              RGFixedPointStructure.R2 lam lam = (-lam, -lam)
                ∧ RGFixedPointStructure.R2 (-lam) (-lam) = (lam, lam)
                ∧ ((-lam, -lam) : ℚ × ℚ) ≠ (lam, lam))
          ∧ (∀ lam kap : ℚ, lam ≠ 0 → kap ≠ 0 → |kap| < |lam| →
              |(RGFixedPointStructure.R2 lam kap).2| = kap ^ 2 / |lam|
                ∧ |(RGFixedPointStructure.R2 lam kap).2| < |kap|))) ∧
    (((∀ lam kap : ℚ, lam ≠ 0 → |kap| = |lam| →
          |Goal3ExactRG.Rkap lam kap| = |Goal3ExactRG.Rlam lam kap|
            ∧ Goal3ExactRG.R (lam, kap) = (-lam, -lam))
        ∧ Goal3ExactRG.R (1, 1 / 2) = (1 / 2, -1 / 4)
        ∧ Goal3ExactRG.R (1, 1 / 2) ≠ (1, 1 / 2))
        ∧ (Goal3ExactRG.Jac.mulVec ![4, 1] = (2 : ℝ) • ![4, 1]
            ∧ Goal3ExactRG.Jac.mulVec ![1, 1] = (-1 : ℝ) • ![1, 1]
            ∧ Goal3ExactRG.Jac.trace = 1
            ∧ Goal3ExactRG.Jac.det = -2
            ∧ Real.logb 2 2 = 1)
        ∧ (Goal3ChannelRG4.classify Goal3ChannelRG4.solderingEigenvalue
              = Goal3ChannelRG4.RGClass.relevant
            ∧ 1 < |Goal3ChannelRG4.solderingEigenvalue|))) ∧
    -- Packet 2: finite information / resource / thermodynamics
    ((InformationResourceBridge.ParticleInfoPacketProp ∧
          InformationResourceBridge.CompressionDPIDistinguishabilityPacketProp ∧
          InformationResourceBridge.ResourceGuardrailPacketProp) ∧
      (∀ l k : ℝ, MassThermo.bA l k + MassThermo.bC l k + MassThermo.bT l k = 1) ∧
      (∀ l : ℝ, 0 < l →
          Filter.Tendsto (fun k => deriv (fun k => MassThermo.bC l k) k)
            (𝓝[≠] l) Filter.atTop) ∧
      (∀ lA lC lT lE : ℂ,
          (∃ ν d : ℂ, ModularSelection.ggeGen lA lC lT lE
              = ν • ModularSelection.Bsum + d • (1 : Matrix (Fin 5) (Fin 5) ℂ))
            ↔ (lA = lC ∧ lC = lT ∧ lT = lE)) ∧
      (¬ ∃ ν d : ℂ, ModularSelection.ggeGen 1 2 3 4
          = ν • ModularSelection.Bsum + d • (1 : Matrix (Fin 5) (Fin 5) ℂ))) :=
  ⟨dynamics_rg_packet D psi chi A hA U hUA, information_thermo_packet⟩

/-! ## Guard pins for every headline -/

/-- info: 'CarrierDynamicsRGInformationCapstone.dynamics_rg_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dynamics_rg_packet

/-- info: 'CarrierDynamicsRGInformationCapstone.information_thermo_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms information_thermo_packet

/-- info: 'CarrierDynamicsRGInformationCapstone.carrier_dynamics_rg_information_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms carrier_dynamics_rg_information_capstone

end CarrierDynamicsRGInformationCapstone
