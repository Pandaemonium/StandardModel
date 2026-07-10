# Aristotle semantic context pack

Generated: 2026-07-10T01:28:55
Query: `summable envelope infinite Fourier synthesis norm error convergence tsum`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/E8QExpansionExtraction.lean` [qPIMTT]

Score: `0.805`

```text
noncomputable def qPIMTT {d : ℕ} {L : Submodule ℤ (EuclideanSpace ℝ (Fin d))}
    (n : ℕ) (z : L) : C(ℝ, ℂ) :=
  ⟨fun u => (Function.Periodic.qParam (1 : ℝ) ((↑u : ℂ) + Complex.I) ^ n)⁻¹ *
        thetaTermAbstract ((↑u : ℂ) + Complex.I) z,
   continuous_qParamPowInv_mul_thetaTerm n z⟩

/-- Summability of restricted norms for the integral-tsum swap. -/
```

### 2. `PhysicsSM/Draft/E8ThetaDim8MF.lean` [thetaSeriesUHP8]

Score: `0.799`

```text
noncomputable def thetaSeriesUHP8 (z : UpperHalfPlane) : ℂ :=
  thetaSeries8 (z : ℂ)

/-! ## 2. Norm formula and summability -/
```

### 3. `PhysicsSM/Draft/E8QExpansionExtraction.lean` [summable_norm_restrict_qPIMTT]

Score: `0.793`

```text
lemma summable_norm_restrict_qPIMTT {d : ℕ}
    {L : Submodule ℤ (EuclideanSpace ℝ (Fin d))}
    [Countable L]
    (n : ℕ) (hSumm : Summable fun z : L => thetaTermAbstract (Complex.I : ℂ) z) :
    Summable fun z : L =>
      ‖(qPIMTT n z).restrict
        (⟨Set.uIcc 0 1, isCompact_uIcc⟩ : TopologicalSpace.Compacts ℝ)‖ := by
  refine' .of_nonneg_of_le (fun z => norm_nonneg _) (fun z => _)
    (hSumm.norm.mul_left (Real.exp (2 * n * Real.pi)))
  refine' ContinuousMap.norm_le _ _ |>.2 fun u => _
  · positivity
  · convert norm_qParamPowInv_mul_thetaTerm_le n z u.val using 1

/--
Swap `∫₀¹` and `∑'` for the theta integrand, assuming the theta series at
`τ = I` is summable.
-/
```

### 4. `PhysicsSM/Draft/ThetaDuplicationProof.lean` [summable_]

Score: `0.770`

```text
theorem summable_Θ₂_term {τ : ℂ} (hτ : 0 < τ.im) :
    Summable (fun n : ℤ => cexp (↑π * I * ((n : ℂ) + 1 / 2) ^ 2 * τ)) := by
  -- The norm of the exponential term is $e^{-\pi \tau.im (n + 1/2)^2}$, which decays exponentially as $|n|$ increases.
  have h_exp_decay : Summable (fun n : ℤ => Real.exp (-Real.pi * τ.im * (n + 1 / 2) ^ 2)) := by
    have h_gaussian : Summable (fun n : ℤ => Real.exp (-Real.pi * τ.im * n ^ 2 / 2)) := by
      have h_gaussian : Summable (fun n : ℕ => Real.exp (-Real.pi * τ.im * n ^ 2 / 2)) := by
        have h_gaussian : Summable (fun n : ℕ => Real.exp (-Real.pi * τ.im * n / 2)) := by
          have h_gaussian : Summable (fun n : ℕ => (Real.exp (-Real.pi * τ.im / 2)) ^ n) := by
            exact summable_geometric_of_lt_one ( by positivity ) ( by rw [ Real.exp_lt_one_iff ] ; nlinarith [ Real.pi_pos ] );
          exact h_gaussian.congr fun n => by rw [ ← Real.exp_nat_mul ] ; ring;
        simp +zetaDelta at *;
        exact h_gaussian.of_nonneg_of_le ( fun n => by positivity ) fun n => by gcongr ; norm_cast ; nlinarith;
      have h_split : ∀ {f : ℤ → ℝ}, Summable f ↔ Summable (fun n : ℕ => f n) ∧ Summable (fun n : ℕ => f (-n)) := by
        exact fun {f} => summable_int_iff_summable_nat_and_neg
      aesop;
    have h_gaussian : ∀ n : ℤ, Real.exp (-Real.pi * τ.im * (n + 1 / 2) ^ 2) ≤ Real.exp (-Real.pi * τ.im * n ^ 2 / 2) + Real.exp (-Real.pi * τ.im * (n + 1) ^ 2 / 2) := by
      intro n; rcases n with ( _ | n ) <;> norm_num <;> ring_nf <;> norm_num [ Real.pi_pos, hτ ] ;
      · exact le_add_of_le_of_nonneg ( Real.exp_le_exp.mpr <| by nlinarith [ Real.pi_pos, mul_nonneg Real.pi_pos.le hτ.le ] ) ( Real.exp_nonneg _ );
      · exact le_add_of_nonneg_of_le ( Real.exp_nonneg _ ) ( Real.exp_le_exp.mpr ( by nlinarith [ Real.pi_pos, mul_nonneg Real.p
```

### 5. `PhysicsSM/Draft/ThetaDuplicationProof.lean` [myTheta2_sq_duplication]

Score: `0.769`

```text
m by simpa ) using 1;
          exact funext fun n => by ring;
        · convert summable_Θ₂_term ( show 0 < ( 2 * τ |> Complex.im ) by simpa using by positivity ) using 1;
          exact funext fun n => by ring;
      have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (2 * p.1 ^ 2) * τ) * Complex.exp (Real.pi * Complex.I * (2 * (p.2 + 1 / 2) ^ 2) * τ)) := by
        exact .of_norm <| by simpa using Summable.mul_norm ( h_summable.1.norm ) ( h_summable.2.norm ) ;
      convert h_summable using 2 ; push_cast [ ← Complex.exp_add ] ; ring;
  grind

end
```

### 6. `PhysicsSM/Draft/ThetaDuplicationProof.lean` [myTheta4_sq_duplication]

Score: `0.761`

```text
* (p.1 ^ 2 + p.2 ^ 2) * τ) else 0) := by
    rw [ ← Summable.tsum_sub ];
    · refine' tsum_congr fun p => _;
      rcases Int.even_or_odd' ( p.1 + p.2 ) with ⟨ k, hk | hk ⟩ <;> norm_num [ hk, zpow_add₀, zpow_mul ];
    · have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ)) := by
        have h_summable : Summable (fun n : ℤ => Complex.exp (Real.pi * Complex.I * (n : ℂ) ^ 2 * τ)) := by
          convert summable_Θ₃_term hτ using 1;
        have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 : ℂ) ^ 2 * τ) * Complex.exp (Real.pi * Complex.I * (p.2 : ℂ) ^ 2 * τ)) := by
          exact .of_norm <| by simpa using Summable.mul_norm ( h_summable.norm ) ( h_summable.norm ) ;
        convert h_summable using 2 ; push_cast [ ← Complex.exp_add ] ; ring;
      -- Since the original series is summable, any subseries (where we pick some terms and ignore others) is also summable.
      have h_subseries : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ)) → Summable (fun p : ℤ × ℤ => if (p.1 + p.2) % 2 = 0 then Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ) else 0) := by
        intro h_summable
        have h_subseries : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ)) → Summable (fun p : ℤ × ℤ => if (p.1 + p.2) % 2 = 0 then Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ) else 0) := by
          intro h_summable
          have h_abs_summable : Summable (fun p : ℤ × ℤ => ‖Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ)‖) := by
            exact h_summable.norm
          have h_abs_summable : Summable (fun p : ℤ × ℤ => ‖if (p.1 + p.2) % 2 = 0 then Complex.exp (Real.pi * Complex.I * (p.1 ^ 2
```

### 7. `PhysicsSM/NullStrand/NullFiber/RegulatorMeanNorm.lean` [uniformComponent_bounds_meanNorm]

Score: `0.761`

```text
theorem uniformComponent_bounds_meanNorm
    {Ω : Type*} [Fintype Ω] {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (dir : Ω → E) (hdir : ∀ ω, ‖dir ω‖ = 1)
    (u q : Ω → ℝ) (ε : ℝ) (hε0 : 0 ≤ ε) (hε1 : ε ≤ 1)
    (hu_mean : ∑ ω, u ω • dir ω = 0)
    (hq_nonneg : ∀ ω, 0 ≤ q ω) (hq_sum : ∑ ω, q ω = 1) :
    ‖∑ ω, (ε * u ω + (1 - ε) * q ω) • dir ω‖ ≤ 1 - ε := by
  simp +decide only [add_smul, mul_smul]
  rw [Finset.sum_add_distrib, ← Finset.smul_sum, ← Finset.smul_sum, hu_mean, smul_zero, zero_add]
  rw [norm_smul, Real.norm_of_nonneg (sub_nonneg.2 hε1)]
  exact mul_le_of_le_one_right (sub_nonneg.2 hε1)
    (le_trans (norm_sum_le _ _) (by simp +decide [norm_smul, abs_of_nonneg, *]))

end PhysicsSM.NullStrand.NullFiber
```

### 8. `PhysicsSM/Draft/ThetaDuplicationProof.lean` [my]

Score: `0.754`

```text
theorem myΘ₄_eq_jacobiTheta₂ (τ : ℂ) : myΘ₄ τ = jacobiTheta₂ (1 / 2) τ := by
  simp only [myΘ₄, jacobiTheta₂, jacobiTheta₂_term]
  congr 1; ext n
  rw [ ← Complex.exp_log ( by norm_num : ( -1 : ℂ ) ≠ 0 ), ← Complex.exp_int_mul ] ; ring;
  rw [ ← Complex.exp_add, Complex.log ] ; norm_num ; ring;

-- Summability helpers
```

## Scoped paper hits

### 1. Finite element exterior calculus: from Hodge theory to numerical stability

Score: `0.703`
Zotero key: `8JFSI9CS`
DOI: `10.1090/s0273-0979-10-01278-4`
URL: https://doi.org/10.1090/s0273-0979-10-01278-4

### 2. Finite-Difference Approach to the Hodge Theory of Harmonic Forms

Score: `0.702`
Zotero key: `TSAQXS9N`
DOI: `10.2307/2373615`
URL: https://doi.org/10.2307/2373615

### 3. Finite element exterior calculus, homological techniques, and applications

Score: `0.691`
Zotero key: `DM6NREPA`
DOI: `10.1017/s0962492906210018`
URL: https://doi.org/10.1017/s0962492906210018

Abstract:

Finite element exterior calculus is an approach to the design and understanding of finite element discretizations for a wide variety of systems of partial differential equations. This approach brings to bear tools from differential geometry, algebraic topology, and homological algebra to develop discretizations which are compatible with the geometric, topological, and algebraic structures which underlie well-posedness of the PDE problem being solved. In the finite element exterior calculus, many finite element spaces are revealed as spaces of piecewise polynomial differential forms. These connect to each other in discrete subcomplexes of elliptic differential complexes, and are also related to the continuous elliptic complex through projections which commute with the complex differential. Applications are made to the finite element discretization of a variety of problems, including the Hodge Laplacian, Maxwell’s equations, the equations of elasticity, and elliptic eigenvalue problems, and also to preconditioners.

### 4. Frustration index and Cheeger inequalities for discrete and continuous magnetic Laplacians

Score: `0.691`
Zotero key: `FNP9V3DT`
DOI: `10.1007/s00526-015-0935-x`
URL: https://doi.org/10.1007/s00526-015-0935-x

### 5. Correction terms for propagators and d'Alembertians due to spacetime discreteness

Score: `0.690`
Zotero key: `arxiv:1411.2614`
arXiv: `1411.2614`
DOI: `10.1088/0264-9381/32/19/195020`
URL: http://arxiv.org/abs/1411.2614

Abstract:

Finite-sprinkling correction terms for causal-set retarded propagators and d'Alembertian operators compared with continuum limits.
