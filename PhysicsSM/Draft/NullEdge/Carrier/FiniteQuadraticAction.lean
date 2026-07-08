/-
# Finite quadratic action and mass shell

DRAFT (kernel-clean). This module continues the D1 dynamics lane after
`FiniteCarrierAction`: the multiplier action gives the first-order equation
`D psi = 0`; this file gives the finite quadratic / mass-shell scaffold used by
Rayleigh-quotient and Hamiltonian simulations.

For a finite complex carrier space and operator `A : H ->L[Complex] H`, the
quadratic action is

  `Q_A(psi) = Re <psi, A psi>`.

When `A` is self-adjoint, its finite first variation in a direction `eta` is
`2 Re <eta, A psi>`, so stationarity is exactly the equation `A psi = 0`.
The constrained mass-shell variant uses the finite gradient
`A psi - m^2 psi`; stationarity is exactly the eigen/mass-shell equation
`A psi = m^2 psi`.

This is not yet the physical carrier action, a proof of a particular spectrum,
or a theorem about the continuum limit. It is the clean finite variational API
that lets the carrier mass functional be treated as an action-derived equation
in later specializations.

Provenance: clean-room D1 formalization from the 2026-07-08 dynamics guidance,
using PhysLean's `ClassicalMechanics` / `VariationalCalculus` organization as a
model for "action, gradient, equation of motion" theorem names. No PhysLean
source is imported.
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction

open ContinuousLinearMap
open scoped ComplexConjugate

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

/-- The finite quadratic action `Q_A(psi) = Re <psi, A psi>`. -/
noncomputable def quadraticAction (A : H →L[ℂ] H) (psi : H) : ℝ :=
  (inner ℂ psi (A psi)).re

/-- The symmetric finite first variation of the quadratic action. -/
noncomputable def quadraticFirstVariation (A : H →L[ℂ] H) (psi eta : H) : ℝ :=
  (inner ℂ eta (A psi)).re + (inner ℂ psi (A eta)).re

/-- Stationarity of the quadratic action against every finite variation. -/
def quadraticStationary (A : H →L[ℂ] H) (psi : H) : Prop :=
  ∀ eta : H, quadraticFirstVariation A psi eta = 0

/-- For a self-adjoint operator, the finite first variation is twice the real
pairing of the variation with the Euler operator `A psi`. -/
theorem quadraticFirstVariation_eq_two_re_inner [CompleteSpace H]
    (A : H →L[ℂ] H) (hA : IsSelfAdjoint A) (psi eta : H) :
    quadraticFirstVariation A psi eta = 2 * (inner ℂ eta (A psi)).re := by
  unfold quadraticFirstVariation
  have hinner : inner ℂ psi (A eta) = inner ℂ (A psi) eta := by
    conv_lhs => rw [← hA.adjoint_eq]
    exact ContinuousLinearMap.adjoint_inner_right A psi eta
  have hre : (inner ℂ psi (A eta)).re = (inner ℂ eta (A psi)).re := by
    rw [hinner]
    rw [← Complex.conj_re (inner ℂ (A psi) eta)]
    rw [inner_conj_symm]
  rw [hre]
  ring

/-- **Quadratic Euler equation.** For a self-adjoint finite operator, stationary
points of the quadratic action are exactly solutions of `A psi = 0`. -/
theorem quadraticStationary_iff_eom [CompleteSpace H]
    (A : H →L[ℂ] H) (hA : IsSelfAdjoint A) (psi : H) :
    quadraticStationary A psi ↔ A psi = 0 := by
  constructor
  · intro h
    have hvar := h (A psi)
    rw [quadraticFirstVariation_eq_two_re_inner A hA psi (A psi)] at hvar
    have hre : (inner ℂ (A psi) (A psi)).re = 0 := by linarith
    have him : (inner ℂ (A psi) (A psi)).im = 0 :=
      inner_self_im (𝕜 := ℂ) (A psi)
    have hinner : inner ℂ (A psi) (A psi) = 0 := by
      apply Complex.ext <;> assumption
    exact inner_self_eq_zero.mp hinner
  · intro h eta
    rw [quadraticFirstVariation_eq_two_re_inner A hA psi eta]
    simp [h]

/-- The finite constrained mass-shell action
`Re <psi, A psi> - m2 * Re <psi, psi>`.

For self-adjoint `A`, the displayed finite gradient below is its stationarity
operator. The theorem in this module records the stationarity equation directly;
later carrier specializations can add the derivative theorem they need. -/
noncomputable def massShellAction (A : H →L[ℂ] H) (m2 : ℝ) (psi : H) : ℝ :=
  quadraticAction A psi - m2 * (inner ℂ psi psi).re

/-- The finite gradient of the constrained mass-shell action. -/
noncomputable def massShellGradient (A : H →L[ℂ] H) (m2 : ℝ) (psi : H) : H :=
  A psi - (m2 : ℂ) • psi

/-- First variation against the finite mass-shell gradient. -/
noncomputable def massShellVariation (A : H →L[ℂ] H) (m2 : ℝ) (psi eta : H) : ℝ :=
  (inner ℂ eta (massShellGradient A m2 psi)).re

/-- Stationarity of the finite constrained mass-shell action. -/
def massShellStationary (A : H →L[ℂ] H) (m2 : ℝ) (psi : H) : Prop :=
  ∀ eta : H, massShellVariation A m2 psi eta = 0

/-- **Mass-shell Euler equation.** Stationarity of the finite mass-shell
gradient is exactly the eigen/mass-shell equation `A psi = m^2 psi`. -/
theorem massShellStationary_iff_eigen (A : H →L[ℂ] H) (m2 : ℝ) (psi : H) :
    massShellStationary A m2 psi ↔ A psi = (m2 : ℂ) • psi := by
  constructor
  · intro h
    have hself_re := h (massShellGradient A m2 psi)
    have hself_im : (inner ℂ (massShellGradient A m2 psi)
        (massShellGradient A m2 psi)).im = 0 :=
      inner_self_im (𝕜 := ℂ) (massShellGradient A m2 psi)
    have hinner : inner ℂ (massShellGradient A m2 psi)
        (massShellGradient A m2 psi) = 0 := by
      apply Complex.ext
      · simpa [massShellVariation] using hself_re
      · simpa using hself_im
    have hgrad : massShellGradient A m2 psi = 0 := inner_self_eq_zero.mp hinner
    exact sub_eq_zero.mp (by simpa [massShellGradient] using hgrad)
  · intro h eta
    simp [massShellVariation, massShellGradient, h]

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction.quadraticStationary_iff_eom' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quadraticStationary_iff_eom

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction.massShellStationary_iff_eigen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massShellStationary_iff_eigen

end PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction
