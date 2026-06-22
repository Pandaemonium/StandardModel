import Mathlib

/-!
# Finite diamond-source visibility API toy model

This module records the first observer-facing API for the P9
source-visibility campaign.

It packages three finite notions:

* `BoundaryExact D source`: the source is generated from boundary bookkeeping.
* `BulkClosed D test`: the bulk test has zero adjoint divergence.
* `InvisibleToClosedBulkTests D source`: the source pairs to zero against every
  closed bulk test.

The module also includes a one-face sanity check: with no boundary cells, the
constant unit source is visible to the unit test and is not boundary-exact. This
prevents the API from becoming vacuous.

Proven by Aristotle project `4b710873-4cce-4c84-b55f-52ac55c92669`
on 2026-06-22 from the focused standalone package
`null-edge-p9-diamond-visibility-api-20260622`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9DiamondVisibility

abbrev Cochain (n : Nat) := Fin n -> Real

/-- Finite Euclidean pairing on `Fin n` cochains. -/
def dot {n : Nat} (x y : Cochain n) : Real :=
  Finset.univ.sum fun i => x i * y i

/-- Pair a finite source with a finite bulk test observable. -/
def sourcePairing {n : Nat} (source test : Cochain n) : Real :=
  dot source test

/-- Boundary-generated source or cochain induced by an incidence matrix. -/
def boundarySource {b f : Nat} (D : Fin b -> Fin f -> Real)
    (a : Cochain b) : Cochain f :=
  fun i => Finset.univ.sum fun j => D j i * a j

/-- Adjoint divergence of a face test against the same incidence matrix. -/
def codiff {b f : Nat} (D : Fin b -> Fin f -> Real)
    (test : Cochain f) : Cochain b :=
  fun j => Finset.univ.sum fun i => D j i * test i

/-- A bulk test is closed when its adjoint divergence vanishes. -/
def BulkClosed {b f : Nat} (D : Fin b -> Fin f -> Real)
    (test : Cochain f) : Prop :=
  codiff D test = 0

/-- A source is boundary-exact when it is generated from boundary data. -/
def BoundaryExact {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) : Prop :=
  exists a : Cochain b, source = boundarySource D a

/-- A source is invisible to all closed bulk tests. -/
def InvisibleToClosedBulkTests {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) : Prop :=
  forall test : Cochain f, BulkClosed D test -> sourcePairing source test = 0

/-- Boundary-exact source terms are invisible to closed bulk tests. -/
theorem boundaryExact_invisible_to_closed_tests
    {b f : Nat} (D : Fin b -> Fin f -> Real) (source : Cochain f)
    (hsource : BoundaryExact D source) :
    InvisibleToClosedBulkTests D source := by
  obtain ⟨a, ha⟩ := hsource
  intro test htest
  simp [ha, sourcePairing, dot]
  have h_codiff_zero : ∀ j, Finset.univ.sum (fun i => D j i * test i) = 0 := by
    exact fun j => congr_fun htest j
  have h_fubini :
      Finset.univ.sum (fun x => (Finset.univ.sum fun j => D j x * a j) * test x) =
        Finset.univ.sum (fun j => a j * (Finset.univ.sum fun x => D j x * test x)) := by
    simpa only [mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _] using
      Finset.sum_comm
  aesop

/-- No-boundary incidence matrix for the one-face test example. -/
def emptyBoundaryToOneFace : Fin 0 -> Fin 1 -> Real :=
  fun _ _ => 0

/-- Constant unit source on the one-face toy diamond. -/
def unitSource : Cochain 1 :=
  fun _ => 1

/-- Constant unit test on the one-face toy diamond. -/
def unitTest : Cochain 1 :=
  fun _ => 1

/-- The unit test is closed when there are no boundary cells. -/
theorem unitTest_closed_emptyBoundary :
    BulkClosed emptyBoundaryToOneFace unitTest := by
  exact funext fun x => by fin_cases x

/-- The unit source is visible to the unit test. -/
theorem unitSource_pairing_unitTest_eq_one :
    sourcePairing unitSource unitTest = 1 := by
  unfold sourcePairing unitSource unitTest dot
  norm_num

/-- The unit source is not boundary-exact when there are no boundary cells. -/
theorem unitSource_not_boundaryExact_emptyBoundary :
    Not (BoundaryExact emptyBoundaryToOneFace unitSource) := by
  by_contra h
  obtain ⟨a, ha⟩ := h
  exact absurd (congr_fun ha 0)
    (by norm_num [unitSource, boundarySource, emptyBoundaryToOneFace])

/--
There exists a closed-test-visible source that is not boundary-exact.

This is a minimal sanity check for the P9 visibility vocabulary: the API
distinguishes boundary bookkeeping from genuinely bulk-visible source data.
-/
theorem exists_bulkVisible_not_boundaryExact :
    exists source test : Cochain 1,
      And (BulkClosed emptyBoundaryToOneFace test)
        (And (sourcePairing source test = 1)
          (Not (BoundaryExact emptyBoundaryToOneFace source))) := by
  exact ⟨unitSource, unitTest, unitTest_closed_emptyBoundary,
    unitSource_pairing_unitTest_eq_one, unitSource_not_boundaryExact_emptyBoundary⟩

end PhysicsSM.Draft.NullEdgeP9DiamondVisibility
