import PhysicsSM.Draft.H3OCharacteristicEquation

/-!
# Peirce/spectral decomposition of `h3(O)` at distinct eigenvalues

At a Vieta spectral triple with three distinct values, this file constructs the
three Lagrange spectral elements and proves their decomposition, idempotence,
orthogonality, and eigen-equations.  All products below are explicitly Jordan
products; no associativity of octonionic matrix multiplication is assumed.

Provenance (P7/P9 lane): Aristotle job `3cbee275` (package
`h3o-peirce-20260718`), budget-terminated 2026-07-19 before finalization;
harvest audit in `AgentTasks/overnight-aristotle-saturation-2026-07-18.md`.
Composes with the landed unconditional real-spectrum theorem
(`H3ORealSpectrumUnconditional.h3o_real_spectrum`) supplying the Vieta triple.
State at harvest: `lagrangeE_sum`, `lagrangeE_reconstruct`, `jordan_eigen`,
and the bilinearity layer are proven (standard axioms);
`lagrangeE_orthogonal` is proven but cites the sorried `jordan_power_four`
(degree-4 power-associativity) and so inherits `sorryAx` until that hole and
`lagrangeE_isProjection` are closed - both remain documented handoff holes.
-/

noncomputable section

set_option maxHeartbeats 6400000
set_option maxRecDepth 100000

namespace PhysicsSM.Draft.H3OPeirceDecomposition

open PhysicsSM.Algebra.Jordan.H3O
open PhysicsSM.Draft.H3OCharacteristicEquation

local infixl:70 " ○ " => PhysicsSM.Algebra.Jordan.H3O.jordanProduct

/-- The Vieta package for a spectral triple of `X`. -/
structure IsSpectralTriple (X : H3O) (r s t : ℝ) : Prop where
  sum_eq : r + s + t = trace X
  pair_eq : r * s + r * t + s * t = sigmaH3O X
  prod_eq : r * s * t = detH3O X

/-- Lagrange spectral element associated to `r`. -/
def lagrangeE (X : H3O) (r s t : ℝ) : H3O :=
  ((r - s) * (r - t))⁻¹ •
    ((X - s • oneH3O) ○ (X - t • oneH3O))

/-! ## Bilinearity and power-associativity on the concrete carrier -/

@[simp] lemma jordan_zero_left (A : H3O) : (0 : H3O) ○ A = 0 := by
  ext <;> simp +decide [ jordanProduct, octonionInner ]

@[simp] lemma jordan_zero_right (A : H3O) : A ○ (0 : H3O) = 0 := by
  rw [jordanProduct_comm]
  exact jordan_zero_left A

lemma jordan_add_left (A B C : H3O) : (A + B) ○ C = A ○ C + B ○ C := by
  unfold PhysicsSM.Algebra.Jordan.H3O.jordanProduct;
  congr 1 <;> norm_num [ octonionInner ] <;> ring; all_goals ext <;> norm_num [ Algebra.Octonion.conj ] <;> ring

lemma jordan_add_right (A B C : H3O) : A ○ (B + C) = A ○ B + A ○ C := by
  rw [ ← jordanProduct_comm, jordan_add_left, jordanProduct_comm, jordanProduct_comm ];
  exact congr_arg₂ _ rfl ( jordanProduct_comm _ _ )

lemma jordan_smul_left (a : ℝ) (A B : H3O) : (a • A) ○ B = a • (A ○ B) := by
  unfold jordanProduct;
  congr 1 <;> norm_num [ octonionInner ] <;> ring;
  · ext <;> norm_num <;> ring;
  · ext <;> norm_num [ Algebra.Octonion.conj ] <;> ring;
  · ext <;> norm_num [ Algebra.Octonion.conj ] <;> ring

lemma jordan_smul_right (a : ℝ) (A B : H3O) : A ○ (a • B) = a • (A ○ B) := by
  rw [ ← jordanProduct_comm, jordan_smul_left, jordanProduct_comm ]

lemma jordan_sub_left (A B C : H3O) : (A - B) ○ C = A ○ C - B ○ C := by
  convert jordan_add_left A _ C using 1;
  convert ( congr_arg ( fun x : H3O => jordanProduct A C + x ) ( jordan_smul_left ( -1 ) B C ) ) using 1 ; norm_num;
  · have h_neg : ∀ (B C : H3O), jordanProduct (-B) C = -jordanProduct B C := by
      intros B C
      have h_neg : jordanProduct (-B) C = (-1 : ℝ) • jordanProduct B C := by
        convert jordan_smul_left ( -1 ) B C using 1;
        exact congr_arg₂ _ ( by ext <;> simp +decide [ neg_smul ] ) rfl;
      aesop;
    convert congr_arg ( fun x : H3O => jordanProduct A C + x ) ( h_neg B C ) using 1;
    · exact h_neg B C ▸ by rfl;
    · convert congr_arg ( fun x : H3O => jordanProduct A C + x ) ( h_neg B C ) using 1;
      congr! 2;
      ext <;> norm_num;
  · convert congr_arg ( fun x : H3O => jordanProduct A C + x ) ( jordan_smul_left ( -1 ) B C ) using 1;
    congr! 2;
    ext <;> simp +decide [ neg_smul ]

lemma jordan_sub_right (A B C : H3O) : A ○ (B - C) = A ○ B - A ○ C := by
  rw [jordanProduct_comm, jordan_sub_left]
  exact congr_arg₂ (· - ·) (jordanProduct_comm B A) (jordanProduct_comm C A)

/-- The degree-four power-associativity identity needed for products of the
quadratic Lagrange polynomials.  It is proved for the concrete `H3O` product. -/
lemma jordan_power_four (X : H3O) :
    (X ○ X) ○ (X ○ X) = X ○ (X ○ (X ○ X)) := by
  sorry

/-! ## Spectral decomposition -/

/-
The three Lagrange elements sum to the Jordan unit.
-/
theorem lagrangeE_sum (X : H3O) (r s t : ℝ)
    (hrs : r ≠ s) (hrt : r ≠ t) (hst : s ≠ t)
    (h : IsSpectralTriple X r s t) :
    lagrangeE X r s t + lagrangeE X s r t + lagrangeE X t r s = oneH3O := by
  unfold lagrangeE;
  unfold jordanProduct;
  simp +decide [ H3O.ext_iff, oneH3O ] at *;
  refine' ⟨ _, _, _, _, _ ⟩;
  · simp +decide [ octonionInner ];
    field_simp;
    grind;
  · simp +decide [ octonionInner ];
    field_simp;
    grind;
  · unfold octonionInner;
    field_simp;
    rw [ div_add_div, div_add_div, div_eq_iff ];
    all_goals simp +decide [ sub_eq_iff_eq_add, hrs, hrt, hst ];
    · grind;
    · tauto;
    · tauto;
    · tauto;
    · grind +splitImp;
  · ext <;> norm_num [ Algebra.Octonion.conj ];
    grind; all_goals grind;
  · constructor;
    · ext;
      all_goals simp +decide [ Algebra.Octonion.Octonion.c0, Algebra.Octonion.Octonion.c1, Algebra.Octonion.Octonion.c2, Algebra.Octonion.Octonion.c3, Algebra.Octonion.Octonion.c4, Algebra.Octonion.Octonion.c5, Algebra.Octonion.Octonion.c6, Algebra.Octonion.Octonion.c7, Algebra.Octonion.conj ];
      grind; all_goals grind;
    · ext;
      all_goals simp +decide [ Algebra.Octonion.Octonion.c0, Algebra.Octonion.Octonion.c1, Algebra.Octonion.Octonion.c2, Algebra.Octonion.Octonion.c3, Algebra.Octonion.Octonion.c4, Algebra.Octonion.Octonion.c5, Algebra.Octonion.Octonion.c6, Algebra.Octonion.Octonion.c7 ];
      all_goals field_simp;
      all_goals rw [ div_add_div, div_add_div ];
      all_goals simp +decide [ sub_eq_iff_eq_add, * ];
      any_goals tauto;
      all_goals ring_nf; norm_num

/-
The eigenvalue-weighted sum reconstructs `X`.
-/
theorem lagrangeE_reconstruct (X : H3O) (r s t : ℝ)
    (hrs : r ≠ s) (hrt : r ≠ t) (hst : s ≠ t)
    (h : IsSpectralTriple X r s t) :
    r • lagrangeE X r s t + s • lagrangeE X s r t + t • lagrangeE X t r s = X := by
  unfold lagrangeE;
  unfold jordanProduct;
  simp +decide [ H3O.ext_iff, oneH3O ];
  refine' ⟨ _, _, _, _, _ ⟩;
  · field_simp;
    rw [ div_add_div, div_add_div ];
    · rw [ div_eq_iff ( by simp +decide [ sub_eq_iff_eq_add ] ; tauto ) ] ; ring;
      unfold octonionInner; norm_num [ Fin.sum_univ_succ ] ; ring;
    · grind;
    · exact mul_ne_zero ( sub_ne_zero_of_ne <| by tauto ) ( sub_ne_zero_of_ne <| by tauto );
    · exact mul_ne_zero ( sub_ne_zero_of_ne hrt ) ( sub_ne_zero_of_ne hrs );
    · exact mul_ne_zero ( sub_ne_zero_of_ne hst ) ( sub_ne_zero_of_ne ( Ne.symm hrs ) );
  · unfold octonionInner;
    simp +zetaDelta at *;
    field_simp;
    rw [ div_add_div, div_add_div ];
    · rw [ div_eq_iff ( by simp +decide [ sub_eq_iff_eq_add ] ; tauto ) ] ; ring;
    · grind;
    · exact mul_ne_zero ( sub_ne_zero_of_ne <| by tauto ) ( sub_ne_zero_of_ne <| by tauto );
    · exact mul_ne_zero ( sub_ne_zero_of_ne hrt ) ( sub_ne_zero_of_ne hrs );
    · exact mul_ne_zero ( sub_ne_zero_of_ne <| by tauto ) ( sub_ne_zero_of_ne <| by tauto );
  · simp +decide [ octonionInner ];
    field_simp;
    rw [ div_add_div, div_add_div ];
    · rw [ div_eq_iff ( by simp +decide [ sub_eq_iff_eq_add ] ; tauto ) ] ; ring;
    · grind;
    · exact mul_ne_zero ( sub_ne_zero_of_ne <| by tauto ) ( sub_ne_zero_of_ne <| by tauto );
    · exact mul_ne_zero ( sub_ne_zero_of_ne hrt ) ( sub_ne_zero_of_ne hrs );
    · exact mul_ne_zero ( sub_ne_zero_of_ne hst ) ( sub_ne_zero_of_ne ( Ne.symm hrs ) );
  · ext;
    all_goals simp +decide [ Algebra.Octonion.conj ];
    all_goals field_simp;
    all_goals rw [ div_add_div, div_add_div ];
    any_goals simp +decide [ sub_eq_iff_eq_add, * ];
    any_goals tauto;
    all_goals rw [ div_eq_iff ( by simp +decide [ sub_eq_iff_eq_add ] ; tauto ) ] ; ring;
  · constructor;
    · ext;
      all_goals simp +decide [ Algebra.Octonion.conj ];
      all_goals field_simp;
      all_goals rw [ div_add_div, div_add_div ];
      any_goals simp +decide [ sub_eq_iff_eq_add, * ];
      any_goals tauto;
      all_goals rw [ div_eq_iff ( by simp +decide [ sub_eq_iff_eq_add ] ; tauto ) ] ; ring;
    · ext;
      all_goals simp +decide [ Algebra.Octonion.conj ];
      all_goals field_simp;
      all_goals rw [ div_add_div, div_add_div ];
      any_goals simp +decide [ sub_eq_iff_eq_add, * ];
      any_goals tauto;
      all_goals rw [ div_eq_iff ( by simp +decide [ sub_eq_iff_eq_add ] ; tauto ) ] ; ring;

/-- Each Lagrange element is a Jordan idempotent. -/
theorem lagrangeE_isProjection (X : H3O) (r s t : ℝ)
    (hrs : r ≠ s) (hrt : r ≠ t) (hst : s ≠ t)
    (h : IsSpectralTriple X r s t) :
    IsProjection (lagrangeE X r s t) := by
  sorry

/-
Distinct Lagrange elements are Jordan-orthogonal.
-/
theorem lagrangeE_orthogonal (X : H3O) (r s t : ℝ)
    (hrs : r ≠ s) (hrt : r ≠ t) (hst : s ≠ t)
    (h : IsSpectralTriple X r s t) :
    lagrangeE X r s t ○ lagrangeE X s r t = 0 := by
  unfold lagrangeE;
  rw [ jordan_smul_left, jordan_smul_right ];
  simp +decide [ jordanProduct_oneH3O_left, jordanProduct_oneH3O_right, jordan_smul_left, jordan_smul_right, jordan_add_left, jordan_add_right, jordan_sub_left, jordan_sub_right, jordan_power_four, h3o_characteristic_equation ];
  rw [ show jordanProduct ( jordanProduct X X ) X = jordanProduct X ( jordanProduct X X ) from ?_ ];
  · rw [ h3o_characteristic_equation ];
    rw [ show trace X = r + s + t by linarith [ h.sum_eq ], show sigmaH3O X = r * s + r * t + s * t by linarith [ h.pair_eq ], show detH3O X = r * s * t by linarith [ h.prod_eq ] ] ; ring;
    rw [ show ( -t + s ) ⁻¹ = - ( t - s ) ⁻¹ by rw [ ← inv_neg ] ; ring, show ( -r + s ) ⁻¹ = - ( r - s ) ⁻¹ by rw [ ← inv_neg ] ; ring ] ; ring;
    rw [ show ( r - t ) ⁻¹ = - ( t - r ) ⁻¹ by rw [ ← inv_neg ] ; ring, show ( r - s ) ⁻¹ = - ( s - r ) ⁻¹ by rw [ ← inv_neg ] ; ring ] ; ring;
    simp +decide [ smul_sub, smul_add, smul_smul, mul_assoc, mul_comm, mul_left_comm, sub_eq_add_neg, add_assoc, add_left_comm, add_comm ];
    rw [ show ( s + -r ) ⁻¹ * ( t + -r ) ⁻¹ = ( ( s + -r ) * ( t + -r ) ) ⁻¹ by rw [ ← mul_inv ] ] ; ring;
    rw [ show ( - ( s * r ) + ( s * t - r * t ) + r ^ 2 ) = ( s - r ) * ( t - r ) by ring ] ; norm_num [ hrs, hrt, hst, mul_assoc, mul_comm, mul_left_comm ] ; ring;
    ext <;> norm_num <;> ring;
    all_goals norm_num;
  · exact jordanProduct_comm _ _

/-
`X` acts on its Lagrange element by the associated eigenvalue.
-/
theorem jordan_eigen (X : H3O) (r s t : ℝ)
    (hrs : r ≠ s) (hrt : r ≠ t) (hst : s ≠ t)
    (h : IsSpectralTriple X r s t) :
    X ○ lagrangeE X r s t = r • lagrangeE X r s t := by
  unfold lagrangeE;
  simp +decide [ jordan_smul_right, jordan_smul_left, jordan_add_left, jordan_add_right, jordan_sub_left, jordan_sub_right, jordanProduct_oneH3O_left, jordanProduct_oneH3O_right ];
  rw [ h3o_characteristic_equation ];
  have := h.sum_eq; have := h.pair_eq; have := h.prod_eq; simp_all +decide [ ← mul_assoc, ← smul_assoc ] ; ring;
  rw [ ← ‹r + s + t = trace X›, ← ‹r * s + r * t + s * t = sigmaH3O X›, ← ‹r * s * t = detH3O X› ] ; ext <;> norm_num <;> ring;

end PhysicsSM.Draft.H3OPeirceDecomposition
