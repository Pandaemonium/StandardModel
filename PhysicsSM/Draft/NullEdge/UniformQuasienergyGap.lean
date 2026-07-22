import Mathlib

/-!

WAVE-3 AUDIT CORRECTION (2026-07-21, job `6ea8b5f0`, witnesses in
`MassLandingsAuditWave3`). The `[Nonempty K]` instance is **semantically load-bearing, not
boilerplate**: over `Empty` every gap function vacuously admits a positive uniform lower
bound (`AuditWitnesses.empty_parameter_uniform_margin`). A uniform margin has content only
once the parameter space is inhabited
(`AuditWitnesses.uniform_margin_has_pointwise_content`). Do not present the `Nonempty`
hypothesis as a technicality, and do not drop it in any restatement.
# Compactness upgrade: pointwise no-crossing implies a uniform quasienergy gap

Audit-driven strengthening of the AFPL HNU headline
`HNUMassiveGlobalGap.massiveHNU_zero_pi_gap`, which proves that a continuous
family of `4 x 4` unitaries over the compact Brillouin cube has
`det (U k - 1) ≠ 0` and `det (U k + 1) ≠ 0` for every `k` (no zero/pi
quasienergy crossing, POINTWISE). Independent review (Opus, 2026-07-20) noted
that over a compact parameter space, continuity plus exact unitarity upgrade
this to a UNIFORM spectral-gap margin. This module states that abstract upgrade,
which is Mathlib-only and composes with the landed HNU theorem.

Intended reading: `μ` is an eigenvalue of `U k` iff `det (U k - μ • 1) = 0`.
For a unitary `U k` every eigenvalue lies on the unit circle, so
`‖μ - 1‖ ≤ 2` and `det (U k - 1) = ∏ (μ_j - 1)` over the eigenvalues gives
`‖μ - 1‖ ≥ |det (U k - 1)| / 2^(m-1)`. Compactness makes `|det (U k ∓ 1)|`
bounded below by some `δ₀ > 0`, so every eigenvalue is bounded away from `+1`
and `-1` uniformly.

Proof plan (for the prover):
1. `k ↦ (U k - 1).det` and `k ↦ (U k + 1).det` are continuous (det is
   continuous, `U` is continuous); their norms are continuous and nowhere zero
   on the compact `K`, so each attains a positive minimum
   (`IsCompact.exists_isMinOn` / `Continuous.exists_forall_le` on `univ`),
   giving `δ₀ > 0` with `δ₀ ≤ ‖(U k - 1).det‖` and `δ₀ ≤ ‖(U k + 1).det‖`.
2. For fixed `k`, if `det (U k - μ • 1) = 0` then `μ` is a root of the
   characteristic polynomial, so `(U k - 1).det = ∏_j (μ_j - 1)` over the
   eigenvalues (with multiplicity) and `μ` is one of the `μ_j`. Unitarity gives
   `‖μ_j - 1‖ ≤ 2`, so `‖μ - 1‖ ≥ ‖(U k - 1).det‖ / 2^(m-1) ≥ δ₀ / 2^(m-1)`.
   Symmetrically for `+1`.
3. Take `δ = δ₀ / 2^(m-1)`.

If the eigenvalue-product route is heavy, the acceptable fallback is to prove
the theorem for `m = 4` concretely (the HNU case) and report the general-`m`
lemma (`det (U - 1) = ∏ (eigenvalue - 1)` for a matrix over `ℂ`) as the one
missing ingredient.
-/

namespace PhysicsSM.Draft.NullEdge.UniformQuasienergyGap

open Matrix

set_option maxHeartbeats 1000000 in
/-- **Uniform quasienergy gap from pointwise no-crossing.**  A continuous family
of `m x m` unitaries over a nonempty compact parameter space with no zero and no
pi crossing anywhere has a single uniform margin `δ > 0` separating every
eigenvalue from both `+1` and `-1`.
-/
theorem uniform_quasienergy_gap
    {K : Type*} [TopologicalSpace K] [CompactSpace K] [Nonempty K]
    {m : ℕ} (U : K → Matrix (Fin m) (Fin m) ℂ) (hcont : Continuous U)
    (hunit : ∀ k, U k ∈ Matrix.unitaryGroup (Fin m) ℂ)
    (h0 : ∀ k, (U k - 1).det ≠ 0) (hpi : ∀ k, (U k + 1).det ≠ 0) :
    ∃ δ : ℝ, 0 < δ ∧ ∀ (k : K) (μ : ℂ), (U k - μ • (1 : Matrix (Fin m) (Fin m) ℂ)).det = 0 →
      δ ≤ ‖μ - 1‖ ∧ δ ≤ ‖μ + 1‖ := by
  -- Use compactness to obtain a positive lower bound for norms of det(U k - 1) and det(U k + 1).
  obtain ⟨δ0, hδ0_pos, hδ0⟩ : ∃ δ0 > 0, ∀ k, ‖Matrix.det (U k - 1)‖ ≥ δ0 ∧ ‖Matrix.det (U k + 1)‖ ≥ δ0 := by
    -- The functions $k \mapsto \det(U k - 1)$ and $k \mapsto \det(U k + 1)$ are continuous.
    have h_cont_det : Continuous (fun k => ‖(U k - 1).det‖) ∧ Continuous (fun k => ‖(U k + 1).det‖) := by
      exact ⟨ Continuous.norm ( Continuous.matrix_det ( hcont.sub continuous_const ) ), Continuous.norm ( Continuous.matrix_det ( hcont.add continuous_const ) ) ⟩;
    -- Since $K$ is compact, the continuous functions $k \mapsto \det(U k - 1)$ and $k \mapsto \det(U k + 1)$ attain their minimum values on $K$.
    obtain ⟨k_min, hk_min⟩ : ∃ k_min : K, ∀ k : K, ‖(U k - 1).det‖ ≥ ‖(U k_min - 1).det‖ := by
      exact ( IsCompact.exists_isMinOn ( CompactSpace.isCompact_univ ) ⟨ Classical.arbitrary K, Set.mem_univ _ ⟩ h_cont_det.1.continuousOn ) |> fun ⟨ k, hk₁, hk₂ ⟩ => ⟨ k, fun k' => hk₂ ( Set.mem_univ k' ) ⟩
    obtain ⟨k_max, hk_max⟩ : ∃ k_max : K, ∀ k : K, ‖(U k + 1).det‖ ≥ ‖(U k_max + 1).det‖ := by
      exact ( IsCompact.exists_isMinOn ( CompactSpace.isCompact_univ ) ⟨ k_min, Set.mem_univ k_min ⟩ h_cont_det.2.continuousOn ) |> fun ⟨ k, hk ⟩ => ⟨ k, fun k' => hk.2 ( Set.mem_univ k' ) ⟩;
    exact ⟨ Min.min ‖ ( U k_min - 1 |> Matrix.det )‖ ‖ ( U k_max + 1 |> Matrix.det )‖, lt_min ( norm_pos_iff.mpr ( h0 k_min ) ) ( norm_pos_iff.mpr ( hpi k_max ) ), fun k => ⟨ le_trans ( min_le_left _ _ ) ( hk_min k ), le_trans ( min_le_right _ _ ) ( hk_max k ) ⟩ ⟩;
  by_cases hm : m = 0;
  · aesop;
  · -- For fixed `k`, if `det (U k - μ • 1) = 0` then `μ` is a root of the characteristic polynomial, so `(U k - 1).det = ∏_j (μ_j - 1)` over the eigenvalues (with multiplicity) and `μ` is one of the `μ_j`.
    have h_char_poly : ∀ k μ, Matrix.det (U k - μ • 1) = 0 → ∃ (ev : Fin m → ℂ), (∀ i, ‖ev i‖ = 1) ∧ Matrix.det (U k - 1) = ∏ i, (ev i - 1) ∧ Matrix.det (U k + 1) = ∏ i, (ev i + 1) ∧ μ ∈ Set.range ev := by
      intro k μ hμ
      obtain ⟨ev, hev⟩ : ∃ (ev : Fin m → ℂ), Matrix.charpoly (U k) = ∏ i, (Polynomial.X - Polynomial.C (ev i)) ∧ (∀ i, ‖ev i‖ = 1) := by
        have h_char_poly : ∃ (ev : Fin m → ℂ), Matrix.charpoly (U k) = ∏ i, (Polynomial.X - Polynomial.C (ev i)) := by
          have h_char_poly : ∃ (ev : Multiset ℂ), Matrix.charpoly (U k) = Multiset.prod (Multiset.map (fun μ => Polynomial.X - Polynomial.C μ) ev) := by
            use Polynomial.roots (Matrix.charpoly (U k));
            convert Polynomial.Splits.eq_prod_roots _;
            any_goals exact Complex.isAlgClosed.splits _;
            rw [ Matrix.charpoly_monic ] ; norm_num;
            infer_instance;
          obtain ⟨ev, hev⟩ := h_char_poly
          have h_card : Multiset.card ev = m := by
            replace hev := congr_arg Polynomial.natDegree hev ; simp_all +decide [ Matrix.charpoly_degree_eq_dim ];
          obtain ⟨ev', hev'⟩ : ∃ ev' : Fin m → ℂ, ev = Multiset.ofList (List.ofFn ev') := by
            obtain ⟨ev', hev'⟩ : ∃ ev' : List ℂ, ev = Multiset.ofList ev' ∧ ev'.length = m := by
              exact ⟨ ev.toList, by simpa, by simpa using h_card ⟩;
            use fun i => ev'[i]!;
            convert hev'.1 using 1;
            refine' congr_arg _ ( List.ext_get _ _ ) <;> simp +decide [ hev'.2 ];
          simp_all +decide [ Finset.prod ];
          exact ⟨ ev', rfl ⟩;
        obtain ⟨ev, hev⟩ := h_char_poly
        have h_eigenvalues : ∀ i, Matrix.det (U k - ev i • 1) = 0 := by
          intro i
          have h_eigenvalue : Polynomial.eval (ev i) (Matrix.charpoly (U k)) = 0 := by
            simp +decide [ hev, Finset.prod_eq_prod_diff_singleton_mul ( Finset.mem_univ i ) ];
          rw [ Matrix.det_eq_sign_charpoly_coeff ];
          simp_all +decide [ Matrix.charpoly, Matrix.det_apply' ];
          convert congr_arg ( Polynomial.eval ( ev i ) ) hev using 1;
          · simp +decide [ Polynomial.eval_finset_sum, Polynomial.eval_mul, Polynomial.eval_prod, Polynomial.eval_sub, Polynomial.eval_X, Polynomial.eval_one, Polynomial.coeff_zero_eq_eval_zero ];
            exact Finset.sum_congr rfl fun _ _ => by congr; ext; by_cases h : ‹Equiv.Perm ( Fin m ) › ‹_› = ‹_› <;> simp +decide [ h ] ;
          · exact h_eigenvalue.symm;
        have h_eigenvalues_unitary : ∀ i, ∀ v : Fin m → ℂ, v ≠ 0 → (U k).mulVec v = ev i • v → ‖ev i‖ = 1 := by
          intro i v hv hv'
          have h_unitary : star v ⬝ᵥ (U k).conjTranspose.mulVec ((U k).mulVec v) = star v ⬝ᵥ v := by
            simp_all +decide [ ← Matrix.mul_assoc, ← Matrix.ext_iff ];
            rw [ ← hv', Matrix.mulVec_mulVec ];
            have := hunit k;
            have := this.2;
            rw [ show ( U k ) ᴴ * U k = 1 from by simpa [ mul_eq_one_comm ] using this ] ; simp +decide [ Matrix.mulVec ];
          simp_all +decide [ Matrix.mulVec_smul, dotProduct_smul ];
          have h_unitary : star v ⬝ᵥ (U k)ᴴ *ᵥ v = star (ev i) * star v ⬝ᵥ v := by
            simp +decide [ Matrix.dotProduct_mulVec, Matrix.vecMul_conjTranspose, hv' ];
          simp_all +decide [ dotProduct, Complex.ext_iff ];
          simp_all +decide [ Complex.normSq, Complex.norm_def ];
          exact mul_left_cancel₀ ( show ( ∑ x : Fin m, ( ( v x |> Complex.re ) * ( v x |> Complex.re ) + ( v x |> Complex.im ) * ( v x |> Complex.im ) ) ) ≠ 0 from fun h => hv <| funext fun x => by norm_num [ Complex.ext_iff ] ; constructor <;> nlinarith only [ h ▸ Finset.single_le_sum ( fun a _ => add_nonneg ( mul_self_nonneg ( v a |> Complex.re ) ) ( mul_self_nonneg ( v a |> Complex.im ) ) ) ( Finset.mem_univ x ) ] ) <| by linarith;
        refine' ⟨ ev, hev, fun i => _ ⟩;
        obtain ⟨ v, hv ⟩ := Matrix.exists_mulVec_eq_zero_iff.mpr ( h_eigenvalues i );
        simp_all +decide [ sub_eq_iff_eq_add, Matrix.sub_mulVec ];
        simp_all +decide [ Matrix.smul_eq_diagonal_mul ];
        exact h_eigenvalues_unitary i v hv.1 hv.2;
      refine' ⟨ ev, hev.2, _, _, _ ⟩;
      · have h_det : Matrix.det (U k - 1) = Polynomial.eval 1 (Matrix.charpoly (U k)) * (-1) ^ m := by
          rw [ Matrix.det_eq_sign_charpoly_coeff ];
          simp +decide [ Matrix.charpoly, Matrix.det_apply' ];
          simp +decide [ Polynomial.eval_finset_sum, Polynomial.eval_mul, Polynomial.eval_prod, Polynomial.eval_sub, Polynomial.eval_X, Polynomial.eval_one, Polynomial.coeff_zero_eq_eval_zero ] ; ring;
          exact congrArg₂ _ ( Finset.sum_congr rfl fun _ _ => by congr; ext; by_cases h : ‹Equiv.Perm ( Fin m ) › ‹_› = ‹_› <;> simp +decide [ h ] ) rfl;
        simp_all +decide [ Polynomial.eval_prod, Finset.prod_mul_distrib ];
        rw [ ← Finset.prod_congr rfl fun _ _ => neg_sub _ _ ] ; rw [ Finset.prod_congr rfl fun _ _ => neg_eq_neg_one_mul _, Finset.prod_mul_distrib ] ; simp +decide [ hm ] ;
        ring ; aesop;
      · have h_det : Matrix.det (U k + 1) = Polynomial.eval (-1) (Matrix.charpoly (U k)) * (-1) ^ m := by
          rw [ Matrix.det_eq_sign_charpoly_coeff ];
          simp +decide [ Matrix.charpoly, Matrix.det_apply' ];
          simp +decide [ Polynomial.eval_finset_sum, Polynomial.eval_mul, Polynomial.eval_prod, Polynomial.eval_add, Polynomial.eval_X, Polynomial.eval_one, Polynomial.coeff_zero_eq_eval_zero ];
          simp +decide [ mul_comm, Matrix.charmatrix ];
          simp +decide [ Matrix.one_apply, Polynomial.eval_sub, Polynomial.eval_add, Polynomial.eval_X, Polynomial.eval_one ];
          exact Finset.sum_congr rfl fun _ _ => by congr; ext; split_ifs <;> simp +decide [ * ] ; ring;
        simp_all +decide [ Polynomial.eval_prod ];
        rw [ Finset.prod_congr rfl fun _ _ => show -1 - ev _ = ( -1 ) * ( ev _ + 1 ) by ring, Finset.prod_mul_distrib, Finset.prod_const, Finset.card_fin ] ; ring;
        norm_num [ pow_mul' ];
      · have h_char_poly : Matrix.det (U k - μ • 1) = Polynomial.eval μ (Matrix.charpoly (U k)) * (-1) ^ m := by
          rw [ Matrix.det_eq_sign_charpoly_coeff ];
          simp +decide [ Matrix.charpoly, Matrix.det_apply' ];
          simp +decide [ Polynomial.eval_finset_sum, Polynomial.eval_mul, Polynomial.eval_prod, Polynomial.eval_sub, Polynomial.eval_X, Polynomial.eval_one, Polynomial.coeff_zero_eq_eval_zero ] ; ring;
          exact congrArg₂ _ ( Finset.sum_congr rfl fun _ _ => by congr; ext; by_cases h : ‹Equiv.Perm ( Fin m ) › ‹_› = ‹_› <;> simp +decide [ h ] ) rfl;
        simp_all +decide [ Polynomial.eval_prod, Finset.prod_eq_zero_iff, sub_eq_zero ];
        tauto;
    refine' ⟨ δ0 / 2 ^ ( m - 1 ), div_pos hδ0_pos ( pow_pos zero_lt_two _ ), fun k μ hμ => _ ⟩;
    obtain ⟨ ev, hev₁, hev₂, hev₃, ⟨ i, rfl ⟩ ⟩ := h_char_poly k μ hμ;
    -- Since $|ev_i| = 1$, we have $|ev_i - 1| \leq 2$ and $|ev_i + 1| \leq 2$.
    have h_bound : ∀ i, ‖ev i - 1‖ ≤ 2 ∧ ‖ev i + 1‖ ≤ 2 := by
      exact fun i => ⟨ le_trans ( norm_sub_le _ _ ) ( by norm_num [ hev₁ i ] ), le_trans ( norm_add_le _ _ ) ( by norm_num [ hev₁ i ] ) ⟩;
    -- Using the bounds on the norms, we can derive the inequalities for the determinants.
    have h_det_bound : ‖∏ i, (ev i - 1)‖ ≤ 2 ^ (m - 1) * ‖ev i - 1‖ ∧ ‖∏ i, (ev i + 1)‖ ≤ 2 ^ (m - 1) * ‖ev i + 1‖ := by
      simp +decide [ Finset.prod_eq_prod_diff_singleton_mul ( Finset.mem_univ i ), h_bound ];
      exact ⟨ mul_le_mul_of_nonneg_right ( le_trans ( Finset.prod_le_prod ( fun _ _ => norm_nonneg _ ) fun _ _ => h_bound _ |>.1 ) ( by simp +decide [ Finset.card_sdiff, * ] ) ) ( norm_nonneg _ ), mul_le_mul_of_nonneg_right ( le_trans ( Finset.prod_le_prod ( fun _ _ => norm_nonneg _ ) fun _ _ => h_bound _ |>.2 ) ( by simp +decide [ Finset.card_sdiff, * ] ) ) ( norm_nonneg _ ) ⟩;
    exact ⟨ by rw [ div_le_iff₀' ( by positivity ) ] ; linarith [ hδ0 k, hev₂ ▸ hδ0 k |>.1 ], by rw [ div_le_iff₀' ( by positivity ) ] ; linarith [ hδ0 k, hev₃ ▸ hδ0 k |>.2 ] ⟩

end PhysicsSM.Draft.NullEdge.UniformQuasienergyGap
