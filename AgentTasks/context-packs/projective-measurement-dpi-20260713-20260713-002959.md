# Aristotle semantic context pack

Generated: 2026-07-13T00:30:04
Query: `Prove quantum data-processing inequality for projective measurement in the positive-definite reference density matrix eigenbasis: classical D(p||mu) <= quantum S(rho||sigma), using CFC-free spectral decomposition, unistochastic overlap majorization, and convexity of x log x`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/aristotle-p9-sj-reference-state-report.md` [Summary]

Score: `0.827`

```text
ide.

relative entropy / data-processing connection:
  Normalize the kept SJ eigenvalues to sjSpectralDist : FinDist; encode nested
  sub-diamond restriction as a column-stochastic FinObs; then reuse the proved
  finite klDiv data-processing inequality, convexity-along-chain, and
  equality/recoverability (sufficiency / discrete Petz) lemmas from
  NullEdgeRelativeEntropyObserverRoadmap. The genuine matrix Umegaki SJ entropy
  is deferred to the (open) quantum matrix layer.

ranked next theorem signatures:
  1. iDelta_isHermitian  : (iDelta G).IsHermitian
       (gates the whole spectral construction; expected easy from Δᵀ = −Δ).
  2. pauliJordanReal_antisymm : (pauliJordanReal G)ᵀ = - pauliJordanReal G.
  3. sjTwoPoint_posSemidef : 0 ⪯ sjTwoPoint G hH.
  4. sjTwoPoint_peierls :
       sjTwoPoint G hH - star (sjTwoPoint G hH) = iDelta G  (on range iΔ).
  5. sjSpectralDist_wellDef : the kept-eigenvalue weights form a FinDist
       (nonneg + sum_one).
  6. sj_dpi_nested :
       klDiv (pushforward (restrictChannel D') (sjSpectralDist D))
             (pushforward (restrictChannel D') ref)
         ≤ klDiv (sjSpectralDist D) ref.
  7. sj_entropy_chain_monotone : k ↦ klDiv (sjSpectralDist (Dchain k)) ref
       is antitone along a nested diamond chain.
  8. sjTwoPointTrunc_trace_le :
       trace (sjTwoPointTrunc …) ≤ trace (sjTwoPoint …)  (truncation control).

likely blockers:
  - Mathlib spectral-API friction: assembling the positive part via
    eigenvectorUnitary / spectral_theorem and proving PSD and the Peierls
    identity on range(iΔ) can be fiddly (unitary star bookkeeping, coercions
    ℝ→ℂ). Budget the most effort here.
  - Existence/invertibility of the link-resolvent model (need L nilpotent in a
    linear extension); the direct-causal model avoids this and s
```

### 2. `AgentTasks/null-edge-relative-entropy-observer-channel-output.md` [Stage 3 (LATER, quantum — gated): matrix relative entropy]

Score: `0.823`

```text
### Stage 3 (LATER, quantum — gated): matrix relative entropy

Only attempt once a concrete program need forces it. Explicit hypotheses that
**must** be bundled (the prompt's checklist), and why the classical layer dodges
each:

| quantum hypothesis | needed because | classical analogue (already handled) |
|---|---|---|
| finite-dim Hilbert space `Fin d`, `Matrix (Fin d) (Fin d) ℂ` | `Tr`, eigen-decomposition exist | finite `ι` |
| `ρ.PosSemidef`, `σ.PosSemidef` | `log` of operator defined; entropy real | `nonneg` |
| `ρ.trace = 1`, `σ.trace = 1` | normalization, `S(ρ‖ρ)=0` | `sum_one` |
| support inclusion `ker σ ⊆ ker ρ` (i.e. `ρ ≪ σ`) | otherwise `S = +∞` | `AbsCont` |
| channel is **CPTP** (`Φ` completely positive, trace preserving) | DPI needs *complete* positivity, not just positivity | column-stochastic = CPTP for diagonal/classical channels |

The hard part of the quantum DPI (Lindblad/Uhlmann monotonicity, operator
convexity of `t ↦ t log t`, Lieb concavity) has **no Mathlib support** and is a
large independent formalization. Recommendation: do **not** open this gate for
P7/P9. The classical layer is the honest "Type-I matrix analogue" the
publication plan already says is the safe claim. If a quantum statement is ever
needed, restrict first to **commuting** `ρ, σ` (simultaneously diagonalizable),
which reduces *exactly* to the proven classical `klDiv` on shared eigenvalues —
no new analysis required.

Staging confidence:

| stage | conf | status |
|---|---|---|
| 0 classical KL spine | 9 | DONE (proved) |
| 1 observer loss + exact recovery | 9 | DONE (proved) |
| 2 partition specializations | 9 | trivial reuse |
| 3 quantum matrix RE | 3 | gated; only via commuting-operator reduction |

---
```

### 3. `AgentTasks/overnight-allmass-run-2026-07-09/ARISTOTLE_PROMPT_codex_bloch_mass_resource_channels_1500.md` [Claim boundary and references]

Score: `0.816`

```text
## Claim boundary and references

This is a complete theorem about a real Bloch-disk avatar. It is not a
classification of all complex CPTP maps, and linear entropy/determinant is not
the von Neumann relative entropy. The result may justify a finite resource
interpretation only for the displayed contraction class.

Reference/clean-room sources already recorded in RUN_PLAN section 1c:

```text
lean-quantum: density operators, channels, entropy, DPI theorem shapes
testing-lower-bounds: divergence and data-processing proof shapes
```

They are version-pinned away and must not be imported. Use only Mathlib and the
local modules. Add exact rational witnesses, in-file axiom-footprint guard pins,
and a concise completion report.

Literature addendum (15:42 PDT): Li and Choi, `On unital qubit channels`,
arXiv:2301.01358, gives the canonical Bloch-sphere-to-ellipsoid description and
the convex-mixture-of-unitaries structure for unital qubit channels. It supports
the unital contraction interpretation, but this job must retain its narrower
real Bloch-disk scope and must not claim a full CPTP classification.
```

### 4. `AgentTasks/aristotle-wave10-20260626/c22-branch-projectors-krein-signatures/Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P7-F/P7-R. Observer channels and relative-entropy monotonicity]

Score: `0.815`

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

### 5. `AgentTasks/aristotle-wave10-20260626/c21-actual-clifford-symbol-branch-chirality/Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P7-F/P7-R. Observer channels and relative-entropy monotonicity]

Score: `0.815`

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

### 6. `AgentTasks/aristotle-wave10-20260626/d18-d0-positive-dec-proxy-plan/Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P7-F/P7-R. Observer channels and relative-entropy monotonicity]

Score: `0.815`

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

### 7. `AgentTasks/aristotle-downloads-wave12-13-20260626/m14-p1-crosswalk-application-audit/m14-p1-crosswalk-application-audit_aristotle/Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P7-F/P7-R. Observer channels and relative-entropy monotonicity]

Score: `0.815`

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

### 8. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P7-F/P7-R. Observer channels and relative-entropy monotonicity]

Score: `0.815`

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

## Scoped paper hits

### 1. Equality conditions for the quantum f-relative entropy and generalized data processing inequalities

Score: `0.820`
Zotero key: `2IR54QB2`
DOI: `10.1109/isit.2010.5513655`
URL: https://doi.org/10.1109/isit.2010.5513655

Abstract:

Information-theoretic equality conditions for generalized data-processing inequalities; useful as a guardrail for Petz/recoverability claims.

### 2. An analysis of completely-positive trace-preserving maps on M2

Score: `0.764`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 3. Quantum conditional mutual information and approximate Markov chains

Score: `0.760`
Zotero key: `BHNTND4W`
arXiv: `1410.0664`
DOI: `10.1007/s00220-015-2466-x`
URL: http://arxiv.org/abs/1410.0664

Abstract:

Conditional mutual information quantifies how well a tripartite quantum state approximates a recoverable quantum Markov chain.

### 4. Strengthened monotonicity of relative entropy via pinched Petz recovery map

Score: `0.754`
Zotero key: `4RRBQPGM`
DOI: `10.1109/isit.2016.7541401`
URL: https://doi.org/10.1109/isit.2016.7541401

Abstract:

Strengthened relative-entropy monotonicity using a pinched Petz recovery map; useful as a guardrail for finite observer-channel recoverability claims.

### 5. alpha-z-relative Renyi entropies

Score: `0.753`
Zotero key: `MKJFW9HM`
arXiv: `1310.7178`
DOI: `10.1063/1.4906367`
URL: http://arxiv.org/abs/1310.7178

Abstract:

Defines alpha-z quantum Renyi relative entropies and studies the parameter region where data processing holds.
