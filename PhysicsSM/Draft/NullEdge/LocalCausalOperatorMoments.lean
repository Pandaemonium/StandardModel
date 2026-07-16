import Mathlib

/-!
# Ideal moment audit for a local causal operator

This draft module records the exact finite algebra behind the local
causal-set d'Alembertian proposed by Boguna and Krioukov. Their source
convention is `(-,+,+,...)`; `projectLocalStencil` applies the global sign
needed for the project's `(+---)` convention.

The temporal endpoints, spatial neighborhood means, scale, and balance
constant are supplied. The theorems prove constant and affine cancellation
and the intended quadratic principal symbol when the displayed source moment
relations hold. They do not construct the neighborhoods or distances from a
causal order, prove concentration, or establish a curved-space limit.

Provenance: M. Boguna and D. Krioukov, "Local d'Alembertian for causal sets,"
arXiv:2506.18745, equations (84)--(91). This is a clean-room formalization of
the mathematical stencil, with an explicit convention conversion.

Claim grade: `M [comp]` for the finite algebra only.
-/

namespace PhysicsSM.Draft.NullEdge.LocalCausalOperatorMoments

noncomputable section

/-- A centered second difference formed from two endpoint or neighborhood
mean values at a common scale. -/
def secondDifference
    (scale center forward backward : ℝ) : ℝ :=
  (forward + backward - 2 * center) / scale ^ 2

/-- The source-sign local operator response
`-(C+d+1) D_t + C D_s`. -/
def sourceLocalResponse
    (spatialDimension : ℕ) (C temporal spatial : ℝ) : ℝ :=
  -(C + spatialDimension + 1) * temporal + C * spatial

/-- Evaluate the source-sign operator from temporal endpoints and two spatial
neighborhood means. -/
def sourceLocalStencil
    (spatialDimension : ℕ) (C scale center : ℝ)
    (temporalForward temporalBackward : ℝ)
    (spatialForwardMean spatialBackwardMean : ℝ) : ℝ :=
  sourceLocalResponse spatialDimension C
    (secondDifference scale center temporalForward temporalBackward)
    (secondDifference scale center spatialForwardMean spatialBackwardMean)

/-- The project-sign response for signature `(+---)`. -/
def projectLocalStencil
    (spatialDimension : ℕ) (C scale center : ℝ)
    (temporalForward temporalBackward : ℝ)
    (spatialForwardMean spatialBackwardMean : ℝ) : ℝ :=
  -sourceLocalStencil spatialDimension C scale center
    temporalForward temporalBackward
    spatialForwardMean spatialBackwardMean

/-- Constants are annihilated exactly, independently of scale and balance. -/
theorem projectLocalStencil_constant
    (spatialDimension : ℕ) (C scale value : ℝ) :
    projectLocalStencil spatialDimension C scale value
      value value value value = 0 := by
  unfold projectLocalStencil sourceLocalStencil sourceLocalResponse
    secondDifference
  ring

/-- Opposite first moments cancel exactly in both the temporal pair and the
two spatial neighborhood means. -/
theorem projectLocalStencil_affineCancellation
    (spatialDimension : ℕ) (C scale center temporalDrift spatialDrift : ℝ) :
    projectLocalStencil spatialDimension C scale center
      (center + temporalDrift) (center - temporalDrift)
      (center + spatialDrift) (center - spatialDrift) = 0 := by
  unfold projectLocalStencil sourceLocalStencil sourceLocalResponse
    secondDifference
  ring

/-- Under the source temporal/spatial second-moment relation, the project-sign
operator maps the temporal coordinate square to `2`. -/
theorem projectLocalStencil_temporalQuadratic
    {spatialDimension : ℕ} {C scale : ℝ}
    (hC : C ≠ 0) (hscale : scale ≠ 0) :
    projectLocalStencil spatialDimension C scale 0
      (scale ^ 2) (scale ^ 2)
      (((spatialDimension : ℝ) / C + 1) * scale ^ 2)
      (((spatialDimension : ℝ) / C + 1) * scale ^ 2) = 2 := by
  unfold projectLocalStencil sourceLocalStencil sourceLocalResponse
    secondDifference
  field_simp [hC, hscale]
  ring

/-- Under isotropic spatial second moments `scale^2/C`, the project-sign
operator maps each spatial coordinate square to `-2`. -/
theorem projectLocalStencil_spatialQuadratic
    {spatialDimension : ℕ} {C scale : ℝ}
    (hC : C ≠ 0) (hscale : scale ≠ 0) :
    projectLocalStencil spatialDimension C scale 0
      0 0 (scale ^ 2 / C) (scale ^ 2 / C) = -2 := by
  unfold projectLocalStencil sourceLocalStencil sourceLocalResponse
    secondDifference
  field_simp [hC, hscale]
  ring

/-- Vanishing mixed second moments give a zero off-diagonal response. -/
theorem projectLocalStencil_mixedQuadratic
    (spatialDimension : ℕ) (C scale : ℝ) :
    projectLocalStencil spatialDimension C scale 0 0 0 0 0 = 0 := by
  exact projectLocalStencil_constant spatialDimension C scale 0

/-- The diagonal corrected pairing read from temporal and spatial quadratic
responses in `3+1` dimensions. -/
def quadraticMetricDiagonal
    (temporalResponse spatialResponse : ℝ) (i : Fin 4) : ℝ :=
  if i = 0 then temporalResponse / 2 else spatialResponse / 2

/-- The ideal local stencil induces the exact `(+---)` metric diagonal. -/
theorem projectLocalStencil_quadraticMetricDiagonal
    {C scale : ℝ} (hC : C ≠ 0) (hscale : scale ≠ 0) :
    quadraticMetricDiagonal
        (projectLocalStencil 3 C scale 0
          (scale ^ 2) (scale ^ 2)
          ((((3 : ℕ) : ℝ) / C + 1) * scale ^ 2)
          ((((3 : ℕ) : ℝ) / C + 1) * scale ^ 2))
        (projectLocalStencil 3 C scale 0
          0 0 (scale ^ 2 / C) (scale ^ 2 / C)) =
      fun i => if i = 0 then 1 else -1 := by
  rw [projectLocalStencil_temporalQuadratic
    (spatialDimension := 3) hC hscale]
  rw [projectLocalStencil_spatialQuadratic
    (spatialDimension := 3) hC hscale]
  funext i
  by_cases hi : i = 0 <;> simp [quadraticMetricDiagonal, hi]

end

end PhysicsSM.Draft.NullEdge.LocalCausalOperatorMoments
