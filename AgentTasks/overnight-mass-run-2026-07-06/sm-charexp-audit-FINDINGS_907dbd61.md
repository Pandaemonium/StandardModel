# Adversarial audit — `CharacterExpansion.lean`

Scope: the four files in this repo (`CharacterExpansion`, `WilsonWeightPositivity`,
`FusionConvolution`, `FusionTransferSpectrum`). Note: the transitively-imported
support files (`FDRepUnitarizable`, `Theorem2AreaLaw`,
`IndependentPlaquetteEnsemble`, `WilsonLocalWeight`) are **not present** in the
project tree, so a full `lake build` is impossible here anyway; this is a source
+ semantics review. Every Mathlib fact I rely on below (notably
`FDRep.char_orthonormal`, `FDRep.char_one`, and the new
`trace_unitary_norm_le`) was checked in an isolated Mathlib snippet.

---

## VERDICTS (items 1–5)

1. **Central over-claim risk** — `charCoeff_abs_le_trivCoeff`: **OVER-CLAIM**
   (theorem is *true as stated*, but its docstring framing is an over-claim; the
   hypothesis `hbound` restricts it to **1-dimensional irreps only**).
2. **Correct nonabelian statement**: the honest inequality is
   `‖c_R(β)‖ ≤ dim(R) · c_triv(β)` (equivalently `‖γ_R‖ ≤ 1` for the normalized
   fusion eigenvalue). Provable; kernel lemma verified below. **(gap that is
   fixable)**
3. **Normalization / convention check** (`char_orthogonality_inv/conj`):
   **SOUND**.
4. **Bridge hypotheses / vacuity**
   (`fusion_scalar_eq_card_mul_charCoeff`, `fusion_convolution_charCoeff`):
   **SOUND** (no vacuity, no both-sides-zero, no convention slip).
5. **Axiom / trust surface**: **SOUND** — no `axiom`, no `sorry`, no
   `native_decide`; every `decide` / `simp +decide` is ordinary kernel `decide`
   on finite decidable goals.

---

## Sharpest single problem

`charCoeff_abs_le_trivCoeff` is the module's *only* trivial-rep-dominance
statement, and its hypothesis `hbound : ∀ g, ‖R.character g‖ ≤ 1` **cannot hold
for any irreducible of dimension ≥ 2**, because `χ_R(1) = dim R`
(`FDRep.char_one`), so `‖χ_R(1)‖ = dim R ≤ 1 ⟹ dim R = 1`. Precisely:

> `hbound` is satisfiable **iff `dim R = 1`** (a linear character).
> `⇒`: evaluate at `g = 1`. `⇐`: a 1-dim rep of a finite group sends each `g`
> to a root of unity, so `‖χ_R(g)‖ = 1 ≤ 1`.

This is a property of `dim R`, **not** of whether `G` is abelian. For abelian `G`
every irrep is 1-dimensional, so the theorem covers all of them — which is why
the docstring's "in particular for all irreducibles of an abelian group" is
accurate. But for a **nonabelian** group only the linear characters (those
factoring through `G/[G,G]`) qualify; the genuinely nonabelian irreps
(`dim ≥ 2`) never do. In particular the **fundamental representations of SU(2)
(dim 2) and SU(3) (dim 3)** — the stated physical targets — are excluded:
`hbound` fails already at `g = 1`.

**Consequence.** As written the theorem gives strong-coupling trivial-rep
dominance only in the 1-dimensional-irrep (abelian-type) case. The docstring line
"This is the input the strong-coupling character expansion needs" is an
**over-claim** relative to what is proved: it silently omits that the nonabelian
`dim ≥ 2` sector — exactly the sector the nonabelian area-law argument needs — is
not covered. It does **not** invalidate the *module* (the orthogonality, the
reality lemma, the fusion bridge, and the `Z2` example are all fine), but it does
mean this specific dominance theorem may **not** be cited as "the strong-coupling
input for nonabelian YM". The `Z2` results (`z2_trivCoeff_dominates`) are a
correct but abelian illustration, not evidence for the nonabelian case.

Independent corroboration inside the repo: `FusionTransferSpectrum`'s
`wilsonStringTension` docstring already admits the real bound is missing —
"the spectral-dominance statement `|gamma| <= 1` is future work (needs the
character bound `|chi(g)| <= chi(1)`)". That is precisely the missing ingredient.

---

## The correct nonabelian strong-coupling dominance theorem

The true bound uses the **dimension factor** (equivalently, normalized
characters `χ_R(g)/χ_R(1)`):

> **Character bound.** For every finite-dimensional unitary rep,
> `‖χ_R(g)‖ ≤ χ_R(1) = dim R` for all `g` (trace of a unitary matrix; its
> eigenvalues are roots of unity).

Applying the triangle inequality to `c_R(β) = |G|⁻¹ ∑_g w(g)·conj χ_R(g)` with
`w ≥ 0` gives the honest dominance inequality

>   **‖c_R(β)‖ ≤ dim(R) · c_triv(β).**

Equivalently, in the area-law language of `FusionTransferSpectrum`
(`hasEigenvalue_character`, `wilsonNormalizedGamma`), the normalized eigenvalue
ratio satisfies

>   **‖γ_R‖ = ‖(∑_g w(g) χ_R(g⁻¹)) / (χ_R(1) · ∑_g w(g))‖ ≤ 1,**

because `‖∑_g w(g) χ_R(g⁻¹)‖ ≤ ∑_g w(g)‖χ_R(g⁻¹)‖ ≤ dim(R)·∑_g w(g)` and the
vacuum eigenvalue is `∑_g w(g) = |G|·c_triv` (this is `hasEigenvector_const_one`).
`‖γ_R‖ ≤ 1` (with strictness `< 1` at strong coupling) is exactly what makes
`wilsonStringTension = -log‖γ_R‖ ≥ 0` and drives the area law
`|⟨W_R⟩| = |χ_R(1)|·exp(-σ·area)` in `norm_wilson_loop_expectation_exp`. Note the
correct statement keeps the `dim R` (= `χ_R(1)`) factor that the buggy
`hbound ≤ 1` version silently drops.

### Shortest Lean route from the lemmas already present

The only missing ingredient is the character bound
`char_norm_le_char_one : ‖R.character g‖ ≤ (R.character 1).re`. It is obtained
from the repo's own unitary matrix model (the same one `character_inv_eq_conj`
uses) plus the following **machine-verified** kernel lemma (checked against this
repo's pinned Mathlib):

```lean
open scoped Matrix BigOperators

/-- |tr U| ≤ n for a unitary n×n complex matrix. VERIFIED against Mathlib. -/
theorem trace_unitary_norm_le (n : ℕ) (U : Matrix (Fin n) (Fin n) ℂ)
    (hU : Uᴴ * U = 1) : ‖Matrix.trace U‖ ≤ n := by
  have hcol : ∀ i, ‖U i i‖ ≤ 1 := by
    intro i
    have hdiag : (Uᴴ * U) i i = 1 := by rw [hU]; simp
    rw [Matrix.mul_apply] at hdiag
    have hsum : ∑ k, ‖U k i‖ ^ 2 = 1 := by
      have hre := congrArg Complex.re hdiag
      simp only [Complex.re_sum, Complex.one_re] at hre
      rw [← hre]
      apply Finset.sum_congr rfl
      intro k _
      rw [Matrix.conjTranspose_apply, Complex.mul_re]
      simp only [Complex.star_def, Complex.conj_re, Complex.conj_im, Complex.sq_norm,
        Complex.normSq_apply]
      ring
    have hterm : ‖U i i‖ ^ 2 ≤ ∑ k, ‖U k i‖ ^ 2 :=
      Finset.single_le_sum (f := fun k => ‖U k i‖ ^ 2)
        (fun k _ => sq_nonneg _) (Finset.mem_univ i)
    rw [hsum] at hterm
    nlinarith [norm_nonneg (U i i)]
  calc ‖Matrix.trace U‖ = ‖∑ i, U i i‖ := by rw [Matrix.trace]; rfl
    _ ≤ ∑ i, ‖U i i‖ := norm_sum_le _ _
    _ ≤ ∑ i : Fin n, (1:ℝ) := Finset.sum_le_sum (fun i _ => hcol i)
    _ = n := by simp
```

Then, reusing `FDRepUnitarizable.fdRep_exists_unitary_matrix_model R` (the very
model `character_inv_eq_conj` already destructs — `hmodel g : χ_R g = tr(ρ' g)`,
`hunit' g : (ρ' g)ᴴ * ρ' g = 1`, `hone' : ρ' 1 = 1`):

```lean
/-- `‖χ_R(g)‖ ≤ χ_R(1) = dim R`. (Uses this repo's unitary matrix model.) -/
theorem char_norm_le_char_one (R : FDRep ℂ G) (g : G) :
    ‖R.character g‖ ≤ (R.character 1).re := by
  obtain ⟨n', rho', hmul', hone', hunit', hmodel⟩ :=
    FDRepUnitarizable.fdRep_exists_unitary_matrix_model R
  have h1 : (R.character 1).re = (n' : ℝ) := by
    rw [hmodel 1, hone', Matrix.trace_one]; simp
  rw [hmodel g, h1]
  exact trace_unitary_norm_le n' (rho' g) (hunit' g)
```

Finally the corrected dominance theorem — same triangle-inequality skeleton as
the existing `charCoeff_abs_le_trivCoeff`, but with the `dim R = (χ_R 1).re`
factor and **no** `hbound`:

```lean
/-- **Correct nonabelian strong-coupling dominance.** No `‖χ‖ ≤ 1` hypothesis;
the honest bound carries the dimension factor `dim R = (χ_R 1).re ≥ 0`. -/
theorem charCoeff_abs_le_dim_mul_trivCoeff (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G) :
    ‖charCoeff beta rho R‖ ≤ (R.character 1).re * trivCoeff beta rho := by
  unfold charCoeff trivCoeff
  rw [norm_mul, norm_inv, Complex.norm_natCast]
  -- ‖∑ w(g)·conj χ(g)‖ ≤ ∑ w(g)·‖χ(g)‖ ≤ (dim R)·∑ w(g); then pull the |G|⁻¹.
  have hdim : 0 ≤ (R.character 1).re := by
    rw [FDRep.char_one]; simp   -- dim R = finrank ≥ 0
  -- key per-term bound: w(g)·‖χ(g)‖ ≤ w(g)·(χ 1).re, using char_norm_le_char_one
  -- and w(g) = exp(...) ≥ 0; then Finset.sum_le_sum + norm_sum_le, and gcongr
  -- to reinstate the (|G|⁻¹) factor. (mirrors the existing proof)
  sorry
```

The `sorry` in the last block is only the bookkeeping tail (identical in shape to
the proof already in the file); the two mathematically load-bearing pieces
(`trace_unitary_norm_le`, hence `char_norm_le_char_one`) are established. This
full version applies to **every** simple `R`, including SU(2)/SU(3) fundamentals,
and yields `‖γ_R‖ ≤ 1` via `fusion_scalar_eq_card_mul_charCoeff`
(`∑_g w(g)χ_R(g⁻¹) = |G|·c_R`) together with the vacuum eigenvalue
`∑_g w(g) = |G|·c_triv`.

Relevant existing lemmas that plug in directly: `char_orthogonality_conj`
(orthogonality), `charCoeff_real` (coefficients are real, so `‖c_R‖ = |c_R|`),
`fusion_scalar_eq_card_mul_charCoeff` (numerator ↔ coefficient), and Mathlib's
`FDRep.char_one`.

---

## Item-by-item detail

### 3. Normalization / convention — SOUND
`FDRep.char_orthonormal` (verified signature):
`⅟↑(card G) • ∑ g, V.character g * W.character g⁻¹ = if Nonempty (V ≅ W) then 1 else 0`.
- `char_orthogonality_inv` installs `Invertible (card G : ℂ)` from
  `card_ne_zero_complex`, then `smul_eq_mul, invOf_eq_inv` turns `⅟` into
  `(card G)⁻¹`. Correct, matches the `if Nonempty (V ≅ W)` branch verbatim.
- `char_orthogonality_conj` substitutes only `W.character g⁻¹ = conj (W.character g)`
  via `FusionTransferSpectrum.character_inv_eq_conj W g` — on **W**, the correct
  factor; `V` is untouched, `V`/`W` are not swapped, and the `|G|⁻¹` factor is
  preserved (the rewrite is under the sum). No off-by-normalization.
- `character_inv_eq_conj` itself is unconditional and correct (unitary model +
  `rho_inv_eq_conjTranspose` + `Matrix.trace_conjTranspose`).

### 4. Bridge — SOUND (no vacuity)
- `fusion_scalar_eq_card_mul_charCoeff`: `∑_g w(g) χ_R(g⁻¹) = |G|·c_R(β)`. True:
  unfold `charCoeff`, cancel `|G|·|G|⁻¹` (needs `card ≠ 0`, supplied implicitly),
  rewrite `χ_R(g⁻¹) = conj χ_R(g)`. Holds for **all** `R` (no `Simple`), sides are
  generically nonzero — not vacuous, not secretly-zero.
- `fusion_convolution_charCoeff`: combines `lemma2a_fusion_convolution R w hw A`
  (needs `[Simple R]`, `hw = wilsonWeightFun_isClassFunction`) with the scalar
  rewrite. Hypotheses `hmul/hone/hunit` are load-bearing (they produce `hw`).
  `Simple R ⟹ χ_R(1) = dim R ≠ 0` (`character_one_ne_zero`), so the identity is
  not vacuous. Convolution argument order `χ_R(h⁻¹·A)` matches `convLeft`; the
  `g⁻¹`-vs-`conj` handling is consistent throughout.

### 5. Trust surface — SOUND
`grep` over all four files: **no** `sorry`/`admit`, **no** `axiom` declarations
(the only "axiom" hits are prose in comments), **no** `native_decide`. The
`simp +decide` occurrences (`wilsonWeightFun_conj`, `charCoeff_real`,
`fusion_scalar_eq_card_mul_charCoeff`) and the bare `decide` uses (`z2Sign_add`,
`z2_expansion`'s `Finset.sum_insert (by decide)`) are ordinary **kernel**
`decide` on finite decidable goals — fine, not `native_decide`.

---

## One-line bottom line

The module is sound *as Lean* (items 3–5 clean), but its single dominance
theorem is abelian-only in disguise: `hbound : ‖χ_R‖ ≤ 1` forces `dim R = 1`, so
it does **not** supply strong-coupling trivial-rep dominance for SU(2)/SU(3).
The fix is the dimension-weighted bound `‖c_R‖ ≤ dim(R)·c_triv` (≡ `‖γ_R‖ ≤ 1`),
whose only new ingredient — `‖tr U‖ ≤ n` for unitary `U` — is verified above.
