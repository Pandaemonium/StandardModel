import Mathlib

/-!
# Gate C1 C278 review of Pro's Taste16 `W_branch`

This draft module records the machine-checkable core of Aristotle C278's review
of Pro's branch-locked Taste16 proposal.

The literal proposal has branch/taste mass eigenvalue

```text
mu(b,t) = 2 r d(b,t) + 2 lam wt(t) - m0,
```

where `d` is Hamming distance between a branch corner and a taste corner, and
`wt` is the taste weight.  We prove that the window
`r > 0`, `lam > 0`, `0 < m0 < 2 min r lam` gives exactly one negative
mass-level sector, namely `(0000,0000)`.

We also record the decisive obstruction to the literal lift: if
`W = I_spin tensor W_taste` and `Q = Q_spin tensor I_taste`, then the two
operators commute on tensor-factor grounds.  Therefore the commutator term in
the branch-Wilson square vanishes.  This makes the literal Taste16 proposal a
useful mass-window benchmark, but not a physical chiral-release candidate as
written.
-/

noncomputable section

open scoped BigOperators Kronecker
open Matrix

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace ProTaste16Review

/-- Hypercube corner label, shared by the branch index and the taste register. -/
abbrev Corner := Fin 4 -> Bool

/-- Branch corner label. -/
abbrev Branch := Corner

/-- Taste corner label for Pro's literal 16-state lift. -/
abbrev Taste := Corner

/-- Joint branch/taste sector. -/
abbrev Sector := Branch × Taste

/-- Hamming distance between two corners. -/
def hdist (b t : Corner) : ℕ := ∑ A : Fin 4, (if b A = t A then 0 else 1)

/-- Taste weight: number of `true` entries. -/
def wt (t : Corner) : ℕ := ∑ A : Fin 4, (if t A then 1 else 0)

/-- The origin corner. -/
def zeroCorner : Corner := fun _ => false

/-- The target branch/taste sector in the literal Pro proposal. -/
def targetSector : Sector := (zeroCorner, zeroCorner)

/-- Pro's exact joint branch/taste mass eigenvalue. -/
def proMass (r lam m0 : ℝ) (b t : Corner) : ℝ :=
  2 * r * (hdist b t : ℝ) + 2 * lam * (wt t : ℝ) - m0

/-- Sector form of `proMass`. -/
def proSectorMass (r lam m0 : ℝ) (s : Sector) : ℝ :=
  proMass r lam m0 s.1 s.2

/-- Combinatorial core: every joint sector other than `(origin,origin)` has
positive combined distance-plus-weight.  This is a finite check over 256
sectors, discharged by kernel-checked decidability. -/
theorem dist_wt_pos (b t : Corner) (hne : ¬ (b = zeroCorner ∧ t = zeroCorner)) :
    1 ≤ hdist b t + wt t := by
  revert b t hne
  decide

/-- The target sector carries mass `-m0`. -/
theorem proMass_target (r lam m0 : ℝ) :
    proMass r lam m0 zeroCorner zeroCorner = -m0 := by
  have h : hdist zeroCorner zeroCorner = 0 ∧ wt zeroCorner = 0 := by decide
  unfold proMass
  rw [h.1, h.2]
  push_cast
  ring

/-- At any positive `m0`, the target sector is negative. -/
theorem proMass_target_neg (r lam m0 : ℝ) (hm0 : 0 < m0) :
    proMass r lam m0 zeroCorner zeroCorner < 0 := by
  rw [proMass_target]
  linarith

/-- Pro mass-window soundness: in the symbolic window
`r > 0`, `lam > 0`, `0 < m0 < 2 min r lam`, every non-target joint sector has
strictly positive mass.  Together with `proMass_target_neg`, this is the exact
one-sector mass-window statement. -/
theorem proMass_window (r lam m0 : ℝ) (hr : 0 < r) (hlam : 0 < lam)
    (hm0 : 0 < m0) (hwin : m0 < 2 * min r lam)
    (b t : Corner) (hne : ¬ (b = zeroCorner ∧ t = zeroCorner)) :
    0 < proMass r lam m0 b t := by
  have hcore : 1 ≤ hdist b t + wt t := dist_wt_pos b t hne
  set d : ℝ := (hdist b t : ℝ) with hd
  set w : ℝ := (wt t : ℝ) with hw
  have hd0 : 0 ≤ d := by positivity
  have hw0 : 0 ≤ w := by positivity
  have h1 : (1 : ℝ) ≤ d + w := by
    rw [hd, hw]
    exact_mod_cast hcore
  have hmin_r : min r lam ≤ r := min_le_left _ _
  have hmin_l : min r lam ≤ lam := min_le_right _ _
  have e1 : 2 * (min r lam) * d ≤ 2 * r * d := by nlinarith
  have e2 : 2 * (min r lam) * w ≤ 2 * lam * w := by nlinarith
  have e3 : 2 * (min r lam) * 1 ≤ 2 * (min r lam) * (d + w) := by
    have : (0 : ℝ) ≤ min r lam := le_min (le_of_lt hr) (le_of_lt hlam)
    nlinarith
  unfold proMass
  nlinarith

/-- Bundled mass-level witness for Pro's literal branch/taste table.

This is deliberately only a mass-window witness.  It does not assert a nonzero
overlap index or physical C1 release. -/
structure BranchTasteMassScanWitness where
  /-- Wilson scale in the mass table. -/
  r : ℝ
  /-- Taste-locking scale in the mass table. -/
  lam : ℝ
  /-- Negative target offset. -/
  m0 : ℝ
  /-- Positive Wilson scale. -/
  r_pos : 0 < r
  /-- Positive taste-locking scale. -/
  lam_pos : 0 < lam
  /-- Positive target offset. -/
  m0_pos : 0 < m0
  /-- The one-sector mass-window upper bound. -/
  m0_lt_window : m0 < 2 * min r lam

namespace BranchTasteMassScanWitness

/-- The target sector is negative for any bundled mass-window witness. -/
theorem target_negative (w : BranchTasteMassScanWitness) :
    proSectorMass w.r w.lam w.m0 targetSector < 0 := by
  exact proMass_target_neg w.r w.lam w.m0 w.m0_pos

/-- Every non-target sector is positive for any bundled mass-window witness. -/
theorem off_target_positive (w : BranchTasteMassScanWitness) (s : Sector)
    (hs : s ≠ targetSector) :
    0 < proSectorMass w.r w.lam w.m0 s := by
  rcases s with ⟨b, t⟩
  exact proMass_window w.r w.lam w.m0 w.r_pos w.lam_pos w.m0_pos w.m0_lt_window b t
    (by
      intro h
      apply hs
      exact Prod.ext h.1 h.2)

end BranchTasteMassScanWitness

/-- Concrete normalized Pro mass-window witness: `r = lam = m0 = 1`. -/
def proWitness1 : BranchTasteMassScanWitness where
  r := 1
  lam := 1
  m0 := 1
  r_pos := by norm_num
  lam_pos := by norm_num
  m0_pos := by norm_num
  m0_lt_window := by norm_num

/-- A mass-level retained-sector index used only as a finite scan marker.

This is not the overlap/Ginsparg-Wilson index.  It records that the retained
mass-window sector is assigned chirality weight `1`. -/
def massLevelRetainedIndex (_w : BranchTasteMassScanWitness) : ℤ := 1

/-- The Pro mass-level retained index is nonzero for any bundled witness.

This theorem is intentionally labelled mass-level only; C278 shows that the
literal pure-taste operator still has a vanishing commutator with a spin-only
kinetic slash. -/
theorem proTaste_retainedIndex_ne_zero (w : BranchTasteMassScanWitness) :
    massLevelRetainedIndex w ≠ 0 := by
  norm_num [massLevelRetainedIndex]

/-- Reduction remark: on the origin branch, the same window lifts every
non-target taste sector.  The mass-window discriminator is `hdist + wt`, not the
mere size of the 16-state taste register. -/
theorem proMass_window_origin_branch (r lam m0 : ℝ) (hr : 0 < r) (hlam : 0 < lam)
    (hm0 : 0 < m0) (hwin : m0 < 2 * min r lam) (t : Corner) (ht : t ≠ zeroCorner) :
    0 < proMass r lam m0 zeroCorner t :=
  proMass_window r lam m0 hr hlam hm0 hwin zeroCorner t (by
    intro h
    exact ht h.2)

/-- A purely taste branch term commutes with a purely spin kinetic slash because
they act on disjoint tensor factors. -/
theorem taste_only_commutes_spin_only
    {S T : Type*} [Fintype S] [Fintype T] [DecidableEq S] [DecidableEq T]
    (Qs : Matrix S S ℂ) (Wt : Matrix T T ℂ) :
    ((1 : Matrix S S ℂ) ⊗ₖ Wt) * (Qs ⊗ₖ (1 : Matrix T T ℂ))
      = (Qs ⊗ₖ (1 : Matrix T T ℂ)) * ((1 : Matrix S S ℂ) ⊗ₖ Wt) := by
  rw [← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul,
    Matrix.mul_one, Matrix.one_mul, Matrix.mul_one, Matrix.one_mul]

/-- Consequence: the commutator term driving the branch square vanishes
identically for Pro's literal `I_spin tensor W_taste` form. -/
theorem taste_only_commutator_zero
    {S T : Type*} [Fintype S] [Fintype T] [DecidableEq S] [DecidableEq T]
    (Qs : Matrix S S ℂ) (Wt : Matrix T T ℂ) :
    ((1 : Matrix S S ℂ) ⊗ₖ Wt) * (Qs ⊗ₖ (1 : Matrix T T ℂ))
      - (Qs ⊗ₖ (1 : Matrix T T ℂ)) * ((1 : Matrix S S ℂ) ⊗ₖ Wt) = 0 := by
  rw [taste_only_commutes_spin_only]
  abel

/-!
## Minimal Adams-style noncommutation toy

The literal pure-taste lift commutes because it is placed entirely on a tensor
factor disjoint from the spin slash.  A spin-mixing flavored term has the right
kind of algebraic escape hatch.  The following two-by-two toy is not a physical
operator; it is a small checked witness that a gamma5-like diagonal term need
not commute with an off-diagonal slash.
-/

/-- Two-dimensional toy spin/taste index. -/
abbrev Two := Fin 2

/-- Toy off-diagonal slash block. -/
def sigmaX : Matrix Two Two ℂ := fun i j =>
  if (i = 0 ∧ j = 1) ∨ (i = 1 ∧ j = 0) then 1 else 0

/-- Toy gamma5-like diagonal block. -/
def sigmaZ : Matrix Two Two ℂ := fun i j =>
  if i = j then if i = 0 then 1 else -1 else 0

/-- A gamma5-like block does not commute with the off-diagonal toy slash. -/
theorem sigmaZ_sigmaX_commutator_ne_zero :
    sigmaZ * sigmaX - sigmaX * sigmaZ ≠ 0 := by
  intro h
  have h01 := congrArg (fun M : Matrix Two Two ℂ => M 0 1) h
  norm_num [sigmaZ, sigmaX, Matrix.mul_apply, Fin.sum_univ_two] at h01

end ProTaste16Review
end GateC1
end NullEdge
end Draft
end PhysicsSM
