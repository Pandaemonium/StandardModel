import Mathlib

/-!
# Finite transfer positivity and gap decay (Opus, verified e8f3f87b)

The POSITIVITY/GAP half of the A3 composite-mass bridge, deliberately kept UNPAIRED
from any gauge observable. Contents: `gram_posDef` (a real Gram matrix A^T A is
positive definite when A.mulVec is injective) and `posDef_of_eq_gram`; normalized
finite spectral moments with their top-state correction; and `spectralGap_decay`
giving the exact decomposition, the explicit bound |correction k| <= (sum of
non-top weights)(lam1/lam0)^k, and convergence of the normalized moment to the
top-state weight - with hypotheses that SEPARATE eigenvalue positivity from the
strict nondegenerate top-gap assumption.

TWO NEGATIVE RESULTS that stop the usual A3 shortcut:
* `arbitrarily_small_gap` - diag(1+eps, 1) for every eps > 0: positive definiteness
  supplies NO uniform positive gap. The gap is an INDEPENDENT input.
* `same_gap_different_eigenvectors` - diag(2,1) and diag(1,2): equal unit gap,
  different top eigenvectors, explicitly unequal rank-one spectral projectors. The
  gap alone does NOT fix the projector.

No gauge observable and no observable-pairing claim appears here, by design. See
`SU3PlaquetteObservable` for the observable half and the linkage job for the step
that actually connects them.

Namespace kept as the prover's FiniteTransfer. Provenance: verified at pin from task
f7ed5c26. Standard three. Claim grade M, [comp]. -/

open scoped BigOperators
open Filter Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option autoImplicit false

namespace FiniteTransfer

/-
A square real Gram matrix with full column rank is positive definite.
This is the abstract positivity input; it contains no assertion about an observable.
-/
theorem gram_posDef {m n : Type*} [Fintype m] [Fintype n]
    [DecidableEq n] (A : Matrix m n ℝ)
    (hA : Function.Injective A.mulVec) :
    (A.transpose * A).PosDef := by
  refine' ⟨ _, _ ⟩;
  · simp +decide [ Matrix.IsHermitian, Matrix.transpose_mul ];
  · intro x hx_ne;
    -- By definition of matrix multiplication and the properties of the dot product, we can rewrite the quadratic form.
    have h_quad_form : ∑ i, ∑ j, x i * (Aᵀ * A) i j * x j = ∑ k, (∑ i, A k i * x i) ^ 2 := by
      simp +decide only [mul_apply, transpose_apply, mul_comm, mul_left_comm, pow_two];
      simp +decide only [Finset.sum_mul _ _ _, mul_assoc, Finset.mul_sum];
      exact Eq.symm ( Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring ) ) );
    -- Since $A$ has full column rank, the only solution to $A x = 0$ is $x = 0$.
    have h_full_rank : ∀ x : n → ℝ, A.mulVec x = 0 → x = 0 := by
      exact fun x hx => hA <| by simpa using hx;
    contrapose! h_full_rank;
    refine' ⟨ x, _, _ ⟩ <;> simp_all +decide [ Finsupp.sum_fintype ];
    exact funext fun k => sq_eq_zero_iff.mp ( le_antisymm ( le_trans ( Finset.single_le_sum ( fun a _ => sq_nonneg ( ∑ i, A a i * x i ) ) ( Finset.mem_univ k ) ) h_full_rank ) ( sq_nonneg _ ) )

/-- Equality to a full-column-rank Gram form gives both symmetry and positive
definiteness of the stated transfer matrix. -/
theorem posDef_of_eq_gram {m n : Type*} [Fintype m] [Fintype n]
    [DecidableEq n] (T : Matrix n n ℝ) (A : Matrix m n ℝ)
    (hT : T = A.transpose * A) (hA : Function.Injective A.mulVec) :
    T.IsHermitian ∧ T.PosDef := by
  subst T
  exact ⟨(gram_posDef A hA).isHermitian, gram_posDef A hA⟩

/-- The normalized spectral moment attached to eigenvalues `lam` and nonnegative
spectral weights `weight`. -/
noncomputable def normalizedSpectralMoment {ι : Type*} [Fintype ι]
    (lam weight : ι → ℝ) (lam0 : ℝ) (k : ℕ) : ℝ :=
  (∑ i, weight i * lam i ^ k) / lam0 ^ k

/-- The part of a normalized spectral moment away from the distinguished top state. -/
noncomputable def spectralCorrection {ι : Type*} [Fintype ι] [DecidableEq ι]
    (lam weight : ι → ℝ) (top : ι) (lam0 : ℝ) (k : ℕ) : ℝ :=
  ∑ i ∈ Finset.univ.erase top, weight i * (lam i / lam0) ^ k

/-
Exact finite-dimensional gap statement.

`weight i` is the squared overlap of the vector with the `i`th normalized
eigenvector.  Thus the theorem applies to `⟪v,T^k v⟫ / lam0^k` after the
(real symmetric) spectral theorem identifies that expression with
`normalizedSpectralMoment lam weight lam0 k`.

The conclusion separates the top-state limit from the correction, and gives
an explicit geometric bound.  Positivity enters through `0 ≤ lam i` and
`0 < lam0`; the strict, nondegenerate top eigenvalue and the independent gap
input are expressed by `lam i ≤ lam1 < lam0` away from `top`.
-/
theorem spectralGap_decay {ι : Type*} [Fintype ι] [DecidableEq ι]
    (lam weight : ι → ℝ) (top : ι) (lam0 lam1 : ℝ)
    (hlam0 : lam top = lam0) (hlam0pos : 0 < lam0)
    (hweight : ∀ i, 0 ≤ weight i)
    (hlam_nonneg : ∀ i, 0 ≤ lam i)
    (hsecond : ∀ i, i ≠ top → lam i ≤ lam1)
    (hgap : lam1 < lam0) :
    (∀ k : ℕ,
      normalizedSpectralMoment lam weight lam0 k =
        weight top + spectralCorrection lam weight top lam0 k) ∧
    (∀ k : ℕ,
      |spectralCorrection lam weight top lam0 k| ≤
        (∑ i ∈ Finset.univ.erase top, weight i) * (lam1 / lam0) ^ k) ∧
    Tendsto (normalizedSpectralMoment lam weight lam0) atTop (nhds (weight top)) := by
  refine' ⟨ _, _, _ ⟩;
  · intro k; unfold normalizedSpectralMoment spectralCorrection; simp +decide [ hlam0, Finset.sum_div _ _ _ ] ;
    simp +decide [ div_pow, mul_div_assoc, hlam0pos.ne' ];
  · intro k;
    rw [ spectralCorrection, Finset.sum_mul ];
    rw [ abs_of_nonneg ( Finset.sum_nonneg fun i hi => mul_nonneg ( hweight i ) ( pow_nonneg ( div_nonneg ( hlam_nonneg i ) hlam0pos.le ) _ ) ) ] ; exact Finset.sum_le_sum fun i hi => mul_le_mul_of_nonneg_left ( pow_le_pow_left₀ ( div_nonneg ( hlam_nonneg i ) hlam0pos.le ) ( div_le_div_of_nonneg_right ( hsecond i ( Finset.ne_of_mem_erase hi ) ) hlam0pos.le ) _ ) ( hweight i ) ;
  · -- The sum of the eigenvalues can be split into the top state and the remaining states.
    have h_split : ∀ k, normalizedSpectralMoment lam weight lam0 k = weight top + ∑ i ∈ Finset.univ.erase top, weight i * (lam i / lam0) ^ k := by
      unfold normalizedSpectralMoment;
      simp +decide [ Finset.sum_div _ _ _, mul_div, hlam0, hlam0pos.ne', div_pow ];
    rw [ show normalizedSpectralMoment lam weight lam0 = _ from funext h_split ];
    exact le_trans ( tendsto_const_nhds.add ( tendsto_finset_sum _ fun i hi => tendsto_const_nhds.mul ( tendsto_pow_atTop_nhds_zero_of_lt_one ( div_nonneg ( hlam_nonneg i ) hlam0pos.le ) ( by rw [ div_lt_iff₀ hlam0pos ] ; linarith [ hsecond i ( Finset.ne_of_mem_erase hi ) ] ) ) ) ) ( by simp +decide )

/-
Witness family showing that positive definiteness gives no uniform positive
lower bound on the spectral gap.  For every `ε > 0`, `diag(1+ε,1)` is positive
definite and has orthogonal eigenvectors with eigenvalues only `ε` apart.
-/
theorem arbitrarily_small_gap (ε : ℝ) (hε : 0 < ε) :
    ∃ T : Matrix (Fin 2) (Fin 2) ℝ,
      T.PosDef ∧ T.IsHermitian ∧
      T.mulVec ![1, 0] = (1 + ε) • ![1, 0] ∧
      T.mulVec ![0, 1] = (1 : ℝ) • ![0, 1] ∧
      (1 + ε) - 1 = ε := by
  -- Let's choose the matrix $T = \text{diag}(1 + \epsilon, 1)$.
  use Matrix.diagonal ![1 + ε, 1];
  refine' ⟨ _, _, _, _ ⟩ <;> norm_num [ Matrix.IsHermitian, Matrix.mulVec ];
  · linarith;
  · ext i ; fin_cases i <;> norm_num [ Matrix.mulVec ];
  · ext i ; fin_cases i <;> norm_num [ Matrix.mulVec ]

/-- The rank-one matrix `u uᵀ`; for a unit eigenvector this is its spectral
projector. -/
def rankOneProjector {n : Type*} (u : n → ℝ) : Matrix n n ℝ :=
  fun i j => u i * u j

/-
Two positive-definite symmetric matrices can have the same (here unit)
gap while their top eigenspaces and top spectral projectors differ.
The displayed unit top eigenvectors are different coordinate axes.
-/
theorem same_gap_different_eigenvectors :
    ∃ T₁ T₂ : Matrix (Fin 2) (Fin 2) ℝ,
      T₁.PosDef ∧ T₂.PosDef ∧ T₁.IsHermitian ∧ T₂.IsHermitian ∧
      T₁.mulVec ![1, 0] = (2 : ℝ) • ![1, 0] ∧
      T₁.mulVec ![0, 1] = (1 : ℝ) • ![0, 1] ∧
      T₂.mulVec ![0, 1] = (2 : ℝ) • ![0, 1] ∧
      T₂.mulVec ![1, 0] = (1 : ℝ) • ![1, 0] ∧
      ((1 : ℝ) = 2 - 1) ∧
      (![1, 0] : Fin 2 → ℝ) ≠ ![0, 1] ∧
      rankOneProjector (![1, 0] : Fin 2 → ℝ) ≠
        rankOneProjector (![0, 1] : Fin 2 → ℝ) := by
  norm_num [ ← List.ofFn_inj ] at *;
  refine' ⟨ Matrix.diagonal ( fun i => if i = 0 then 2 else 1 ), _, Matrix.diagonal ( fun i => if i = 0 then 1 else 2 ), _, _, _, _ ⟩ <;> norm_num [ Matrix.mulVec, rankOneProjector ]
  intro h
  have h00 := congrFun (congrFun h (0 : Fin 2)) (0 : Fin 2)
  norm_num [rankOneProjector] at h00

end FiniteTransfer
