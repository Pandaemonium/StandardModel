import Mathlib

open scoped BigOperators Topology
open Filter

namespace SummableFourier

variable {ι E : Type*} [Countable ι]
  [NormedAddCommGroup E] [NormedSpace ℂ E] [CompleteSpace E]

noncomputable def synthInfinite (phase : ι -> ℂ) (f : ι -> E) : E :=
  ∑' k, phase k • f k

/-- A summable mode envelope lifts a pointwise relative error to an
infinite-volume synthesis bound. -/
theorem infinite_fourier_error_bound
    (phase : ι -> ℂ) (approx exact : ι -> E)
    (g : ι -> ℝ) (ε : ℝ)
    (hg : Summable g) (hg0 : ∀ k, 0 ≤ g k) (hε : 0 ≤ ε)
    (hphase : ∀ k, ‖phase k‖ ≤ 1)
    (ha : Summable fun k => phase k • approx k)
    (he : Summable fun k => phase k • exact k)
    (herr : ∀ k, ‖approx k - exact k‖ ≤ ε * g k) :
    ‖synthInfinite phase approx - synthInfinite phase exact‖ ≤
      ε * ∑' k, g k := by
  sorry

/-- A vanishing relative envelope gives convergence of the infinite Fourier
synthesis, provided every synthesized series is summable. -/
theorem infinite_fourier_tendsto
    (phase : ι -> ℂ) (approx : ℕ -> ι -> E) (exact : ι -> E)
    (g : ι -> ℝ) (ε : ℕ -> ℝ)
    (hg : Summable g) (hg0 : ∀ k, 0 ≤ g k)
    (hε0 : Tendsto ε atTop (nhds 0)) (hε : ∀ n, 0 ≤ ε n)
    (hphase : ∀ k, ‖phase k‖ ≤ 1)
    (ha : ∀ n, Summable fun k => phase k • approx n k)
    (he : Summable fun k => phase k • exact k)
    (herr : ∀ n k, ‖approx n k - exact k‖ ≤ ε n * g k) :
    Tendsto (fun n => synthInfinite phase (approx n)) atTop
      (nhds (synthInfinite phase exact)) := by
  sorry

noncomputable def geometricEnvelope (k : ℕ) : ℝ :=
  (1 / 2 : ℝ) ^ (k + 1)

theorem geometric_envelope_witness :
    Summable geometricEnvelope ∧
      (∑' k, geometricEnvelope k) = 1 ∧ geometricEnvelope 0 > 0 := by
  sorry

end SummableFourier
