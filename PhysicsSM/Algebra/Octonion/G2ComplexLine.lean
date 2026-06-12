import Mathlib
import PhysicsSM.Algebra.Octonion.ComplexLine
import PhysicsSM.Algebra.Octonion.ComplexSplitting
import PhysicsSM.Algebra.Octonion.Norm

/-!
# Algebra.Octonion.G2ComplexLine

Preservation and complex-linearity theorems for octonion linear maps that
preserve multiplication and fix the chosen imaginary unit `e111`.

## Mathematical context

In Baez's 2021 talk "Can We Understand the Standard Model Using Octonions?",
choosing a unit imaginary octonion `i` selects a copy of the complex numbers
`ℂ = span_ℝ {1, i}` inside the octonions. The stabilizer of `i` (among
multiplicative linear maps) preserves the splitting `𝕆 = ℂ ⊕ ℂ³` and acts
complex-linearly on the complement `ℂ³`.

This file proves:
- A multiplicative linear map fixing `e111` preserves the chosen complex line.
- It preserves the complement.
- It commutes with left multiplication by `e111` (complex-linearity).

## Claim boundary

This file does **not** claim or prove `Stab_{G₂}(e111) ≅ SU(3)`. It only
proves the algebraic implications of the record `FixingE111MulLinear`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## The lightweight local record -/

/-- A real-linear map on the project octonions that preserves multiplication,
    maps `1 ↦ 1`, and fixes the chosen imaginary unit `e111`.

    This is a minimal record for the algebraic implications below. It does not
    assert membership in `G₂` or any automorphism group. -/
structure FixingE111MulLinear where
  toFun : Octonion → Octonion
  map_add : ∀ x y, toFun (x + y) = toFun x + toFun y
  map_smul : ∀ (r : ℝ) x, toFun (r • x) = r • toFun x
  map_one : toFun 1 = 1
  map_mul : ∀ x y, toFun (x * y) = toFun x * toFun y
  fixes_e111 : toFun e111 = e111
  map_conj : ∀ x, toFun (Octonion.conj x) = Octonion.conj (toFun x)

/-! ## Helper: the conjugation action α(x) = e111 * (x * e111)

The map `α(x) = e111 * (x * e111)` acts as `-id` on the chosen complex line
and as `+id` on the complement. This is the key tool for proving complement
preservation algebraically. -/

/--
The conjugation action `α(x) = e111 * (x * e111)` negates the `c0`
    coordinate of any octonion.
-/
theorem conj_action_c0 (x : Octonion) :
    (e111 * (x * e111)).c0 = -x.c0 := by
      convert rightMul_e111_sq_neg x using 1;
      constructor <;> intro h <;> simp_all +decide [ Octonion.ext_iff ]

/--
The conjugation action `α(x) = e111 * (x * e111)` negates the `c7`
    coordinate of any octonion.
-/
theorem conj_action_c7 (x : Octonion) :
    (e111 * (x * e111)).c7 = -x.c7 := by
      grind +suggestions

/--
The conjugation action fixes every element of the complement:
    if `x.c0 = 0` and `x.c7 = 0`, then `e111 * (x * e111) = x`.
-/
theorem conj_action_on_complement {x : Octonion}
    (hx : InChosenComplexComplement x) :
    e111 * (x * e111) = x := by
      obtain ⟨h0, h7⟩ := hx
      ext
      all_goals simp [h0, h7]

/--
A `FixingE111MulLinear` map commutes with the conjugation action:
    `e111 * (g(x) * e111) = g(e111 * (x * e111))`.
-/
theorem conj_action_commutes (g : FixingE111MulLinear) (x : Octonion) :
    e111 * (g.toFun x * e111) = g.toFun (e111 * (x * e111)) := by
      have h_g_e111 : g.toFun (e111 * (x * e111)) = g.toFun e111 * (g.toFun x * g.toFun e111) := by
        rw [ g.map_mul, g.map_mul ];
      rw [ h_g_e111, g.fixes_e111 ]

/-! ## Main theorems -/

/--
A `FixingE111MulLinear` map preserves the chosen complex line
    `span_ℝ {1, e111}`.

    **Proof idea.** An element `x` in the line satisfies
    `x.c1 = … = x.c6 = 0`, so `x = x.c0 • 1 + x.c7 • e111`. By linearity,
    `g(x) = x.c0 • g(1) + x.c7 • g(e111) = x.c0 • 1 + x.c7 • e111`, which
    is in the line.
-/
theorem preserves_chosen_complex_line
    (g : FixingE111MulLinear) {x : Octonion}
    (hx : InChosenComplexLine x) :
    InChosenComplexLine (g.toFun x) := by
      have h_decomp : x = x.c0 • (1 : Octonion) + x.c7 • e111 := by
        obtain ⟨hx1, hx2, hx3, hx4, hx5, hx6⟩ := hx;
        cases x ; aesop;
      -- By linearity of `g`, we have `g(x) = x.c0 • g(1) + x.c7 • g(e111)`.
      have h_linear : g.toFun x = x.c0 • g.toFun 1 + x.c7 • g.toFun e111 := by
        conv_lhs => rw [ h_decomp ];
        rw [ g.map_add, g.map_smul, g.map_smul ];
      rw [ h_linear, g.map_one, g.fixes_e111 ];
      grind +qlia

/-- A `FixingE111MulLinear` map preserves the complement of the chosen
    complex line.

    **Proof idea.** Define `α(y) = e111 * (y * e111)`. One checks coordinate-
    wise that `α(y).c0 = -y.c0` and `α(y).c7 = -y.c7` for all `y`, and
    `α(x) = x` when `x` is in the complement. Since `g` commutes with `α`
    (by `map_mul` and `fixes_e111`), we get `α(g(x)) = g(α(x)) = g(x)`,
    hence `g(x).c0 = 0` and `g(x).c7 = 0`. -/
theorem preserves_chosen_complex_complement
    (g : FixingE111MulLinear) {x : Octonion}
    (hx : InChosenComplexComplement x) :
    InChosenComplexComplement (g.toFun x) := by
  have hcomm := conj_action_commutes g x
  have hfix := conj_action_on_complement hx
  -- From hcomm and hfix: e111 * (g(x) * e111) = g(x)
  have hkey : e111 * (g.toFun x * e111) = g.toFun x := by rw [hcomm, hfix]
  constructor
  · -- g(x).c0 = 0
    have h1 := conj_action_c0 (g.toFun x)
    have h2 := congrArg Octonion.c0 hkey
    linarith
  · -- g(x).c7 = 0
    have h1 := conj_action_c7 (g.toFun x)
    have h2 := congrArg Octonion.c7 hkey
    linarith

/-- A `FixingE111MulLinear` map commutes with left multiplication by `e111`.

    This is the complex-linearity statement: `g` intertwines the complex
    structure `J = L_{e111}` on the full octonion algebra. -/
theorem commutes_with_left_e111
    (g : FixingE111MulLinear) (x : Octonion) :
    g.toFun (e111 * x) = e111 * g.toFun x := by
  rw [g.map_mul, g.fixes_e111]

/-- Specialization of `commutes_with_left_e111` to complement elements. -/
theorem complex_linear_on_complement
    (g : FixingE111MulLinear) {x : Octonion}
    (_hx : InChosenComplexComplement x) :
    g.toFun (e111 * x) = e111 * g.toFun x :=
  commutes_with_left_e111 g x

/-- `g` commutes with `J = L_{e111}` on complement elements expressed as
    `ComplexTriple.toOctonion`. -/
theorem commutes_with_J_on_triple
    (g : FixingE111MulLinear) (w : ComplexTriple) :
    g.toFun (e111 * w.toOctonion) = e111 * g.toFun w.toOctonion :=
  commutes_with_left_e111 g w.toOctonion

/-! ## Norm preservation -/

/-
A `FixingE111MulLinear` map preserves the squared octonion norm.

    **Proof.** Since `normSq x • 1 = x * conj x`, applying `g` gives
    `g(normSq x • 1) = normSq x • 1` (by `map_smul` and `map_one`), and
    `g(x * conj x) = g(x) * conj(g(x))` (by `map_mul` and `map_conj`).
    Hence `normSq x • 1 = g(x) * conj(g(x)) = normSq(g(x)) • 1`, so
    `normSq(g(x)) = normSq x`.
-/
theorem FixingE111MulLinear.normSq_preserved
    (g : FixingE111MulLinear) (x : Octonion) :
    Octonion.normSq (g.toFun x) = Octonion.normSq x := by
  have h_normSq_def : ∀ x : Octonion,
      Octonion.normSq x • (1 : Octonion) = x * Octonion.conj x :=
    fun x ↦ normSq_eq_mul_conj x
  have h_g_normSq_def :
      ∀ x : Octonion, Octonion.normSq x • (1 : Octonion) =
        g.toFun x * Octonion.conj (g.toFun x) := by
    intros x
    have := h_normSq_def x
    have := congr_arg (g.toFun) this
    simp at this;
    grind +suggestions;
  convert congr_arg
    ( fun y => y.c0 ) ( h_g_normSq_def x ) |> Eq.symm using 1;
  · simp +decide [ ← h_normSq_def ];
  · simp +decide [ Octonion.smul_c0 ]

end PhysicsSM.Algebra.Octonion.G2ComplexLine
