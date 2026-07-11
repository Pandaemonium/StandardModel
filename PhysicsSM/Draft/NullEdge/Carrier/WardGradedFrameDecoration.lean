import PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization

/-!
# A charge-derived flag block for the finite Ward quotient

The separately built `WardQuotientFactorization` module proves that
physical-line compression classifies charge-commuting maps modulo constraint
homotopy in this concrete finite model. This module retains two additional
pieces: the grading separating the two-dimensional constraint block from the
physical line, and the induced action on the ordered charge flag.

For grading-preserving charge-commuting maps, the physical-line action together
with the retained block reads off all three surviving matrix coordinates. This
coordinate completeness is not by itself structural. The additional theorem
below identifies the block intrinsically as an intertwiner of the nilpotent
charge restricted to its two-step flag. The existing imaginary shear then
shows that physical compression forgets this charge-flag action.

Scope: this is an exact finite decorated-Ward theorem. The flag subspace and
its ordering are tied to the displayed charge matrix, but are not derived from
graph locality or continuum soldering, and the result does not classify full
decorated null-edge carriers.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Carrier.WardGradedFrameDecoration

open WardAutomorphismQuotient WardQuotientFactorization

abbrev Mat3 := Matrix (Fin 3) (Fin 3) Complex

/-- The two constraint directions are odd and the surviving physical line is
even. -/
def grading : Mat3 := !![-1, 0, 0; 0, -1, 0; 0, 0, 1]

/-- Inclusion of the ordered two-vector null frame. -/
def nullI : Matrix (Fin 3) (Fin 2) Complex := !![1, 0; 0, 1; 0, 0]

/-- Projection onto the ordered two-vector null frame. -/
def nullP : Matrix (Fin 2) (Fin 3) Complex := !![1, 0, 0; 0, 1, 0]

/-- Preservation of the supplied constraint/physical grading. -/
def PreservesGrading (U : Mat3) : Prop := U * grading = grading * U

/-- The action retained on the ordered null frame. -/
def nullFrameAction (U : Mat3) : Matrix (Fin 2) (Fin 2) Complex :=
  nullP * U * nullI

/-- The nilpotent charge restricted to the ordered two-step flag. -/
def restrictedCharge : Matrix (Fin 2) (Fin 2) Complex :=
  nullP * Q * nullI

/-- In the charge-selected ordering, the restricted charge sends the second
flag vector to the first and kills the first. -/
theorem restrictedCharge_eq : restrictedCharge = !![0, 1; 0, 0] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [restrictedCharge, nullP, nullI, Q, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- The decorated observable retains both physical-line action and null-frame
action. -/
def decoratedAction (U : Mat3) :=
  (physP * U * physI, nullFrameAction U)

/-- Inside the charge-commuting Ward family, grading preservation removes
exactly the two off-block coordinates. -/
theorem wardFamily_preservesGrading_iff (a b c d e : Complex) :
    PreservesGrading (wardFamily a b c d e) ↔ c = 0 ∧ d = 0 := by
  constructor
  · intro h
    have h02 := congrFun (congrFun h (0 : Fin 3)) (2 : Fin 3)
    have h21 := congrFun (congrFun h (2 : Fin 3)) (1 : Fin 3)
    constructor
    · simp [grading, wardFamily, Matrix.mul_apply,
        Fin.sum_univ_succ] at h02
      linear_combination (1 / 2 : Complex) * h02
    · simp [grading, wardFamily, Matrix.mul_apply,
        Fin.sum_univ_succ] at h21
      linear_combination (-1 / 2 : Complex) * h21
  · rintro ⟨rfl, rfl⟩
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [grading, wardFamily, Matrix.mul_apply,
        Fin.sum_univ_succ]

/-- Exact null-frame block of a grading-preserving Ward-family element. -/
theorem nullFrameAction_family (a b e : Complex) :
    nullFrameAction (wardFamily a b 0 0 e) = !![a, b; 0, a] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [nullFrameAction, nullP, nullI, wardFamily, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- Every charge-commuting endomorphism induces an intertwiner of the charge's
own two-step flag. This is the structural content behind the retained block. -/
theorem nullFrameAction_commutes_restrictedCharge_of_chain
    (U : Mat3) (hUQ : U * Q = Q * U) :
    nullFrameAction U * restrictedCharge =
      restrictedCharge * nullFrameAction U := by
  obtain ⟨a, b, c, d, e, rfl⟩ := (commutes_Q_iff_family U).1 hUQ
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [nullFrameAction, restrictedCharge, nullP, nullI, Q, wardFamily,
      Matrix.mul_apply, Fin.sum_univ_succ]

/-- The intertwiners of the restricted nilpotent charge are exactly the
two-parameter upper-triangular Jordan blocks. -/
theorem commutes_restrictedCharge_iff
    (A : Matrix (Fin 2) (Fin 2) Complex) :
    A * restrictedCharge = restrictedCharge * A ↔
      ∃ a b : Complex, A = !![a, b; 0, a] := by
  constructor
  · intro h
    have h00 := congrFun (congrFun h (0 : Fin 2)) (0 : Fin 2)
    have h01 := congrFun (congrFun h (0 : Fin 2)) (1 : Fin 2)
    refine ⟨A 0 0, A 0 1, ?_⟩
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [restrictedCharge, nullP, nullI, Q, Matrix.mul_apply,
        Fin.sum_univ_succ] at h00 h01 ⊢ <;>
      simp_all
  · rintro ⟨a, b, rfl⟩
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [restrictedCharge, nullP, nullI, Q, Matrix.mul_apply,
        Fin.sum_univ_succ]

@[simp] theorem nullFrameAction_one : nullFrameAction (1 : Mat3) = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [nullFrameAction, nullP, nullI, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- On the graded charge-commuting family, `decoratedAction` records the three
surviving scalars: the physical scalar and the two coordinates of the
charge-intertwining flag block. This is literal coordinate read-off, not a
classification of intrinsic graph or soldering data. -/
theorem eq_iff_same_decoratedAction_of_graded_chain
    (U V : Mat3)
    (hUQ : U * Q = Q * U) (hVQ : V * Q = Q * V)
    (hUG : PreservesGrading U) (hVG : PreservesGrading V) :
    U = V ↔ decoratedAction U = decoratedAction V := by
  constructor
  · exact fun h => congrArg decoratedAction h
  · intro hdec
    obtain ⟨a, b, c, d, e, rfl⟩ := (commutes_Q_iff_family U).1 hUQ
    obtain ⟨a', b', c', d', e', rfl⟩ := (commutes_Q_iff_family V).1 hVQ
    rw [wardFamily_preservesGrading_iff] at hUG hVG
    rcases hUG with ⟨rfl, rfl⟩
    rcases hVG with ⟨rfl, rfl⟩
    have hphys := congrArg Prod.fst hdec
    have hnull := congrArg Prod.snd hdec
    change physP * wardFamily a b 0 0 e * physI =
      physP * wardFamily a' b' 0 0 e' * physI at hphys
    change nullFrameAction (wardFamily a b 0 0 e) =
      nullFrameAction (wardFamily a' b' 0 0 e') at hnull
    rw [physical_compression_family, physical_compression_family] at hphys
    rw [nullFrameAction_family, nullFrameAction_family] at hnull
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [wardFamily] at hphys hnull ⊢ <;>
      grind

/-- The inherited imaginary shear is invisible on the physical line and
constraint-exact, but the retained null frame detects it. -/
theorem exact_shear_changes_nullFrame :
    let U := wardFamily 1 Complex.I 0 0 1
    IsWardAutomorphism U ∧ PreservesGrading U ∧
      WardExactEquivalent U 1 ∧
      physP * U * physI = physP * (1 : Mat3) * physI ∧
      nullFrameAction U ≠ nullFrameAction 1 := by
  let U := wardFamily 1 Complex.I 0 0 1
  rcases nontrivial_exact_class_witness with ⟨hAuto, _, hExact⟩
  refine ⟨hAuto, ?_, hExact, ?_, ?_⟩
  · exact (wardFamily_preservesGrading_iff 1 Complex.I 0 0 1).2 ⟨rfl, rfl⟩
  · rw [physical_compression_family]
    ext i j
    fin_cases i
    fin_cases j
    simp [physP, physI, Matrix.mul_apply, Fin.sum_univ_succ]
  · intro h
    rw [nullFrameAction_family, nullFrameAction_one] at h
    have h01 := congrFun (congrFun h (0 : Fin 2)) (1 : Fin 2)
    norm_num at h01

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardGradedFrameDecoration.commutes_restrictedCharge_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms commutes_restrictedCharge_iff

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardGradedFrameDecoration.nullFrameAction_commutes_restrictedCharge_of_chain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullFrameAction_commutes_restrictedCharge_of_chain

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardGradedFrameDecoration.eq_iff_same_decoratedAction_of_graded_chain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms eq_iff_same_decoratedAction_of_graded_chain

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardGradedFrameDecoration.exact_shear_changes_nullFrame' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exact_shear_changes_nullFrame

end PhysicsSM.Draft.NullEdge.Carrier.WardGradedFrameDecoration
