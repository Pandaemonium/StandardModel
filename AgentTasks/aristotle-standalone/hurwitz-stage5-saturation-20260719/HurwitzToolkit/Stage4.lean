import HurwitzToolkit.Stage2

/-!
# Hurwitz stage 4a: the doubled submodule is a unital subalgebra of twice
# the dimension, and proper subalgebras admit orthogonal doubling elements

Target statements for the Aristotle job `hurwitz-stage4a-20260718`.
Source: Springer-Veldkamp Ch. 1 / Baez math/0105155 sec 2.2 lineage,
clean-room; statements are original to this campaign.

Dependencies note (IMPORTANT, pre-registered): `Stage2.lean` currently has
two documented holes (`associator_mul_right`, `mul_right_moufang`; a separate
job is closing them).  The stage-4a targets split by hole-dependence:

* `doubledSubmodule_mem_iff`, `conj_doubled_mem`, and
  `exists_orthogonal_ne_zero` must be proved WITHOUT the holed lemmas
  (their proofs need only stage-1 toolkit identities and linear algebra).
* `doubled_isUnitalSubalgebra`, `doubled_inf_map_eq_bot`, and
  `finrank_doubled` may use the stage-2 doubling theorems
  (`doubling_product`, `doubling_closed`, `doubling_norm`), which currently
  inherit the Moufang holes; that inheritance is accepted and tracked.

Do not weaken statements.  If a statement needs an extra hypothesis (e.g.
finite-dimensionality where it is not yet assumed), add the hypothesis
explicitly, keep the rest exact, and record the addition prominently in the
docstring.  Every `s o r r y` below is a documented handoff hole.
-/

namespace HurwitzToolkit

variable {A : Type*} [NonAssocRing A] [Module ℝ A]
  [SMulCommClass ℝ A A] [IsScalarTower ℝ A A] [Nontrivial A]

open QuadraticMap

/-- The internal Cayley-Dickson double `S + S * a` as a submodule. -/
def doubledSubmodule (S : Submodule ℝ A) (a : A) : Submodule ℝ A :=
  S ⊔ S.map (LinearMap.mulRight ℝ a)

/-
Membership in the double is exactly the `x + y * a` decomposition shape
used by the stage-2 theorems.
-/
theorem doubledSubmodule_mem_iff (S : Submodule ℝ A) (a : A) (u : A) :
    u ∈ doubledSubmodule S a ↔ ∃ x ∈ S, ∃ y ∈ S, u = x + y * a := by
  simp +decide [ doubledSubmodule, Submodule.mem_sup ];
  grind

/-
Conjugation preserves the double: `conj Q (x + y * a) = conj Q x - y * a`
for `x, y` in `S` and `a` orthogonal to `S` (in particular the double is
conjugation-closed).  Hole-independent target.
-/
theorem conj_doubled_mem (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (u : A) (hu : u ∈ doubledSubmodule S a) :
    conj Q u ∈ doubledSubmodule S a := by
  obtain ⟨ x, hx, y, hy, rfl ⟩ := doubledSubmodule_mem_iff S a u |>.1 hu;
  -- By definition of conjugation, we have:
  have h_conj_def : conj Q (x + y * a) = conj Q x - y * a := by
    -- Since $a$ is orthogonal to $S$, we have $polar Q (y * a) 1 = 0$.
    have h_polar_zero : polar Q (y * a) 1 = 0 := by
      rw [ polar_comm ];
      apply polar_mul_orthogonal Q hQ S hS a ha 1 y (by
      exact hS.one_mem) hy;
    simp +decide [ conj, h_polar_zero ];
    rw [ sub_add_eq_sub_sub ];
  rw [h_conj_def];
  exact Submodule.sub_mem _ ( Submodule.mem_sup_left ( hS.conj_mem x hx ) ) ( Submodule.mem_sup_right ( Submodule.mem_map_of_mem hy ) )

/-
**Stage-4a main target.**  The double of a unital subalgebra along an
orthogonal element is again a unital subalgebra.
-/
theorem doubled_isUnitalSubalgebra (Q : QuadraticForm ℝ A)
    (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a) :
    IsUnitalSubalgebra Q (doubledSubmodule S a) := by
  refine' ⟨ _, _, _ ⟩;
  · exact Submodule.mem_sup_left hS.one_mem;
  · intro x hx y hy;
    obtain ⟨ x₁, hx₁, x₂, hx₂, rfl ⟩ := doubledSubmodule_mem_iff S a x |>.1 hx
    obtain ⟨ y₁, hy₁, y₂, hy₂, rfl ⟩ := doubledSubmodule_mem_iff S a y |>.1 hy
    generalize_proofs at *;
    convert doubledSubmodule_mem_iff S a _ |>.2 _;
    convert doubling_closed Q hQ S hS a ha _ _ _ _ using 1;
    · exact ⟨ x₁, hx₁, x₂, hx₂, rfl ⟩;
    · exact ⟨ y₁, hy₁, y₂, hy₂, rfl ⟩;
  · exact fun x hx => conj_doubled_mem Q hQ S hS a ha x hx

/-
The two summands of the double intersect trivially when `a` is
orthogonal to `S` with `Q a ≠ 0` (norm splitting plus anisotropy).
-/
theorem doubled_inf_map_eq_bot (Q : QuadraticForm ℝ A)
    (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a) (hQa : Q a ≠ 0) :
    S ⊓ S.map (LinearMap.mulRight ℝ a) = ⊥ := by
  rw [Submodule.eq_bot_iff]
  intro x hx
  rcases hx with ⟨hxS, ⟨y, hy, hyx⟩⟩
  have hyx' : y * a = x := by simpa using hyx
  have hp : polar Q x x = 0 := by
    calc
      polar Q x x = polar Q x (y * a) := by rw [hyx']
      _ = 0 := polar_mul_orthogonal Q hQ S hS a ha x y hxS hy
  rw [QuadraticMap.polar_self, two_smul] at hp
  have hQx : Q x = 0 := by linarith
  exact hQ.anisotropic x hQx

/-
Doubling doubles the dimension: with `a` orthogonal and `Q a ≠ 0`,
`finrank (S + S a) = 2 * finrank S`.
-/
theorem finrank_doubled [FiniteDimensional ℝ A]
    (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a) (hQa : Q a ≠ 0) :
    Module.finrank ℝ (doubledSubmodule S a) = 2 * Module.finrank ℝ S := by
  -- Apply the finrank supremum/intersection formula together with doubled_inf_map_eq_bot.
  have h_finrank : Module.finrank ℝ (↥(S ⊔ S.map (LinearMap.mulRight ℝ a))) = Module.finrank ℝ S + Module.finrank ℝ (↥(S.map (LinearMap.mulRight ℝ a))) := by
    rw [ ← Submodule.finrank_sup_add_finrank_inf_eq, doubled_inf_map_eq_bot Q hQ S hS a ha hQa, finrank_bot, add_zero ];
  -- Show that the map $mulRight a$ is injective on $S$.
  have h_inj : Function.Injective (LinearMap.mulRight ℝ a ∘ₗ Submodule.subtype S) := by
    intro x y hxy
    have h_eq : x.val * a = y.val * a := by
      exact hxy;
    have := hQ.comp ( x - y ) a; simp_all +decide [ sub_mul ] ;
    exact Subtype.ext ( sub_eq_zero.mp ( hQ.anisotropic _ this ) );
  convert h_finrank using 1;
  rw [ two_mul, show Submodule.map ( LinearMap.mulRight ℝ a ) S = LinearMap.range ( LinearMap.mulRight ℝ a ∘ₗ S.subtype ) from ?_, LinearMap.finrank_range_of_inj h_inj ];
  aesop

/-
Every PROPER submodule of a finite-dimensional composition algebra
admits a nonzero orthogonal element (polar nondegeneracy); by anisotropy it
automatically has `Q a ≠ 0`.  Hole-independent target.
-/
theorem exists_orthogonal_ne_zero [FiniteDimensional ℝ A]
    (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hne : S ≠ ⊤) :
    ∃ a : A, a ≠ 0 ∧ OrthogonalTo Q S a := by
  -- By nondegeneracy of the bilinear form, the orthogonal complement of $S$ is nontrivial.
  have h_orthogonal_complement_nontrivial : ¬(∀ a : A, (∀ x ∈ S, (polar Q x a = 0)) → a = 0) := by
    intro h_contra;
    have h_orthogonal_complement_nontrivial : LinearMap.ker (show (A →ₗ[ℝ] (S →ₗ[ℝ] ℝ)) from { toFun := fun a => { toFun := fun x => polar Q x a, map_add' := fun x y => by
                                                                                                                    simp +decide [ polar_add_left ], map_smul' := fun c x => by
                                                                                                                    simp +decide [ polar, QuadraticMap.map_smul ];
                                                                                                                    have := Q.polar_smul_left c ( x : A ) a; simp +decide [ polar ] at this;
                                                                                                                    rw [ ← this, Q.map_smul ] ; ring;
                                                                                                                    norm_num ; ring }, map_add' := fun a b => by
                                                                                                                    ext x; simp +decide [ polar_add_right ] ;, map_smul' := fun c a => by
                                                                                                                    ext x; simp +decide [ polar ] ;
                                                                                                                    simp +decide [ polar, QuadraticMap.map_smul ];
                                                                                                                    convert Q.polar_smul_right c x a using 1 ; ring;
                                                                                                                    simp +decide [ polar, QuadraticMap.map_smul ] ; ring }) = ⊥ := by
                                                                                                                    exact LinearMap.ker_eq_bot'.mpr fun x hx => h_contra x fun y hy => by simpa using congr_arg ( fun f => f ⟨ y, hy ⟩ ) hx;
    have h_orthogonal_complement_nontrivial : Module.finrank ℝ A ≤ Module.finrank ℝ (S →ₗ[ℝ] ℝ) := by
      apply_rules [ LinearMap.finrank_le_finrank_of_injective ];
      all_goals exact LinearMap.ker_eq_bot.mp h_orthogonal_complement_nontrivial;
    simp +decide [ Module.finrank_linearMap ] at h_orthogonal_complement_nontrivial;
    exact hne ( Submodule.eq_top_of_finrank_eq ( le_antisymm ( Submodule.finrank_le _ ) h_orthogonal_complement_nontrivial ) );
  exact by push_neg at h_orthogonal_complement_nontrivial; tauto;

/-
Convenience corollary packaging the ladder step: a proper unital
subalgebra of a finite-dimensional composition algebra doubles to a unital
subalgebra of exactly twice its dimension.
-/
theorem ladder_step [FiniteDimensional ℝ A]
    (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S) (hne : S ≠ ⊤) :
    ∃ a : A, OrthogonalTo Q S a ∧ Q a ≠ 0 ∧
      IsUnitalSubalgebra Q (doubledSubmodule S a) ∧
      Module.finrank ℝ (doubledSubmodule S a) = 2 * Module.finrank ℝ S := by
  obtain ⟨a, hane, ha⟩ := exists_orthogonal_ne_zero Q hQ S hne
  have hQa : Q a ≠ 0 := fun h => hane (hQ.anisotropic a h)
  exact ⟨a, ha, hQa, doubled_isUnitalSubalgebra Q hQ S hS a ha,
    finrank_doubled Q hQ S hS a ha hQa⟩

end HurwitzToolkit
