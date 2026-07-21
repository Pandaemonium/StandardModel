import Mathlib

/-!
# Mixed / pseudo-Dirac neutrino branch (Opus, verified Aristotle 5ae0bb6e)

CLOSES the A5 gap the wave-2 self-audit exposed (the 'complete four-branch'
classification was missing the mixed row). Complex symmetric M=[[ML,mD],[mD,MR]]:
pure-Dirac (ML=MR=0) and pure-Majorana (mD=0) as special cases, characteristic
polynomial mu^2-(ML+MR)mu+ML MR-mD^2, exact eigenvalues (ML+MR +- r)/2, and the
pseudo-Dirac nearly-degenerate splitting. Audit-found gap -> proved brick.

Namespace kept as the prover's (verbatim, preserving proofs). Provenance:
verified at the pinned toolchain from Aristotle project 5ae0bb6e.
Clean-room Mathlib port; standard three axioms. Claim grade M, [comp]. -/

open scoped Matrix

set_option autoImplicit false

namespace MixedPseudoDirac

/-- The complex symmetric mass matrix in the basis `(ν_L, ν_R)`. -/
def massMatrix (ML mD MR : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![ML, mD; mD, MR]

/-
The mixed mass matrix is complex symmetric (transpose-symmetric, rather
than Hermitian): this is the algebraic form appropriate to Majorana masses.
-/
theorem massMatrix_isSymm (ML mD MR : ℂ) :
    (massMatrix ML mD MR)ᵀ = massMatrix ML mD MR := by
  ext i j; fin_cases i <;> fin_cases j <;> rfl;

/-- The off-diagonal-only (pure Dirac) branch. -/
def IsPureDirac (M : Matrix (Fin 2) (Fin 2) ℂ) : Prop :=
  M 0 0 = 0 ∧ M 1 1 = 0

/-- The diagonal-only (pure Majorana) branch. -/
def IsPureMajorana (M : Matrix (Fin 2) (Fin 2) ℂ) : Prop :=
  M 0 1 = 0 ∧ M 1 0 = 0

/-- At least one Majorana mass is present; this is the algebraic marker for
lepton-number violation in this model. -/
def ViolatesLeptonNumber (ML MR : ℂ) : Prop := ML ≠ 0 ∨ MR ≠ 0

/-- A number is an algebraic eigenvalue exactly when the characteristic
matrix is singular.  This avoids choosing eigenvectors or a square-root branch. -/
def IsMassEigenvalue (M : Matrix (Fin 2) (Fin 2) ℂ) (μ : ℂ) : Prop :=
  (M - μ • (1 : Matrix (Fin 2) (Fin 2) ℂ)).det = 0

/-
Setting both Majorana masses to zero recovers the pure-Dirac matrix.
-/
theorem pureDirac_special_case (mD : ℂ) :
    massMatrix 0 mD 0 = !![0, mD; mD, 0] ∧
      IsPureDirac (massMatrix 0 mD 0) := by
  exact ⟨ rfl, rfl, rfl ⟩

/-
Setting the Dirac mass to zero recovers the pure-Majorana matrix.
-/
theorem pureMajorana_special_case (ML MR : ℂ) :
    massMatrix ML 0 MR = !![ML, 0; 0, MR] ∧
      IsPureMajorana (massMatrix ML 0 MR) := by
  exact ⟨ rfl, by unfold IsPureMajorana; unfold massMatrix; norm_num ⟩

/-
The characteristic polynomial of the mixed matrix.
-/
theorem characteristic_polynomial (ML mD MR μ : ℂ) :
    (massMatrix ML mD MR - μ • (1 : Matrix (Fin 2) (Fin 2) ℂ)).det =
      μ ^ 2 - (ML + MR) * μ + (ML * MR - mD ^ 2) := by
  unfold massMatrix; norm_num [ Matrix.det_fin_two ] ; ring;

/-
Exact algebraic eigenvalues of the general complex symmetric matrix.
Here `r` may be either square root of the discriminant.
-/
theorem exact_eigenvalues (ML mD MR r : ℂ)
    (hr : r ^ 2 = (ML - MR) ^ 2 + 4 * mD ^ 2) :
    IsMassEigenvalue (massMatrix ML mD MR) ((ML + MR + r) / 2) ∧
    IsMassEigenvalue (massMatrix ML mD MR) ((ML + MR - r) / 2) := by
  constructor <;> rw [ IsMassEigenvalue, characteristic_polynomial ] <;> ring; all_goals rw [ hr ] ; ring

/-
A discriminant square root, and hence the displayed pair of exact
complex eigenvalues, always exists.
-/
theorem exact_eigenvalues_exist (ML mD MR : ℂ) :
    ∃ r : ℂ,
      r ^ 2 = (ML - MR) ^ 2 + 4 * mD ^ 2 ∧
      IsMassEigenvalue (massMatrix ML mD MR) ((ML + MR + r) / 2) ∧
      IsMassEigenvalue (massMatrix ML mD MR) ((ML + MR - r) / 2) := by
  obtain ⟨ r, hr ⟩ := IsAlgClosed.exists_eq_mul_self ( ( ML - MR ) ^ 2 + 4 * mD ^ 2 );
  exact ⟨ r, by linear_combination' hr.symm, exact_eigenvalues ML mD MR r ( by linear_combination' hr.symm ) ⟩

/-
The two exact roots have sum `ML + MR`.
-/
theorem exact_eigenvalue_sum (ML MR r : ℂ) :
    (ML + MR + r) / 2 + (ML + MR - r) / 2 = ML + MR := by
  ring

/-
The exact splitting between the two signed roots is the discriminant root.
-/
theorem exact_eigenvalue_splitting (ML MR r : ℂ) :
    (ML + MR + r) / 2 - (ML + MR - r) / 2 = r := by
  ring

/-
Exact small-splitting expansion for the positive pseudo-Dirac mass.
The correction to `mD + (ML+MR)/2` is quadratic in `ML-MR`.
-/
theorem pseudoDirac_expansion_plus (ML mD MR r : ℂ)
    (hr : r ^ 2 = (ML - MR) ^ 2 + 4 * mD ^ 2)
    (hden : r + 2 * mD ≠ 0) :
    (ML + MR + r) / 2 =
      mD + (ML + MR) / 2 + (ML - MR) ^ 2 / (2 * (r + 2 * mD)) := by
  grind +locals

/-
After changing the sign of the root near `-mD` (the harmless Majorana
rephasing used for physical masses), its expansion is
`mD - (ML+MR)/2` plus the same quadratic correction.
-/
theorem pseudoDirac_expansion_minus (ML mD MR r : ℂ)
    (hr : r ^ 2 = (ML - MR) ^ 2 + 4 * mD ^ 2)
    (hden : r + 2 * mD ≠ 0) :
    -((ML + MR - r) / 2) =
      mD - (ML + MR) / 2 + (ML - MR) ^ 2 / (2 * (r + 2 * mD)) := by
  grind +qlia

/-
At the Dirac endpoint the two signed roots are exactly `mD` and `-mD`.
-/
theorem dirac_limit_eigenvalues (mD : ℂ) :
    IsMassEigenvalue (massMatrix 0 mD 0) mD ∧
      IsMassEigenvalue (massMatrix 0 mD 0) (-mD) := by
  unfold IsMassEigenvalue;
  unfold massMatrix; norm_num [ Matrix.det_fin_two ] ;

/-
Explicit genuinely mixed parameters: both a Dirac and a Majorana entry are
present, so this matrix belongs to neither pure branch.
-/
theorem genuinely_mixed_example :
    let M := massMatrix 1 1 0
    ¬ IsPureDirac M ∧ ¬ IsPureMajorana M ∧ ViolatesLeptonNumber 1 0 := by
  unfold IsPureDirac IsPureMajorana ViolatesLeptonNumber; norm_num [ massMatrix ] ;

/-
Scaling the Majorana masses continuously/algebraically interpolates between
an exactly Dirac endpoint and lepton-number-violating mixed points.
-/
theorem interpolation (ML mD MR : ℂ)
    (hMaj : ViolatesLeptonNumber ML MR) :
    massMatrix (0 * ML) mD (0 * MR) = massMatrix 0 mD 0 ∧
    (∀ t : ℂ, t ≠ 0 → ViolatesLeptonNumber (t * ML) (t * MR)) ∧
    massMatrix (1 * ML) mD (1 * MR) = massMatrix ML mD MR := by
  simp_all +decide [ ViolatesLeptonNumber ]

/-
The missing A5 row, packaged as one statement: the mixed branch contains
both limiting branches, has exact pseudo-Dirac eigenvalues and their quadratic
small-splitting expansion, admits a genuinely mixed lepton-number-violating
point, and has a Dirac endpoint.
-/
theorem mixed_branch_closes_A5 :
    (∀ mD : ℂ, IsPureDirac (massMatrix 0 mD 0)) ∧
    (∀ ML MR : ℂ, IsPureMajorana (massMatrix ML 0 MR)) ∧
    (∃ ML mD MR : ℂ,
      ¬ IsPureDirac (massMatrix ML mD MR) ∧
      ¬ IsPureMajorana (massMatrix ML mD MR) ∧
      ViolatesLeptonNumber ML MR) ∧
    (∀ mD : ℂ, IsMassEigenvalue (massMatrix 0 mD 0) mD ∧
      IsMassEigenvalue (massMatrix 0 mD 0) (-mD)) := by
  refine' ⟨ _, _, _, _ ⟩;
  · exact fun mD => pureDirac_special_case mD |>.2;
  · exact fun ML MR => pureMajorana_special_case ML MR |>.2;
  · exact ⟨ 1, 1, 0, by unfold IsPureDirac; unfold massMatrix; norm_num, by unfold IsPureMajorana; unfold massMatrix; norm_num, by unfold ViolatesLeptonNumber; norm_num ⟩;
  · exact fun mD => dirac_limit_eigenvalues mD

end MixedPseudoDirac

#print axioms MixedPseudoDirac.massMatrix_isSymm
#print axioms MixedPseudoDirac.mixed_branch_closes_A5
#print axioms MixedPseudoDirac.exact_eigenvalues
#print axioms MixedPseudoDirac.exact_eigenvalues_exist
#print axioms MixedPseudoDirac.pseudoDirac_expansion_plus
#print axioms MixedPseudoDirac.pseudoDirac_expansion_minus
#print axioms MixedPseudoDirac.interpolation
