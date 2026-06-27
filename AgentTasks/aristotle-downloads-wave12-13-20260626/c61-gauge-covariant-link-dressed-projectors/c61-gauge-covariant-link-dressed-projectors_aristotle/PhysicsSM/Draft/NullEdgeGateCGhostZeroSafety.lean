import Mathlib

/-!
# C47/C48: Golterman–Shamir ghost-zero safety for Gate C Route B

This module is the **Lean-facing skeleton** for the Gate C safety audit recorded
in `AgentTasks/null-edge-golterman-shamir-ghost-zero-audit.md`.  It converts the
Golterman–Shamir propagator-zero hazard (arXiv:2311.12790, and the companion
arXiv:2505.20436 cited in Working Plan §23.2/§25.3) into a precise, machine-
checkable Gate C checklist and an honest release/downgrade calculus.

## The hazard in one line

Route B releases the flavored-chirality index by producing *branch signs* via
point-split projectors, taste operators, or species-splitting terms.  Such
constructions generically introduce **propagator zeros** (determinant zeros of
the Dirac symbol, `p(q)^2 = 0` with `p(q) ≠ 0`, Working Plan §23.1/§25.3).  The
Golterman–Shamir lesson is that a determinant/propagator zero is **not
automatically benign**: once weak gauge coupling is switched on it can promote to
a *gauge-coupled ghost state* — a propagating mode with wrong-sign (negative
Krein) residue — wrecking unitarity, **even while the anomaly-like / index
behaviour survives**.

Therefore a *computed flavored index* must **not** release Gate C on its own.
This module makes the missing side conditions explicit and separately accounted
for, exactly as C22 (`NullEdgeBranchKreinSignatures`) already showed that
*modeled branch chirality* and *modeled Krein signature* are different data.

## Compatibility with the existing modules (no duplication, no import coupling)

The sibling modules `NullEdgeGateCReleaseCriterion` (C19 release criterion) and
`NullEdgeBranchKreinSignatures` (C22 Krein-signature package) build their data on
top of `NullEdgeFlavoredChirality` / `KreinDoubleAndCounterexamples`.  To keep
this audit skeleton **self-contained, `sorry`-free, and axiom-clean** it does not
import those files; instead it re-uses *their conventions* abstractly:

* the four high-momentum null **branches** are indexed by `Fin 4`;
* the spacetime-chirality pattern is `g5 = (+,+,-,-)` (`g5pattern` below),
  matching `NullEdgeFlavoredChirality.g5`;
* the **flavored index** of a branch-sign vector `s : Fin 4 → ℝ` is
  `∑ a, s a * g5 a` (`flavoredIndex`), matching
  `NullEdgeGateCReleaseCriterion.flavoredOp_index`;
* a **Krein-positive physical sector** means every physical pole carries a
  strictly positive Krein residue, matching the C22 `branchKreinSig` /
  `ReleasesKreinPositive` discipline.

A future integration module can identify these abstractions with the concrete
operator data once `NullEdgeFlavoredChirality` is in scope; the predicates and
theorems below are stated so that identification is a definitional substitution.

## Honesty discipline

Nothing physical is *assumed*.  The only genuinely-proven content is:
(i) the pure classification/decision calculus of zeros; (ii) the logical
equivalences characterising ghost-zero safety; (iii) a concrete *separation*
witness showing a nonzero flavored index can coexist with a fatal ghost zero;
and (iv) a stated-but-open **post-gauge-coupling contract** (`PostGaugeGhostSafe`)
that records, as a bundled `Prop`, exactly what must be proven *after* weak gauge
coupling for Route B to remain physically safe.  Inhabiting that contract on the
actual operator data is the real obligation and is deliberately left open.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety

open scoped BigOperators

/-! ## 0. Branch / chirality conventions reused from C19/C22 -/

/-- The spacetime-chirality pattern `g5 = (+,+,-,-)` on the four null branches,
matching `NullEdgeFlavoredChirality.g5`. -/
def g5pattern : Fin 4 → ℝ := ![1, 1, -1, -1]

/-- The **flavored index** of a branch-sign vector `s`, `∑_a s a · g5 a`,
matching the closed form `NullEdgeGateCReleaseCriterion.flavoredOp_index`. -/
def flavoredIndex (s : Fin 4 → ℝ) : ℝ := ∑ a, s a * g5pattern a

/-- With aligned operator signs `s = g5`, the flavored index is `4` (the Route B
"release" value). -/
theorem flavoredIndex_aligned : flavoredIndex g5pattern = 4 := by
  simp only [flavoredIndex, g5pattern, Fin.sum_univ_four, Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.cons_val]
  norm_num

/-! ## 1. Zero classification (Working Plan §23.1 / §25.3, deliverable 3)

Every determinant/propagator zero of the Dirac symbol must be classified before
Gate C may release.  We distinguish the six physically distinct kinds the audit
requires.  Only the last is fatal; the others are benign *provided* they are
correctly identified (which is itself an obligation, recorded by
`WellClassified` below). -/

/-- Classification of a propagator / determinant zero of the null-edge Dirac
symbol. -/
inductive ZeroKind
  /-- A genuine physical pole: a propagating particle, positive (Krein) residue. -/
  | physicalPole
  /-- An *intended* doubler / taste partner that is part of the flavored-index
  bookkeeping and carries a consistent chirality/taste sign. -/
  | physicalDoubler
  /-- A zero forced by symmetry / kinematics (e.g. an on-shell projector or form
  factor vanishing) carrying **no** propagating degree of freedom. -/
  | kinematicalZero
  /-- A zero removable by a field redefinition / composite (interpolating) field:
  an artifact of the chosen field variable, not a physical state. -/
  | compositeRemovable
  /-- A sign feature attributable to the **indefinite Krein metric** (modeled
  Krein signature ≠ chirality, cf. C22) that is *not* an actual negative-norm
  propagating state of the physical, gauge-invariant on-shell subspace. -/
  | kreinArtifact
  /-- The Golterman–Shamir failure mode: a propagator zero that, under weak gauge
  coupling, promotes to a **gauge-coupled propagating state with wrong-sign
  (negative Krein) residue** — a unitarity-violating ghost. -/
  | fatalGhostZero
  deriving DecidableEq, Repr, Inhabited

/-- A zero is **benign** unless it is a fatal ghost zero. -/
def ZeroKind.IsBenign : ZeroKind → Prop
  | .fatalGhostZero => False
  | _ => True

instance : DecidablePred ZeroKind.IsBenign := by
  intro k; cases k <;> unfold ZeroKind.IsBenign <;> infer_instance

/-! ## 2. Zero data and the operational ghost criterion (deliverable 2)

A single zero is described by its classification together with the two pieces of
data the Golterman–Shamir hazard actually turns on:

* whether, **after weak gauge coupling**, it propagates as a gauge-coupled state
  (`gaugeCoupledPropagating`); and
* the **Krein / norm residue** of the associated state (`kreinResidue`), with the
  convention `> 0` physical, `< 0` wrong-sign/ghost, `= 0` non-propagating. -/

/-- Data attached to one determinant/propagator zero. -/
structure ZeroDatum where
  /-- the classification assigned by the Gate C audit. -/
  kind : ZeroKind
  /-- the Krein/norm residue of the associated state (`>0` physical, `<0` ghost,
  `=0` non-propagating). -/
  kreinResidue : ℝ
  /-- whether the zero promotes to a propagating, gauge-coupled state once weak
  gauge coupling is switched on. -/
  gaugeCoupledPropagating : Bool

/-- **Operational ghost criterion.**  A zero is a *fatal ghost* exactly when it
both propagates under gauge coupling **and** carries a wrong-sign (negative)
Krein residue.  This is the precise content of the Golterman–Shamir hazard. -/
def ZeroDatum.IsFatalGhost (z : ZeroDatum) : Prop :=
  z.gaugeCoupledPropagating = true ∧ z.kreinResidue < 0

/-- The classification is **honest** when the `fatalGhostZero` label is used iff
the operational ghost criterion holds, and the genuinely-benign labels
(kinematical, composite-removable, Krein-artifact) carry no gauge-coupled
propagating mode (so they cannot secretly hide a ghost). -/
def ZeroDatum.WellClassified (z : ZeroDatum) : Prop :=
  (z.kind = ZeroKind.fatalGhostZero ↔ z.IsFatalGhost) ∧
  (z.kind = ZeroKind.kinematicalZero → z.gaugeCoupledPropagating = false) ∧
  (z.kind = ZeroKind.compositeRemovable → z.gaugeCoupledPropagating = false) ∧
  (z.kind = ZeroKind.kreinArtifact → z.gaugeCoupledPropagating = false)

/-- A well-classified, non-`fatalGhostZero` zero is genuinely not a fatal ghost. -/
theorem ZeroDatum.not_fatal_of_wellClassified_of_label_ne
    {z : ZeroDatum} (hw : z.WellClassified) (h : z.kind ≠ ZeroKind.fatalGhostZero) :
    ¬ z.IsFatalGhost := by
  intro hfg; exact h (hw.1.mpr hfg)

/-! ## 3. Spectrum-level ghost-zero safety (deliverable 1 checklist core)

A *zero spectrum* is the finite enumerated set of determinant/propagator zeros of
the symbol (Working Plan §23.6 step 1, §25.3 audit step 1–2). -/

/-- **Ghost-zero safety of a spectrum**: no enumerated zero is a fatal ghost. -/
def GhostZeroSafe (zs : List ZeroDatum) : Prop :=
  ∀ z ∈ zs, ¬ z.IsFatalGhost

/-- **Operational restatement.**  A spectrum is ghost-zero safe iff every zero
that becomes gauge-coupled-propagating carries a nonnegative Krein residue, i.e.
weak gauge coupling never produces a wrong-sign propagating state. -/
theorem ghostZeroSafe_iff (zs : List ZeroDatum) :
    GhostZeroSafe zs ↔
      ∀ z ∈ zs, z.gaugeCoupledPropagating = true → 0 ≤ z.kreinResidue := by
  unfold GhostZeroSafe ZeroDatum.IsFatalGhost
  constructor
  · intro h z hz hg
    by_contra hlt
    exact h z hz ⟨hg, lt_of_not_ge hlt⟩
  · intro h z hz ⟨hg, hlt⟩
    exact absurd (h z hz hg) (not_le.mpr hlt)

/-- If every zero is well-classified and none is labelled `fatalGhostZero`, the
spectrum is ghost-zero safe. -/
theorem ghostZeroSafe_of_no_fatal_label
    {zs : List ZeroDatum}
    (hw : ∀ z ∈ zs, z.WellClassified)
    (hlabel : ∀ z ∈ zs, z.kind ≠ ZeroKind.fatalGhostZero) :
    GhostZeroSafe zs :=
  fun z hz => ZeroDatum.not_fatal_of_wellClassified_of_label_ne (hw z hz) (hlabel z hz)

/-! ## 4. The Krein-positive physical sector (C22 interface) -/

/-- **Krein-positive physical sector**: every zero labelled a physical pole
carries a strictly positive Krein residue.  This is the spectrum-level analogue
of C22 `ReleasesKreinPositive` (all physical branch modes Krein-positive). -/
def KreinPositivePhysicalSector (zs : List ZeroDatum) : Prop :=
  ∀ z ∈ zs, z.kind = ZeroKind.physicalPole → 0 < z.kreinResidue

/-! ## 5. The Gate C release / downgrade calculus (deliverable, release language)

The decisive point of the audit: a nonzero flavored index is **necessary but not
sufficient**.  Full release requires all three independent certificates. -/

/-- A complete Route B Gate C dataset: the operator branch signs together with the
classified zero spectrum. -/
structure RouteBData where
  /-- operator-supplied branch signs `s : Fin 4 → ℝ`. -/
  signs : Fin 4 → ℝ
  /-- the enumerated, classified determinant/propagator zeros. -/
  zeros : List ZeroDatum

/-- The flavored index of a Route B dataset. -/
def RouteBData.index (d : RouteBData) : ℝ := flavoredIndex d.signs

/-- **Gate C full-release predicate.**  Release requires *all three*:
the flavored index is nonzero (anomaly-like content), the spectrum is ghost-zero
safe (Golterman–Shamir), and the physical sector is Krein-positive (C22). -/
def GateCFullRelease (d : RouteBData) : Prop :=
  d.index ≠ 0 ∧ GhostZeroSafe d.zeros ∧ KreinPositivePhysicalSector d.zeros

/-- The four-valued Gate C verdict, matching the Working Plan §23.6 step 9
vocabulary, refined for the ghost-zero audit. -/
inductive GateCVerdict
  /-- all three certificates hold. -/
  | released
  /-- index nonzero but ghost-zero safety and/or Krein positivity unproven. -/
  | pendingSafety
  /-- a fatal ghost zero is present: must not release. -/
  | downgradedGhostHazard
  /-- the index itself is zero: no anomaly-like release content. -/
  | noReleaseContent
  deriving DecidableEq, Repr, Inhabited

/-- **Release implies the index alone is not the certificate.**  Full release
entails ghost-zero safety; in particular a fatal ghost forbids release. -/
theorem fullRelease_imp_ghostSafe {d : RouteBData}
    (h : GateCFullRelease d) : GhostZeroSafe d.zeros := h.2.1

/-- A fatal ghost in the spectrum blocks full release, *regardless* of the
flavored index value. -/
theorem no_release_of_fatal_ghost {d : RouteBData}
    {z : ZeroDatum} (hz : z ∈ d.zeros) (hfg : z.IsFatalGhost) :
    ¬ GateCFullRelease d := by
  intro h
  exact (fullRelease_imp_ghostSafe h) z hz hfg

/-! ## 6. Separation theorem: a nonzero flavored index does NOT release Gate C

This is the formal core of the audit's "do not let a computed flavored index
release Gate C" instruction: we exhibit a Route B dataset whose flavored index is
the maximal release value `4`, yet which contains a fatal ghost zero and so is
**not** releasable. -/

/-- A single fatal ghost zero: gauge-coupled and wrong-sign (`residue = -1`). -/
def ghostZeroWitness : ZeroDatum :=
  { kind := ZeroKind.fatalGhostZero, kreinResidue := -1, gaugeCoupledPropagating := true }

/-- A single benign physical pole: gauge-coupled with positive (`residue = 1`)
Krein norm. -/
def physicalPoleWitness : ZeroDatum :=
  { kind := ZeroKind.physicalPole, kreinResidue := 1, gaugeCoupledPropagating := true }

theorem ghostZeroWitness_isFatal : ghostZeroWitness.IsFatalGhost := by
  refine ⟨rfl, ?_⟩; norm_num [ghostZeroWitness]

/-- The dangerous dataset: operator signs aligned (so the flavored index is the
maximal release value `4`), but the zero spectrum contains a fatal ghost. -/
def dangerousRouteB : RouteBData :=
  { signs := g5pattern, zeros := [ghostZeroWitness] }

theorem dangerousRouteB_index_nonzero : dangerousRouteB.index ≠ 0 := by
  show flavoredIndex g5pattern ≠ 0
  rw [flavoredIndex_aligned]; norm_num

/-- **Separation theorem.**  There is a Route B dataset with a *nonzero* (indeed
maximal `= 4`) flavored index that nonetheless **fails** Gate C full release,
because it harbours a Golterman–Shamir fatal ghost zero.  Hence the flavored
index is necessary but not sufficient for release. -/
theorem index_nonzero_not_sufficient :
    ∃ d : RouteBData, d.index ≠ 0 ∧ ¬ GateCFullRelease d := by
  refine ⟨dangerousRouteB, dangerousRouteB_index_nonzero, ?_⟩
  apply no_release_of_fatal_ghost (z := ghostZeroWitness)
  · simp [dangerousRouteB]
  · exact ghostZeroWitness_isFatal

/-- A complementary *safe* dataset (a single physical pole, no ghost): full
release genuinely holds, showing the release predicate is not vacuous. -/
def safeRouteB : RouteBData :=
  { signs := g5pattern, zeros := [physicalPoleWitness] }

theorem safeRouteB_releases : GateCFullRelease safeRouteB := by
  refine ⟨?_, ?_, ?_⟩
  · show flavoredIndex g5pattern ≠ 0
    rw [flavoredIndex_aligned]; norm_num
  · intro z hz
    simp only [safeRouteB, List.mem_singleton] at hz
    subst hz
    intro hfg; rcases hfg with ⟨-, hlt⟩; norm_num [physicalPoleWitness] at hlt
  · intro z hz _
    simp only [safeRouteB, List.mem_singleton] at hz
    subst hz; norm_num [physicalPoleWitness]

/-! ## 7. The post-gauge-coupling obligation (deliverable 4)

This is what must be proven *after* weak gauge coupling for Route B to remain
physically safe.  We package it as a bundled `Prop` (a *contract*, in the style
of `D0PositiveProxy.D0SymbolContract`): nothing is assumed; inhabiting it on the
actual operator data is the open obligation.

`deformed g i` is the datum of zero `i` at gauge coupling `g`.  The contract
asserts a coupling threshold `g₀ > 0` below which **no** zero is a fatal ghost,
i.e. weak gauge coupling never generates a wrong-sign gauge-coupled state. -/

/-- **Post-gauge-coupling ghost-safety contract.**  For a one-parameter family
`deformed : ℝ → ι → ZeroDatum` of zero data over the index set `S`, there is a
coupling threshold `g₀ > 0` such that for all `0 < g ≤ g₀` and all `i ∈ S` the
deformed zero is not a fatal ghost. -/
def PostGaugeGhostSafe {ι : Type*} (deformed : ℝ → ι → ZeroDatum)
    (S : Finset ι) : Prop :=
  ∃ g₀ : ℝ, 0 < g₀ ∧ ∀ g : ℝ, 0 < g → g ≤ g₀ →
    ∀ i ∈ S, ¬ (deformed g i).IsFatalGhost

/-- **Sufficient condition (residue control ⇒ ghost-safety).**  If, for small
coupling, every gauge-coupled deformed zero keeps a nonnegative Krein residue,
then the post-gauge-coupling contract holds.  This is the precise estimate a
weak-coupling perturbation theorem must establish. -/
theorem postGaugeGhostSafe_of_residue_nonneg
    {ι : Type*} (deformed : ℝ → ι → ZeroDatum) (S : Finset ι)
    {g₀ : ℝ} (hg₀ : 0 < g₀)
    (h : ∀ g : ℝ, 0 < g → g ≤ g₀ → ∀ i ∈ S,
          (deformed g i).gaugeCoupledPropagating = true → 0 ≤ (deformed g i).kreinResidue) :
    PostGaugeGhostSafe deformed S := by
  refine ⟨g₀, hg₀, fun g hg hle i hi => ?_⟩
  rintro ⟨hgc, hlt⟩
  exact absurd (h g hg hle i hi hgc) (not_le.mpr hlt)

/-- The contract is **satisfiable**: a coupling-independent benign deformation
(here a single physical pole with residue `1`) inhabits it. -/
theorem postGaugeGhostSafe_benign_example :
    PostGaugeGhostSafe (fun (_ : ℝ) (_ : Fin 1) => physicalPoleWitness)
      (Finset.univ : Finset (Fin 1)) := by
  apply postGaugeGhostSafe_of_residue_nonneg _ _ (g₀ := 1) (by norm_num)
  intro g _ _ i _ _; norm_num [physicalPoleWitness]

/-- The contract is **nontrivial**: a deformation that turns a benign zero into a
gauge-coupled wrong-sign mode for every positive coupling *violates* it. -/
theorem postGaugeGhostSafe_violation_example :
    ¬ PostGaugeGhostSafe (fun (_ : ℝ) (_ : Fin 1) => ghostZeroWitness)
        (Finset.univ : Finset (Fin 1)) := by
  rintro ⟨g₀, hg₀, h⟩
  exact (h g₀ hg₀ le_rfl 0 (Finset.mem_univ 0)) ghostZeroWitness_isFatal

/-! ## 8. The full safe-release statement (release language) -/

/-- **Physically-safe Gate C release for Route B.**  Route B may release Gate C
only when *all four* certificates are in hand:

1. nonzero flavored index (`d.index ≠ 0`, the anomaly-like content, C19);
2. ghost-zero safety of the enumerated spectrum
   (`GhostZeroSafe`, Golterman–Shamir);
3. a Krein-positive physical sector (`KreinPositivePhysicalSector`, C22);
4. the post-gauge-coupling ghost-safety contract `PostGaugeGhostSafe` for the
   weak-coupling deformation `deformed` of the spectrum.

Dropping any one of these downgrades the verdict (PENDING or
DOWNGRADED-GHOST-HAZARD); item 1 alone never suffices
(`index_nonzero_not_sufficient`). -/
def SafeRouteBRelease {ι : Type*} (d : RouteBData)
    (deformed : ℝ → ι → ZeroDatum) (S : Finset ι) : Prop :=
  GateCFullRelease d ∧ PostGaugeGhostSafe deformed S

theorem safeRouteBRelease_imp_index_ne_zero
    {ι : Type*} {d : RouteBData} {deformed : ℝ → ι → ZeroDatum} {S : Finset ι}
    (h : SafeRouteBRelease d deformed S) : d.index ≠ 0 :=
  h.1.1

theorem safeRouteBRelease_imp_ghostSafe
    {ι : Type*} {d : RouteBData} {deformed : ℝ → ι → ZeroDatum} {S : Finset ι}
    (h : SafeRouteBRelease d deformed S) : GhostZeroSafe d.zeros :=
  h.1.2.1

/-- **Audit summary theorem.**  The Gate C ghost-zero calculus is consistent and
nonvacuous: there is a dataset that *fails* release despite a maximal flavored
index (the Golterman–Shamir separation), and there is a dataset that genuinely
releases. -/
theorem gateC_ghostzero_audit_summary :
    (∃ d : RouteBData, d.index ≠ 0 ∧ ¬ GateCFullRelease d) ∧
    (∃ d : RouteBData, GateCFullRelease d) :=
  ⟨index_nonzero_not_sufficient, ⟨safeRouteB, safeRouteB_releases⟩⟩

end PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety
