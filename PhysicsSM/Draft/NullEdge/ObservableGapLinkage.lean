import Mathlib

/-!
# Observable-gap linkage for A3 (Opus, verified Aristotle a6f3c703)

The step where composite-mass bridges habitually overclaim, proved rather than
assumed. THE LINKAGE CONDITION IS NONZERO FIRST-EXCITED OVERLAP.

Proved: the normalized connected correlation converges to the SQUARED FIRST-EXCITED
OVERLAP (given the spectral remainder estimate and lam1 != 0); nonzero overlap makes
the limiting amplitude strictly positive; the correlation mass is log(lam0/lam1);
and when the first overlap VANISHES with 0 <= lam2 < lam1, normalization by lam1^n
tends to 0 while lam2^n recovers the amplitude - a smaller decay eigenvalue yielding
a STRICTLY LARGER reported mass. Explicit witness: diagonal SPD transfer with
spectrum (3,2,1) and observable (1,0,1) has vanishing first-excited overlap, leading
base 1, and a mass strictly larger than the transfer-gap mass based on 2.

INDEPENDENCE, BOTH DIRECTIONS: a constant observable is gauge invariant yet has ZERO
first-excited overlap; and a first-excited observable can have nonzero overlap
WITHOUT being gauge invariant. Gauge invariance and overlap are logically unrelated.

CORRECTION TO MY OWN FRAMING (recorded by the prover): I had posed this as 'four
obligations, any three insufficient'. That literal claim is TOO STRONG. Once overlap
and the spectral asymptotic estimate are in hand, gauge invariance is NOT analytically
needed for the decay calculation - it remains needed for the intended PHYSICAL
observable interpretation. State the obligations that way, not as a blanket
'any three fail'.

Namespace kept as the prover's ObservableGap. Provenance: verified at pin from task
b6253bcc. Standard three. Claim grade M, [comp]. -/

open Filter Finset
open scoped BigOperators Topology

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# The observable--gap linkage

The spectral input needed for the linkage is isolated as an asymptotic remainder
statement.  This is the finite-dimensional spectral theorem's conclusion after the
top eigenspace has been subtracted: the first excited contribution is explicit and
all lower spectral contributions are in `remainder`.

The final section gives a three-dimensional diagonal, symmetric positive-definite
transfer operator.  It is an explicit counterexample to inferring overlap from gauge
invariance.
-/

namespace ObservableGap

/-- `C` has leading decay base `lam` and amplitude `A`. -/
def HasLeadingDecay (C : ℕ → ℝ) (lam A : ℝ) : Prop :=
  Tendsto (fun n => C n / lam ^ n) atTop (𝓝 A)

/-- The mass associated to a transfer eigenvalue relative to the vacuum eigenvalue. -/
noncomputable def correlationMass (lam0 lam : ℝ) : ℝ := Real.log (lam0 / lam)

/-
The exact spectral linkage.  In a diagonalization, `a = ⟪e₁,v⟫` and
`remainder` is the sum over eigenspaces below the first excited one.
-/
theorem linkage_under_overlap
    (C remainder : ℕ → ℝ) (lam1 a : ℝ) (hlam1 : lam1 ≠ 0)
    (hdecomp : ∀ n, C n = a ^ 2 * lam1 ^ n + remainder n)
    (hrem : Tendsto (fun n => remainder n / lam1 ^ n) atTop (𝓝 0)) :
    HasLeadingDecay C lam1 (a ^ 2) := by
  unfold HasLeadingDecay;
  convert hrem.const_add ( a ^ 2 ) using 2 <;> simp +decide [ *, add_div ]

/-
Nonzero first-excited overlap gives a strictly positive asymptotic amplitude.
-/
theorem overlap_amplitude_pos {a : ℝ} (ha : a ≠ 0) : 0 < a ^ 2 := by
  positivity

/-
Thus the limit in the linkage theorem is positive.
-/
theorem linkage_under_nonzero_overlap
    (C remainder : ℕ → ℝ) (lam1 a : ℝ)
    (hlam1 : lam1 ≠ 0) (ha : a ≠ 0)
    (hdecomp : ∀ n, C n = a ^ 2 * lam1 ^ n + remainder n)
    (hrem : Tendsto (fun n => remainder n / lam1 ^ n) atTop (𝓝 0)) :
    HasLeadingDecay C lam1 (a ^ 2) ∧ 0 < a ^ 2 := by
  exact ⟨ by simpa using linkage_under_overlap C remainder lam1 a hlam1 hdecomp hrem, by positivity ⟩

/-
The usual two expressions for the correlation mass agree.
-/
theorem mass_eq_negative_log_ratio {lam0 lam1 : ℝ} :
    correlationMass lam0 lam1 = -Real.log (lam1 / lam0) := by
  unfold correlationMass; rw [ ← Real.log_inv ] ; rw [ inv_div ] ;

/-
If the first overlap vanishes and the next nonzero spectral contribution has
base `lam2`, then the first-excited normalized correlation tends to zero.
-/
theorem faster_decay_when_first_overlap_zero
    (C : ℕ → ℝ) (lam1 lam2 b : ℝ)
    (h1 : 0 < lam1) (h2 : 0 ≤ lam2) (hlt : lam2 < lam1)
    (hC : ∀ n, C n = b ^ 2 * lam2 ^ n) :
    Tendsto (fun n => C n / lam1 ^ n) atTop (𝓝 0) := by
  simp +decide only [hC];
  simpa [ mul_div_assoc, ← div_pow ] using tendsto_const_nhds.mul ( tendsto_pow_atTop_nhds_zero_of_lt_one ( by positivity ) ( show lam2 / lam1 < 1 by rw [ div_lt_iff₀ h1 ] ; linarith ) )

/-
The next nonzero overlap still identifies its own, smaller decay base.
-/
theorem next_nonzero_overlap_decay
    (C : ℕ → ℝ) (lam2 b : ℝ) (h2 : lam2 ≠ 0)
    (hC : ∀ n, C n = b ^ 2 * lam2 ^ n) :
    HasLeadingDecay C lam2 (b ^ 2) := by
  exact tendsto_const_nhds.congr fun n => by simp +decide [ hC, mul_div_cancel_right₀ _ ( pow_ne_zero n h2 ) ] ;

/-
A smaller positive decay base reports a strictly larger mass.
-/
theorem smaller_base_larger_mass {lam0 lam1 lam2 : ℝ}
    (h0 : 0 < lam0) (h2 : 0 < lam2) (hlt : lam2 < lam1) :
    correlationMass lam0 lam1 < correlationMass lam0 lam2 := by
  refine' Real.log_lt_log _ _;
  · exact div_pos h0 ( by linarith );
  · gcongr

section ConcreteWitness

abbrev E3 := Fin 3 → ℝ

/-- The diagonal transfer spectrum `(3,2,1)`. -/
def witnessEigenvalue : Fin 3 → ℝ := ![3, 2, 1]

/-- Coordinatewise action of the `n`th transfer power. -/
def transferPow (lam : Fin 3 → ℝ) (n : ℕ) (v : E3) : E3 :=
  fun i => lam i ^ n * v i

/-- The Euclidean inner product, written explicitly to keep the witness elementary. -/
def dot (x y : E3) : ℝ := ∑ i, x i * y i

/-- Connected correlation after subtracting the nondegenerate top coordinate. -/
def connectedCorrelation (lam : Fin 3 → ℝ) (v : E3) (n : ℕ) : ℝ :=
  dot v (transferPow lam n v) - v 0 ^ 2 * lam 0 ^ n

/-- The observable has top and next-level components, but zero first-excited overlap. -/
def skippedObservable : E3 := ![1, 0, 1]

/-
Its connected correlation is exactly the faster base `1^n`.
-/
theorem skippedObservable_correlation (n : ℕ) :
    connectedCorrelation witnessEigenvalue skippedObservable n = 1 := by
  -- By definition of `connectedCorrelation`, we have:
  unfold connectedCorrelation dot transferPow witnessEigenvalue skippedObservable
  simp +decide [Fin.sum_univ_three]

/-
The witness therefore has no first-excited amplitude.
-/
theorem skippedObservable_first_overlap : skippedObservable 1 = 0 := by
  rfl

/-
The witness decays strictly faster than the first-excited eigenvalue `2`.
-/
theorem skippedObservable_faster :
    Tendsto (fun n => connectedCorrelation witnessEigenvalue skippedObservable n / 2 ^ n)
      atTop (𝓝 0) := by
  simpa [ skippedObservable_correlation ] using tendsto_inv_atTop_zero.comp ( tendsto_pow_atTop_atTop_of_one_lt one_lt_two )

/-
Its true leading decay base is the next eigenvalue, `1`.
-/
theorem skippedObservable_next_decay :
    HasLeadingDecay (connectedCorrelation witnessEigenvalue skippedObservable) 1 1 := by
  refine' tendsto_const_nhds.congr' _;
  filter_upwards [ Filter.eventually_gt_atTop 0 ] with n hn using by rw [ skippedObservable_correlation ] ; norm_num;

/-
Consequently the reported mass is strictly larger than the transfer gap mass.
-/
theorem skippedObservable_mass_larger :
    correlationMass 3 2 < correlationMass 3 1 := by
  exact Real.log_lt_log ( by norm_num ) ( by norm_num )

/-
Symmetry of the concrete diagonal transfer.
-/
theorem witness_symmetric (x y : E3) :
    dot x (transferPow witnessEigenvalue 1 y) =
      dot (transferPow witnessEigenvalue 1 x) y := by
  unfold dot transferPow; norm_num [ Fin.sum_univ_succ ] ; ring;

/-
Positive-definiteness of the concrete diagonal transfer.
-/
theorem witness_positive_definite (x : E3) (hx : x ≠ 0) :
    0 < dot x (transferPow witnessEigenvalue 1 x) := by
  contrapose! hx;
  unfold dot transferPow at hx;
  unfold witnessEigenvalue at hx; norm_num [ Fin.sum_univ_succ ] at hx;
  exact funext fun i => by fin_cases i <;> norm_num <;> nlinarith! [ sq_nonneg ( x 0 ), sq_nonneg ( x 1 ), sq_nonneg ( x 2 ) ] ;

/-
The witness has a nondegenerate top eigenvalue and a strict first gap.
-/
theorem witness_spectral_gap :
    witnessEigenvalue 1 < witnessEigenvalue 0 ∧
      witnessEigenvalue 2 < witnessEigenvalue 1 := by
  exact ⟨ by exact show ( 2 : ℝ ) < 3 by norm_num, by exact show ( 1 : ℝ ) < 2 by norm_num ⟩

/-- Flip the first-excited coordinate; this is a simple `ℤ/2` gauge action. -/
def gaugeFlip (g : Bool) (v : E3) : E3 :=
  fun i => if g ∧ i = 1 then -v i else v i

/-- Gauge invariance is a property separate from the transfer spectrum. -/
def GaugeInvariant (v : E3) : Prop := ∀ g, gaugeFlip g v = v

/-- The top (constant/vacuum) coordinate is invariant under every gauge flip. -/
def constantObservable : E3 := ![1, 0, 0]

/-
A constant observable is gauge invariant.
-/
theorem constantObservable_invariant : GaugeInvariant constantObservable := by
  intro g; ext i; fin_cases i <;> simp +decide [ gaugeFlip, constantObservable ] ;

/-
But it has zero first-excited overlap.
-/
theorem constantObservable_zero_overlap : constantObservable 1 = 0 := by
  rfl

/-- Conversely the first-excited vector has nonzero overlap. -/
def firstExcitedObservable : E3 := ![0, 1, 0]

theorem firstExcitedObservable_nonzero_overlap : firstExcitedObservable 1 ≠ 0 := by
  -- By definition of `firstExcitedObservable`, we have `firstExcitedObservable 1 = 1`.
  simp [firstExcitedObservable]

/-
Nonzero overlap does not imply gauge invariance either.
-/
theorem firstExcitedObservable_not_invariant :
    ¬ GaugeInvariant firstExcitedObservable := by
  intro h; have := congr_fun ( h Bool.true ) 1; norm_num [ gaugeFlip, firstExcitedObservable ] at this;

/-
The requested three-properties counterexample: gauge invariance, positive transfer,
and a strict spectral gap coexist with zero first-excited overlap.
-/
theorem gauge_positive_gap_do_not_force_overlap :
    GaugeInvariant constantObservable ∧
    (∀ x : E3, x ≠ 0 → 0 < dot x (transferPow witnessEigenvalue 1 x)) ∧
    (witnessEigenvalue 1 < witnessEigenvalue 0) ∧
    constantObservable 1 = 0 := by
  exact ⟨constantObservable_invariant, witness_positive_definite,
    by norm_num [witnessEigenvalue], constantObservable_zero_overlap⟩

end ConcreteWitness

/-- The four obligations that a physical A3 bridge commonly has to establish.
Gauge invariance makes the observable admissible; positivity and the spectral gap
supply the transfer interpretation; overlap is the logically separate linkage. -/
structure A3BridgeObligations where
  gaugeInvariant : Prop
  positiveTransfer : Prop
  spectralGap : Prop
  nonzeroFirstOverlap : Prop

/-- Once all physical obligations and the spectral remainder estimate are available,
the bridge retains the three physical certificates and obtains exact linkage with
strictly positive amplitude. -/
theorem a3_bridge_linkage
    (C remainder : ℕ → ℝ) (lam1 a : ℝ)
    (hlam1 : lam1 ≠ 0)
    (gaugeInvariant positiveTransfer spectralGap : Prop)
    (hg : gaugeInvariant) (hp : positiveTransfer) (hs : spectralGap)
    (ha : a ≠ 0)
    (hdecomp : ∀ n, C n = a ^ 2 * lam1 ^ n + remainder n)
    (hrem : Tendsto (fun n => remainder n / lam1 ^ n) atTop (𝓝 0)) :
    gaugeInvariant ∧ positiveTransfer ∧ spectralGap ∧
      HasLeadingDecay C lam1 (a ^ 2) ∧ 0 < a ^ 2 := by
  exact ⟨hg, hp, hs,
    linkage_under_overlap C remainder lam1 a hlam1 hdecomp hrem,
    overlap_amplitude_pos ha⟩

end ObservableGap
