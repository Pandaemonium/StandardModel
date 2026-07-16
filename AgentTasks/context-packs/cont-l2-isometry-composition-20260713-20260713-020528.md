# Aristotle semantic context pack

Generated: 2026-07-13T02:05:51
Query: `variable measurable pointwise continuous linear isometry composition vector-valued L2 Lp representative almost everywhere exact flow time group`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/ChangingCellFourierL2.lean` [euclideanErrorLp]

Score: `0.797`

```text
def euclideanErrorLp (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  MeasureTheory.Lp.compMeasurePreserving
    (fun x : FourierMomentum3 => WithLp.ofLp x)
    (PiLp.volume_preserving_ofLp (ι := Fin 3))
    (embeddedErrorLp m t M N F)

/-- The explicit measure-preserving domain bridge is an `L2` isometry. -/
```

### 2. `PhysicsSM/Draft/NullEdge/Carrier/CarrierUnitaryFlow.lean` [hermitian_flow_isometry]

Score: `0.789`

```text
noncomputable def hermitian_flow_isometry {n : Type*} [Fintype n] [DecidableEq n]
    {H : Matrix n n ℂ} (hH : H.IsHermitian) (t : ℝ) :
    EuclideanSpace ℂ n ≃ₗᵢ[ℂ] EuclideanSpace ℂ n := by
  set U : Matrix n n ℂ := NormedSpace.exp ((-(t : ℂ)) • (Complex.I • H)) with hU
  have hmem : U ∈ Matrix.unitaryGroup n ℂ := hermitian_flow_mem_unitaryGroup hH t
  have h1 : U * Uᴴ = 1 := Matrix.mem_unitaryGroup_iff.mp hmem
  have h2 : Uᴴ * U = 1 := Matrix.mem_unitaryGroup_iff'.mp hmem
  have hmul : ∀ P Q : Matrix n n ℂ,
      (P * Q).toEuclideanLin = P.toEuclideanLin ∘ₗ Q.toEuclideanLin := by
    intro P Q; ext x i; simp [Matrix.mulVec_mulVec]
  have hone : (1 : Matrix n n ℂ).toEuclideanLin = LinearMap.id := by
    ext x i; simp
  refine LinearEquiv.isometryOfInner
    (LinearEquiv.ofLinear U.toEuclideanLin Uᴴ.toEuclideanLin ?_ ?_) ?_
  · rw [← hmul, h1, hone]
  · rw [← hmul, h2, hone]
  · intro x y
    show inner ℂ (U.toEuclideanLin x) (U.toEuclideanLin y) = inner ℂ x y
    rw [← LinearMap.adjoint_inner_right, ← Matrix.toEuclideanLin_conjTranspose_eq_adjoint,
        ← LinearMap.comp_apply, ← hmul, h2, hone]
    rfl

/-- **Specialization.** The carrier block `MassGapWitness.B lam kappa` generates a
unitary flow: the T2 carrier's time step is a genuine sector isometry, so
`FiniteUnitaryEvolution` fires on the actual carrier. -/
```

### 3. `PhysicsSM/Draft/NullEdge/ChangingMomentumL2Density.lean`

Score: `0.781`

```text
namespace PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density

open ChangingMomentumCellIsometry

/-- Every complex `L2(R^3)` field admits a continuous compactly supported
approximation with arbitrarily small squared error. -/
```

### 4. `PhysicsSM/Draft/NullEdge/FixedMomentumManyStepContinuum.lean` [exactFlow]

Score: `0.780`

```text
def exactFlow (k m t : ℝ) : Mat :=
  NormedSpace.exp ((-(t : ℂ)) • (I • H k m))
```

### 5. `AgentTasks/aristotle-standalone/physical-mass-continuum-audit-20260710/Audit/Inputs/PriorCompositionAudit.md` [C. Fixed-momentum many-step continuum (self-contained; all derived from Mathlib)]

Score: `0.779`

```text
### C. Fixed-momentum many-step continuum (self-contained; all derived from Mathlib)
```
[primitive: Mathlib]  NormedSpace.exp, Matrix.unitaryGroup, L2 operator norm  ═▶
   │
   ├─ abs_one_sub_cos_le, abs_sub_sin_le ─┐
   ├─ norm_H_le, l2_opNorm_le_two_entryMax ┤
   ├─ walk_sub_firstOrder_entry{00,01,10,11}_bound ─▶ walk_sub_firstOrder_entry_bound ─▶ walk_sub_firstOrder_bound
   ├─ norm_exp_sub_one_sub_le ─▶ firstOrder_sub_exactFlow_bound
   │        └──────────────┬───────────────┘
   │                       ▼
   │            one_step_to_exact_flow_bound  (‖walk−flow‖ ≤ Dkm·eps²)
   ├─ walk_mem_unitary, exactFlow_mem_unitary ─▶ unitary_pow_telescope (linear, no eⁿ loss)
   ├─ exactFlow_div_pow (flow(t/n)^n = flow(t))
   │                       ▼
   └──────────▶ fixed_time_many_step_bound ──▶ fixed_time_many_step_tendsto
                          OBSERVABLE: n-step walk → exact Dirac flow, rate Dkm·t²/n
```
```

### 6. `AgentTasks/model-calls/claude/2026-07-08-112828-fable-call-07-dynamics-final.md` [Provenance]

Score: `0.778`

```text
) • (Complex.I • H)) ∈ Matrix.unitaryGroup n ℂ := by
  set A : Matrix n n ℂ := (-(t : ℂ)) • (Complex.I • H) with hA
  have hskew : Aᴴ = -A := skewHermitian_neg_I_smul hH t
  rw [Matrix.mem_unitaryGroup_iff]
  have hstar : star (NormedSpace.exp A) = NormedSpace.exp (-A) := by
    rw [show star (NormedSpace.exp A) = (NormedSpace.exp A)ᴴ from rfl,
        ← Matrix.exp_conjTranspose, hskew]
  rw [hstar, ← Matrix.exp_add_of_commute A (-A) ((Commute.refl A).neg_right),
      add_neg_cancel, NormedSpace.exp_zero]

/-- **Isometry packaging.** The linear map on `EuclideanSpace ℂ n` induced by the
unitary flow `exp(-i t H)` is a `LinearIsometryEquiv`, i.e. a genuine
norm-preserving sector isometry — the object `FiniteUnitaryEvolution` takes as its
step. -/
noncomputable def hermitian_flow_isometry {n : Type*} [Fintype n] [DecidableEq n]
    {H : Matrix n n ℂ} (hH : H.IsHermitian) (t : ℝ) :
    EuclideanSpace ℂ n ≃ₗᵢ[ℂ] EuclideanSpace ℂ n := by
  set U : Matrix n n ℂ := NormedSpace.exp ((-(t : ℂ)) • (Complex.I • H)) with hU
  have hmem : U ∈ Matrix.unitaryGroup n ℂ := hermitian_flow_mem_unitaryGroup hH t
  have h1 : U * Uᴴ = 1 := Matrix.mem_unitaryGroup_iff.mp hmem
  have h2 : Uᴴ * U = 1 := Matrix.mem_unitaryGroup_iff'.mp hmem
  have hmul : ∀ P Q : Matrix n n ℂ,
      (P * Q).toEuclideanLin = P.toEuclideanLin ∘ₗ Q.toEuclideanLin := by
    intro P Q; ext x i; simp [Matrix.mulVec_mulVec]
  have hone : (1 : Matrix n n ℂ).toEuclideanLin = LinearMap.id := by
    ext x i; simp
  refine LinearEquiv.isometryOfInner
    (LinearEquiv.ofLinear U.toEuclideanLin Uᴴ.toEuclideanLin ?_ ?_) ?_
  · rw [← hmul, h1, hone]
  · rw [← hmul, h2, hone]
  · intro x y
    show inner ℂ (U.toEuclideanLin x) (U.toEuclideanLin y) = inner ℂ x y
    rw [← LinearMap.adjoint_inner_right, ← Matrix.toEuclideanLin_con
```

### 7. `AgentTasks/overnight-null-information-run-2026-07-10/2026-07-10_ARISTOTLE_COMPOSITION_LANDINGS_AUDIT_01.md` [C. Fixed-momentum many-step continuum (self-contained; all derived from Mathlib)]

Score: `0.776`

```text
### C. Fixed-momentum many-step continuum (self-contained; all derived from Mathlib)
```
[primitive: Mathlib]  NormedSpace.exp, Matrix.unitaryGroup, L2 operator norm  ═▶
   │
   ├─ abs_one_sub_cos_le, abs_sub_sin_le ─┐
   ├─ norm_H_le, l2_opNorm_le_two_entryMax ┤
   ├─ walk_sub_firstOrder_entry{00,01,10,11}_bound ─▶ walk_sub_firstOrder_entry_bound ─▶ walk_sub_firstOrder_bound
   ├─ norm_exp_sub_one_sub_le ─▶ firstOrder_sub_exactFlow_bound
   │        └──────────────┬───────────────┘
   │                       ▼
   │            one_step_to_exact_flow_bound  (‖walk−flow‖ ≤ Dkm·eps²)
   ├─ walk_mem_unitary, exactFlow_mem_unitary ─▶ unitary_pow_telescope (linear, no eⁿ loss)
   ├─ exactFlow_div_pow (flow(t/n)^n = flow(t))
   │                       ▼
   └──────────▶ fixed_time_many_step_bound ──▶ fixed_time_many_step_tendsto
                          OBSERVABLE: n-step walk → exact Dirac flow, rate Dkm·t²/n
```
```

### 8. `PhysicsSM/Draft/NullEdge/Carrier/CarrierUnitaryFlow.lean` [hermitian_flow_mem_unitaryGroup]

Score: `0.776`

```text
theorem hermitian_flow_mem_unitaryGroup {n : Type*} [Fintype n] [DecidableEq n]
    {H : Matrix n n ℂ} (hH : H.IsHermitian) (t : ℝ) :
    NormedSpace.exp ((-(t : ℂ)) • (Complex.I • H)) ∈ Matrix.unitaryGroup n ℂ := by
  set A : Matrix n n ℂ := (-(t : ℂ)) • (Complex.I • H) with hA
  have hskew : Aᴴ = -A := skewHermitian_neg_I_smul hH t
  rw [Matrix.mem_unitaryGroup_iff]
  have hstar : star (NormedSpace.exp A) = NormedSpace.exp (-A) := by
    rw [show star (NormedSpace.exp A) = (NormedSpace.exp A)ᴴ from rfl,
        ← Matrix.exp_conjTranspose, hskew]
  rw [hstar, ← Matrix.exp_add_of_commute A (-A) ((Commute.refl A).neg_right),
      add_neg_cancel, NormedSpace.exp_zero]

/-- **Isometry packaging.** The linear map on `EuclideanSpace ℂ n` induced by the
unitary flow `exp(-i t H)` is a `LinearIsometryEquiv`, i.e. a genuine
norm-preserving sector isometry — the object `FiniteUnitaryEvolution` takes as its
step. -/
```

## Scoped paper hits

### 1. Hodgelets: Localized Spectral Representations of Flows on Simplicial Complexes

Score: `0.750`
Zotero key: `33X7ZETB`
arXiv: `2109.08728`
URL: http://arxiv.org/abs/2109.08728

### 2. Combinatorial and Hodge Laplacians: Similarities and Differences

Score: `0.721`
Zotero key: `9RE64BCV`
DOI: `10.1137/22M1482299`
URL: https://doi.org/10.1137/22M1482299

### 3. Frustration index and Cheeger inequalities for discrete and continuous magnetic Laplacians

Score: `0.719`
Zotero key: `FNP9V3DT`
DOI: `10.1007/s00526-015-0935-x`
URL: https://doi.org/10.1007/s00526-015-0935-x

### 4. Finite-Difference Approach to the Hodge Theory of Harmonic Forms

Score: `0.706`
Zotero key: `TSAQXS9N`
DOI: `10.2307/2373615`
URL: https://doi.org/10.2307/2373615

### 5. Random Walks on Simplicial Complexes and the Normalized Hodge 1-Laplacian

Score: `0.705`
Zotero key: `N7T76U5H`
arXiv: `1807.05044`
DOI: `10.1137/18M1201019`
URL: https://doi.org/10.1137/18M1201019
