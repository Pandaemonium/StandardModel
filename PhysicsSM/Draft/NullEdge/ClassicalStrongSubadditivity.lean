import Mathlib

/-!
# Classical strong subadditivity of Shannon entropy

Draft module. The classical strong subadditivity `H(XZ) + H(YZ) >= H(XYZ) + H(Z)`
for a finite joint distribution -- equivalently, conditional mutual information
`I(X:Y|Z) >= 0`. SSA is the deep entropy inequality behind holographic entropy
bounds, monotonicity of relative entropy, and the NERD gravity/DPI program
(Q1/Q2); the finite classical case is the tractable gate and the deepest of the
classical information-toolkit landings.

## Statement

For a joint probability vector `p : X x Y x Z -> R` (nonnegative, summing to one),
with Shannon entropy `H(r) = sum negMulLog (r .)` of a marginal:
`shannonEntropy (margXZ p) + shannonEntropy (margYZ p)
   >= shannonEntropy p + shannonEntropy (margZ p)`.

## Trust status

Draft-trust by kernel: `shannon_ssa` is `sorry`-free and depends only on
`[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard block at the end.

## Provenance

Statement authored in-project (AFPL run 2026-07-12). Proof search by Aristotle
(project `f52514f3-ef05-4365-bab9-effafa551ebd`), then independently re-checked in
this repo (`lake env lean`; axiom footprint confirmed kernel-only). Route:
`I(X:Y|Z)` is the relative entropy between `p(x,y,z)` and the Markov
reconstruction `margXZ(x,z) margYZ(y,z) / margZ(z)` (both normalized to one, via
the `recon_sum_one` helper), which is nonnegative by the log-sum / Gibbs
inequality. Clean-room formalization from the mathematical statement, not copied
from external code.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ClassicalSSA

open scoped BigOperators

variable {X Y Z : Type*} [Fintype X] [Fintype Y] [Fintype Z]

/-- Shannon entropy of a finite distribution `r`, `∑ i, negMulLog (r i)`. -/
def shannonEntropy {ι : Type*} [Fintype ι] (r : ι → ℝ) : ℝ :=
  ∑ i, Real.negMulLog (r i)

/-- `XZ` marginal of a joint `X × Y × Z` distribution. -/
def margXZ (p : X × Y × Z → ℝ) : X × Z → ℝ :=
  fun xz => ∑ y : Y, p (xz.1, y, xz.2)

/-- `YZ` marginal. -/
def margYZ (p : X × Y × Z → ℝ) : Y × Z → ℝ :=
  fun yz => ∑ x : X, p (x, yz.1, yz.2)

/-- `Z` marginal. -/
def margZ (p : X × Y × Z → ℝ) : Z → ℝ :=
  fun z => ∑ x : X, ∑ y : Y, p (x, y, z)

omit [Fintype X] [Fintype Z] in
/-- Marginals are nonnegative. -/
lemma margXZ_nonneg (p : X × Y × Z → ℝ) (hp : ∀ t, 0 ≤ p t) (xz : X × Z) :
    0 ≤ margXZ p xz := by
      exact Finset.sum_nonneg fun _ _ => hp _

omit [Fintype Y] [Fintype Z] in
lemma margYZ_nonneg (p : X × Y × Z → ℝ) (hp : ∀ t, 0 ≤ p t) (yz : Y × Z) :
    0 ≤ margYZ p yz := by
      exact Finset.sum_nonneg fun _ _ => hp _

omit [Fintype Z] in
lemma margZ_nonneg (p : X × Y × Z → ℝ) (hp : ∀ t, 0 ≤ p t) (z : Z) :
    0 ≤ margZ p z := by
      exact Finset.sum_nonneg fun x _ => Finset.sum_nonneg fun y _ => hp _

omit [Fintype X] [Fintype Z] in
/-- Each entry is bounded by its `XZ` marginal. -/
lemma le_margXZ (p : X × Y × Z → ℝ) (hp : ∀ t, 0 ≤ p t) (t : X × Y × Z) :
    p t ≤ margXZ p (t.1, t.2.2) := by
      exact Finset.single_le_sum ( fun y _ => hp ( t.1, y, t.2.2 ) ) ( Finset.mem_univ t.2.1 )

omit [Fintype Y] [Fintype Z] in
lemma le_margYZ (p : X × Y × Z → ℝ) (hp : ∀ t, 0 ≤ p t) (t : X × Y × Z) :
    p t ≤ margYZ p (t.2.1, t.2.2) := by
      exact Finset.single_le_sum ( fun x _ => hp ( x, t.2.1, t.2.2 ) ) ( Finset.mem_univ t.1 )

omit [Fintype Z] in
lemma le_margZ (p : X × Y × Z → ℝ) (hp : ∀ t, 0 ≤ p t) (t : X × Y × Z) :
    p t ≤ margZ p t.2.2 := by
      exact Finset.single_le_sum ( fun x _ => Finset.sum_nonneg fun y _ => hp ( x, y, t.2.2 ) ) ( Finset.mem_univ t.1 ) |> le_trans ( Finset.single_le_sum ( fun y _ => hp ( t.1, y, t.2.2 ) ) ( Finset.mem_univ t.2.1 ) )

/-
Entropy of `p`, written as a sum over the full space.
-/
lemma entropy_p_expand (p : X × Y × Z → ℝ) :
    shannonEntropy p = ∑ t : X × Y × Z, (- p t * Real.log (p t)) := by
      rfl

/-
Entropy of the `XZ` marginal, written as a sum over the full space using
`margXZ p (x,z) = ∑_y p (x,y,z)`.
-/
lemma entropy_margXZ_expand (p : X × Y × Z → ℝ) :
    shannonEntropy (margXZ p)
      = ∑ t : X × Y × Z, (- p t * Real.log (margXZ p (t.1, t.2.2))) := by
        unfold shannonEntropy;
        unfold Real.negMulLog;
        simp +decide [ margXZ, Fintype.sum_prod_type ];
        simp +decide only [Finset.sum_mul _ _ _];
        exact Finset.sum_congr rfl fun _ _ => Finset.sum_comm

lemma entropy_margYZ_expand (p : X × Y × Z → ℝ) :
    shannonEntropy (margYZ p)
      = ∑ t : X × Y × Z, (- p t * Real.log (margYZ p (t.2.1, t.2.2))) := by
        unfold shannonEntropy margYZ;
        erw [ Finset.sum_product ];
        simp +decide [ Real.negMulLog, Finset.sum_mul ];
        rw [ Finset.sum_comm ];
        simp +decide only [← Finset.sum_product'];
        refine' Finset.sum_bij ( fun x _ => ( x.2.2, x.2.1, x.1 ) ) _ _ _ _ <;> aesop

lemma entropy_margZ_expand (p : X × Y × Z → ℝ) :
    shannonEntropy (margZ p)
      = ∑ t : X × Y × Z, (- p t * Real.log (margZ p t.2.2)) := by
        unfold shannonEntropy margZ;
        simp +decide [ Real.negMulLog, Finset.sum_mul _ _ _ ];
        simp +decide only [← Finset.sum_product'];
        refine' Finset.sum_bij ( fun x _ => ( x.2.1, x.2.2, x.1 ) ) _ _ _ _ <;> simp +decide

/-- The Markov reconstruction `margXZ * margYZ / margZ` sums to one. -/
lemma recon_sum_one (p : X × Y × Z → ℝ) (hps : ∑ t, p t = 1) :
    ∑ t : X × Y × Z,
        margXZ p (t.1, t.2.2) * margYZ p (t.2.1, t.2.2) / margZ p t.2.2 = 1 := by
          -- For each fixed $z$, the inner sum $\sum_{x,y} \text{margXZ}(p)(x,z) \cdot \text{margYZ}(p)(y,z) / \text{margZ}(p)(z)$ is equal to $\text{margZ}(p)(z)$.
          have h_inner_sum : ∀ z, ∑ x : X, ∑ y : Y, margXZ p (x, z) * margYZ p (y, z) / margZ p z = margZ p z := by
            intro z
            have h_inner_sum_eq : ∑ x : X, margXZ p (x, z) = margZ p z ∧ ∑ y : Y, margYZ p (y, z) = margZ p z := by
              simp +decide only [margXZ, margZ, margYZ];
              exact ⟨ trivial, Finset.sum_comm ⟩;
            by_cases h : margZ p z = 0 <;> simp_all +decide [ ← Finset.mul_sum _ _ _, ← Finset.sum_div ];
          convert Finset.sum_congr rfl fun z _ => h_inner_sum z using 1;
          any_goals exact Finset.univ;
          · simp +decide only [Finset.sum_sigma'];
            refine' Finset.sum_bij ( fun t _ => ⟨ t.2.2, t.1, t.2.1 ⟩ ) _ _ _ _ <;> simp +decide;
          · simp +decide only [margZ];
            rw [ ← hps, ← Finset.sum_product' ];
            rw [ ← Finset.sum_product' ];
            refine' Finset.sum_bij ( fun t _ => ( ( t.2.2, t.1 ), t.2.1 ) ) _ _ _ _ <;> simp +decide

omit [Fintype Z] in
/-- Termwise Gibbs inequality: the summand of `I(X:Y|Z)` dominates
`p - (reconstruction)`. -/
lemma term_ineq (p : X × Y × Z → ℝ) (hp : ∀ t, 0 ≤ p t) (t : X × Y × Z) :
    p t - margXZ p (t.1, t.2.2) * margYZ p (t.2.1, t.2.2) / margZ p t.2.2
      ≤ (- p t * Real.log (margXZ p (t.1, t.2.2)))
        + (- p t * Real.log (margYZ p (t.2.1, t.2.2)))
        - (- p t * Real.log (p t)) - (- p t * Real.log (margZ p t.2.2)) := by
          by_cases h : p t = 0;
          · simp +decide [ h, margXZ, margYZ, margZ ];
            exact div_nonneg ( mul_nonneg ( Finset.sum_nonneg fun _ _ => hp _ ) ( Finset.sum_nonneg fun _ _ => hp _ ) ) ( Finset.sum_nonneg fun _ _ => Finset.sum_nonneg fun _ _ => hp _ );
          · have h_log : Real.log (margXZ p (t.1, t.2.2)) + Real.log (margYZ p (t.2.1, t.2.2)) - Real.log (p t) - Real.log (margZ p t.2.2) ≤ margXZ p (t.1, t.2.2) * margYZ p (t.2.1, t.2.2) / (p t * margZ p t.2.2) - 1 := by
              have h_log : Real.log (margXZ p (t.1, t.2.2) * margYZ p (t.2.1, t.2.2) / (p t * margZ p t.2.2)) ≤ margXZ p (t.1, t.2.2) * margYZ p (t.2.1, t.2.2) / (p t * margZ p t.2.2) - 1 := by
                apply Real.log_le_sub_one_of_pos;
                refine' div_pos ( mul_pos _ _ ) ( mul_pos ( lt_of_le_of_ne ( hp t ) ( Ne.symm h ) ) _ );
                · exact lt_of_lt_of_le ( lt_of_le_of_ne ( hp t ) ( Ne.symm h ) ) ( le_margXZ p hp t );
                · exact lt_of_lt_of_le ( lt_of_le_of_ne ( hp t ) ( Ne.symm h ) ) ( le_margYZ p hp t );
                · exact lt_of_lt_of_le ( lt_of_le_of_ne ( hp t ) ( Ne.symm h ) ) ( le_margZ p hp t );
              by_cases h' : margXZ p ( t.1, t.2.2 ) = 0 <;> by_cases h'' : margYZ p ( t.2.1, t.2.2 ) = 0 <;> by_cases h''' : p t = 0 <;> by_cases h'''' : margZ p t.2.2 = 0 <;> simp_all +decide [ Real.log_div, Real.log_mul ];
              all_goals linarith;
            by_cases h' : margZ p t.2.2 = 0 <;> simp_all +decide [ div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm ];
            · nlinarith [ hp t.1 t.2.1 t.2.2 ];
            · nlinarith [ hp t.1 t.2.1 t.2.2, mul_inv_cancel_left₀ h ( margYZ p t.2 * ( ( margZ p t.2.2 ) ⁻¹ * margXZ p ( t.1, t.2.2 ) ) ) ]

/-- **TARGET (the hole): classical strong subadditivity.**  For a finite joint
distribution, `H(XZ) + H(YZ) ≥ H(XYZ) + H(Z)`. -/
theorem shannon_ssa (p : X × Y × Z → ℝ)
    (hp : ∀ t, 0 ≤ p t) (hps : ∑ t, p t = 1) :
    shannonEntropy p + shannonEntropy (margZ p)
      ≤ shannonEntropy (margXZ p) + shannonEntropy (margYZ p) := by
  rw [entropy_p_expand, entropy_margZ_expand, entropy_margXZ_expand, entropy_margYZ_expand]
  -- Reduce to `0 ≤ RHS - LHS = ∑ (termRHS)`.
  have hkey : ∑ t : X × Y × Z,
      (p t - margXZ p (t.1, t.2.2) * margYZ p (t.2.1, t.2.2) / margZ p t.2.2)
    ≤ ∑ t : X × Y × Z,
        ((- p t * Real.log (margXZ p (t.1, t.2.2)))
          + (- p t * Real.log (margYZ p (t.2.1, t.2.2)))
          - (- p t * Real.log (p t)) - (- p t * Real.log (margZ p t.2.2))) := by
    apply Finset.sum_le_sum
    intro t _
    exact term_ineq p hp t
  have hlhs : ∑ t : X × Y × Z,
      (p t - margXZ p (t.1, t.2.2) * margYZ p (t.2.1, t.2.2) / margZ p t.2.2) = 0 := by
    rw [Finset.sum_sub_distrib, hps, recon_sum_one p hps, sub_self]
  rw [hlhs] at hkey
  rw [Finset.sum_sub_distrib, Finset.sum_sub_distrib, Finset.sum_add_distrib] at hkey
  linarith [hkey]

end PhysicsSM.Draft.NullEdge.ClassicalSSA

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only, no
-- `native_decide` / `Lean.ofReduceBool`.
/--
info: 'PhysicsSM.Draft.NullEdge.ClassicalSSA.shannon_ssa' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ClassicalSSA.shannon_ssa
