import CodeLatticeE8.SPL.QExpansionBridge
import CodeLatticeE8.SPL.E8ThetaModular
import CodeLatticeE8.SPL.BasisBridge

/-!
# Shell-count bridge: Construction A ↔ E8Lattice

This module records the shell-count transport between the project's
Hamming Construction A integer model and SPL's `E8Lattice`.

## Architecture

The bridge maps Construction A vectors `z : Fin 8 → ℤ` (with
`sqNorm z = 4n`) to E8Lattice vectors `v : E8Lattice` (with
`‖v‖² = 2n`), preserving shell cardinalities.

The full bridge requires:

1. A lattice isomorphism `φ : (Fin 8 → ℤ) ≃ₗ[ℤ] ↥(Submodule.E8 ℝ)`
   that maps `hammingConstructionA` onto `E8Lattice`.
2. A norm compatibility theorem: `‖φ(z)‖² = sqNorm(z) / 2`.
3. Therefore: `sqNorm(z) = 4n ↔ ‖φ(z)‖² = 2n`.

## Status

The explicit lattice bridge and norm-compatibility theorem are packaged in
`CodeLatticeE8.SPL.BasisBridge`.  This module uses them to prove the shell-count
transport theorem needed by the q-expansion coefficient comparison.
-/

set_option linter.style.longLine false

open scoped RealInnerProductSpace

local notation "ℝ⁸" => EuclideanSpace ℝ (Fin 8)

namespace CodeLatticeE8.SPL

open CodeLatticeE8.E8
open CodeLatticeE8.ConstructionA

/-! ## Shell definitions -/

/-- The semantic E8Lattice shell at squared norm `2n`. -/
noncomputable def e8LatticeShell (n : ℕ) : Set E8Lattice :=
  {w : E8Lattice | ‖(w : ℝ⁸)‖ ^ 2 = 2 * (n : ℝ)}

/-- The Hamming Construction A shell `sqNorm = 4n` has the same cardinality as
the SPL E8 shell `||w||^2 = 2n`. -/
theorem constructionAShellSet_ncard_eq_e8Shell (n : ℕ) :
    Set.ncard (CodeLatticeE8.constructionAShellSet (4 * n)) =
      Set.ncard (e8LatticeShell n) := by
  rw [← Nat.card_coe_set_eq, ← Nat.card_coe_set_eq]
  apply Nat.card_congr
  have fwd_norm :
      ∀ (z : Fin 8 → ℤ) (hz : z ∈ hammingConstructionA)
        (hsq : sqNorm z = ((4 * n : ℕ) : ℤ)),
        ‖toE8LatticeVec (hammingConstructionBasisCoeffs z)‖ ^ 2 =
          2 * (n : ℝ) := by
    intro z hz_mem hz_norm
    have hnorm := sqNorm_eq_two_mul_norm_sq z hz_mem
    simp only [toE8LatticeVec] at hnorm ⊢
    have hsq_real : (sqNorm z : ℝ) = (4 * n : ℝ) := by
      exact_mod_cast hz_norm
    linarith
  refine Equiv.ofBijective
    (fun ⟨z, hz⟩ =>
      ⟨⟨toE8LatticeVec (hammingConstructionBasisCoeffs z), toE8LatticeVec_mem _⟩,
        fwd_norm z hz.1 hz.2⟩) ⟨?_, ?_⟩
  · intro ⟨z1, hz1⟩ ⟨z2, hz2⟩ h
    ext i
    have h_val :
        toE8LatticeVec (hammingConstructionBasisCoeffs z1) =
          toE8LatticeVec (hammingConstructionBasisCoeffs z2) :=
      congr_arg Subtype.val (Subtype.ext_iff.mp h)
    have hinj := toE8LatticeVec_injective h_val
    have h1 := fromBasisCoeffs_hammingConstructionBasisCoeffs z1 hz1.1
    have h2 := fromBasisCoeffs_hammingConstructionBasisCoeffs z2 hz2.1
    calc
      z1 i = fromBasisCoeffs (hammingConstructionBasisCoeffs z1) i := by rw [h1]
      _ = fromBasisCoeffs (hammingConstructionBasisCoeffs z2) i := by rw [hinj]
      _ = z2 i := by rw [h2]
  · intro ⟨⟨w, hw_mem⟩, hw_shell⟩
    have hw_norm : ‖(w : ℝ⁸)‖ ^ 2 = 2 * (n : ℝ) := by
      simpa [e8LatticeShell] using hw_shell
    obtain ⟨c, hc⟩ := toE8LatticeVec_surj w hw_mem
    set z := fromBasisCoeffs c
    have hz_mem : z ∈ hammingConstructionA := fromBasisCoeffs_mem c
    have hcoeff : hammingConstructionBasisCoeffs z = c := by
      simpa [z] using hammingConstructionBasisCoeffs_fromBasisCoeffs c
    have hnorm := sqNorm_eq_two_mul_norm_sq z hz_mem
    rw [hcoeff] at hnorm
    dsimp at hnorm
    change WithLp.toLp 2 (constructionAToE8 c) = w at hc
    rw [hc] at hnorm
    have hz_norm : sqNorm z = ((4 * n : ℕ) : ℤ) := by
      have : (sqNorm z : ℝ) = (4 * (n : ℝ)) := by linarith
      exact_mod_cast this
    refine ⟨⟨z, ⟨hz_mem, hz_norm⟩⟩, ?_⟩
    simp only [Subtype.mk.injEq]
    show toE8LatticeVec (hammingConstructionBasisCoeffs z) = w
    change WithLp.toLp 2 (constructionAToE8 (hammingConstructionBasisCoeffs z)) = w
    rw [hcoeff, hc]

end CodeLatticeE8.SPL
