import Mathlib

/-!
# Weyl-generator claim audit (Opus, verified Aristotle d2e6ba9b)

Independent adversarial audit of the SHAPE of a pointwise two-component Weyl
generator claim, requested by Codex (msg-20260720-084102). Kernel witnesses:
* two unitary-on-the-real-axis families with the SAME derivative -iG at zero but
  DIFFERENT quadratic behaviour (one with error/||z||^2 -> 1, the other exactly 0)
  - so a derivative theorem does NOT state or prove an O(eps^2) rate, and does not
  determine the quadratic coefficient;
* a sign witness: the -iG and +iG derivative claims are genuinely unequal;
* explicit noncommuting A,B with AB != BA and exp A exp B != exp B exp A, so a
  summed first-order generator hides an ordering choice at second order;
* a concrete nonzero witness (q=(0,0,1), G=diag(1,-1)) discharging vacuity.

VERDICTS: vacuity discharged only by the concrete witness (not by an abstract
derivative claim); hollow telescoping NOT excluded by a summed first-order formula
(factor-level ordering must be exposed); docstring-outruns-kernel if a derivative
theorem is cited as a rate; false shape - sign AND multiplication order are both
load-bearing, not conventional.

Namespace kept as the prover's WeylAudit. Provenance: verified at pin from task
9cf72cfd. Standard three. Grade M, [orig] (independent-review artifact). -/

open scoped BigOperators
open Filter Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace WeylAudit

abbrev M2 := Matrix (Fin 2) (Fin 2) ℂ

/-- Entrywise derivative, the finite-dimensional derivative notion needed by the audit. -/
def EntrywiseHasDerivAt (W W' : ℂ → M2) (z : ℂ) : Prop :=
  ∀ i j, HasDerivAt (fun t => W t i j) (W' z i j) z

/-- The concrete nonzero momentum used in the non-vacuity witness. -/
def q : Fin 3 → ℝ := ![0, 0, 1]

/-- Pauli sigma-z, hence `sigma · q` for the concrete `q` above. -/
def G : M2 := !![1, 0; 0, -1]

/-- The exact exponential family for the generator `G`. -/
noncomputable def Wexact (z : ℂ) : M2 :=
  Matrix.diagonal (fun j => Complex.exp (-Complex.I * z * G j j))

/-
The diagonal presentation really is the Banach-algebra exponential `exp (-i z G)`.
-/
theorem Wexact_eq_matrix_exp (z : ℂ) :
    Wexact z = NormedSpace.exp ((-Complex.I * z) • G) := by
  convert ( Matrix.exp_diagonal _ ) |> Eq.symm;
  rotate_right;
  exact fun j => -Complex.I * z * G j j;
  all_goals try infer_instance;
  · ext i j; by_cases hi : i = j <;> simp +decide [ hi, Wexact, G ];
    rw [ Complex.exp_eq_exp_ℂ ];
  · ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ G ]

/-- A unitary-on-the-real-axis perturbation which first differs at quadratic order. -/
noncomputable def Wquadratic (z : ℂ) : M2 :=
  Matrix.diagonal (fun j => Complex.exp (-Complex.I * z * G j j + Complex.I * z ^ 2))

/-- The opposite-sign family. -/
noncomputable def Wopposite (z : ℂ) : M2 :=
  Matrix.diagonal (fun j => Complex.exp (Complex.I * z * G j j))

/-
Both families have exactly the claimed pointwise derivative at zero.
-/
theorem same_first_derivative :
    EntrywiseHasDerivAt Wexact (fun _ => -Complex.I • G) 0 ∧
      EntrywiseHasDerivAt Wquadratic (fun _ => -Complex.I • G) 0 := by
  constructor <;> intro i j <;> fin_cases i <;> fin_cases j <;> norm_num [ G, Matrix.mulVec ];
  all_goals norm_num [ Wexact, Wquadratic, G ];
  any_goals exact hasDerivAt_const _ _;
  · simpa using HasDerivAt.comp 0 ( Complex.hasDerivAt_exp _ ) ( HasDerivAt.neg ( HasDerivAt.const_mul Complex.I ( hasDerivAt_id 0 ) ) );
  · simpa using HasDerivAt.comp 0 ( Complex.hasDerivAt_exp _ ) ( HasDerivAt.const_mul Complex.I ( hasDerivAt_id 0 ) );
  · convert HasDerivAt.comp 0 ( Complex.hasDerivAt_exp _ ) ( HasDerivAt.add ( HasDerivAt.neg ( HasDerivAt.const_mul Complex.I ( hasDerivAt_id 0 ) ) ) ( HasDerivAt.const_mul Complex.I ( hasDerivAt_pow 2 0 ) ) ) using 1 ; norm_num;
  · convert HasDerivAt.comp 0 ( Complex.hasDerivAt_exp _ ) ( HasDerivAt.add ( HasDerivAt.const_mul Complex.I ( hasDerivAt_id 0 ) ) ( HasDerivAt.const_mul Complex.I ( hasDerivAt_pow 2 0 ) ) ) using 1 ; norm_num

/-
The exact family has zero error, while the perturbed family's `(0,0)` error has
nonzero quadratic coefficient `I`: this is the precise second-order witness.
-/
theorem quadratic_error_witness :
    (∀ z, (Wexact z - Wexact z) 0 0 = 0) ∧
      Tendsto (fun z : ℂ => ((Wquadratic z - Wexact z) 0 0) / z ^ 2)
        (nhdsWithin 0 ({0}ᶜ)) (nhds Complex.I) := by
  simp +zetaDelta at *;
  unfold Wquadratic Wexact;
  unfold G; norm_num [ mul_comm Complex.I ] ; ring; norm_num;
  -- Factor out $e^{-iz}$:
  suffices h_suff : Filter.Tendsto (fun z : ℂ => (Complex.exp (z ^ 2 * Complex.I) - 1) / z ^ 2) (nhdsWithin 0 {0}ᶜ) (nhds Complex.I) by
    convert h_suff.mul ( Continuous.continuousWithinAt ( show Continuous fun z : ℂ => Complex.exp ( - ( z * Complex.I ) ) by continuity ) ) using 2 <;> ring;
    · rw [ Complex.exp_add ] ; ring;
    · norm_num;
  have h_exp : Filter.Tendsto (fun z : ℂ => (Complex.exp (z * Complex.I) - 1) / z) (nhdsWithin 0 {0}ᶜ) (nhds Complex.I) := by
    simpa [ div_eq_inv_mul ] using HasDerivAt.tendsto_slope_zero ( HasDerivAt.comp 0 ( Complex.hasDerivAt_exp _ ) ( hasDerivAt_mul_const Complex.I ) );
  exact h_exp.comp ( Filter.Tendsto.inf ( Continuous.tendsto' ( by continuity ) _ _ <| by norm_num ) <| by norm_num )

/-
The same witness stated as a genuine distance: the `(0,0)` component distance
has nonzero quadratic scale.
-/
theorem quadratic_entry_distance_witness :
    Tendsto
      (fun z : ℂ =>
        dist (Wquadratic z 0 0) (Wexact z 0 0) / ‖z‖ ^ 2)
      (nhdsWithin 0 ({0}ᶜ)) (nhds 1) := by
  -- Use the fact that the limit of a quotient is the quotient of the limits, provided the denominator does not tend to 0.
  have h_quot : Filter.Tendsto (fun z : ℂ => ((Wquadratic z - Wexact z) 0 0) / z^2) (nhdsWithin 0 ({0}ᶜ)) (nhds Complex.I) := by
    convert quadratic_error_witness.2 using 1;
  simpa [ dist_eq_norm, norm_div, norm_pow ] using h_quot.norm

/-
On real parameters both displayed families really are unitary.
-/
theorem families_unitary_on_real_axis (t : ℝ) :
    star (Wexact t) * Wexact t = 1 ∧
      star (Wquadratic t) * Wquadratic t = 1 := by
  unfold Wexact Wquadratic;
  norm_num [ ← Matrix.ext_iff, Fin.forall_fin_two, Complex.ext_iff, Complex.exp_re, Complex.exp_im ];
  unfold G; norm_num [ sq, Complex.exp_re, Complex.exp_im ] ; ring_nf; norm_num [ Real.cos_sq' ] ;

/-
The scalar sign is load-bearing: the two derivatives are negatives and are unequal.
-/
theorem sign_orientation_witness :
    EntrywiseHasDerivAt Wexact (fun _ => -Complex.I • G) 0 ∧
      EntrywiseHasDerivAt Wopposite (fun _ => Complex.I • G) 0 ∧
      (-Complex.I • G : M2) ≠ Complex.I • G := by
  refine' ⟨ _, _, _ ⟩;
  · exact same_first_derivative.1;
  · intro i j; fin_cases i <;> fin_cases j <;> norm_num [ EntrywiseHasDerivAt, Wopposite, G ];
    · simpa using HasDerivAt.comp 0 ( Complex.hasDerivAt_exp _ ) ( HasDerivAt.const_mul Complex.I ( hasDerivAt_id 0 ) );
    · exact hasDerivAt_const _ _;
    · exact hasDerivAt_const _ _;
    · simpa using HasDerivAt.comp 0 ( Complex.hasDerivAt_exp _ ) ( HasDerivAt.neg ( HasDerivAt.const_mul Complex.I ( hasDerivAt_id 0 ) ) );
  · intro h; have := congrFun ( congrFun h 0 ) 0; norm_num [ G ] at this;
    norm_num [ Complex.ext_iff ] at this

/-- Two explicit noncommuting matrices for the multiplication-order audit. -/
def A : M2 := !![1, 0; 0, 0]
def B : M2 := !![0, 1; 0, 0]

/-
Exponential products genuinely depend on multiplication orientation.
-/
theorem exponential_order_witness :
    A * B ≠ B * A ∧
      NormedSpace.exp A * NormedSpace.exp B ≠
        NormedSpace.exp B * NormedSpace.exp A := by
  constructor
  · intro h
    have h01 := congrFun (congrFun h 0) 1
    norm_num [A, B, Matrix.mul_apply] at h01
  ·
    -- Use the Lie series expansion to simplify the exponentials.
    have h_exp_A : NormedSpace.exp A = Matrix.diagonal (fun j => Complex.exp (if j = 0 then 1 else 0)) := by
      convert Matrix.exp_diagonal _;
      any_goals try infer_instance;
      rotate_right;
      exact fun i => if i = 0 then 1 else 0;
      · ext i j ; fin_cases i <;> fin_cases j <;> rfl;
      · split_ifs <;> simp +decide [*, Complex.exp_eq_exp_ℂ]
    have h_exp_B : NormedSpace.exp B = 1 + B := by
      -- By definition of $B$, we know that $B^2 = 0$.
      have hB_sq : B^2 = 0 := by
        ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ sq, B ] ;
      simp +decide [NormedSpace.exp];
      split_ifs <;> simp_all +decide [pow_succ'];
      · simp +decide [NormedSpace.expSeries_sum_eq];
        rw [ tsum_eq_sum ];
        any_goals exact { 0, 1 };
        · norm_num [ Algebra.smul_def ];
        · intro b hb; rcases b with ( _ | _ | b ) <;> simp_all +decide [ pow_succ' ] ;
          simp_all +decide [← mul_assoc];
          norm_num [ Algebra.smul_def ];
      · exact False.elim <| ‹IsEmpty ( Algebra ℚ M2 ) ›.elim' <| inferInstance;
    simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two ];
    simp_all +decide [ Matrix.mul_apply, B ];
    norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ]

/-
The concrete momentum and its Weyl generator are both nonzero.
-/
theorem nonvacuity_witness : q ≠ 0 ∧ G ≠ 0 ∧ (-Complex.I • G : M2) ≠ 0 := by
  refine' ⟨ _, _, _ ⟩;
  · exact ne_of_apply_ne ( fun x => x 2 ) one_ne_zero;
  · exact ne_of_apply_ne ( fun m => m 0 0 ) one_ne_zero;
  · exact ne_of_apply_ne ( fun m => m 0 0 ) ( by norm_num [ Complex.ext_iff, G ] )

/-
The concrete exact family has the nonzero advertised generator.
-/
theorem concrete_generator_witness :
    EntrywiseHasDerivAt Wexact (fun _ => -Complex.I • G) 0 ∧
      (-Complex.I • G : M2) ≠ 0 := by
  -- Apply the results from same_first_derivative and nonvacuity_witness to conclude the proof.
  apply And.intro (same_first_derivative.left) (nonvacuity_witness.right.right)

end WeylAudit
