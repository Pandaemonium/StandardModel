import PhysicsSM.Draft.NullEdge.GateC1.TetraQMatrixSquareExact

/-!
# Scalar Wilson tetrahedral free symbol

This module is the first bridge from the abstract tetrahedral Euclidean slash
identity to the Gate C1 free-symbol gap lane.

The main object is the scalar Wilson/free symbol

`K(k) = a^{-1} (i Q(sin k) + m(k) I)`,

where `Q` is supplied by the abstract `TetraEuclideanSlashData` interface and
`m(k) = r * sum_A (1 - cos k_A) - rho`.

The theorem `K_star_mul` proves the exact Hilbert-sign-kernel identity

`K(k)^* K(k) = ((qExact(sin k) + m(k)^2) / a^2) I`.

This deliberately stays on the Euclidean/Hilbert track. Concrete gamma-matrix
witnesses, Lorentzian/Krein interpretation, and matrix-valued branch masses are
separate later layers.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraScalarWilsonSymbol

open scoped BigOperators
open TetraQMatrixSquareExact

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- Finite Hilbert/L2 norm squared for spin vectors.  This avoids relying on a
possibly non-Hilbert default norm on bare function spaces while staying equal
to the usual finite-dimensional complex Hilbert norm squared. -/
def l2NormSq {n : Type*} [Fintype n] (v : n -> ℂ) : ℝ :=
  ∑ i : n, Complex.normSq (v i)

theorem l2NormSq_nonneg {n : Type*} [Fintype n] (v : n -> ℂ) :
    0 ≤ l2NormSq v := by
  unfold l2NormSq
  exact Finset.sum_nonneg (by intro i _hi; exact Complex.normSq_nonneg _)

/-- Complex-dot-product form of the finite L2 norm square. -/
theorem l2NormSq_complex {n : Type*} [Fintype n] (v : n -> ℂ) :
    ((l2NormSq v : ℝ) : ℂ) = star v ⬝ᵥ v := by
  unfold l2NormSq dotProduct
  simp [Complex.normSq_eq_conj_mul_self]

/--
Generic finite Hilbert/L2 bridge: if `A^* A = coeff I`, then applying `A`
multiplies finite L2 norm squared by the real coefficient.
-/
theorem l2NormSq_mulVec_of_star_mul_eq_smul_one
    {n : Type*} [Fintype n] [DecidableEq n]
    (A : Matrix n n ℂ) (coeff : ℝ)
    (hA : star A * A = ((coeff : ℝ) : ℂ) • (1 : Matrix n n ℂ))
    (v : n -> ℂ) :
    l2NormSq (A.mulVec v) = coeff * l2NormSq v := by
  apply Complex.ofReal_injective
  calc
    ((l2NormSq (A.mulVec v) : ℝ) : ℂ)
        = star (A.mulVec v) ⬝ᵥ A.mulVec v := l2NormSq_complex (A.mulVec v)
    _ = Matrix.vecMul (star v) (star A) ⬝ᵥ A.mulVec v := by
          rw [Matrix.star_mulVec]
          simp [Matrix.star_eq_conjTranspose]
    _ = Matrix.vecMul (Matrix.vecMul (star v) (star A)) A ⬝ᵥ v := by
          rw [Matrix.dotProduct_mulVec]
    _ = Matrix.vecMul (star v) (star A * A) ⬝ᵥ v := by
          rw [Matrix.vecMul_vecMul]
    _ = Matrix.vecMul (star v) (((coeff : ℝ) : ℂ) •
          (1 : Matrix n n ℂ)) ⬝ᵥ v := by
          rw [hA]
    _ = (((coeff : ℝ) : ℂ) • star v) ⬝ᵥ v := by
          simp [Matrix.vecMul_smul, Matrix.vecMul_one]
    _ = ((coeff * l2NormSq v : ℝ) : ℂ) := by
          unfold dotProduct l2NormSq
          simp [Complex.normSq_eq_conj_mul_self, Finset.mul_sum, mul_assoc]

/-- Lower-bound variant of `l2NormSq_mulVec_of_star_mul_eq_smul_one`. -/
theorem l2NormSq_mulVec_lower_of_star_mul_coeff_gap
    {n : Type*} [Fintype n] [DecidableEq n]
    (A : Matrix n n ℂ) (coeff gamma : ℝ)
    (hA : star A * A = ((coeff : ℝ) : ℂ) • (1 : Matrix n n ℂ))
    (hgap : gamma ≤ coeff) (v : n -> ℂ) :
    gamma * l2NormSq v ≤ l2NormSq (A.mulVec v) := by
  rw [l2NormSq_mulVec_of_star_mul_eq_smul_one A coeff hA v]
  exact mul_le_mul_of_nonneg_right hgap (l2NormSq_nonneg v)

/-- The first scalar Wilson band for the equal-weight tetrahedral model. -/
def FirstWilsonBand (r rho : ℝ) : Prop :=
  0 < r ∧ 0 < rho ∧ rho < 2 * r

namespace FirstWilsonBand

theorem r_pos {r rho : ℝ} (h : FirstWilsonBand r rho) : 0 < r :=
  h.1

theorem rho_pos {r rho : ℝ} (h : FirstWilsonBand r rho) : 0 < rho :=
  h.2.1

theorem rho_lt_two_r {r rho : ℝ} (h : FirstWilsonBand r rho) : rho < 2 * r :=
  h.2.2

theorem two_r_sub_rho_pos {r rho : ℝ} (h : FirstWilsonBand r rho) :
    0 < 2 * r - rho := by
  nlinarith [h.rho_lt_two_r]

end FirstWilsonBand

/-- Sine coefficients for the rank-4 tetrahedral translation torus. -/
def sinCoeffs (k : Fin 4 -> ℝ) : Fin 4 -> ℝ :=
  fun A => Real.sin (k A)

/-- Scalar Wilson mass profile on the rank-4 tetrahedral momentum torus. -/
def mWilson (r rho : ℝ) (k : Fin 4 -> ℝ) : ℝ :=
  r * ∑ A : Fin 4, (1 - Real.cos (k A)) - rho

/-- Rank-4 Wilson radial coordinate `R(k) = sum_A (1 - cos k_A)`. -/
def wilsonR (k : Fin 4 -> ℝ) : ℝ :=
  ∑ A : Fin 4, (1 - Real.cos (k A))

/-- Scalar Wilson mass in terms of `wilsonR`. -/
theorem mWilson_eq_r_mul_wilsonR_sub (r rho : ℝ) (k : Fin 4 -> ℝ) :
    mWilson r rho k = r * wilsonR k - rho := by
  rfl

/-- The explicit uniform coefficient certificate for the first Wilson band. -/
def firstBandMu (r rho : ℝ) : ℝ :=
  min (rho ^ 2 / 4)
    (min ((2 * r - rho) ^ 2 / 4)
      (rho * (2 * r - rho) / (16 * r ^ 2)))

theorem firstBandMu_pos {r rho : ℝ} (hband : FirstWilsonBand r rho) :
    0 < firstBandMu r rho := by
  have hr : 0 < r := hband.r_pos
  have hrho : 0 < rho := hband.rho_pos
  have h1 : 0 < rho ^ 2 / 4 := by
    have hs : 0 < rho ^ 2 := sq_pos_of_pos hrho
    nlinarith
  have h2 : 0 < (2 * r - rho) ^ 2 / 4 := by
    have hgap : 0 < 2 * r - rho := hband.two_r_sub_rho_pos
    have hs : 0 < (2 * r - rho) ^ 2 := sq_pos_of_pos hgap
    nlinarith
  have h3 : 0 < rho * (2 * r - rho) / (16 * r ^ 2) := by
    have hgap : 0 < 2 * r - rho := hband.two_r_sub_rho_pos
    have hnum : 0 < rho * (2 * r - rho) := mul_pos hrho hgap
    have hden : 0 < 16 * r ^ 2 := by
      have hrsq : 0 < r ^ 2 := sq_pos_of_pos hr
      nlinarith
    exact div_pos hnum hden
  unfold firstBandMu
  exact lt_min h1 (lt_min h2 h3)

theorem firstBandMu_le_rho_sq_div_four (r rho : ℝ) :
    firstBandMu r rho ≤ rho ^ 2 / 4 := by
  unfold firstBandMu
  exact min_le_left _ _

theorem firstBandMu_le_two_r_sub_rho_sq_div_four (r rho : ℝ) :
    firstBandMu r rho ≤ (2 * r - rho) ^ 2 / 4 := by
  unfold firstBandMu
  exact le_trans (min_le_right _ _) (min_le_left _ _)

theorem firstBandMu_le_middle_bound (r rho : ℝ) :
    firstBandMu r rho ≤ rho * (2 * r - rho) / (16 * r ^ 2) := by
  unfold firstBandMu
  exact le_trans (min_le_right _ _) (min_le_right _ _)

/-- Trigonometric rewrite used by the explicit scalar-gap certificate. -/
theorem sin_sq_eq_one_sub_cos_mul (t : ℝ) :
    Real.sin t ^ 2 = (1 - Real.cos t) * (2 - (1 - Real.cos t)) := by
  have h := Real.sin_sq_add_cos_sq t
  nlinarith

/-- `qLower` controls the Wilson radial expression `R(k) * (2 - R(k)) / 4`. -/
theorem quarter_wilsonR_mul_two_sub_le_qLower (k : Fin 4 -> ℝ) :
    (1 / 4 : ℝ) * (wilsonR k * (2 - wilsonR k)) ≤
      TetraQSquareExact.qLower (sinCoeffs k) := by
  let x0 : ℝ := 1 - Real.cos (k 0)
  let x1 : ℝ := 1 - Real.cos (k 1)
  let x2 : ℝ := 1 - Real.cos (k 2)
  let x3 : ℝ := 1 - Real.cos (k 3)
  have hx0 : 0 ≤ x0 := by
    dsimp [x0]
    have h := Real.cos_le_one (k 0)
    nlinarith
  have hx1 : 0 ≤ x1 := by
    dsimp [x1]
    have h := Real.cos_le_one (k 1)
    nlinarith
  have hx2 : 0 ≤ x2 := by
    dsimp [x2]
    have h := Real.cos_le_one (k 2)
    nlinarith
  have hx3 : 0 ≤ x3 := by
    dsimp [x3]
    have h := Real.cos_le_one (k 3)
    nlinarith
  have hp01 : 0 ≤ x0 * x1 := mul_nonneg hx0 hx1
  have hp02 : 0 ≤ x0 * x2 := mul_nonneg hx0 hx2
  have hp03 : 0 ≤ x0 * x3 := mul_nonneg hx0 hx3
  have hp12 : 0 ≤ x1 * x2 := mul_nonneg hx1 hx2
  have hp13 : 0 ≤ x1 * x3 := mul_nonneg hx1 hx3
  have hp23 : 0 ≤ x2 * x3 := mul_nonneg hx2 hx3
  unfold TetraQSquareExact.qLower sinCoeffs wilsonR
  simp [Fin.sum_univ_four, sin_sq_eq_one_sub_cos_mul]
  nlinarith

/-- The scalar Wilson/free symbol attached to the abstract tetrahedral slash. -/
def K (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (k : Fin 4 -> ℝ) :
    Matrix Spin Spin ℂ :=
  ((a : ℂ)⁻¹) •
    (Complex.I • TetraEuclideanSlashData.Q D (sinCoeffs k)
      + ((mWilson r rho k : ℝ) : ℂ) • (1 : Matrix Spin Spin ℂ))

/-- The scalar Wilson/free symbol adjoint. -/
theorem K_star (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (k : Fin 4 -> ℝ) :
    star (K D a r rho k) =
      ((a : ℂ)⁻¹) •
        ((-Complex.I) • TetraEuclideanSlashData.Q D (sinCoeffs k)
          + ((mWilson r rho k : ℝ) : ℂ) • (1 : Matrix Spin Spin ℂ)) := by
  unfold K
  simp [TetraEuclideanSlashData.Q_hermitian]

/-- Exact scalar Wilson/free-symbol square. Cross terms cancel because `Q` is
Hermitian and the Wilson mass is scalar. -/
theorem K_star_mul (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (k : Fin 4 -> ℝ) :
    star (K D a r rho k) * K D a r rho k =
      ((((TetraQSquareExact.qExact (sinCoeffs k)
          + (mWilson r rho k) ^ 2) / a ^ 2 : ℝ) : ℂ)) •
        (1 : Matrix Spin Spin ℂ) := by
  let Q : Matrix Spin Spin ℂ := TetraEuclideanSlashData.Q D (sinCoeffs k)
  let m : ℂ := ((mWilson r rho k : ℝ) : ℂ)
  let q : ℂ := ((TetraQSquareExact.qExact (sinCoeffs k) : ℝ) : ℂ)
  let alpha : ℂ := (a : ℂ)⁻¹
  let L : Matrix Spin Spin ℂ :=
    (-Complex.I) • Q + m • (1 : Matrix Spin Spin ℂ)
  let R : Matrix Spin Spin ℂ :=
    Complex.I • Q + m • (1 : Matrix Spin Spin ℂ)
  have hQ2 : Q * Q = q • (1 : Matrix Spin Spin ℂ) := by
    simpa [Q, q] using TetraEuclideanSlashData.Q_square_exact D (sinCoeffs k)
  have hinner : L * R = (q + m ^ 2) • (1 : Matrix Spin Spin ℂ) := by
    dsimp [L, R]
    calc
      ((-Complex.I) • Q + m • (1 : Matrix Spin Spin ℂ)) *
          (Complex.I • Q + m • (1 : Matrix Spin Spin ℂ))
          =
            ((-Complex.I * Complex.I) • (Q * Q))
            + ((-Complex.I * m) • (Q * (1 : Matrix Spin Spin ℂ)))
            + ((m * Complex.I) • ((1 : Matrix Spin Spin ℂ) * Q))
            + ((m * m) •
                ((1 : Matrix Spin Spin ℂ) * (1 : Matrix Spin Spin ℂ))) := by
              simp [mul_add, add_mul, smul_add, smul_smul]
              module
      _ = (q + m ^ 2) • (1 : Matrix Spin Spin ℂ) := by
            rw [hQ2]
            ext i j
            by_cases hij : i = j
            · subst j
              simp
              ring_nf
            · simp [hij]
              ring_nf
  have hleftFactor :
      -(alpha • (Complex.I • Q))
          + alpha • (m • (1 : Matrix Spin Spin ℂ)) =
        alpha • L := by
    dsimp [L]
    ext i j
    simp [alpha]
    ring
  have hrightFactor :
      alpha • (Complex.I • Q)
          + alpha • (m • (1 : Matrix Spin Spin ℂ)) =
        alpha • R := by
    dsimp [R]
    ext i j
    simp [alpha]
    ring
  calc
    star (K D a r rho k) * K D a r rho k
        =
          (-(alpha • (Complex.I • Q))
              + alpha • (m • (1 : Matrix Spin Spin ℂ))) *
            (alpha • (Complex.I • Q)
              + alpha • (m • (1 : Matrix Spin Spin ℂ))) := by
            rw [K_star]
            unfold K
            simp [Q, m, alpha]
    _ = (alpha • L) * (alpha • R) := by
            rw [hleftFactor, hrightFactor]
    _ = alpha • (L * (alpha • R)) := by
            rw [smul_mul_assoc]
    _ = alpha • (alpha • (L * R)) := by
            rw [mul_smul_comm]
    _ = (alpha * alpha) • (L * R) := by
            rw [smul_smul]
    _ = ((((TetraQSquareExact.qExact (sinCoeffs k)
          + (mWilson r rho k) ^ 2) / a ^ 2 : ℝ) : ℂ)) •
        (1 : Matrix Spin Spin ℂ) := by
          rw [hinner]
          ext i j
          by_cases hij : i = j
          · subst j
            simp [q, m, alpha]
            ring_nf
          · simp [hij]

/-- Coefficient-level lower bound for the scalar Wilson/free-symbol square. -/
theorem scalarWilsonCoeff_lower (a r rho : ℝ) (k : Fin 4 -> ℝ) :
    (TetraQSquareExact.qLower (sinCoeffs k) + (mWilson r rho k) ^ 2) / a ^ 2 ≤
      (TetraQSquareExact.qExact (sinCoeffs k) + (mWilson r rho k) ^ 2) /
        a ^ 2 := by
  have hq := TetraQSquareExact.qLower_le_qExact (sinCoeffs k)
  have hsum :
      TetraQSquareExact.qLower (sinCoeffs k) + (mWilson r rho k) ^ 2 ≤
        TetraQSquareExact.qExact (sinCoeffs k) + (mWilson r rho k) ^ 2 := by
    linarith
  exact div_le_div_of_nonneg_right hsum (sq_nonneg a)

/-- If an external scalar/global-gap computation proves a uniform lower bound
for `qLower + m^2`, the exact scalar Wilson/free-symbol coefficient inherits the
same bound after the `a^{-2}` scaling. -/
theorem scalarWilsonCoeff_gap_from_qLower (a c r rho : ℝ) (k : Fin 4 -> ℝ)
    (hscalar :
      c ^ 2 ≤ TetraQSquareExact.qLower (sinCoeffs k) + (mWilson r rho k) ^ 2) :
    c ^ 2 / a ^ 2 ≤
      (TetraQSquareExact.qExact (sinCoeffs k) + (mWilson r rho k) ^ 2) /
        a ^ 2 := by
  have hq := TetraQSquareExact.qLower_le_qExact (sinCoeffs k)
  have hsum :
      c ^ 2 ≤ TetraQSquareExact.qExact (sinCoeffs k) + (mWilson r rho k) ^ 2 :=
    by linarith
  exact div_le_div_of_nonneg_right hsum (sq_nonneg a)

/--
Uniform coefficient-gap adapter.

If a scalar/global-gap certificate supplies `mu > 0` for
`qLower(sin k) + m(k)^2`, then the checked exact symbol coefficient inherits the
scaled uniform gap `mu / a^2`, provided `a > 0`.
-/
theorem scalarWilsonCoeff_uniform_scaled_gap_from_qLower
    (a mu r rho : ℝ) (ha : 0 < a) (hmu : 0 < mu)
    (hscalar :
      ∀ k : Fin 4 -> ℝ,
        mu ≤ TetraQSquareExact.qLower (sinCoeffs k) + (mWilson r rho k) ^ 2) :
    0 < mu / a ^ 2 ∧
      ∀ k : Fin 4 -> ℝ,
        mu / a ^ 2 ≤
          (TetraQSquareExact.qExact (sinCoeffs k) + (mWilson r rho k) ^ 2) /
            a ^ 2 := by
  constructor
  · exact div_pos hmu (sq_pos_of_pos ha)
  · intro k
    have hq := TetraQSquareExact.qLower_le_qExact (sinCoeffs k)
    have hsum :
        mu ≤ TetraQSquareExact.qExact (sinCoeffs k) + (mWilson r rho k) ^ 2 := by
      have hk := hscalar k
      linarith
    exact div_le_div_of_nonneg_right hsum (sq_nonneg a)

/-- Existential form of `scalarWilsonCoeff_uniform_scaled_gap_from_qLower`. -/
theorem scalarWilsonCoeff_uniform_scaled_gap_from_qLower_exists
    (a r rho : ℝ) (ha : 0 < a)
    (hscalar :
      ∃ mu : ℝ, 0 < mu ∧
        ∀ k : Fin 4 -> ℝ,
          mu ≤ TetraQSquareExact.qLower (sinCoeffs k) + (mWilson r rho k) ^ 2) :
    ∃ gamma : ℝ, 0 < gamma ∧
      ∀ k : Fin 4 -> ℝ,
        gamma ≤
          (TetraQSquareExact.qExact (sinCoeffs k) + (mWilson r rho k) ^ 2) /
            a ^ 2 := by
  rcases hscalar with ⟨mu, hmu, hbound⟩
  refine ⟨mu / a ^ 2, ?_, ?_⟩
  · exact (scalarWilsonCoeff_uniform_scaled_gap_from_qLower
      a mu r rho ha hmu hbound).1
  · exact (scalarWilsonCoeff_uniform_scaled_gap_from_qLower
      a mu r rho ha hmu hbound).2

/--
Uniform scalar lower-bound certificate for the first scalar Wilson band.

This proves the hard coefficient statement requested by the Gate C1 audit:
throughout the first Wilson band, the lower scalar expression
`qLower(sin k) + mWilson(k)^2` has a strictly positive uniform lower bound.

The explicit certificate is `firstBandMu r rho`.
-/
theorem scalarWilsonCoeff_uniform_gap (r rho : ℝ)
    (hband : FirstWilsonBand r rho) :
    ∃ mu : ℝ, 0 < mu ∧
      ∀ k : Fin 4 -> ℝ,
        mu ≤ TetraQSquareExact.qLower (sinCoeffs k) + (mWilson r rho k) ^ 2 := by
  refine ⟨firstBandMu r rho, firstBandMu_pos hband, ?_⟩
  intro k
  have hr : 0 < r := hband.r_pos
  have hr_nonneg : 0 ≤ r := le_of_lt hr
  have hrne : r ≠ 0 := ne_of_gt hr
  have hrho : 0 < rho := hband.rho_pos
  have hgap : 0 < 2 * r - rho := hband.two_r_sub_rho_pos
  have hqnonneg : 0 ≤ TetraQSquareExact.qLower (sinCoeffs k) := by
    unfold TetraQSquareExact.qLower
    positivity
  have hmassnonneg : 0 ≤ (mWilson r rho k) ^ 2 := sq_nonneg _
  by_cases hlow : wilsonR k ≤ rho / (2 * r)
  · have hmul := mul_le_mul_of_nonneg_left hlow hr_nonneg
    have hcoef : r * (rho / (2 * r)) = rho / 2 := by
      field_simp [hrne]
    have hmle : mWilson r rho k ≤ -rho / 2 := by
      rw [mWilson_eq_r_mul_wilsonR_sub]
      nlinarith
    have hmass : rho ^ 2 / 4 ≤ (mWilson r rho k) ^ 2 := by
      nlinarith [sq_nonneg (mWilson r rho k + rho / 2)]
    have hmu : firstBandMu r rho ≤ rho ^ 2 / 4 :=
      firstBandMu_le_rho_sq_div_four r rho
    nlinarith
  · by_cases hhigh : 1 + rho / (2 * r) ≤ wilsonR k
    · have hmul := mul_le_mul_of_nonneg_left hhigh hr_nonneg
      have hcoef : r * (1 + rho / (2 * r)) = r + rho / 2 := by
        field_simp [hrne]
      have hmge : (2 * r - rho) / 2 ≤ mWilson r rho k := by
        rw [mWilson_eq_r_mul_wilsonR_sub]
        nlinarith
      have hmass :
          (2 * r - rho) ^ 2 / 4 ≤ (mWilson r rho k) ^ 2 := by
        nlinarith [sq_nonneg (mWilson r rho k - (2 * r - rho) / 2)]
      have hmu : firstBandMu r rho ≤ (2 * r - rho) ^ 2 / 4 :=
        firstBandMu_le_two_r_sub_rho_sq_div_four r rho
      nlinarith
    · have hRlower_lt : rho / (2 * r) < wilsonR k := lt_of_not_ge hlow
      have hRlower : rho / (2 * r) ≤ wilsonR k := le_of_lt hRlower_lt
      have hRupper_lt : wilsonR k < 1 + rho / (2 * r) := lt_of_not_ge hhigh
      have hRupper : wilsonR k ≤ 1 + rho / (2 * r) := le_of_lt hRupper_lt
      have hdenpos : 0 < 2 * r := by nlinarith
      have hleft_nonneg : 0 ≤ rho / (2 * r) := le_of_lt (div_pos hrho hdenpos)
      have hRnonneg : 0 ≤ wilsonR k := le_trans hleft_nonneg hRlower
      have hright_nonneg : 0 ≤ (2 * r - rho) / (2 * r) :=
        le_of_lt (div_pos hgap hdenpos)
      have h2lower : (2 * r - rho) / (2 * r) ≤ 2 - wilsonR k := by
        have hcoef : 2 - (1 + rho / (2 * r)) = (2 * r - rho) / (2 * r) := by
          field_simp [hrne]
          ring
        nlinarith
      have hprod :
          (rho / (2 * r)) * ((2 * r - rho) / (2 * r)) ≤
            wilsonR k * (2 - wilsonR k) :=
        mul_le_mul hRlower h2lower hright_nonneg hRnonneg
      have hprod_eq :
          (rho / (2 * r)) * ((2 * r - rho) / (2 * r)) =
            rho * (2 * r - rho) / (4 * r ^ 2) := by
        field_simp [hrne]
        ring
      have hquarter :
          rho * (2 * r - rho) / (16 * r ^ 2) ≤
            (1 / 4 : ℝ) * (wilsonR k * (2 - wilsonR k)) := by
        calc
          rho * (2 * r - rho) / (16 * r ^ 2)
              = (1 / 4 : ℝ) * (rho * (2 * r - rho) / (4 * r ^ 2)) := by
                ring
          _ = (1 / 4 : ℝ) *
              ((rho / (2 * r)) * ((2 * r - rho) / (2 * r))) := by
                rw [hprod_eq]
          _ ≤ (1 / 4 : ℝ) * (wilsonR k * (2 - wilsonR k)) := by
                exact mul_le_mul_of_nonneg_left hprod (by norm_num)
      have hq :
          rho * (2 * r - rho) / (16 * r ^ 2) ≤
            TetraQSquareExact.qLower (sinCoeffs k) :=
        le_trans hquarter (quarter_wilsonR_mul_two_sub_le_qLower k)
      have hmu :
          firstBandMu r rho ≤ rho * (2 * r - rho) / (16 * r ^ 2) :=
        firstBandMu_le_middle_bound r rho
      nlinarith

/--
Uniform exact scalar Wilson/free-symbol coefficient gap in the first Wilson
band, including the physical `a > 0` scaling.
-/
theorem scalarWilsonExactCoeff_uniform_gap (a r rho : ℝ)
    (ha : 0 < a) (hband : FirstWilsonBand r rho) :
    ∃ gamma : ℝ, 0 < gamma ∧
      ∀ k : Fin 4 -> ℝ,
        gamma ≤
          (TetraQSquareExact.qExact (sinCoeffs k) + (mWilson r rho k) ^ 2) /
            a ^ 2 :=
  scalarWilsonCoeff_uniform_scaled_gap_from_qLower_exists
    a r rho ha (scalarWilsonCoeff_uniform_gap r rho hband)

/--
Uniform symbol-square package for the scalar Wilson/free symbol.

This is the coefficient-level form immediately before the vector norm theorem:
there is a positive `gamma` such that every momentum block satisfies the exact
identity `K(k)^* K(k) = coeff(k) I` with `coeff(k) >= gamma`.
-/
theorem K_star_mul_uniform_coeff_gap
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (ha : 0 < a) (hband : FirstWilsonBand r rho) :
    ∃ gamma : ℝ, 0 < gamma ∧
      ∀ k : Fin 4 -> ℝ,
        let coeff : ℝ :=
          (TetraQSquareExact.qExact (sinCoeffs k) + (mWilson r rho k) ^ 2) /
            a ^ 2
        gamma ≤ coeff ∧
          star (K D a r rho k) * K D a r rho k =
            ((coeff : ℝ) : ℂ) • (1 : Matrix Spin Spin ℂ) := by
  rcases scalarWilsonExactCoeff_uniform_gap a r rho ha hband with
    ⟨gamma, hgamma, hbound⟩
  refine ⟨gamma, hgamma, ?_⟩
  intro k
  exact ⟨hbound k, K_star_mul D a r rho k⟩

/--
Canonical finite Hilbert/L2 symbol norm-squared gap for the scalar Wilson/free
symbol `K`.

This is the vector form that the later Fourier/Parseval lift should consume.
The norm square is represented explicitly as `l2NormSq` to avoid accidentally
using a non-Hilbert default norm on a bare function space.
-/
theorem K_symbol_l2NormSq_gap
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (ha : 0 < a) (hband : FirstWilsonBand r rho) :
    ∃ gamma : ℝ, 0 < gamma ∧
      ∀ k : Fin 4 -> ℝ, ∀ psi : Spin -> ℂ,
        gamma * l2NormSq psi ≤ l2NormSq ((K D a r rho k).mulVec psi) := by
  rcases K_star_mul_uniform_coeff_gap D a r rho ha hband with
    ⟨gamma, hgamma, hgap⟩
  refine ⟨gamma, hgamma, ?_⟩
  intro k psi
  rcases hgap k with ⟨hcoeff, hstar⟩
  exact l2NormSq_mulVec_lower_of_star_mul_coeff_gap
    (K D a r rho k)
    ((TetraQSquareExact.qExact (sinCoeffs k) + (mWilson r rho k) ^ 2) / a ^ 2)
    gamma hstar hcoeff psi

/-- Hermitian sign-kernel symbol obtained from the scalar Wilson/free symbol by
left multiplication with a chirality matrix. -/
def H (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (k : Fin 4 -> ℝ) :
    Matrix Spin Spin ℂ :=
  gamma5 * K D a r rho k

/--
Unitary `gamma5` transfer: if `gamma5^* gamma5 = 1`, then left multiplication
by `gamma5` preserves finite L2 norm squared.
-/
theorem H_l2NormSq_eq_K_l2NormSq
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (k : Fin 4 -> ℝ)
    (hgamma5 : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (psi : Spin -> ℂ) :
    l2NormSq ((H gamma5 D a r rho k).mulVec psi) =
      l2NormSq ((K D a r rho k).mulVec psi) := by
  have hgamma5' :
      star gamma5 * gamma5 =
        (((1 : ℝ) : ℂ) • (1 : Matrix Spin Spin ℂ)) := by
    simpa using hgamma5
  calc
    l2NormSq ((H gamma5 D a r rho k).mulVec psi)
        = l2NormSq (gamma5.mulVec ((K D a r rho k).mulVec psi)) := by
            unfold H
            rw [← Matrix.mulVec_mulVec]
    _ = l2NormSq ((K D a r rho k).mulVec psi) := by
            simpa using
              l2NormSq_mulVec_of_star_mul_eq_smul_one
                gamma5 (1 : ℝ) hgamma5' ((K D a r rho k).mulVec psi)

/--
Canonical finite L2 symbol norm-squared gap for the Hermitian sign-kernel
symbol `H = gamma5 K`, transferred from the scalar Wilson/free symbol `K`.
-/
theorem H_symbol_l2NormSq_gap
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hgamma5 : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (ha : 0 < a) (hband : FirstWilsonBand r rho) :
    ∃ gamma : ℝ, 0 < gamma ∧
      ∀ k : Fin 4 -> ℝ, ∀ psi : Spin -> ℂ,
        gamma * l2NormSq psi ≤
          l2NormSq ((H gamma5 D a r rho k).mulVec psi) := by
  rcases K_symbol_l2NormSq_gap D a r rho ha hband with
    ⟨gamma, hgamma, hKgap⟩
  refine ⟨gamma, hgamma, ?_⟩
  intro k psi
  rw [H_l2NormSq_eq_K_l2NormSq gamma5 D a r rho k hgamma5 psi]
  exact hKgap k psi

/--
Pointwise physical positivity of the exact scalar Wilson/free-symbol
coefficient in the first Wilson band.

This is not yet the uniform `mu` theorem. It adapts the existing
`TetrahedralGlobalGap` pointwise branch-window scaffold to the checked
`K_star_mul` coefficient and adds the physical `a > 0` hypothesis required by
gap-facing APIs.
-/
theorem scalarWilsonCoeff_pos_of_firstBand (a r rho : ℝ) (k : Fin 4 -> ℝ)
    (ha : 0 < a) (hband : FirstWilsonBand r rho)
    (hper : ∀ A, k A ∈ Set.Ico 0 (2 * Real.pi)) :
    0 <
      (TetraQSquareExact.qExact (sinCoeffs k) + (mWilson r rho k) ^ 2) /
        a ^ 2 := by
  have hglobal :=
    TetrahedralGlobalGap.tetrahedral_freeGapScalar_pos r rho k hper
      hband.rho_pos hband.rho_lt_two_r
  have hq :
      TetrahedralGlobalGap.tetraKineticCoeffNormSq k =
        TetraQSquareExact.qExact (sinCoeffs k) := by
    simpa [sinCoeffs] using
      TetraQSquareExact.tetraKineticCoeffNormSq_eq_qExact k
  have hm :
      TetrahedralGlobalGap.wilsonScalar r rho k = mWilson r rho k := by
    rfl
  have hnum :
      0 < TetraQSquareExact.qExact (sinCoeffs k) + (mWilson r rho k) ^ 2 := by
    simpa [TetrahedralGlobalGap.freeGapScalar, hq, hm] using hglobal
  exact div_pos hnum (sq_pos_of_pos ha)

end TetraScalarWilsonSymbol
end GateC1
end NullEdge
end Draft
end PhysicsSM
