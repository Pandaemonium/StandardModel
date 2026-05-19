import Mathlib

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.style.multiGoal false
set_option linter.style.refine false
set_option linter.style.whitespace false
set_option linter.flexible false
set_option maxHeartbeats 400000

/-!
# Formal power series coefficient theorem for finite products

This file proves a general lemma connecting `PowerSeries.coeff_prod`
(which uses `finsuppAntidiag`) to a sum over `Fin k → Fin (s+1)`.

The lemma `coeff_finset_prod_eq_sum_fin` is used by the weight-enumerator
bridge to connect the formal product of one-dimensional lift series with
the `weightContribConvolution` definition.
-/

/--
For a finite product of power series over `Fin k`, the `s`-th coefficient
equals a sum over all functions `Fin k → Fin (s+1)` whose values sum to `s`,
of the product of individual coefficients.

This converts from the `finsuppAntidiag` formulation in Mathlib's
`PowerSeries.coeff_prod` to the explicit `Fin (s+1)` formulation used in the
project's `weightContribConvolution`.
-/
theorem coeff_finset_prod_eq_sum_fin {k : ℕ} {R : Type*} [CommSemiring R]
    (f : Fin k → PowerSeries R) (s : ℕ) :
    PowerSeries.coeff s (∏ i : Fin k, f i) =
      (Finset.univ : Finset (Fin k → Fin (s + 1))).sum fun parts =>
        if (Finset.univ.sum fun i => (parts i).val) = s then
          Finset.univ.prod fun i => PowerSeries.coeff (parts i).val (f i)
        else 0 := by
  have h_sum : (PowerSeries.coeff s (∏ i, f i)) = ∑ parts ∈ Finset.filter (fun parts : Fin k → ℕ => ∑ i, parts i = s) (Finset.Iic fun _ => s), ∏ i, (PowerSeries.coeff (parts i) (f i)) := by
    convert PowerSeries.coeff_prod using 1;
    rotate_left;
    exact R;
    exact inferInstance;
    exact Fin k;
    infer_instance;
    constructor;
    · exact fun a f d s => PowerSeries.coeff_prod f d s;
    · intro h;
      convert h f s Finset.univ using 1;
      refine' Finset.sum_bij ( fun l hl => Finsupp.equivFunOnFinite.symm l ) _ _ _ _ <;> simp +decide;
      exact fun b hb => ⟨ b, ⟨ fun i => hb ▸ Finset.single_le_sum ( fun a _ => Nat.zero_le ( b a ) ) ( Finset.mem_univ i ), hb ⟩, by simp +decide ⟩;
  rw [ h_sum, ← Finset.sum_filter ];
  refine' Finset.sum_bij ( fun parts hparts => fun i => ⟨ parts i, _ ⟩ ) _ _ _ _ <;> simp_all +decide;
  exacts [ hparts.1 i, fun a₁ ha₁ ha₂ a₂ ha₃ ha₄ h => funext fun i => by simpa using congr_fun h i, fun b hb => ⟨ fun i => b i, ⟨ fun i => Nat.le_of_lt_succ ( Fin.is_lt _ ), hb ⟩, funext fun i => rfl ⟩ ]
