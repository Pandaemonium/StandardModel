import Mathlib

/-!
# The naive global finite transport trace always cancels

This target prevents a hollow definition in the open-boundary 3+1 route. On a
finite Hilbert space, exact unitarity and cyclicity force the global trace of a
transported projector minus itself to vanish. Local flow can still be nonzero;
the explicit swap witness shows its compensating contribution elsewhere.

## Correct consequence

`globalCutFlow_zero` shows that the *naive global* finite cut flow
`Tr(U^* P U - P)` is identically zero for every exactly unitary finite matrix,
so it can never serve as a chiral certificate on its own. This is **not** a
universal no-go against boundary transport: the swap witness below exhibits
genuine, nonzero, and mutually opposite *local* diagonal flow at the two sites
while the global trace cancels. The takeaway is that any nonzero chiral
certificate must be **localized/relative** (a difference of local flows or a
relative index), **causal-region restricted** (traced over a subregion rather
than globally), or **infinite-volume** (where cyclicity of the global trace no
longer applies). No claim is made that boundary transport itself vanishes.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteTransportTraceNoGo

open Matrix Complex

def IsUnitary {n : Type*} [Fintype n] [DecidableEq n]
    (U : Matrix n n Complex) : Prop := Uᴴ * U = 1 ∧ U * Uᴴ = 1

def globalCutFlow {n : Type*} [Fintype n] [DecidableEq n]
    (U P : Matrix n n Complex) : Complex := (Uᴴ * P * U - P).trace

/-- Any naive global finite transport trace vanishes exactly. -/
theorem globalCutFlow_zero {n : Type*} [Fintype n] [DecidableEq n]
    (U P : Matrix n n Complex) (hU : IsUnitary U) :
    globalCutFlow U P = 0 := by
  convert Matrix.trace_sub (Uᴴ * P * U) P using 1
  rw [Matrix.trace_mul_comm]
  simp_all +decide [← Matrix.mul_assoc, IsUnitary]

def swap : Matrix (Fin 2) (Fin 2) Complex := !![0, 1; 1, 0]
def leftProjector : Matrix (Fin 2) (Fin 2) Complex := !![1, 0; 0, 0]

theorem swap_unitary : IsUnitary swap := by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply, swap]

/-- The two local diagonal contributions are nonzero and opposite. -/
theorem swap_local_flow_witness :
    (swapᴴ * leftProjector * swap - leftProjector) 0 0 = -1 ∧
    (swapᴴ * leftProjector * swap - leftProjector) 1 1 = 1 := by
  norm_num [swap, leftProjector, Matrix.mul_apply]

/-- The same witness has zero global flow despite nonzero local motion. -/
theorem swap_global_flow_zero : globalCutFlow swap leftProjector = 0 := by
  convert globalCutFlow_zero swap leftProjector swap_unitary using 1

end PhysicsSM.Draft.NullEdge.FiniteTransportTraceNoGo

/-! ### Build-enforced standard-axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTransportTraceNoGo.globalCutFlow_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteTransportTraceNoGo.globalCutFlow_zero

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteTransportTraceNoGo.swap_local_flow_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteTransportTraceNoGo.swap_local_flow_witness
