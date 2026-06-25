import Mathlib
import PhysicsSM.NullStrand.Conventions
import PhysicsSM.NullStrand.NullFiber.FiniteDesign

/-!
# NullStrand.NullFiber.Basic

API entry point for the null-fiber core geometry.

This trusted module intentionally re-exports the draft-stage scaffolding under the
`PhysicsSM.NullStrand.NullFiber` namespace expected by the roadmap.
-/

noncomputable section

namespace PhysicsSM.NullStrand.NullFiber

structure NullFiber (U : Minkowski4) where
  k : Minkowski4
  future : IsFuture k
  null : IsNull k
  normalized : minkowskiInner U k = 1

structure RestSphere (U : Minkowski4) where
  xi : Minkowski4
  orthogonal : minkowskiInner U xi = 0
  unitSpacelike : minkowskiSq xi = -1

/-- Lift with explicit proof payload from a rest direction to a null-fiber point. -/
def restToNull (U : Minkowski4) (xi : RestSphere U)
    (hFuture : IsFuture (fun i => U i + xi.xi i)) (hNull : IsNull (fun i => U i + xi.xi i))
    (hNorm : minkowskiInner U (fun i => U i + xi.xi i) = 1) :
    NullFiber U :=
  ⟨fun i => U i + xi.xi i, hFuture, hNull, hNorm⟩

/-- Projection with explicit unit-future-timelike hypothesis on `U`. -/
def nullToRest (U : Minkowski4) (k : NullFiber U) (hU : IsUnitFutureTimelike U) : RestSphere U :=
  ⟨fun i => k.k i - U i, by
    have hInner :
        minkowskiInner U (fun i => k.k i - U i) =
          minkowskiInner U k.k - minkowskiSq U := by
      simp [minkowskiInner, minkowskiSq]
      ring
    nlinarith [hInner, k.normalized, hU.2],
    by
      have hSq :
          minkowskiSq (fun i => k.k i - U i) =
            minkowskiSq k.k + minkowskiSq U - 2 * minkowskiInner U k.k := by
        simp [minkowskiSq, minkowskiInner]
        ring
      have hkNull : minkowskiSq k.k = 0 := by
        simpa [IsNull] using k.null
      nlinarith [hSq, hkNull, k.normalized, hU.2]⟩

theorem restToNull_isFutureNull (U : Minkowski4) (xi : RestSphere U)
    (hFuture : IsFuture (fun i => U i + xi.xi i)) :
    IsFuture (fun i => U i + xi.xi i) := hFuture

theorem nullToRest_tangent (U : Minkowski4) (k : NullFiber U) (hU : IsUnitFutureTimelike U) :
    minkowskiInner U (nullToRest U k hU).xi = 0 :=
  (nullToRest U k hU).orthogonal

theorem nullToRest_isUnitSpacelike (U : Minkowski4) (k : NullFiber U)
    (hU : IsUnitFutureTimelike U) :
    minkowskiSq (nullToRest U k hU).xi = -1 :=
  (nullToRest U k hU).unitSpacelike

theorem nullFiber_nonempty (U : Minkowski4) (xi : RestSphere U)
    (hFuture : IsFuture (fun i => U i + xi.xi i)) (hNull : IsNull (fun i => U i + xi.xi i))
    (hNorm : minkowskiInner U (fun i => U i + xi.xi i) = 1) : Nonempty (NullFiber U) :=
  ⟨restToNull U xi hFuture hNull hNorm⟩

theorem nullFiber_equiv_restSphere (U : Minkowski4) (hU : IsUnitFutureTimelike U)
    (xi : RestSphere U) (hFuture : IsFuture (fun i => U i + xi.xi i))
    (hNull : IsNull (fun i => U i + xi.xi i))
    (hNorm : minkowskiInner U (fun i => U i + xi.xi i) = 1) :
    (nullToRest U (restToNull U xi hFuture hNull hNorm) hU).xi = xi.xi :=
  by
    funext i
    simp [nullToRest, restToNull]

end PhysicsSM.NullStrand.NullFiber
