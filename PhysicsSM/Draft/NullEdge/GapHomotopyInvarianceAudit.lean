import Mathlib

/-!
# Gapped-unitary homotopy invariance audit (Opus, verified 83cd8f08)

Independent 3+1 audit supporting the HNU massive-gap homotopy claim: the
upper-half-circle eigenvalue multiplicity is CONSTANT along a continuous path of
unitaries avoiding both `+1` and `-1` (det-to-gap implication); a gapped path (endpoint
counts both 1) + crossing path (count jumps 0->1) show the gap hypothesis is
essential. IMPORTANT: the FULL Floquet/spectral-flow invariant additionally needs
oriented crossing sign + chirality/topological charge + multiplicity (reversing
orientation preserves the unsigned count but reverses the signed invariant).
Interface note: Mathlib lacks a directly reusable global continuous
eigenvalue-selection theorem; made explicit here via the characteristic polynomial.
Namespace kept as prover's GapAudit. Provenance: verified at pin from task
8cdf652f. Standard three. Grade M, [orig] (independent-review artifact). -/

open scoped BigOperators ComplexConjugate
open Set Matrix Complex

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace GapAudit

/-- A labelled, continuous enumeration of a finite-dimensional spectrum along a path.
This is the exact abstract datum needed to reduce spectral stability to the intermediate
value theorem; algebraic multiplicity is represented by the labels. -/
structure SpectralBranches (m : ℕ) where
  value : Fin m → Set.Icc (0 : ℝ) 1 → ℂ
  continuous_value : ∀ j, Continuous (value j)
  on_circle : ∀ j t, ‖value j t‖ = 1

/-- Number (with multiplicity) of labelled eigenvalues in the open upper semicircle. -/
noncomputable def upperCount {m : ℕ} (E : SpectralBranches m) (t : Set.Icc (0 : ℝ) 1) : ℕ :=
  ((Finset.univ : Finset (Fin m)).filter fun j => 0 < (E.value j t).im).card

/-
On the unit circle, a point with zero imaginary part is one of the two gap points.
-/
lemma unitCircle_im_eq_zero {z : ℂ} (hz : ‖z‖ = 1) (him : z.im = 0) :
    z = 1 ∨ z = -1 := by
  simp_all +decide [ Complex.ext_iff ];
  exact eq_or_eq_neg_of_sq_eq_sq _ _ <| by simpa [ Complex.normSq_apply, Complex.norm_def, sq, him ] using hz;

/-
A single continuous eigenvalue branch cannot change semicircle without hitting `+1` or `-1`.
-/
lemma branch_upper_iff {f : Set.Icc (0 : ℝ) 1 → ℂ} (hf : Continuous f)
    (hcircle : ∀ t, ‖f t‖ = 1) (hgap : ∀ t, f t ≠ 1 ∧ f t ≠ -1)
    (s t : Set.Icc (0 : ℝ) 1) :
    (0 < (f s).im ↔ 0 < (f t).im) := by
  -- Since the image of the complex conjugate of $f$ is the same as the image of $f$, it suffices to show that the function values at $s$ and $t$ belong to one of the four quadrants.
  have h_quad : (∀ t : (Set.Icc 0 1), (f t).im ≠ 0) := by
    grind +suggestions;
  contrapose! h_quad;
  -- By the intermediate value theorem, since $f$ is continuous and its image is connected, if $(f s).im$ and $(f t).im$ have opposite signs, there must be some $c \in [s, t]$ such that $(f c).im = 0$.
  have h_ivt : IsConnected (Set.range (fun t : (Set.Icc 0 1) => (f t).im)) := by
    exact isConnected_range ( Complex.continuous_im.comp hf );
  cases' h_quad with h_quad h_quad <;> [ exact h_ivt.Icc_subset ( Set.mem_range_self t ) ( Set.mem_range_self s ) ⟨ h_quad.2, h_quad.1.le ⟩ ; exact h_ivt.Icc_subset ( Set.mem_range_self s ) ( Set.mem_range_self t ) ⟨ h_quad.1, h_quad.2.le ⟩ ]

/-
**Gapped-path invariance.**  For continuously labelled eigenvalues of unitary matrices,
absence of both real unit-circle eigenvalues makes the upper-half-circle multiplicity constant.
For a matrix path, the labels are an enumeration of the roots of its characteristic polynomial,
so this is precisely the eigenvalue count with algebraic multiplicity.
-/
theorem upperCount_constant {m : ℕ} (E : SpectralBranches m)
    (hgap : ∀ j t, E.value j t ≠ 1 ∧ E.value j t ≠ -1)
    (s t : Set.Icc (0 : ℝ) 1) :
    upperCount E s = upperCount E t := by
  refine' Finset.card_bij ( fun j hj => j ) _ _ _ <;> simp +decide [ * ];
  · exact fun j hj => branch_upper_iff ( E.continuous_value j ) ( fun t => E.on_circle j t ) ( fun t => hgap j t ) s t |>.1 hj;
  · exact fun j hj => branch_upper_iff ( E.continuous_value j ) ( E.on_circle j ) ( hgap j ) t s |>.1 hj

/-
A determinant formulation of the gap, for any alleged eigenvalue branch supplied with an
actual eigenvector.  Thus `det(U-I) ≠ 0` and `det(U+I) ≠ 0` imply the branch gap used above.
-/
lemma branch_gap_of_det {m : Type} [Fintype m] [DecidableEq m]
    (U : Matrix m m ℂ) (z : ℂ) (v : m → ℂ) (hv : v ≠ 0)
    (heig : U *ᵥ v = z • v)
    (hplus : (U - 1).det ≠ 0) (hminus : (U + 1).det ≠ 0) :
    z ≠ 1 ∧ z ≠ -1 := by
  constructor <;> intro h <;> simp_all +decide [ ← Matrix.exists_mulVec_eq_zero_iff ];
  · exact hplus v hv ( by simpa [ sub_mul, Matrix.sub_mulVec ] using sub_eq_zero.mpr heig );
  · exact hminus v hv ( by simpa [ Matrix.add_mulVec, heig ] )

/-- Matrix-path version of `upperCount_constant`.  `E` is a continuous enumeration of all
`m` eigenvalues (with algebraic multiplicity); `v` certifies each label as an eigenvalue.
The continuity/unitarity/completeness assumptions record the advertised matrix setting.  Once the
continuous spectral enumeration has been supplied, determinant gaps give the branch gaps and the
counting argument is `upperCount_constant`. -/
theorem matrix_upperCount_constant {m : ℕ}
    (U : Set.Icc (0 : ℝ) 1 → Matrix (Fin m) (Fin m) ℂ)
    (hUcont : ∀ i j, Continuous (fun t => U t i j))
    (hunitary : ∀ t, star (U t) * U t = 1)
    (hdetPlus : ∀ t, (U t - 1).det ≠ 0)
    (hdetMinus : ∀ t, (U t + 1).det ≠ 0)
    (E : SpectralBranches m)
    (v : Fin m → Set.Icc (0 : ℝ) 1 → Fin m → ℂ)
    (hv : ∀ j t, v j t ≠ 0)
    (heig : ∀ j t, U t *ᵥ v j t = E.value j t • v j t)
    (hcomplete : ∀ t,
      (U t).charpoly = ∏ j : Fin m, (Polynomial.X - Polynomial.C (E.value j t)))
    (s t : Set.Icc (0 : ℝ) 1) :
    upperCount E s = upperCount E t := by
  have hgap : ∀ j t, E.value j t ≠ 1 ∧ E.value j t ≠ -1 := by
    intro j x
    exact branch_gap_of_det (U x) (E.value j x) (v j x) (hv j x) (heig j x)
      (hdetPlus x) (hdetMinus x)
  exact upperCount_constant E hgap s t

/-- The rational parametrization of the unit circle.  It passes through `+1` at `q = 0`. -/
noncomputable def cayleyCircle (q : ℝ) : ℂ :=
  ((1 - q^2) / (1 + q^2) : ℝ) + (((2*q) / (1 + q^2) : ℝ) * Complex.I)

lemma cayleyCircle_re (q : ℝ) : (cayleyCircle q).re = (1-q^2)/(1+q^2) := by
  unfold cayleyCircle; norm_num;
  norm_cast ; norm_num;
  norm_num [ div_eq_mul_inv ];
  norm_cast ; norm_num

lemma cayleyCircle_im (q : ℝ) : (cayleyCircle q).im = (2*q)/(1+q^2) := by
  norm_num [ cayleyCircle ] ; ring;
  norm_cast ; norm_num

lemma cayleyCircle_norm (q : ℝ) : ‖cayleyCircle q‖ = 1 := by
  norm_num [ Complex.normSq, Complex.norm_def, cayleyCircle ];
  norm_cast; ring_nf;
  norm_cast ; norm_num ; ring;
  -- Combine like terms and simplify the expression.
  field_simp
  ring

lemma cayleyCircle_eq_one_iff (q : ℝ) : cayleyCircle q = 1 ↔ q = 0 := by
  unfold cayleyCircle; simp [Complex.ext_iff]; (
  norm_cast; ring_nf;
  norm_cast; exact ⟨ fun h => by nlinarith [ mul_inv_cancel₀ ( by positivity : ( 1 + q ^ 2 ) ≠ 0 ) ], fun h => by norm_num [ h ] ⟩ ;);

lemma cayleyCircle_ne_neg_one (q : ℝ) : cayleyCircle q ≠ -1 := by
  unfold cayleyCircle;
  norm_num [ Complex.ext_iff ];
  norm_cast; ring_nf;
  norm_cast ; norm_num ; intros ; nlinarith [ mul_inv_cancel₀ ( by positivity : ( 1 + q ^ 2 ) ≠ 0 ) ]

lemma continuous_cayleyCircle : Continuous cayleyCircle := by
  refine' Continuous.add _ _;
  · exact Complex.continuous_ofReal.comp <| Continuous.div ( by continuity ) ( by continuity ) fun q => by positivity;
  · exact Continuous.mul ( Complex.continuous_ofReal.comp <| Continuous.div ( continuous_const.mul continuous_id' ) ( continuous_const.add <| continuous_pow 2 ) fun x => by positivity ) continuous_const

lemma continuous_gapped_value (j : Fin 2) :
    Continuous (fun t : Set.Icc (0 : ℝ) 1 =>
      if j = 0 then cayleyCircle (1 + t.1) else conj (cayleyCircle (1 + t.1))) := by
  fin_cases j <;> simp +decide [ continuous_const ];
  · exact continuous_cayleyCircle.comp ( continuous_const.add continuous_subtype_val );
  · exact Complex.continuous_conj.comp ( continuous_cayleyCircle.comp <| by continuity )

lemma norm_gapped_value (j : Fin 2) (t : Set.Icc (0 : ℝ) 1) :
    ‖if j = 0 then cayleyCircle (1 + t.1) else conj (cayleyCircle (1 + t.1))‖ = 1 := by
  split_ifs <;> simp_all +decide [ Complex.norm_conj, cayleyCircle_norm ]

/-- A concrete nonconstant two-band gapped path: one band stays in each open semicircle. -/
noncomputable def gappedBranches : SpectralBranches 2 where
  value j t := if j = 0 then cayleyCircle (1 + t.1) else conj (cayleyCircle (1 + t.1))
  continuous_value := continuous_gapped_value
  on_circle := norm_gapped_value

lemma gappedBranches_gap (j : Fin 2) (t : Set.Icc (0 : ℝ) 1) :
    gappedBranches.value j t ≠ 1 ∧ gappedBranches.value j t ≠ -1 := by
  unfold gappedBranches;
  fin_cases j <;> simp_all +decide [ Complex.ext_iff ]; all_goals grind +suggestions

/-- The diagonal `2 × 2` unitary matrix path represented by `gappedBranches`. -/
noncomputable def gappedMatrix (t : Set.Icc (0 : ℝ) 1) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.diagonal (fun j => gappedBranches.value j t)

lemma gappedMatrix_continuous (i j : Fin 2) :
    Continuous (fun t => gappedMatrix t i j) := by
  fin_cases i <;> fin_cases j <;> simp +decide [ gappedMatrix ];
  · exact gappedBranches.continuous_value 0;
  · exact continuous_const;
  · exact continuous_const;
  · exact gappedBranches.continuous_value 1

lemma gappedMatrix_unitary (t : Set.Icc (0 : ℝ) 1) :
    star (gappedMatrix t) * gappedMatrix t = 1 := by
  ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ *, Matrix.mul_apply ];
  · simp +decide [ gappedMatrix ];
    rw [ mul_comm, Complex.mul_conj, Complex.normSq_eq_norm_sq ] ; norm_num [ gappedBranches ];
    exact Or.inl ( cayleyCircle_norm _ );
  · unfold gappedMatrix; norm_num [ Complex.ext_iff ] ;
  · unfold gappedMatrix; aesop;
  · unfold gappedMatrix; simp +decide [ gappedBranches ] ;
    rw [ Complex.mul_conj, Complex.normSq_eq_norm_sq ] ; norm_num [ cayleyCircle_norm ]

lemma gappedMatrix_det_gaps (t : Set.Icc (0 : ℝ) 1) :
    (gappedMatrix t - 1).det ≠ 0 ∧ (gappedMatrix t + 1).det ≠ 0 := by
  constructor <;> simp_all +decide [ sub_eq_iff_eq_add, add_eq_zero_iff_eq_neg, Matrix.det_fin_two, gappedMatrix ];
  · exact ⟨ gappedBranches_gap 0 t |>.1, gappedBranches_gap 1 t |>.1 ⟩;
  · exact ⟨ gappedBranches_gap 0 t |>.2, gappedBranches_gap 1 t |>.2 ⟩

/-
The concrete gapped path has the same count (one) at both endpoints.
-/
theorem gapped_endpoint_counts :
    upperCount gappedBranches ⟨0, by norm_num⟩ = 1 ∧
    upperCount gappedBranches ⟨1, by norm_num⟩ = 1 := by
  unfold upperCount; simp +decide [ gappedBranches ] ;
  norm_num [ Finset.card, cayleyCircle ];
  erw [ Multiset.coe_card, Multiset.coe_card ];
  norm_num [ List.finRange, Complex.ext_iff, div_eq_mul_inv ]

lemma continuous_crossing_value (j : Fin 2) :
    Continuous (fun t : Set.Icc (0 : ℝ) 1 =>
      if j = 0 then cayleyCircle (t.1 - (1/2 : ℝ)) else -Complex.I) := by
  fin_cases j <;> simp +decide [ continuous_const ];
  convert continuous_cayleyCircle.comp ( continuous_subtype_val.sub continuous_const ) using 1

lemma norm_crossing_value (j : Fin 2) (t : Set.Icc (0 : ℝ) 1) :
    ‖if j = 0 then cayleyCircle (t.1 - (1/2 : ℝ)) else -Complex.I‖ = 1 := by
  split_ifs <;> norm_num [ cayleyCircle_norm ]

/-- A non-gapped two-band path.  Its first band crosses `+1` at `t=1/2`; its second
band is fixed at `-i`. -/
noncomputable def crossingBranches : SpectralBranches 2 where
  value j t := if j = 0 then cayleyCircle (t.1 - (1/2 : ℝ)) else -Complex.I
  continuous_value := continuous_crossing_value
  on_circle := norm_crossing_value

/-- The diagonal `2 × 2` unitary matrix path represented by `crossingBranches`. -/
noncomputable def crossingMatrix (t : Set.Icc (0 : ℝ) 1) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.diagonal (fun j => crossingBranches.value j t)

lemma crossingMatrix_continuous (i j : Fin 2) :
    Continuous (fun t => crossingMatrix t i j) := by
  by_cases hij : i = j <;> simp_all +decide [ crossingMatrix ];
  · exact crossingBranches.continuous_value j;
  · exact continuous_const

lemma crossingMatrix_unitary (t : Set.Icc (0 : ℝ) 1) :
    star (crossingMatrix t) * crossingMatrix t = 1 := by
  ext i j; by_cases hi : i = j <;> simp_all +decide [ Matrix.mul_apply, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, mul_assoc, mul_left_comm, mul_comm ] ;
  · fin_cases i <;> fin_cases j <;> simp_all +decide [ Matrix.one_apply, crossingMatrix ];
    · rw [ Complex.mul_conj, Complex.normSq_eq_norm_sq ] ; norm_num [ crossingBranches ];
      exact Or.inl ( cayleyCircle_norm _ );
    · unfold crossingBranches; norm_num [ Complex.ext_iff ] ;
  · fin_cases i <;> fin_cases j <;> simp_all +decide [ crossingMatrix ]

/-
The crossing really occurs at the gap point `+1`.
-/
theorem crossing_hits_one :
    crossingBranches.value 0 ⟨(1/2 : ℝ), by norm_num⟩ = 1 := by
  unfold crossingBranches; norm_num [ cayleyCircle_eq_one_iff ] ;

/-
At the crossing the `+1` determinant gap fails.
-/
theorem crossing_det_gap_fails :
    (crossingMatrix ⟨(1/2 : ℝ), by norm_num⟩ - 1).det = 0 := by
  unfold crossingMatrix; norm_num [ Matrix.det_fin_two ] ;
  exact Or.inl ( sub_eq_zero_of_eq <| by exact crossing_hits_one )

/-
On opposite sides of the crossing the upper-half-circle count jumps from zero to one.
-/
theorem crossing_count_jumps :
    upperCount crossingBranches ⟨(1/4 : ℝ), by norm_num⟩ = 0 ∧
    upperCount crossingBranches ⟨(3/4 : ℝ), by norm_num⟩ = 1 := by
  unfold upperCount crossingBranches; norm_num [ Finset.card ] ;
  erw [ Multiset.filter_coe ] ; norm_num [ Finset.univ ];
  norm_num [ List.finRange, cayleyCircle_im ]

/-- The extra local datum required by a full spectral-flow/Floquet invariant.
`orientation` is the sign of phase velocity through the chosen cut; `chirality` is the
symmetry/topological charge carried by that eigenstate.  Multiplicity is explicit. -/
structure CrossingDatum where
  parameter : ℝ
  band : ℕ
  orientation : ℤ
  chirality : ℤ
  multiplicity : ℕ

/-- The signed/chiral contribution of a finite crossing list. -/
def signedCrossingSum (C : List CrossingDatum) : ℤ :=
  (C.map fun c => (c.multiplicity : ℤ) * c.orientation * c.chirality).sum

/-- Unsigned endpoint occupation cannot determine the full invariant: reversing only the
orientation leaves the number of crossing events unchanged but reverses the signed answer. -/
theorem orientation_is_missing_input :
    let positive : CrossingDatum := ⟨1/2, 0, 1, 1, 1⟩
    let negative : CrossingDatum := ⟨1/2, 0, -1, 1, 1⟩
    [positive].length = [negative].length ∧
      signedCrossingSum [positive] = 1 ∧ signedCrossingSum [negative] = -1 := by
  norm_num [signedCrossingSum]

end GapAudit

#print axioms GapAudit.upperCount_constant
#print axioms GapAudit.matrix_upperCount_constant
#print axioms GapAudit.branch_gap_of_det
#print axioms GapAudit.gappedMatrix_continuous
#print axioms GapAudit.gappedMatrix_unitary
#print axioms GapAudit.gappedMatrix_det_gaps
#print axioms GapAudit.gapped_endpoint_counts
#print axioms GapAudit.crossingMatrix_continuous
#print axioms GapAudit.crossingMatrix_unitary
#print axioms GapAudit.crossing_det_gap_fails
#print axioms GapAudit.crossing_count_jumps
#print axioms GapAudit.orientation_is_missing_input
