import Mathlib

/-!
# A3 concrete reflection-positive glueball-like sector (Opus, verified ea4eb225)

SCOPE CORRECTION (wave-2 self-audit `bb32d90b`, docstring-outruns-kernel guard):
what is proved is POSITIVE-DEFINITENESS of the finite transfer matrix (a necessary
ingredient), NOT the full Osterwalder-Seiler reflected positive-time reflection
positivity - a positive-definite two-point kernel can still fail the reflected
positive-time form.  Read "reflection-positive" below as "positive-definite finite
transfer"; genuine OS reflection positivity is an owed separate ingredient.

Explicit positive-definite T=diag(1,1/2): nondegenerate vacuum (eig 1), gapped
excitation (eig 1/2), gauge-invariant observable O=(1,1) with connected
correlation (1/2)^n=exp(-n log 2) (composite mass log 2), vacuum-only control
O'=(1,0) with zero connected correlation. The concrete A3 nontrivial-sector +
constituent-vs-binding control. Namespace kept as prover's A3FiniteSector.
Provenance: verified at pin from task 86303afc. Standard three. Grade M,[orig]. -/

open scoped BigOperators

set_option autoImplicit false
set_option maxHeartbeats 8000000

namespace A3FiniteSector

abbrev Sector := Fin 2 → ℝ
abbrev TransferMatrix := Matrix (Fin 2) (Fin 2) ℝ

/-- A two-dimensional transfer sector with vacuum eigenvalue `1` and excitation
    eigenvalue `1/2`. -/
noncomputable def T : TransferMatrix := !![1, 0; 0, (1 / 2 : ℝ)]

def vacuum : Sector := ![1, 0]
def excited : Sector := ![0, 1]
def O : Sector := ![1, 1]
def Ocontrol : Sector := vacuum

/-- This is already the gauge-invariant sector: the residual gauge group acts
    trivially on it. -/
def gaugeAction (_g : Fin 2) (v : Sector) : Sector := v

def GaugeInvariant (v : Sector) : Prop := ∀ g : Fin 2, gaugeAction g v = v

/-- The real inner product in the finite sector. -/
def inner (x y : Sector) : ℝ := ∑ i, x i * y i

/-- Reflection positivity in its finite transfer-matrix form. -/
def ReflectionPositive (A : TransferMatrix) : Prop :=
  A.IsHermitian ∧ ∀ x : Sector, x ≠ 0 → 0 < inner x (A.mulVec x)

/-- Vacuum-subtracted (connected) two-point function. -/
noncomputable def connectedCorr (X : Sector) (n : ℕ) : ℝ :=
  inner X ((T ^ n).mulVec X) - inner X vacuum * inner vacuum X

/-- The ordinary spectral gap between the vacuum and excited eigenvalues. -/
noncomputable def spectralGap : ℝ := 1 - (1 / 2 : ℝ)

/-- The transfer-matrix mass corresponding to the eigenvalue ratio `(1/2)/1`. -/
noncomputable def compositeMass : ℝ := Real.log 2

lemma all_gaugeInvariant (v : Sector) : GaugeInvariant v := by
  exact fun _ => rfl

lemma T_symmetric : T.IsHermitian := by
  ext i j; fin_cases i <;> fin_cases j <;> rfl;

lemma T_quadratic (x : Sector) :
    inner x (T.mulVec x) = (x 0) ^ 2 + (1 / 2 : ℝ) * (x 1) ^ 2 := by
  unfold inner T;
  norm_num [ Fin.sum_univ_succ, Matrix.mulVec ] ; ring

lemma T_reflectionPositive : ReflectionPositive T := by
  constructor;
  · exact T_symmetric;
  · -- By definition of $T$, we know that its quadratic form is given by $T(x) = x_0^2 + \frac{1}{2} x_1^2$.
    intro x hx_nonzero
    have h_quad_form : inner x (T.mulVec x) = x 0 ^ 2 + (1 / 2 : ℝ) * x 1 ^ 2 := by
      convert T_quadratic x using 1;
    exact h_quad_form.symm ▸ by contrapose! hx_nonzero; ext i; fin_cases i <;> norm_num <;> nlinarith!;

lemma vacuum_eigenvector : T.mulVec vacuum = vacuum := by
  ext i; fin_cases i <;> norm_num [ T, vacuum ] ;

lemma excited_eigenvector : T.mulVec excited = (1 / 2 : ℝ) • excited := by
  ext i ; fin_cases i <;> norm_num [ T, excited ]

/-
The top eigenvalue is nondegenerate: every eigenvector of eigenvalue one is
    a scalar multiple of the vacuum.
-/
lemma top_eigenvalue_nondegenerate (v : Sector) :
    T.mulVec v = v ↔ v = (v 0) • vacuum := by
  constructor;
  · intro hv
    have hv1 : v 1 = 0 := by
      unfold T at hv; have := congr_fun hv 1; norm_num [ Matrix.mulVec ] at this; linarith!;
    ext i; fin_cases i <;> simp +decide [ hv1, vacuum ] ;
  · intro h;
    rw [ h ];
    rw [ Matrix.mulVec_smul, vacuum_eigenvector ]

/-
These are the only eigenvalues of the two-dimensional sector, so `1` is
    genuinely the top eigenvalue and `1/2` is the unique lower level.
-/
lemma eigenvalue_classification (lambda : ℝ) (v : Sector) (hv : v ≠ 0)
    (heig : T.mulVec v = lambda • v) :
    lambda = 1 ∨ lambda = (1 / 2 : ℝ) := by
  by_cases h : v 0 = 0 <;> simp_all +decide [ funext_iff, Fin.forall_fin_two, Matrix.mulVec ];
  · exact Or.inr ( by rw [ ← heig.2 ] ; norm_num [ T ] );
  · norm_num [ T ] at *;
    exact Or.inl ( mul_left_cancel₀ h <| by linarith )

lemma excitation_below_vacuum : (1 / 2 : ℝ) < 1 := by
  norm_num

lemma spectralGap_pos : 0 < spectralGap := by
  norm_num [spectralGap]

lemma O_excited_overlap : inner O excited = 1 := by
  unfold inner O excited; norm_num;

lemma Ocontrol_vacuum_only :
    inner Ocontrol excited = 0 ∧ inner Ocontrol vacuum = 1 := by
  unfold inner Ocontrol vacuum excited; norm_num [ Fin.sum_univ_succ ] ;

lemma T_pow_mulVec_O (n : ℕ) :
    (T ^ n).mulVec O = ![1, (1 / 2 : ℝ) ^ n] := by
  induction' n with n ih;
  · unfold O; norm_num;
  · rw [ pow_succ', ← Matrix.mulVec_mulVec, ih ];
    ext i; fin_cases i <;> norm_num [ T ] ; ring;

/-
The nontrivial observable has exactly the first-excitation decay rate.
-/
theorem connectedCorr_O (n : ℕ) :
    connectedCorr O n = (1 / 2 : ℝ) ^ n := by
  unfold connectedCorr;
  rw [ show ( T ^ n : Matrix ( Fin 2 ) ( Fin 2 ) ℝ ) = !![1, 0; 0, ( 1 / 2 : ℝ ) ^ n] from _ ] ; norm_num [ Matrix.mulVec, inner ] ; ring;
  · unfold O vacuum; norm_num;
  · induction n <;> simp_all +decide [ pow_succ, T ];
    exact Matrix.one_fin_two

/-
Equivalently, the exact decay is exponential with composite mass `log 2`.
-/
theorem connectedCorr_O_mass_rate (n : ℕ) :
    connectedCorr O n = Real.exp (-(n : ℝ) * compositeMass) := by
  rw [ connectedCorr_O, compositeMass ];
  norm_num [ Real.exp_neg, Real.exp_nat_mul, Real.exp_log ];
  rw [ one_div, inv_pow ]

/-
A vacuum-only control sees no connected composite excitation.
-/
theorem connectedCorr_control (n : ℕ) : connectedCorr Ocontrol n = 0 := by
  -- By definition of $T$, we know that $(T^n).mulVec vacuum = vacuum$.
  have h_mulVec_vacuum : (T ^ n).mulVec vacuum = vacuum := by
    induction n <;> simp_all +decide [pow_succ'];
    rw [ ← Matrix.mulVec_mulVec, ‹Matrix.mulVec ( T ^ _ ) vacuum = vacuum›, vacuum_eigenvector ];
  unfold connectedCorr Ocontrol;
  norm_num [ h_mulVec_vacuum, inner ];
  unfold vacuum; norm_num;

/-
The composite transfer mass is strictly positive.
-/
theorem compositeMass_pos : 0 < compositeMass := by
  exact Real.log_pos one_lt_two

/-
Thus the excitation-sensitive and vacuum-only correlations differ at every
    finite Euclidean time.
-/
theorem correlation_behaviors_differ (n : ℕ) :
    connectedCorr O n ≠ connectedCorr Ocontrol n := by
  norm_num [ connectedCorr_O, connectedCorr_control ]

/-
A single bundled statement recording the requested finite A3 sector.
-/
theorem finite_A3_sector :
    ReflectionPositive T ∧
    T.mulVec vacuum = vacuum ∧
    T.mulVec excited = (1 / 2 : ℝ) • excited ∧
    (∀ v : Sector, T.mulVec v = v → v = (v 0) • vacuum) ∧
    (∀ lambda : ℝ, ∀ v : Sector, v ≠ 0 → T.mulVec v = lambda • v →
      lambda = 1 ∨ lambda = (1 / 2 : ℝ)) ∧
    (1 / 2 : ℝ) < 1 ∧
    GaugeInvariant O ∧ GaugeInvariant Ocontrol ∧
    inner O excited ≠ 0 ∧ inner Ocontrol excited = 0 ∧
    0 < spectralGap ∧ 0 < compositeMass ∧
    (∀ n : ℕ, connectedCorr O n = Real.exp (-(n : ℝ) * compositeMass)) ∧
    (∀ n : ℕ, connectedCorr Ocontrol n = 0) ∧
    (∀ n : ℕ, connectedCorr O n ≠ connectedCorr Ocontrol n) := by
  refine ⟨T_reflectionPositive, vacuum_eigenvector, excited_eigenvector,
    ?_, eigenvalue_classification, excitation_below_vacuum,
    all_gaugeInvariant O, all_gaugeInvariant Ocontrol, ?_,
    Ocontrol_vacuum_only.1, spectralGap_pos, compositeMass_pos,
    connectedCorr_O_mass_rate,
    connectedCorr_control, correlation_behaviors_differ⟩
  · intro v hv
    exact (top_eigenvalue_nondegenerate v).mp hv
  · rw [O_excited_overlap]
    norm_num

#print axioms finite_A3_sector

end A3FiniteSector
