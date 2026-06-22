import Mathlib

/-!
# Null-edge Yukawa mass-operator bridge

This standalone finite target connects two theorem islands in the null-edge
program:

* Higgs/Yukawa legality is the finite permission rule for a chirality-changing
  vertex.
* A chirality-changing scalar flip is an odd first-order operator whose square
  is the scalar mass block.

The file intentionally keeps only the small finite table needed for the proof
job.  It mirrors the trusted `PhysicsSM.StandardModel.YukawaGauge` bookkeeping
without importing the full Standard Model table, so Aristotle can spend time on
the target proofs rather than on the project import graph.
-/

noncomputable section

namespace NullEdgeYukawaMassOperator

open Matrix

/-! ## Minimal finite Yukawa bookkeeping -/

/-- Physical handedness of a finite fermion multiplet. -/
inductive Chirality where
  | left
  | right
deriving DecidableEq, Repr

/-- Weak-isospin pattern used by the finite Yukawa classifier. -/
inductive WeakPattern where
  | singlet
  | doublet
deriving DecidableEq, Repr

/-- Color pattern used by the finite Yukawa classifier. -/
inductive ColorPattern where
  | singlet
  | triplet
deriving DecidableEq, Repr

/-- Minimal one-generation physical multiplet table. -/
inductive Multiplet where
  | Q_L
  | L_L
  | u_R
  | d_R
  | e_R
  | nu_R
deriving DecidableEq, Repr

/-- Physical chirality of each multiplet. -/
def multipletChirality : Multiplet -> Chirality
  | .Q_L => .left
  | .L_L => .left
  | .u_R => .right
  | .d_R => .right
  | .e_R => .right
  | .nu_R => .right

/-- Weak pattern of each multiplet. -/
def multipletWeak : Multiplet -> WeakPattern
  | .Q_L => .doublet
  | .L_L => .doublet
  | .u_R => .singlet
  | .d_R => .singlet
  | .e_R => .singlet
  | .nu_R => .singlet

/-- Color pattern of each multiplet. -/
def multipletColor : Multiplet -> ColorPattern
  | .Q_L => .triplet
  | .L_L => .singlet
  | .u_R => .triplet
  | .d_R => .triplet
  | .e_R => .singlet
  | .nu_R => .singlet

/--
Hypercharge in the convention `Q = T3 + Y/2`, stored as rationals.
-/
def multipletHypercharge : Multiplet -> Rat
  | .Q_L => 1 / 3
  | .L_L => -1
  | .u_R => 4 / 3
  | .d_R => -2 / 3
  | .e_R => -2
  | .nu_R => 0

/-- Higgs insertion used in a finite Yukawa monomial. -/
inductive HiggsInsertion where
  | higgs
  | conjugateHiggs
deriving DecidableEq, Repr

/-- Weak pattern of the Higgs or conjugate-Higgs insertion. -/
def higgsWeak : HiggsInsertion -> WeakPattern
  | .higgs => .doublet
  | .conjugateHiggs => .doublet

/-- Hypercharge of the Higgs or conjugate-Higgs insertion. -/
def higgsHypercharge : HiggsInsertion -> Rat
  | .higgs => 1
  | .conjugateHiggs => -1

/-- The four one-generation Yukawa flip channels. -/
inductive YukawaFlip where
  | chargedLepton
  | downQuark
  | upQuark
  | neutrino
deriving DecidableEq, Repr

/-- Left-handed source of a finite Yukawa flip. -/
def YukawaFlip.leftMultiplet : YukawaFlip -> Multiplet
  | .chargedLepton => .L_L
  | .downQuark => .Q_L
  | .upQuark => .Q_L
  | .neutrino => .L_L

/-- Right-handed target of a finite Yukawa flip. -/
def YukawaFlip.rightMultiplet : YukawaFlip -> Multiplet
  | .chargedLepton => .e_R
  | .downQuark => .d_R
  | .upQuark => .u_R
  | .neutrino => .nu_R

/-- Higgs insertion of a finite Yukawa flip. -/
def YukawaFlip.higgsInsertion : YukawaFlip -> HiggsInsertion
  | .chargedLepton => .higgs
  | .downQuark => .higgs
  | .upQuark => .conjugateHiggs
  | .neutrino => .conjugateHiggs

/-- A candidate Yukawa vertex before imposing legality. -/
structure CandidateYukawaVertex where
  left : Multiplet
  right : Multiplet
  higgs : HiggsInsertion
deriving DecidableEq, Repr

/-- Hypercharge defect of `bar(left) * higgs * right`. -/
def CandidateYukawaVertex.hyperchargeDefect (c : CandidateYukawaVertex) : Rat :=
  -multipletHypercharge c.left + higgsHypercharge c.higgs + multipletHypercharge c.right

/-- Candidate chirality legality. -/
def CandidateYukawaVertex.ChiralityLegal (c : CandidateYukawaVertex) : Prop :=
  multipletChirality c.left = .left /\ multipletChirality c.right = .right

/-- Candidate weak-pattern legality. -/
def CandidateYukawaVertex.WeakLegal (c : CandidateYukawaVertex) : Prop :=
  multipletWeak c.left = .doublet /\
    higgsWeak c.higgs = .doublet /\
    multipletWeak c.right = .singlet

/-- Candidate color-neutrality. -/
def CandidateYukawaVertex.ColorNeutral (c : CandidateYukawaVertex) : Prop :=
  multipletColor c.left = multipletColor c.right

/-- Combined finite gauge-legality predicate for a Yukawa candidate. -/
def CandidateGaugeLegal (c : CandidateYukawaVertex) : Prop :=
  c.ChiralityLegal /\ c.WeakLegal /\ c.ColorNeutral /\ c.hyperchargeDefect = 0

/-- Candidate vertex attached to a physical finite Yukawa flip. -/
def candidateOfYukawaFlip (v : YukawaFlip) : CandidateYukawaVertex where
  left := v.leftMultiplet
  right := v.rightMultiplet
  higgs := v.higgsInsertion

/-! ## Finite first-order chirality-flip operator -/

variable {X : Type*} [Fintype X] [DecidableEq X]

/-- Off-diagonal operator on a finite left/right space. -/
def offDiagonal
    (phi psi : Matrix X X Complex) :
    Matrix (Sum X X) (Sum X X) Complex :=
  fun a b =>
    match a, b with
    | Sum.inl _, Sum.inl _ => 0
    | Sum.inl l, Sum.inr r => psi l r
    | Sum.inr r, Sum.inl l => phi r l
    | Sum.inr _, Sum.inr _ => 0

/-- Chirality grading: `+1` on the left copy and `-1` on the right copy. -/
def chiralityMatrix : Matrix (Sum X X) (Sum X X) Complex :=
  fun a b =>
    match a, b with
    | Sum.inl l, Sum.inl l' => if l = l' then 1 else 0
    | Sum.inr r, Sum.inr r' => if r = r' then -1 else 0
    | _, _ => 0

/--
Scalar Higgs/Yukawa flip operator.  The scalar `m` is the post-symmetry-breaking
mass parameter attached to the Yukawa amplitude.
-/
def scalarYukawaFlipOperator (m : Complex) :
    Matrix (Sum X X) (Sum X X) Complex :=
  offDiagonal (X := X)
    (m • (1 : Matrix X X Complex))
    (m • (1 : Matrix X X Complex))

/-! ## Aristotle proof targets -/

/-- Every physical finite Yukawa flip is gauge-legal. -/
theorem physicalYukawaFlip_gaugeLegal (v : YukawaFlip) :
    CandidateGaugeLegal (candidateOfYukawaFlip v) := by
  cases v <;>
    exact ⟨⟨rfl, rfl⟩, ⟨rfl, rfl, rfl⟩, rfl, by norm_num [CandidateYukawaVertex.hyperchargeDefect,
      candidateOfYukawaFlip, multipletHypercharge, higgsHypercharge,
      YukawaFlip.leftMultiplet, YukawaFlip.rightMultiplet, YukawaFlip.higgsInsertion]⟩

/--
The finite candidate predicate picks out exactly the physical Yukawa flips.
-/
theorem candidateGaugeLegal_iff_exists_yukawaFlip (c : CandidateYukawaVertex) :
    CandidateGaugeLegal c <-> exists v : YukawaFlip, c = candidateOfYukawaFlip v := by
  constructor;
  · rintro ⟨ h1, h2, h3, h4 ⟩;
    rcases c with ⟨ l, r, h ⟩;
    cases l <;> cases r <;> cases h <;> simp_all +decide [ CandidateYukawaVertex.ChiralityLegal, CandidateYukawaVertex.WeakLegal, CandidateYukawaVertex.ColorNeutral ];
    all_goals unfold CandidateYukawaVertex.hyperchargeDefect at h4; norm_num [ multipletHypercharge, higgsHypercharge ] at h4;
    · exact ⟨ YukawaFlip.upQuark, rfl ⟩;
    · exact ⟨ YukawaFlip.downQuark, rfl ⟩;
    · exact ⟨ YukawaFlip.chargedLepton, rfl ⟩;
    · exact ⟨ YukawaFlip.neutrino, rfl ⟩;
  · rintro ⟨ v, rfl ⟩ ; exact physicalYukawaFlip_gaugeLegal v;

/-- The scalar Yukawa flip operator is odd for chirality. -/
theorem scalarYukawaFlipOperator_anticommutes_chirality (m : Complex) :
    chiralityMatrix (X := X) * scalarYukawaFlipOperator (X := X) m +
      scalarYukawaFlipOperator (X := X) m * chiralityMatrix (X := X) = 0 := by
  unfold chiralityMatrix scalarYukawaFlipOperator
  ext a b
  simp +decide [Matrix.mul_apply, Matrix.add_apply]
  cases a <;> cases b <;> simp +decide [offDiagonal]

/-- The scalar Yukawa flip operator squares to the scalar mass block. -/
theorem scalarYukawaFlipOperator_sq_eq_massSq (m : Complex) :
    scalarYukawaFlipOperator (X := X) m *
      scalarYukawaFlipOperator (X := X) m =
      (m * m) • (1 : Matrix (Sum X X) (Sum X X) Complex) := by
  ext a b
  cases a <;> cases b <;>
    simp +decide [scalarYukawaFlipOperator, offDiagonal, Matrix.mul_apply,
      Matrix.one_apply, mul_comm]

/--
A gauge-legal candidate supplies a physical finite Yukawa channel together with
the odd first-order mass operator expected by the null-edge interpretation.
-/
theorem legalCandidate_has_yukawaMassOperator
    (c : CandidateYukawaVertex) (hc : CandidateGaugeLegal c) (m : Complex) :
    exists v : YukawaFlip,
      c = candidateOfYukawaFlip v /\
      scalarYukawaFlipOperator (X := X) m *
        scalarYukawaFlipOperator (X := X) m =
          (m * m) • (1 : Matrix (Sum X X) (Sum X X) Complex) /\
      chiralityMatrix (X := X) * scalarYukawaFlipOperator (X := X) m +
        scalarYukawaFlipOperator (X := X) m * chiralityMatrix (X := X) = 0 := by
  convert candidateGaugeLegal_iff_exists_yukawaFlip c |>.1 hc |> Exists.imp fun v => ?_;
  exact fun h => ⟨ h, scalarYukawaFlipOperator_sq_eq_massSq m, scalarYukawaFlipOperator_anticommutes_chirality m ⟩

end NullEdgeYukawaMassOperator

end
