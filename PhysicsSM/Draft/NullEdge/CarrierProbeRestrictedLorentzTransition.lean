import PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition

/-!
# Proper-orthochronous reduction of carrier-probe transitions

`CarrierProbeOverlapTransition.lean` derives an exact `eta`-orthogonal matrix
from compatible overlap observations and Lorentz-normalized frames.  This file
separates the two remaining discrete choices:

* properness is the determinant condition `det M = 1`;
* orthochronousness is the time-orientation condition `0 <= M 0 0`.

These definitions are a clean-room, matrix-level port of the conventions in
PhysLean's `LorentzGroup.IsProper`, `LorentzGroup.IsOrthochronous`, and
`LorentzGroup.restricted` (`Physlib.Relativity.LorentzGroup.*`).  PhysLean is
consulted for convention alignment but is not imported because its pinned Lean
version differs from this project.

The main finite result is stronger than a mere definition: eta-orthogonality
forces `1 <= |M 0 0|`.  Thus time orientation is a genuinely discrete sign
choice, just like determinant orientation.  Supplied nonnegative signs package
the overlap transition as restricted Lorentz data.  Deriving those signs from
the causal graph, constructing the concrete `SL(2,C)` cover, and proving a
global spin lift remain separate gates.

Claim grade: finite matrix identities are `M [comp]`; the graph derivation of
the sign hypotheses remains open.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition

open Matrix
open AlexandrovAlgebraGerm
open AlexandrovGermInternalOperator
open AlexandrovGermPacking
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace
open OverlapRestrictionTransition
open ProbeFrameLorentzGauge
open RankFourProbeSector
open CarrierProbeOverlapTransition

variable {V : Type} [Fintype V]

/-- Matrix-level membership in `O(1,3)` in the project's mostly-minus
convention. -/
def IsEtaLorentz (M : Matrix (Fin 4) (Fin 4) Real) : Prop :=
  Matrix.transpose M * MinkowskiConvention.eta * M =
    MinkowskiConvention.eta

/-- Matrix-level properness, aligned with PhysLean's determinant convention. -/
def IsProperLorentz (M : Matrix (Fin 4) (Fin 4) Real) : Prop :=
  M.det = 1

/-- Matrix-level orthochronousness, aligned with PhysLean's `00`-entry
convention. -/
def IsOrthochronousLorentz (M : Matrix (Fin 4) (Fin 4) Real) : Prop :=
  0 <= M 0 0

/-- The proper-orthochronous, or restricted, Lorentz conditions on a concrete
four-by-four matrix. -/
def IsRestrictedLorentz (M : Matrix (Fin 4) (Fin 4) Real) : Prop :=
  IsEtaLorentz M /\ IsProperLorentz M /\ IsOrthochronousLorentz M

/-- Bundled restricted Lorentz transition data.  This is deliberately a
matrix-level package, not yet a replacement for a concrete Lie-group or spin
cover implementation. -/
structure RestrictedLorentzTransition where
  matrix : Matrix (Fin 4) (Fin 4) Real
  isRestricted : IsRestrictedLorentz matrix

/-- The time column of an eta-orthogonal matrix has Minkowski norm one. -/
theorem timeTime_sq_eq_one_add_spatial_sq
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M) :
    M 0 0 ^ 2 =
      1 + M 1 0 ^ 2 + M 2 0 ^ 2 + M 3 0 ^ 2 := by
  have h00 := congrFun (congrFun hM 0) 0
  simp [Matrix.mul_apply, Matrix.transpose_apply,
    MinkowskiConvention.eta, Fin.sum_univ_four] at h00
  nlinarith [h00]

/-- In particular, the time-time entry of a Lorentz matrix cannot cross zero:
its absolute value is at least one. -/
theorem one_le_abs_timeTime
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M) :
    1 <= |M 0 0| := by
  rw [<- one_le_sq_iff_one_le_abs]
  have htime := timeTime_sq_eq_one_add_spatial_sq M hM
  nlinarith [sq_nonneg (M 1 0), sq_nonneg (M 2 0), sq_nonneg (M 3 0)]

/-- Time orientation is a discrete sign sector: the time-time entry is at
least one or at most minus one. -/
theorem timeOrientation_split
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M) :
    (1 <= M 0 0 /\ IsOrthochronousLorentz M) \/
      (M 0 0 <= -1 /\ Not (IsOrthochronousLorentz M)) := by
  by_cases htime : 0 <= M 0 0
  · left
    constructor
    · simpa [abs_of_nonneg htime] using one_le_abs_timeTime M hM
    · exact htime
  · right
    have hnonpos : M 0 0 <= 0 := le_of_not_ge htime
    have habs := one_le_abs_timeTime M hM
    rw [abs_of_nonpos hnonpos] at habs
    exact And.intro (by linarith) htime

/-- Eta-orthogonality leaves exactly the two determinant signs. -/
theorem det_eq_one_or_neg_one
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M) :
    M.det = 1 \/ M.det = -1 := by
  have hdet := congrArg Matrix.det hM
  simp only [Matrix.det_mul, Matrix.det_transpose] at hdet
  rw [MinkowskiConvention.eta_det] at hdet
  have hfactor : (M.det - 1) * (M.det + 1) = 0 := by
    nlinarith
  rcases mul_eq_zero.mp hfactor with hplus | hminus
  · left
    linarith
  · right
    linarith

/-- On eta-orthogonal matrices, a nonnegative determinant is necessarily
`+1`. -/
theorem isProper_of_det_nonnegative
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M)
    (hdet : 0 <= M.det) :
    IsProperLorentz M := by
  rcases det_eq_one_or_neg_one M hM with hplus | hminus
  · exact hplus
  · exfalso
    rw [hminus] at hdet
    norm_num at hdet

/-- Nonnegative determinant and nonnegative time-time entry are exactly the
two additional graph-facing gates needed to reduce an eta-orthogonal matrix to
the restricted Lorentz sector. -/
theorem isRestricted_of_nonnegative_signs
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M)
    (hdet : 0 <= M.det) (htime : 0 <= M 0 0) :
    IsRestrictedLorentz M := by
  exact And.intro hM (And.intro
    (isProper_of_det_nonnegative M hM hdet) htime
  )

/-- The graph-derived pair transition lands in the restricted Lorentz sector
once orientation and time-orientation signs are supplied.  The lengthy metric
hypotheses are precisely the finite overlap gate from the predecessor module;
the final two inequalities are the still-open graph-selection gates. -/
theorem pairFrameTransitionMatrix_isRestricted
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (Q : RankFourCarrierProbeSector B)
    (H : PairOverlapCompatible A B P Q)
    (ell nonlocalityScale : Real) (xA : ClosedCarrier A)
    (xB : ClosedCarrier B)
    (overlapForm : LinearMap.BilinForm Real (CarrierOverlap A B -> Real))
    (hleft : sectorBilinForm A P ell nonlocalityScale xA =
      pulledForm overlapForm (leftOverlapRestriction A B P))
    (hright : sectorBilinForm B Q ell nonlocalityScale xB =
      pulledForm overlapForm (rightOverlapRestriction A B Q))
    (b : SectorFrame P) (c : SectorFrame Q)
    (hb : IsSectorLorentzNormalized A P ell nonlocalityScale xA b)
    (hc : IsSectorLorentzNormalized B Q ell nonlocalityScale xB c)
    (hdet : 0 <=
      (pairFrameTransitionMatrix (V := V) (C := C) A B P Q H b c).det)
    (htime : 0 <=
      (pairFrameTransitionMatrix (V := V) (C := C) A B P Q H b c) 0 0) :
    IsRestrictedLorentz
      (pairFrameTransitionMatrix (V := V) (C := C) A B P Q H b c) := by
  apply isRestricted_of_nonnegative_signs
  · exact pairFrameTransitionMatrix_lorentz (V := V) (C := C) A B P Q H ell
      nonlocalityScale xA xB overlapForm hleft hright b c hb hc
  · exact hdet
  · exact htime

/-- Bundled form of `pairFrameTransitionMatrix_isRestricted`, ready to be the
base transition input of a later concrete spin-cover construction. -/
def pairRestrictedLorentzTransition
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (Q : RankFourCarrierProbeSector B)
    (H : PairOverlapCompatible A B P Q)
    (ell nonlocalityScale : Real) (xA : ClosedCarrier A)
    (xB : ClosedCarrier B)
    (overlapForm : LinearMap.BilinForm Real (CarrierOverlap A B -> Real))
    (hleft : sectorBilinForm A P ell nonlocalityScale xA =
      pulledForm overlapForm (leftOverlapRestriction A B P))
    (hright : sectorBilinForm B Q ell nonlocalityScale xB =
      pulledForm overlapForm (rightOverlapRestriction A B Q))
    (b : SectorFrame P) (c : SectorFrame Q)
    (hb : IsSectorLorentzNormalized A P ell nonlocalityScale xA b)
    (hc : IsSectorLorentzNormalized B Q ell nonlocalityScale xB c)
    (hdet : 0 <=
      (pairFrameTransitionMatrix (V := V) (C := C) A B P Q H b c).det)
    (htime : 0 <=
      (pairFrameTransitionMatrix (V := V) (C := C) A B P Q H b c) 0 0) :
    RestrictedLorentzTransition where
  matrix := pairFrameTransitionMatrix (V := V) (C := C) A B P Q H b c
  isRestricted := pairFrameTransitionMatrix_isRestricted A B P Q H ell
    nonlocalityScale xA xB overlapForm hleft hright b c hb hc hdet htime

end PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition.one_le_abs_timeTime' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition.one_le_abs_timeTime

/-- info: 'PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition.timeOrientation_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition.timeOrientation_split

/-- info: 'PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition.det_eq_one_or_neg_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition.det_eq_one_or_neg_one

/-- info: 'PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition.pairFrameTransitionMatrix_isRestricted' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition.pairFrameTransitionMatrix_isRestricted
