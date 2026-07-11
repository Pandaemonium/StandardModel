/-
# Deliverable 2 (part 1) — The two-chart mirror atlas of reflection certificates

Companion Lean file for `PINNED_STABILITY_DESIGN.md`.  Builds on the landed
context (`context/HalfPeriodInvariant.lean`, `context/ModeInvariantHalfWinding.lean`),
left byte-identical; the landed `reflR`, `gradeX` (`Γ`), `Wof`, `Bfix`, `Mfix`,
`wallCount`, `loneAt`, `fixedSingleton`, `protectedField`, `selfadj_iff_protected`
are reused.

This file establishes the **axis-equivariant two-chart atlas** and the block
level of the taxonomy:

* the **mirror site-axis chart** `{0,2}` (`reflR0`, `Bfix0`, `Mfix0`) with its
  protection law `selfadj0_iff_mirrorProtected` (mirror of the landed
  `selfadj_iff_protected` for the `{1,3}` chart);
* the **atlas** `atlas_two_charts`: every two-wall field is engine-certified in
  at least one site-axis chart, with `charts_complementary` showing the two
  charts are exactly complementary on the singletons;
* the **block** level `block_involution`: block walks are themselves traceless
  self-adjoint unitary involutions;
* the **bond reflections** `reflBondA`, `reflBondB` for the blocks, with
  `[R_bond, Γ] = 0` and the block bond symmetries.

All facts are exact `ℚ` identities discharged by `native_decide`
(draft-trust: adds `Lean.ofReduceBool` / `Lean.trustCompiler`).
-/
/-
Provenance: Aristotle job 573430f4 (fable-pub-pinned-stability-20260711),
harvested 2026-07-11 ~10:20 PDT (24h-run P0); part of a six-module return
(SpecProjectors held back pending two abstract-lemma proofs). Statements
integrated UNCHANGED except this header and import rewires
(context/Pinned paths -> project paths). The job absorbed three exact
mid-task data injections (census, axis-equivariant charts, block
involutions) recorded in the 2026-07-11 overnight ledger. Draft-trust
disclosure: finite family decisions use native_decide (+2 footprint) as
stated per-file; abstract lemmas are kernel-only.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.HalfPeriodInvariant

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PinnedSymmetryResolved

open Matrix
open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding
open PhysicsSM.Draft.NullEdge.HalfPeriodInvariant

/-! ## 1.  The second (mirror) site-axis chart `{0,2}` -/

/-- Spatial reflection through the `{0,2}` axis (swap sites `1 ↔ 3`, fix `0,2`) —
the mirror of the landed `reflR` (axis `{1,3}`). -/
def reflR0 : Matrix V8 V8 ℚ := Matrix.of fun i j =>
  if i.1 = (![0, 3, 2, 1] : Fin 4 → Fin 4) j.1 ∧ i.2 = j.2 then (1 : ℚ) else 0

/-- Isometry onto the `{0,2}`-fixed sub-sector `span{e_(0,·), e_(2,·)}`. -/
def Bfix0 : Matrix V8 (Fin 4) ℚ := Matrix.of fun x j =>
  if x = (![(0,0),(0,1),(2,0),(2,1)] : Fin 4 → V8) j then 1 else 0

/-- The `{0,2}`-fixed-leg compression `M0(b) = Bfix0ᵀ · W(b) · Bfix0`. -/
def Mfix0 (b : Fin 4 → Bool) : Matrix (Fin 4) (Fin 4) ℚ := Bfix0ᵀ * Wof b * Bfix0

/-- `reflR0` is an involution commuting with `Γ` (field-independently). -/
theorem reflR0_sq : reflR0 * reflR0 = 1 := by native_decide
theorem reflR0_comm_grade : reflR0 * gradeX = gradeX * reflR0 := by native_decide

/-- The `{0,2}`-axis reflection-symmetry predicate: the fixed sites `0, 2` carry
equal signs. -/
def reflSym0 (b : Fin 4 → Bool) : Bool := b 0 == b 2

/-- `reflR0` commutes with the walk iff the field is `{0,2}`-reflection-symmetric. -/
theorem reflR0_comm_walk_iff :
    ∀ b, (reflR0 * Wof b = Wof b * reflR0) ↔ reflSym0 b = true := by native_decide

/-! ## 2.  Predicates for the taxonomy -/

/-- A `{0,2}`-singleton: a lone flip seated on a `{0,2}`-fixed site (`0` or `2`). -/
def zeroAxisSingleton (b : Fin 4 → Bool) : Bool := loneAt b 0 || loneAt b 2

/-- The mirror-protecting predicate: two walls and **not** a `{0,2}`-singleton. -/
def mirrorProtected (b : Fin 4 → Bool) : Bool := (wallCount b == 2) && (! zeroAxisSingleton b)

/-- A field is a single lone flip at some site. -/
def isSingleton (b : Fin 4 → Bool) : Bool :=
  loneAt b 0 || loneAt b 1 || loneAt b 2 || loneAt b 3

/-- A domain **block**: two walls, not a singleton (`++--` and its rotations). -/
def isBlock (b : Fin 4 → Bool) : Bool := (wallCount b == 2) && (! isSingleton b)

/-- A **protected singleton**: a protected field that is a lone flip (site `0`/`2`
singleton). -/
def protectedSingleton (b : Fin 4 → Bool) : Bool := protectedField b && isSingleton b

/-! ## 3.  The mirror protection law (chart `{0,2}`) -/

/-- **Mirror of `selfadj_iff_protected` (landed).**  The `{0,2}`-fixed-leg
compression is self-adjoint iff the field is *mirror*-protected (two walls, not a
`{0,2}`-singleton).  This certifies exactly the 4 **blind** singletons (lone flip
at `1` or `3`) together with the 4 blocks. -/
theorem selfadj0_iff_mirrorProtected :
    ∀ b, (Mfix0 b = (Mfix0 b)ᵀ) ↔ mirrorProtected b = true := by native_decide

/-- Structural facts for chart `{0,2}`: `Bfix0` is an isometry, the `{0,2}` sector
is `W`-invariant for every field, and the compression is traceless. -/
theorem Bfix0_isometry : Bfix0ᵀ * Bfix0 = 1 := by native_decide
theorem Bfix0_intertwine : ∀ b, Wof b * Bfix0 = Bfix0 * Mfix0 b := by native_decide
theorem Mfix0_trace_zero : ∀ b, (Mfix0 b).trace = 0 := by native_decide

/-! ## 4.  The atlas: every two-wall field is certified in ≥ 1 site-axis chart -/

/-- **Two-chart atlas (exact 16-field check).**  Every two-wall field is
engine-certified (self-adjoint fixed-leg compression) in the `{1,3}` chart, the
`{0,2}` chart, or both.  Protected singletons → `{1,3}`; blind singletons →
`{0,2}`; blocks → both. -/
theorem atlas_two_charts :
    ∀ b, wallCount b = 2 →
      (Mfix b = (Mfix b)ᵀ) ∨ (Mfix0 b = (Mfix0 b)ᵀ) := by native_decide

/-- The charts are exactly complementary on the singletons: chart `{1,3}` misses
precisely the `{0,2}`-singletons and vice versa (the mirror pair). -/
theorem charts_complementary :
    ∀ b, wallCount b = 2 →
      ((Mfix b = (Mfix b)ᵀ) ↔ ¬ (loneAt b 1 || loneAt b 3 = true)) ∧
      ((Mfix0 b = (Mfix0 b)ᵀ) ↔ ¬ (loneAt b 0 || loneAt b 2 = true)) := by native_decide

/-! ## 5.  Blocks: the walk is itself the involution (compression level `B = 1`) -/

/-- **Block involution (compression at `B = 1`).**  For every block field the
walk `Wof b` is itself a traceless self-adjoint unitary involution, so its full
`(4,4)` sector is pinned by the same engine with no compression needed. -/
theorem block_involution :
    ∀ b, isBlock b = true →
      (Wof b * Wof b = 1) ∧ (Wof b = (Wof b)ᵀ) ∧ ((Wof b).trace = 0) := by native_decide

/-! ## 6.  Bond reflections (for the blocks; `[R_bond, Γ]` check) -/

/-- Bond reflection through the `(0-1)`/`(2-3)` axis (swap `0↔1`, `2↔3`). -/
def reflBondA : Matrix V8 V8 ℚ := Matrix.of fun i j =>
  if i.1 = (![1, 0, 3, 2] : Fin 4 → Fin 4) j.1 ∧ i.2 = j.2 then (1 : ℚ) else 0

/-- Bond reflection through the `(0-3)`/`(1-2)` axis (swap `0↔3`, `1↔2`). -/
def reflBondB : Matrix V8 V8 ℚ := Matrix.of fun i j =>
  if i.1 = (![3, 2, 1, 0] : Fin 4 → Fin 4) j.1 ∧ i.2 = j.2 then (1 : ℚ) else 0

theorem reflBondA_sq : reflBondA * reflBondA = 1 := by native_decide
theorem reflBondB_sq : reflBondB * reflBondB = 1 := by native_decide

/-- Both bond reflections commute with `Γ`. -/
theorem reflBondA_comm_grade : reflBondA * gradeX = gradeX * reflBondA := by native_decide
theorem reflBondB_comm_grade : reflBondB * gradeX = gradeX * reflBondB := by native_decide

/-- **Bond-reflection symmetry of the blocks (exact).**  `+--+` and `-++-`
commute with `reflBondA`; `++--` and `--++` commute with `reflBondB`. -/
theorem block_bond_symmetry :
    (reflBondA * Wof ![true,false,false,true] = Wof ![true,false,false,true] * reflBondA) ∧
    (reflBondA * Wof ![false,true,true,false] = Wof ![false,true,true,false] * reflBondA) ∧
    (reflBondB * Wof ![true,true,false,false] = Wof ![true,true,false,false] * reflBondB) ∧
    (reflBondB * Wof ![false,false,true,true] = Wof ![false,false,true,true] * reflBondB) := by
  native_decide

end PhysicsSM.Draft.NullEdge.PinnedSymmetryResolved
