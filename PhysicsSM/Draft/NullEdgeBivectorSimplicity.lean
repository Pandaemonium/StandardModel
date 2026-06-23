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

namespace PhysicsSM.Draft.NullEdgeBivectorSimplicity

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
  simp only [Pfaffian, wedge]; ring

/-- The quadratic Plucker identity: for an antisymmetric bivector with vanishing
Pfaffian, the 2x2 minors of any two columns are proportional to the bivector
itself. This is the algebraic heart of the Klein-quadric decomposition. -/
theorem plucker_identity (w : Fin 4 → Fin 4 → Real) (hanti : ∀ i j, w i j = -w j i)
    (hpf : Pfaffian w = 0) (i j k l : Fin 4) :
    w i k * w j l - w j k * w i l = w k l * w i j := by
  simp only [Pfaffian] at hpf
  have z0 : w 0 0 = 0 := by linarith [hanti 0 0]
  have z1 : w 1 1 = 0 := by linarith [hanti 1 1]
  have z2 : w 2 2 = 0 := by linarith [hanti 2 2]
  have z3 : w 3 3 = 0 := by linarith [hanti 3 3]
  have a10 : w 1 0 = -w 0 1 := hanti 1 0
  have a20 : w 2 0 = -w 0 2 := hanti 2 0
  have a30 : w 3 0 = -w 0 3 := hanti 3 0
  have a21 : w 2 1 = -w 1 2 := hanti 2 1
  have a31 : w 3 1 = -w 1 3 := hanti 3 1
  have a32 : w 3 2 = -w 2 3 := hanti 3 2
  fin_cases i <;> fin_cases j <;> fin_cases k <;> fin_cases l <;>
    simp only [Fin.isValue, Fin.reduceFinMk, z0, z1, z2, z3, a10, a20, a30, a21, a31, a32] <;>
    first
    | linear_combination hpf
    | linear_combination -hpf
    | ring

/-- If some entry of an antisymmetric, Pfaffian-null bivector is nonzero, it is a
single wedge: take two columns through that entry and rescale. -/
theorem simple_of_entry_ne (w : Fin 4 → Fin 4 → Real) (hanti : ∀ i j, w i j = -w j i)
    (hpf : Pfaffian w = 0) (k l : Fin 4) (hkl : w k l ≠ 0) : Simple w := by
  refine ⟨fun j => w j k / w k l, fun j => w j l, ?_⟩
  funext i j
  simp only [wedge]
  rw [eq_comm, div_mul_eq_mul_div, div_mul_eq_mul_div, div_sub_div_same, div_eq_iff hkl]
  linear_combination plucker_identity w hanti hpf i j k l

/-- Single-bivector simplicity is exactly vanishing of the Pfaffian (Klein
quadric). The forward direction is the Plucker relation; the converse builds a
decomposition from a null Pfaffian.

Note: no nonzero/rank hypothesis is needed. When the bivector is identically
zero it is the wedge of the zero vector with itself; otherwise some entry is
nonzero and `simple_of_entry_ne` produces an explicit decomposition. -/
theorem simple_iff_pfaffian_zero (w : Fin 4 -> Fin 4 -> Real)
    (hanti : ∀ i j, w i j = - w j i) :
    Simple w ↔ Pfaffian w = 0 := by
  constructor
  · rintro ⟨a, b, rfl⟩
    exact wedge_pfaffian_zero a b
  · intro hpf
    by_cases h : ∀ i j, w i j = 0
    · refine ⟨0, 0, ?_⟩
      funext i j
      simp only [wedge, Pi.zero_apply, mul_zero, sub_zero]
      exact h i j
    · push_neg at h
      obtain ⟨k, l, hkl⟩ := h
      exact simple_of_entry_ne w hanti hpf k l hkl

end PhysicsSM.Draft.NullEdgeBivectorSimplicity
