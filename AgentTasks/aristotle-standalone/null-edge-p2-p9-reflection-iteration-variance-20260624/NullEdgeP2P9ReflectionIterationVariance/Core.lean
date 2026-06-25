import Mathlib

/-!
# Iterated P2 reflection preserves P9 screen variance

This standalone target strengthens the finite P2/P9 bridge from one pointwise
branch reflection to any finite number of repeated branch reflections.

Physics context: a single on-shell branch reflection `R = H/E` preserves the
two-component fiber norm and therefore the P9 screen second moment. The finite
closure theorem says that repeated local reflection steps cannot create screen
variance either. This is a discrete stability theorem for the already-defined
reflection observable, not a null-step walk, shift operator, boundary condition,
continuum limit, or gravitational response law.
-/

noncomputable section

namespace NullEdgeP2P9ReflectionIterationVariance

open BigOperators Matrix

abbrev RMat2 := Matrix (Fin 2) (Fin 2) Real
abbrev Vec2 := Fin 2 -> Real

/-- Two-level chiral Hamiltonian for fixed helicity sign `h`. -/
def chiralHamiltonian (h p m : Real) : RMat2 :=
  !![-h * p, m; m, h * p]

/-- Branch reflection in scalar form. -/
def branchReflection (h p m E : Real) : RMat2 :=
  E⁻¹ • chiralHamiltonian h p m

/-- Matrix-vector action on a real two-component fiber. -/
def matVec (M : RMat2) (v : Vec2) : Vec2 :=
  fun i => Finset.univ.sum fun j => M i j * v j

/-- Squared Euclidean norm of a real two-component fiber. -/
def vecNormSq (v : Vec2) : Real :=
  Finset.univ.sum fun i => v i ^ 2

/-- Screen second moment for a two-component amplitude over screen cells. -/
def screenFiberSecondMoment {n : Nat} (screen : Finset (Fin n))
    (amp : Fin n -> Vec2) : Real :=
  screen.sum fun c => vecNormSq (amp c)

/-- Apply the same branch reflection pointwise to every screen-cell fiber. -/
def reflectAmp {n : Nat} (h p m E : Real) (amp : Fin n -> Vec2) :
    Fin n -> Vec2 :=
  fun c => matVec (branchReflection h p m E) (amp c)

/-
One branch reflection preserves the real fiber norm on shell.
-/
theorem branchReflection_preserves_vecNormSq_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) (v : Vec2) :
    vecNormSq (matVec (branchReflection h p m E) v) = vecNormSq v := by
  unfold vecNormSq matVec branchReflection
  simp +decide [Fin.sum_univ_two, chiralHamiltonian]
  grind

/-- One pointwise branch reflection preserves the screen second moment. -/
theorem reflectAmp_preserves_screenFiberSecondMoment_on_massShell
    {n : Nat} (screen : Finset (Fin n)) (amp : Fin n -> Vec2)
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    screenFiberSecondMoment screen (reflectAmp h p m E amp)
      = screenFiberSecondMoment screen amp := by
  exact Finset.sum_congr rfl fun _ _ =>
    branchReflection_preserves_vecNormSq_on_massShell h p m E hh hE0 hshell _

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
      reflectAmp_preserves_screenFiberSecondMoment_on_massShell screen _ h p m E hh hE0 hshell,
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
  simpa using Finset.sum_le_sum hbound

end NullEdgeP2P9ReflectionIterationVariance

end
