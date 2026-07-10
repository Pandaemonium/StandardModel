/-
# Finite Hamiltonian / phase-generator boundary capstone

DRAFT (kernel-clean; no `s o r r y`). This module is the citable *finite phase
generator boundary* packet for the null-edge carrier lane. It is a composition
capstone: it introduces no new mathematics, only bundles already-kernelized
bricks into four honest "packet" theorems.

The point is to **distinguish** two things that are easy to conflate:

* what is actually *derived* — finite action-derived equations of motion and
  finite unitary/isometric conservation laws; and
* what is a *convenient modeling choice* — which finite operator (`D`, `D†D`, or
  the compressed sector mass block) plays the role of the physical time-evolution
  generator.

## What is proved (all finite, all kernel-clean)

1. **Finite variational route** (`action_derived_eom_packet`).
   * The finite multiplier action's stationary pairs are exactly primal/adjoint
     carrier solutions `D ψ = 0 ∧ D† χ = 0`
     (`FiniteCarrierAction.stationaryPair_iff_eom_pair`).
   * The finite quadratic action's stationary points are exactly the operator
     kernel `A ψ = 0` (`FiniteQuadraticAction.quadraticStationary_iff_eom`).
   * The constrained mass-shell action's stationarity is exactly the
     eigen/mass-shell equation `A ψ = m² ψ`
     (`FiniteQuadraticAction.massShellStationary_iff_eigen`).

2. **Finite phase-evolution route** (`unitary_phase_conservation_packet`).
   * A finite isometry/transfer step preserves norm along the whole orbit and
     preserves all inner products at each step
     (`FiniteUnitaryEvolution.norm_conserved_orbit`,
     `FiniteUnitaryEvolution.inner_conserved_step`).
   * A commuting observable has conserved real expectation along the orbit
     (`FiniteUnitaryEvolution.energy_conserved_orbit`).
   * The concrete carrier flow `exp(-i t B)` is Euclidean-unitary and fires
     these on the actual carrier step
     (`CarrierUnitaryFlow.B_flow_unitary`,
     `CarrierUnitaryFlow.carrier_orbit_norm_conserved`).

3. **Dirac velocity / mass-shell projector facts**
   (`dirac_mass_shell_generator_packet`). The velocity operator spectrum
   `{±1}`, the mass term `β` as the chirality-flipping coupling, and the
   energy/mass-shell projector pair `Λ± = (pslash ± m)/2m`
   (`DiracVelocityOperator.velocity_spectrum`,
   `DiracVelocityOperator.massless_luminal`,
   `MassShellProjectors.mass_shell_projector_verdict`).

## The honest generator-choice boundary (read before citing)

`D` (the finite carrier operator), `D†D` (its positive square), and the
compressed sector mass block `B = MassGapWitness.B` are all *finite operator
candidates* for a physical phase generator. This capstone does **not** claim that
any one of them is *the* derived Hamiltonian of the full theory. The D1 finite
action yields the constraint `D ψ = 0`, not a Schrödinger equation; treating the
sector mass form as the generator of a one-parameter flow `exp(-i t B)` is a
Stueckelberg-style proper-time modeling choice, defensible but chosen, not
derived. What is kernel-checked is precisely (i) the action-derived equations of
motion and (ii) the unitary conservation scaffold of `exp(-i t B)` — the
remaining physical-generator selection is a *named boundary*, not a theorem.

## Provenance

Composition capstone over the imported finite-dynamics bricks. No new
mathematics; every headline carries an in-file `#print axioms` guard pinned to
exactly `[propext, Classical.choice, Quot.sound]`.
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction
import PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction
import PhysicsSM.Draft.NullEdge.Carrier.FiniteUnitaryEvolution
import PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow
import PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone
import PhysicsSM.Draft.NullEdge.CarrierDynamicsRGInformationCapstone
import PhysicsSM.Draft.NullEdge.DiracVelocityOperator
import PhysicsSM.Draft.NullEdge.MassShellProjectors

namespace FiniteHamiltonianGeneratorCapstone

open Matrix Complex
open PhysicsSM.Draft.NullEdge.Carrier
open DiracVelocityOperator
open MassShellProjectors

/-! ## Packet 1: the finite variational route -/

/-- **Action-derived EOM packet.** The finite variational route, as one
conjunction:

1. finite multiplier action stationary pairs `↔` primal/adjoint carrier
   solutions `D ψ = 0 ∧ D† χ = 0`;
2. finite quadratic action stationarity `↔` the operator kernel `A ψ = 0`;
3. finite constrained mass-shell action stationarity `↔` the eigen/mass-shell
   equation `A ψ = m² ψ`.

This is exactly the finite first-order and second-order equations of motion the
action principle produces — nothing about which operator is "the" physical
generator. -/
theorem action_derived_eom_packet
    {V W : Type*} [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    [NormedAddCommGroup W] [InnerProductSpace ℂ W]
    [CompleteSpace V] [CompleteSpace W]
    (D : V →L[ℂ] W) (psi : V) (chi : W)
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]
    (A : H →L[ℂ] H) (hA : IsSelfAdjoint A) :
    (FiniteCarrierAction.stationaryPair D psi chi
        ↔ D psi = 0 ∧ ContinuousLinearMap.adjoint D chi = 0) ∧
    (∀ w : H, FiniteQuadraticAction.quadraticStationary A w ↔ A w = 0) ∧
    (∀ (m2 : ℝ) (w : H),
        FiniteQuadraticAction.massShellStationary A m2 w ↔ A w = (m2 : ℂ) • w) :=
  ⟨FiniteCarrierAction.stationaryPair_iff_eom_pair D psi chi,
   fun w => FiniteQuadraticAction.quadraticStationary_iff_eom A hA w,
   fun m2 w => FiniteQuadraticAction.massShellStationary_iff_eigen A m2 w⟩

/-! ## Packet 2: the finite phase-evolution route -/

/-- **Unitary phase conservation packet.** The finite phase-evolution route, as
one conjunction:

1. any finite isometry orbit conserves the norm;
2. any finite isometry step preserves all inner products (hence commuting
   observables);
3. an observable commuting with the step has conserved real expectation along
   the orbit;
4. the concrete carrier flow `exp(-i t B)` is Euclidean-unitary;
5. the concrete carrier orbit conserves the sector norm.

This is the derived conservation scaffold of the chosen phase flow — it does not
claim `B` is the physical Hamiltonian, only that *if* the flow is generated by a
Hermitian block then it is unitary and conserving. -/
theorem unitary_phase_conservation_packet
    {K : Type*} [NormedAddCommGroup K] [InnerProductSpace ℂ K] :
    (∀ (U : K ≃ₗᵢ[ℂ] K) (psi : K) (n : ℕ),
        ‖FiniteUnitaryEvolution.orbit U psi n‖ = ‖psi‖) ∧
    (∀ (U : K ≃ₗᵢ[ℂ] K) (psi phi : K),
        inner ℂ (U psi) (U phi) = inner ℂ psi phi) ∧
    (∀ (U : K ≃ₗᵢ[ℂ] K) (E : K →L[ℂ] K),
        FiniteUnitaryEvolution.CommutesWithStep U E → ∀ (psi : K) (n : ℕ),
        FiniteUnitaryEvolution.observableEnergy E (FiniteUnitaryEvolution.orbit U psi n)
          = FiniteUnitaryEvolution.observableEnergy E psi) ∧
    (∀ lam kappa t : ℝ,
        NormedSpace.exp ((-(t : ℂ)) • (Complex.I • MassGapWitness.B lam kappa))
          ∈ Matrix.unitaryGroup (Fin 3) ℂ) ∧
    (∀ (lam kappa t : ℝ) (psi : EuclideanSpace ℂ (Fin 3)) (n : ℕ),
        ‖FiniteUnitaryEvolution.orbit
            (CarrierUnitaryFlow.carrierFlowStep lam kappa t) psi n‖ = ‖psi‖) :=
  ⟨fun U psi n => FiniteUnitaryEvolution.norm_conserved_orbit U psi n,
   fun U psi phi => FiniteUnitaryEvolution.inner_conserved_step U psi phi,
   fun U E hUE psi n => FiniteUnitaryEvolution.energy_conserved_orbit U E hUE psi n,
   fun lam kappa t => CarrierUnitaryFlow.B_flow_unitary lam kappa t,
   fun lam kappa t psi n =>
     CarrierUnitaryFlow.carrier_orbit_norm_conserved lam kappa t psi n⟩

/-! ## Packet 3: the Dirac velocity / mass-shell generator facts -/

/-- **Dirac mass-shell generator packet.** The finite Dirac-side facts that
motivate the generator candidates, as one conjunction:

1. the velocity operator `α₁` has spectrum `{±1}` with traceless, evenly split
   `±c` eigenspaces (`velocity_spectrum`);
2. the mass term `β` anticommutes with every velocity operator and shares no
   common eigenvector with `α₁` — it is the chirality-flipping coupling
   (`massless_luminal`);
3. the energy/mass-shell projectors `Λ± = (pslash ± m)/2m` form a complete
   orthogonal idempotent pair splitting the spinor by sign of energy, singular
   as `m → 0` (`mass_shell_projector_verdict`).

These are the finite operator facts that make `D` / `D†D` / the compressed mass
block *natural* generator candidates; they are not, on their own, a derivation of
a physical Hamiltonian. -/
theorem dirac_mass_shell_generator_packet :
    (alpha1 * alpha1 = 1 ∧ alpha1.trace = 0 ∧ alpha1 ≠ 1 ∧ alpha1 ≠ -1 ∧
        (alpha1.mulVec vplus = vplus ∧ vplus ≠ 0) ∧
        (alpha1.mulVec vminus = -vminus ∧ vminus ≠ 0)) ∧
    (alpha1 * beta = -(beta * alpha1) ∧
        alpha2 * beta = -(beta * alpha2) ∧
        alpha3 * beta = -(beta * alpha3) ∧
        (∀ (v : Fin 4 → ℂ) (a b : ℂ),
          alpha1.mulVec v = a • v → beta.mulVec v = b • v → a * b = 0 ∨ v = 0)) ∧
    ((∀ E kz m : ℚ, m ≠ 0 → E ^ 2 - kz ^ 2 = m ^ 2 →
          Lp E kz m + Lm E kz m = 1 ∧
          Lp E kz m * Lp E kz m = Lp E kz m ∧
          Lm E kz m * Lm E kz m = Lm E kz m ∧
          Lp E kz m * Lm E kz m = 0 ∧
          Lm E kz m * Lp E kz m = 0 ∧
          Matrix.trace (Lp E kz m) = 2 ∧
          Matrix.trace (Lm E kz m) = 2) ∧
        (pslash 5 3 * pslash 5 3 = (16 : ℚ) • (1 : Matrix (Fin 4) (Fin 4) ℚ) ∧
          Lp 5 3 4 * Lp 5 3 4 = Lp 5 3 4 ∧
          Matrix.trace (Lp 5 3 4) = 2 ∧
          Lp 5 3 4 ≠ 0 ∧
          Lp 5 3 4 ≠ 1)) :=
  ⟨velocity_spectrum, massless_luminal, mass_shell_projector_verdict⟩

/-! ## Capstone: the finite phase-generator boundary packet -/

/-- **Finite Hamiltonian generator capstone.** One conjunction gathering the
three packets: the finite variational route (`action_derived_eom_packet`), the
finite phase-evolution conservation route (`unitary_phase_conservation_packet`),
and the Dirac velocity / mass-shell projector facts
(`dirac_mass_shell_generator_packet`).

**Honest scope.** This is a composition theorem. It proves finite
action-derived equations of motion and a finite unitary conservation scaffold,
and it records the finite Dirac-side facts that make `D` / `D†D` / the compressed
mass block natural generator candidates. It does **not** claim a physical
Hamiltonian for the full theory has been derived: the selection of the physical
phase generator remains a named boundary (see the module docstring). -/
theorem finite_hamiltonian_generator_capstone
    {V W : Type*} [NormedAddCommGroup V] [InnerProductSpace ℂ V]
    [NormedAddCommGroup W] [InnerProductSpace ℂ W]
    [CompleteSpace V] [CompleteSpace W]
    (D : V →L[ℂ] W) (psi : V) (chi : W)
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]
    (A : H →L[ℂ] H) (hA : IsSelfAdjoint A)
    {K : Type*} [NormedAddCommGroup K] [InnerProductSpace ℂ K] :
    -- Route 1: finite action principles give equations of motion
    ((FiniteCarrierAction.stationaryPair D psi chi
          ↔ D psi = 0 ∧ ContinuousLinearMap.adjoint D chi = 0) ∧
      (∀ w : H, FiniteQuadraticAction.quadraticStationary A w ↔ A w = 0) ∧
      (∀ (m2 : ℝ) (w : H),
          FiniteQuadraticAction.massShellStationary A m2 w ↔ A w = (m2 : ℂ) • w)) ∧
    -- Route 2: the chosen phase flow is unitary and conserving
    ((∀ (U : K ≃ₗᵢ[ℂ] K) (v : K) (n : ℕ),
          ‖FiniteUnitaryEvolution.orbit U v n‖ = ‖v‖) ∧
      (∀ (U : K ≃ₗᵢ[ℂ] K) (v w : K),
          inner ℂ (U v) (U w) = inner ℂ v w) ∧
      (∀ (U : K ≃ₗᵢ[ℂ] K) (E : K →L[ℂ] K),
          FiniteUnitaryEvolution.CommutesWithStep U E → ∀ (v : K) (n : ℕ),
          FiniteUnitaryEvolution.observableEnergy E (FiniteUnitaryEvolution.orbit U v n)
            = FiniteUnitaryEvolution.observableEnergy E v) ∧
      (∀ lam kappa t : ℝ,
          NormedSpace.exp ((-(t : ℂ)) • (Complex.I • MassGapWitness.B lam kappa))
            ∈ Matrix.unitaryGroup (Fin 3) ℂ) ∧
      (∀ (lam kappa t : ℝ) (v : EuclideanSpace ℂ (Fin 3)) (n : ℕ),
          ‖FiniteUnitaryEvolution.orbit
              (CarrierUnitaryFlow.carrierFlowStep lam kappa t) v n‖ = ‖v‖)) ∧
    -- Dirac-side facts motivating the generator candidates
    ((alpha1 * alpha1 = 1 ∧ alpha1.trace = 0 ∧ alpha1 ≠ 1 ∧ alpha1 ≠ -1 ∧
          (alpha1.mulVec vplus = vplus ∧ vplus ≠ 0) ∧
          (alpha1.mulVec vminus = -vminus ∧ vminus ≠ 0)) ∧
      (alpha1 * beta = -(beta * alpha1) ∧
          alpha2 * beta = -(beta * alpha2) ∧
          alpha3 * beta = -(beta * alpha3) ∧
          (∀ (v : Fin 4 → ℂ) (a b : ℂ),
            alpha1.mulVec v = a • v → beta.mulVec v = b • v → a * b = 0 ∨ v = 0)) ∧
      ((∀ E kz m : ℚ, m ≠ 0 → E ^ 2 - kz ^ 2 = m ^ 2 →
            Lp E kz m + Lm E kz m = 1 ∧
            Lp E kz m * Lp E kz m = Lp E kz m ∧
            Lm E kz m * Lm E kz m = Lm E kz m ∧
            Lp E kz m * Lm E kz m = 0 ∧
            Lm E kz m * Lp E kz m = 0 ∧
            Matrix.trace (Lp E kz m) = 2 ∧
            Matrix.trace (Lm E kz m) = 2) ∧
        (pslash 5 3 * pslash 5 3 = (16 : ℚ) • (1 : Matrix (Fin 4) (Fin 4) ℚ) ∧
          Lp 5 3 4 * Lp 5 3 4 = Lp 5 3 4 ∧
          Matrix.trace (Lp 5 3 4) = 2 ∧
          Lp 5 3 4 ≠ 0 ∧
          Lp 5 3 4 ≠ 1))) :=
  ⟨action_derived_eom_packet D psi chi A hA,
   unitary_phase_conservation_packet,
   dirac_mass_shell_generator_packet⟩

/-! ## Guard pins for every headline -/

/-- info: 'FiniteHamiltonianGeneratorCapstone.action_derived_eom_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms action_derived_eom_packet

/-- info: 'FiniteHamiltonianGeneratorCapstone.unitary_phase_conservation_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms unitary_phase_conservation_packet

/-- info: 'FiniteHamiltonianGeneratorCapstone.dirac_mass_shell_generator_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dirac_mass_shell_generator_packet

/-- info: 'FiniteHamiltonianGeneratorCapstone.finite_hamiltonian_generator_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finite_hamiltonian_generator_capstone

end FiniteHamiltonianGeneratorCapstone
