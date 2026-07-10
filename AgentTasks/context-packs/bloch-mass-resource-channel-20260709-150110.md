# Aristotle semantic context pack

Generated: 2026-07-09T15:01:17
Query: `mass resource theory qubit Bloch determinant unital channel contraction decoherence monotonicity amplitude damping counterexample exact finite`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P7-F/P7-R. Observer channels and relative-entropy monotonicity]

Score: `0.850`

```text
d in
  `NullEdgeP7ProperTimePurityBridge`, making the normalized static bridge
  explicit);
- `blochContraction_properTimeRatioSq_monotone` and strict variant (banked in
  the same module, giving the unital-channel monotonicity form);
- `partialDephasing_massRatioSq_gap`,
  `iteratedPartialDephasing_massRatioSq_gap`, and related determinant/purity
  gap identities (banked in `NullEdgeP2PartialDephasingRateBridge`, giving
  one-step and `n`-step dephasing-channel laws for the loss of off-diagonal
  coherence);
- `linearEntropyRate_visible_eq_flipFrequency`, shared with the null-step
  dynamics paper.

Remaining. A precise statement of the resolution observer, the kinematic
observer, the explicit unital visible-channel construction, and a finite
observer-channel API shared by P7 and P9. Ruskai-Szarek-Werner
(`quant-ph/0101003`, DOI `10.1016/s0024-3795(01)00547-x`, Zotero `M6HR9WD6`)
gives the affine Bloch-ball form and is the practical route for the celestial
qubit before we attempt a general CPTP formalization.

The newest audit boundary is important: the proper-time/purity bridge is no
longer only a static scalar rewrite, because the partial-dephasing module now
records exact finite one-step and `n`-step channel increments. It is still not a
continuum rate law or a Higgs/Yukawa dynamics theorem. The next
publication-grade strengthening is to connect the finite iterated formula to a
named null-step transfer channel.

Lead venue. Foundations / quantum information with a gravity angle.

Literature anchors. Faulkner et al. ANEC (`1605.08072`, Zotero `B68T629C`);
Ceyhan-Faulkner QNEC/ANEC recovery (`1812.04683`, `TFGTQQTU`); Casini's
relative-entropy Bekenstein bound (`0804.2182`, `S9FTNNRU`); Fawzi-Renner
recoverability (`1410.0664`, `BHNTND4W`); Ruskai-Szarek-Werner qubit
```

### 2. `AgentTasks/null-edge-grand-strategy-v2-output.md` [Cluster B — Affine-Bloch CPTP celestial-channel dynamics]

Score: `0.830`

```text
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

**Proof strategy.** Orthogonal `T` preserves `‖r‖` (`Mat
```

### 3. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P7-F/P7-R. Observer channels and relative-entropy monotonicity]

Score: `0.830`

```text
st_is_filtering`;
- `normalizedVisible_det_eq_massRatio_sq`;
- `det_visibleReduced_eq_gramWeighted_plucker`;
- `det_visibleReduced_twoLabel_eq_wedge_times_detGram` (banked in
  `NullEdgeObserverChannelCore`);
- `dephasing_internalGram_mass_monotone` (banked in
  `NullEdgeObserverChannelCore`);
- `restFrame_iff_normalizedMomentum_maximallyMixed`;
- `massRatio_eq_sqrt_one_minus_blochNormSq`;
- `relativeEntropy_partialTrace_monotone`, or a focused finite data-processing
  lemma if the mathlib API supports it;
- `unital_visibleChannel_massRatioSq_monotone` (banked in
  `NullEdgeObserverChannelCore`);
- `entangling_hiddenChannel_massRatioSq_can_decrease` (banked toy
  counterexample in `NullEdgeObserverChannelCore`);
- `petzRecoverable_iff_relativeEntropyLoss_zero`, if a small finite matrix
  statement can be isolated;
- `recoverabilityGap_bounds_sourceVisibilityDefect`, initially as a definition
  and conjectural inequality.
- `internalCoherenceLoss_eq_relativeEntropyDeficit`;
- `coherenceDeficit_not_determined_by_mass_alone` (finite same-det,
  different-coherence density-class guardrail banked in
  `NullEdgeP7CoherenceNotDeterminedByDet`);
- `sameDet_different_operationalReadout` (banked in the same module via an
  explicit off-diagonal trace-pairing observable);
- `sameDet_different_positiveEffectReadout` (banked via an X-basis-style
  bounded positive-effect proxy in the finite real-symmetric model);
- `sameDet_different_twoOutcomeReadout` (banked with the positive effect and
  its complement summing to the trace-one total);
- `properTimeRatioSq_eq_two_linearEntropy` (banked in
  `NullEdgeP7ProperTimePurityBridge`, making the normalized static bridge
  explicit);
- `blochContraction_properTimeRatioSq_monotone` and strict variant (banked in
  the same module, giving the
```

### 4. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Executive conclusion]

Score: `0.827`

```text
the non-covariance of reduced spin
entropy under boosts is a standard relativistic-quantum-information warning
from Peres-Scudo-Terno `quant-ph/0203033` / PRL 88, 230402 and
Gingrich-Adami `quant-ph/0205179` / PRL 89, 270402. The program's novelty
should be claimed in the finite null-edge packaging, Lean-checked bundle
generalization, and dynamical/channel use of the mass ratio, not in the bare
two-qubit concurrence analogy.

The dynamical version should be a finite qubit-channel statement. A CPTP
channel on the visible celestial density matrix acts affinely on the Bloch
ball,

```text
r |-> T r + t,
```

while the mass ratio is `sqrt(1 - |r|^2)`. Thus the l=1 relaxation conjecture
should be stated as a spectral property of a channel or generator, not as a
raw flip-count slogan. Visible unitaries preserve `|r|`; depolarizing or
unital visible channels can increase the mass ratio by contracting `|r|`;
entangling hidden dynamics are not visible channels and can reverse the
monotonicity. Broad LOCC/local language should be replaced by the explicit
channel class being used.

The new big-physics development note
`Sources/Null_Edge_Big_Physics_Inquiry_Development.md` sharpens this into
three concrete inquiry lines. First, nonorthogonal internal labels replace the
orthogonal Pluecker sum by an exterior-square Gram formula
`det(M G M^dagger) = w^dagger (Lambda^2 G) w`; this is now isolated as the
draft Lean handoff `PhysicsSM.Draft.NullEdgeGramWeightedMassAristotle` and is
the finite spine for the flavor-overlap/Yukawa-hierarchy proposal. Second,
the normalized determinant identity makes `2 sqrt(det rho_vis) = m/E` a
proper-time-rate/concurrence wrapper, with monotonicity claims restricted first
to explicit unital visible-channel classes and with entangling hidden dynamics
kept
```

### 5. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [New synthesis: proper time as visible concurrence]

Score: `0.826`

```text
celestial
Bloch ball. A finite CPTP channel has affine form

```text
r |-> T r + t
```

on the visible Bloch vector, and the mass ratio is
`sqrt(1 - |r|^2)`. The l=1 relaxation conjecture should therefore be stated
as a spectral property of the channel or its generator, not as an informal
flip count. A visible unitary preserves `|r|`; depolarizing or entangling
channels can increase mass/proper-time rate; LOCC/local hidden-channel
classes are the only safe place to import monotonicity.

**2026-06-21 Zotero/Neo4j additions.** Added Connes-Rovelli `I8XNBREW`
(`10.1088/0264-9381/11/12/007`) and Page-Wootters `EWXH3E6A`
(`10.1103/PhysRevD.27.2885`), tagged `proper-time-mixedness` and
`quantum-time`.

**Lean targets.**

- `properTimeRate_eq_two_sqrt_det_visibleDensity`;
- `normalized_mass_ratio_eq_concurrence`;
- `properTimeRate_zero_iff_visiblePure`;
- `celestialChannel_CPTP`;
- `celestialChannel_affineBloch`;
- `massRatio_afterChannel_eq_blochContraction`;
- `l1SpectralGap_bounds_massGenerationRate`;
- `partialCoherence_properTimeRate_monotone_for_real_overlap`, only when the
  channel is proven local on the visible/internal cut;
- `hiddenChannel_concurrence_nonincreasing_under_LOCC`, only for a precisely
  specified finite LOCC/coarse-graining map.

**Falsification.** Do not promote this if the concurrence identity requires
nonstandard normalization, if the monotonicity only holds after choosing ad hoc
channels, or if physically relevant hidden dynamics are generically entangling
on the visible/internal cut.

**2026-06-21 Gemma4/Zotero/Neo4j update.** Added the massive two-twistor papers
Fedoruk-Lukierski `1403.4127` (`HPP4FME8`) and Deguchi-Okano `1512.07740`
(`7V6SJB4F`). They support a sharper hidden-channel theorem target: the finite
internal label should carry a loc
```

### 6. `AgentTasks/null-edge-p7-bloch-contraction-mixedness-aristotle-2026-06-23.md` [Aristotle task: P7 Bloch contraction mixedness]

Score: `0.825`

```text
# Aristotle task: P7 Bloch contraction mixedness

Target project: `null-edge-p7-bloch-contraction-mixedness-20260623`

Target file:

```text
NullEdgeP7BlochContractionMixedness/Core.lean
```

```yaml
aristotle:
  project_id: 00bf48ec-8497-4418-8738-b00ea52d928f
  target_file: NullEdgeP7BlochContractionMixedness/Core.lean
  expected_module: NullEdgeP7BlochContractionMixedness.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p7-bloch-contraction-mixedness-20260623-project
  status: integrated
```

Goal: close the proof hole in a focused standalone Mathlib package.

Scientific value: this is a finite qubit-channel guardrail: a unital Bloch
contraction cannot decrease normalized celestial mixedness `1 - r^2`.

Required final report:

- solved targets;
- whether any theorem statement or definition changed;
- any remaining proof holes or placeholder constructs;
- exact Lean command run;
- axiom profile if available.
```

### 7. `PhysicsSM/Draft/NullEdgeP7BlochContractionMixedness.lean`

Score: `0.822`

```text
import Mathlib.Tactic

/-!
# P7 Bloch contraction increases normalized mixedness

For a normalized celestial qubit, the scalar mixedness is `1 - r^2`. A unital
Bloch contraction `r |-> a r` with `0 <= a <= 1` cannot decrease this
mixedness. This is the finite qubit-channel guardrail for observer maps.
-/
```

### 8. `AgentTasks/null-edge-gemini-aristotle-run-ledger-2026-06-23.md` [Wave 2: Suppression & Concurrence]

Score: `0.821`

```text
### Wave 2: Suppression & Concurrence
4. **`null-edge-p9-weighted-residual-suppression-threshold`** (Proof/Counterexample)
   - *Target file:* `PhysicsSM/Draft/NullEdgeP9WeightedSuppressionThreshold.lean`
   - *Task:* Find the exact threshold where weighted residual noise beats $1/\sqrt{V}$ everpresent-Lambda scaling.
5. **`null-edge-p6-mass-ratio-eq-concurrence`** (Proof)
   - *Target file:* `PhysicsSM/Draft/NullEdgeP6MassConcurrence.lean`
   - *Task:* Prove the normalized determinant mass ratio equals the concurrence for a finite qubit with internal state.
6. **`null-edge-p7-qubit-concurrence-mass-ratio-monotonicity`** (Proof)
   - *Target file:* `PhysicsSM/Draft/NullEdgeP7Monotonicity.lean`
   - *Task:* Prove mass ratio is monotone under unital Bloch contraction.
```

## Scoped paper hits

### 1. Von Neumann algebra automorphisms and time-thermodynamics relation in generally covariant quantum theories

Score: `0.766`
Zotero key: `I8XNBREW`
DOI: `10.1088/0264-9381/11/12/007`
URL: https://doi.org/10.1088/0264-9381/11/12/007

### 2. Quantum geometric tensor determines the pure-state i.i.d. conversion rate in the resource theory of asymmetry for any compact Lie group

Score: `0.761`
Zotero key: `45FTB5VF`
arXiv: `2411.04766`
URL: http://arxiv.org/abs/2411.04766

Abstract:

Shows that the quantum geometric tensor determines pure-state iid conversion rates in the resource theory of asymmetry for compact Lie groups.

### 3. An analysis of completely-positive trace-preserving maps on M2

Score: `0.760`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 4. An Argument for Strong Positivity of the Decoherence Functional

Score: `0.759`
Zotero key: `arxiv:2011.06120`
arXiv: `2011.06120`
URL: http://arxiv.org/abs/2011.06120

Abstract:

Argues that strong positivity is the correct physical positivity condition for path-integral/decoherence-functional quantum theory, via closure and maximality under tensor products.

### 5. Strengthened monotonicity of relative entropy via pinched Petz recovery map

Score: `0.754`
Zotero key: `4RRBQPGM`
DOI: `10.1109/isit.2016.7541401`
URL: https://doi.org/10.1109/isit.2016.7541401

Abstract:

Strengthened relative-entropy monotonicity using a pinched Petz recovery map; useful as a guardrail for finite observer-channel recoverability claims.
