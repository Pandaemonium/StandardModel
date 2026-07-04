import PhysicsSM.Draft.NullEdge.GateYM.TransferHilbert
import PhysicsSM.Draft.NullEdge.GateYM.TransferHilbertBlock

/-!
# Q2/Q3 bridge: block-matrix shift covariance

This module connects the concrete reflection-positive block matrix
(`TransferHilbertBlock.rpBlockMatrix`) to the abstract center-shift /
electric-sector API (`CenterFluxSector.ShiftSystem`,
`TransferHilbert.KernelCommutesShifts`).

## Setup

The block matrix `rpBlockMatrix W : Matrix (C x A) (C x A) Complex` is indexed
by `C x A`, with the cut coordinate `C` outer and the positive/mirror
coordinate `A` inner:

  `rpBlockMatrix W (c1, b) (c2, a) = if c1 = c2 then W a c1 b else 0`.

Given a `ShiftSystem C Shift` acting on cut configurations and a
`ShiftSystem A Shift` acting on positive/mirror configurations, the product
`blockShiftSystem SC SA : ShiftSystem (C x A) Shift` shifts a block index
`(c, a)` by shifting the cut coordinate and the positive/mirror coordinate
simultaneously by the same shift `z`:

  `(blockShiftSystem SC SA).shiftConfig z (c, a)
      = (SC.shiftConfig z c, SA.shiftConfig z a)`.

## Invariance direction

`BlockWeightInvariantUnderShifts SC SA W` says the reflection-positive weight
`W a c b` is invariant under a *simultaneous* shift of all three coordinates
(positive `a`, cut `c`, mirror `b`) by the same `z`:

  `W (SA.shiftConfig z a) (SC.shiftConfig z c) (SA.shiftConfig z b) = W a c b`.

The three coordinates are the two `A`-arguments (positive side `a` and mirror
side `b`) and the middle `C`-argument (cut side `c`); the argument order
`W a c b` matches `TransferHilbertBlock` and
`ReflectionPositivityKernel.reflectionForm`.

## What is proved

- `rpBlockMatrix_kernelInvariantUnderBlockShifts`: simultaneous invariance of
  `W` implies the block matrix is invariant under simultaneous row/column
  shifts (the `CenterFluxSector` entrywise predicate).
- `rpBlockMatrix_commutes_blockShifts`: the same, phrased as matrix-level
  commutation with the block shift permutations
  (`TransferHilbert.KernelCommutesShifts`), via `kernelCommutesShifts_iff`.
- `shiftOp_preserves_rpHilbertSpace_rpBlockMatrix`: therefore the generic
  `TransferHilbert` shift covariance theorem applies, so each block shift
  operator preserves `TransferHilbert.rpHilbertSpace (rpBlockMatrix W)`.

## What is NOT claimed

No physical transfer matrix, Hamiltonian, spectral gap, or concrete
torus/Z2 center-shift invariance of the Wilson transfer matrix.  This is an
abstract finite algebraic bridge that the concrete torus/Z2 layer can
instantiate later.

Claim label: **finite identity / Q2-Q3 bridge**.  Draft-trust:
kernel-checked, no `s o r r y`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TransferHilbertBlockShift

open scoped Matrix
open CenterFluxSector TransferHilbert TransferHilbertBlock

variable {A C Shift : Type} [Fintype A] [Fintype C]

/-- The product shift system on block indices `C x A`: a shift `z` acts on
`(c, a)` by shifting the cut coordinate `c` (via `SC`) and the
positive/mirror coordinate `a` (via `SA`) simultaneously. -/
def blockShiftSystem (SC : ShiftSystem C Shift) (SA : ShiftSystem A Shift) :
    ShiftSystem (C × A) Shift where
  shift z := Equiv.prodCongr (SC.shift z) (SA.shift z)

omit [Fintype A] [Fintype C] in
/-- The block shift acts componentwise on `(c, a)`. -/
@[simp]
theorem blockShiftSystem_shiftConfig (SC : ShiftSystem C Shift)
    (SA : ShiftSystem A Shift) (z : Shift) (c : C) (a : A) :
    (blockShiftSystem SC SA).shiftConfig z (c, a)
      = (SC.shiftConfig z c, SA.shiftConfig z a) :=
  rfl

/-- Simultaneous shift invariance of a reflection-positive weight `W a c b`:
shifting all three coordinates (positive `a`, cut `c`, mirror `b`) by the same
`z` leaves `W` unchanged. -/
def BlockWeightInvariantUnderShifts (SC : ShiftSystem C Shift)
    (SA : ShiftSystem A Shift) (W : A → C → A → ℂ) : Prop :=
  ∀ z a c b,
    W (SA.shiftConfig z a) (SC.shiftConfig z c) (SA.shiftConfig z b)
      = W a c b

omit [Fintype A] [Fintype C] in
/-- **Block-matrix shift invariance (entrywise form).**  If the weight `W` is
invariant under simultaneous shifts of all three coordinates, then the block
matrix is invariant under simultaneous shifts of its row and column indices. -/
theorem rpBlockMatrix_kernelInvariantUnderBlockShifts [DecidableEq C]
    (SC : ShiftSystem C Shift) (SA : ShiftSystem A Shift)
    (W : A → C → A → ℂ)
    (hW : BlockWeightInvariantUnderShifts SC SA W) :
    ShiftSystem.KernelInvariantUnderShifts
      (blockShiftSystem SC SA)
      (fun x y => rpBlockMatrix W x y) := by
  intro z x y
  obtain ⟨c₁, b⟩ := x
  obtain ⟨c₂, a⟩ := y
  simp only [blockShiftSystem_shiftConfig, rpBlockMatrix, Matrix.of_apply]
  by_cases h : c₁ = c₂
  · subst h
    rw [if_pos rfl, if_pos rfl]
    exact hW z a c₁ b
  · have hne : SC.shiftConfig z c₁ ≠ SC.shiftConfig z c₂ :=
      fun hc => h ((SC.shift z).injective hc)
    rw [if_neg hne, if_neg h]

/-- **Block-matrix shift commutation (matrix form).**  The block matrix
commutes with the block shift permutations. -/
theorem rpBlockMatrix_commutes_blockShifts [DecidableEq C] [DecidableEq A]
    (SC : ShiftSystem C Shift) (SA : ShiftSystem A Shift)
    (W : A → C → A → ℂ)
    (hW : BlockWeightInvariantUnderShifts SC SA W) :
    TransferHilbert.KernelCommutesShifts
      (blockShiftSystem SC SA) (rpBlockMatrix W) :=
  (TransferHilbert.kernelCommutesShifts_iff
      (blockShiftSystem SC SA) (rpBlockMatrix W)).mpr
    (rpBlockMatrix_kernelInvariantUnderBlockShifts SC SA W hW)

/-- **Shift covariance of the block OS space.**  Under simultaneous shift
invariance of `W`, each block shift operator preserves the finite OS Hilbert
space `TransferHilbert.rpHilbertSpace (rpBlockMatrix W)`; hence Q3 electric
sectors survive the block OS/GNS construction. -/
theorem shiftOp_preserves_rpHilbertSpace_rpBlockMatrix
    [DecidableEq C] [DecidableEq A]
    (SC : ShiftSystem C Shift) (SA : ShiftSystem A Shift)
    (W : A → C → A → ℂ)
    (hW : BlockWeightInvariantUnderShifts SC SA W) (z : Shift) :
    ∀ v ∈ TransferHilbert.rpHilbertSpace (rpBlockMatrix W),
      TransferHilbert.shiftOp (blockShiftSystem SC SA) z v
        ∈ TransferHilbert.rpHilbertSpace (rpBlockMatrix W) :=
  TransferHilbert.shiftOp_preserves_rpHilbertSpace
    (rpBlockMatrix_commutes_blockShifts SC SA W hW) z

end TransferHilbertBlockShift
end GateYM
end NullEdge
end Draft
end PhysicsSM
