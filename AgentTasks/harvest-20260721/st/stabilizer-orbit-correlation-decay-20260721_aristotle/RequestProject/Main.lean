import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace StabilizerCorrelation

variable {X J : Type*} [Fintype X] [DecidableEq X]
  [Fintype J]

/-- A finite presentation of the non-base-point suborbits.  This avoids developing
permutation-group orbit machinery: the finsets are assumed disjoint, exhaustive away
from `x0`, and the selected row is constant on each one. -/
structure SuborbitData (C : Matrix X X ℝ) (x0 : X) where
  orbit : J → Finset X
  c : J → ℝ
  nonempty : ∀ j, (orbit j).Nonempty
  pairwise : (Set.univ : Set J).PairwiseDisjoint orbit
  cover : Finset.biUnion Finset.univ orbit = Finset.univ.erase x0
  row_constant : ∀ j y, y ∈ orbit j → C x0 y = c j

/--
The selected row sum splits into its diagonal entry and one cardinality-weighted
term for every suborbit.
-/
theorem row_sum_identity (C : Matrix X X ℝ) (x0 : X)
    (D : SuborbitData (J := J) C x0) :
    ∑ y, C x0 y = C x0 x0 + ∑ j, ((D.orbit j).card : ℝ) * D.c j := by
  -- Split the sum into the diagonal term and the off-diagonal terms.
  have h_split : ∑ y, C x0 y = C x0 x0 + ∑ y ∈ Finset.univ.erase x0, C x0 y := by
    rw [ add_comm, Finset.sum_erase_add _ _ ( Finset.mem_univ _ ) ];
  rw [ h_split, ← D.cover, Finset.sum_biUnion ];
  · exact congrArg _ ( Finset.sum_congr rfl fun j hj => by rw [ Finset.sum_congr rfl fun i hi => D.row_constant j i hi ] ; simp +decide );
  · exact fun i _ j _ hij => D.pairwise ( Set.mem_univ i ) ( Set.mem_univ j ) hij

section OnesEigenvector

variable {Y : Type*} [Fintype Y]

/--
Matrix multiplication by the all-ones vector is exactly the row sum.  Thus, when
all row sums share a value `lam`, the ones vector is an eigenvector with eigenvalue
`lam`; transitivity/invariance is one standard way to obtain that hypothesis.
-/
theorem ones_eigenvector_of_constant_row_sum (C : Matrix Y Y ℝ) (lam : ℝ)
    (hrow : ∀ x, ∑ y, C x y = lam) :
    C.mulVec (1 : Y → ℝ) = lam • (1 : Y → ℝ) := by
  ext x; simp +decide [ hrow, Matrix.mulVec, dotProduct ] ;

end OnesEigenvector

/--
The fixed-total (`C.mulVec 1 = 0`) constraint says that the weighted sum of all
off-diagonal suborbit correlations is the negative of the base variance.
-/
theorem fixed_total_constraint (C : Matrix X X ℝ) (x0 : X)
    (D : SuborbitData (J := J) C x0)
    (hzero : C.mulVec (1 : X → ℝ) = 0) :
    ∑ j, ((D.orbit j).card : ℝ) * D.c j = -C x0 x0 := by
  simp_all +decide [ funext_iff, Matrix.mulVec, dotProduct ];
  linarith [ hzero x0, row_sum_identity C x0 D ]

/--
**Sign correction.** For a positive-semidefinite covariance with zero row sum,
nonnegative off-diagonal suborbit correlations cannot merely decay: they all vanish
(and so does the base variance).
-/
theorem nonnegative_correlations_vanish (C : Matrix X X ℝ) (x0 : X)
    (D : SuborbitData (J := J) C x0) (hpsd : C.PosSemidef)
    (hzero : C.mulVec (1 : X → ℝ) = 0)
    (hnonneg : ∀ j, 0 ≤ D.c j) :
    C x0 x0 = 0 ∧ ∀ j, D.c j = 0 := by
  -- From the fixed_total_constraint, we have ∑ j, ((D.orbit j).card : ℝ) * D.c j = -C x0 x0.
  have h_sum : ∑ j, ((D.orbit j).card : ℝ) * D.c j = -C x0 x0 :=
    fixed_total_constraint C x0 D hzero
  -- From the fixed_total_constraint, we have C x0 x0 = 0.
  have h_diag : C x0 x0 = 0 := by
    have := hpsd.2;
    specialize this ( Finsupp.single x0 1 ) ; simp_all +decide [ Finsupp.sum_single_index ];
    linarith [ show 0 ≤ ∑ j, ( D.orbit j |> Finset.card : ℝ ) * D.c j from Finset.sum_nonneg fun _ _ => mul_nonneg ( Nat.cast_nonneg _ ) ( hnonneg _ ) ];
  simp_all +decide [ Finset.sum_eq_zero_iff_of_nonneg, mul_nonneg ];
  exact fun j => Or.resolve_left ( h_sum j ) ( Finset.Nonempty.ne_empty ( D.nonempty j ) )

/--
The correct quantitative orbit-size bound has the opposite sign: under
nonpositive (anti-)correlations, a separation class of size `n` carries correlation
of magnitude at most the base variance divided by `n`.  Without a common sign,
cancellation between classes prevents this conclusion from the fixed-total identity.
-/
theorem anticorrelation_orbit_bound (C : Matrix X X ℝ) (x0 : X)
    (D : SuborbitData (J := J) C x0) (hpsd : C.PosSemidef)
    (hzero : C.mulVec (1 : X → ℝ) = 0)
    (hnonpos : ∀ j, D.c j ≤ 0) (j : J) :
    ((D.orbit j).card : ℝ) * |D.c j| ≤ C x0 x0 := by
  -- From the fixed_total_constraint, we have that the sum of (orbit j).card * D.c j over all j is equal to -C x0 x0.
  have h_sum : ∑ j, ((D.orbit j).card : ℝ) * D.c j = -C x0 x0 := by
    convert fixed_total_constraint C x0 D hzero using 1;
  rw [ Finset.sum_eq_add_sum_diff_singleton ( Finset.mem_univ j ) ] at h_sum;
  have hdiag : 0 ≤ C x0 x0 := hpsd.diag_nonneg
  nlinarith [ hdiag, hnonpos j, abs_of_nonpos ( hnonpos j ), show ∑ x ∈ Finset.univ \ { j }, ( D.orbit x |> Finset.card : ℝ ) * D.c x ≤ 0 by exact Finset.sum_nonpos fun i hi => mul_nonpos_of_nonneg_of_nonpos ( Nat.cast_nonneg _ ) ( hnonpos i ) ]

/--
Finite white-noise estimate: if an anti-correlated suborbit has at least `K > 0`
points, its covariance magnitude is at most the base variance divided by `K`.  Hence
uniformly growing same-sign classes suppress off-diagonal covariance toward white
noise; this is only a finite covariance statement, not a theorem about point processes.
-/
theorem large_orbit_decay (C : Matrix X X ℝ) (x0 : X)
    (D : SuborbitData (J := J) C x0) (hpsd : C.PosSemidef)
    (hzero : C.mulVec (1 : X → ℝ) = 0)
    (hnonpos : ∀ j, D.c j ≤ 0) (j : J) (K : ℕ)
    (hK : 0 < K) (hsize : K ≤ (D.orbit j).card) :
    |D.c j| ≤ C x0 x0 / K := by
  rw [ le_div_iff₀ ( by positivity ) ];
  -- From anticorrelation_orbit_bound obtain card*|c|≤a.
  have h_card_abs : ((D.orbit j).card : ℝ) * |D.c j| ≤ C x0 x0 := by
    convert anticorrelation_orbit_bound C x0 D hpsd hzero hnonpos j using 1;
  nlinarith [ show ( K : ℝ ) ≤ ( D.orbit j |> Finset.card ) by norm_cast, abs_nonneg ( D.c j ) ]

/--
The one-suborbit (maximal-symmetry) specialization: a class of size `N-1`
forces the familiar `a/(N-1)` bound.
-/
theorem single_suborbit_bound (C : Matrix X X ℝ) (x0 : X)
    (D : SuborbitData (J := Fin 1) C x0) (hpsd : C.PosSemidef)
    (hzero : C.mulVec (1 : X → ℝ) = 0)
    (hnonpos : D.c 0 ≤ 0) (N : ℕ) (hN : 1 < N)
    (hcard : (D.orbit 0).card = N - 1) :
    |D.c 0| ≤ C x0 x0 / (N - 1) := by
  convert large_orbit_decay C x0 D hpsd hzero ?_ 0 ( N - 1 ) ?_ hcard.ge <;> norm_num [ hnonpos ];
  · rw [ Nat.cast_pred hN.le ];
  · exact hN

section CyclicExample

abbrev Six := Fin 6

/-- An oriented incidence vector of the six-cycle. -/
noncomputable def cycleEdge (i : Six) : EuclideanSpace ℝ Six :=
  EuclideanSpace.single i 1 -
    EuclideanSpace.single ⟨(i.val + 1) % 6, by omega⟩ 1

/-- The second-difference covariance on the six-cycle, presented as a Gram matrix. -/
noncomputable def cycleCov : Matrix Six Six ℝ := Matrix.gram ℝ cycleEdge

/--
The cyclic second-difference covariance is positive semidefinite.
-/
theorem cycleCov_posSemidef : cycleCov.PosSemidef := by
  convert Matrix.posSemidef_gram ℝ cycleEdge using 1

/--
The cyclic second-difference covariance has fixed total: every row sums to zero.
-/
theorem cycleCov_mulVec_one : cycleCov.mulVec (1 : Six → ℝ) = 0 := by
  ext i;
  simp +decide [ cycleCov, Matrix.mulVec, dotProduct ];
  fin_cases i <;> simp +decide [ cycleEdge ];
  all_goals simp +decide [ Fin.sum_univ_succ, inner ] ;
  norm_num

/--
Its nearest-neighbor correlation is nonzero (in fact `-1`).
-/
theorem cycleCov_nonzero_offdiag : cycleCov 0 1 = -1 := by
  unfold cycleCov;
  unfold cycleEdge; norm_num [ EuclideanSpace.inner_single_left, EuclideanSpace.inner_single_right ] ;
  norm_num [ Fin.ext_iff, inner_sub_left, inner_sub_right ];
  erw [ EuclideanSpace.inner_single_left, EuclideanSpace.inner_single_left, EuclideanSpace.inner_single_left ] ; norm_num

/--
Cyclic translation preserves the covariance.
-/
theorem cycleCov_shift_invariant :
    ∀ i j : Six,
      cycleCov ⟨(i.val + 1) % 6, by omega⟩ ⟨(j.val + 1) % 6, by omega⟩ =
        cycleCov i j := by
  unfold cycleCov;
  unfold cycleEdge; norm_num [ EuclideanSpace.inner_single_left, EuclideanSpace.inner_single_right ] ;
  simp +decide [ Fin.forall_fin_succ, EuclideanSpace.inner_single_right, inner_sub_left, inner_sub_right ]

/--
Translation of `ZMod 6` acts freely at the origin, so its point stabilizer is
trivial.
-/
theorem zmod6_stabilizer_trivial (g : ZMod 6) (h : g + 0 = 0) : g = 0 := by
  fin_cases g <;> trivial

/--
Consequently an oriented separation class for the regular cyclic action is a
singleton, hence has size one.
-/
theorem zmod6_oriented_class_card (d : ZMod 6) : ({d} : Finset (ZMod 6)).card = 1 := by
  exact Finset.card_singleton d

end CyclicExample

#print axioms row_sum_identity
#print axioms ones_eigenvector_of_constant_row_sum
#print axioms fixed_total_constraint
#print axioms nonnegative_correlations_vanish
#print axioms anticorrelation_orbit_bound
#print axioms large_orbit_decay
#print axioms single_suborbit_bound
#print axioms cycleCov_posSemidef
#print axioms cycleCov_mulVec_one
#print axioms cycleCov_nonzero_offdiag
#print axioms cycleCov_shift_invariant
#print axioms zmod6_stabilizer_trivial
#print axioms zmod6_oriented_class_card

end StabilizerCorrelation
