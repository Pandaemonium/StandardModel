import Mathlib.Tactic

/-!
# Single-bivector simplicity: the Klein quadric Pfaffian

A 2-form (bivector) in four dimensions is simple/decomposable, `omega = a wedge b`,
exactly on the Klein quadric where its Pfaffian vanishes. This is the Stage-0
Lane E target: the genuine bivector arena is `Lambda^2` of a 4-space, and
single-bivector simplicity is `Pf(omega) = 0`.

Source guardrail (Neo4j null-edge collection): Freidel-Krasnov, "A New Spin Foam
Model for 4d Gravity" (`0708.1595`, Zotero `K8QAB5UD`) - this single-bivector
simplicity must be kept separate from full spin-foam cross-simplicity
constraints. We formalize only the single-bivector statement here.

Standalone (Mathlib only).
-/

noncomputable section

namespace NullEdgeBivectorSimplicity

/-- Wedge of two four-vectors as an antisymmetric matrix. -/
def wedge (a b : Fin 4 -> Real) : Fin 4 -> Fin 4 -> Real :=
  fun i j => a i * b j - a j * b i

/-- Pfaffian of a 4x4 antisymmetric bivector. -/
def Pfaffian (w : Fin 4 -> Fin 4 -> Real) : Real :=
  w 0 1 * w 2 3 - w 0 2 * w 1 3 + w 0 3 * w 1 2

/-- A bivector is simple/decomposable if it is a single wedge. -/
def Simple (w : Fin 4 -> Fin 4 -> Real) : Prop := ∃ a b : Fin 4 -> Real, w = wedge a b

/-- Decomposable bivectors satisfy the Plucker/Klein-quadric relation. -/
theorem wedge_pfaffian_zero (a b : Fin 4 -> Real) : Pfaffian (wedge a b) = 0 := by
  sorry

/-- Single-bivector simplicity is exactly vanishing of the Pfaffian (Klein
quadric). The forward direction is the Plucker relation; the converse builds a
decomposition from a null Pfaffian. -/
theorem simple_iff_pfaffian_zero (w : Fin 4 -> Fin 4 -> Real)
    (hanti : ∀ i j, w i j = - w j i) :
    Simple w ↔ Pfaffian w = 0 := by
  sorry

end NullEdgeBivectorSimplicity
