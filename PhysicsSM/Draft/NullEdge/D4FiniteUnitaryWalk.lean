import PhysicsSM.Draft.NullEdge.D4NullShellLattice

/-!
# Finite periodic 3+1 D4 null-shift walk

The six future axial roots of the selected D4 null shell define periodic shifts
on a finite three-dimensional lattice. Precomposition by those shifts preserves
the finite complex inner product. A supplied unitary six-channel coin also
preserves it, so shift-after-coin is an exactly norm-preserving finite 3+1 walk.

This is a genuine local finite dynamics, but its coin space has dimension six.
It is not yet identified with the four-component Clifford/Dirac symbol, and it
does not derive the preferred time axis, the coin, or a continuum limit.

Provenance: proof completed by Aristotle project
`1253313b-b5be-41c7-8bf9-7a15786e1c46`, informed by quantum-walk literature and
Mathlib finite-sum reindexing APIs; clean-room project port on 2026-07-10.
-/

open scoped BigOperators ComplexConjugate
open Matrix

namespace PhysicsSM.Draft.NullEdge.D4FiniteUnitaryWalk

open PhysicsSM.Draft.NullEdge.D4NullShellLattice

abbrev Direction := Fin 6
abbrev SpatialVec := Fin 3 -> ℤ

def spatialStep : Direction -> SpatialVec
  | 0 => ![1, 0, 0]
  | 1 => ![-1, 0, 0]
  | 2 => ![0, 1, 0]
  | 3 => ![0, -1, 0]
  | 4 => ![0, 0, 1]
  | 5 => ![0, 0, -1]

def futureNullRoot (d : Direction) : Vec4 :=
  ![1, spatialStep d 0, spatialStep d 1, spatialStep d 2]

theorem future_roots_in_selected_shell :
    ∀ d : Direction, futureNullRoot d ∈ nullRoots := by
  intro d
  fin_cases d <;> decide

theorem six_roots_are_unit_luminal :
    ∀ d : Direction,
      minkowskiSq (futureNullRoot d) = 0 ∧
      (spatialStep d 0) ^ 2 + (spatialStep d 1) ^ 2 +
        (spatialStep d 2) ^ 2 = 1 := by
  intro d
  fin_cases d <;> simp [minkowskiSq, futureNullRoot, spatialStep]

abbrev Position (L : ℕ) := Fin 3 -> ZMod L
abbrev State (L : ℕ) := Position L × Direction -> ℂ

def advance (L : ℕ) (q : Position L × Direction) :
    Position L × Direction :=
  (fun i => q.1 i + (spatialStep q.2 i : ZMod L), q.2)

def retreat (L : ℕ) (q : Position L × Direction) :
    Position L × Direction :=
  (fun i => q.1 i - (spatialStep q.2 i : ZMod L), q.2)

def shiftEquiv (L : ℕ) :
    (Position L × Direction) ≃ (Position L × Direction) where
  toFun := advance L
  invFun := retreat L
  left_inv := by
    intro q
    ext i <;> simp [advance, retreat]
  right_inv := by
    intro q
    ext i <;> simp [advance, retreat]

noncomputable def inner {L : ℕ} [NeZero L] (psi phi : State L) : ℂ :=
  ∑ q, conj (psi q) * phi q

noncomputable def shift {L : ℕ} [NeZero L] (psi : State L) : State L :=
  fun q => psi ((shiftEquiv L).symm q)

theorem shift_preserves_inner {L : ℕ} [NeZero L] (psi phi : State L) :
    inner (shift psi) (shift phi) = inner psi phi := by
  unfold inner shift
  conv_rhs => rw [← Equiv.sum_comp (shiftEquiv L).symm]

noncomputable def coin {L : ℕ} [NeZero L]
    (U : Matrix Direction Direction ℂ) (psi : State L) : State L :=
  fun q => ∑ e, U q.2 e * psi (q.1, e)

def IsUnitary (U : Matrix Direction Direction ℂ) : Prop :=
  U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1

theorem coin_preserves_inner {L : ℕ} [NeZero L]
    (U : Matrix Direction Direction ℂ) (hU : IsUnitary U)
    (psi phi : State L) :
    inner (coin U psi) (coin U phi) = inner psi phi := by
  unfold coin inner
  simp +decide [mul_assoc, mul_comm, mul_left_comm,
    Finset.mul_sum _ _ _]
  have hFubini : ∀ p : Position L,
      ∑ d1 : Direction, ∑ d2 : Direction, ∑ d3 : Direction,
        U d1 d3 * (starRingEnd ℂ) (U d1 d2) *
          (starRingEnd ℂ) (psi (p, d2)) * phi (p, d3) =
      ∑ d2 : Direction, (starRingEnd ℂ) (psi (p, d2)) * phi (p, d2) := by
    intro p
    have hInner :
        ∑ d1 : Direction, ∑ d2 : Direction, ∑ d3 : Direction,
          U d1 d3 * (starRingEnd ℂ) (U d1 d2) *
            (starRingEnd ℂ) (psi (p, d2)) * phi (p, d3) =
        ∑ d2 : Direction, ∑ d3 : Direction,
          (∑ d1 : Direction, U d1 d3 * (starRingEnd ℂ) (U d1 d2)) *
            (starRingEnd ℂ) (psi (p, d2)) * phi (p, d3) := by
      simp +decide only [mul_assoc, Finset.sum_mul _ _ _]
      exact Finset.sum_comm.trans
        (Finset.sum_congr rfl fun _ _ => Finset.sum_comm)
    have hUnit := hU.1
    simp_all +decide [← Matrix.ext_iff, Matrix.mul_apply]
    simp_all +decide [mul_comm, Matrix.one_apply]
  convert Finset.sum_congr rfl (fun p hp => hFubini p) using 1
  any_goals exact Finset.univ
  · erw [Finset.sum_product]
    simp +decide [mul_assoc]
  · rw [← Finset.sum_product']
    simp +decide [mul_comm]

noncomputable def walk {L : ℕ} [NeZero L]
    (U : Matrix Direction Direction ℂ) (psi : State L) : State L :=
  shift (coin U psi)

/-- A finite periodic six-direction D4 null walk is exactly norm preserving
for every supplied unitary coin. -/
theorem walk_preserves_norm {L : ℕ} [NeZero L]
    (U : Matrix Direction Direction ℂ) (hU : IsUnitary U)
    (psi : State L) :
    inner (walk U psi) (walk U psi) = inner psi psi := by
  rw [walk, shift_preserves_inner, coin_preserves_inner U hU]

def origin5 : Position 5 := fun _ => 0

/-- The x-plus null shift moves a site on a nontrivial periodic lattice. -/
theorem nontrivial_shift_control :
    advance 5 (origin5, (0 : Direction)) ≠
      (origin5, (0 : Direction)) := by
  simp +decide

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.D4FiniteUnitaryWalk.future_roots_in_selected_shell' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms future_roots_in_selected_shell

/-- info: 'PhysicsSM.Draft.NullEdge.D4FiniteUnitaryWalk.walk_preserves_norm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms walk_preserves_norm

/-- info: 'PhysicsSM.Draft.NullEdge.D4FiniteUnitaryWalk.nontrivial_shift_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nontrivial_shift_control

end PhysicsSM.Draft.NullEdge.D4FiniteUnitaryWalk
