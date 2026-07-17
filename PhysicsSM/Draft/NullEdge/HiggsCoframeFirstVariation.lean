import Mathlib

/-!
# Exact signed Higgs kinetic expansion under dual-frame perturbation

This module holds transported complex matter samples fixed while a supplied
real dual-frame matrix follows an affine perturbation. It proves the exact
linear change of extracted derivative components and the exact quadratic
expansion of an arbitrary signed kinetic contraction. The linear coefficient
is the finite first-response candidate and is gauge invariant under a common
anchor phase.

No dual frame is constructed. The perturbation is not identified with a metric
or coframe component, the samples are not varied, and no stress tensor,
conservation law, or continuum derivative is claimed. The five finite proofs
were produced by Aristotle project `15c10e3f-3352-4f2a-8879-489298a33e6c`,
replayed under the pinned toolchain, and ported here without statement
weakening. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsCoframeFirstVariation

open scoped BigOperators

variable {Y I : Type*} [Fintype Y] [Fintype I]

/-- Extract complex derivative components from fixed complex samples using a
supplied real dual matrix. -/
def extractComponents
    (dualMatrix : Matrix I Y Real) (samples : Y -> Complex) : I -> Complex :=
  fun i => ∑ y, (dualMatrix i y : Complex) * samples y

/-- Arbitrary signed kinetic contraction. -/
def signedKinetic
    (sign : I -> Real) (derivative : I -> Complex) : Real :=
  ∑ i, sign i * Complex.normSq (derivative i)

/-- Linear coefficient in the signed kinetic expansion. -/
def signedKineticFirstVariation
    (sign : I -> Real) (derivative variation : I -> Complex) : Real :=
  2 * ∑ i, sign i * (star (derivative i) * variation i).re

/-- Exact norm-square expansion along a real affine parameter. -/
theorem normSq_add_real_smul
    (z dz : Complex) (epsilon : Real) :
    Complex.normSq (z + (epsilon : Complex) * dz) =
      Complex.normSq z +
        epsilon * (2 * (star z * dz).re) +
        epsilon ^ 2 * Complex.normSq dz := by
  simpa [Complex.normSq, Complex.ext_iff] using (by ring)

omit [Fintype I] in
/-- A real affine perturbation of the dual matrix changes extracted complex
components by the corresponding complex affine perturbation. -/
theorem extractComponents_affine_dual
    (dualMatrix dualVariation : Matrix I Y Real)
    (samples : Y -> Complex) (epsilon : Real) :
    extractComponents (dualMatrix + epsilon • dualVariation) samples =
      fun i => extractComponents dualMatrix samples i +
        (epsilon : Complex) * extractComponents dualVariation samples i := by
  funext i
  simp [extractComponents, Finset.mul_sum, mul_assoc, add_mul,
    Finset.sum_add_distrib]

/-- Exact quadratic expansion of every signed kinetic contraction. -/
theorem signedKinetic_affine_expansion
    (sign : I -> Real) (derivative variation : I -> Complex)
    (epsilon : Real) :
    signedKinetic sign
        (fun i => derivative i + (epsilon : Complex) * variation i) =
      signedKinetic sign derivative +
        epsilon * signedKineticFirstVariation sign derivative variation +
        epsilon ^ 2 * signedKinetic sign variation := by
  unfold signedKinetic signedKineticFirstVariation
  simp [Complex.normSq, mul_assoc, mul_comm, Finset.mul_sum]
  simpa only [← Finset.sum_add_distrib] using
    Finset.sum_congr rfl fun _ _ => by ring

/-- The exact affine dual-frame response is the linear coefficient in the
signed kinetic expansion, with a quadratic remainder displayed exactly. -/
theorem extractedKinetic_affine_expansion
    (sign : I -> Real)
    (dualMatrix dualVariation : Matrix I Y Real)
    (samples : Y -> Complex) (epsilon : Real) :
    signedKinetic sign
        (extractComponents (dualMatrix + epsilon • dualVariation) samples) =
      signedKinetic sign (extractComponents dualMatrix samples) +
        epsilon * signedKineticFirstVariation sign
          (extractComponents dualMatrix samples)
          (extractComponents dualVariation samples) +
        epsilon ^ 2 * signedKinetic sign
          (extractComponents dualVariation samples) := by
  rw [extractComponents_affine_dual]
  exact signedKinetic_affine_expansion sign
    (extractComponents dualMatrix samples)
    (extractComponents dualVariation samples) epsilon

/-- The finite first-response coefficient is invariant when both the extracted
derivative and its frame variation acquire one common anchor phase. -/
theorem signedKineticFirstVariation_gauge_invariant
    (sign : I -> Real) (derivative variation : I -> Complex)
    (g0 : Circle) :
    signedKineticFirstVariation sign
        (fun i => (g0 : Complex) * derivative i)
        (fun i => (g0 : Complex) * variation i) =
      signedKineticFirstVariation sign derivative variation := by
  simp only [signedKineticFirstVariation]
  have h_g0 : Complex.normSq (g0 : ℂ) = 1 := by
    simp [Complex.normSq_eq_norm_sq]
  simp_all [Complex.normSq_apply]
  grind

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCoframeFirstVariation.normSq_add_real_smul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normSq_add_real_smul

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCoframeFirstVariation.extractComponents_affine_dual' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms extractComponents_affine_dual

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCoframeFirstVariation.signedKinetic_affine_expansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms signedKinetic_affine_expansion

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCoframeFirstVariation.extractedKinetic_affine_expansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms extractedKinetic_affine_expansion

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCoframeFirstVariation.signedKineticFirstVariation_gauge_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms signedKineticFirstVariation_gauge_invariant

end PhysicsSM.Draft.NullEdge.HiggsCoframeFirstVariation

end
