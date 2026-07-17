import PhysicsSM.Draft.NullEdge.FiniteKernelPathExtraction
import PhysicsSM.Draft.NullEdge.HiggsStrictPastCausalSupport

/-!
# Path semantics of finite Higgs retarded terms

This module connects the finite Higgs response series to explicit causal
histories. If a target-source entry of a positive matrix power is nonzero, the
matrix-power path-extraction theorem supplies a primitive chain of the same
length. When the primitive kernel is supported in a supplied transitive strict
past, that chain is a strict-past history and its source strictly precedes its
target.

In particular, every nonzero order-`k` summand of the uniform massive Higgs
retarded series has a `(k + 1)`-step strict-past history. The result is exact
finite combinatorics. It does not derive the strict-past relation from a bare
graph, identify it with continuum null geometry, or select physical path
weights. Claim grade: `M [orig/comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsRetardedPathSemantics

open PhysicsSM.Draft.NullEdge.FiniteKernelPathExtraction
open PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix
open PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence
open PhysicsSM.Draft.NullEdge.HiggsStrictPastCausalSupport

variable {V : Type*} [Fintype V] [DecidableEq V]

omit [DecidableEq V] in
/-- Entrywise strict-past support induces the primitive support predicate used
by matrix-power path extraction. -/
theorem kernelSupportedOn_before_of_matrixSupported
    (C : FiniteStrictRelation V) (A : Matrix V V Real)
    (hA : MatrixSupportedInStrictPast C A) :
    KernelSupportedOn A C.before := by
  intro target source hNonzero
  by_contra hNotBefore
  exact hNonzero (hA target source hNotBefore)

/-- A nonzero positive power of a strict-past-supported matrix has an explicit
strict-past path of the same length. -/
theorem positivePower_nonzero_has_strictPastPath
    (C : FiniteStrictRelation V) (A : Matrix V V Real)
    (hA : MatrixSupportedInStrictPast C A)
    (n : Nat) (source target : V)
    (hPower : (A ^ (n + 1)) target source ≠ 0) :
    HasRelationPath C.before (n + 1) source target := by
  exact matrixPower_entry_ne_zero_has_supportedPath A C.before
    (kernelSupportedOn_before_of_matrixSupported C A hA)
    (n + 1) source target hPower

/-- Hence a nonzero positive-power entry places its source strictly before its
target in the supplied relation. -/
theorem positivePower_nonzero_implies_before
    (C : FiniteStrictRelation V) (A : Matrix V V Real)
    (hA : MatrixSupportedInStrictPast C A)
    (n : Nat) (source target : V)
    (hPower : (A ^ (n + 1)) target source ≠ 0) :
    C.before source target := by
  exact HasRelationPath.implies_transitive_relation C.before C.before
    (fun hStep => hStep) (fun hxy hyz => C.transitive hxy hyz)
    (positivePower_nonzero_has_strictPastPath C A hA n source target hPower)

/-- Every nonzero matrix-power factor in the uniform Higgs response carries an
explicit strict-past history. -/
theorem weightedPastKernel_power_nonzero_has_path
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (n : Nat) (source target : V)
    (hPower :
      ((weightedPastKernelMatrix C weight) ^ (n + 1)) target source ≠ 0) :
    HasRelationPath C.before (n + 1) source target := by
  exact positivePower_nonzero_has_strictPastPath C
    (weightedPastKernelMatrix C weight)
    (weightedPastKernelMatrix_supported C weight)
    n source target hPower

/-- Headline termwise form: a nonzero order-`n` uniform massive retarded
summand has an explicit `(n + 1)`-step strict-past history. -/
theorem massiveRetardedSummand_nonzero_has_path
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (massSq : Real) (n : Nat) (source target : V)
    (hTerm :
      (((-massSq) ^ n) •
        ((weightedPastKernelMatrix C weight) ^ (n + 1))) target source ≠ 0) :
    HasRelationPath C.before (n + 1) source target := by
  apply weightedPastKernel_power_nonzero_has_path C weight n source target
  intro hPower
  apply hTerm
  simp [hPower]

/-- A nonzero uniform massive retarded summand can only connect a source to a
strictly later target. -/
theorem massiveRetardedSummand_nonzero_implies_before
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (massSq : Real) (n : Nat) (source target : V)
    (hTerm :
      (((-massSq) ^ n) •
        ((weightedPastKernelMatrix C weight) ^ (n + 1))) target source ≠ 0) :
    C.before source target := by
  exact HasRelationPath.implies_transitive_relation C.before C.before
    (fun hStep => hStep) (fun hxy hyz => C.transitive hxy hyz)
    (massiveRetardedSummand_nonzero_has_path
      C weight massSq n source target hTerm)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsRetardedPathSemantics.positivePower_nonzero_has_strictPastPath' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positivePower_nonzero_has_strictPastPath

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsRetardedPathSemantics.massiveRetardedSummand_nonzero_has_path' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveRetardedSummand_nonzero_has_path

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsRetardedPathSemantics.massiveRetardedSummand_nonzero_implies_before' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveRetardedSummand_nonzero_implies_before

end PhysicsSM.Draft.NullEdge.HiggsRetardedPathSemantics

end
