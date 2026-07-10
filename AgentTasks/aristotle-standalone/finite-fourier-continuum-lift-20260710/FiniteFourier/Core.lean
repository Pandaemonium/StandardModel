import Mathlib

open scoped BigOperators Topology

namespace FiniteFourier

variable {ι E : Type*} [Fintype ι] [DecidableEq ι]
  [NormedAddCommGroup E] [NormedSpace ℂ E]

noncomputable def synth (phase : ι -> ℂ) (f : ι -> E) : E :=
  ∑ k, phase k • f k

theorem synth_sub (phase : ι -> ℂ) (f g : ι -> E) :
    synth phase f - synth phase g = synth phase (fun k => f k - g k) := by
  sorry

/-- Uniform modewise error on a finite momentum grid lifts to a synthesized
position-space error with the explicit cardinality factor. -/
theorem finite_fourier_error_bound (phase : ι -> ℂ) (approx exact : ι -> E)
    (ε : ℝ) (hε : 0 ≤ ε)
    (hphase : ∀ k, ‖phase k‖ ≤ 1)
    (herr : ∀ k, ‖approx k - exact k‖ ≤ ε) :
    ‖synth phase approx - synth phase exact‖ ≤ (Fintype.card ι : ℝ) * ε := by
  sorry

/-- A uniform `D/n` symbol estimate on a fixed finite momentum grid implies
convergence of the finite Fourier synthesis. -/
theorem finite_fourier_tendsto (phase : ι -> ℂ)
    (approx : ℕ -> ι -> E) (exact : ι -> E) (D : ℝ)
    (hD : 0 ≤ D) (hphase : ∀ k, ‖phase k‖ ≤ 1)
    (herr : ∀ n, 0 < n -> ∀ k,
      ‖approx n k - exact k‖ ≤ D / (n : ℝ)) :
    Filter.Tendsto (fun n => synth phase (approx n)) Filter.atTop
      (nhds (synth phase exact)) := by
  sorry

def twoPhase : Fin 2 -> ℂ := ![1, 1]
def twoModes : Fin 2 -> ℂ := ![1, 1]

theorem two_mode_sharp_witness :
    synth twoPhase twoModes = 2 ∧
      ‖synth twoPhase twoModes‖ = (Fintype.card (Fin 2) : ℝ) * 1 := by
  sorry

end FiniteFourier
