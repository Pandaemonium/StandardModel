import Mathlib.Tactic

/-!
# P9 coarse-grained noise-kernel PSD

Focused Aristotle target for the C4 P9 route.

Scientific role: the corrected P9 gate asks for a fixed coarse-graining map `R`
and a projected/coarse noise kernel `R K R^T`. The first necessary theorem is
that coarse-graining preserves positive semidefiniteness and that coarse
response is exactly fine response against the pulled-back coarse test.
-/

noncomputable section

open scoped BigOperators

namespace NullEdgeP9CoarseKernelPSD

abbrev Vec (n : Nat) := Fin n -> Real

/-- Quadratic response of a finite kernel. -/
def response {n : Nat} (K : Fin n -> Fin n -> Real) (x : Vec n) : Real :=
  Finset.univ.sum fun i => Finset.univ.sum fun j => x i * K i j * x j

/-- Positive semidefinite kernel, stated only through finite quadratic tests. -/
def PSD {n : Nat} (K : Fin n -> Fin n -> Real) : Prop :=
  forall x : Vec n, 0 <= response K x

/-- Pull back a coarse test to a fine test using the coarse-graining matrix `R`. -/
def pullback {m n : Nat} (R : Fin m -> Fin n -> Real) (y : Vec m) : Vec n :=
  fun i => Finset.univ.sum fun a => R a i * y a

/-- Push a fine kernel forward to a coarse kernel: `R K R^T`. -/
def coarseKernel {m n : Nat} (R : Fin m -> Fin n -> Real)
    (K : Fin n -> Fin n -> Real) : Fin m -> Fin m -> Real :=
  fun a b => Finset.univ.sum fun i =>
    Finset.univ.sum fun j => R a i * K i j * R b j

/-- Coarse response equals fine response of the pulled-back test. -/
theorem response_coarseKernel_eq_response_pullback {m n : Nat}
    (R : Fin m -> Fin n -> Real) (K : Fin n -> Fin n -> Real)
    (y : Vec m) :
    response (coarseKernel R K) y = response K (pullback R y) := by
  sorry

/-- Coarse-graining preserves positive semidefiniteness. -/
theorem coarseKernel_psd {m n : Nat}
    (R : Fin m -> Fin n -> Real) (K : Fin n -> Fin n -> Real)
    (hK : PSD K) :
    PSD (coarseKernel R K) := by
  sorry

/-- Coordinate basis vector. -/
def standardBasis {n : Nat} (i : Fin n) : Vec n :=
  fun j => if j = i then 1 else 0

/-- A PSD kernel has nonnegative diagonal entries. -/
theorem psd_diag_nonneg {n : Nat} (K : Fin n -> Fin n -> Real)
    (hK : PSD K) (i : Fin n) :
    0 <= K i i := by
  sorry

/-- The trace of a PSD coarse kernel is nonnegative. -/
theorem trace_coarseKernel_nonneg {m n : Nat}
    (R : Fin m -> Fin n -> Real) (K : Fin n -> Fin n -> Real)
    (hK : PSD K) :
    0 <= Finset.univ.sum fun a : Fin m => coarseKernel R K a a := by
  sorry

end NullEdgeP9CoarseKernelPSD

end
