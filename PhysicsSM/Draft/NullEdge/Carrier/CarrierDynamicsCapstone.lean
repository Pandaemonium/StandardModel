/-
# Carrier dynamics capstone (finite lane)

DRAFT (kernel-clean). This module is the composition capstone for the null-edge
carrier *dynamics* lane. It does not introduce new mathematics: it bundles the
already-kernelized D1–D5 dynamics bricks into four "packet" theorems and a single
capstone conjunction, so downstream simulations can cite one statement for the
whole finite dynamics layer.

The four ingredients, honestly named:

* **D1 (finite action ⇒ Euler equations).** The finite multiplier action's
  stationary pairs are exactly primal/adjoint carrier solutions
  (`FiniteCarrierAction.stationaryPair_iff_eom_pair`); the finite quadratic
  action's stationary points are the operator kernel
  (`FiniteQuadraticAction.quadraticStationary_iff_eom`); the constrained
  mass-shell action's stationarity is the eigen/mass-shell equation
  (`FiniteQuadraticAction.massShellStationary_iff_eigen`); and a unitary symmetry
  commuting with the operator transports mass-shell solutions
  (`FiniteQuadraticAction.massShell_equation_symmetry`).

* **D2/D3 (unitary/Krein transfer ⇒ conserved quantities).** A finite
  isometry/transfer step conserves norm and commuting-observable expectation
  along the whole discrete orbit (`FiniteUnitaryEvolution.norm_conserved_orbit`,
  `FiniteUnitaryEvolution.energy_conserved_orbit`); the concrete mass-block flow
  `exp(-i t B)` is Euclidean-unitary and fires these on the carrier step
  (`CarrierUnitaryFlow.B_flow_unitary`,
  `CarrierUnitaryFlow.carrier_orbit_norm_conserved`,
  `CarrierUnitaryFlow.carrier_orbit_energy_conserved`); and the `12×12` carrier
  generator flow `exp(-i t HAC)` is `Jmet`-unitary
  (`CarrierKreinFlow.HAC_flow_Jmet_unitary`).

* **D4 (finite RG ⇒ propagated one-step invariants).** One-step invariants,
  conserved observables, and antitone observables all propagate along every
  iterate of a finite blocking step (`FiniteRGFlow.invariant_orbit`,
  `FiniteRGFlow.observable_invariant_orbit`,
  `FiniteRGFlow.observable_antitone_orbit`).

* **D5 (finite canonical ensemble ⇒ normalized probabilities).** The finite
  Boltzmann probabilities sum to one and the energy variance is nonnegative
  (`FiniteCanonicalEnsemble.sum_probability_eq_one`,
  `FiniteCanonicalEnsemble.energyVariance_nonneg`).

**Semantic caveat (read before citing).** Every statement below is a theorem of
*finite* linear algebra / finite probability. This is a finite dynamics layer,
**not** a continuum field theory: there is no spacetime, no field measure, no
thermodynamic/continuum limit, and no derivation of a physical Hamiltonian or QCD
statement. The "energy" naming on commuting observables is decorative, the
mass-block flow is Euclidean-unitary (its certified *Krein* form appears only in
`HAC_flow_Jmet_unitary`), and the carrier tie is kernel-checked at the fixed
point `(λ,κ) = (2,1)` and oracle-grade off it. PhysLean's variational-calculus,
classical-mechanics, RG, and canonical-ensemble APIs were consulted only as
clean-room shape references; there is no PhysLean build dependency.
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction
import PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction
import PhysicsSM.Draft.NullEdge.Carrier.FiniteUnitaryEvolution
import PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow
import PhysicsSM.Draft.NullEdge.Carrier.CarrierKreinFlow
import PhysicsSM.Draft.NullEdge.Carrier.FiniteRGFlow
import PhysicsSM.Draft.NullEdge.Carrier.FiniteCanonicalEnsemble
import PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness

namespace PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone

open Matrix Complex

/-! ## D1 packet: finite action principles give Euler equations -/

/-- **D1 packet.** The finite action/EOM layer, as one conjunction:

1. finite multiplier action stationary pairs `↔` primal/adjoint carrier solutions;
2. finite quadratic action stationarity `↔` `A w = 0`;
3. finite mass-shell action stationarity `↔` the eigen equation `A w = m² w`;
4. a unitary symmetry commuting with `A` transports mass-shell solutions. -/
theorem finite_action_eom_packet
    {V W : Type*} [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    [NormedAddCommGroup W] [InnerProductSpace ℂ W]
    [CompleteSpace V] [CompleteSpace W]
    (D : V →L[ℂ] W) (psi : V) (chi : W)
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]
    (A : H →L[ℂ] H) (hA : IsSelfAdjoint A)
    (U : H ≃ₗᵢ[ℂ] H) (hUA : FiniteQuadraticAction.CommutesWithSymmetry U A) :
    (FiniteCarrierAction.stationaryPair D psi chi
        ↔ D psi = 0 ∧ ContinuousLinearMap.adjoint D chi = 0) ∧
    (∀ w : H, FiniteQuadraticAction.quadraticStationary A w ↔ A w = 0) ∧
    (∀ (m2 : ℝ) (w : H),
        FiniteQuadraticAction.massShellStationary A m2 w ↔ A w = (m2 : ℂ) • w) ∧
    (∀ (m2 : ℝ) (w : H),
        A w = (m2 : ℂ) • w → A (U w) = (m2 : ℂ) • U w) :=
  ⟨FiniteCarrierAction.stationaryPair_iff_eom_pair D psi chi,
   fun w => FiniteQuadraticAction.quadraticStationary_iff_eom A hA w,
   fun m2 w => FiniteQuadraticAction.massShellStationary_iff_eigen A m2 w,
   fun m2 _w hpsi => FiniteQuadraticAction.massShell_equation_symmetry U A m2 hUA hpsi⟩

/-! ## D2/D3 packet: unitary/Krein transfer gives conserved quantities -/

/-- **D2/D3 packet.** The finite conservation layer, as one conjunction:

1. finite isometry orbits conserve norm;
2. commuting observables have conserved expectation along the orbit;
3. the mass-block flow `exp(-i t B)` is Euclidean-unitary;
4. the concrete carrier orbit conserves the sector norm;
5. the concrete carrier orbit conserves commuting-observable expectation;
6. the `12×12` carrier generator flow `exp(-i t HAC)` is `Jmet`-unitary. -/
theorem finite_transfer_conservation_packet
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] :
    (∀ (U : H ≃ₗᵢ[ℂ] H) (psi : H) (n : ℕ),
        ‖FiniteUnitaryEvolution.orbit U psi n‖ = ‖psi‖) ∧
    (∀ (U : H ≃ₗᵢ[ℂ] H) (E : H →L[ℂ] H),
        FiniteUnitaryEvolution.CommutesWithStep U E → ∀ (psi : H) (n : ℕ),
        FiniteUnitaryEvolution.observableEnergy E (FiniteUnitaryEvolution.orbit U psi n)
          = FiniteUnitaryEvolution.observableEnergy E psi) ∧
    (∀ lam kappa t : ℝ,
        NormedSpace.exp ((-(t : ℂ)) • (Complex.I • MassGapWitness.B lam kappa))
          ∈ Matrix.unitaryGroup (Fin 3) ℂ) ∧
    (∀ (lam kappa t : ℝ) (psi : EuclideanSpace ℂ (Fin 3)) (n : ℕ),
        ‖FiniteUnitaryEvolution.orbit (CarrierUnitaryFlow.carrierFlowStep lam kappa t) psi n‖
          = ‖psi‖) ∧
    (∀ (lam kappa t : ℝ)
        (E : EuclideanSpace ℂ (Fin 3) →L[ℂ] EuclideanSpace ℂ (Fin 3)),
        FiniteUnitaryEvolution.CommutesWithStep
            (CarrierUnitaryFlow.carrierFlowStep lam kappa t) E →
        ∀ (psi : EuclideanSpace ℂ (Fin 3)) (n : ℕ),
        FiniteUnitaryEvolution.observableEnergy E
            (FiniteUnitaryEvolution.orbit
              (CarrierUnitaryFlow.carrierFlowStep lam kappa t) psi n)
          = FiniteUnitaryEvolution.observableEnergy E psi) ∧
    (∀ t : ℝ,
        (NormedSpace.exp ((-(t : ℂ)) • (Complex.I • SectorGroundMassWitness.HAC)))ᴴ
            * SectorGroundMassWitness.Jmet
            * (NormedSpace.exp ((-(t : ℂ)) • (Complex.I • SectorGroundMassWitness.HAC)))
          = SectorGroundMassWitness.Jmet) :=
  ⟨fun U psi n => FiniteUnitaryEvolution.norm_conserved_orbit U psi n,
   fun U E hUE psi n => FiniteUnitaryEvolution.energy_conserved_orbit U E hUE psi n,
   fun lam kappa t => CarrierUnitaryFlow.B_flow_unitary lam kappa t,
   fun lam kappa t psi n =>
     CarrierUnitaryFlow.carrier_orbit_norm_conserved lam kappa t psi n,
   fun lam kappa t E hUE psi n =>
     CarrierUnitaryFlow.carrier_orbit_energy_conserved lam kappa t E hUE psi n,
   fun t => CarrierKreinFlow.HAC_flow_Jmet_unitary t⟩

/-! ## D4/D5 packet: finite RG propagation and canonical normalization -/

/-- **D4/D5 packet.** The finite RG and canonical-ensemble layer, as one
conjunction:

1. one-step invariants propagate along the finite RG orbit;
2. one-step conserved observables propagate along the finite RG orbit;
3. one-step antitone observables stay bounded along the finite RG orbit;
4. the finite canonical probabilities sum to one;
5. the finite canonical energy variance is nonnegative. -/
theorem finite_rg_ensemble_packet
    {State Value : Type*}
    {PVal : Type*} [Preorder PVal]
    {α : Type*} [Fintype α] [Nonempty α] :
    (∀ (step : State → State) (P : State → Prop),
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
        0 ≤ FiniteCanonicalEnsemble.energyVariance beta energy) :=
  ⟨fun step P hstep _ hx n => FiniteRGFlow.invariant_orbit step P hstep hx n,
   fun step obs hobs x n => FiniteRGFlow.observable_invariant_orbit step obs hobs x n,
   fun step obs hobs x n => FiniteRGFlow.observable_antitone_orbit step obs hobs x n,
   fun beta energy => FiniteCanonicalEnsemble.sum_probability_eq_one beta energy,
   fun beta energy => FiniteCanonicalEnsemble.energyVariance_nonneg beta energy⟩

/-! ## Capstone: the whole finite dynamics layer in one statement -/

/-- **Carrier dynamics capstone (finite lane).** One conjunction gathering the
three packets: finite action principles give Euler equations (D1), unitary/Krein
transfer gives conserved quantities (D2/D3), and finite RG propagates one-step
invariants while finite canonical probabilities normalize (D4/D5).

This is a composition theorem, not new mathematics. See the module docstring for
the standing semantic caveat: this is a *finite* dynamics layer, not a continuum
field theory. -/
theorem carrier_dynamics_capstone
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
    -- D1: finite action principles give Euler equations
    ((FiniteCarrierAction.stationaryPair D psi chi
          ↔ D psi = 0 ∧ ContinuousLinearMap.adjoint D chi = 0) ∧
      (∀ w : H, FiniteQuadraticAction.quadraticStationary A w ↔ A w = 0) ∧
      (∀ (m2 : ℝ) (w : H),
          FiniteQuadraticAction.massShellStationary A m2 w ↔ A w = (m2 : ℂ) • w) ∧
      (∀ (m2 : ℝ) (w : H),
          A w = (m2 : ℂ) • w → A (U w) = (m2 : ℂ) • U w)) ∧
    -- D2/D3: unitary/Krein transfer gives conserved quantities
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
    -- D4/D5: finite RG propagation and canonical normalization
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
          0 ≤ FiniteCanonicalEnsemble.energyVariance beta energy)) :=
  ⟨finite_action_eom_packet D psi chi A hA U hUA,
   finite_transfer_conservation_packet,
   finite_rg_ensemble_packet⟩

/-! ## Guard pins for every headline -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone.finite_action_eom_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finite_action_eom_packet

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone.finite_transfer_conservation_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finite_transfer_conservation_packet

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone.finite_rg_ensemble_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finite_rg_ensemble_packet

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone.carrier_dynamics_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms carrier_dynamics_capstone

end PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone
