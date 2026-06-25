import PhysicsSM.Draft.NullEdgeP2P9ReflectionScreenVariance

/-!
# Draft.NullEdgeP2P9ReflectionIterationVariance

This module strengthens the finite P2/P9 bridge from one pointwise branch
reflection to repeated finite local branch reflections.

The one-step module proves that an on-shell branch reflection preserves the
real two-component fiber norm and the P9 screen second moment. Here we prove
that any finite iterate of that same pointwise reflection preserves the screen
second moment, and therefore preserves the screen-cardinality variance bound.

This remains finite screen arithmetic and finite `2 x 2` real algebra. It does
not introduce a shift operator, boundary condition, continuum walk, or
gravitational response law.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP2P9ReflectionIterationVariance

abbrev Vec2 := PhysicsSM.Draft.NullEdgeP2P9ReflectionScreenVariance.Vec2

abbrev vecNormSq := PhysicsSM.Draft.NullEdgeP2P9ReflectionScreenVariance.vecNormSq

/-- Screen second moment for a two-component amplitude over screen cells. -/
def screenFiberSecondMoment {n : Nat} (screen : Finset (Fin n))
    (amp : Fin n -> Vec2) : Real :=
  PhysicsSM.Draft.NullEdgeP2P9ReflectionScreenVariance.screenFiberSecondMoment screen amp

/-- Apply the same branch reflection pointwise to every screen-cell fiber. -/
def reflectAmp {n : Nat} (h p m E : Real) (amp : Fin n -> Vec2) :
    Fin n -> Vec2 :=
  fun c => PhysicsSM.Draft.NullEdgeP2P9ReflectionScreenVariance.matVec
    (PhysicsSM.Draft.NullEdgeP2P9ReflectionScreenVariance.branchReflection h p m E)
    (amp c)

/-- One pointwise branch reflection preserves the screen second moment. -/
theorem reflectAmp_preserves_screenFiberSecondMoment_on_massShell
    {n : Nat} (screen : Finset (Fin n)) (amp : Fin n -> Vec2)
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    screenFiberSecondMoment screen (reflectAmp h p m E amp)
      = screenFiberSecondMoment screen amp := by
  exact PhysicsSM.Draft.NullEdgeP2P9ReflectionScreenVariance.branchReflection_preserves_screenFiberSecondMoment_on_massShell
    screen amp h p m E hh hE0 hshell

/--
Any finite number of repeated pointwise branch reflections preserves the screen
second moment.
-/
theorem iterated_reflectAmp_preserves_screenFiberSecondMoment_on_massShell
    {n : Nat} (screen : Finset (Fin n)) (amp : Fin n -> Vec2)
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) (k : Nat) :
    screenFiberSecondMoment screen ((reflectAmp h p m E)^[k] amp)
      = screenFiberSecondMoment screen amp := by
  induction k with
  | zero => rfl
  | succ k ih =>
      rw [Function.iterate_succ_apply',
        reflectAmp_preserves_screenFiberSecondMoment_on_massShell
          screen _ h p m E hh hE0 hshell,
        ih]

/--
The screen-cardinality variance bound is stable under any finite number of
repeated pointwise branch reflections.
-/
theorem iterated_reflectAmp_screenFiberSecondMoment_le_card_mul_sigmaSq
    {n : Nat} (screen : Finset (Fin n)) (amp : Fin n -> Vec2)
    (h p m E sigmaSq : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) (_hsigma_nonneg : 0 <= sigmaSq)
    (hbound : forall c, c ∈ screen -> vecNormSq (amp c) <= sigmaSq)
    (k : Nat) :
    screenFiberSecondMoment screen ((reflectAmp h p m E)^[k] amp)
      <= (screen.card : Real) * sigmaSq := by
  rw [iterated_reflectAmp_preserves_screenFiberSecondMoment_on_massShell
    screen amp h p m E hh hE0 hshell k]
  exact le_trans (Finset.sum_le_sum hbound) (by simp [mul_comm])

end PhysicsSM.Draft.NullEdgeP2P9ReflectionIterationVariance

end
