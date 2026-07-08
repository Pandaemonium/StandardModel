/-
# Finite carrier action and Euler equation

DRAFT (kernel-clean). This module is the first D1 dynamics brick for the
null-edge carrier lane: a finite, clean-room variational action inspired by the
API shape of PhysLean's variational-calculus and Euler-Lagrange stack, but with
no build-time PhysLean import. See
`AgentTasks/overnight-allmass-run-2026-07-08/DYNAMICS_GROUNDWORK.md` and
`docs/PHYSLEAN.md`.

The point is deliberately modest. For a finite-dimensional complex carrier
operator `D : V ->L[Complex] W` (the statements below are slightly more general,
with completeness added only where adjoints need it), introduce an independent
multiplier field `chi : W` and the real action

  `S_D(psi, chi) = Re <D psi, chi>`.

Stationarity in all multiplier variations is exactly the carrier equation
`D psi = 0`. Stationarity in all field variations is exactly the adjoint
equation `D† chi = 0`. Thus a stationary pair is precisely a primal/adjoint
solution pair.

This is not yet a physical time evolution, Hamiltonian flow, Noether theorem,
canonical ensemble, continuum theorem, or uniqueness theorem for the actual
interacting carrier. It is the finite action/EOM scaffold that those next
dynamics targets can build on.

Provenance: clean-room D1 formalization from the 2026-07-08 dynamics guidance,
after consulting PhysLean declaration names
`Physlib.Mathematics.VariationalCalculus.HasVarGradient`,
`Physlib.Mathematics.VariationalCalculus.HasVarAdjDeriv`, and
`Physlib.StatisticalMechanics.CanonicalEnsemble.Basic` as API reference points.
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction

open ContinuousLinearMap
open scoped ComplexConjugate

variable {V W : Type*}
  [NormedAddCommGroup V] [InnerProductSpace ℂ V]
  [NormedAddCommGroup W] [InnerProductSpace ℂ W]

/-- The finite multiplier action `S_D(psi, chi) = Re <D psi, chi>`. The field
`psi` is the carrier state; `chi` is an independent multiplier/adjoint field. -/
noncomputable def carrierAction (D : V →L[ℂ] W) (psi : V) (chi : W) : ℝ :=
  (inner ℂ (D psi) chi).re

/-- First variation of the action in the multiplier direction. -/
noncomputable def multiplierVariation (D : V →L[ℂ] W) (psi : V) (eta : W) : ℝ :=
  carrierAction D psi eta

/-- First variation of the action in the carrier-field direction. -/
noncomputable def fieldVariation (D : V →L[ℂ] W) (xi : V) (chi : W) : ℝ :=
  carrierAction D xi chi

/-- Stationarity against all multiplier variations. -/
def multiplierStationary (D : V →L[ℂ] W) (psi : V) : Prop :=
  ∀ eta : W, multiplierVariation D psi eta = 0

/-- Stationarity against all carrier-field variations. -/
def fieldStationary (D : V →L[ℂ] W) (chi : W) : Prop :=
  ∀ xi : V, fieldVariation D xi chi = 0

/-- A stationary primal/adjoint pair for the finite carrier action. -/
def stationaryPair (D : V →L[ℂ] W) (psi : V) (chi : W) : Prop :=
  multiplierStationary D psi ∧ fieldStationary D chi

/-- The multiplier variation is the real part of pairing the variation with the
carrier equation `D psi`. -/
theorem multiplierVariation_eq (D : V →L[ℂ] W) (psi : V) (eta : W) :
    multiplierVariation D psi eta = (inner ℂ (D psi) eta).re := rfl

/-- The carrier-field variation is the real part of pairing the variation with
the adjoint equation `D† chi`. -/
theorem fieldVariation_eq_adjoint [CompleteSpace V] [CompleteSpace W]
    (D : V →L[ℂ] W) (xi : V) (chi : W) :
    fieldVariation D xi chi = (inner ℂ xi (adjoint D chi)).re := by
  unfold fieldVariation carrierAction
  rw [ContinuousLinearMap.adjoint_inner_right]

/-- **D1 multiplier Euler equation.** Stationarity in all multiplier variations
is exactly the carrier equation `D psi = 0`. -/
theorem multiplierStationary_iff_eom (D : V →L[ℂ] W) (psi : V) :
    multiplierStationary D psi ↔ D psi = 0 := by
  constructor
  · intro h
    have hself_re := h (D psi)
    have hself_im : (inner ℂ (D psi) (D psi)).im = 0 :=
      inner_self_im (𝕜 := ℂ) (D psi)
    have hinner : inner ℂ (D psi) (D psi) = 0 := by
      apply Complex.ext
      · simpa [multiplierVariation, carrierAction] using hself_re
      · simpa using hself_im
    exact inner_self_eq_zero.mp hinner
  · intro h eta
    simp [multiplierVariation, carrierAction, h]

/-- **D1 adjoint Euler equation.** Stationarity in all carrier-field variations
is exactly the adjoint carrier equation `D† chi = 0`. -/
theorem fieldStationary_iff_adjoint_eom [CompleteSpace V] [CompleteSpace W]
    (D : V →L[ℂ] W) (chi : W) :
    fieldStationary D chi ↔ adjoint D chi = 0 := by
  constructor
  · intro h
    have hself_re : (inner ℂ (adjoint D chi) (adjoint D chi)).re = 0 := by
      rw [ContinuousLinearMap.adjoint_inner_right]
      exact h (adjoint D chi)
    have hself_im : (inner ℂ (adjoint D chi) (adjoint D chi)).im = 0 :=
      inner_self_im (𝕜 := ℂ) (adjoint D chi)
    have hinner : inner ℂ (adjoint D chi) (adjoint D chi) = 0 := by
      apply Complex.ext
      · simpa [fieldVariation, carrierAction] using hself_re
      · simpa using hself_im
    exact inner_self_eq_zero.mp hinner
  · intro h xi
    unfold fieldVariation carrierAction
    rw [← ContinuousLinearMap.adjoint_inner_right]
    simp [h]

/-- **D1 stationary-pair theorem.** A stationary pair for the finite action is
exactly a primal carrier solution plus an adjoint carrier solution. -/
theorem stationaryPair_iff_eom_pair [CompleteSpace V] [CompleteSpace W]
    (D : V →L[ℂ] W) (psi : V) (chi : W) :
    stationaryPair D psi chi ↔ D psi = 0 ∧ adjoint D chi = 0 := by
  rw [stationaryPair, multiplierStationary_iff_eom, fieldStationary_iff_adjoint_eom]

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction.multiplierStationary_iff_eom' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms multiplierStationary_iff_eom

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction.stationaryPair_iff_eom_pair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms stationaryPair_iff_eom_pair

end PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction
