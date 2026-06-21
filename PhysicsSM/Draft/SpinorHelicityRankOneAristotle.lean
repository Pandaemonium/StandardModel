import Mathlib

/-!
# Draft.SpinorHelicityRankOneAristotle

Aristotle handoff: the spinor-helicity rank-one factorization of null
4-momenta over the complex numbers -- `p` is null and future-pointing iff
`sigma . p = lambda lambda^dagger` for some 2-spinor `lambda`.

## Mathematical intent

WP6a of `Sources/Luminal_Motion_Checkerboard_Research_Program.md` (the
`K = C`, spacetime dimension 4 case of the division-algebra spinor-helicity
correspondence `Spin(d-1,1) = SL(2,K)` for `K = R, C, H, O` in
`d = 3, 4, 6, 10`; the octonionic case will connect to the
`PhysicsSM.Spinor.SpinorTenfold*` pure-spinor layer in a later wave).  This
is the algebraic heart of the "spinor = null direction" coincidence that the
checkerboard program exploits: the 2x2 Hermitian matrix of a 4-vector has
Minkowski-norm determinant, and the null future-pointing vectors are exactly
the rank-one positive matrices `lambda lambda^dagger`.

Source: standard spinor-helicity folklore (e.g. Baez--Huerta, "Division
Algebras and Supersymmetry II", arXiv:1003.3436, Section 2); clean-room
formalization from the mathematical definitions.

## Conventions

- Metric signature `(+, -, -, -)`; `p 0` is the time component.
- `minkHerm p = p0 * 1 + p1 * sigmaX + p2 * sigmaY + p3 * sigmaZ`, i.e.
  `!![p0 + p3, p1 - i p2; p1 + i p2, p0 - p3]`.
- `rankOne lam = lam lam^dagger`, i.e. `(rankOne lam) i j = lam i * conj (lam j)`
  (via `Matrix.vecMulVec lam (star lam)`).
- "Null" is stated as `(p 0)^2 = (p 1)^2 + (p 2)^2 + (p 3)^2` and
  "future-pointing" (weakly) as `0 ≤ p 0`.

## Proof guidance

- `minkHerm_apply_*` and the Hermitian/trace/determinant targets are
  entrywise computations: `ext`/`fin_cases`, `simp [Matrix.det_fin_two, ...]`,
  `Complex.ext_iff`, `push_cast`, `ring`.
- `minkHerm_momentumOf`: entrywise; `Complex.normSq`, `Complex.mul_conj`,
  and re/im arithmetic close it.
- The forward construction in `minkHerm_rankOne_iff`: case split on whether
  `p 0 + p 3 = 0`.
  - If `0 < p 0 + p 3`, take
    `lam = ![Real.sqrt (p 0 + p 3), (p 1 + p 2 * I) / Real.sqrt (p 0 + p 3)]`
    and verify entrywise using `Real.sq_sqrt` and the null relation in the
    form `(p 0 + p 3) * (p 0 - p 3) = (p 1)^2 + (p 2)^2`.
  - If `p 0 + p 3 = 0`, the null relation and `0 ≤ p 0` force
    `p 1 = 0`, `p 2 = 0`, and `p 3 = -p 0` (from
    `p0^2 = p1^2 + p2^2 + p0^2` after substituting); take
    `lam = ![0, Real.sqrt (2 * p 0)]`.
- The reverse direction is computational: `det (rankOne lam) = 0` and
  `2 * p 0 = trace = normSq (lam 0) + normSq (lam 1) ≥ 0`, with the
  components of `p` read off from the Hermitian entries.

Helper lemmas are welcome. The final state should contain no placeholder
proof commands, no new assumptions, and no forbidden declarations.

This draft file now contains kernel-checked proofs of the submitted targets.
-/

noncomputable section

namespace PhysicsSM.Draft.SpinorHelicityRankOne

open Matrix Complex

/-! ## The Hermitian matrix of a 4-vector -/

/-- The 2x2 Hermitian matrix `sigma . p` of a real 4-vector `p` in signature
`(+, -, -, -)`:  `!![p0 + p3, p1 - i p2; p1 + i p2, p0 - p3]`. -/
def minkHerm (p : Fin 4 → ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![((p 0 + p 3 : ℝ) : ℂ), ((p 1 : ℝ) : ℂ) - ((p 2 : ℝ) : ℂ) * I;
     ((p 1 : ℝ) : ℂ) + ((p 2 : ℝ) : ℂ) * I, ((p 0 - p 3 : ℝ) : ℂ)]

/-- The rank-one bispinor `lambda lambda^dagger` of a 2-spinor. -/
def rankOne (lam : Fin 2 → ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.vecMulVec lam (star lam)

/-- The null future-pointing 4-momentum recovered from a 2-spinor:
`p^mu = (1/2) lambda^dagger sigma^mu lambda` conventions folded into
components. -/
def momentumOf (lam : Fin 2 → ℂ) : Fin 4 → ℝ :=
  ![(Complex.normSq (lam 0) + Complex.normSq (lam 1)) / 2,
    (lam 0 * (starRingEnd ℂ) (lam 1)).re,
    -((lam 0 * (starRingEnd ℂ) (lam 1)).im),
    (Complex.normSq (lam 0) - Complex.normSq (lam 1)) / 2]

/-! ## Target 1: structure of `minkHerm` -/

/-
`minkHerm p` is Hermitian.
-/
theorem minkHerm_conjTranspose (p : Fin 4 → ℝ) :
    (minkHerm p)ᴴ = minkHerm p := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ minkHerm ] ;
  ring

/-
**The determinant is the Minkowski norm** (signature `(+, -, -, -)`).
-/
theorem det_minkHerm (p : Fin 4 → ℝ) :
    (minkHerm p).det
      = (((p 0) ^ 2 - (p 1) ^ 2 - (p 2) ^ 2 - (p 3) ^ 2 : ℝ) : ℂ) := by
  norm_num [ Matrix.det_fin_two, minkHerm ] ; ring;
  norm_num ; ring

/-
The trace recovers twice the time component.
-/
theorem trace_minkHerm (p : Fin 4 → ℝ) :
    Matrix.trace (minkHerm p) = ((2 * p 0 : ℝ) : ℂ) := by
  simp +decide [ minkHerm, Matrix.trace ] ; ring;

/-
`minkHerm` is injective (the components are recoverable from the
entries), so the factorization below determines `p` from `lambda`.
-/
theorem minkHerm_injective : Function.Injective minkHerm := by
  intro p q h; ext i; fin_cases i <;> (have := congr_fun ( congr_fun h 0 ) 0 ; have := congr_fun ( congr_fun h 0 ) 1 ; have := congr_fun ( congr_fun h 1 ) 0 ; have := congr_fun ( congr_fun h 1 ) 1;);
  · unfold minkHerm at *; norm_num [ Complex.ext_iff ] at *; linarith!;
  · simp_all +decide [ Complex.ext_iff, minkHerm ];
  · simp_all +decide [ Complex.ext_iff, minkHerm ];
  · unfold minkHerm at *; norm_num [ Complex.ext_iff ] at *; linarith!

/-! ## Target 2: spinors give null vectors -/

/-
The rank-one bispinor of a 2-spinor is the Hermitian matrix of its
momentum: `lambda lambda^dagger = sigma . (momentumOf lambda)`.
-/
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
theorem momentumOf_null (lam : Fin 2 → ℂ) :
    (momentumOf lam 0) ^ 2
      = (momentumOf lam 1) ^ 2 + (momentumOf lam 2) ^ 2
        + (momentumOf lam 3) ^ 2 := by
  unfold momentumOf;
  simp +decide [ Complex.normSq, Complex.mul_re, Complex.mul_im ] ; ring

/-
The momentum of a 2-spinor is future-pointing (weakly).
-/
theorem momentumOf_nonneg (lam : Fin 2 → ℂ) : 0 ≤ momentumOf lam 0 := by
  exact div_nonneg ( add_nonneg ( Complex.normSq_nonneg _ ) ( Complex.normSq_nonneg _ ) ) zero_le_two

/-! ## Target 3: the rank-one factorization theorem -/

/-
**Spinor-helicity rank-one factorization** (`K = C`, `d = 4`).  A real
4-vector is null and future-pointing iff its Hermitian matrix is a rank-one
bispinor `lambda lambda^dagger`.
-/
theorem minkHerm_rankOne_iff (p : Fin 4 → ℝ) :
    ((p 0) ^ 2 = (p 1) ^ 2 + (p 2) ^ 2 + (p 3) ^ 2 ∧ 0 ≤ p 0)
      ↔ ∃ lam : Fin 2 → ℂ, minkHerm p = rankOne lam := by
  constructor <;> intro h;
  · by_cases h_case : p 0 + p 3 = 0;
    · use ![0, Real.sqrt (2 * p 0)];
      ext i j; fin_cases i <;> fin_cases j <;> norm_num [ minkHerm, rankOne ] <;> ring;
      · norm_cast;
      · norm_num [ Complex.ext_iff ];
        constructor <;> nlinarith;
      · norm_num [ Complex.ext_iff ];
        constructor <;> nlinarith;
      · norm_cast; norm_num [ Real.sq_sqrt h.2 ] ; nlinarith;
    · have hsqrt_ne : (Real.sqrt (p 0 + p 3) : ℂ) ≠ 0 :=
        Complex.ofReal_ne_zero.mpr <| ne_of_gt <| Real.sqrt_pos.mpr <|
          lt_of_le_of_ne (by nlinarith) (Ne.symm h_case)
      refine ⟨fun i => if i = 0 then Real.sqrt (p 0 + p 3)
          else (p 1 + p 2 * Complex.I) / Real.sqrt (p 0 + p 3), ?_⟩
      ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ *, minkHerm, rankOne ];
      · simp +decide [ vecMulVec, Matrix.mulVec ];
        norm_cast ; rw [ Real.mul_self_sqrt ( by nlinarith ) ];
      · simp +decide [ vecMulVec, Matrix.mul_apply ];
        rw [ mul_div_cancel₀ _ hsqrt_ne ] ; ring;
      · simp +decide [ vecMulVec, Matrix.mul_apply ];
        rw [ div_mul_cancel₀ _ hsqrt_ne ];
      · simp +decide [ vecMulVec, Complex.ext_iff ];
        ring_nf; norm_num [ h_case, Real.sq_sqrt ( show 0 ≤ p 0 + p 3 by nlinarith ) ];
        grind;
  · obtain ⟨lam, hlam⟩ := h;
    have hp : p = momentumOf lam :=
      minkHerm_injective <| hlam.trans <| minkHerm_momentumOf lam ▸ rfl
    exact ⟨ hp ▸ momentumOf_null lam, hp ▸ momentumOf_nonneg lam ⟩

end PhysicsSM.Draft.SpinorHelicityRankOne

end
