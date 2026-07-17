import PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional

/-!
# Radial Higgs potential curvature

This module isolates the mass normalization of the radial excitation in the
one-component Higgs control model. Along the real radial line

`phi(h) = vacuum + h`,

the quartic potential has an exact polynomial expansion. Its quadratic term is
`(1 / 2) * radialMassSquared * h^2`, with

`radialMassSquared = 8 * lam * vacuum^2`.

The factor eight belongs to the potential convention used by
`GeometryWeightedHiggsFunctional`; it is not the usual Standard Model doublet
normalization unless the field and coupling conventions are translated. The
coupling and vacuum value are supplied. No electroweak vacuum selection,
renormalization-group flow, continuum pole theorem, or 125 GeV prediction is
claimed. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsRadialCurvature

open PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional

/-- Real radial fluctuation embedded in the one-component complex field. -/
def radialFluctuation (vacuum h : Real) : Complex :=
  ((vacuum + h : Real) : Complex)

/-- Mass-squared normalization read from one half of the quadratic radial
potential coefficient. -/
def radialMassSquared (lam vacuum : Real) : Real :=
  8 * lam * vacuum ^ 2

/-- Exact quartic expansion of the one-component potential along the radial
line through the displayed vacuum. -/
theorem radialPotential_exact_expansion (lam vacuum h : Real) :
    radialPotentialDensity lam vacuum (radialFluctuation vacuum h) =
      4 * lam * vacuum ^ 2 * h ^ 2 +
        4 * lam * vacuum * h ^ 3 + lam * h ^ 4 := by
  unfold radialPotentialDensity radialFluctuation
  rw [Complex.normSq_ofReal]
  ring

/-- The quadratic term is exactly one half of `radialMassSquared` times the
square of the radial fluctuation. -/
theorem radialPotential_eq_massTerm_add_interactions
    (lam vacuum h : Real) :
    radialPotentialDensity lam vacuum (radialFluctuation vacuum h) =
      (1 / 2 : Real) * radialMassSquared lam vacuum * h ^ 2 +
        4 * lam * vacuum * h ^ 3 + lam * h ^ 4 := by
  rw [radialPotential_exact_expansion]
  unfold radialMassSquared
  ring

/-- Positive quartic coupling and a nonzero vacuum give strictly positive
radial mass squared in this normalization. -/
theorem radialMassSquared_pos
    {lam vacuum : Real} (hLam : 0 < lam) (hVacuum : vacuum ≠ 0) :
    0 < radialMassSquared lam vacuum := by
  unfold radialMassSquared
  positivity

/-- A nonzero vacuum does not by itself fix the radial mass: setting the
quartic coupling to zero makes the radial curvature vanish. -/
theorem radialMassSquared_zero_of_zero_coupling (vacuum : Real) :
    radialMassSquared 0 vacuum = 0 := by
  simp [radialMassSquared]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsRadialCurvature.radialPotential_exact_expansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms radialPotential_exact_expansion

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsRadialCurvature.radialPotential_eq_massTerm_add_interactions' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms radialPotential_eq_massTerm_add_interactions

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsRadialCurvature.radialMassSquared_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms radialMassSquared_pos

end PhysicsSM.Draft.NullEdge.HiggsRadialCurvature

end
