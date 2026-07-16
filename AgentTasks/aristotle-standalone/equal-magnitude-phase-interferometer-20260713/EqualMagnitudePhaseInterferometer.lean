import PhysicsSM.Draft.NullEdge.U1HistoryClosureHolonomy

/-!
# Aristotle target: equal-magnitude phase-profile interferometer

Two edge profiles can have exactly the same local magnitudes while carrying
different closed-loop phase. This target proves that a gauge-invariant finite
interference score distinguishes the trivial square profile from the landed
`I`-holonomy profile.

This is an operational finite `U(1)` phase discriminator. The edge phases are
supplied data: the theorem does not yet derive them from local Pluecker fields,
embed the pair-transfer dynamics, or claim an experimental prediction.
-/

noncomputable section

open Complex

namespace PhysicsSM.Draft.NullEdge.EqualMagnitudePhaseInterferometer

open U1HistoryClosureHolonomy

/-- Unit edge field with trivial phase on every edge. -/
def trivialSquareEdgeField : EdgeField (Fin 4) := fun _ _ => 1

/-- Amplitude obtained by interfering a reference path of amplitude one with
the fixed oriented square loop. -/
def squareInterferenceAmplitude (U : EdgeField (Fin 4)) : Complex :=
  1 + pathHolonomyFrom U (0 : Fin 4) [1, 2, 3, 0]

/-- Gauge-invariant intensity of the two-path interference amplitude. -/
def squareInterferenceScore (U : EdgeField (Fin 4)) : Real :=
  Complex.normSq (squareInterferenceAmplitude U)

/-- The trivial and nontrivial profiles have identical local edge magnitudes. -/
theorem equal_local_magnitudes :
    ∀ x y : Fin 4,
      Complex.normSq (trivialSquareEdgeField x y) =
        Complex.normSq (squareEdgeField x y) := by
  intro x y
  simp only [trivialSquareEdgeField, squareEdgeField]
  split <;> simp [Complex.normSq]

/-- The interference score is invariant under every unit-norm vertex gauge
transformation. -/
theorem squareInterferenceScore_gauge_invariant
    (g : Gauge (Fin 4)) (U : EdgeField (Fin 4))
    (hg : ∀ v, Complex.normSq (g v) = 1) :
    squareInterferenceScore (gaugeTransform g U) =
      squareInterferenceScore U := by
  unfold squareInterferenceScore squareInterferenceAmplitude
  rw [closed_pathHolonomy_gauge_invariant g U hg (0 : Fin 4) [1, 2, 3, 0]
    square_loop_closes]

/-- Exact control: trivial square holonomy gives maximal constructive score
`4`. -/
theorem trivial_square_score :
    squareInterferenceScore trivialSquareEdgeField = 4 := by
  unfold squareInterferenceScore squareInterferenceAmplitude
  simp [pathHolonomyFrom, trivialSquareEdgeField, Complex.normSq]
  norm_num

/-- Exact nontrivial fixture: the `I`-holonomy square has score `2`. -/
theorem nontrivial_square_score :
    squareInterferenceScore squareEdgeField = 2 := by
  unfold squareInterferenceScore squareInterferenceAmplitude
  rw [square_nontrivial_gauge_invariant_witness.1]
  simp [Complex.normSq]
  norm_num

/-- **Operational phase capstone.** Equal local magnitudes coexist with an
exact, gauge-invariant difference in a closed-loop interference score. -/
theorem equal_magnitude_profiles_are_operationally_distinct :
    (∀ x y : Fin 4,
      Complex.normSq (trivialSquareEdgeField x y) =
        Complex.normSq (squareEdgeField x y)) ∧
      squareInterferenceScore trivialSquareEdgeField ≠
        squareInterferenceScore squareEdgeField ∧
      (∀ (g : Gauge (Fin 4)),
        (∀ v, Complex.normSq (g v) = 1) ->
          squareInterferenceScore (gaugeTransform g squareEdgeField) = 2) := by
  refine ⟨equal_local_magnitudes, ?_, ?_⟩
  · rw [trivial_square_score, nontrivial_square_score]
    norm_num
  · intro g hg
    rw [squareInterferenceScore_gauge_invariant g squareEdgeField hg]
    exact nontrivial_square_score

end PhysicsSM.Draft.NullEdge.EqualMagnitudePhaseInterferometer
