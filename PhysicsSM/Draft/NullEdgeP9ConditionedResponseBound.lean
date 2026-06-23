import Mathlib.Tactic

/-!
# P9 conditioned response bound

This draft module isolates the condition-number style guardrail for the P9
harmonic/noise channel. If a finite response is bounded above and below by the
projected norm square, then zero response has no hidden projected mode and the
response-to-projected-norm ratio stays between the stated constants.

Proven by Aristotle project `e6ef0730-727a-48e9-a5df-5be70830db99` on
2026-06-23 from the focused package
`null-edge-p9-conditioned-response-bound-20260623`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9ConditionedResponseBound

open BigOperators

abbrev Cochain (n : Nat) := Fin n -> Real

def dot {n : Nat} (x y : Cochain n) : Real :=
  Finset.univ.sum fun i => x i * y i

def normSq {n : Nat} (x : Cochain n) : Real :=
  dot x x

def ResponseBoundedOnProjection {n : Nat}
    (proj : Cochain n -> Cochain n)
    (response : Cochain n -> Real)
    (alpha beta : Real) : Prop :=
  forall t : Cochain n,
    alpha * normSq (proj t) <= response t /\
      response t <= beta * normSq (proj t)

theorem normSq_nonneg {n : Nat} (x : Cochain n) : 0 <= normSq x := by
  unfold normSq dot
  exact Finset.sum_nonneg fun i _ => mul_self_nonneg (x i)

theorem zero_response_forces_zero_projected_norm
    {n : Nat} (proj : Cochain n -> Cochain n)
    (response : Cochain n -> Real)
    (alpha beta : Real)
    (hbound : ResponseBoundedOnProjection proj response alpha beta)
    (halpha : 0 < alpha)
    (t : Cochain n)
    (hzero : response t = 0) :
    normSq (proj t) = 0 := by
  have hnon := normSq_nonneg (proj t)
  have hle := (hbound t).1
  nlinarith

theorem response_ratio_le_beta
    {n : Nat} (proj : Cochain n -> Cochain n)
    (response : Cochain n -> Real)
    (alpha beta : Real)
    (hbound : ResponseBoundedOnProjection proj response alpha beta)
    (t : Cochain n)
    (hnorm : 0 < normSq (proj t)) :
    response t / normSq (proj t) <= beta := by
  field_simp [ne_of_gt hnorm]
  nlinarith [(hbound t).2]

theorem alpha_le_response_ratio
    {n : Nat} (proj : Cochain n -> Cochain n)
    (response : Cochain n -> Real)
    (alpha beta : Real)
    (hbound : ResponseBoundedOnProjection proj response alpha beta)
    (t : Cochain n)
    (hnorm : 0 < normSq (proj t)) :
    alpha <= response t / normSq (proj t) := by
  field_simp [ne_of_gt hnorm]
  nlinarith [(hbound t).1]

theorem response_ratio_between
    {n : Nat} (proj : Cochain n -> Cochain n)
    (response : Cochain n -> Real)
    (alpha beta : Real)
    (hbound : ResponseBoundedOnProjection proj response alpha beta)
    (t : Cochain n)
    (hnorm : 0 < normSq (proj t)) :
    alpha <= response t / normSq (proj t) /\
      response t / normSq (proj t) <= beta := by
  exact And.intro
    (alpha_le_response_ratio proj response alpha beta hbound t hnorm)
    (response_ratio_le_beta proj response alpha beta hbound t hnorm)

end PhysicsSM.Draft.NullEdgeP9ConditionedResponseBound
