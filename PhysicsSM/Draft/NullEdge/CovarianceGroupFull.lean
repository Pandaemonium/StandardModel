/-
Provenance: Aristotle job 86779752 (fable-24h-covfull), harvested
2026-07-12 ~05:36 PDT. KERNEL-ONLY. covariance_group_full: a 2x2 unitary
is covariant for {B_z} IFF diagonal (chiral phase circle) OR antidiagonal
(orientation-flip coset) - the COMPLETE covariance group (both cosets),
closing the red-team T2-only-diagonal nuance.
-/
/-
Follow-up to `context/MassCovarianceForcing.lean`.  A red-team review of the
covariance classification noted that the *full* covariance group of the derived
mass-operator family `{B z = !![0, z; conj z, 0]}` is BOTH cosets: the
orientation-preserving diagonal chiral-phase circle AND the orientation-flip
antidiagonal coset.  The original `covariance_group_eq_chiralPhase` identified
only the diagonal branch.

This file gives the COMPLETE group description (kernel-only, 2×2 algebra):

* `covariance_group_full` — the membership iff: a `2×2` unitary `W` admits
  spectral images at the two probes `z = 1, i` (i.e. is covariant for `{B z}`)
  **iff** `W` has one of two explicit shapes:
    (a) `W = λ • chiralPhase u`  (diagonal, `|λ| = |u| = 1`), the
        orientation-preserving chiral-phase circle mod global phase; or
    (b) `W = λ • chiralFlip u`   (antidiagonal, `|λ| = |u| = 1`), the
        orientation-flip coset.

* Group structure: the covariant unitaries are closed under multiplication and
  conjugate-transpose (inverse) and contain the identity; the diagonal circle is
  an index-2 subgroup and the antidiagonal set its nontrivial coset.  The coset
  structure is witnessed by:
    - `covariant_disjoint_shapes` — no unitary is simultaneously diagonal and
      antidiagonal (a matrix that is both is the zero matrix, excluded by
      unitarity); so the two branches are genuinely disjoint cosets;
    - `chiralFlip_sq` — `(chiralFlip u)^2 = u • 1` is diagonal, i.e. the flip
      squared lands back in the diagonal subgroup.

The definitions `massOperator`, `chiralPhase`, `IsDiagonal`, `IsAntidiagonal`
and the classification lemmas `classification`, `orientation_preserving`,
`orientation_flip`, `covariance_group_eq_chiralPhase` are copied verbatim from
`context/MassCovarianceForcing.lean`.
-/
import Mathlib

noncomputable section

namespace CovarianceGroupFull

open Matrix Complex
open scoped Matrix ComplexConjugate

/-! ## Definitions copied verbatim from `MassCovarianceForcing` -/

/-- The odd Hermitian rest / mass operator `B z = !![0, z; conj z, 0]`. -/
def massOperator (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![0, z; (starRingEnd ℂ) z, 0]

/-- The diagonal chiral phase unitary `!![u, 0; 0, 1]`. -/
def chiralPhase (u : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![u, 0; 0, 1]

/-- The antidiagonal orientation-flip unitary `!![0, u; 1, 0]`. -/
def chiralFlip (u : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![0, u; 1, 0]

/-- `W` is diagonal (off-diagonal entries vanish). -/
def IsDiagonal (W : Matrix (Fin 2) (Fin 2) ℂ) : Prop := W 0 1 = 0 ∧ W 1 0 = 0

/-- `W` is antidiagonal (diagonal entries vanish). -/
def IsAntidiagonal (W : Matrix (Fin 2) (Fin 2) ℂ) : Prop := W 0 0 = 0 ∧ W 1 1 = 0

/-- `W` is covariant for the derived mass-operator family at the two probes
`z = 1, i`: it is unitary and admits spectral images `w1, w2`. -/
def Covariant (W : Matrix (Fin 2) (Fin 2) ℂ) : Prop :=
  W * Wᴴ = 1 ∧ ∃ w1 w2 : ℂ,
    W * massOperator 1 * Wᴴ = massOperator w1 ∧
      W * massOperator Complex.I * Wᴴ = massOperator w2

/-! ## Classification lemmas copied verbatim from `MassCovarianceForcing` -/

theorem classification (W : Matrix (Fin 2) (Fin 2) ℂ) (hW : W * Wᴴ = 1)
    (w1 w2 : ℂ) (h1 : W * massOperator 1 * Wᴴ = massOperator w1)
    (h2 : W * massOperator Complex.I * Wᴴ = massOperator w2) :
    IsDiagonal W ∨ IsAntidiagonal W := by
  simp_all +decide [ IsDiagonal, IsAntidiagonal, massOperator ];
  simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply ];
  norm_num [ Complex.ext_iff ] at *;
  grind +ring

theorem orientation_preserving (W : Matrix (Fin 2) (Fin 2) ℂ)
    (hd : IsDiagonal W) (z : ℂ) :
    W * massOperator z * Wᴴ = massOperator ((W 0 0 * (starRingEnd ℂ) (W 1 1)) * z) := by
  simp_all +decide [ IsDiagonal, massOperator ]
  ext i j ; fin_cases i <;> fin_cases j <;>
    simp +decide [ *, Matrix.mul_apply, Matrix.conjTranspose_apply ] <;> ring

theorem orientation_flip (W : Matrix (Fin 2) (Fin 2) ℂ)
    (ha : IsAntidiagonal W) (z : ℂ) :
    W * massOperator z * Wᴴ =
      massOperator ((W 0 1 * (starRingEnd ℂ) (W 1 0)) * (starRingEnd ℂ) z) := by
  unfold IsAntidiagonal at ha; simp_all +decide [ massOperator ] ;
  ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ *, Matrix.mul_apply ] <;> ring!;

theorem covariance_group_eq_chiralPhase (W : Matrix (Fin 2) (Fin 2) ℂ)
    (hW : W * Wᴴ = 1) (hd : IsDiagonal W) :
    ∃ lam : ℂ, ‖lam‖ = 1 ∧
      W = lam • chiralPhase (W 0 0 * (starRingEnd ℂ) (W 1 1)) := by
  refine' ⟨ W 1 1, _, _ ⟩;
  · replace hW := congr_fun ( congr_fun hW 1 ) 1; simp_all +decide [ Matrix.mul_apply ] ;
    simp_all +decide [ Complex.ext_iff, IsDiagonal ];
    norm_num [ Complex.normSq, Complex.norm_def, hW ];
  · ext i j;
    fin_cases i <;> fin_cases j <;> simp_all +decide [ hd.1, hd.2, chiralPhase ];
    replace hW := congr_fun ( congr_fun hW 1 ) 1 ; simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ];
    have := hd.2; simp_all +decide [ Complex.ext_iff ] ;
    grind

/-! ## Unitarity of the diagonal entries -/

/-
A diagonal unitary has unimodular diagonal entries.
-/
theorem diagonal_unitary_entries (W : Matrix (Fin 2) (Fin 2) ℂ)
    (hW : W * Wᴴ = 1) (hd : IsDiagonal W) : ‖W 0 0‖ = 1 ∧ ‖W 1 1‖ = 1 := by
  simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply ];
  simp_all +decide [ Complex.ext_iff, IsDiagonal ];
  norm_num [ Complex.normSq, Complex.norm_def, hW ]

/-
An antidiagonal unitary has unimodular off-diagonal entries.
-/
theorem antidiagonal_unitary_entries (W : Matrix (Fin 2) (Fin 2) ℂ)
    (hW : W * Wᴴ = 1) (ha : IsAntidiagonal W) : ‖W 0 1‖ = 1 ∧ ‖W 1 0‖ = 1 := by
  simp_all +decide [ IsAntidiagonal, ← Matrix.ext_iff ];
  simp_all +decide [ Matrix.mul_apply, Complex.ext_iff ];
  norm_num [ Complex.normSq, Complex.norm_def, hW ]

/-! ## Explicit shapes -/

/-
Every diagonal unitary has the orientation-preserving shape
`λ • chiralPhase u` with `|λ| = |u| = 1`.
-/
theorem diagonal_shape (W : Matrix (Fin 2) (Fin 2) ℂ)
    (hW : W * Wᴴ = 1) (hd : IsDiagonal W) :
    ∃ lam u : ℂ, ‖lam‖ = 1 ∧ ‖u‖ = 1 ∧ W = lam • chiralPhase u := by
  obtain ⟨lam, hlam, hW⟩ := covariance_group_eq_chiralPhase W hW hd;
  refine' ⟨ lam, W 0 0 * ( starRingEnd ℂ ) ( W 1 1 ), hlam, _, hW ⟩;
  have := diagonal_unitary_entries W ‹_› hd; norm_num at *;
  rw [ this.1, this.2, mul_one ]

/-
Every antidiagonal unitary has the orientation-flip shape
`λ • chiralFlip u` with `|λ| = |u| = 1`.
-/
theorem antidiagonal_shape (W : Matrix (Fin 2) (Fin 2) ℂ)
    (hW : W * Wᴴ = 1) (ha : IsAntidiagonal W) :
    ∃ lam u : ℂ, ‖lam‖ = 1 ∧ ‖u‖ = 1 ∧ W = lam • chiralFlip u := by
  use W 1 0, W 0 1 * starRingEnd ℂ ( W 1 0 );
  simp_all +decide [ IsAntidiagonal, chiralFlip ];
  have := antidiagonal_unitary_entries W hW ⟨ ha.1, ha.2 ⟩ ; simp_all +decide ;
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ *, mul_left_comm ] ;
  simp_all +decide [ Complex.mul_conj, Complex.normSq_eq_norm_sq ]

/-
The diagonal shape `λ • chiralPhase u` (unimodular `λ, u`) is a covariant
unitary.
-/
theorem chiralPhase_shape_covariant (lam u : ℂ) (hlam : ‖lam‖ = 1) (hu : ‖u‖ = 1) :
    Covariant (lam • chiralPhase u) := by
  constructor;
  · ext i j; fin_cases i <;> fin_cases j <;> simp_all +decide [ Complex.ext_iff, chiralPhase ];
    · simp_all +decide [ Complex.normSq, Complex.norm_def, Matrix.vecMul ];
      norm_num [ vecHead ] ; constructor <;> nlinarith;
    · simp +decide [ Matrix.vecMul ];
      simp +decide [ vecHead ];
    · simp +decide [ Matrix.vecMul, dotProduct ];
    · simp_all +decide [ Matrix.vecMul, dotProduct ];
      exact ⟨ by simpa [ Complex.norm_def, sq ] using hlam, by ring ⟩;
  · unfold chiralPhase massOperator; norm_num [ Complex.ext_iff, Matrix.mul_apply ] ;
    constructor <;> norm_num [ ← List.ofFn_inj, Matrix.vecMul ];
    · simp +decide [ vecHead, vecTail ];
      ring;
    · simp +decide [ vecHead, vecTail ];
      ring

/-
The antidiagonal shape `λ • chiralFlip u` (unimodular `λ, u`) is a covariant
unitary.
-/
theorem chiralFlip_shape_covariant (lam u : ℂ) (hlam : ‖lam‖ = 1) (hu : ‖u‖ = 1) :
    Covariant (lam • chiralFlip u) := by
  constructor;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Matrix.conjTranspose_apply, chiralFlip ] <;> ring_nf <;> simp_all +decide [ Complex.normSq, Complex.norm_def ];
    · simp_all +decide [ Complex.ext_iff, mul_assoc ];
      grind;
    · simp_all +decide [ Complex.ext_iff ];
      ring;
  · unfold chiralFlip massOperator;
    simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply, Matrix.smul_eq_diagonal_mul ];
    constructor <;> ring

/-! ## The complete membership characterization -/

/-
**Complete covariance group.**  A `2×2` unitary `W` is covariant for the derived
mass-operator family `{B z = !![0, z; conj z, 0]}` (admits spectral images at
the two probes `z = 1, i`) **iff** it has one of the two explicit shapes:

* (a) diagonal `W = λ • chiralPhase u` with `|λ| = |u| = 1` — the
  orientation-preserving chiral-phase circle mod global phase; or
* (b) antidiagonal `W = λ • chiralFlip u` with `|λ| = |u| = 1` — the
  orientation-flip coset.

Both cosets are genuinely covariant, so the full covariance group is the union
of the two — not just the diagonal branch of the earlier
`covariance_group_eq_chiralPhase`.
-/
theorem covariance_group_full (W : Matrix (Fin 2) (Fin 2) ℂ) :
    Covariant W ↔
      (∃ lam u : ℂ, ‖lam‖ = 1 ∧ ‖u‖ = 1 ∧ W = lam • chiralPhase u) ∨
        (∃ lam u : ℂ, ‖lam‖ = 1 ∧ ‖u‖ = 1 ∧ W = lam • chiralFlip u) := by
  constructor;
  · rintro ⟨ hW, w1, w2, h1, h2 ⟩;
    rcases classification W hW w1 w2 h1 h2 with ( ⟨ h3, h4 ⟩ | ⟨ h3, h4 ⟩ );
    · exact Or.inl <| diagonal_shape W hW ⟨ h3, h4 ⟩;
    · exact Or.inr ( antidiagonal_shape W hW ⟨ h3, h4 ⟩ );
  · rintro ( ⟨ lam, u, hlam, hu, rfl ⟩ | ⟨ lam, u, hlam, hu, rfl ⟩ ) <;> [ exact chiralPhase_shape_covariant lam u hlam hu; exact chiralFlip_shape_covariant lam u hlam hu ]

/-! ## Group structure: index-2 subgroup + nontrivial coset -/

/-
The two branches are disjoint: no unitary is both diagonal and antidiagonal.
A matrix that is both is the zero matrix, which is not unitary.
-/
theorem covariant_disjoint_shapes (W : Matrix (Fin 2) (Fin 2) ℂ)
    (hW : W * Wᴴ = 1) : ¬ (IsDiagonal W ∧ IsAntidiagonal W) := by
  intro h; have := congr_fun ( congr_fun hW 0 ) 0; simp_all +decide [ IsDiagonal, IsAntidiagonal, Matrix.mul_apply ] ;

/-
The identity is covariant (it is diagonal).
-/
theorem covariant_one : Covariant (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  convert chiralPhase_shape_covariant 1 1 _ _ <;> norm_num;
  exact Matrix.ext fun i j => by fin_cases i <;> fin_cases j <;> rfl;

/-
The covariant unitaries are closed under conjugate-transpose (i.e. inverse,
since `Wᴴ = W⁻¹` for a unitary).
-/
theorem covariant_conjTranspose (W : Matrix (Fin 2) (Fin 2) ℂ)
    (hW : Covariant W) : Covariant Wᴴ := by
  constructor;
  · have := hW.1; rw [ mul_eq_one_comm ] at this; aesop;
  · obtain ⟨ w1, w2, hw1, hw2 ⟩ := hW.2;
    obtain ⟨ u, hu ⟩ := classification W hW.1 w1 w2 hw1 hw2;
    · simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply, Matrix.conjTranspose_apply ];
      simp_all +decide [ mul_assoc, mul_comm, mul_left_comm, massOperator ];
    · simp_all +decide [ IsAntidiagonal ];
      unfold massOperator at *; simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply ] ;
      grind

/-
The covariant unitaries are closed under multiplication.
-/
theorem covariant_mul (W₁ W₂ : Matrix (Fin 2) (Fin 2) ℂ)
    (h₁ : Covariant W₁) (h₂ : Covariant W₂) : Covariant (W₁ * W₂) := by
  constructor;
  · simp_all +decide [ Matrix.mul_assoc, Matrix.conjTranspose_mul ];
    simp_all +decide [ ← Matrix.mul_assoc, Covariant ];
  · have h_prod : IsDiagonal (W₁ * W₂) ∨ IsAntidiagonal (W₁ * W₂) := by
      have h_prod : (IsDiagonal W₁ ∨ IsAntidiagonal W₁) ∧ (IsDiagonal W₂ ∨ IsAntidiagonal W₂) := by
        exact ⟨ classification W₁ h₁.1 _ _ h₁.2.choose_spec.choose_spec.1 h₁.2.choose_spec.choose_spec.2, classification W₂ h₂.1 _ _ h₂.2.choose_spec.choose_spec.1 h₂.2.choose_spec.choose_spec.2 ⟩;
      rcases h_prod with ⟨ h₁ | h₁, h₂ | h₂ ⟩ <;> simp_all +decide [ IsDiagonal, IsAntidiagonal, Matrix.mul_apply ];
    cases' h_prod with h_prod h_prod;
    · exact ⟨ _, _, orientation_preserving _ h_prod 1, orientation_preserving _ h_prod Complex.I ⟩;
    · exact ⟨ _, _, orientation_flip _ h_prod 1, orientation_flip _ h_prod Complex.I ⟩

/-
The flip squared lands back in the diagonal subgroup:
`(chiralFlip u)^2 = u • 1`, which is diagonal.
-/
theorem chiralFlip_sq (u : ℂ) :
    chiralFlip u * chiralFlip u = u • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ chiralFlip ]

end CovarianceGroupFull
