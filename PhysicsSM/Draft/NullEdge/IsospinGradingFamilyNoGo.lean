import PhysicsSM.Draft.NullEdge.IsospinGradingSearch

/-!
# The eq-36 grading family no-go (linear span of the killed candidates)

The adjoint action is linear in its grading operator when the graded operator
is additive.  Both ideal operators used below are complex-linear.  Since the
landed computations give the same grades for `X1` and `X2` under both `G_PL`
and `G_R`, every member of their affine span has the same coefficient on the
two operators.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.IsospinGradingFamilyNoGo

open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.CompositionWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakCAR
open PhysicsSM.Draft.NullEdge.CompositionSU2
open PhysicsSM.Draft.NullEdge.CompositionIdealRepContent
open PhysicsSM.Draft.NullEdge.IsospinGradingSearch
open PhysicsSM.Draft.NullEdge.RankOneCore
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem vIdemStar)

set_option maxHeartbeats 64000000

/-- The three-parameter candidate family spanned by the killed generators
and the identity. -/
def famG (a b e : ℂ) (d : Dixon) : Dixon :=
  a • G_PL d + b • G_R d + e • d

/-- Each weak ladder operator is additive. -/
lemma betaHat1_add_local (x y : Dixon) : betaHat1 (x + y) = betaHat1 x + betaHat1 y := by
  simp [betaHat1, R1_add, R2_add, coT3_add, smul_add]
  module

lemma betaHat2_add_local (x y : Dixon) : betaHat2 (x + y) = betaHat2 x + betaHat2 y := by
  simp [betaHat2, R1_add, coOmD_add, smul_add]

lemma betaHat1dag_add_local (x y : Dixon) :
    betaHat1dag (x + y) = betaHat1dag x + betaHat1dag y := by
  simp [betaHat1dag, R1_add, R2_add, coT3_add, smul_add]
  module

lemma betaHat2dag_add_local (x y : Dixon) :
    betaHat2dag (x + y) = betaHat2dag x + betaHat2dag y := by
  simp [betaHat2dag, R1_add, coOm_add, smul_add]

lemma vwHat_add_local (x y : Dixon) : vwHat (x + y) = vwHat x + vwHat y := by
  simp only [vwHat, betaHat1_add_local, betaHat2_add_local,
    betaHat1dag_add_local, betaHat2dag_add_local]

/-- Each weak ladder operator commutes with complex scalar action. -/
lemma betaHat1_smul_local (c : ℂ) (x : Dixon) : betaHat1 (c • x) = c • betaHat1 x := by
  simp [betaHat1, R1_smul, R2_smul, coT3_smul]
  module

lemma betaHat2_smul_local (c : ℂ) (x : Dixon) : betaHat2 (c • x) = c • betaHat2 x := by
  simp [betaHat2, R1_smul, coOmD_smul]
  module

lemma betaHat1dag_smul_local (c : ℂ) (x : Dixon) :
    betaHat1dag (c • x) = c • betaHat1dag x := by
  simp [betaHat1dag, R1_smul, R2_smul, coT3_smul]
  module

lemma betaHat2dag_smul_local (c : ℂ) (x : Dixon) :
    betaHat2dag (c • x) = c • betaHat2dag x := by
  simp [betaHat2dag, R1_smul, coOm_smul]
  module

lemma vwHat_smul_local (c : ℂ) (x : Dixon) : vwHat (c • x) = c • vwHat x := by
  simp only [vwHat, betaHat1_smul_local, betaHat2_smul_local,
    betaHat1dag_smul_local, betaHat2dag_smul_local]

/-- `X1` is additive. -/
lemma X1_add (x y : Dixon) : X1 (x + y) = X1 x + X1 y := by
  simp [X1, betaHat1dag_add_local, vwHat_add_local]

/-- `X2` is additive. -/
lemma X2_add (x y : Dixon) : X2 (x + y) = X2 x + X2 y := by
  simp [X2, betaHat2dag_add_local, vwHat_add_local]

/-- `X1` commutes with complex scalar action. -/
lemma X1_smul (c : ℂ) (x : Dixon) : X1 (c • x) = c • X1 x := by
  simp [X1, betaHat1dag_smul_local, vwHat_smul_local]

/-- `X2` commutes with complex scalar action. -/
lemma X2_smul (c : ℂ) (x : Dixon) : X2 (c • x) = c • X2 x := by
  simp [X2, betaHat2dag_smul_local, vwHat_smul_local]

/-- `adG` is additive in the grading operator (pointwise), provided the
operator being graded is additive.  The original draft omitted this necessary
hypothesis; without it the statement is false for arbitrary functions `X`. -/
theorem adG_add (G H X : Dixon → Dixon)
    (hX : ∀ x y, X (x + y) = X x + X y) (d : Dixon) :
    adG (fun z => G z + H z) X d = adG G X d + adG H X d := by
  simp only [adG, hX, sub_eq_add_neg, neg_add_rev]
  ac_rfl

/-- `adG` of a scalar multiple of the grading operator, for `X1`. -/
theorem adG_smul_X1 (c : ℂ) (G : Dixon → Dixon) (d : Dixon) :
    adG (fun z => c • G z) X1 d = c • adG G X1 d := by
  unfold adG
  rw [X1_smul]
  module

/-- The identity component contributes nothing to any grade. -/
theorem adG_id (X : Dixon → Dixon) (d : Dixon) :
    adG (fun z => z) X d = 0 := by
  simp [adG]

/-- Family grade on `X1`: the affine combination of the generator grades. -/
theorem famG_X1 (a b e : ℂ) (d : Dixon) :
    adG (famG a b e) X1 d = (a + 2 * b) • X1 d := by
  unfold adG famG
  rw [X1_add, X1_add, X1_smul, X1_smul, X1_smul]
  calc
    _ = a • (G_PL (X1 d) - X1 (G_PL d)) +
        b • (G_R (X1 d) - X1 (G_R d)) := by module
    _ = a • ((1 : ℂ) • X1 d) + b • ((2 : ℂ) • X1 d) := by
      rw [← adG_PL_X1 d, ← adG_R_X1 d]
      rfl
    _ = _ := by module

/-- Family grade on `X2`: the SAME affine combination (this equality of
coefficients is the obstruction). -/
theorem famG_X2 (a b e : ℂ) (d : Dixon) :
    adG (famG a b e) X2 d = (a + 2 * b) • X2 d := by
  unfold adG famG
  rw [X2_add, X2_add, X2_smul, X2_smul, X2_smul]
  calc
    _ = a • (G_PL (X2 d) - X2 (G_PL d)) +
        b • (G_R (X2 d) - X2 (G_R d)) := by module
    _ = a • ((1 : ℂ) • X2 d) + b • ((2 : ℂ) • X2 d) := by
      rw [← adG_PL_X2 d, ← adG_R_X2 d]
      rfl
    _ = _ := by module

/-- `X1` is nonzero: on the concrete state with `vIdemStar` in its
colour slot, its `x2.re.c0` coordinate is nonzero. -/
lemma X1_nonzero : ∃ d : Dixon, X1 d ≠ 0 := by
  refine ⟨⟨vIdemStar, 0, 0, 0⟩, ?_⟩
  intro h
  have hc := congrArg (fun z : Dixon => z.x2.re.c0) h
  unfold X1 vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag at hc
  simp only [co] at hc
  simp_rw [R1_slots, R2_slots] at hc
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one] at hc
  simp [phi, psi, vIdem, vIdemStar] at hc
  norm_num [Complex.I_sq] at hc

/-- `X2` is nonzero: on the concrete state with `vIdem` in its colour slot,
its `x1.re.c0` coordinate is nonzero. -/
lemma X2_nonzero : ∃ d : Dixon, X2 d ≠ 0 := by
  refine ⟨⟨vIdem, 0, 0, 0⟩, ?_⟩
  intro h
  have hc := congrArg (fun z : Dixon => z.x1.re.c0) h
  unfold X2 vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag at hc
  simp only [co] at hc
  simp_rw [R1_slots, R2_slots] at hc
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one] at hc
  simp [phi, psi, vIdem, vIdemStar] at hc
  norm_num [Complex.I_sq] at hc

/-- **Family no-go.**  No member of the candidate family grades `X1` and
`X2` by the prescribed opposite signs. -/
theorem famG_no_sign_separation :
    ¬ ∃ (a b e : ℂ) (lam mu : ℂ),
      (∀ d, adG (famG a b e) X1 d = lam • X1 d) ∧
      (∀ d, adG (famG a b e) X2 d = mu • X2 d) ∧
      lam = 1 ∧ mu = -1 := by
  rintro ⟨a, b, e, lam, mu, h1, h2, hlam, hmu⟩
  obtain ⟨d1, hd1⟩ := X1_nonzero
  obtain ⟨d2, hd2⟩ := X2_nonzero
  have hc1 : (a + 2 * b) • X1 d1 = lam • X1 d1 := by
    rw [← famG_X1 a b e d1, h1 d1]
  have hc2 : (a + 2 * b) • X2 d2 = mu • X2 d2 := by
    rw [← famG_X2 a b e d2, h2 d2]
  have heq1 : a + 2 * b = lam := by
    by_contra hne
    have : (a + 2 * b - lam) • X1 d1 = 0 := by
      rw [sub_smul, hc1, sub_self]
    have hz : a + 2 * b - lam = 0 :=
      (smul_eq_zero_iff_left hd1).mp this
    exact (sub_ne_zero.mpr hne) hz
  have heq2 : a + 2 * b = mu := by
    by_contra hne
    have : (a + 2 * b - mu) • X2 d2 = 0 := by
      rw [sub_smul, hc2, sub_self]
    have hz : a + 2 * b - mu = 0 :=
      (smul_eq_zero_iff_left hd2).mp this
    exact (sub_ne_zero.mpr hne) hz
  rw [hlam] at heq1
  rw [hmu] at heq2
  have : (1 : ℂ) = -1 := heq1.symm.trans heq2
  norm_num at this

end PhysicsSM.Draft.NullEdge.IsospinGradingFamilyNoGo
