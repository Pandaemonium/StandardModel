import Mathlib
import PhysicsSM.Draft.NullEdge.PathSumSemantics
import PhysicsSM.Draft.NullEdge.CheckerboardCarrierBridge
import PhysicsSM.Draft.NullEdge.SuiteBCl4Walk
import PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone
import PhysicsSM.Draft.NullEdge.CarrierDynamicsRGInformationCapstone
import PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction
import PhysicsSM.Draft.NullEdge.MassPhaseRGCapstone

open scoped BigOperators
open scoped ComplexConjugate ComplexOrder
open scoped DiracWalkCarrier

set_option maxHeartbeats 4000000
set_option maxRecDepth 4000

/-!
# Four-channel path-action capstone (finite lane)

DRAFT (kernel-clean).  This module turns the **static four-channel mass budget**
`4 · D^# D = Q_A + Q_C + 4·Q_T + 4·E_#` (aperture / closure / turn / soldering)
of `CheckerboardCarrierBridge` into the nearest *finite* path-sum / action
statement we can honestly prove now.

It contributes three things:

1. **A small finite four-channel action API** (`FourChannelAction`).  Each history
   carries a real aperture / closure / turn / soldering contribution; the total
   action is their sum, and the associated phase is
   `phaseOf S = Complex.exp (Complex.I * S)`.  The bookkeeping theorems say the
   total action decomposes into the four channels, the phase factorizes over the
   channel sums, and adding an action difference multiplies the phase by the
   relative phase `exp(I·Δ)`.  This is the finite Feynman-style path-phase
   scaffold sitting on top of the static budget's four channel names.

2. **The landed path-sum semantics packet** (`path_sum_information_packet`):
   coherent histories give the pure / massless packet (`det ρ = 0`), decohered
   histories expose the retained which-direction information (`det ρ` = weighted
   pairwise null disagreement), with the explicit rational witness `det = 4/25`.

3. **The finite carrier + dynamics / RG packet** (`checkerboard_dynamics_packet`):
   the 1+1D checkerboard four-channel budget and mass shell, the Cl(4) walk
   mass-shell square, together with the finite mass-phase / exact-RG verdicts.

The top capstone `four_channel_path_action_capstone` bundles all of the above.

**Honest claim boundary (read before citing).**  Everything here is *finite*:
finite-dimensional linear algebra, finite path sums, real/rational arithmetic,
and the complex exponential of a real total action.  There is **no** claim of the
checkerboard-to-continuum Dirac propagator limit; that remains a paper-level limit
theorem.  The statement proved is exactly: the program now has a local
four-channel action / phase scaffold plus the existing finite path-sum and finite
carrier / dynamics / RG packets.  All naming ("action", "phase", "aperture",
etc.) is decorative avatar language for the finite constructions. The four
action contributions can either be supplied abstractly or, in the checkerboard
specialization, derived as the four quadratic block expectations whose sum is
the carrier mass-form action. No theorem here assigns those block expectations
locally to individual checkerboard histories. That history-level wiring is the
next target.
-/

namespace FourChannelPathActionCapstone

/-! ## 1. The finite four-channel action / phase API -/

/-- A finite four-channel action contribution: the real aperture (kinetic),
closure (gauge), turn (mass) and soldering (geometry) parts attached to a single
history, named after the four channels of the static budget
`4 · D^# D = Q_A + Q_C + 4·Q_T + 4·E_#`. -/
structure FourChannelAction where
  /-- Aperture / kinetic channel contribution. -/
  aperture : ℝ
  /-- Closure / gauge channel contribution. -/
  closure : ℝ
  /-- Turn / mass channel contribution. -/
  turn : ℝ
  /-- Soldering / geometry channel contribution. -/
  soldering : ℝ

/-- The total four-channel action is the sum of the four channel contributions. -/
def FourChannelAction.total (a : FourChannelAction) : ℝ :=
  a.aperture + a.closure + a.turn + a.soldering

/-- The Feynman-style phase of a real action value `S` is `exp(I·S)`. -/
noncomputable def phaseOf (S : ℝ) : ℂ := Complex.exp (Complex.I * (S : ℂ))

/-- The phase attached to a four-channel action is the phase of its total. -/
noncomputable def FourChannelAction.phase (a : FourChannelAction) : ℂ :=
  phaseOf a.total

/-- **Four-channel action decomposition.**  The total action is exactly the sum of
the aperture, closure, turn and soldering contributions. -/
theorem four_channel_action_decomposition (a : FourChannelAction) :
    a.total = a.aperture + a.closure + a.turn + a.soldering := rfl

/-- The phase is multiplicative under addition of actions: `exp(I(S+T)) = exp(IS)·exp(IT)`.
This is the finite "relative phase" bookkeeping law. -/
theorem phaseOf_add (S T : ℝ) : phaseOf (S + T) = phaseOf S * phaseOf T := by
  unfold phaseOf
  rw [← Complex.exp_add]
  congr 1
  push_cast
  ring

/-- The phase of the zero action is `1`. -/
@[simp] theorem phaseOf_zero : phaseOf 0 = 1 := by
  unfold phaseOf; simp

/-- **Four-channel phase factorization.**  The total phase factorizes into the
product of the four per-channel phases. -/
theorem four_channel_phase_factorization (a : FourChannelAction) :
    a.phase
      = phaseOf a.aperture * phaseOf a.closure * phaseOf a.turn * phaseOf a.soldering := by
  unfold FourChannelAction.phase FourChannelAction.total
  rw [phaseOf_add, phaseOf_add, phaseOf_add]

/-- **Relative phase law.**  Adding an action difference `d` to the total multiplies
the phase by the relative phase `phaseOf d = exp(I·d)`. -/
theorem phase_shift_by_action_difference (a : FourChannelAction) (d : ℝ) :
    phaseOf (a.total + d) = a.phase * phaseOf d := by
  rw [phaseOf_add]; rfl

/-- Two actions with the same total have the same phase, and their phases differ by
the relative phase of the total difference. -/
theorem phase_relative (a b : FourChannelAction) :
    b.phase = a.phase * phaseOf (b.total - a.total) := by
  rw [FourChannelAction.phase, FourChannelAction.phase, ← phaseOf_add]
  congr 1
  ring

/-! ## 2. Deriving the finite action budget from the checkerboard carrier -/

/-- Real two-component checkerboard state used by the concrete carrier symbol. -/
abbrev CheckerboardState := Fin 2 → ℝ

/-- The real quadratic expectation of a concrete checkerboard matrix. -/
def matrixAction (A : DiracWalkCarrier.M2) (psi : CheckerboardState) : ℝ :=
  dotProduct psi (A.mulVec psi)

/-- The four state-dependent action contributions obtained from the exact
checkerboard carrier blocks. The factors match the landed matrix budget
`4 D^# D = Q_A + Q_C + 4 Q_T + 4 E_#`. -/
def checkerboardChannelAction (E k m : ℝ) (psi : CheckerboardState) :
    FourChannelAction where
  aperture := matrixAction (DiracWalkCarrier.Q_A E k) psi
  closure := matrixAction DiracWalkCarrier.Q_C psi
  turn := 4 * matrixAction (DiracWalkCarrier.Q_T m) psi
  soldering := 4 * matrixAction (DiracWalkCarrier.E_sharp E k m) psi

/-- The state-dependent quadratic mass-form action of the scaled carrier square. -/
def checkerboardCarrierAction (E k m : ℝ) (psi : CheckerboardState) : ℝ :=
  matrixAction
    ((4 : ℝ) • ((DiracWalkCarrier.Dop E k m)^# * DiracWalkCarrier.Dop E k m)) psi

/-- **Carrier-derived four-channel action.** The sum of the four concrete channel
expectations is exactly the quadratic action of `4 D^# D` on every state. This
is the missing finite wiring between the static carrier budget and the abstract
four-channel phase API; it does not yet assign the terms to individual paths. -/
theorem checkerboard_channel_action_total (E k m : ℝ) (psi : CheckerboardState) :
    (checkerboardChannelAction E k m psi).total
      = checkerboardCarrierAction E k m psi := by
  have h := congrArg (fun A : DiracWalkCarrier.M2 => matrixAction A psi)
    (DiracWalkCarrier.four_channel_budget E k m)
  simpa [checkerboardChannelAction, checkerboardCarrierAction,
    FourChannelAction.total, matrixAction, Matrix.add_mulVec,
    Matrix.smul_mulVec, dotProduct_add, dotProduct_smul, smul_eq_mul] using h.symm

/-- The phase of the carrier-derived channel action is the phase of the full
quadratic carrier action. -/
theorem checkerboard_channel_phase_eq_carrier (E k m : ℝ)
    (psi : CheckerboardState) :
    (checkerboardChannelAction E k m psi).phase
      = phaseOf (checkerboardCarrierAction E k m psi) := by
  rw [FourChannelAction.phase, checkerboard_channel_action_total]

/-- First checkerboard basis state, used for the exact non-degeneracy fixture. -/
def checkerboardBasis0 : CheckerboardState := ![1, 0]

/-- **On-shell non-degeneracy fixture.** At the exact `3-4-5` symbol
`(k,m,E)=(3,4,5)`, the carrier-derived action is nonzero. Aperture and turn each
contribute `64`, closure and the state expectation of soldering vanish, and the
total carrier action is `128`. -/
theorem three_four_five_channel_action_witness :
    (checkerboardChannelAction 5 3 4 checkerboardBasis0).aperture = 64
      ∧ (checkerboardChannelAction 5 3 4 checkerboardBasis0).closure = 0
      ∧ (checkerboardChannelAction 5 3 4 checkerboardBasis0).turn = 64
      ∧ (checkerboardChannelAction 5 3 4 checkerboardBasis0).soldering = 0
      ∧ checkerboardCarrierAction 5 3 4 checkerboardBasis0 = 128
      ∧ (checkerboardChannelAction 5 3 4 checkerboardBasis0).phase = phaseOf 128
      ∧ (DiracWalkCarrier.Dop 5 3 4).det = 0 := by
  have hA : (checkerboardChannelAction 5 3 4 checkerboardBasis0).aperture = 64 := by
    norm_num [checkerboardChannelAction, matrixAction, checkerboardBasis0,
      DiracWalkCarrier.Q_A, DiracWalkCarrier.slashp, Matrix.mulVec, dotProduct,
      Fin.sum_univ_two, Matrix.mul_apply]
  have hC : (checkerboardChannelAction 5 3 4 checkerboardBasis0).closure = 0 := by
    simp [checkerboardChannelAction, matrixAction, DiracWalkCarrier.Q_C]
  have hT : (checkerboardChannelAction 5 3 4 checkerboardBasis0).turn = 64 := by
    norm_num [checkerboardChannelAction, matrixAction, checkerboardBasis0,
      DiracWalkCarrier.Q_T, DiracWalkCarrier.turn, Matrix.mulVec, dotProduct,
      Fin.sum_univ_two, Matrix.mul_apply]
  have hE : (checkerboardChannelAction 5 3 4 checkerboardBasis0).soldering = 0 := by
    norm_num [checkerboardChannelAction, matrixAction, checkerboardBasis0,
      DiracWalkCarrier.E_sharp, DiracWalkCarrier.slashp, DiracWalkCarrier.turn,
      Matrix.mulVec, dotProduct, Fin.sum_univ_two, Matrix.mul_apply]
  have htotal : (checkerboardChannelAction 5 3 4 checkerboardBasis0).total = 128 := by
    norm_num [FourChannelAction.total, hA, hC, hT, hE]
  have hcarrier : checkerboardCarrierAction 5 3 4 checkerboardBasis0 = 128 := by
    rw [← checkerboard_channel_action_total]
    exact htotal
  have hphase : (checkerboardChannelAction 5 3 4 checkerboardBasis0).phase
      = phaseOf 128 := by
    rw [FourChannelAction.phase, htotal]
  exact ⟨hA, hC, hT, hE, hcarrier, hphase,
    (DiracWalkCarrier.mass_shell 5 3 4).2 (by norm_num)⟩

/-! ## 3. The landed path-sum semantics packet -/

/-- **Path-sum information packet.**  Bundling the landed `PathSumSemantics`
headlines:

* **coherent ⇒ pure / massless:** with the all-ones coherence kernel, the visible
  direction density operator is the rank-≤1 projector `|Ψ⟩⟨Ψ|`, so `det ρ = 0`
  (no retained which-direction information / no mass);
* **decohered ⇒ retained which-direction information:** with the delta kernel and
  two histories, `det ρ` is exactly the weighted pairwise null disagreement
  `|a₀|²|a₁|²|ψ₀ ∧ ψ₁|²`;
* **non-degeneracy witness:** on the explicit rational non-collinear witness the
  decohered determinant is the nonzero value `4/25`. -/
theorem path_sum_information_packet
    {H : Type*} [Fintype H] (a : H → ℂ) (psi : H → Fin 2 → ℂ) :
    (SuiteB_PathSum.rhoDir a psi SuiteB_PathSum.onesKer
        = SuiteB_PathSum.outer (SuiteB_PathSum.Psi a psi) (SuiteB_PathSum.Psi a psi)
      ∧ (SuiteB_PathSum.rhoDir a psi SuiteB_PathSum.onesKer).det = 0)
    ∧ (∀ (b : Fin 2 → ℂ) (chi : Fin 2 → Fin 2 → ℂ),
        (SuiteB_PathSum.rhoDir b chi SuiteB_PathSum.deltaKer).det
          = ((Complex.normSq (b 0) * Complex.normSq (b 1)
              * Complex.normSq (SuiteB_PathSum.wedge (chi 0) (chi 1)) : ℝ) : ℂ))
    ∧ (SuiteB_PathSum.rhoDir SuiteB_PathSum.witnessA SuiteB_PathSum.witnessPsi
          SuiteB_PathSum.deltaKer).det = ((4 / 25 : ℝ) : ℂ) :=
  ⟨SuiteB_PathSum.coherent_is_pure a psi,
    SuiteB_PathSum.decohered_mass_two,
    SuiteB_PathSum.witness_decohered_det⟩

/-! ## 4. The finite carrier + dynamics / RG packet -/

/-- **Checkerboard carrier + finite dynamics / RG packet.**  Bundling the landed
finite carrier and finite dynamics / RG headlines:

* the 1+1D checkerboard four-channel budget
  `4 · D^# D = Q_A + Q_C + 4·Q_T + 4·E_#`;
* the checkerboard mass shell `det D = 0 ↔ E² = k² + m²`;
* the Cl(4) walk mass-shell square `D(a,m)² = (a²+m²)·1`;
* the finite mass-phase verdict (`phase_rg_verdict`);
* the finite exact-RG capstone (`exact_rg_capstone`).

Honest scope: these are finite matrix / rational facts; no continuum limit. -/
theorem checkerboard_dynamics_packet :
    (∀ E k m : ℝ,
        (4 : ℝ) • ((DiracWalkCarrier.Dop E k m)^# * DiracWalkCarrier.Dop E k m)
          = DiracWalkCarrier.Q_A E k + DiracWalkCarrier.Q_C
              + (4 : ℝ) • DiracWalkCarrier.Q_T m + (4 : ℝ) • DiracWalkCarrier.E_sharp E k m)
    ∧ (∀ E k m : ℝ, (DiracWalkCarrier.Dop E k m).det = 0 ↔ E ^ 2 = k ^ 2 + m ^ 2)
    ∧ (∀ a m : ℚ,
        SuiteB_Cl4Walk.D a m * SuiteB_Cl4Walk.D a m
          - (a ^ 2 + m ^ 2) • (1 : SuiteB_Cl4Walk.M4) = 0)
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
    ∧ (((∀ lam kap : ℚ, lam ≠ 0 → |kap| = |lam| →
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
  ⟨DiracWalkCarrier.four_channel_budget,
    DiracWalkCarrier.mass_shell,
    SuiteB_Cl4Walk.dispersion_square,
    MassPhaseRGCapstone.phase_rg_verdict,
    MassPhaseRGCapstone.exact_rg_capstone⟩

/-! ## 5. The capstone -/

/-- **Four-channel path-action capstone (finite lane).**  One conjunction gathering:

1. the finite four-channel action / phase scaffold (decomposition, phase
   factorization, relative-phase law);
2. the landed path-sum information packet (coherent ⇒ pure / massless, decohered ⇒
   retained which-direction information, with a nonzero rational witness);
3. the finite checkerboard carrier + Cl(4) mass-shell + finite mass-phase / RG
   packet.

This is a composition theorem, not new mathematics.  **Honest claim boundary:**
every conjunct is a finite statement; there is no continuum Dirac-propagator
limit.  It certifies that the static four-channel budget now carries a local
finite action / phase scaffold on top of the existing finite path-sum and finite
carrier / dynamics / RG packets. The abstract action components in this theorem
remain free inputs; `checkerboard_channel_action_total` separately derives their
checkerboard specialization from the carrier blocks, but not from a history. -/
theorem four_channel_path_action_capstone
    {H : Type*} [Fintype H] (a : H → ℂ) (psi : H → Fin 2 → ℂ)
    (act : FourChannelAction) (d : ℝ) :
    -- (1) finite four-channel action / phase scaffold
    (act.total = act.aperture + act.closure + act.turn + act.soldering
      ∧ act.phase = phaseOf act.aperture * phaseOf act.closure
          * phaseOf act.turn * phaseOf act.soldering
      ∧ phaseOf (act.total + d) = act.phase * phaseOf d)
    -- (2) landed path-sum information packet
    ∧ ((SuiteB_PathSum.rhoDir a psi SuiteB_PathSum.onesKer
          = SuiteB_PathSum.outer (SuiteB_PathSum.Psi a psi) (SuiteB_PathSum.Psi a psi)
        ∧ (SuiteB_PathSum.rhoDir a psi SuiteB_PathSum.onesKer).det = 0)
      ∧ (∀ (b : Fin 2 → ℂ) (chi : Fin 2 → Fin 2 → ℂ),
          (SuiteB_PathSum.rhoDir b chi SuiteB_PathSum.deltaKer).det
            = ((Complex.normSq (b 0) * Complex.normSq (b 1)
                * Complex.normSq (SuiteB_PathSum.wedge (chi 0) (chi 1)) : ℝ) : ℂ))
      ∧ (SuiteB_PathSum.rhoDir SuiteB_PathSum.witnessA SuiteB_PathSum.witnessPsi
            SuiteB_PathSum.deltaKer).det = ((4 / 25 : ℝ) : ℂ))
    -- (3) finite carrier + dynamics / RG packet
    ∧ ((∀ E k m : ℝ,
          (4 : ℝ) • ((DiracWalkCarrier.Dop E k m)^# * DiracWalkCarrier.Dop E k m)
            = DiracWalkCarrier.Q_A E k + DiracWalkCarrier.Q_C
                + (4 : ℝ) • DiracWalkCarrier.Q_T m + (4 : ℝ) • DiracWalkCarrier.E_sharp E k m)
      ∧ (∀ E k m : ℝ, (DiracWalkCarrier.Dop E k m).det = 0 ↔ E ^ 2 = k ^ 2 + m ^ 2)
      ∧ (∀ a m : ℚ,
          SuiteB_Cl4Walk.D a m * SuiteB_Cl4Walk.D a m
            - (a ^ 2 + m ^ 2) • (1 : SuiteB_Cl4Walk.M4) = 0)
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
      ∧ (((∀ lam kap : ℚ, lam ≠ 0 → |kap| = |lam| →
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
              ∧ 1 < |Goal3ChannelRG4.solderingEigenvalue|))) :=
  ⟨⟨four_channel_action_decomposition act,
      four_channel_phase_factorization act,
      phase_shift_by_action_difference act d⟩,
    path_sum_information_packet a psi,
    checkerboard_dynamics_packet⟩

/-! ## Guard pins for every headline theorem -/

/-- info: 'FourChannelPathActionCapstone.four_channel_action_decomposition' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms four_channel_action_decomposition

/-- info: 'FourChannelPathActionCapstone.four_channel_phase_factorization' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms four_channel_phase_factorization

/-- info: 'FourChannelPathActionCapstone.phase_shift_by_action_difference' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phase_shift_by_action_difference

/-- info: 'FourChannelPathActionCapstone.checkerboard_channel_action_total' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms checkerboard_channel_action_total

/-- info: 'FourChannelPathActionCapstone.checkerboard_channel_phase_eq_carrier' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms checkerboard_channel_phase_eq_carrier

/-- info: 'FourChannelPathActionCapstone.three_four_five_channel_action_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms three_four_five_channel_action_witness

/-- info: 'FourChannelPathActionCapstone.path_sum_information_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms path_sum_information_packet

/-- info: 'FourChannelPathActionCapstone.checkerboard_dynamics_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms checkerboard_dynamics_packet

/-- info: 'FourChannelPathActionCapstone.four_channel_path_action_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms four_channel_path_action_capstone

end FourChannelPathActionCapstone
