import PhysicsSM.Draft.NullEdgeYukawaFlip

/-!
# Draft.NullEdgeYukawaGaugeAristotle

Aristotle handoff for the next Standard Model bookkeeping layer in the
null-edge interpretation of Higgs-permitted chirality flips.

`NullEdgeYukawaFlip` proves the `U(1)_Y` hypercharge part: after inserting the
Higgs or conjugate Higgs, the usual one-generation Yukawa flip channels are
hypercharge neutral.  This file adds a finite representation-pattern API for
the remaining discrete bookkeeping:

1. the source is left-handed and the target is right-handed;
2. the source is an `SU(2)_L` doublet, the target is a singlet, and the Higgs
   insertion is a doublet;
3. the color pattern is neutral: lepton flips are singlet-to-singlet and quark
   flips are triplet-to-triplet, so `bar(left) * right` contains a color
   singlet.

This is still representation bookkeeping, not a proof of mass generation
dynamics or a full tensor-product representation theory.
-/

namespace PhysicsSM.Draft.NullEdgeYukawaGauge

open PhysicsSM.StandardModel.OneGenerationTable
open PhysicsSM.Draft.NullEdgeYukawaFlip

/-! ## Finite representation-pattern API -/

/-- The weak `SU(2)_L` representation pattern needed for Yukawa bookkeeping. -/
inductive WeakPattern where
  | singlet
  | doublet
deriving DecidableEq, Repr

/-- The color `SU(3)_c` representation pattern needed for Yukawa bookkeeping. -/
inductive ColorPattern where
  | singlet
  | triplet
deriving DecidableEq, Repr

/-- Higgs insertion used in the physical Yukawa monomial. -/
inductive HiggsInsertion where
  | higgs
  | conjugateHiggs
deriving DecidableEq, Repr

/-- Weak representation pattern of each physical one-generation multiplet. -/
def weakPatternOfMultiplet : PhysicalMultiplet -> WeakPattern
  | .Q_L => .doublet
  | .L_L => .doublet
  | .u_R => .singlet
  | .d_R => .singlet
  | .e_R => .singlet
  | .nu_R => .singlet

/-- Color representation pattern of each physical one-generation multiplet. -/
def colorPatternOfMultiplet : PhysicalMultiplet -> ColorPattern
  | .Q_L => .triplet
  | .L_L => .singlet
  | .u_R => .triplet
  | .d_R => .triplet
  | .e_R => .singlet
  | .nu_R => .singlet

/-- Higgs versus conjugate-Higgs insertion in the physical Yukawa term. -/
def higgsInsertion : YukawaFlip -> HiggsInsertion
  | .chargedLepton => .higgs
  | .downQuark => .higgs
  | .upQuark => .conjugateHiggs
  | .neutrino => .conjugateHiggs

/-- The weak representation pattern of either Higgs insertion. -/
def HiggsInsertion.weakPattern : HiggsInsertion -> WeakPattern
  | .higgs => .doublet
  | .conjugateHiggs => .doublet

/-- Hypercharge carried by the finite Higgs insertion marker. -/
def HiggsInsertion.hypercharge : HiggsInsertion -> ℚ
  | .higgs => 1
  | .conjugateHiggs => -1

/--
Weak-isospin pattern required for a Yukawa vertex:
`bar(left doublet) * Higgs doublet * right singlet`.
-/
def WeakYukawaPattern (v : YukawaFlip) : Prop :=
  weakPatternOfMultiplet (YukawaFlip.leftMultiplet v) = .doublet ∧
  (higgsInsertion v).weakPattern = .doublet ∧
  weakPatternOfMultiplet (YukawaFlip.rightMultiplet v) = .singlet

/--
Color pattern required for a Yukawa vertex.  This abstracts the fact that
`bar(3) ⊗ 3` and `bar(1) ⊗ 1` contain color singlets.
-/
def ColorNeutralPattern (v : YukawaFlip) : Prop :=
  colorPatternOfMultiplet (YukawaFlip.leftMultiplet v) =
    colorPatternOfMultiplet (YukawaFlip.rightMultiplet v)

/-- Electroweak legality at the finite representation-pattern level. -/
def ElectroweakLegalPattern (v : YukawaFlip) : Prop :=
  WeakYukawaPattern v ∧ YukawaFlip.hyperchargeDefect v = 0

/-- Full finite gauge-bookkeeping legality used by this draft file. -/
def GaugeLegalPattern (v : YukawaFlip) : Prop :=
  ElectroweakLegalPattern v ∧ ColorNeutralPattern v

/-! ## Aristotle targets -/

/-- The chosen Higgs marker has the same hypercharge as the original table. -/
theorem higgsInsertion_hypercharge_matches (v : YukawaFlip) :
    (higgsInsertion v).hypercharge =
      YukawaFlip.higgsInsertionHypercharge v := by
  cases v <;> rfl

/-- Every Yukawa source in this finite table is left-handed. -/
theorem leftMultiplet_chirality_left (v : YukawaFlip) :
    (YukawaFlip.leftMultiplet v).chirality = .left := by
  cases v <;> rfl

/-- Every Yukawa target in this finite table is right-handed. -/
theorem rightMultiplet_chirality_right (v : YukawaFlip) :
    (YukawaFlip.rightMultiplet v).chirality = .right := by
  cases v <;> rfl

/-- Every physical Yukawa flip has the required weak representation pattern. -/
theorem weakYukawaPattern_all (v : YukawaFlip) :
    WeakYukawaPattern v := by
  cases v <;> exact ⟨rfl, rfl, rfl⟩

/-- Every physical Yukawa flip has the required color-neutral pattern. -/
theorem colorNeutralPattern_all (v : YukawaFlip) :
    ColorNeutralPattern v := by
  cases v <;> rfl

/--
Every physical Yukawa flip is legal at the finite gauge-bookkeeping level:
weak pattern, hypercharge neutrality, and color neutrality.
-/
theorem gaugeLegalPattern_all (v : YukawaFlip) :
    GaugeLegalPattern v := by
  exact ⟨⟨weakYukawaPattern_all v, YukawaFlip.hyperchargeDefect_eq_zero v⟩,
    colorNeutralPattern_all v⟩

end PhysicsSM.Draft.NullEdgeYukawaGauge
