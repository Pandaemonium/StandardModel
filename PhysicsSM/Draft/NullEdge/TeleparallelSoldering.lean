import Mathlib

/-!
# The soldering (E-slot) is a finite teleparallel connection

Teleparallel gravity re-expresses gravity through a **flat** connection carrying nonzero
**torsion** (rather than curvature).  This file gives a fully explicit, finite, kernel-checked
avatar of that geometry over a tiny oriented graph, using only small rational `2 × 2` matrices.

## The model

A triangle with vertices `0, 1, 2` and oriented edges `0 → 1`, `1 → 2`, `2 → 0`.  Each edge `e`
carries a **soldering** matrix `γ_e ∈ GL₂(ℚ)`, the null-frame comparison across `e`, and parallel
transport along `e` is multiplication by `γ_e`.

* **Curvature** of a loop is the product of the solderings around it.  *Flatness* (the
  teleparallel condition) means this product is the identity: transport is path-independent.
* **Torsion** `T(γ) = ½ (γ - γᵀ)` is the antisymmetric part — the failure of the soldering to
  close symmetrically.  This is the gravitational field strength.
* **Nonmetricity** `Q(γ) = ½ (γ + γᵀ)` is the symmetric, metric-changing part.

The E-slot decoration is the soldering `γ` itself, and it splits **exactly** as
`γ = T(γ) + Q(γ)`.  The *pure-torsion* (teleparallel) choice sets nonmetricity to zero.

## Honest scope

This is a finite one-complex avatar of teleparallel geometry: explicit rational matrices on a
small edge/vertex complex, not continuum gravity.
-/

namespace TeleparallelSoldering

open Matrix

/-- The finite structure group: rational `2 × 2` matrices (a small `GL`/soldering slot). -/
abbrev M := Matrix (Fin 2) (Fin 2) ℚ

/-! ### The soldering data on the triangle -/

/-- Soldering across the edge `0 → 1`. -/
def g01 : M := !![1, 1; 0, 1]

/-- Soldering across the edge `1 → 2`. -/
def g12 : M := !![1, 0; 1, 1]

/-- Soldering across the edge `2 → 0`, chosen so the loop closes (flatness). -/
def g20 : M := !![2, -1; -1, 1]

/-- Curvature of the basic loop `0 → 1 → 2 → 0`: the product of solderings around it. -/
def curvatureLoop : M := g20 * g12 * g01

/-! ### Torsion and nonmetricity: the E-slot split -/

/-- Torsion of a soldering: its antisymmetric part (the gravitational field strength). -/
def torsion (g : M) : M := (1 / 2 : ℚ) • (g - gᵀ)

/-- Nonmetricity of a soldering: its symmetric, metric-changing part. -/
def nonmetricity (g : M) : M := (1 / 2 : ℚ) • (g + gᵀ)

/-! ### Example solderings distinguishing gravity from no-gravity -/

/-- A generic (mixed) soldering: nonzero torsion **and** nonzero nonmetricity. -/
def gGrav : M := !![1, 1; 0, 1]

/-- A pure-torsion (teleparallel) soldering: antisymmetric, so nonmetricity vanishes. -/
def gPure : M := !![0, 1; -1, 0]

/-- A control soldering (no gravity): symmetric, so torsion vanishes. -/
def gFlat : M := !![2, 3; 3, 5]

/-! ## Target 1 — flat curvature (teleparallel) -/

/-- **Flatness.** The curvature of the basic loop is the identity: the connection is flat, so
transport is path-independent up to the teleparallel gauge. -/
theorem curvature_flat : curvatureLoop = 1 := by
  simp only [curvatureLoop, g01, g12, g20, Matrix.mul_fin_two, Matrix.one_fin_two]
  norm_num

/-- info: 'TeleparallelSoldering.curvature_flat' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms curvature_flat

/-! ## Target 2 — nonzero torsion (the payload: gravity is torsion) -/

/-- **Torsion is nonzero.** For the generic soldering the torsion is the explicit nonzero
rational antisymmetric matrix `!![0, ½; -½, 0]`; gravity is carried by torsion, not curvature. -/
theorem torsion_nonzero :
    torsion gGrav = !![0, 1 / 2; -1 / 2, 0] ∧ torsion gGrav ≠ 0 := by
  refine ⟨?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp only [torsion, gGrav, Matrix.smul_apply, Matrix.sub_apply, Matrix.transpose_apply,
        Matrix.cons_val', Matrix.of_apply, Matrix.cons_val_fin_one, Matrix.empty_val',
        smul_eq_mul] <;> norm_num
  · intro h
    have := congrFun (congrFun h 0) 1
    simp only [torsion, gGrav, Matrix.smul_apply, Matrix.sub_apply, Matrix.transpose_apply,
      Matrix.cons_val', Matrix.of_apply, Matrix.cons_val_fin_one, Matrix.empty_val',
      smul_eq_mul, Matrix.zero_apply] at this
    norm_num at this

/-- info: 'TeleparallelSoldering.torsion_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms torsion_nonzero

/-! ## Target 3 — the E-slot split `E_# = torsion (+) nonmetricity` -/

/-- **Exact split.** Every soldering (E-slot decoration) decomposes exactly as the sum of its
torsion (antisymmetric) part and its nonmetricity (symmetric) part. -/
theorem eslot_split (g : M) : g = torsion g + nonmetricity g := by
  rw [torsion, nonmetricity]; module

/-- info: 'TeleparallelSoldering.eslot_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms eslot_split

/-- **Pure-torsion (teleparallel) choice.** The antisymmetric soldering has vanishing
nonmetricity while its torsion is nonzero. -/
theorem eslot_pure_torsion : nonmetricity gPure = 0 ∧ torsion gPure ≠ 0 := by
  refine ⟨?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp only [nonmetricity, gPure, Matrix.smul_apply, Matrix.add_apply, Matrix.transpose_apply,
        Matrix.cons_val', Matrix.of_apply, Matrix.cons_val_fin_one, Matrix.empty_val',
        smul_eq_mul, Matrix.zero_apply] <;> norm_num
  · intro h
    have := congrFun (congrFun h 0) 1
    simp only [torsion, gPure, Matrix.smul_apply, Matrix.sub_apply, Matrix.transpose_apply,
      Matrix.cons_val', Matrix.of_apply, Matrix.cons_val_fin_one, Matrix.empty_val',
      smul_eq_mul, Matrix.zero_apply] at this
    norm_num at this

/-- info: 'TeleparallelSoldering.eslot_pure_torsion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms eslot_pure_torsion

/-- **Mixed soldering.** The generic soldering has both torsion and nonmetricity nonzero. -/
theorem eslot_mixed : torsion gGrav ≠ 0 ∧ nonmetricity gGrav ≠ 0 := by
  refine ⟨torsion_nonzero.2, ?_⟩
  intro h
  have := congrFun (congrFun h 0) 0
  simp only [nonmetricity, gGrav, Matrix.smul_apply, Matrix.add_apply, Matrix.transpose_apply,
    Matrix.cons_val', Matrix.of_apply, Matrix.cons_val_fin_one, Matrix.empty_val',
    smul_eq_mul, Matrix.zero_apply] at this
  norm_num at this

/-- info: 'TeleparallelSoldering.eslot_mixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms eslot_mixed

/-- **Control (no gravity).** The symmetric soldering has vanishing torsion: torsion genuinely
distinguishes the gravitational solderings from the trivial ones. -/
theorem torsion_control_zero : torsion gFlat = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp only [torsion, gFlat, Matrix.smul_apply, Matrix.sub_apply, Matrix.transpose_apply,
      Matrix.cons_val', Matrix.of_apply, Matrix.cons_val_fin_one, Matrix.empty_val',
      smul_eq_mul, Matrix.zero_apply] <;> norm_num

/-- info: 'TeleparallelSoldering.torsion_control_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms torsion_control_zero

/-! ## Target 4 — the teleparallel verdict -/

/-- **The verdict.** The soldering / E-slot channel *is* a finite teleparallel connection:

* the curvature of the basic loop is trivial (flat, teleparallel);
* the torsion of a generic soldering is nonzero (gravity is carried by torsion) — with an
  explicit rational value;
* the E-slot splits exactly into torsion `+` nonmetricity;
* the pure-torsion (teleparallel) choice sets nonmetricity to zero, while a mixed soldering has
  both nonzero;
* a symmetric control soldering has zero torsion, so torsion genuinely distinguishes gravity
  from no-gravity.

Honest scope: a finite one-complex avatar of teleparallel geometry, not continuum gravity. -/
theorem teleparallel_verdict :
    curvatureLoop = 1 ∧
    (torsion gGrav = !![0, 1 / 2; -1 / 2, 0] ∧ torsion gGrav ≠ 0) ∧
    (∀ g : M, g = torsion g + nonmetricity g) ∧
    (nonmetricity gPure = 0 ∧ torsion gPure ≠ 0) ∧
    (torsion gGrav ≠ 0 ∧ nonmetricity gGrav ≠ 0) ∧
    torsion gFlat = 0 :=
  ⟨curvature_flat, torsion_nonzero, eslot_split, eslot_pure_torsion, eslot_mixed,
    torsion_control_zero⟩

/-- info: 'TeleparallelSoldering.teleparallel_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms teleparallel_verdict

end TeleparallelSoldering
