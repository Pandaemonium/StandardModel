import Mathlib
import PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry

/-!
# Finite field-equation/Bianchi source-conservation bridge

This module isolates the exact algebraic implication used by general
relativity after the contracted Bianchi identity. In a possibly
noncommutative ring, suppose an algebraic left-hand side `G` and source `T` obey

```text
G = kappa * T.
```

If `G` commutes with the finite covariant derivative `nab`, the coupling
`kappa` also commutes with `nab`, and left multiplication by `kappa` cancels a
zero product, then `T` commutes with `nab` as well. A displayed left inverse is
a convenient sufficient condition for this cancellation property.

This is a finite conditional bridge, not a derivation of any premise. In
particular, this module does not define an Einstein tensor, prove a contracted
Bianchi identity for null-edge curvature, derive universal coupling, or
construct a spacetime stress-energy tensor. Its value is to make the final
conservation implication precise and to expose exactly which inputs remain.

An explicit nonzero `2 x 2` rational matrix witness shows that the hypotheses
are jointly satisfiable in a noncommutative ambient algebra.
-/

open Matrix

namespace PhysicsSM.Draft.NullEdge.FiniteGravityConservation

open PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry

section AbstractBridge

variable {A : Type*} [Ring A]

/-- Finite operator field equation with a displayed left coupling. -/
def FieldEquation (einstein coupling source : A) : Prop :=
  einstein = coupling * source

/-- Adjoint finite covariant conservation. -/
def CovariantlyConserved (nab tensor : A) : Prop :=
  FiniteConnectionGeometry.commutator nab tensor = 0

/-- The adjoint commutator obeys the factor-order-sensitive Leibniz rule in an
arbitrary associative ring. -/
theorem commutator_mul_leibniz (nab x y : A) :
    FiniteConnectionGeometry.commutator nab (x * y) =
      FiniteConnectionGeometry.commutator nab x * y +
        x * FiniteConnectionGeometry.commutator nab y := by
  unfold FiniteConnectionGeometry.commutator
  simp [sub_mul, mul_sub, ← mul_assoc]

/-- The left-cancellation form of the finite conservation bridge. It asks
only that left multiplication by the coupling cancel a zero product. -/
theorem source_conserved_of_fieldEquation_bianchi_of_left_cancel
    (nab einstein coupling source : A)
    (hField : FieldEquation einstein coupling source)
    (hCouplingParallel : nab * coupling = coupling * nab)
    (hCouplingLeftCancel : ∀ z : A, coupling * z = 0 → z = 0)
    (hBianchi : CovariantlyConserved nab einstein) :
    CovariantlyConserved nab source := by
  simp_all [CovariantlyConserved, FiniteConnectionGeometry.commutator]
  rw [hField] at hBianchi
  convert hCouplingLeftCancel (nab * source - source * nab) _ using 1
  simp [mul_sub, ← mul_assoc, ← hCouplingParallel]
  rwa [mul_assoc]

/-- **Finite Bianchi-to-source-conservation bridge.** A conserved algebraic
left-hand side and a parallel left-invertible coupling force conservation of
the algebraic source. The names record the intended later GR use; the theorem
assumes rather than derives its field equation and conservation premise. -/
theorem source_conserved_of_fieldEquation_bianchi
    (nab einstein coupling couplingLeftInv source : A)
    (hField : FieldEquation einstein coupling source)
    (hCouplingParallel : nab * coupling = coupling * nab)
    (hCouplingLeftInv : couplingLeftInv * coupling = 1)
    (hBianchi : CovariantlyConserved nab einstein) :
    CovariantlyConserved nab source := by
  apply source_conserved_of_fieldEquation_bianchi_of_left_cancel
    nab einstein coupling source hField hCouplingParallel _ hBianchi
  intro z hz
  have hzLeft := congrArg (fun w => couplingLeftInv * w) hz
  simpa [← mul_assoc, hCouplingLeftInv] using hzLeft

end AbstractBridge

/-! ## Explicit nonzero matrix witness -/

abbrev M2 := Matrix (Fin 2) (Fin 2) ℚ

def witnessNab : M2 := !![1, 0; 0, 1]

def witnessSource : M2 := !![1, 0; 1, 1]

def witnessCoupling : M2 := !![1, 1; 0, 1]

def witnessCouplingLeftInv : M2 := !![1, -1; 0, 1]

def witnessEinstein : M2 := !![2, 1; 1, 1]

/-- Nonzero, mutually noncommuting source and coupling satisfying the finite
field equation, left-inverse, parallel-coupling, Bianchi, and
source-conservation hypotheses. -/
theorem nonzero_matrix_conservation_witness :
    witnessSource ≠ 0
      /\ witnessCoupling ≠ 0
      /\ witnessCoupling * witnessSource ≠ witnessSource * witnessCoupling
      /\ FieldEquation witnessEinstein witnessCoupling witnessSource
      /\ witnessNab * witnessCoupling = witnessCoupling * witnessNab
       /\ witnessCouplingLeftInv * witnessCoupling = 1
       /\ CovariantlyConserved witnessNab witnessEinstein
       /\ CovariantlyConserved witnessNab witnessSource := by
  unfold FieldEquation CovariantlyConserved FiniteConnectionGeometry.commutator
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro h
    have h00 := congrFun (congrFun h (0 : Fin 2)) (0 : Fin 2)
    norm_num [witnessSource] at h00
  · intro h
    have h00 := congrFun (congrFun h (0 : Fin 2)) (0 : Fin 2)
    norm_num [witnessCoupling] at h00
  · intro h
    have h00 := congrFun (congrFun h (0 : Fin 2)) (0 : Fin 2)
    norm_num [witnessSource, witnessCoupling, Matrix.mul_apply,
      Fin.sum_univ_two] at h00
  all_goals
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [witnessNab, witnessSource, witnessCoupling,
        witnessCouplingLeftInv, witnessEinstein,
        Matrix.mul_apply, Fin.sum_univ_two] <;> norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteGravityConservation.commutator_mul_leibniz' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteGravityConservation.commutator_mul_leibniz

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteGravityConservation.source_conserved_of_fieldEquation_bianchi_of_left_cancel' does not depend on any axioms -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteGravityConservation.source_conserved_of_fieldEquation_bianchi_of_left_cancel

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteGravityConservation.source_conserved_of_fieldEquation_bianchi' does not depend on any axioms -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteGravityConservation.source_conserved_of_fieldEquation_bianchi

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteGravityConservation.nonzero_matrix_conservation_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteGravityConservation.nonzero_matrix_conservation_witness

end PhysicsSM.Draft.NullEdge.FiniteGravityConservation
