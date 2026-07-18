import PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator
import PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence
import PhysicsSM.Draft.NullEdge.RetardedPolynomialProjectorNoGo

/-!
# Polynomial-projector no-go for finite layered causal operators

This module composes two exact finite results. A weighted strict-past operator
on a finite causal order is nilpotent, and an idempotent polynomial filter of a
scalar-plus-nilpotent operator is zero or the identity. The existing
`FiniteCausalOrder.layeredOperator` is bundled as exactly such an endomorphism.

Consequently, no direct real-polynomial filter of this one-spectrum retarded
operator can select a nonzero proper subspace, including a rank-four probe
sector on a carrier of dimension greater than four.

This kills only the direct polynomial-filter architecture. It does not exclude
normal or Hermitian operators constructed from retarded/advanced data,
non-polynomial functional calculus, larger probe representations, or a
separately derived constraint kernel.

Claim grade: `M [orig/comp]`, finite causal-order and linear algebra only.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo

open Polynomial
open PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator
open PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator
open PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence
open PhysicsSM.Draft.NullEdge.RetardedPolynomialProjectorNoGo

variable {V : Type*} [Fintype V]

/-- Forget the decidability field of a finite causal order, retaining its
transitive irreflexive strict relation. -/
def toFiniteStrictRelation
    (C : FiniteCausalOrder V) : FiniteStrictRelation V where
  before := C.before
  transitive := C.trans
  irrefl := C.irrefl

/-- The off-diagonal strict-past part of a layered causal operator, including
its common prefactor in the edge weights. -/
def layeredPastLinear
    (C : FiniteCausalOrder V) (prefactor : Real)
    (coefficient : Nat -> Real) : Module.End Real (V -> Real) :=
  weightedPastOperator (toFiniteStrictRelation C) fun y x =>
    prefactor * coefficient (C.openIntervalCount y x)

/-- Bundled real-linear form of the existing diagonal-plus-past layered
operator. -/
def layeredOperatorLinear
    (C : FiniteCausalOrder V) (prefactor diagonal : Real)
    (coefficient : Nat -> Real) : Module.End Real (V -> Real) :=
  (prefactor * diagonal) • LinearMap.id +
    layeredPastLinear C prefactor coefficient

/-- The bundled past operator is exactly the prefactor times the existing
pointwise layered past sum. -/
theorem layeredPastLinear_apply
    (C : FiniteCausalOrder V) (prefactor : Real)
    (coefficient : Nat -> Real) (phi : V -> Real) (x : V) :
    layeredPastLinear C prefactor coefficient phi x =
      prefactor * C.layeredPastSum coefficient phi x := by
  classical
  unfold layeredPastLinear weightedPastOperator
    FiniteCausalOrder.layeredPastSum
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro y _
  by_cases h : C.before y x <;> simp [toFiniteStrictRelation, h]
  ring

/-- Evaluation of the bundled endomorphism agrees exactly with the existing
layered causal operator. -/
theorem layeredOperatorLinear_apply
    (C : FiniteCausalOrder V) (prefactor diagonal : Real)
    (coefficient : Nat -> Real) (phi : V -> Real) (x : V) :
    layeredOperatorLinear C prefactor diagonal coefficient phi x =
      C.layeredOperator prefactor diagonal coefficient phi x := by
  rw [layeredOperatorLinear]
  simp only [LinearMap.add_apply, LinearMap.smul_apply, LinearMap.id_apply,
    Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  rw [layeredPastLinear_apply C]
  unfold FiniteCausalOrder.layeredOperator
  ring

/-- The off-diagonal part is nilpotent at the event-cardinality power. -/
theorem layeredPastLinear_pow_card_eq_zero
    [Nonempty V] (C : FiniteCausalOrder V) (prefactor : Real)
    (coefficient : Nat -> Real) :
    layeredPastLinear C prefactor coefficient ^ Fintype.card V = 0 := by
  exact weightedPastOperator_pow_card_eq_zero (toFiniteStrictRelation C) _

/-- **Direct retarded polynomial-filter no-go.** Every idempotent polynomial
filter of a finite diagonal-plus-strict-past layered causal operator is zero or
the identity. -/
theorem layeredOperatorLinear_polynomial_idempotent_trivial
    [Nonempty V] (C : FiniteCausalOrder V)
    (prefactor diagonal : Real) (coefficient : Nat -> Real) (p : Real[X])
    (hidempotent :
      let P : Module.End Real (V -> Real) :=
        aeval (layeredOperatorLinear C prefactor diagonal coefficient) p
      P.comp P = P) :
    let P : Module.End Real (V -> Real) :=
      aeval (layeredOperatorLinear C prefactor diagonal coefficient) p
    P = 0 ∨ P = LinearMap.id := by
  simpa [layeredOperatorLinear] using
    polynomial_idempotent_of_scalar_add_nilpotent_trivial
      (M := V -> Real) (prefactor * diagonal)
      (layeredPastLinear C prefactor coefficient) (Fintype.card V)
      Fintype.card_pos (layeredPastLinear_pow_card_eq_zero C prefactor coefficient)
      p hidempotent

/-- Bundled source-sign local four-dimensional causal-set operator. -/
def sourceLocal4DOperatorLinear
    (C : FiniteCausalOrder V) (ell : Real) : Module.End Real (V -> Real) :=
  layeredOperatorLinear C (sourceLocal4DPrefactor ell) (-1)
    sourceLocal4DCoefficient

/-- The bundled source-sign operator evaluates to the existing pointwise
definition. -/
theorem sourceLocal4DOperatorLinear_apply
    (C : FiniteCausalOrder V) (ell : Real) (phi : V -> Real) (x : V) :
    sourceLocal4DOperatorLinear C ell phi x =
      sourceLocal4DOperator C ell phi x := by
  exact layeredOperatorLinear_apply C _ _ _ _ _

/-- No idempotent polynomial of the concrete local four-dimensional retarded
operator selects a nonzero proper sector. -/
theorem sourceLocal4DOperatorLinear_polynomial_idempotent_trivial
    [Nonempty V] (C : FiniteCausalOrder V) (ell : Real) (p : Real[X])
    (hidempotent :
      let P : Module.End Real (V -> Real) :=
        aeval (sourceLocal4DOperatorLinear C ell) p
      P.comp P = P) :
    let P : Module.End Real (V -> Real) :=
      aeval (sourceLocal4DOperatorLinear C ell) p
    P = 0 ∨ P = LinearMap.id := by
  exact layeredOperatorLinear_polynomial_idempotent_trivial C _ _ _ p
    hidempotent

/-- Bundled active project-sign smeared operator, including its equal-scale
branch. -/
def projectSmeared4DOperatorLinear
    (C : FiniteCausalOrder V) (ell nonlocalityScale : Real) :
    Module.End Real (V -> Real) :=
  layeredOperatorLinear C
    (projectSmearedEffectivePrefactor ell nonlocalityScale) (-1)
    (projectSmearedEffectiveCoefficient ell nonlocalityScale)

/-- The bundled project-sign smeared operator evaluates to the existing
pointwise definition. -/
theorem projectSmeared4DOperatorLinear_apply
    (C : FiniteCausalOrder V) (ell nonlocalityScale : Real)
    (phi : V -> Real) (x : V) :
    projectSmeared4DOperatorLinear C ell nonlocalityScale phi x =
      projectSmeared4DOperator C ell nonlocalityScale phi x := by
  unfold projectSmeared4DOperatorLinear
  rw [layeredOperatorLinear_apply,
    projectSmeared4DOperator_eq_layeredOperator]

/-- **Concrete project-sign no-go.** No idempotent polynomial of the active
finite smeared retarded operator selects a nonzero proper sector. -/
theorem projectSmeared4DOperatorLinear_polynomial_idempotent_trivial
    [Nonempty V]
    (C : FiniteCausalOrder V) (ell nonlocalityScale : Real) (p : Real[X])
    (hidempotent :
      let P : Module.End Real (V -> Real) :=
        aeval (projectSmeared4DOperatorLinear C ell nonlocalityScale) p
      P.comp P = P) :
    let P : Module.End Real (V -> Real) :=
      aeval (projectSmeared4DOperatorLinear C ell nonlocalityScale) p
    P = 0 ∨ P = LinearMap.id := by
  exact layeredOperatorLinear_polynomial_idempotent_trivial C _ _ _ p
    hidempotent

end PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo.layeredOperatorLinear_apply' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo.layeredOperatorLinear_apply

/-- info: 'PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo.layeredPastLinear_pow_card_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo.layeredPastLinear_pow_card_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo.layeredOperatorLinear_polynomial_idempotent_trivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo.layeredOperatorLinear_polynomial_idempotent_trivial

/-- info: 'PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo.sourceLocal4DOperatorLinear_polynomial_idempotent_trivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo.sourceLocal4DOperatorLinear_polynomial_idempotent_trivial

/-- info: 'PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo.projectSmeared4DOperatorLinear_apply' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo.projectSmeared4DOperatorLinear_apply

/-- info: 'PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo.projectSmeared4DOperatorLinear_polynomial_idempotent_trivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo.projectSmeared4DOperatorLinear_polynomial_idempotent_trivial
