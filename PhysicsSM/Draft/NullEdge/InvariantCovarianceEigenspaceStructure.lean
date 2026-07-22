import Mathlib

/-!
# Spectral structure of finite invariant covariance matrices

This module explains why a rank-two transitive orbital algebra forces one
regional-variance profile while a higher-rank commutative association scheme
permits spectral reweighting.  Pair-class indicator matrices span the invariant
matrices.  Closure requires explicit intersection numbers, and commutativity is
an additional hypothesis: neither is silently inferred from transitivity.

The central finite identity writes regional variance as the sum of spectral
weights times squared projected indicator norms.  The rank-two specialization
forces `c * |A| * (N - |A|) / N`; a three-dimensional witness shows that two
nonuniform eigendirections already permit distinct regional profiles at equal
trace.

Provenance: clean-room finite linear algebra completed by Aristotle project
`f4fba0df-fcd9-4d29-ba99-41062b5c32c2`.  This is a finite covariance theorem,
not a point-process, Lorentz-invariance, or cosmological-constant result.

Draft-trust status: every declaration is kernel-checked; the axiom guard is in
`InvariantCovarianceEigenspaceStructureAxiomGuard`.
-/

open scoped BigOperators
open scoped Real
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure

section Orbitals

variable {α β : Type*} [Fintype α] [Fintype β] [DecidableEq β]

/-- The zero-one matrix of a class in a labeling of ordered pairs.  For an action,
`label` may be taken to label the orbits on `α × α`. -/
def pairClassMatrix (label : α × α → β) (b : β) : Matrix α α ℝ :=
  fun i j => if label (i, j) = b then 1 else 0

/-- A matrix is invariant under the pair classes when it is constant on every fiber
of the pair-class labeling. -/
def PairClassInvariant (label : α × α → β) (M : Matrix α α ℝ) : Prop :=
  ∀ i j k l, label (i, j) = label (k, l) → M i j = M k l

/-
Distinct pair-class indicator matrices are linearly independent, provided every
class occurs.
-/
theorem pairClassMatrix_linearIndependent (label : α × α → β)
    (hsurj : Function.Surjective label) :
    LinearIndependent ℝ (pairClassMatrix label) := by
  refine' Fintype.linearIndependent_iff.2 _;
  intro g hg i; obtain ⟨ a, ha ⟩ := hsurj i; replace hg := congr_fun ( congr_fun hg a.1 ) a.2; simp_all +decide [ Finset.sum_apply, Matrix.sum_apply, pairClassMatrix ] ;

/-
Pair-class indicators span exactly the matrices constant on pair classes.
-/
theorem pairClassMatrix_span (label : α × α → β) (M : Matrix α α ℝ)
    (hM : PairClassInvariant label M) :
    ∃ c : β → ℝ, M = ∑ b, c b • pairClassMatrix label b := by
  by_contra! h_contra;
  -- By definition of pair-class invariant, for each $b \in \beta$, there exists a constant $c_b$ such that $M i j = c_b$ whenever $label (i, j) = b$.
  have h_const : ∀ b : β, ∃ c_b : ℝ, ∀ i j : α, label (i, j) = b → M i j = c_b := by
    intro b
    by_cases h_exists : ∃ i j : α, label (i, j) = b;
    · exact ⟨ M h_exists.choose h_exists.choose_spec.choose, fun i j hij => hM _ _ _ _ ( hij.trans h_exists.choose_spec.choose_spec.symm ) ⟩;
    · exact ⟨ 0, fun i j hij => False.elim ( h_exists ⟨ i, j, hij ⟩ ) ⟩;
  choose c hc using h_const;
  refine' h_contra c ( Matrix.ext fun i j => _ );
  simp +decide [ pairClassMatrix, hc ];
  simp +decide [ pairClassMatrix, Matrix.sum_apply ]

/-- The usual association-scheme closure condition, stated without assuming it follows
from transitivity: products of class matrices have constant coefficients on classes. -/
def HasIntersectionNumbers (label : α × α → β) : Prop :=
  ∀ b d, PairClassInvariant label (pairClassMatrix label b * pairClassMatrix label d)

/-
Under the intersection-number hypothesis, products of invariant matrices remain
invariant.
-/
theorem invariant_mul (label : α × α → β)
    (hinter : HasIntersectionNumbers label) {M N : Matrix α α ℝ}
    (hM : PairClassInvariant label M) (hN : PairClassInvariant label N) :
    PairClassInvariant label (M * N) := by
  obtain ⟨c₁, hc₁⟩ := pairClassMatrix_span label M hM
  obtain ⟨c₂, hc₂⟩ := pairClassMatrix_span label N hN;
  simp +decide [ hc₁, hc₂, Finset.sum_mul _ _ _, Finset.mul_sum, Matrix.mul_sum, Matrix.sum_mul ];
  intro i j k l h; simp +decide [ Finset.sum_apply, Matrix.sum_apply, h ] ;
  exact Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by rw [ hinter _ _ _ _ _ _ h ] ;

/-
Commutativity is an additional hypothesis: if the class matrices commute, then all
invariant matrices commute.  It is not a consequence of transitivity alone.
-/
theorem invariant_commute (label : α × α → β)
    (hcomm : ∀ b d, Commute (pairClassMatrix label b) (pairClassMatrix label d))
    {M N : Matrix α α ℝ} (hM : PairClassInvariant label M)
    (hN : PairClassInvariant label N) : Commute M N := by
  -- By the pairClassMatrix_span theorem, there exist coefficients c and d such that M = ∑ b, c b • pairClassMatrix label b and N = ∑ b, d b • pairClassMatrix label b.
  obtain ⟨c, hc⟩ : ∃ c : β → ℝ, M = ∑ b, c b • pairClassMatrix label b := by
    convert pairClassMatrix_span label M hM using 1
  obtain ⟨d, hd⟩ : ∃ d : β → ℝ, N = ∑ b, d b • pairClassMatrix label b := by
    convert pairClassMatrix_span label N hN using 1;
  simp +decide [ hc, hd, Commute ];
  simp +decide [ SemiconjBy, Finset.mul_sum _ _ _, Finset.sum_mul, mul_assoc, hcomm ];
  simp +decide only [Finset.smul_sum, smul_smul, mul_comm];
  exact Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by rw [ hcomm _ _ ] )

end Orbitals

section Spectral

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
  [FiniteDimensional ℝ E]

/-
A real symmetric endomorphism has an orthonormal eigenbasis.  This is the
single-operator spectral decomposition used below; a commuting symmetric family can be
refined successively to common eigenspaces.
-/
theorem symmetric_orthonormal_eigenbasis (C : E →ₗ[ℝ] E) (hC : C.IsSymmetric) :
    ∃ n : ℕ, ∃ b : OrthonormalBasis (Fin n) ℝ E, ∃ c : Fin n → ℝ,
      ∀ i, C (b i) = c i • b i := by
  by_contra! h_contra;
  convert h_contra ( Module.finrank ℝ E ) _ _;
  rotate_left;
  exact hC.eigenvectorBasis rfl;
  exact fun i => hC.eigenvalues rfl i;
  simp +decide [ Classical.not_not ]

end Spectral

section Variance

variable {α ι : Type*} [Fintype α] [DecidableEq α] [Fintype ι]

/-- The squared Euclidean norm on finite coordinate vectors.  This is defined
explicitly because the generic Pi-space norm on functions is the sup norm. -/
def euclideanNormSq (x : α → ℝ) : ℝ := dotProduct x x

/-- The quadratic form giving the variance of a vector-supported region. -/
def regionalVariance (C : Matrix α α ℝ) (x : α → ℝ) : ℝ :=
  dotProduct x (C.mulVec x)

/-- The real indicator vector of a finite region. -/
def regionIndicator (A : Finset α) : α → ℝ :=
  fun i => if i ∈ A then 1 else 0

/-- Matrix formulation of a finite orthogonal spectral resolution. -/
structure OrthogonalResolution (P : ι → Matrix α α ℝ) : Prop where
  symmetric : ∀ i, Matrix.transpose (P i) = P i
  idempotent : ∀ i, P i * P i = P i
  orthogonal : ∀ i j, i ≠ j → P i * P j = 0
  sum_eq_one : ∑ i, P i = 1

/-
The variance formula: a spectral multiplier weights precisely the squared norm of
each projected component of the region vector.
-/
theorem regionalVariance_spectral (P : ι → Matrix α α ℝ)
    (hP : OrthogonalResolution P) (c : ι → ℝ) (x : α → ℝ) :
    regionalVariance (∑ i, c i • P i) x =
      ∑ i, c i * euclideanNormSq ((P i).mulVec x) := by
  unfold regionalVariance euclideanNormSq;
  have h_expand : ∀ i, dotProduct x ((P i).mulVec x) = dotProduct ((P i).mulVec x) ((P i).mulVec x) := by
    intro i
    have h_symm : Matrix.transpose (P i) = P i := by
      exact hP.symmetric i
    have h_idempotent : P i * P i = P i := by
      exact hP.idempotent i
    have h_dot : dotProduct x (Matrix.mulVec (P i) x) = dotProduct (Matrix.mulVec (P i) x) (Matrix.mulVec (P i) x) := by
      simp +decide [ Matrix.dotProduct_mulVec, Matrix.vecMul_mulVec, h_symm, h_idempotent ]
    exact h_dot;
  simp +decide only [dotProduct_comm x, ← h_expand];
  induction' ( Finset.univ : Finset ι ) using Finset.induction <;> simp_all +decide [ Finset.sum_add_distrib, Matrix.add_mulVec, Matrix.smul_eq_diagonal_mul ];
  simp +decide [ Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _ ];
  simp +decide only [mul_assoc, Finset.sum_mul, Finset.mul_sum _ _ _]

/-
Parseval for a finite orthogonal resolution: the spectral weights of a vector sum
to its squared norm.
-/
theorem sum_projection_norm_sq (P : ι → Matrix α α ℝ)
    (hP : OrthogonalResolution P) (x : α → ℝ) :
    ∑ i, euclideanNormSq ((P i).mulVec x) = euclideanNormSq x := by
  obtain ⟨ symmetric, idempotent, orthogonal, sum_eq_one ⟩ := hP;
  -- By definition of $P$, we know that $\sum_{i} P_i = I$, so we can rewrite the right-hand side.
  have h_sum : dotProduct x (∑ i, (P i).mulVec ((P i).mulVec x)) = dotProduct x x := by
    simp +decide [ ← Matrix.mul_assoc, ← Finset.sum_mul, idempotent, sum_eq_one ];
    simp +decide [ ← Matrix.mulVec_mulVec, ← Matrix.sum_mulVec, sum_eq_one ];
  have h_linear : dotProduct x (∑ i, (P i).mulVec ((P i).mulVec x)) = ∑ i, dotProduct x ((P i).mulVec ((P i).mulVec x)) := by
    exact dotProduct_sum x Finset.univ fun i => (P i).mulVec ((P i).mulVec x)
  simp_all +decide [ euclideanNormSq, dotProduct_comm ];
  simp_all +decide [ Matrix.dotProduct_mulVec, Matrix.vecMul_mulVec ]

/-
The squared Euclidean norm of a region indicator is its cardinality.
-/
theorem regionIndicator_norm_sq (A : Finset α) :
    euclideanNormSq (regionIndicator A) = (A.card : ℝ) := by
  unfold euclideanNormSq regionIndicator
  simp +decide [dotProduct, Finset.sum_ite]

/-- For a region indicator, the nonnegative spectral weights sum exactly to the size of
the region.  Combined with `regionalVariance_spectral`, this makes regional variance a
weighted combination of the spectral multipliers. -/
theorem region_projection_weights (P : ι → Matrix α α ℝ)
    (hP : OrthogonalResolution P) (A : Finset α) :
    ∑ i, euclideanNormSq ((P i).mulVec (regionIndicator A)) = (A.card : ℝ) := by
  rw [sum_projection_norm_sq P hP, regionIndicator_norm_sq]

end Variance

section RankTwo

variable {α : Type*} [Fintype α] [DecidableEq α] [Nonempty α]

/-- The all-ones matrix. -/
def allOnesMatrix : Matrix α α ℝ := fun _ _ => 1

/-- Orthogonal projection away from the uniform vector. -/
noncomputable def uniformComplement : Matrix α α ℝ :=
  1 - (1 / (Fintype.card α : ℝ)) • allOnesMatrix

/-
Applying the uniform-complement projection subtracts the mean.
-/
theorem uniformComplement_mulVec (x : α → ℝ) (i : α) :
    (uniformComplement.mulVec x) i = x i - (∑ j, x j) / Fintype.card α := by
  unfold uniformComplement allOnesMatrix; simp +decide [ Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _ ] ; ring;
  simp +decide [ Matrix.one_apply, Finset.sum_sub_distrib, Finset.mul_sum _ _ _ ] ; ring

/-
If the uniform mode is killed and the entire sum-zero subspace is one
eigenspace with eigenvalue `c`, the matrix is forced to be the scalar multiple of the
uniform-complement projection.
-/
theorem rankTwo_matrix_rigidity (C : Matrix α α ℝ) (c : ℝ)
    (hzero : C.mulVec (fun _ => (1 : ℝ)) = 0)
    (hscalar : ∀ x : α → ℝ, (∑ i, x i) = 0 → C.mulVec x = c • x) :
    C = c • uniformComplement := by
  -- For any $x \in \mathbb{R}^\alpha$, decompose $x = y + m \cdot 1$ where $m = \frac{\sum x_i}{N}$ and $y = x - m \cdot 1$.
  have h_decomp : ∀ x : α → ℝ, ∃ y : α → ℝ, ∑ i, y i = 0 ∧ x = y + ( (∑ i, x i) / Fintype.card α ) • (fun _ => 1 : α → ℝ) := by
    intro x
    use x - ( (∑ i, x i) / Fintype.card α ) • (fun _ => 1 : α → ℝ);
    simp +decide [ sub_eq_add_neg, Finset.sum_add_distrib ];
    rw [ mul_div_cancel₀ ] <;> aesop;
  -- For any $x \in \mathbb{R}^\alpha$, we have $C x = c (x - m \cdot 1)$.
  have h_Cx : ∀ x : α → ℝ, C.mulVec x = c • (x - ( (∑ i, x i) / Fintype.card α ) • (fun _ => 1 : α → ℝ)) := by
    intro x
    obtain ⟨y, hy_sum, hy_decomp⟩ := h_decomp x
    have hy_C : C.mulVec y = c • y := by
      exact hscalar y hy_sum
    have hx_C : C.mulVec x = C.mulVec y + ((∑ i, x i) / Fintype.card α) • C.mulVec (fun _ => 1) := by
      conv_lhs => rw [ hy_decomp ] ; simp +decide [ Matrix.mulVec_add, Matrix.mulVec_smul ] ; ring;
      rfl
    simp [hx_C, hy_C, hzero];
    exact congr_arg _ ( eq_sub_of_add_eq hy_decomp.symm );
  have h_Cx : ∀ x : α → ℝ, C.mulVec x = (c • (uniformComplement)).mulVec x := by
    intro x; rw [ h_Cx x ] ; ext i; simp +decide [ uniformComplement, Matrix.mulVec, dotProduct ] ; ring;
    simp +decide [ Matrix.one_apply, allOnesMatrix, Finset.sum_add_distrib, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _ ] ; ring;
  exact Matrix.toLin'.injective ( LinearMap.ext h_Cx )

/-
Explicit norm computation behind the rank-two regional law.
-/
theorem centered_indicator_norm_sq (A : Finset α) :
    euclideanNormSq (uniformComplement.mulVec (regionIndicator A)) =
      (A.card : ℝ) * (Fintype.card α - A.card) / Fintype.card α := by
  unfold uniformComplement;
  unfold euclideanNormSq; simp +decide [ regionIndicator, dotProduct, mul_sub, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Matrix.mulVec, allOnesMatrix ] ; ring;
  simp +decide [ Matrix.one_apply, Finset.sum_ite, Finset.filter_eq, Finset.filter_ne ] ; ring;
  simpa [ sq, mul_assoc, ne_of_gt ( Fintype.card_pos ) ] using by ring;

/-
Rank-two rigidity, once the one-nontrivial-eigenspace hypothesis has identified the
covariance as a scalar multiple of the uniform-complement projection.
-/
theorem rankTwo_regionalVariance (c : ℝ) (A : Finset α) :
    regionalVariance (c • uniformComplement) (regionIndicator A) =
      c * (A.card : ℝ) * (Fintype.card α - A.card) / Fintype.card α := by
  unfold regionalVariance;
  unfold regionIndicator;
  unfold uniformComplement; simp +decide [ dotProduct, Matrix.mulVec, Finset.mul_sum _ _ _ ] ; ring;
  simp +decide [ Matrix.one_apply, allOnesMatrix ] ; ring

end RankTwo

section FreedomWitness

/-- Two explicit orthogonal nonuniform directions on the same three-dimensional real
space. -/
def u3 : Fin 3 → ℝ := ![1, -1, 0]
def v3 : Fin 3 → ℝ := ![1, 1, -2]

def rankOneMatrix {n : ℕ} (x : Fin n → ℝ) : Matrix (Fin n) (Fin n) ℝ :=
  fun i j => x i * x j

/-- First covariance, projection onto `u3`. -/
noncomputable def covarianceU : Matrix (Fin 3) (Fin 3) ℝ := (1 / 2 : ℝ) • rankOneMatrix u3
/-- Second covariance, projection onto `v3`. -/
noncomputable def covarianceV : Matrix (Fin 3) (Fin 3) ℝ := (1 / 6 : ℝ) • rankOneMatrix v3

/-
The two witness projections commute, so they belong to the same commutative
symmetric matrix algebra.
-/
theorem covarianceU_commute_covarianceV : Commute covarianceU covarianceV := by
  unfold covarianceU covarianceV rankOneMatrix; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Fin.sum_univ_succ, Matrix.mul_apply ] ; ring;
  all_goals unfold u3 v3; norm_num;
  all_goals repeat erw [ Matrix.cons_val_succ' ] ; norm_num;

/-
Two nontrivial eigenspaces permit equal-trace positive semidefinite covariances with
different regional profiles.  The displayed witness also annihilates the uniform mode;
the singleton region `{0}` distinguishes the two.
-/
theorem spectral_freedom_witness :
    Matrix.PosSemidef covarianceU ∧ Matrix.PosSemidef covarianceV ∧
    covarianceU.mulVec (fun _ => (1 : ℝ)) = 0 ∧
    covarianceV.mulVec (fun _ => (1 : ℝ)) = 0 ∧
    Matrix.trace covarianceU = Matrix.trace covarianceV ∧
    regionalVariance covarianceU (regionIndicator {0}) ≠
      regionalVariance covarianceV (regionIndicator {0}) := by
  refine' ⟨ _, _, _, _, _ ⟩;
  · unfold covarianceU;
    constructor;
    · ext i j ; norm_num [ rankOneMatrix ] ; ring;
    · unfold rankOneMatrix u3;
      norm_num [ Fin.sum_univ_succ, Finsupp.sum_fintype ];
      exact fun x => by nlinarith [ sq_nonneg ( x 0 - x 1 ) ] ;
  · constructor <;> norm_num [ covarianceV ];
    · ext i j ; norm_num [ rankOneMatrix ] ; ring;
    · unfold rankOneMatrix ; ring_nf ;
      intro x; norm_num [ Finsupp.sum_fintype, v3 ] ; ring_nf ;
      norm_num [ Fin.sum_univ_succ ] ; ring_nf ;
      nlinarith [ sq_nonneg ( x 0 - x 1 ), sq_nonneg ( x 0 + x 1 - 2 * x 2 ) ];
  · unfold covarianceU;
    unfold rankOneMatrix; norm_num [ ← List.ofFn_inj, Matrix.mulVec ] ;
    norm_num [ Fin.sum_univ_succ, dotProduct, u3 ];
  · unfold covarianceV;
    ext i; fin_cases i <;> norm_num [ Matrix.mulVec, dotProduct, rankOneMatrix ] ;
    · norm_num [ Fin.sum_univ_succ, v3 ];
    · norm_num [ Fin.sum_univ_succ, v3 ];
    · norm_num [ Fin.sum_univ_succ, v3 ];
  · unfold covarianceU covarianceV regionalVariance regionIndicator;
    unfold rankOneMatrix; norm_num [ Fin.sum_univ_succ, Matrix.mulVec, dotProduct ] ;
    unfold u3 v3; norm_num [ Fin.sum_univ_succ, Matrix.trace ] ;

end FreedomWitness

#print axioms pairClassMatrix_linearIndependent
#print axioms pairClassMatrix_span
#print axioms invariant_mul
#print axioms invariant_commute
#print axioms symmetric_orthonormal_eigenbasis
#print axioms regionalVariance_spectral
#print axioms sum_projection_norm_sq
#print axioms regionIndicator_norm_sq
#print axioms region_projection_weights
#print axioms rankTwo_matrix_rigidity
#print axioms centered_indicator_norm_sq
#print axioms rankTwo_regionalVariance
#print axioms covarianceU_commute_covarianceV
#print axioms spectral_freedom_witness

end PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure
