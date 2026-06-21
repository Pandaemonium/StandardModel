import Mathlib.Tactic
import PhysicsSM.StandardModel.OneGenerationTable

/-!
# StandardModel.YukawaGauge

Trusted finite bookkeeping for one-generation Yukawa gauge-legality patterns.

This module checks the finite representation and hypercharge data behind the
usual one-generation Yukawa chirality flips:

* charged lepton;
* down quark;
* up quark;
* neutrino, in the optional right-handed-neutrino table already present in
  `PhysicsSM.StandardModel.OneGenerationTable`.

Claim boundary:
* the theorem `candidateGaugeLegal_iff_exists_yukawaFlip` is a finite
  classifier for the predicates defined here;
* weak `SU(2)_L` and color `SU(3)_c` information is represented only by
  singlet/doublet and singlet/triplet pattern tags;
* it does not construct tensor-product contractions, prove a full Standard
  Model Yukawa Lagrangian, or assert mass generation dynamics.

Sources and provenance:
* `PhysicsSM.StandardModel.OneGenerationTable`
* `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
* `AgentTasks/null-edge-overnight-synthesis-aristotle-2026-06-21.md`
* Promoted from the no-s o r r y draft modules
  `PhysicsSM.Draft.NullEdgeYukawaFlip`,
  `PhysicsSM.Draft.NullEdgeYukawaGaugeAristotle`, and
  `PhysicsSM.Draft.NullEdgeOvernightSynthesisAristotle` after semantic review.

Status: trusted, no `s o r r y`.
-/

namespace PhysicsSM.StandardModel.YukawaGauge

open PhysicsSM.StandardModel.OneGenerationTable

/-! ## Physical Yukawa flip channels -/

/-- One-generation Yukawa flip channels. -/
inductive YukawaFlip where
  | chargedLepton
  | downQuark
  | upQuark
  | neutrino
deriving DecidableEq, Repr

namespace YukawaFlip

/-- The left-handed source multiplet of a Yukawa flip. -/
def leftMultiplet : YukawaFlip -> PhysicalMultiplet
  | .chargedLepton => .L_L
  | .downQuark => .Q_L
  | .upQuark => .Q_L
  | .neutrino => .L_L

/-- The right-handed target multiplet of a Yukawa flip. -/
def rightMultiplet : YukawaFlip -> PhysicalMultiplet
  | .chargedLepton => .e_R
  | .downQuark => .d_R
  | .upQuark => .u_R
  | .neutrino => .nu_R

/--
Hypercharge of the Higgs insertion in the physical Yukawa term.

In the repo convention `Q = T3 + Y/2`, the Higgs doublet has `Y = 1` and the
conjugate Higgs has `Y = -1`.
-/
def higgsInsertionHypercharge : YukawaFlip -> ℚ
  | .chargedLepton => 1
  | .downQuark => 1
  | .upQuark => -1
  | .neutrino => -1

/--
The hypercharge defect of the physical Yukawa monomial
`bar(left) * HiggsInsertion * right`.

The bar on the left-handed field contributes the negated left hypercharge.
-/
def hyperchargeDefect (v : YukawaFlip) : ℚ :=
  -(leftMultiplet v).hypercharge +
    higgsInsertionHypercharge v +
    (rightMultiplet v).hypercharge

/--
Every one-generation Yukawa chirality flip is hypercharge neutral after
inserting the Higgs or conjugate Higgs with the usual Standard Model charge.
-/
theorem hyperchargeDefect_eq_zero (v : YukawaFlip) :
    hyperchargeDefect v = 0 := by
  cases v <;>
    norm_num [hyperchargeDefect, leftMultiplet, rightMultiplet,
      higgsInsertionHypercharge, PhysicalMultiplet.hypercharge]

end YukawaFlip

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

/-- Full finite gauge-bookkeeping legality for the physical flip table. -/
def GaugeLegalPattern (v : YukawaFlip) : Prop :=
  ElectroweakLegalPattern v ∧ ColorNeutralPattern v

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

/-! ## Candidate-level finite classifier -/

/-- A candidate finite Yukawa vertex before imposing legality. -/
structure CandidateYukawaVertex where
  left : PhysicalMultiplet
  right : PhysicalMultiplet
  higgs : HiggsInsertion
deriving DecidableEq, Repr

namespace CandidateYukawaVertex

/-- Hypercharge defect of the candidate monomial `bar(left) * higgs * right`. -/
def hyperchargeDefect (c : CandidateYukawaVertex) : ℚ :=
  -c.left.hypercharge + c.higgs.hypercharge + c.right.hypercharge

/-- The candidate is a chirality flip from a left-handed to a right-handed multiplet. -/
def ChiralityLegal (c : CandidateYukawaVertex) : Prop :=
  c.left.chirality = .left ∧ c.right.chirality = .right

/-- The candidate has the weak-representation pattern of a Yukawa monomial. -/
def WeakLegal (c : CandidateYukawaVertex) : Prop :=
  weakPatternOfMultiplet c.left = .doublet ∧
  c.higgs.weakPattern = .doublet ∧
  weakPatternOfMultiplet c.right = .singlet

/-- The candidate is color-neutral at the finite representation-pattern level. -/
def ColorNeutral (c : CandidateYukawaVertex) : Prop :=
  colorPatternOfMultiplet c.left = colorPatternOfMultiplet c.right

end CandidateYukawaVertex

/-- Combined finite legality predicate for a candidate Yukawa vertex. -/
def CandidateGaugeLegal (c : CandidateYukawaVertex) : Prop :=
  c.ChiralityLegal ∧ c.WeakLegal ∧ c.ColorNeutral ∧
  c.hyperchargeDefect = 0

/-- Embed the four physical one-generation Yukawa flips as candidate vertices. -/
def candidateOfYukawaFlip (v : YukawaFlip) : CandidateYukawaVertex where
  left := YukawaFlip.leftMultiplet v
  right := YukawaFlip.rightMultiplet v
  higgs := higgsInsertion v

/-- Every table Yukawa flip gives a legal candidate vertex. -/
theorem candidateOfYukawaFlip_gaugeLegal (v : YukawaFlip) :
    CandidateGaugeLegal (candidateOfYukawaFlip v) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact ⟨leftMultiplet_chirality_left v, rightMultiplet_chirality_right v⟩
  · exact weakYukawaPattern_all v
  · exact colorNeutralPattern_all v
  · dsimp [CandidateYukawaVertex.hyperchargeDefect, candidateOfYukawaFlip]
    rw [higgsInsertion_hypercharge_matches]
    exact YukawaFlip.hyperchargeDefect_eq_zero v

/--
Finite classifier: the Standard-Model-like candidate legality predicate picks
out exactly the four one-generation Yukawa flip channels.
-/
theorem candidateGaugeLegal_iff_exists_yukawaFlip
    (c : CandidateYukawaVertex) :
    CandidateGaugeLegal c ↔
      ∃ v : YukawaFlip, c = candidateOfYukawaFlip v := by
  constructor
  · intro hc
    rcases hc with ⟨hcChirality, hcWeak, hcColor, hcHyper⟩
    obtain ⟨hL, hR⟩ := hcChirality
    rcases c with ⟨left, right, higgsIns⟩
    cases left <;> cases right <;> cases higgsIns <;>
      simp_all [CandidateYukawaVertex.WeakLegal,
        CandidateYukawaVertex.ColorNeutral,
        CandidateYukawaVertex.hyperchargeDefect,
        weakPatternOfMultiplet, colorPatternOfMultiplet,
        HiggsInsertion.weakPattern, HiggsInsertion.hypercharge,
        PhysicalMultiplet.chirality, PhysicalMultiplet.hypercharge]
    all_goals try norm_num at hcHyper
    all_goals first
      | exact ⟨YukawaFlip.upQuark, rfl⟩
      | exact ⟨YukawaFlip.downQuark, rfl⟩
      | exact ⟨YukawaFlip.chargedLepton, rfl⟩
      | exact ⟨YukawaFlip.neutrino, rfl⟩
  · rintro ⟨v, rfl⟩
    exact candidateOfYukawaFlip_gaugeLegal v

end PhysicsSM.StandardModel.YukawaGauge
