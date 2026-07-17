import Mathlib

/-!
# Exact complex derivative recovery from a real dual frame

This module isolates the finite linear algebra of a local derivative fit. A
real sample matrix maps complex derivative components to complex edge samples.
A supplied real left inverse recovers every complex component exactly and
makes the sample map injective.

The left inverse is a hypothesis. No graph selector, rank-availability
theorem, condition-number bound, statistical fit, coframe construction, or
continuum convergence is claimed. The four finite proofs were produced by
Aristotle project `3eb2c62e-1dc3-4836-8065-153a8a7b7663`, replayed under the
pinned toolchain, and ported here without statement weakening. Claim grade:
`M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DualFrameHiggsRecovery

open scoped BigOperators

variable {Y I : Type*} [Fintype Y] [Fintype I] [DecidableEq I]

/-- Synthesize complex neighbor samples from complex derivative components
using one supplied real sample matrix. -/
def synthesizeSamples
    (sampleMatrix : Matrix Y I Real) (derivative : I -> Complex) : Y -> Complex :=
  fun y => ∑ j, (sampleMatrix y j : Complex) * derivative j

/-- Extract complex derivative components from complex neighbor samples using
one supplied real dual matrix. -/
def extractComponents
    (dualMatrix : Matrix I Y Real) (samples : Y -> Complex) : I -> Complex :=
  fun i => ∑ y, (dualMatrix i y : Complex) * samples y

/-- A real left inverse recovers every complex derivative vector exactly. -/
theorem extract_synthesize_of_leftInverse
    (sampleMatrix : Matrix Y I Real) (dualMatrix : Matrix I Y Real)
    (hLeft : dualMatrix * sampleMatrix = (1 : Matrix I I Real))
    (derivative : I -> Complex) :
    extractComponents dualMatrix (synthesizeSamples sampleMatrix derivative) =
      derivative := by
  ext i
  simp +decide [extractComponents, synthesizeSamples]
  convert congr_arg
    (fun m : Matrix I I ℝ => ∑ j, (m i j : ℂ) * derivative j) hLeft using 1
  · simp +decide [Matrix.mul_apply, Finset.mul_sum _ _ _]
    exact Finset.sum_comm.trans (Finset.sum_congr rfl fun _ _ => by
      rw [Finset.sum_mul]
      exact Finset.sum_congr rfl fun _ _ => by ring)
  · simp +decide [Matrix.one_apply]
    rw [Finset.sum_eq_single i] <;> aesop

/-- A sample matrix with a supplied real left inverse is injective even after
extension from real coefficients to complex derivative components. -/
theorem synthesizeSamples_injective_of_leftInverse
    (sampleMatrix : Matrix Y I Real) (dualMatrix : Matrix I Y Real)
    (hLeft : dualMatrix * sampleMatrix = (1 : Matrix I I Real)) :
    Function.Injective (synthesizeSamples sampleMatrix) := by
  intro derivative₁ derivative₂ h
  rw [← extract_synthesize_of_leftInverse sampleMatrix dualMatrix hLeft derivative₁,
    ← extract_synthesize_of_leftInverse sampleMatrix dualMatrix hLeft derivative₂, h]

/-- Zero synthesized samples force every complex derivative component to
vanish when a real left inverse is supplied. -/
theorem derivative_eq_zero_of_samples_eq_zero
    (sampleMatrix : Matrix Y I Real) (dualMatrix : Matrix I Y Real)
    (hLeft : dualMatrix * sampleMatrix = (1 : Matrix I I Real))
    (derivative : I -> Complex)
    (hZero : synthesizeSamples sampleMatrix derivative = 0) :
    derivative = 0 := by
  apply synthesizeSamples_injective_of_leftInverse sampleMatrix dualMatrix hLeft
  calc
    synthesizeSamples sampleMatrix derivative = 0 := hZero
    _ = synthesizeSamples sampleMatrix 0 := by
      ext y
      simp [synthesizeSamples]

/-- Exact four-component control: the identity sample frame and identity dual
recover every complex derivative vector. -/
theorem identity_fourFrame_exact_recovery
    (derivative : Fin 4 -> Complex) :
    extractComponents (1 : Matrix (Fin 4) (Fin 4) Real)
        (synthesizeSamples (1 : Matrix (Fin 4) (Fin 4) Real) derivative) =
      derivative := by
  exact extract_synthesize_of_leftInverse
    (1 : Matrix (Fin 4) (Fin 4) Real)
    (1 : Matrix (Fin 4) (Fin 4) Real) (by simp) derivative

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.DualFrameHiggsRecovery.extract_synthesize_of_leftInverse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms extract_synthesize_of_leftInverse

/-- info: 'PhysicsSM.Draft.NullEdge.DualFrameHiggsRecovery.synthesizeSamples_injective_of_leftInverse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms synthesizeSamples_injective_of_leftInverse

/-- info: 'PhysicsSM.Draft.NullEdge.DualFrameHiggsRecovery.derivative_eq_zero_of_samples_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms derivative_eq_zero_of_samples_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.DualFrameHiggsRecovery.identity_fourFrame_exact_recovery' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms identity_fourFrame_exact_recovery

end PhysicsSM.Draft.NullEdge.DualFrameHiggsRecovery

end
