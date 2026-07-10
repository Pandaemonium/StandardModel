/-
# Finite dynamics Noether/thermo capstone

DRAFT (kernel-clean). This module pushes the null-edge carrier *dynamics* lane one
level beyond `Carrier.CarrierDynamicsCapstone`: it repackages the already
kernel-checked finite action / EOM / conservation / RG / ensemble bricks into two
sharper "Noether/thermo" packets and a single capstone that conjoins the generic
facts with the concrete carrier-flow facts.

The genuinely new organizing idea (vs. the earlier capstone) is the **finite
Noether link**: the *same* unitary symmetry `U` that commutes with the operator
`A` simultaneously

* transports mass-shell solutions to mass-shell solutions with the same mass
  (`FiniteQuadraticAction.massShell_equation_symmetry`), and
* conserves the real `A`-expectation `Re ⟨ψ, A ψ⟩` along its entire discrete orbit
  (`FiniteUnitaryEvolution.energy_conserved_orbit`, applicable because
  `CommutesWithSymmetry U A` and `CommutesWithStep U A` are the same predicate).

So a single commutation hypothesis feeds both the symmetry side (Noether) and the
conservation side. That link is bundled in `action_symmetry_conservation_packet`.
`rg_ensemble_packet` bundles the finite RG propagation and finite canonical
ensemble facts, and `finite_dynamics_noether_thermo_capstone` conjoins both with
the concrete mass-block / sector-form carrier flow facts.

**Semantic caveat (read before citing).** Every statement below is a theorem of
*finite* linear algebra / finite probability. This is a finite dynamics layer,
**not** a continuum field theory: there is no spacetime, no field measure, no
thermodynamic/continuum limit, no continuum Noether theorem, and no derivation of
a physical Hamiltonian or QCD statement. The "energy" naming on commuting
observables is decorative, the mass-block flow is Euclidean-unitary, and the
carrier tie is kernel-checked at the fixed point `(λ,κ) = (2,1)` and oracle-grade
off it. PhysLean's variational-calculus, classical-mechanics, RG, and
canonical-ensemble APIs were consulted only as clean-room shape references; there
is no PhysLean build dependency.
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction
import PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction
import PhysicsSM.Draft.NullEdge.Carrier.FiniteUnitaryEvolution
import PhysicsSM.Draft.NullEdge.Carrier.FiniteRGFlow
import PhysicsSM.Draft.NullEdge.Carrier.FiniteCanonicalEnsemble
import PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow
import PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone

namespace PhysicsSM.Draft.NullEdge.FiniteDynamicsNoetherThermoCapstone

open PhysicsSM.Draft.NullEdge.Carrier
open Matrix Complex

/-! ## Noether packet: action principles + symmetry + conservation -/

/-- **Finite Noether packet.** For a finite carrier operator `D`, a self-adjoint
finite operator `A`, and a unitary symmetry `U` commuting with `A`, one
conjunction records:

1. finite multiplier action stationary pairs `↔` primal/adjoint carrier solutions;
2. finite quadratic action stationarity `↔` `A w = 0`;
3. finite mass-shell action stationarity `↔` the eigen equation `A w = m² w`;
4. the symmetry `U` transports mass-shell solutions to mass-shell solutions of the
   same mass (symmetry side of Noether);
5. the symmetry flow conserves the carrier norm along its whole discrete orbit;
6. the symmetry flow conserves the real `A`-expectation along its whole discrete
   orbit (conservation side of Noether — driven by the *same* commutation
   hypothesis `hUA`).

Points 4 and 6 are the finite Noether link: a single commutation hypothesis both
transports solutions and produces a conserved expectation. -/
theorem action_symmetry_conservation_packet
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
        A w = (m2 : ℂ) • w → A (U w) = (m2 : ℂ) • U w) ∧
    (∀ (w : H) (n : ℕ),
        ‖FiniteUnitaryEvolution.orbit U w n‖ = ‖w‖) ∧
    (∀ (w : H) (n : ℕ),
        FiniteUnitaryEvolution.observableEnergy A (FiniteUnitaryEvolution.orbit U w n)
          = FiniteUnitaryEvolution.observableEnergy A w) :=
  ⟨FiniteCarrierAction.stationaryPair_iff_eom_pair D psi chi,
   fun w => FiniteQuadraticAction.quadraticStationary_iff_eom A hA w,
   fun m2 w => FiniteQuadraticAction.massShellStationary_iff_eigen A m2 w,
   fun m2 _w hpsi => FiniteQuadraticAction.massShell_equation_symmetry U A m2 hUA hpsi,
   fun w n => FiniteUnitaryEvolution.norm_conserved_orbit U w n,
   fun w n => FiniteUnitaryEvolution.energy_conserved_orbit U A hUA w n⟩

/-! ## Thermo packet: finite RG propagation + canonical ensemble -/

/-- **Finite RG / thermo packet.** One conjunction over a finite RG state space and
a finite canonical-ensemble state space:

1. one-step invariants propagate along the finite RG orbit;
2. one-step conserved observables propagate along the finite RG orbit;
3. one-step antitone observables stay bounded along the finite RG orbit;
4. the finite canonical probabilities sum to one;
5. the finite canonical energy variance is nonnegative. -/
theorem rg_ensemble_packet
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

/-! ## Capstone: generic Noether/thermo packets + concrete carrier flow facts -/

/-- **Finite dynamics Noether/thermo capstone.** One conjunction gathering:

* the generic finite Noether packet (`action_symmetry_conservation_packet`);
* the generic finite RG/thermo packet (`rg_ensemble_packet`);
* the concrete carrier flow facts: the `3×3` mass-block flow `exp(-i t B)` is
  Euclidean-unitary, its carrier orbit conserves norm and commuting-observable
  expectation, and the full `6×6` sector-form flow orbit conserves norm.

This is a composition theorem, not new mathematics; see the module docstring for
the standing finite-vs-continuum caveat. -/
theorem finite_dynamics_noether_thermo_capstone
    {V W : Type*} [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    [NormedAddCommGroup W] [InnerProductSpace ℂ W]
    [CompleteSpace V] [CompleteSpace W]
    (D : V →L[ℂ] W) (psi : V) (chi : W)
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]
    (A : H →L[ℂ] H) (hA : IsSelfAdjoint A)
    (U : H ≃ₗᵢ[ℂ] H) (hUA : FiniteQuadraticAction.CommutesWithSymmetry U A)
    {State Value : Type*}
    {PVal : Type*} [Preorder PVal]
    {α : Type*} [Fintype α] [Nonempty α] :
    -- generic finite Noether packet
    ((FiniteCarrierAction.stationaryPair D psi chi
          ↔ D psi = 0 ∧ ContinuousLinearMap.adjoint D chi = 0) ∧
      (∀ w : H, FiniteQuadraticAction.quadraticStationary A w ↔ A w = 0) ∧
      (∀ (m2 : ℝ) (w : H),
          FiniteQuadraticAction.massShellStationary A m2 w ↔ A w = (m2 : ℂ) • w) ∧
      (∀ (m2 : ℝ) (w : H),
          A w = (m2 : ℂ) • w → A (U w) = (m2 : ℂ) • U w) ∧
      (∀ (w : H) (n : ℕ),
          ‖FiniteUnitaryEvolution.orbit U w n‖ = ‖w‖) ∧
      (∀ (w : H) (n : ℕ),
          FiniteUnitaryEvolution.observableEnergy A (FiniteUnitaryEvolution.orbit U w n)
            = FiniteUnitaryEvolution.observableEnergy A w)) ∧
    -- generic finite RG / thermo packet
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
          0 ≤ FiniteCanonicalEnsemble.energyVariance beta energy)) ∧
    -- concrete carrier flow facts
    ((∀ lam kappa t : ℝ,
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
      (∀ (t : ℝ) (v : EuclideanSpace ℂ (Fin 6)) (n : ℕ),
          ‖FiniteUnitaryEvolution.orbit (CarrierUnitaryFlow.carrierFlowStep6 t) v n‖
            = ‖v‖)) :=
  ⟨action_symmetry_conservation_packet D psi chi A hA U hUA,
   rg_ensemble_packet,
   ⟨fun lam kappa t => CarrierUnitaryFlow.B_flow_unitary lam kappa t,
    fun lam kappa t v n =>
      CarrierUnitaryFlow.carrier_orbit_norm_conserved lam kappa t v n,
    fun lam kappa t E hUE v n =>
      CarrierUnitaryFlow.carrier_orbit_energy_conserved lam kappa t E hUE v n,
    fun t v n => CarrierUnitaryFlow.carrier6_orbit_norm_conserved t v n⟩⟩

/-! ## Guard pins for every headline -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDynamicsNoetherThermoCapstone.action_symmetry_conservation_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms action_symmetry_conservation_packet

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDynamicsNoetherThermoCapstone.rg_ensemble_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rg_ensemble_packet

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDynamicsNoetherThermoCapstone.finite_dynamics_noether_thermo_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finite_dynamics_noether_thermo_capstone

end PhysicsSM.Draft.NullEdge.FiniteDynamicsNoetherThermoCapstone
