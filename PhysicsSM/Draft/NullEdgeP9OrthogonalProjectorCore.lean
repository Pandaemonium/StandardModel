import Mathlib.Tactic

/-!
# P9 orthogonal projector core

This draft module records the finite algebra behind a P9 harmonic/source-visible
projector. Given a finite self-adjoint idempotent projector, harmonic tests see
only the projected source, and the residual part is invisible to those tests.

Proven by Aristotle project `a0dadc4c-2ea3-4741-b96b-508a795d1e1b` on
2026-06-23 from the focused package
`null-edge-p9-orthogonal-projector-core-20260623`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9OrthogonalProjectorCore

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
  unfold sourcePairing
  calc
    dot source test = dot source (lin Pi test) := by
      rw [htest]
    _ = dot (lin Pi source) test := (hself source test).symm

theorem residual_orthogonal_to_harmonicTest
    {n : Nat} (Pi : Fin n -> Fin n -> Real)
    (source test : Cochain n)
    (hself : SelfAdjoint Pi)
    (htest : HarmonicTest Pi test) :
    dot (subCochain source (lin Pi source)) test = 0 := by
  have hpair := harmonic_pairing_eq_projected_pairing Pi source test hself htest
  unfold sourcePairing at hpair
  calc
    dot (subCochain source (lin Pi source)) test =
        dot source test - dot (lin Pi source) test := by
      unfold dot subCochain
      simp +decide [Finset.sum_sub_distrib, sub_mul]
    _ = 0 := by
      rw [hpair]
      ring

theorem harmonic_tests_see_only_projected_source
    {n : Nat} (Pi : Fin n -> Fin n -> Real)
    (source test : Cochain n)
    (hself : SelfAdjoint Pi)
    (htest : HarmonicTest Pi test) :
    sourcePairing source test =
      sourcePairing (lin Pi source) test +
        dot (subCochain source (lin Pi source)) test := by
  calc
    sourcePairing source test =
        sourcePairing (lin Pi source) test :=
      harmonic_pairing_eq_projected_pairing Pi source test hself htest
    _ = sourcePairing (lin Pi source) test + 0 := by ring
    _ = sourcePairing (lin Pi source) test +
        dot (subCochain source (lin Pi source)) test := by
      rw [residual_orthogonal_to_harmonicTest Pi source test hself htest]

end PhysicsSM.Draft.NullEdgeP9OrthogonalProjectorCore
