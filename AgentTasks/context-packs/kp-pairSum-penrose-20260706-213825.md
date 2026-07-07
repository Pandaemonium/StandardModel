# Aristotle semantic context pack

Generated: 2026-07-06T21:38:55
Query: `Kotecky Preiss Penrose tree graph partition scheme pairSum_le_expBound canonical root deletion fiber injection polymer cluster expansion`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/CodeLatticeE8_Remaining_Migration_Handoff.md` [3. Construction A Short Shell To Root List Bridge]

Score: `0.747`

```text
torList.map shortVectorToRootCoords).Perm Roots.rootList
```

Trust note: the bridge has been strengthened past the explicit 240-element
native checks.  `RootBridge.lean` currently has no `native_decide` proofs.
```

### 2. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [14. Live formalization work queue (frozen 2026-07-04; for agents and Aristotle)]

Score: `0.744`

```text
n the skeleton where applicable - see
`AgentTasks/ym1-treegauge-rect-aristotle-2026-07-04.md` for the pattern
that produced a 16-minute general-case success); task note with the yaml
metadata block per `docs/ARISTOTLE.md`.

**Status snapshot (2026-07-04).** Kernel-checked and integrated, standard
axiom footprint: Lemma 2a fusion (Aristotle `3435c7a3`), Lemma 2b +
independent-plaquette area law (`IndependentPlaquetteEnsemble`), generic
tree-gauge bridge (`TreeGaugeBridge`), concrete 2D comb-gauge
coordinatization + concrete-lattice area law (Aristotle `1d9b5b19`,
`RectTreeGauge`), fusion transfer spectrum + string tension
(`FusionTransferSpectrum`), conditional vacuum dominance
(`WilsonVacuumDominance`), real/complex ensemble connector
(`EnsembleComplexBridge`), and RP-KER - the master finite
reflection-positivity kernel theorem (`ReflectionPositivityKernel`:
per-cut PSD kernels imply OS positivity; factorized and mixture weight
classes closed end-to-end). Active Aristotle: `d4a9bd1f`
(unitarizability, item Q4).

**The attack graph** (adopted 2026-07-04 from a second external model
review, screened against repo state; its "Job 1" and "Job 6" were already
done/submitted at adoption time):

```text
RP-KER (DONE)
  -> Q1 Wilson cut factorization -> Q2 transfer Hilbert space
  -> Q3 D12 sector-correct transfer matrix
  -> Q4 unitarizability (OUT: d4a9bd1f) -> Q5 eigenvalue ordering
  -> Q6 KP abstract polymer conclusion -> Q7 strong-coupling polymer map
  -> Q8 exponential clustering -> Q9 finite strong-coupling gap (YM4)
  -> Q10 infinite-volume state by cluster series
  -> (later) Peter-Weyl / compact extension; Balaban compression; YM6.
```
```

### 3. `Sources/Hamming_ConstructionA_E8_Manuscript_Revision.md` [Appendix B. Lean Theorem Index]

Score: `0.744`

```text
d analytic,
q-expansion, shell-transport, and formal power-series theorem chain.

The standalone package currently has no live `native_decide` dependency in the
paper spine.  The root-list characterization, root-bridge permutation chain,
short-vector count, Cartan determinant, Gram-Cartan congruence, simple-root
Gram theorem, small theta arithmetic, all-shell Construction A convolution,
and Weyl reflection closure are now proved without compiler-trusted native
evaluation.
```

### 4. `AgentTasks/aristotle-downloads-wave12-13-20260626/c60-species-split-nodal-line-lift/c60-species-split-nodal-line-lift_aristotle/ARISTOTLE_TASK.md` [C60: Species-splitting lift of the exact high-branch nodal curves]

Score: `0.743`

```text
# C60: Species-splitting lift of the exact high-branch nodal curves

    Type: proof/audit
```

### 5. `PhysicsSM/Algebra/Octonion/E8WeylOrbitConvergence.lean` [rootWordTable]

Score: `0.741`

```text
,
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,0,1,6,2],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,7,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,0,1,6],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,6,0],
  [1,2,3,4,0,1,5,2,6,3,4,5,3,6,4,2,1,7,3,6,2,4,3,5,4,6],
  [7,6,4,5,3,4,1,0,6],
  [7,6,4,5,3,4,6,1],
  [7,6,4,5,3,4,6],
  [1,2,3,0,7,1,6,2],
  [7,6,4,5,3,4,6,2],
  [1,2,3,0,7,1,6],
  [1,0,7,2,6,3],
  [1,2,7,3,6],
  [7,6,4,5,3,4,2,3,6],
  [1,0,7,2,6,1],
  [1,0,7,2,6],
  [7,6,1,2],
  [7,6,1,0],
  [7,6,1],
  [7,6],
  [1,2,0,1,3,2,4,3,5,4,7],
  [7,6,4,5,3,4,2,3,6,4],
  [1,0,7,2,6,1,4],
  [7,6,1,0,4,2],
  [7,6,1,2,4],
  [7,6,1,0,4],
  [7,6,4,1],
  [7,6,4],
  [1,2,3,4,0,1,5,2,7,3],
  [7,6,4,3,1,0],
  [7,6,4,3,1],
  [7,6,4,3],
  [1,2,3,4,0,1,5,2,7],
  [7,6,4,3,2],
  [1,2,3,4,5,0,7,1],
  [1,2,3,4,5,0,7],
  [1,2,3,4,7,5],
  [7,6,4,5,3,4,2,3,6,4,5],
  [7,6,1,0,4,2,5,1],
  [7,6,1,0,4,2,5],
  [7,6,4,5,1,2],
  [7,6,4,5,1,0],
  [7,6,4,5,1],
  [7,6,4,5],
  [1,2,0,1,3,2,4,3,7],
  [7,6,4,5,1,0,3],
  [7,6,4,3,1,5],
  [7,6,4,5,3],
  [1,2,3,4,0,1,7,2],
  [7,6,4,3,2,5],
  [1,2,3,4,0,1,7],
  [1,2,3,0,7,4],
  [1,2,3,4,7],
  [7,6,4,5,3,4,1,0],
  [7,6,4,5,3,4,1],
  [7,6,4,5,3,4],
  [1,2,0,1,3,2,7],
  [7,6,4,5,3,4,2],
  [1,2,3,0,7,1],
  [1,2,3,0,7],
  [1,2,7,3],
  [7,6,4,5,3,4,2,3],
  [1,2,0,1,7],
  [1,0,7,2],
  [1,2,7],
  [1,0,7],
  [7,1],
  [7],
  [1,2,0,1,3,2,4,3,5,4,7,6]]

set_option maxRecDepth 100000 in
-- 240 roots × 8 coordinates, each verified by kernel reduction
set_option maxHeartbeats 8000000 in
/-- **Word table correctness**: applying each word to `firstRoot` gives the
corresponding root, verified pointwise by kernel reduction (`decide`). -/
```

### 6. `Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md` [34.5 Next Aristotle priorities]

Score: `0.740`

```text
### 34.5 Next Aristotle priorities

The next batch should focus on the live proof bottlenecks rather than broad
strategy:

1. post-gauge ghost-safety/residue signs for the projected branch sector,
2. full nodal-set exhaustion or a certified no-exhaustion warning,
3. canonical species selection or a no-go theorem for canonical selection,
4. concrete Furey `Phi_H` over `J` and `J*`,
5. number-parity `chi_E` on the actual Furey ideal,
6. a live-tree bridge from the coordinate conjugate ideal to the existing Furey
   `Jbar`/octonion machinery.
```

### 7. `AgentTasks/aristotle-downloads-wave12-13-20260626/download-report.md` [c58-projected-branch-weyl-projector]

Score: `0.740`

```text
ty.lean
c58-projected-branch-weyl-projector_aristotle/PhysicsSM/Draft/NullEdgeSpectralGraphNodalSet.lean
c58-projected-branch-weyl-projector_aristotle/PhysicsSM/Draft/NullEdgeSymmetryForcedSpeciesSplit.lean
```

### 8. `AgentTasks/null-edge-relative-entropy-observer-channel-output.md` [Stage 2 (NEXT, classical): partition / deterministic refinements]

Score: `0.739`

```text
### Stage 2 (NEXT, classical): partition / deterministic refinements

Cheap specializations to bank for P9 plumbing:

* `klDiv_dataProcessing_for_finitePartition` := `klDiv_dataProcessing (FinObs.ofFun f)`.
  *Decision: keep, but as a one-line specialization, not a separate proof job.*
* `observerLoss_ofFun_eq_conditional_divergence` (optional, the grouped-by-fiber
  identity) — only if a downstream proof actually needs the closed form.
```

## Scoped paper hits

### 1. Cluster expansion for abstract polymer models. New bounds from an old approach

Score: `0.813`
Zotero key: `SI5BD9GT`
arXiv: `math-ph/0605041`
DOI: `10.1007/s00220-007-0279-2`
URL: http://arxiv.org/abs/math-ph/0605041

Abstract:

We revisit the classical approach to cluster expansions, based on tree graphs, and establish a new convergence condition that improves those by Kotecky-Preiss and Dobrushin, as we show in some examples. The two ingredients of our approach are: (i) a careful consideration of the Penrose identity for truncated functions, and (ii) the use of iterated transformations to bound tree-graph expansions.

### 2. Graph Sparsification by Effective Resistances

Score: `0.750`
Zotero key: `UFHN99H4`
arXiv: `0803.0929`
DOI: `10.1137/080734029`
URL: https://doi.org/10.1137/080734029

### 3. Tri-partitions and Bases of an Ordered Complex

Score: `0.745`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x

### 4. Abstract polymer gas. A simple inductive proof of the Fernández-Procacci criterion

Score: `0.744`
Zotero key: `254FV2U8`
arXiv: `2001.00652`
URL: http://arxiv.org/abs/2001.00652

Abstract:

This note contains an alternative proof of the Fernández-Procacci criterion for the convergence of cluster expansion on the abstract polymer gas via a simple inductive argument a lá Dobrushin.

### 5. Laplacian Coarse Graining in Complex Networks

Score: `0.721`
Zotero key: `UR5ADCBP`
arXiv: `2302.07093`
URL: http://arxiv.org/abs/2302.07093
