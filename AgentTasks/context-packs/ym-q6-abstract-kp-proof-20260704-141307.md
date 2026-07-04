# Aristotle semantic context pack

Generated: 2026-07-04T14:13:30
Query: `Q6 abstract Kotecky Preiss polymer cluster convergence proof kp_cluster_summable kp_convergence_bound ClusterCoeffData`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [C116: path-sum control is summability-first]

Score: `0.762`

```text
### C116: path-sum control is summability-first

C116 proves a finite path-sum/Neumann-series control package:

```text
walkSum M i j n = (M^n) i j;
path sums are controlled by summable per-shell bounds;
exponential decay is one sufficient case, not the primitive definition;
finite-volume convergence and infinite/limit claims must be kept separate;
projector/selector attachment preserves control but does not create a gap.
```

Update:

```text
GateC1_NU should use summable shell/path control as the primitive non-ultralocal
certificate.
```
```

### 2. `PhysicsSM/Draft/NullEdgeP9CoarseKernelPSD.lean` [trace_coarseKernel_nonneg]

Score: `0.759`

```text
theorem trace_coarseKernel_nonneg {m n : Nat}
    (R : Fin m -> Fin n -> Real) (K : Fin n -> Fin n -> Real)
    (hK : PSD K) :
    0 <= Finset.univ.sum fun a : Fin m => coarseKernel R K a a := by
  exact Finset.sum_nonneg fun a _ => psd_diag_nonneg _ (coarseKernel_psd R K hK) a

end PhysicsSM.Draft.NullEdgeP9CoarseKernelPSD

end
```

### 3. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [C110_PathSumControl]

Score: `0.753`

```text
### C110_PathSumControl

Proves:

```text
path_count(n) <= C b^n
amplitude_bound(n) <= A a^n
a b < 1
=> controlled summable tail.
```

Also define power-law and regulated finite-volume variants later.

Note: an early C108 path-sum control Aristotle job was submitted before this
numbering sharpened. Treat it as an early `C110_PathSumControl` result or
renumber during integration.
```

### 4. `PhysicsSM/Draft/NullEdgeP7KLDataProcessing.lean` [kl_data_processing]

Score: `0.752`

```text
theorem kl_data_processing {m n : Nat}
    (T : Fin m -> Fin n -> Real)
    (hnonneg : forall i j, 0 <= T i j)
    (hcol : forall j, Finset.univ.sum (fun i => T i j) = 1)
    (p q : Fin n -> Real)
    (hp : forall i, 0 <= p i) (hq : forall i, 0 < q i) :
    kl (applyMap T p) (applyMap T q) <= kl p q := by
  -- Apply the log-sum inequality to each term in the sum.
  have h_log_sum : forall i, (sum j, T i j * p j) * Real.log ((sum j, T i j * p j) / (sum j, T i j * q j)) <= sum j, T i j * p j * Real.log (p j / q j) := by
    intro i; convert log_sum_ineq ( fun j => T i j * p j ) ( fun j => T i j * q j ) ( fun j => mul_nonneg ( hnonneg i j ) ( hp j ) ) ( fun j => mul_nonneg ( hnonneg i j ) ( le_of_lt ( hq j ) ) ) ( fun j => ?_ ) using 1;
    * grind;
    * simp +contextual [ ne_of_gt ( hq _ ) ]
  -- Summing over all rows and using column-stochasticity of `T`.
  calc kl (applyMap T p) (applyMap T q)
      <= sum i, sum j, T i j * p j * Real.log (p j / q j) :=
        Finset.sum_le_sum fun i _ => h_log_sum i
    _ = kl p q := by
        rw [Finset.sum_comm]
        simp only [kl, <- Finset.sum_mul, mul_assoc, mul_left_comm, hcol, one_mul]

end PhysicsSM.Draft.NullEdgeP7KLDataProcessing
```

### 5. `Sources/NullStrand_Lean_Roadmap.md` [CONDITIONAL cluster with known theorem shape]

Score: `0.750`

```text
### CONDITIONAL cluster with known theorem shape

1. `intrinsicNullMeasure_firstMoment`
2. `intrinsicNullMeasure_lorentzCovariant`
3. `dirac_chiralContinuity`
4. `weightedAngularPoisson_exists_unique`
5. `weightedAngularGenerator_spectralGap`
6. `weightedAngularProcess_nonexplosive`
7. `finiteIrreducibleMarkov_empiricalMean_tendsto`
8. `foliatedNullLift_equivariant`
9. `internalHolonomy_gaugeCovariant`
10. `superDirac_symbol_sq_eq_weightedPluckerMass`
```

### 6. `AgentTasks/checkerboard-kernel-closed-forms-aristotle-2026-06-21.md` [Why this target]

Score: `0.745`

```text
## Why this target

`PhysicsSM.Spinor.CheckerboardDynamics` now proves the finite endpoint
recursion, iterated two-component evolution, and telegraph/Klein-Gordon
recursion.  The remaining finite combinatorics needed for a publication-grade
checkerboard core is to turn the corner-count closed forms into endpoint
kernel formulas for the path sum itself.

The imported draft files already prove:

- the path sum is a polynomial in the corner weight;
- the polynomial coefficients are fixed-endpoint corner classes;
- those corner classes have binomial closed forms for right-incoming paths.

The target is the summation glue.
```

### 7. `AgentTasks/model-calls/claude/2026-06-24-round-023-constructive-next-target.md` [Summary]

Score: `0.744`

```text
## Summary

Claude's strong contribution is the criterion for a non-empty P2/P3 next step:
put geometric content in closure/shell constraints and prove a real sum rule,
rather than wrapping generic branch data. The concrete theorem still needs a
feasibility check because the proposed RHS was not specified.
```

### 8. `AgentTasks/null-edge-relative-entropy-observer-channel-output.md` [Stage 0 (DONE): classical finite KL spine]

Score: `0.742`

```text
### Stage 0 (DONE): classical finite KL spine

```lean
def AbsCont (p q : FinDist iota) : Prop := forall i, q.p i = 0 -> p.p i = 0   -- support inclusion
def klDiv (p q : FinDist iota) : Real := sum i, p.p i * Real.log (p.p i / q.p i)

theorem klDiv_self        (p)            : klDiv p p = 0
theorem klDiv_nonneg      (hac : AbsCont p q) : 0 <= klDiv p q          -- Gibbs
theorem klDiv_eq_zero_iff (hac : AbsCont p q) : klDiv p q = 0 <-> p.p = q.p
theorem klDiv_dataProcessing (T) (hac : AbsCont p q) :                 -- HEADLINE
    klDiv (pushforward T p) (pushforward T q) <= klDiv p q
```

All proved. `klDiv_dataProcessing` is the **finite log-sum inequality**
specialised fiberwise and summed; it is not in Mathlib (Mathlib has
`InformationTheory.klDiv` over measures in `Real>=0infty` but **no** DPI). The proof
rests only on `Real.log_le_sub_one_of_pos` and `Real.log_lt_sub_one_of_pos`.

**Hypothesis that must be bundled:** `AbsCont p q` (support inclusion). Without
it the finite formula silently drops the `+infty` terms (`p i > 0, q i = 0` gives a
spurious `0` because Lean's `log 0 = 0`), so every nonnegativity / monotonicity
statement is false-as-written without it. This is the single most important
"definition-risk" lesson: the support-inclusion hypothesis is not optional
decoration, it is load-bearing.
```

## Scoped paper hits

### 1. Laplacian Coarse Graining in Complex Networks

Score: `0.713`
Zotero key: `UR5ADCBP`
arXiv: `2302.07093`
URL: http://arxiv.org/abs/2302.07093

### 2. Tri-partitions and Bases of an Ordered Complex

Score: `0.712`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x

### 3. Graph Sparsification by Effective Resistances

Score: `0.708`
Zotero key: `UFHN99H4`
arXiv: `0803.0929`
DOI: `10.1137/080734029`
URL: https://doi.org/10.1137/080734029

### 4. Frustration index and Cheeger inequalities for discrete and continuous magnetic Laplacians

Score: `0.699`
Zotero key: `FNP9V3DT`
DOI: `10.1007/s00526-015-0935-x`
URL: https://doi.org/10.1007/s00526-015-0935-x

### 5. Hodgelets: Localized Spectral Representations of Flows on Simplicial Complexes

Score: `0.698`
Zotero key: `33X7ZETB`
arXiv: `2109.08728`
URL: http://arxiv.org/abs/2109.08728
