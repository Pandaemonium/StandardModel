# Aristotle semantic context pack

Generated: 2026-07-09T21:29:37
Query: `positive 2x2 momentum factorization unitary special unitary little group null spin`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/SpinorHelicityRankOneAristotle.lean` [momentumOf_null]

Score: `0.807`

```text
theorem momentumOf_null (lam : Fin 2 → ℂ) :
    (momentumOf lam 0) ^ 2
      = (momentumOf lam 1) ^ 2 + (momentumOf lam 2) ^ 2
        + (momentumOf lam 3) ^ 2 := by
  unfold momentumOf;
  simp +decide [ Complex.normSq, Complex.mul_re, Complex.mul_im ] ; ring

/-
The momentum of a 2-spinor is future-pointing (weakly).
-/
```

### 2. `PhysicsSM/Draft/SpinorHelicityRankOneAristotle.lean` [minkHerm_momentumOf]

Score: `0.806`

```text
theorem minkHerm_momentumOf (lam : Fin 2 → ℂ) :
    minkHerm (momentumOf lam) = rankOne lam := by
  unfold minkHerm rankOne momentumOf;
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff, Matrix.vecMulVec ] <;> ring;
  · erw [ Matrix.cons_val_succ' ] ; norm_num ; ring;
    rw [ Complex.normSq_apply, sq, sq ];
  · erw [ Matrix.cons_val_succ' ] ; norm_num ; ring;
  · exact ⟨ trivial, rfl ⟩;
  · erw [ Matrix.cons_val_succ' ] ; norm_num [ Complex.normSq ] ; ring

/-
The momentum of a 2-spinor is null.
-/
```

### 3. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Spinor-helicity rank-one factorization]

Score: `0.797`

```text
### Spinor-helicity rank-one factorization

`PhysicsSM.Draft.SpinorHelicityRankOneAristotle` proves the complex
rank-one factorization of future null 4-momenta.

`PhysicsSM.Draft.SpinorHelicityQuaternionAristotle` extends the analogous
idea to the quaternionic 6-dimensional case.

These modules remain useful bases for adjacent Pluecker, twistor, and
null-step theorem packages.
```

### 4. `Sources/NERD_4.md` [4.4 Synthesis: U(2) = spin × clock — the minimal-split gauge group factorizes]

Score: `0.795`

```text
### 4.4 Synthesis: U(2) = spin × clock — the minimal-split gauge group factorizes
U(2) ≅ (SU(2) × U(1))/ℤ₂. So the redundancy of a minimal null split of a
massive momentum splits into exactly two physical gauge structures:

    SU(2)  = the massive little group  (spin frame)      [review's I1.7]
    U(1)   = the determinant line       (internal clock)  [Gate I3]

and the ℤ₂ identification (−I, −1) is the spinorial double-valuedness that
makes the clock the square root of the det-line motion (Prop. I3.5). One
sentence for the paper: **spin and time are the two factors of the
minimal-split gauge group; the momentum forgets both.** This is the cleanest
conceptual output of the v2.1 revision and costs three finite lemmas
(U(2)/SU(2) ≅ U(1); the ℤ₂ quotient; I3.5).

---
```

### 5. `Sources/NERD_2.md` [1.3 The little group is the splitting gauge]

Score: `0.788`

```text
### 1.3 The little group is the splitting gauge

Decomposing a timelike $P$ into two null edges is not unique: the pair $(\lambda_1,\lambda_2)$ can be rotated by $\mathrm{SU}(2)$ (acting on the pair index) without changing $P$. But this $\mathrm{SU}(2)$ is precisely the **massive little group** of modern massive spinor-helicity (Arkani-Hamed–Huang–Huang). The theory therefore gets, for free:

> The internal $\mathrm{SU}(2)$ little-group fiber of a massive particle *is* the gauge redundancy of its decomposition into a pair of null edges.

Spin of a massive particle is not extra structure bolted onto the graph. It is the residual symmetry of the null split.
```

### 6. `PhysicsSM/Draft/SpinorHelicityRankOneAristotle.lean` [momentumOf_nonneg]

Score: `0.785`

```text
theorem momentumOf_nonneg (lam : Fin 2 → ℂ) : 0 ≤ momentumOf lam 0 := by
  exact div_nonneg ( add_nonneg ( Complex.normSq_nonneg _ ) ( Complex.normSq_nonneg _ ) ) zero_le_two

/-! ## Target 3: the rank-one factorization theorem -/

/-
**Spinor-helicity rank-one factorization** (`K = C`, `d = 4`).  A real
4-vector is null and future-pointing iff its Hermitian matrix is a rank-one
bispinor `lambda lambda^dagger`.
-/
```

### 7. `Sources/NERD_2.md` [1.5 Gate I1 (new, finite-dimensional, Lean-tractable)]

Score: `0.784`

```text
### 1.5 Gate I1 (new, finite-dimensional, Lean-tractable)

1. $\det(p_\mu\sigma^\mu) = p^2$ (soldering determinant).
2. PSD rank-one factorization: future-null $\iff P = \lambda\lambda^\dagger$.
3. Cauchy–Binet mass identity $\det(LL^\dagger) = \sum_{i<j}|\langle ij\rangle|^2$ and its equality with the cross-term expansion.
4. Little-group theorem: stabilizer of $P$ under right action on $L$ is $\mathrm{U}(2)$ (with $\mathrm{SU}(2)$ as the spin part).

Every item is finite matrix algebra. This is the cheapest nontrivial formal target in the entire program and can run in parallel with C1 without touching it.

---
```

### 8. `PhysicsSM/Draft/SpinorHelicityQuaternionAristotle.lean` [minkHermQ_momentumOfQ]

Score: `0.783`

```text
theorem minkHermQ_momentumOfQ (lam : Fin 2 → ℍ[ℝ]) :
    minkHermQ (momentumOfQ lam) = rankOneQ lam := by
  ext i j;
  · fin_cases i <;> fin_cases j <;> simp +decide [ minkHermQ, rankOneQ ];
    · simp +decide [ momentumOfQ, vecMulVec ];
      norm_num [ normSq ] ; ring;
    · unfold vecMulVec momentumOfQ quatOf; simp +decide [ Matrix.vecMulVec ] ;
    · simp +decide [ quatOf, momentumOfQ, vecMulVec ];
      ring;
    · simp +decide [ momentumOfQ, vecMulVec ];
      rw [ normSq_def, normSq_def ] ; ring!;
      simp +decide [ Quaternion.re_mul, Quaternion.imI_mul, Quaternion.imJ_mul, Quaternion.imK_mul ] ; ring!;
  · fin_cases i <;> fin_cases j <;> simp +decide [ minkHermQ, rankOneQ, Matrix.vecMulVec ];
    · ring;
    · unfold quatOf momentumOfQ; norm_num [ Quaternion.ext_iff ] ; ring;
      rfl;
    · unfold quatOf momentumOfQ; norm_num [ Quaternion.ext_iff ] ; ring;
      erw [ Matrix.cons_val_succ' ] ; norm_num ; ring;
    · ring;
  · fin_cases i <;> fin_cases j <;> simp +decide [ minkHermQ, rankOneQ, Matrix.vecMulVec_apply, momentumOfQ, quatOf ] <;> ring!;
    · norm_num [ div_eq_mul_inv ];
      erw [ Quaternion.inv_def ] ; norm_num;
    · norm_num [ div_eq_mul_inv ];
      erw [ Quaternion.inv_def ] ; norm_num;
  · fin_cases i <;> fin_cases j <;> simp +decide [ minkHermQ, rankOneQ, Matrix.vecMulVec_apply, momentumOfQ, quatOf ] <;> ring!;
    · norm_num [ div_eq_mul_inv ];
      erw [ Quaternion.inv_def ] ; norm_num;
    · norm_num [ div_eq_mul_inv ];
      erw [ Quaternion.inv_def ] ; norm_num

/-- The momentum of a quaternionic 2-spinor is null. -/
```

## Scoped paper hits

### 1. Momentum bispinor, two-qubit entanglement and twistor space

Score: `0.752`
Zotero key: `3VBEK82X`
arXiv: `1407.2492`
URL: http://arxiv.org/abs/1407.2492

Abstract:

Re-examines massive momentum bispinor symmetry and connects unit-energy future-lightcone geometry with two-qubit entanglement and twistor-space normalization. Important prior-art guardrail for observer-conditioned Pluecker mixedness.

### 2. Massive relativistic particle model with spin from free two-twistor dynamics and its quantization

Score: `0.745`
Zotero key: `zotero:2T3HC5NC`
arXiv: `hep-th/0510161`
DOI: `10.1103/PhysRevD.73.105011`
URL: https://doi.org/10.1103/PhysRevD.73.105011

### 3. Twisted geometries: A geometric parametrisation of SU(2) phase space

Score: `0.741`
Zotero key: `63MQ6KC3`
arXiv: `1001.2748v3`
URL: http://arxiv.org/abs/1001.2748v3

Abstract:

Twisted-geometry parametrization of SU(2) loop-gravity phase space, including face areas, normals, extrinsic angle, gauge-invariant reduced phase space, and connection to closure/geometricity constraints.

### 4. Null twisted geometries

Score: `0.736`
Zotero key: `BC9Q4QNG`
arXiv: `1311.3279v2`
URL: http://arxiv.org/abs/1311.3279v2

Abstract:

Extends twisted-geometry/spin-network ideas to null hypersurfaces using twistors and ISO(2) little-group structure. Useful prior art for the null-edge P9 closure and null-horizon geometry lane.

### 5. On the Dirac Theory of Spin 1/2 Particles and Its Non-Relativistic Limit

Score: `0.726`
Zotero key: `NFMI3A99`
DOI: `10.1103/physrev.78.29`
URL: https://doi.org/10.1103/physrev.78.29
