import Mathlib.Tactic

/-!
# Weighted finite sign-source fluctuation scaling

This draft module generalizes the equal-cell P9 fluctuation theorem. Each cell
has a real amplitude `amp i`; the source sign is independently `+1` or `-1`.
The weighted total source has zero ensemble sum and second moment

```text
sum_cfg weightedTotalSource(amp,cfg)^2 = (sum_i amp_i^2) * 2^N.
```

After normalization by the number of configurations, the variance is
`sum_i amp_i^2`. This is the finite algebraic handle needed before discussing
suppressed or nonuniform residual sources in a diamond.

Proven by Aristotle project `4ddda2cc-0fe7-4e6e-b230-19fa8a209f6a` on
2026-06-22 from the focused standalone package
`null-edge-p9-weighted-fluctuation-scaling-20260622`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9WeightedFluctuation

open BigOperators

/-- A two-point source sign. -/
def sign (b : Bool) : Real :=
  if b then 1 else -1

/-- Weighted total sign source of an `N`-cell configuration. -/
def weightedTotalSource {N : Nat} (amp : Fin N -> Real)
    (cfg : Fin N -> Bool) : Real :=
  Finset.univ.sum fun i => amp i * sign (cfg i)

/-- Unnormalized weighted ensemble mean. -/
def weightedEnsembleMeanTotal {N : Nat} (amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun cfg : Fin N -> Bool => weightedTotalSource amp cfg

/-- Unnormalized weighted ensemble second moment. -/
def weightedEnsembleSecondMoment {N : Nat} (amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun cfg : Fin N -> Bool => weightedTotalSource amp cfg ^ 2

/-- Sum of squared cell amplitudes. -/
def amplitudeSqSum {N : Nat} (amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => amp i ^ 2

/-- The two signs cancel in the one-cell ensemble. -/
theorem sign_sum_eq_zero :
    (Finset.univ.sum fun b : Bool => sign b) = 0 := by
  unfold sign
  norm_cast

/-- Every sign has unit square. -/
theorem sign_sq_eq_one (b : Bool) :
    sign b ^ 2 = 1 := by
  cases b <;> norm_num [sign]

/-- A single coordinate has zero ensemble sum over all configurations. -/
theorem coordinate_sign_sum_eq_zero {N : Nat} (i : Fin N) :
    (Finset.univ.sum fun cfg : Fin N -> Bool => sign (cfg i)) = 0 := by
  have h_sum_zero :
      (Finset.univ.sum fun cfg : Fin N -> Bool => sign (cfg i)) =
        Finset.univ.sum fun cfg : Fin N -> Bool => sign (cfg i) * (-1) := by
    apply Finset.sum_bij (fun cfg _ => fun j => if j == i then !cfg i else cfg j)
    · exact fun _ _ => Finset.mem_univ _
    · intro a₁ _ a₂ _ h
      ext j
      replace h := congr_fun h j
      by_cases hj : j = i <;> aesop
    · exact fun b _ => ⟨fun j => if j == i then !b i else b j,
        Finset.mem_univ _, by aesop⟩
    · unfold sign
      aesop
  norm_num [Finset.sum_mul _ _ _] at h_sum_zero
  linarith

/-- Distinct coordinates have zero ensemble cross-sum. -/
theorem coordinate_sign_product_sum_eq_zero {N : Nat} {i j : Fin N}
    (hij : i != j) :
    (Finset.univ.sum fun cfg : Fin N -> Bool => sign (cfg i) * sign (cfg j)) = 0 := by
  have h_pair :
      (Finset.univ.sum fun cfg : Fin N -> Bool => sign (cfg i) * sign (cfg j)) =
        Finset.univ.sum fun cfg : Fin N -> Bool => -sign (cfg i) * sign (cfg j) := by
    apply Finset.sum_bij (fun cfg _ => Function.update cfg j (not (cfg j)))
    · grind
    · intro a₁ _ a₂ _ h
      ext k
      by_cases hk : k = j <;> replace h := congr_fun h k <;> aesop
    · exact fun b _ => ⟨Function.update b j (!b j), Finset.mem_univ _, by aesop⟩
    · unfold sign
      aesop
  norm_num [Finset.sum_neg_distrib] at h_pair
  linarith

/-- A coordinate square contributes one unit for every configuration. -/
theorem coordinate_sign_square_sum_eq_card {N : Nat} (i : Fin N) :
    (Finset.univ.sum fun cfg : Fin N -> Bool => sign (cfg i) ^ 2) =
      (2 : Real) ^ N := by
  simp +decide [sign_sq_eq_one]

/-- The weighted total source has zero ensemble sum. -/
theorem weightedEnsembleMeanTotal_eq_zero {N : Nat} (amp : Fin N -> Real) :
    weightedEnsembleMeanTotal amp = 0 := by
  convert Finset.sum_comm using 1
  simp +decide [← Finset.mul_sum _ _ _, coordinate_sign_sum_eq_zero]

/-- The exact weighted finite fluctuation-scaling identity. -/
theorem weightedEnsembleSecondMoment_eq_amplitudeSqSum_times_configs
    {N : Nat} (amp : Fin N -> Real) :
    weightedEnsembleSecondMoment amp = amplitudeSqSum amp * (2 : Real) ^ N := by
  have h_fubini :
      (Finset.univ.sum fun cfg : Fin N -> Bool =>
        (Finset.univ.sum fun j => amp j * sign (cfg j)) ^ 2) =
        Finset.univ.sum fun j =>
          Finset.univ.sum fun k =>
            amp j * amp k *
              Finset.univ.sum fun cfg : Fin N -> Bool => sign (cfg j) * sign (cfg k) := by
    simp +decide only [pow_two, Finset.mul_sum _ _ _, mul_comm, mul_left_comm]
    exact Finset.sum_comm.trans
      (Finset.sum_congr rfl fun _ _ => Finset.sum_comm.trans
        (Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring))
  have h_inner :
      forall j k : Fin N,
        (Finset.univ.sum fun cfg : Fin N -> Bool => sign (cfg j) * sign (cfg k)) =
          if j = k then 2 ^ N else 0 := by
    intro j k
    split_ifs with h
    · subst j
      simpa [← sq] using coordinate_sign_square_sum_eq_card k
    · exact coordinate_sign_product_sum_eq_zero
        (show j != k from by simpa using h)
  simp_all +decide [← Finset.sum_mul]
  simpa only [← sq, weightedEnsembleSecondMoment, amplitudeSqSum] using h_fubini

/-- Normalized second moment, stated as a division corollary. -/
theorem normalizedWeightedSecondMoment_eq_amplitudeSqSum
    {N : Nat} (amp : Fin N -> Real) :
    weightedEnsembleSecondMoment amp / (2 : Real) ^ N = amplitudeSqSum amp := by
  rw [div_eq_iff] <;> first
    | positivity
    | exact weightedEnsembleSecondMoment_eq_amplitudeSqSum_times_configs amp

end PhysicsSM.Draft.NullEdgeP9WeightedFluctuation
