import Mathlib.Tactic

/-!
# Finite sign-source fluctuation scaling

This draft module records a finite probability-free pilot for the P9
cosmological-constant/source-visibility branch.

The model is intentionally minimal: an `N`-cell configuration assigns each cell
a sign source `+1` or `-1`. The total source has zero ensemble sum, while its
unnormalized second moment scales like `N * 2^N`, so the normalized variance is
`N`. This is the exact finite algebra behind the expected `sqrt(N)`
fluctuation size.

No measure theory, causal sets, or continuum limit is assumed here.

Proven by Aristotle project `75f0e4c0-7944-4bca-83f3-fd26c96976a7` on
2026-06-22 from the focused standalone package
`null-edge-p9-fluctuation-scaling-20260622`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9FluctuationScaling

open BigOperators

/-- A two-point source sign. -/
def sign (b : Bool) : Real :=
  if b then 1 else -1

/-- Total sign source of an `N`-cell configuration. -/
def totalSource {N : Nat} (cfg : Fin N -> Bool) : Real :=
  Finset.univ.sum fun i => sign (cfg i)

/-- Unnormalized ensemble sum of the total source over all configurations. -/
def ensembleMeanTotal (N : Nat) : Real :=
  Finset.univ.sum fun cfg : Fin N -> Bool => totalSource cfg

/-- Unnormalized ensemble second moment of the total source. -/
def ensembleSecondMoment (N : Nat) : Real :=
  Finset.univ.sum fun cfg : Fin N -> Bool => totalSource cfg ^ 2

/-- The two signs cancel in the one-cell ensemble. -/
theorem sign_sum_eq_zero :
    (Finset.univ.sum fun b : Bool => sign b) = 0 := by
  unfold sign
  norm_num

/-- Every sign has unit square. -/
theorem sign_sq_eq_one (b : Bool) :
    sign b ^ 2 = 1 := by
  cases b <;> norm_num [sign]

/-- A single coordinate has zero ensemble sum over all configurations. -/
theorem coordinate_sign_sum_eq_zero {N : Nat} (i : Fin N) :
    (Finset.univ.sum fun cfg : Fin N -> Bool => sign (cfg i)) = 0 := by
  have h_opposite :
      (Finset.univ.sum fun cfg : Fin N -> Bool => sign (cfg i)) =
        Finset.univ.sum fun cfg : Fin N -> Bool => sign (!cfg i) := by
    apply Finset.sum_bij (fun cfg _ => Function.update cfg i (!cfg i))
    · grind
    · intro a₁ _ a₂ _ h
      ext j
      replace h := congr_fun h j
      by_cases hj : j = i <;> aesop
    · exact fun b _ => ⟨Function.update b i (!b i), Finset.mem_univ _, by simp +decide⟩
    · aesop
  unfold sign at *
  norm_num [Finset.sum_ite] at *
  linarith

/-- Distinct coordinates have zero ensemble cross-sum. -/
theorem coordinate_sign_product_sum_eq_zero {N : Nat} {i j : Fin N}
    (hij : i != j) :
    (Finset.univ.sum fun cfg : Fin N -> Bool => sign (cfg i) * sign (cfg j)) = 0 := by
  have h_decomp :
      (Finset.univ.sum fun cfg : Fin N -> Bool => sign (cfg i) * sign (cfg j)) =
        Finset.univ.sum
          (fun cfg : Fin N -> Bool => sign (cfg i) * sign (cfg j) * (-1 : Real)) := by
    apply Finset.sum_bij (fun cfg _ => fun k => if k = i then !cfg i else cfg k)
    · exact fun _ _ => Finset.mem_univ _
    · intro a₁ _ a₂ _ h
      ext k
      replace h := congr_fun h k
      aesop
    · exact fun b _ => ⟨fun k => if k = i then !b i else b k, Finset.mem_univ _, by aesop⟩
    · unfold sign
      aesop
  norm_num [Finset.sum_mul _ _ _] at *
  linarith

/-- A coordinate square contributes one unit for every configuration. -/
theorem coordinate_sign_square_sum_eq_card {N : Nat} (i : Fin N) :
    (Finset.univ.sum fun cfg : Fin N -> Bool => sign (cfg i) ^ 2) =
      (2 : Real) ^ N := by
  norm_num [sign_sq_eq_one]

/-- The total source has zero ensemble sum. -/
theorem ensembleMeanTotal_eq_zero (N : Nat) :
    ensembleMeanTotal N = 0 := by
  unfold ensembleMeanTotal totalSource
  rw [Finset.sum_comm]
  simp +decide [coordinate_sign_sum_eq_zero]

/--
The exact finite fluctuation-scaling identity.

After dividing by the `2^N` configurations, this says that the variance of the
total sign source is `N`, hence the root-mean-square source scales as
`sqrt(N)`.
-/
theorem ensembleSecondMoment_eq_card_times_configs (N : Nat) :
    ensembleSecondMoment N = (N : Real) * (2 : Real) ^ N := by
  simp +decide [ensembleSecondMoment, totalSource]
  have h_expand :
      (Finset.univ.sum fun x : Fin N -> Bool => (Finset.univ.sum fun i : Fin N =>
        sign (x i)) ^ 2) =
        Finset.univ.sum fun i : Fin N =>
          Finset.univ.sum fun j : Fin N =>
            Finset.univ.sum fun x : Fin N -> Bool => sign (x i) * sign (x j) := by
    simp +decide only [sq, Finset.mul_sum _ _ _, mul_comm]
    exact Finset.sum_comm.trans
      (Finset.sum_congr rfl fun _ _ => Finset.sum_comm)
  rw [h_expand]
  rw [Finset.sum_congr rfl fun i hi =>
    Finset.sum_eq_single i (fun j hj => ?_) (?_)] <;> norm_num
  · simp +decide [← sq, coordinate_sign_square_sum_eq_card]
  · exact fun hij => coordinate_sign_product_sum_eq_zero
      (by simpa [Fin.ext_iff] using Ne.symm hij)

end PhysicsSM.Draft.NullEdgeP9FluctuationScaling
