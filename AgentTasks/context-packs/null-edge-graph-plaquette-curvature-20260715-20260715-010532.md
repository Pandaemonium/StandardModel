# Aristotle semantic context pack

Generated: 2026-07-15T01:06:08
Query: `explicit group-valued square holonomy near-identity matrix links plaquette area normalized curvature signed commutator finite torus residual convergence false-shape audit`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [witnessFirstOrderHolonomyLimit]

Score: `0.822`

```text
def witnessFirstOrderHolonomyLimit :
    FirstOrderHolonomyLimit witnessArea witnessHolonomy (1 : ℝ) 3 := by
  refine ⟨witnessResidual, ?_, ?_, ?_, ?_⟩
  · exact Filter.Eventually.of_forall (fun n => by
      unfold witnessArea
      positivity)
  · change Tendsto (fun n : ℕ => (1 : ℝ) / ((n : ℝ) + 1))
      atTop (nhds 0)
    exact tendsto_one_div_add_atTop_nhds_zero_nat
  · exact Filter.Eventually.of_forall (fun n => rfl)
  · change Tendsto (fun n : ℕ => (1 : ℝ) / ((n : ℝ) + 1))
      atTop (nhds 0)
    exact tendsto_one_div_add_atTop_nhds_zero_nat

/-- The normalized curvature of the explicit nonzero target family converges
to three while its loop area tends to zero. -/
```

### 2. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [FirstOrderHolonomyLimit]

Score: `0.822`

```text
structure FirstOrderHolonomyLimit
    (area : ℕ -> ℝ) (holonomy : ℕ -> E) (base target : E) where
  /-- Normalized first-order error. -/
  residual : ℕ -> E
  /-- Refined loop areas are eventually nonzero, so normalization is defined. -/
  area_ne_zero : ∀ᶠ n in atTop, area n ≠ 0
  /-- The loops shrink in the refinement limit. -/
  area_tendsto_zero : Tendsto area atTop (nhds 0)
  /-- Exact first-order expansion with the displayed residual. -/
  expansion : ∀ᶠ n in atTop,
    holonomy n = base + area n • (target + residual n)
  /-- The normalized first-order error vanishes. -/
  residual_tendsto_zero : Tendsto residual atTop (nhds 0)

/-- **Area-normalized holonomy convergence.** A shrinking-loop first-order
expansion with vanishing normalized residual converges to its curvature
coefficient. -/
```

### 3. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean` [holonomyDefect_swap_eq_zero_iff_commute]

Score: `0.816`

```text
theorem holonomyDefect_swap_eq_zero_iff_commute {d : Type*} [Fintype d] [DecidableEq d]
    (A B : Matrix d d ℂ) :
    holonomyDefect [A, B] [B, A] = 0 ↔ Commute A B := by
  rw [holonomyDefect_swap_eq_commutator, sub_eq_zero]
  exact Iff.rfl

/-- **Failure of path independence from nonvanishing curvature.**

If the matrix commutator (curvature defect) is nonzero, then the two ways around
the elementary square give genuinely different holonomies: synchronization is
path dependent. This is the contrapositive direction of the defect/flatness
correspondence. -/
```

### 4. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [normalizedHolonomyCurvature]

Score: `0.815`

```text
def normalizedHolonomyCurvature
    (area : ℕ -> ℝ) (holonomy : ℕ -> E) (base : E) (n : ℕ) : E :=
  (area n)⁻¹ • (holonomy n - base)

/-- Data certifying a shrinking-loop first-order holonomy expansion. -/
```

### 5. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [normalizedHolonomy_error_le]

Score: `0.810`

```text
theorem normalizedHolonomy_error_le
    (area : ℕ -> ℝ) (holonomy : ℕ -> E) (base target : E)
    (epsilon : ℕ -> ℝ)
    (harea : ∀ᶠ n in atTop, 0 < area n)
    (herror : ∀ᶠ n in atTop,
      ‖holonomy n - base - area n • target‖ ≤ area n * epsilon n) :
    ∀ᶠ n in atTop,
      ‖normalizedHolonomyCurvature area holonomy base n - target‖ ≤
        epsilon n := by
  filter_upwards [harea, herror] with n ha herr
  have hne : area n ≠ 0 := ha.ne'
  have htarget : (area n)⁻¹ • (area n • target) = target := by
    simp [hne, smul_smul]
  have hid :
      normalizedHolonomyCurvature area holonomy base n - target =
        (area n)⁻¹ • (holonomy n - base - area n • target) := by
    unfold normalizedHolonomyCurvature
    calc
      (area n)⁻¹ • (holonomy n - base) - target =
          (area n)⁻¹ • (holonomy n - base) -
            (area n)⁻¹ • (area n • target) := by rw [htarget]
      _ = (area n)⁻¹ • (holonomy n - base - area n • target) :=
        (smul_sub (area n)⁻¹ (holonomy n - base) (area n • target)).symm
  rw [hid, norm_smul, Real.norm_eq_abs, abs_inv, abs_of_pos ha]
  calc
    (area n)⁻¹ * ‖holonomy n - base - area n • target‖
        ≤ (area n)⁻¹ * (area n * epsilon n) :=
      mul_le_mul_of_nonneg_left herr (le_of_lt (inv_pos.mpr ha))
    _ = epsilon n := by field_simp

/-- **Quantitative holonomy convergence interface.** If the raw first-order
remainder is bounded by `area * epsilon` and `epsilon` tends to zero, then the
area-normalized holonomy displacement converges to the target curvature. -/
```

### 6. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [normalizedHolonomy_nonzero_limit_witness]

Score: `0.807`

```text
theorem normalizedHolonomy_nonzero_limit_witness :
    Tendsto witnessArea atTop (nhds 0) ∧
      Tendsto
        (normalizedHolonomyCurvature witnessArea witnessHolonomy (1 : ℝ))
        atTop (nhds 3) :=
  firstOrderHolonomyLimit_converges witnessArea witnessHolonomy 1 3
    witnessFirstOrderHolonomyLimit

/-! ## Curvature-component identities pass to the limit -/
```

### 7. `PhysicsSM/Draft/NullEdge/NonabelianHistoryClosureHolonomy.lean` [square_holonomy_val]

Score: `0.806`

```text
theorem square_holonomy_val :
    (↑(transportFrom squareEdgeField (0 : Fin 4) [1, 2, 3, 0]) :
        Matrix (Fin 2) (Fin 2) ℚ) = !![1, 1; 1, 2] := by
  rw [square_holonomy_eq, Units.val_mul]
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [shearUp, shearDown, Matrix.mul_apply, Fin.sum_univ_two]

/-- The bare holonomy is not the identity: the loop stores nontrivial
closure data. -/
```

### 8. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean` [holonomyDefect_swap_eq_commutator]

Score: `0.806`

```text
theorem holonomyDefect_swap_eq_commutator {d : Type*} [Fintype d] [DecidableEq d]
    (A B : Matrix d d ℂ) :
    holonomyDefect [A, B] [B, A] = A * B - B * A := by
  simp [holonomyDefect, internalHolonomy]

/-- **Curvature defect detects commutativity.**

The elementary-square defect vanishes exactly when the two transports commute,
i.e. path independence around the square is equivalent to vanishing curvature. -/
```

## Scoped paper hits

### 1. Random Walks on Simplicial Complexes and the Normalized Hodge 1-Laplacian

Score: `0.758`
Zotero key: `N7T76U5H`
arXiv: `1807.05044`
DOI: `10.1137/18M1201019`
URL: https://doi.org/10.1137/18M1201019

### 2. Connections on non-abelian Gerbes and their Holonomy

Score: `0.752`
URL: http://arxiv.org/abs/0808.1923

### 3. Combinatorial and Hodge Laplacians: Similarities and Differences

Score: `0.750`
Zotero key: `9RE64BCV`
DOI: `10.1137/22M1482299`
URL: https://doi.org/10.1137/22M1482299

### 4. Frustration index and Cheeger inequalities for discrete and continuous magnetic Laplacians

Score: `0.746`
Zotero key: `FNP9V3DT`
DOI: `10.1007/s00526-015-0935-x`
URL: https://doi.org/10.1007/s00526-015-0935-x

### 5. Hodgelets: Localized Spectral Representations of Flows on Simplicial Complexes

Score: `0.743`
Zotero key: `33X7ZETB`
arXiv: `2109.08728`
URL: http://arxiv.org/abs/2109.08728
