import Mathlib

/-!
# Exact product-character DFT core

This standalone target isolates the finite harmonic-analysis core needed by the
live three-dimensional null-edge walk.  Its definitions exactly match the
`Axis`, `Position`, `planeWave`, `siteCard`, and normalization conventions in
`Finite3Plus1FourierBridge` and the pending live-DFT composition.
-/

noncomputable section

open Matrix Complex
open scoped BigOperators ZMod

namespace ProductDFTCore

abbrev Axis := Fin 3
abbrev Position (L : Nat) := Axis -> ZMod L

def planeWave {L : Nat} [NeZero L] (k p : Position L) : Complex :=
  ∏ j : Axis, ZMod.stdAddChar (p j * k j)

def siteCard (L : Nat) [NeZero L] : Nat := Fintype.card (Position L)

def fourierNormFactor (L : Nat) [NeZero L] : Real :=
  1 / Real.sqrt (siteCard L : Real)

theorem star_stdAddChar {L : Nat} [NeZero L] (x : ZMod L) :
    star (ZMod.stdAddChar x) = ZMod.stdAddChar (-x) := by
  sorry

theorem planeWave_norm {L : Nat} [NeZero L] (k p : Position L) :
    ‖planeWave k p‖ = 1 := by
  sorry

theorem planeWave_ne_zero {L : Nat} [NeZero L] (k p : Position L) :
    planeWave k p ≠ 0 := by
  sorry

theorem sum_prod_stdAddChar {L : Nat} [NeZero L] (b : Position L) :
    ∑ x : Position L, ∏ j : Axis, ZMod.stdAddChar (x j * b j) =
      if b = 0 then (siteCard L : Complex) else 0 := by
  sorry

theorem star_planeWave_mul_prod {L : Nat} [NeZero L] (k p q : Position L) :
    star (planeWave k p) * planeWave k q =
      ∏ j : Axis, ZMod.stdAddChar (k j * (q j - p j)) := by
  sorry

theorem planeWave_mul_star_prod {L : Nat} [NeZero L] (k ell p : Position L) :
    planeWave k p * star (planeWave ell p) =
      ∏ j : Axis, ZMod.stdAddChar (p j * (k j - ell j)) := by
  sorry

theorem planeWave_column_orthogonality {L : Nat} [NeZero L]
    (p q : Position L) :
    ∑ k : Position L, star (planeWave k p) * planeWave k q =
      if p = q then (siteCard L : Complex) else 0 := by
  sorry

theorem planeWave_row_orthogonality {L : Nat} [NeZero L]
    (k ell : Position L) :
    ∑ p : Position L, planeWave k p * star (planeWave ell p) =
      if k = ell then (siteCard L : Complex) else 0 := by
  sorry

theorem siteCard_pos (L : Nat) [NeZero L] : 0 < siteCard L := by
  sorry

theorem fourierNormFactor_sq_mul_card (L : Nat) [NeZero L] :
    fourierNormFactor L * fourierNormFactor L * (siteCard L : Real) = 1 := by
  sorry

theorem column_zero_control (L : Nat) [NeZero L] :
    ∑ k : Position L,
        star (planeWave k (0 : Position L)) * planeWave k 0 =
      (siteCard L : Complex) := by
  sorry

theorem distinct_column_control :
    ∑ k : Position 2,
        star (planeWave k (0 : Position 2)) *
          planeWave k (fun j => if j = 0 then 1 else 0) = 0 := by
  sorry

end ProductDFTCore
