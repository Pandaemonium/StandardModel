import Mathlib.Tactic

/-!
# P9 projected noise-kernel positivity

This draft module proves the finite algebra for projecting a noise kernel onto a
chosen observer/harmonic subspace. The projected kernel response is the original
kernel response evaluated on the projected test vector; hence positive
semidefiniteness is preserved by projection.

Proven by Aristotle project `914a99b2-b1b7-4721-9cf0-c7f50558bd39` on
2026-06-23 from the focused package
`null-edge-p9-projected-noise-kernel-20260623`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9ProjectedNoiseKernel

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
  unfold kernelResponse projectedKernel linTranspose
  simp +decide only [mul_comm, mul_left_comm, Finset.mul_sum, Finset.sum_mul _ _ _]
  simp +decide only [<- Finset.sum_product']
  apply Finset.sum_bij (fun x _ => (x.2.2.1, x.2.2.2, x.1, x.2.1))
  all_goals aesop

theorem projectedKernel_positive
    {n : Nat} (Pi : Fin n -> Fin n -> Real) (K : Kernel n)
    (hK : PositiveKernel K) :
    PositiveKernel (projectedKernel Pi K) := by
  intro t
  exact hK _ |> fun h => by
    rw [projectedKernel_response_eq_response_projectedTest]
    exact h

end PhysicsSM.Draft.NullEdgeP9ProjectedNoiseKernel
