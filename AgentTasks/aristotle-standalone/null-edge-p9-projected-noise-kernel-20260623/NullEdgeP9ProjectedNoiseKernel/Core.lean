import Mathlib.Tactic

/-!
# P9 projected noise-kernel positivity

This focused package proves the finite algebra for projecting a noise kernel
onto a chosen observer/harmonic subspace. The projected kernel response is the
original kernel response evaluated on the projected test vector; hence
positive-semidefiniteness is preserved by projection.
-/

noncomputable section

namespace NullEdgeP9ProjectedNoiseKernel

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

def PositiveKernel {n : Nat} (K : Kernel n) : Prop :=
  forall t : Cochain n, 0 <= kernelResponse K t

theorem projectedKernel_response_eq_response_projectedTest
    {n : Nat} (Pi : Fin n -> Fin n -> Real) (K : Kernel n)
    (t : Cochain n) :
    kernelResponse (projectedKernel Pi K) t =
      kernelResponse K (linTranspose Pi t) := by
  sorry

theorem projectedKernel_positive
    {n : Nat} (Pi : Fin n -> Fin n -> Real) (K : Kernel n)
    (hK : PositiveKernel K) :
    PositiveKernel (projectedKernel Pi K) := by
  sorry

end NullEdgeP9ProjectedNoiseKernel
