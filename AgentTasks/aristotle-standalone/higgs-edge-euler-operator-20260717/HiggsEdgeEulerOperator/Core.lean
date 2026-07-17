import Mathlib

/-!
# Finite radial Higgs edge Euler operator

This focused package derives a finite real radial-scalar quadratic operator
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
-/

noncomputable section

namespace HiggsEdgeEulerOperator

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
  sorry

/-- The weighted edge Laplacian is symmetric. -/
theorem weightedEdgeLaplacian_symmetric
    (source target : E -> V) (edgeWeight : E -> Real) :
    (weightedEdgeLaplacian source target edgeWeight).IsSymm := by
  sorry

/-- The complete edge-plus-mass operator is symmetric. -/
theorem massiveRadialOperator_symmetric
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) :
    (massiveRadialOperator source target edgeWeight massSq
      vertexMeasure).IsSymm := by
  sorry

/-- The quadratic action is exactly one half of the matrix quadratic form. -/
theorem radialQuadraticAction_eq_half_matrixQuadratic
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) (field : V -> Real) :
    radialQuadraticAction source target edgeWeight massSq vertexMeasure field =
      (1 / 2) * matrixQuadratic
        (massiveRadialOperator source target edgeWeight massSq vertexMeasure)
        field := by
  sorry

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
  sorry

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
  sorry

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
  sorry

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
  sorry

/-- Under the same positivity hypotheses, the massive radial operator has
trivial kernel. -/
theorem massiveRadialOperator_mulVec_eq_zero_iff
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real) (field : V -> Real)
    (hEdge : ∀ edge, 0 <= edgeWeight edge)
    (hMass : 0 < massSq) (hMeasure : ∀ vertex, 0 < vertexMeasure vertex) :
    (massiveRadialOperator source target edgeWeight massSq vertexMeasure).mulVec
        field = 0 <-> field = 0 := by
  sorry

/-- The massive radial matrix action is injective. -/
theorem massiveRadialOperator_mulVec_injective
    (source target : E -> V) (edgeWeight : E -> Real)
    (massSq : Real) (vertexMeasure : V -> Real)
    (hEdge : ∀ edge, 0 <= edgeWeight edge)
    (hMass : 0 < massSq) (hMeasure : ∀ vertex, 0 < vertexMeasure vertex) :
    Function.Injective
      (massiveRadialOperator source target edgeWeight massSq
        vertexMeasure).mulVec := by
  sorry

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
  sorry

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
  sorry

end HiggsEdgeEulerOperator

end
