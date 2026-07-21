import PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol

/-!
# Successive-axis four-component Dirac walk

This module realizes the literature-supported route around the simultaneous
six-channel obstruction. Three normalized axis factors and one mass factor act
successively on a shared four-component internal space. Each factor is exactly
unitary on its normalization circle, their ordered product is unitary, and the
componentwise complex derivative at zero has generator `-i H`, where `H` is the
full `3+1` Clifford symbol. The symbol squares to the relativistic scalar.

This is an internal split-step construction. It does not yet attach the factors
to spatial shifts, prove a product-limit error bound, or recover a spacetime
propagator. Those are separate successor theorems.

Provenance: theorem shape informed by Mlodinow-Brun, arXiv:1802.03910; proofs
completed by Aristotle project `293514db-97eb-4541-97a1-8489683bfe86` and
locally validated from an in-progress snapshot on 2026-07-10.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk

abbrev Mat4 := Matrix (Fin 4) (Fin 4) ℂ

def alpha1 : Mat4 :=
  !![0, 0, 0, 1; 0, 0, 1, 0; 0, 1, 0, 0; 1, 0, 0, 0]

def alpha2 : Mat4 :=
  !![0, 0, 0, -I; 0, 0, I, 0; 0, -I, 0, 0; I, 0, 0, 0]

def alpha3 : Mat4 :=
  !![0, 0, 1, 0; 0, 0, 0, -1; 1, 0, 0, 0; 0, -1, 0, 0]

def beta : Mat4 :=
  !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

def H (kx ky kz m : ℂ) : Mat4 :=
  kx • alpha1 + ky • alpha2 + kz • alpha3 + m • beta

def IsUnitary (U : Mat4) : Prop :=
  U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1

noncomputable def normalizedFactor (a b : ℝ) (g : Mat4) : Mat4 :=
  (a : ℂ) • (1 : Mat4) - (I * (b : ℂ)) • g

noncomputable def successiveStep
    (ax bx ay by_ az bz am bm : ℝ) : Mat4 :=
  normalizedFactor ax bx alpha1 *
    normalizedFactor ay by_ alpha2 *
    normalizedFactor az bz alpha3 *
    normalizedFactor am bm beta

theorem generators_hermitian :
    alpha1.conjTranspose = alpha1 ∧
      alpha2.conjTranspose = alpha2 ∧
      alpha3.conjTranspose = alpha3 ∧
      beta.conjTranspose = beta := by
  -- By definition of conjugate transpose, we know that each element of the conjugate transpose is the complex conjugate of the corresponding element in the original matrix.
  simp [Matrix.conjTranspose, alpha1, alpha2, alpha3, beta];
  -- By definition of conjugate transpose, we know that each element of the conjugate transpose is the complex conjugate of the corresponding element in the original matrix. We can verify this for each matrix.
  simp [Matrix.map, Matrix.transpose];
  -- By definition of conjugate transpose, we know that each element of the conjugate transpose is the complex conjugate of the corresponding element in the original matrix. We can verify this for each matrix by checking each element.
  simp [funext_iff, Fin.forall_fin_succ]

theorem generators_square_one :
    alpha1 * alpha1 = 1 ∧ alpha2 * alpha2 = 1 ∧
      alpha3 * alpha3 = 1 ∧ beta * beta = 1 := by
  -- By definition of matrix multiplication, we can compute each product directly.
  simp [alpha1, alpha2, alpha3, beta];
  -- The matrix !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1] is indeed the identity matrix.
  ext i j; fin_cases i <;> fin_cases j <;> rfl

theorem normalized_factor_unitary
    (g : Mat4) (hg : g.conjTranspose = g) (hgg : g * g = 1)
    (a b : ℝ) (hab : a ^ 2 + b ^ 2 = 1) :
    IsUnitary (normalizedFactor a b g) := by
  constructor <;> simp +decide [ *, normalizedFactor ];
  · simp_all +decide [ mul_sub, add_mul, ← mul_assoc, ← Matrix.ext_iff ];
    intro i j; ring_nf; norm_num [ Complex.ext_iff, sq ] at *;
    by_cases hi : i = j <;> simp_all +decide [ Matrix.one_apply ];
  · simp_all +decide [ mul_add, add_mul, sub_mul, mul_sub, ← mul_assoc, mul_comm ];
    ext i j ; norm_num ; ring ; norm_num [ Complex.ext_iff, sq ] ; ring;
    grind +qlia

theorem successive_step_unitary
    (ax bx ay by_ az bz am bm : ℝ)
    (hx : ax ^ 2 + bx ^ 2 = 1)
    (hy : ay ^ 2 + by_ ^ 2 = 1)
    (hz : az ^ 2 + bz ^ 2 = 1)
    (hm : am ^ 2 + bm ^ 2 = 1) :
    IsUnitary (successiveStep ax bx ay by_ az bz am bm) := by
  -- Each normalized factor is unitary by the normalized_factor_unitary lemma.
  have h_normalized_factors_unitary : IsUnitary (normalizedFactor ax bx alpha1) ∧ IsUnitary (normalizedFactor ay by_ alpha2) ∧ IsUnitary (normalizedFactor az bz alpha3) ∧ IsUnitary (normalizedFactor am bm beta) := by
    exact ⟨ normalized_factor_unitary _ ( generators_hermitian.1 ) ( generators_square_one.1 ) _ _ hx, normalized_factor_unitary _ ( generators_hermitian.2.1 ) ( generators_square_one.2.1 ) _ _ hy, normalized_factor_unitary _ ( generators_hermitian.2.2.1 ) ( generators_square_one.2.2.1 ) _ _ hz, normalized_factor_unitary _ ( generators_hermitian.2.2.2 ) ( generators_square_one.2.2.2 ) _ _ hm ⟩;
  -- The product of unitary matrices is unitary.
  have h_product_unitary : ∀ (U V : Mat4), IsUnitary U → IsUnitary V → IsUnitary (U * V) := by
    simp +contextual [ IsUnitary ];
    grind +locals;
  exact h_product_unitary _ _ ( h_product_unitary _ _ ( h_product_unitary _ _ h_normalized_factors_unitary.1 h_normalized_factors_unitary.2.1 ) h_normalized_factors_unitary.2.2.1 ) h_normalized_factors_unitary.2.2.2

noncomputable def linearFactor (eps coeff : ℂ) (g : Mat4) : Mat4 :=
  (1 : Mat4) - (I * eps * coeff) • g

noncomputable def linearSplit (kx ky kz m eps : ℂ) : Mat4 :=
  linearFactor eps kx alpha1 * linearFactor eps ky alpha2 *
    linearFactor eps kz alpha3 * linearFactor eps m beta

theorem linear_split_at_zero (kx ky kz m : ℂ) :
    linearSplit kx ky kz m 0 = 1 := by
  -- By definition of linearSplit, when eps is zero, each linearFactor term becomes 1.
  simp [linearSplit, linearFactor]

/-
The infinitesimal generator of the successive-axis product is the full
Dirac symbol.
-/
set_option maxHeartbeats 2000000 in
theorem linear_split_entry_hasDerivAt
    (kx ky kz m : ℂ) (i j : Fin 4) :
    HasDerivAt (fun eps : ℂ => linearSplit kx ky kz m eps i j)
      ((-I) * H kx ky kz m i j) 0 := by
  simp +decide [ linearSplit, linearFactor, H ];
  simp +decide [ Matrix.mul_apply, mul_assoc ];
  simp +decide [ Matrix.one_apply, Fin.sum_univ_succ ];
  unfold alpha1 alpha2 alpha3 beta;
  fin_cases i <;> simp +decide [ Fin.sum_univ_succ ];
  · fin_cases j <;> simp +decide [ Fin.ext_iff ] <;> ring_nf;
    · convert HasDerivAt.add ( HasDerivAt.sub ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_id ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.sub ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 2 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 3 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ) using 1 ; norm_num;
    · convert HasDerivAt.add ( HasDerivAt.add ( HasDerivAt.neg ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 2 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 2 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.sub ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 3 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 3 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ) using 1 ; norm_num;
    · convert HasDerivAt.add ( HasDerivAt.sub ( HasDerivAt.neg ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_id ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 2 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) |> HasDerivAt.mul <| hasDerivAt_const _ _ ) ) ( HasDerivAt.sub ( HasDerivAt.neg ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 3 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) |> HasDerivAt.mul <| hasDerivAt_const _ _ ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 4 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) |> HasDerivAt.mul <| hasDerivAt_const _ _ ) ( hasDerivAt_const _ _ ) ) ) using 1 ; norm_num;
    · convert HasDerivAt.add ( HasDerivAt.add ( HasDerivAt.neg ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_id ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.sub ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_id ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 2 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 2 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) using 1 ; norm_num;
  · fin_cases j <;> simp +decide [ Fin.ext_iff ];
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ) ( HasDerivAt.sub ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) using 1 ; norm_num;
    · ring_nf;
      convert HasDerivAt.add ( HasDerivAt.add ( hasDerivAt_const _ _ ) ( HasDerivAt.sub ( HasDerivAt.neg ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_id ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 2 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 3 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) using 1 ; norm_num;
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.neg ( HasDerivAt.const_mul I ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ( HasDerivAt.neg ( HasDerivAt.const_mul I ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ) ( HasDerivAt.add ( hasDerivAt_const _ _ ) ( HasDerivAt.const_mul I ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) using 1 ; norm_num;
      ring;
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.const_mul I ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.neg ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ) ) ) ( HasDerivAt.add ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) using 1 ; norm_num;
  · fin_cases j <;> simp +decide [ Fin.ext_iff ];
    · ring_nf;
      convert HasDerivAt.add ( HasDerivAt.add ( HasDerivAt.neg ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_id ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.sub ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 2 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 3 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( hasDerivAt_pow 4 ( 0 : ℂ ) ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) ( hasDerivAt_const _ _ ) ) using 1 ; norm_num;
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.neg ( HasDerivAt.const_mul I ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ( HasDerivAt.const_mul I ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ( HasDerivAt.sub ( hasDerivAt_const _ _ ) ( HasDerivAt.const_mul I ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) using 1 ; norm_num;
      ring;
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ( hasDerivAt_const _ _ ) ) ( HasDerivAt.add ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) using 1 ; norm_num;
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.neg ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ) ( HasDerivAt.add ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) using 1 ; norm_num;
  · fin_cases j <;> simp +decide [ Fin.ext_iff ];
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.neg ( HasDerivAt.const_mul I ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ( HasDerivAt.neg ( HasDerivAt.const_mul I ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ) ( HasDerivAt.sub ( hasDerivAt_const _ _ ) ( HasDerivAt.const_mul I ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) using 1 ; norm_num;
      ring;
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.neg ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ) ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ( HasDerivAt.sub ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) using 1 ; norm_num;
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ) ( HasDerivAt.add ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) using 1 ; norm_num;
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.neg ( HasDerivAt.mul ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) ) ( hasDerivAt_const _ _ ) ) ( HasDerivAt.add ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_const _ _ ) ( HasDerivAt.mul ( hasDerivAt_id ( 0 : ℂ ) ) ( hasDerivAt_const _ _ ) ) ) ) using 1 ; norm_num

theorem H_sq (kx ky kz m : ℂ) :
    H kx ky kz m * H kx ky kz m =
      (kx ^ 2 + ky ^ 2 + kz ^ 2 + m ^ 2) • (1 : Mat4) := by
  unfold H;
  simp +decide [ Matrix.mul_add, Matrix.add_mul, Matrix.mul_smul, Matrix.smul_mul, sq ];
  unfold alpha1 alpha2 alpha3 beta; ext i j; norm_num; ring;
  fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.one_apply ]

theorem nondegenerate_1223_control :
    H 1 2 2 3 * H 1 2 2 3 = (18 : ℂ) • (1 : Mat4) ∧
      H 1 2 2 3 ≠ 0 ∧
      IsUnitary (successiveStep (3 / 5) (4 / 5) (3 / 5) (4 / 5)
        (3 / 5) (4 / 5) (3 / 5) (4 / 5)) := by
  -- First, we need to show that $H(1, 2, 2, 3)$ is not zero.
  have h_nonzero : H 1 2 2 3 ≠ 0 := by
    -- By definition of $H$, we know that $H(1, 2, 2, 3)$ is not zero because it contains non-zero entries.
    simp [H, alpha1, alpha2, alpha3, beta];
    -- To prove the matrix is not zero, we can show that at least one of its entries is non-zero.
    intro h
    have := congr_fun (congr_fun h 0) 0
    simp at this;
  -- Now let's show that the successive step is unitary.
  apply And.intro (by
  convert H_sq 1 2 2 3 using 1 ; norm_num) (And.intro h_nonzero (by
  -- Apply the successive_step_unitary theorem with the given parameters.
  apply successive_step_unitary; norm_num; norm_num; norm_num; norm_num))

/-- On real coefficients, the split-step tangent generator is exactly the
project's previously landed Clifford symbol. -/
theorem real_symbol_matches_project (kx ky kz m : ℝ) :
    H (kx : ℂ) (ky : ℂ) (kz : ℂ) (m : ℂ) =
      PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.H kx ky kz m := by
  rfl

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk.successive_step_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms successive_step_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk.linear_split_entry_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linear_split_entry_hasDerivAt

/-- info: 'PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk.nondegenerate_1223_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nondegenerate_1223_control

end PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk
