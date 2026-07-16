import Mathlib
import PhysicsSM.Draft.NullEdgeFiniteLichnerowiczBridge

/-!
# Finite null-edge connection geometry

This module extracts three exact connection identities that sit between the
finite tetrad-postulate algebra and the continuum general-relativity
reconstruction problem:

* the adjoint connection commutator obeys the cyclic Bianchi identity;
* the finite tetrad postulate implies compatibility with the
  Clifford-anticommutator metric proxy;
* the same postulate implies that connection curvature is compatible with each
  fixed Clifford generator;
* fixed conjugation-shaped transforms preserve commutators, anticommutators,
  and curvature under a displayed left-inverse relation.

The final theorem composes the first three identities with the existing finite
Lichnerowicz square.  It is a finite associative-ring theorem.  It does not
construct a manifold, Levi-Civita connection, Riemann tensor, Einstein tensor,
continuum limit, or gravitational field equation.

Conventions follow `docs/NULLSTRAND.md`: `C a` is the dual-soldered Clifford
symbol and `nab a` is the corresponding finite transport/covariant-difference
operator.  The finite tetrad postulate is
`PhysicsSM.Draft.frameComm C nab a b = 0`.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry

open PhysicsSM.Draft
open PhysicsSM.Draft.FiniteLichnerowiczBridge
open PhysicsSM.Draft.SuperDirac

section ConnectionAlgebra

variable {A : Type*} [Ring A]

/-- Ring commutator, used as the finite adjoint covariant derivative. -/
def commutator (x y : A) : A := x * y - y * x

/-- Ring anticommutator, used for the Clifford-encoded metric proxy. -/
def anticommutator (x y : A) : A := x * y + y * x

/-- Curvature of a finite connection represented by operator commutators. -/
def curvature {ι : Type*} (nab : ι -> A) (a b : ι) : A :=
  commutator (nab a) (nab b)

/-- Adjoint covariant derivative associated with the finite connection. -/
def covariantDerivative {ι : Type*} (nab : ι -> A) (a : ι) (x : A) : A :=
  commutator (nab a) x

/-- Clifford anticommutator carrying the finite metric information. -/
def cliffordMetric {ι : Type*} (C : ι -> A) (b c : ι) : A :=
  anticommutator (C b) (C c)

/-- The cyclic covariant derivative of commutator curvature vanishes exactly.
This is the algebraic Bianchi identity (the Jacobi identity for commutators),
not yet a discrete-to-continuum Riemannian Bianchi theorem. -/
theorem covariant_bianchi_commutator {ι : Type*} (nab : ι -> A) (a b c : ι) :
    covariantDerivative nab a (curvature nab b c)
      + covariantDerivative nab b (curvature nab c a)
      + covariantDerivative nab c (curvature nab a b) = 0 := by
  unfold covariantDerivative curvature commutator
  noncomm_ring

/-- The finite tetrad postulate implies compatibility with the
Clifford-anticommutator metric proxy. -/
theorem metric_compatibility_from_tetrad {ι : Type*} (C nab : ι -> A)
    (htetrad : forall a b, frameComm C nab a b = 0) (a b c : ι) :
    covariantDerivative nab a (cliffordMetric C b c) = 0 := by
  have hb : nab a * C b = C b * nab a := by
    exact sub_eq_zero.mp (by simpa [frameComm] using htetrad a b)
  have hc : nab a * C c = C c * nab a := by
    exact sub_eq_zero.mp (by simpa [frameComm] using htetrad a c)
  unfold covariantDerivative cliffordMetric commutator anticommutator
  rw [mul_add, add_mul]
  repeat' rw [← mul_assoc]
  rw [hb, hc]
  repeat' rw [mul_assoc]
  rw [hb, hc]
  abel

/-- Integrability consequence of the finite tetrad postulate: commutator
curvature remains compatible with every fixed Clifford generator. -/
theorem curvature_clifford_compatible_of_tetrad {ι : Type*} (C nab : ι -> A)
    (htetrad : forall a b, frameComm C nab a b = 0) (a b c : ι) :
    commutator (curvature nab a b) (C c) = 0 := by
  have ha : nab a * C c = C c * nab a := by
    exact sub_eq_zero.mp (by simpa [frameComm] using htetrad a c)
  have hb : nab b * C c = C c * nab b := by
    exact sub_eq_zero.mp (by simpa [frameComm] using htetrad b c)
  unfold curvature commutator
  rw [sub_mul, mul_sub]
  rw [mul_assoc (nab a) (nab b) (C c), hb,
    ← mul_assoc (nab a) (C c) (nab b), ha,
    mul_assoc (C c) (nab a) (nab b)]
  rw [mul_assoc (nab b) (nab a) (C c), ha,
    ← mul_assoc (nab b) (C c) (nab a), hb,
    mul_assoc (C c) (nab b) (nab a)]
  abel

/-! ### One-sided conjugation-shaped covariance

The following identities require only the displayed left-inverse relation
`gInv * g = 1`. In each product of two transformed factors, only the middle
pair `gInv * g` is cancelled. With no right-inverse relation, this transform
need not define a group action or an algebra automorphism; those stronger
geometric interpretations require additional structure.
-/

/-- Commutators transform covariantly under a fixed conjugation-shaped map
when the displayed left-inverse relation holds. -/
theorem commutator_conjugation_covariant (g gInv x y : A)
    (hleft : gInv * g = 1) :
    commutator (g * x * gInv) (g * y * gInv) =
      g * commutator x y * gInv := by
  unfold commutator
  simp only [mul_assoc]
  simp [← mul_assoc, sub_mul, mul_sub, hleft]

/-- Anticommutators transform covariantly under the same displayed
left-inverse relation. -/
theorem anticommutator_conjugation_covariant (g gInv x y : A)
    (hleft : gInv * g = 1) :
    anticommutator (g * x * gInv) (g * y * gInv) =
      g * anticommutator x y * gInv := by
  unfold anticommutator
  simp only [mul_assoc, add_mul, mul_add]
  simp [← mul_assoc, hleft]

/-- Commutator curvature transforms covariantly when every connection operator
is transformed by the same fixed pair satisfying the left-inverse relation. -/
theorem curvature_conjugation_covariant {ι : Type*} (nab : ι -> A)
    (g gInv : A) (hleft : gInv * g = 1) (a b : ι) :
    curvature (fun i => g * nab i * gInv) a b =
      g * curvature nab a b * gInv := by
  exact commutator_conjugation_covariant g gInv (nab a) (nab b) hleft

end ConnectionAlgebra

section DiracConnectionChain

variable {ι : Type*} [Fintype ι]
variable {A : Type*} [Ring A] [Invertible (4 : A)]

/-- **Finite connection/Dirac chain.**  Under the clean super-Dirac sign
hypotheses and the finite tetrad postulate, one obtains simultaneously:

1. compatibility of the Clifford-encoded metric;
2. compatibility of commutator curvature with the Clifford generators;
3. the algebraic covariant Bianchi identity;
4. the tetrad-specialized finite Lichnerowicz square.

This conjunction records the strongest exact finite G3/G4/G5 bridge currently
available from these APIs.  Its continuum geometric interpretation remains a
separate reconstruction theorem. -/
theorem finite_connection_dirac_chain
    (Im Gs Ph : A) (C nab : ι -> A)
    (hclean : CleanSquareHypotheses Im Gs Ph C nab)
    (htetrad : forall a b, frameComm C nab a b = 0)
    (a b c : ι) :
    covariantDerivative nab a (cliffordMetric C b c) = 0
      /\ commutator (curvature nab a b) (C c) = 0
      /\ (covariantDerivative nab a (curvature nab b c)
          + covariantDerivative nab b (curvature nab c a)
          + covariantDerivative nab c (curvature nab a b) = 0)
      /\ ((Im * dNsum C nab + Gs * Ph) * (Im * dNsum C nab + Gs * Ph)
          = -(Boxnull C nab) - Cdiamond C nab + Ph * Ph
            - Im * (Gs * Finset.sum Finset.univ
              (fun i => C i * (nab i * Ph - Ph * nab i)))) := by
  refine ⟨metric_compatibility_from_tetrad C nab htetrad a b c,
    curvature_clifford_compatible_of_tetrad C nab htetrad a b c,
    covariant_bianchi_commutator nab a b c, ?_⟩
  simpa only using finite_lichnerowicz_square_tetrad Im Gs Ph C nab hclean htetrad

end DiracConnectionChain

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.covariant_bianchi_commutator' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.covariant_bianchi_commutator

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.metric_compatibility_from_tetrad' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.metric_compatibility_from_tetrad

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.curvature_clifford_compatible_of_tetrad' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.curvature_clifford_compatible_of_tetrad

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.commutator_conjugation_covariant' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.commutator_conjugation_covariant

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.anticommutator_conjugation_covariant' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.anticommutator_conjugation_covariant

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.curvature_conjugation_covariant' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.curvature_conjugation_covariant

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.finite_connection_dirac_chain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry.finite_connection_dirac_chain

end PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry
