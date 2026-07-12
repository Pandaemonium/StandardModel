/-
Provenance: harvested from Aristotle job
`9be8f014-9b7a-4713-9f22-de1166cf9aae` (`lambda-fermionic-fork`, 2026-07-12).
Reviewed before integration: all statements BYTE-IDENTICAL to the submitted target
(the only addition is the helper `regionA_card`); the crux `bondProj_numberVariance`
proves Var = k/4 EXACTLY, `bondProj_isProjection` proves K^2 = K (genuine Fermi-sea
kernel), `fork_subextensive` gives region k^2 with Var k/4 (alpha = 1/2). No
`sorry`/`native_decide` in any proof. Only edit from the returned file is this note.
-/
/-
# T1 -- Resolving the everpresent-Lambda fork on the framework's own fermionic states

Standalone Aristotle target. Imports ONLY Mathlib.

## Why this is the paper-maker

The null-edge cosmological-constant manuscript (Section 5) pre-registers a fork:
does the framework's own count have EXTENSIVE variance (`Var(N) ~ N`, Poisson,
everpresent Lambda survives at `1/sqrt V`) or SUB-EXTENSIVE variance
(`Var(N) = o(N)`, hyperuniform, everpresent identification is killed)?  The
landed `LambdaCountDichotomy` only shows both branches are POSSIBLE on generic
witnesses.  The framework's counted objects are FERMIONIC, and for any
free-fermion / Gaussian (CAR) state with (real, here) correlation matrix `K`
(a valid kernel has `0 <= K <= 1`), the regional number variance is one finite
line of Wick's theorem:

    Var(N_A) = tr(K_A) - tr(K_A^2)                              (`numberVariance`)

where `K_A` is the `A x A` submatrix.  This makes BOTH branches COMPUTABLE now:

* THERMAL / diagonal kernel `K = diag p`:  `Var(N_A) = sum_{i in A} p_i (1 - p_i)`
  -- the extensive branch (this is exactly the diagonal special case of the
  program's landed `LambdaSusceptibility.var_count`).  Everpresent survives.

* KINEMATIC / projection kernel `K^2 = K` (a Fermi-sea correlation matrix): the
  variance counts only boundary-crossing modes, and can be made SUB-EXTENSIVE
  and NON-DEGENERATE.  Everpresent is killed.

The explicit projection witness below (`bondProj`) is a genuine kernel
(`K^2 = K`, real symmetric, so `0 <= K <= 1`): `b` fully-occupied bulk sites plus
`k` boundary bonds, each bond crossing the region boundary.  Its number variance
is `k/4`, INDEPENDENT of the bulk `b`.  Choosing `b` grows the region without
growing the variance:

* `b = 0`         => region size `k`,   `Var = k/4 = |A|/4`      (EXTENSIVE, alpha=1)
* `b = k^2 - k`   => region size `k^2`, `Var = k/4 = sqrt|A|/4`  (SUB-EXTENSIVE,
                                                                  alpha = 1/2,
                                                                  and Var -> infinity)

So a single projection family realizes a genuinely sub-extensive, unbounded number
variance -- the non-degenerate hyperuniform witness the manuscript's kill branch
needs -- and the fork is resolved into a DICHOTOMY: everpresent Lambda survives iff
the Lambda-conjugate count is the thermal/diagonal count rather than the
kinematic/projection (vacuum-weighted) count.

## Targets (replace the `sorry`s)

1. `numberVariance_diagonal` -- the thermal/extensive form (ties to `var_count`).
2. `bondProj_symm`, `bondProj_isProjection` -- the witness is a genuine Fermi kernel.
3. `bondProj_numberVariance` -- `Var = k/4` (the crux computation).
4. `fork_extensive`, `fork_subextensive` -- the two branches as corollaries.
5. `fermionic_fork_verdict` -- the dichotomy statement.

Do NOT weaken any statement. NO `sorry`/`admit`/`axiom`/`native_decide` in the final
proof; kernel footprint `[propext, Classical.choice, Quot.sound]`.

## Proof notes

`numberVariance K A = (sum_{i in A} K i i) - sum_{i in A} sum_{j in A} (K i j)^2`
equals `tr K_A - tr K_A^2` for symmetric `K` (since `(K_A^2)_{ii} = sum_j K_ij K_ji
= sum_j (K_ij)^2`).  For `bondProj`, within `A x A` the matrix is DIAGONAL (each
boundary bond's off-diagonal entry connects an in-`A` site to an out-of-`A`
partner), so `sum_{A,A}(K_ij)^2 = sum_{i in A}(K_ii)^2`, giving
`Var = sum_{i in A} K_ii(1 - K_ii) = b*(1-1) + k*(1/2)(1/2) = k/4`.
For `bondProj_isProjection`, `bondProj` is a sum of rank-1 projectors on disjoint
supports (single sites `< b`, and 2-site bonds `{b+t, b+k+t}`), hence idempotent.
-/
import Mathlib

open scoped BigOperators
open Finset Matrix

namespace LambdaFermionicFork

variable {n : ℕ}

/-- Regional number variance of a free-fermion / Gaussian state with real symmetric
correlation matrix `K` on `Fin n`, over the region `A`.  Wick's theorem:
`Var(N_A) = tr K_A - tr K_A^2`, here in entrywise form (valid for symmetric `K`). -/
noncomputable def numberVariance (K : Matrix (Fin n) (Fin n) ℝ) (A : Finset (Fin n)) : ℝ :=
  (∑ i ∈ A, K i i) - ∑ i ∈ A, ∑ j ∈ A, (K i j) ^ 2

/-
**Thermal / diagonal branch.**  A diagonal correlation kernel `K = diag p`
(independent occupancies `p_i`) has number variance `sum_{i in A} p_i (1 - p_i)` --
the extensive branch, and exactly the diagonal special case of the program's landed
`LambdaSusceptibility.var_count`.
-/
theorem numberVariance_diagonal (p : Fin n → ℝ) (A : Finset (Fin n)) :
    numberVariance (Matrix.diagonal p) A = ∑ i ∈ A, p i * (1 - p i) := by
  unfold numberVariance;
  simp +decide [ diagonal, pow_two, mul_sub ]

/-! ## The kinematic (projection) witness -/

/-- The boundary-bond correlation kernel on `Fin (b + 2*k)`: `b` fully-occupied
bulk sites (diagonal `1`), and `k` boundary bonds, bond `t` connecting site `b+t`
(in the region) to site `b+k+t` (outside), each a `[[1/2,1/2],[1/2,1/2]]` block. -/
noncomputable def bondProj (b k : ℕ) : Matrix (Fin (b + 2 * k)) (Fin (b + 2 * k)) ℝ := fun i j =>
  if i = j then (if (i : ℕ) < b then 1 else 1 / 2)
  else if ((b ≤ (i : ℕ) ∧ (i : ℕ) < b + k ∧ (j : ℕ) = (i : ℕ) + k) ∨
           (b ≤ (j : ℕ) ∧ (j : ℕ) < b + k ∧ (i : ℕ) = (j : ℕ) + k)) then 1 / 2
  else 0

/-- The region: bulk plus the boundary sites (the first `b + k` sites). -/
def regionA (b k : ℕ) : Finset (Fin (b + 2 * k)) :=
  Finset.univ.filter (fun i => (i : ℕ) < b + k)

/-
The region has `b + k` sites (the first `b + k` of the `b + 2*k` total).
-/
theorem regionA_card (b k : ℕ) : (regionA b k).card = b + k := by
  convert Finset.card_range ( b + k ) using 1;
  refine' Finset.card_bij ( fun x hx => x ) _ _ _ <;> simp +decide;
  · exact fun x hx => Finset.mem_filter.mp hx |>.2;
  · exact fun a₁ ha₁ a₂ ha₂ h => Fin.ext h;
  · exact fun x hx => ⟨ ⟨ x, by linarith ⟩, Finset.mem_filter.mpr ⟨ Finset.mem_univ _, hx ⟩, rfl ⟩

/-
The bond kernel is symmetric.
-/
theorem bondProj_symm (b k : ℕ) : (bondProj b k).IsSymm := by
  ext i j; unfold bondProj; norm_num; split_ifs <;> try linarith;
  all_goals aesop;

/-
The bond kernel is a genuine projection (`K^2 = K`), hence a valid fermionic
correlation kernel with spectrum in `{0,1} ⊆ [0,1]`.
-/
set_option maxHeartbeats 1600000 in
theorem bondProj_isProjection (b k : ℕ) :
    (bondProj b k) * (bondProj b k) = bondProj b k := by
  ext i j;
  by_cases hi : ( i : ℕ ) < b <;> by_cases hj : ( j : ℕ ) < b <;> simp +decide [ *, Finset.sum_ite, Finset.filter_ne', Finset.filter_eq', bondProj ];
  · rw [ Matrix.mul_apply ];
    rw [ Finset.sum_eq_single i ] <;> simp +decide [ *, bondProj ];
    grind;
  · rw [ Matrix.mul_apply ];
    rw [ Finset.sum_eq_single i ] <;> simp_all +decide [ bondProj ]; all_goals grind;
  · unfold bondProj; simp +decide [ *, Matrix.mul_apply ] ;
    rw [ Finset.sum_eq_single j ] <;> norm_num; all_goals grind;
  · by_cases hi' : ( i : ℕ ) < b + k <;> by_cases hj' : ( j : ℕ ) < b + k <;> simp +decide [ *, Finset.sum_ite, Finset.filter_ne', Finset.filter_eq', bondProj ];
    · unfold bondProj; simp +decide [ *, Finset.sum_ite, Finset.filter_ne', Finset.filter_eq', Finset.sum_add_distrib, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Matrix.mul_apply ] ;
      split_ifs <;> simp_all +decide [ Finset.filter_eq', Finset.filter_ne' ];
      · simp_all +decide [ Finset.filter_eq, Finset.filter_ne ];
        split_ifs <;> simp_all +decide [ Finset.filter_singleton, Finset.filter_erase ];
        · linarith;
        · rw [ if_neg ( by linarith ) ] ; norm_num;
          rw [ Finset.card_eq_one.mpr ] ; norm_num;
          use ⟨ j + k, by linarith ⟩ ; ext x; simp +decide [ Fin.ext_iff ] ;
          grind;
      · omega;
      · simp_all +decide [ Finset.filter_singleton, Finset.filter_erase, Finset.filter_or, Finset.filter_and ];
        split_ifs <;> simp_all +decide [ Finset.filter_eq, Finset.filter_ne ]; all_goals grind;
    · rw [ Matrix.mul_apply ];
      rw [ Finset.sum_eq_add ( i ) ( ⟨ i + k, by linarith ⟩ : Fin ( b + 2 * k ) ) ] <;> norm_num [ bondProj ];
      · grind;
      · exact ne_of_lt ( Nat.lt_add_of_pos_right ( by linarith [ Fin.is_lt i ] ) );
      · grind;
    · rw [ Matrix.mul_apply ];
      rw [ Finset.sum_eq_add ( ⟨ j, by linarith [ Fin.is_lt j ] ⟩ : Fin ( b + 2 * k ) ) ( ⟨ j + k, by linarith [ Fin.is_lt j ] ⟩ : Fin ( b + 2 * k ) ) ] <;> norm_num [ bondProj ]; all_goals grind;
    · unfold bondProj; simp +decide [ *, Finset.sum_ite, Finset.filter_ne', Finset.filter_eq', Matrix.mul_apply ] ;
      split_ifs <;> simp_all +decide [ Finset.filter_singleton, Finset.filter_erase ];
      · split_ifs <;> simp_all +decide [ Finset.filter_eq, Finset.filter_ne ];
        · linarith;
        · split_ifs <;> norm_num at *;
          · linarith;
          · rw [ Finset.card_eq_one.mpr ] ; norm_num;
            use ⟨ j - k, by omega ⟩ ; ext ; simp +decide [ Fin.ext_iff ] ; omega;
      · split_ifs <;> simp_all +decide [ Finset.filter_eq', Finset.filter_ne' ];
        · grobner;
        · grind;
        · grind +splitIndPred;
        · rw [ Finset.card_eq_zero.mpr, Finset.card_eq_zero.mpr ] <;> norm_num;
          · intros; omega;
          · grind

/-
**The crux computation.**  The number variance of the boundary-bond projection
kernel is `k/4`, INDEPENDENT of the bulk size `b`.
-/
theorem bondProj_numberVariance (b k : ℕ) :
    numberVariance (bondProj b k) (regionA b k) = (k : ℝ) / 4 := by
  -- First, we show that the diagonal entries of `bondProj b k` are `1` if the index is in the bulk, and `1/2` if the index is on the boundary.
  have h_diag : ∀ i : Fin (b + 2 * k), (bondProj b k) i i = if (i : ℕ) < b then 1 else 1 / 2 := by
    unfold bondProj; aesop;
  -- Next, we show that the off-diagonal entries of `bondProj b k` are `0` for indices in `regionA b k`.
  have h_off_diag : ∀ i j : Fin (b + 2 * k), i ∈ regionA b k → j ∈ regionA b k → i ≠ j → (bondProj b k) i j = 0 := by
    grind +locals;
  -- Using the results about the diagonal and off-diagonal entries, we can simplify the expression for the number variance.
  have h_simplified : numberVariance (bondProj b k) (regionA b k) = ∑ i ∈ regionA b k, ((bondProj b k) i i) * (1 - (bondProj b k) i i) := by
    unfold numberVariance;
    rw [ ← Finset.sum_sub_distrib ] ; refine' Finset.sum_congr rfl fun i hi => _ ; rw [ Finset.sum_eq_single i ] <;> norm_num ; ring;
    · exact fun j hj hij => h_off_diag i j hi hj ( Ne.symm hij );
    · tauto;
  -- Now let's evaluate the sum $\sum_{i \in \text{regionA } b k} (bondProj b k) i i * (1 - (bondProj b k) i i)$.
  have h_sum : ∑ i ∈ regionA b k, ((bondProj b k) i i) * (1 - (bondProj b k) i i) = ∑ i ∈ Finset.range (b + k), (if i < b then 0 else 1 / 4 : ℝ) := by
    refine' Finset.sum_bij ( fun i hi => i ) _ _ _ _ <;> norm_num [ h_diag ];
    · exact fun i hi => Finset.mem_filter.mp hi |>.2;
    · exact fun i hi j hj hij => Fin.ext hij;
    · exact fun i hi => ⟨ ⟨ i, by linarith ⟩, Finset.mem_filter.mpr ⟨ Finset.mem_univ _, hi ⟩, rfl ⟩;
    · intro i hi; split_ifs <;> norm_num;
  simp_all +decide [ Finset.sum_range_add ];
  rw [ Finset.sum_congr rfl fun x hx => if_pos <| Finset.mem_range.mp hx ] ; norm_num ; ring

/-! ## The fork, resolved -/

/-
**Extensive instance.**  With no bulk (`b = 0`), the region has size `k` and the
variance is `|A|/4`: extensive (`alpha = 1`).  Everpresent Lambda survives.
-/
theorem fork_extensive (k : ℕ) :
    (regionA 0 k).card = k ∧ numberVariance (bondProj 0 k) (regionA 0 k) = (k : ℝ) / 4 := by
  refine' ⟨ _, _ ⟩;
  · convert regionA_card 0 k using 1 ; norm_num;
  · convert bondProj_numberVariance 0 k using 1

/-
**Sub-extensive instance.**  With bulk `b = k^2 - k` (for `k ≥ 1`), the region has
size `k^2` while the variance is still `k/4 = sqrt(|A|)/4`: SUB-EXTENSIVE
(`alpha = 1/2`) and UNBOUNDED as `k → ∞`.  This is the non-degenerate hyperuniform
witness; the everpresent identification is killed for this kinematic count.
-/
theorem fork_subextensive (k : ℕ) (hk : 1 ≤ k) :
    (regionA (k * k - k) k).card = k * k ∧
    numberVariance (bondProj (k * k - k) k) (regionA (k * k - k) k) = (k : ℝ) / 4 := by
  constructor;
  · rw [ regionA_card, Nat.sub_add_cancel ( by nlinarith ) ];
  · convert bondProj_numberVariance ( k * k - k ) k using 1

/-
**The dichotomy.**  A single fermionic-variance identity drives both branches:
the extensive family (`b = 0`) has variance equal to a fixed fraction of the region
size, while the projection family with `b = k^2 - k` has variance `sqrt(|A|)/4`,
which is `o(|A|)` yet unbounded.  Everpresent Lambda survives on the extensive
(thermal) count and is killed on the sub-extensive (kinematic/projection) count --
so the fork reduces to the pre-registered question of which count is Lambda-conjugate.
-/
theorem fermionic_fork_verdict :
    -- extensive branch: variance is a fixed positive fraction of region size
    (∀ k : ℕ, 1 ≤ k →
      numberVariance (bondProj 0 k) (regionA 0 k)
        = ((regionA 0 k).card : ℝ) / 4) ∧
    -- sub-extensive branch: variance / region size -> 0, yet variance -> infinity
    (∀ k : ℕ, 1 ≤ k →
      numberVariance (bondProj (k * k - k) k) (regionA (k * k - k) k) * 4
        = (k : ℝ)
      ∧ (regionA (k * k - k) k).card = k * k) := by
  grind +suggestions

end LambdaFermionicFork
