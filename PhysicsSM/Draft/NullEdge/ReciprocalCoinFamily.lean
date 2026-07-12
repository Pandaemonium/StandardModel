import PhysicsSM.Draft.NullEdge.ReciprocalConditionalShiftRegulator

/-!
# Exact rational reciprocal-coin family

Generalize the landed `3-4-5` reciprocal conditional-shift primitive to the
rational tangent-half-angle coin family.  Classify exactly which real
parameters close the zero or pi corner gap at `z = -1`, and connect `r=1/2`
back to the landed fixture.

This is a two-band primitive classification, not a four-component embedding or
an all-torus root theorem.

Provenance: target architecture by Codex, informed by exact oracle and hostile
audit `f19c0fa2-f31d-476f-a2e9-eaeca1e7dad9`; proofs by Aristotle project
`32c20d53-3631-4ae9-9d01-57b7e21329de`, rebuilt locally on July 11, 2026.
-/

namespace PhysicsSM.Draft.NullEdge.ReciprocalCoinFamily

open Matrix Complex
open ReciprocalConditionalShiftRegulator

noncomputable section

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

def cParam (r : Real) : Complex := ((1 - r ^ 2) / (1 + r ^ 2) : Real)
def sParam (r : Real) : Complex := (2 * r / (1 + r ^ 2) : Real)

def coinR (r : Real) : M2 :=
  !![cParam r, sParam r; -sParam r, cParam r]

def coinRInv (r : Real) : M2 :=
  !![cParam r, -sParam r; sParam r, cParam r]

def shiftCoinCommutatorR (r : Real) (z : Complex) : M2 :=
  conditionalShift z * coinR r * conditionalShift z⁻¹ * coinRInv r

def reciprocalRegulatorR (r : Real) (z : Complex) : M2 :=
  shiftCoinCommutatorR r z * shiftCoinCommutatorR r z⁻¹

theorem one_add_sq_pos (r : Real) : 0 < 1 + r ^ 2 := by
  positivity

/-
Helper: `c^2 + s^2 = 1` for the rational tangent-half-angle coin.
-/
theorem cParam_sq_add_sParam_sq (r : Real) :
    (cParam r) ^ 2 + (sParam r) ^ 2 = 1 := by
  unfold cParam sParam;
  norm_cast; field_simp; ring;

/-
Helper: closed form of the shift-coin commutator away from `z = 0`.
-/
theorem shiftCoinCommutatorR_eq (r : Real) (z : Complex) (hz : z ≠ 0) :
    shiftCoinCommutatorR r z =
      !![cParam r ^ 2 + z * sParam r ^ 2, cParam r * sParam r * (z - 1);
          cParam r * sParam r * (z - 1) / z, cParam r ^ 2 + sParam r ^ 2 / z] := by
  unfold shiftCoinCommutatorR conditionalShift coinR coinRInv; ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply, Fin.sum_univ_two] ; ring;
  · grind;
  · grind;
  · grind;
  · ring

/-
Helper: closed form of the regulator at the corner `z = -1`.
-/
theorem reciprocalRegulatorR_neg_one_eq (r : Real) :
    reciprocalRegulatorR r (-1) =
      !![(cParam r ^ 2 - sParam r ^ 2) ^ 2 - (2 * cParam r * sParam r) ^ 2,
          -2 * (cParam r ^ 2 - sParam r ^ 2) * (2 * cParam r * sParam r);
        2 * (cParam r ^ 2 - sParam r ^ 2) * (2 * cParam r * sParam r),
          (cParam r ^ 2 - sParam r ^ 2) ^ 2 - (2 * cParam r * sParam r) ^ 2] := by
  -- By definition of $reciprocalRegulatorR$, we have
  simp [reciprocalRegulatorR, shiftCoinCommutatorR_eq];
  grind

theorem coinR_mul_coinRInv (r : Real) : coinR r * coinRInv r = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] ; ring;
  · convert cParam_sq_add_sParam_sq r using 1 ; ring!;
  · unfold coinR coinRInv; norm_num; ring;
  · unfold coinR coinRInv; norm_num; ring;
  · unfold coinR coinRInv; norm_num; ring;
    exact cParam_sq_add_sParam_sq r ▸ by ring;

theorem coinR_conjTranspose (r : Real) :
    (coinR r).conjTranspose = coinRInv r := by
  unfold coinR coinRInv;
  unfold cParam sParam; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff ] ;

theorem coinR_unitary (r : Real) : IsUnitary2 (coinR r) := by
  constructor;
  · simp +decide [coinR];
    ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, cParam, sParam ] <;> ring;
    · erw [ Complex.conj_ofReal ] ; norm_num ; ring;
      linear_combination' mul_inv_cancel₀ ( by norm_cast; positivity : ( 1 + r ^ 2 * 2 + r ^ 4 : ℂ ) ≠ 0 );
    · erw [ Complex.conj_ofReal ] ; norm_num ; ring;
    · erw [ Complex.conj_ofReal ] ; norm_num ; ring;
    · norm_num [ Complex.ext_iff, sq ];
      norm_cast ; norm_num [ Complex.normSq ] ; ring;
      -- Combine like terms and simplify the expression.
      field_simp
      ring;
  · convert coinR_mul_coinRInv r using 1;
    exact congr_arg _ ( coinR_conjTranspose r )

/-
Helper: the shift-coin commutator is unitary on the circle.
-/
theorem shiftCoinCommutatorR_unitary (r : Real) (z : Complex) (hz : z ≠ 0)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary2 (shiftCoinCommutatorR r z) := by
  -- Each of the factors in the product is unitary:
  have h_conditionalShift : IsUnitary2 (conditionalShift z) := by
    exact conditionalShift_unitary z hz hcircle
  have h_coinR : IsUnitary2 (coinR r) := by
    -- By definition of `coinR`, we know that it is unitary.
    apply coinR_unitary
  have h_conditionalShift_inv : IsUnitary2 (conditionalShift z⁻¹) := by
    grind +suggestions
  have h_coinRInv : IsUnitary2 (coinRInv r) := by
    obtain ⟨ h₁, h₂ ⟩ := h_coinR;
    constructor <;> rw [ ← coinR_conjTranspose ] at * <;> aesop;
  convert isUnitary2_mul ( isUnitary2_mul ( isUnitary2_mul h_conditionalShift h_coinR ) h_conditionalShift_inv ) h_coinRInv using 1

theorem reciprocalRegulatorR_unitary (r : Real) (z : Complex) (hz : z ≠ 0)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary2 (reciprocalRegulatorR r z) := by
  apply isUnitary2_mul (shiftCoinCommutatorR_unitary r z hz hcircle) (shiftCoinCommutatorR_unitary r z⁻¹ (inv_ne_zero hz) (by
  simp +decide [hcircle]))

theorem reciprocalRegulatorR_det (r : Real) (z : Complex) (hz : z ≠ 0) :
    (reciprocalRegulatorR r z).det = 1 := by
  unfold reciprocalRegulatorR;
  unfold shiftCoinCommutatorR;
  unfold conditionalShift; unfold coinR; unfold coinRInv; norm_num [ Matrix.det_fin_two ] ; ring;
  grind +suggestions

theorem reciprocalRegulatorR_one (r : Real) :
    reciprocalRegulatorR r 1 = 1 := by
  unfold reciprocalRegulatorR shiftCoinCommutatorR conditionalShift;
  norm_num [ ← Matrix.one_fin_two, ← Matrix.mul_assoc ];
  grind +suggestions

/-
Exact zero-quasienergy corner determinant for the whole rational family.
-/
theorem det_negOne_sub_one (r : Real) :
    (reciprocalRegulatorR r (-1) - 1).det =
      (((64 * r ^ 2 * (r - 1) ^ 2 * (r + 1) ^ 2) /
        (r ^ 2 + 1) ^ 4 : Real) : Complex) := by
  rw [ reciprocalRegulatorR_neg_one_eq ];
  norm_num [ Matrix.det_fin_two, cParam, sParam ];
  field_simp;
  rw [ div_sub_one, div_pow, div_add_div, div_eq_div_iff ] <;> ring <;> norm_cast; all_goals positivity

/-
Exact pi-quasienergy corner determinant for the whole rational family.
-/
theorem det_negOne_add_one (r : Real) :
    (reciprocalRegulatorR r (-1) + 1).det =
      (((4 * (r ^ 2 - 2 * r - 1) ^ 2 * (r ^ 2 + 2 * r - 1) ^ 2) /
        (r ^ 2 + 1) ^ 4 : Real) : Complex) := by
  rw [ reciprocalRegulatorR_neg_one_eq ];
  norm_num [ Matrix.det_fin_two, cParam, sParam ];
  field_simp;
  rw [ div_add_one, div_pow, div_add_div, div_eq_div_iff ] <;> ring <;> norm_cast <;> positivity

theorem det_negOne_sub_one_ne_zero_iff (r : Real) :
    (reciprocalRegulatorR r (-1) - 1).det ≠ 0 ↔
      r ≠ 0 ∧ r ≠ 1 ∧ r ≠ -1 := by
  rw [ det_negOne_sub_one ] ; norm_cast ; simp +decide [ sub_eq_iff_eq_add, add_eq_zero_iff_eq_neg, or_assoc ] ; ring ;
  exact fun _ _ _ => by nlinarith;

theorem det_negOne_add_one_ne_zero_iff (r : Real) :
    (reciprocalRegulatorR r (-1) + 1).det ≠ 0 ↔
      r ^ 2 - 2 * r - 1 ≠ 0 ∧ r ^ 2 + 2 * r - 1 ≠ 0 := by
  rw [ det_negOne_add_one ];
  norm_cast ; norm_num [ show r ^ 2 + 1 ≠ 0 by positivity ]

theorem no_zero_or_pi_crossing_iff (r : Real) :
    ((reciprocalRegulatorR r (-1) - 1).det ≠ 0 ∧
      (reciprocalRegulatorR r (-1) + 1).det ≠ 0) ↔
      r ≠ 0 ∧ r ≠ 1 ∧ r ≠ -1 ∧
      r ^ 2 - 2 * r - 1 ≠ 0 ∧ r ^ 2 + 2 * r - 1 ≠ 0 := by
  rw [ det_negOne_sub_one_ne_zero_iff, det_negOne_add_one_ne_zero_iff ] ; tauto;

/-
The landed `3-4-5` coin is exactly the `r=1/2` family member.
-/
theorem half_eq_landed_fixture (z : Complex) :
    reciprocalRegulatorR (1 / 2) z = reciprocalRegulator z := by
  unfold reciprocalRegulatorR reciprocalRegulator;
  unfold shiftCoinCommutatorR shiftCoinCommutator;
  congr;
  · unfold coinR coin cParam sParam; norm_num;
  · unfold coinRInv coinInv; norm_num [ Complex.ext_iff ] ;
    unfold cParam sParam; norm_num;
  · unfold coinR coin cParam sParam; norm_num;
  · unfold coinRInv coinInv; norm_num [ Complex.ext_iff ] ;
    unfold cParam sParam; norm_num;

/-
Nondegenerate rational control inside the good parameter set.
-/
theorem half_has_no_zero_or_pi_crossing :
    (reciprocalRegulatorR (1 / 2) (-1) - 1).det ≠ 0 ∧
      (reciprocalRegulatorR (1 / 2) (-1) + 1).det ≠ 0 := by
  convert neg_one_has_no_zero_or_pi_crossing using 8 <;> norm_num; all_goals exact funext fun z => half_eq_landed_fixture z

/-
Degenerate control: `r=0` is the identity coin and does not gap the
zero-quasienergy corner.
-/
theorem zero_parameter_control :
    reciprocalRegulatorR 0 (-1) = 1 ∧
      (reciprocalRegulatorR 0 (-1) - 1).det = 0 := by
  rw [ reciprocalRegulatorR_neg_one_eq ];
  norm_num [ cParam, sParam, Matrix.det_fin_two ];
  exact Matrix.one_fin_two.symm

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ReciprocalCoinFamily.no_zero_or_pi_crossing_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_zero_or_pi_crossing_iff

/-- info: 'PhysicsSM.Draft.NullEdge.ReciprocalCoinFamily.half_has_no_zero_or_pi_crossing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms half_has_no_zero_or_pi_crossing

/-- info: 'PhysicsSM.Draft.NullEdge.ReciprocalCoinFamily.zero_parameter_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zero_parameter_control

end

end PhysicsSM.Draft.NullEdge.ReciprocalCoinFamily
