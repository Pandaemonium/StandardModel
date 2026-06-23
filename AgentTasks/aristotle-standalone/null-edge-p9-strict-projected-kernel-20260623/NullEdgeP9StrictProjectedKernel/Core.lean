import Mathlib.Tactic

/-!
# P9 strict projected-kernel core

Standalone Aristotle target.  The intended live-repo destination is
`PhysicsSM.Draft.NullEdgeP9StrictProjectedKernel`.

Scientific role: strengthen the projected-noise result from positivity to a
no-hidden-null-modes statement.  If the original finite noise kernel is strictly
positive and the projected test is nonzero, then the projected response is
strictly positive; zero projected response is equivalent to a zero projected
test.
-/

noncomputable section

namespace NullEdgeP9StrictProjectedKernel

open BigOperators

abbrev Cochain (n : Nat) := Fin n -> Real
abbrev Kernel (n : Nat) := Fin n -> Fin n -> Real

def linTranspose {n : Nat}
    (Pi : Fin n -> Fin n -> Real) (t : Cochain n) : Cochain n :=
  fun a => Finset.univ.sum fun i => Pi a i * t i

def kernelResponse {n : Nat} (K : Kernel n) (t : Cochain n) : Real :=
  Finset.univ.sum fun i =>
    Finset.univ.sum fun j => t i * t j * K i j

def projectedKernel {n : Nat}
    (Pi : Fin n -> Fin n -> Real) (K : Kernel n) : Kernel n :=
  fun i j =>
    Finset.univ.sum fun a =>
      Finset.univ.sum fun b => Pi a i * Pi b j * K a b

def PositiveDefiniteKernel {n : Nat} (K : Kernel n) : Prop :=
  forall t : Cochain n, t != 0 -> 0 < kernelResponse K t

theorem projectedKernel_response_eq_response_projectedTest
    {n : Nat} (Pi : Fin n -> Fin n -> Real) (K : Kernel n)
    (t : Cochain n) :
    kernelResponse (projectedKernel Pi K) t =
      kernelResponse K (linTranspose Pi t) := by
  sorry

theorem projectedKernel_strict_on_nonzero_projectedTest
    {n : Nat} (Pi : Fin n -> Fin n -> Real) (K : Kernel n)
    (hK : PositiveDefiniteKernel K)
    (t : Cochain n)
    (hproj : linTranspose Pi t != 0) :
    0 < kernelResponse (projectedKernel Pi K) t := by
  sorry

theorem projectedKernel_response_zero_iff_projectedTest_zero
    {n : Nat} (Pi : Fin n -> Fin n -> Real) (K : Kernel n)
    (hK : PositiveDefiniteKernel K)
    (t : Cochain n) :
    kernelResponse (projectedKernel Pi K) t = 0 <->
      linTranspose Pi t = 0 := by
  sorry

end NullEdgeP9StrictProjectedKernel
