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

/-- **Thermal / diagonal branch.**  A diagonal correlation kernel `K = diag p`
(independent occupancies `p_i`) has number variance `sum_{i in A} p_i (1 - p_i)` --
the extensive branch, and exactly the diagonal special case of the program's landed
`LambdaSusceptibility.var_count`. -/
theorem numberVariance_diagonal (p : Fin n → ℝ) (A : Finset (Fin n)) :
    numberVariance (Matrix.diagonal p) A = ∑ i ∈ A, p i * (1 - p i) := by
  sorry

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

/-- The bond kernel is symmetric. -/
theorem bondProj_symm (b k : ℕ) : (bondProj b k).IsSymm := by
  sorry

/-- The bond kernel is a genuine projection (`K^2 = K`), hence a valid fermionic
correlation kernel with spectrum in `{0,1} ⊆ [0,1]`. -/
theorem bondProj_isProjection (b k : ℕ) :
    (bondProj b k) * (bondProj b k) = bondProj b k := by
  sorry

/-- **The crux computation.**  The number variance of the boundary-bond projection
kernel is `k/4`, INDEPENDENT of the bulk size `b`. -/
theorem bondProj_numberVariance (b k : ℕ) :
    numberVariance (bondProj b k) (regionA b k) = (k : ℝ) / 4 := by
  sorry

/-! ## The fork, resolved -/

/-- **Extensive instance.**  With no bulk (`b = 0`), the region has size `k` and the
variance is `|A|/4`: extensive (`alpha = 1`).  Everpresent Lambda survives. -/
theorem fork_extensive (k : ℕ) :
    (regionA 0 k).card = k ∧ numberVariance (bondProj 0 k) (regionA 0 k) = (k : ℝ) / 4 := by
  sorry

/-- **Sub-extensive instance.**  With bulk `b = k^2 - k` (for `k ≥ 1`), the region has
size `k^2` while the variance is still `k/4 = sqrt(|A|)/4`: SUB-EXTENSIVE
(`alpha = 1/2`) and UNBOUNDED as `k → ∞`.  This is the non-degenerate hyperuniform
witness; the everpresent identification is killed for this kinematic count. -/
theorem fork_subextensive (k : ℕ) (hk : 1 ≤ k) :
    (regionA (k * k - k) k).card = k * k ∧
    numberVariance (bondProj (k * k - k) k) (regionA (k * k - k) k) = (k : ℝ) / 4 := by
  sorry

/-- **The dichotomy.**  A single fermionic-variance identity drives both branches:
the extensive family (`b = 0`) has variance equal to a fixed fraction of the region
size, while the projection family with `b = k^2 - k` has variance `sqrt(|A|)/4`,
which is `o(|A|)` yet unbounded.  Everpresent Lambda survives on the extensive
(thermal) count and is killed on the sub-extensive (kinematic/projection) count --
so the fork reduces to the pre-registered question of which count is Lambda-conjugate. -/
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
  sorry

end LambdaFermionicFork
