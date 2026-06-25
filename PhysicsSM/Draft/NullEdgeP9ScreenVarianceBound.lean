import Mathlib.Tactic

/-!
# Draft.NullEdgeP9ScreenVarianceBound

This module isolates a finite screen-supported variance bound for the P9
source-visibility/noise lane.

If the observer-visible residual source is supported only on screen cells and
each screen amplitude has squared size at most `sigmaSq`, then the total second
moment is bounded by the screen cardinality times `sigmaSq`. This is a finite
scaling theorem only: it supports a screen-versus-volume noise distinction, but
does not by itself supply a gravitational response law or a cosmological
constant amplitude.
-/

namespace PhysicsSM.Draft.NullEdgeP9ScreenVarianceBound

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

The nonnegativity hypothesis is kept for publication-facing clarity even though
the finite sum proof does not need it directly.
-/
theorem screenSecondMoment_le_card_mul_sigmaSq {n : Nat}
    (screen : Finset (Fin n)) (amp : Amp n) (sigmaSq : Real)
    (_hsigma_nonneg : 0 <= sigmaSq)
    (hbound : forall i, i ∈ screen -> (amp i) ^ 2 <= sigmaSq) :
    screenSecondMoment screen amp <= (screen.card : Real) * sigmaSq := by
  exact le_trans (Finset.sum_le_sum hbound) (by simp [mul_comm])

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
  gcongr
  exact screenSecondMoment_le_card_mul_sigmaSq screen amp sigmaSq hsigma_nonneg hbound

/--
If `screen.card <= volumeCells`, the screen-supported bound is no larger than
the corresponding volume-count bound. This theorem is intentionally modest: it
shows filtering, not by itself the observed dark-energy amplitude.
-/
theorem screen_bound_le_volume_bound {n : Nat}
    (screen : Finset (Fin n)) (volumeCells : Nat) (sigmaSq volume : Real)
    (hsigma_nonneg : 0 <= sigmaSq)
    (hvolume_pos : 0 < volume)
    (hcard : screen.card <= volumeCells) :
    ((screen.card : Real) * sigmaSq) / (volume ^ 2)
      <= ((volumeCells : Real) * sigmaSq) / (volume ^ 2) := by
  gcongr

end PhysicsSM.Draft.NullEdgeP9ScreenVarianceBound
