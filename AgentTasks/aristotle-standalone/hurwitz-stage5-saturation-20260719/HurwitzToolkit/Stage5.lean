import HurwitzToolkit.Stage3
import HurwitzToolkit.Stage4

/-!
# Hurwitz stage 5: the saturation endgame - `finrank A ∈ {1, 2, 4, 8}`

Target statements for the Aristotle job `hurwitz-stage5-20260719`.
Source lineage: Springer-Veldkamp Ch. 1 / Baez math/0105155 sec 2.2,
clean-room; statements original to this campaign.

Included and PROVEN: stage-1 toolkit (`Target.lean`), the stage-2 doubling
theorems (two documented Moufang holes remain upstream of `doubling_closed`;
a separate job is closing them - inheritance through
`doubled_isUnitalSubalgebra`/`ladder_step` is accepted and tracked), the
stage-3a crux `orthogonal_forces_associative` (ZERO holes), and all seven
stage-4a ladder theorems (five with zero holes).

The saturation argument (pre-drafted design, statements frozen against the
harvested stage-3/4 APIs):

* the base rung `span {1}` is a unital subalgebra of dimension 1;
* every proper rung doubles (`ladder_step`), multiplying dimension by 2;
* a rung of dimension `>= 2` contains `x` with `conj Q x ≠ x`;
* doubling a rung containing such an `x` yields a NON-COMMUTATIVE rung
  (`x * a = a * conj Q x` vs `a * x`, killed by left-multiplication
  injectivity from the composition law);
* doubling a non-commutative rung yields a NON-ASSOCIATIVE rung (the
  associator `(x, y, a)` is `((x*y) - (y*x)) * a ≠ 0` directly from
  `mul_mul_orthogonal_right`);
* a PROPER rung admits a nonzero orthogonal direction
  (`exists_orthogonal_ne_zero`), which is anisotropic, so stage-3a forces
  the rung ASSOCIATIVE - contradiction at the non-associative dim-8 rung;
* hence the tower stops with `A` itself at dimension 1, 2, 4, or 8.

Do not weaken the final statement.  If an intermediate needs an extra
standard hypothesis, add it explicitly and record it prominently.  Every
`s o r r y` below is a documented handoff hole.
-/

namespace HurwitzToolkit

variable {A : Type*} [NonAssocRing A] [Module ℝ A]
  [SMulCommClass ℝ A A] [IsScalarTower ℝ A A] [Nontrivial A]

open QuadraticMap

/-
The requested `Q_one` result is already proved in `Target.lean` as
`HurwitzToolkit.Q_one` (with `Q` implicit), with exactly the required
conclusion, so it is reused rather than redeclared here.

The base rung: the scalar line is a unital subalgebra.
-/
theorem spanOne_isUnitalSubalgebra (Q : QuadraticForm ℝ A)
    (hQ : IsCompositionForm Q) :
    IsUnitalSubalgebra Q (Submodule.span ℝ ({1} : Set A)) := by
  constructor <;> intros <;> simp_all +decide [ Submodule.mem_span_singleton ];
  · rename_i hx hy;
    obtain ⟨ a, rfl ⟩ := hx; obtain ⟨ b, rfl ⟩ := hy; use a * b; simp +decide [ mul_smul_comm ] ;
    rw [ smul_smul, mul_comm ];
  · rename_i x hx; obtain ⟨ a, rfl ⟩ := hx; use polar Q ( a • 1 ) 1 - a; simp +decide [ conj ] ;
    rw [ sub_smul ]

/-
The base rung has dimension one.
-/
theorem finrank_spanOne :
    Module.finrank ℝ (Submodule.span ℝ ({1} : Set A)) = 1 := by
  convert finrank_span_singleton ( one_ne_zero : ( 1 : A ) ≠ 0 )

/-
A rung of dimension at least two contains a conjugation-nontrivial
element.
-/
theorem exists_conj_ne_of_one_lt_finrank [FiniteDimensional ℝ A]
    (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (h2 : 1 < Module.finrank ℝ S) :
    ∃ x ∈ S, conj Q x ≠ x := by
  by_contra h_contra
  push_neg at h_contra
  have h_sub : S ≤ Submodule.span ℝ ({1} : Set A) := by
    intro x hx
    have h_eq : polar Q x 1 • (1 : A) - x = x := by
      exact h_contra x hx
    have h_eq' : x = (1 / 2 : ℝ) • (polar Q x 1) • (1 : A) := by
      rw [ sub_eq_iff_eq_add ] at h_eq;
      simp +decide [ h_eq, ← two_smul ℝ ]
    exact (by
    exact h_eq'.symm ▸ Submodule.smul_mem _ _ ( Submodule.smul_mem _ _ ( Submodule.mem_span_singleton_self _ ) ))
  have h_eq : S = Submodule.span ℝ ({1} : Set A) := by
    exact le_antisymm h_sub ( Submodule.span_le.mpr ( Set.singleton_subset_iff.mpr hS.one_mem ) )
  rw [h_eq] at h2
  exact (by
  exact h2.ne' ( by rw [ finrank_span_singleton ] ; norm_num ))

/-
Doubling along a conjugation-nontrivial element produces a
non-commutative rung.
-/
theorem doubled_not_commutative (Q : QuadraticForm ℝ A)
    (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a) (hQa : Q a ≠ 0)
    (x : A) (hx : x ∈ S) (hne : conj Q x ≠ x) :
    ∃ u ∈ doubledSubmodule S a, ∃ v ∈ doubledSubmodule S a,
      u * v ≠ v * u := by
  refine' ⟨ x, _, a, _, _ ⟩ <;> norm_num [ doubledSubmodule_mem_iff ];
  · exact ⟨ x, hx, 0, S.zero_mem, by simp +decide ⟩;
  · exact ⟨ 0, S.zero_mem, 1, hS.one_mem, by simp +decide ⟩;
  · have h_comm : x * a = a * conj Q x := by
      simpa using mul_orthogonal_commute Q hQ S hS a ha x 1 hx ( hS.one_mem );
    intro h_eq
    have h_contra : a * (conj Q x - x) = 0 := by
      rw [ mul_sub, ← h_comm, h_eq, sub_self ];
    -- Apply Q and hQ.comp: 0 = Q a * Q(conj x-x), so hQa gives Q difference=0 and anisotropy yields conj x=x, contradiction.
    have h_anisotropy : Q (conj Q x - x) = 0 := by
      have := hQ.comp a ( conj Q x - x ) ; simp_all +decide ;
    exact hne ( sub_eq_zero.mp ( hQ.anisotropic _ h_anisotropy ) )

/-
Doubling a non-commutative rung produces a non-associative rung.
-/
theorem doubled_not_associative (Q : QuadraticForm ℝ A)
    (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a) (hQa : Q a ≠ 0)
    (x y : A) (hx : x ∈ S) (hy : y ∈ S) (hne : x * y ≠ y * x) :
    ∃ u ∈ doubledSubmodule S a, ∃ v ∈ doubledSubmodule S a,
      ∃ w ∈ doubledSubmodule S a, (u * v) * w ≠ u * (v * w) := by
  refine' ⟨ x, _, y, _, a, _, _ ⟩;
  · exact Submodule.mem_sup_left hx;
  · exact Submodule.mem_sup_left hy;
  · exact Submodule.mem_sup_right ( Submodule.mem_map.mpr ⟨ 1, hS.one_mem, by simp +decide ⟩ );
  · intro h;
    have h_contra : Q ((x * y - y * x) * a) = 0 := by
      simp_all +decide [ mul_mul_orthogonal_right Q hQ S hS a ha x y hx hy ];
      simp +decide [ sub_mul, h ];
    have := hQ.comp ( x * y - y * x ) a; simp_all +decide ;
    exact hne ( sub_eq_zero.mp ( hQ.anisotropic _ h_contra ) )

/-
**HURWITZ (dimension classification).**  A nontrivial
finite-dimensional real composition algebra has dimension 1, 2, 4, or 8.
-/
theorem hurwitz_finrank_mem [FiniteDimensional ℝ A]
    (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q) :
    Module.finrank ℝ A ∈ ({1, 2, 4, 8} : Set ℕ) := by
  by_contra h;
  -- Let's apply the ladder_step theorem three times to construct a submodule of dimension 8.
  obtain ⟨S1, hS1, hfin1⟩ : ∃ S1 : Submodule ℝ A, IsUnitalSubalgebra Q S1 ∧ Module.finrank ℝ S1 = 2 := by
    obtain ⟨a, ha, haQ, hS1, hfin1⟩ : ∃ a : A, OrthogonalTo Q (Submodule.span ℝ ({1} : Set A)) a ∧ Q a ≠ 0 ∧ IsUnitalSubalgebra Q (doubledSubmodule (Submodule.span ℝ ({1} : Set A)) a) ∧ Module.finrank ℝ (doubledSubmodule (Submodule.span ℝ ({1} : Set A)) a) = 2 := by
      convert ladder_step Q hQ ( Submodule.span ℝ { 1 } ) ( spanOne_isUnitalSubalgebra Q hQ ) _;
      · rw [ finrank_span_singleton ] ; norm_num;
      · contrapose! h;
        rw [ ← finrank_top, ← h, finrank_span_singleton ] <;> norm_num;
    exact ⟨ _, hS1, hfin1 ⟩
  generalize_proofs at *;
  obtain ⟨a2, ha2, hQa2, hS2, hfin2⟩ : ∃ a2 : A, OrthogonalTo Q S1 a2 ∧ Q a2 ≠ 0 ∧ IsUnitalSubalgebra Q (doubledSubmodule S1 a2) ∧ Module.finrank ℝ (doubledSubmodule S1 a2) = 4 := by
    refine' ladder_step Q hQ S1 hS1 _ |> fun ⟨ a2, ha2, hQa2, hS2, hfin2 ⟩ => ⟨ a2, ha2, hQa2, hS2, hfin2.trans ( by simp +decide [ hfin1 ] ) ⟩;
    rintro rfl; simp_all +decide ;
  generalize_proofs at *;
  obtain ⟨S2, hS2, hfin2⟩ : ∃ S2 : Submodule ℝ A, IsUnitalSubalgebra Q S2 ∧ Module.finrank ℝ S2 = 4 ∧ ∃ x y : A, x ∈ S2 ∧ y ∈ S2 ∧ x * y ≠ y * x := by
    -- Let's choose any $x \in S1$ such that $conj Q x \neq x$.
    obtain ⟨x, hxS1, hx_ne⟩ : ∃ x ∈ S1, conj Q x ≠ x := by
      apply exists_conj_ne_of_one_lt_finrank Q hQ S1 hS1 (by linarith)
    generalize_proofs at *;
    obtain ⟨ u, hu, v, hv, huv ⟩ := doubled_not_commutative Q hQ S1 hS1 a2 ha2 hQa2 x hxS1 hx_ne
    generalize_proofs at *;
    exact ⟨ _, hS2, hfin2, u, v, hu, hv, huv ⟩
  generalize_proofs at *;
  obtain ⟨a3, ha3, hQa3, hS3, hfin3⟩ : ∃ a3 : A, OrthogonalTo Q S2 a3 ∧ Q a3 ≠ 0 ∧ IsUnitalSubalgebra Q (doubledSubmodule S2 a3) ∧ Module.finrank ℝ (doubledSubmodule S2 a3) = 8 := by
    have := ladder_step Q hQ S2 hS2 (by
    rintro rfl; simp_all +decide ;)
    generalize_proofs at *;
    exact ⟨ this.choose, this.choose_spec.1, this.choose_spec.2.1, this.choose_spec.2.2.1, this.choose_spec.2.2.2.trans ( by simp +decide [ hfin2.1 ] ) ⟩
  generalize_proofs at *;
  obtain ⟨S3, hS3, hfin3⟩ : ∃ S3 : Submodule ℝ A, IsUnitalSubalgebra Q S3 ∧ Module.finrank ℝ S3 = 8 ∧ ∃ x y z : A, x ∈ S3 ∧ y ∈ S3 ∧ z ∈ S3 ∧ (x * y) * z ≠ x * (y * z) := by
    grind +suggestions
  generalize_proofs at *;
  -- If $S3$ is proper, then there exists $b \neq 0$ orthogonal to $S3$.
  obtain ⟨b, hb⟩ : ∃ b : A, b ≠ 0 ∧ OrthogonalTo Q S3 b := by
    apply exists_orthogonal_ne_zero Q hQ S3 (by
    rintro rfl; simp_all +decide ;)
  generalize_proofs at *;
  -- Since $b$ is orthogonal to $S3$, we have $Q(b) \neq 0$.
  have hQb : Q b ≠ 0 := by
    exact fun h => hb.1 ( hQ.anisotropic b h )
  generalize_proofs at *;
  obtain ⟨ x, y, z, hx, hy, hz, h ⟩ := hfin3.2;
  exact h ( orthogonal_forces_associative Q hQ S3 hS3 b hb.2 hQb x y z hx hy hz )

end HurwitzToolkit
