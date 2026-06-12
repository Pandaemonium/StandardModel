import Mathlib
import PhysicsSM.Gauge.StandardModelCoverageImageSMBlock
import PhysicsSM.Gauge.StandardModelGroupStructure

/-!
# Gauge.StandardModelCoveringMapSurjective

Surjectivity of the SM covering map onto `SMBlockPredicate`.

## Mathematical context

The `StandardModelCoverageImageSMBlock` module proves that every `SMCoveringTriple`
maps to an element satisfying `SMBlockPredicate` (forward direction). This file
proves the reverse: every element of `SMBlockPredicate` is in the image of some
`SMCoveringTriple` (surjectivity / converse direction).

Together with the forward direction, this establishes that the SM covering triples
exactly characterize `S(U(2) × U(3))` at the algebraic level.

## Claim boundary

This proves algebraic surjectivity. It does **not** prove topological quotient
structure, smooth Lie group isomorphism, or uniqueness of the covering triple
(the preimage fibre is the Z₆ kernel, proved separately).

Status: trusted; all proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.GUTSquare

/-! ## Lifting unitary matrices to units -/

/-- A unitary matrix is invertible (it is a unit). -/
noncomputable def unitOfIsUnitary {n : Type*} [Fintype n] [DecidableEq n]
    {M : Matrix n n ℂ} (hM : IsUnitary M) :
    Units (Matrix n n ℂ) :=
  ⟨M, M.conjTranspose,
    by unfold IsUnitary at hM; rw [← mul_eq_one_comm]; exact hM,
    hM⟩

@[simp] theorem unitOfIsUnitary_val {n : Type*} [Fintype n] [DecidableEq n]
    {M : Matrix n n ℂ} (hM : IsUnitary M) :
    (unitOfIsUnitary hM).val = M := rfl

/-! ## Determinant product for SMBlockPredicate -/

/-- The determinant product of any SMBlock element is 1. -/
theorem SMBlockPredicate_det_product
    {A : Matrix (Fin 2) (Fin 2) ℂ} {B : Matrix (Fin 3) (Fin 3) ℂ}
    (h : SMBlockPredicate (fromBlocks A 0 0 B)) :
    A.det * B.det = 1 := by
  obtain ⟨A', B', heq, _, _, hdet⟩ := h
  have hA : A' = A := by
    ext i j
    have := congr_fun (congr_fun heq (Sum.inl i)) (Sum.inl j)
    simpa [fromBlocks] using this.symm
  have hB : B' = B := by
    ext i j
    have := congr_fun (congr_fun heq (Sum.inr i)) (Sum.inr j)
    simpa [fromBlocks] using this.symm
  rw [← hA, ← hB]; exact hdet

/-! ## Image of trivial-phase covering triple -/

/-- The image of a UnitCoveringTriple with phase = 1 is just the pair of matrix parts. -/
theorem image_of_trivial_phase (su2 : Units (Matrix (Fin 2) (Fin 2) ℂ))
    (su3 : Units (Matrix (Fin 3) (Fin 3) ℂ)) :
    (⟨1, su2, su3⟩ : UnitCoveringTriple).image = (su2, su3) := by
  simp [UnitCoveringTriple.image]

/-! ## Main surjectivity theorem -/

/-- Every element satisfying SMBlockPredicate is in the image of an
    SMCoveringTriple under the covering map. -/
theorem smBlock_isCovering
    {M : GUTMatrix} (hM : SMBlockPredicate M) :
    ∃ x : SMCoveringTriple,
      fromBlocks x.image.1.val 0 0 x.image.2.val = M := by
  obtain ⟨A, B, rfl, hA, hB, hdet⟩ := hM
  refine ⟨{
    toUnitCoveringTriple := ⟨1, unitOfIsUnitary hA, unitOfIsUnitary hB⟩
    phase_norm_one := by simp [Units.val_one]
    su2_unitary := by simpa using hA
    su3_unitary := by simpa using hB
    det_product_one := by simpa using hdet
  }, ?_⟩
  simp [image_of_trivial_phase]

/-! ## Bundled surjectivity package -/

/-- Bundled surjectivity result. -/
structure SMBlockCoveringSurjectivePackage where
  /-- Every SMBlock element is covered. -/
  is_covering :
    ∀ M : GUTMatrix, SMBlockPredicate M →
      ∃ x : SMCoveringTriple,
        fromBlocks x.image.1.val 0 0 x.image.2.val = M
  /-- The determinant product of any SMBlock element is 1. -/
  det_product :
    ∀ {A : Matrix (Fin 2) (Fin 2) ℂ} {B : Matrix (Fin 3) (Fin 3) ℂ},
      SMBlockPredicate (fromBlocks A 0 0 B) →
      A.det * B.det = 1

/-- The SMBlock surjectivity package. -/
noncomputable def smBlockCoveringSurjectivePackage :
    SMBlockCoveringSurjectivePackage :=
  { is_covering := fun _ hM => smBlock_isCovering hM
    det_product := fun h => SMBlockPredicate_det_product h }

end PhysicsSM.Gauge.StandardModelSubgroup
