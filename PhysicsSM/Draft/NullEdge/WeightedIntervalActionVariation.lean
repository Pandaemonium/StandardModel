import PhysicsSM.Draft.NullEdge.RelaxedCausalMetricVariationBridge
import PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator

/-!
# Weighted interval-count action variation

This module implements the first graph-native, noncircular action derivative in
the null-edge general-relativity program. A fixed finite causal order supplies
the interval counts. Continuous layer weights are varied while the order,
bulk weight, boundary value, and cosmological value are held fixed.

The derivative is an explicit finite sum of interval-layer abundances. It is
equivariant under causal-order isomorphism and has a nonzero two-event witness.
No Ricci tensor, scalar curvature, metric, or Einstein coefficient appears in
the definition of the action or its derivative.

This result does not yet show that the layer-weight directions reconstruct all
symmetric metric variations, that the action descends to the operator-derived
metric, or that its derivative equals the Einstein tensor. Those are the next
rank, fiber-independence, curvature-identification, sign, and boundary gates.

Provenance: the interval-layer architecture is a clean-room finite abstraction
of the Benincasa-Dowker causal-set operator/action program. The precise first
target and its kill conditions were independently audited in Aristotle project
`8800eed1-b87b-464b-b28e-89c21ce9c8a0`. Claim grade: `M [orig/comp]` for the
finite variation and covariance only.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.WeightedIntervalActionVariation

open scoped BigOperators
open FiniteCausalOrderOperator

variable {V W : Type*} [Fintype V] [Fintype W]

/-- The weighted abundance of causal pairs whose future endpoint has the
displayed bulk weight and whose open interval has cardinality `layer`. -/
def intervalLayerAbundance
    (C : FiniteCausalOrder V) (bulkWeight : V -> Real)
    (layer : Nat) : Real :=
  ∑ x : V, bulkWeight x *
    C.layeredPastSum (fun n => if n = layer then 1 else 0)
      (fun _ => 1) x

/-- Truncated interval-count action with displayed held-fixed boundary and
cosmological contributions. Their later geometric formulas and variations
must be supplied separately rather than hidden in this first bulk test. -/
def truncatedIntervalAction
    (C : FiniteCausalOrder V) (bulkWeight : V -> Real) (K : Nat)
    (weight : Fin K -> Real) (boundary cosmological : Real) : Real :=
  (∑ k : Fin K, weight k * intervalLayerAbundance C bulkWeight k) +
    boundary + cosmological

/-- Explicit response obtained by replacing every layer weight by its affine
direction while holding the graph and remaining action data fixed. -/
def intervalWeightResponse
    (C : FiniteCausalOrder V) (bulkWeight : V -> Real) (K : Nat)
    (direction : Fin K -> Real) : Real :=
  ∑ k : Fin K, direction k * intervalLayerAbundance C bulkWeight k

/-- **Genuine weighted-interval derivative.** The derivative follows directly
from the displayed finite interval-count action. -/
theorem truncatedIntervalAction_directionalDerivative
    (C : FiniteCausalOrder V) (bulkWeight : V -> Real) (K : Nat)
    (weight direction : Fin K -> Real) (boundary cosmological : Real) :
    HasDerivAt
      (fun t : Real => truncatedIntervalAction C bulkWeight K
        (weight + t • direction) boundary cosmological)
      (intervalWeightResponse C bulkWeight K direction) 0 := by
  have hSum : HasDerivAt
      (fun t : Real => ∑ k : Fin K,
        (weight k + t * direction k) *
          intervalLayerAbundance C bulkWeight k)
      (∑ k : Fin K, direction k *
        intervalLayerAbundance C bulkWeight k) 0 := by
    simpa using HasDerivAt.fun_sum (u := Finset.univ)
      (fun k _ =>
        ((((hasDerivAt_id (𝕜 := Real) 0).mul_const (direction k)).const_add
          (weight k)).mul_const (intervalLayerAbundance C bulkWeight k)))
  simpa [truncatedIntervalAction, intervalWeightResponse, Pi.add_apply,
    Pi.smul_apply, smul_eq_mul] using
      (hSum.add_const boundary).add_const cosmological

/-! ## Relabeling covariance -/

/-- Interval-layer abundance is intrinsic to the finite causal order when the
bulk weight is relabeled with the events. -/
theorem intervalLayerAbundance_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (bulkWeight : V -> Real) (layer : Nat) :
    intervalLayerAbundance D (e.relabelField bulkWeight) layer =
      intervalLayerAbundance C bulkWeight layer := by
  unfold intervalLayerAbundance
  symm
  apply Fintype.sum_equiv e.toEquiv
  intro x
  rw [e.relabelField_apply]
  have hLayer := e.layeredPastSum_equivariant
    (fun n => if n = layer then (1 : Real) else 0) (fun _ : V => 1) x
  have hLayerConstant :
      D.layeredPastSum (fun n => if n = layer then (1 : Real) else 0)
          (fun _ : W => 1) (e.toEquiv x) =
        C.layeredPastSum (fun n => if n = layer then (1 : Real) else 0)
          (fun _ : V => 1) x := by
    simpa [OrderIso.relabelField] using hLayer
  rw [hLayerConstant]

/-- The truncated action is invariant under causal-order relabeling. -/
theorem truncatedIntervalAction_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (bulkWeight : V -> Real) (K : Nat)
    (weight : Fin K -> Real) (boundary cosmological : Real) :
    truncatedIntervalAction D (e.relabelField bulkWeight) K weight
        boundary cosmological =
      truncatedIntervalAction C bulkWeight K weight boundary cosmological := by
  unfold truncatedIntervalAction
  congr 2
  apply Finset.sum_congr rfl
  intro k _
  rw [intervalLayerAbundance_equivariant e]

/-- The directional response is likewise invariant under relabeling. -/
theorem intervalWeightResponse_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (bulkWeight : V -> Real) (K : Nat)
    (direction : Fin K -> Real) :
    intervalWeightResponse D (e.relabelField bulkWeight) K direction =
      intervalWeightResponse C bulkWeight K direction := by
  unfold intervalWeightResponse
  apply Finset.sum_congr rfl
  intro k _
  rw [intervalLayerAbundance_equivariant e]

/-! ## Nonzero two-event witness -/

/-- Select the future event of the canonical two-event causal order. -/
def twoEventBulkWeight (x : Fin 2) : Real :=
  if x = 1 then 1 else 0

/-- The selected two-event order contains exactly one layer-zero causal pair. -/
theorem twoEvent_layerZero_abundance :
    intervalLayerAbundance twoEventOrder twoEventBulkWeight 0 = 1 := by
  have hLayer :
      twoEventOrder.layeredPastSum
        (fun n => if n = 0 then (1 : Real) else 0) (fun _ => 1) 1 = 1 := by
    unfold FiniteCausalOrder.layeredPastSum
    rw [Fin.sum_univ_two, twoEvent_openIntervalCount]
    norm_num [twoEventOrder]
  unfold intervalLayerAbundance
  rw [Fin.sum_univ_two, hLayer]
  norm_num [twoEventBulkWeight]

/-- One layer coefficient is enough for the nonzero derivative control. -/
def zeroLayerWeight : Fin 1 -> Real :=
  fun _ => 0

/-- Unit affine variation of the sole retained layer coefficient. -/
def unitLayerDirection : Fin 1 -> Real :=
  fun _ => 1

/-- The graph-native weighted action has a genuine nonzero derivative: on the
two-event order, increasing the layer-zero coefficient has derivative one. -/
theorem twoEvent_intervalAction_nonzeroDerivative :
    HasDerivAt
      (fun t : Real => truncatedIntervalAction twoEventOrder
        twoEventBulkWeight 1 (zeroLayerWeight + t • unitLayerDirection) 0 0)
      1 0 := by
  have hDerivative := truncatedIntervalAction_directionalDerivative
    twoEventOrder twoEventBulkWeight 1 zeroLayerWeight unitLayerDirection 0 0
  simpa [intervalWeightResponse, unitLayerDirection,
    twoEvent_layerZero_abundance, Fin.sum_univ_one] using hDerivative

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.WeightedIntervalActionVariation.truncatedIntervalAction_directionalDerivative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeightedIntervalActionVariation.truncatedIntervalAction_directionalDerivative

/-- info: 'PhysicsSM.Draft.NullEdge.WeightedIntervalActionVariation.truncatedIntervalAction_equivariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeightedIntervalActionVariation.truncatedIntervalAction_equivariant

/-- info: 'PhysicsSM.Draft.NullEdge.WeightedIntervalActionVariation.twoEvent_intervalAction_nonzeroDerivative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.WeightedIntervalActionVariation.twoEvent_intervalAction_nonzeroDerivative

end PhysicsSM.Draft.NullEdge.WeightedIntervalActionVariation
