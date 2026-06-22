# Null-edge grand strategy v2 — Aristotle roadmap output

Date: 2026-06-22
Mode: strategy / scaffold only. No repository build was performed (per the v2
prompt's "do not build the whole repository" instruction). The trusted anchor
modules and the most recently integrated draft islands were read directly.

This document answers the five deliverables of
`AgentTasks/aristotle-grand-strategy-v2-prompt-20260621.md`:

1. a ranked roadmap of the next 10–20 Aristotle proof jobs;
2. per-cluster module name, declaration sketches, definitions, repo
   dependencies, mathlib dependencies, proof strategy, semantic/convention
   risk, and standalone-vs-full-repo recommendation;
3. a dependency graph;
4. a "do not submit yet" list;
5. an assessment of whether the program has enough formal spine for a
   publishable finite-math paper and which cluster most improves it.

Non-compiling Lean scaffolds with labelled handoff points live under
`PhysicsSM/Draft/NullEdgeRoadmap/`. They are planning artifacts, not trusted
modules. See `PhysicsSM/Draft/NullEdgeRoadmap/README.md`.

---

## 0. What is already banked (corrected inventory)

The v1 roadmap predates several integrations. A direct re-read of the package
shows the following are **already kernel-clean draft islands or trusted
modules**, so they should *not* be re-submitted:

Trusted:

- `PhysicsSM.Spinor.PluckerMass` — finite bundle determinant mass
  `det(Σ ψ_i ψ_i^†) = Σ_{i<j}|ψ_i ∧ ψ_j|²`, real nonnegativity
  (`fin_bundle_det_eq_ofReal_nonneg`, `fin_bundle_det_re_nonneg`,
  `fin_bundle_det_im_eq_zero`), and the zero-mass/common-direction criterion.
  The "determinant-is-nonnegative-real" milestone the v1 ledger queued
  (`det-nonneg`) is **done** here — do not re-open it.
- `PhysicsSM.Gauge.CausalDiamondHolonomy` — Abelian invariance, non-Abelian
  endpoint covariance, class-function invariance, vertical/horizontal path-pair
  composition laws.
- `PhysicsSM.Gauge.OrderComplexCochain` — `∂∂=0`, cochain `d²=0`, cohomology
  equivalence relation. This is the order-complex seed.

Kernel-clean draft islands (verify provenance before promoting, but the math is
banked):

- `NullEdgeDiracSlashCore`, `NullEdgeBundleDiracPluckerCore` — static chiral
  slash squares to the Minkowski/Pluecker scalar
  (`chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass`). The v1 `static-spine`
  target is essentially landed.
- `NullEdgeSuperDiracBlockCore`, `NullEdgeSuperconnectionExpansionCore` —
  off-diagonal `D` squares to block-diagonal Laplacian + Higgs/cross blocks;
  chirality anticommutation; no-cross corollaries.
- `NullEdgeCovariantDifferentialCore` — finite `d_U² = curvature`.
- `NullEdgeDiracTwoSheetCore`, `NullEdgeDiracMassShellProjectorsCore` —
  two-sheet projectors `½(I ± m⁻¹D)`, mass-shell branch projectors.
- `TopologicalDiracBianconi` — `D=d+δ`, `D²=` Hodge Laplacian,
  `{γ,D}=0`, gapped eigenvalue `gappedDirac_eigenvalue`. The v1
  `topological-dirac` target (`topological_dirac_sq_eq_laplacian`) is **done**
  as linear-map algebra; what remains is *placing it on a concrete causal order
  complex* (assembly), not re-proving the square.
- `NullEdgeCelestialMomentWrapper` — abstract celestial moment algebra:
  `angularVarianceMass_eq_chordalPairMass`,
  `angularVarianceMass_zero_iff_dipoleSaturates` over `Vec3` weighted
  directions. The wrapper exists but is **not yet bridged** to the trusted
  `finBundleMomentum` determinant. That bridge is open (Cluster A).
- `NullEdgeCelestialMixednessAristotle` — `visibleReducedDensity`,
  `visibleReducedDensity_det_eq_plucker`,
  `normalizedVisibleDensity_det_eq_plucker_over_trace_sq`, Bloch density
  identities. The reduced-density *determinant* layer is banked; the real
  `m/E = 2√det ρ_vis` proper-time wrapper and the concurrence assembly are open
  (Cluster E).
- `NullEdgeQubitConcurrence` — `linearEntropyComplex_eq_concurrenceSq_of_trace_one`,
  `normalized_mass_ratio_eq_concurrence`, `*_sq_eq_four_det`.
- `NullEdgeDecoherenceChannelAristotle`, `NullEdgeTwoTwistorHiddenChannelAristotle` —
  hidden-coherence mass gap, isometric hidden-basis invariance, partial
  coherence. The *affine-Bloch CPTP* channel formalism is **not** here
  (Cluster B).
- `NullEdgeGramWeightedMassAristotle`, `NullEdgeGramWeightedOperator`,
  `NullEdgeGramWeightedHermitian` — Cauchy–Binet `det(MGM†)=w†(Λ²G)w`,
  PSD transfer, Hermiticity.
- `NullEdgeSpinorGeometryTargets` — Lagrange identity, SL(2) invariance of
  Pluecker mass (`finPairwisePluckerMass_sl2_invariant`), twistor chart
  wrappers.
- `NullEdgePathPairInterchange` — `pathPairDefect_interchange` (the v1/Stage-2
  item 20 is **proved**); `pathPairDefect_grid_comm`.
- `NullEdgePhysicsBridgeAristotle` — observable-nullity diagnostics
  (`quotient_incidence_internal_edge_eq_zero`,
  `exact_two_step_cycle_holonomy_trivial`, `homology_null_boundary_chain`),
  chiral mass square on eigenvector.
- `NullEdgeCochainDiamond` — cochain `d²=0` seed.

**Net correction to the v1 ledger.** Of the v1 "next jobs", `det-nonneg`,
`static-spine`, `topological-dirac` (as algebra), and `pathpair-interchange` are
already satisfied. The remaining high-value *open* work concentrates exactly on
the eight v2 priorities, plus one structural debt (definition consolidation).

---

## 1. Ranked roadmap — next jobs

Ranking criterion: (decisive finite theorem) × (low convention risk) ×
(uses already-banked anchors) ÷ (new definitions required). "Forces a
constraint" beats "restates a square".

| # | Cluster | Job | Kind | Status leverage |
|---|---|---|---|---|
| 1 | A | Spinor-network closure / celestial moment-map identity bridge | focused standalone | bridges two banked islands; cheapest decisive theorem |
| 2 | C | Pairwise Klein-quadric / simplicity-defect wrapper | focused standalone | `B∧B=0 ↔ Pluecker masslessness`; one convention audit |
| 3 | E | Reduced-density real proper-time-rate + concurrence assembly | focused standalone | promotes `m/E=2√det ρ` over banked det layer |
| 4 | D | Crossed-module / fake-flatness layer over path-pair interchange | focused standalone | interchange already proved; pure group algebra |
| 5 | B | Affine-Bloch CPTP celestial-channel dynamics | focused standalone | mass ratio `√(1−|r|²)`; l=1 generator spectral |
| 6 | H | Definition-consolidation semantic audit (`NullEdge/Core`) | design pass (no landed code) | removes ~5 duplicate `CSpinor`/`rankOneHermitian`/Bloch copies |
| 7 | F | Causal super-Dirac order-complex *assembly* `D_{U,Φ}` | focused standalone (deps) | glues banked block/Bianconi/covariant cores onto one complex |
| 8 | G | Diamond source-visibility *definitions* + sharp failure lemma | design + 1 focused proof | closure→source; sharp falsification mode |
| 9 | C′ | Positive-Grassmannian / Pluecker-minor stratification | focused standalone | only after real ordered sector defined |
| 10 | F′ | Finite spectral-triple audit of `D_{U,Φ}` | design + focused | first-order condition forces Yukawa legality |
| 11 | B′ | l=1 relaxation gap as channel/generator spectral target | focused standalone | depends on B; sharpens flip-rate conjecture |
| 12 | G′ | Discrete ANEC/QNEC positivity gate for diamond source | focused standalone | depends on G defs |
| 13 | E′ | Gram-weighted reduced-density (nonorthogonal labels) wrapper | focused standalone | extends E to coherent internal labels |
| 14 | D′ | `edgeNeighbor_N` finite locality relation + monotonicity | focused standalone | independent; small |

Jobs 1–5 are the "do these next" tranche: each is a single decisive finite
theorem resting on banked anchors with bounded convention risk. Jobs 6–8 unlock
the structural backbone. Jobs 9–14 are second-wave.

---

## 2. Theorem clusters in detail

Convention baseline for every cluster (the Stage-0 table, copied so jobs do not
drift): metric `(+---)`; visible spinors are complex two-spinors
`CSpinor := Fin 2 → ℂ`; `rankOneHermitian ψ = vecMulVec ψ (star ψ)`;
`spinorWedge ψ φ = ψ0 φ1 − ψ1 φ0`; mass-square convention `m² = det P` (never
silently mixed with the trace-pairing `P² = 2 det P · …`); Pauli order
`σx,σy,σz` with `σy = [[0,−i],[i,0]]`. Irrep split: scalar Pluecker bracket
lives in `Λ²S ≅ ℂ`; self-dual curvature in `Sym²S ≅ Λ²₊`; visible momentum in
`S⊗S̄`; the genuine bivector/Klein arena is `Λ²ℂ⁴`.

### Cluster A — Spinor-network closure / celestial moment-map identity  ★ top job

**Module:** `PhysicsSM/Draft/NullEdgeRoadmap/SpinorNetworkClosure.lean`
(scaffold provided).

**Purpose.** Promote the existing abstract celestial moment wrapper to a
theorem *about the trusted bundle momentum*: the Pluecker determinant mass is
the energy/closure-vector Casimir
`m² = ¼((Σ_i w_i)² − |C|²)`, with `C = Σ_i w_i n_i` the moment-map closure
vector and `w_i = |ψ_i|²`. Then separate visible momentum closure from BF face
closure and internal bookkeeping closure.

**Definitions needed.**

```lean
def blochVector (M : Matrix (Fin 2) (Fin 2) ℂ) : Fin 3 → ℝ      -- (2x,2y,2z)
def hermTrace   (M : Matrix (Fin 2) (Fin 2) ℂ) : ℝ              -- Re(M00+M11)
def closureVector {n} (psi : Fin n → CSpinor) : Fin 3 → ℝ       -- blochVector ∘ finBundleMomentum
def totalEnergy  {n} (psi : Fin n → CSpinor) : ℝ                -- Σ |ψ_i|²
```

**Theorem statements (near-exact).**

```lean
-- 2×2 Hermitian moment-map identity (pure linear algebra)
theorem hermitian_det_eq_energy_sq_sub_bloch_sq
    (M : Matrix (Fin 2) (Fin 2) ℂ) (hM : M.IsHermitian) :
    (M.det).re = ¼ * ((hermTrace M)^2 - ‖blochVector M‖²)

-- bundle specialization through the trusted determinant theorem
theorem pluckerMass_eq_energy_sq_sub_closureDefect_sq {n} (psi : Fin n → CSpinor) :
    PluckerMass.finPairwisePluckerMassReal psi
      = ¼ * ((totalEnergy psi)^2 - ‖closureVector psi‖²)

-- rest frame ⇔ closure
theorem closed_spinorFan_is_restFrame {n} (psi : Fin n → CSpinor) :
    closureVector psi = 0 ↔ (totalEnergy psi)^2 = 4 * PluckerMass.finPairwisePluckerMassReal psi
```

**Repo dependencies.** `Spinor.PluckerMass` (det = pairwise mass, real, ≥0);
optional re-export to `NullEdgeCelestialMomentWrapper` for the
angular-variance/dipole-saturation forms already proved there.

**Mathlib.** `Matrix.det_fin_two`, `Matrix.IsHermitian`, `Complex.normSq`,
`Fin.sum_univ_two`, `EuclideanSpace`/`Fin 3 → ℝ` norm or an explicit `normSq3`
(the wrapper already uses `normSq3`; reuse it to stay convention-aligned).

**Proof strategy.** For the Hermitian identity, expand `det_fin_two`, use
`M10 = conj M01` and `M00,M11 ∈ ℝ`, then `ring`/`nlinarith` on real parts. For
the bundle theorem, rewrite via `fin_bundle_det_eq_ofReal_pluckerMassReal` and
the Hermiticity of `finBundleMomentum` (each `rankOneHermitian` is Hermitian;
sum of Hermitian is Hermitian — `Matrix.IsHermitian.add`). Then `totalEnergy`
and `closureVector` are literally `hermTrace` and `blochVector` of the bundle.

**Semantic / convention risk.** Low. The only risk is the Bloch normalization
factor (program states `m² = ¼((Σw)²−|C|²)`; the factor `¼` and the `2x,2y,2z`
Bloch convention must agree). Keep `m² = det P` and do **not** divide trace into
the closure unless explicitly normalizing — the program warns that closure
`C=0` is a *rest-frame* condition, not masslessness.

**Standalone vs full-repo.** Standalone (import only `Spinor.PluckerMass`).

### Cluster B — Affine-Bloch CPTP celestial-channel dynamics

**Module:** `PhysicsSM/Draft/NullEdgeRoadmap/CelestialChannelDynamics.lean`.

**Purpose.** The banked decoherence/hidden-channel files are *static*. The
program's dynamical form is a CPTP channel acting affinely on the Bloch ball,
`r ↦ T r + t`, with mass ratio `√(1−|r|²)`. Encode the affine action and the
mass-ratio contraction, then state l=1 relaxation as a spectral property of `T`.

**Definitions needed.**

```lean
structure BlochChannel where
  T : Matrix (Fin 3) (Fin 3) ℝ      -- linear part
  t : Fin 3 → ℝ                     -- translation
def applyBloch (Φ : BlochChannel) (r : Fin 3 → ℝ) : Fin 3 → ℝ   -- T r + t
def massRatioOfBloch (r : Fin 3 → ℝ) : ℝ := Real.sqrt (1 - ‖r‖²)
def IsUnitalContraction (Φ : BlochChannel) : Prop               -- t = 0 ∧ ‖T‖ ≤ 1 (operator norm)
```

**Theorem statements (handoff).**

```lean
-- visible unitaries (rotations, t=0, T ∈ SO(3)) preserve |r| and hence m/E
theorem unitary_channel_preserves_massRatio (Φ : BlochChannel)
    (hΦ : Φ.t = 0) (hO : Φ.T ∈ Matrix.orthogonalGroup (Fin 3) ℝ) (r) :
    massRatioOfBloch (applyBloch Φ r) = massRatioOfBloch r
-- depolarizing / contracting unital channels do not decrease the mass ratio
theorem unital_contraction_massRatio_monotone (Φ : BlochChannel)
    (hΦ : IsUnitalContraction Φ) (r) (hr : ‖r‖ ≤ 1) :
    massRatioOfBloch r ≤ massRatioOfBloch (applyBloch Φ r)
```

**Repo dependencies.** Bloch density identities in
`NullEdgeCelestialMixednessAristotle` (`blochDensity_det_eq_one_sub_radius_sq`)
to tie `det ρ = ¼(1−|r|²)` to `massRatioOfBloch`.

**Mathlib.** `Matrix.orthogonalGroup`, operator/`Real.sqrt` monotonicity
(`Real.sqrt_le_sqrt`), `Finset`/`EuclideanSpace` norms.

**Proof strategy.** Orthogonal `T` preserves `‖r‖` (`Matrix.mem_orthogonalGroup`
→ inner-product preservation). For monotonicity, `IsUnitalContraction ⇒
‖T r‖ ≤ ‖r‖ ⇒ 1−‖Tr‖² ≥ 1−‖r‖² ⇒ sqrt mono`.

**Semantic / convention risk.** Medium. Full CPTP ⇔ "complete positivity" is
*more* than `‖T‖ ≤ 1`; do **not** claim the affine map is CPTP — only that the
stated contraction class behaves monotonically. The l=1 spectral-gap claim is a
genuine physics conjecture; keep it as a *definition + named target* (`B′`), not
a theorem, until a concrete generator is fixed. Monotonicity must be advertised
only for the unital/LOCC class, matching the program's stated boundary.

**Standalone vs full-repo.** Standalone (import the mixedness draft).

### Cluster C — Pairwise Klein-quadric / simplicity-defect wrapper

**Module:** `PhysicsSM/Draft/NullEdgeRoadmap/KleinQuadricSimplicity.lean`.

**Purpose.** State the program's slogan
`decomposable bivector ↔ Pluecker relation ↔ Klein quadric ↔ simplicity` as a
finite theorem at the pairwise level, and identify the single-bivector
simplicity condition `B∧B=0` with the trusted two-edge masslessness criterion.
Keep `Λ²S` (scalar bracket) separate from `Sym²S` curvature.

**Definitions needed.**

```lean
abbrev Bivector := Fin 6 → ℂ                              -- Plücker coords of Λ²ℂ⁴ basis
def kleinForm (B : Bivector) : ℂ                          -- B01 B23 − B02 B13 + B03 B12
def IsSimple (B : Bivector) : Prop := kleinForm B = 0
def bivectorOfSpinorPair (psi phi : CSpinor) : Bivector   -- decomposable B = u∧v image
```

**Theorem statements.**

```lean
-- a 2-form built from two vectors is always on the Klein quadric
theorem decomposable_is_simple (u v : Fin 4 → ℂ) :
    IsSimple (wedge4 u v)
-- pairwise null-edge masslessness is the single-bivector simplicity defect
theorem massless_iff_repeated_principal_spinor (psi phi : CSpinor)
    (h : psi 0 ≠ 0 ∨ psi 1 ≠ 0) :
    (PluckerMass.twoEdgeMomentum psi phi).det = 0
      ↔ ∃ c : ℂ, phi = c • psi
-- and this is exactly the B∧B=0 simplicity condition for the fan bivector
theorem twoEdge_mass_eq_klein_simplicityDefect (psi phi : CSpinor) :
    (PluckerMass.twoEdgeMomentum psi phi).det
      = PluckerMass.complexAbsSq (PluckerMass.spinorWedge psi phi)
```

**Repo dependencies.** `Spinor.PluckerMass.two_edge_mass_zero_iff_wedge_zero`,
`spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero`,
`two_edge_plucker_mass_identity` (the last theorem above is *already* this).

**Mathlib.** `Matrix.det_fin_two`, basic `Finset` algebra; no deep geometry.

**Proof strategy.** `massless_iff_repeated_principal_spinor` is a thin restatement
of two banked lemmas composed. `decomposable_is_simple` is a direct `ring`
expansion of the antisymmetrized `wedge4`. The honest novelty is the *bridge*
identifying the Pluecker bracket with the Klein form on the decomposable locus.

**Semantic / convention risk.** Medium-high on *vocabulary*, low on *math*. The
Klein form sign pattern and the `Λ²ℂ⁴` basis ordering must be fixed once and
cited. Do **not** claim `n>2` bundles are single simple bivectors — the program
is explicit that the multi-edge case must go through closure (Cluster A), not a
single `B`. Keep `Λ²S` bracket distinct from `Sym²S` self-dual curvature; the
EPRL/FK *linear* simplicity constraint is the right continuum match, and the
older quadratic Barrett–Crane form is **not** the target.

**Standalone vs full-repo.** Standalone.

### Cluster D — Crossed-module / fake-flatness over path-pair interchange

**Module:** `PhysicsSM/Draft/NullEdgeRoadmap/CrossedModuleFakeFlatness.lean`.

**Purpose.** `pathPairDefect_interchange` is already proved. Build the
2-group/crossed-module layer it licenses: a crossed module `(∂ : H → G, ▷)`,
the fake-curvature/fake-flatness condition for a labelled diamond, and the
statement that interchange + fake-flatness make surface transport well defined
on a `2×2` grid.

**Definitions needed.**

```lean
structure CrossedModule (G H : Type*) [Group G] [Group H] where
  boundary : H →* G
  act : G → H → H                            -- G acts on H by automorphisms
  peiffer : ∀ h k, act (boundary h) k = h * k * h⁻¹
  equivariant : ∀ g h, boundary (act g h) = g * boundary h * g⁻¹
def FakeFlat (X : CrossedModule G H) (surf : H) (P : PathPair G) : Prop :=
  X.boundary surf = pathPairDefect P
```

**Theorem statements (handoff).**

```lean
theorem fakeFlat_vertical_compose (X : CrossedModule G H) ...
    (h1 : FakeFlat X s P) (h2 : FakeFlat X t Q) :
    FakeFlat X (s * X.act P.left t) (verticalComposePathPair P Q)   -- 2-group whiskering
theorem fakeFlat_interchange (X : CrossedModule G H) (P Q R S : PathPair G) ... :
    -- the two bracketings of a 2×2 grid produce equal G-defect (already) and
    -- equal H-surface labels under the crossed-module action
    True   -- handoff: exact surface equality is the open proof body
```

**Repo dependencies.** `Gauge.CausalDiamondHolonomy`
(`pathPairDefect`, `verticalComposePathPair`, `horizontalComposePathPair`,
`pathPairDefect_verticalCompose`), `NullEdgePathPairInterchange`.

**Mathlib.** `MonoidHom`, `Group` conjugation lemmas; possibly
`Mathlib`'s nascent 2-group/`CrossedModule`? — **verify**; if absent, define
locally (small).

**Proof strategy.** Peiffer + equivariance reduce the surface-composition
goals to group rewriting matching the *already proved* defect composition law
`pathPairDefect_verticalCompose`. The vertical law has the conjugation
correction `Q.left⁻¹ · defect P · Q.left`; the crossed-module action `▷` is
exactly that correction, so fake-flatness is preserved by construction.

**Semantic / convention risk.** Medium. The Peiffer identity orientation and
left-vs-right action must match the existing `verticalCompose` conjugation side.
Whether the *full* interchange of surface labels holds (not just the boundary
defect) is the genuine open question the program asked to record — if it fails,
**bank the obstruction** rather than weakening to `True`.

**Standalone vs full-repo.** Standalone (import the gauge module).

### Cluster E — Reduced-density real proper-time-rate + concurrence assembly

**Module:** `PhysicsSM/Draft/NullEdgeRoadmap/ReducedDensityConcurrence.lean`.

**Purpose.** The banked layer proves `det(visibleReducedDensity) = Pluecker`
and the normalized det formula, and `NullEdgeQubitConcurrence` proves the
trace-one concurrence identity. The missing physics-facing wrapper is the
**real** equation `m/E = 2√det ρ_vis = concurrence`, valid under exact trace
normalization and `det ρ ≥ 0`, with the LOCC/local-channel monotonicity
*boundary* stated honestly.

**Definitions needed.** Reuse `normalizedVisibleDensity`,
`visibleTrace`, `NullEdgeQubitConcurrence.normalizedMassRatioFromDet`. Add:

```lean
def properTimeRate {n} (psi : Fin n → CSpinor) : ℝ      -- 2 * Real.sqrt (det ρ_vis).re
```

**Theorem statements.**

```lean
theorem properTimeRate_eq_two_sqrt_det_visibleDensity {n} (psi : Fin n → CSpinor)
    (hE : (visibleTrace psi).re ≠ 0) :
    properTimeRate psi
      = 2 * Real.sqrt ((normalizedVisibleDensity psi).det.re)
theorem properTimeRate_eq_concurrence {n} (psi : Fin n → CSpinor) (hE : …) :
    properTimeRate psi
      = NullEdgeQubitConcurrence.qubitConcurrenceFromDet
          ((normalizedVisibleDensity psi).det.re)
-- monotonicity ONLY under an explicit local/LOCC hidden-channel hypothesis
theorem properTimeRate_monotone_under_local_channel {n}
    (Φ : LocalHiddenChannel) (psi) (h : Φ.IsLOCC) : … 
```

**Repo dependencies.** `NullEdgeCelestialMixednessAristotle`
(`normalizedVisibleDensity_det_eq_plucker_over_trace_sq`,
`visibleReducedDensity_det_re_nonneg`), `NullEdgeQubitConcurrence`.

**Mathlib.** `Real.sqrt`, `Real.sqrt_mul`, `Complex.ofReal` machinery.

**Proof strategy.** The first two are real-`sqrt` algebra over the banked det
identities. The monotonicity theorem is the **risk point**: it must carry the
LOCC hypothesis as an explicit predicate (Cluster B's channel class) — the
program is emphatic that entangling hidden channels can *increase* concurrence,
so a bare monotonicity claim is false. State the safe direction only.

**Semantic / convention risk.** Medium. `det ρ ≥ 0` requires `ρ` actually PSD;
the banked file proves `det.re ≥ 0` but not Hermiticity/PSD of the normalized
density in full generality — confirm trace `> 0` and Hermiticity hypotheses are
threaded, or restrict to the genuinely-density case. Do not silently assume
orthonormal internal labels (that is Cluster E′ vs the coherent case).

**Standalone vs full-repo.** Standalone.

### Cluster F — Causal super-Dirac order-complex assembly `D_{U,Φ}`

**Module:** `PhysicsSM/Draft/NullEdgeRoadmap/CausalSuperDiracAssembly.lean`.

**Purpose.** All the *pieces* exist (block square, superconnection expansion,
covariant `d_U²=curvature`, Bianconi `D²=Laplacian`, order-complex `∂∂=0`). The
open job is the **assembly**: instantiate `D_{U,Φ} = d_U + δ_U + Φ + Φ†` on an
actual finite causal order complex and prove its square equals
`covariant graph Laplacian + diamond curvature + Higgs/Yukawa mass + visible
Pluecker scalar block`, under explicit anticommutation/covariance hypotheses.

**Definitions needed.** A concrete finite order complex (reuse
`OrderComplexCochain.Chain`), a transport-twisted coboundary `d_U`, its adjoint
`δ_U`, the chiral grading, and the `Φ` Higgs block from
`NullEdgeSuperDiracBlockCore`.

**Theorem statement (handoff — this is the program's master criterion).**

```lean
theorem superDirac_sq_eq_laplacian_plus_curvature_plus_higgs
    (D := d_U + δ_U + Φ + Φ.adjoint) :
    D * D
      = graphLaplacian + diamondCurvatureBlock + higgsMassBlock      -- block-diagonal
```

**Repo dependencies (all banked).** `NullEdgeSuperconnectionExpansionCore`
(block expansion + no-cross corollaries), `NullEdgeSuperDiracBlockCore`
(`hodgeDirac_sq_*`, `scalarFlip_sq_eq_massSq`, chirality anticommutation),
`NullEdgeCovariantDifferentialCore` (curvature block),
`TopologicalDiracBianconi`/`OrderComplexCochain` (Laplacian, `∂∂=0`),
`NullEdgeBundleDiracPluckerCore` (visible scalar block = Pluecker).

**Mathlib.** `Matrix`/`LinearMap` block algebra; `Finset` sums.

**Proof strategy.** This is *assembly*, not new mathematics: choose the finite
state space and adjoint, then reduce each block of `D²` to a banked lemma via
the superconnection expansion's no-cross corollaries. The work is bookkeeping
the cross terms = curvature and ensuring `Φ†` is the genuine adjoint.

**Semantic / convention risk.** High on *naturality*, low on *each block*. The
falsification mode is real: if no natural odd self-adjoint `D` exists whose
square *simultaneously* yields all four blocks (especially the visible Pluecker
scalar living on the same space as the Laplacian), the synthesis fails. Submit
only after Cluster H fixes a single state-space/adjoint convention; otherwise
the assembly will be re-typed.

**Standalone vs full-repo.** Full-repo (needs several `PhysicsSM.Draft`
imports) — but keep it a focused *assembly* job with the block lemmas named.

### Cluster G — Diamond source-visibility definitions + sharp failure lemma

**Module:** `PhysicsSM/Draft/NullEdgeRoadmap/DiamondSourceVisibility.lean`.

**Purpose.** Definition-design first. Define a diamond screen, source pairing,
visible/boundary split, flux functional, and a *closure* (`Σ_f B_f = 0`)
Gauss-law predicate, then prove the **sharp** visibility lemma:
closure-satisfying (coherent/internal) bookkeeping contributes only
boundary/mean-zero source, while a visible Pluecker excitation produces a bulk
closure violation. This is the flagship cosmological-constant branch — its
*failure mode* is its main value.

**Definitions needed.**

```lean
structure DiamondScreen (ι : Type*) where  faces : Finset ι;  Bfield : ι → Bivector
def closureDefect (S : DiamondScreen ι) : Bivector := Σ_{f ∈ S.faces} S.Bfield f
def IsCoherentBookkeeping (S) : Prop := closureDefect S = 0     -- Gauss law
def diamondSource (S) : ℝ := ‖closureDefect S‖²                  -- candidate bulk source
```

**Theorem statements.**

```lean
-- sharp failure mode: coherent bookkeeping sources nothing in the bulk
theorem coherent_bookkeeping_bulk_source_zero (S) (h : IsCoherentBookkeeping S) :
    diamondSource S = 0
-- a visible Pluecker excitation is a genuine closure violation
theorem visible_excitation_sources_bulk (psi φ : CSpinor)
    (hne : PluckerMass.spinorWedge psi φ ≠ 0) :
    diamondSource (excitationScreen psi φ) ≠ 0
```

**Repo dependencies.** `Spinor.PluckerMass`, Cluster A's `closureVector`.

**Mathlib.** norms, `Finset.sum`.

**Proof strategy.** Definitional once the closure predicate is right;
`coherent ⇒ defect 0 ⇒ source 0` is immediate, and the excitation lemma reuses
`two_edge_mass_zero_iff_wedge_zero`.

**Semantic / convention risk.** Very high on *physics overclaim*. The lemmas are
honest finite statements but do **not** by themselves give cosmological-constant
leverage; per the falsification ledger, the branch dies if coherent bookkeeping
in the *intended physical* encoding still sources a bulk volume term, or if the
residual inherits the everpresent-Λ amplitude tension. Ship as definitions +
the two sharp lemmas + an explicit "this does not yet address Λ" boundary.

**Standalone vs full-repo.** Standalone for defs; the cosmology claim stays
prose.

### Cluster H — Definition-consolidation semantic audit (`NullEdge/Core`)

**Module:** design note + `PhysicsSM/Draft/NullEdgeRoadmap/NullEdgeCoreAudit.lean`
(API proposal only, no landed retypes).

**Purpose.** `CSpinor`, `rankOneHermitian`, `spinorWedge`, `complexAbsSq`,
`blochDensity`/`blochVector`, `visibleReducedDensity` are **duplicated** across
`Spinor.PluckerMass`, `NullEdgeCoreAristotle`, `NullEdgeCelestialMixedness`,
`NullEdgeCelestialMomentWrapper`, `NullEdgeDecoherenceChannel`, and the Gram
modules. Before more algebra, propose one canonical home (re-exporting the
trusted `Spinor.PluckerMass` names) and a dependency graph, so later jobs do not
re-type banked decls. Per the loop plan's "net rule": never submit a proof job
whose target decl will be renamed by a pending consolidation.

**Deliverable.** Module API + dep graph note, **no code rewrite**. Adopt the
canonical names in a single later refactor once Clusters A/E pin their shapes.

**Risk.** Low (design only). The trap is doing it *too early* and forcing reproofs
— scope it to `SuperDirac`/`OrderComplex`/`BivectorB`/`DiamondSource`
structures that have no trusted home yet, and treat the spinor/density names as
a documented proposal.

### Second-wave clusters (brief)

- **C′ Positive-Grassmannian strata** — `pluckerMinorVanishingPattern_refines_…`;
  positivity only after a real ordered / phase-gauge-fixed sector is defined.
  Risk: positivity may add nothing beyond `normSq ≥ 0`. Standalone.
- **F′ Spectral-triple audit** — `firstOrderCondition_fails_or_forces_YukawaLegality`,
  `higgsPhi_is_innerFluctuation_of_finiteDirac`. Depends on F. Design + focused.
- **B′ l=1 relaxation gap** — channel/generator spectral target; depends on B.
  Keep conjectural until generator fixed.
- **G′ Discrete ANEC/QNEC** — `visiblePluckerFlux_satisfies_discreteANEC`,
  `diamondRelativeEntropy_secondDifference_nonnegative`. Depends on G.
- **E′ Gram-weighted reduced density** — nonorthogonal internal labels via the
  banked `det(MGM†)=w†(Λ²G)w`; depends on E + Gram modules.
- **D′ `edgeNeighbor_N` locality** — `edgeNeighborN_finite`,
  `edgeNeighborN_subdiamond_mono`. Independent, small. Standalone.

---

## 3. Dependency graph

```text
                 [Spinor.PluckerMass]  (trusted)
                 /        |        \________________________
                /         |                                 \
        (A) SpinorNetwork  (C) KleinQuadric        [CelestialMixedness] (banked)
          Closure          Simplicity                       |
            |   \                |                           |
            |    \               | (vocab only)        (E) ReducedDensity
            |     \              v                       Concurrence ──► (E′) GramWeighted
            |      \      [bivector wrapper]                 |               reduced density
            v       \                                        v
   (G) DiamondSource \                                 (B) CelestialChannel
       Visibility ────► (G′) ANEC/QNEC                  Dynamics ──► (B′) l=1 gap
            ^
            | closure reused

   [CausalDiamondHolonomy] (trusted) ──► [PathPairInterchange] (banked) ──► (D) CrossedModule/FakeFlatness

   [OrderComplexCochain]+[TopologicalDiracBianconi]+[SuperDiracBlockCore]
   +[SuperconnectionExpansion]+[CovariantDifferential]+[BundleDiracPlucker]
        \_________________________ (F) CausalSuperDirac Assembly ──► (F′) SpectralTriple audit

   (H) NullEdge/Core semantic audit  ──gates──►  (F), and the eventual rename of A/E/C names
```

Order of execution: **A, C, D** have no unbanked prerequisites and are the
parallelizable first batch. **E, B** rest on banked mixedness/Bloch identities
(second batch). **H** should run as a design pass in parallel but *land* only
after A/E. **F** waits on H. **G** is independent but physics-gated; do its
*definitions* early, its cosmology claims never (until forced).

---

## 4. Do-not-submit-yet list (attractive but underspecified)

These look tempting but are convention-mismatched, definition-starved, or
interpretive. Submitting them now would either bank a vacuous statement or a
false one.

1. **"Mass is l=1 flip-count" as a theorem.** The honest target is an l=1
   *spectral-gap of a fixed generator/channel* (B′), not a flip-count slogan.
   No generator is yet fixed; a raw flip-count theorem would be false or
   vacuous. Needs B first.
2. **Full CPTP / complete-positivity of celestial channels.** The affine-Bloch
   contraction (B) is provable; *complete positivity* requires the
   Choi-matrix/`‖T‖`-plus-determinant conditions and is strictly stronger. Do
   not label the affine map "CPTP" without those constraints.
3. **Generic proper-time monotonicity.** False without an LOCC/local-channel
   hypothesis — entangling hidden channels increase concurrence. Only the
   restricted-class direction (E) is safe.
4. **`n>2` bundle = single simple bivector.** The program forbids this; multi-edge
   must go through closure (A). A "whole-bundle simplicity" theorem would be
   wrong. Keep C strictly pairwise.
5. **Cosmological-constant leverage / everpresent-Λ improvement.** Interpretive
   until G's closure→source lemma is proved *and* survives the amplitude-tension
   failure mode. Ship G's finite lemmas, not a Λ claim.
6. **Albert algebra `H₃(O)` derives three generations / Yukawa hierarchy.**
   Counting/representation lead only. A "three generations" theorem is not
   available; at most a quantum-marginal/moment-polytope *constraint* note,
   clearly conditional.
7. **Full twistor incidence / Penrose transform.** Current twistor results are
   chart-level wrappers; projective incidence, reality structures, and
   cohomology are not in scope and not in mathlib. Do not open as a proof job.
8. **Continuum / universality Dirac limit.** "Random null-edge flip ensembles
   flow to a Dirac operator with effective mass" is the central open *physics*
   conjecture and an analytic limit; it is a Stage-3/4 pilot, not a finite
   Aristotle theorem.
9. **`Sym²S` self-dual curvature reused as the Pluecker bracket.** A convention
   trap flagged by the irrep table: keep `Λ²S` (scalar bracket) and `Sym²S`
   (curvature) apart; conflating them produces statements that change under a
   convention audit.
10. **Surface-label interchange in D before checking it.** Prove (or refute) the
    crossed-module surface equality; if it fails, bank the obstruction. Do not
    pre-assume a 2-group structure.

---

## 5. Formal-spine assessment and the single best cluster

**Is there enough spine for a publishable finite-math paper?** Yes — for two
papers already, and a third is one cluster away.

- **Paper "Pluecker mass from null spinor bundles" is ready now.** The trusted
  `Spinor.PluckerMass` gives the Cauchy–Binet/`Gr(2,n)` generalization of the
  Arkani-Hamed–Huang–Huang `n=2` `det p = m²` identity (the genuinely novel
  `n>2` statement), with real nonnegativity and the collinearity criterion, plus
  banked celestial Bloch/mixedness and SL(2)-invariance wrappers. This is a
  self-contained, kernel-checked finite-mathematics result.
- **Paper "causal diamonds as gauge-curvature carriers" is ready now.**
  `Gauge.CausalDiamondHolonomy` + `PathPairInterchange` give Abelian invariance,
  non-Abelian covariance, class-function invariance, composition laws, and the
  interchange law — a clean graph-native gauge-curvature theorem island.

What is *missing* for the strongest single paper is a **bridge theorem that
makes the mass theorem a moment-map identity** and ties the static squares to a
first-order operator. The determinant/Bloch/concurrence results are currently a
*family of squares*; the program's own slogan is that they are "the square of a
theorem not yet fully written."

**Most spine-improving cluster: A (spinor-network closure / celestial
moment-map identity).** Reasons:

1. It converts the determinant mass into the physically meaningful
   `m² = ¼((Σw)² − |C|²)` energy/closure Casimir, which is the headline identity
   for Paper 2 and the phase-space home (Dupuis–Speziale–Tambornino) for the
   whole closure/source program.
2. It is *cheap and low-risk*: pure `2×2` Hermitian linear algebra over a trusted
   theorem, no new physics assumption.
3. It is the shared prerequisite for the two highest-leverage physics branches
   (G source-visibility and C Klein/simplicity assembly via closure) — proving it
   unlocks the cosmology and bivector lines without committing to their risky
   claims.

Runner-up: **F (super-Dirac assembly)**, because it would turn the scattered
square-root islands into the program's "master" operator and is the true
falsification criterion — but it carries naturality risk and should wait for the
Cluster H convention freeze.

---

## Appendix — convention checklist to attach to every job

Copy into each focused job prompt (matches the loop plan's pre-integration
checklist):

- metric signature `(+---)`;
- Pauli order/sign (`σy = [[0,−i],[i,0]]`) matches the Weyl-block cores;
- `spinorWedge ψ φ = ψ0 φ1 − ψ1 φ0`; Pluecker normalization matches
  `finPairwisePluckerMass`;
- `m² = det P`; never silently mix with the trace pairing;
- chirality/γ signs match `NullEdgeDiracSlashCore`;
- internal Gram/hidden labels tagged orthonormal-vs-coherent (decohered theorem
  never applied to a coherent case);
- Bloch normalization fixed once (`r = (2x,2y,2z)`, `det = ¼(E²−|r|²)` for the
  unnormalized Hermitian block).
