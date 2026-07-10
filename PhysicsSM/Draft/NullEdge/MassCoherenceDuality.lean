import Mathlib
import PhysicsSM.Draft.NullEdgeDecoherenceChannelAristotle

/-!
# Exact finite mass-coherence duality

This draft module packages one equation that connects the null-edge kinematic
and information-theoretic layers. For two visible spinor alternatives `psi` and
`phi`, let `k` be the overlap of their hidden labels. The visible determinant
mass obeys

```text
visibleMassSq = (1 - visibilitySq) * maxDisagreementMassSq.
```

Equivalently,

```text
visibleMassSq + visibilitySq * maxDisagreementMassSq
  = maxDisagreementMassSq.
```

When the two visible directions are non-collinear, division by the nonzero
maximum gives `mass fraction + visibility squared = 1`. The explicit rational
witness has visibility squared `9 / 25` and visible mass fraction `16 / 25`.

The result is finite `2 x 2` complex matrix algebra. It is an exact
Englert-Greenberger-Yasin-shaped complementarity identity for this model, not a
claim about an experimental interferometer, a continuum quantum field theory,
or a measured particle mass.

Provenance: clean-room composition of
`NullEdgeDecoherenceChannelAristotle.partialCoherenceMomentum_det_eq_overlap_factor_mul_plucker`
with the standard visibility/which-way complementarity reading. The physical
comparison is to B.-G. Englert, Phys. Rev. Lett. 77 (1996) 2154, DOI
10.1103/PhysRevLett.77.2154; no external code is imported.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.MassCoherenceDuality

open Matrix Complex
open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdgeDecoherenceChannel

/-- The maximum determinant mass exposed by fully distinguishable hidden
labels: the squared Pluecker disagreement of the two visible spinors. -/
def maxDisagreementMassSq (psi phi : CSpinor) : ℝ :=
  Complex.normSq (spinorWedge psi phi)

/-- Squared visibility carried by the hidden-label overlap. -/
def visibilitySq (k : ℂ) : ℝ := Complex.normSq k

/-- Visible determinant mass after retaining hidden overlap `k`. -/
def visibleMassSq (k : ℂ) (psi phi : CSpinor) : ℝ :=
  ((partialCoherenceMomentum k psi phi).det).re

/-- The visible determinant mass is the incoherent fraction of the maximum
Pluecker disagreement mass. -/
theorem visibleMassSq_eq_one_sub_visibility_mul_max
    (k : ℂ) (psi phi : CSpinor) :
    visibleMassSq k psi phi =
      (1 - visibilitySq k) * maxDisagreementMassSq psi phi := by
  simp [visibleMassSq, visibilitySq, maxDisagreementMassSq,
    partialCoherenceMomentum_det_eq_overlap_factor_mul_plucker,
    hiddenOverlapDetFactor, complexAbsSq_eq_ofReal_normSq]

/-- **Exact mass-coherence duality.** Visible mass plus retained hidden-label
visibility, measured in the same maximum-disagreement units, is conserved. -/
theorem mass_visibility_duality (k : ℂ) (psi phi : CSpinor) :
    visibleMassSq k psi phi +
      visibilitySq k * maxDisagreementMassSq psi phi =
        maxDisagreementMassSq psi phi := by
  rw [visibleMassSq_eq_one_sub_visibility_mul_max]
  ring

/-- For non-collinear visible alternatives, the normalized mass fraction plus
squared visibility is exactly one. -/
theorem normalized_mass_visibility_duality
    (k : ℂ) (psi phi : CSpinor)
    (hmax : maxDisagreementMassSq psi phi ≠ 0) :
    visibleMassSq k psi phi / maxDisagreementMassSq psi phi +
      visibilitySq k = 1 := by
  rw [visibleMassSq_eq_one_sub_visibility_mul_max]
  field_simp
  ring

/-! ## Nondegenerate rational witness -/

/-- First orthogonal visible direction. -/
def witnessPsi : CSpinor := ![1, 0]

/-- Second orthogonal visible direction. -/
def witnessPhi : CSpinor := ![0, 1]

/-- Exact rational hidden-label overlap. -/
def witnessOverlap : ℂ := 3 / 5

/-- The orthogonal visible directions have unit maximum disagreement mass. -/
theorem witness_max_mass :
    maxDisagreementMassSq witnessPsi witnessPhi = 1 := by
  norm_num [maxDisagreementMassSq, witnessPsi, witnessPhi, spinorWedge,
    Complex.normSq]

/-- The witness retains squared visibility `9 / 25`. -/
theorem witness_visibility : visibilitySq witnessOverlap = 9 / 25 := by
  norm_num [visibilitySq, witnessOverlap, Complex.normSq]

/-- The complementary visible determinant mass is `16 / 25`. -/
theorem witness_visible_mass :
    visibleMassSq witnessOverlap witnessPsi witnessPhi = 16 / 25 := by
  rw [visibleMassSq_eq_one_sub_visibility_mul_max]
  rw [witness_max_mass, witness_visibility]
  norm_num

/-- The nondegenerate rational witness realizes `16 / 25 + 9 / 25 = 1`. -/
theorem witness_duality :
    visibleMassSq witnessOverlap witnessPsi witnessPhi +
      visibilitySq witnessOverlap = 1 := by
  rw [witness_visible_mass, witness_visibility]
  norm_num

/-! ## Kernel-footprint guard pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.MassCoherenceDuality.mass_visibility_duality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_visibility_duality

/-- info: 'PhysicsSM.Draft.NullEdge.MassCoherenceDuality.normalized_mass_visibility_duality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normalized_mass_visibility_duality

/-- info: 'PhysicsSM.Draft.NullEdge.MassCoherenceDuality.witness_duality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_duality

end PhysicsSM.Draft.NullEdge.MassCoherenceDuality
