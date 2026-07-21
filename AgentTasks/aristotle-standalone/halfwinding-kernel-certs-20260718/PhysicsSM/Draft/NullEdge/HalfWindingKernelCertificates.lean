import PhysicsSM.Draft.NullEdge.HalfWindingFieldPositionClassification

/-!
# Paper C gate: kernel-only certificates for the four-site discriminant

Target statements for the Aristotle job `halfwinding-kernel-certs-20260718`.

Context.  `HalfWindingFieldPositionClassification` (included, PROVEN) is the
decisive Paper C negative bridge result: over all 16 nowhere-zero sign fields
on the four-cycle, compression self-adjointness is equivalent to two walls
plus the positional no-fixed-singleton condition, and winding is blind to the
signature.  Its family-wide decisions, however, use compiled evaluation
(`n a t i v e _ d e c i d e`), so their axiom footprint carries
`Lean.ofReduceBool` / `Lean.trustCompiler`.  The portfolio's submission gate
for the exact finite obstruction paper requires KERNEL-ONLY certificates.

Route (repo-proven pattern: the Gaussian-integer twin decide).  All entries
of `Mof n` are rational with denominator a power of `5` (the sign fields are
`+-3/5`).  Define the integer twin by clearing denominators, prove the
scaling bridge once, transfer each decision to the integer twin, and close
the integer decisions with plain kernel `decide` (16 cases of small integer
4x4 matrix arithmetic - kernel-feasible; if a single `decide` over all 16
is too heavy, split into per-`n` lemmas via `Fin.cases` and assemble).

Pre-registered honesty license: if the denominator power differs from the
one stated below, fix the exponent (prove the true scaling bridge) and keep
everything else exact; record the correction.  The FINAL theorems must have
axiom footprint exactly `[propext, Classical.choice, Quot.sound]` - that is
the entire point of the job.  Do not use compiled evaluation anywhere in
this file.  Every `s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HalfWindingKernelCertificates

open Matrix
open PhysicsSM.Draft.NullEdge.HalfWindingFieldPositionClassification

/-- The integer twin of the compressed matrix: `Mof n` with denominators
cleared.  The compression is a product of three matrices whose entries are
integers or fifths, so a fixed power of `5` clears it; `5 ^ 2` is the
expected exponent (correct it if the true bridge needs another power). -/
def MofZ (n : Fin 16) : Matrix (Fin 4) (Fin 4) ℤ :=
  fun i j => Int.floor ((25 : ℚ) * Mof n i j)

/-- Scaling bridge: the twin is exact (no rounding occurred), i.e. the
rational compression is recovered from the integer twin. -/
theorem mofZ_bridge (n : Fin 16) (i j : Fin 4) :
    (Mof n i j) = (MofZ n i j : ℚ) / 25 := by
  sorry

/-- Kernel-only discriminant: self-adjointness of the compression is
equivalent to two walls plus no fixed singleton.  (Kernel twin of the
compiled `discriminant`.) -/
theorem discriminant_kernel (n : Fin 16) :
    (Mof n = (Mof n)ᵀ) ↔
      (wallCount n = 2 ∧ fixedSingleton n = false) := by
  sorry

/-- Kernel-only version of `selfadj_iff_involution`. -/
theorem selfadj_iff_involution_kernel (n : Fin 16) :
    (Mof n = (Mof n)ᵀ) ↔ (Mof n * Mof n = 1) := by
  sorry

/-- Kernel-only version of the corrected bridge (the paper's headline
finite classification). -/
theorem corrected_bridge_kernel (n : Fin 16) :
    (Mof n * Mof n = 1 ∧ Mof n ≠ 1 ∧ Mof n ≠ -1) ↔
      (wallCount n = 2 ∧ fixedSingleton n = false) := by
  sorry

/-- Kernel-only witness pair: the two-wall field 11 is self-adjoint, the
same-winding field 2 is not. -/
theorem witness_pair_kernel :
    Mof 11 = (Mof 11)ᵀ ∧ Mof 2 ≠ (Mof 2)ᵀ := by
  sorry

/-- Kernel-only sector controls: the counterexample's compressed sector has
neither a `+1` nor a `-1` mode. -/
theorem counterexample_sector_kernel :
    (Mof 2 + 1).det ≠ 0 ∧ (Mof 2 - 1).det ≠ 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.HalfWindingKernelCertificates
