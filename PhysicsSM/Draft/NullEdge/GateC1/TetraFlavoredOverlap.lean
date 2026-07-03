import PhysicsSM.Draft.NullEdge.GateC1.TetraBranchWilsonSymbol

/-!
# Gate C1 flavored-overlap branch-mass scan scaffold

This Draft module records the smallest finite acceptance test recommended by the
C273-C276 Aristotle strategy wave.

The current C1 direction is not to release chirality from the origin fiber.  The
next decisive finite test is a branch-mass window: over the tetrahedral branch
set, a concrete matrix-valued flavored Wilson term should make exactly one
chosen branch negative while all other branches have positive mass, and the
retained branch should carry nonzero chirality.

This file deliberately does not construct the physical `W_branch`.  Instead it
packages the finite branch/window/index criterion that such a construction must
satisfy.  A later module should connect `branchMass` to an actual
`BranchWilsonData.W` and to the sector gap theorem in `TetraBranchWilsonSymbol`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraFlavoredOverlap

open scoped BigOperators
open TetraBranchWilsonSymbol

/-- The finite tetrahedral branch labels used by the first mass-window scan.

`false` denotes the zero/cosine-even choice in a coordinate and `true` denotes
the opposite corner.  The actual physical branch set may later be quotiented or
restricted, but `Fin 4 -> Bool` is the smallest explicit scan surface. -/
abbrev Branch := Fin 4 -> Bool

/-- The origin branch. -/
def originBranch : Branch :=
  fun _ => false

/-- The standard corner momentum associated to a branch label. -/
def branchMomentum (b : Branch) : Fin 4 -> ℝ :=
  fun A => if b A then Real.pi else 0

/-- The origin branch maps to zero corner momentum. -/
theorem branchMomentum_origin : branchMomentum originBranch = fun _ => 0 := by
  ext A
  simp [branchMomentum, originBranch]

/-- A branch is retained by a real branch-mass profile when its mass is negative.
This is the finite shadow of choosing an overlap mass window. -/
def retainedByMass (mass : Branch -> ℝ) (b : Branch) : Prop :=
  mass b < 0

/-- A branch-mass profile has a one-branch window if the target branch is
negative and every other branch is positive. -/
structure BranchMassWindow (mass : Branch -> ℝ) (target : Branch) : Prop where
  /-- The physical/retained branch is below zero in the overlap mass window. -/
  target_negative : mass target < 0
  /-- Every non-target branch is above zero, hence gapped away at the mass level. -/
  others_positive : ∀ b, b ≠ target -> 0 < mass b

/-- The chirality-weighted retained index of a finite branch-mass scan. -/
def retainedIndex (mass : Branch -> ℝ) (chirality : Branch -> ℤ) : ℤ :=
  by
    classical
    exact ∑ b : Branch, if retainedByMass mass b then chirality b else 0

/-- A one-branch mass window retains exactly the target chirality. -/
theorem retainedIndex_eq_target {mass : Branch -> ℝ} {chirality : Branch -> ℤ}
    {target : Branch} (hwin : BranchMassWindow mass target) :
    retainedIndex mass chirality = chirality target := by
  classical
  unfold retainedIndex
  rw [Finset.sum_eq_single target]
  · have htarget : retainedByMass mass target := by
      unfold retainedByMass
      exact hwin.target_negative
    rw [if_pos htarget]
  · intro b _hb hb
    have hpos : 0 < mass b := hwin.others_positive b hb
    have hnot : ¬ retainedByMass mass b := by
      unfold retainedByMass
      linarith
    rw [if_neg hnot]
  · intro hnotmem
    simp at hnotmem

/-- A one-branch mass window with nonzero target chirality gives nonzero retained
index. -/
theorem retainedIndex_ne_zero {mass : Branch -> ℝ} {chirality : Branch -> ℤ}
    {target : Branch} (hwin : BranchMassWindow mass target)
    (hchi : chirality target ≠ 0) :
    retainedIndex mass chirality ≠ 0 := by
  rw [retainedIndex_eq_target hwin]
  exact hchi

/-- A toy profile that keeps one target branch and gives all other branches the
same positive mirror mass.  This is not a physical operator; it is the reference
shape the concrete flavored Wilson scan must realize. -/
def singleBranchMass (target : Branch) (mPhysical mMirror : ℝ) : Branch -> ℝ :=
  fun b => if b = target then -mPhysical else mMirror

/-- The toy one-branch profile has the desired mass window whenever both input
scales are positive. -/
theorem singleBranchMass_window (target : Branch) {mPhysical mMirror : ℝ}
    (hPhysical : 0 < mPhysical) (hMirror : 0 < mMirror) :
    BranchMassWindow (singleBranchMass target mPhysical mMirror) target := by
  constructor
  · unfold singleBranchMass
    simp
    linarith
  · intro b hb
    unfold singleBranchMass
    simp [hb, hMirror]

/-- Bundled finite branch-mass scan witness.

A concrete `W_branch` search should produce this bundle first, before claiming a
full `BranchRetentionCertificate` or `PhysicalC1Certificate`. -/
structure BranchMassScanWitness where
  /-- Candidate branch-mass profile, normally computed from a branch Wilson term. -/
  mass : Branch -> ℝ
  /-- Chirality/sign contribution attached to each branch. -/
  chirality : Branch -> ℤ
  /-- The intended retained physical branch. -/
  target : Branch
  /-- Exactly one-branch mass window. -/
  window : BranchMassWindow mass target
  /-- The retained branch is chiral rather than index-zero. -/
  target_chirality_ne_zero : chirality target ≠ 0

namespace BranchMassScanWitness

/-- Any accepted branch-mass scan has nonzero chirality-weighted retained index. -/
theorem retainedIndex_ne_zero (w : BranchMassScanWitness) :
    retainedIndex w.mass w.chirality ≠ 0 :=
  TetraFlavoredOverlap.retainedIndex_ne_zero w.window w.target_chirality_ne_zero

end BranchMassScanWitness

/-- Interface tying the finite branch-mass scan to an actual branch-Wilson datum.

This is still a search specification, not a physical C1 certificate.  It records
that the search output came from some `BranchWilsonData`; later work must prove
that this same datum satisfies the square/gap, island, locality, anomaly, and
Krein clauses. -/
structure FlavoredWilsonSearchSpec (Spin : Type*) [Fintype Spin]
    [DecidableEq Spin] where
  /-- Matrix-valued flavored branch Wilson candidate. -/
  BW : BranchWilsonData (Spin := Spin)
  /-- Branch-mass profile extracted from the candidate. -/
  branchMass : Branch -> ℝ
  /-- Chirality contribution per branch. -/
  chirality : Branch -> ℤ
  /-- Intended retained branch. -/
  target : Branch
  /-- One-branch mass window. -/
  mass_window : BranchMassWindow branchMass target
  /-- The retained branch has nonzero chirality contribution. -/
  target_chirality_ne_zero : chirality target ≠ 0

namespace FlavoredWilsonSearchSpec

/-- A flavored-Wilson search candidate satisfying the mass-window interface has
nonzero retained finite branch index. -/
theorem retainedIndex_ne_zero {Spin : Type*} [Fintype Spin] [DecidableEq Spin]
    (S : FlavoredWilsonSearchSpec Spin) :
    retainedIndex S.branchMass S.chirality ≠ 0 :=
  TetraFlavoredOverlap.retainedIndex_ne_zero
    S.mass_window S.target_chirality_ne_zero

end FlavoredWilsonSearchSpec

end TetraFlavoredOverlap
end GateC1
end NullEdge
end Draft
end PhysicsSM
