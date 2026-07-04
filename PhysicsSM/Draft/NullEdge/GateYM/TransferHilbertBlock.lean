import PhysicsSM.Draft.NullEdge.GateYM.TransferHilbert
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel

/-!
# Q2 transfer-Hilbert block instantiation

This module instantiates the generic finite OS/GNS transfer-Hilbert matrix
layer (`TransferHilbert.lean`) from the family of reflection-positivity cut
kernels (`ReflectionPositivityKernel.lean`).

## The block matrix

Given an ensemble weight in mirror coordinates `W : A -> C -> A -> Complex`,
we assemble the single block-diagonal matrix

  `rpBlockMatrix W : Matrix (C x A) (C x A) Complex`

indexed by `C x A` (cut coordinate first, positive-side/mirror coordinate
second).  It is block diagonal in the cut coordinate `C`, and inside the
block at cut `c` it agrees with `cutKernel W c = Matrix.of fun b a => W a c b`:

  `rpBlockMatrix W (c1, b) (c2, a) = if c1 = c2 then W a c1 b else 0`.

The index-order choice `C x A` (rather than `A x C`) is deliberate: making
the block (cut) coordinate the outer coordinate lets the block-diagonal
structure be read off directly from the first components of the indices, and
keeps the quadratic-form decomposition a clean sum over `c : C` of the
per-cut kernels.

## What is proved

- `rpBlockMatrix_sameCut` / `rpBlockMatrix_neCut`: the defining
  block-diagonal entries.
- `rpBlockMatrix_posSemidef_of_reflectionPositive`: for a reflection-positive
  `W`, the block matrix is `Matrix.PosSemidef`.  The quadratic form of the
  block matrix on any vector `g : C x A -> Complex` is exactly the
  Osterwalder-Seiler reflection form `reflectionForm W (fun a c => g (c, a))`,
  hence nonnegative; Hermitian-ness comes blockwise from the PSD cut kernels
  (`cutKernel_posSemidef_of_reflectionPositive`).
- `reflectionPairingVec`: the vector `C x A -> Complex` attached to a
  positive-side observable `f : A -> C -> Complex`.
- `reflectionPairing_rpBlockMatrix_eq_reflectionForm`: the bridge identifying
  the generic OS pairing `TransferHilbert.reflectionPairing (rpBlockMatrix W)`
  on such vectors with `ReflectionPositivityKernel.reflectionForm W`.
- `rpHilbertSpace_of_reflectionPositive`: under reflection positivity, the OS
  pairing of the block matrix is nonnegative on every positive-side
  observable vector.  Together with the PSD statement this exhibits
  `TransferHilbert.rpHilbertSpace (rpBlockMatrix W)` (the range of
  `CFC.sqrt (rpBlockMatrix W)`) as the concrete finite OS space built from a
  reflection-positive ensemble weight.

## What is NOT claimed

No physical transfer matrix, Hamiltonian, continuum Hilbert space, or
spectral gap.  This is a finite, purely algebraic instantiation layer.

Claim label: **finite identity**.  Draft-trust: kernel-checked, no
`s o r r y`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TransferHilbertBlock

open scoped BigOperators ComplexOrder MatrixOrder Matrix
open ReflectionPositivityKernel

variable {A C : Type} [Fintype A] [Fintype C]

/-- The block-diagonal-in-the-cut-coordinate matrix assembled from the family
of cut kernels.  Indexed by `C x A` (cut coordinate outer): the block at cut
`c` is `cutKernel W c`, i.e. entry `(c, b), (c, a)` is `W a c b`, and entries
across different cuts vanish. -/
def rpBlockMatrix [DecidableEq C] (W : A → C → A → ℂ) :
    Matrix (C × A) (C × A) ℂ :=
  Matrix.of fun p q => if p.1 = q.1 then W q.2 p.1 p.2 else 0

omit [Fintype A] [Fintype C] in
/-- On the diagonal cut block, `rpBlockMatrix` agrees with `cutKernel`. -/
@[simp]
theorem rpBlockMatrix_sameCut [DecidableEq C] (W : A → C → A → ℂ)
    (c : C) (b a : A) :
    rpBlockMatrix W (c, b) (c, a) = cutKernel W c b a := by
  simp [rpBlockMatrix, cutKernel]

omit [Fintype A] [Fintype C] in
/-- Across different cuts, `rpBlockMatrix` vanishes. -/
theorem rpBlockMatrix_neCut [DecidableEq C] (W : A → C → A → ℂ)
    {c₁ c₂ : C} (b a : A) (h : c₁ ≠ c₂) :
    rpBlockMatrix W (c₁, b) (c₂, a) = 0 := by
  simp [rpBlockMatrix, h]

/-- The vector on `C x A` attached to a positive-side observable
`f : A -> C -> Complex`: at index `(c, a)` it is `f a c`. -/
def reflectionPairingVec (f : A → C → ℂ) : C × A → ℂ :=
  fun p => f p.2 p.1

/-- **Pairing bridge (general vector form).** The quadratic form of the block
matrix on the vector attached to `f` is the Osterwalder-Seiler reflection
form of `f`. -/
theorem dotProduct_rpBlockMatrix_eq_reflectionForm [DecidableEq C]
    (W : A → C → A → ℂ) (f : A → C → ℂ) :
    star (reflectionPairingVec f) ⬝ᵥ
        (rpBlockMatrix W *ᵥ reflectionPairingVec f)
      = reflectionForm W f := by
  rw [dotProduct, reflectionForm]
  rw [Fintype.sum_prod_type]
  refine Finset.sum_congr rfl ?_
  intro c _hc
  refine Finset.sum_congr rfl ?_
  intro b _hb
  simp only [Matrix.mulVec, dotProduct, rpBlockMatrix, reflectionPairingVec,
    Matrix.of_apply, Pi.star_apply, Finset.mul_sum]
  rw [Fintype.sum_prod_type]
  rw [Finset.sum_eq_single c]
  · refine Finset.sum_congr rfl ?_
    intro a _ha
    simp only [if_true, starRingEnd_apply]
    ring
  · intro c' _hc' hc'
    apply Finset.sum_eq_zero
    intro a _ha
    simp [Ne.symm hc']
  · intro h
    exact absurd (Finset.mem_univ c) h

/-- **Pairing bridge.** The generic OS pairing of the block matrix on the
vectors attached to `f` equals `reflectionForm W f`. -/
theorem reflectionPairing_rpBlockMatrix_eq_reflectionForm [DecidableEq C]
    (W : A → C → A → ℂ) (f : A → C → ℂ) :
    TransferHilbert.reflectionPairing (rpBlockMatrix W)
        (reflectionPairingVec f) (reflectionPairingVec f)
      = reflectionForm W f := by
  unfold TransferHilbert.reflectionPairing
  exact dotProduct_rpBlockMatrix_eq_reflectionForm W f

/-- **Block instantiation PSD.**  For a reflection-positive weight, the
block-diagonal matrix assembled from the cut kernels is positive
semidefinite. -/
theorem rpBlockMatrix_posSemidef_of_reflectionPositive [DecidableEq C]
    (W : A → C → A → ℂ) (hW : IsReflectionPositive W) :
    (rpBlockMatrix W).PosSemidef := by
  refine Matrix.PosSemidef.of_dotProduct_mulVec_nonneg ?_ ?_
  · ext p q
    obtain ⟨c₁, b⟩ := p
    obtain ⟨c₂, a⟩ := q
    simp only [Matrix.conjTranspose_apply, rpBlockMatrix, Matrix.of_apply]
    by_cases h : c₁ = c₂
    · subst h
      have hHerm :=
        (cutKernel_posSemidef_of_reflectionPositive W hW c₁).isHermitian
      have := congr_fun (congr_fun hHerm b) a
      simpa only [if_true, cutKernel, Matrix.conjTranspose_apply,
        Matrix.of_apply] using this
    · rw [if_neg (Ne.symm h), if_neg h]
      simp
  · intro g
    have hg : g = reflectionPairingVec (fun a c => g (c, a)) := by
      ext p
      obtain ⟨c, a⟩ := p
      rfl
    rw [hg, dotProduct_rpBlockMatrix_eq_reflectionForm]
    exact hW _

/-- Under reflection positivity, the OS pairing of the block matrix is
nonnegative on every positive-side observable vector.  This exhibits
`TransferHilbert.rpHilbertSpace (rpBlockMatrix W)` as a genuine finite OS
space built from the reflection-positive weight. -/
theorem rpHilbertSpace_of_reflectionPositive [DecidableEq C]
    (W : A → C → A → ℂ) (hW : IsReflectionPositive W) (f : A → C → ℂ) :
    0 ≤ TransferHilbert.reflectionPairing (rpBlockMatrix W)
        (reflectionPairingVec f) (reflectionPairingVec f) := by
  rw [reflectionPairing_rpBlockMatrix_eq_reflectionForm]
  exact hW f

end TransferHilbertBlock
end GateYM
end NullEdge
end Draft
end PhysicsSM
