import PhysicsSM.Spinor.SpinorTenfoldPurity

/-!
# S2 prerequisite bricks 1-2: the exterior-power action on the Fock model

Target statements for the Aristotle job `spin10-ext-action-20260719`.

Context.  The S2 audit (project 25d92b80) rejected a hollow constant
construction and decomposed the real block-homomorphism problem into three
prerequisites; this module states the first two: the COMPOUND-MATRIX
(exterior-power) action of a `5 x 5` matrix on the Fock model
`FockSpinor = Finset (Fin 5) → ℂ`, its unit and multiplicativity
(Cauchy-Binet functoriality), vacuum fixing, and - MANDATORY nonvacuity,
per the run's 9d discipline - the concrete phase action of a nontrivial
diagonal unit on the weak spinor.  (Prerequisite 3, landing the action
inside `evenCliffordGroup`, is a separate later brick.)

Conventions: for `S T : Finset (Fin 5)` with cards equal, the compound
entry is the determinant of the submatrix of `U` with rows `S`, columns
`T` (via the order embeddings `Finset.orderIsoOfFin`); entries with
`S.card ≠ T.card` are zero.

Pre-registered honesty license: if a sign convention in the submatrix
determinant (row/column order) must be fixed for multiplicativity to hold,
fix it ONCE, record it prominently, and keep the nonvacuity payload
exact.  Every `s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

namespace PhysicsSM.Draft.Spin10FockExteriorAction

open PhysicsSM.Spinor.SpinorTenfold

/-- The compound (exterior-power) matrix entry: the minor of `U` on row
set `S` and column set `T` (zero when the cardinalities differ). -/
def compoundEntry (U : Matrix (Fin 5) (Fin 5) ℂ) (S T : Finset (Fin 5)) : ℂ :=
  if h : S.card = T.card then
    Matrix.det (Matrix.of fun (i : Fin S.card) (j : Fin S.card) =>
      U (S.orderIsoOfFin rfl i) (T.orderIsoOfFin h.symm j))
  else 0

/-- The exterior-power action of `U` on the Fock model. -/
def extAction (U : Matrix (Fin 5) (Fin 5) ℂ) (psi : FockSpinor) : FockSpinor :=
  fun S => ∑ T, compoundEntry U S T * psi T

/-
A diagonal compound entry is supported on equal row and column sets,
and its value there is the product of the selected diagonal entries.
-/
lemma compoundEntry_diagonal (d : Fin 5 → ℂ) (S T : Finset (Fin 5)) :
    compoundEntry (Matrix.diagonal d) S T =
      if S = T then ∏ i ∈ S, d i else 0 := by
  split_ifs with h;
  · subst h;
    unfold compoundEntry; simp +decide [ Matrix.det_diagonal ] ;
    rw [ Matrix.det_of_upperTriangular ] <;> norm_num [ Matrix.diagonal ];
    · change (∏ i : Fin S.card, d (S.orderIsoOfFin rfl i)) = ∏ i ∈ S, d i
      rw [Fintype.prod_equiv (S.orderIsoOfFin rfl)
          (fun i => d (S.orderIsoOfFin rfl i)) (fun i : S => d i) (fun _ => rfl)]
      exact Finset.prod_attach S d
    · intro i j hij; aesop;
  · by_cases h' : S.card = T.card <;> simp_all +decide [ compoundEntry ];
    obtain ⟨i, hiS, hiT⟩ : ∃ i ∈ S, i ∉ T := by
      by_contra hn
      push_neg at hn
      have hsub : S ⊆ T := fun i hi => hn i hi
      exact h (Finset.eq_of_subset_of_card_le hsub (by omega))
    obtain ⟨ k, hk ⟩ := Finset.mem_image.mp ( show i ∈ Finset.image ( fun k : Fin S.card => S.orderEmbOfFin rfl k ) Finset.univ from by aesop ) ; simp_all +decide [ Matrix.diagonal ] ;
    rw [ Matrix.det_eq_zero_of_row_eq_zero k ] ; aesop

/-
The action on a wedge-basis vector is the corresponding compound column.
-/
lemma extAction_basisSpinor (U : Matrix (Fin 5) (Fin 5) ℂ)
    (T : Finset (Fin 5)) :
    extAction U (basisSpinor T) = fun S => compoundEntry U S T := by
  funext S; simp [extAction, basisSpinor]

/-
Unit law: the identity matrix acts as the identity.
-/
theorem extAction_one (psi : FockSpinor) : extAction 1 psi = psi := by
  ext S
  simp [extAction, ← Matrix.diagonal_one, compoundEntry_diagonal]


/-- **Cauchy-Binet functoriality (the crux).**  The exterior action of a
product is the composite of the actions. -/
theorem extAction_mul (U V : Matrix (Fin 5) (Fin 5) ℂ) (psi : FockSpinor) :
    extAction (U * V) psi = extAction U (extAction V psi) := by
  sorry

/-- The vacuum is fixed by every action (the empty minor is `1`). -/
theorem extAction_vacuum (U : Matrix (Fin 5) (Fin 5) ℂ) :
    extAction U vacuumSpinor = vacuumSpinor := by
  sorry

/-- The concrete nontrivial diagonal unit: phase `c` on mode `3`. -/
def diagPhase3 (c : ℂ) : Matrix (Fin 5) (Fin 5) ℂ :=
  Matrix.diagonal (fun i => if i = 3 then c else 1)

/-
**MANDATORY nonvacuity payload.**  The phase-3 diagonal unit
multiplies the weak spinor (`{3,4}` wedge) by exactly `c` - the action is
NOT trivial, and the weak spinor is an eigenvector with the concrete
eigenvalue.
-/
theorem extAction_diagPhase3_weak (c : ℂ) :
    extAction (diagPhase3 c) weakSpinor = c • weakSpinor := by
  convert extAction_basisSpinor ( diagPhase3 c ) { 3, 4 } using 1;
  ext S; simp +decide [ compoundEntry_diagonal, diagPhase3, weakSpinor ] ;
  unfold basisSpinor; aesop;

/-
Nonvacuity control: the same unit moves the `{0, 3}` basis spinor by
`c` as well, while fixing the pure-colour `{0, 1}` spinor - the action
distinguishes weak content.
-/
theorem extAction_diagPhase3_control :
    extAction (diagPhase3 (2 : ℂ)) (basisSpinor ({0, 1} : Finset (Fin 5)))
      = basisSpinor ({0, 1} : Finset (Fin 5)) := by
  convert extAction_basisSpinor _ _ using 1;
  ext S; simp +decide [ compoundEntry_diagonal, diagPhase3 ] ;
  fin_cases S <;> simp +decide [ basisSpinor ]

end PhysicsSM.Draft.Spin10FockExteriorAction
