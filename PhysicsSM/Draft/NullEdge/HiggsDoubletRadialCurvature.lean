import PhysicsSM.Draft.NullEdge.HiggsTangentDecomposition
import PhysicsSM.Draft.NullEdge.HiggsRadialCurvature

/-!
# Standard-doublet Higgs radial curvature

This module translates the one-component Higgs potential normalization into
the standard electroweak-doublet convention already used by `H0` and
`radialTangent`:

```text
H(h) = (0, (v + h) / sqrt 2),
V(H) = lambda * (||H||^2 - v^2 / 2)^2.
```

Along this normalized radial line the exact quadratic coefficient is
`lambda * v^2`, hence `m_h^2 = 2 * lambda * v^2` when the potential mass term
is written as `(1/2) * m_h^2 * h^2`.  This removes the factor-of-four
coordinate mismatch with the one-component control in `HiggsRadialCurvature`.

Provenance: clean-room convention cross-check against the Higgs potential API
in PhysLean (`StandardModel.HiggsField.Potential.toFun`), consulted at its
pinned external version.  No external implementation text is copied.

The coupling and vacuum are supplied.  No vacuum-selection, running-coupling,
continuum-pole, or observed-mass theorem is claimed.  Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsDoubletRadialCurvature

open PhysicsSM.Draft
open PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable
open PhysicsSM.Draft.NullEdge.HiggsTangentDecomposition

/-- The standard-doublet radial line `H(h) = (0, (v+h)/sqrt 2)`. -/
def radialDoubletField (v h : Real) : Fin 2 -> Complex :=
  H0 v + radialTangent h

/-- Vacuum-subtracted quartic potential in the standard doublet
normalization. -/
def doubletPotentialDensity
    (lam v : Real) (field : Fin 2 -> Complex) : Real :=
  lam * (vectorNormSq field - v ^ 2 / 2) ^ 2

/-- Radial mass squared in the standard doublet normalization. -/
def radialMassSquared (lam v : Real) : Real :=
  2 * lam * v ^ 2

/-- The standard-doublet potential is invariant under every unitary internal
transformation, hence in particular under the supplied electroweak action. -/
theorem doubletPotentialDensity_unitary
    (lam v : Real) (g : Matrix.unitaryGroup (Fin 2) Complex)
    (field : Fin 2 -> Complex) :
    doubletPotentialDensity lam v (unitaryTransform g field) =
      doubletPotentialDensity lam v field := by
  unfold doubletPotentialDensity
  rw [vectorNormSq_unitary]

/-- The norm squared of the normalized radial doublet is `(v+h)^2/2`. -/
theorem vectorNormSq_radialDoubletField (v h : Real) :
    vectorNormSq (radialDoubletField v h) = (v + h) ^ 2 / 2 := by
  have hsq : (Real.sqrt 2) ^ 2 = (2 : Real) := Real.sq_sqrt (by norm_num)
  have hsqrt : Real.sqrt 2 ≠ 0 := Real.sqrt_ne_zero'.mpr (by norm_num)
  unfold vectorNormSq realHermitianBilinear radialDoubletField H0 radialTangent
  simp [Fin.sum_univ_two, Complex.mul_re]
  field_simp [hsqrt]
  nlinarith [hsq]

/-- Exact quartic expansion along the normalized radial doublet. -/
theorem doubletPotential_exact_expansion (lam v h : Real) :
    doubletPotentialDensity lam v (radialDoubletField v h) =
      lam * v ^ 2 * h ^ 2 + lam * v * h ^ 3 + (lam / 4) * h ^ 4 := by
  unfold doubletPotentialDensity
  rw [vectorNormSq_radialDoubletField]
  ring

/-- The quadratic term is exactly one half of the standard-doublet radial mass
squared times `h^2`. -/
theorem doubletPotential_eq_massTerm_add_interactions (lam v h : Real) :
    doubletPotentialDensity lam v (radialDoubletField v h) =
      (1 / 2 : Real) * radialMassSquared lam v * h ^ 2 +
        lam * v * h ^ 3 + (lam / 4) * h ^ 4 := by
  rw [doubletPotential_exact_expansion]
  unfold radialMassSquared
  ring

/-- Exact coordinate bridge to the one-component control: substitute both the
vacuum and fluctuation by their standard-doublet coordinates. -/
theorem doubletPotential_eq_oneComponent_rescaled (lam v h : Real) :
    doubletPotentialDensity lam v (radialDoubletField v h) =
      GeometryWeightedHiggsFunctional.radialPotentialDensity
        lam (v / Real.sqrt 2)
        (PhysicsSM.Draft.NullEdge.HiggsRadialCurvature.radialFluctuation
          (v / Real.sqrt 2) (h / Real.sqrt 2)) := by
  rw [doubletPotential_exact_expansion,
    PhysicsSM.Draft.NullEdge.HiggsRadialCurvature.radialPotential_exact_expansion]
  have hsq : (Real.sqrt 2) ^ 2 = (2 : Real) := Real.sq_sqrt (by norm_num)
  have hsqrt : Real.sqrt 2 ≠ 0 := Real.sqrt_ne_zero'.mpr (by norm_num)
  have hfour : (Real.sqrt 2) ^ 4 = (4 : Real) := by
    calc
      (Real.sqrt 2) ^ 4 = ((Real.sqrt 2) ^ 2) ^ 2 := by ring
      _ = (2 : Real) ^ 2 := by rw [hsq]
      _ = 4 := by norm_num
  field_simp [hsqrt]
  rw [hfour]
  ring

/-- The one-component mass parameter is twice the doublet mass parameter after
rescaling the field coordinate; the kinetic coordinate rescaling supplies the
compensating factor. -/
theorem oneComponentMassSquared_rescaled (lam v : Real) :
    PhysicsSM.Draft.NullEdge.HiggsRadialCurvature.radialMassSquared
        lam (v / Real.sqrt 2) =
      2 * radialMassSquared lam v := by
  unfold PhysicsSM.Draft.NullEdge.HiggsRadialCurvature.radialMassSquared
    radialMassSquared
  have hsq : (Real.sqrt 2) ^ 2 = (2 : Real) := Real.sq_sqrt (by norm_num)
  have hsqrt : Real.sqrt 2 ≠ 0 := Real.sqrt_ne_zero'.mpr (by norm_num)
  field_simp [hsqrt]
  rw [hsq]
  ring

/-- Positive quartic coupling and a nonzero electroweak vacuum give positive
radial mass squared in the standard doublet normalization. -/
theorem radialMassSquared_pos
    {lam v : Real} (hLam : 0 < lam) (hv : v ≠ 0) :
    0 < radialMassSquared lam v := by
  unfold radialMassSquared
  positivity

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsDoubletRadialCurvature.doubletPotential_exact_expansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms doubletPotential_exact_expansion

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsDoubletRadialCurvature.doubletPotentialDensity_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms doubletPotentialDensity_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsDoubletRadialCurvature.doubletPotential_eq_massTerm_add_interactions' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms doubletPotential_eq_massTerm_add_interactions

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsDoubletRadialCurvature.doubletPotential_eq_oneComponent_rescaled' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms doubletPotential_eq_oneComponent_rescaled

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsDoubletRadialCurvature.radialMassSquared_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms radialMassSquared_pos

end PhysicsSM.Draft.NullEdge.HiggsDoubletRadialCurvature

end
