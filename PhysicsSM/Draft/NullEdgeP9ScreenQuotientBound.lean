import Mathlib.Tactic

/-!
# P9 screen quotient response bound

This draft module integrates Aristotle project
`8763fcb1-96ff-4f2d-8c1a-599a3b052c11`.

Physics context: exact local bookkeeping should be invisible to closed screen
tests, while observer-visible residuals should have a finite screen-size
bound. This module packages the finite quotient layer for the P9
source-visibility program without identifying a screen projection with a
metric-dependent harmonic/Hodge projection.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9ScreenQuotientBound

open BigOperators

/-- A finite face cochain on a screen with `n` face cells. -/
abbrev FaceCochain (n : Nat) := Fin n -> Real

/-- A finite rim cochain whose weighted adjoint gives exact face bookkeeping. -/
abbrev RimCochain (m : Nat) := Fin m -> Real

/-- The ordinary finite pairing used for closed-test response. -/
def pairing {n : Nat} (source test : FaceCochain n) : Real :=
  Finset.univ.sum fun i => source i * test i

/--
Finite incidence data. The vector `inc r` is the exact-source generator
associated with the rim cell `r`.
-/
structure ExactData (n m : Nat) where
  inc : Fin m -> FaceCochain n

namespace ExactData

/-- Exact local bookkeeping: a finite linear combination of rim generators. -/
def exactSource {n m : Nat} (E : ExactData n m) (a : RimCochain m) :
    FaceCochain n :=
  fun i => Finset.univ.sum fun r => a r * E.inc r i

/-- A closed test annihilates every exact-source generator. -/
def ClosedTest {n m : Nat} (E : ExactData n m) (test : FaceCochain n) : Prop :=
  forall r : Fin m, pairing (E.inc r) test = 0

/-- Two sources agree in the quotient by exact local bookkeeping. -/
def SameModuloExact {n m : Nat} (E : ExactData n m)
    (source source' : FaceCochain n) : Prop :=
  exists a : RimCochain m, source' = fun i => source i + E.exactSource a i

/-- Exact local bookkeeping has zero response against every closed test. -/
theorem exactSource_pairing_closedTest_zero {n m : Nat} (E : ExactData n m)
    (a : RimCochain m) (test : FaceCochain n) (hclosed : E.ClosedTest test) :
    pairing (E.exactSource a) test = 0 := by
  -- Expand the pairing and exchange the two finite sums (discrete Fubini).
  have h_fubini :
      (∑ i : Fin n, (∑ r : Fin m, a r * E.inc r i) * test i)
        = ∑ r : Fin m, a r * ∑ i : Fin n, E.inc r i * test i := by
    simpa only [mul_assoc, Finset.mul_sum, Finset.sum_mul] using Finset.sum_comm
  unfold pairing exactSource
  refine h_fubini.trans (Finset.sum_eq_zero ?_)
  exact fun r _ => mul_eq_zero_of_right _ (hclosed r)

/--
Closed-test response is well-defined on the quotient by exact sources. This is
the finite observer-channel version of "boundary bookkeeping is invisible".
-/
theorem closedResponse_eq_of_sameModuloExact {n m : Nat} (E : ExactData n m)
    (source source' test : FaceCochain n) (hclosed : E.ClosedTest test)
    (hsame : E.SameModuloExact source source') :
    pairing source' test = pairing source test := by
  obtain ⟨a, rfl⟩ := hsame
  have h0 := exactSource_pairing_closedTest_zero E a test hclosed
  unfold pairing exactSource at h0 ⊢
  rw [Finset.sum_congr rfl (fun i _ => add_mul (source i) _ (test i)),
    Finset.sum_add_distrib, h0, add_zero]

/-- Adding an exact perturbation to a source does not change its closed response. -/
theorem closedResponse_stable_under_exact_perturbation {n m : Nat}
    (E : ExactData n m) (source test : FaceCochain n) (a : RimCochain m)
    (hclosed : E.ClosedTest test) :
    pairing (fun i => source i + E.exactSource a i) test = pairing source test :=
  closedResponse_eq_of_sameModuloExact E source _ test hclosed ⟨a, rfl⟩

/-- A source is supported on a chosen finite screen. -/
def SupportedOn {n : Nat} (screen : Finset (Fin n))
    (source : FaceCochain n) : Prop :=
  forall i : Fin n, i ∉ screen -> source i = 0

/-- Pointwise absolute-value bound on a source over a chosen screen. -/
def AbsBoundOn {n : Nat} (screen : Finset (Fin n))
    (source : FaceCochain n) (sigma : Real) : Prop :=
  forall i : Fin n, i ∈ screen -> |source i| <= sigma

/--
Finite screen response bound. If a residual source is supported on `screen`,
and source/test amplitudes are bounded there by `sigma` and `tau`, then the
closed-test response is bounded by `screen.card * sigma * tau`.

This supplies a finite-rank witness for the observer response; quotient
visibility is measured by an explicit finite screen observable, not by an
implicit continuum norm.
-/
theorem abs_pairing_le_screen_card_mul {n : Nat}
    (screen : Finset (Fin n)) (source test : FaceCochain n)
    (sigma tau : Real) (hsigma : 0 <= sigma)
    (hsupp : SupportedOn screen source)
    (hsource : AbsBoundOn screen source sigma)
    (htest : AbsBoundOn screen test tau) :
    |pairing source test| <= (screen.card : Real) * sigma * tau := by
  have hrestrict :
      pairing source test = ∑ i ∈ screen, source i * test i := by
    rw [pairing, ← Finset.sum_subset (Finset.subset_univ screen)]
    intro i _ hi
    rw [hsupp i hi, zero_mul]
  calc |pairing source test|
      = |∑ i ∈ screen, source i * test i| := by rw [hrestrict]
    _ ≤ ∑ i ∈ screen, |source i * test i| := Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ _i ∈ screen, sigma * tau := by
        refine Finset.sum_le_sum (fun i hi => ?_)
        rw [abs_mul]
        exact mul_le_mul (hsource i hi) (htest i hi) (abs_nonneg _) hsigma
    _ = (screen.card : Real) * sigma * tau := by
        rw [Finset.sum_const, nsmul_eq_mul, mul_assoc]

end ExactData

end PhysicsSM.Draft.NullEdgeP9ScreenQuotientBound
