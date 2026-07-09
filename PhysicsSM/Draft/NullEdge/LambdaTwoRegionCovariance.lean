import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# Everpresent Lambda: the two-region (nested causal) covariance fingerprint

A finite, independent-edge covariance model for the everpresent-Lambda dark-energy
fluctuation between two nested causal regions `R1 ⊆ R2`.

## Model

Edges are partitioned into three **independent** groups by counts:

* `a` = edges only in `R1`,
* `b` = shared edges (`R1 ∩ R2`, the overlap),
* `c` = edges only in `R2`.

So `N1 = a + b` (edge count in `R1`) and `N2 = b + c` (edge count in `R2`).

Under independent Poisson-ish edges each group has variance equal to its count and
distinct groups are uncorrelated.  We realise this **honestly** (not by fiat) by
representing a random variable as its vector of coefficients on the three
independent fluctuations `δNa, δNb, δNc`, and defining the covariance as the
count-weighted inner product
`cov x y = x.a*y.a*a + x.b*y.b*b + x.c*y.c*c`.
Independence is then a *theorem* (cross terms vanish), and the
bilinear identity `Cov(X+Y, X+Z) = Var(X)` for independent `X,Y,Z` follows from
bilinearity + orthogonality.

## Results

* `count_variances`   : `Var(N1)=a+b`, `Var(N2)=b+c`, `Cov(N1,N2)=b` (only the shared edges correlate).
* `lambda_covariance` : `Cov(Λ1,Λ2) = b/(⟨N1⟩⟨N2⟩)`  — set by the SHARED count.
* `correlation_length_reading` : `Corr = b / √((a+b)(b+c))`, with the two limits
  (`→ 1` co-moving, `→ 0` decoupled) on explicit rational witnesses.
* `distinguisher_verdict` : the packaged fingerprint.

## Honest scope

This is a finite independent-edge covariance model.  The physical ensemble's
actual correlations — and whether they are Poisson vs. hyperuniform per the
dichotomy — are the open input.  No claim is made here about the real
dark-energy power spectrum.
-/

namespace LambdaTwoRegionCovariance

/-- A (mean-zero) random variable is represented by its coefficients on the three
independent group fluctuations `(δNa, δNb, δNc)`. -/
abbrev RV : Type := ℚ × ℚ × ℚ

/-- The three independent basis fluctuations. -/
def dNa : RV := (1, 0, 0)
def dNb : RV := (0, 1, 0)
def dNc : RV := (0, 0, 1)

/-- The count-weighted covariance form for group counts `a`, `b`, `c`.
Because it is diagonal in the independent groups, distinct groups are
uncorrelated and each group's variance equals its count. -/
def cov (a b c : ℚ) (x y : RV) : ℚ :=
  x.1 * y.1 * a + x.2.1 * y.2.1 * b + x.2.2 * y.2.2 * c

/-- Variance is covariance with itself. -/
def var (a b c : ℚ) (x : RV) : ℚ := cov a b c x x

/-- The edge-count fluctuation in `R1`: `δN1 = δNa + δNb`. -/
def N1 : RV := dNa + dNb
/-- The edge-count fluctuation in `R2`: `δN2 = δNb + δNc`. -/
def N2 : RV := dNb + dNc

/-! ### Bilinearity, symmetry, and independence (orthogonality) of the covariance -/

theorem cov_symm (a b c : ℚ) (x y : RV) : cov a b c x y = cov a b c y x := by
  simp only [cov]; ring

theorem cov_add_left (a b c : ℚ) (x y z : RV) :
    cov a b c (x + y) z = cov a b c x z + cov a b c y z := by
  simp only [cov, Prod.fst_add, Prod.snd_add]; ring

theorem cov_add_right (a b c : ℚ) (x y z : RV) :
    cov a b c x (y + z) = cov a b c x y + cov a b c x z := by
  simp only [cov, Prod.fst_add, Prod.snd_add]; ring

theorem cov_smul_left (a b c t : ℚ) (x y : RV) :
    cov a b c (t • x) y = t * cov a b c x y := by
  simp only [cov, Prod.smul_fst, Prod.smul_snd, smul_eq_mul]; ring

theorem cov_smul_right (a b c t : ℚ) (x y : RV) :
    cov a b c x (t • y) = t * cov a b c x y := by
  simp only [cov, Prod.smul_fst, Prod.smul_snd, smul_eq_mul]; ring

/-- Distinct independent groups are uncorrelated. -/
theorem cov_dNa_dNb (a b c : ℚ) : cov a b c dNa dNb = 0 := by
  simp [cov, dNa, dNb]

theorem cov_dNa_dNc (a b c : ℚ) : cov a b c dNa dNc = 0 := by
  simp [cov, dNa, dNc]

theorem cov_dNb_dNc (a b c : ℚ) : cov a b c dNb dNc = 0 := by
  simp [cov, dNb, dNc]

/-- Each group's variance equals its count. -/
theorem var_dNa (a b c : ℚ) : var a b c dNa = a := by simp [var, cov, dNa]
theorem var_dNb (a b c : ℚ) : var a b c dNb = b := by simp [var, cov, dNb]
theorem var_dNc (a b c : ℚ) : var a b c dNc = c := by simp [var, cov, dNc]

/-! ### Target 1 : the count variances/covariance -/

/-- **`count_variances`** : from independence,
`Var(N1) = a+b`, `Var(N2) = b+c`, and the cross covariance is exactly the shared
count `Cov(N1,N2) = b` (the general shape `Cov(X+Y, X+Z) = Var(X)` for
independent `X,Y,Z`). -/
theorem count_variances (a b c : ℚ) :
    var a b c N1 = a + b ∧ var a b c N2 = b + c ∧ cov a b c N1 N2 = b := by
  refine ⟨?_, ?_, ?_⟩
  · simp only [var, N1, cov, dNa, dNb, Prod.fst_add, Prod.snd_add]; ring
  · simp only [var, N2, cov, dNb, dNc, Prod.fst_add, Prod.snd_add]; ring
  · simp only [N1, N2, cov, dNa, dNb, dNc, Prod.fst_add, Prod.snd_add]; ring

/-- The overlap identity read via bilinearity + orthogonality:
`Cov(δNa+δNb, δNb+δNc) = Var(δNb) = b`. -/
theorem cov_N1_N2_via_independence (a b c : ℚ) : cov a b c N1 N2 = var a b c dNb := by
  rw [N1, N2, cov_add_left, cov_add_right, cov_add_right,
      cov_dNa_dNb, cov_dNa_dNc, cov_dNb_dNc, var]
  ring

/-! ### Target 2 : the Lambda covariance (payload) -/

/-- `Λ1 = δN1 / ⟨N1⟩` as an `RV`. -/
def Lambda1 (m1 : ℚ) : RV := (1 / m1) • N1
/-- `Λ2 = δN2 / ⟨N2⟩` as an `RV`. -/
def Lambda2 (m2 : ℚ) : RV := (1 / m2) • N2

/-- **`lambda_covariance`** (payload) : the normalized Lambda covariance is set by
the SHARED edge count `b`, normalized by the two mean volumes:
`Cov(Λ1,Λ2) = Cov(δN1,δN2)/(⟨N1⟩⟨N2⟩) = b/(⟨N1⟩⟨N2⟩)`. -/
theorem lambda_covariance (a b c m1 m2 : ℚ) (hm1 : m1 ≠ 0) (hm2 : m2 ≠ 0) :
    cov a b c (Lambda1 m1) (Lambda2 m2) = b / (m1 * m2) := by
  rw [Lambda1, Lambda2, cov_smul_left, cov_smul_right, (count_variances a b c).2.2]
  field_simp

/-! ### Target 3 : the correlation and its two limits -/

/-- The normalized two-region correlation
`Corr(Λ1,Λ2) = b / √((a+b)(b+c))`. -/
noncomputable def corr (a b c : ℚ) : ℝ :=
  (b : ℝ) / Real.sqrt (((a : ℝ) + b) * ((b : ℝ) + c))

/-- Co-moving / nested limit: when the private counts vanish (`a = c = 0`) and the
overlap is positive, the correlation is exactly `1` (long, horizon-scale
correlation length). -/
theorem corr_comoving (b : ℚ) (hb : 0 < b) : corr 0 b 0 = 1 := by
  have hbR : (0 : ℝ) < (b : ℝ) := by exact_mod_cast hb
  simp only [corr, Rat.cast_zero, zero_add, add_zero]
  rw [Real.sqrt_mul_self hbR.le]
  field_simp

/-- Decoupled limit: when the shared count vanishes (`b = 0`) the regions are
uncorrelated, `Corr = 0`. -/
theorem corr_decoupled (a c : ℚ) : corr a 0 c = 0 := by
  simp [corr]

/-- **`correlation_length_reading`** : the correlation is `b/√((a+b)(b+c))`, going
to `1` as the overlap dominates (`a,c → 0`, nested / co-moving) and to `0` as the
regions decouple (`b → 0`). -/
theorem correlation_length_reading :
    (∀ a b c : ℚ, corr a b c = (b : ℝ) / Real.sqrt (((a : ℝ) + b) * ((b : ℝ) + c)))
      ∧ (∀ b : ℚ, 0 < b → corr 0 b 0 = 1)
      ∧ (∀ a c : ℚ, corr a 0 c = 0) := by
  exact ⟨fun _ _ _ => rfl, fun b hb => corr_comoving b hb, fun a c => corr_decoupled a c⟩

/-! ### MANDATORY non-degeneracy witnesses (explicit rationals in-theorem) -/

/-- Nested witness `a=1, b=98, c=1` (large overlap): the cross covariance is the
shared count `Cov(N1,N2) = 98`, and the correlation is `98/99 ≈ 1`. -/
theorem nested_witness :
    cov 1 98 1 N1 N2 = 98 ∧ corr 1 98 1 = 98 / 99 := by
  refine ⟨?_, ?_⟩
  · simp only [N1, N2, cov, dNa, dNb, dNc, Prod.fst_add, Prod.snd_add]; norm_num
  · simp only [corr]
    rw [show ((1 : ℚ) : ℝ) = (1 : ℝ) by norm_num, show ((98 : ℚ) : ℝ) = (98 : ℝ) by norm_num]
    rw [show ((1 : ℝ) + 98) * (98 + 1) = (99 : ℝ) ^ 2 by norm_num,
        Real.sqrt_sq (by norm_num)]

/-- Decoupled witness `a=50, b=1, c=50` (tiny overlap): the correlation is
`1/51 ≈ 0`. -/
theorem decoupled_witness :
    cov 50 1 50 N1 N2 = 1 ∧ corr 50 1 50 = 1 / 51 := by
  refine ⟨?_, ?_⟩
  · simp only [N1, N2, cov, dNa, dNb, dNc, Prod.fst_add, Prod.snd_add]; norm_num
  · simp only [corr]
    rw [show ((50 : ℚ) : ℝ) = (50 : ℝ) by norm_num, show ((1 : ℚ) : ℝ) = (1 : ℝ) by norm_num]
    rw [show ((50 : ℝ) + 1) * (1 + 50) = (51 : ℝ) ^ 2 by norm_num,
        Real.sqrt_sq (by norm_num)]

/-! ### Target 4 : the distinguisher verdict (package) -/

/-- **`distinguisher_verdict`** : everpresent Lambda has a specific two-region
covariance structure set by the *causal overlap* `b`:

* the count variances are the group counts, and the cross covariance is exactly
  the shared count (`Cov(N1,N2) = b`);
* the normalized Lambda covariance is `b/(⟨N1⟩⟨N2⟩)`;
* the correlation `b/√((a+b)(b+c))` runs from `1` (co-moving/nested) to `0`
  (decoupled).

This is a falsifiable fingerprint: the correlation is fixed by geometric overlap,
distinct from a local scalar (quintessence) field, whose correlation would be
potential-driven.  Honest scope: a finite independent-edge covariance model; the
physical ensemble's actual correlations are the open input. -/
theorem distinguisher_verdict :
    (∀ a b c : ℚ, var a b c N1 = a + b ∧ var a b c N2 = b + c ∧ cov a b c N1 N2 = b)
      ∧ (∀ a b c m1 m2 : ℚ, m1 ≠ 0 → m2 ≠ 0 →
          cov a b c (Lambda1 m1) (Lambda2 m2) = b / (m1 * m2))
      ∧ (∀ b : ℚ, 0 < b → corr 0 b 0 = 1)
      ∧ (∀ a c : ℚ, corr a 0 c = 0) := by
  refine ⟨fun a b c => count_variances a b c,
          fun a b c m1 m2 h1 h2 => lambda_covariance a b c m1 m2 h1 h2,
          fun b hb => corr_comoving b hb,
          fun a c => corr_decoupled a c⟩

/-! ### Axiom-footprint audit : exactly `[propext, Classical.choice, Quot.sound]` -/

/-- info: 'LambdaTwoRegionCovariance.count_variances' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms count_variances

/-- info: 'LambdaTwoRegionCovariance.lambda_covariance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lambda_covariance

/-- info: 'LambdaTwoRegionCovariance.correlation_length_reading' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms correlation_length_reading

/-- info: 'LambdaTwoRegionCovariance.nested_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nested_witness

/-- info: 'LambdaTwoRegionCovariance.decoupled_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms decoupled_witness

/-- info: 'LambdaTwoRegionCovariance.distinguisher_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms distinguisher_verdict

end LambdaTwoRegionCovariance
