import Mathlib

/-!
# P2/P9 reflection-screen variance bridge

This standalone target composes two newly integrated null-edge artifacts.

Physics context:

- P2 supplies a finite branch reflection `R = P+ - P-`, equivalently `R = H/E`
  on the mass shell, for the two-level chiral Hamiltonian.
- P9 supplies finite screen-supported second-moment bounds.

The bridge theorem says that the P2 reflection preserves the fiber norm at each
screen cell, so applying the branch reflection pointwise cannot create or
destroy the P9 screen second moment. This is finite `2 x 2` real algebra plus a
finite `Finset` sum. It does not introduce a shift operator, boundary condition,
continuum walk, or gravitational response law.
-/

noncomputable section

namespace NullEdgeP2P9ReflectionScreenVariance

open BigOperators Matrix

abbrev RMat2 := Matrix (Fin 2) (Fin 2) Real
abbrev Vec2 := Fin 2 -> Real

/-- Two-level chiral Hamiltonian for fixed helicity sign `h`. -/
def chiralHamiltonian (h p m : Real) : RMat2 :=
  !![-h * p, m; m, h * p]

/-- Branch reflection in the scalar form certified by the P2 branch package. -/
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

/-
On the mass shell, the branch reflection preserves the real fiber norm. This is
the finite coin/reflection analogue of norm conservation, before any shift
operator or walk dynamics are introduced.
-/
theorem branchReflection_preserves_vecNormSq_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) (v : Vec2) :
    vecNormSq (matVec (branchReflection h p m E) v) = vecNormSq v := by
  unfold vecNormSq matVec branchReflection chiralHamiltonian
  norm_num [Fin.sum_univ_succ]
  have hE2 : E ^ 2 ≠ 0 := pow_ne_zero 2 hE0
  field_simp
  linear_combination (p ^ 2 * (v 0 ^ 2 + v 1 ^ 2)) * hh - (v 0 ^ 2 + v 1 ^ 2) * hshell

/-
Pointwise branch reflection preserves the P9 screen second moment.
-/
theorem branchReflection_preserves_screenFiberSecondMoment_on_massShell
    {n : Nat} (screen : Finset (Fin n)) (amp : Fin n -> Vec2)
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    screenFiberSecondMoment screen
        (fun c => matVec (branchReflection h p m E) (amp c))
      = screenFiberSecondMoment screen amp := by
  refine Finset.sum_congr rfl fun x _ => ?_
  exact branchReflection_preserves_vecNormSq_on_massShell h p m E hh hE0 hshell (amp x)

/-
If the original screen amplitudes obey a per-cell squared-norm bound, then the
reflected amplitudes obey the same screen-cardinality second-moment bound.
-/
theorem reflected_screenFiberSecondMoment_le_card_mul_sigmaSq
    {n : Nat} (screen : Finset (Fin n)) (amp : Fin n -> Vec2)
    (h p m E sigmaSq : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) (_hsigma_nonneg : 0 <= sigmaSq)
    (hbound : forall c, c ∈ screen -> vecNormSq (amp c) <= sigmaSq) :
    screenFiberSecondMoment screen
        (fun c => matVec (branchReflection h p m E) (amp c))
      <= (screen.card : Real) * sigmaSq := by
  convert Finset.sum_le_card_nsmul _ _ _ hbound using 1
  · convert branchReflection_preserves_screenFiberSecondMoment_on_massShell
      screen amp h p m E hh hE0 hshell using 1
  · norm_num

end NullEdgeP2P9ReflectionScreenVariance

end
