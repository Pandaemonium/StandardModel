import Mathlib

/-!
# Dynamical covariance of the complex Dirac rest family

Provenance: Aristotle project `2635219c-e0be-4dbd-ade0-4130eddb4dd6`, task
`bd027307-d7cb-4c9f-ab39-b24b510c22ff`, harvested 2026-07-12. The seven target
statements were preserved exactly. This is a clean-room finite matrix
formalization using the project's standard complex conjugation convention.

This focused target closes the gap between covariance of the static family
`B z` and covariance of the full momentum-dependent Dirac generator

`H(k,z) = k Gamma + B z`.

The same-momentum branch must preserve `Gamma`, hence is diagonal and is the
chiral phase circle modulo a global scalar.  The orientation-reversing branch
is antidiagonal and becomes a covariance only when accompanied by parity
`k -> -k`.  The theorem is finite `2 x 2` complex matrix algebra.

This target concerns covariance of the Dirac generator family.  It does not by
itself classify every symmetry of the ordered `3+1` split-step regulator.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DynamicalMassCovariance

open Matrix Complex
open scoped Matrix ComplexConjugate

abbrev Mat := Matrix (Fin 2) (Fin 2) Complex

def velocity : Mat := !![1, 0; 0, -1]

def massOperator (z : Complex) : Mat := !![0, z; conj z, 0]

def diracSymbol (k : Real) (z : Complex) : Mat :=
  (k : Complex) • velocity + massOperator z

def chiralPhase (u : Complex) : Mat := !![u, 0; 0, 1]

def chiralFlip (u : Complex) : Mat := !![0, u; 1, 0]

def IsUnitary (W : Mat) : Prop := W * Wᴴ = 1

def SameMomentumCovariant (W : Mat) : Prop :=
  IsUnitary W ∧
    ∃ f : Complex → Complex, ∀ (k : Real) (z : Complex),
      W * diracSymbol k z * Wᴴ = diracSymbol k (f z)

def ParityCovariant (W : Mat) : Prop :=
  IsUnitary W ∧
    ∃ f : Complex → Complex, ∀ (k : Real) (z : Complex),
      W * diracSymbol k z * Wᴴ = diracSymbol (-k) (f z)

/-
Same-momentum dynamical covariance forces the velocity grading to be
preserved.
-/
theorem sameMomentum_forces_velocity (W : Mat) (h : SameMomentumCovariant W) :
    W * velocity * Wᴴ = velocity := by
  obtain ⟨ f, hf ⟩ := h.2;
  have h1 := hf 0 0; have h2 := hf 1 0; simp_all +decide [ diracSymbol ] ;
  simp_all +decide [ massOperator, mul_add, add_mul ]

/-
A unitary preserving the velocity grading is diagonal.
-/
theorem unitary_preserving_velocity_is_diagonal (W : Mat)
    (hW : IsUnitary W) (hGamma : W * velocity * Wᴴ = velocity) :
    W 0 1 = 0 ∧ W 1 0 = 0 := by
  simp_all +decide [ IsUnitary, ← List.ofFn_inj ];
  unfold velocity at hGamma; simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply ] ;
  grind +qlia

/-
Complete same-momentum classification: the dynamical covariance group is
the chiral phase circle modulo global phase.
-/
theorem sameMomentum_covariant_iff (W : Mat) :
    SameMomentumCovariant W ↔
      ∃ lam u : Complex, ‖lam‖ = 1 ∧ ‖u‖ = 1 ∧
        W = lam • chiralPhase u := by
  constructor <;> intro hW;
  · obtain ⟨lam, u, hlam, hu, hW⟩ : ∃ lam u : ℂ, W = !![lam * u, 0; 0, lam] ∧ ‖lam‖ = 1 ∧ ‖u‖ = 1 := by
      obtain ⟨hW_unitary, hW_covariant⟩ := hW
      have hW_velocity : W * velocity * Wᴴ = velocity := by
        exact sameMomentum_forces_velocity W ⟨ hW_unitary, hW_covariant ⟩
      have hW_diagonal : W 0 1 = 0 ∧ W 1 0 = 0 := by
        exact unitary_preserving_velocity_is_diagonal W hW_unitary hW_velocity
      obtain ⟨a, d, ha, hd⟩ : ∃ a d : ℂ, W = !![a, 0; 0, d] ∧ ‖a‖ = 1 ∧ ‖d‖ = 1 := by
        have := congr_fun ( congr_fun hW_unitary 0 ) 0; have := congr_fun ( congr_fun hW_unitary 1 ) 1; simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ] ;
        simp_all +decide [ Complex.normSq, Complex.norm_def ];
        exact ⟨ W 0 0, W 1 1, by ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ *, Complex.ext_iff ], by linarith, by linarith ⟩;
      use d, a / d;
      by_cases hd : d = 0 <;> simp_all +decide [ mul_div_cancel₀ ];
    use lam, u;
    simp_all +decide [ chiralPhase ];
  · obtain ⟨ lam, u, hl, hu, rfl ⟩ := hW;
    refine' ⟨ _, _ ⟩;
    · unfold IsUnitary chiralPhase; norm_num [ Matrix.mul_apply, Complex.ext_iff ] ; ring_nf;
      ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.vecMul, Matrix.vecHead, Matrix.vecTail ] <;> ring_nf <;> simp_all +decide [ Complex.ext_iff, sq ];
      · norm_num [ Complex.normSq, Complex.norm_def ] at *;
        grind;
      · exact ⟨ by simpa [ Complex.norm_def, sq ] using hl, by ring ⟩;
    · use fun z => lam * conj lam * u * z;
      simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply, diracSymbol, chiralPhase ];
      simp_all +decide [ Complex.ext_iff, Matrix.vecMul, Matrix.mul_apply, velocity, massOperator ];
      simp_all +decide [ Complex.normSq, Complex.norm_def, vecHead, vecTail ];
      grind

/-
Parity covariance forces reversal of the velocity grading.
-/
theorem parity_forces_velocity_reversal (W : Mat) (h : ParityCovariant W) :
    W * velocity * Wᴴ = -velocity := by
  obtain ⟨hW, f, hf⟩ := h;
  convert hf 1 0 using 1 <;> norm_num [ diracSymbol ];
  · unfold massOperator;
    norm_num [ velocity ];
  · specialize hf 0 0;
    convert hf.symm using 1 <;> norm_num [ diracSymbol ];
    unfold massOperator; norm_num;
    ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply ]

/-
Complete parity branch: orientation reversal is the antidiagonal coset,
again modulo a global phase.
-/
set_option maxHeartbeats 1000000 in
theorem parity_covariant_iff (W : Mat) :
    ParityCovariant W ↔
      ∃ lam u : Complex, ‖lam‖ = 1 ∧ ‖u‖ = 1 ∧
        W = lam • chiralFlip u := by
  constructor;
  · intro hW
    obtain ⟨h_unitary, f, hf⟩ := hW
    have h_velocity_reversal : W * velocity * Wᴴ = -velocity := by
      convert parity_forces_velocity_reversal W ⟨ h_unitary, f, hf ⟩ using 1
    have h_antidiagonal : W 0 0 = 0 ∧ W 1 1 = 0 := by
      have h_antidiagonal : W * velocity = -velocity * W := by
        convert congr_arg ( · * W ) h_velocity_reversal using 1 ; norm_num [ mul_assoc, h_unitary ];
        rw [ show Wᴴ * W = 1 from by simpa [ mul_eq_one_comm ] using h_unitary ] ; norm_num;
      simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply ];
      unfold velocity at *; norm_num at *; constructor <;> norm_num [ Complex.ext_iff ] at * <;> constructor <;> linarith;
    have h_norm : ‖W 0 1‖ = 1 ∧ ‖W 1 0‖ = 1 := by
      have := congr_fun ( congr_fun h_unitary 0 ) 0; ( have := congr_fun ( congr_fun h_unitary 1 ) 1; simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ] ; );
      simp_all +decide [ Complex.normSq, Complex.norm_def ]
    use W 1 0, W 0 1 * star (W 1 0);
    simp_all +decide [ chiralFlip ];
    ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ *, mul_assoc, mul_comm, mul_left_comm ] ;
    simp_all +decide [ Complex.mul_conj, Complex.normSq_eq_norm_sq ];
  · rintro ⟨ lam, u, hl, hu, rfl ⟩;
    constructor;
    · unfold IsUnitary chiralFlip;
      ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Complex.ext_iff ] <;> ring;
      · simp_all +decide [ Complex.normSq, Complex.norm_def ];
        grind;
      · simp_all +decide [ Complex.norm_def, Complex.normSq_apply, sq ];
    · unfold chiralFlip diracSymbol;
      unfold velocity massOperator;
      refine' ⟨ fun z => u * starRingEnd ℂ z, fun k z => _ ⟩ ; ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Complex.ext_iff ];
      · simp_all +decide [ Complex.normSq, Complex.norm_def ];
        grind;
      · norm_num [ Complex.normSq, Complex.norm_def ] at *;
        grind +revert;
      · norm_num [ Complex.normSq, Complex.norm_def ] at *;
        grind;
      · simp_all +decide [ Complex.normSq, Complex.norm_def ];
        exact ⟨ by linear_combination' hl * k, by ring ⟩

/-
Non-vacuity: every chiral phase is a same-momentum covariance with
`z -> u z`.
-/
theorem chiralPhase_covariant (u : Complex) (hu : ‖u‖ = 1) :
    SameMomentumCovariant (chiralPhase u) := by
  refine' ⟨ _, fun z => u * z, _ ⟩;
  · unfold IsUnitary chiralPhase;
    ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ hu, Complex.ext_iff, Matrix.mul_apply ];
    exact ⟨ by simpa [ Complex.norm_def, sq ] using hu, by ring ⟩;
  · intro k z; ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ *, chiralPhase, diracSymbol, Matrix.mul_apply ];
    · simp +decide [ Matrix.vecMul, dotProduct, velocity, massOperator ];
      rw [ mul_right_comm, Complex.mul_conj, Complex.normSq_eq_norm_sq ] ; aesop;
    · simp +decide [ Matrix.vecMul, dotProduct, velocity, massOperator ];
    · unfold velocity massOperator; norm_num [ Matrix.vecMul ] ; ring;
      simp +decide [ vecHead, vecTail, mul_comm ];
    · simp +decide [ Matrix.vecMul, dotProduct ];
      unfold massOperator; norm_num

/-
Non-vacuity: every chiral flip is a parity covariance.
-/
theorem chiralFlip_parity_covariant (u : Complex) (hu : ‖u‖ = 1) :
    ParityCovariant (chiralFlip u) := by
  refine' ⟨ _, _ ⟩;
  · unfold IsUnitary chiralFlip; norm_num [ hu, Complex.ext_iff ] ;
    ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.vecMul, Matrix.vecHead, Matrix.vecTail ];
    simp +decide [ Complex.mul_conj, Complex.normSq_eq_norm_sq, hu ];
  · refine' ⟨ fun z => u * conj z, _ ⟩;
    intro k z; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ chiralFlip, diracSymbol, velocity, massOperator ] <;> ring;
    · simp +decide [ Matrix.vecMul, dotProduct ];
      rw [ mul_right_comm, Complex.mul_conj, Complex.normSq_eq_norm_sq ] ; aesop;
    · simp +decide [ Matrix.vecMul, dotProduct ];
    · simp +decide [ Matrix.vecMul, dotProduct ] ; ring!;
    · norm_num [ Matrix.vecMul ];
      norm_num [ vecHead, vecTail ]

end PhysicsSM.Draft.NullEdge.DynamicalMassCovariance
