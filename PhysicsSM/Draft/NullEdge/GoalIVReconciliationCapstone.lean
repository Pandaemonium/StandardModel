import Mathlib
import PhysicsSM.Draft.NullEdge.GravityUnificationCapstone
import PhysicsSM.Draft.NullEdge.UnifiedActionVariation
import PhysicsSM.Draft.NullEdge.UnifiedActionCapstone
import PhysicsSM.Draft.NullEdge.TeleparallelWEPCapstone
import PhysicsSM.Draft.NullEdge.HolographicResourceCapstone
import PhysicsSM.Draft.NullEdge.MinkowskiConvention

/-!
# Goal IV — finite Section 7 reconciliation capstone

This draft module composes the already-landed finite Goal IV packets into a small
set of honest reconciliation bundles.  There are two *finite avatars* of the
"one gravity" story:

* the **variational route** (`UnifiedActionVariation`): one finite spectral action
  `S(E,g)` whose two directional derivatives give a gravity and a matter field
  equation, meeting at a coupled stationary point;
* the **source / equation-of-state route** (`GravityUnificationCapstone`,
  `TeleparallelWEPCapstone`): a stationary sourced finite action whose matrix
  source `G = K` (channel-blind) reproduces the trace-source WEP, teleparallel
  E-slot geometry, and the Jacobson/Clausius finite equation of state.

**Semantic caveat.**  These two routes are *not* proved to be the same map.  No
imported theorem identifies the variational action `S(E,g)` with the sourced
action of the WEP/teleparallel lane, and this file makes **no** such claim.  The
bundles below simply record that both finite routes land, side by side, together
with their nonzero witnesses and the mostly-minus convention anchors.  Every
conjunct is the exact proposition of an already-proved imported theorem,
discharged by the imported proof term; nothing new is assumed.  This is a finite,
kernel-checked composition, **not** a continuum quantum-gravity claim.
-/

open Matrix ModularSelection PositiveSectorClass PhysicsSM.Draft.NullEdge.GateI1

namespace GoalIVReconciliationCapstone

/-- **Variational route capstone.**  Bundles the finite spectral-action variation
lane: one action `S(E,g)`, its closed form, the gravity (`dS/dE = 0`) and matter
(`dS/dg = 0`) field equations, their coupled joint stationary point `(-1,-1)`, and
the fact that the two variations are genuinely distinct.  Every conjunct is an
imported proof term from `UnifiedActionVariation`. -/
theorem variational_route_capstone :
    -- `one_action_verdict`: one functional, two field equations
    ((∀ E g : ℝ, UnifiedActionVariation.S E g =
          10 - 8 * UnifiedActionVariation.wComb E g + 2 * (UnifiedActionVariation.wComb E g) ^ 2) ∧
      (∀ g E : ℝ, HasDerivAt (fun E => UnifiedActionVariation.S E g)
          ((-8 + 4 * UnifiedActionVariation.wComb E g) * (3 + g)) E) ∧
      (∀ E g : ℝ, HasDerivAt (fun g => UnifiedActionVariation.S E g)
          ((-8 + 4 * UnifiedActionVariation.wComb E g) * (2 + E)) g) ∧
      (HasDerivAt (fun E => UnifiedActionVariation.S E (-1)) 0 (-1) ∧
        HasDerivAt (fun g => UnifiedActionVariation.S (-1) g) 0 (-1)) ∧
      ((-8 + 4 * UnifiedActionVariation.wComb 0 0) * (3 + 0) ≠ 0 ∧
        (-8 + 4 * UnifiedActionVariation.wComb 0 0) * (2 + 0) ≠ 0)) ∧
    -- `action_closed_form`
    (∀ E g : ℝ, UnifiedActionVariation.S E g =
        10 - 8 * UnifiedActionVariation.wComb E g + 2 * (UnifiedActionVariation.wComb E g) ^ 2) ∧
    -- `gravity_equation`
    (∀ (g E : ℝ), (3 : ℝ) + g ≠ 0 →
        ((-8 + 4 * UnifiedActionVariation.wComb E g) * (3 + g) = 0 ↔ E = (-4 - 2 * g) / (3 + g))) ∧
    -- `matter_equation`
    (∀ (E g : ℝ), (2 : ℝ) + E ≠ 0 →
        ((-8 + 4 * UnifiedActionVariation.wComb E g) * (2 + E) = 0 ↔ g = (-4 - 3 * E) / (2 + E))) ∧
    -- `coupled_stationary_point`
    ((-8 + 4 * UnifiedActionVariation.wComb (-1) (-1)) * (3 + (-1)) = 0 ∧
      (-8 + 4 * UnifiedActionVariation.wComb (-1) (-1)) * (2 + (-1)) = 0 ∧
      (-1 : ℝ) = (-4 - 2 * (-1)) / (3 + (-1)) ∧
      (-1 : ℝ) = (-4 - 3 * (-1)) / (2 + (-1))) ∧
    -- `derivatives_distinct`
    ((-8 + 4 * UnifiedActionVariation.wComb 0 0) * (3 + 0) ≠
      (-8 + 4 * UnifiedActionVariation.wComb 0 0) * (2 + 0)) :=
  ⟨UnifiedActionVariation.one_action_verdict,
    UnifiedActionVariation.action_closed_form,
    UnifiedActionVariation.gravity_equation,
    UnifiedActionVariation.matter_equation,
    UnifiedActionVariation.coupled_stationary_point,
    UnifiedActionVariation.derivatives_distinct⟩

/-- **Source / equation-of-state route capstone.**  Given a channel-blind coupling
`K = κ • 1` and stationarity of the sourced finite action, bundles the full finite
gravity unification verdict (`GravityUnificationCapstone.gravity_unification_capstone`)
together with the teleparallel / WEP / source capstone
(`TeleparallelWEPCapstone.teleparallel_source_capstone`).  Both are imported proof
terms specialized to the given `(hK, hstat)`. -/
theorem source_equation_route_capstone
    {n : ℕ} {G K : Matrix (Fin n) (Fin n) ℂ} {kappa : ℂ}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hstat : WEPActionBridge.Stationary G K) :
    -- (A) the full finite gravity unification capstone
    ((∃ (K rho1 rho2 : Matrix (Fin 2) (Fin 2) ℂ) (kappa : ℂ),
        WEPTrace.ChannelBlind K kappa ∧ kappa ≠ 0 ∧ rho1 ≠ rho2 ∧
          rho1.trace = rho2.trace ∧ WEPTrace.Source K rho1 = WEPTrace.Source K rho2) ∧
    (∃ (G K rho : Matrix (Fin 2) (Fin 2) ℂ) (kappa : ℂ),
        kappa ≠ 0 ∧ WEPTrace.ChannelBlind K kappa ∧ WEPActionBridge.Stationary G K ∧
          WEPTrace.Source K rho ≠ 0) ∧
    ((∃ P : MassEntropyMonotone.FutureConeMomentum,
          MassEntropyMonotone.massEntropyMonotone.value P = 0) ∧
      (∃ P : MassEntropyMonotone.FutureConeMomentum,
          0 < MassEntropyMonotone.massEntropyMonotone.value P)) ∧
    (Goal4FieldEquation.Qform 1 1 = 0 ∧
      (Goal4FieldEquation.Mmat 2 3 *ᵥ ![(1 : ℝ), 1] =
        (-6 : ℝ) • (Goal4FieldEquation.eta *ᵥ ![1, 1])) ∧ (-6 : ℝ) ≠ 0) ∧
    (Goal4FieldEquation.Qform 1 1 = 0 ∧
      ∀ mu : ℝ, ¬ (Goal4FieldEquation.Mmat 1 0 *ᵥ ![(1 : ℝ), 1] =
        mu • (Goal4FieldEquation.eta *ᵥ ![1, 1]))) ∧
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
    ((∀ g : ℝ × ℝ, JacobsonClausius.ClausiusHolds g ↔ JacobsonClausius.FieldEq g) ∧
      (∃ g v : ℝ × ℝ, JacobsonClausius.FieldEq g ∧
        deriv (fun t => JacobsonClausius.heat (JacobsonClausius.path g v t)) 0 =
          JacobsonClausius.temp *
            deriv (fun t => JacobsonClausius.entropy (JacobsonClausius.path g v t)) 0 ∧
        deriv (fun t => JacobsonClausius.heat (JacobsonClausius.path g v t)) 0 ≠ 0) ∧
      (∃ g v : ℝ × ℝ, ¬ JacobsonClausius.FieldEq g ∧
        deriv (fun t => JacobsonClausius.heat (JacobsonClausius.path g v t)) 0 ≠
          JacobsonClausius.temp *
            deriv (fun t => JacobsonClausius.entropy (JacobsonClausius.path g v t)) 0)) ∧
    (((4 : ℚ) • ((UnifiedMassBudget.D)ᵀ * UnifiedMassBudget.D) =
        (UnifiedMassBudget.QA + UnifiedMassBudget.QC + UnifiedMassBudget.QT) + UnifiedMassBudget.Es) ∧
      (UnifiedMassBudget.Gam * UnifiedMassBudget.Gam = 1) ∧
      (UnifiedMassBudget.Gam * UnifiedMassBudget.QA * UnifiedMassBudget.Gam = UnifiedMassBudget.QA) ∧
      (UnifiedMassBudget.Gam * UnifiedMassBudget.QC * UnifiedMassBudget.Gam = UnifiedMassBudget.QC) ∧
      (UnifiedMassBudget.Gam * UnifiedMassBudget.QT * UnifiedMassBudget.Gam = UnifiedMassBudget.QT) ∧
      (UnifiedMassBudget.Gam * UnifiedMassBudget.Es * UnifiedMassBudget.Gam = -UnifiedMassBudget.Es) ∧
      (UnifiedMassBudget.QA ≠ 0 ∧ UnifiedMassBudget.QC ≠ 0 ∧
        UnifiedMassBudget.QT ≠ 0 ∧ UnifiedMassBudget.Es ≠ 0) ∧
      ((UnifiedMassBudget.bA + UnifiedMassBudget.bC + UnifiedMassBudget.bT) + UnifiedMassBudget.bE = 1 ∧
        UnifiedMassBudget.bE ≠ 0) ∧
      (UnifiedMassBudget.totalBudget = UnifiedMassBudget.c * UnifiedMassBudget.P.det)) ∧
    (SpectralActionAvatar.S 1 1 1 2 1 3 5 = 166 ∧
      ((SpectralActionAvatar.D 2 1 3 5 ^ 2).trace - 6 = 8 ∧ (8 : ℚ) ≠ 0) ∧
      ((SpectralActionAvatar.D 2 1 3 5 ^ 4).trace - (SpectralActionAvatar.D 2 0 0 0 ^ 4).trace = 60 ∧
        (60 : ℚ) ≠ 0) ∧
      (SpectralActionAvatar.D 3 1 3 5 ^ 2).trace ≠ (SpectralActionAvatar.D 2 1 3 5 ^ 2).trace ∧
      (SpectralActionAvatar.D 2 7 8 9 ^ 2).trace = (SpectralActionAvatar.D 2 1 3 5 ^ 2).trace ∧
      (SpectralActionAvatar.D 2 1 3 6 ^ 4).trace ≠ (SpectralActionAvatar.D 2 1 3 5 ^ 4).trace) ∧
    ((∀ E : ℚ, Matrix.trace (EinsteinHilbertTerm.D E * EinsteinHilbertTerm.D E) =
          Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dkin) + EinsteinHilbertTerm.Rfin E) ∧
      (∀ E : ℚ, EinsteinHilbertTerm.Rfin E = 4 * E + 2 * E ^ 2) ∧
      HasDerivAt (fun x : ℚ => Matrix.trace (EinsteinHilbertTerm.D x * EinsteinHilbertTerm.D x)) 0
        EinsteinHilbertTerm.Estar ∧
      EinsteinHilbertTerm.Estar =
        -Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dsold) /
          Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold) ∧
      0 < Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold)) ∧
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
    ((TeleparallelSoldering.curvatureLoop = 1 ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
        (∀ g : TeleparallelSoldering.M,
          g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
        (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
          TeleparallelSoldering.nonmetricity TeleparallelSoldering.gGrav ≠ 0) ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0) ∧
      (G = K ∧
        ∀ rho : Matrix (Fin n) (Fin n) ℂ,
          WEPActionBridge.traceForm G rho = kappa * rho.trace) ∧
      ((∃ P : MassEntropyMonotone.FutureConeMomentum,
          MassEntropyMonotone.massEntropyMonotone.value P = 0) ∧
        (∃ P : MassEntropyMonotone.FutureConeMomentum,
          0 < MassEntropyMonotone.massEntropyMonotone.value P)) ∧
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
      (Goal4FieldEquation.Qform 1 1 = 0 ∧
        (Goal4FieldEquation.Mmat 2 3 *ᵥ ![(1 : ℝ), 1] =
          (-6 : ℝ) • (Goal4FieldEquation.eta *ᵥ ![1, 1])) ∧ (-6 : ℝ) ≠ 0) ∧
      (Goal4FieldEquation.Qform 1 1 = 0 ∧
        ∀ mu : ℝ, ¬ (Goal4FieldEquation.Mmat 1 0 *ᵥ ![(1 : ℝ), 1] =
          mu • (Goal4FieldEquation.eta *ᵥ ![1, 1])))) ∧
    ((Module.finrank ℚ HolographicEdgeBound.Phys = 2 ∧ HolographicEdgeBound.edges = 3 ∧
        0 < Module.finrank ℚ HolographicEdgeBound.Phys ∧
        0 < HolographicEdgeBound.edges ∧
        Module.finrank ℚ HolographicEdgeBound.Phys ≤ HolographicEdgeBound.edges)
      ∧ (HolographicEdgeBound.entropy ≤ HolographicEdgeBound.area)
      ∧ (HolographicEdgeBound.interiorState ≠ 0 ∧
          HolographicEdgeBound.R HolographicEdgeBound.interiorState = 0 ∧
          HolographicEdgeBound.interiorState ∉ HolographicEdgeBound.Phys)
      ∧ ((IsPositive wPositive) ∧
          (IsProtectedNull wProtectedNull ∧ kProtectedNull ≠ 0 ∧
            wProtectedNull *ᵥ kProtectedNull = 0) ∧
          (IsIndefinite wIndefinite ∧ vIndefinite ≠ 0 ∧
            vIndefinite ⬝ᵥ (wIndefinite *ᵥ vIndefinite) < 0) ∧
          (IsBalanced wBalanced))
      ∧ ((∃ P : MassEntropyMonotone.FutureConeMomentum,
            MassEntropyMonotone.massEntropyMonotone.value P = 0) ∧
          (∃ P : MassEntropyMonotone.FutureConeMomentum,
            0 < MassEntropyMonotone.massEntropyMonotone.value P))
      ∧ ((QA.trace = 0 ∧ QC.trace = 0 ∧ QT.trace = 0 ∧ EE.trace = 0 ∧ Bsum.trace = 0)
          ∧ LinearIndependent ℂ ![QA, QC, QT, EE]
          ∧ (Commute QA QC ∧ Commute QA QT ∧ Commute QA EE ∧
              Commute QC QT ∧ Commute QC EE ∧ Commute QT EE)
          ∧ (Commute QA Bsum ∧ Commute QC Bsum ∧ Commute QT Bsum ∧ Commute EE Bsum)
          ∧ (∀ (B A : Matrix (Fin 2) (Fin 2) ℂ) (c : ℂ),
              (c • (1 : Matrix (Fin 2) (Fin 2) ℂ) + B) * A
                  - A * (c • (1 : Matrix (Fin 2) (Fin 2) ℂ) + B)
                = B * A - A * B)
          ∧ (∀ (c : ℂ), c ≠ 0 → ∀ (B : Matrix (Fin 2) (Fin 2) ℂ),
              c • (1 : Matrix (Fin 2) (Fin 2) ℂ) + B ≠ B))
      ∧ (QA ≠ 0 ∧ QC ≠ 0 ∧ QT ≠ 0 ∧ EE ≠ 0)
      ∧ (Bsum ≠ 0 ∧ Bsum ≠ (Bsum.trace / 5) • (1 : Matrix (Fin 5) (Fin 5) ℂ))) ∧
    ((MinkowskiConvention.eta 0 0 : ℚ) = 1 ∧ (MinkowskiConvention.eta 1 1 : ℚ) = -1)) ∧
    -- (B) the teleparallel / WEP / source capstone
    ((TeleparallelSoldering.curvatureLoop = 1 ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
        (∀ g : TeleparallelSoldering.M,
          g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
        (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
          TeleparallelSoldering.nonmetricity TeleparallelSoldering.gGrav ≠ 0) ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0) ∧
      (G = K ∧
        ∀ rho : Matrix (Fin n) (Fin n) ℂ,
          WEPActionBridge.traceForm G rho = kappa * rho.trace) ∧
      ((∃ P : MassEntropyMonotone.FutureConeMomentum,
          MassEntropyMonotone.massEntropyMonotone.value P = 0) ∧
        (∃ P : MassEntropyMonotone.FutureConeMomentum,
          0 < MassEntropyMonotone.massEntropyMonotone.value P)) ∧
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
      (Goal4FieldEquation.Qform 1 1 = 0 ∧
        (Goal4FieldEquation.Mmat 2 3 *ᵥ ![(1 : ℝ), 1] =
          (-6 : ℝ) • (Goal4FieldEquation.eta *ᵥ ![1, 1])) ∧ (-6 : ℝ) ≠ 0) ∧
      (Goal4FieldEquation.Qform 1 1 = 0 ∧
        ∀ mu : ℝ, ¬ (Goal4FieldEquation.Mmat 1 0 *ᵥ ![(1 : ℝ), 1] =
          mu • (Goal4FieldEquation.eta *ᵥ ![1, 1])))) :=
  ⟨GravityUnificationCapstone.gravity_unification_capstone hK hstat,
    TeleparallelWEPCapstone.teleparallel_source_capstone hK hstat⟩

/-- **Section 7 non-vacuity and boundary bundle.**  Records the nonzero
gravity/matter witnesses (`UnifiedActionCapstone.nonzero_gravity_matter_witness_bundle`),
the positive holographic boundary (`HolographicResourceCapstone.positive_boundary_nonvacuity_bundle`),
the non-vacuity of the mass-entropy resource measure
(`WEPActionResourceBridge.massEntropyMonotone_nonvacuous`), and the mostly-minus
Minkowski convention anchors (`MinkowskiConvention.convention_note`). -/
theorem s7_nonvacuity_and_boundary :
    -- nonzero gravity/matter witnesses
    (SpectralActionAvatar.S 1 1 1 2 1 3 5 = 166
      ∧ ((SpectralActionAvatar.D 2 1 3 5 ^ 2).trace - 6 = 8 ∧ (8 : ℚ) ≠ 0)
      ∧ (((SpectralActionAvatar.D 2 1 3 5 ^ 4).trace
            - (SpectralActionAvatar.D 2 0 0 0 ^ 4).trace = 60) ∧ (60 : ℚ) ≠ 0)
      ∧ UnifiedMassBudget.bE ≠ 0
      ∧ UnifiedMassBudget.bA + UnifiedMassBudget.bC + UnifiedMassBudget.bT ≠ 0
      ∧ UnifiedMassBudget.totalBudget = UnifiedMassBudget.c * UnifiedMassBudget.P.det
      ∧ GravitySourceMatter.solderingCurv 1
          = (GravitySourceMatter.kappa : ℝ) * (GravitySourceMatter.matterBudget ![1, 0] : ℝ)
      ∧ GravitySourceMatter.solderingCurv 1 = 18
      ∧ JacobsonClausius.FieldEq ((1 : ℝ), (1 : ℝ))) ∧
    -- positive holographic boundary
    (0 < HolographicEdgeBound.edges
      ∧ 0 < Module.finrank ℚ HolographicEdgeBound.Phys
      ∧ Module.finrank ℚ HolographicEdgeBound.Phys ≤ HolographicEdgeBound.edges) ∧
    -- resource non-vacuity
    ((∃ P : MassEntropyMonotone.FutureConeMomentum,
        MassEntropyMonotone.massEntropyMonotone.value P = 0) ∧
      (∃ P : MassEntropyMonotone.FutureConeMomentum,
        0 < MassEntropyMonotone.massEntropyMonotone.value P)) ∧
    -- mostly-minus convention anchors
    ((MinkowskiConvention.eta 0 0 : ℚ) = 1 ∧ (MinkowskiConvention.eta 1 1 : ℚ) = -1) :=
  ⟨UnifiedActionCapstone.nonzero_gravity_matter_witness_bundle,
    HolographicResourceCapstone.positive_boundary_nonvacuity_bundle,
    WEPActionResourceBridge.massEntropyMonotone_nonvacuous,
    MinkowskiConvention.convention_note⟩

/-- **Finite Section 7 reconciliation verdict.**  The honest boundary of the
reconciliation: the variational route lands (one finite action, two distinct
field equations meeting at a coupled stationary point — `one_action_verdict`,
`derivatives_distinct`), the source route lands (stationarity recovers the full
matrix source `G = K` before its channel-blind trace shadow —
`slot_before_trace_shadow`), and the finite geometry is pinned by the sharp
numerical anchors (`finite_gravity_claim_boundary`).

**Caveat (stated, not proved away).**  The two routes are placed side by side;
no conjunct identifies the variational action with the sourced action, and this
verdict makes no such identification. -/
theorem finite_s7_reconciliation_verdict
    {n : ℕ} {G K : Matrix (Fin n) (Fin n) ℂ} {kappa : ℂ}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hstat : WEPActionBridge.Stationary G K) :
    -- variational route: one action, two field equations
    ((∀ E g : ℝ, UnifiedActionVariation.S E g =
          10 - 8 * UnifiedActionVariation.wComb E g + 2 * (UnifiedActionVariation.wComb E g) ^ 2) ∧
      (∀ g E : ℝ, HasDerivAt (fun E => UnifiedActionVariation.S E g)
          ((-8 + 4 * UnifiedActionVariation.wComb E g) * (3 + g)) E) ∧
      (∀ E g : ℝ, HasDerivAt (fun g => UnifiedActionVariation.S E g)
          ((-8 + 4 * UnifiedActionVariation.wComb E g) * (2 + E)) g) ∧
      (HasDerivAt (fun E => UnifiedActionVariation.S E (-1)) 0 (-1) ∧
        HasDerivAt (fun g => UnifiedActionVariation.S (-1) g) 0 (-1)) ∧
      ((-8 + 4 * UnifiedActionVariation.wComb 0 0) * (3 + 0) ≠ 0 ∧
        (-8 + 4 * UnifiedActionVariation.wComb 0 0) * (2 + 0) ≠ 0)) ∧
    -- source route: matrix source before trace shadow
    (G = K ∧
      (∀ rho : Matrix (Fin n) (Fin n) ℂ,
        WEPActionBridge.traceForm G rho = kappa * rho.trace)) ∧
    -- finite claim boundary: the sharp numerical anchors
    ((MinkowskiConvention.eta 0 0 : ℚ) = 1
      ∧ (MinkowskiConvention.eta 1 1 : ℚ) = -1
      ∧ TeleparallelSoldering.curvatureLoop = 1
      ∧ TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0
      ∧ EinsteinHilbertTerm.Rfin EinsteinHilbertTerm.Estar = -2
      ∧ JacobsonClausius.FieldEq ((1 : ℝ), (1 : ℝ))) ∧
    -- the two variations are genuinely distinct (routes are not collapsed)
    ((-8 + 4 * UnifiedActionVariation.wComb 0 0) * (3 + 0) ≠
      (-8 + 4 * UnifiedActionVariation.wComb 0 0) * (2 + 0)) :=
  ⟨UnifiedActionVariation.one_action_verdict,
    TeleparallelWEPCapstone.slot_before_trace_shadow hK hstat,
    GravityUnificationCapstone.finite_gravity_claim_boundary,
    UnifiedActionVariation.derivatives_distinct⟩

end GoalIVReconciliationCapstone

/-! ## Kernel-footprint guard pins -/

/-- info: 'GoalIVReconciliationCapstone.variational_route_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms GoalIVReconciliationCapstone.variational_route_capstone

/-- info: 'GoalIVReconciliationCapstone.source_equation_route_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms GoalIVReconciliationCapstone.source_equation_route_capstone

/-- info: 'GoalIVReconciliationCapstone.s7_nonvacuity_and_boundary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms GoalIVReconciliationCapstone.s7_nonvacuity_and_boundary

/-- info: 'GoalIVReconciliationCapstone.finite_s7_reconciliation_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms GoalIVReconciliationCapstone.finite_s7_reconciliation_verdict
