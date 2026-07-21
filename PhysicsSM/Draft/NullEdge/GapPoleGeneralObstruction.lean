import Mathlib

/-!
# General gap-pole obstruction (Opus, verified Aristotle 4379be17)

Upgrades `GapPoleResponseObstruction` from a single 2x2 witness to arbitrary finite
dimension - commissioned precisely because the docstring audit `364a29ac` found the
single witness could not support a general claim.

Proved: `weight_map`, the exact covariance `weight (U S) v = weight S (U-inverse v)`;
`spectrum_unitary_conjugate`; `weight_attains_zero_and_one` - for EVERY nonzero
proper subspace and fixed unit vector, unitary placements attaining physical weights
1 and 0 in ARBITRARY finite dimension; `spectrum_does_not_determine_physical_weight`;
and `eigenvalue_weight_obstruction` specializing to a lambda-eigenspace. Supporting
transitivity of the unitary group on unit vectors is proved too.

HONEST READING (per audit 364a29ac, and NOT to be inflated): what is now general is
that the SPECTRUM does not determine this observable-relative WEIGHT - the readout
depends on the physical-sector embedding, and both extreme values are attainable at
fixed spectrum in every finite dimension. This is a well-posedness obstruction for a
spectrum -> weight map. It is still NOT the physical claim that a mass gap fails to
determine a physical mass, and it constructs no propagator zero.

SCOPE: the requested full-interval `[0,1]` statement was NOT proved; the delivered
form is attainment of both 0 and 1.

Provenance: verified at pin from task 474692a9. Standard three. Grade M, [orig]. -/

open scoped ComplexConjugate
open scoped InnerProductSpace

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace GapWeightObstruction

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
  [FiniteDimensional ℂ E]

/-
The unitary group acts transitively on the unit sphere of a nonzero finite-dimensional
complex inner-product space.
-/
theorem exists_unitary_sending_unit_vector [Nontrivial E]
    {x y : E} (hx : ‖x‖ = 1) (hy : ‖y‖ = 1) :
    ∃ U : E ≃ₗᵢ[ℂ] E, U x = y := by
  revert x y;
  -- Extend each singleton unit vector x and y to an orthonormal basis, then compose their coordinate linear isometry equivalences to map x to y.
  have h_orthonormal_basis : ∀ (x : E), ‖x‖ = 1 → ∃ basis : OrthonormalBasis (Fin (Module.finrank ℂ E)) ℂ E, basis ⟨0, Module.finrank_pos⟩ = x := by
    intro x hx
    have h_orthonormal : ∃ basis : OrthonormalBasis (Fin (Module.finrank ℂ E)) ℂ E, basis ⟨0, Module.finrank_pos⟩ = x := by
      have h_subspace : ∃ (W : Submodule ℂ E), W = (Submodule.span ℂ {x})ᗮ ∧ Module.finrank ℂ W = Module.finrank ℂ E - 1 := by
        have := Submodule.finrank_add_finrank_orthogonal ( Submodule.span ℂ { x } );
        rw [ ← this, finrank_span_singleton ] <;> aesop
      obtain ⟨ W, hW₁, hW₂ ⟩ := h_subspace
      have h_orthonormal_basis : ∃ basis : OrthonormalBasis (Fin (Module.finrank ℂ W)) ℂ W, True := by
        exact ⟨ by exact ( stdOrthonormalBasis ℂ W ), trivial ⟩;
      obtain ⟨ basis, _ ⟩ := h_orthonormal_basis;
      have h_combined_basis : ∃ basis : OrthonormalBasis (Fin (Module.finrank ℂ E)) ℂ E, basis ⟨0, Module.finrank_pos⟩ = x := by
        have h_combined_basis : ∃ basis : OrthonormalBasis (Fin (Module.finrank ℂ W + 1)) ℂ E, basis ⟨0, Nat.succ_pos (Module.finrank ℂ W)⟩ = x := by
          refine' ⟨ _, _ ⟩;
          refine' OrthonormalBasis.mk _ _;
          use Fin.cons x ( fun i => basis i );
          all_goals simp_all +decide [ Orthonormal, Fin.forall_fin_succ ];
          · simp_all +decide [ Pairwise, Fin.forall_fin_succ ];
            refine' ⟨ _, _, _ ⟩;
            · exact fun i => basis.orthonormal.1 i;
            · intro i hi; have := basis i |>.2; simp_all +decide [ Submodule.mem_orthogonal' ] ;
              simpa [ inner_eq_zero_symm ] using this x ( Submodule.mem_span_singleton_self x );
            · intro i; have := basis.orthonormal; simp_all +decide [ orthonormal_iff_ite ] ;
              have := basis i |>.2; simp_all +decide [ Submodule.mem_orthogonal' ] ;
          · have h_combined_basis : Submodule.span ℂ (insert x (Set.range (fun i => basis i : Fin (Module.finrank ℂ W) → E))) = Submodule.span ℂ {x} ⊔ W := by
              rw [ Submodule.span_insert ];
              refine' congr_arg₂ _ rfl ( le_antisymm _ _ );
              · exact Submodule.span_le.mpr ( Set.range_subset_iff.mpr fun i => basis i |>.2 );
              · intro w hw;
                have := basis.sum_repr ⟨ w, hw ⟩;
                rw [ Submodule.mem_span_range_iff_exists_fun ];
                exact ⟨ _, by simpa [ Subtype.ext_iff ] using this ⟩;
            rw [ h_combined_basis, hW₁ ];
            exact Submodule.sup_orthogonal_of_hasOrthogonalProjection
        convert h_combined_basis; all_goals rw [ hW₂, Nat.sub_add_cancel ( Module.finrank_pos ) ];
      exact h_combined_basis;
    exact h_orthonormal;
  intro x y hx hy; obtain ⟨ basis_x, hx' ⟩ := h_orthonormal_basis x hx; obtain ⟨ basis_y, hy' ⟩ := h_orthonormal_basis y hy; use basis_x.repr.trans basis_y.repr.symm; aesop;

/-
A finite-dimensional nonzero subspace contains a unit vector.
-/
omit [FiniteDimensional ℂ E] in
theorem Submodule.exists_unit_vector (S : Submodule ℂ E) (hS : S ≠ ⊥) :
    ∃ x : E, x ∈ S ∧ ‖x‖ = 1 := by
  obtain ⟨ x, hx, hx' ⟩ := S.ne_bot_iff.mp hS;
  exact ⟨ ‖x‖⁻¹ • x, S.smul_mem _ hx, by simp +decide [ norm_smul, hx' ] ⟩

/-
A proper finite-dimensional subspace has a unit vector in its orthogonal complement.
-/
theorem Submodule.exists_orthogonal_unit_vector (S : Submodule ℂ E) (hS : S ≠ ⊤) :
    ∃ x : E, x ∈ Sᗮ ∧ ‖x‖ = 1 := by
  by_cases hS_bot : Sᗮ = ⊥
  · exact False.elim (hS (eq_top_iff.mpr fun x _ => by simp_all +decide))
  · exact Submodule.exists_unit_vector Sᗮ hS_bot

/-- The eigenspace of a continuous operator at `lambda`. -/
def eigenspace (H : E →L[ℂ] E) (lambda : ℂ) : Submodule ℂ E :=
  Module.End.eigenspace (H.toLinearMap : Module.End ℂ E) lambda

/-- The physical weight attached to a subspace (in particular, an eigenspace). -/
noncomputable def weight (S : Submodule ℂ E) (v : E) : ℂ :=
  inner ℂ v (S.starProjection v)

/-
Exact covariance of a physical projection weight under a unitary change of basis:
the transformed weight at `v` is the original weight in direction `U⁻¹v`.
-/
theorem weight_map (S : Submodule ℂ E) (U : E ≃ₗᵢ[ℂ] E) (v : E) :
    weight (S.map U.toLinearEquiv.toLinearMap) v = weight S (U.symm v) := by
  unfold weight
  conv_lhs => lhs; rw [← U.apply_symm_apply v]
  rw [Submodule.starProjection_map_apply]
  exact U.inner_map_map _ _


/-- The continuous unitary operator represented by a linear isometric equivalence. -/
noncomputable def unitaryOperator (U : E ≃ₗᵢ[ℂ] E) : unitary (E →L[ℂ] E) :=
  Unitary.linearIsometryEquiv.symm U

/-- Unitary conjugation of an operator. -/
noncomputable def unitaryConjugate (U : E ≃ₗᵢ[ℂ] E) (H : E →L[ℂ] E) : E →L[ℂ] E :=
  (unitaryOperator U : E →L[ℂ] E) * H * star (unitaryOperator U : E →L[ℂ] E)

/-
Unitary conjugation does not change the spectrum.  No self-adjointness assumption is
needed for this algebraic fact.
-/
theorem spectrum_unitary_conjugate (H : E →L[ℂ] E)
    (U : unitary (E →L[ℂ] E)) :
    spectrum ℂ ((U : E →L[ℂ] E) * H * star (U : E →L[ℂ] E)) = spectrum ℂ H := by
  exact Unitary.spectrum_star_right_conjugate

/-
A nonzero proper eigenspace can be unitarily positioned so that a fixed unit physical
vector has weight one, and can also be positioned so that it has weight zero.  Thus this
holds in every dimension and every multiplicity strictly between zero and the ambient
one.
-/
theorem weight_attains_zero_and_one [Nontrivial E]
    (S : Submodule ℂ E) (hS0 : S ≠ ⊥) (hS1 : S ≠ ⊤)
    (v : E) (hv : ‖v‖ = 1) :
    (∃ U : E ≃ₗᵢ[ℂ] E, weight (S.map U.toLinearEquiv.toLinearMap) v = 1) ∧
    (∃ U : E ≃ₗᵢ[ℂ] E, weight (S.map U.toLinearEquiv.toLinearMap) v = 0) := by
  constructor;
  · obtain ⟨ x, hxS, hx ⟩ := Submodule.exists_unit_vector S hS0;
    obtain ⟨ U, hU ⟩ := exists_unitary_sending_unit_vector hx hv;
    refine' ⟨ U, _ ⟩;
    rw [ ← hU, weight_map ];
    simp +decide [weight]
    rw [ Submodule.starProjection_eq_self_iff.mpr hxS, inner_self_eq_norm_sq_to_K ] ; aesop;
  · -- Choose a unit vector $y \in S^\perp$.
    obtain ⟨y, hy⟩ : ∃ y : E, y ∈ Sᗮ ∧ ‖y‖ = 1 := by
      apply_rules [ Submodule.exists_orthogonal_unit_vector ];
    -- Obtain U with U y = v.
    obtain ⟨U, hU⟩ : ∃ U : E ≃ₗᵢ[ℂ] E, U y = v := by
      apply exists_unitary_sending_unit_vector hy.2 hv;
    -- Then $U^{-1} v = y$, so $\langle U^{-1} v, S.starProjection (U^{-1} v) \rangle = \langle y, S.starProjection y \rangle = 0$.
    have hUy : U.symm v = y := by simpa [hU] using U.symm_apply_apply y
    have hproj : S.starProjection y = 0 := by
      change y ∈ S.starProjection.ker
      rw [Submodule.ker_starProjection]
      exact hy.1
    have h_zero : inner ℂ (U.symm v) (S.starProjection (U.symm v)) = 0 := by
      rw [hUy, hproj, inner_zero_right]
    exact ⟨ U, by rw [ weight_map ] ; exact h_zero ⟩

/-
The general gap-does-not-fix-pole obstruction, stated without choosing a particular
matrix: among operators with the same unitary-conjugacy-invariant spectral data, the
physical weight at any eigenspace of multiplicity strictly between `0` and `finrank ℂ E`
is not determined.  The two witnesses may always be chosen with weights `1` and `0`.
-/
theorem spectrum_does_not_determine_physical_weight [Nontrivial E]
    (H : E →L[ℂ] E) (S : Submodule ℂ E) (hS0 : S ≠ ⊥) (hS1 : S ≠ ⊤)
    (v : E) (hv : ‖v‖ = 1) :
    ∃ U₁ U₀ : E ≃ₗᵢ[ℂ] E,
      spectrum ℂ (unitaryConjugate U₁ H) = spectrum ℂ H ∧
      spectrum ℂ (unitaryConjugate U₀ H) = spectrum ℂ H ∧
      weight (S.map U₁.toLinearEquiv.toLinearMap) v = 1 ∧
      weight (S.map U₀.toLinearEquiv.toLinearMap) v = 0 := by
  obtain ⟨⟨U₁, hU₁⟩, U₀, hU₀⟩ := weight_attains_zero_and_one S hS0 hS1 v hv
  exact ⟨U₁, U₀, Unitary.spectrum_star_right_conjugate,
    Unitary.spectrum_star_right_conjugate, hU₁, hU₀⟩


/-- Eigenvalue-specialized form: whenever the `lambda`-eigenspace is nonzero and proper
(equivalently, its multiplicity is strictly between zero and the ambient dimension),
two unitary conjugates have the same spectrum as `H` but physical `lambda`-weights
`1` and `0`. -/
theorem eigenvalue_weight_obstruction [Nontrivial E]
    (H : E →L[ℂ] E) (lambda : ℂ)
    (h0 : eigenspace H lambda ≠ ⊥) (h1 : eigenspace H lambda ≠ ⊤)
    (v : E) (hv : ‖v‖ = 1) :
    ∃ U₁ U₀ : E ≃ₗᵢ[ℂ] E,
      spectrum ℂ (unitaryConjugate U₁ H) = spectrum ℂ H ∧
      spectrum ℂ (unitaryConjugate U₀ H) = spectrum ℂ H ∧
      weight ((eigenspace H lambda).map U₁.toLinearEquiv.toLinearMap) v = 1 ∧
      weight ((eigenspace H lambda).map U₀.toLinearEquiv.toLinearMap) v = 0 := by
  exact spectrum_does_not_determine_physical_weight H (eigenspace H lambda) h0 h1 v hv

end GapWeightObstruction
