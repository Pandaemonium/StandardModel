import Mathlib

/-!
# NullEdge.Carrier.ColorCommutantScalar — the [H2] color-commutant constraint

This module realizes **Fable-5's reframe of `OctonionMassCoupling`** (see
`PhysicsSM.Algebra.Furey.OctonionMassCoupling` and
`AgentTasks/overnight-mass-run-2026-07-06/FABLE_STEER.md` §5.4 / [H2]).

## The [H2] audit, made precise

`OctonionMassCoupling` proved that a **non-degenerate diagonal grading**
`diag(m0, m1, m2)` on the color triplet **fails to commute** with the octonionic
`su(3)` color action. Read as physics that result is a **CONSTRAINT** (a small
no-go), not a mass mechanism: color is an *exact* symmetry, so a genuine physical
mass/Yukawa operator must lie in the **commutant** of the color action. Hence a
non-degenerate color-non-singlet grading is simply **not a physical (color-exact)
mass** on the triplet.

This file proves the **positive companion** to that no-go. On a *single*
irreducible fundamental triplet `ℂ³` the color commutant is exactly the
**scalars**:

* `color_commutant_eq_scalars` (**headline**, Schur's lemma made concrete): a
  matrix `Mx` commutes with every color generator **iff** `Mx = c • 1` for some
  `c : ℂ`.
* `scalar_mass_is_color_exact` (easy direction, stated separately): every scalar
  `c • 1` commutes with every color generator — i.e. scalars are color-exact.
* `nonscalar_mass_not_color_exact` (**constraint corollary**, the honest reading
  of `mass_grading_not_central`): a diagonal mass `diagonal ![m0, m1, m2]`
  commutes with every color generator **iff** it is color-blind
  (`m0 = m1 ∧ m1 = m2`). In particular `diagonal ![1, 2, 3]` does **not** commute
  with the color action, so it is not a color-exact mass operator.

So the only color-exact mass on one triplet is a color-blind scalar. This is the
precise content of the [H2] constraint on the single-irreducible-triplet base
case.

## Generators

We work with `M := Matrix (Fin 3) (Fin 3) ℂ` acting on the color triplet `ℂ³`,
and use the **standard `su(3)` fundamental generators**, reconstructed to match
the action table of `PhysicsSM.Algebra.Furey.OctonionMassCoupling`: the two
Cartan generators `H23m`, `H13m` and the six ladders `T12m, T21m, T13m, T31m,
T23m, T32m`. Their span is the fundamental `su(3)` action on `ℂ³`; the six
ladders alone realize all six off-diagonal elementary matrices `E_{i,j}`
(`i ≠ j`), which is what forces the commutant down to the scalars (this is Schur's
lemma for the irreducible fundamental).

## Scope / honesty (draft-trust, finite linear algebra)

The place where genuine flavor / generation / Yukawa structure can live is the
commutant on the **FULL reducible internal space** (the multiplicity spaces, per
Schur `⨁ End(mult space)`). That is **OPEN / out of scope** here — **not**
computed in this file. This module is only the single-irreducible-triplet base
case: finite linear algebra, draft-trust.

## Axiom footprint

The final theorems use only Lean/Mathlib standard axioms
(`propext`, `Classical.choice`, `Quot.sound`). No `sorry`, no `axiom`, no
`native_decide`. See the `#print axioms` guards at the end.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier

open Matrix

/-! ## Color-triplet generators as `3 × 3` complex matrices

On the ordered basis `(v4, v5, v6) ↔ (e0, e1, e2)`, matching the action table of
`OctonionMassCoupling`. A matrix `A` acts by `A.mulVec`, so the elementary matrix
`E_{i,j}` (entry `(i,j) = 1`) sends `e_j ↦ e_i`. -/

/-- Color Cartan `H23`: weights `v4 ↦ -1`, `v5 ↦ +1`, `v6 ↦ 0`. -/
def H23m : Matrix (Fin 3) (Fin 3) ℂ := !![(-1 : ℂ), 0, 0; 0, 1, 0; 0, 0, 0]

/-- Color Cartan `H13`: weights `v4 ↦ -1`, `v5 ↦ 0`, `v6 ↦ +1`. -/
def H13m : Matrix (Fin 3) (Fin 3) ℂ := !![(-1 : ℂ), 0, 0; 0, 0, 0; 0, 0, 1]

/-- Color ladder `T23`: `v5 ↦ v4` (i.e. `E_{0,1}`). -/
def T23m : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; 0, 0, 0; 0, 0, 0]

/-- Color ladder `T32`: `v4 ↦ v5` (i.e. `E_{1,0}`). -/
def T32m : Matrix (Fin 3) (Fin 3) ℂ := !![0, 0, 0; 1, 0, 0; 0, 0, 0]

/-- Color ladder `T12`: `v6 ↦ v5` (i.e. `E_{1,2}`). -/
def T12m : Matrix (Fin 3) (Fin 3) ℂ := !![0, 0, 0; 0, 0, 1; 0, 0, 0]

/-- Color ladder `T21`: `v5 ↦ v6` (i.e. `E_{2,1}`). -/
def T21m : Matrix (Fin 3) (Fin 3) ℂ := !![0, 0, 0; 0, 0, 0; 0, 1, 0]

/-- Color ladder `T13`: `v6 ↦ -v4` (i.e. `-E_{0,2}`). -/
def T13m : Matrix (Fin 3) (Fin 3) ℂ := !![0, 0, -1; 0, 0, 0; 0, 0, 0]

/-- Color ladder `T31`: `v4 ↦ -v6` (i.e. `-E_{2,0}`). -/
def T31m : Matrix (Fin 3) (Fin 3) ℂ := !![0, 0, 0; 0, 0, 0; -1, 0, 0]

/-- The chosen generating set of the fundamental `su(3)` action on `ℂ³`: the two
Cartan generators together with the six color ladders. Their span is the
fundamental `su(3)` action; the six ladders realize all six off-diagonal
elementary matrices. -/
def colorGens : Set (Matrix (Fin 3) (Fin 3) ℂ) :=
  {H23m, H13m, T23m, T32m, T12m, T21m, T13m, T31m}

/-! ## Headline: the color commutant is exactly the scalars (Schur, concrete). -/

/-
**Schur's lemma, concrete for the irreducible fundamental.** A matrix `Mx`
commutes with every color generator **iff** it is a scalar multiple of the
identity. The commutation constraints from the six ladders force all off-diagonal
entries of `Mx` to vanish and all diagonal entries to be equal.
-/
theorem color_commutant_eq_scalars (Mx : Matrix (Fin 3) (Fin 3) ℂ) :
    (∀ g ∈ colorGens, Mx * g = g * Mx) ↔
      ∃ c : ℂ, Mx = c • (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
  constructor <;> intro h;
  · simp_all +decide [ colorGens, H23m, H13m, T23m, T32m, T12m, T21m, T13m, T31m ];
    simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply ];
    simp_all +decide [ Fin.sum_univ_three, Matrix.vecMul ];
    grind;
  · unfold colorGens; aesop;

/-! ## Easy direction, stated separately: scalars are color-exact. -/

/-- Every scalar `c • 1` commutes with every color generator: scalars are
color-exact mass operators. -/
theorem scalar_mass_is_color_exact (c : ℂ) :
    ∀ g ∈ colorGens, (c • (1 : Matrix (Fin 3) (Fin 3) ℂ)) * g
      = g * (c • (1 : Matrix (Fin 3) (Fin 3) ℂ)) := by
  intro g _
  rw [smul_mul_assoc, one_mul, mul_smul_comm, mul_one]

/-! ## Constraint corollary: a diagonal mass is color-exact iff color-blind. -/

/-- **The [H2] constraint corollary** (honest reading of
`mass_grading_not_central`). A diagonal mass `diagonal ![m0, m1, m2]` commutes
with every color generator **iff** it is color-blind, i.e. `m0 = m1 ∧ m1 = m2`. -/
theorem diagonal_mass_color_exact_iff (m0 m1 m2 : ℂ) :
    (∀ g ∈ colorGens, (Matrix.diagonal ![m0, m1, m2]) * g
        = g * (Matrix.diagonal ![m0, m1, m2])) ↔ (m0 = m1 ∧ m1 = m2) := by
  constructor;
  · intro h
    have h1 : m0 = m1 := by
      have := h T23m ( by simp +decide [ colorGens ] );
      simpa [ T23m ] using congr_fun ( congr_fun this 0 ) 1
    have h2 : m1 = m2 := by
      convert congr_arg ( fun x : Matrix ( Fin 3 ) ( Fin 3 ) ℂ => x 1 2 ) ( h T12m ( by simp +decide [ colorGens ] ) ) using 1 ; simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ ];
      · simp +decide [ T12m ];
      · simp +decide [ T12m, Matrix.mul_apply ];
        simp +decide [ Matrix.diagonal ]
    exact ⟨h1, h2⟩;
  · -- If m0 = m1 = m2 the matrix is diagonal-constant, hence commutes with every generator.
    rintro ⟨rfl, rfl⟩
    simp +decide [colorGens, H23m, H13m, T23m, T32m, T12m, T21m, T13m, T31m]
    simp +decide [← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.vecMul]

/-- **Constraint corollary (concrete).** The non-degenerate diagonal mass
`diagonal ![1, 2, 3]` does **not** commute with the color action, so it is not a
color-exact (physical) mass operator on the triplet. -/
theorem nonscalar_mass_not_color_exact :
    ¬ (∀ g ∈ colorGens, (Matrix.diagonal ![(1 : ℂ), 2, 3]) * g
        = g * (Matrix.diagonal ![(1 : ℂ), 2, 3])) := by
  intro h
  have := (diagonal_mass_color_exact_iff 1 2 3).mp h
  exact absurd this.1 (by norm_num)

/-! ## Axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.color_commutant_eq_scalars' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms color_commutant_eq_scalars

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.diagonal_mass_color_exact_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms diagonal_mass_color_exact_iff

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.nonscalar_mass_not_color_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonscalar_mass_not_color_exact

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.scalar_mass_is_color_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms scalar_mass_is_color_exact

end PhysicsSM.Draft.NullEdge.Carrier
