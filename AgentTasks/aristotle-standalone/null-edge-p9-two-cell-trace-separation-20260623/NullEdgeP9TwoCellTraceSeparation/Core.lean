import Mathlib.Tactic

/-!
# P9 two-cell trace separation

Focused Aristotle target for the C4 P9 route.

Scientific role: the C4 gate needs non-vacuous geometry sensitivity. This toy
module proves that a fixed two-cell coarse readout can distinguish two explicit
diagonal kernels. It is not a causal-diamond result, but it prevents the
variance route from being purely formal: the trace statistic can move when the
kernel weights move.
-/

noncomputable section

open scoped BigOperators

namespace NullEdgeP9TwoCellTraceSeparation

abbrev Kernel (n : Nat) := Fin n -> Fin n -> Real

def trace {n : Nat} (K : Kernel n) : Real :=
  Finset.univ.sum fun i => K i i

def diagonalKernel2 (a b : Real) : Kernel 2 :=
  fun i j =>
    if i = j then
      if i = (0 : Fin 2) then a else b
    else 0

def identityR2 : Fin 2 -> Fin 2 -> Real :=
  fun a i => if a = i then 1 else 0

def coarseKernel {m n : Nat} (R : Fin m -> Fin n -> Real)
    (K : Kernel n) : Kernel m :=
  fun a b => Finset.univ.sum fun i =>
    Finset.univ.sum fun j => R a i * K i j * R b j

theorem trace_diagonalKernel2 (a b : Real) :
    trace (diagonalKernel2 a b) = a + b := by
  sorry

theorem identityR2_coarse_diagonal_trace (a b : Real) :
    trace (coarseKernel identityR2 (diagonalKernel2 a b)) = a + b := by
  sorry

theorem two_cell_trace_separates :
    trace (coarseKernel identityR2 (diagonalKernel2 1 1)) !=
      trace (coarseKernel identityR2 (diagonalKernel2 1 2)) := by
  sorry

theorem two_cell_trace_strict_mono {a b c d : Real}
    (h : a + b < c + d) :
    trace (coarseKernel identityR2 (diagonalKernel2 a b)) <
      trace (coarseKernel identityR2 (diagonalKernel2 c d)) := by
  sorry

end NullEdgeP9TwoCellTraceSeparation

end
