import Mathlib.Tactic

/-!
# P9 screen-supported variance bound

This standalone file isolates the finite scaling inequality needed by the P9
source-visibility/noise branch.

Physics context: if the observer-visible residual source is supported only on
screen cells rather than volume cells, the residual second moment scales with
the screen cell count. This is useful as a vacuum-source filtering theorem, but
it may suppress the residual more strongly than the observed cosmological
constant unless a global or harmonic mode survives.
-/

namespace NullEdgeP9ScreenVarianceBound.Core

open BigOperators

/-- A finite source amplitude vector on `Fin n`. -/
abbrev Amp (n : Nat) := Fin n -> Real

/-- Total second moment on a preselected screen support. -/
noncomputable def screenSecondMoment {n : Nat} (screen : Finset (Fin n))
    (amp : Amp n) : Real :=
  screen.sum fun i => (amp i) ^ 2

/--
If every screen-supported amplitude has squared size at most `sigmaSq`, the
screen second moment is at most `screen.card * sigmaSq`.
-/
theorem screenSecondMoment_le_card_mul_sigmaSq {n : Nat}
    (screen : Finset (Fin n)) (amp : Amp n) (sigmaSq : Real)
    (hsigma_nonneg : 0 <= sigmaSq)
    (hbound : forall i, i ∈ screen -> (amp i) ^ 2 <= sigmaSq) :
    screenSecondMoment screen amp <= (screen.card : Real) * sigmaSq := by
  sorry

/--
Normalized residual variance bound. This is the finite form of the P9 scaling
claim `variance <= N_screen * sigmaSq / V^2`.
-/
theorem normalized_screen_variance_bound {n : Nat}
    (screen : Finset (Fin n)) (amp : Amp n) (sigmaSq volume : Real)
    (hsigma_nonneg : 0 <= sigmaSq)
    (hvolume_pos : 0 < volume)
    (hbound : forall i, i ∈ screen -> (amp i) ^ 2 <= sigmaSq) :
    screenSecondMoment screen amp / (volume ^ 2)
      <= ((screen.card : Real) * sigmaSq) / (volume ^ 2) := by
  sorry

/--
If `screen.card <= volumeCells`, the screen-supported bound is no larger than
the corresponding volume-count bound. This theorem is intentionally modest:
it shows filtering, not by itself the observed dark-energy amplitude.
-/
theorem screen_bound_le_volume_bound {n : Nat}
    (screen : Finset (Fin n)) (volumeCells : Nat) (sigmaSq volume : Real)
    (hsigma_nonneg : 0 <= sigmaSq)
    (hvolume_pos : 0 < volume)
    (hcard : screen.card <= volumeCells) :
    ((screen.card : Real) * sigmaSq) / (volume ^ 2)
      <= ((volumeCells : Real) * sigmaSq) / (volume ^ 2) := by
  sorry

end NullEdgeP9ScreenVarianceBound.Core
