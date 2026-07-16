import Mathlib
import PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry

/-!
# Finite Cartan-Bianchi identities for null-edge connection data

This module adds the torsionful partner of the commutator Bianchi identity in
`FiniteConnectionGeometry`. For finite connection operators `nab a` and
coframe operators `E a`, define the fixed-label Cartan torsion

```text
T_ab = [nab_a, E_b] - [nab_b, E_a].
```

The main theorem is the exact associative-ring identity

```text
D_a T_bc + D_b T_ca + D_c T_ab
  = [F_ab, E_c] + [F_bc, E_a] + [F_ca, E_b],
```

where `D_a X = [nab_a, X]` and `F_ab = [nab_a, nab_b]`. It is the algebraic
Cartan first-Bianchi shape for globally fixed labels. It does not construct a
cochain complex, include anholonomic structure coefficients, identify a
continuum torsion or Riemann tensor, or imply the contracted Bianchi identity.

The torsion-free corollary gives the cyclic curvature action on the coframe.
The final paired theorem records both this first-Bianchi identity and the
Jacobi/connection second-Bianchi identity from `FiniteConnectionGeometry`.
The closing covariance layer proves that simultaneous fixed sandwiching of
`nab` and `E` carries torsion and both sides of the first identity by the same
transform. With only a left inverse this transform need not be a group action
or algebra automorphism.
-/

namespace PhysicsSM.Draft.NullEdge.FiniteCartanBianchi

open PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry

section RingIdentities

variable {ι A : Type*} [Ring A]

/-- Fixed-label finite Cartan torsion obtained by antisymmetrizing covariant
derivatives of the coframe operators. -/
def cartanTorsion (nab E : ι -> A) (a b : ι) : A :=
  covariantDerivative nab a (E b) - covariantDerivative nab b (E a)

/-- Adjoint covariant derivatives commute by the adjoint action of curvature. -/
theorem adjoint_derivative_commutator
    (nab : ι -> A) (a b : ι) (x : A) :
    covariantDerivative nab a (covariantDerivative nab b x)
        - covariantDerivative nab b (covariantDerivative nab a x)
      = FiniteConnectionGeometry.commutator (curvature nab a b) x := by
  unfold covariantDerivative curvature FiniteConnectionGeometry.commutator
  noncomm_ring

/-- Cartan torsion is antisymmetric in its direction labels. -/
theorem cartanTorsion_antisymm (nab E : ι -> A) (a b : ι) :
    cartanTorsion nab E a b = -cartanTorsion nab E b a := by
  unfold cartanTorsion
  abel

/-- **Finite torsionful Cartan first-Bianchi identity.** -/
theorem cartan_first_bianchi
    (nab E : ι -> A) (a b c : ι) :
    covariantDerivative nab a (cartanTorsion nab E b c)
        + covariantDerivative nab b (cartanTorsion nab E c a)
        + covariantDerivative nab c (cartanTorsion nab E a b)
      = FiniteConnectionGeometry.commutator (curvature nab a b) (E c)
        + FiniteConnectionGeometry.commutator (curvature nab b c) (E a)
        + FiniteConnectionGeometry.commutator (curvature nab c a) (E b) := by
  unfold cartanTorsion covariantDerivative curvature FiniteConnectionGeometry.commutator
  noncomm_ring

/-- If the fixed-label Cartan torsion vanishes in every pair, the cyclic
curvature action on the coframe vanishes. -/
theorem curvature_frame_cyclic_zero_of_torsion_free
    (nab E : ι -> A)
    (hT : forall a b, cartanTorsion nab E a b = 0)
    (a b c : ι) :
    FiniteConnectionGeometry.commutator (curvature nab a b) (E c)
        + FiniteConnectionGeometry.commutator (curvature nab b c) (E a)
        + FiniteConnectionGeometry.commutator (curvature nab c a) (E b) = 0 := by
  rw [← cartan_first_bianchi nab E a b c]
  rw [hT b c, hT c a, hT a b]
  simp [covariantDerivative, FiniteConnectionGeometry.commutator]

/-- Paired finite Cartan identities: the torsionful first-Bianchi relation and
the connection/Jacobi second-Bianchi relation hold simultaneously. -/
theorem finite_cartan_bianchi_pair
    (nab E : ι -> A) (a b c : ι) :
    (covariantDerivative nab a (cartanTorsion nab E b c)
          + covariantDerivative nab b (cartanTorsion nab E c a)
          + covariantDerivative nab c (cartanTorsion nab E a b)
        = FiniteConnectionGeometry.commutator (curvature nab a b) (E c)
          + FiniteConnectionGeometry.commutator (curvature nab b c) (E a)
          + FiniteConnectionGeometry.commutator (curvature nab c a) (E b))
      /\ (covariantDerivative nab a (curvature nab b c)
          + covariantDerivative nab b (curvature nab c a)
          + covariantDerivative nab c (curvature nab a b) = 0) := by
  exact ⟨cartan_first_bianchi nab E a b c,
    covariant_bianchi_commutator nab a b c⟩

/-! ## Simultaneous conjugation-shaped covariance -/

/-- Pointwise fixed sandwiching of a labelled operator family. -/
def conjugateFamily (g gInv : A) (X : ι -> A) : ι -> A :=
  fun a => g * X a * gInv

/-- The adjoint covariant derivative is covariant when both its connection and
argument are transformed by the same fixed sandwiching. -/
theorem covariantDerivative_conjugateFamily
    (g gInv : A) (hInv : gInv * g = 1) (nab : ι -> A) (a : ι) (x : A) :
    covariantDerivative (conjugateFamily g gInv nab) a (g * x * gInv) =
      g * covariantDerivative nab a x * gInv := by
  unfold covariantDerivative conjugateFamily
  exact commutator_conjugation_covariant g gInv (nab a) x hInv

/-- Commutator curvature is covariant under pointwise fixed sandwiching. -/
theorem curvature_conjugateFamily
    (g gInv : A) (hInv : gInv * g = 1) (nab : ι -> A) (a b : ι) :
    curvature (conjugateFamily g gInv nab) a b =
      g * curvature nab a b * gInv := by
  unfold conjugateFamily
  exact curvature_conjugation_covariant nab g gInv hInv a b

/-- Fixed-label Cartan torsion is covariant when both the connection and
coframe families are transformed by the same fixed sandwiching. -/
theorem cartanTorsion_conjugateFamily
    (g gInv : A) (hInv : gInv * g = 1) (nab E : ι -> A) (a b : ι) :
    cartanTorsion (conjugateFamily g gInv nab)
        (conjugateFamily g gInv E) a b =
      g * cartanTorsion nab E a b * gInv := by
  unfold cartanTorsion
  change
    covariantDerivative (conjugateFamily g gInv nab) a (g * E b * gInv) -
        covariantDerivative (conjugateFamily g gInv nab) b (g * E a * gInv) = _
  rw [covariantDerivative_conjugateFamily g gInv hInv nab a (E b),
    covariantDerivative_conjugateFamily g gInv hInv nab b (E a)]
  noncomm_ring

/-- The cyclic covariant-torsion side of `cartan_first_bianchi` transforms
covariantly under simultaneous fixed sandwiching. -/
theorem cartan_first_bianchi_lhs_conjugateFamily
    (g gInv : A) (hInv : gInv * g = 1) (nab E : ι -> A) (a b c : ι) :
    covariantDerivative (conjugateFamily g gInv nab) a
          (cartanTorsion (conjugateFamily g gInv nab)
            (conjugateFamily g gInv E) b c)
        + covariantDerivative (conjugateFamily g gInv nab) b
          (cartanTorsion (conjugateFamily g gInv nab)
            (conjugateFamily g gInv E) c a)
        + covariantDerivative (conjugateFamily g gInv nab) c
          (cartanTorsion (conjugateFamily g gInv nab)
            (conjugateFamily g gInv E) a b) =
      g * (covariantDerivative nab a (cartanTorsion nab E b c)
        + covariantDerivative nab b (cartanTorsion nab E c a)
        + covariantDerivative nab c (cartanTorsion nab E a b)) * gInv := by
  rw [cartanTorsion_conjugateFamily g gInv hInv nab E b c,
    cartanTorsion_conjugateFamily g gInv hInv nab E c a,
    cartanTorsion_conjugateFamily g gInv hInv nab E a b]
  rw [covariantDerivative_conjugateFamily g gInv hInv nab a (cartanTorsion nab E b c),
    covariantDerivative_conjugateFamily g gInv hInv nab b (cartanTorsion nab E c a),
    covariantDerivative_conjugateFamily g gInv hInv nab c (cartanTorsion nab E a b)]
  noncomm_ring

/-- The cyclic curvature-action side of `cartan_first_bianchi` transforms
covariantly under simultaneous fixed sandwiching. -/
theorem cartan_first_bianchi_rhs_conjugateFamily
    (g gInv : A) (hInv : gInv * g = 1) (nab E : ι -> A) (a b c : ι) :
    FiniteConnectionGeometry.commutator
          (curvature (conjugateFamily g gInv nab) a b)
          (conjugateFamily g gInv E c)
        + FiniteConnectionGeometry.commutator
          (curvature (conjugateFamily g gInv nab) b c)
          (conjugateFamily g gInv E a)
        + FiniteConnectionGeometry.commutator
          (curvature (conjugateFamily g gInv nab) c a)
          (conjugateFamily g gInv E b) =
      g * (FiniteConnectionGeometry.commutator (curvature nab a b) (E c)
        + FiniteConnectionGeometry.commutator (curvature nab b c) (E a)
        + FiniteConnectionGeometry.commutator (curvature nab c a) (E b)) * gInv := by
  rw [curvature_conjugateFamily g gInv hInv nab a b,
    curvature_conjugateFamily g gInv hInv nab b c,
    curvature_conjugateFamily g gInv hInv nab c a]
  simp only [conjugateFamily]
  rw [commutator_conjugation_covariant g gInv (curvature nab a b) (E c) hInv,
    commutator_conjugation_covariant g gInv (curvature nab b c) (E a) hInv,
    commutator_conjugation_covariant g gInv (curvature nab c a) (E b) hInv]
  noncomm_ring

end RingIdentities

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCartanBianchi.cartan_first_bianchi' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteCartanBianchi.cartan_first_bianchi

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCartanBianchi.finite_cartan_bianchi_pair' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteCartanBianchi.finite_cartan_bianchi_pair

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCartanBianchi.cartanTorsion_conjugateFamily' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteCartanBianchi.cartanTorsion_conjugateFamily

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCartanBianchi.cartan_first_bianchi_lhs_conjugateFamily' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteCartanBianchi.cartan_first_bianchi_lhs_conjugateFamily

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCartanBianchi.cartan_first_bianchi_rhs_conjugateFamily' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteCartanBianchi.cartan_first_bianchi_rhs_conjugateFamily

end PhysicsSM.Draft.NullEdge.FiniteCartanBianchi
