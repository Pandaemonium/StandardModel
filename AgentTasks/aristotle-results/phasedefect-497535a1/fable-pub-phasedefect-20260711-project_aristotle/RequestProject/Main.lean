import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

/-!
# Exact 4×4 Plücker phase-defect spectral theorem (free carrier)

This file formalises the free-carrier one-particle avatar of the statement
"the Plücker phase is physical": two sites with **equal** modulus `|z|` but
different parallel-transported phase have different spectra.

All objects are finite matrices over `ℂ` with symbolic parameters, so every
proof is kernel-only finite ring algebra (`ring`, `norm_num`, `fin_cases`,
`Matrix.ext`); no `native_decide` is used.

## Objects

* `zL zR : ℂ`, `t : ℝ`, `w : ℂ` with `w * conj w = 1` (the edge half-phase;
  `w` replaces `e^{iχ/2}` so nothing transcendental appears).
* `Bmat z = [[0, z], [conj z, 0]]`.
* `Sig = [[1,0],[0,-1]]` (Pauli-z).
* `Dg w = diag(w, conj w)`, `Tcoup t w = t • (Σ · diag(w, conj w))`.
* `Hmat zL zR t w` is the 4×4 Hamiltonian with block form
  `[[B zL, T], [Tᴴ, B zR]]`, written out entrywise.
* `aObs zL t = |zL|² + t²` (as a complex scalar `zL·conj zL + t²`).
* `Delta zL zR w = zR - (conj w)² · zL` (the transported mismatch,
  `(conj w)² = e^{-iχ}`).

## Physics framing (memo only)

Two sites with equal `|z|` but different transported relative phase have
different spectra, with preregistered gap observable `gSq` and exact zero-mode
locus `t = |zL|`, `zR = -e^{-iχ} zL` (Jackiw–Rossi / GW-adjacent, finite and
self-contained).  This is **not** a topological-protection statement.

Note: in this Mathlib version `Complex.abs` no longer exists, so the norm `‖·‖`
is used in place of `Complex.abs` throughout (`‖Δ‖`).
-/

namespace PhysicsSM.Draft.NullEdge.PlueckerPhaseDefectSpectrum

open Matrix ComplexConjugate

noncomputable section

/-- 2×2 off-diagonal block `B z = [[0, z], [conj z, 0]]`. -/
def Bmat (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ := !![0, z; conj z, 0]

/-- Pauli-`z` matrix `Σ = [[1,0],[0,-1]]`. -/
def Sig : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- The diagonal edge-phase matrix `diag(w, conj w)`. -/
def Dg (w : ℂ) : Matrix (Fin 2) (Fin 2) ℂ := !![w, 0; 0, conj w]

/-- Edge coupling `T = t • (Σ · diag(w, conj w))`. -/
def Tcoup (t : ℝ) (w : ℂ) : Matrix (Fin 2) (Fin 2) ℂ := (t : ℂ) • (Sig * Dg w)

/-- The 4×4 Hamiltonian in block form `[[B zL, T], [Tᴴ, B zR]]`, written
entrywise.  Its four 2×2 blocks are `B zL`, `Tcoup t w`, `(Tcoup t w)ᴴ`,
`B zR`. -/
def Hmat (zL zR : ℂ) (t : ℝ) (w : ℂ) : Matrix (Fin 4) (Fin 4) ℂ :=
  !![ 0,             zL,           (t : ℂ) * w,   0;
      conj zL,       0,            0,             -(t : ℂ) * conj w;
      (t : ℂ) * conj w, 0,         0,             zR;
      0,             -(t : ℂ) * w, conj zR,       0 ]

/-- Squared-energy shift `a = |zL|² + t²` (complex-valued: `zL·conj zL + t²`). -/
def aObs (zL : ℂ) (t : ℝ) : ℂ := zL * conj zL + (t : ℂ) ^ 2

/-- Parallel-transported mismatch `Δ = zR - e^{-iχ} zL`, with
`e^{-iχ} = (conj w)²`. -/
def Delta (zL zR w : ℂ) : ℂ := zR - (conj w) ^ 2 * zL

/-- Preregistered gap observable `gSq = a - t‖Δ‖` (real-valued).  This is the
lower squared-energy level `a - t|Δ|`; it vanishes exactly on the zero-mode
locus of `gap_zero_iff`. -/
noncomputable def gSq (zL zR w : ℂ) (t : ℝ) : ℝ :=
  Complex.normSq zL + t ^ 2 - t * ‖Delta zL zR w‖

/-- The common-phase conjugator `V = diag(b, conj b, b, conj b)`. -/
def Vmat (b : ℂ) : Matrix (Fin 4) (Fin 4) ℂ :=
  !![ b, 0, 0, 0; 0, conj b, 0, 0; 0, 0, b, 0; 0, 0, 0, conj b ]

/-! ### T1–T2: algebra of the 2×2 blocks -/

/-
**T1.** `B z · B z = (z · conj z) • 1`.
-/
theorem Bz_sq (z : ℂ) :
    Bmat z * Bmat z = (z * conj z) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ Bmat, Matrix.mul_apply ] ; ring

/-
**T2.** `Σ · B z = -(B z · Σ)` (the block and Pauli-z anticommute).
-/
theorem sigma_anticomm (z : ℂ) : Sig * Bmat z = - (Bmat z * Sig) := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Sig, Bmat, Matrix.mul_apply ]

/-! ### T3: hermiticity -/

/-
**T3.** `Hᴴ = H`.
-/
theorem H_hermitian (zL zR : ℂ) (t : ℝ) (w : ℂ) :
    (Hmat zL zR t w)ᴴ = Hmat zL zR t w := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Hmat, Matrix.mul_apply, Matrix.conjTranspose ] ;

/-! ### T4: the main phase-defect polynomial identity -/

/-
**T4 (MAIN).** Under equal moduli `hmod : zL·conj zL = zR·conj zR` (and
`|w| = 1`),
`(H² - a·1)² = (t² · Δ·conj Δ) · 1`.
-/
theorem phaseDefect_polynomial (zL zR : ℂ) (t : ℝ) (w : ℂ)
    (hw : w * conj w = 1) (hmod : zL * conj zL = zR * conj zR) :
    (Hmat zL zR t w * Hmat zL zR t w - aObs zL t • 1) *
        (Hmat zL zR t w * Hmat zL zR t w - aObs zL t • 1)
      = ((t : ℂ) ^ 2 * (Delta zL zR w * conj (Delta zL zR w)))
          • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  unfold Hmat aObs Delta;
  simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply, Fin.sum_univ_succ ] at *;
  grind +ring

/-! ### T5: the equal-modulus hypothesis is load-bearing -/

/-
**T5 (CONTROL).** Without equal moduli the T4 identity fails: at
`zL = 1, zR = 2, t = 1, w = 1` the two sides differ.
-/
theorem phaseDefect_needs_equal_moduli :
    (Hmat 1 2 1 1 * Hmat 1 2 1 1 - aObs 1 1 • 1) *
        (Hmat 1 2 1 1 * Hmat 1 2 1 1 - aObs 1 1 • 1)
      ≠ (((1 : ℂ) ^ 2 * (Delta 1 2 1 * conj (Delta 1 2 1)))
          • (1 : Matrix (Fin 4) (Fin 4) ℂ)) := by
  intro h; have := congr_fun ( congr_fun h 3 ) 3; norm_num [ Fin.sum_univ_succ, Fin.sum_univ_zero, Matrix.mul_apply, Matrix.sub_apply, Matrix.smul_apply, Matrix.one_apply, aObs, Delta ] at this;
  simp +decide [ Hmat ] at this;
  norm_num [ Complex.ext_iff ] at this

/-! ### T6: spectral consequence -/

/-
**T6.** For any eigenpair `H·v = μ·v` with `v ≠ 0`,
`(μ² - a)² = t² · Δ·conj Δ`, i.e. `μ² = a ± t‖Δ‖`.
-/
theorem phaseDefect_spectrum (zL zR : ℂ) (t : ℝ) (w : ℂ)
    (hw : w * conj w = 1) (hmod : zL * conj zL = zR * conj zR)
    (mu : ℂ) (v : Fin 4 → ℂ) (hv : v ≠ 0)
    (hev : (Hmat zL zR t w) *ᵥ v = mu • v) :
    (mu ^ 2 - aObs zL t) ^ 2
      = (t : ℂ) ^ 2 * (Delta zL zR w * conj (Delta zL zR w)) := by
  have hM : (Hmat zL zR t w * Hmat zL zR t w - aObs zL t • 1) *ᵥ v = (mu^2 - aObs zL t) • v := by
    simp_all +decide [ sq, sub_smul, Matrix.sub_mulVec, Matrix.smul_eq_diagonal_mul ];
    simp_all +decide [ ← Matrix.mulVec_mulVec, ← smul_assoc ];
    rw [ Matrix.mulVec_smul, hev, smul_smul, mul_comm ];
  have := phaseDefect_polynomial zL zR t w hw hmod;
  replace := congr_arg ( fun m => m *ᵥ v ) this; simp_all +decide [ sq, Matrix.mul_assoc ] ;
  simp_all +decide [ ← Matrix.mulVec_mulVec, Matrix.smul_eq_diagonal_mul ];
  simp_all +decide [ funext_iff, Matrix.mulVec ];
  exact mul_left_cancel₀ hv.choose_spec <| by linear_combination' this hv.choose;

/-! ### T7: trace / multiplicity balance -/

/-
**T7.** `trace H² = 2|zL|² + 2|zR|² + 4t²`.
-/
theorem trace_Hsq (zL zR : ℂ) (t : ℝ) (w : ℂ) (hw : w * conj w = 1) :
    Matrix.trace (Hmat zL zR t w * Hmat zL zR t w)
      = 2 * (zL * conj zL) + 2 * (zR * conj zR) + 4 * (t : ℂ) ^ 2 := by
  unfold Hmat; simp +decide [ Matrix.trace ] ; ring;
  simp +decide [ Fin.sum_univ_succ ] ; ring;
  linear_combination' hw * t ^ 2 * 4

/-
**T7 corollary.** Under equal moduli, `trace H² = 4a`.  With T4 this forces
the two squared-energy levels `a ± t‖Δ‖` to carry equal total multiplicity
`2 + 2` whenever `Δ ≠ 0`.
-/
theorem trace_Hsq_eq_four_a (zL zR : ℂ) (t : ℝ) (w : ℂ)
    (hw : w * conj w = 1) (hmod : zL * conj zL = zR * conj zR) :
    Matrix.trace (Hmat zL zR t w * Hmat zL zR t w) = 4 * aObs zL t := by
  rw [ trace_Hsq zL zR t w hw ];
  unfold aObs; linear_combination -2 * hmod;

/-! ### T8: zero-mode locus -/

/-
**T8 (⇐).** On the locus `t = |zL|`, `zR = -e^{-iχ} zL` the gap vanishes.
-/
theorem gap_zero_of (zL zR : ℂ) (t : ℝ) (w : ℂ)
    (hw : w * conj w = 1) (ht : t = ‖zL‖) (hz : zR = -(conj w) ^ 2 * zL) :
    gSq zL zR w t = 0 := by
  unfold gSq;
  simp_all +decide [ Complex.normSq_eq_norm_sq, Complex.norm_conj, hw, hz, Delta ];
  rw [ show - ( ( starRingEnd ℂ ) w ^ 2 * zL ) - ( starRingEnd ℂ ) w ^ 2 * zL = -2 * ( ( starRingEnd ℂ ) w ^ 2 * zL ) by ring ] ; norm_num [ Complex.norm_def, Complex.normSq ] ; ring;
  simp_all +decide [ Complex.ext_iff, sq ]

/-
**T8 (⇒).** For `t ≥ 0` and equal moduli, a vanishing gap forces the
zero-mode locus.
-/
theorem gap_zero_forward (zL zR : ℂ) (t : ℝ) (w : ℂ)
    (hw : w * conj w = 1) (htge : 0 ≤ t) (hmod : zL * conj zL = zR * conj zR)
    (hg : gSq zL zR w t = 0) :
    t = ‖zL‖ ∧ zR = -(conj w) ^ 2 * zL := by
  -- Set `A := zR`, `B := -(conj w)^2 * zL`, so `A + B = Delta zL zR w` and `‖A‖ = m`, `‖B‖ = m`.
  set A : ℂ := zR
  set B : ℂ := -(starRingEnd ℂ w) ^ 2 * zL
  have hA_eq_zero : ‖A‖ = ‖zL‖ := by
    simp_all +decide [ Complex.normSq, Complex.norm_def ];
    simp_all +decide [ Complex.ext_iff ]
  have hB_eq_zero : ‖B‖ = ‖zL‖ := by
    simp +zetaDelta at *;
    replace hw := congr_arg Norm.norm hw ; simp_all +decide [ sq ]
  have hAB_eq_zero : ‖A + B‖ = 2 * ‖zL‖ := by
    unfold gSq at hg;
    -- From `hg`, we get `(m - t)^2 + t * (2 * m - ‖Delta‖) = 0`.
    have h_eq_zero : (‖zL‖ - t) ^ 2 + t * (2 * ‖zL‖ - ‖A + B‖) = 0 := by
      convert hg using 1 ; rw [ Complex.normSq_eq_norm_sq ] ; ring;
      unfold Delta; ring;
      grind;
    by_cases ht : t = 0;
    · simp_all +decide [ Complex.normSq_eq_norm_sq ];
    · nlinarith [ show 0 < t by positivity, show ‖A + B‖ ≤ ‖A‖ + ‖B‖ by exact norm_add_le _ _ ]
  have hAB_eq_zero' : A = B := by
    -- Since ‖A + B‖ = ‖A‖ + ‖B‖, we have that A and B are collinear.
    have h_collinear : ∃ r : ℝ, 0 ≤ r ∧ r • A = B := by
      have h_collinear : ‖A + B‖ = ‖A‖ + ‖B‖ := by
        linarith;
      by_cases hA : A = 0;
      · aesop;
      · have := @sameRay_iff_norm_add ℂ;
        exact this.mpr h_collinear |> fun h => h.exists_nonneg_left hA;
    by_cases hzL : zL = 0 <;> simp_all +decide;
    obtain ⟨ r, hr₀, hr ⟩ := h_collinear; have := congr_arg Norm.norm hr; norm_num at this; simp_all +decide [ mul_comm ] ;
    rw [ abs_of_nonneg hr₀ ] at this; aesop;
  simp_all +decide [ gSq ];
  simp_all +decide [ Delta ];
  grind +suggestions

/-- **T8.** Full iff: for `t ≥ 0` and equal moduli, `gSq = 0` iff
`t = |zL|` and `zR = -e^{-iχ} zL`. -/
theorem gap_zero_iff (zL zR : ℂ) (t : ℝ) (w : ℂ)
    (hw : w * conj w = 1) (htge : 0 ≤ t) (hmod : zL * conj zL = zR * conj zR) :
    gSq zL zR w t = 0 ↔ (t = ‖zL‖ ∧ zR = -(conj w) ^ 2 * zL) :=
  ⟨gap_zero_forward zL zR t w hw htge hmod,
    fun h => gap_zero_of zL zR t w hw h.1 h.2⟩

/-! ### T9: common-phase conjugacy -/

/-
**T9 (unitarity).** `V = diag(b, conj b, b, conj b)` is unitary.
-/
theorem Vmat_unitary (b : ℂ) (hb : b * conj b = 1) :
    (Vmat b)ᴴ * Vmat b = 1 := by
  ext i j;
  simp +decide [ Vmat, Matrix.mul_apply ];
  fin_cases i <;> fin_cases j <;> simp +decide [ Fin.sum_univ_succ, hb ]; all_goals rwa [ mul_comm ]

/-
**T9.** Conjugating by `V` multiplies both site amplitudes by the common
phase `b²` and leaves the edge coupling untouched:
`V · H(zL, zR) · Vᴴ = H(b²·zL, b²·zR)`.  The observable depends only on the
transported **relative** phase.
-/
theorem common_phase_conjugacy (zL zR : ℂ) (t : ℝ) (w b : ℂ)
    (hb : b * conj b = 1) :
    Vmat b * Hmat zL zR t w * (Vmat b)ᴴ = Hmat (b ^ 2 * zL) (b ^ 2 * zR) t w := by
  unfold Vmat Hmat;
  ext i j; fin_cases i <;> fin_cases j <;>
    simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ ] <;> ring_nf
  · grobner
  · linear_combination' hb * t * starRingEnd ℂ w
  · linear_combination' hb * t * starRingEnd ℂ w
  · linear_combination' hb * t * w

end

end PhysicsSM.Draft.NullEdge.PlueckerPhaseDefectSpectrum
