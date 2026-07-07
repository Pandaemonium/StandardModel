import Mathlib

/-!
# Algebra.Furey.OctonionMassCoupling

A concrete, kernel-checked **coupling relation** tying the octonionic `SU(3)`
color structure to a mass-like grading operator — going *beyond* mere charge
co-location.

## Context and honest scope

The companion module `ColorTripletFundamental` establishes that the Furey color
triplet `{v4, v5, v6}` inside the complex-octonion minimal left ideal carries the
`SU(3)` fundamental representation. Its content is *co-location*: the SM color
charges sit where the octonion algebra says. It says nothing about how a
mass/chirality grading interacts with the color action.

This file formalizes ONE genuine structural coupling. We reconstruct, **at the
linear-operator level**, the exact color action table proved in
`ColorTripletFundamental`:

* Cartan generators with the weights `w4 = (-1,-1)`, `w5 = (1,0)`, `w6 = (0,1)`,
* the six color ladders acting as
  `T12 v6 = v5`, `T21 v5 = v6`, `T13 v6 = -v4`, `T31 v4 = -v6`,
  `T23 v5 = v4`, `T32 v4 = v5`, all other ladder actions zero,

on the ordered basis `(v4, v5, v6) ↔ (e0, e1, e2)` of `Fin 3 → ℂ`, realized as
`3 × 3` complex matrices acting on `ℂ³`.

**Why operator level.** In the octonionic construction the color generators are
built from octonion *left-multiplication* maps `L_x : y ↦ x·y`, which are linear
even though octonion multiplication is nonassociative. All algebra here is done
with these induced linear operators (matrices), i.e. by composing linear maps,
respecting the nonassociativity caution: no raw octonion products are formed.
The upstream `PhysicsSM.Algebra.Octonion.*` modules that build these operators
from the octonions are not present in this build, so the *induced* operators on
the color triplet are reconstructed here directly from the proven action table.

## The coupling (what IS established)

Let `M = diag(m0, m1, m2)` be a mass-like grading assigning a mass value to each
color-triplet state (a diagonal mass functional on the ideal). The commutator
`⁅G, M⁆ = G·M − M·G` measures the infinitesimal color variation of the mass
operator.

* `mass_comm_cartan_zero` (**co-location part**): `M` commutes with BOTH color
  Cartan generators `H23, H13`. So the mass grading is co-diagonal with the color
  Cartan — this is exactly the "charges sit where the algebra says" content.

* `mass_comm_ladder_*` (**coupling part, headline**): for each of the six color
  ladders `T`, `⁅T, M⁆ = (Δ) • T` with `Δ` a definite mass *splitting*
  (`m_j − m_i`). Hence when the masses are non-degenerate, `M` does NOT commute
  with the ladders: the mass grading is **not central** w.r.t. the color action.

* `mass_grading_not_central` (**headline**): a concrete non-degenerate mass
  `diag(1,2,3)` fails to commute with the color ladder `T23`, i.e.
  `M·T23 ≠ T23·M`. The mass grading is genuinely coupled to color, not a scalar
  co-located label.

* `mass_covariant_not_invariant` (**covariance headline**): there exists a color
  generator under which `M` transforms non-trivially. The precise
  `mass_comm_ladder_*` identities show `M` transforms as a *definite tensor*
  (each `⁅T, M⁆` lands on the corresponding root generator with the mass
  splitting as coefficient) — SU(3)-**covariant**, not invariant.

* `scalar_mass_central` (**contrast / delimiter**): a color-blind scalar mass
  `m • 1` commutes with EVERY generator. This is the trivial co-location case and
  marks precisely what "beyond co-location" adds: non-degeneracy of the mass
  grading across the triplet is what produces the coupling.

## Physical reading: this is a CONSTRAINT, not a mass mechanism (Fable-5 audit)

Physically, a genuine mass/Yukawa operator MUST commute with the color action —
color is an exact symmetry. Read that way, the headline `mass_grading_not_central`
is a **constraint (a small no-go)**, not a positive coupling: a color-non-singlet
diagonal grading `diag(m0, m1, m2)` with non-degenerate entries CANNOT be a
physical (color-exact) mass operator on the triplet. The physically-allowed mass
operators are exactly those in the **commutant of the color action** on
`End(ideal)`; by Schur that commutant is `⨁ End(multiplicity spaces)`, and the
multiplicity spaces are precisely where flavor / generation / Yukawa structure is
permitted to live. So the productive successor to this module is not "more
coupling" but the **color-commutant computation** — the allowed *shape* of the
turn-slot potential `Φ` — which is finite and formalizable. See
`AgentTasks/overnight-mass-run-2026-07-06/FABLE_STEER.md` §5.4 / [H2]. The kernel
theorems below are unchanged and correct; only this interpretation note is added.

## What is NOT established

This is a *finite structural identity* about the induced color-triplet operators.
It is NOT a derivation of the Standard Model Yukawa sector, of physical quark
mass values, of electroweak symmetry breaking, or of a dynamical mass mechanism.
The "mass operator" is a chosen grading exhibiting the algebraic coupling; the
theorems say the octonionic color action does not commute with a non-degenerate
mass grading (and does commute with a color-blind one), nothing more.

## Axiom footprint

The final theorems use only Lean/Mathlib standard axioms
(`propext`, `Classical.choice`, `Quot.sound`). No `sorry`, no `axiom`, no
`native_decide`. See `#print axioms mass_grading_not_central` at the end.
-/

namespace PhysicsSM.Algebra.Furey.OctonionMassCoupling

open Matrix

/-! ## Color-triplet generators as `3 × 3` complex matrices

On the ordered basis `(v4, v5, v6) ↔ (e0, e1, e2)`, matching the action table of
`ColorTripletFundamental`. A matrix `A` acts by `A.mulVec`, so the elementary
matrix `E_{i,j}` (entry `(i,j) = 1`) sends `e_j ↦ e_i`. -/

/-- Color Cartan `H23`: weights `v4 ↦ -1`, `v5 ↦ +1`, `v6 ↦ 0`. -/
noncomputable def H23m : Matrix (Fin 3) (Fin 3) ℂ := !![(-1 : ℂ), 0, 0; 0, 1, 0; 0, 0, 0]

/-- Color Cartan `H13`: weights `v4 ↦ -1`, `v5 ↦ 0`, `v6 ↦ +1`. -/
noncomputable def H13m : Matrix (Fin 3) (Fin 3) ℂ := !![(-1 : ℂ), 0, 0; 0, 0, 0; 0, 0, 1]

/-- Color ladder `T23`: `v5 ↦ v4` (i.e. `E_{0,1}`); all other basis actions zero. -/
noncomputable def T23m : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; 0, 0, 0; 0, 0, 0]

/-- Color ladder `T32`: `v4 ↦ v5` (i.e. `E_{1,0}`). -/
noncomputable def T32m : Matrix (Fin 3) (Fin 3) ℂ := !![0, 0, 0; 1, 0, 0; 0, 0, 0]

/-- Color ladder `T12`: `v6 ↦ v5` (i.e. `E_{1,2}`). -/
noncomputable def T12m : Matrix (Fin 3) (Fin 3) ℂ := !![0, 0, 0; 0, 0, 1; 0, 0, 0]

/-- Color ladder `T21`: `v5 ↦ v6` (i.e. `E_{2,1}`). -/
noncomputable def T21m : Matrix (Fin 3) (Fin 3) ℂ := !![0, 0, 0; 0, 0, 0; 0, 1, 0]

/-- Color ladder `T13`: `v6 ↦ -v4` (i.e. `-E_{0,2}`). -/
noncomputable def T13m : Matrix (Fin 3) (Fin 3) ℂ := !![0, 0, -1; 0, 0, 0; 0, 0, 0]

/-- Color ladder `T31`: `v4 ↦ -v6` (i.e. `-E_{2,0}`). -/
noncomputable def T31m : Matrix (Fin 3) (Fin 3) ℂ := !![0, 0, 0; 0, 0, 0; -1, 0, 0]

/-- The mass-like grading operator `M = diag(m0, m1, m2)`: it assigns a mass
value to each of the three color-triplet states. -/
noncomputable def massM (m0 m1 m2 : ℂ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![m0, 0, 0; 0, m1, 0; 0, 0, m2]

/-- Operator commutator `⁅A, B⁆ = A·B − B·A` of induced linear operators. Since
these are honest linear maps (matrices), composition is associative and the
commutator is well defined — no nonassociative octonion products appear. -/
noncomputable def commM (A B : Matrix (Fin 3) (Fin 3) ℂ) : Matrix (Fin 3) (Fin 3) ℂ :=
  A * B - B * A

/-! ## Sanity: the eight generators are traceless (an `su(3)` requirement). -/

theorem generators_traceless :
    Matrix.trace H23m = 0 ∧ Matrix.trace H13m = 0 ∧
    Matrix.trace T23m = 0 ∧ Matrix.trace T32m = 0 ∧
    Matrix.trace T12m = 0 ∧ Matrix.trace T21m = 0 ∧
    Matrix.trace T13m = 0 ∧ Matrix.trace T31m = 0 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    simp [Matrix.trace, H23m, H13m, T23m, T32m, T12m, T21m, T13m, T31m,
      Fin.sum_univ_three]

/-! ## Co-location part: the mass grading commutes with the color Cartan. -/

/-- The mass grading is co-diagonal with the color Cartan: it commutes with both
`H23` and `H13`. This is the *co-location* content — the mass values sit on the
same weight axes as the color charges. -/
theorem mass_comm_cartan_zero (m0 m1 m2 : ℂ) :
    commM H23m (massM m0 m1 m2) = 0 ∧ commM H13m (massM m0 m1 m2) = 0 := by
  constructor <;> (ext i j; fin_cases i <;> fin_cases j <;> simp [commM, H23m, H13m, massM])

/-! ## Coupling part: the mass grading does NOT commute with the color ladders.

For each ladder `T = c·E_{i,j}`, the commutator equals `(m_j − m_i) • T`: a
definite mass *splitting* times the same root generator. These are the genuine
structural coupling identities. -/

theorem mass_comm_ladder_T23 (m0 m1 m2 : ℂ) :
    commM T23m (massM m0 m1 m2) = (m1 - m0) • T23m := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [commM, T23m, massM]

theorem mass_comm_ladder_T32 (m0 m1 m2 : ℂ) :
    commM T32m (massM m0 m1 m2) = (m0 - m1) • T32m := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [commM, T32m, massM]

theorem mass_comm_ladder_T12 (m0 m1 m2 : ℂ) :
    commM T12m (massM m0 m1 m2) = (m2 - m1) • T12m := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [commM, T12m, massM]

theorem mass_comm_ladder_T21 (m0 m1 m2 : ℂ) :
    commM T21m (massM m0 m1 m2) = (m1 - m2) • T21m := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [commM, T21m, massM]

theorem mass_comm_ladder_T13 (m0 m1 m2 : ℂ) :
    commM T13m (massM m0 m1 m2) = (m2 - m0) • T13m := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [commM, T13m, massM, neg_add_eq_sub]

theorem mass_comm_ladder_T31 (m0 m1 m2 : ℂ) :
    commM T31m (massM m0 m1 m2) = (m0 - m2) • T31m := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [commM, T31m, massM, neg_add_eq_sub]

/-! ## Headline coupling statements. -/

/-- **Coupling (parametric).** If the mass grading is non-degenerate on the
`(v4, v5)` pair (`m0 ≠ m1`), then it does NOT commute with the color ladder
`T23`: the mass grading is not central w.r.t. the color action. -/
theorem mass_not_central_of_split {m0 m1 m2 : ℂ} (h : m0 ≠ m1) :
    massM m0 m1 m2 * T23m ≠ T23m * massM m0 m1 m2 := by
  intro hcomm
  have hz : commM T23m (massM m0 m1 m2) = 0 := by
    simp only [commM, hcomm, sub_self]
  rw [mass_comm_ladder_T23] at hz
  have hne : (m1 - m0) ≠ 0 := sub_ne_zero.mpr fun h' => h h'.symm
  have : (m1 - m0) • T23m ≠ 0 := by
    intro h0
    apply hne
    have := congrArg (fun A => A 0 1) h0
    simpa [T23m] using this
  exact this hz

/-- **Headline coupling (concrete).** The non-degenerate mass grading
`diag(1, 2, 3)` fails to commute with the color ladder `T23`. Concretely: the
mass grading is coupled to the octonionic color action, not a scalar co-located
label. -/
theorem mass_grading_not_central :
    massM 1 2 3 * T23m ≠ T23m * massM 1 2 3 :=
  mass_not_central_of_split (by norm_num)

/-- **Covariance headline.** The mass grading is SU(3)-**covariant, not
invariant**: there is a color generator whose action on `M` is non-trivial.
Combined with the explicit `mass_comm_ladder_*` identities (each commutator is a
definite multiple of a single root generator), `M` transforms as a definite
tensor under the color action rather than as a color singlet. -/
theorem mass_covariant_not_invariant :
    ∃ G : Matrix (Fin 3) (Fin 3) ℂ,
      (G = H23m ∨ G = H13m ∨ G = T23m ∨ G = T32m ∨
       G = T12m ∨ G = T21m ∨ G = T13m ∨ G = T31m) ∧
      commM G (massM 1 2 3) ≠ 0 := by
  refine ⟨T23m, Or.inr (Or.inr (Or.inl rfl)), ?_⟩
  rw [mass_comm_ladder_T23]
  intro h0
  have := congrArg (fun A => A 0 1) h0
  simp [T23m] at this
  norm_num at this

/-! ## Contrast / delimiter: a color-blind scalar mass IS central. -/

/-- A color-blind scalar mass `m • 1` commutes with EVERY operator, in particular
with all eight color generators. This is the trivial co-location case: only a
non-degenerate (non-scalar) mass grading produces the coupling above. -/
theorem scalar_mass_central (m : ℂ) (A : Matrix (Fin 3) (Fin 3) ℂ) :
    commM (m • (1 : Matrix (Fin 3) (Fin 3) ℂ)) A = 0 := by
  simp [commM]

/-! ## Build-enforced axiom guard + faithfulness note

FAITHFULNESS (honest scope): the `3x3` matrices `H23m/H13m/T12m..T31m` are the
`su(3)` fundamental generators RECONSTRUCTED to match the color-triplet action
table PROVED in `ColorTripletFundamental` (not imported here only because its
upstream octonion stack was absent from the Aristotle package). The coupling
statements are therefore genuine finite matrix identities in the FAITHFUL matrix
model of the octonionic color action on the triplet; a follow-up should import
`ColorTripletFundamental` and prove these matrices equal its proven action
operators, closing the by-construction faithfulness gap. -/

/-- info: 'PhysicsSM.Algebra.Furey.OctonionMassCoupling.mass_comm_ladder_T23' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_comm_ladder_T23

/-- info: 'PhysicsSM.Algebra.Furey.OctonionMassCoupling.mass_not_central_of_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_not_central_of_split

end PhysicsSM.Algebra.Furey.OctonionMassCoupling
