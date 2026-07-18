import PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation

/-!
# Krein-adjoint periodic link transport

The transported finite-fiber Palatini control uses the Euclidean component
pairing and therefore the ordinary matrix transpose. A Lorentzian bivector
fiber instead needs a nondegenerate indefinite pairing. This module isolates
that convention by supplying a finite fundamental symmetry `J`, the pairing

`[u,v]_J = <J u,v>`,

and the transported adjoint

`U^sharp u = J U^T J u`.

The main theorem proves exact periodic summation by parts with `U^sharp` on the
predecessor link. No orthogonality of `U` is assumed. This is the algebraic
adjoint needed before a Lorentz-valued link/face Palatini equation can be
interpreted physically.

## Scope and provenance

The module proves finite linear-algebra identities. It does not yet show that
a chosen transport preserves `J`, derive a six-component bivector basis from
the null coframe, or vary nonlinear Lorentz-group plaquette holonomy. The
fundamental-symmetry formulation is standard Krein-space algebra `[import]`;
its periodic null-edge specialization and guarded finite theorem chain are
`[orig]`. Claim label: finite identity.
-/

namespace PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint

open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation

variable {Site : Type*} [Fintype Site] [DecidableEq Site]
variable {n : Nat}

/-- A finite real fundamental symmetry. Involutivity makes `J` invertible;
self-adjointness makes the induced real pairing symmetric. -/
structure FundamentalSymmetry (n : Nat) where
  matrix : Matrix (Fin n) (Fin n) Real
  involutive : forall field : Fiber n,
    transportApply matrix (transportApply matrix field) = field
  selfAdjoint : forall field : Fiber n,
    transportAdjointApply matrix field = transportApply matrix field

/-- Finite symmetric indefinite pairing selected by a fundamental symmetry.
-/
def kreinPair (fundamental : FundamentalSymmetry n)
    (left right : Fiber n) : Real :=
  fiberPair (transportApply fundamental.matrix left) right

/-- The `J`-adjoint action `J U^T J` on a fiber vector. -/
def kreinAdjointApply (fundamental : FundamentalSymmetry n)
    (transport : Matrix (Fin n) (Fin n) Real) (field : Fiber n) : Fiber n :=
  transportApply fundamental.matrix
    (transportAdjointApply transport
      (transportApply fundamental.matrix field))

/-- The finite component pairing is symmetric. -/
theorem fiberPair_comm (left right : Fiber n) :
    fiberPair left right = fiberPair right left := by
  unfold fiberPair
  apply Finset.sum_congr rfl
  intro component _
  ring

/-- A fundamental symmetry induces a symmetric real pairing. -/
theorem kreinPair_comm (fundamental : FundamentalSymmetry n)
    (left right : Fiber n) :
    kreinPair fundamental left right = kreinPair fundamental right left := by
  unfold kreinPair
  calc
    fiberPair (transportApply fundamental.matrix left) right =
        fiberPair
          (transportAdjointApply fundamental.matrix left) right := by
      rw [fundamental.selfAdjoint]
    _ = fiberPair left (transportApply fundamental.matrix right) := by
      exact (fiberPair_transportApply fundamental.matrix left right).symm
    _ = fiberPair (transportApply fundamental.matrix right) left := by
      exact fiberPair_comm _ _

/-- `J U^T J` is adjoint to forward transport for the `J` pairing. -/
theorem kreinPair_transportApply
    (fundamental : FundamentalSymmetry n)
    (transport : Matrix (Fin n) (Fin n) Real) (left right : Fiber n) :
    kreinPair fundamental left (transportApply transport right) =
      kreinPair fundamental (kreinAdjointApply fundamental transport left)
        right := by
  unfold kreinPair kreinAdjointApply
  rw [fiberPair_transportApply, fundamental.involutive]

/-- Matrix action distributes over subtraction of fiber fields. -/
theorem transportApply_sub
    (transport : Matrix (Fin n) (Fin n) Real) (left right : Fiber n) :
    transportApply transport (fun component => left component - right component) =
      fun component =>
        transportApply transport left component -
          transportApply transport right component := by
  funext component
  unfold transportApply
  simp only [mul_sub, Finset.sum_sub_distrib]

/-- The Krein pairing distributes over subtraction in its right argument. -/
theorem kreinPair_sub_right (fundamental : FundamentalSymmetry n)
    (left right right' : Fiber n) :
    kreinPair fundamental left
        (fun component => right component - right' component) =
      kreinPair fundamental left right -
        kreinPair fundamental left right' := by
  unfold kreinPair
  rw [fiberPair_sub_right]

/-- The Krein pairing distributes over subtraction in its left argument. -/
theorem kreinPair_sub_left (fundamental : FundamentalSymmetry n)
    (left left' right : Fiber n) :
    kreinPair fundamental
        (fun component => left component - left' component) right =
      kreinPair fundamental left right -
        kreinPair fundamental left' right := by
  unfold kreinPair
  rw [transportApply_sub, fiberPair_sub_left]

/-- Backward covariant adjoint for a `J`-paired fiber. -/
def kreinCovariantBackwardAdjoint
    (shift : Fin 4 -> Equiv Site Site) (fundamental : FundamentalSymmetry n)
    (transport : LinkTransport Site n) (covector : Site -> Fiber n)
    (site : Site) (direction : Fin 4) : Fiber n :=
  fun component =>
    kreinAdjointApply fundamental
        (transport ((shift direction).symm site) direction)
        (covector ((shift direction).symm site)) component -
      covector site component

omit [Fintype Site] [DecidableEq Site] in
/-- Pointwise forward transport paired before periodic site reindexing. -/
theorem kreinPair_covariantForwardDifference
    (shift : Fin 4 -> Equiv Site Site) (fundamental : FundamentalSymmetry n)
    (transport : LinkTransport Site n) (weight field : Site -> Fiber n)
    (site : Site) (direction : Fin 4) :
    kreinPair fundamental (weight site)
        (covariantForwardDifference shift transport field site direction) =
      kreinPair fundamental
          (kreinAdjointApply fundamental (transport site direction)
            (weight site))
          (field (shift direction site)) -
        kreinPair fundamental (weight site) (field site) := by
  unfold covariantForwardDifference
  rw [kreinPair_sub_right, kreinPair_transportApply]

omit [Fintype Site] [DecidableEq Site] in
/-- Pointwise predecessor adjoint paired after periodic site reindexing. -/
theorem kreinPair_kreinCovariantBackwardAdjoint
    (shift : Fin 4 -> Equiv Site Site) (fundamental : FundamentalSymmetry n)
    (transport : LinkTransport Site n) (weight field : Site -> Fiber n)
    (site : Site) (direction : Fin 4) :
    kreinPair fundamental
        (kreinCovariantBackwardAdjoint shift fundamental transport weight site
          direction)
        (field site) =
      kreinPair fundamental
          (kreinAdjointApply fundamental
            (transport ((shift direction).symm site) direction)
            (weight ((shift direction).symm site)))
          (field site) -
        kreinPair fundamental (weight site) (field site) := by
  unfold kreinCovariantBackwardAdjoint
  rw [kreinPair_sub_left]

omit [DecidableEq Site] in
/-- Exact periodic summation by parts for a finite Krein-paired link fiber. -/
theorem sum_kreinPair_covariantForwardDifference_periodic
    (shift : Fin 4 -> Equiv Site Site) (fundamental : FundamentalSymmetry n)
    (transport : LinkTransport Site n) (weight field : Site -> Fiber n)
    (direction : Fin 4) :
    Finset.sum Finset.univ (fun site =>
        kreinPair fundamental (weight site)
          (covariantForwardDifference shift transport field site direction)) =
      Finset.sum Finset.univ (fun site =>
        kreinPair fundamental
          (kreinCovariantBackwardAdjoint shift fundamental transport weight
            site direction)
          (field site)) := by
  simp_rw [kreinPair_covariantForwardDifference,
    kreinPair_kreinCovariantBackwardAdjoint]
  simp only [Finset.sum_sub_distrib]
  congr 1
  have hReindex := Equiv.sum_comp (shift direction)
    (fun site =>
      kreinPair fundamental
        (kreinAdjointApply fundamental
          (transport ((shift direction).symm site) direction)
          (weight ((shift direction).symm site)))
        (field site))
  simpa using hReindex

/-- Identity matrix action on a finite real fiber. -/
theorem transportApply_one (field : Fiber n) :
    transportApply (1 : Matrix (Fin n) (Fin n) Real) field = field := by
  funext component
  simp [transportApply, Matrix.one_apply]

/-- The identity matrix is the Euclidean fundamental symmetry. -/
def euclideanFundamentalSymmetry (n : Nat) : FundamentalSymmetry n where
  matrix := 1
  involutive := by
    intro field
    rw [transportApply_one, transportApply_one]
  selfAdjoint := by
    intro field
    rw [transportAdjointApply_one, transportApply_one]

/-- For the Euclidean fundamental symmetry, the Krein adjoint reduces to the
ordinary transpose action used by the transported finite-fiber control. -/
theorem kreinAdjointApply_euclidean
    (transport : Matrix (Fin n) (Fin n) Real) (field : Fiber n) :
    kreinAdjointApply (euclideanFundamentalSymmetry n) transport field =
      transportAdjointApply transport field := by
  unfold kreinAdjointApply euclideanFundamentalSymmetry
  rw [transportApply_one, transportApply_one]

/-! ## Explicit split-six control -/

/-- A convention-explicit `(3,3)` sign function: components `0,1,2` are
positive and `3,4,5` are negative. This is a finite control ordering, not yet
the derived physical boost/rotation ordering. -/
def splitSixSign : Fin 6 -> Real :=
  fun component => if component.val < 3 then 1 else -1

/-- Every split-six diagonal sign squares to one. -/
theorem splitSixSign_sq (component : Fin 6) :
    splitSixSign component * splitSixSign component = 1 := by
  by_cases hPositive : component.val < 3 <;>
    simp [splitSixSign, hPositive]

/-- Diagonal split-sign matrix on the six-component control fiber. -/
def splitSixMatrix : Matrix (Fin 6) (Fin 6) Real :=
  Matrix.diagonal splitSixSign

/-- The diagonal `(3,3)` split is an explicit finite fundamental symmetry. -/
def splitSixFundamentalSymmetry : FundamentalSymmetry 6 where
  matrix := splitSixMatrix
  involutive := by
    intro field
    funext component
    change
      Matrix.mulVec (Matrix.diagonal splitSixSign)
          (Matrix.mulVec (Matrix.diagonal splitSixSign) field) component =
        field component
    rw [Matrix.mulVec_diagonal, Matrix.mulVec_diagonal]
    rw [← mul_assoc, splitSixSign_sq, one_mul]
  selfAdjoint := by
    intro field
    funext component
    change
      Matrix.mulVec (Matrix.diagonal splitSixSign).transpose field component =
        Matrix.mulVec (Matrix.diagonal splitSixSign) field component
    simp

/-- The explicit split-six control has the advertised three positive and
three negative diagonal entries. -/
theorem splitSixSign_values :
    (splitSixSign 0, splitSixSign 1, splitSixSign 2,
      splitSixSign 3, splitSixSign 4, splitSixSign 5) =
      ((1 : Real), (1 : Real), (1 : Real),
        (-1 : Real), (-1 : Real), (-1 : Real)) := by
  norm_num [splitSixSign]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint.kreinPair_transportApply' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kreinPair_transportApply

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint.sum_kreinPair_covariantForwardDifference_periodic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sum_kreinPair_covariantForwardDifference_periodic

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint.kreinAdjointApply_euclidean' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kreinAdjointApply_euclidean

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint.splitSixSign_values' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms splitSixSign_values

end PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
