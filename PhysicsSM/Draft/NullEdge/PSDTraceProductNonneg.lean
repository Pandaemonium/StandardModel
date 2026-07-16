import Mathlib

/-!
# Trace of a product of positive semidefinite matrices is nonnegative

Draft module. For positive semidefinite complex matrices `A, B`, the real part of
`tr(A * B)` is nonnegative. This is a foundational, everywhere-used
quantum-information / gravity-resource lemma (expectation values, purities,
state overlaps, resource monotone positivity) and it is pure linear algebra --
no matrix exponential or logarithm, so it avoids functional-calculus instance
friction. It underwrites the positivity side-conditions in the mass-as-resource
and information-resource bridge modules.

## Statement

`0 <= (A * B).trace.re` for `A B : Matrix n n C` with `A.PosSemidef`,
`B.PosSemidef`.

## Trust status

Draft-trust by kernel: `trace_mul_nonneg` is `sorry`-free and depends only on
`[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard block at the end of
this file.

## Provenance

Statement authored in-project (AFPL run 2026-07-12). Proof search by Aristotle
(project `5edc72d8-35cc-49a2-ba7f-1c233d4d8db4`), then independently re-checked in
this repo under the pinned toolchain (`lake env lean`; axiom footprint confirmed
kernel-only). Route: factor `B = C^H C`
(`Matrix.posSemidef_iff_eq_conjTranspose_mul_self`), use trace cyclicity to write
`tr(A B) = tr(C A C^H)`, note `C A C^H` is PSD when `A` is
(`Matrix.PosSemidef.conjTranspose_mul_mul_same`), and a PSD matrix has real
nonnegative trace (`Matrix.PosSemidef.trace_nonneg`). Clean-room formalization
from the mathematical statement, not copied from external code.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PSDTrace

open Matrix
open scoped ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **Trace of a product of PSD matrices has nonnegative real part.** -/
theorem trace_mul_nonneg (A B : Matrix n n ℂ)
    (hA : A.PosSemidef) (hB : B.PosSemidef) :
    0 ≤ (A * B).trace.re := by
  obtain ⟨C, hC⟩ : ∃ C : Matrix n n ℂ, B = C.conjTranspose * C := by
    have hB_decomp : ∃ C : Matrix n n ℂ, B = Cᴴ * C := by
      have hB_pos : Matrix.PosSemidef B := hB
      convert Matrix.posSemidef_iff_eq_conjTranspose_mul_self.mp hB_pos;
    exact hB_decomp;
  have h_pos_semidef : (C * A * C.conjTranspose).PosSemidef := by
    convert hA.conjTranspose_mul_mul_same C.conjTranspose using 1 ; simp +decide [ Matrix.mul_assoc ];
  have := h_pos_semidef.trace_nonneg;
  simp_all +decide [ Matrix.mul_assoc, Matrix.trace_mul_comm C ];
  cases this ; aesop

end PhysicsSM.Draft.NullEdge.PSDTrace

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only, no
-- `native_decide` / `Lean.ofReduceBool`.
/--
info: 'PhysicsSM.Draft.NullEdge.PSDTrace.trace_mul_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PSDTrace.trace_mul_nonneg
