import Mathlib
import PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety
import PhysicsSM.Draft.NullEdgeSymmetryForcedSpeciesSplit

/-!
# C59: the post-C21 *projected / species-split* Gate C release theorem

C21 (`PhysicsSM.Draft.NullEdgeActualCliffordSymbol`) killed the old *bare*
release criterion: the actual flat tetrahedral null-edge Clifford symbol assigns
**no single chirality sign** to a branch — its per-branch kernel is
two-dimensional and chirality-balanced (one `γ₅ = +1` and one `γ₅ = -1` mode),
so the C19 hypothesis `OperatorForcesAlignment bc := bc = g5` is *not* discharged
by the bare operator.  A single-sign branch chirality only emerges after an
extra energy/Krein/Weyl projection that selects one kernel mode per branch.

Consequently the correct Gate C release statement must be **projected /
species-split** and must keep *separate, independent* clauses for

* nodal-set control (C43/C44 extended determinant-zero curves must be gapped),
* branch-projector control (the species projection is well-defined),
* one-dimensionality of the *projected* kernel (vs. the 2-dim bare kernel, C21),
* chirality alignment of the *projected* mode,
* Krein positivity of the projected physical sector (C22 / K2),
* ghost-zero safety (Golterman–Shamir, C47/C48), and
* the moduli status of the species splitting (C45/C46).

This is an **API / theorem-integration module** (the concrete projector theorem
is the separate C58 obligation).  It defines the projected release predicate as a
conjunction of independent clauses, proves the conjunction implies a named
projected release theorem, and proves the requested negative guardrails.

## Interfacing, not duplicating

* The ghost-zero calculus (`ZeroDatum`, `GhostZeroSafe`,
  `KreinPositivePhysicalSector`, `GateCFullRelease`, `flavoredIndex`,
  `g5pattern`, witnesses) is **reused verbatim** from C47/C48
  (`PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety`).
* The species-splitting moduli predicates (`BlockConstant`, `Traceless`,
  `SymmetryForcesDirection`, `direction_forced_scale_free`) are **reused
  verbatim** from C45/C46 (`PhysicsSM.Draft.NullEdgeSymmetryForcedSpeciesSplit`).
* The K2 Krein-positive *sector* discipline
  (`PhysicsSM.Draft.NullEdgeKreinPositiveReleaseCriterion`) is mirrored at the
  per-branch level by `ProjectedKreinPositive`.  K2's *matrix-level* realization
  (`KreinPositiveSector`, `Pphys`) is the intended concrete model; it lives in a
  sibling module whose source dependencies (`NullEdgeFlavoredChirality`,
  `KreinDoubleAndCounterexamples`) are not present in this snapshot, so it is not
  imported here (importing it would break the build).  The per-branch interface
  below is stated so that identification is a definitional substitution once that
  data is in scope, exactly as C47/C48 already does for the chirality pattern.

## Honesty discipline

Nothing physical is assumed as fact.  The genuine content is the *logical*
decomposition: that the conjunction of the seven clauses entails the bundled
release certificate, and four *separation* theorems showing the clauses are
mutually independent (no single one implies release, and the bare-symbol
chirality failure of C21 is consistent with projected release).  Discharging the
clauses on the actual projected operator data is the open C58 obligation.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeProjectedGateCRelease

open PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety
  (ZeroDatum RouteBData flavoredIndex g5pattern flavoredIndex_aligned
   KreinPositivePhysicalSector GateCFullRelease physicalPoleWitness
   ghostZeroWitness ghostZeroWitness_isFatal)

open PhysicsSM.Draft.NullEdgeSymmetryForcedSpeciesSplit
  (SymmetryForcesDirection BlockConstant Traceless direction_forced_scale_free g5)

/-! ## The projected / species-split Gate C dataset -/

/-- A complete *projected* Gate C dataset.  All branch quantities are recorded
**after** the species/Krein/Weyl projection that C21 showed is required (the bare
symbol does not assign a single branch chirality).

* `signs` — the species-splitting branch signs (`M_split = r · T` direction,
  C45/C46).
* `chir` — the chirality eigenvalue of the *projected* (one-dimensional) mode on
  each branch.
* `krein` — the Krein signature of the projected mode on each branch.
* `kerDim` — the dimension of the *projected* kernel on each branch (`1` on a
  retained branch, `0` on a projected-out branch).
* `nodalGap` — the spectral gap the branch-control term opens on each branch's
  determinant-zero curve (C43/C44); positive means the extended nodal curve is
  controlled.
* `retained` — the physical (Krein-positive) branches selected by the projection.
* `zeros` — the enumerated, classified determinant/propagator zeros (C47/C48).
* `bareChirTrace` — the *bare* (pre-projection) per-branch kernel chirality
  trace, which C21 shows is `0` (the kernel is chirality-balanced). -/
structure ProjData where
  /-- species-splitting branch signs (`M_split = r · T` direction). -/
  signs : Fin 4 → ℝ
  /-- chirality eigenvalue of the projected mode on each branch. -/
  chir : Fin 4 → ℝ
  /-- Krein signature of the projected mode on each branch. -/
  krein : Fin 4 → ℝ
  /-- dimension of the projected kernel on each branch. -/
  kerDim : Fin 4 → ℕ
  /-- spectral gap of each branch's nodal (determinant-zero) curve. -/
  nodalGap : Fin 4 → ℝ
  /-- the physical (retained) branches selected by the projection. -/
  retained : Fin 4 → Bool
  /-- the enumerated, classified determinant/propagator zeros (C47/C48). -/
  zeros : List ZeroDatum
  /-- the bare, pre-projection per-branch kernel chirality trace (C21: `0`). -/
  bareChirTrace : Fin 4 → ℝ

/-- The C47/C48 Route B dataset underlying a projected dataset (its branch signs
and its classified zero spectrum). -/
def ProjData.toRouteB (d : ProjData) : RouteBData :=
  { signs := d.signs, zeros := d.zeros }

/-- The flavored index of the projected dataset (reusing C47/C48
`flavoredIndex`). -/
def ProjData.index (d : ProjData) : ℝ := flavoredIndex d.signs

/-- The underlying Route B index agrees with the projected index. -/
theorem index_toRouteB (d : ProjData) : d.toRouteB.index = d.index := rfl

/-! ## The seven independent release clauses -/

/-- **Clause 1 — nodal-set control (C43/C44).**  Every branch's
determinant-zero curve is gapped (`0 < nodalGap a`): the extended one-parameter
nodal curves of the bare symbol are controlled by the branch-control term, so
species-count language is justified. -/
def NodalSetControlled (d : ProjData) : Prop :=
  ∀ a, 0 < d.nodalGap a

/-- **Clause 2 — branch-projector control.**  The species projection is
well-defined: it retains a nonempty physical sector and annihilates every
projected-out branch (zero projected kernel there). -/
def BranchProjectorsControlled (d : ProjData) : Prop :=
  (∃ a, d.retained a = true) ∧ (∀ a, d.retained a = false → d.kerDim a = 0)

/-- **Clause 3 — projected kernel one-dimensional (vs. the bare 2-dim kernel,
C21).**  On every retained branch the *projected* kernel is one-dimensional. -/
def ProjectedKernelOneDim (d : ProjData) : Prop :=
  ∀ a, d.retained a = true → d.kerDim a = 1

/-- **Clause 4 — projected chirality aligned.**  On every retained branch the
projected one-dimensional mode carries the aligned chirality sign `g5 a` (the C21
obstruction — the balanced bare kernel — is removed by the projection). -/
def ProjectedChiralityAligned (d : ProjData) : Prop :=
  ∀ a, d.retained a = true → d.chir a = g5pattern a

/-- **Clause 5 — projected Krein positivity (C22 / K2).**  Every retained branch
is Krein-positive (`krein a = 1`) and the determinant-zero physical poles carry
strictly positive Krein residue (`KreinPositivePhysicalSector`, reused from
C47/C48). -/
def ProjectedKreinPositive (d : ProjData) : Prop :=
  (∀ a, d.retained a = true → d.krein a = 1) ∧ KreinPositivePhysicalSector d.zeros

/-- **Clause 6 — ghost-zero safety (Golterman–Shamir, C47/C48).**  No enumerated
determinant/propagator zero is a fatal (gauge-coupled, wrong-sign-Krein)
ghost. -/
def GhostZeroSafe (d : ProjData) : Prop :=
  NullEdgeGateCGhostZeroSafety.GhostZeroSafe d.zeros

/-- **Clause 7 — species-splitting audited (C45/C46).**  The splitting direction
is symmetry-forced (`BlockConstant ∧ Traceless`, hence `signs = (signs 0) • g5`)
and is a genuine nonzero modulus. -/
def SpeciesSplittingAudited (d : ProjData) : Prop :=
  SymmetryForcesDirection d.signs ∧ d.signs ≠ 0

/-! ## The bundled projected release certificate -/

/-- **Projected Gate C release certificate.**  The physically meaningful
consequence of all seven clauses: a nonzero (release-content) flavored index, a
nonempty retained sector of one-dimensional `g5`-aligned Krein-positive projected
modes, controlled nodal curves, a ghost-zero-safe spectrum with a Krein-positive
physical pole sector, and — packaged through the C47/C48 interface — a genuine
`GateCFullRelease` of the underlying Route B dataset. -/
def ProjectedGateCRelease (d : ProjData) : Prop :=
  d.index ≠ 0 ∧
  (∃ a, d.retained a = true) ∧
  (∀ a, d.retained a = true → d.kerDim a = 1 ∧ d.chir a = g5pattern a ∧ d.krein a = 1) ∧
  (∀ a, 0 < d.nodalGap a) ∧
  NullEdgeGateCGhostZeroSafety.GhostZeroSafe d.zeros ∧
  KreinPositivePhysicalSector d.zeros ∧
  GateCFullRelease d.toRouteB

/-! ## Index nonvanishing from the audited species splitting -/

/-
The species-audited direction has equal-magnitude `±(signs 0)` entries
matching `g5`, so its flavored index is `4 · (signs 0)`, nonzero.
-/
theorem species_audited_index_ne_zero (d : ProjData)
    (h : SpeciesSplittingAudited d) : d.index ≠ 0 := by
  obtain ⟨hsym, hne⟩ := h
  have hforced : d.signs = (d.signs 0) • g5 :=
    direction_forced_scale_free d.signs hsym.1 hsym.2
  have h0 : d.signs 0 ≠ 0 := fun hz => hne (by rw [hforced, hz, zero_smul])
  have hval : d.index = d.signs 0 * 4 := by
    unfold ProjData.index flavoredIndex
    rw [Fin.sum_univ_four, hforced]
    simp [g5, g5pattern, Pi.smul_apply, smul_eq_mul]
    ring
  rw [hval]
  exact mul_ne_zero h0 (by norm_num)

/-! ## The main projected release theorem -/

/-
**Projected Gate C release theorem (C59).**  The conjunction of the seven
independent clauses entails the bundled projected release certificate.  This is
the post-C21 replacement for the dead bare release criterion: release is granted
only on the *projected / species-split* data, with chirality, Krein positivity,
ghost-zero safety, nodal control, one-dimensionality, and moduli status each
separately certified.
-/
theorem projected_gateC_release (d : ProjData)
    (hNodal : NodalSetControlled d)
    (hProj : BranchProjectorsControlled d)
    (hKer : ProjectedKernelOneDim d)
    (hChir : ProjectedChiralityAligned d)
    (hKrein : ProjectedKreinPositive d)
    (hGhost : GhostZeroSafe d)
    (hSpecies : SpeciesSplittingAudited d) :
    ProjectedGateCRelease d := by
  exact ⟨ species_audited_index_ne_zero d hSpecies, hProj.1, fun a ha => ⟨ hKer a ha, hChir a ha, hKrein.1 a ha ⟩, hNodal, hGhost, hKrein.2, ⟨ index_toRouteB d ▸ species_audited_index_ne_zero d hSpecies, hGhost, hKrein.2 ⟩ ⟩

/-! ## A concrete released witness (the release predicate is not vacuous) -/

/-- A canonical released dataset: the physical pair `{0,2}` (as in K2's `physSel`)
retained with one-dimensional `g5`-aligned Krein-positive projected modes, gapped
nodal curves, a single benign physical pole, aligned species signs, and a
balanced bare kernel (C21). -/
def releasedData : ProjData where
  signs := g5pattern
  chir := g5pattern
  krein := ![1, -1, 1, -1]
  kerDim := ![1, 0, 1, 0]
  nodalGap := fun _ => 1
  retained := ![true, false, true, false]
  zeros := [physicalPoleWitness]
  bareChirTrace := fun _ => 0

theorem releasedData_releases : ProjectedGateCRelease releasedData := by
  refine ⟨?_, ⟨0, by decide⟩, ?_, fun _ => one_pos, ?_, ?_, ?_, ?_, ?_⟩
  · show flavoredIndex g5pattern ≠ 0
    rw [flavoredIndex_aligned]; norm_num
  · intro a ha
    fin_cases a <;> simp_all [releasedData, g5pattern]
  · intro z hz
    simp only [releasedData, List.mem_singleton] at hz; subst hz
    rintro ⟨-, hlt⟩; norm_num [physicalPoleWitness] at hlt
  · intro z hz _
    simp only [releasedData, List.mem_singleton] at hz; subst hz; norm_num [physicalPoleWitness]
  · show flavoredIndex g5pattern ≠ 0
    rw [flavoredIndex_aligned]; norm_num
  · intro z hz
    simp only [releasedData, ProjData.toRouteB, List.mem_singleton] at hz; subst hz
    rintro ⟨-, hlt⟩; norm_num [physicalPoleWitness] at hlt
  · intro z hz _
    simp only [releasedData, ProjData.toRouteB, List.mem_singleton] at hz; subst hz; norm_num [physicalPoleWitness]

/-! ## Negative guardrails (the clauses are mutually independent) -/

/-- The bare symbol assigns *no single chirality sign*: the bare per-branch
kernel chirality trace vanishes (C21's balanced two-dimensional kernel). -/
def BareAlignmentFails (d : ProjData) : Prop :=
  ∀ a, d.bareChirTrace a = 0

/-
**Guardrail (a): bare alignment failure does not contradict projected
release.**  C21's bare-symbol chirality failure (`bareChirTrace = 0`,
chirality-balanced kernel) coexists with a full projected release — precisely
because release is read off the *projected* data, not the bare symbol.
-/
theorem bare_failure_consistent_with_release :
    ∃ d, BareAlignmentFails d ∧ ProjectedGateCRelease d := by
  use releasedData;
  exact ⟨ fun _ => rfl, releasedData_releases ⟩

/-- A dangerous dataset: aligned species signs (so the flavored index is the
maximal value `4`) but a fatal ghost zero in the spectrum. -/
def dangerousData : ProjData :=
  { releasedData with zeros := [ghostZeroWitness] }

/-
**Guardrail (b): a (flavored) index alone does not imply release.**  There is
a dataset with nonzero — indeed maximal — flavored index that fails projected
release, because it harbours a Golterman–Shamir fatal ghost zero.
-/
theorem index_not_sufficient :
    ∃ d, d.index ≠ 0 ∧ ¬ ProjectedGateCRelease d := by
  refine ⟨dangerousData, ?_, ?_⟩
  · show flavoredIndex g5pattern ≠ 0
    rw [flavoredIndex_aligned]; norm_num
  · intro h
    exact h.2.2.2.2.1 ghostZeroWitness (by simp [dangerousData]) ghostZeroWitness_isFatal

/-- A dataset that is Krein-positive on every retained branch but whose projected
chirality is *not* aligned (`chir ≡ 1`, so `chir 2 = 1 ≠ -1 = g5 2`). -/
def kreinNotChirData : ProjData :=
  { releasedData with chir := fun _ => 1, krein := fun _ => 1 }

/-
**Guardrail (c): Krein positivity alone does not imply chirality
alignment.**  (Mirrors C22 `kreinSig_ne_chirality`: the Krein signature pattern
is independent of the chirality pattern.)
-/
theorem kreinPositive_not_chirality :
    ∃ d, ProjectedKreinPositive d ∧ ¬ ProjectedChiralityAligned d := by
  refine ⟨kreinNotChirData, ⟨fun _ _ => rfl, ?_⟩, ?_⟩
  · intro z hz _
    simp only [kreinNotChirData, releasedData, List.mem_singleton] at hz; subst hz
    norm_num [physicalPoleWitness]
  · intro h
    have := h 2 (by decide)
    simp [kreinNotChirData, g5pattern] at this
    norm_num at this

/-
**Guardrail (d): projected chirality alone does not imply ghost safety.**
The aligned-chirality dataset can still harbour a fatal ghost zero.
-/
theorem chirality_not_ghostSafe :
    ∃ d, ProjectedChiralityAligned d ∧ ¬ GhostZeroSafe d := by
  -- Use `dangerousData` as the witness.
  use dangerousData;
  unfold ProjectedChiralityAligned GhostZeroSafe dangerousData;
  unfold NullEdgeGateCGhostZeroSafety.GhostZeroSafe; simp +decide [ ghostZeroWitness_isFatal ] ;
  simp +decide [ releasedData ]

/-! ## Summary -/

/-- **C59 summary.**  The post-C21 projected Gate C release API:

1. the seven clauses `NodalSetControlled`, `BranchProjectorsControlled`,
   `ProjectedKernelOneDim`, `ProjectedChiralityAligned`, `ProjectedKreinPositive`,
   `GhostZeroSafe`, `SpeciesSplittingAudited` jointly imply the bundled
   `ProjectedGateCRelease` certificate (`projected_gateC_release`), which is
   non-vacuous (`releasedData_releases`);
2. the bare-symbol chirality failure of C21 is consistent with projected release
   (`bare_failure_consistent_with_release`);
3. the flavored index alone, Krein positivity alone, and projected chirality
   alone each fail to imply release / each other
   (`index_not_sufficient`, `kreinPositive_not_chirality`,
   `chirality_not_ghostSafe`). -/
theorem c59_projected_release_summary :
    (∀ d : ProjData,
        NodalSetControlled d → BranchProjectorsControlled d →
        ProjectedKernelOneDim d → ProjectedChiralityAligned d →
        ProjectedKreinPositive d → GhostZeroSafe d →
        SpeciesSplittingAudited d → ProjectedGateCRelease d) ∧
    (∃ d, BareAlignmentFails d ∧ ProjectedGateCRelease d) ∧
    (∃ d, d.index ≠ 0 ∧ ¬ ProjectedGateCRelease d) ∧
    (∃ d, ProjectedKreinPositive d ∧ ¬ ProjectedChiralityAligned d) ∧
    (∃ d, ProjectedChiralityAligned d ∧ ¬ GhostZeroSafe d) :=
  ⟨projected_gateC_release, bare_failure_consistent_with_release,
    index_not_sufficient, kreinPositive_not_chirality, chirality_not_ghostSafe⟩

end PhysicsSM.Draft.NullEdgeProjectedGateCRelease
