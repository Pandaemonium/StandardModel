# Aristotle semantic context pack

Generated: 2026-07-15T08:59:39
Query: `intrinsic causal order probe sector retarded support two-sided interior projector scale stable spectral cluster product rule metric reconstruction`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.5 Executable Stage A calibration]

Score: `0.809`

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

### 2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G2. Operator metric and unique scale reconstruction]

Score: `0.787`

```text
### G2. Operator metric and unique scale reconstruction

Construct a count-normalized causal operator and prove that its corrected
carre du champ converges on a mesoscopic probe sector to the full inverse
metric. The finite Gram matrix must exhibit a stable rank-four Lorentzian image
with signature \((+---)\), and its induced volume must agree with counting.

The checked algebraic boundary is exact: scalar zeroth-order potentials cancel
from the corrected pairing. What is not checked is the causal construction of
\(\widehat B_C\), selection of \(\mathcal H_D\), joint convergence on products,
rank/signature stability, or volume convergence.

The Stage A oracle is the first executable partial pass of this gate. It
recovers rank-four Lorentzian ensemble means over a mesoscopic scale window and
shows improving per-sprinkling signature reliability with density. It does not
pass G2 because its probes and smooth support are selected using embedding
coordinates, its absolute density and \(L_k\) are supplied, its finite metric
normalization remains biased, and no joint continuum theorem or count-volume
agreement has been demonstrated.

Relate the resulting metric volume to the soldering Gram volume without
introducing a second independent scale field.

The finite boundary is now exact. Bare-relation invariance alone leaves a
positive global rescaling ray, and a nonzero event count determines absolute
volume only after a positive density calibration is supplied. Given that
calibration and a nondegenerate four-dimensional conformal coframe
representative, the unique positive Weyl factor is the fourth root of the
target/base volume ratio.

There is nevertheless a useful relative result before the density is known.
For two positive regional counts \(n,n_0\), supplied conformal repre
```

### 3. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.4 Selected operator-first metric architecture]

Score: `0.784`

```text
]** because those
joint product limits are premises, not consequences of the finite order.

At finite density, arbitrary functions on the event set are too numerous and
too noisy to serve as cotangent probes. A mesoscopic region must supply a
basis-free slowly varying sector \(\mathcal H_D\), for example through low
singular modes of a filtered operator after boundary-dominated modes are
removed. For probes \(f_A\in\mathcal H_D\), form

\[
  G_{AB}(x)=\Gamma_C(f_A,f_B)(x).
\]

The decisive four-dimensional manifoldlikeness gate is a stable rank-four
image with one positive and three negative directions over a nontrivial range
of mesoscopic scales. The quotient

\[
  T_x^*C=\mathcal H_D/\ker\Gamma_C(x)
\]

is then a finite cotangent estimator. Choosing four probe functions is only a
coordinate gauge; no preferred tetrad is selected from the sprinkling.

The normalization of \(\widehat B_C\) carries inverse-length-squared units, so
the operator route can contain the same count calibration that normalizes
volume. The reconstructed metric volume must still satisfy the independent
consistency test

\[
  \int_D\sqrt{|g_C|}\,d^4X\simeq \ell^4|D|.
\]

This avoids two local scale fields, but it does not derive an absolute unit
from a bare order: the value of \(\ell\), or one equivalent positive anchor,
remains supplied. The existing relative scale theorems therefore remain useful
as normalization and no-double-counting audits.
```

### 4. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3. Causal order gives conformal geometry, not scale]

Score: `0.779`

```text
## 3. Causal order gives conformal geometry, not scale

The most important reconstruction discipline is the order-scale split.
```

### 5. `PhysicsSM/Draft/NullEdge/PinnedSpecProjectors.lean`

Score: `0.776`

```text
/-
# Deliverable 2 (part 3c) — the spectral projectors are genuine (structural)

Companion Lean file for `PINNED_STABILITY_DESIGN.md`.  Certifies that the
projectors of `Pinned.SectorDefs` used to define the sector-resolved index are
genuine orthogonal spectral projectors onto `ker(W-ε)`.  Proved **structurally**
(matrix algebra) from the landed isometry/intertwining facts plus the exact
`4×4` involution of the fixed-leg compression — no heavy `native_decide` on the
full `8×8` expressions.

* general `B`-compression projector lemma `bproj_spectral`;
* general involution projector lemma `invproj_spectral`;
* instantiations: `eigProj13_is_spectral` (protected singletons, rank `2`),
  `eigProj02_is_spectral` (blind singletons, rank `2`),
  `eigProjW_is_spectral` (blocks, rank `4`).

Draft-trust disclosure: only the small `4×4` involution facts
(`Mfix_involution`, `Mfix0_involution`) use `native_decide`; everything else is
kernel-only.
-/
/-
Provenance: Aristotle job 573430f4 harvest (statements) + local Fable
proofs for the two abstract projector lemmas (2026-07-11, 24h run;
elementary ring algebra closed locally per the local-first policy).
Statements UNCHANGED from the harvest; import rewires only.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.HalfPeriodInvariant
import PhysicsSM.Draft.NullEdge.PinnedMirrorChart
import PhysicsSM.Draft.NullEdge.PinnedSectorDefs
```

### 6. `Sources/Null_Edge_Future_Directions.md` [Decoder moduli and chain-homotopy gauge (Pro follow-up, 2026-07-09)]

Score: `0.769`

```text
te uniform-shift absorption theorem, and
  `LambdaThreeSplit` proves the matching finite traceless projection statement.
  What remains open is survival under the geometry measure, radiative feedback,
  refinement, and the continuum limit.
- **[C] Recovery-Compton theorem:** define recovery error for Schur decimation
  and relate its length scale to the inverse positive gap. Entropy monotonicity
  alone is not enough.
- **[C] Information equivalence principle:** derive a Ward identity equating
  state acceleration with opposite soldering/frame acceleration. Existing WEP
  trace identities are anchors, not this theorem.
- **[spec] Causal amplitude functor, self-consistent free energy, holographic
  capacity, code-proliferation criticality, and an arrow from lost
  recoverability:** each needs a category of finite causal complexes, a measure
  or refinement law, and a physicalization functor that have not been derived.

The strongest safe synthesis is therefore: **physical observables should live
on a chosen invariant positive subspace of cohomology and be unchanged by
chain-homotopy changes of decoder presentation.** Existence, maximality,
comparison of positive choices, and dynamics of the proposed full moduli space
remain reconstruction problems.

---
```

### 7. `AgentTasks/null-edge-p11-channel-sector-strategy-report-2026-06-23.md` [Next Aristotle job]

Score: `0.768`

```text
## Next Aristotle job

Run a focused proof package for the calibrated-readout core:

```text
null-edge-p11-readout-core
```

Targets:

- determinant rescaling under normalization;
- exact reconstruction from `(normalize(P), Tr(P))`;
- explicit counterexample showing normalized state alone loses mass scale.

This should come before spectral-sector theorems, because the readout scale is
the part that prevents the particle-sector ontology from silently becoming an
`m/E`-only theory.
```

### 8. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G1. Conformal reconstruction]

Score: `0.766`

```text
### G1. Conformal reconstruction

Recover the continuum causal relation and prove that it determines the target
conformal class under explicit causality hypotheses.

**Success:** the reconstructed light cones converge independently of regulator
frame.  
**Kill:** persistent preferred cones or inequivalent conformal limits.
```

## Scoped paper hits

### 1. The Spectral Action Principle

Score: `0.728`
Zotero key: `6WURA7MF`
DOI: `10.1007/s002200050126`
URL: https://doi.org/10.1007/s002200050126

### 2. The Scalar Curvature of a Causal Set

Score: `0.728`
Zotero key: `JUVWME9X`
arXiv: `1001.2725`
DOI: `10.1103/PhysRevLett.104.181301`
URL: https://www.zotero.org/19894138/items/JUVWME9X

Abstract:

A one parameter family of retarded linear operators on scalar fields on causal sets is introduced. When the causal set is well-approximated by 4 dimensional Minkowski spacetime, the operators are Lorentz invariant but nonlocal, are parametrised by the scale of the nonlocality and approximate the continuum scalar D'Alembertian, $\Box$, when acting on fields that vary slowly on the nonlocality scale. The same operators can be applied to scalar fields on causal sets which are well-approximated by curved spacetimes in which case they approximate $\Box - {{1/2}}R$ where $R$ is the Ricci scalar curvature. This can used to define an approximately local action functional for causal sets.

### 3. Correction terms for propagators and d'Alembertians due to spacetime discreteness

Score: `0.725`
Zotero key: `arxiv:1411.2614`
arXiv: `1411.2614`
DOI: `10.1088/0264-9381/32/19/195020`
URL: http://arxiv.org/abs/1411.2614

Abstract:

Finite-sprinkling correction terms for causal-set retarded propagators and d'Alembertian operators compared with continuum limits.

### 4. Space-time as a causal set

Score: `0.725`
Zotero key: `I8DJ26QC`
DOI: `10.1103/PhysRevLett.59.521`
URL: https://www.zotero.org/19894138/items/I8DJ26QC

### 5. Local d'Alembertian for causal sets

Score: `0.723`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`
