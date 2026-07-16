# Aristotle semantic context pack

Generated: 2026-07-13T05:15:29
Query: `scalar Klein inequality equality doubly stochastic matrix probability eigenvalue overlap zero lambda positive mu`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/Goal1Hadron.lean` [discr_nonneg]

Score: `0.773`

```text
theorem discr_nonneg (d : Fin 3 → ℝ) (kappa : ℝ) : 0 ≤ discr d kappa :=
  add_nonneg (div_nonneg (sq_nonneg _) zero_le_four) (sq_nonneg _)

/-- The defining quadratic relation of the least eigenvalue: `(a-μ)(c-μ) = κ²`. -/
```

### 2. `AgentTasks/model-calls/claude/2026-07-08-004503-fable-call-03.md` [Response stdout]

Score: `0.771`

```text
g B] (G₁ G₂ : B) :\n172\t    (!![0, G₁; G₂, 0] : Matrix (Fin 2) (Fin 2) B) ^ 2 = 0\n173\t      ↔ G₁ * G₂ = 0 ∧ G₂ * G₁ = 0 := by\n174\t  have hsq : (!![0, G₁; G₂, 0] : Matrix (Fin 2) (Fin 2) B)\n175\t      * !![0, G₁; G₂, 0] = !![G₁ * G₂, 0; 0, G₂ * G₁] := by\n176\t    ext i j\n177\t    fin_cases i <;> fin_cases j <;>\n178\t      simp [Matrix.mul_apply, Fin.sum_univ_two]\n179\t  rw [sq, hsq]\n180\t  constructor\n181\t  · intro hQ\n182\t    refine ⟨?_, ?_⟩\n183\t    · have := congrFun (congrFun hQ 0) 0; simpa using this\n184\t    · have := congrFun (congrFun hQ 1) 1; simpa using this\n185\t  · rintro ⟨h1, h2⟩\n186\t    ext i j\n187\t    fin_cases i <;> fin_cases j <;> simp [h1, h2]\n188\t\n189\tend PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia\n190\t"}]},"parent_tool_use_id":null,"session_id":"e6c6e3b0-0265-4770-b1a6-d84ed8d06188","uuid":"b2127190-05ec-42a0-a32f-332bd6dad3a6","timestamp":"2026-07-08T07:30:50.662Z","tool_use_result":{"type":"text","file":{"filePath":"C:\\Projects\\StandardModel\\PhysicsSM\\Draft\\NullEdge\\GateYM\\S1CCBalancedInertia.lean","content":"/-\n# S1-CC: closure is balanced (not positive) on the physical sector\n\nDRAFT (kernel-clean; no `s o r r y`). The kernel core of the Fable call-01\nresolution of the central positivity crux (S1-CC), overnight all-mass run\n2026-07-08. The full analysis is in the call log\n(`AgentTasks/model-calls/claude/2026-07-07-231939-fable-call-01.md`,\nPart B) and summarized in the QCD roadmap.\n\n## The finding (grade MEMO for the physics, M for this file)\n\nThe nonabelian closure channel is an
...[truncated]
```

### 3. `PhysicsSM/Draft/NullEdge/NullChainJointWitness.lean` [krein_pos]

Score: `0.771`

```text
lemma krein_pos : star e2 ⬝ᵥ Jc.mulVec e2 = 1 := by
  norm_num [ e2, Jc, dotProduct ];
  simp +decide [ Fin.sum_univ_succ, vecHead, vecTail ]

/-
The Krein spectral square has `e2` as eigenvector with eigenvalue `mu^2`.
-/
```

### 4. `PhysicsSM/Draft/NullEdge/Carrier/InteractingTwoBody.lean` [discr_nonneg]

Score: `0.770`

```text
theorem discr_nonneg (d : Fin 3 → ℝ) (kappa : ℝ) : 0 ≤ discr d kappa := by
  exact add_nonneg ( div_nonneg ( sq_nonneg _ ) zero_le_four ) ( sq_nonneg _ )

/-
The defining quadratic relation of the least eigenvalue: with `a = d0+d1`,
`c = d0+d2`, `boundEnergy` satisfies `(a - μ)(c - μ) = κ²`.
-/
```

### 5. `PhysicsSM/Draft/NullEdge/FiniteSSBDegeneracyNoGo.lean` [pureDensity]

Score: `0.764`

```text
noncomputable def pureDensity {n : Nat} (psi : Fin n → ℂ) :
    Matrix (Fin n) (Fin n) ℂ :=
  fun i j => psi i * star (psi j)

/-- A displayed eigenvalue is simple when every eigenvector at that value is a
scalar multiple of the chosen nonzero vector. -/
```

## Scoped paper hits

### 1. An analysis of completely-positive trace-preserving maps on M2

Score: `0.726`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 2. An Analysis of Completely-Positive Trace-Preserving Maps on 2x2 Matrices

Score: `0.724`
Zotero key: `PKMDHXHA`
arXiv: `quant-ph/0101003`
URL: http://arxiv.org/abs/quant-ph/0101003

Abstract:

We give a useful new characterization of the set of all completely positive, trace-preserving (i.e., stochastic) maps from 2x2 matrices to 2x2 matrices. These conditions allow one to easily check any trace-preserving map for complete positivity. We also determine explicitly all extreme points of this set, and give a useful parameterization after reduction to a certain canonical form.

### 3. Some Identities for the Quantum Measure and its Generalizations

Score: `0.721`
Zotero key: `arxiv:gr-qc/9903015`
arXiv: `gr-qc/9903015`
DOI: `10.1142/S0217732302007041`
URL: http://arxiv.org/abs/gr-qc/9903015

Abstract:

Algebraic identities for Sorkin generalized measure theory and the hierarchy of sum rules, including the quantum grade-2 measure condition.

### 4. Matching number, Hamiltonian graphs and magnetic Laplacian matrices

Score: `0.719`
Zotero key: `GNEARI9Q`
arXiv: `2010.08828`
DOI: `10.1016/j.laa.2022.02.006`
URL: https://doi.org/10.1016/j.laa.2022.02.006
