import Mathlib.Tactic

/-!
# P9 strict projected-kernel core

This draft module strengthens projected noise-kernel positivity to a strict
no-hidden-null-modes statement. If the original finite noise kernel is strictly
positive and the projected test is nonzero, then the projected response is
strictly positive; zero projected response is equivalent to a zero projected
test.

Proven by Aristotle project `6dfa769d-2271-4cbf-aca6-4a05e7827254` on
2026-06-23 from the focused package
`null-edge-p9-strict-projected-kernel-20260623`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9StrictProjectedKernel

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
  unfold kernelResponse projectedKernel linTranspose
  simp +decide only [mul_comm, Finset.mul_sum _ _ _, mul_assoc]
  simp +decide only [<- Finset.sum_product']
  refine' Finset.sum_bij (fun x _ => (x.2.2.1, x.2.2.2, x.2.1, x.1)) _ _ _ _ <;>
    simp +decide
  exact fun _ _ _ _ => Or.inl <| Or.inl <| by ring

theorem projectedKernel_strict_on_nonzero_projectedTest
    {n : Nat} (Pi : Fin n -> Fin n -> Real) (K : Kernel n)
    (hK : PositiveDefiniteKernel K)
    (t : Cochain n)
    (hproj : linTranspose Pi t != 0) :
    0 < kernelResponse (projectedKernel Pi K) t := by
  rw [projectedKernel_response_eq_response_projectedTest]
  exact hK _ hproj

theorem projectedKernel_response_zero_iff_projectedTest_zero
    {n : Nat} (Pi : Fin n -> Fin n -> Real) (K : Kernel n)
    (hK : PositiveDefiniteKernel K)
    (t : Cochain n) :
    kernelResponse (projectedKernel Pi K) t = 0 <->
      linTranspose Pi t = 0 := by
  constructor
  case mp =>
    intro hzero
    by_contra hproj
    have hprojBool : linTranspose Pi t != 0 := by
      simp [hproj]
    have hpos := projectedKernel_strict_on_nonzero_projectedTest Pi K hK t hprojBool
    rw [hzero] at hpos
    exact (not_lt_of_ge le_rfl) hpos
  case mpr =>
    intro hproj
    rw [projectedKernel_response_eq_response_projectedTest, hproj]
    unfold kernelResponse
    simp

end PhysicsSM.Draft.NullEdgeP9StrictProjectedKernel
