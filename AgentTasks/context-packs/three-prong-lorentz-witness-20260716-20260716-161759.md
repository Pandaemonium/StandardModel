# Aristotle semantic context pack

Generated: 2026-07-16T16:18:15
Query: `finite causal order corrected weighted difference pairing five event diamond rank four Lorentzian signature zero sum probes`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `docs/NULLSTRAND.md` [Scaling and continuum tests]

Score: `0.814`

```text
not require a physical scalar-probe basis to be pointwise natural under all
order isomorphisms. On an automorphism-transitive order, every such individual
probe is constant, and a zero-sum one vanishes. The viable finite object is a
natural probe subspace transported up to basis change. The canonical zero-sum
subspace gives a rank-four control on a five-event antichain and an exactly
covariant carrier pairing, but that rank comes from cardinality rather than
causal dimension and is not evidence by itself for Lorentzian signature.

Once a natural carrier subspace has rank four, treat a probe tetrad as a basis
of that subspace. The active corrected pairing is a symmetric bilinear form,
and its matrices in two probe frames obey `G_c = M^T G_b M`. Conditional on one
frame giving the project matrix `diag(1,-1,-1,-1)`, the normalized frame changes
are exactly the `eta`-orthogonal transformations. This identifies the correct
finite Lorentz-gauge quotient, but it is not a proof that physical carriers
have rank four or that their operator pairing has Lorentzian inertia.

Open target-metric and signature scores only after the intrinsic retarded-shell
availability gate. Build the shell from count-band past/future abundance and a
marked event, and treat visibility basis-freely as injectivity of probe-space
restriction to that shell. Exact finite dimension gives
`finrank P <= shell.card`; in particular, fewer than four shell events forbid a
visible rank-four probe sector. Four events are only the sharp qualitative
minimum. They do not imply a positive quantitative coverage quotient, local
affinity, product closure, Lorentzian inertia, or metric convergence.

Keep the tensor variance explicit when composing probe frames with relative
scale. Simultaneously scaling the operator lengths
```

### 2. `AgentTasks/model-calls/claude/2026-07-16-102530-rank-four-probe-sector-semantic-audit-20260716.md` [Intrinsic scalar-probe subspaces without a preferred basis]

Score: `0.807`

```text
ansitive fiveEventAntichain
      fiveEventAntichain_automorphismTransitive a y 0
  have hsum :
      (∑ y : Fin 5, P.probe fiveEventAntichain a y) = 0 := by
    exact hzeroSum
  simp_rw [hconstant] at hsum
  have hbase : P.probe fiveEventAntichain a 0 = 0 := by
    norm_num at hsum ⊢
    exact hsum
  rw [hconstant x, hbase]

/-- The positive/negative split on the five-event symmetric control: the
natural zero-sum subspace has rank four, while every individually natural
zero-sum probe vanishes. -/
theorem fiveEvent_rankFour_subspace_but_no_natural_vectors
    {r : Nat} (P : IntrinsicProbeSector r)
    (hzeroSum : ∀ a, P.probe fiveEventAntichain a ∈
      zeroSumFieldSubspace (Fin 5)) :
    Module.finrank ℝ (zeroSumProbeSector.space fiveEventAntichain) = 4 ∧
      ∀ a x, P.probe fiveEventAntichain a x = 0 := by
  constructor
  · exact finrank_fiveEvent_zeroSum
  · intro a x
    exact intrinsicProbe_zero_of_fiveEvent_meanZero P a (hzeroSum a) x

/-! ## Basis-free carrier pairing -/

/-- Zero-sum probe subspace on one closed Alexandrov carrier. -/
def carrierProbeSubspace
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) :
    Submodule ℝ (ClosedCarrier A → ℝ) :=
  zeroSumFieldSubspace (ClosedCarrier A)

/-- Corrected causal-operator pairing restricted to the basis-free carrier
probe subspace. -/
def carrierProbePairing
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : carrierProbeSubspace A) : ℝ :=
  correctedPairingAt
    (projectSmeared4DOperator (inducedOrder A) ell nonlocalityScale)
    x f.1 h.1

/-- The restricted pairing remains symmetric without a chosen probe basis. -/
theorem carrierProbePairing_comm
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCa
```

### 3. `docs/DOCUMENT_MAP.md` [The null-edge program: core documents]

Score: `0.801`

```text
- fresh two-density complete-family test of the post-hoc
  `1-S_N = O(N^(-1/2))` form. All six cells pass the frozen scaling, flat
  `F_4`, capability, resource, and tripwire gates. This is finite stochastic
  evidence only; growing atlas cardinality, overlap complexity, and G2 remain
  open. Every citation carries
  `INC-2026-07-16-A3F-R3-DUPLICATE-RUN` until Director review because two blind
  concurrent launches wrote the frozen path; independent review retained the
  second artifact with full disclosure. [EXPERIMENT]
- `PhysicsSM/Draft/NullEdge/IntrinsicProbeSubspace.lean` - basis-free natural
  scalar-probe sectors under finite-order isomorphism. The zero-sum field
  subspace transports exactly, has real rank four on the five-event antichain,
  and feeds an exactly covariant corrected operator pairing on every closed
  Alexandrov carrier. The same symmetric control proves that every zero-sum
  probe selected as an individually natural vector vanishes, so a physical
  probe frame must transform inside a subspace up to basis change. The rank-four
  control is cardinality-driven and does not establish causal dimension,
  Lorentzian signature, or continuum probe convergence. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ProbeFrameLorentzGauge.lean` - packages the active
  smeared causal operator as a linear map and its corrected carrier pairing as
  a symmetric bilinear form. Four-probe frames are bases of the natural probe
  subspace; their Gram matrices obey exact change-of-basis congruence. If one
  frame gives the mostly-minus Minkowski matrix, the other normalized frames
  differ from it exactly by Lorentz transformations. The existence of such a
  frame is invariant under order isomorphism and implies nondegeneracy. Frame
  existence, Lorentzian inertia on physical c
```

### 4. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.4 Selected operator-first metric architecture]

Score: `0.801`

```text
]** because those
joint product limits are premises, not consequences of the finite order.

The arbitrary-operator boundary has now been narrowed by
`FiniteCausalOrderOperator.lean`. From a supplied finite strict causal order it
constructs open intervals, interval-count past layers, the exact local
four-dimensional Benincasa-Dowker coefficients, and the broadened smeared
kernel. It proves event-relabeling covariance, exact source-to-project sign
conversion, inverse-square scale covariance, same-scale local reduction, and
the corrected pairing directly on finite scalar fields. A two-event witness
shows that the layer sum is not vacuous. These are **M [comp]** finite
identities, not a derivation of dimension four: the coefficient family is
selected from the four-dimensional continuum target, while the microscopic
and nonlocality scales remain supplied.

The same module now records the next convergence interface without fixing one
carrier across refinement. An `IntrinsicProbeSector` is a supplied finite
probe family natural under every finite order isomorphism, and
`tendsto_intrinsicProbePairing_projectSmeared4D` transports six independent
scalar limits across varying finite carriers to the corresponding corrected
pairing limit. The target is constructed algebraically from those limits; it
is not named or assumed to be a metric. Existence of a nontrivial slowly
varying intrinsic selector, convergence of its operator evaluations, and the
rank/signature gate remain open.

There is also an exact finite warning about the interface itself. The current
`IntrinsicProbeSector` asks each named probe to be individually natural under
every order isomorphism. The checked theorem
`probe_constant_of_automorphismTransitive` shows that this forces every such
probe to be constant on an aut
```

### 5. `AgentTasks/null-edge-intrinsic-probe-stage-a-benchmark-2026-07-15.md` [Construction and oracle boundary]

Score: `0.796`

```text
## Construction and oracle boundary

Each realization conditionally sprinkles a four-dimensional Minkowski diamond.
Embedding coordinates choose a marked event nearest
`(0.85 * duration, 0, 0, 0)`. After that event is marked, each probe selector
uses only the finite causal relation, interval counts, supplied scales, and the
marked event. Coordinates re-enter only after selection to fit a local affine
Jacobian and score the reconstructed pairing.

Three selectors were pre-registered for the final fixed-scale sweep:

1. `profile_pca`: the leading four predecessor/successor incidence-profile
   modes in a profile-distance window with inner/outer quantiles `0.08/0.30`.
2. `operator_svd`: the four lowest right-singular modes of the full project-sign
   smeared Benincasa-Dowker operator.
3. `filtered_profile`: the profile modes smoothed by
   `(I + tau L^4 B_C^* B_C)^-1` with fixed dimensionless `tau = 0.10`.

The profile-distance window assigns equal weights to equal integer distances;
it does not break ties by event label. Probe subspaces are compared through
their orthogonal projectors, so arbitrary signs and basis rotations are gauge.
```

### 6. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.5 Executable Stage A calibration]

Score: `0.790`

```text
### 3.5 Executable Stage A calibration

`Scripts/experiments/causal_operator_metric.py` now implements the local and
smeared four-dimensional Benincasa-Dowker operator on a conditionally sprinkled
Minkowski diamond and evaluates the corrected pairing on known compactly
supported coordinate probes. This is an external calibration oracle, not an
intrinsic reconstruction: coordinates are used to define the sprinkling and
probe fields, while the operator row uses only causal order, interval counts,
density, and a supplied nonlocality scale. The source `(-+++)` operator is
explicitly sign-converted to the project `(+---)` convention.

The first benchmark found a genuine finite scale window. With probe-support
radius `0.5`, \(N=5000\), and 20 realizations, the ensemble-mean metric error
was `0.387` at \(L_k=0.14\) and `0.424` at \(L_k=0.16\); the latter had lower
per-sprinkling error because of stronger smoothing. At fixed \(L_k=0.16\), the
correct-signature frequency rose from 43% at \(N=1000\) to 95% at
\(N=10000\), while mean per-sprinkling error fell from `2.386` to `0.723`.
Affine probe covariance held to floating-point roundoff.

This is useful positive evidence for the operator route, but it also exposes
the next debt. The metric depends materially on the embedding-defined support
cutoff, and decreasing \(L_k\) improves bias while reviving fluctuations. The
new finite Lean construction now agrees with the order/count operator used by
this oracle at the formula level; it does not internalize the oracle's
sprinkling, coordinate probes, support cutoff, or stochastic convergence. A
basis-free order-derived probe sector and a pre-registered two-scale selection
or averaging rule are required before this counts as metric reconstruction.
Full parameters, outputs, and kill cond
```

### 7. `AgentTasks/aristotle-p9-sj-reference-state-report.md` [1. Finite causal diamond representation]

Score: `0.787`

```text
## 1. Finite causal diamond representation
```

### 8. `AgentTasks/context-packs/intrinsic-probe-next-selector-20260715-20260715-085913.md` [3.5 Executable Stage A calibration]

Score: `0.787`

```text
### 3.5 Executable Stage A calibration

`Scripts/experiments/causal_operator_metric.py` now implements the local and
smeared four-dimensional Benincasa-Dowker operator on a conditionally sprinkled
Minkowski diamond and evaluates the corrected pairing on known compactly
supported coordinate probes. This is an external calibration oracle, not an
intrinsic reconstruction: coordinates are used to define the sprinkling and
probe fields, while the operator row uses only causal order, interval counts,
density, and a supplied nonlocality scale. The source `(-+++)` operator is
explicitly sign-converted to the project `(+---)` convention.

The first benchmark found a genuine finite scale window. With probe-support
radius `0.5`, \(N=5000\), and 20 realizations, the ensemble-mean metric error
was `0.387` at \(L_k=0.14\) and `0.424` at \(L_k=0.16\); the latter had lower
per-sprinkling error because of stronger smoothing. At fixed \(L_k=0.16\), the
correct-signature frequency rose from 43% at \(N=1000\) to 95% at
\(N=10000\), while mean per-sprinkling error fell from `2.386` to `0.723`.
Affine probe covariance held to floating-point roundoff.

This is useful positive evidence for the operator route, but it also exposes
the next debt. The metric depends materially on the embedding-defined support
cutoff, and decreasing \(L_k\) improves bias while reviving fluctuations. A
basis-free order-derived probe sector and a pre-registered two-scale selection
or averaging rule are required before this counts as metric reconstruction.
Full parameters, outputs, and kill conditions are recorded in
`AgentTasks/null-edge-causal-operator-metric-stage-a-benchmark-2026-07-15.md`.
```
```

## Scoped paper hits

### 1. Space-time as a causal set

Score: `0.742`
Zotero key: `I8DJ26QC`
DOI: `10.1103/PhysRevLett.59.521`
URL: https://www.zotero.org/19894138/items/I8DJ26QC

### 2. Gravitational Thermodynamics of Causal Diamonds in (A)dS

Score: `0.739`
Zotero key: `2ZZTQS43`
arXiv: `1812.01596`
URL: http://arxiv.org/abs/1812.01596v3

### 3. Spacetime Entanglement Entropy in 1+1 Dimensions

Score: `0.738`
Zotero key: `8TA2W3MV`
arXiv: `1311.7146`
DOI: `10.1088/0264-9381/31/21/214006`
URL: http://arxiv.org/abs/1311.7146

Abstract:

Computes spacetime entanglement entropy from correlation data in regions of causal sets or continuum spacetimes.

### 4. Entanglement Entropy in Causal Set Theory

Score: `0.736`
Zotero key: `G2JGSV9B`
arXiv: `1611.10281`
DOI: `10.1088/1361-6382/aab06f`
URL: http://arxiv.org/abs/1611.10281

Abstract:

Studies causal-set entanglement entropy for causal diamonds and the role of Pauli-Jordan spectral truncation in obtaining area-law behavior.

### 5. Local d'Alembertian for causal sets

Score: `0.734`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`
