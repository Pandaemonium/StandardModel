import Mathlib

/-!
# Draft.SpinorHelicityQuaternionAristotle

Aristotle handoff (wave 2): the quaternionic spinor-helicity rank-one
factorization -- the `K = H`, spacetime dimension 6 case of the
division-algebra correspondence.

## Mathematical intent

WP6 of `Sources/Luminal_Motion_Checkerboard_Research_Program.md`, second
rung of the ladder `K = R, C, H, O` in `d = 3, 4, 6, 10` (the complex
`d = 4` case is `PhysicsSM.Draft.SpinorHelicityRankOneAristotle`, proved in
wave 1; the octonionic `d = 10` case will connect to
`PhysicsSM.Spinor.SpinorTenfold*` in a later wave).  A real 6-vector in
signature `(+,-,-,-,-,-)` is encoded as the 2x2 quaternionic Hermitian
matrix

`minkHermQ p = !![p0 + p5, q; star q, p0 - p5]`,  `q = p1 + p2 i + p3 j + p4 k`,

and the theorem is that `p` is null and future-pointing iff
`minkHermQ p = lam lam^dagger` for a quaternionic 2-spinor `lam`.  The
quaternionic case is the genuine stress test of the formalism short of
octonionic nonassociativity: `H` is noncommutative, so there is no
determinant, and the null condition must be carried by the explicit
Minkowski norm.

Source: standard division-algebra spinor folklore (Baez--Huerta,
arXiv:1003.3436, Section 2); clean-room formalization.  All statements were
validated numerically (`Scripts/oracle/validate_checkerboard.py`, section
"quaternionic rank-one").

## Conventions

- Signature `(+,-,-,-,-,-)`; `p 0` is time; components `p 1 .. p 4` fill
  the quaternion `quatOf p`; `p 5` is the remaining spatial direction on
  the diagonal.
- `rankOneQ lam = Matrix.vecMulVec lam (star lam)`, so
  `(rankOneQ lam) i j = lam i * star (lam j)` -- the order matters over
  `H`; this is the Hermitian order.
- "Null" is `(p 0)^2 = (p 1)^2 + (p 2)^2 + (p 3)^2 + (p 4)^2 + (p 5)^2`;
  "future-pointing" (weakly) is `0 ≤ p 0`.

## Proof guidance

- Useful mathlib API: `Quaternion.normSq` (a `MonoidWithZeroHom`, so
  multiplicative), `Quaternion.self_mul_star` / `Quaternion.star_mul_self`
  (`a * star a = ((normSq a : ℝ) : ℍ[ℝ])` and symm), `Quaternion.coe_*`
  simp lemmas for the real coercion, and the `ext` lemma for quaternion
  components (`Quaternion.ext`).
- `minkHermQ_momentumOfQ`: entrywise; the diagonal entries are
  `self_mul_star`, the off-diagonal is the definition of `quatProd`.
- `momentumOfQ_null`: multiplicativity of `normSq` plus
  `normSq (lam 0 * star (lam 1)) = normSq (lam 0) * normSq (lam 1)` and
  the component expansion of `normSq` for `quatProd`.
- The forward construction in `minkHermQ_rankOne_iff`: case split on
  `p 0 + p 5 = 0`.
  - If `0 < p 0 + p 5`, take
    `lam = ![((Real.sqrt (p 0 + p 5) : ℝ) : ℍ[ℝ]),
             (Real.sqrt (p 0 + p 5))⁻¹ • star (quatOf p)]`
    and use the null relation in the form
    `(p 0 + p 5) * (p 0 - p 5) = normSq (quatOf p)`.
  - If `p 0 + p 5 = 0`, nullity and `0 ≤ p 0` force `quatOf p = 0` and
    `p 5 = -(p 0)`; take `lam = ![0, ((Real.sqrt (2 * p 0) : ℝ) : ℍ[ℝ])]`.
- Real scalars are central in `H`, so the chart algebra goes through; this
  is exactly the step that will *fail* octonionically, which is why the
  quaternionic file should be kept clean and explicit.

Helper lemmas are welcome.  The final state should contain no placeholder
proof commands, no new assumptions, and no forbidden declarations.

This is draft code: the statements below contain documented handoff holes
and must not be imported from trusted code until they are eliminated.
-/

noncomputable section

namespace PhysicsSM.Draft.SpinorHelicityQuaternion

open Matrix Quaternion

/-! ## The quaternionic Hermitian encoding of a 6-vector -/

/-- The quaternion carrying the spatial components `p 1 .. p 4`. -/
def quatOf (p : Fin 6 → ℝ) : ℍ[ℝ] := ⟨p 1, p 2, p 3, p 4⟩

/-- The 2x2 quaternionic Hermitian matrix of a real 6-vector in signature
`(+,-,-,-,-,-)`. -/
def minkHermQ (p : Fin 6 → ℝ) : Matrix (Fin 2) (Fin 2) ℍ[ℝ] :=
  !![((p 0 + p 5 : ℝ) : ℍ[ℝ]), quatOf p;
     star (quatOf p), ((p 0 - p 5 : ℝ) : ℍ[ℝ])]

/-- The rank-one quaternionic bispinor `lam lam^dagger`. -/
def rankOneQ (lam : Fin 2 → ℍ[ℝ]) : Matrix (Fin 2) (Fin 2) ℍ[ℝ] :=
  Matrix.vecMulVec lam (star lam)

/-- The null future-pointing 6-momentum recovered from a quaternionic
2-spinor. -/
def momentumOfQ (lam : Fin 2 → ℍ[ℝ]) : Fin 6 → ℝ :=
  ![(normSq (lam 0) + normSq (lam 1)) / 2,
    (lam 0 * star (lam 1)).re,
    (lam 0 * star (lam 1)).imI,
    (lam 0 * star (lam 1)).imJ,
    (lam 0 * star (lam 1)).imK,
    (normSq (lam 0) - normSq (lam 1)) / 2]

/-! ## Target 1: structure of `minkHermQ` -/

/-- `minkHermQ p` is Hermitian. -/
theorem minkHermQ_conjTranspose (p : Fin 6 → ℝ) :
    (minkHermQ p)ᴴ = minkHermQ p := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ minkHermQ, Matrix.conjTranspose ] ;
  · fin_cases i <;> fin_cases j <;> simp +decide [ minkHermQ, Matrix.conjTranspose ];
  · fin_cases i <;> fin_cases j <;> simp +decide [ minkHermQ ];
  · fin_cases i <;> fin_cases j <;> simp +decide [ minkHermQ, Matrix.conjTranspose ]

/-- The trace recovers twice the time component. -/
theorem trace_minkHermQ (p : Fin 6 → ℝ) :
    Matrix.trace (minkHermQ p) = ((2 * p 0 : ℝ) : ℍ[ℝ]) := by
  simp +decide [ Matrix.trace, minkHermQ ];
  norm_num [ ← two_mul ];
  exact Or.inl rfl

/-- `minkHermQ` is injective. -/
theorem minkHermQ_injective : Function.Injective minkHermQ := by
  intro p q h; have := congr_fun ( congr_fun h 0 ) 0; have := congr_fun ( congr_fun h 0 ) 1; have := congr_fun ( congr_fun h 1 ) 0; have := congr_fun ( congr_fun h 1 ) 1; simp_all +decide [ minkHermQ ] ;
  simp_all +decide [ funext_iff, Fin.forall_fin_succ, quatOf ];
  norm_num [ Quaternion.ext_iff ] at h;
  grind

/-! ## Target 2: spinors give null vectors -/

/-- The rank-one bispinor of a quaternionic 2-spinor is the Hermitian
matrix of its momentum. -/
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
theorem momentumOfQ_null (lam : Fin 2 → ℍ[ℝ]) :
    (momentumOfQ lam 0) ^ 2
      = (momentumOfQ lam 1) ^ 2 + (momentumOfQ lam 2) ^ 2
        + (momentumOfQ lam 3) ^ 2 + (momentumOfQ lam 4) ^ 2
        + (momentumOfQ lam 5) ^ 2 := by
  -- Let's expand both sides of the equation using the definitions of momentumOfQ.
  simp [momentumOfQ, Quaternion.normSq];
  ring

/-- The momentum of a quaternionic 2-spinor is future-pointing (weakly). -/
theorem momentumOfQ_nonneg (lam : Fin 2 → ℍ[ℝ]) :
    0 ≤ momentumOfQ lam 0 := by
  have h0 : (0 : ℝ) ≤ normSq (lam 0) := normSq_nonneg
  have h1 : (0 : ℝ) ≤ normSq (lam 1) := normSq_nonneg
  simp only [momentumOfQ, Matrix.cons_val_zero]
  linarith

/-! ## Target 3: the rank-one factorization theorem (`K = H`, `d = 6`) -/

/-- Forward construction, generic case `0 < p 0 + p 5`: the explicit spinor
whose rank-one bispinor is `minkHermQ p`. -/
theorem minkHermQ_rankOne_of_pos (p : Fin 6 → ℝ)
    (hnull : (p 0) ^ 2
      = (p 1) ^ 2 + (p 2) ^ 2 + (p 3) ^ 2 + (p 4) ^ 2 + (p 5) ^ 2)
    (hpos : 0 < p 0 + p 5) :
    minkHermQ p
      = rankOneQ ![((Real.sqrt (p 0 + p 5) : ℝ) : ℍ[ℝ]),
          ((Real.sqrt (p 0 + p 5))⁻¹ : ℝ) • star (quatOf p)] := by
  ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ minkHermQ, rankOneQ, Matrix.vecMulVec_apply ] ; ring!;
  any_goals rw [ Real.sq_sqrt hpos.le ];
  any_goals rw [ inv_mul_eq_div, eq_div_iff ] ; ring ; positivity;
  · unfold quatOf;
    grind;
  · fin_cases i <;> fin_cases j <;> simp +decide [ minkHermQ, rankOneQ ];
    · rw [ ← mul_assoc, inv_mul_cancel₀ ( ne_of_gt ( Real.sqrt_pos.mpr hpos ) ), one_mul ];
    · rw [ inv_mul_eq_div, mul_div_cancel_right₀ _ ( ne_of_gt ( Real.sqrt_pos.mpr hpos ) ) ];
    · exact Or.inr ( by ring );
  · fin_cases i <;> fin_cases j <;> simp +decide [ minkHermQ, rankOneQ ];
    · rw [ ← mul_assoc, inv_mul_cancel₀ ( ne_of_gt ( Real.sqrt_pos.mpr hpos ) ), one_mul ];
    · rw [ inv_mul_eq_div, mul_div_cancel_right₀ _ ( ne_of_gt ( Real.sqrt_pos.mpr hpos ) ) ];
    · exact Or.inr ( by ring! );
  · fin_cases i <;> fin_cases j <;> norm_num [ minkHermQ, rankOneQ ];
    · rw [ ← mul_assoc, inv_mul_cancel₀ ( ne_of_gt ( Real.sqrt_pos.mpr hpos ) ), one_mul ];
    · rw [ inv_mul_eq_div, mul_div_cancel_right₀ _ ( ne_of_gt ( Real.sqrt_pos.mpr hpos ) ) ];
    · exact Or.inr ( by ring )

/-- Forward construction, degenerate case `p 0 + p 5 = 0`: nullity and
`0 ≤ p 0` force `quatOf p = 0` and `p 5 = -(p 0)`. -/
theorem minkHermQ_rankOne_of_zero (p : Fin 6 → ℝ)
    (hnull : (p 0) ^ 2
      = (p 1) ^ 2 + (p 2) ^ 2 + (p 3) ^ 2 + (p 4) ^ 2 + (p 5) ^ 2)
    (hp0 : 0 ≤ p 0) (hz : p 0 + p 5 = 0) :
    minkHermQ p = rankOneQ ![0, ((Real.sqrt (2 * p 0) : ℝ) : ℍ[ℝ])] := by
  ext i j
  · fin_cases i <;> fin_cases j <;> simp +decide [*, minkHermQ, rankOneQ]
    · unfold quatOf
      simp +decide [show p 5 = -p 0 by linarith] at *
      nlinarith
    · unfold quatOf; nlinarith!
    · ring; norm_num [hp0]; linarith
  · fin_cases i <;> fin_cases j <;> simp +decide [minkHermQ, rankOneQ]
    · norm_num [show p 5 = -p 0 by linarith, quatOf] at *
      nlinarith
    · unfold quatOf; nlinarith
  · fin_cases i <;> fin_cases j <;> simp +decide [minkHermQ, rankOneQ]
    · unfold quatOf; nlinarith
    · exact eq_zero_of_mul_self_eq_zero (by nlinarith!)
  · fin_cases i <;> fin_cases j <;> simp +decide [minkHermQ, rankOneQ]
    · unfold quatOf; nlinarith!
    · unfold quatOf
      nlinarith! [sq_nonneg (p 1), sq_nonneg (p 2), sq_nonneg (p 3), sq_nonneg (p 4)]

/-- **Quaternionic spinor-helicity rank-one factorization.**  A real
6-vector is null and future-pointing iff its quaternionic Hermitian matrix
is a rank-one bispinor `lam lam^dagger`. -/
theorem minkHermQ_rankOne_iff (p : Fin 6 → ℝ) :
    ((p 0) ^ 2
        = (p 1) ^ 2 + (p 2) ^ 2 + (p 3) ^ 2 + (p 4) ^ 2 + (p 5) ^ 2
      ∧ 0 ≤ p 0)
      ↔ ∃ lam : Fin 2 → ℍ[ℝ], minkHermQ p = rankOneQ lam := by
  constructor
  · rintro ⟨hnull, hp0⟩
    have hple : 0 ≤ p 0 + p 5 := by nlinarith [sq_nonneg (p 0 - p 5)]
    rcases eq_or_lt_of_le hple with hz | hpos
    · exact ⟨_, minkHermQ_rankOne_of_zero p hnull hp0 hz.symm⟩
    · exact ⟨_, minkHermQ_rankOne_of_pos p hnull hpos⟩
  · rintro ⟨lam, hlam⟩
    have h_eq : p = momentumOfQ lam :=
      minkHermQ_injective <| hlam.trans <| (minkHermQ_momentumOfQ lam).symm
    rw [h_eq]
    exact ⟨momentumOfQ_null lam, momentumOfQ_nonneg lam⟩

end PhysicsSM.Draft.SpinorHelicityQuaternion

end
