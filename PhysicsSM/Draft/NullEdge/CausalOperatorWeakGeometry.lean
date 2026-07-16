import PhysicsSM.Draft.NullEdge.CausalOperatorMetric

/-!
# Weak geometry from one scalar causal operator

This module packages the algebraic identities behind an operator-first weak
geometry reconstruction.  Multiplication by probe fields and one scalar
operator `L` produce a double commutator whose value on the constant field is
twice the corrected metric pairing.  A third multiplication commutator is the
finite locality diagnostic corresponding to differential order at most two.

The normalized operator `potentialFreeOperator L` removes multiplication by
`L 1`.  The corrected pairing, double and triple multiplication commutators,
weak Hessian, and normalized `Gamma2` expression are all unchanged when an
arbitrary multiplication potential is added to `L`.

These are exact finite identities.  They do not select a mesoscopic function
algebra, prove that the triple commutator is small, reconstruct dimension or
signature, or establish a causal-operator continuum limit.  Claim grade:
`M [comp]`.

Provenance: the multiplication-commutator characterization of a second-order
differential operator and the polarized weak Hessian/Bochner calculus are
standard.  This file records the exact convention used by the null-edge
operator program.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CausalOperatorWeakGeometry

variable {X K : Type*} [Field K]

/-- Scalar fields on the finite or continuum carrier. -/
abbrev ScalarField (X K : Type*) := X -> K

/-- A not-necessarily-linear scalar operator. -/
abbrev ScalarOperator (X K : Type*) := ScalarField X K -> ScalarField X K

/-- Pointwise multiplication by a scalar field. -/
def multiplicationOperator (f : ScalarField X K) : ScalarOperator X K :=
  fun u => f * u

/-- Addition of pointwise multiplication by a scalar potential. -/
def addMultiplicationPotential
    (L : ScalarOperator X K) (V : ScalarField X K) : ScalarOperator X K :=
  fun u => L u + V * u

/-- Pointwise corrected product defect of a scalar operator. -/
def correctedPairing
    (L : ScalarOperator X K) (f h : ScalarField X K) : ScalarField X K :=
  fun x =>
    (2 : K)⁻¹ *
      (L (f * h) x - f x * L h x - h x * L f x + f x * h x * L 1 x)

/-- The pointwise corrected pairing is symmetric. -/
theorem correctedPairing_comm
    (L : ScalarOperator X K) (f h : ScalarField X K) :
    correctedPairing L f h = correctedPairing L h f := by
  funext x
  unfold correctedPairing
  ring

/-- The pointwise corrected pairing ignores a multiplication potential. -/
theorem correctedPairing_addMultiplicationPotential
    (L : ScalarOperator X K) (V f h : ScalarField X K) :
    correctedPairing (addMultiplicationPotential L V) f h =
      correctedPairing L f h := by
  funext x
  unfold correctedPairing addMultiplicationPotential
  simp only [Pi.add_apply, Pi.mul_apply, Pi.one_apply]
  ring

/-- Commutator of two scalar operators. -/
def operatorCommutator
    (left right : ScalarOperator X K) : ScalarOperator X K :=
  fun u => left (right u) - right (left u)

/-- Double commutator with multiplication by two probe fields. -/
def doubleMultiplicationCommutator
    (L : ScalarOperator X K) (f h : ScalarField X K) : ScalarOperator X K :=
  operatorCommutator
    (operatorCommutator L (multiplicationOperator f))
    (multiplicationOperator h)

/-- Triple commutator with multiplication by three probe fields. -/
def tripleMultiplicationCommutator
    (L : ScalarOperator X K) (f h k : ScalarField X K) : ScalarOperator X K :=
  operatorCommutator (doubleMultiplicationCommutator L f h)
    (multiplicationOperator k)

/-- Remove multiplication by `L 1`, so the resulting operator kills constants. -/
def potentialFreeOperator (L : ScalarOperator X K) : ScalarOperator X K :=
  fun u => L u - u * L 1

/-- The corrected pairing is exactly half of the double commutator on one. -/
theorem doubleMultiplicationCommutator_one
    [CharZero K]
    (L : ScalarOperator X K) (f h : ScalarField X K) :
    doubleMultiplicationCommutator L f h 1 =
      fun x => 2 * correctedPairing L f h x := by
  funext x
  simp [doubleMultiplicationCommutator, operatorCommutator,
    multiplicationOperator, correctedPairing]
  ring

/-- The normalized operator annihilates the constant field. -/
@[simp] theorem potentialFreeOperator_one
    (L : ScalarOperator X K) :
    potentialFreeOperator L 1 = 0 := by
  simp [potentialFreeOperator]

/-- Adding a multiplication potential does not change the normalized operator. -/
theorem potentialFreeOperator_addMultiplicationPotential
    (L : ScalarOperator X K) (V : ScalarField X K) :
    potentialFreeOperator (addMultiplicationPotential L V) =
      potentialFreeOperator L := by
  funext u x
  simp [potentialFreeOperator, addMultiplicationPotential]
  ring

/-- A multiplication potential contributes nothing to the double commutator. -/
theorem doubleMultiplicationCommutator_addMultiplicationPotential
    (L : ScalarOperator X K) (V f h : ScalarField X K) :
    doubleMultiplicationCommutator (addMultiplicationPotential L V) f h =
      doubleMultiplicationCommutator L f h := by
  funext u x
  simp [doubleMultiplicationCommutator, operatorCommutator,
    multiplicationOperator, addMultiplicationPotential]
  ring

/-- A multiplication potential contributes nothing to the triple commutator. -/
theorem tripleMultiplicationCommutator_addMultiplicationPotential
    (L : ScalarOperator X K) (V f h k : ScalarField X K) :
    tripleMultiplicationCommutator (addMultiplicationPotential L V) f h k =
      tripleMultiplicationCommutator L f h k := by
  funext u x
  simp [tripleMultiplicationCommutator, doubleMultiplicationCommutator,
    operatorCommutator, multiplicationOperator, addMultiplicationPotential]
  ring

/-- Weak Hessian evaluated on the gradient directions of two probe fields. -/
def weakHessian
    (L : ScalarOperator X K) (f g h : ScalarField X K) : ScalarField X K :=
  fun x =>
    (2 : K)⁻¹ *
      (correctedPairing L g (correctedPairing L f h) x +
        correctedPairing L h (correctedPairing L f g) x -
        correctedPairing L f (correctedPairing L g h) x)

/-- The weak Hessian is symmetric in its two gradient-direction probes. -/
theorem weakHessian_comm
    (L : ScalarOperator X K) (f g h : ScalarField X K) :
    weakHessian L f g h = weakHessian L f h g := by
  funext x
  unfold weakHessian
  rw [correctedPairing_comm L h g]
  ring

/-- The weak Hessian is independent of an arbitrary multiplication potential. -/
theorem weakHessian_addMultiplicationPotential
    (L : ScalarOperator X K) (V f g h : ScalarField X K) :
    weakHessian (addMultiplicationPotential L V) f g h =
      weakHessian L f g h := by
  funext x
  simp only [weakHessian, correctedPairing_addMultiplicationPotential]

/-- Polarized normalized `Gamma2`, the weak Bochner curvature input. -/
def weakGammaTwo
    (L : ScalarOperator X K) (f h : ScalarField X K) : ScalarField X K :=
  let box := potentialFreeOperator L
  fun x =>
    (2 : K)⁻¹ *
      (box (correctedPairing L f h) x -
        correctedPairing L f (box h) x -
        correctedPairing L h (box f) x)

/-- Normalized `Gamma2` is independent of an arbitrary multiplication potential. -/
theorem weakGammaTwo_addMultiplicationPotential
    (L : ScalarOperator X K) (V f h : ScalarField X K) :
    weakGammaTwo (addMultiplicationPotential L V) f h = weakGammaTwo L f h := by
  unfold weakGammaTwo
  rw [potentialFreeOperator_addMultiplicationPotential]
  simp only [correctedPairing_addMultiplicationPotential]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CausalOperatorWeakGeometry.doubleMultiplicationCommutator_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms doubleMultiplicationCommutator_one

/-- info: 'PhysicsSM.Draft.NullEdge.CausalOperatorWeakGeometry.tripleMultiplicationCommutator_addMultiplicationPotential' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms tripleMultiplicationCommutator_addMultiplicationPotential

/-- info: 'PhysicsSM.Draft.NullEdge.CausalOperatorWeakGeometry.weakGammaTwo_addMultiplicationPotential' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weakGammaTwo_addMultiplicationPotential

end PhysicsSM.Draft.NullEdge.CausalOperatorWeakGeometry
