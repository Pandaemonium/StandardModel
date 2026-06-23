import Mathlib.Tactic

/-!
# P9 orthogonal projector core

Standalone Aristotle target.  The intended live-repo destination is
`PhysicsSM.Draft.NullEdgeP9OrthogonalProjectorCore`.

Scientific role: make the P9 harmonic/source-visible layer more concrete.
Given a finite self-adjoint idempotent projector, the residual part
`x - Pi x` is invisible to harmonic tests.  This is the abstract finite algebra
that an explicit diamond Hodge projector should later instantiate.
-/

noncomputable section

namespace NullEdgeP9OrthogonalProjectorCore

open BigOperators

abbrev Cochain (n : Nat) := Fin n -> Real

def dot {n : Nat} (x y : Cochain n) : Real :=
  Finset.univ.sum fun i => x i * y i

def lin {n : Nat} (Pi : Fin n -> Fin n -> Real) (x : Cochain n) : Cochain n :=
  fun i => Finset.univ.sum fun j => Pi i j * x j

def subCochain {n : Nat} (x y : Cochain n) : Cochain n :=
  fun i => x i - y i

def sourcePairing {n : Nat} (source test : Cochain n) : Real :=
  dot source test

def SelfAdjoint {n : Nat} (Pi : Fin n -> Fin n -> Real) : Prop :=
  forall x y : Cochain n, dot (lin Pi x) y = dot x (lin Pi y)

def Idempotent {n : Nat} (Pi : Fin n -> Fin n -> Real) : Prop :=
  forall x : Cochain n, lin Pi (lin Pi x) = lin Pi x

def HarmonicTest {n : Nat} (Pi : Fin n -> Fin n -> Real)
    (test : Cochain n) : Prop :=
  lin Pi test = test

theorem projected_is_harmonicTest
    {n : Nat} (Pi : Fin n -> Fin n -> Real) (x : Cochain n)
    (hidempotent : Idempotent Pi) :
    HarmonicTest Pi (lin Pi x) := by
  unfold HarmonicTest Idempotent at *
  exact hidempotent x

theorem harmonic_pairing_eq_projected_pairing
    {n : Nat} (Pi : Fin n -> Fin n -> Real)
    (source test : Cochain n)
    (hself : SelfAdjoint Pi)
    (htest : HarmonicTest Pi test) :
    sourcePairing source test = sourcePairing (lin Pi source) test := by
  sorry

theorem residual_orthogonal_to_harmonicTest
    {n : Nat} (Pi : Fin n -> Fin n -> Real)
    (source test : Cochain n)
    (hself : SelfAdjoint Pi)
    (htest : HarmonicTest Pi test) :
    dot (subCochain source (lin Pi source)) test = 0 := by
  sorry

theorem harmonic_tests_see_only_projected_source
    {n : Nat} (Pi : Fin n -> Fin n -> Real)
    (source test : Cochain n)
    (hself : SelfAdjoint Pi)
    (htest : HarmonicTest Pi test) :
    sourcePairing source test =
      sourcePairing (lin Pi source) test +
        dot (subCochain source (lin Pi source)) test := by
  sorry

end NullEdgeP9OrthogonalProjectorCore
