# Aristotle semantic context pack

Generated: 2026-07-04T11:04:25
Query: `finite polymer Kotecky Preiss cluster expansion tree graph tail bound PolymerKPCriterion`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/checkerboard-kernel-closed-forms-aristotle-2026-06-21.md` [Why this target]

Score: `0.740`

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

### 2. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [C110_PathSumControl]

Score: `0.721`

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

### 3. `PhysicsSM/Draft/CheckerboardKernelClosedFormsAristotle.lean` [with]

Score: `0.719`

```text
import PhysicsSM.Draft.CheckerboardCornerPolynomialAristotle
import PhysicsSM.Draft.CheckerboardCornerClosedFormsAristotle

/-!
# Draft.CheckerboardKernelClosedFormsAristotle

Focused Aristotle handoff: combine the corner-count polynomial theorem with
the binomial corner-count closed forms to get endpoint-level closed forms for
the finite checkerboard path sum.

The imported draft files already prove:

- the path sum is a polynomial in the corner weight, with coefficients given
  by fixed-endpoint corner classes;
- the right-incoming corner classes have binomial closed forms.

The target here is the publication-facing kernel statement: for a path from
`0` to displacement `p - q` in `p + q` lightlike steps, starting incoming
right, the directed endpoint path sum is the corresponding finite polynomial
in `mu`.

This is still finite combinatorics.  No continuum limit or analytic
normalization is asserted here.
-/
```

### 4. `AgentTasks/null-edge-codex-overnight-run-ledger-2026-06-23.md` [Literature pass: C4 coarse-graining operator guardrail]

Score: `0.716`

```text
## Literature pass: C4 coarse-graining operator guardrail

Semantic Scholar remained rate-limited, so this pass used OpenAlex, Crossref,
arXiv, and the local Neo4j paper index. The local index confirmed that the
already-added Laplacian coarse-graining sources `AN5RZGJZ` and `UR5ADCBP` are
the closest existing project anchors.

New source added to Zotero collection `9W59V3K9`:

- `PTU4XM4U`: Andreas Loukas, "Graph reduction with spectral and cut
  guarantees," arXiv `1808.10650`.

Neo4j link added:

- `PTU4XM4U` supports claim `P9_prespecified_coarse_graining_operator`.

Scientific consequence: the C4 P9 pilot should not invent or tune a
coarse-graining map after seeing the output. It should choose `R` from an
established graph/cellular reduction family with spectral/cut guarantees, then
test whether `tr(R K R^T)` has a stable, geometry-moving plateau.

Docs updated:

- `Sources/Null_Edge_Key_Conjectures.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
```

### 5. `AgentTasks/checkerboard-corner-polynomial-split-aristotle-2026-06-13.md` [Mathematical Intent]

Score: `0.715`

```text
## Mathematical Intent

This is the algebraic bridge from the raw finite path sum in
`PhysicsSM.Spinor.Checkerboard` to the discrete Bessel-kernel viewpoint: the
kernel is a finite polynomial in the corner weight `mu`, with coefficients
given by exact corner-class cardinalities.

This job is intentionally split off from the binomial closed-form problem, so
Aristotle can focus on the list/filter partitioning, endpoint translation,
turn-count weight, and flip symmetry.
```

### 6. `AgentTasks/checkerboard-kernel-closed-forms-aristotle-2026-06-21.md` [Claim boundary]

Score: `0.713`

```text
## Claim boundary

This is finite combinatorics only.

It does not prove:

- a continuum limit;
- Bessel-function asymptotics;
- equality with the analytic Dirac propagator;
- a four-dimensional checkerboard theorem.
```

### 7. `PhysicsSM/Draft/CheckerboardCornerCountAristotle.lean` [pathWeight_eq_pow_turnCount]

Score: `0.713`

```text
theorem pathWeight_eq_pow_turnCount [Semiring S] (mu : S)
    (d : Direction) (h : List Direction) :
    pathWeight mu d h = mu ^ turnCount d h := by
  induction' h with e rest ih generalizing d;
  · simp +decide;
  · cases d <;> cases e <;> simp +decide [ *, pow_add ];
    · rw [ turnCount_cons ] ; simp +decide;
    · simp +decide [ *, turnWeight, turnCount ];
      rw [ pow_add, pow_one ];
    · simp +decide [ turnWeight, turnCount ];
      rw [ pow_add, pow_one ];
    · rw [ turnCount_cons ] ; simp +decide

/-! ## Target 2: the path sum as a corner-counting polynomial -/

/-
**Discrete kernel expansion.**  The finite checkerboard path sum is the
polynomial in the corner weight `mu` whose `k`-th coefficient is the number
of length-`n` histories with the prescribed endpoint data and exactly `k`
corners.
-/
```

### 8. `AgentTasks/null-edge-order-complex-design-prompt-20260622.md` [Aristotle prompt: finite order-complex / graph Kahler-Dirac API (design)]

Score: `0.712`

```text
# Aristotle prompt: finite order-complex / graph Kahler-Dirac API (design)

Roadmap/scaffold job, not a proof job. Do not build the whole repo. Deliverable:
a minimal Lean module API (definitions, theorem signatures, proof sketches,
dependencies, blockers). Label unproved nodes as handoffs; no kernel-proof claims.
```

## Scoped paper hits

### 1. Laplacian Coarse Graining in Complex Networks

Score: `0.707`
Zotero key: `UR5ADCBP`
arXiv: `2302.07093`
URL: http://arxiv.org/abs/2302.07093

### 2. Graph Sparsification by Effective Resistances

Score: `0.707`
Zotero key: `UFHN99H4`
arXiv: `0803.0929`
DOI: `10.1137/080734029`
URL: https://doi.org/10.1137/080734029

### 3. Tri-partitions and Bases of an Ordered Complex

Score: `0.701`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x

### 4. Matching number, Hamiltonian graphs and magnetic Laplacian matrices

Score: `0.690`
Zotero key: `GNEARI9Q`
arXiv: `2010.08828`
DOI: `10.1016/j.laa.2022.02.006`
URL: https://doi.org/10.1016/j.laa.2022.02.006

### 5. The mass of simple and higher-order networks

Score: `0.683`
Zotero key: `8ITHD4PG`
arXiv: `2309.07851`
DOI: `10.1088/1751-8121/ad0fb5`
URL: http://arxiv.org/abs/2309.07851
