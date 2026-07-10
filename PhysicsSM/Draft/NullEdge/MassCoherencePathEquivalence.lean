import Mathlib
import PhysicsSM.Draft.NullEdge.PathSumSemantics
import PhysicsSM.Draft.NullEdge.MassCoherenceDuality

/-!
# One complementarity curve for hidden overlap and path decoherence

The hidden-label model in `MassCoherenceDuality` exposes the visible mass
fraction `1 - |k|^2`. The two-history path model in `PathSumSemantics` exposes
the factor `t(2-t)`. These are the same curve after the exact identification

```text
k = 1 - t,
t(2-t) = 1 - (1-t)^2.
```

This module proves that identification without equating the two models' state
spaces. In particular, the path model has amplitude-weighted maximum
disagreement, while the hidden-label model uses the unweighted visible-spinor
Pluecker disagreement. What is shared is the normalized finite complementarity
law, not an experimental interferometer or a continuum dynamics claim.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.MassCoherencePathEquivalence

open Complex Matrix
open SuiteB_PathSum
open PhysicsSM.Draft.NullEdge.MassCoherenceDuality

/-- Maximum determinant mass exposed by complete decoherence of two paths. -/
def pathMaxMassSq (a : Fin 2 -> ℂ) (psi : Fin 2 -> Fin 2 -> ℂ) : ℝ :=
  normSq (a 0) * normSq (a 1) * normSq (wedge (psi 0) (psi 1))

/-- Squared path visibility under the overlap parameter `k = 1 - t`. -/
def pathVisibilitySq (t : ℝ) : ℝ := (1 - t) ^ 2

/-- Real determinant mass visible at path-decoherence parameter `t`. -/
def pathVisibleMassSq
    (a : Fin 2 -> ℂ) (psi : Fin 2 -> Fin 2 -> ℂ) (t : ℝ) : ℝ :=
  ((rhoDir a psi (OmegaT t)).det).re

/-- The path-decoherence determinant has the same complementarity shape as the
hidden-overlap mass law. -/
theorem pathVisibleMassSq_eq_one_sub_visibility_mul_max
    (a : Fin 2 -> ℂ) (psi : Fin 2 -> Fin 2 -> ℂ) (t : ℝ) :
    pathVisibleMassSq a psi t =
      (1 - pathVisibilitySq t) * pathMaxMassSq a psi := by
  rw [pathVisibleMassSq, decohered_family_det]
  simp only [Complex.ofReal_re]
  unfold pathVisibilitySq pathMaxMassSq
  ring

/-- **Path mass-coherence duality.** Visible determinant mass plus retained
path visibility equals the maximum path-disagreement mass. -/
theorem path_mass_visibility_duality
    (a : Fin 2 -> ℂ) (psi : Fin 2 -> Fin 2 -> ℂ) (t : ℝ) :
    pathVisibleMassSq a psi t +
        pathVisibilitySq t * pathMaxMassSq a psi = pathMaxMassSq a psi := by
  rw [pathVisibleMassSq_eq_one_sub_visibility_mul_max]
  ring

/-- The path visibility at `t` is exactly the hidden-label visibility of the
real overlap `k = 1 - t`. -/
theorem pathVisibilitySq_eq_hiddenOverlapVisibilitySq (t : ℝ) :
    pathVisibilitySq t = visibilitySq (((1 - t : ℝ) : ℂ)) := by
  simp [pathVisibilitySq, visibilitySq, Complex.normSq]
  ring

/-- Off the collinear/zero-weight locus, the path mass fraction and the
hidden-overlap visibility obey the same normalized equation. -/
theorem normalized_path_hidden_overlap_duality
    (a : Fin 2 -> ℂ) (psi : Fin 2 -> Fin 2 -> ℂ) (t : ℝ)
    (hmax : pathMaxMassSq a psi ≠ 0) :
    pathVisibleMassSq a psi t / pathMaxMassSq a psi +
      visibilitySq (((1 - t : ℝ) : ℂ)) = 1 := by
  rw [pathVisibleMassSq_eq_one_sub_visibility_mul_max,
    <- pathVisibilitySq_eq_hiddenOverlapVisibilitySq]
  field_simp
  ring

/-! ## Exact nondegenerate witness -/

/-- Decoherence parameter matching the hidden-overlap witness `k = 3/5`. -/
def witnessT : ℝ := 2 / 5

/-- The path witness has nonzero maximum disagreement mass `4/25`. -/
theorem witness_path_max_mass :
    pathMaxMassSq SuiteB_PathSum.witnessA SuiteB_PathSum.witnessPsi = 4 / 25 := by
  norm_num [pathMaxMassSq, SuiteB_PathSum.witnessA,
    SuiteB_PathSum.witnessPsi, wedge, Complex.normSq, Complex.ext_iff]

/-- The path witness retains squared visibility `9/25`. -/
theorem witness_path_visibility : pathVisibilitySq witnessT = 9 / 25 := by
  norm_num [pathVisibilitySq, witnessT]

/-- Its normalized visible determinant mass is the complementary `16/25`. -/
theorem witness_path_mass_fraction :
    pathVisibleMassSq SuiteB_PathSum.witnessA SuiteB_PathSum.witnessPsi witnessT /
        pathMaxMassSq SuiteB_PathSum.witnessA SuiteB_PathSum.witnessPsi = 16 / 25 := by
  rw [pathVisibleMassSq_eq_one_sub_visibility_mul_max,
    witness_path_max_mass, witness_path_visibility]
  norm_num

/-- The path and hidden-overlap parameterizations realize the same exact
`16/25 + 9/25 = 1` witness. -/
theorem witness_same_complementarity_curve :
    pathVisibleMassSq SuiteB_PathSum.witnessA SuiteB_PathSum.witnessPsi witnessT /
        pathMaxMassSq SuiteB_PathSum.witnessA SuiteB_PathSum.witnessPsi +
      visibilitySq (((1 - witnessT : ℝ) : ℂ)) = 1 := by
  apply normalized_path_hidden_overlap_duality
  rw [witness_path_max_mass]
  norm_num

/-! ## Kernel-footprint guard pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.MassCoherencePathEquivalence.path_mass_visibility_duality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms path_mass_visibility_duality

/-- info: 'PhysicsSM.Draft.NullEdge.MassCoherencePathEquivalence.normalized_path_hidden_overlap_duality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normalized_path_hidden_overlap_duality

/-- info: 'PhysicsSM.Draft.NullEdge.MassCoherencePathEquivalence.witness_same_complementarity_curve' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_same_complementarity_curve

end PhysicsSM.Draft.NullEdge.MassCoherencePathEquivalence
