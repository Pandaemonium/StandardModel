import PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelectorStability

/-!
# General finite perturbations of the rank-four selector

An arbitrary non-diagonal self-adjoint perturbation does **not** preserve the
old Lagrange projector exactly.  The five-dimensional rational example below
records this obstruction: a symmetric perturbation mixes one selected and one
unselected coordinate, so the old projector no longer commutes with the
perturbed operator.

The positive theorem proved here is the strongest finite-dimensional
projector-level statement available without importing an unformalized
Davis--Kahan theorem.  Two (not necessarily commuting or orthogonal)
finite-dimensional projections at operator-norm distance strictly less than
one have ranges of the same dimension.  Thus any genuine spectral-projector
construction or estimate which supplies `‖Q - P‖ < 1` preserves the rank-four
sector under completely non-diagonal perturbations.

The remaining analytic bridge is precisely a finite-dimensional
Davis--Kahan/Riesz estimate deriving such a projector bound from a spectral
gap and a norm bound on the underlying self-adjoint operators.  No such bridge
is assumed or claimed in this file.

Provenance: Aristotle project `cd32b70b-e8e9-48ee-b520-4722d9009b88`,
clean-room finite-dimensional formalization over Mathlib's continuous-linear-map API.
-/

open Polynomial

noncomputable section

namespace PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector

/-! ## Exact rational counterexample to unchanged projectors -/

/-- Five simple eigenvalues, with the first four forming the selected sector. -/
def counterexampleEigenvalue : Fin 5 → Real := ![0, 1, 2, 3, 10]

/-- The first four coordinates are selected and the last is complementary. -/
def counterexampleSelected : Finset (Fin 5) := {0, 1, 2, 3}

/-- A rational, genuinely off-diagonal perturbation mixing coordinates `0` and
`4`.  Its matrix has the two symmetric off-diagonal entries `1/10`. -/
def rationalMixingPerturbation : Module.End Real (Fin 5 → Real) where
  toFun v i := if i = 0 then v 4 / 10 else if i = 4 then v 0 / 10 else 0
  map_add' v w := by
    funext i
    split_ifs <;> simp_all <;> ring
  map_smul' r v := by
    funext i
    split_ifs <;> simp_all <;> ring

/-
The perturbation is symmetric for the standard real dot product.
-/
theorem rationalMixingPerturbation_symmetric (x y : Fin 5 → Real) :
    (∑ i, x i * rationalMixingPerturbation y i) =
      ∑ i, rationalMixingPerturbation x i * y i := by
  simp +decide [ rationalMixingPerturbation, Fin.sum_univ_five ] ; ring!

/-
The rational perturbation really mixes the selected coordinate `0` with
its unselected complement `4`.
-/
theorem rationalMixingPerturbation_exact_mix :
    rationalMixingPerturbation (Pi.single 4 1) 0 = (1 : Real) / 10 ∧
      rationalMixingPerturbation (Pi.single 0 1) 4 = (1 : Real) / 10 := by
  unfold rationalMixingPerturbation; simp +decide ;

/-
Exact counterexample: after the symmetric non-diagonal rational
perturbation, the old rank-four Lagrange projector does not even commute with
the perturbed operator, hence cannot remain its spectral projector.
-/
theorem old_rankFour_projector_not_unchanged :
    let P := polynomialFilter (diagonalOperator counterexampleEigenvalue)
      (selectorPolynomial counterexampleEigenvalue counterexampleSelected)
    let B := diagonalOperator counterexampleEigenvalue + rationalMixingPerturbation
    P.comp B ≠ B.comp P := by
  norm_num [ funext_iff, LinearMap.ext_iff ];
  refine' ⟨ fun i => if i = 4 then 1 else 0, 0, _ ⟩ ; simp +decide [ *, Fin.sum_univ_succ ];
  erw [ polynomialFilter_selector_eq_coordinateProjector ];
  · unfold coordinateProjector rationalMixingPerturbation diagonalOperator; simp +decide ;
  · unfold counterexampleEigenvalue; simp +decide [ Function.Injective ] ;
    norm_num [ Fin.forall_fin_succ ]

/-! ## The finite non-diagonal projector theorem -/

variable {𝕜 E : Type*} [RCLike 𝕜] [NormedAddCommGroup E] [InnerProductSpace 𝕜 E]
  [FiniteDimensional 𝕜 E]

/-
Projections less than one apart in operator norm have equally dimensional
ranges.  Orthogonality and commutativity are not required.
-/
set_option maxHeartbeats 800000 in
-- The two range-restriction arguments require heavier finite-dimensional simplification.
theorem finrank_range_eq_of_projection_norm_sub_lt_one
    (P Q : E →L[𝕜] E)
    (hP : P.comp P = P) (hQ : Q.comp Q = Q)
    (hclose : ‖Q - P‖ < 1) :
    Module.finrank 𝕜 (LinearMap.range P.toLinearMap) =
      Module.finrank 𝕜 (LinearMap.range Q.toLinearMap) := by
  refine' le_antisymm _ _;
  · -- Restrict $Q$ to $\text{range}(P)$: $x \mapsto Q(x)$.
    have h_restrict_Q : ∀ x ∈ LinearMap.range P.toLinearMap, (Q.toLinearMap) x = 0 → x = 0 := by
      intro x hx hxQ
      have hPQx : (P - Q) x = x := by
        obtain ⟨ y, rfl ⟩ := hx; simp_all +decide [ ContinuousLinearMap.ext_iff ] ;
      have := ContinuousLinearMap.le_opNorm ( P - Q ) x; simp_all +decide [ norm_sub_rev ] ;
      exact norm_le_zero_iff.mp ( by nlinarith [ norm_nonneg x ] );
    have h_restrict_Q : LinearMap.range (Q.toLinearMap.comp (Submodule.subtype (LinearMap.range P.toLinearMap))) = Submodule.map Q.toLinearMap (LinearMap.range P.toLinearMap) := by
      ext; simp [Submodule.map];
    have h_restrict_Q : Module.finrank 𝕜 (LinearMap.range (Q.toLinearMap.comp (Submodule.subtype (LinearMap.range P.toLinearMap)))) = Module.finrank 𝕜 (LinearMap.range P.toLinearMap) := by
      rw [ LinearMap.finrank_range_of_inj ];
      intro x y hxy;
      rename_i h; specialize h ( x - y ) ; simp_all +decide [ sub_eq_zero ] ;
      obtain ⟨ z, hz ⟩ := x.2; obtain ⟨ w, hw ⟩ := y.2; specialize h ( z - w ) ; simp_all +decide [ sub_eq_iff_eq_add ] ;
    exact h_restrict_Q ▸ Submodule.finrank_mono ( show LinearMap.range ( Q.toLinearMap.comp ( Submodule.subtype ( LinearMap.range P.toLinearMap ) ) ) ≤ LinearMap.range Q.toLinearMap from by aesop_cat );
  · -- Let $x \in \text{range}(Q)$. Then $Q(x) = x$. We want to show that $P(x) \neq 0$.
    have h_inj : Function.Injective (fun x : ↥(LinearMap.range Q.toLinearMap) => P x) := by
      intro x y hxy;
      -- Since $P(x) = P(y)$, we have $(Q - P)(x) = Q(x) - P(x) = x - P(x)$ and $(Q - P)(y) = Q(y) - P(y) = y - P(y)$.
      have h_eq : (Q - P) (x - y) = x - y := by
        simp_all +decide [ sub_eq_iff_eq_add, ContinuousLinearMap.ext_iff ];
        rcases x with ⟨ x, ⟨ x', hx' ⟩ ⟩ ; rcases y with ⟨ y, ⟨ y', hy' ⟩ ⟩ ; aesop;
      have := ContinuousLinearMap.le_opNorm ( Q - P ) ( x - y );
      contrapose! this;
      rw [ h_eq ] ; exact mul_lt_of_lt_one_left ( norm_pos_iff.mpr <| sub_ne_zero.mpr <| by simpa using this ) hclose;
    convert Submodule.finrank_mono ( show LinearMap.range ( P.toLinearMap.comp ( Submodule.subtype ( LinearMap.range Q.toLinearMap ) ) ) ≤ LinearMap.range P.toLinearMap from LinearMap.range_comp_le_range _ _ ) using 1;
    convert LinearEquiv.finrank_eq ( LinearEquiv.ofInjective ( P.toLinearMap.comp ( Submodule.subtype ( LinearMap.range Q.toLinearMap ) ) ) h_inj ) using 1

/-
Rank-four stability under an arbitrary finite-dimensional change of
spectral projector whose operator-norm displacement is less than one.  This is
the non-diagonal finite perturbation theorem; a Davis--Kahan estimate can feed
its quantitative hypothesis once that analytic bridge is available.
-/
theorem rankFour_spectral_sector_stable_of_projector_norm_lt_one
    (P Q : E →L[𝕜] E)
    (hP : P.comp P = P) (hQ : Q.comp Q = Q)
    (hPfour : Module.finrank 𝕜 (LinearMap.range P.toLinearMap) = 4)
    (hclose : ‖Q - P‖ < 1) :
    Module.finrank 𝕜 (LinearMap.range Q.toLinearMap) = 4 := by
  rw [← hPfour,
    finrank_range_eq_of_projection_norm_sub_lt_one P Q hP hQ hclose]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.rationalMixingPerturbation_symmetric' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rationalMixingPerturbation_symmetric

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.rationalMixingPerturbation_exact_mix' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rationalMixingPerturbation_exact_mix

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.old_rankFour_projector_not_unchanged' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms old_rankFour_projector_not_unchanged

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.finrank_range_eq_of_projection_norm_sub_lt_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finrank_range_eq_of_projection_norm_sub_lt_one

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.rankFour_spectral_sector_stable_of_projector_norm_lt_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rankFour_spectral_sector_stable_of_projector_norm_lt_one

end PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector
