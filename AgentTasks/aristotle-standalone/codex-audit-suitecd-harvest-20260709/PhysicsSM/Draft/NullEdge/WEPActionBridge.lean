import Mathlib
import PhysicsSM.Draft.NullEdge.WEPTrace

/-!
# Goal IV: WEP source / finite action bridge

This draft module connects the WEP trace identity (`WEPTrace`) to the finite
variational-action lane (`Carrier.FiniteCarrierAction`,
`Carrier.FiniteQuadraticAction`).

## What is proved here, and only this

The finite carrier-action modules use the multiplier-action pattern: an action
that is linear in a test/multiplier field, whose stationarity against every
variation is an equation of motion. We realize that pattern at the matrix/trace
level, with the WEP gravitational source `Source K rho = Tr(K rho)` sitting on
the source side.

Concretely, for a finite response operator `G`, standing in for the geometric
response side, and a coupling `K`, the sourced action on the budget field `rho`
is

  `sourcedAction G K rho = Tr(G rho) - Source K rho = Tr(G rho) - Tr(K rho)`.

Because this action is linear in `rho`, its directional variation in direction
`eta` is `sourcedAction G K eta`, and:

* `stationary_iff_fieldEquation`: stationarity against every variation is
  exactly the finite operator field equation `G = K`, response equals source.
  This uses nondegeneracy of the trace pairing (`traceForm_nondegenerate`).
* `stationary_channelBlind_source`: when the coupling is channel-blind, a
  stationary configuration forces the response to be channel-blind too, and its
  source side is `kappa` times the total budget `Tr rho`.

## Nondegeneracy gate

* The variation ranges over the full operator space (`∀ eta`), so the equation
  is not obtained by constraining the variation away.
* `bridge_nonvacuous` exhibits a stationary configuration with a nonzero
  channel-blind coupling and a nonzero source.
* `zero_source_is_degenerate` records the collapsed case we are avoiding: with
  `K = 0` the field equation forces `G = 0`, so the whole balance collapses.

## False-shape audit

`WEPTrace` is a finite matrix trace identity, and this bridge only turns it into
the source side of a finite linear multiplier action. This module does not prove:

* the full E-slot / Einstein field equation as an operator identity forced by
  physics; here `G = K` is an equation extracted from a chosen action, not a
  derived gravitational dynamics;
* stationarity of the geometric soldering action of `CarrierRigidity`;
  `square_decomposition` is an algebraic identity, not yet a variational
  principle;
* any Clausius/Jacobson entropy-to-Einstein result.

The precise next targets and the missing hypotheses/API needed to promote the
trace-level bridge to an operator-level E-slot variation are recorded in the
`NextTargets` comment block at the end of this file.
-/

namespace WEPActionBridge

open Matrix WEPTrace

variable {n : ℕ}

/-- Trace pairing of a finite response operator `G` with the budget field `rho`.
This is the bilinear form `⟨G, rho⟩ = Tr(G rho)` used as the response side of the
sourced action. -/
noncomputable def traceForm (G rho : Matrix (Fin n) (Fin n) ℂ) : ℂ := (G * rho).trace

/-- The sourced finite action on the budget field `rho`: the response pairing
minus the WEP gravitational source. It is linear in `rho`. -/
noncomputable def sourcedAction (G K rho : Matrix (Fin n) (Fin n) ℂ) : ℂ :=
  traceForm G rho - Source K rho

/-- The action is additive in the budget field. -/
theorem sourcedAction_add (G K rho eta : Matrix (Fin n) (Fin n) ℂ) :
    sourcedAction G K (rho + eta) = sourcedAction G K rho + sourcedAction G K eta := by
  unfold sourcedAction traceForm Source
  simp [Matrix.mul_add, Matrix.trace_add]
  ring

/-- The directional variation of the linear sourced action in direction `eta`
is the action evaluated at `eta`. -/
theorem sourcedAction_variation (G K rho eta : Matrix (Fin n) (Fin n) ℂ) :
    sourcedAction G K (rho + eta) - sourcedAction G K rho = sourcedAction G K eta := by
  rw [sourcedAction_add]
  ring

/-- Stationarity of the sourced action: its variation vanishes for every
unconstrained direction `eta`. -/
def Stationary (G K : Matrix (Fin n) (Fin n) ℂ) : Prop :=
  ∀ eta : Matrix (Fin n) (Fin n) ℂ, sourcedAction G K eta = 0

/-- Nondegeneracy of the trace pairing. If `Tr(M eta) = 0` for every `eta`,
then `M = 0`. This is the gate that turns stationarity into an operator
equation. -/
theorem traceForm_nondegenerate (M : Matrix (Fin n) (Fin n) ℂ)
    (h : ∀ eta : Matrix (Fin n) (Fin n) ℂ, traceForm M eta = 0) : M = 0 := by
  ext i j
  have hh := h (Matrix.single j i 1)
  rw [traceForm, Matrix.trace_mul_single] at hh
  simpa using hh

/-- Finite field equation from stationarity. Stationarity of the sourced action
against every variation is exactly the operator field equation `G = K`. -/
theorem stationary_iff_fieldEquation (G K : Matrix (Fin n) (Fin n) ℂ) :
    Stationary G K ↔ G = K := by
  constructor
  · intro h
    have hpair : ∀ eta, traceForm (G - K) eta = 0 := by
      intro eta
      have := h eta
      unfold sourcedAction traceForm Source at *
      rw [Matrix.sub_mul, Matrix.trace_sub]
      linear_combination this
    have := traceForm_nondegenerate (G - K) hpair
    exact sub_eq_zero.mp this
  · intro h eta
    subst h
    unfold sourcedAction traceForm Source
    ring

/-- Channel-blind source side of the finite action equation. If the coupling is
channel-blind and the sourced action is stationary, then the response operator
is forced channel-blind and its source side is `kappa` times the total budget
`Tr rho` for every budget `rho`. -/
theorem stationary_channelBlind_source {G K : Matrix (Fin n) (Fin n) ℂ} {kappa : ℂ}
    (hK : ChannelBlind K kappa) (hstat : Stationary G K) :
    G = kappa • (1 : Matrix (Fin n) (Fin n) ℂ) ∧
      ∀ rho : Matrix (Fin n) (Fin n) ℂ, traceForm G rho = kappa * rho.trace := by
  have hGK : G = K := (stationary_iff_fieldEquation G K).mp hstat
  refine ⟨by rw [hGK]; exact hK, ?_⟩
  intro rho
  rw [traceForm, hGK]
  exact wep_trace_identity hK

/-- Nonvacuity of the bridge. There is a stationary configuration with a
nonzero channel-blind coupling and a nonzero source, so the field equation is
genuinely sourced. -/
theorem bridge_nonvacuous :
    ∃ (G K rho : Matrix (Fin 2) (Fin 2) ℂ) (kappa : ℂ),
      kappa ≠ 0 ∧ ChannelBlind K kappa ∧ Stationary G K ∧ Source K rho ≠ 0 := by
  refine ⟨(1 : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ),
    (1 : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ), 1, 1, one_ne_zero, rfl, ?_, ?_⟩
  · exact (stationary_iff_fieldEquation _ _).mpr rfl
  · rw [wep_trace_identity (kappa := 1) rfl]
    simp [Matrix.trace_one]

/-- Degenerate escape hatch we avoid. With a zero coupling, stationarity forces
the response to vanish and the source side is identically zero. -/
theorem zero_source_is_degenerate {G : Matrix (Fin n) (Fin n) ℂ}
    (hstat : Stationary G (0 : Matrix (Fin n) (Fin n) ℂ)) :
    G = 0 ∧
      ∀ rho : Matrix (Fin n) (Fin n) ℂ, Source (0 : Matrix (Fin n) (Fin n) ℂ) rho = 0 := by
  refine ⟨(stationary_iff_fieldEquation G 0).mp hstat, ?_⟩
  intro rho
  simp [Source]

end WEPActionBridge

/-! ## Kernel-footprint guard -/

/-- info: 'WEPActionBridge.stationary_iff_fieldEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPActionBridge.stationary_iff_fieldEquation

/-- info: 'WEPActionBridge.stationary_channelBlind_source' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPActionBridge.stationary_channelBlind_source

/-- info: 'WEPActionBridge.bridge_nonvacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPActionBridge.bridge_nonvacuous

/-
## NextTargets: promoting the trace-level bridge to an operator E-slot variation

The theorem above is honest but linear (multiplier-action) in the budget field.
The genuinely dynamical E-slot target is a quadratic geometric action whose
Euler operator is the `CarrierRigidity` response `D# D`, sourced by `K`. The
exact missing pieces are:

1. A Frobenius/Hilbert-Schmidt `InnerProductSpace ℂ (Matrix (Fin n) (Fin n) ℂ)`
   instance, or a hand-rolled real inner product, so the abstract
   `FiniteQuadraticAction` machinery can be instantiated with the matrix carrier.
   Mathlib does not ship this instance for `Matrix`; it must be built.

2. A quadratic geometric action `Q(rho) = re Tr(rho^* (G rho))` whose
   self-adjoint Euler operator equals the `CarrierRigidity` response operator
   built from `D# D`. Missing hypothesis: self-adjointness of the response under
   the Frobenius adjoint, which should follow from `CarrierRigidity` facts after
   the adjoint-identification lemma is built.

3. The sourced Euler equation at operator level, obtained from
   `massShellStationary_iff_eigen`-style reasoning with a linear source term
   added. Missing API: a sourced variant of
   `quadraticFirstVariation_eq_two_re_inner`.

Only after (1)-(3) is it legitimate to speak of the E-slot field equation; the
present module deliberately claims only the trace-level source-side bridge.
-/
