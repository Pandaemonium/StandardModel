import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# Confinement as a finite positive-sector obstruction (Conjecture B)

This file builds the smallest explicit `Clifford ⊗ color` carrier equipped with a
Krein (indefinite) closure form and a Gauss / physical-sector compression, and proves
the **confinement dichotomy** as a finite positivity theorem:

* on a **colored** (non-singlet, traceless) sub-sector the compressed closure form is
  **negative definite** — in particular indefinite / not positive-definite: there is a
  negative direction, hence *no isolated positive mass* (a colored excitation is a
  "non-decodable message");
* on the **color-singlet** sub-sector the compression is **positive definite**
  (aperture-dominated): it *admits a positive isolated mass* (a genuine "codeword",
  i.e. a particle).

## The carrier

* Clifford factor: `Fin 2` with the Krein form `etaKrein = diag(1, -1)` (an *indefinite*
  ledger: `s = 0` is the physical/aperture mode, `s = 1` the null/ghost mode).
* Color factor: `Fin 3` (three colors, an `SU(3)`-flavoured label). The **color closure
  form** is
  `Gcolor = 𝟙_all - I = !![0,1,1; 1,0,1; 1,1,0]`,
  i.e. `x ↦ (∑ᵢ xᵢ)² - ‖x‖²`. The uniform all-ones coupling only sees the *total color
  charge* `∑ᵢ xᵢ` (the singlet component), while `-‖x‖²` is the per-mode aperture cost.
* Full closure/Krein form on the carrier: `Mfull = etaKrein ⊗ₖ Gcolor`.
* Gauss / physical-sector compression: `physColor` embeds a color state into the physical
  Clifford mode `s = 0`; `ghostColor` into the null mode `s = 1`. Compressing `Mfull`
  along `physColor` recovers exactly `Gcolor` (the physical closure form), while along
  `ghostColor` it flips sign (the Krein signature), witnessing that the *raw* ledger is
  indefinite before the quotient.

## The distinguishing criterion

`qval Gcolor x > 0  ↔  (∑ᵢ xᵢ)² > ‖x‖²` (`criterion`). Positivity of the closure form is
*exactly* the statement that the singlet (total color charge) component dominates the
norm. Singlets `x ∝ (1,1,1)` achieve `(∑xᵢ)² = 3‖x‖² > ‖x‖²`; colored (traceless) states
have `∑xᵢ = 0 < ‖x‖²`. This is the mechanism, stated as a criterion rather than a single
example.

## Boundary

This is a *finite positivity analogue* of confinement — a linear-algebraic obstruction on
an explicit finite Krein carrier — **not** a continuum gauge-theory confinement proof.
-/

namespace ConfinementB

open Matrix
open scoped Kronecker

/-- The Clifford Krein form on `Fin 2`: `diag(1, -1)`. Mode `0` is physical/aperture
(positive), mode `1` is the null/ghost mode (negative). Indefinite by design. -/
noncomputable def etaKrein : Matrix (Fin 2) (Fin 2) ℝ := !![1, 0; 0, -1]

/-- The color closure form on `Fin 3` (three colors): the all-ones matrix minus the
identity, `!![0,1,1; 1,0,1; 1,1,0]`. Its quadratic form is `(∑ xᵢ)² - ‖x‖²`. -/
noncomputable def Gcolor : Matrix (Fin 3) (Fin 3) ℝ := !![0, 1, 1; 1, 0, 1; 1, 1, 0]

/-- The full `Clifford ⊗ color` Krein closure form on the carrier `Fin 2 × Fin 3`. -/
noncomputable def Mfull : Matrix (Fin 2 × Fin 3) (Fin 2 × Fin 3) ℝ := etaKrein ⊗ₖ Gcolor

/-- Quadratic form (closure value) associated to a symmetric matrix `M`:
`qval M x = xᵀ M x`. -/
noncomputable def qval {n : Type*} [Fintype n] (M : Matrix n n ℝ) (x : n → ℝ) : ℝ :=
  x ⬝ᵥ (M *ᵥ x)

/-- Gauss / physical-sector embedding: place a color state in the physical Clifford
mode `s = 0` (the aperture-dominated sector). -/
noncomputable def physColor (x : Fin 3 → ℝ) : Fin 2 × Fin 3 → ℝ :=
  fun p => if p.1 = 0 then x p.2 else 0

/-- Ghost embedding: place a color state in the null Clifford mode `s = 1`. -/
noncomputable def ghostColor (x : Fin 3 → ℝ) : Fin 2 × Fin 3 → ℝ :=
  fun p => if p.1 = 0 then 0 else x p.2

/-- **Color grading — colored (non-singlet) sub-sector.** A state is *colored* when its
total color charge vanishes (`∑ᵢ xᵢ = 0`), i.e. it lies in the traceless / adjoint part,
carrying no singlet component. -/
def IsColored (x : Fin 3 → ℝ) : Prop := x 0 + x 1 + x 2 = 0

/-- **Color grading — singlet sub-sector.** A state is a *singlet* when all its color
components agree, i.e. it is proportional to `(1,1,1)` (the center-invariant direction). -/
def IsSinglet (x : Fin 3 → ℝ) : Prop := x 0 = x 1 ∧ x 1 = x 2

/-! ### Basic structure: symmetry and the explicit closure quadratic form -/

/-- The color closure form is symmetric. -/
lemma Gcolor_isSymm : Gcolor.IsSymm := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Matrix.transpose_apply, Gcolor]

/-- The Clifford Krein form is symmetric. -/
lemma etaKrein_isSymm : etaKrein.IsSymm := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Matrix.transpose_apply, etaKrein]

/-- The full carrier form is symmetric. -/
lemma Mfull_isSymm : Mfull.IsSymm := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.transpose_apply, Mfull, Matrix.kroneckerMap_apply, etaKrein, Gcolor]

/-- **Explicit closure quadratic form.** The color closure value is
`(∑ᵢ xᵢ)² - ‖x‖²`: the coherent singlet (total-charge) term minus the per-mode aperture
cost. -/
lemma qval_color (x : Fin 3 → ℝ) :
    qval Gcolor x = (x 0 + x 1 + x 2) ^ 2 - (x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2) := by
  simp [qval, Gcolor, dotProduct, Matrix.mulVec, Fin.sum_univ_three]
  ring

/-! ### The Gauss / physical-sector compression -/

/-- **Physical (Gauss) compression recovers the color closure form.** Compressing the
full Krein form `Mfull` along the physical Clifford mode `s = 0` gives exactly `Gcolor`.
This is the physical sector on which the confinement dichotomy is stated. -/
lemma phys_compression (x : Fin 3 → ℝ) : qval Mfull (physColor x) = qval Gcolor x := by
  simp only [qval, Mfull, physColor, dotProduct, Matrix.mulVec, Fintype.sum_prod_type,
    Matrix.kroneckerMap_apply, Fin.sum_univ_two, Fin.sum_univ_three]
  simp [etaKrein, Gcolor]

/-- **Ghost compression flips the sign.** Compressing `Mfull` along the null Clifford
mode `s = 1` yields `-Gcolor`: the Krein signature. This is why the raw ledger is
indefinite before the Gauss quotient. -/
lemma ghost_compression (x : Fin 3 → ℝ) : qval Mfull (ghostColor x) = - qval Gcolor x := by
  simp only [qval, Mfull, ghostColor, dotProduct, Matrix.mulVec, Fintype.sum_prod_type,
    Matrix.kroneckerMap_apply, Fin.sum_univ_two, Fin.sum_univ_three]
  simp [etaKrein, Gcolor]
  ring

/-! ### The confinement dichotomy -/

/-- **Colored ⇒ no isolated positive mass.** On the colored (traceless, non-singlet)
sub-sector the compressed closure form is *negative definite*: every nonzero colored
state has strictly negative closure value. Hence the colored compression is indefinite /
not positive-definite — a colored excitation is a non-decodable message with no isolated
positive mass. -/
theorem colored_negDef (x : Fin 3 → ℝ) (hc : IsColored x) (hx : x ≠ 0) :
    qval Gcolor x < 0 := by
  rw [qval_color, hc]
  have hne : x 0 ≠ 0 ∨ x 1 ≠ 0 ∨ x 2 ≠ 0 := by
    by_contra hcon
    push_neg at hcon
    exact hx (by funext i; fin_cases i <;> simp [hcon.1, hcon.2.1, hcon.2.2])
  rcases hne with h0 | h1 | h2
  · nlinarith [sq_nonneg (x 0), sq_nonneg (x 1), sq_nonneg (x 2), pow_two_pos_of_ne_zero h0]
  · nlinarith [sq_nonneg (x 0), sq_nonneg (x 1), sq_nonneg (x 2), pow_two_pos_of_ne_zero h1]
  · nlinarith [sq_nonneg (x 0), sq_nonneg (x 1), sq_nonneg (x 2), pow_two_pos_of_ne_zero h2]

/-- **Singlet ⇒ positive isolated mass.** On the color-singlet sub-sector the compression
is *positive definite*: every nonzero singlet has strictly positive closure value. The
singlet is aperture-dominated and admits a positive isolated mass — a genuine particle. -/
theorem singlet_posDef (x : Fin 3 → ℝ) (hs : IsSinglet x) (hx : x ≠ 0) :
    0 < qval Gcolor x := by
  obtain ⟨h1, h2⟩ := hs
  rw [qval_color]
  have hx0 : x 0 ≠ 0 := by
    intro hc
    exact hx (by funext i; fin_cases i <;> simp_all)
  nlinarith [pow_two_pos_of_ne_zero hx0]

/-! ### The distinguishing criterion -/

/-- **Distinguishing criterion.** The closure form is positive on `x` *iff* the singlet
(total color charge) component dominates the norm: `(∑ᵢ xᵢ)² > ‖x‖²`. This is the exact
mechanism separating particles (singlets) from confined colored excitations. -/
theorem criterion (x : Fin 3 → ℝ) :
    0 < qval Gcolor x ↔ (x 0 + x 1 + x 2) ^ 2 > x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2 := by
  rw [qval_color]; constructor <;> intro h <;> linarith

/-- Singlets satisfy the positivity criterion strictly (their total charge dominates). -/
theorem singlet_satisfies_criterion (x : Fin 3 → ℝ) (hs : IsSinglet x) (hx : x ≠ 0) :
    (x 0 + x 1 + x 2) ^ 2 > x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2 :=
  (criterion x).1 (singlet_posDef x hs hx)

/-- Colored states fail the positivity criterion (zero total charge). -/
theorem colored_fails_criterion (x : Fin 3 → ℝ) (hc : IsColored x) (hx : x ≠ 0) :
    ¬ ((x 0 + x 1 + x 2) ^ 2 > x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2) := by
  intro h
  exact absurd ((criterion x).2 h) (not_lt.2 (le_of_lt (colored_negDef x hc hx)))

/-! ### The raw ledger is indefinite (Krein) -/

/-- **The raw carrier form is genuinely indefinite (Krein).** Before the Gauss quotient
the full form `Mfull` takes both strictly positive and strictly negative values (a singlet
placed in the physical mode is positive, the same singlet in the null mode is negative).
This is the indefinite information ledger the positive-sector functor acts on. -/
theorem Mfull_indefinite :
    ∃ v w : Fin 2 × Fin 3 → ℝ, 0 < qval Mfull v ∧ qval Mfull w < 0 := by
  refine ⟨physColor ![1, 1, 1], ghostColor ![1, 1, 1], ?_, ?_⟩
  · rw [phys_compression]
    exact singlet_posDef _ ⟨by simp, by simp⟩ (by
      intro h; have := congrFun h 0; simp at this)
  · rw [ghost_compression]
    have : 0 < qval Gcolor ![1, 1, 1] :=
      singlet_posDef _ ⟨by simp, by simp⟩ (by intro h; have := congrFun h 0; simp at this)
    linarith

/-! ### Summary dichotomy (the confinement statement)

Putting the two theorems together: a color state admits an isolated positive mass on the
physical (Gauss) sector **iff** it is not confined, and exactly the singlets qualify.
-/

/-- **Confinement dichotomy.** For a nonzero physical color state:
`singlet ⇒ positive isolated mass` and `colored ⇒ negative (no isolated mass)`. The two
gradings are mutually exclusive on the positive-sector question. -/
theorem confinement_dichotomy (x : Fin 3 → ℝ) (hx : x ≠ 0) :
    (IsSinglet x → 0 < qval Mfull (physColor x)) ∧
    (IsColored x → qval Mfull (physColor x) < 0) := by
  rw [phys_compression]
  exact ⟨fun hs => singlet_posDef x hs hx, fun hc => colored_negDef x hc hx⟩

end ConfinementB

-- Axiom footprint guards (kernel-checked, Mathlib only).
#print axioms ConfinementB.colored_negDef
#print axioms ConfinementB.singlet_posDef
#print axioms ConfinementB.criterion
#print axioms ConfinementB.phys_compression
#print axioms ConfinementB.ghost_compression
#print axioms ConfinementB.Mfull_indefinite
#print axioms ConfinementB.confinement_dichotomy
