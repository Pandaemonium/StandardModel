import Mathlib

/-!
# Signed vs unsigned crossing invariant (Opus, verified Aristotle 90a61b95)

CLOSES the gap the HNU homotopy audit named: the unsigned eigenvalue count is NOT
the full Floquet invariant. Defines orientationSign, signedCrossingNumber,
unsignedCrossingNumber from phase derivatives on a regular crossing ledger, and
proves orientation reversal t -> a+b-t NEGATES the signed count while PRESERVING
the unsigned count - exactly the oriented datum a spectral-flow invariant needs.

Namespace kept as the prover's (verbatim, preserving proofs). Provenance:
verified at the pinned toolchain from Aristotle project 90a61b95.
Clean-room Mathlib port; standard three axioms. Claim grade M, [comp]. -/

open scoped BigOperators ComplexConjugate

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace SignedCrossing

/-- The orientation of a regular real crossing. Positive phase velocity means
counterclockwise motion and negative velocity means clockwise motion. -/
noncomputable def orientationSign (v : ℝ) : ℤ :=
  if 0 < v then 1 else if v < 0 then -1 else 0

/-- Signed crossing number of a lifted eigenphase at a finite set of crossing
parameters. A crossing ledger is expected to contain precisely the isolated
solutions of `exp (phase t * I) = 1`, with multiplicity (one ledger per
eigenphase in the diagonal case). -/
noncomputable def signedCrossingNumber (phase : ℝ → ℝ) (crossings : Finset ℝ) : ℤ :=
  ∑ t ∈ crossings, orientationSign (deriv phase t)

/-- The corresponding unsigned regular-crossing count. -/
noncomputable def unsignedCrossingNumber (phase : ℝ → ℝ) (crossings : Finset ℝ) : ℕ :=
  ∑ t ∈ crossings, if deriv phase t = 0 then 0 else 1

/-- A finite ledger contains exactly the `+1` crossings in the half-open
interval and all listed crossings are regular. Finiteness plus exactness makes
the crossings isolated. -/
def IsRegularCrossingLedgerOn (phase : ℝ → ℝ) (a b : ℝ)
    (crossings : Finset ℝ) : Prop :=
  (∀ t ∈ Set.Ico a b,
      (Complex.exp (phase t * Complex.I) = 1 ↔ t ∈ crossings)) ∧
    ∀ t ∈ crossings, deriv phase t ≠ 0

/-- Reflection of a finite crossing ledger when path orientation is reversed. -/
def reverseCrossings (crossings : Finset ℝ) : Finset ℝ :=
  crossings.map ⟨fun t => -t, by intro x y h; linarith⟩

/-
Reversing endpoint-to-endpoint orientation negates the signed count.
-/
theorem signedCrossingNumber_reverse (phase : ℝ → ℝ) (crossings : Finset ℝ)
    (hphase : ∀ t ∈ crossings, DifferentiableAt ℝ phase t) :
    signedCrossingNumber (fun t => phase (-t)) (reverseCrossings crossings) =
      -signedCrossingNumber phase crossings := by
  simp +decide [ signedCrossingNumber, reverseCrossings ];
  rw [ ← Finset.sum_neg_distrib ] ; refine' Finset.sum_congr rfl fun x hx => _ ; rw [ show deriv ( fun t => phase ( -t ) ) ( -x ) = -deriv phase x from _ ] ;
  · unfold orientationSign; split_ifs <;> linarith;
  · erw [ deriv_comp ] <;> norm_num [ hphase x hx ];
    fun_prop

/-
Unlike the signed count, the unsigned count is unchanged by reversal.
-/
theorem unsignedCrossingNumber_reverse (phase : ℝ → ℝ) (crossings : Finset ℝ)
    (hphase : ∀ t ∈ crossings, DifferentiableAt ℝ phase t) :
    unsignedCrossingNumber (fun t => phase (-t)) (reverseCrossings crossings) =
      unsignedCrossingNumber phase crossings := by
  refine' Finset.sum_bij ( fun t ht => -t ) _ _ _ _ <;> simp_all +decide [ reverseCrossings ];
  intro t ht; erw [ deriv_comp ] <;> norm_num [ hphase t ht ] ;
  exact differentiableAt_id.neg

/-- Reflection of a crossing ledger for reversal of a path on `[a,b]`:
`t ↦ a + b - t`. -/
def reverseCrossingsBetween (a b : ℝ) (crossings : Finset ℝ) : Finset ℝ :=
  crossings.map ⟨fun t => a + b - t, by intro x y h; linarith⟩

/-
General endpoint-to-endpoint reversal on `[a,b]` negates the signed count.
-/
theorem signedCrossingNumber_reverseBetween (phase : ℝ → ℝ) (crossings : Finset ℝ)
    (a b : ℝ) (hphase : ∀ t ∈ crossings, DifferentiableAt ℝ phase t) :
    signedCrossingNumber (fun t => phase (a + b - t))
        (reverseCrossingsBetween a b crossings) =
      -signedCrossingNumber phase crossings := by
  unfold signedCrossingNumber reverseCrossingsBetween; simp +decide [ Finset.sum_map ] ;
  rw [ ← Finset.sum_neg_distrib ] ; refine' Finset.sum_congr rfl fun x hx => _ ; rw [ show deriv ( fun t => phase ( a + b - t ) ) ( a + b - x ) = -deriv phase x from _ ] ; unfold orientationSign; split_ifs <;> linarith;
  erw [ deriv_comp ] <;> norm_num [ hphase x hx, sub_eq_add_neg ];
  · erw [ deriv_sub ] <;> norm_num; ring_nf
  · convert hphase x hx using 1 ; ring;
  · fun_prop

/-
General endpoint-to-endpoint reversal preserves the unsigned count.
-/
theorem unsignedCrossingNumber_reverseBetween (phase : ℝ → ℝ) (crossings : Finset ℝ)
    (a b : ℝ) (hphase : ∀ t ∈ crossings, DifferentiableAt ℝ phase t) :
    unsignedCrossingNumber (fun t => phase (a + b - t))
        (reverseCrossingsBetween a b crossings) =
      unsignedCrossingNumber phase crossings := by
  unfold unsignedCrossingNumber reverseCrossingsBetween;
  rw [ Finset.sum_map ];
  refine' Finset.sum_congr rfl fun x hx => _;
  erw [ deriv_comp ] <;> norm_num [ hphase x hx, sub_eq_add_neg ];
  · erw [ deriv_sub ] <;> norm_num; ring_nf
  · convert hphase x hx using 1 ; ring;
  · fun_prop

abbrev Matrix2 := Matrix (Fin 2) (Fin 2) ℂ

/-- A diagonal `2×2` path with moving eigenvalue `exp(i phase)` and fixed
second eigenvalue `-1`. -/
noncomputable def diagonalPath (phase : ℝ → ℝ) (t : ℝ) : Matrix2 :=
  Matrix.diagonal ![Complex.exp (phase t * Complex.I), (-1 : ℂ)]

/-
Every member of `diagonalPath` is unitary.
-/
theorem diagonalPath_unitary (phase : ℝ → ℝ) (t : ℝ) :
    Matrix.conjTranspose (diagonalPath phase t) * diagonalPath phase t = 1 := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, diagonalPath ];
  norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ];
  exact ⟨ by rw [ ← sq, ← sq, Real.cos_sq_add_sin_sq ], by ring ⟩

/-
A continuous phase gives a continuous path of unitary matrices.
-/
theorem continuous_diagonalPath {phase : ℝ → ℝ} (hphase : Continuous phase) :
    Continuous (diagonalPath phase) := by
  exact continuous_pi_iff.mpr fun i => continuous_pi_iff.mpr fun j => by fin_cases i <;> fin_cases j <;> continuity;

/-- Counterclockwise and clockwise one-turn eigenphases. The half-open
endpoint convention counts each crossing of the resulting loop once. -/
noncomputable def ccwPhase (t : ℝ) : ℝ := 2 * Real.pi * t
noncomputable def cwPhase (t : ℝ) : ℝ := -(2 * Real.pi * t)

noncomputable def ccwPath : ℝ → Matrix2 := diagonalPath ccwPhase
noncomputable def cwPath : ℝ → Matrix2 := diagonalPath cwPhase

def oneCrossing : Finset ℝ := {0}

/-
In the fundamental half-open parameter interval, the counterclockwise
moving eigenvalue meets `+1` exactly at zero.
-/
theorem ccw_crossing_exact {t : ℝ} (ht : t ∈ Set.Ico (-(1 / 2 : ℝ)) (1 / 2 : ℝ)) :
    Complex.exp (ccwPhase t * Complex.I) = 1 ↔ t = 0 := by
  rw [ Complex.exp_eq_one_iff ] ; norm_num [ ccwPhase ];
  norm_num [ Complex.ext_iff, mul_assoc, mul_left_comm ];
  exact ⟨ fun ⟨ n, hn ⟩ => by rcases n with ⟨ _ | _ | n ⟩ <;> norm_num at * <;> nlinarith [ Real.pi_pos ], fun hn => ⟨ 0, by norm_num [ hn ] ⟩ ⟩

/-
The analogous exact crossing statement for clockwise traversal.
-/
theorem cw_crossing_exact {t : ℝ} (ht : t ∈ Set.Ico (-(1 / 2 : ℝ)) (1 / 2 : ℝ)) :
    Complex.exp (cwPhase t * Complex.I) = 1 ↔ t = 0 := by
  rw [ Complex.exp_eq_one_iff ] ; norm_num [ cwPhase ];
  norm_num [ Complex.ext_iff ];
  exact ⟨ fun ⟨ n, hn ⟩ => by rcases n with ⟨ _ | _ | n ⟩ <;> norm_num at * <;> nlinarith [ Real.pi_pos ], fun hn => ⟨ 0, by norm_num [ hn ] ⟩ ⟩

/-
`{0}` is the complete regular crossing ledger for the counterclockwise
path on the chosen half-open fundamental interval.
-/
theorem ccw_regular_crossing_ledger :
    IsRegularCrossingLedgerOn ccwPhase (-(1 / 2 : ℝ)) (1 / 2 : ℝ) oneCrossing := by
  constructor;
  · intro t ht; rw [ ccw_crossing_exact ht ] ; norm_num [ oneCrossing ] ;
  · unfold oneCrossing ccwPhase; norm_num;
    norm_num [ mul_comm ]

/-
`{0}` is also the complete regular crossing ledger for the clockwise path.
-/
theorem cw_regular_crossing_ledger :
    IsRegularCrossingLedgerOn cwPhase (-(1 / 2 : ℝ)) (1 / 2 : ℝ) oneCrossing := by
  constructor;
  · exact fun t ht => by rw [ cw_crossing_exact ht ] ; norm_num [ oneCrossing ] ;
  · unfold oneCrossing cwPhase; norm_num [ mul_comm ] ;

/-
The two explicit paths have the same unsigned crossing count.
-/
theorem explicit_same_unsigned :
    unsignedCrossingNumber ccwPhase oneCrossing = 1 ∧
    unsignedCrossingNumber cwPhase oneCrossing = 1 := by
  unfold unsignedCrossingNumber oneCrossing ;
  unfold ccwPhase cwPhase; norm_num [ mul_comm ] ;

/-
Their signed crossing counts are opposite.
-/
theorem explicit_opposite_signed :
    signedCrossingNumber ccwPhase oneCrossing = 1 ∧
    signedCrossingNumber cwPhase oneCrossing = -1 := by
  unfold signedCrossingNumber oneCrossing ;
  unfold orientationSign ccwPhase cwPhase; norm_num [ mul_comm ] ;
  exact ⟨ fun h => by linarith [ Real.pi_pos ], by rw [ if_neg ( by linarith [ Real.pi_pos ] ), if_pos ( by linarith [ Real.pi_pos ] ) ] ⟩

/-
Thus unsigned crossing data does not determine signed crossing data.
-/
theorem signed_strictly_finer :
    unsignedCrossingNumber ccwPhase oneCrossing =
        unsignedCrossingNumber cwPhase oneCrossing ∧
      signedCrossingNumber ccwPhase oneCrossing ≠
        signedCrossingNumber cwPhase oneCrossing := by
  unfold unsignedCrossingNumber signedCrossingNumber; norm_num [ oneCrossing ] ;
  unfold ccwPhase cwPhase; norm_num [ mul_comm ] ;
  unfold orientationSign; norm_num [ Real.pi_pos ] ;

/-
The determinant of the diagonal path.
-/
theorem det_diagonalPath (phase : ℝ → ℝ) (t : ℝ) :
    Matrix.det (diagonalPath phase t) = -Complex.exp (phase t * Complex.I) := by
  unfold diagonalPath; norm_num

/-- For a lifted determinant phase, its net winding over `[a,b]` is the net
phase change divided by `2π`. This is integral for a closed diagonal path. -/
noncomputable def determinantNetWinding (phase : ℝ → ℝ) (a b : ℝ) : ℝ :=
  (phase b - phase a) / (2 * Real.pi)

/-
Precise diagonal relation: on one traversal of the half-open fundamental
interval, signed eigenvalue crossing count equals the net winding of the
determinant. The fixed `-1` contributes a constant phase and hence no winding.
-/
theorem ccw_signed_eq_det_winding :
    (signedCrossingNumber ccwPhase oneCrossing : ℝ) =
      determinantNetWinding ccwPhase (-(1 / 2 : ℝ)) (1 / 2 : ℝ) := by
  unfold signedCrossingNumber determinantNetWinding; norm_num [ oneCrossing ] ;
  unfold orientationSign ccwPhase; norm_num [ mul_comm ] ; ring_nf;
  rw [ if_pos Real.pi_pos, mul_inv_cancel₀ Real.pi_ne_zero ]

/-
The same winding relation for the reversed (clockwise) diagonal path.
-/
theorem cw_signed_eq_det_winding :
    (signedCrossingNumber cwPhase oneCrossing : ℝ) =
      determinantNetWinding cwPhase (-(1 / 2 : ℝ)) (1 / 2 : ℝ) := by
  unfold signedCrossingNumber determinantNetWinding;
  unfold orientationSign cwPhase; norm_num [ mul_comm ] ; ring_nf; norm_num [ Real.pi_ne_zero ] ;
  rw [ if_neg ( by linarith [ Real.pi_pos ] ), if_pos ( by linarith [ Real.pi_pos ] ) ] ; norm_cast

end SignedCrossing
