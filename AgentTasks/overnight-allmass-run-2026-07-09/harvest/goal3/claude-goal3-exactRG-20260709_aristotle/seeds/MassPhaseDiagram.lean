import Mathlib

set_option maxHeartbeats 1600000

/-!
# The multi-channel mass phase diagram (P–B)

A finite null-edge Dirac program identifies a carrier's mass-gap block as the
Hermitian matrix `B(λ,κ) = !![λ, κi, 0; −κi, λ, 0; 0, 0, λ]` with spectrum
`{λ−κ, λ, λ+κ}` and a three-phase diagram:

* **massive** `|κ| < λ` (positive-definite),
* **critical** `|κ| = λ` (singular, massless line),
* **over-closure** `|κ| > λ` (a negative eigenvalue `λ−κ`, unphysical).

Here we work with the *real-symmetric* representative
`B₃(λ,κ) = !![λ, κ, 0; κ, λ, 0; 0, 0, λ]`, which is unitarily equivalent to the
Hermitian form (closure `κ` rotated from imaginary to real off-diagonal) and has
the same spectrum `{λ−κ, λ, λ+κ}`.

The carrier square has **four** channels: aperture `λ` (kinetic, a positive
diagonal mass), closure `κ` (a signed off-diagonal coupling), turn `τ`
(chirality-flip / Higgs mass — here a *positive diagonal mass* on the flipped
"turn" sector) and soldering `ε` (the geometric coupling that solders the
aperture sector to the turn sector).

We promote `B₃` to the four-parameter Hermitian block

```
B₄(λ,κ,τ,ε) = !![ λ, κ, ε, 0;
                  κ, λ, 0, ε;
                  ε, 0, τ, 0;
                  0, ε, 0, τ ]
```

Reading of the four channels (all given a *faithful* matrix form):

* aperture `λ` : diagonal of the top-left "aperture" sector (positive mass);
* closure `κ` : off-diagonal of the aperture sector (signed);
* turn `τ`    : diagonal of the bottom-right "turn" sector (positive mass);
* soldering `ε`: the `(1,3)` / `(2,4)` entries soldering aperture to turn.

At `τ = ε = 0` the block degenerates to the aperture–closure sector `!![λ,κ],[κ,λ]`
(spectrum `λ ± κ`, i.e. the non-spectator part of `B₃`) direct-sum a dead turn
sector.

## Main results

* `B4_isHermitian`, `B4_quadForm` : the block and its quadratic form.
* `B4_charpoly` : the characteristic polynomial factors into two quadratics —
  the exact spectrum.
* `B4_det` : `det B₄ = ((λ+κ)τ − ε²)·((λ−κ)τ − ε²)`, the **critical (massless)
  surface** `det = 0`.
* `B4_posDef_iff` : the positivity criterion (four scalar inequalities).
* Phase theorems : `B4_massive_iff`, `B4_aperture_necessary`,
  `B4_turn_necessary`, `B4_posDef_iff_of_sol_zero` (decoupled aperture/turn
  masses), `B4_singular_iff` (critical surface), `B4_critical`
  (a PSD-but-singular boundary point), and the indefinite/unphysical witnesses
  `B4_indefinite_of_neg_aperture`, `B4_indefinite_of_neg_turn`,
  `B4_indefinite_of_detMinus_neg`.
-/

open Matrix

namespace MassPhase

/-! ## The base three-phase block `B₃(λ,κ)` (real-symmetric representative) -/

/-- The base mass-gap block, real-symmetric representative of `B(λ,κ)`. -/
def B3 (lam kap : ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  !![ lam, kap, 0; kap, lam, 0; 0, 0, lam ]

theorem B3_isHermitian (lam kap : ℝ) : (B3 lam kap).IsHermitian := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ B3 ] ;

/--
Characteristic polynomial of `B₃`: roots `λ−κ, λ, λ+κ` (the spectrum).
-/
theorem B3_charpoly (lam kap X : ℝ) :
    (X • (1 : Matrix (Fin 3) (Fin 3) ℝ) - B3 lam kap).det
      = (X - lam) * ((X - (lam + kap)) * (X - (lam - kap))) := by
  unfold B3; norm_num [ Matrix.det_fin_three ] ; ring;
  simp +decide [ Matrix.one_apply ] ; ring!;

/--
Determinant of `B₃`: vanishes exactly on the critical line `|κ| = λ` (and `λ=0`).
-/
theorem B3_det (lam kap : ℝ) : (B3 lam kap).det = lam * (lam ^ 2 - kap ^ 2) := by
  norm_num [ Matrix.det_fin_three, B3 ] ; ring;
  simp +zetaDelta at *;
  ring

theorem B3_quadForm (lam kap : ℝ) (x : Fin 3 → ℝ) :
    x ⬝ᵥ (B3 lam kap *ᵥ x)
      = lam * (x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2) + 2 * kap * (x 0 * x 1) := by
  simp [B3, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  ring

/--
The known three-phase criterion for the base block: `B₃` is positive-definite
iff aperture beats closure, `|κ| < λ`.
-/
theorem B3_posDef_iff (lam kap : ℝ) :
    (B3 lam kap).PosDef ↔ (0 < lam - kap ∧ 0 < lam + kap) := by
  constructor <;> intro h;
  · constructor <;> have := h.2 <;> simp_all +decide [ B3, Matrix.mulVec ];
    · have := @this ( Finsupp.single 0 1 - Finsupp.single 1 1 ) ; simp_all +decide [ Finsupp.sum_fintype ];
      simp_all +decide [ Fin.sum_univ_succ, Finsupp.single_apply ];
      linarith [ this ( ne_of_apply_ne ( fun x => x 0 ) ( by norm_num ) ) ];
    · have := @this ( Finsupp.single 0 1 + Finsupp.single 1 1 ) ; norm_num [ Finsupp.sum_add_index', Finsupp.sum_single_index ] at this;
      simp_all +decide [ Finsupp.sum_add_index', add_mul, mul_add, mul_assoc, mul_comm, mul_left_comm ];
      linarith [ this ( by exact ne_of_apply_ne ( fun x => x 0 ) ( by norm_num ) ) ];
  · constructor;
    · grind +suggestions;
    · intro x hx_nonzero
      have h_pos : 0 < (x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2) * lam + 2 * x 0 * x 1 * kap := by
        by_cases h₂ : x 0 + x 1 = 0;
        · by_cases h₃ : x 2 = 0 <;> simp_all +decide [ add_eq_zero_iff_eq_neg ];
          · nlinarith [ mul_self_pos.mpr ( show x 1 ≠ 0 from fun h' => hx_nonzero <| by ext i; fin_cases i <;> aesop ) ];
          · nlinarith [ mul_self_pos.2 h₃, mul_self_nonneg ( x 1 ), mul_self_nonneg ( x 2 ) ];
        · nlinarith [ mul_self_pos.2 h₂, sq_nonneg ( x 0 - x 1 ), sq_nonneg ( x 0 + x 1 ), sq_nonneg ( x 2 ) ];
      convert h_pos using 1 ; simp +decide [ Finsupp.sum_fintype, B3 ] ; ring!;
      simp +decide [ Fin.sum_univ_three ] ; ring!;

/-! ## The four-parameter block `B₄(λ,κ,τ,ε)` -/

/-- The four-channel Hermitian mass block. `lam` = aperture, `kap` = closure,
`tau` = turn, `eps` = soldering. -/
def B4 (lam kap tau eps : ℝ) : Matrix (Fin 4) (Fin 4) ℝ :=
  !![ lam, kap, eps, 0;
      kap, lam, 0, eps;
      eps, 0, tau, 0;
      0, eps, 0, tau ]

theorem B4_isHermitian (lam kap tau eps : ℝ) : (B4 lam kap tau eps).IsHermitian := by
  ext i j; fin_cases i <;> fin_cases j <;> rfl;

/--
The quadratic form (mass functional) of `B₄`.
-/
theorem B4_quadForm (lam kap tau eps : ℝ) (x : Fin 4 → ℝ) :
    x ⬝ᵥ (B4 lam kap tau eps *ᵥ x)
      = lam * (x 0 ^ 2 + x 1 ^ 2) + 2 * kap * (x 0 * x 1)
        + tau * (x 2 ^ 2 + x 3 ^ 2) + 2 * eps * (x 0 * x 2 + x 1 * x 3) := by
  unfold B4; simp +decide [ Matrix.mulVec, dotProduct, Fin.sum_univ_succ ] ; ring;

/--
**Spectrum.** The characteristic polynomial of `B₄` factors into two quadratics
`(X² − (λ+κ+τ)X + ((λ+κ)τ−ε²))·(X² − (λ−κ+τ)X + ((λ−κ)τ−ε²))`; its four roots are
the eigenvalues (two from each aperture-closure sub-sector).
-/
theorem B4_charpoly (lam kap tau eps X : ℝ) :
    (X • (1 : Matrix (Fin 4) (Fin 4) ℝ) - B4 lam kap tau eps).det
      = (X ^ 2 - (lam + kap + tau) * X + ((lam + kap) * tau - eps ^ 2))
        * (X ^ 2 - (lam - kap + tau) * X + ((lam - kap) * tau - eps ^ 2)) := by
  unfold B4;
  simp +decide [ Matrix.det_succ_row_zero, Fin.sum_univ_succ ] ; ring;
  simp +decide [ Fin.succAbove, Matrix.one_apply ] ; ring!

/--
**Critical (massless) surface.** `det B₄ = ((λ+κ)τ − ε²)·((λ−κ)τ − ε²)`.
-/
theorem B4_det (lam kap tau eps : ℝ) :
    (B4 lam kap tau eps).det
      = ((lam + kap) * tau - eps ^ 2) * ((lam - kap) * tau - eps ^ 2) := by
  convert B4_charpoly lam kap tau eps 0 using 1 <;> norm_num [ B4 ] ; ring;
  norm_num [ Matrix.det_succ_row_zero ];
  simp +decide [ Fin.sum_univ_succ, Fin.succAbove ] ; ring!;

/--
`B₄` is singular (a zero eigenvalue / massless mode) exactly on the union of the
two critical sheets `(λ+κ)τ = ε²` and `(λ−κ)τ = ε²`.
-/
theorem B4_singular_iff (lam kap tau eps : ℝ) :
    (B4 lam kap tau eps).det = 0 ↔
      ((lam + kap) * tau - eps ^ 2 = 0 ∨ (lam - kap) * tau - eps ^ 2 = 0) := by
  rw [ B4_det, mul_eq_zero ]

/--
**Positivity criterion.** `B₄` is positive-definite (the fully massive phase)
iff both aperture-closure sub-sectors are positive-definite:
`0 < λ+κ`, `0 < λ−κ`, `0 < (λ+κ)τ − ε²`, `0 < (λ−κ)τ − ε²`.
-/
theorem B4_posDef_iff (lam kap tau eps : ℝ) :
    (B4 lam kap tau eps).PosDef ↔
      (0 < lam + kap ∧ 0 < lam - kap ∧
        0 < (lam + kap) * tau - eps ^ 2 ∧ 0 < (lam - kap) * tau - eps ^ 2) := by
  constructor;
  · intro h_pos_def
    have h_lam_kap : 0 < lam + kap ∧ 0 < lam - kap := by
      constructor <;> have := h_pos_def.2;
      · specialize @this ( Finsupp.single 0 1 + Finsupp.single 1 1 ) ; simp_all +decide [ Finsupp.sum_fintype ];
        simp_all +decide [ Fin.sum_univ_succ, B4 ];
        linarith [ this ( by exact ne_of_apply_ne ( fun f => f 0 ) ( by norm_num ) ) ];
      · specialize @this ( Finsupp.single 0 1 - Finsupp.single 1 1 ) ; norm_num [ Finsupp.sum_fintype, B4 ] at this;
        simp_all +decide [ Fin.sum_univ_succ, Finsupp.single_apply ];
        linarith [ this ( ne_of_apply_ne ( fun f => f 0 ) ( by norm_num ) ) ]
    have h_det_pos : 0 < (lam + kap) * tau - eps ^ 2 ∧ 0 < (lam - kap) * tau - eps ^ 2 := by
      constructor;
      · have := h_pos_def.2;
        specialize this ( show ( Finsupp.single 0 ( -eps ) + Finsupp.single 1 ( -eps ) + Finsupp.single 2 ( lam + kap ) + Finsupp.single 3 ( lam + kap ) ) ≠ 0 from ?_ ) ; simp_all +decide [ Finsupp.sum_add_index' ];
        · intro h; have := congr_arg ( fun f => f 2 ) h; norm_num at this;
          simp_all +decide;
        · simp_all +decide [ Finsupp.sum_fintype, Fin.sum_univ_four ];
          simp_all +decide [ B4 ] ; nlinarith [ mul_pos h_lam_kap.1 h_lam_kap.1 ] ;
      · have := h_pos_def.2;
        specialize @this ( Finsupp.single 0 ( -eps ) + Finsupp.single 1 eps + Finsupp.single 2 ( lam - kap ) + Finsupp.single 3 ( - ( lam - kap ) ) ) ; simp_all +decide [ Finsupp.sum_fintype ];
        simp_all +decide [ Finsupp.single_apply, B4 ];
        simp_all +decide [ Fin.sum_univ_succ, Finsupp.ext_iff ];
        simp_all +decide [ Fin.forall_fin_succ, Finsupp.single_apply ];
        nlinarith [ this.2.1 ( by linarith ), this.2.2 ( by linarith ) ]
    exact ⟨h_lam_kap.left, h_lam_kap.right, h_det_pos.left, h_det_pos.right⟩;
  · intro h;
    constructor;
    · exact B4_isHermitian lam kap tau eps
    · intro x hx_ne_zero
      have h_pos : 0 < (lam + kap) * (x 0 + x 1) ^ 2 + 2 * eps * (x 0 + x 1) * (x 2 + x 3) + tau * (x 2 + x 3) ^ 2 + (lam - kap) * (x 0 - x 1) ^ 2 + 2 * eps * (x 0 - x 1) * (x 2 - x 3) + tau * (x 2 - x 3) ^ 2 := by
        by_cases h_case1 : x 0 + x 1 = 0 ∧ x 2 + x 3 = 0;
        · by_cases h_case2 : x 0 - x 1 = 0 ∧ x 2 - x 3 = 0;
          · exact False.elim <| hx_ne_zero <| Finsupp.ext fun i => by fin_cases i <;> norm_num <;> linarith!;
          · by_cases h_case3 : x 0 - x 1 = 0 <;> by_cases h_case4 : x 2 - x 3 = 0 <;> simp_all +decide [ sub_eq_iff_eq_add ];
            · exact mul_pos ( by nlinarith ) ( by nlinarith [ mul_self_pos.mpr ( sub_ne_zero.mpr h_case4 ) ] );
            · nlinarith [ mul_self_pos.2 ( sub_ne_zero.2 h_case3 ) ];
            · nlinarith [ sq_nonneg ( ( lam - kap ) * ( x 0 - x 1 ) + eps * ( x 2 - x 3 ) ), mul_self_pos.2 ( sub_ne_zero.2 h_case3 ), mul_self_pos.2 ( sub_ne_zero.2 h_case4 ) ];
        · have h_pos1 : 0 < (lam + kap) * (x 0 + x 1) ^ 2 + 2 * eps * (x 0 + x 1) * (x 2 + x 3) + tau * (x 2 + x 3) ^ 2 := by
            by_cases h_case2 : x 2 + x 3 = 0;
            · simp_all +decide [ add_eq_zero_iff_eq_neg ];
              nlinarith [ mul_self_pos.2 ( sub_ne_zero.2 h_case1 ) ];
            · nlinarith [ sq_nonneg ( ( lam + kap ) * ( x 0 + x 1 ) + eps * ( x 2 + x 3 ) ), mul_self_pos.2 h_case2 ];
          nlinarith [ sq_nonneg ( ( lam - kap ) * ( x 0 - x 1 ) + eps * ( x 2 - x 3 ) ), sq_nonneg ( eps * ( x 0 - x 1 ) + tau * ( x 2 - x 3 ) ) ];
      convert div_pos h_pos ( show 0 < 2 by norm_num ) using 1 ; ring!;
      simp +decide [ Finsupp.sum_fintype, B4 ] ; ring!;
      simp +decide [ Fin.sum_univ_succ ] ; ring!

/-! ## Mass-phase classification -/

/-- **Massive phase** (positive mass gap) = positive-definite region. -/
theorem B4_massive_iff (lam kap tau eps : ℝ) :
    (B4 lam kap tau eps).PosDef ↔
      (0 < lam + kap ∧ 0 < lam - kap ∧
        0 < (lam + kap) * tau - eps ^ 2 ∧ 0 < (lam - kap) * tau - eps ^ 2) :=
  B4_posDef_iff lam kap tau eps

/--
**Aperture is necessary.** In the massive phase the aperture strictly beats the
closure, `|κ| < λ` (equivalently `0 < λ−κ` and `0 < λ+κ`).
-/
theorem B4_aperture_necessary (lam kap tau eps : ℝ)
    (h : (B4 lam kap tau eps).PosDef) : 0 < lam - kap ∧ 0 < lam + kap := by
  obtain ⟨h1, h2, h3, h4⟩ := (B4_posDef_iff lam kap tau eps).mp h; exact ⟨by linarith, by linarith⟩;

/--
**Turn is necessary.** In the massive phase the turn mass is strictly positive.
-/
theorem B4_turn_necessary (lam kap tau eps : ℝ)
    (h : (B4 lam kap tau eps).PosDef) : 0 < tau := by
  obtain ⟨h1, h2, h3, h4⟩ := (B4_posDef_iff lam kap tau eps).mp h; nlinarith [sq_nonneg eps] ;

/--
**Decoupled aperture/turn masses.** With soldering off (`ε = 0`) the block is
massive iff the aperture sector beats closure (`|κ| < λ`) *and* the turn sector has
a positive mass (`0 < τ`): the two mass channels act independently.
-/
theorem B4_posDef_iff_of_sol_zero (lam kap tau : ℝ) :
    (B4 lam kap tau 0).PosDef ↔ (0 < lam - kap ∧ 0 < lam + kap ∧ 0 < tau) := by
  constructor;
  · grind +suggestions;
  · intro h;
    convert B4_posDef_iff lam kap tau 0 |>.2 ⟨ h.2.1, h.1, _, _ ⟩ using 1 <;> nlinarith

/--
**Closure-cancelled critical boundary.** On the sheet `(λ−κ)τ = ε²` (with the
remaining sub-sector strictly positive), `B₄` is positive-*semi*-definite but not
positive-definite: the least eigenvalue has hit `0` — a massless mode.
-/
theorem B4_critical (lam kap tau eps : ℝ)
    (h1 : 0 < lam - kap) (h2 : 0 < lam + kap)
    (h4 : (lam - kap) * tau - eps ^ 2 = 0)
    (h5 : 0 < (lam + kap) * tau - eps ^ 2) :
    (B4 lam kap tau eps).PosSemidef ∧ ¬ (B4 lam kap tau eps).PosDef := by
  constructor;
  · constructor;
    · grind +suggestions;
    · intro x
      have h_sum : ∑ i, ∑ j, x i * B4 lam kap tau eps i j * x j = lam * (x 0 ^ 2 + x 1 ^ 2) + 2 * kap * (x 0 * x 1) + tau * (x 2 ^ 2 + x 3 ^ 2) + 2 * eps * (x 0 * x 2 + x 1 * x 3) := by
        simp +decide [ B4, Fin.sum_univ_succ ] ; ring!;
      have h_nonneg : (lam + kap) * (x 0 + x 1) ^ 2 + 2 * eps * (x 0 + x 1) * (x 2 + x 3) + tau * (x 2 + x 3) ^ 2 ≥ 0 := by
        nlinarith [ sq_nonneg ( ( lam + kap ) * ( x 0 + x 1 ) + eps * ( x 2 + x 3 ) ) ];
      have h_nonneg2 : (lam - kap) * (x 0 - x 1) ^ 2 + 2 * eps * (x 0 - x 1) * (x 2 - x 3) + tau * (x 2 - x 3) ^ 2 ≥ 0 := by
        nlinarith [ sq_nonneg ( ( lam - kap ) * ( x 0 - x 1 ) + eps * ( x 2 - x 3 ) ), sq_nonneg ( ( lam - kap ) * ( x 0 - x 1 ) - eps * ( x 2 - x 3 ) ), h4 ];
      norm_num [ Finsupp.sum_fintype ] at *;
      linarith;
  · exact fun h => by have := ( B4_posDef_iff lam kap tau eps ).mp h; linarith;

/--
**Indefinite / unphysical (aperture over-closed).** If closure overwhelms
aperture (`λ − κ < 0`) there is a state of negative mass², so `B₄` is not even
positive-semidefinite.
-/
theorem B4_indefinite_of_neg_aperture (lam kap tau eps : ℝ) (h : lam - kap < 0) :
    ∃ x : Fin 4 → ℝ, x ⬝ᵥ (B4 lam kap tau eps *ᵥ x) < 0 := by
  use ![1, -1, 0, 0];
  unfold B4; norm_num [ Matrix.mulVec ] ; linarith!;

/--
**Indefinite / unphysical (negative turn).** If the turn mass is negative
(`τ < 0`) the turn sector carries a negative mass² mode.
-/
theorem B4_indefinite_of_neg_turn (lam kap tau eps : ℝ) (h : tau < 0) :
    ∃ x : Fin 4 → ℝ, x ⬝ᵥ (B4 lam kap tau eps *ᵥ x) < 0 := by
  use ![0, 0, 1, 0];
  convert h using 1;
  convert B4_quadForm lam kap tau eps _ using 1 ; norm_num;
  simp +zetaDelta at *

/--
**Indefinite / unphysical (soldering over-closes a sub-sector).** If the
aperture and turn are individually positive (`0 < λ−κ`, `0 < τ`) but soldering is
strong enough to drive a sub-determinant negative (`(λ−κ)τ − ε² < 0`), then a
negative mass² mode exists.
-/
theorem B4_indefinite_of_detMinus_neg (lam kap tau eps : ℝ)
    (h1 : 0 < lam - kap) (h4 : (lam - kap) * tau - eps ^ 2 < 0) :
    ∃ x : Fin 4 → ℝ, x ⬝ᵥ (B4 lam kap tau eps *ᵥ x) < 0 := by
  use ![-eps, eps, lam - kap, -(lam - kap)];
  simp +decide [ B4 ];
  simp +decide [ vecHead, vecTail ] at * ; nlinarith

/-! ## Axiom footprint (kernel-checked, no `sorry`/`axiom`/`native_decide`) -/

-- Base three-phase block
#print axioms B3_isHermitian
#print axioms B3_charpoly
#print axioms B3_det
#print axioms B3_quadForm
#print axioms B3_posDef_iff

-- Four-parameter block: construction, spectrum, determinant, positivity
#print axioms B4_isHermitian
#print axioms B4_quadForm
#print axioms B4_charpoly
#print axioms B4_det
#print axioms B4_singular_iff
#print axioms B4_posDef_iff

-- Phase classification
#print axioms B4_massive_iff
#print axioms B4_aperture_necessary
#print axioms B4_turn_necessary
#print axioms B4_posDef_iff_of_sol_zero
#print axioms B4_critical
#print axioms B4_indefinite_of_neg_aperture
#print axioms B4_indefinite_of_neg_turn
#print axioms B4_indefinite_of_detMinus_neg

end MassPhase
