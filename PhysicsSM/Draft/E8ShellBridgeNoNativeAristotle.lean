import PhysicsSM.Draft.E8ShellBridgeHelper
import PhysicsSM.Draft.E8BasisSpanningNoNativeAristotle
import PhysicsSM.Draft.E8TransitionMatrixNoNativeAristotle

/-!
# No-native shell-count bridge target

This file provides the no-native shell-count transport theorem,
replacing `E8ShellBridge.constructionAShellSetLocal_ncard_eq_e8Shell`
with a proof that does not transitively depend on `Lean.trustCompiler`.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.style.maxHeartbeats false
set_option linter.unusedSimpArgs false
set_option linter.flexible false

open scoped RealInnerProductSpace
open PhysicsSM.Draft.E8SpherePackingImported
open PhysicsSM.Draft.E8SpherePackingIsometryHelper
open PhysicsSM.Coding

local notation "R8" => EuclideanSpace Real (Fin 8)

namespace PhysicsSM.Coding.E8ShellBridge

/-! ## Key bridge: local = imported transition matrix -/

/-- The local copy equals the imported definition (entrywise check). -/
theorem constructionAToSPLTransitionLocal_eq :
    constructionAToSPLTransitionLocal = constructionAToSPLTransition := by decide

/-! ## No-native injectivity -/

/-- No-native injectivity of `constructionAToE8`. -/
theorem constructionAToE8_injective_no_native :
    Function.Injective constructionAToE8 := by
  intro a b hab
  have h0 : constructionAToE8 (a - b) = 0 := by rw [map_sub, sub_eq_zero]; exact hab
  have hunitT : IsUnit constructionAToSPLTransition := by
    rw [← constructionAToSPLTransitionLocal_eq]
    exact constructionAToSPLTransitionLocal_isUnit
  have hunitST : IsUnit (E8Matrix ℝ).transpose := by
    rw [Matrix.isUnit_iff_isUnit_det, Matrix.det_transpose, E8Matrix_unimodular]
    exact isUnit_one
  set c := a - b with hc
  set d : Fin 8 → ℝ := fun i => (constructionAToSPLTransition.mulVec c i : ℝ) with hd_def
  have h1 : (E8Matrix ℝ).transpose.mulVec d = 0 := by
    ext k
    simp only [Matrix.mulVec, dotProduct, Pi.zero_apply, hd_def, Matrix.transpose_apply]
    have := congr_fun h0 k
    simp only [constructionAToE8, LinearMap.coe_mk, AddHom.coe_mk, Finset.sum_apply,
      Pi.smul_apply, zsmul_eq_mul, Pi.zero_apply, Matrix.row_apply] at this
    convert this using 1
    congr 1; ext i; simp [Matrix.mulVec, dotProduct, Matrix.row_apply]; ring
  have h2 : d = 0 :=
    (Matrix.mulVec_injective_of_isUnit hunitST) (by rw [h1, Matrix.mulVec_zero])
  have h3 : constructionAToSPLTransition.mulVec c = 0 := by
    ext i
    have := congr_fun h2 i
    simp only [Pi.zero_apply, hd_def] at this
    exact_mod_cast this
  have h4 : c = 0 :=
    (Matrix.mulVec_injective_of_isUnit hunitT) (by rw [h3, Matrix.mulVec_zero])
  exact sub_eq_zero.mp h4

/-! ## No-native surjectivity -/

/-- No-native version of the mulVec inverse identity. -/
private theorem transition_mulVec_inv_mulVec_no_native (d : Fin 8 → ℤ) :
    constructionAToSPLTransition.mulVec
      (constructionAToSPLTransitionLocalInv.mulVec d) = d := by
  rw [Matrix.mulVec_mulVec, ← constructionAToSPLTransitionLocal_eq,
      constructionAToSPLTransitionLocal_mul_inv]
  simp

/-- No-native surjectivity of `constructionAToE8`. -/
theorem constructionAToE8_surj_E8_no_native (v : Fin 8 → ℝ) (hv : v ∈ Submodule.E8 ℝ) :
    ∃ c : Fin 8 → ℤ, constructionAToE8 c = v := by
  rw [← span_E8Matrix ℝ] at hv
  rw [Submodule.mem_span_range_iff_exists_fun] at hv
  obtain ⟨d, hd⟩ := hv
  refine ⟨constructionAToSPLTransitionLocalInv.mulVec d, ?_⟩
  change ∑ i : Fin 8,
    (constructionAToSPLTransition.mulVec
      (constructionAToSPLTransitionLocalInv.mulVec d) i) •
    (E8Matrix ℝ).row i = v
  rw [transition_mulVec_inv_mulVec_no_native]
  exact hd

/-! ## No-native inner product -/

/-- The gram congruence cast to ℝ. -/
private theorem gram_congruence_R_no_native :
    (constructionAToSPLTransition.map (Int.castRingHom ℝ)).transpose *
    (splE8GramQ.map (algebraMap ℚ ℝ)) *
    (constructionAToSPLTransition.map (Int.castRingHom ℝ)) =
    e8ScaledGramQ.map (algebraMap ℚ ℝ) := by
  rw [← constructionAToSPLTransitionLocal_eq]
  exact gram_congruence_Q_to_R
    constructionAToSPLTransitionLocal splE8GramQ e8ScaledGramQ
    constructionAToSPLTransitionLocal_gram

/-- No-native inner product formula. -/
theorem constructionAToE8_inner_no_native (c₁ c₂ : Fin 8 → ℤ) :
    constructionAToE8 c₁ ⬝ᵥ constructionAToE8 c₂ =
    ∑ i : Fin 8, ∑ j : Fin 8,
      (c₁ i : ℝ) * (e8ScaledGramQ i j : ℝ) * (c₂ j : ℝ) := by
  have h1 := inner_intLinComb_eq_gram_form
    (E8Matrix ℝ) constructionAToSPLTransition c₁ c₂
  rw [E8Matrix_gram_R_eq_splE8GramQ_cast] at h1
  rw [gram_congruence_R_no_native] at h1
  simp only [Matrix.map_apply] at h1
  exact h1

/-! ## No-native basis membership -/

/-- No-native version of `e8CodeBasisInt_mem`. Each basis vector's mod-2
    reduction is in the extended Hamming code. -/
theorem e8CodeBasisInt_mem_no_native (i : Fin 8) :
    e8CodeBasisInt i ∈ e8IntLattice := by
  fin_cases i <;> (change reduceModTwo _ ∈ extendedHamming8; rw [extendedHamming8_mem_iff_mulVec]; decide)

/-- No-native version of `fromBasisCoeffs_mem`. -/
private theorem fromBasisCoeffs_mem_no_native (c : Fin 8 → ℤ) :
    fromBasisCoeffs c ∈ e8IntLattice := by
  have h : fromBasisCoeffs c = ∑ i : Fin 8, c i • e8CodeBasisInt i := by
    ext j; simp [fromBasisCoeffs, Finset.sum_apply]
  rw [h]
  exact AddSubgroup.sum_mem _ fun i _ =>
    AddSubgroup.zsmul_mem _ (e8CodeBasisInt_mem_no_native i) _

/-! ## No-native basis coefficient helpers -/

/-- No-native version of `fromBasisCoeffs_basisLinearCombination`. -/
private theorem fromBasisCoeffs_basisLinearCombination_no_native
    (z : Fin 8 → ℤ) (hz : z ∈ e8IntLattice) :
    fromBasisCoeffs (basisLinearCombination z) = z := by
  ext j
  simp [fromBasisCoeffs]
  exact (basisLinearCombination_reconstruction_no_native z hz j).symm

/-! ## No-native norm relationship -/

set_option maxHeartbeats 1600000 in
/-- No-native norm relation. -/
theorem sqNorm_eq_two_mul_norm_sq_no_native (z : Fin 8 → ℤ) (hz : z ∈ e8IntLattice) :
    let c := basisLinearCombination z
    let v := constructionAToE8 c
    let w : R8 := (WithLp.linearEquiv 2 Real (Fin 8 → Real)).symm v
    (sqNorm z : Real) = 2 * ‖w‖ ^ 2 := by
  simp only
  rw [withLp_norm_sq_eq_dot]
  rw [constructionAToE8_inner_no_native]
  have hrec : z = fromBasisCoeffs (basisLinearCombination z) :=
    (fromBasisCoeffs_basisLinearCombination_no_native z hz).symm
  set c := basisLinearCombination z with hc_def
  rw [hrec]
  simp only [sqNorm, fromBasisCoeffs]
  simp_rw [e8ScaledGramQ_eq_half_gram]
  simp only [e8CodeBasisGram_eq]
  push_cast
  simp only [Fin.sum_univ_eight]
  ring

/-! ## Main no-native shell-count target -/

/-- Helper: toE8LatticeVec is injective (no-native). -/
private theorem toE8LatticeVec_injective_no_native : Function.Injective toE8LatticeVec := by
  intro a b hab
  have : constructionAToE8 a = constructionAToE8 b := by
    have h := congr_arg (WithLp.linearEquiv 2 Real (Fin 8 → Real)) hab
    simp [toE8LatticeVec] at h
    exact h
  exact constructionAToE8_injective_no_native this

/-- Helper: toE8LatticeVec is surjective onto E8Lattice (no-native). -/
private theorem toE8LatticeVec_surj_no_native (w : R8) (hw : w ∈ E8Lattice) :
    ∃ c : Fin 8 → ℤ, toE8LatticeVec c = w := by
  unfold E8Lattice at hw
  rw [Submodule.mem_map] at hw
  obtain ⟨v, hv, hvw⟩ := hw
  obtain ⟨c, hc⟩ := constructionAToE8_surj_E8_no_native v hv
  exact ⟨c, by unfold toE8LatticeVec; rw [hc]; exact hvw⟩

/--
No-`native_decide` replacement for the shell-count bridge.

This is the key theorem needed to remove `Lean.trustCompiler` from the final
`Theta_E8 = E4` coefficient theorem.
-/
theorem constructionAShellSetLocal_ncard_eq_e8Shell_no_native (n : Nat) :
    Set.ncard (constructionAShellSetLocal (4 * n)) =
      Set.ncard {w : E8Lattice | ‖(w : R8)‖ ^ 2 = 2 * (n : Real)} := by
  rw [← Nat.card_coe_set_eq, ← Nat.card_coe_set_eq]
  apply Nat.card_congr
  have fwd_norm : ∀ (z : Fin 8 → ℤ) (hz : z ∈ e8IntLattice)
      (hsq : sqNorm z = ((4 * n : Nat) : Int)),
      ‖toE8LatticeVec (basisLinearCombination z)‖ ^ 2 = 2 * (n : Real) := by
    intro z hz_mem hz_norm
    have hnorm := sqNorm_eq_two_mul_norm_sq_no_native z hz_mem
    simp only [toE8LatticeVec] at hnorm ⊢
    have : (sqNorm z : Real) = (4 * n : Real) := by exact_mod_cast hz_norm
    linarith
  refine Equiv.ofBijective
    (fun ⟨z, hz⟩ => ⟨⟨toE8LatticeVec (basisLinearCombination z), toE8LatticeVec_mem _⟩,
                      fwd_norm z hz.1 hz.2⟩) ⟨?_, ?_⟩
  · intro ⟨z1, hz1⟩ ⟨z2, hz2⟩ h
    ext i
    have h_val : toE8LatticeVec (basisLinearCombination z1) =
        toE8LatticeVec (basisLinearCombination z2) :=
      congr_arg Subtype.val (Subtype.ext_iff.mp h)
    have hinj := toE8LatticeVec_injective_no_native h_val
    have h1 := fromBasisCoeffs_basisLinearCombination_no_native z1 hz1.1
    have h2 := fromBasisCoeffs_basisLinearCombination_no_native z2 hz2.1
    calc
      z1 i = fromBasisCoeffs (basisLinearCombination z1) i := by rw [h1]
      _ = fromBasisCoeffs (basisLinearCombination z2) i := by rw [hinj]
      _ = z2 i := by rw [h2]
  · intro ⟨⟨w, hw_mem⟩, hw_norm⟩
    obtain ⟨c, hc⟩ := toE8LatticeVec_surj_no_native w hw_mem
    set z := fromBasisCoeffs c
    have hz_mem : z ∈ e8IntLattice := fromBasisCoeffs_mem_no_native c
    have hblc : basisLinearCombination z = c := basisLinearCombination_fromBasisCoeffs c
    have hnorm := sqNorm_eq_two_mul_norm_sq_no_native z hz_mem
    simp only [toE8LatticeVec] at hnorm
    rw [hblc] at hnorm
    simp only [toE8LatticeVec] at hc
    rw [show (WithLp.linearEquiv 2 Real (Fin 8 → Real)).symm (constructionAToE8 c) = w
      from hc] at hnorm
    have hw_norm' : ‖w‖ ^ 2 = 2 * (n : Real) := hw_norm
    have hz_norm : sqNorm z = ((4 * n : Nat) : Int) := by
      have : (sqNorm z : Real) = (4 * ↑n : Real) := by linarith
      exact_mod_cast this
    refine ⟨⟨z, ⟨hz_mem, hz_norm⟩⟩, ?_⟩
    simp only [Subtype.mk.injEq]
    show toE8LatticeVec (basisLinearCombination z) = w
    simp only [toE8LatticeVec]
    rw [hblc, hc]

end PhysicsSM.Coding.E8ShellBridge
