import PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace

/-!
# Rank-four no-go for fully symmetric scalar vertex probes

A complete or edgeless finite graph admits every vertex permutation as an
automorphism. Any canonical projector on its scalar vertex-probe module must
therefore commute with the natural permutation action. The theorem below
classifies such an idempotent through its constant and zero-sum sectors and
proves that its possible range dimensions are `0`, `1`, `n - 1`, and `n`.
For at least six vertices, rank four is impossible.

This complements the exact five-event antichain control in
`IntrinsicProbeSubspace.lean`, where the canonical zero-sum sector does have
rank four. That rank is a carrier-cardinality exception, not a stable
reconstruction across refinements. The no-go applies only to the natural
scalar vertex-probe representation under full permutation symmetry. It does
not rule out asymmetric graph classes, equivariant decorations, edge or
cochain probes, spin-frame data, or richer local representations.

Claim grade: `M [orig/comp]`. Provenance: the unchanged Mathlib-only theorem
statement and proof were returned by Aristotle project
`f523fa23-14ad-4bdb-b5f7-f35a6cb6b47c` and verified locally before this
project-facing integration.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.BareGraphPermutationProjectorNoGo

/-- The natural action of a permutation on real-valued vertex probes. -/
def permuteCoordinates {n : Nat} (sigma : Equiv.Perm (Fin n)) :
    (Fin n -> Real) ≃ₗ[Real] (Fin n -> Real) where
  toFun x i := x (sigma.symm i)
  invFun x i := x (sigma i)
  left_inv x := by
    funext i
    simp
  right_inv x := by
    funext i
    simp
  map_add' x y := by
    rfl
  map_smul' c x := by
    rfl

/-- A vertex-probe endomorphism is fully permutation-equivariant when it
commutes with every coordinate permutation. -/
def IsFullyPermutationEquivariant {n : Nat}
    (P : (Fin n -> Real) →ₗ[Real] (Fin n -> Real)) : Prop :=
  forall sigma : Equiv.Perm (Fin n),
    P.comp (permuteCoordinates sigma).toLinearMap =
      (permuteCoordinates sigma).toLinearMap.comp P

set_option maxHeartbeats 1000000 in
/-- No fully permutation-equivariant idempotent on the natural real vertex
probe module can have rank four once there are at least six vertices. -/
theorem no_rank_four_fully_permutation_equivariant_idempotent
    {n : Nat} (hn : 6 <= n)
    (P : (Fin n -> Real) →ₗ[Real] (Fin n -> Real))
    (hP : P.comp P = P)
    (hequiv : IsFullyPermutationEquivariant P) :
    Module.finrank Real (LinearMap.range P) ≠ 4 := by
  obtain ⟨a, b, hP_coeff⟩ :
      ∃ a b : ℝ, ∀ i j : Fin n,
        (P (Pi.single j 1)) i = if i = j then a else b := by
    have hP_coeff :
        ∀ sigma : Equiv.Perm (Fin n), ∀ i j : Fin n,
          (P (Pi.single (sigma j) 1)) (sigma i) =
            (P (Pi.single j 1)) i := by
      intro sigma i j
      specialize hequiv sigma
      replace hequiv := LinearMap.congr_fun hequiv (Pi.single j 1)
      simp_all +decide [funext_iff, LinearMap.ext_iff]
      convert hequiv (sigma i) using 1
      · congr! 2
        ext
        simp [permuteCoordinates]
        rw [Pi.single_apply, Pi.single_apply]
        aesop
      · unfold permuteCoordinates
        aesop
    use P (Pi.single ⟨0, by linarith⟩ 1) ⟨0, by linarith⟩,
      P (Pi.single ⟨1, by linarith⟩ 1) ⟨0, by linarith⟩
    intro i j
    split_ifs with hij
    · have := hP_coeff (Equiv.swap ⟨0, by linarith⟩ j)
        ⟨0, by linarith⟩ ⟨0, by linarith⟩
      aesop
    · obtain ⟨sigma, hsigma⟩ :
          ∃ sigma : Equiv.Perm (Fin n),
            sigma ⟨0, by linarith⟩ = i ∧ sigma ⟨1, by linarith⟩ = j := by
        obtain ⟨sigma, hsigma⟩ :
            ∃ sigma : Equiv.Perm (Fin n), sigma ⟨0, by linarith⟩ = i := by
          exact ⟨Equiv.swap ⟨0, by linarith⟩ i, by simp +decide⟩
        use sigma * Equiv.swap ⟨1, by linarith⟩ (sigma.symm j)
        simp +decide [*, Equiv.swap_apply_def]
        grind
      grind
  have hP_decomp :
      ∀ x : Fin n -> ℝ,
        P x = (a - b) • x + b • (fun _ => ∑ j, x j) := by
    intro x
    ext i
    have := congr_arg (fun f => f i)
      (show P x = ∑ j, x j • P (Pi.single j 1) from by
        convert P.pi_apply_eq_sum_univ x using 1
        exact Finset.sum_congr rfl fun _ _ => by
          congr
          ext
          aesop)
    simp_all +decide [Finset.mul_sum _ _ _, mul_comm]
    simp +decide [Finset.sum_ite, Finset.filter_eq, Finset.filter_ne]
    ring_nf
  have hP_scalars :
      (a + (n - 1) * b = 0 ∨ a + (n - 1) * b = 1) ∧
        (a - b = 0 ∨ a - b = 1) := by
    have hP_scalars : ∀ x : Fin n -> ℝ, P (P x) = P x := by
      exact fun x => LinearMap.congr_fun hP x
    simp_all +decide [funext_iff]
    have := hP_scalars (fun _ => 1) ⟨0, by linarith⟩
    have := hP_scalars
      (fun i => if i = ⟨0, by linarith⟩ then 1 else 0) ⟨0, by linarith⟩
    norm_num [Finset.sum_ite, Finset.filter_eq', Finset.filter_ne'] at *
    norm_num [Finset.sum_add_distrib, Finset.sum_ite, Finset.filter_eq',
      Finset.filter_ne'] at this
    exact ⟨
      Classical.or_iff_not_imp_left.2 fun h =>
        mul_left_cancel₀ (sub_ne_zero_of_ne h) <| by
          nlinarith [(by norm_cast : (6 : ℝ) ≤ n)],
      Classical.or_iff_not_imp_left.2 fun h =>
        mul_left_cancel₀ (sub_ne_zero_of_ne h) <| by
          nlinarith [(by norm_cast : (6 : ℝ) ≤ n)]⟩
  have hP_range :
      P.range =
        if a + (n - 1) * b = 0 ∧ a - b = 0 then ⊥
        else if a + (n - 1) * b = 1 ∧ a - b = 0 then
          Submodule.span ℝ {fun _ => 1}
        else if a + (n - 1) * b = 0 ∧ a - b = 1 then
          LinearMap.ker
            (show (Fin n -> ℝ) →ₗ[ℝ] ℝ from ∑ j, LinearMap.proj j)
        else ⊤ := by
    split_ifs <;> simp_all +decide [Submodule.eq_bot_iff, Submodule.eq_top_iff']
    · exact fun x => Or.inl (by
        nlinarith [show (n : ℝ) ≥ 6 by norm_cast])
    · ext
      simp [hP_decomp]
      simp +decide [funext_iff, Submodule.mem_span_singleton]
      constructor <;> rintro ⟨y, hy⟩
      · exact ⟨_, hy⟩
      · use fun _ => y / (n * b)
        simp +decide [← hy]
        grind +qlia
    · ext x
      simp [hP_decomp]
      constructor
      · rintro ⟨y, rfl⟩
        norm_num [Finset.sum_add_distrib, Finset.mul_sum _ _ _]
        ring_nf
        norm_num [← Finset.mul_sum _ _ _, ← Finset.sum_mul]
        cases lt_or_ge (∑ j : Fin n, y j) 0 <;>
          nlinarith [(by norm_cast : (6 : ℝ) ≤ n)]
      · exact fun hx => ⟨x, by ext i; simp +decide [hx]⟩
    · cases hP_scalars.1 <;> cases hP_scalars.2 <;> simp_all +decide
      norm_num [show b = 0 by
        nlinarith [show (n : ℝ) ≥ 6 by norm_cast]] at *
  split_ifs at hP_range
  · rw [hP_range, finrank_bot]
    norm_num
  · rw [hP_range, finrank_span_singleton] <;> norm_num
    exact fun h => by simpa using congr_fun h ⟨0, by linarith⟩
  · rw [hP_range]
    have := LinearMap.finrank_range_add_finrank_ker
      (∑ j : Fin n, LinearMap.proj j : (Fin n -> ℝ) →ₗ[ℝ] ℝ)
    norm_num at *
    linarith [show Module.finrank ℝ
      (LinearMap.range
        (∑ j : Fin n, LinearMap.proj j : (Fin n -> ℝ) →ₗ[ℝ] ℝ)) ≤ 1 by
      exact le_trans (Submodule.finrank_le _) (by norm_num)]
  · rw [hP_range, finrank_top]
    norm_num
    linarith [show (n : ℝ) ≥ 6 by norm_cast]

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.BareGraphPermutationProjectorNoGo.no_rank_four_fully_permutation_equivariant_idempotent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.BareGraphPermutationProjectorNoGo.no_rank_four_fully_permutation_equivariant_idempotent

end PhysicsSM.Draft.NullEdge.BareGraphPermutationProjectorNoGo
