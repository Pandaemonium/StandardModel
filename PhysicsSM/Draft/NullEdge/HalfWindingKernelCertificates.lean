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

/-- The integer twin of the compressed matrix, at the true clearing scale `5`. -/
def MofZ (n : Fin 16) : Matrix (Fin 4) (Fin 4) ℤ := !![
  0, (if n.val.testBit 0 then -3 else 3), 4, 0;
  (if n.val.testBit 2 then 3 else -3), 0, 0, 4;
  4, 0, 0, (if n.val.testBit 2 then -3 else 3);
  0, 4, (if n.val.testBit 0 then 3 else -3), 0]

/- Scaling bridge at the true clearing scale `5`. -/
set_option maxHeartbeats 2000000 in
theorem mofZ_bridge (n : Fin 16) (i j : Fin 4) :
    (Mof n i j) = (MofZ n i j : ℚ) / 5 := by
  fin_cases n <;> fin_cases i <;> fin_cases j <;>
    norm_num [MofZ, Mof, Wof, signField,
      ModeInvariantHalfWinding.walkQ, ModeInvariantHalfWinding.coinQ,
      ModeInvariantHalfWinding.shiftQ, ModeInvariantHalfWinding.cW,
      ModeInvariantHalfWinding.Bfix, Matrix.mul_apply, Matrix.transpose_apply,
      Fintype.sum_prod_type, Fin.sum_univ_four, Fin.sum_univ_two, Nat.testBit] <;>
    simp <;> norm_num

lemma mof_selfadj_iff_mofZ (n : Fin 16) :
    Mof n = (Mof n)ᵀ ↔ MofZ n = (MofZ n)ᵀ := by
  constructor
  · intro h
    ext i j
    have hij := congr_fun (congr_fun h i) j
    simp only [Matrix.transpose_apply] at hij ⊢
    rw [mofZ_bridge n i j, mofZ_bridge n j i] at hij
    have hq : (MofZ n i j : ℚ) = (MofZ n j i : ℚ) := by linarith
    exact_mod_cast hq
  · intro h
    ext i j
    have hij := congr_fun (congr_fun h i) j
    simp only [Matrix.transpose_apply] at hij ⊢
    rw [mofZ_bridge n i j, mofZ_bridge n j i]
    exact congrArg (fun z : ℚ => z / 5) (by exact_mod_cast hij)

lemma mofZ_discriminant (n : Fin 16) :
    MofZ n = (MofZ n)ᵀ ↔
      (wallCount n = 2 ∧ fixedSingleton n = false) := by
  fin_cases n <;> decide

/-- Kernel-only discriminant. -/
theorem discriminant_kernel (n : Fin 16) :
    (Mof n = (Mof n)ᵀ) ↔
      (wallCount n = 2 ∧ fixedSingleton n = false) := by
  rw [mof_selfadj_iff_mofZ, mofZ_discriminant]

/-
Kernel-only version of `selfadj_iff_involution`.
-/
lemma mof_mul_bridge (n : Fin 16) (i j : Fin 4) :
    (Mof n * Mof n) i j = ((MofZ n * MofZ n) i j : ℚ) / 25 := by
  simp only [Matrix.mul_apply]
  rw [Fin.sum_univ_four]
  simp only [mofZ_bridge]
  rw [Fin.sum_univ_four]
  norm_num
  ring

lemma mof_involution_iff_mofZ (n : Fin 16) :
    Mof n * Mof n = 1 ↔ MofZ n * MofZ n = (25 : ℤ) • 1 := by
  constructor <;> intro h <;> ext i j
  · have hij := congr_fun (congr_fun h i) j
    rw [mof_mul_bridge] at hij
    simp only [one_apply, smul_apply]
    by_cases e : i = j
    · subst j
      simp at hij ⊢
      have hq : ((MofZ n * MofZ n) i i : ℚ) = 25 := by linarith
      exact_mod_cast hq
    · simp [e] at hij ⊢
      exact hij
  · have hij := congr_fun (congr_fun h i) j
    rw [mof_mul_bridge]
    simp only [one_apply, smul_apply] at hij ⊢
    by_cases e : i = j <;> simp [e] at hij ⊢
    · rw [hij]; norm_num
    · rw [hij]

lemma mofZ_selfadj_iff_involution (n : Fin 16) :
    MofZ n = (MofZ n)ᵀ ↔ MofZ n * MofZ n = (25 : ℤ) • 1 := by
  fin_cases n <;> decide

theorem selfadj_iff_involution_kernel (n : Fin 16) :
    (Mof n = (Mof n)ᵀ) ↔ (Mof n * Mof n = 1) := by
  rw [mof_selfadj_iff_mofZ, mof_involution_iff_mofZ,
    mofZ_selfadj_iff_involution]

/-- Kernel-only version of the corrected bridge (the paper's headline
finite classification). -/
lemma mofZ_nontrivial (n : Fin 16) : MofZ n ≠ (5 : ℤ) • 1 ∧ MofZ n ≠ (-5 : ℤ) • 1 := by
  fin_cases n <;> decide

lemma mof_nontrivial (n : Fin 16) : Mof n ≠ 1 ∧ Mof n ≠ -1 := by
  constructor
  · intro h
    have hz := (mofZ_nontrivial n).1
    apply hz
    ext i j
    have hij := congr_fun (congr_fun h i) j
    rw [mofZ_bridge] at hij
    simp only [one_apply, smul_apply]
    by_cases e : i = j
    · subst j; simp at hij ⊢
      have hq : (MofZ n i i : ℚ) = 5 := by linarith
      exact_mod_cast hq
    · simp [e] at hij ⊢
      exact hij
  · intro h
    have hz := (mofZ_nontrivial n).2
    apply hz
    ext i j
    have hij := congr_fun (congr_fun h i) j
    rw [mofZ_bridge] at hij
    simp only [neg_apply, one_apply, smul_apply] at hij ⊢
    by_cases e : i = j
    · subst j; simp at hij ⊢
      have hq : (MofZ n i i : ℚ) = -5 := by linarith
      exact_mod_cast hq
    · simp [e] at hij ⊢
      exact hij

theorem corrected_bridge_kernel (n : Fin 16) :
    (Mof n * Mof n = 1 ∧ Mof n ≠ 1 ∧ Mof n ≠ -1) ↔
      (wallCount n = 2 ∧ fixedSingleton n = false) := by
  rw [← discriminant_kernel, selfadj_iff_involution_kernel]
  exact and_iff_left (mof_nontrivial n)

/-- Kernel-only witness pair: the two-wall field 11 is self-adjoint, the
same-winding field 2 is not. -/
theorem witness_pair_kernel :
    Mof 11 = (Mof 11)ᵀ ∧ Mof 2 ≠ (Mof 2)ᵀ := by
  constructor
  · exact (mof_selfadj_iff_mofZ 11).mpr (by decide)
  · intro h
    exact absurd ((mof_selfadj_iff_mofZ 2).mp h) (by decide)

/-- Kernel-only sector controls: the counterexample's compressed sector has
neither a `+1` nor a `-1` mode. -/
theorem counterexample_sector_kernel :
    (Mof 2 + 1).det ≠ 0 ∧ (Mof 2 - 1).det ≠ 0 := by
  constructor <;> decide +kernel

end PhysicsSM.Draft.NullEdge.HalfWindingKernelCertificates
