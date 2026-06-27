import Mathlib
import PhysicsSM.Draft.NullEdgeCanonicalSpeciesSelector

/-!
# K3: origin of the Krein branch lock — a no-go with a sharp orientation characterization

C65 (`NullEdgeCanonicalSpeciesSelector`) proved the physical-species selector is
canonical **relative to the locked Krein-sign data**, and that it is *not*
determined by chirality / taste / energy / grading alone.  K3 asks the deeper
question: can the Krein-sign assignment **itself** be derived from a deeper
structure (retarded/advanced sheet orientation, causal orientation, a preferred
covector, a charge-conjugation/reflection structure, or the dual-soldered frame
convention)?

## What actually fixes the Krein signs

The branch Krein signature is, by definition (C22),
`branchKreinSig a = tr(J · P_a)` for the modeled fundamental symmetry
`J = kreinJ`.  So the Krein-sign assignment is *exactly* the diagonal of the
chosen fundamental symmetry on the branch corners.  Deriving the Krein lock means
deriving `kreinJ` (or at least its branch diagonal) from deeper data; a no-go
means exhibiting an equally-valid fundamental symmetry — one preserving every
currently formalized structural relation — that carries a different branch
pattern.

A *fundamental symmetry* is, intrinsically, only required to be a self-adjoint
involution.  All the structural relations the program records for `kreinJ` are:

* it is an involution: `J * J = 1`;
* it is symmetric (self-adjoint for the real form): `Jᵀ = J`;
* it preserves the branch decomposition: `J * P_a = P_a * J` for all `a`;
* it preserves the spacetime-chirality grading: `J * Γ_s = Γ_s * J`.

These are bundled in `IsBranchFundamentalSymmetry`.  `kreinJ` satisfies them
(`kreinJ_isFund`).  They are exactly the data available about the Krein metric in
the current tree.

## The no-go (this module)

1. **Orientation flip.**  `-kreinJ` is *also* a branch fundamental symmetry
   (`negKreinJ_isFund`) but flips every branch Krein sign
   (`negKreinJ_pattern`), moving the retained maximal Krein-positive sector from
   `{0, 2}` to `{1, 3}` (`negKreinJ_selector_eq`).  The flip `J ↦ -J` is exactly
   the exchange of the two doubling sheets (retarded ↔ advanced / positive ↔
   negative energy): the global orientation of the fundamental symmetry is a free
   sign not fixed by any formalized datum.

2. **Total freedom of the pattern.**  For *every* sign assignment
   `ε : Fin 4 → ℝ` with `ε a ∈ {±1}` there is a branch fundamental symmetry
   `Jof ε` realizing it: `tr(Jof ε · P_a) = ε a` (`Jof_isFund`,
   `Jof_pattern`).  Hence the branch Krein pattern is **completely unconstrained**
   by the formalized structural relations — all `2⁴` patterns occur, including the
   trivial `(+,+,+,+)` (no Krein indefiniteness at all) and every `2+2` split
   (the C45/C46 species modulus).  The specific locked pattern `(+,-,+,-)` is one
   choice among these.

3. **No-go statement.**  `krein_assignment_no_go`: there exist two branch
   fundamental symmetries that satisfy *all* the formalized structural relations
   yet induce *different* retained Krein-positive sectors.  So the Krein-sign
   assignment is **not derivable** from the currently formalized data.

## The conditional derivation that feeds C65

The single missing datum is an **orientation lock**: a choice declaring which
branch pattern the fundamental symmetry carries (equivalently, which sheet is
Krein-positive).  `OrientationLocked J` says `J` carries the locked branch
pattern `branchKreinSig`.  Under it, the maximal Krein-positive selector is
forced to the canonical `{0, 2}` (`orientationLocked_selector`,
`orientationLocked_feeds_c65`), re-feeding C65 with the orientation datum made
explicit.  This makes precise that C65's "locked Krein data" is *exactly* a
sheet-orientation convention, nothing deeper.

## Gate impact

* **Gate C release (C59):** unaffected.  Gate C consumes the Krein data as a
  locked input; once the orientation is fixed, `{0, 2}` is canonical (C65), and
  the release certificate `ProjectedGateCRelease` is unchanged.
* **Gate F prediction language:** any prediction naming the literal physical pair
  `{0, 2}` without declaring the sheet orientation as locked input inherits the
  full `2⁴`-pattern freedom of (2) (in particular the global flip of (1)).
  Predictions phrased structurally ("the retained sector is the maximal
  Krein-positive pair for the chosen retarded sheet") are safe.
* **Convention / provenance:** the Krein lock is a **convention** (sheet/causal
  orientation), not a theorem of the currently formalized data.  No deeper
  formalized structure (causal orientation operator, preferred covector,
  charge-conjugation, dual-soldered frame) presently pins `kreinJ`'s branch
  diagonal; supplying one would upgrade this no-go to a derivation.

See `AgentTasks/null-edge-k3-krein-lock-origin-report.md`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeKreinLockOrigin

open Matrix
open PhysicsSM.Draft.NullEdgeFlavoredChirality (RMat Idx GammaS kreinJ g5)
open PhysicsSM.Draft.NullEdgeGateCReleaseCriterion (Pbranch)
open PhysicsSM.Draft.NullEdgeBranchKreinSignatures
  (branchKreinSig branchKreinSig_eq Pbranch_trace)
open PhysicsSM.Draft.NullEdgeKreinPositiveReleaseCriterion (physSel physSel_eq)

/-! ## Branch fundamental symmetries: the formalized data about the Krein metric -/

/-- A **branch fundamental symmetry**: a self-adjoint involution preserving the
branch decomposition and the spacetime-chirality grading.  These are *exactly*
the structural relations the current tree records for the modeled Krein metric
`kreinJ`; any `J` satisfying them is, structurally, an equally valid Krein
metric. -/
def IsBranchFundamentalSymmetry (J : RMat) : Prop :=
  J * J = 1 ∧ Jᵀ = J ∧ (∀ a, J * Pbranch a = Pbranch a * J) ∧ J * GammaS = GammaS * J

/-- The branch Krein pattern induced by a fundamental symmetry `J`:
`a ↦ tr(J · P_a)`.  For `J = kreinJ` this is the locked `branchKreinSig`. -/
def branchKreinPattern (J : RMat) (a : Fin 4) : ℝ := (J * Pbranch a).trace

/-- The retained-sector selector induced by `J`: retain the Krein-positive
branches of `J`. -/
def kreinSelectorOf (J : RMat) : Fin 4 → Bool := fun a => decide (branchKreinPattern J a = 1)

/-- For the modeled metric, the induced pattern is the locked branch signature. -/
theorem branchKreinPattern_kreinJ : branchKreinPattern kreinJ = branchKreinSig := rfl

/-- For the modeled metric, the induced selector is the C65 physical selector. -/
theorem kreinSelectorOf_kreinJ : kreinSelectorOf kreinJ = physSel := rfl

/-! ## `kreinJ` is a branch fundamental symmetry -/

/-
The modeled Krein metric satisfies every formalized structural relation.
-/
theorem kreinJ_isFund : IsBranchFundamentalSymmetry kreinJ := by
  refine' ⟨ _, _, _, _ ⟩ <;> norm_num [ kreinJ ];
  · ext i j ; aesop;
  · unfold Pbranch; norm_num [ mul_comm ] ;
  · ext i j ; by_cases hi : i = j <;> simp +decide [ hi, GammaS ]

/-! ## 1. The orientation flip `J ↦ -J` -/

/-
The orientation flip `-kreinJ` is *also* a branch fundamental symmetry.
-/
theorem negKreinJ_isFund : IsBranchFundamentalSymmetry (-kreinJ) := by
  constructor <;> norm_num [ IsBranchFundamentalSymmetry ];
  · exact kreinJ_isFund.1;
  · exact ⟨ kreinJ_isFund.2.1, kreinJ_isFund.2.2.1, kreinJ_isFund.2.2.2 ⟩

/-
The orientation flip reverses every branch Krein sign.
-/
theorem negKreinJ_pattern (a : Fin 4) :
    branchKreinPattern (-kreinJ) a = -branchKreinSig a := by
      convert Matrix.trace_neg ( kreinJ * Pbranch a ) using 1;
      unfold branchKreinPattern; norm_num [ Matrix.mul_assoc ] ;

/-
The orientation flip moves the retained sector from `{0,2}` to `{1,3}`.
-/
theorem negKreinJ_selector_eq :
    kreinSelectorOf (-kreinJ) = ![false, true, false, true] := by
      ext a; fin_cases a <;> simp +decide [ kreinSelectorOf, negKreinJ_pattern, branchKreinSig_eq ] ;
      · norm_num;
      · grind

/-! ## 2. Total freedom of the branch Krein pattern -/

/-- The diagonal fundamental symmetry realizing an arbitrary `±1` branch pattern
`ε`: `+ε a` on each branch corner `(a,a)` and `+1` elsewhere. -/
def Jof (ε : Fin 4 → ℝ) : RMat :=
  Matrix.diagonal (fun p => if p.1 = p.2 then ε p.1 else 1)

/-
For any `±1`-valued `ε`, `Jof ε` is a branch fundamental symmetry.
-/
theorem Jof_isFund (ε : Fin 4 → ℝ) (hε : ∀ a, ε a = 1 ∨ ε a = -1) :
    IsBranchFundamentalSymmetry (Jof ε) := by
      refine' ⟨ _, _, _, _ ⟩;
      · ext i j ; by_cases hi : i = j <;> simp +decide [ *, Jof ];
        cases hε j.1 <;> simp +decide [ * ];
        · simp +decide [ hi, Matrix.one_apply ];
        · fin_cases i <;> fin_cases j <;> simp +decide [ * ] at hi ⊢;
      · exact Matrix.diagonal_transpose _;
      · unfold Jof Pbranch; aesop;
      · ext i j; simp +decide [ Jof, GammaS, Matrix.mul_apply, Matrix.diagonal ] ;
        grind +splitIndPred

/-
`Jof ε` realizes exactly the prescribed branch Krein pattern `ε`.
-/
theorem Jof_pattern (ε : Fin 4 → ℝ) (a : Fin 4) :
    branchKreinPattern (Jof ε) a = ε a := by
      fin_cases a <;> simp +decide [ branchKreinPattern, Jof, Pbranch, Matrix.diagonal_mul_diagonal, Matrix.trace ];
      · rw [ Finset.sum_eq_single ( 0, 0 ) ] <;> aesop;
      · rw [ Finset.sum_eq_single ( 1, 1 ) ] <;> aesop;
      · rw [ Finset.sum_eq_single ( 2, 2 ) ] <;> aesop;
      · rw [ Finset.sum_eq_single ( 3, 3 ) ] <;> aesop

/-! ## 3. The no-go -/

/-- **No-go.**  There are two branch fundamental symmetries — both satisfying every
formalized structural relation about the Krein metric — inducing *different*
retained Krein-positive sectors.  Hence the Krein-sign assignment is **not
determined** by the currently formalized data; it requires an external
sheet/causal orientation choice. -/
theorem krein_assignment_no_go :
    ∃ J₁ J₂ : RMat,
      IsBranchFundamentalSymmetry J₁ ∧ IsBranchFundamentalSymmetry J₂ ∧
      kreinSelectorOf J₁ ≠ kreinSelectorOf J₂ := by
  refine ⟨kreinJ, -kreinJ, kreinJ_isFund, negKreinJ_isFund, ?_⟩
  rw [kreinSelectorOf_kreinJ, negKreinJ_selector_eq]
  intro h
  have h0 := congrFun h 0
  rw [physSel_eq] at h0
  simp at h0

/-- **Stronger no-go.**  Every `±1` branch pattern is realized by a branch
fundamental symmetry; in particular both the locked pattern `(+,-,+,-)` and the
degenerate `(+,+,+,+)` (no Krein indefiniteness) occur, so no formalized datum
selects the locked pattern. -/
theorem krein_pattern_totally_free :
    ∀ ε : Fin 4 → ℝ, (∀ a, ε a = 1 ∨ ε a = -1) →
      ∃ J : RMat, IsBranchFundamentalSymmetry J ∧ branchKreinPattern J = ε :=
  fun ε hε => ⟨Jof ε, Jof_isFund ε hε, funext (Jof_pattern ε)⟩

/-! ## The conditional derivation that feeds C65 -/

/-- An **orientation lock**: the fundamental symmetry carries the locked branch
pattern `branchKreinSig` (i.e. the retarded sheet is declared Krein-positive).
This is the single datum missing from the no-go. -/
def OrientationLocked (J : RMat) : Prop := branchKreinPattern J = branchKreinSig

/-- `kreinJ` is orientation-locked (by construction it realizes the locked
pattern). -/
theorem kreinJ_orientationLocked : OrientationLocked kreinJ := rfl

/-- **Conditional derivation.**  Under an orientation lock, the induced retained
selector is forced to the canonical physical selector `physSel = {0,2}`. -/
theorem orientationLocked_selector (J : RMat) (h : OrientationLocked J) :
    kreinSelectorOf J = physSel := by
  unfold kreinSelectorOf physSel branchKreinPattern OrientationLocked at *
  funext a
  rw [show (J * Pbranch a).trace = branchKreinSig a from congrFun h a]

/-- **Feeds C65.**  Under an orientation lock the retained sector equals the
canonical `{0, 2}` pair, exactly the C65 selector. -/
theorem orientationLocked_feeds_c65 (J : RMat) (h : OrientationLocked J) :
    kreinSelectorOf J = ![true, false, true, false] := by
  rw [orientationLocked_selector J h, physSel_eq]

/-! ## Verdict -/

/-- **K3 verdict.**  A compact record of the Krein-lock origin audit:

* (no-go) two structurally-valid fundamental symmetries give different retained
  sectors — the Krein assignment is not determined by the formalized data;
* (total freedom) every `±1` branch pattern is realized by a fundamental
  symmetry;
* (orientation lock) supplying the sheet-orientation datum forces the canonical
  `{0, 2}` selector, re-feeding C65. -/
theorem k3_verdict :
    (∃ J₁ J₂ : RMat,
        IsBranchFundamentalSymmetry J₁ ∧ IsBranchFundamentalSymmetry J₂ ∧
        kreinSelectorOf J₁ ≠ kreinSelectorOf J₂) ∧
    (∀ ε : Fin 4 → ℝ, (∀ a, ε a = 1 ∨ ε a = -1) →
        ∃ J : RMat, IsBranchFundamentalSymmetry J ∧ branchKreinPattern J = ε) ∧
    (∀ J : RMat, OrientationLocked J → kreinSelectorOf J = ![true, false, true, false]) :=
  ⟨krein_assignment_no_go, krein_pattern_totally_free, orientationLocked_feeds_c65⟩

end PhysicsSM.Draft.NullEdgeKreinLockOrigin
