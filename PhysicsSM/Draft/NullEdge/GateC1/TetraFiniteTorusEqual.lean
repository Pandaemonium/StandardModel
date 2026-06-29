import PhysicsSM.Draft.NullEdge.GateC1.FiniteBlockDiagonalGap

/-!
# Equal-side finite rank-4 tetrahedral torus scaffold

This module starts the concrete finite/free operator-gap instantiation requested
by the Gate C1 plan.

It deliberately stops before the full Fourier-character diagonalization.  The
purpose here is to pin the finite translation substrate:

* equal-side site torus `SiteN N = Fin 4 -> ZMod N`;
* equal-side momentum torus `MomN N = Fin 4 -> ZMod N`;
* the four commuting cyclic shifts;
* shift equivalences/permutations;
* preservation of the explicit finite L2 field norm square.

The next module should add characters/Fourier normalization and instantiate
`FiniteBlockDiagonalGap.UnitaryBlockDiagonalization`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraFiniteTorusEqual

open scoped BigOperators
open TetraScalarWilsonSymbol

/-- Equal-side rank-4 cyclic site torus. -/
abbrev SiteN (N : ℕ) := Fin 4 -> ZMod N

/-- Equal-side rank-4 cyclic momentum torus. -/
abbrev MomN (N : ℕ) := Fin 4 -> ZMod N

/-- Increment the `A`-th cyclic coordinate. -/
def shiftSite (N : ℕ) [NeZero N] (A : Fin 4) (x : SiteN N) : SiteN N :=
  fun B => if B = A then x B + 1 else x B

/-- Decrement the `A`-th cyclic coordinate. -/
def unshiftSite (N : ℕ) [NeZero N] (A : Fin 4) (x : SiteN N) : SiteN N :=
  fun B => if B = A then x B - 1 else x B

/-- Decrementing after incrementing returns the original site. -/
theorem unshift_shift (N : ℕ) [NeZero N] (A : Fin 4) (x : SiteN N) :
    unshiftSite N A (shiftSite N A x) = x := by
  funext B
  unfold unshiftSite shiftSite
  by_cases h : B = A
  · simp [h]
  · simp [h]

/-- Incrementing after decrementing returns the original site. -/
theorem shift_unshift (N : ℕ) [NeZero N] (A : Fin 4) (x : SiteN N) :
    shiftSite N A (unshiftSite N A x) = x := by
  funext B
  unfold unshiftSite shiftSite
  by_cases h : B = A
  · simp [h]
  · simp [h]

/-- Site shift as a permutation/equivalence of the finite torus. -/
def shiftEquiv (N : ℕ) [NeZero N] (A : Fin 4) : SiteN N ≃ SiteN N where
  toFun := shiftSite N A
  invFun := unshiftSite N A
  left_inv := unshift_shift N A
  right_inv := shift_unshift N A

/-- The four coordinate shifts commute on sites. -/
theorem shiftSite_commute (N : ℕ) [NeZero N] (A B : Fin 4) (x : SiteN N) :
    shiftSite N A (shiftSite N B x) =
      shiftSite N B (shiftSite N A x) := by
  by_cases hAB : A = B
  · subst B
    rfl
  · have hBA : ¬ B = A := by
      intro h
      exact hAB h.symm
    funext C
    unfold shiftSite
    by_cases hCA : C = A
    · have hCB : ¬ C = B := by
        intro h
        exact hAB (hCA.symm.trans h)
      simp [hCA, hAB]
    · by_cases hCB : C = B
      · simp [hCB, hBA]
      · simp [hCA, hCB]

/-- The inverse coordinate shifts commute on sites. -/
theorem unshiftSite_commute (N : ℕ) [NeZero N] (A B : Fin 4) (x : SiteN N) :
    unshiftSite N A (unshiftSite N B x) =
      unshiftSite N B (unshiftSite N A x) := by
  by_cases hAB : A = B
  · subst B
    rfl
  · have hBA : ¬ B = A := by
      intro h
      exact hAB h.symm
    funext C
    unfold unshiftSite
    by_cases hCA : C = A
    · have hCB : ¬ C = B := by
        intro h
        exact hAB (hCA.symm.trans h)
      simp [hCA, hAB]
    · by_cases hCB : C = B
      · simp [hCB, hBA]
      · simp [hCA, hCB]

/-- Finite L2 norm square of a spinor field on the equal-side torus. -/
def fieldL2NormSq (N : ℕ) [NeZero N] {Spin : Type*} [Fintype Spin]
    (Psi : SiteN N -> Spin -> ℂ) : ℝ :=
  ∑ x : SiteN N, l2NormSq (Psi x)

/-- Pullback action of a coordinate shift on spinor fields. -/
def shiftField (N : ℕ) [NeZero N] {Spin : Type*} (A : Fin 4)
    (Psi : SiteN N -> Spin -> ℂ) : SiteN N -> Spin -> ℂ :=
  fun x => Psi (unshiftSite N A x)

/--
Pullback action by the inverse coordinate shift.

This is the orientation used for the canonical finite free transport operator:
with the Fourier convention in `TetraCharactersEqual`, it has positive phase
eigenvalue and therefore matches the symbol convention `T_A -> exp(+i k_A)`.
-/
def invShiftField (N : ℕ) [NeZero N] {Spin : Type*} (A : Fin 4)
    (Psi : SiteN N -> Spin -> ℂ) : SiteN N -> Spin -> ℂ :=
  fun x => Psi (shiftSite N A x)

/-- Canonical transport shift used by the finite free operator. -/
def transportShift (N : ℕ) [NeZero N] {Spin : Type*} (A : Fin 4)
    (Psi : SiteN N -> Spin -> ℂ) : SiteN N -> Spin -> ℂ :=
  invShiftField N A Psi

/-- Coordinate shifts preserve the finite field L2 norm square. -/
theorem shiftField_l2NormSq (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) :
    fieldL2NormSq N (shiftField N A Psi) = fieldL2NormSq N Psi := by
  simpa [fieldL2NormSq, shiftField] using
    (Equiv.sum_comp ((shiftEquiv N A).symm)
      (fun x : SiteN N => l2NormSq (Psi x)))

/-- Inverse coordinate shifts also preserve the finite field L2 norm square. -/
theorem invShiftField_l2NormSq (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) :
    fieldL2NormSq N (invShiftField N A Psi) = fieldL2NormSq N Psi := by
  simpa [fieldL2NormSq, invShiftField] using
    (Equiv.sum_comp (shiftEquiv N A)
      (fun x : SiteN N => l2NormSq (Psi x)))

/-- Canonical transport shifts preserve the finite field L2 norm square. -/
theorem transportShift_l2NormSq (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) :
    fieldL2NormSq N (transportShift N A Psi) = fieldL2NormSq N Psi := by
  simpa [transportShift] using invShiftField_l2NormSq N A Psi

/-- The induced coordinate shifts commute on spinor fields. -/
theorem shiftField_commute (N : ℕ) [NeZero N]
    {Spin : Type*} (A B : Fin 4) (Psi : SiteN N -> Spin -> ℂ) :
    shiftField N A (shiftField N B Psi) =
      shiftField N B (shiftField N A Psi) := by
  funext x s
  unfold shiftField
  rw [unshiftSite_commute N B A]

/-- The induced inverse coordinate shifts commute on spinor fields. -/
theorem invShiftField_commute (N : ℕ) [NeZero N]
    {Spin : Type*} (A B : Fin 4) (Psi : SiteN N -> Spin -> ℂ) :
    invShiftField N A (invShiftField N B Psi) =
      invShiftField N B (invShiftField N A Psi) := by
  funext x s
  unfold invShiftField
  rw [shiftSite_commute N B A]

/-- The canonical transport shifts commute on spinor fields. -/
theorem transportShift_commute (N : ℕ) [NeZero N]
    {Spin : Type*} (A B : Fin 4) (Psi : SiteN N -> Spin -> ℂ) :
    transportShift N A (transportShift N B Psi) =
      transportShift N B (transportShift N A Psi) := by
  simpa [transportShift] using invShiftField_commute N A B Psi

end TetraFiniteTorusEqual
end GateC1
end NullEdge
end Draft
end PhysicsSM
