import PhysicsSM.Spinor.CheckerboardDynamics
import PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle
import PhysicsSM.Draft.CausalDiamondHigherGaugeAristotle
import PhysicsSM.Draft.TwistorPluckerMass
import PhysicsSM.Draft.NullEdgeYukawaGaugeAristotle
import PhysicsSM.Draft.NullEdgeCochainDiamond

/-!
# Draft.NullEdgeOvernightSynthesisAristotle

An intentionally ambitious overnight Aristotle handoff for the null-edge
causal graph research program.

This file does not add trusted results.  It collects finite theorem targets
that would substantially strengthen the program if Aristotle can discharge
them:

1. stacked causal-diamond defects as a finite non-Abelian/Abelian Stokes
   theorem;
2. endpoint gauge covariance for abstract path-pair defects;
3. projective and massless-collinearity structure for multi-twistor charts;
4. a finite classifier saying that Standard-Model-like Yukawa legality picks
   out exactly the four one-generation flip channels;
5. all-`q` checkerboard closed forms packaged as a directed endpoint kernel;
6. cochain language around the order-complex seed theorem.

All statements below are finite algebra, finite combinatorics, or exact
bookkeeping.  They deliberately avoid continuum limits, smooth gauge fields,
twistor cohomology, and dynamical mass-generation claims.

Aristotle guidance:
- Do not weaken statements merely to close a proof.
- Helper lemmas in this file are welcome.
- Prefer induction on lists for the stacked-diamond targets.
- Prefer finite case splits for the Yukawa classifier.
- Prefer existing theorem names from imported modules before reproving facts.
- This file is draft-only while it contains `sorry`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeOvernightSynthesis

open Matrix Complex
open PhysicsSM.Gauge.CausalDiamondHolonomy
open PhysicsSM.Draft.CausalDiamondHigherGauge
open PhysicsSM.Spinor.Checkerboard
open PhysicsSM.Spinor.Checkerboard.Direction
open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.TwistorPluckerMass
open PhysicsSM.Draft.CheckerboardKernelClosedForms
open PhysicsSM.StandardModel.OneGenerationTable
open PhysicsSM.Draft.NullEdgeYukawaFlip
open PhysicsSM.Draft.NullEdgeYukawaGauge
open PhysicsSM.Draft.NullEdgeCochainDiamond

/-! ## 1. Stacked causal diamonds: finite Stokes targets -/

variable {G : Type*}

/-- A flat path pair with identical left and right branch holonomies. -/
def flatPathPair [One G] (h : G) : PathPair G where
  left := h
  right := h

/-- The identity path pair used as the empty vertical stack. -/
def identityPathPair [One G] : PathPair G :=
  flatPathPair (1 : G)

/--
Vertical stack of path pairs.  The list order is bottom to top: `P :: Ps`
means traverse `P` first, then the already-stacked upper part `Ps`.
-/
def verticalStack [Monoid G] : List (PathPair G) -> PathPair G
  | [] => identityPathPair
  | P :: Ps => verticalComposePathPair P (verticalStack Ps)

/--
The ordered non-Abelian product of transported cell defects for a vertical
stack.  The defect of a lower cell is transported through the total left
branch above it.
-/
def transportedDefectProduct [Group G] : List (PathPair G) -> G
  | [] => 1
  | P :: Ps =>
      transportDefect (verticalStack Ps).left (pathPairDefect P)
        * transportedDefectProduct Ps

/-
A flat path pair has trivial defect.
-/
theorem pathPairDefect_flatPathPair [Group G] (h : G) :
    pathPairDefect (flatPathPair h) = 1 := by
  unfold pathPairDefect flatPathPair; simp +decide ;

/-
Finite non-Abelian vertical Stokes theorem for stacked causal diamonds:
the boundary defect of the stack is the ordered product of transported
cell defects.
-/
theorem pathPairDefect_verticalStack_transport [Group G]
    (Ps : List (PathPair G)) :
    pathPairDefect (verticalStack Ps) = transportedDefectProduct Ps := by
  induction' Ps with P Ps ih <;> simp_all +decide [ verticalStack, transportedDefectProduct ];
  · exact pathPairDefect_flatPathPair 1
  · convert PhysicsSM.Gauge.CausalDiamondHolonomy.pathPairDefect_verticalCompose P ( verticalStack Ps ) using 1 ; aesop

/-
Finite Abelian vertical Stokes theorem: in a commutative gauge group, all
transport corrections disappear and the stack defect is the product of the
individual cell defects.
-/
theorem pathPairDefect_verticalStack_comm [CommGroup G]
    (Ps : List (PathPair G)) :
    pathPairDefect (verticalStack Ps) =
      (Ps.map fun P => pathPairDefect P).prod := by
  induction Ps <;> simp_all +decide [ List.prod_cons ];
  · exact pathPairDefect_flatPathPair 1
  · rename_i P Ps ih;
    rw [ ← ih, show verticalStack ( P :: Ps ) = verticalComposePathPair P ( verticalStack Ps ) from rfl, pathPairDefect_verticalCompose_comm ]

/-
A stack of flat path pairs has trivial total defect.
-/
theorem pathPairDefect_verticalStack_eq_one_of_all_flat [Group G]
    (Ps : List (PathPair G))
    (hPs : ∀ P ∈ Ps, pathPairDefect P = 1) :
    pathPairDefect (verticalStack Ps) = 1 := by
  induction' Ps with P Ps ih;
  · exact pathPairDefect_flatPathPair 1
  · rw [ show verticalStack ( P :: Ps ) = verticalComposePathPair P ( verticalStack Ps ) from rfl, PhysicsSM.Gauge.CausalDiamondHolonomy.pathPairDefect_verticalCompose, hPs P ( by simp +decide ), ih fun P hP => hPs P ( by simp +decide [ hP ] ) ] ; simp +decide

/-! ## 2. Endpoint gauge covariance for path pairs -/

/-- Endpoint gauge transformation of an abstract path pair. -/
def gaugeTransformPathPair [Group G] (bottom top : G)
    (P : PathPair G) : PathPair G where
  left := bottom⁻¹ * P.left * top
  right := bottom⁻¹ * P.right * top

/-
The path-pair defect is covariant under endpoint gauge transformation; only
the top endpoint gauge survives.
-/
theorem pathPairDefect_gaugeTransformPathPair [Group G]
    (bottom top : G) (P : PathPair G) :
    pathPairDefect (gaugeTransformPathPair bottom top P) =
      top⁻¹ * pathPairDefect P * top := by
  unfold gaugeTransformPathPair pathPairDefect;
  group

/-
In an Abelian gauge group, the endpoint-transformed path-pair defect is invariant.
-/
theorem pathPairDefect_gaugeTransformPathPair_comm [CommGroup G]
    (bottom top : G) (P : PathPair G) :
    pathPairDefect (gaugeTransformPathPair bottom top P) =
      pathPairDefect P := by
  simp +decide [ pathPairDefect, gaugeTransformPathPair, mul_assoc ];
  simp +decide [ mul_assoc, mul_comm, mul_left_comm ];
  simp +decide [ mul_left_comm top ]

/-! ## 3. Multi-twistor projective mass targets -/

/-- Independently rescale every chart twistor in a finite multi-twistor chart. -/
def rescaleMultiTwistor {n : Nat} (a : Fin n -> ℂ)
    (Z : MultiTwistorChart n) : MultiTwistorChart n where
  twistor i := rescaleTwistor (a i) (Z.twistor i)

/-- Uniform projective rescaling of a finite multi-twistor chart. -/
def rescaleMultiTwistorConst {n : Nat} (a : ℂ)
    (Z : MultiTwistorChart n) : MultiTwistorChart n :=
  rescaleMultiTwistor (fun _ => a) Z

/-
Independent projective-rescaling law for finite multi-twistor pairwise mass.
Each pair term scales by the squared moduli of the two projective factors.
-/
theorem multiTwistorPairwiseMass_rescale
    {n : Nat} (a : Fin n -> ℂ) (Z : MultiTwistorChart n) :
    multiTwistorPairwiseMass (rescaleMultiTwistor a Z) =
      ∑ p ∈ finPairIndexSet n,
        complexAbsSq (a p.1) * complexAbsSq (a p.2) *
          complexAbsSq
            (infinityTwistorPairing (Z.twistor p.1) (Z.twistor p.2)) := by
  refine' Finset.sum_congr rfl fun p hp => _;
  convert congr_arg complexAbsSq ( PhysicsSM.Draft.TwistorPluckerMass.infinityTwistorPairing_rescale ( a p.1 ) ( a p.2 ) ( Z.twistor p.1 ) ( Z.twistor p.2 ) ) using 1;
  simp +decide [ complexAbsSq, mul_assoc, mul_comm, mul_left_comm ]

/-
Uniform projective rescaling scales finite multi-twistor mass quadratically.
-/
theorem multiTwistorPairwiseMass_rescale_const
    {n : Nat} (a : ℂ) (Z : MultiTwistorChart n) :
    multiTwistorPairwiseMass (rescaleMultiTwistorConst a Z) =
      complexAbsSq a ^ 2 * multiTwistorPairwiseMass Z := by
  convert multiTwistorPairwiseMass_rescale ( fun _ => a ) Z using 1;
  rw [ ← Finset.mul_sum _ _ _, multiTwistorPairwiseMass ] ; ring

/-
Two-twistor mass vanishes exactly when the two momentum spinors are collinear.
-/
theorem twoTwistorMassInvariant_eq_zero_iff_pi_collinear
    (Z W : SpinorChartTwistor)
    (hZ : Z.pi 0 ≠ 0 ∨ Z.pi 1 ≠ 0) :
    twoTwistorMassInvariant Z W = 0 ↔
      ∃ c : ℂ, W.pi = c • Z.pi := by
  constructor <;> intro h;
  · -- By definition of spinorWedge, we have spinorWedge Z.pi W.pi = Z.pi 0 * W.pi 1 - Z.pi 1 * W.pi 0.
    have h_spinorWedge : Z.pi 0 * W.pi 1 - Z.pi 1 * W.pi 0 = 0 := by
      contrapose! h;
      exact mul_ne_zero h ( star_ne_zero.mpr h );
    exact (spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero Z.pi W.pi hZ).mp h_spinorWedge
  · unfold twoTwistorMassInvariant;
    obtain ⟨ c, hc ⟩ := h; simp_all +decide [ infinityTwistorPairing, spinorWedge ] ;
    ring ; norm_num [ complexAbsSq ]

/-
Finite multi-twistor mass vanishes exactly when all momentum spinors share a
common projective direction, assuming the chosen base spinor is nonzero.
-/
theorem multiTwistorPairwiseMass_eq_zero_iff_common_pi_direction
    {n : Nat} (Z : MultiTwistorChart n) (base : Fin n)
    (hbase : (Z.twistor base).pi 0 ≠ 0 ∨ (Z.twistor base).pi 1 ≠ 0) :
    multiTwistorPairwiseMass Z = 0 ↔
      ∃ c : Fin n -> ℂ,
        ∀ i : Fin n, (Z.twistor i).pi = c i • (Z.twistor base).pi := by
  constructor <;> intro h;
  · -- By definition of multiTwistorPairwiseMass, if it is zero, then for all i < j, the wedge of (Z.twistor i).pi and (Z.twistor j).pi is zero.
    have h_wedge_zero : ∀ i j : Fin n, i < j → spinorWedge (Z.twistor i).pi (Z.twistor j).pi = 0 := by
      have h_wedge_zero : ∀ p ∈ finPairIndexSet n, spinorWedge (Z.twistor p.1).pi (Z.twistor p.2).pi = 0 := by
        convert h using 1;
        unfold multiTwistorPairwiseMass; simp +decide [ complexAbsSq_eq_ofReal_normSq ] ;
        norm_cast;
        rw [ Finset.sum_eq_zero_iff_of_nonneg fun _ _ => normSq_nonneg _ ] ; aesop;
      exact fun i j hij => h_wedge_zero ( i, j ) ( Finset.mem_filter.mpr ⟨ Finset.mem_univ _, hij ⟩ );
    have h_collinear : ∀ i : Fin n, ∃ c : ℂ, (Z.twistor i).pi = c • (Z.twistor base).pi := by
      intro i
      by_cases h_cases : i = base;
      · exact ⟨ 1, by simp +decide [ h_cases ] ⟩;
      · have h_collinear : spinorWedge (Z.twistor base).pi (Z.twistor i).pi = 0 := by
          cases lt_or_gt_of_ne h_cases <;> simp_all +decide [ spinorWedge ];
          linear_combination -h_wedge_zero _ _ ‹_›;
        have := twoTwistorMassInvariant_eq_zero_iff_pi_collinear ( Z.twistor base ) ( Z.twistor i ) hbase; simp_all +decide [ twoTwistorMassInvariant ] ;
        exact this.mp ( by rw [ show infinityTwistorPairing ( Z.twistor base ) ( Z.twistor i ) = spinorWedge ( Z.twistor base ).pi ( Z.twistor i ).pi from rfl ] ; exact h_collinear.symm ▸ by norm_num [ complexAbsSq ] );
    exact ⟨ fun i => Classical.choose ( h_collinear i ), fun i => Classical.choose_spec ( h_collinear i ) ⟩;
  · obtain ⟨ c, hc ⟩ := h;
    refine' Finset.sum_eq_zero fun p hp => _;
    unfold infinityTwistorPairing; simp +decide [ hc p.1, hc p.2, spinorWedge ] ;
    ring ; norm_num [ complexAbsSq ]

/-
Determinant-convention multi-twistor massless criterion.
-/
theorem multiTwistorMassSqDetConvention_eq_zero_iff_common_pi_direction
    {n : Nat} (Z : MultiTwistorChart n) (base : Fin n)
    (hbase : (Z.twistor base).pi 0 ≠ 0 ∨ (Z.twistor base).pi 1 ≠ 0) :
    multiTwistorMassSqDetConvention Z = 0 ↔
      ∃ c : Fin n -> ℂ,
        ∀ i : Fin n, (Z.twistor i).pi = c i • (Z.twistor base).pi := by
  convert multiTwistorPairwiseMass_eq_zero_iff_common_pi_direction Z base hbase using 1;
  rw [ PhysicsSM.Draft.TwistorPluckerMass.multiTwistorMassSqDetConvention_eq_pairwiseMass ]

/-
Trace-pairing-convention multi-twistor massless criterion.
-/
theorem multiTwistorMassSqTraceConvention_eq_zero_iff_common_pi_direction
    {n : Nat} (Z : MultiTwistorChart n) (base : Fin n)
    (hbase : (Z.twistor base).pi 0 ≠ 0 ∨ (Z.twistor base).pi 1 ≠ 0) :
    multiTwistorMassSqTraceConvention Z = 0 ↔
      ∃ c : Fin n -> ℂ,
        ∀ i : Fin n, (Z.twistor i).pi = c i • (Z.twistor base).pi := by
  convert multiTwistorPairwiseMass_eq_zero_iff_common_pi_direction Z base hbase using 1;
  unfold multiTwistorMassSqTraceConvention; simp +decide [ mul_eq_zero ] ;
  rw [ multi_twistor_momentum_det_eq_pairwiseMass ]

/-! ## 4. Finite classifier for Standard-Model-like Yukawa legality -/

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

/-
Every table Yukawa flip gives a legal candidate vertex.
-/
theorem candidateOfYukawaFlip_gaugeLegal (v : YukawaFlip) :
    CandidateGaugeLegal (candidateOfYukawaFlip v) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact ⟨leftMultiplet_chirality_left v, rightMultiplet_chirality_right v⟩
  · exact weakYukawaPattern_all v
  · exact colorNeutralPattern_all v
  · dsimp [CandidateYukawaVertex.hyperchargeDefect, candidateOfYukawaFlip]
    rw [higgsInsertion_hypercharge_matches]
    exact YukawaFlip.hyperchargeDefect_eq_zero v

/-
Finite classifier: the Standard-Model-like candidate legality predicate picks
out exactly the four one-generation Yukawa flip channels.
-/
theorem candidateGaugeLegal_iff_exists_yukawaFlip
    (c : CandidateYukawaVertex) :
    CandidateGaugeLegal c ↔
      ∃ v : YukawaFlip, c = candidateOfYukawaFlip v := by
  constructor <;> intro hc;
  · rcases hc with ⟨hcL, hcR, hcH⟩;
    obtain ⟨hL, hR⟩ := hcL;
    rcases c with ⟨ left, right, higgsIns ⟩;
    cases left <;> cases right <;> cases higgsIns <;> simp_all +decide only [CandidateYukawaVertex.hyperchargeDefect];
    all_goals norm_num [ PhysicalMultiplet.hypercharge, HiggsInsertion.hypercharge ] at hcH;
    · exact ⟨ YukawaFlip.upQuark, rfl ⟩;
    · exact ⟨ YukawaFlip.downQuark, rfl ⟩;
    · exact ⟨ YukawaFlip.chargedLepton, rfl ⟩;
    · exact ⟨ YukawaFlip.neutrino, rfl ⟩;
  · obtain ⟨ v, rfl ⟩ := hc; exact candidateOfYukawaFlip_gaugeLegal v;

/-! ## 5. Checkerboard endpoint closed forms packaged for all `q` -/

/-- Right-starting, right-terminal closed form including the straight boundary case. -/
def rrClosedForm [Semiring S] (mu : S) (p q : Nat) : S :=
  if q = 0 then
    1
  else
    ∑ r ∈ Finset.Icc 1 (p + q),
      ((p.choose r * (q - 1).choose (r - 1) : Nat) : S) * mu ^ (2 * r)

/-- Right-starting, left-terminal closed form including the straight boundary case. -/
def rlClosedForm [Semiring S] (mu : S) (p q : Nat) : S :=
  if q = 0 then
    0
  else
    ∑ r ∈ Finset.range (p + 1),
      ((p.choose r * (q - 1).choose r : Nat) : S) * mu ^ (2 * r + 1)

/-- Directed endpoint kernel for a right-incoming checkerboard path. -/
structure RightStartedEndpointKernel (S : Type*) where
  rightTerminal : S
  leftTerminal : S

/-- Path-sum endpoint kernel for a right-incoming path with `p` right and `q` left steps. -/
def rightStartedPathKernel [Semiring S] (mu : S)
    (p q : Nat) : RightStartedEndpointKernel S where
  rightTerminal :=
    pathSum mu 0 Direction.right (p + q)
      ((p : Int) - (q : Int)) Direction.right
  leftTerminal :=
    pathSum mu 0 Direction.right (p + q)
      ((p : Int) - (q : Int)) Direction.left

/-- Closed-form endpoint kernel for a right-incoming path. -/
def rightStartedClosedKernel [Semiring S] (mu : S)
    (p q : Nat) : RightStartedEndpointKernel S where
  rightTerminal := rrClosedForm mu p q
  leftTerminal := rlClosedForm mu p q

/-
All-`q` right/right endpoint closed form.
-/
theorem pathSum_right_right_closed_form_all [Semiring S]
    (mu : S) (p q : Nat) :
    pathSum mu 0 Direction.right (p + q)
        ((p : Int) - (q : Int)) Direction.right =
      rrClosedForm mu p q := by
  unfold rrClosedForm;
  split_ifs with hq;
  · convert PhysicsSM.Draft.CheckerboardKernelClosedForms.pathSum_right_right_straight mu p;
    · rw [ hq, add_zero ];
    · aesop;
  · exact pathSum_right_right_closed_form mu p q ( Nat.pos_of_ne_zero hq )

/-
All-`q` right/left endpoint closed form.
-/
theorem pathSum_right_left_closed_form_all [Semiring S]
    (mu : S) (p q : Nat) :
    pathSum mu 0 Direction.right (p + q)
        ((p : Int) - (q : Int)) Direction.left =
      rlClosedForm mu p q := by
  by_cases hq : q = 0;
  · convert PhysicsSM.Draft.CheckerboardKernelClosedForms.pathSum_right_left_straight_zero mu p using 1;
    · aesop;
    · unfold rlClosedForm; aesop;
  · convert PhysicsSM.Draft.CheckerboardKernelClosedForms.pathSum_right_left_closed_form mu p q ( Nat.pos_of_ne_zero hq ) using 1;
    unfold rlClosedForm; aesop;

/-
The directed right-starting kernel equals the all-`q` closed-form kernel.
-/
theorem rightStartedPathKernel_eq_closed [Semiring S]
    (mu : S) (p q : Nat) :
    rightStartedPathKernel mu p q = rightStartedClosedKernel mu p q := by
  unfold rightStartedPathKernel rightStartedClosedKernel;
  congr 1 <;> [ exact pathSum_right_right_closed_form_all mu p q; exact pathSum_right_left_closed_form_all mu p q ]

/-! ## 6. Cochain language around the order-complex seed theorem -/

/-- A finite integral cochain whose coboundary vanishes. -/
def IsCocycle {V : Type*} (f : IntegralCochain V) : Prop :=
  cochainCoboundary f = 0

/-- A finite integral cochain that is a coboundary. -/
def IsCoboundary {V : Type*} (f : IntegralCochain V) : Prop :=
  ∃ g : IntegralCochain V, f = cochainCoboundary g

/-
Every coboundary is a cocycle, the first cohomological wrapper around `d^2 = 0`.
-/
theorem coboundary_is_cocycle {V : Type*}
    (f : IntegralCochain V) (hf : IsCoboundary f) :
    IsCocycle f := by
  obtain ⟨ g, rfl ⟩ := hf;
  exact cochainCoboundary_comp_self_eq_zero g

/-- Cohomologous integral cochains differ by a coboundary. -/
def Cohomologous {V : Type*} (f g : IntegralCochain V) : Prop :=
  IsCoboundary (f - g)

/-
Cohomology is reflexive at the finite cochain level.
-/
theorem cohomologous_refl {V : Type*} (f : IntegralCochain V) :
    Cohomologous f f := by
  use 0; simp +decide [ cochainCoboundary ] ;

/-
Cohomology is symmetric at the finite cochain level.
-/
theorem cohomologous_symm {V : Type*} {f g : IntegralCochain V}
    (h : Cohomologous f g) :
    Cohomologous g f := by
  obtain ⟨ k, hk ⟩ := h;
  refine' ⟨ -k, _ ⟩;
  convert congr_arg Neg.neg hk using 1 ; abel_nf

/-
Cohomology is transitive at the finite cochain level.
-/
theorem cohomologous_trans {V : Type*} {f g h : IntegralCochain V}
    (hfg : Cohomologous f g) (hgh : Cohomologous g h) :
    Cohomologous f h := by
  obtain ⟨a, ha⟩ := hfg
  obtain ⟨b, hb⟩ := hgh
  use a + b
  ext c
  simp [cochainCoboundary_apply];
  replace ha := congr_arg ( fun f => f ( Finsupp.single c 1 ) ) ha; replace hb := congr_arg ( fun f => f ( Finsupp.single c 1 ) ) hb; simp_all +decide [ cochainCoboundary_apply ] ;
  lia

end PhysicsSM.Draft.NullEdgeOvernightSynthesis

end
