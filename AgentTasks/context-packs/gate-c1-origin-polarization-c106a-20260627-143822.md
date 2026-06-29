# Aristotle semantic context pack

Generated: 2026-06-27T14:38:29
Query: `Gate C1 origin polarization balanced commutant zero chiral index native branch classifier T_br`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/model-calls/claude/2026-06-27-125829-cycle16-c102-c104-review.md` [The no-go fork]

Score: `0.857`

```text
num; ring;

/-! ## Guardrail 3: a taste-only involution cannot polarize the origin kernel

We reuse the C88 balanced-origin model and its no-go verbatim. There
`ePlus`, `eMinus` are the two `Γ_s = ±1` origin lines, `GammaS` is the chirality
grading, and `OriginPolarized M` means both origin lines share a *single*
eigenvalue of `M` (one chirality). A taste-only classifier `T_br = c • I`
produces `Γ_s · T_br = c • Γ_s`, which is again balanced. -/

open PhysicsSM.Draft.NullEdgeTasteOnlyOriginNoGo

/--
**Guardrail 3 (`TbrTasteOnlyOnOrigin → cannot polarize balanced origin`).**
A taste-only branch classifier `T_br = c • I` with `c ∈ {+1, -1}` (an involution)
cannot polarize the balanced origin kernel: the induced chirality operator
`Γ_s · T_br` is not origin-polarized.
-/
theorem tasteOnlyOnOrigin_cannot_polarize (c : ℂ) (hc : c = 1 ∨ c = -1) :
    ¬ OriginPolarized
        (GammaS * (c • (1 : Matrix (Fin 2) (Fin 2) ℂ))) := by
  convert tasteOnly_not_originPolarized c hc using 1

/-! ## The bundled branch classifier object and a realizability witness -/

/-- A **branch classifier** object on carrier size `n`, for gauge action `G`,
balanced origin kernel `k`, and retained/mirror germs `vR`, `vM`: the involution
`T_br` together with gauge-neutrality, non-scalarity on the origin kernel, and
germ separation. This is the *algebraic* template; physical locality, Krein
safety, and ghost-zero safety are NOT part of it and are the open Gate C1 data. -/
structure BranchClassifier (n : ℕ) (G : Set (CMat n)) {ι : Type*}
    (k : ι → (Fin n → ℂ)) (vR vM : Fin n → ℂ) where
  /-- The classifier involution `T_br`. -/
  T : CMat n
  /-- `T_br² = 1`. -/
  involution : TbrInvolution T
  /-- `T_br` commutes with the gauge action. -/
  gaugeNeutral : TbrGaugeNeutral T G
  /-- `T_br` is genuinel
```

### 2. `AgentTasks/model-calls/claude/2026-06-27-125829-cycle16-c102-c104-review.md` [The no-go fork]

Score: `0.852`

```text
er involution `T_br`. -/
  T : CMat n
  /-- `T_br² = 1`. -/
  involution : TbrInvolution T
  /-- `T_br` commutes with the gauge action. -/
  gaugeNeutral : TbrGaugeNeutral T G
  /-- `T_br` is genuinely non-scalar on the balanced origin kernel. -/
  nonScalarOnOrigin : TbrNonScalarOnOriginKernel T k
  /-- `T_br` separates the retained and mirror branch germs. -/
  separatesGerms : TbrSeparatesBranchGerms T vR vM

/--
**Realizability witness (algebraic only).** The chirality grading `Γ_s` on
the C88 balanced-origin model is a branch classifier in the abstract algebraic
sense, for the trivial gauge set `{1}`, with origin kernel `![ePlus, eMinus]`
and germs `ePlus` (retained) / `eMinus` (mirror). This shows the predicate layer
is *not vacuous*. It does NOT discharge Gate C1: locality, a nontrivial gauge
action, Krein safety, and ghost-zero safety are outside this structure and remain
open.
-/
theorem branchClassifier_witness :
    Nonempty (BranchClassifier 2 {(1 : CMat 2)}
      (![ePlus, eMinus] : Fin 2 → (Fin 2 → ℂ)) ePlus eMinus) := by
  use GammaS;
  · ext i j; fin_cases i <;> fin_cases j <;> norm_num [ GammaS ] ;
  · exact fun g hg => by rw [ Set.mem_singleton_iff.mp hg ] ; exact Commute.one_right _;
  · use 0, 1
    simp [ePlus, eMinus, GammaS];
    exact ⟨ 1, -1, by norm_num, by ext i; fin_cases i <;> rfl, by ext i; fin_cases i <;> rfl ⟩;
  · exact ⟨ 1, -1, by norm_num, by simp +decide [ tasteOnly_origin_balanced ], by simp +decide [ tasteOnly_origin_balanced ] ⟩

/-! ## The C1 no-go fork -/

/-- The candidate routes for the Gate C1 (physical chiral release) construction. -/
inductive C1Route
  /-- A genuinely local, gauge-safe branch classifier / projector `T_br`/`Π_br`. -/
  | localBranchClassifier
  /-- A domain-wall construction. -/
  | domainWall
  /-- A projec
```

### 3. `PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean` [tasteOnlyOnOrigin_cannot_polarize]

Score: `0.848`

```text
theorem tasteOnlyOnOrigin_cannot_polarize (c : ℂ) (hc : c = 1 ∨ c = -1) :
    ¬ OriginPolarized
        (GammaS * (c • (1 : Matrix (Fin 2) (Fin 2) ℂ))) := by
  convert tasteOnly_not_originPolarized c hc using 1

/-! ## The bundled branch classifier object and a realizability witness -/

/-- A **branch classifier** object on carrier size `n`, for gauge action `G`,
balanced origin kernel `k`, and retained/mirror germs `vR`, `vM`: the involution
`T_br` together with gauge-neutrality, non-scalarity on the origin kernel, and
germ separation. This is the *algebraic* template; physical locality, Krein
safety, and ghost-zero safety are NOT part of it and are the open Gate C1 data. -/
```

### 4. `PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean` [BranchClassifier]

Score: `0.844`

```text
structure BranchClassifier (n : ℕ) (G : Set (CMat n)) {ι : Type*}
    (k : ι → (Fin n → ℂ)) (vR vM : Fin n → ℂ) where
  /-- The classifier involution `T_br`. -/
  T : CMat n
  /-- `T_br² = 1`. -/
  involution : TbrInvolution T
  /-- `T_br` commutes with the gauge action. -/
  gaugeNeutral : TbrGaugeNeutral T G
  /-- `T_br` is genuinely non-scalar on the balanced origin kernel. -/
  nonScalarOnOrigin : TbrNonScalarOnOriginKernel T k
  /-- `T_br` separates the retained and mirror branch germs. -/
  separatesGerms : TbrSeparatesBranchGerms T vR vM

/--
**Realizability witness (algebraic only).** The chirality grading `Γ_s` on
the C88 balanced-origin model is a branch classifier in the abstract algebraic
sense, for the trivial gauge set `{1}`, with origin kernel `![ePlus, eMinus]`
and germs `ePlus` (retained) / `eMinus` (mirror). This shows the predicate layer
is *not vacuous*. It does NOT discharge Gate C1: locality, a nontrivial gauge
action, Krein safety, and ghost-zero safety are outside this structure and remain
open.
-/
```

### 5. `PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean` [branchClassifier_witness]

Score: `0.827`

```text
theorem branchClassifier_witness :
    Nonempty (BranchClassifier 2 {(1 : CMat 2)}
      (![ePlus, eMinus] : Fin 2 → (Fin 2 → ℂ)) ePlus eMinus) := by
  use GammaS;
  · ext i j; fin_cases i <;> fin_cases j <;> norm_num [ GammaS ] ;
  · exact fun g hg => by rw [ Set.mem_singleton_iff.mp hg ] ; exact Commute.one_right _;
  · use 0, 1
    simp [ePlus, eMinus, GammaS];
    exact ⟨ 1, -1, by norm_num, by ext i; fin_cases i <;> rfl, by ext i; fin_cases i <;> rfl ⟩;
  · exact ⟨ 1, -1, by norm_num, by simp +decide [ tasteOnly_origin_balanced ], by simp +decide [ tasteOnly_origin_balanced ] ⟩

/-! ## The C1 no-go fork -/

/-- The candidate routes for the Gate C1 (physical chiral release) construction. -/
```

### 6. `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [6. Gate C current truth]

Score: `0.827`

```text
## 6. Gate C current truth

Gate C is no longer a simple no-doubling or coefficient-zero problem. The
physical object is determinant/propagator-zero structure.

Named rule:

```text
Gate C is a branch-locus / physical-sector theorem,
not a scalar regulator theorem.
```

Scalar lifting can support Gate C0 species health. It cannot be advertised as
Gate C1 chiral release without branch-line/projector/index data and ghost-safe
inverse-propagator gaps.

Distinguish:

```text
p(q) = 0           coefficient-vector zero
det D(q) = 0      determinant branch / pole candidate
p(q)^2 = 0        massless Clifford branch condition in the flat slash case
```

C21 refuted the old bare alignment hope:

```text
Bare OperatorForcesAlignment is false for the actual four-component symbol.
```

At each nonzero null branch, the raw four-component kernel is expected and now
formalized as:

```text
two-dimensional;
chirality-balanced;
one left Weyl line plus one right Weyl line.
```

Therefore the active target is:

```text
OperatorForcesAlignmentAfterProjection.
```

Gate C release now requires a specified physical branch operator or projected
sector satisfying all of:

```text
NodalSetControlled
BranchProjectorsControlled
ProjectedKernelOneDim
ProjectedChiralityAligned
ProjectedKreinPositive
GhostZeroSafe
SpeciesSplittingAudited
```

Recent blockers:

```text
C43/C44: high branches lie on exact determinant-zero nodal curves.
C64: there are off-branch determinant zeros such as q_star.
C66: there is a cyclotomic/S4 orbit of extra zeros.
The natural g5 split T_lin does not control the full determinant-zero locus.
```

Strategic fork:

```text
Route B1: classify the full determinant-zero locus.
Route B2: after classification, build a richer split term that gaps unwanted
          zeros while pre
```

### 7. `AgentTasks/model-calls/claude/2026-06-27-125829-cycle16-c102-c104-review.md` [Null-Edge Gate C: branch-locus / physical-sector release API (C100)]

Score: `0.820`

```text
# Null-Edge Gate C: branch-locus / physical-sector release API (C100)

This is a small, self-contained finite API for the **C1-facing** part of the
Gate C program.  Task: `null-edge-wave25-c100-branch-locus-sheaf-alternatives`.

The new lateral analysis (context pack
`AgentTasks/context-packs/null-edge-wave25-lateral-analysis-20260627-114614.md`)
proposes treating the raw branch object

```text
Z = { q : det D_+(q) = 0 }
```

as a *branch-index / topological* problem rather than a scalar-coefficient
tuning problem.  The repo already records (and this file does **not** re-prove):

* bare `D_+` has chirality-balanced branch kernels;
* known off-branch and cyclotomic zeros exist;
* scalar Wilson terms may support Gate **C0** species health but cannot release
  **C1** chirality at the origin
  (`PhysicsSM.Draft.NullEdgeGateCSplit`, `NullEdgeGateC0SpeciesHealth`);
* ghost-zero safety forbids removing gauge-charged branches *only* by propagator
  zeros (`PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety`).
```

### 8. `AgentTasks/model-calls/claude/2026-06-27-124149-cycle14-c103-c105-review.md` [Null-Edge Gate C: branch-locus / physical-sector release API (C100)]

Score: `0.820`

```text
# Null-Edge Gate C: branch-locus / physical-sector release API (C100)

This is a small, self-contained finite API for the **C1-facing** part of the
Gate C program.  Task: `null-edge-wave25-c100-branch-locus-sheaf-alternatives`.

The new lateral analysis (context pack
`AgentTasks/context-packs/null-edge-wave25-lateral-analysis-20260627-114614.md`)
proposes treating the raw branch object

```text
Z = { q : det D_+(q) = 0 }
```

as a *branch-index / topological* problem rather than a scalar-coefficient
tuning problem.  The repo already records (and this file does **not** re-prove):

* bare `D_+` has chirality-balanced branch kernels;
* known off-branch and cyclotomic zeros exist;
* scalar Wilson terms may support Gate **C0** species health but cannot release
  **C1** chirality at the origin
  (`PhysicsSM.Draft.NullEdgeGateCSplit`, `NullEdgeGateC0SpeciesHealth`);
* ghost-zero safety forbids removing gauge-charged branches *only* by propagator
  zeros (`PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety`).
```

## Scoped paper hits

### 1. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.695`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 2. An analysis of completely-positive trace-preserving maps on M2

Score: `0.691`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 3. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.691`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 4. An invitation to higher gauge theory

Score: `0.682`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9

### 5. Extension of the Nielsen-Ninomiya theorem

Score: `0.677`
Zotero key: `arxiv:hep-lat/9803002`
arXiv: `hep-lat/9803002`
DOI: `10.1103/PhysRevD.58.057505`
URL: http://arxiv.org/abs/hep-lat/9803002

Abstract:

Extends the Nielsen-Ninomiya no-go theorem for lattice chiral Dirac fermions using the index theorem, including translation non-invariant and non-local formulations.
