import Mathlib
import PhysicsSM.Draft.E8SpherePackingImported

/-!
# Helper lemmas for the E8 shell count bridge

This draft helper was recovered from Aristotle job
`a7562d4b-901e-4cb2-9da7-f36066da7c3d`, which stopped out of budget after
proving the algebraic shell-count transport.  The result connects the project
Construction A shell count to the SPL `E8Lattice` shell count through the
existing coordinate bridge in `E8SpherePackingImported`.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.flexible false
set_option linter.unusedSimpArgs false
set_option maxHeartbeats 1600000

open scoped RealInnerProductSpace
open PhysicsSM.Coding
open PhysicsSM.Draft.E8SpherePackingImported

local notation "R8" => EuclideanSpace Real (Fin 8)

namespace PhysicsSM.Coding.E8ShellBridge

/-- Local copy of `constructionAShellSet` to avoid heavier theta imports. -/
def constructionAShellSetLocal (s : Nat) : Set (Fin 8 -> Int) :=
  {z | z ∈ e8IntLattice ∧ sqNorm z = (s : Int)}

/-! ## Basis coefficient functions -/

/-- Map from basis coefficients to a Construction A lattice vector. -/
noncomputable def fromBasisCoeffs (c : Fin 8 -> Int) : Fin 8 -> Int :=
  fun j => ∑ i : Fin 8, c i * e8CodeBasisInt i j

lemma fromBasisCoeffs_mem (c : Fin 8 -> Int) : fromBasisCoeffs c ∈ e8IntLattice := by
  rw [← mem_e8IntLatticeSubmodule, e8IntLatticeSubmodule_eq_span]
  have : fromBasisCoeffs c = ∑ i : Fin 8, c i • e8CodeBasisInt i := by
    ext j
    simp [fromBasisCoeffs, Finset.sum_apply]
  rw [this]
  exact Submodule.sum_mem _ (fun i _ =>
    Submodule.smul_mem _ _ (Submodule.subset_span (Set.mem_range_self i)))

lemma basisLinearCombination_fromBasisCoeffs (c : Fin 8 -> Int) :
    basisLinearCombination (fromBasisCoeffs c) = c := by
  ext i
  fin_cases i <;>
    simp [basisLinearCombination, fromBasisCoeffs, e8CodeBasisInt,
      Matrix.cons_val_zero, Matrix.cons_val_one, Fin.sum_univ_eight] <;>
    omega

lemma fromBasisCoeffs_basisLinearCombination (z : Fin 8 -> Int) (hz : z ∈ e8IntLattice) :
    fromBasisCoeffs (basisLinearCombination z) = z := by
  ext j
  simp [fromBasisCoeffs]
  exact (basisLinearCombination_reconstruction z hz j).symm

/-! ## Norm relationships -/

lemma withLp_norm_sq_eq_dot (v : Fin 8 -> Real) :
    ‖(WithLp.linearEquiv 2 Real (Fin 8 -> Real)).symm v‖ ^ 2 = v ⬝ᵥ v := by
  rw [EuclideanSpace.norm_eq]
  rw [Real.sq_sqrt (Finset.sum_nonneg (fun i _ => sq_nonneg _))]
  simp only [dotProduct, WithLp.linearEquiv]
  congr 1
  ext i
  simp [sq, Real.norm_eq_abs]

lemma e8ScaledGramQ_eq_half_gram (i j : Fin 8) :
    (e8ScaledGramQ i j : Real) = (e8CodeBasisGram i j : Real) / 2 := by
  simp [e8ScaledGramQ, Matrix.of_apply]

/--
Key norm relation for the bridge: if `z` is a Construction A lattice vector,
then its integer norm is twice the squared norm of the corresponding SPL
`E8Lattice` vector.
-/
lemma sqNorm_eq_two_mul_norm_sq (z : Fin 8 -> Int) (hz : z ∈ e8IntLattice) :
    let c := basisLinearCombination z
    let v := constructionAToE8 c
    let w : R8 := (WithLp.linearEquiv 2 Real (Fin 8 -> Real)).symm v
    (sqNorm z : Real) = 2 * ‖w‖ ^ 2 := by
  simp only
  rw [withLp_norm_sq_eq_dot, constructionAToE8_norm_sq]
  have hrec : z = fromBasisCoeffs (basisLinearCombination z) :=
    (fromBasisCoeffs_basisLinearCombination z hz).symm
  set c := basisLinearCombination z with hc_def
  rw [hrec]
  simp only [sqNorm, fromBasisCoeffs]
  simp_rw [e8ScaledGramQ_eq_half_gram]
  simp only [e8CodeBasisGram_eq]
  push_cast
  simp only [Fin.sum_univ_eight]
  ring

/-! ## Bijection components -/

noncomputable def toE8LatticeVec (c : Fin 8 -> Int) : R8 :=
  (WithLp.linearEquiv 2 Real (Fin 8 -> Real)).symm (constructionAToE8 c)

lemma toE8LatticeVec_mem (c : Fin 8 -> Int) :
    toE8LatticeVec c ∈ E8Lattice := by
  unfold E8Lattice
  rw [Submodule.mem_map]
  exact ⟨constructionAToE8 c, constructionAToE8_mem_E8 c, rfl⟩

lemma toE8LatticeVec_injective : Function.Injective toE8LatticeVec := by
  intro a b hab
  have : constructionAToE8 a = constructionAToE8 b := by
    have h := congr_arg (WithLp.linearEquiv 2 Real (Fin 8 -> Real)) hab
    simp [toE8LatticeVec] at h
    exact h
  exact constructionAToE8_injective this

lemma toE8LatticeVec_surj (w : R8) (hw : w ∈ E8Lattice) :
    ∃ c : Fin 8 -> Int, toE8LatticeVec c = w := by
  unfold E8Lattice at hw
  rw [Submodule.mem_map] at hw
  obtain ⟨v, hv, hvw⟩ := hw
  obtain ⟨c, hc⟩ := constructionAToE8_surj_E8 v hv
  exact ⟨c, by unfold toE8LatticeVec; rw [hc]; exact hvw⟩

/-! ## Main shell bridge -/

/-- Shell count bridge, stated with the local shell definition in this helper. -/
theorem constructionAShellSetLocal_ncard_eq_e8Shell (n : Nat) :
    Set.ncard (constructionAShellSetLocal (4 * n)) =
      Set.ncard {w : E8Lattice | ‖(w : R8)‖ ^ 2 = 2 * (n : Real)} := by
  rw [← Nat.card_coe_set_eq, ← Nat.card_coe_set_eq]
  apply Nat.card_congr
  have fwd_norm : ∀ (z : Fin 8 -> Int) (hz : z ∈ e8IntLattice)
      (hsq : sqNorm z = ((4 * n : Nat) : Int)),
      ‖toE8LatticeVec (basisLinearCombination z)‖ ^ 2 = 2 * (n : Real) := by
    intro z hz_mem hz_norm
    have hnorm := sqNorm_eq_two_mul_norm_sq z hz_mem
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
    have hinj := toE8LatticeVec_injective h_val
    have h1 := fromBasisCoeffs_basisLinearCombination z1 hz1.1
    have h2 := fromBasisCoeffs_basisLinearCombination z2 hz2.1
    calc
      z1 i = fromBasisCoeffs (basisLinearCombination z1) i := by rw [h1]
      _ = fromBasisCoeffs (basisLinearCombination z2) i := by rw [hinj]
      _ = z2 i := by rw [h2]
  · intro ⟨⟨w, hw_mem⟩, hw_norm⟩
    obtain ⟨c, hc⟩ := toE8LatticeVec_surj w hw_mem
    set z := fromBasisCoeffs c
    have hz_mem : z ∈ e8IntLattice := fromBasisCoeffs_mem c
    have hblc : basisLinearCombination z = c := basisLinearCombination_fromBasisCoeffs c
    have hnorm := sqNorm_eq_two_mul_norm_sq z hz_mem
    simp only [toE8LatticeVec] at hnorm
    rw [hblc] at hnorm
    simp only [toE8LatticeVec] at hc
    rw [show (WithLp.linearEquiv 2 Real (Fin 8 -> Real)).symm (constructionAToE8 c) = w
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
