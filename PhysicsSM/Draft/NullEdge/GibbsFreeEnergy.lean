import Mathlib

/-!
# Gibbs free-energy variational lower bound (finite, beta = 1)

Draft module (the free-energy dual of the landed max-entropy principle). For
finite energies `E` and any probability vector `p`, the negative log partition
function lower-bounds the free energy:
`-log(sum_i exp(-E_i)) <= (sum_i p_i E_i) - H(p)`, where `H(p) = sum negMulLog p`.
Equivalently `H(p) - sum p_i E_i <= log Z`; equality holds at the Gibbs
distribution `p_i = exp(-E_i)/Z`.

Route: let `g_i = exp(-E_i)/Z` with `Z = sum exp(-E_i) > 0`. Then
`sum_i p_i E_i - H(p) + log Z = sum_i p_i (E_i + log Z) + sum_i p_i log p_i
= sum_i p_i log(p_i / g_i)` (since `log g_i = -E_i - log Z`), which is the
relative entropy `D(p || g) >= 0` by Gibbs' inequality
(`Real.log_le_sub_one_of_pos` termwise, summed, using `sum p = sum g = 1`;
`p_i = 0` terms vanish). Rearrange to the stated bound. Do not use
`n a t i v e _ d e c i d e`.

## Trust status

Draft-trust by kernel: `gibbs_free_energy_lower` has no proof hole and depends
only on `[propext, Classical.choice, Quot.sound]` (no compiled-evaluator trust),
pinned by the `#print axioms` guard block at the end.

## Provenance

Statement authored in-project (AFPL run 2026-07-12). Proof search by Aristotle
(project `07f05e60-94a3-486e-8e3b-e39fabdd659f`), independently re-checked
(`lake env lean`; axiom footprint kernel-only). Route: relative entropy
`D(p||g) >= 0` for the Gibbs `g_i = exp(-E_i)/Z` rearranged. Clean-room
formalization.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GibbsFreeEnergy

open scoped BigOperators

variable {k : Type*} [Fintype k] [Nonempty k]

/-
**TARGET: Gibbs free-energy variational lower bound (beta = 1).**
-/
theorem gibbs_free_energy_lower (E : k → ℝ) (p : k → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hps : ∑ i, p i = 1) :
    -Real.log (∑ i, Real.exp (-(E i)))
      ≤ (∑ i, p i * E i) - (∑ i, Real.negMulLog (p i)) := by
  -- Let $Z = \sum_{i} \exp(-E_i)$.
  set Z : ℝ := ∑ i, Real.exp (-E i) with hZ_def
  have hZ_pos : 0 < Z := by
    exact Finset.sum_pos ( fun _ _ => Real.exp_pos _ ) Finset.univ_nonempty;
  -- Using the fact that $\log(g_i) = -E_i - \log(Z)$, we can rewrite the sum as:
  have h_rewrite : ∑ i, (p i) * (E i) + ∑ i, (p i) * Real.log (p i) + Real.log Z ≥ 0 := by
    -- Applying the inequality $\log(x) \leq x - 1$ to each term in the sum, we get:
    have h_ineq : ∀ i, (p i) * (E i + Real.log (p i) + Real.log Z) ≥ (p i) - (Real.exp (-E i)) / Z := by
      intro i
      by_cases hpi : p i = 0;
      · simp [hpi];
        positivity;
      · have := Real.log_le_sub_one_of_pos ( show 0 < ( Real.exp ( -E i ) / Z ) / p i from div_pos ( div_pos ( Real.exp_pos _ ) hZ_pos ) ( lt_of_le_of_ne ( hp i ) ( Ne.symm hpi ) ) );
        rw [ Real.log_div ( by positivity ) ( by positivity ), Real.log_div ( by positivity ) ( by positivity ), Real.log_exp ] at this ; nlinarith [ hp i, mul_div_cancel₀ ( Real.exp ( -E i ) / Z ) hpi ];
    have := Finset.univ.sum_le_sum fun i _ => h_ineq i; simp_all +decide [ mul_add, Finset.sum_add_distrib, ← Finset.sum_div _ _ _ ] ;
    simp_all +decide [ ← Finset.sum_mul _ _ _, ne_of_gt ];
  simp_all +decide [ Real.negMulLog ];
  linarith

end PhysicsSM.Draft.NullEdge.GibbsFreeEnergy

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only.
/--
info: 'PhysicsSM.Draft.NullEdge.GibbsFreeEnergy.gibbs_free_energy_lower' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GibbsFreeEnergy.gibbs_free_energy_lower
