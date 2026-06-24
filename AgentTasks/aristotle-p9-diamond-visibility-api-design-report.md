# P9 `DiamondSourceVisibility` API — Design Report

Target file: `AgentTasks/aristotle-p9-diamond-visibility-api-design-report.md`
Scope: design + research-guidance only (no proofs). Signatures below are handoff
stubs to be discharged later by the prover lane.

---

## 0. Problem statement and falsification target

The P9 cosmological-constant / source-visibility branch already has a finite,
kernel-checked theorem spine, but every module re-defines the same primitives
(`Cochain n := Fin n → ℝ`, `dot`, `sourcePairing`, `boundarySource`, `codiff`,
`BulkClosed`, `BoundaryExact`, `closureVector`, `momentMassSq`, …) and pairs
sources against an **abstract** `unitTest : Cochain 1` or an abstract closed
bulk test. The amplitudes `amp_i` are abstract reals; the "test" carries no
geometry; and "visible" only means "nonzero pairing with *some* closed test."

This makes the central physical claim untestable as stated: there is no object
in the API that says *what a source is visible to* in geometric terms, and no
object that forces the everpresent-Λ tension (`PhysicsSM.Draft.
NullEdgeP9EverpresentLambdaTension`, `…Scaling`) to be about **diamond volume**
rather than an abstract cell count `N`.

**Falsification target (kept front and center).** The everpresent-Λ prediction
is `|Λ| ~ δN / V` with `δN ~ √V`, i.e. RMS `~ 1/√V`. The P9 suppression model
claims a *boundary-exact* (surface-supported) residual can beat this. The
geometric API must be built so that the following is a *provable or refutable*
statement, not a definitional escape hatch:

> If the only sources that are invisible to every curvature-defect observer are
> forced to scale their residual variance with **bulk volume** (`∝ V`) rather
> than **screen area** (`∝ ∂V`), then the cosmological-constant suppression
> model is falsified.

Concretely the API must let the prover compare two scaling laws *inside one
structure*: `diamondResidualVariance` of a coarse-grained source against
`cellArea`/`screenArea` (good for suppression) versus `bulkVolume` (fatal). If
the API can only express the volume law, that is the falsification.

---

## 1. Finite diamond / screen with incidence data

Replace the bare `D : Fin b → Fin f → ℝ` matrices, scattered across
`NullEdgeP9BoundarySource`, `…BFClosure`, and `…DiamondSourceVisibilityCore`,
with one record carrying the full incidence skeleton of a finite causal diamond.

```lean
/-- A finite causal-diamond screen complex: a 3-term graded incidence skeleton
    `cells (volume) → faces (screen) → boundary (rim)` together with its two
    incidence operators. Indices are `Fin _` so everything stays decidable. -/
structure DiamondScreen where
  nCell  : Nat                      -- bulk cells (volume elements)
  nFace  : Nat                      -- screen faces (codim-1 elements)
  nRim   : Nat                      -- boundary cells of the screen (codim-2)
  /-- incidence faces ← cells (∂ of the bulk, the "BF" map) -/
  bulkInc : Fin nCell → Fin nFace → ℝ
  /-- incidence rim ← faces (∂ of the screen) -/
  rimInc  : Fin nFace → Fin nRim  → ℝ
  /-- chain-complex law `∂∘∂ = 0`: rim ∘ bulk = 0 -/
  dd_zero :
    ∀ c r, (Finset.univ.sum fun fc => bulkInc c fc * rimInc fc r) = 0

abbrev DiamondScreen.CellCochain  (S : DiamondScreen) := Fin S.nCell → ℝ
abbrev DiamondScreen.FaceCochain  (S : DiamondScreen) := Fin S.nFace → ℝ
abbrev DiamondScreen.RimCochain   (S : DiamondScreen) := Fin S.nRim  → ℝ
```

`dd_zero` is exactly the existing `ChainComplex` predicate
(`NullEdgeP9DiamondSourceVisibilityCore.ChainComplex` /
`NullEdgeP9BFClosure.ChainComplex`) promoted into the structure, so the
no-bulk-source closure theorem becomes a field rather than a hypothesis floating
in each statement. The two-level `bulkInc`/`rimInc` pair is the finite analogue
of the `DiamondLabels` left/right branch data in
`PhysicsSM.Gauge.CausalDiamondHolonomy`, but in additive-cochain form.

The discrete differential and codifferential reuse the existing definitions
verbatim (just typed against the structure):

```lean
def DiamondScreen.dFace (S : DiamondScreen) (a : S.FaceCochain) : S.RimCochain :=
  fun r => Finset.univ.sum fun fc => S.rimInc fc r * a fc          -- = `boundarySource`
def DiamondScreen.codiff (S : DiamondScreen) (t : S.FaceCochain) : S.CellCochain :=
  fun c => Finset.univ.sum fun fc => S.bulkInc c fc * t fc          -- = `codiff`
```

## 2. Geometric cell weights (amplitudes become measures)

Amplitudes stop being abstract reals. A `DiamondMeasure` assigns a *positive*
geometric weight to each graded element, and the physical amplitude of a source
is read off against that measure. This is what makes "area vs volume scaling" a
statement about the *same* object.

```lean
/-- Positive geometric weights on each graded piece of the screen: a volume
    element per cell, an area element per face, a length element per rim cell. -/
structure DiamondMeasure (S : DiamondScreen) where
  cellVol  : Fin S.nCell → ℝ
  faceArea : Fin S.nFace → ℝ
  rimLen   : Fin S.nRim  → ℝ
  cellVol_pos  : ∀ c, 0 < cellVol c
  faceArea_pos : ∀ f, 0 < faceArea f
  rimLen_pos   : ∀ r, 0 < rimLen r

def DiamondMeasure.bulkVolume  (μ : DiamondMeasure S) : ℝ := Finset.univ.sum μ.cellVol
def DiamondMeasure.screenArea  (μ : DiamondMeasure S) : ℝ := Finset.univ.sum μ.faceArea

/-- Weighted (measure-aware) pairing replacing the bare Euclidean `dot`.
    `geomPairing μ source test = Σ_f area_f · source_f · test_f`. -/
def DiamondMeasure.geomPairing (μ : DiamondMeasure S)
    (source test : S.FaceCochain) : ℝ :=
  Finset.univ.sum fun f => μ.faceArea f * source f * test f

/-- A geometric amplitude of a face source = its measure-weighted value;
    this is the bridge identifying `amp_i` with an area element. -/
def DiamondMeasure.amp (μ : DiamondMeasure S) (source : S.FaceCochain)
    (f : Fin S.nFace) : ℝ := μ.faceArea f * source f
```

Setting all weights to `1` (the *uniform measure* `DiamondMeasure.unit`)
recovers the bare `dot`/`sourcePairing` of every current module, which is what
makes the bridge lemmas in §5 hold definitionally. The `uniformAmp`/
`weightedTotalSource`/`amplitudeSqSum` constructions of
`NullEdgeP9UniformSuppression` and `…WeightedFluctuation` become the special
cases `μ.faceArea ≡ A` and `μ.faceArea = amp²` respectively.

## 3. Curvature / holonomy-defect cochain (replacing `unitTest`)

The abstract `unitTest : Cochain 1` is replaced by an *observer family of
curvature defects*. A curvature defect is a closed test (zero codifferential)
built from a holonomy comparison around each face — the additive linearization
of `diamondDefect` from `PhysicsSM.Gauge.CausalDiamondHolonomy`.

```lean
/-- An (abelian/linearized) curvature defect cochain on the screen: a face test
    that is *closed*, i.e. `codiff = 0`, and is exact-of-a-loop, i.e. equals the
    coboundary-comparison of a face potential `θ`. Physically: holonomy mismatch
    around each face's two branches. -/
structure CurvatureDefect (S : DiamondScreen) where
  test    : S.FaceCochain
  closed  : S.codiff test = 0
  /-- realized as a holonomy/branch defect of a face potential -/
  potential : S.FaceCochain
  isDefect  : ∀ f, test f = potential f - (S.codiff S.dFace? potential) f  -- schematic; see note

/-- The set of curvature-defect observers. -/
def DiamondScreen.curvatureDefects (S : DiamondScreen) : Set S.FaceCochain :=
  { t | S.codiff t = 0 }

/-- A source is *visible to a curvature defect* if it pairs non-trivially with
    some closed defect test. -/
def DiamondMeasure.VisibleToCurvature (μ : DiamondMeasure S)
    (source : S.FaceCochain) : Prop :=
  ∃ t ∈ S.curvatureDefects, μ.geomPairing source t ≠ 0
```

Note on `isDefect`: the additive model takes a *defect = closed cochain* as the
honest minimal object (`closed` field), with the `potential`/holonomy realization
as the bridge to the nonabelian `diamondDefect`. The handoff theorem
`curvatureDefect_is_holonomy_linearization` (§6) connects `CurvatureDefect.test`
to `pathPairDefect` of `CausalDiamondHolonomy` in the abelian limit, so the
"unitTest" of the toy modules is recovered as the constant defect on a one-face
screen with no rim (`nRim = 0`, where *every* face cochain is closed — this is
exactly `unitTest_closed_emptyBoundary`).

## 4. Observer / coarse-graining projection (invisibility = kernel)

An observer cannot resolve individual faces; it sees a coarse-grained,
measure-averaged source over observation patches. Invisibility becomes membership
in the **kernel** of this linear observer map composed with the defect pairing.

```lean
/-- A coarse-graining of the screen into `nPatch` observation patches with a
    (row-stochastic, measure-weighted) assignment matrix. -/
structure Observer (S : DiamondScreen) (μ : DiamondMeasure S) where
  nPatch : Nat
  assign : Fin S.nFace → Fin nPatch → ℝ        -- face → patch weights
  assign_nonneg : ∀ f p, 0 ≤ assign f p

/-- The observer projection: average each source onto patches by area weight. -/
def Observer.project (O : Observer S μ) (source : S.FaceCochain)
    (p : Fin O.nPatch) : ℝ :=
  Finset.univ.sum fun f => O.assign f p * μ.faceArea f * source f

/-- Observable response = patch readings paired against the curvature defects
    the observer can actually probe. The source is *invisible to `O`* iff its
    projection lies in the kernel of every defect read-out. -/
def Observer.InvisibleTo (O : Observer S μ) (source : S.FaceCochain) : Prop :=
  ∀ t ∈ S.curvatureDefects, μ.geomPairing source t = 0
  -- equivalently: source ∈ ker (defect read-out ∘ project) for the unit observer

/-- The recoverability gap: how much of the source the observer *fails* to put
    in the defect kernel — the operator norm / Rayleigh quotient of the residual
    after projecting out boundary-exact (pure-bookkeeping) pieces. -/
def Observer.recoverabilityGap (O : Observer S μ) (source : S.FaceCochain) : ℝ :=
  sSup { μ.geomPairing source t | (t : S.FaceCochain) (_ : t ∈ S.curvatureDefects)
         (_ : μ.geomPairing t t = 1) }
```

`Observer.InvisibleTo` with the unit observer/unit measure is *exactly*
`InvisibleToClosedBulkTests` from the current core module — that identity is the
load-bearing bridge (§5). The `recoverabilityGap` is the new quantitative handle
that turns the qualitative invisibility predicate into the scaling test driving
the falsification target.

---

## 5. Bridge maps — existing finite theorems as special cases

Each current spine theorem is recovered by instantiating
`(S, μ, O) := (toyScreen, unitMeasure, unitObserver)`.

| Existing result | Specialization |
|---|---|
| `NullEdgeP9BoundarySource.boundaryExact_source_eq_zero` | `dFace` ⇒ `boundarySource`; `geomPairing` with `μ = unit` ⇒ `sourcePairing`; integration-by-parts is `geomPairing (dFace a) t = dot a (codiff t)`. |
| `NullEdgeP9DiamondSourceVisibilityCore.boundaryExact_invisible_to_closed_tests` | `BoundaryExact S source → Observer.InvisibleTo unitObserver source`. |
| `NullEdgeP9BFClosure.boundarySource_comp_eq_zero_of_chainComplex` | the `DiamondScreen.dd_zero` field. |
| `NullEdgeP9DiamondVisibility.exists_bulkVisible_not_boundaryExact` | `toyScreen` with `nRim = 0` makes every face cochain a curvature defect ⇒ non-vacuity of `VisibleToCurvature`. |
| `…Core.closed_visibleFan_mass_eq_restEnergy` / `…VisibleFanMassCharacterization` | `closureVector`/`momentMassSq` reinterpreted as the rim-image of a directional face measure; closed fan ⇔ `dFace (dir-weighted source) = 0`. |
| `…UniformSuppression` / `…WeightedFluctuation` second-moment identities | `μ.faceArea ≡ A` (uniform) and `μ.faceArea = amp²` (weighted); `diamondResidualVariance` = normalized `geomPairing source source`. |
| `…EverpresentLambdaScaling` / `…Tension` | `bulkVolume μ = V`, `screenArea μ = ∂V`; the `N` of `uniformSecondMoment` becomes `μ`-cardinality, exposing the area-vs-volume comparison. |

Bridge lemma stubs:

```lean
/-- The geometric pairing under the unit measure is the legacy `sourcePairing`. -/
theorem geomPairing_unit_eq_sourcePairing (S : DiamondScreen)
    (source test : S.FaceCochain) :
    (DiamondMeasure.unit S).geomPairing source test
      = NullEdgeP9DiamondSourceVisibilityCore.sourcePairing source test := by sorry

/-- Legacy boundary-exact ⇒ kernel of the unit observer. -/
theorem boundaryExact_imp_invisible (S : DiamondScreen)
    (source : S.FaceCochain) (h : ∃ a, source = S.dFace a) :
    (Observer.unit S).InvisibleTo source := by sorry

/-- The closed visible fan rest-energy theorem as a `DiamondScreen` statement. -/
theorem closedFan_restEnergy_bridge {n : Nat} (weight : Fin n → ℝ)
    (dir : Fin n → (Fin 3 → ℝ))
    (hclosure : NullEdgeP9DiamondSourceVisibilityCore.closureVector weight dir = 0) :
    NullEdgeP9DiamondSourceVisibilityCore.momentMassSq weight dir
      = NullEdgeP9DiamondSourceVisibilityCore.totalEnergy weight ^ 2 / 4 := by sorry
```

---

## 6. Handoff theorem signatures (next 5–8, no proofs)

These are the statements the API should make *provable*. Listed with the three
mandated names first.

```lean
/-- 1. THE central equivalence: a source is invisible to every curvature-defect
    observer iff it is boundary-exact (pure screen-bookkeeping). Forward = legacy
    `boundaryExact_invisible_to_closed_tests`; reverse is the new content
    (Hodge/exactness of the finite complex). -/
theorem boundaryExact_iff_invisible_to_curvatureDefects
    (S : DiamondScreen) (μ : DiamondMeasure S) (source : S.FaceCochain) :
    (∃ a : S.RimCochain, source = S.coDFace a)
      ↔ ¬ μ.VisibleToCurvature source := by sorry

/-- 2. Residual variance of a coarse-grained source scales with cell AREA, not
    volume — the suppression-favorable law. The normalized second moment of an
    area-uniform source over the screen is `(Σ area)·c / screenArea = O(area)`. -/
theorem diamondResidualVariance_scales_with_cellArea
    (S : DiamondScreen) (μ : DiamondMeasure S) (O : Observer S μ)
    (source : S.FaceCochain) (hsurf : ∃ a, source = S.coDFace a) :
    O.diamondResidualVariance source
      = (Finset.univ.sum fun f => μ.faceArea f * source f ^ 2) / μ.screenArea := by sorry

/-- 3. The recoverability gap upper-/lower-bounds source visibility: a source is
    visible to some curvature defect iff its recoverability gap is strictly
    positive, and the gap controls the maximal observable response. -/
theorem recoverabilityGap_controls_sourceVisibility
    (S : DiamondScreen) (μ : DiamondMeasure S) (O : Observer S μ)
    (source : S.FaceCochain) :
    (0 < O.recoverabilityGap source ↔ μ.VisibleToCurvature source)
      ∧ (∀ t ∈ S.curvatureDefects, μ.geomPairing t t = 1 →
           μ.geomPairing source t ≤ O.recoverabilityGap source) := by sorry

/-- 4. THE FALSIFICATION DICHOTOMY: any source invisible to all defects has its
    residual variance bounded by the screen-area law; conversely if invisibility
    forced a volume law the model is refuted. States both sides so the prover
    must land on one. -/
theorem invisibleResidual_area_not_volume
    (S : DiamondScreen) (μ : DiamondMeasure S) (O : Observer S μ)
    (source : S.FaceCochain) (hinv : O.InvisibleTo source) :
    O.diamondResidualVariance source ≤ μ.screenArea⁻¹ * (legacyTotalResidual source)
      ∧ ¬ (O.diamondResidualVariance source = μ.bulkVolume⁻¹ * (legacyTotalResidual source)
            ∧ μ.bulkVolume ≠ μ.screenArea) := by sorry

/-- 5. Curvature defects are the abelian linearization of diamond holonomy: each
    `CurvatureDefect.test` equals the additive `pathPairDefect` of a
    `CausalDiamondHolonomy.PathPair` over the additive group `(ℝ,+)`. -/
theorem curvatureDefect_is_holonomy_linearization
    (S : DiamondScreen) (d : CurvatureDefect S) :
    ∃ P : Fin S.nFace → PathPair (Multiplicative ℝ),
      ∀ f, d.test f = Additive.toMul.symm (pathPairDefect (P f)) := by sorry

/-- 6. Observer composition / coarse-graining functoriality: refining an observer
    can only shrink the invisible kernel (more resolution ⇒ fewer invisible
    sources), so invisibility is monotone in coarse-graining. -/
theorem invisibleKernel_antitone_in_refinement
    (S : DiamondScreen) (μ : DiamondMeasure S) (O O' : Observer S μ)
    (href : O'.Refines O) (source : S.FaceCochain) :
    O'.InvisibleTo source → O.InvisibleTo source := by sorry

/-- 7. Everpresent-Λ bridge inside the geometric API: the everpresent residual
    second moment equals `bulkVolume`, the suppressed one equals
    `screenArea`-normalized; suppression beats everpresence iff `screenArea`
    is sub-extensive in `bulkVolume`. Recovers `…EverpresentLambdaTension`. -/
theorem everpresentLambda_geometric_tension
    (S : DiamondScreen) (μ : DiamondMeasure S)
    (hsub : μ.screenArea < μ.bulkVolume) :
    suppressedResidualVariance S μ < everpresentResidualVariance S μ := by sorry

/-- 8. Mean-zero defect cancellation as antisymmetry of the rim involution:
    a source antisymmetric under a screen reflection pairs to zero with every
    symmetric curvature defect. Recovers `meanZero_of_equiv_antisymm`. -/
theorem meanZeroDefect_of_screen_involution
    (S : DiamondScreen) (μ : DiamondMeasure S)
    (τ : Equiv (Fin S.nFace) (Fin S.nFace)) (source : S.FaceCochain)
    (hanti : ∀ f, source (τ f) = - source f) :
    Finset.univ.sum (fun f => μ.faceArea f * source f) = 0 := by sorry
```

---

## 7. Next targets and lane priority

**Suggested build order (bottom-up).**
1. Land the structures (`DiamondScreen`, `DiamondMeasure`, `Observer`,
   `CurvatureDefect`) + the `unit` instances. No proofs, just `#check` clean.
2. Discharge the three definitional bridge lemmas in §5 (these are `rfl`/`simp`
   away from existing modules — fast wins that lock the API to the spine).
3. Prove handoff #1 forward direction (reuse
   `boundaryExact_invisible_to_closed_tests`), then the reverse (genuinely new:
   finite exactness of the 3-term complex — this is the keystone).
4. Prove #2, #3 (algebra over the finite sums; moderate).
5. Tackle #4/#7 — the falsification dichotomy and everpresent tension; these are
   where the physics verdict lives.
6. #5, #6, #8 are independent and can be parallelized once structures land.

**Lane priority evaluation.**
- **PROMOTE** the *geometric-API core* lane (handoffs #1–#4). It converts the
  abstract spine into a testable structure and is where the falsification
  verdict is decided. Highest information value per proof.
- **CONTINUE** the *holonomy-linearization* lane (#5, the
  `CausalDiamondHolonomy` connection) and the *everpresent-tension* lane (#7):
  both are well-scoped, build on already-proven modules, and are good
  parallel-subagent fodder.
- **DEMOTE** the standalone abstract toy modules
  (`NullEdgeP9DiamondVisibility`, `…VisibleClosureSource`,
  `…NoncollinearMassNogo`) to *legacy/bridge-only* status: keep them as the
  sources of the §5 specializations, but stop adding new abstract theorems to
  them — new results should be stated on `DiamondScreen`.

---

## 8. Summary (requested shape)

```text
overall assessment:
  The P9 spine is algebraically solid but geometrically abstract: every module
  re-derives the same Fin n cochain primitives and pairs sources against an
  abstract unitTest, so the cosmological-constant claim is not yet falsifiable
  inside the formalism. A single DiamondScreen / DiamondMeasure / Observer /
  CurvatureDefect API unifies the duplicated primitives, makes amplitudes
  geometric (area/volume measures), replaces unitTest with closed
  curvature-defect observers, and recasts invisibility as membership in an
  observer kernel. Crucially it puts the area-law (suppression-favorable) and
  volume-law (fatal) residual scalings inside one structure, so the falsification
  target becomes a provable/refutable dichotomy rather than a definitional
  escape. Recommended: build the API now; the existing spine becomes special
  cases via cheap (often rfl) bridge lemmas.

proposed core definitions:
  - DiamondScreen        (nCell/nFace/nRim incidence skeleton with ∂∘∂ = 0)
  - DiamondScreen.dFace / codiff / coDFace (graded differentials)
  - DiamondMeasure       (positive cellVol/faceArea/rimLen; bulkVolume, screenArea)
  - DiamondMeasure.geomPairing / amp / VisibleToCurvature
  - CurvatureDefect      (closed face test, holonomy-realized; replaces unitTest)
  - Observer             (coarse-graining projection; InvisibleTo = kernel;
                          recoverabilityGap, diamondResidualVariance)

bridge lemmas to existing theorems:
  - geomPairing_unit_eq_sourcePairing      (unit measure = legacy dot)
  - boundaryExact_imp_invisible            (legacy core, re-typed)
  - closedFan_restEnergy_bridge            (momentMassSq via dFace closure)
  - dd_zero field                          (= ChainComplex / BFClosure)
  - uniform/weighted second-moment specializations (UniformSuppression,
    WeightedFluctuation) via faceArea ≡ A and faceArea = amp²
  - everpresent/tension specialization     (bulkVolume = V, screenArea = ∂V)

ranked next theorem signatures:
  1. boundaryExact_iff_invisible_to_curvatureDefects   (keystone; reverse is new)
  2. invisibleResidual_area_not_volume                 (falsification dichotomy)
  3. recoverabilityGap_controls_sourceVisibility       (quantitative visibility)
  4. diamondResidualVariance_scales_with_cellArea      (area law)
  5. everpresentLambda_geometric_tension               (named-prediction bridge)
  6. curvatureDefect_is_holonomy_linearization         (Gauge module connection)
  7. invisibleKernel_antitone_in_refinement            (coarse-graining functor)
  8. meanZeroDefect_of_screen_involution               (cancellation, easy)

likely blockers:
  - Reverse of #1 needs finite exactness (discrete Hodge) of the 3-term complex;
    requires a rim-potential reconstruction, the one genuinely new lemma.
  - recoverabilityGap uses sSup over a constrained set; needs nonempty/bounded
    witnesses (BddAbove, Set.Nonempty) or a reformulation via an explicit
    orthonormal defect basis to stay constructive.
  - The area-vs-volume dichotomy depends on relating screenArea to bulkVolume
    through the incidence operators; without a discrete isoperimetric input the
    bound may only be conditional (state hsub : screenArea < bulkVolume as a
    hypothesis, as done in everpresentLambda_geometric_tension).
  - Holonomy linearization (#5) mixes multiplicative G and additive ℝ; use
    Additive/Multiplicative and keep the abelian limit explicit.
  - Coercion hygiene: keep cardinalities/volumes in ℝ from the start; avoid
    ZMod and Fin-index arithmetic in types.

integration notes:
  - Place the API in a new PhysicsSM/Draft/NullEdgeP9DiamondScreen.lean (or a
    Geometry/ subdir) with `import Mathlib`; re-export the legacy abbrevs so
    downstream modules compile unchanged.
  - Demote the abstract toy modules to bridge-only; state all new results on
    DiamondScreen.
  - Provide `DiamondScreen.toy1`, `DiamondMeasure.unit`, `Observer.unit` instances
    so each legacy theorem has a one-line specialization; verify with lean_build
    on the new module name explicitly (it is not yet a default target).
  - Keep the falsification dichotomy (#2/#4) phrased as a two-sided statement so
    the prover lane must resolve the physics verdict rather than pick a vacuous
    side.
```
