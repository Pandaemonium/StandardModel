import Mathlib

/-!
# Draft.NullEdgeTasteOnlyOriginNoGo

Aristotle task C88 (Wave 20): the finite no-go from the C83 taste-involution
origin-polarization audit
(`AgentTasks/null-edge-taste-involution-origin-polarization-audit.md`).

## Statement in words

A **taste-only** involution `T` that acts as a single *scalar* `t = ±1` on the
whole origin corner cannot turn a `Γ_s`-balanced two-line origin kernel into a
single-chirality ("origin-polarized") kernel.

## Finite model

We use a two-dimensional complex space with basis `ePlus`, `eMinus`, and the
chirality grading `Γ_s = diag(1, -1)`:

```text
Γ_s ePlus  = + ePlus       (a `+` chirality line)
Γ_s eMinus = − eMinus      (a `−` chirality line)
```

The two origin kernel lines sit in the **same** taste corner, so a taste-only
involution acts there as a single scalar `c • I` with `c ∈ {+1, −1}`. The
modified chirality operator is therefore

```text
Γ_f = Γ_s · (c • I) = c • Γ_s,
```

whose eigenvalues on `{ePlus, eMinus}` are `{c, −c}` — still one `+` line and one
`−` line, never a single chirality. Splitting the two origin chiralities would
require an operator that acts *relatively* on the two spinor lines (a Weyl /
chirality projector), which is precisely *not* a taste-only scalar.

## Theorem package

* `tasteOnly_origin_balanced` — `Γ_s` is balanced on the origin kernel: it acts
  as `+1` on `ePlus`, `−1` on `eMinus`, with vanishing trace.
* `tasteOnly_modifiedChirality_still_balanced` — for any taste scalar `c`,
  `Γ_f = c • Γ_s` is again balanced (eigenvalues `c` and `−c`, vanishing trace).
* `tasteOnly_not_originPolarized` — for a taste **involution** (`c ∈ {±1}`),
  `Γ_f` is not origin-polarized: there is no single eigenvalue shared by both
  origin lines.
* `originPolarization_requires_nonTasteProjector` — packaged guardrail: any
  origin-polarizing operator on this model cannot be of the taste-only form
  `c • Γ_s` with `c ≠ 0`. Hence origin polarization requires a non-taste
  (spinor-line / Weyl) projector.

## Scope

This rules out **taste-only / scalar-on-origin** involutions only, matching C83.
It makes no claim that no auxiliary layer exists: projected Weyl, domain-wall,
overlap, or other spinor-line projectors remain open possibilities and are
exactly the objects this no-go points to.
-/

namespace PhysicsSM.Draft.NullEdgeTasteOnlyOriginNoGo

open Matrix

/-- The `+` chirality origin line. -/
def ePlus : Fin 2 → ℂ := ![1, 0]

/-- The `−` chirality origin line. -/
def eMinus : Fin 2 → ℂ := ![0, 1]

/-- The chirality grading `Γ_s = diag(1, -1)` on the two origin lines. -/
noncomputable def GammaS : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- A taste-only involution acts on the single origin corner as the scalar
`c • I`. -/
noncomputable def tasteScalar (c : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  c • (1 : Matrix (Fin 2) (Fin 2) ℂ)

/-- The taste-modified chirality operator `Γ_f = Γ_s · (c • I)`. -/
noncomputable def GammaF (c : ℂ) : Matrix (Fin 2) (Fin 2) ℂ := GammaS * tasteScalar c

/-- `Γ_f = c • Γ_s`: the taste scalar just rescales the grading. -/
theorem GammaF_eq_smul (c : ℂ) : GammaF c = c • GammaS := by
  rw [GammaF, tasteScalar, Matrix.mul_smul, Matrix.mul_one]

/-- The two origin lines are linearly independent (in particular both nonzero). -/
theorem ePlus_ne_eMinus_indep : ePlus ≠ 0 ∧ eMinus ≠ 0 := by
  refine ⟨fun h => ?_, fun h => ?_⟩
  · have := congrFun h 0; simp [ePlus] at this
  · have := congrFun h 1; simp [eMinus] at this

/--
**Origin balanced.** `Γ_s` acts as `+1` on `ePlus` and `−1` on `eMinus`, and has
vanishing trace: the origin kernel is a balanced `{+, −}` pair.
-/
theorem tasteOnly_origin_balanced :
    GammaS *ᵥ ePlus = (1 : ℂ) • ePlus ∧
    GammaS *ᵥ eMinus = (-1 : ℂ) • eMinus ∧
    Matrix.trace GammaS = 0 := by
  refine ⟨?_, ?_, ?_⟩
  · funext i; fin_cases i <;>
      simp [GammaS, ePlus, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  · funext i; fin_cases i <;>
      simp [GammaS, eMinus, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  · simp [GammaS, Matrix.trace, Matrix.diag, Fin.sum_univ_two]

/--
**Modified chirality still balanced.** For *any* taste scalar `c`, the modified
operator `Γ_f = c • Γ_s` still acts as `c` on `ePlus` and `−c` on `eMinus`, with
vanishing trace. So a taste-only modification keeps one `+` line and one `−`
line.
-/
theorem tasteOnly_modifiedChirality_still_balanced (c : ℂ) :
    GammaF c *ᵥ ePlus = c • ePlus ∧
    GammaF c *ᵥ eMinus = (-c) • eMinus ∧
    Matrix.trace (GammaF c) = 0 := by
  obtain ⟨hp, hm, ht⟩ := tasteOnly_origin_balanced
  refine ⟨?_, ?_, ?_⟩
  · rw [GammaF_eq_smul, Matrix.smul_mulVec, hp]; simp [smul_smul]
  · rw [GammaF_eq_smul, Matrix.smul_mulVec, hm]; simp [smul_smul]
  · rw [GammaF_eq_smul, Matrix.trace_smul, ht, smul_zero]

/--
An operator `M` is **origin-polarized** if both origin lines are eigenvectors
sharing a *single* eigenvalue `ε` — i.e. the surviving origin sector is a single
chirality.
-/
def OriginPolarized (M : Matrix (Fin 2) (Fin 2) ℂ) : Prop :=
  ∃ ε : ℂ, M *ᵥ ePlus = ε • ePlus ∧ M *ᵥ eMinus = ε • eMinus

/--
**Taste-only no-go.** For a taste **involution** (`c ∈ {+1, −1}`), the modified
chirality `Γ_f` is *not* origin-polarized: the two origin lines carry opposite
eigenvalues `c` and `−c`, which cannot coincide. Hence a scalar-on-origin
involution cannot make the balanced two-line origin kernel single-chirality.
-/
theorem tasteOnly_not_originPolarized (c : ℂ) (hc : c = 1 ∨ c = -1) :
    ¬ OriginPolarized (GammaF c) := by
  rintro ⟨ε, hp, hm⟩
  obtain ⟨hgp, hgm, _⟩ := tasteOnly_modifiedChirality_still_balanced c
  rw [hgp] at hp
  rw [hgm] at hm
  -- read off c = ε from the ePlus line and -c = ε from the eMinus line
  have e1 : c = ε := by
    have := congrFun hp 0
    simpa [ePlus, smul_eq_mul] using this
  have e2 : -c = ε := by
    have := congrFun hm 1
    simpa [eMinus, smul_eq_mul] using this
  have hc0 : c = 0 := by
    have : c = -c := e1.trans e2.symm
    linear_combination (this) / 2
  rcases hc with h | h <;> rw [h] at hc0 <;> norm_num at hc0

/--
**Origin polarization requires a non-taste projector.** Any origin-polarizing
operator on this model cannot be of the taste-only form `c • Γ_s` with a nonzero
scalar `c` (equivalently `Γ_f = Γ_s · (c • I)`). In particular it cannot be a
taste involution. Thus polarizing the origin requires a genuinely non-taste
operator — a spinor-line / Weyl projector — not a scalar-on-origin involution.
-/
theorem originPolarization_requires_nonTasteProjector
    (M : Matrix (Fin 2) (Fin 2) ℂ) (hM : OriginPolarized M) :
    ¬ ∃ c : ℂ, c ≠ 0 ∧ M = GammaF c := by
  rintro ⟨c, hc0, rfl⟩
  obtain ⟨ε, hp, hm⟩ := hM
  obtain ⟨hgp, hgm, _⟩ := tasteOnly_modifiedChirality_still_balanced c
  rw [hgp] at hp
  rw [hgm] at hm
  have e1 : c = ε := by
    have := congrFun hp 0
    simpa [ePlus, smul_eq_mul] using this
  have e2 : -c = ε := by
    have := congrFun hm 1
    simpa [eMinus, smul_eq_mul] using this
  have : c = -c := e1.trans e2.symm
  exact hc0 (by linear_combination (this) / 2)

end PhysicsSM.Draft.NullEdgeTasteOnlyOriginNoGo
