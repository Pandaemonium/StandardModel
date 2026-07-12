import PhysicsSM.Draft.NullEdge.CommutatorRegulator
import PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge

/-!
# Mixed second derivative of the exact unitary commutator

The exact trigonometric group commutator has identity value and zero complete
first derivative at the origin. Its first nontrivial mixed derivative is the
Lie coefficient `G*A-A*G`. This module makes that analytic statement exact.

Provenance: internal exact regulator construction; all proof bodies were
completed by Aristotle project `2ed756dc-b838-4fa3-8fea-0bffe6a433bc` on
2026-07-11.

## Implementation notes

`M4 = Matrix (Fin 4) (Fin 4) ℂ` carries only its product (topological-module)
structure in this project, so the Fréchet derivative `fderiv` used in the
statements is the topological-vector-space `fderiv`.  All proofs activate the
`L¹-L∞` normed instances on `M4` *locally* (via `letI`); the topology of those
instances is definitionally the product topology, so the resulting
`HasFDerivAt`/`fderiv`/`deriv` facts unify with the statements verbatim.  This
gives genuine Fréchet calculus (product rule, chain rule, `cos`/`sin`
derivatives) at the matrix level — no entrywise, formal-series, finite
difference or assumed-differentiability weakening.
-/

open Matrix Complex

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CommutatorMixedDerivative

open PhysicsSM.Draft.NullEdge.CommutatorRegulator

abbrev M4 := Matrix (Fin 4) (Fin 4) Complex
abbrev V2 := Real × Real

def trigRegulator (A G : M4) (x : V2) : M4 :=
  regulator (Real.cos x.1) (Real.sin x.1)
    (Real.cos x.2) (Real.sin x.2) A G

def eP : V2 := (1, 0)
def eQ : V2 := (0, 1)

noncomputable def lieCoefficient (A G : M4) : M4 := G * A - A * G

/-! ### Factor functions and their derivatives -/

/-- The `+` phase factor `phaseStep (cos p) (sin p) C`. -/
noncomputable def pfac (C : M4) (p : ℝ) : M4 :=
  (Real.cos p : ℂ) • (1 : M4) - (Complex.I * (Real.sin p : ℂ)) • C

/-- The `-` phase factor `phaseStep (cos p) (-sin p) C`. -/
noncomputable def nfac (C : M4) (p : ℝ) : M4 :=
  (Real.cos p : ℂ) • (1 : M4) + (Complex.I * (Real.sin p : ℂ)) • C

/-- Derivative of `pfac C`. -/
noncomputable def dpfac (C : M4) (p : ℝ) : M4 :=
  -(Real.sin p : ℂ) • (1 : M4) - (Complex.I * (Real.cos p : ℂ)) • C

/-- Derivative of `nfac C`. -/
noncomputable def dnfac (C : M4) (p : ℝ) : M4 :=
  -(Real.sin p : ℂ) • (1 : M4) + (Complex.I * (Real.cos p : ℂ)) • C

theorem trigRegulator_eq (A G : M4) (x : V2) :
    trigRegulator A G x = pfac A x.1 * pfac G x.2 * nfac A x.1 * nfac G x.2 := by
  simp only [trigRegulator, regulator, phaseStep, pfac, nfac, Complex.ofReal_neg,
    mul_neg, neg_smul, sub_neg_eq_add]

theorem hasDerivAt_pfac (C : M4) (p : ℝ) : HasDerivAt (pfac C) (dpfac C p) p := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  letI : NormedSpace ℂ M4 := Matrix.linftyOpNormedSpace
  unfold pfac dpfac
  have hcos : HasDerivAt (fun p : ℝ => (Real.cos p : ℂ)) (-(Real.sin p : ℂ)) p := by
    simpa using (Real.hasDerivAt_cos p).ofReal_comp
  have hsin : HasDerivAt (fun p : ℝ => (Real.sin p : ℂ)) ((Real.cos p : ℂ)) p := by
    simpa using (Real.hasDerivAt_sin p).ofReal_comp
  have h1 := hcos.smul_const (1 : M4)
  have h2 := (hsin.const_mul Complex.I).smul_const C
  simpa [mul_comm] using h1.sub h2

theorem hasDerivAt_nfac (C : M4) (p : ℝ) : HasDerivAt (nfac C) (dnfac C p) p := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  letI : NormedSpace ℂ M4 := Matrix.linftyOpNormedSpace
  unfold nfac dnfac
  have hcos : HasDerivAt (fun p : ℝ => (Real.cos p : ℂ)) (-(Real.sin p : ℂ)) p := by
    simpa using (Real.hasDerivAt_cos p).ofReal_comp
  have hsin : HasDerivAt (fun p : ℝ => (Real.sin p : ℂ)) ((Real.cos p : ℂ)) p := by
    simpa using (Real.hasDerivAt_sin p).ofReal_comp
  have h1 := hcos.smul_const (1 : M4)
  have h2 := (hsin.const_mul Complex.I).smul_const C
  simpa [mul_comm] using h1.add h2

theorem differentiable_pfac (C : M4) : Differentiable ℝ (pfac C) := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  exact fun p => (hasDerivAt_pfac C p).differentiableAt

theorem differentiable_nfac (C : M4) : Differentiable ℝ (nfac C) := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  exact fun p => (hasDerivAt_nfac C p).differentiableAt

theorem differentiable_dpfac (C : M4) : Differentiable ℝ (dpfac C) := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  letI : NormedSpace ℂ M4 := Matrix.linftyOpNormedSpace
  unfold dpfac
  have hcos : Differentiable ℝ (fun p : ℝ => (Real.cos p : ℂ)) := by
    exact fun p => ((Real.hasDerivAt_cos p).ofReal_comp).differentiableAt
  have hsin : Differentiable ℝ (fun p : ℝ => (Real.sin p : ℂ)) := by
    exact fun p => ((Real.hasDerivAt_sin p).ofReal_comp).differentiableAt
  exact (hsin.neg.smul_const (1 : M4)).sub ((hcos.const_mul Complex.I).smul_const C)

theorem differentiable_dnfac (C : M4) : Differentiable ℝ (dnfac C) := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  letI : NormedSpace ℂ M4 := Matrix.linftyOpNormedSpace
  unfold dnfac
  have hcos : Differentiable ℝ (fun p : ℝ => (Real.cos p : ℂ)) := by
    exact fun p => ((Real.hasDerivAt_cos p).ofReal_comp).differentiableAt
  have hsin : Differentiable ℝ (fun p : ℝ => (Real.sin p : ℂ)) := by
    exact fun p => ((Real.hasDerivAt_sin p).ofReal_comp).differentiableAt
  exact (hsin.neg.smul_const (1 : M4)).add ((hcos.const_mul Complex.I).smul_const C)

/-! ### Value lemmas at the origin -/

@[simp] theorem pfac_zero (C : M4) : pfac C 0 = 1 := by simp [pfac]
@[simp] theorem nfac_zero (C : M4) : nfac C 0 = 1 := by simp [nfac]
@[simp] theorem dpfac_zero (C : M4) : dpfac C 0 = -(Complex.I • C) := by simp [dpfac]
@[simp] theorem dnfac_zero (C : M4) : dnfac C 0 = Complex.I • C := by simp [dnfac]

/-! ### Directional-derivative bridges

For `f` differentiable at `x`, the Fréchet derivative applied to the coordinate
directions `eP`, `eQ` is the corresponding one-dimensional slice derivative. -/

theorem fderiv_apply_eP (f : V2 → M4) (x : V2) (h : DifferentiableAt ℝ f x) :
    fderiv ℝ f x eP = deriv (fun p => f (p, x.2)) x.1 := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  have hι : HasFDerivAt (fun p : ℝ => (p, x.2)) (ContinuousLinearMap.inl ℝ ℝ ℝ) x.1 := by
    simpa using ((hasFDerivAt_id x.1).prodMk (hasFDerivAt_const x.2 x.1))
  have hcomp : HasFDerivAt (fun p => f (p, x.2))
      ((fderiv ℝ f x).comp (ContinuousLinearMap.inl ℝ ℝ ℝ)) x.1 := h.hasFDerivAt.comp x.1 hι
  rw [hcomp.hasDerivAt.deriv]
  simp [ContinuousLinearMap.comp_apply, eP]

theorem fderiv_apply_eQ (f : V2 → M4) (x : V2) (h : DifferentiableAt ℝ f x) :
    fderiv ℝ f x eQ = deriv (fun q => f (x.1, q)) x.2 := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  have hι : HasFDerivAt (fun q : ℝ => (x.1, q)) (ContinuousLinearMap.inr ℝ ℝ ℝ) x.2 := by
    simpa using ((hasFDerivAt_const x.1 x.2).prodMk (hasFDerivAt_id x.2))
  have hcomp : HasFDerivAt (fun q => f (x.1, q))
      ((fderiv ℝ f x).comp (ContinuousLinearMap.inr ℝ ℝ ℝ)) x.2 := h.hasFDerivAt.comp x.2 hι
  rw [hcomp.hasDerivAt.deriv]
  simp [ContinuousLinearMap.comp_apply, eQ]

theorem clm_zero_of_eP_eQ (L : V2 →L[ℝ] M4) (h1 : L eP = 0) (h2 : L eQ = 0) : L = 0 := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  apply ContinuousLinearMap.ext
  intro v
  have hv : v = v.1 • eP + v.2 • eQ := by
    apply Prod.ext_iff.mpr
    constructor <;> simp [eP, eQ]
  rw [hv, map_add, map_smul, map_smul, h1, h2]
  simp

/-! ### Differentiability of `trigRegulator` -/

theorem differentiableAt_trigRegulator (A G : M4) (x : V2) :
    DifferentiableAt ℝ (trigRegulator A G) x := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  letI : NormedRing M4 := Matrix.linftyOpNormedRing
  letI : NormedAlgebra ℝ M4 := Matrix.linftyOpNormedAlgebra
  have hrw : trigRegulator A G =
      fun x : V2 => pfac A x.1 * pfac G x.2 * nfac A x.1 * nfac G x.2 :=
    funext (trigRegulator_eq A G)
  rw [hrw]
  have h1 : DifferentiableAt ℝ (fun x : V2 => pfac A x.1) x :=
    (differentiable_pfac A).differentiableAt.comp x differentiableAt_fst
  have h2 : DifferentiableAt ℝ (fun x : V2 => pfac G x.2) x :=
    (differentiable_pfac G).differentiableAt.comp x differentiableAt_snd
  have h3 : DifferentiableAt ℝ (fun x : V2 => nfac A x.1) x :=
    (differentiable_nfac A).differentiableAt.comp x differentiableAt_fst
  have h4 : DifferentiableAt ℝ (fun x : V2 => nfac G x.2) x :=
    (differentiable_nfac G).differentiableAt.comp x differentiableAt_snd
  exact ((h1.mul h2).mul h3).mul h4

/-! ### The explicit `p`-partial derivative -/

/-- The explicit `eP`-directional (p-)derivative of `trigRegulator A G`. -/
noncomputable def Pexpl (A G : M4) (x : V2) : M4 :=
  dpfac A x.1 * pfac G x.2 * nfac A x.1 * nfac G x.2
    + pfac A x.1 * pfac G x.2 * dnfac A x.1 * nfac G x.2

theorem fderiv_eP_eq (A G : M4) (x : V2) :
    fderiv ℝ (trigRegulator A G) x eP = Pexpl A G x := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  letI : NormedRing M4 := Matrix.linftyOpNormedRing
  letI : NormedAlgebra ℝ M4 := Matrix.linftyOpNormedAlgebra
  rw [fderiv_apply_eP _ _ (differentiableAt_trigRegulator A G x)]
  have hslice : (fun p => trigRegulator A G (p, x.2)) =
      fun p => pfac A p * pfac G x.2 * nfac A p * nfac G x.2 := by
    funext p; simpa using trigRegulator_eq A G (p, x.2)
  rw [hslice]
  have hd : HasDerivAt (fun p => pfac A p * pfac G x.2 * nfac A p * nfac G x.2)
      (dpfac A x.1 * pfac G x.2 * nfac A x.1 * nfac G x.2
        + pfac A x.1 * pfac G x.2 * dnfac A x.1 * nfac G x.2) x.1 := by
    have e1 := ((hasDerivAt_pfac A x.1).mul_const (pfac G x.2)).mul (hasDerivAt_nfac A x.1)
    have e2 := e1.mul_const (nfac G x.2)
    convert e2 using 1
    noncomm_ring
  rw [hd.deriv, Pexpl]

theorem differentiableAt_Pexpl (A G : M4) (x : V2) :
    DifferentiableAt ℝ (Pexpl A G) x := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  letI : NormedRing M4 := Matrix.linftyOpNormedRing
  letI : NormedAlgebra ℝ M4 := Matrix.linftyOpNormedAlgebra
  unfold Pexpl
  have dpA : DifferentiableAt ℝ (fun x : V2 => dpfac A x.1) x :=
    (differentiable_dpfac A).differentiableAt.comp x differentiableAt_fst
  have dnA : DifferentiableAt ℝ (fun x : V2 => dnfac A x.1) x :=
    (differentiable_dnfac A).differentiableAt.comp x differentiableAt_fst
  have pA : DifferentiableAt ℝ (fun x : V2 => pfac A x.1) x :=
    (differentiable_pfac A).differentiableAt.comp x differentiableAt_fst
  have pG : DifferentiableAt ℝ (fun x : V2 => pfac G x.2) x :=
    (differentiable_pfac G).differentiableAt.comp x differentiableAt_snd
  have nA : DifferentiableAt ℝ (fun x : V2 => nfac A x.1) x :=
    (differentiable_nfac A).differentiableAt.comp x differentiableAt_fst
  have nG : DifferentiableAt ℝ (fun x : V2 => nfac G x.2) x :=
    (differentiable_nfac G).differentiableAt.comp x differentiableAt_snd
  exact (((dpA.mul pG).mul nA).mul nG).add (((pA.mul pG).mul dnA).mul nG)

/-! ### The two slice computations -/

/-- The `p`-partial derivative vanishes at the origin: this is the coefficient
of `eP` in the complete first derivative. -/
theorem Pexpl_origin_zero (A G : M4) : Pexpl A G (0, 0) = 0 := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  simp [Pexpl]

/-- The `q`-slice of `trigRegulator` at `p = 0` has vanishing derivative at
`q = 0`: this is the coefficient of `eQ` in the complete first derivative. -/
theorem deriv_slice_q_origin_zero (A G : M4) :
    deriv (fun q => trigRegulator A G (0, q)) 0 = 0 := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  letI : NormedRing M4 := Matrix.linftyOpNormedRing
  letI : NormedAlgebra ℝ M4 := Matrix.linftyOpNormedAlgebra
  have hslice : (fun q => trigRegulator A G (0, q)) =
      fun q => pfac A 0 * pfac G q * nfac A 0 * nfac G q := by
    funext q; simpa using trigRegulator_eq A G (0, q)
  rw [hslice]
  have hd : HasDerivAt (fun q => pfac A 0 * pfac G q * nfac A 0 * nfac G q)
      (pfac A 0 * dpfac G 0 * nfac A 0 * nfac G 0
        + pfac A 0 * pfac G 0 * nfac A 0 * dnfac G 0) 0 := by
    have e1 := (((hasDerivAt_pfac G 0).const_mul (pfac A 0)).mul_const
      (nfac A 0)).mul (hasDerivAt_nfac G 0)
    convert e1 using 1
  rw [hd.deriv]
  simp

/-- The mixed second derivative computation. -/
theorem mixed_deriv_eq (A G : M4) :
    deriv (fun q => Pexpl A G (0, q)) 0 = G * A - A * G := by
  letI : NormedAddCommGroup M4 := Matrix.linftyOpNormedAddCommGroup
  letI : NormedSpace ℝ M4 := Matrix.linftyOpNormedSpace
  letI : NormedRing M4 := Matrix.linftyOpNormedRing
  letI : NormedAlgebra ℝ M4 := Matrix.linftyOpNormedAlgebra
  have hslice : (fun q => Pexpl A G (0, q)) =
      fun q => (dpfac A 0 * pfac G q * nfac A 0 * nfac G q
        + pfac A 0 * pfac G q * dnfac A 0 * nfac G q) := by
    funext q; simp [Pexpl]
  rw [hslice]
  -- derivative of the first summand
  have hT1 : HasDerivAt (fun q => dpfac A 0 * pfac G q * nfac A 0 * nfac G q)
      (dpfac A 0 * dpfac G 0 * nfac A 0 * nfac G 0
        + dpfac A 0 * pfac G 0 * nfac A 0 * dnfac G 0) 0 := by
    have e1 := (((hasDerivAt_pfac G 0).const_mul (dpfac A 0)).mul_const
      (nfac A 0)).mul (hasDerivAt_nfac G 0)
    convert e1 using 1
  have hT2 : HasDerivAt (fun q => pfac A 0 * pfac G q * dnfac A 0 * nfac G q)
      (pfac A 0 * dpfac G 0 * dnfac A 0 * nfac G 0
        + pfac A 0 * pfac G 0 * dnfac A 0 * dnfac G 0) 0 := by
    have e1 := (((hasDerivAt_pfac G 0).const_mul (pfac A 0)).mul_const
      (dnfac A 0)).mul (hasDerivAt_nfac G 0)
    convert e1 using 1
  have hsum : HasDerivAt (fun q => dpfac A 0 * pfac G q * nfac A 0 * nfac G q
      + pfac A 0 * pfac G q * dnfac A 0 * nfac G q)
      ((dpfac A 0 * dpfac G 0 * nfac A 0 * nfac G 0
        + dpfac A 0 * pfac G 0 * nfac A 0 * dnfac G 0)
        + (pfac A 0 * dpfac G 0 * dnfac A 0 * nfac G 0
          + pfac A 0 * pfac G 0 * dnfac A 0 * dnfac G 0)) 0 := hT1.add hT2
  rw [hsum.deriv]
  -- evaluate at the origin and simplify the Clifford algebra
  simp only [pfac_zero, nfac_zero, dpfac_zero, dnfac_zero, one_mul, mul_one]
  simp only [neg_mul, mul_neg, smul_mul_smul_comm, Complex.I_mul_I,
    neg_one_smul, neg_neg]
  abel

/-! ### Main theorems -/

theorem trigRegulator_origin (A G : M4) :
    trigRegulator A G (0, 0) = 1 := by
  simp [trigRegulator, regulator, phaseStep]

/-- The complete Frechet first derivative vanishes, not merely two selected
entrywise derivatives. -/
theorem trigRegulator_fderiv_origin (A G : M4) :
    fderiv Real (trigRegulator A G) (0, 0) = 0 := by
  apply clm_zero_of_eP_eQ
  · rw [fderiv_apply_eP _ _ (differentiableAt_trigRegulator A G _)]
    have := fderiv_eP_eq A G (0, 0)
    rw [fderiv_apply_eP _ _ (differentiableAt_trigRegulator A G _)] at this
    rw [this, Pexpl_origin_zero]
  · rw [fderiv_apply_eQ _ _ (differentiableAt_trigRegulator A G _)]
    exact deriv_slice_q_origin_zero A G

/-- The q-derivative of the p-directional derivative is the Lie coefficient. -/
theorem trigRegulator_mixed_fderiv_origin (A G : M4) :
    fderiv Real
      (fun x : V2 => fderiv Real (trigRegulator A G) x eP)
      (0, 0) eQ = lieCoefficient A G := by
  rw [show (fun x : V2 => fderiv Real (trigRegulator A G) x eP) = Pexpl A G from
    funext (fderiv_eP_eq A G)]
  rw [fderiv_apply_eQ _ _ (differentiableAt_Pexpl A G _)]
  simpa [lieCoefficient] using mixed_deriv_eq A G

noncomputable def liveA : M4 :=
  PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.alpha1

noncomputable def liveG : M4 :=
  PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.beta

/-- Mandatory nondegenerate live fixture. -/
theorem live_mixed_fderiv_ne_zero :
    fderiv Real
      (fun x : V2 => fderiv Real (trigRegulator liveA liveG) x eP)
      (0, 0) eQ ≠ 0 := by
  rw [trigRegulator_mixed_fderiv_origin liveA liveG, lieCoefficient]
  intro h
  have h00 := congrFun (congrFun h 0) 3
  simp [liveA, liveG, PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.alpha1,
    PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.beta,
    Matrix.sub_apply] at h00

/-- Negative control: repeated generators have zero mixed coefficient. -/
theorem repeated_generator_mixed_fderiv_zero (A : M4) :
    fderiv Real
      (fun x : V2 => fderiv Real (trigRegulator A A) x eP)
      (0, 0) eQ = 0 := by
  rw [trigRegulator_mixed_fderiv_origin A A, lieCoefficient, sub_self]

end PhysicsSM.Draft.NullEdge.CommutatorMixedDerivative
