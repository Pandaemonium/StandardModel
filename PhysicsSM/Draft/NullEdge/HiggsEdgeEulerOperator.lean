import Mathlib

/-!
# Finite radial Higgs edge Euler operator

This module derives a finite real radial-scalar quadratic operator
from two distinct ingredients:

```text
kinetic term = edge-weighted squared differences,
mass term    = vertex-measure-weighted radial potential curvature.
```

It asks for the exact action/operator pairing, affine first variation, strict
positivity and trivial kernel when the supplied mass squared and vertex
measures are positive, and a two-vertex witness.

The quadratic action is a Euclidean stiffness/control functional. It is not a
Lorentzian action, retarded propagator, continuum equation, or observed Higgs
mass prediction.

Provenance: project-internal finite graph-Laplacian and scalar-potential
algebra. All twelve proof bodies were completed by Aristotle task
`c498c167-fc21-4341-8c17-a654a75131f5` and replayed under the pinned project
toolchain without changing a public statement. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsEdgeEulerOperator

open scoped BigOperators

variable {V E : Type*}
  [Fintype V] [DecidableEq V] [Nonempty V] [Fintype E]

/-- Signed incidence coefficient, with `+1` at the target and `-1` at the
source. A self-loop has zero incidence. -/
def incidence (source target : E -> V) (edge : E) (vertex : V) : Real :=
  (if vertex = target edge then 1 else 0) -
    (if vertex = source edge then 1 else 0)

/-- Oriented scalar edge difference. -/
def edgeDifference
    (source target : E -> V) (field : V -> Real) (edge : E) : Real :=
  field (target edge) - field (source edge)

/-- Weighted graph Laplacian in the incidence convention. -/
def weightedEdgeLaplacian
    (source target : E -> V) (edgeWeight : E -> Real) : Matrix V V Real :=
  fun i j => ∑ edge,
    edgeWeight edge * incidence source target edge i *
      incidence source target edge j

/-- Local radial mass matrix. -/
def radialMassMatrix
    (massSq : Real) (vertexMeasure : V -> Real) : Matrix V V Real :=
  fun i j => if i = j then massSq * vertexMeasure i else 0

/-- Edge Laplacian plus local radial mass. -/
def massiveRadialOperator
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) : Matrix V V Real :=
  weightedEdgeLaplacian source target edgeWeight +
    radialMassMatrix massSq vertexMeasure

/-- Standard finite real pairing. -/
def finitePairing (left right : V -> Real) : Real :=
  ∑ vertex, left vertex * right vertex

/-- Matrix quadratic form. -/
def matrixQuadratic (operator : Matrix V V Real) (field : V -> Real) : Real :=
  finitePairing field (operator.mulVec field)

/-- Euclidean radial quadratic action. -/
def radialQuadraticAction
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real)
    (field : V -> Real) : Real :=
  (1 / 2) * ∑ edge,
      edgeWeight edge * edgeDifference source target field edge ^ 2 +
    (1 / 2) * massSq * ∑ vertex,
      vertexMeasure vertex * field vertex ^ 2

/-- Bilinear first response of the radial quadratic action. -/
def radialFirstVariation
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real)
    (field variation : V -> Real) : Real :=
  ∑ edge, edgeWeight edge *
      edgeDifference source target field edge *
      edgeDifference source target variation edge +
    massSq * ∑ vertex,
      vertexMeasure vertex * field vertex * variation vertex

/-- Incidence pairing recovers the oriented endpoint difference exactly. -/
theorem incidence_pairing_eq_edgeDifference
    (source target : E -> V) (field : V -> Real) (edge : E) :
    (∑ vertex, incidence source target edge vertex * field vertex) =
      edgeDifference source target field edge := by
  unfold incidence edgeDifference
  simp +decide [sub_mul]

/-- The weighted edge Laplacian is symmetric. -/
theorem weightedEdgeLaplacian_symmetric
    (source target : E -> V) (edgeWeight : E -> Real) :
    (weightedEdgeLaplacian source target edgeWeight).IsSymm := by
  ext i j
  simp +decide [weightedEdgeLaplacian, incidence]
  ring
  grind

/-- The complete edge-plus-mass operator is symmetric. -/
theorem massiveRadialOperator_symmetric
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) :
    (massiveRadialOperator source target edgeWeight massSq
      vertexMeasure).IsSymm := by
  convert Matrix.IsSymm.add
    (weightedEdgeLaplacian_symmetric source target edgeWeight) ?_
  exact Matrix.ext fun i j => by
    unfold radialMassMatrix
    aesop

/-- The quadratic action is exactly one half of the matrix quadratic form. -/
theorem radialQuadraticAction_eq_half_matrixQuadratic
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) (field : V -> Real) :
    radialQuadraticAction source target edgeWeight massSq vertexMeasure field =
      (1 / 2) * matrixQuadratic
        (massiveRadialOperator source target edgeWeight massSq vertexMeasure)
        field := by
  unfold massiveRadialOperator matrixQuadratic
  unfold radialQuadraticAction finitePairing weightedEdgeLaplacian radialMassMatrix
  have h_interchange :
      ∑ edge, edgeWeight edge *
          (∑ vertex, incidence source target edge vertex * field vertex) *
          (∑ vertex', incidence source target edge vertex' * field vertex') =
        ∑ vertex, ∑ vertex',
          (∑ edge, edgeWeight edge * incidence source target edge vertex *
            incidence source target edge vertex') * field vertex * field vertex' := by
    simp +decide only [mul_comm, Finset.mul_sum _ _ _, mul_left_comm]
    exact Finset.sum_comm.trans
      (Finset.sum_congr rfl fun _ _ => Finset.sum_comm.trans
        (Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring))
  convert congr_arg
    (fun x : ℝ => 1 / 2 * x + 1 / 2 * massSq *
      ∑ vertex, vertexMeasure vertex * field vertex ^ 2) h_interchange using 1
  · simp +decide only [pow_two, mul_assoc, incidence_pairing_eq_edgeDifference]
  · simp +decide [Matrix.mulVec, dotProduct, Finset.sum_add_distrib, mul_add,
      add_mul, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _,
      Finset.sum_mul, sq]

/-- The matrix pairing with a variation is the action's displayed first
response. -/
theorem finitePairing_mulVec_eq_radialFirstVariation
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real)
    (field variation : V -> Real) :
    finitePairing variation
        ((massiveRadialOperator source target edgeWeight massSq vertexMeasure).mulVec
          field) =
      radialFirstVariation source target edgeWeight massSq vertexMeasure
        field variation := by
  unfold finitePairing massiveRadialOperator radialFirstVariation
  simp +decide [Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _, mul_assoc,
    mul_comm, mul_left_comm, edgeDifference]
  simp +decide [weightedEdgeLaplacian, radialMassMatrix,
    Finset.sum_add_distrib, mul_add, add_mul, mul_assoc, mul_comm,
    mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul]
  simp +decide [← mul_assoc, ← Finset.mul_sum _ _ _, ← Finset.sum_mul, incidence]
  simp +decide [Finset.sum_comm, Finset.sum_sub_distrib, mul_sub, sub_mul,
    mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul]

/-- Exact quadratic expansion along an affine field variation. -/
theorem radialQuadraticAction_affine_expansion
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real)
    (field variation : V -> Real) (epsilon : Real) :
    radialQuadraticAction source target edgeWeight massSq vertexMeasure
        (field + epsilon • variation) =
      radialQuadraticAction source target edgeWeight massSq vertexMeasure field +
        epsilon * radialFirstVariation source target edgeWeight massSq
          vertexMeasure field variation +
        epsilon ^ 2 * radialQuadraticAction source target edgeWeight massSq
          vertexMeasure variation := by
  unfold radialQuadraticAction
  unfold radialFirstVariation edgeDifference
  simp +decide [mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _,
    Finset.sum_add_distrib]
  ring
  simp +decide [Finset.mul_sum _ _ _, Finset.sum_add_distrib, mul_add,
    mul_sub, mul_assoc, mul_comm, mul_left_comm, pow_two]
  ring

/-- The displayed first variation is the actual derivative at the affine
path's base point. -/
theorem hasDerivAt_radialQuadraticAction_affine
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real)
    (field variation : V -> Real) :
    HasDerivAt
      (fun epsilon : Real => radialQuadraticAction source target edgeWeight massSq
        vertexMeasure (field + epsilon • variation))
      (radialFirstVariation source target edgeWeight massSq vertexMeasure
        field variation) 0 := by
  convert HasDerivAt.congr_of_eventuallyEq _ ?_ using 1
  exact fun epsilon =>
    radialQuadraticAction source target edgeWeight massSq vertexMeasure field +
      epsilon * radialFirstVariation source target edgeWeight massSq vertexMeasure
        field variation +
      epsilon ^ 2 * radialQuadraticAction source target edgeWeight massSq
        vertexMeasure variation
  · convert HasDerivAt.add
      (HasDerivAt.add (hasDerivAt_const _ _)
        (HasDerivAt.mul (hasDerivAt_id (0 : ℝ)) (hasDerivAt_const _ _)))
      (HasDerivAt.mul (hasDerivAt_pow 2 (0 : ℝ)) (hasDerivAt_const _ _)) using 1
    norm_num
  · filter_upwards [] using fun epsilon =>
      radialQuadraticAction_affine_expansion source target edgeWeight massSq
        vertexMeasure field variation epsilon

/-- Nonnegative edge weights, positive mass squared, and positive vertex
measures make the quadratic action strictly positive away from zero. -/
theorem radialQuadraticAction_pos
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) (field : V -> Real)
    (hEdge : ∀ edge, 0 <= edgeWeight edge)
    (hMass : 0 < massSq) (hMeasure : ∀ vertex, 0 < vertexMeasure vertex)
    (hField : field ≠ 0) :
    0 < radialQuadraticAction source target edgeWeight massSq vertexMeasure
      field := by
  refine add_pos_of_nonneg_of_pos
    (mul_nonneg (by norm_num)
      (Finset.sum_nonneg fun e _ => mul_nonneg (hEdge _) (sq_nonneg _)))
    (mul_pos (mul_pos (by norm_num) hMass) ?_)
  exact lt_of_lt_of_le
    (mul_pos (hMeasure (Classical.choose (Function.ne_iff.mp hField)))
      (sq_pos_of_ne_zero (Classical.choose_spec (Function.ne_iff.mp hField))))
    (Finset.single_le_sum
      (fun v _ => mul_nonneg (le_of_lt (hMeasure v)) (sq_nonneg (field v)))
      (Finset.mem_univ _))

/-- Under the same positivity hypotheses, the massive radial operator has
trivial kernel. -/
theorem massiveRadialOperator_mulVec_eq_zero_iff
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) (field : V -> Real)
    (hEdge : ∀ edge, 0 <= edgeWeight edge)
    (hMass : 0 < massSq) (hMeasure : ∀ vertex, 0 < vertexMeasure vertex) :
    (massiveRadialOperator source target edgeWeight massSq vertexMeasure).mulVec
        field = 0 <-> field = 0 := by
  refine ⟨fun h => ?_, fun h => ?_⟩
  · have h_quad_form :
        ∑ vertex, field vertex *
            ((massiveRadialOperator source target edgeWeight massSq vertexMeasure).mulVec
              field) vertex =
          2 * radialQuadraticAction source target edgeWeight massSq vertexMeasure
            field := by
      rw [radialQuadraticAction_eq_half_matrixQuadratic]
      unfold matrixQuadratic finitePairing
      ring
    contrapose! h_quad_form
    exact ne_of_lt (lt_of_le_of_lt
      (Finset.sum_nonpos fun _ _ => by rw [h]; simp +decide)
      (mul_pos zero_lt_two
        (radialQuadraticAction_pos source target edgeWeight massSq vertexMeasure
          field hEdge hMass hMeasure h_quad_form)))
  · aesop

/-- The massive radial matrix action is injective. -/
theorem massiveRadialOperator_mulVec_injective
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real)
    (hEdge : ∀ edge, 0 <= edgeWeight edge)
    (hMass : 0 < massSq) (hMeasure : ∀ vertex, 0 < vertexMeasure vertex) :
    Function.Injective
      (massiveRadialOperator source target edgeWeight massSq
        vertexMeasure).mulVec := by
  intro a b hab
  have h_injective : ∀ (f : V → ℝ),
      (massiveRadialOperator source target edgeWeight massSq vertexMeasure).mulVec f = 0 →
        f = 0 := by
    exact fun f hf =>
      (massiveRadialOperator_mulVec_eq_zero_iff source target edgeWeight massSq
        vertexMeasure f hEdge hMass hMeasure).1 hf
  exact sub_eq_zero.mp (h_injective (a - b) (by
    simpa [sub_eq_add_neg, Matrix.mulVec_add, Matrix.mulVec_neg] using
      sub_eq_zero.mpr hab))

/-- One-component potential-curvature convention used by the null-edge Higgs
control model. -/
def radialMassSquared (lam vacuum : Real) : Real :=
  8 * lam * vacuum ^ 2

/-- Positive supplied quartic coupling and nonzero vacuum lift every radial
zero mode when the vertex measures are positive. -/
theorem higgsPotential_radialOperator_mulVec_injective
    (source target : E -> V) (edgeWeight : E -> Real)
    (lam vacuum : Real) (vertexMeasure : V -> Real)
    (hEdge : ∀ edge, 0 <= edgeWeight edge)
    (hLam : 0 < lam) (hVacuum : vacuum ≠ 0)
    (hMeasure : ∀ vertex, 0 < vertexMeasure vertex) :
    Function.Injective
      (massiveRadialOperator source target edgeWeight
        (radialMassSquared lam vacuum) vertexMeasure).mulVec := by
  exact massiveRadialOperator_mulVec_injective source target edgeWeight
    (radialMassSquared lam vacuum) vertexMeasure hEdge
    (by exact mul_pos (mul_pos (by norm_num) hLam) (sq_pos_of_ne_zero hVacuum))
    hMeasure

/-- Source map for the explicit one-edge, two-vertex control. -/
def twoVertexSource : Fin 1 -> Fin 2 := fun _ => 0

/-- Target map for the explicit one-edge, two-vertex control. -/
def twoVertexTarget : Fin 1 -> Fin 2 := fun _ => 1

/-- Unit edge weight. -/
def twoVertexEdgeWeight : Fin 1 -> Real := fun _ => 1

/-- Unit vertex measure. -/
def twoVertexMeasure : Fin 2 -> Real := fun _ => 1

/-- The unit-mass two-vertex operator is the positive matrix
`[[2,-1],[-1,2]]`. -/
theorem twoVertex_massiveRadialOperator_witness :
    massiveRadialOperator twoVertexSource twoVertexTarget
        twoVertexEdgeWeight 1 twoVertexMeasure =
      !![2, -1; -1, 2] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [massiveRadialOperator, weightedEdgeLaplacian, radialMassMatrix]
  · unfold twoVertexEdgeWeight incidence twoVertexSource twoVertexTarget
      twoVertexMeasure
    norm_num
  · unfold incidence twoVertexEdgeWeight twoVertexSource twoVertexTarget
    norm_num
  · unfold incidence twoVertexEdgeWeight twoVertexSource twoVertexTarget
    norm_num
  · unfold twoVertexEdgeWeight twoVertexMeasure incidence twoVertexSource
      twoVertexTarget
    norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsEdgeEulerOperator.radialQuadraticAction_eq_half_matrixQuadratic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms radialQuadraticAction_eq_half_matrixQuadratic

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsEdgeEulerOperator.massiveRadialOperator_mulVec_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveRadialOperator_mulVec_injective

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsEdgeEulerOperator.twoVertex_massiveRadialOperator_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms twoVertex_massiveRadialOperator_witness

end PhysicsSM.Draft.NullEdge.HiggsEdgeEulerOperator

end
