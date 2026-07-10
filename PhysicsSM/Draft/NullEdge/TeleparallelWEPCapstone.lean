import Mathlib
import PhysicsSM.Draft.NullEdge.TeleparallelSoldering
import PhysicsSM.Draft.NullEdge.WEPActionSlotEquation
import PhysicsSM.Draft.NullEdge.WEPActionResourceBridge
import PhysicsSM.Draft.NullEdge.GravitySourceMatter
import PhysicsSM.Draft.NullEdge.Goal4FieldEquation

/-!
# Goal IV — the teleparallel / WEP / source capstone

This draft module *composes* three already-landed finite Goal IV lanes into a single honest
capstone verdict:

* the finite **teleparallel soldering** geometry (`TeleparallelSoldering`): the E-slot is a flat
  connection whose gravity is carried by nonzero torsion, and which splits exactly as
  `torsion (+) nonmetricity`;
* the slot-resolved **WEP source equation** (`WEPActionSlotEquation`): stationarity of the sourced
  finite action recovers the **full matrix source** `G = K` first, and the channel-blind trace
  identity `Tr(G ρ) = κ · Tr ρ` is only a *shadow* (corollary) of that matrix equation;
* the finite **sourced-gravity witnesses** (`GravitySourceMatter`, `Goal4FieldEquation`,
  `WEPActionResourceBridge`): the source equation is nonvacuous in explicit rational/real
  witnesses (a nonzero Lagrange multiplier, an `18 = 18` field-equation witness, and a
  mass-entropy resource measure that separates massless from massive states).

## What is proved here, and only this

* `teleparallel_source_capstone`: the bundled verdict — teleparallel E-slot geometry, the
  slot-resolved (matrix-first) WEP source recovery, non-vacuity of the mass-entropy resource
  measure, the unification field equation, and the two selectivity/non-degeneracy witnesses.
* `slot_before_trace_shadow`: the ordering statement — stationarity yields the full matrix source
  `G = K`, and only *then* the channel-blind trace shadow `Tr(G ρ) = κ · Tr ρ`.
* `torsion_nonzero_source_nonzero_bundle`: the finite payload — nonzero torsion, flat curvature,
  the explicit soldering response `18`, the sourced non-degeneracy witness, and a nonzero
  Lagrange multiplier.

## Honest scope

Every conjunct is re-exported from the imported finite modules. There is **no** continuum
Einstein equation, **no** physical Hilbert-space positivity, and **no** Clausius/Jacobson
derivation beyond the imported finite facts. This is a finite, kernel-checked composition.
-/

namespace TeleparallelWEPCapstone

open Matrix
open PhysicsSM.Draft.NullEdge.GateI1

/-- **The teleparallel / WEP / source capstone.** Given a channel-blind coupling `K = κ • 1` and
stationarity of the sourced finite action, the following all hold simultaneously:

* the E-slot soldering is a finite teleparallel connection (flat curvature, nonzero torsion,
  exact `torsion (+) nonmetricity` split);
* stationarity recovers the full matrix source `G = K`, with the channel-blind trace identity
  `Tr(G ρ) = κ · Tr ρ` as its shadow;
* the mass-entropy resource measure is non-vacuous (massless vs. massive states are separated);
* the finite unification field equation `solderingCurv γ = κ · matterBudget ψ` holds, sourced by
  the matter channels of the same Dirac square;
* an explicit nonzero-multiplier witness and a genuine selectivity control certify the equation
  is not vacuous. -/
theorem teleparallel_source_capstone
    {n : ℕ} {G K : Matrix (Fin n) (Fin n) ℂ} {kappa : ℂ}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hstat : WEPActionBridge.Stationary G K) :
    -- (1) finite teleparallel E-slot geometry
    (TeleparallelSoldering.curvatureLoop = 1 ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
      (∀ g : TeleparallelSoldering.M,
        g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
      (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
        TeleparallelSoldering.nonmetricity TeleparallelSoldering.gGrav ≠ 0) ∧
      TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0) ∧
    -- (2) slot-resolved WEP source recovery: full matrix first, trace shadow second
    (G = K ∧
      ∀ rho : Matrix (Fin n) (Fin n) ℂ,
        WEPActionBridge.traceForm G rho = kappa * rho.trace) ∧
    -- (3) non-vacuity of the mass-entropy resource measure
    ((∃ P : MassEntropyMonotone.FutureConeMomentum,
        MassEntropyMonotone.massEntropyMonotone.value P = 0) ∧
      (∃ P : MassEntropyMonotone.FutureConeMomentum,
        0 < MassEntropyMonotone.massEntropyMonotone.value P)) ∧
    -- (4) the finite unification field equation, sourced by the matter channels
    ((∀ psi : Fin 2 → ℚ, GravitySourceMatter.matterBudget psi =
          GravitySourceMatter.qA psi + GravitySourceMatter.qC psi + GravitySourceMatter.qT psi) ∧
      (∀ (psi : Fin 2 → ℚ) (g : ℝ),
        HasDerivAt (GravitySourceMatter.action (GravitySourceMatter.matterBudget psi)) 0 g ↔
          GravitySourceMatter.solderingCurv g =
            (GravitySourceMatter.kappa : ℝ) * (GravitySourceMatter.matterBudget psi : ℝ)) ∧
      (∀ (psi1 psi2 : Fin 2 → ℚ) (g : ℝ),
        GravitySourceMatter.matterBudget psi1 = GravitySourceMatter.matterBudget psi2 →
          ((GravitySourceMatter.solderingCurv g =
              (GravitySourceMatter.kappa : ℝ) * (GravitySourceMatter.matterBudget psi1 : ℝ)) ↔
            (GravitySourceMatter.solderingCurv g =
              (GravitySourceMatter.kappa : ℝ) * (GravitySourceMatter.matterBudget psi2 : ℝ)))) ∧
      (GravitySourceMatter.matterBudget ![1, 0] ≠ 0 ∧
        GravitySourceMatter.solderingCurv 1 ≠ 0 ∧ (GravitySourceMatter.kappa : ℝ) ≠ 0 ∧
        GravitySourceMatter.solderingCurv 1 =
          (GravitySourceMatter.kappa : ℝ) * (GravitySourceMatter.matterBudget ![1, 0] : ℝ) ∧
        GravitySourceMatter.solderingCurv 1 = 18) ∧
      (GravitySourceMatter.solderingCurv 0 ≠
        (GravitySourceMatter.kappa : ℝ) * (GravitySourceMatter.matterBudget ![1, 0] : ℝ))) ∧
    -- (5) explicit nonzero-multiplier witness (the equation is not the vacuous 0 = 0)
    (Goal4FieldEquation.Qform 1 1 = 0 ∧
      (Goal4FieldEquation.Mmat 2 3 *ᵥ ![(1 : ℝ), 1] =
        (-6 : ℝ) • (Goal4FieldEquation.eta *ᵥ ![1, 1])) ∧ (-6 : ℝ) ≠ 0) ∧
    -- (6) selectivity control: the equation genuinely selects
    (Goal4FieldEquation.Qform 1 1 = 0 ∧
      ∀ mu : ℝ, ¬ (Goal4FieldEquation.Mmat 1 0 *ᵥ ![(1 : ℝ), 1] =
        mu • (Goal4FieldEquation.eta *ᵥ ![1, 1]))) :=
  ⟨TeleparallelSoldering.teleparallel_verdict,
    WEPActionSlotEquation.slot_resolved_source_recovery hK hstat,
    WEPActionResourceBridge.massEntropyMonotone_nonvacuous,
    GravitySourceMatter.unification_verdict,
    Goal4FieldEquation.multiplier_nonzero,
    Goal4FieldEquation.nontrivial_variation_control⟩

/-- **The slot ordering: matrix source before trace shadow.** Stationarity of the sourced action
recovers the *full matrix* source `G = K` first; the channel-blind scalar trace identity
`Tr(G ρ) = κ · Tr ρ` is only a shadow (corollary) of that full matrix equation. -/
theorem slot_before_trace_shadow
    {n : ℕ} {G K : Matrix (Fin n) (Fin n) ℂ} {kappa : ℂ}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hstat : WEPActionBridge.Stationary G K) :
    G = K ∧
      (∀ rho : Matrix (Fin n) (Fin n) ℂ,
        WEPActionBridge.traceForm G rho = kappa * rho.trace) :=
  WEPActionSlotEquation.slot_resolved_source_recovery hK hstat

/-- **The finite payload bundle.** The generic soldering has the explicit nonzero rational torsion
`!![0, ½; -½, 0]`, the basic loop is flat, the soldering response is the explicit nonzero rational
`18`, the sourced field equation holds non-degenerately (both sides `= 18` with nonzero coupling),
and there is an explicit nonzero Lagrange multiplier `μ = -6` on the null cone. -/
theorem torsion_nonzero_source_nonzero_bundle :
    TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
      TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
      TeleparallelSoldering.curvatureLoop = 1 ∧
      GravitySourceMatter.solderingCurv 1 = 18 ∧
      (GravitySourceMatter.matterBudget ![1, 0] ≠ 0 ∧
        GravitySourceMatter.solderingCurv 1 ≠ 0 ∧ (GravitySourceMatter.kappa : ℝ) ≠ 0 ∧
        GravitySourceMatter.solderingCurv 1 =
          (GravitySourceMatter.kappa : ℝ) * (GravitySourceMatter.matterBudget ![1, 0] : ℝ) ∧
        GravitySourceMatter.solderingCurv 1 = 18) ∧
      (Goal4FieldEquation.Qform 1 1 = 0 ∧
        (Goal4FieldEquation.Mmat 2 3 *ᵥ ![(1 : ℝ), 1] =
          (-6 : ℝ) • (Goal4FieldEquation.eta *ᵥ ![1, 1])) ∧ (-6 : ℝ) ≠ 0) :=
  ⟨TeleparallelSoldering.torsion_nonzero.1, TeleparallelSoldering.torsion_nonzero.2,
    TeleparallelSoldering.curvature_flat,
    GravitySourceMatter.nondegenerate_witness.2.2.2.2,
    GravitySourceMatter.nondegenerate_witness,
    Goal4FieldEquation.multiplier_nonzero⟩

end TeleparallelWEPCapstone

/-! ## Kernel-footprint guard pins -/

/-- info: 'TeleparallelWEPCapstone.teleparallel_source_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms TeleparallelWEPCapstone.teleparallel_source_capstone

/-- info: 'TeleparallelWEPCapstone.slot_before_trace_shadow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms TeleparallelWEPCapstone.slot_before_trace_shadow

/-- info: 'TeleparallelWEPCapstone.torsion_nonzero_source_nonzero_bundle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms TeleparallelWEPCapstone.torsion_nonzero_source_nonzero_bundle
