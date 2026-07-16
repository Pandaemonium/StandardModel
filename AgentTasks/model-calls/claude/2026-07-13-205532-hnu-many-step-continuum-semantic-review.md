# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-13T20:55:24`
- Finished: `2026-07-13T20:55:32`
- Timeout seconds: `900`
- Max budget USD: `3.00`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 3.00 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
You are the independent semantic and Lean reviewer for a proposed headline continuum result in the StandardModel repo.

INTENDED READING:
The exact live HNU endpoint is PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint, with corrected signs and rightmost-first depth-eight schedule. The candidate HNUManyStepContinuum proves an explicit one-step O(eps^2) operator-norm bound against exp(-i eps q.sigma), then an exact-unitarity telescope yielding O(1/n) fixed-time convergence for each fixed momentum q. It must be about the SAME endpoint as the live module. It is not position-space L2 convergence, not uniform-in-q unless separately quantified, not Lorentz recovery, and not a topology/doubling result.

REVIEW TASK:
1. Compare the candidate standalone HNUExactCore.Core endpoint definition against the live HNUExactCore endpoint. Determine whether they are definitionally equal after the explicit name map sx=sigma1, sy=sigma2, sz=sigma3, proj=Pplus/Pminus and indexed Uplus/Uminus. Check factor ordering and all half-step signs.
2. Audit the exact statements and proofs of one_step_bound, many_step_bound, and many_step_tendsto for vacuity, false shape, hidden hypotheses, norm mismatch, or an algebraic error. Pay special attention to n casts/division, small-step eventuality, and whether the bound is genuinely for the actual endpoint.
3. Recommend the smallest safe live integration: either (A) port only Rrot/Mrot factorization lemmas into a live-import module and reuse the candidate proof, (B) prove an explicit endpoint equality bridge to the standalone-shaped definitions, or (C) reject.
4. State APPROVE, APPROVE-SUBSET, or REJECT. List exact theorem-level scientific scope and all forbidden prose claims.
5. If feasible, run direct Lean checks read-only. Do not edit files.

The candidate files and live source are embedded verbatim. Treat kernel acceptance as necessary but not sufficient.

## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/HNUExactCore.lean (459 lines)

```lean
/-
# HNU exact single-Weyl Floquet core

Self-contained, Mathlib-only formalization of the field-free
Higashikawa–Nakagawa–Ueda (HNU) single-Weyl Floquet schedule described in
`HNU_SINGLE_WEYL_RECONSTRUCTION.md`.

Everything lives in `Matrix (Fin 2) (Fin 2) ℂ`, built from the explicit Pauli
matrices and the spin projectors `P_j^± = (σ₀ ± σ_j)/2`.

## Corrected sign convention (recorded prominently)

The paper's compact substep symbol `U_j^±(k) := P_j^± e^{-ik} + P_j^∓` is
internally inconsistent when read with a uniform `e^{-ik}` on both `±` labels.
The unique consistent reading ties the exponent sign to the `±` label:

* `U_j^+(k) = P_j^+ · e^{-i k} + P_j^-`
* `U_j^-(k) = P_j^- · e^{+i k} + P_j^+`

and the half-step analogues along axis 3 use `k₃/2`:

* `U_{h,3}^+(k₃) = P_3^+ · e^{-i k₃/2} + P_3^-`
* `U_{h,3}^-(k₃) = P_3^- · e^{+i k₃/2} + P_3^+`.

Here `·` is genuine scalar multiplication of a matrix by a complex number, and
`+` is matrix addition. All results below use these corrected symbols.

Ordering convention: in a matrix product the **rightmost factor acts first**;
`endpoint` writes the eight factors in the paper's Eq. (5) order.

Provenance: clean-room formalization returned by Aristotle job
`510857de-e789-4e2d-89ed-1f58044381dd`, based on the repository's independent
HNU reconstruction and corrected sign convention.  The exact endpoint,
trace, and zero/pi census are proved here.  The momentum-space winding,
continuum Weyl tangent, real-space locality, and primitive-null realization
are separate gates and are not consequences of this module alone.
-/
import Mathlib

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.HNUExactCore

noncomputable section

/-- The `2 × 2` complex matrices, the single-spin Bloch space of the lower band. -/
abbrev M2 := Matrix (Fin 2) (Fin 2) ℂ

/-! ## Pauli matrices -/

/-- `σ₁ = σx`. -/
def σ1 : M2 := !![0, 1; 1, 0]
/-- `σ₂ = σy = [[0,-i],[i,0]]`. -/
def σ2 : M2 := !![0, -Complex.I; Complex.I, 0]
/-- `σ₃ = σz`. -/
def σ3 : M2 := !![1, 0; 0, -1]

/-! ## Spin projectors `P_j^± = (σ₀ ± σ_j)/2` -/

/-- The `+` projector `P^+(s) = (1 + s)/2`. -/
def Pplus (s : M2) : M2 := (2 : ℂ)⁻¹ • ((1 : M2) + s)
/-- The `-` projector `P^-(s) = (1 - s)/2`. -/
def Pminus (s : M2) : M2 := (2 : ℂ)⁻¹ • ((1 : M2) - s)

/-! ### Pauli involution facts -/

lemma σ1_herm : σ1ᴴ = σ1 := by
  simp only [σ1]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.conjTranspose]

lemma σ2_herm : σ2ᴴ = σ2 := by
  simp only [σ2]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.conjTranspose]

lemma σ3_herm : σ3ᴴ = σ3 := by
  simp only [σ3]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.conjTranspose]

lemma σ1_sq : σ1 * σ1 = 1 := by
  simp only [σ1]
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two]

lemma σ2_sq : σ2 * σ2 = 1 := by
  simp only [σ2]
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Complex.I_mul_I]

lemma σ3_sq : σ3 * σ3 = 1 := by
  simp only [σ3]
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two]

/-! ### Generic projector algebra (item 1) -/

/-- Complementarity: `P^+(s) + P^-(s) = 1`. -/
lemma Pplus_add_Pminus (s : M2) : Pplus s + Pminus s = 1 := by
  simp only [Pplus, Pminus]; module

/-- `P^+(s)` is Hermitian when `s` is Hermitian. -/
lemma Pplus_herm {s : M2} (h : sᴴ = s) : (Pplus s)ᴴ = Pplus s := by
  simp only [Pplus, conjTranspose_smul, conjTranspose_add, conjTranspose_one, h]
  norm_num

/-- `P^-(s)` is Hermitian when `s` is Hermitian. -/
lemma Pminus_herm {s : M2} (h : sᴴ = s) : (Pminus s)ᴴ = Pminus s := by
  simp only [Pminus, conjTranspose_smul, conjTranspose_sub, conjTranspose_one, h]
  norm_num

/-- `P^+(s)` is idempotent when `s² = 1`. -/
lemma Pplus_idem {s : M2} (h : s * s = 1) : Pplus s * Pplus s = Pplus s := by
  simp only [Pplus, Matrix.smul_mul, Matrix.mul_smul, mul_add, add_mul, Matrix.one_mul,
    Matrix.mul_one, h]
  match_scalars <;> ring

/-- `P^-(s)` is idempotent when `s² = 1`. -/
lemma Pminus_idem {s : M2} (h : s * s = 1) : Pminus s * Pminus s = Pminus s := by
  simp only [Pminus, Matrix.smul_mul, Matrix.mul_smul, mul_sub, sub_mul, Matrix.one_mul,
    Matrix.mul_one, h]
  match_scalars <;> ring

/-- Orthogonality: `P^+(s) · P^-(s) = 0` when `s² = 1`. -/
lemma Pplus_mul_Pminus {s : M2} (h : s * s = 1) : Pplus s * Pminus s = 0 := by
  simp only [Pplus, Pminus, Matrix.smul_mul, Matrix.mul_smul, add_mul, mul_sub, Matrix.one_mul,
    Matrix.mul_one, h]
  match_scalars <;> ring

/-- Orthogonality: `P^-(s) · P^+(s) = 0` when `s² = 1`. -/
lemma Pminus_mul_Pplus {s : M2} (h : s * s = 1) : Pminus s * Pplus s = 0 := by
  simp only [Pplus, Pminus, Matrix.smul_mul, Matrix.mul_smul, sub_mul, mul_add, Matrix.one_mul,
    Matrix.mul_one, h]
  match_scalars <;> ring

/-! ## Substep symbols with the corrected sign convention (§1.3) -/

/-- `U^+(s,θ) = e^{-iθ} · P^+(s) + P^-(s)`. -/
def Uplus (s : M2) (θ : ℝ) : M2 := Complex.exp (-(Complex.I * θ)) • Pplus s + Pminus s
/-- `U^-(s,θ) = e^{+iθ} · P^-(s) + P^+(s)`. -/
def Uminus (s : M2) (θ : ℝ) : M2 := Complex.exp (Complex.I * θ) • Pminus s + Pplus s

/-! ### Substep unitarity (item 2) -/

lemma Uplus_unitary {s : M2} (hh : sᴴ = s) (hs : s * s = 1) (θ : ℝ) :
    Uplus s θ ∈ unitary M2 := by
  -- First, we use the fact that `star (Uplus s θ)` is given by `exp(I*θ) • Pplus s + Pminus s` since `Pplus s` and `Pminus s` are Hermitian.
  have h_star_Uplus : (Uplus s θ)ᴴ = Complex.exp (Complex.I * θ) • Pplus s + Pminus s := by
    unfold Uplus; simp +decide [ *, Complex.exp_neg, Matrix.conjTranspose_smul ] ;
    simp +decide [ Complex.inv_def, Complex.normSq_eq_norm_sq, Complex.norm_exp, Pplus_herm hh, Pminus_herm hh ];
  -- Now let's compute the product $(\exp(I\theta) • Pplus s + Pminus s) * (Uplus s θ)$.
  have h_prod : (Complex.exp (Complex.I * θ) • Pplus s + Pminus s) * Uplus s θ = 1 := by
    unfold Uplus Pplus Pminus; simp +decide [ Matrix.mul_add, add_mul, mul_assoc, Complex.exp_add ] ; ring;
    simp_all +decide [ mul_sub, sub_mul, ← mul_assoc, ← smul_assoc ] ; ring;
    norm_num [ ← Complex.exp_add ] ; ext i j ; norm_num ; ring;
  convert Matrix.mem_unitaryGroup_iff.mpr _;
  convert mul_eq_one_comm.mp h_prod using 1;
  exact h_star_Uplus ▸ rfl

lemma Uminus_unitary {s : M2} (hh : sᴴ = s) (hs : s * s = 1) (θ : ℝ) :
    Uminus s θ ∈ unitary M2 := by
  constructor;
  · unfold Uminus; simp +decide [ *, Complex.exp_neg, Complex.exp_conj, Complex.conj_ofReal, Complex.conj_I, Complex.exp_add ] ; ring;
    unfold Pplus Pminus; norm_num [ Complex.exp_neg, Complex.exp_add, Complex.exp_mul_I, Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_assoc, Matrix.mul_add, Matrix.add_mul, hs ] ; ring;
    simp_all +decide [ Complex.exp_ne_zero, mul_sub, sub_mul, mul_assoc, smul_smul ] ; ring;
    rw [ show star s = s from by simpa [ Matrix.conjTranspose ] using hh ] ; ext i j ; norm_num ; ring;
    simp_all +decide [ Complex.mul_conj, Complex.normSq_eq_norm_sq, Complex.norm_exp ] ; ring;
  · unfold Uminus; simp +decide [ mul_add, add_mul, mul_comm, mul_left_comm, Complex.exp_neg, Complex.exp_add, Complex.exp_re, Complex.exp_im, mul_assoc, hh, hs ] ; ring;
    unfold Pplus Pminus; simp +decide [ ← mul_assoc, ← smul_assoc, Complex.exp_ne_zero, hh, hs ] ;
    simp_all +decide [ mul_sub, sub_mul, mul_add, add_mul, mul_assoc, mul_left_comm, Complex.exp_neg, Complex.exp_ne_zero, Complex.exp_add, Complex.exp_re, Complex.exp_im, mul_smul_comm, smul_smul ] ; ring_nf ; norm_num [ ← mul_assoc, ← Complex.exp_add ] ;
    rw [ show star s = s from by simpa [ Matrix.conjTranspose ] using hh ] ; norm_num [ Complex.mul_conj, Complex.normSq_eq_norm_sq, Complex.norm_exp ] ; ring;
    rw [ hs ] ; ext i j ; norm_num ; ring

/-! ### Substep determinant phases (item 2) -/

lemma Uplus_σ1_det (θ : ℝ) : (Uplus σ1 θ).det = Complex.exp (-(Complex.I * θ)) := by
  simp [Uplus, Pplus, Pminus, σ1, Matrix.det_fin_two]; ring

lemma Uplus_σ2_det (θ : ℝ) : (Uplus σ2 θ).det = Complex.exp (-(Complex.I * θ)) := by
  simp [Uplus, Pplus, Pminus, σ2, Matrix.det_fin_two]
  ring_nf; simp only [Complex.I_sq]; ring

lemma Uplus_σ3_det (θ : ℝ) : (Uplus σ3 θ).det = Complex.exp (-(Complex.I * θ)) := by
  simp [Uplus, Pplus, Pminus, σ3, Matrix.det_fin_two]; ring

lemma Uminus_σ1_det (θ : ℝ) : (Uminus σ1 θ).det = Complex.exp (Complex.I * θ) := by
  simp [Uminus, Pplus, Pminus, σ1, Matrix.det_fin_two]; ring

lemma Uminus_σ2_det (θ : ℝ) : (Uminus σ2 θ).det = Complex.exp (Complex.I * θ) := by
  simp [Uminus, Pplus, Pminus, σ2, Matrix.det_fin_two]
  ring_nf; simp only [Complex.I_sq]; ring

lemma Uminus_σ3_det (θ : ℝ) : (Uminus σ3 θ).det = Complex.exp (Complex.I * θ) := by
  simp [Uminus, Pplus, Pminus, σ3, Matrix.det_fin_two]; ring

/-! ## Depth-eight Floquet endpoint (§1.4, Eq. (5); rightmost factor acts first) -/

/-- The one-period lower-band `2×2` Floquet symbol.  `k 0, k 1, k 2` are
`k₁, k₂, k₃`; axis-3 pumps are half-steps `k₃/2`. -/
def endpoint (k : Fin 3 → ℝ) : M2 :=
  Uminus σ1 (k 0) * Uminus σ3 (k 2 / 2) * Uminus σ2 (k 1) * Uplus σ3 (k 2 / 2) *
    Uplus σ1 (k 0) * Uminus σ3 (k 2 / 2) * Uplus σ2 (k 1) * Uplus σ3 (k 2 / 2)

/-! ## Endpoint unitarity and determinant one (item 3) -/

theorem endpoint_unitary (k : Fin 3 → ℝ) : endpoint k ∈ unitary M2 := by
  have h_unitary : ∀ s : M2, sᴴ = s → ∀ θ : ℝ, s * s = 1 → Uplus s θ ∈ unitary M2 ∧ Uminus s θ ∈ unitary M2 := by
    exact fun s hs θ hs' => ⟨ Uplus_unitary hs hs' θ, Uminus_unitary hs hs' θ ⟩;
  exact Submonoid.mul_mem _ ( Submonoid.mul_mem _ ( Submonoid.mul_mem _ ( Submonoid.mul_mem _ ( Submonoid.mul_mem _ ( Submonoid.mul_mem _ ( Submonoid.mul_mem _ ( h_unitary σ1 σ1_herm ( k 0 ) σ1_sq |>.2 ) ( h_unitary σ3 σ3_herm ( k 2 / 2 ) σ3_sq |>.2 ) ) ( h_unitary σ2 σ2_herm ( k 1 ) σ2_sq |>.2 ) ) ( h_unitary σ3 σ3_herm ( k 2 / 2 ) σ3_sq |>.1 ) ) ( h_unitary σ1 σ1_herm ( k 0 ) σ1_sq |>.1 ) ) ( h_unitary σ3 σ3_herm ( k 2 / 2 ) σ3_sq |>.2 ) ) ( h_unitary σ2 σ2_herm ( k 1 ) σ2_sq |>.1 ) ) ( h_unitary σ3 σ3_herm ( k 2 / 2 ) σ3_sq |>.1 )

theorem endpoint_det (k : Fin 3 → ℝ) : (endpoint k).det = 1 := by
  unfold endpoint;
  simp +decide only [det_mul, Uminus_σ1_det, Uminus_σ3_det, Uminus_σ2_det, Uplus_σ3_det, Uplus_σ1_det,
      Uplus_σ2_det];
  norm_num [ ← Complex.exp_add ] ; ring;
  norm_num

/-- The endpoint is `SU(2)`-valued: `star U * U = 1`. -/
theorem endpoint_star_mul (k : Fin 3 → ℝ) : star (endpoint k) * endpoint k = 1 :=
  (Unitary.mem_iff.mp (endpoint_unitary k)).1

/-! ## Endpoint at momentum zero is the identity (item 4) -/

theorem endpoint_zero : endpoint (0 : Fin 3 → ℝ) = 1 := by
  -- By definition of $Uplus$ and $Uminus$, we know that $Uplus 0 = 1$ and $Uminus 0 = 1$.
  have h_Uplus_Uminus_zero : ∀ s : M2, Uplus s 0 = 1 ∧ Uminus s 0 = 1 := by
    unfold Uplus Uminus; simp +decide [ Pplus_add_Pminus ] ;
    exact fun s => by rw [ add_comm, Pplus_add_Pminus ] ;
  unfold endpoint; simp +decide [ h_Uplus_Uminus_zero ] ;

/-! ## SU(2) trace-extremum lemmas -/

/-- A unitary `2×2` matrix with trace `2` is the identity.  (Determinant one is
automatic here, so it is not needed as a hypothesis.) -/
theorem su2_trace_two {M : M2} (hU : M ∈ unitary M2)
    (htr : M.trace = 2) : M = 1 := by
  have h_norm : Matrix.trace (star (M - 1) * (M - 1)) = 0 := by
    simp_all +decide [ Matrix.mul_sub, sub_mul ];
    rw [ show star M = Mᴴ from rfl, Matrix.trace_conjTranspose ] ; aesop;
  simp +decide [ Matrix.trace, Matrix.mul_apply ] at h_norm ⊢;
  ext i j; fin_cases i <;> fin_cases j <;> simp_all +decide [ Complex.ext_iff ] ;
  · constructor <;> nlinarith only [ h_norm.1 ];
  · constructor <;> nlinarith only [ h_norm.1 ];
  · constructor <;> nlinarith only [ h_norm.1 ];
  · constructor <;> nlinarith only [ h_norm.1 ]

/-- A unitary `2×2` matrix with determinant one and trace `-2` is minus the
identity. -/
theorem su2_trace_neg_two {M : M2} (hU : M ∈ unitary M2) (hdet : M.det = 1)
    (htr : M.trace = -2) : M = -1 := by
  -- Let's denote the entries of M as a, b, c, and d.
  set a := M 0 0
  set b := M 0 1
  set c := M 1 0
  set d := M 1 1;
  -- From the unitarity condition, we have the following equations:
  -- 1. $a \overline{a} + b \overline{b} = 1$
  -- 2. $c \overline{c} + d \overline{d} = 1$
  -- 3. $a \overline{c} + b \overline{d} = 0$
  have h_unitarity : a * star a + b * star b = 1 ∧ c * star c + d * star d = 1 ∧ a * star c + b * star d = 0 := by
    have := hU.2;
    exact ⟨ by simpa [ Matrix.mul_apply, Fin.sum_univ_two ] using congr_fun ( congr_fun this 0 ) 0, by simpa [ Matrix.mul_apply, Fin.sum_univ_two ] using congr_fun ( congr_fun this 1 ) 1, by simpa [ Matrix.mul_apply, Fin.sum_univ_two ] using congr_fun ( congr_fun this 0 ) 1 ⟩;
  -- From the trace condition, we have $a + d = -2$.
  have h_trace : a + d = -2 := by
    rw [ ← htr, Matrix.trace_fin_two ];
  -- From the unitarity condition, we have $|a + 1|^2 + |b|^2 + |c|^2 + |d + 1|^2 = 0$.
  have h_sum_zero : Complex.normSq (a + 1) + Complex.normSq b + Complex.normSq c + Complex.normSq (d + 1) = 0 := by
    norm_num [ Complex.normSq, Complex.ext_iff ] at *;
    grind;
  -- Since the sum of squares of real numbers is zero, each square must be zero.
  have h_each_zero : Complex.normSq (a + 1) = 0 ∧ Complex.normSq b = 0 ∧ Complex.normSq c = 0 ∧ Complex.normSq (d + 1) = 0 := by
    exact ⟨ by linarith [ Complex.normSq_nonneg ( a + 1 ), Complex.normSq_nonneg b, Complex.normSq_nonneg c, Complex.normSq_nonneg ( d + 1 ) ], by linarith [ Complex.normSq_nonneg ( a + 1 ), Complex.normSq_nonneg b, Complex.normSq_nonneg c, Complex.normSq_nonneg ( d + 1 ) ], by linarith [ Complex.normSq_nonneg ( a + 1 ), Complex.normSq_nonneg b, Complex.normSq_nonneg c, Complex.normSq_nonneg ( d + 1 ) ], by linarith [ Complex.normSq_nonneg ( a + 1 ), Complex.normSq_nonneg b, Complex.normSq_nonneg c, Complex.normSq_nonneg ( d + 1 ) ] ⟩;
  ext i j; fin_cases i <;> fin_cases j <;> simp_all +decide [ Complex.ext_iff ] ;
  · exact ⟨ by linarith, by linarith ⟩;
  · aesop;
  · tauto;
  · constructor <;> linarith

/-! ## Exact trace identity (item 6) -/

theorem trace_endpoint (k : Fin 3 → ℝ) :
    (endpoint k).trace =
      2 * (2 * (Real.cos (k 0 / 2)) ^ 2 * (Real.cos (k 1 / 2)) ^ 2 *
        (Real.cos (k 2 / 2)) ^ 2 - 1) := by
  unfold endpoint Uplus Uminus Pplus Pminus;
  norm_num [ Complex.exp_neg, Complex.cos, Complex.sin ];
  norm_num [ Matrix.trace, Matrix.mul_apply, σ1, σ2, σ3 ];
  field_simp;
  repeat norm_num [ ← Complex.exp_nat_mul, ← Complex.exp_add ] ; ring

/-! ## Consequences of unitarity + trace -/

/-- If the endpoint trace is `2`, the endpoint is the identity. -/
theorem endpoint_eq_one_of_trace {k : Fin 3 → ℝ} (h : (endpoint k).trace = 2) :
    endpoint k = 1 :=
  su2_trace_two (endpoint_unitary k) h

/-- If the endpoint trace is `-2`, the endpoint is minus the identity. -/
theorem endpoint_eq_neg_one_of_trace {k : Fin 3 → ℝ} (h : (endpoint k).trace = -2) :
    endpoint k = -1 :=
  su2_trace_neg_two (endpoint_unitary k) (endpoint_det k) h

/-! ## Trigonometric facts on the closed interval `[-π,π]` -/

/-- `cos(x/2)² = 1` on `[-π,π]` exactly at `x = 0`. -/
lemma cos_half_sq_eq_one_iff {x : ℝ} (hx : x ∈ Set.Icc (-Real.pi) Real.pi) :
    Real.cos (x / 2) ^ 2 = 1 ↔ x = 0 := by
  constructor <;> intro h <;> simp_all +decide [ Real.cos_sq' ];
  rw [ Real.sin_eq_zero_iff_of_lt_of_lt ] at h <;> linarith [ Real.pi_pos ]

/-- `cos(x/2)² = 0` on `[-π,π]` exactly on the boundary `x = ±π`. -/
lemma cos_half_sq_eq_zero_iff {x : ℝ} (hx : x ∈ Set.Icc (-Real.pi) Real.pi) :
    Real.cos (x / 2) ^ 2 = 0 ↔ x = Real.pi ∨ x = -Real.pi := by
  constructor <;> intro h <;> simp_all +decide [ Real.cos_eq_zero_iff ];
  · rcases h with ⟨ k, rfl ⟩ ; rcases k with ( ⟨ _ | k ⟩ | ⟨ _ | k ⟩ ) <;> norm_num at * <;> nlinarith [ Real.pi_pos ] ;
  · rcases h with ( rfl | rfl ) <;> [ exact ⟨ 0, by ring ⟩ ; exact ⟨ -1, by ring ⟩ ]

/-- `cos(x/2)²` is at most `1`. -/
lemma cos_half_sq_le_one (x : ℝ) : Real.cos (x / 2) ^ 2 ≤ 1 := by
  exact Real.cos_sq_le_one _

/-! ## Boundary pinning: any coordinate `= π` gives `-1` (item 5) -/

theorem endpoint_pi (k : Fin 3 → ℝ) {i : Fin 3} (h : k i = Real.pi) :
    endpoint k = -1 := by
  convert endpoint_eq_neg_one_of_trace _;
  convert trace_endpoint k using 1;
  fin_cases i <;> simp_all +decide

/-! ## Zero-sector census on the closed cube `[-π,π]³` (item 7) -/

theorem zero_census (k : Fin 3 → ℝ) (hk : ∀ i, k i ∈ Set.Icc (-Real.pi) Real.pi) :
    endpoint k = 1 ↔ ∀ i, k i = 0 := by
  constructor;
  · intro h
    have htr : (endpoint k).trace = 2 := by
      aesop
    have hr : 2 * (2 * Real.cos (k 0 / 2) ^ 2 * Real.cos (k 1 / 2) ^ 2 * Real.cos (k 2 / 2) ^ 2 - 1) = 2 := by
      exact_mod_cast trace_endpoint k ▸ htr
    have ha := cos_half_sq_le_one (k 0)
    have hb := cos_half_sq_le_one (k 1)
    have hc := cos_half_sq_le_one (k 2)
    have ha0 := sq_nonneg (Real.cos (k 0 / 2))
    have hb0 := sq_nonneg (Real.cos (k 1 / 2))
    have hc0 := sq_nonneg (Real.cos (k 2 / 2))
    have e0 : Real.cos (k 0 / 2) ^ 2 = 1 := by
      nlinarith [ mul_nonneg ha0 hb0 ]
    have e1 : Real.cos (k 1 / 2) ^ 2 = 1 := by
      nlinarith [ mul_nonneg hb0 hc0 ]
    have e2 : Real.cos (k 2 / 2) ^ 2 = 1 := by
      grind
    intro i
    fin_cases i;
    · exact ( cos_half_sq_eq_one_iff ( hk 0 ) ) |>.1 e0;
    · exact cos_half_sq_eq_one_iff ( hk _ ) |>.1 e1;
    · exact ( cos_half_sq_eq_one_iff ( hk 2 ) ) |>.1 e2;
  · intro h; rw [ show k = 0 from funext h ] ; exact endpoint_zero;

/-! ## π-sector census on the closed cube `[-π,π]³` (item 8) -/

theorem pi_census (k : Fin 3 → ℝ) (hk : ∀ i, k i ∈ Set.Icc (-Real.pi) Real.pi) :
    endpoint k = -1 ↔ ∃ i, k i = Real.pi ∨ k i = -Real.pi := by
  constructor <;> intro h <;> have h' := trace_endpoint k <;> norm_num [ Complex.ext_iff ] at h' ⊢;
  · norm_cast at * ; simp_all +decide [ sq ];
    norm_cast at *; simp_all +decide [ Complex.cos, Complex.exp_re, Complex.exp_im ] ;
    -- By simplifying, we can see that this equation holds if and only if $\cos(k_i / 2) = 0$ for some $i$.
    have h_cos_zero : ∃ i, Real.cos (k i / 2) = 0 := by
      grind;
    obtain ⟨ i, hi ⟩ := h_cos_zero; use i; rw [ Real.cos_eq_zero_iff ] at hi; obtain ⟨ m, hm ⟩ := hi; rcases m with ⟨ _ | m ⟩ <;> norm_num at hm <;> first | left; nlinarith [ hk i ] | right; nlinarith [ hk i ] ;
  · -- Apply the lemma that states if the trace of the endpoint is -2, then the endpoint is -1.
    apply endpoint_eq_neg_one_of_trace; exact (by
    obtain ⟨ i, hi ⟩ := h; fin_cases i <;> simp_all +decide [ Complex.ext_iff ] ;
    · rcases hi with ( hi | hi ) <;> norm_num [ hi, Complex.cos, Complex.exp_re, Complex.exp_im, sq ] ; ring_nf ; norm_num [ mul_div ] at * ; linarith;
    · rcases hi with ( hi | hi ) <;> norm_cast <;> norm_num [ hi ];
      norm_num [ neg_div, Complex.cos, Complex.exp_re, Complex.exp_im, sq ];
    · rcases hi with ( hi | hi ) <;> norm_cast <;> norm_num [ hi ];
      norm_num [ neg_div, Complex.cos, Complex.exp_re, Complex.exp_im, sq ])

/-! ## Witnesses -/

/-- Zero witness: the origin is a zero-sector point. -/
theorem witness_zero : endpoint ![0, 0, 0] = 1 := by
  have : (![0, 0, 0] : Fin 3 → ℝ) = (0 : Fin 3 → ℝ) := by
    ext i; fin_cases i <;> rfl
  rw [this, endpoint_zero]

/-- Nontrivial boundary witness: a face point with three distinct coordinates. -/
theorem witness_pi : endpoint ![Real.pi, 1, 2] = -1 :=
  endpoint_pi _ (i := 0) rfl

/-- The origin is the *only* zero-sector point in the cube: a nonzero interior
point is not the identity. -/
theorem witness_zero_unique :
    endpoint ![Real.pi / 2, 0, 0] ≠ 1 := by
  have := trace_endpoint ![Real.pi / 2, 0, 0];
  contrapose! this; norm_num [ this, Matrix.trace_one ] ;
  erw [ Matrix.cons_val_succ' ] ; norm_num [ div_div ];
  norm_cast ; norm_num [ div_pow ]

end

end PhysicsSM.Draft.NullEdge.HNUExactCore

/-!
## Build-enforced axiom guards

Every headline theorem is checked to depend only on Lean/Mathlib's standard
axioms `propext`, `Classical.choice`, `Quot.sound` (in particular, no
`s o r r y Ax`, no `Lean.ofReduceBool`/`n a t i v e _ d e c i d e`, and no
user axioms).  The `#guard_msgs`
wrapper makes each check *build-enforced*: if the axiom set of any theorem ever
changes, the expected message no longer matches and the build fails.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.Pplus_herm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.Pplus_herm
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.Pplus_idem' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.Pplus_idem
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.Pplus_mul_Pminus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.Pplus_mul_Pminus
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.Uplus_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.Uplus_unitary
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.Uminus_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.Uminus_unitary
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.Uplus_σ1_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.Uplus_σ1_det
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.Uplus_σ2_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.Uplus_σ2_det
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.Uplus_σ3_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.Uplus_σ3_det
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.Uminus_σ1_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.Uminus_σ1_det
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.Uminus_σ2_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.Uminus_σ2_det
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.Uminus_σ3_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.Uminus_σ3_det
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_unitary
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_det
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_zero
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.su2_trace_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.su2_trace_two
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.su2_trace_neg_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.su2_trace_neg_two
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.trace_endpoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.trace_endpoint
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_pi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_pi
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.zero_census' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.zero_census
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.pi_census' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.pi_census
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.witness_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.witness_zero
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.witness_pi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.witness_pi
/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.witness_zero_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in #print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.witness_zero_unique

```

### AgentTasks/aristotle-downloads/73a1d386-9910-493b-84b2-1867bdf6ef2e/output-final_aristotle/HNUExactCore/Core.lean (564 lines)

```lean
/-
# HNU exact single-Weyl Floquet core — endpoint degree-one attack

Self-contained Mathlib-only formalization of the field-free
Higashikawa–Nakagawa–Ueda (HNU) single-Weyl Floquet schedule described in
`HNU_SINGLE_WEYL_RECONSTRUCTION.md`.

## Corrected sign convention (recorded prominently, see §1.3 of the report)

The paper's compact substep symbol `U_j^±(k) = P_j^± e^{-ik} + P_j^∓` is
internally inconsistent (it forces `det U ≠ 1` and destroys the Weyl
structure).  The unique consistent reading ties the exponent sign to the `±`
label:

* `U_j^+(k) = P_j^+ · exp(-i k) + P_j^-`
* `U_j^-(k) = P_j^- · exp(+i k) + P_j^+`
* `U_{h,3}^±(k₃) = P_3^± · exp(∓ i k₃/2) + P_3^∓`.

All definitions below use this corrected convention.

## What is proved here (kernel-checked algebra)

* projector algebra (Hermitian, idempotent, complementary, orthogonal);
* each corrected substep is unitary with the expected determinant phase;
* the depth-eight endpoint is unitary with determinant one (∈ SU(2));
* endpoint at `k = 0` is the identity;
* endpoint is `-1` whenever some momentum coordinate equals `π`;
* the exact trace identity;
* zero-sector and π-sector census on the closed cube.

## The degree-one invariant (topology handoff, `W = 1` left UNCLAIMED)

The headline topological statement is that the degree of `U : 𝕋³ → SU(2) ≅ S³`
equals `1`.  This is the third-homotopy/degree class of the map itself — it is
**not** `π₄(SU(2))`.  Mathlib currently has **no** Brouwer/topological degree
theory for maps between spheres/manifolds (verified: no `Brouwer`, no
topological `degree` in `Mathlib.Topology`).  Therefore `W = 1` is **not**
asserted as a proved theorem here.  The precise missing topology lemmas are
stated in the final section as documented `sorry`/hypothesis handoffs, together
with the algebraic inputs (single regular preimage of `+1`, local orientation
`+1`) that are proved.  No finite-grid surrogate is substituted for the degree.
-/
import Mathlib

namespace HNUExactCore

open Complex Matrix

noncomputable section

/-! ## 0. Pauli matrices and projectors -/

/-- `σ₁ = σx`. -/
def sx : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]
/-- `σ₂ = σy`. -/
def sy : Matrix (Fin 2) (Fin 2) ℂ := !![0, -I; I, 0]
/-- `σ₃ = σz`. -/
def sz : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- The three Pauli matrices indexed by `j : Fin 3` (`0 ↦ σ₁`, `1 ↦ σ₂`, `2 ↦ σ₃`). -/
def pauli : Fin 3 → Matrix (Fin 2) (Fin 2) ℂ
  | 0 => sx
  | 1 => sy
  | 2 => sz

/-- Sign attached to the `±` label. -/
def sgn (b : Bool) : ℂ := if b then 1 else -1

/-- Spin projector `P_j^b = (σ₀ + (±1) σ_j)/2`, `b = true` is `+`, `b = false` is `-`. -/
def proj (j : Fin 3) (b : Bool) : Matrix (Fin 2) (Fin 2) ℂ :=
  (2 : ℂ)⁻¹ • ((1 : Matrix (Fin 2) (Fin 2) ℂ) + sgn b • pauli j)

/-! ## 1. Projector algebra (L-proj) -/

lemma pauli_herm (j : Fin 3) : (pauli j)ᴴ = pauli j := by
  fin_cases j <;>
    (ext a b; fin_cases a <;> fin_cases b <;>
      simp [pauli, sx, sy, sz, Matrix.conjTranspose_apply, Complex.conj_I])

lemma pauli_sq (j : Fin 3) : pauli j * pauli j = 1 := by
  fin_cases j <;>
    (simp only [pauli, sx, sy, sz, Matrix.mul_fin_two]; ext a b; fin_cases a <;> fin_cases b <;>
      simp [Complex.I_mul_I])

lemma proj_herm (j : Fin 3) (b : Bool) : (proj j b)ᴴ = proj j b := by
  cases b <;> fin_cases j <;>
    (ext a c; fin_cases a <;> fin_cases c <;>
      simp [proj, sgn, pauli, sx, sy, sz, Matrix.conjTranspose_apply, Complex.conj_I] <;> ring)

lemma proj_idem (j : Fin 3) (b : Bool) : proj j b * proj j b = proj j b := by
  cases b <;> fin_cases j <;>
    (simp only [proj, sgn, pauli, sx, sy, sz]; ext a c; fin_cases a <;> fin_cases c <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two] <;> ring_nf <;> simp [Complex.I_sq] <;> ring)

lemma proj_add (j : Fin 3) : proj j true + proj j false = 1 := by
  fin_cases j <;>
    (ext a c; fin_cases a <;> fin_cases c <;>
      simp [proj, sgn, pauli, sx, sy, sz] <;> ring)

lemma proj_orthogonal (j : Fin 3) : proj j true * proj j false = 0 := by
  fin_cases j <;>
    (simp only [proj, sgn, pauli, sx, sy, sz]; ext a c; fin_cases a <;> fin_cases c <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two] <;> ring_nf <;> simp [Complex.I_sq])

lemma proj_orthogonal' (j : Fin 3) : proj j false * proj j true = 0 := by
  fin_cases j <;>
    (simp only [proj, sgn, pauli, sx, sy, sz]; ext a c; fin_cases a <;> fin_cases c <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two] <;> ring_nf <;> simp [Complex.I_sq])

/-! ## 2. Corrected substep symbols -/

/-- `U_j^+(k) = P_j^+ · exp(-i k) + P_j^-`. -/
def Uplus (j : Fin 3) (k : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Complex.exp (-I * (k : ℂ)) • proj j true + proj j false

/-- `U_j^-(k) = P_j^- · exp(+i k) + P_j^+`. -/
def Uminus (j : Fin 3) (k : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Complex.exp (I * (k : ℂ)) • proj j false + proj j true

/-- `U_{h,3}^+(k₃) = P_3^+ · exp(-i k₃/2) + P_3^-`. -/
def Uhplus (k3 : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Complex.exp (-I * ((k3 : ℂ) / 2)) • proj 2 true + proj 2 false

/-- `U_{h,3}^-(k₃) = P_3^- · exp(+i k₃/2) + P_3^+`. -/
def Uhminus (k3 : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Complex.exp (I * ((k3 : ℂ) / 2)) • proj 2 false + proj 2 true

/-! ### General conditioned-shift lemma -/

/-- A conditioned shift `z • P⁺ + P⁻` with `normSq z = 1` and complementary
orthogonal Hermitian idempotents is unitary. -/
lemma cshift_unitary (Pp Pm : Matrix (Fin 2) (Fin 2) ℂ) (z : ℂ)
    (hpp : Ppᴴ = Pp) (hpm : Pmᴴ = Pm)
    (hp2 : Pp * Pp = Pp) (hm2 : Pm * Pm = Pm)
    (hc : Pp + Pm = 1) (ho1 : Pp * Pm = 0) (ho2 : Pm * Pp = 0)
    (hz : Complex.normSq z = 1) :
    (z • Pp + Pm)ᴴ * (z • Pp + Pm) = 1 := by
  have hzz : star z * z = 1 := by
    rw [mul_comm]; rw [show z * star z = (Complex.normSq z : ℂ) from Complex.mul_conj z]
    exact_mod_cast hz
  rw [Matrix.conjTranspose_add, Matrix.conjTranspose_smul, hpp, hpm]
  rw [Matrix.add_mul, Matrix.mul_add, Matrix.mul_add]
  rw [Matrix.smul_mul, Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_smul]
  rw [hp2, ho1, ho2, hm2]
  simp only [smul_zero, add_zero, zero_add]
  rw [smul_smul, hzz, one_smul, hc]

/-! ### Substep unitarity (L1) -/

private lemma normSq_phase (w : ℂ) (hw : w.re = 0) : Complex.normSq (Complex.exp w) = 1 := by
  rw [Complex.normSq_eq_norm_sq, Complex.norm_exp, hw]; simp

lemma Uplus_unitary (j : Fin 3) (k : ℝ) : (Uplus j k)ᴴ * Uplus j k = 1 := by
  apply cshift_unitary _ _ _ (proj_herm j true) (proj_herm j false)
    (proj_idem j true) (proj_idem j false) (proj_add j) (proj_orthogonal j)
    (proj_orthogonal' j)
  exact normSq_phase _ (by simp)

lemma Uminus_unitary (j : Fin 3) (k : ℝ) : (Uminus j k)ᴴ * Uminus j k = 1 := by
  apply cshift_unitary _ _ _ (proj_herm j false) (proj_herm j true)
    (proj_idem j false) (proj_idem j true) (by rw [add_comm]; exact proj_add j)
    (proj_orthogonal' j) (proj_orthogonal j)
  exact normSq_phase _ (by simp)

lemma Uhplus_unitary (k3 : ℝ) : (Uhplus k3)ᴴ * Uhplus k3 = 1 := by
  apply cshift_unitary _ _ _ (proj_herm 2 true) (proj_herm 2 false)
    (proj_idem 2 true) (proj_idem 2 false) (proj_add 2) (proj_orthogonal 2)
    (proj_orthogonal' 2)
  exact normSq_phase _ (by simp)

lemma Uhminus_unitary (k3 : ℝ) : (Uhminus k3)ᴴ * Uhminus k3 = 1 := by
  apply cshift_unitary _ _ _ (proj_herm 2 false) (proj_herm 2 true)
    (proj_idem 2 false) (proj_idem 2 true) (by rw [add_comm]; exact proj_add 2)
    (proj_orthogonal' 2) (proj_orthogonal 2)
  exact normSq_phase _ (by simp)

/-- Determinant phase of each substep (L1). -/
lemma Uplus_det (j : Fin 3) (k : ℝ) : (Uplus j k).det = Complex.exp (-I * (k : ℂ)) := by
  fin_cases j <;>
    (simp only [Uplus, proj, sgn, pauli, sx, sy, sz]; rw [Matrix.det_fin_two]) <;>
    · simp [Matrix.add_apply, Matrix.smul_apply] <;> ring_nf <;> simp [Complex.I_sq] <;> ring

lemma Uminus_det (j : Fin 3) (k : ℝ) : (Uminus j k).det = Complex.exp (I * (k : ℂ)) := by
  fin_cases j <;>
    (simp only [Uminus, proj, sgn, pauli, sx, sy, sz]; rw [Matrix.det_fin_two]) <;>
    · simp [Matrix.add_apply, Matrix.smul_apply] <;> ring_nf <;> simp [Complex.I_sq] <;> ring

lemma Uhplus_det (k3 : ℝ) : (Uhplus k3).det = Complex.exp (-I * ((k3 : ℂ) / 2)) := by
  simp only [Uhplus, proj, sgn, pauli, sz]; rw [Matrix.det_fin_two]
  simp [Matrix.add_apply, Matrix.smul_apply] <;> ring_nf <;> simp [Complex.I_sq] <;> ring

lemma Uhminus_det (k3 : ℝ) : (Uhminus k3).det = Complex.exp (I * ((k3 : ℂ) / 2)) := by
  simp only [Uhminus, proj, sgn, pauli, sz]; rw [Matrix.det_fin_two]
  simp [Matrix.add_apply, Matrix.smul_apply] <;> ring_nf <;> simp [Complex.I_sq] <;> ring

/-! ## 3. Depth-eight endpoint -/

/-- The one-period lower-band symbol (rightmost factor acts first):

`U(k) = U₁⁻(k₁) U_{h,3}⁻(k₃) U₂⁻(k₂) U_{h,3}⁺(k₃) U₁⁺(k₁) U_{h,3}⁻(k₃) U₂⁺(k₂) U_{h,3}⁺(k₃)`.

Here `k 0 = k₁`, `k 1 = k₂`, `k 2 = k₃`. -/
def endpoint (k : Fin 3 → ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Uminus 0 (k 0) * Uhminus (k 2) * Uminus 1 (k 1) * Uhplus (k 2) *
    Uplus 0 (k 0) * Uhminus (k 2) * Uplus 1 (k 1) * Uhplus (k 2)

/-! ### Endpoint is in SU(2) (L2) -/

/-- The endpoint is unitary. -/
theorem endpoint_unitary (k : Fin 3 → ℝ) : (endpoint k)ᴴ * endpoint k = 1 := by
  have h : ∀ X Y : Matrix (Fin 2) (Fin 2) ℂ, Xᴴ * X = 1 → Yᴴ * Y = 1 → (X * Y)ᴴ * (X * Y) = 1 := by
    intro X Y hX hY
    rw [Matrix.conjTranspose_mul, mul_assoc, ← mul_assoc Xᴴ, hX, one_mul, hY]
  rw [endpoint]
  exact h _ _ (h _ _ (h _ _ (h _ _ (h _ _ (h _ _ (h _ _
    (Uminus_unitary 0 (k 0)) (Uhminus_unitary (k 2))) (Uminus_unitary 1 (k 1)))
    (Uhplus_unitary (k 2))) (Uplus_unitary 0 (k 0))) (Uhminus_unitary (k 2)))
    (Uplus_unitary 1 (k 1))) (Uhplus_unitary (k 2))

/-- The endpoint has determinant one. -/
theorem endpoint_det_one (k : Fin 3 → ℝ) : (endpoint k).det = 1 := by
  rw [endpoint]
  simp only [Matrix.det_mul, Uminus_det, Uhminus_det, Uhplus_det, Uplus_det]
  simp only [← Complex.exp_add]
  convert Complex.exp_zero using 2
  ring

/-! ## 4. Rotation (Bloch) factorisation and the `U = M²` identity -/

/-- SU(2) rotation `R_j(θ) = cos θ · σ₀ - i sin θ · σ_j`. -/
def Rrot (j : Fin 3) (θ : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (Real.cos θ : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) - (I * (Real.sin θ : ℂ)) • pauli j

/-
Each substep equals a scalar phase times a rotation.
-/
lemma Uplus_eq (j : Fin 3) (k : ℝ) :
    Uplus j k = Complex.exp (-I * ((k : ℂ) / 2)) • Rrot j (k / 2) := by
      fin_cases j <;> ext a b <;> simp +decide [ Uplus, proj, Rrot, sgn, pauli, sx, sy, sz, Matrix.add_apply, Matrix.smul_apply, Matrix.sub_apply, Complex.ofReal_cos, Complex.ofReal_sin, Complex.cos, Complex.sin ] <;> ring_nf;
      · fin_cases a <;> fin_cases b <;> norm_num [ ← Complex.exp_nat_mul, ← Complex.exp_add ] <;> ring; all_goals norm_num [ sq, ← Complex.exp_add ] ; ring;
      · fin_cases a <;> fin_cases b <;> norm_num [ pow_three, ← Complex.exp_add ] <;> ring;
        · rw [ ← Complex.exp_nat_mul ] ; ring;
        · norm_num [ sq, mul_assoc, ← Complex.exp_add ] ; ring;
        · norm_num [ sq, mul_assoc, ← Complex.exp_add ] ; ring;
        · rw [ ← Complex.exp_nat_mul ] ; ring;
      · fin_cases a <;> fin_cases b <;> norm_num [ ← Complex.exp_nat_mul, ← Complex.exp_add ] <;> ring; all_goals norm_num [ sq, ← Complex.exp_add ] ; ring

lemma Uminus_eq (j : Fin 3) (k : ℝ) :
    Uminus j k = Complex.exp (I * ((k : ℂ) / 2)) • Rrot j (k / 2) := by
      fin_cases j <;> ext a b <;> simp +decide [ Uminus, proj, Rrot, sgn, pauli, sx, sy, sz, Matrix.add_apply, Matrix.smul_apply, Matrix.sub_apply, Complex.ofReal_cos, Complex.ofReal_sin, Complex.cos, Complex.sin ] <;> ring;
      · fin_cases a <;> fin_cases b <;> norm_num [ sq, ← Complex.exp_add ] <;> ring; all_goals norm_num [ sq, ← Complex.exp_add ] ; ring;
      · fin_cases a <;> fin_cases b <;> norm_num [ ← Complex.exp_nat_mul, ← Complex.exp_add ] <;> ring; all_goals norm_num [ sq, mul_assoc, ← Complex.exp_add ] ; ring;
      · fin_cases a <;> fin_cases b <;> norm_num [ ← Complex.exp_nat_mul, ← Complex.exp_add ] <;> ring; all_goals norm_num [ sq, ← Complex.exp_add ] ; ring

lemma Uhplus_eq (k3 : ℝ) :
    Uhplus k3 = Complex.exp (-I * ((k3 : ℂ) / 4)) • Rrot 2 (k3 / 4) := by
      ext i j;
      fin_cases i <;> fin_cases j <;> simp +decide [ Uhplus, proj, Rrot, sgn, pauli, sz ] <;> ring;
      · rw [ show ( I * k3 * ( -1 / 2 ) : ℂ ) = I * k3 * ( -1 / 4 ) + I * k3 * ( -1 / 4 ) by ring, Complex.exp_add ] ; norm_num [ Complex.sin, Complex.cos ] ; ring;
        norm_num [ sq, ← Complex.exp_add ] ; ring;
      · norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, Complex.sin, Complex.cos ] ; ring;
        norm_num

lemma Uhminus_eq (k3 : ℝ) :
    Uhminus k3 = Complex.exp (I * ((k3 : ℂ) / 4)) • Rrot 2 (k3 / 4) := by
      ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Uhminus, proj, Rrot, sgn, pauli, sz, Complex.ofReal_cos, Complex.ofReal_sin, Complex.cos, Complex.sin, Complex.exp_re, Complex.exp_im ] <;> ring; all_goals norm_num [ sq, ← Complex.exp_add ] ; ring

/-- Each rotation is `SU(2)`: determinant one. -/
lemma Rrot_det (j : Fin 3) (θ : ℝ) : (Rrot j θ).det = 1 := by
  have h : (Complex.sin (θ : ℂ)) ^ 2 + (Complex.cos (θ : ℂ)) ^ 2 = 1 := Complex.sin_sq_add_cos_sq _
  fin_cases j <;>
    (simp only [Rrot, pauli, sx, sy, sz]; rw [Matrix.det_fin_two];
     simp [Matrix.sub_apply, Matrix.smul_apply]; ring_nf) <;>
    (simp only [Complex.I_sq, Complex.I_pow_four]) <;> linear_combination h

/-- Rotations about a fixed axis add: `R_j(θ) R_j(φ) = R_j(θ+φ)`. -/
lemma Rrot_add (j : Fin 3) (θ φ : ℝ) : Rrot j θ * Rrot j φ = Rrot j (θ + φ) := by
  have hcos : (Real.cos (θ + φ) : ℂ) = Real.cos θ * Real.cos φ - Real.sin θ * Real.sin φ := by
    rw [Real.cos_add]; push_cast; ring
  have hsin : (Real.sin (θ + φ) : ℂ) = Real.sin θ * Real.cos φ + Real.cos θ * Real.sin φ := by
    rw [Real.sin_add]; push_cast; ring
  fin_cases j <;>
    (simp only [Rrot, pauli, sx, sy, sz]; rw [hcos, hsin]; ext a b; fin_cases a <;> fin_cases b <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.sub_apply, Matrix.smul_apply,
        Matrix.one_apply] <;> ring_nf <;> simp [Complex.I_sq] <;> ring)

/-- Each substep is the identity at zero momentum. -/
lemma Uplus_zero (j : Fin 3) : Uplus j 0 = 1 := by
  rw [Uplus]; simp; exact proj_add j
lemma Uminus_zero (j : Fin 3) : Uminus j 0 = 1 := by
  rw [Uminus]; simp; rw [add_comm]; exact proj_add j
lemma Uhplus_zero : Uhplus 0 = 1 := by rw [Uhplus]; simp; exact proj_add 2
lemma Uhminus_zero : Uhminus 0 = 1 := by rw [Uhminus]; simp; rw [add_comm]; exact proj_add 2

/-- The "half-period" rotation word `M(k)`. -/
def Mrot (k : Fin 3 → ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Rrot 0 (k 0 / 2) * Rrot 2 (k 2 / 4) * Rrot 1 (k 1 / 2) * Rrot 2 (k 2 / 4)

/-
The endpoint factorises as the square of the rotation word `M`.
-/
theorem endpoint_eq_Msq (k : Fin 3 → ℝ) : endpoint k = Mrot k * Mrot k := by
  unfold endpoint Mrot;
  simp +decide only [Uminus_eq, Uhminus_eq, Uhplus_eq, Uplus_eq];
  norm_num [ ← smul_assoc, ← Complex.exp_add ] ; ring;
  norm_num [ ← mul_assoc ]

/-- `M(k)` has determinant one. -/
lemma Mrot_det (k : Fin 3 → ℝ) : (Mrot k).det = 1 := by
  simp only [Mrot, Matrix.det_mul, Rrot_det, mul_one]

/-
Scalar (Bloch `n₀`) part of `M(k)`: `tr M = 2 cos(k₁/2) cos(k₂/2) cos(k₃/2)`.
-/
lemma Mrot_trace (k : Fin 3 → ℝ) :
    (Mrot k).trace =
      2 * ((Real.cos (k 0 / 2) * Real.cos (k 1 / 2) * Real.cos (k 2 / 2) : ℝ) : ℂ) := by
  unfold Mrot Rrot;
  unfold pauli;
  unfold sx sy sz; norm_num [ Matrix.trace, Matrix.mul_apply ] ; ring;
  norm_num [ Complex.sin_sq, Complex.cos_sq ] ; ring

/-- Cayley–Hamilton for `2×2` matrices: `M² = (tr M) M - (det M) 1`. -/
lemma cayley_hamilton_two (M : Matrix (Fin 2) (Fin 2) ℂ) :
    M * M = M.trace • M - M.det • 1 := by
  rw [Matrix.trace_fin_two, Matrix.det_fin_two]
  ext a b; fin_cases a <;> fin_cases b <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.sub_apply, Matrix.smul_apply] <;> ring

/-! ## 5. Trace identity (L3) -/

/-- Exact trace identity. -/
theorem endpoint_trace (k : Fin 3 → ℝ) :
    (endpoint k).trace =
      2 * (2 * Real.cos (k 0 / 2) ^ 2 * Real.cos (k 1 / 2) ^ 2 * Real.cos (k 2 / 2) ^ 2 - 1) := by
  rw [endpoint_eq_Msq, cayley_hamilton_two, Matrix.trace_sub, Matrix.trace_smul,
    Matrix.trace_smul, Matrix.trace_one, Mrot_det, Mrot_trace]
  simp only [smul_eq_mul, Fintype.card_fin, Nat.cast_ofNat]
  push_cast; ring

/-! ## 6. Special values: identity and boundary pinning (L4) -/

/-- Endpoint at momentum zero is the identity. -/
theorem endpoint_zero : endpoint (fun _ => 0) = 1 := by
  have hp : ∀ j : Fin 3, Uplus j 0 = 1 := by
    intro j; rw [Uplus]; simp; exact proj_add j
  have hm : ∀ j : Fin 3, Uminus j 0 = 1 := by
    intro j; rw [Uminus]; simp; rw [add_comm]; exact proj_add j
  have hhp : Uhplus 0 = 1 := by rw [Uhplus]; simp; exact proj_add 2
  have hhm : Uhminus 0 = 1 := by rw [Uhminus]; simp; rw [add_comm]; exact proj_add 2
  simp only [endpoint, hp, hm, hhp, hhm, mul_one]

/-- Endpoint equals `-1` exactly when the scalar part of `M(k)` vanishes. -/
theorem endpoint_eq_neg_one_iff (k : Fin 3 → ℝ) :
    endpoint k = -1 ↔ (Mrot k).trace = 0 := by
  rw [endpoint_eq_Msq, cayley_hamilton_two, Mrot_det, one_smul]
  constructor
  · intro h
    have hz : (Mrot k).trace • Mrot k = 0 := by
      rw [sub_eq_iff_eq_add] at h; rw [h]; abel
    have hd := congrArg Matrix.det hz
    rw [Matrix.det_smul, Mrot_det, Matrix.det_zero ⟨0⟩, mul_one, Fintype.card_fin] at hd
    exact pow_eq_zero_iff (by norm_num) |>.mp hd
  · intro h; rw [h, zero_smul, zero_sub]

/-- Boundary pinning: if some coordinate equals `π`, the endpoint is `-1`. -/
theorem endpoint_pi (k : Fin 3 → ℝ) (i : Fin 3) (hi : k i = Real.pi) :
    endpoint k = -1 := by
  rw [endpoint_eq_neg_one_iff, Mrot_trace]
  have hc : Real.cos (k i / 2) = 0 := by rw [hi]; exact Real.cos_pi_div_two
  suffices h : Real.cos (k 0 / 2) * Real.cos (k 1 / 2) * Real.cos (k 2 / 2) = 0 by rw [h]; simp
  fin_cases i <;> simp_all

/-! ## 7. Zero- and π-sector census on the closed cube `[-π, π]³` (L6, L7) -/

/-- The closed Brillouin cube. -/
def cube (k : Fin 3 → ℝ) : Prop := ∀ i, k i ∈ Set.Icc (-Real.pi) Real.pi

/-
Zero-sector census: on the closed cube the endpoint is the identity iff all
coordinates vanish.
-/
theorem endpoint_zero_census (k : Fin 3 → ℝ) (hk : cube k) :
    endpoint k = 1 ↔ ∀ i, k i = 0 := by
      constructor;
      · intro h_eq_one
        have h_cos : ∀ i, Real.cos (k i / 2) = 1 := by
          have h_cos_sq : (Real.cos (k 0 / 2) * Real.cos (k 1 / 2) * Real.cos (k 2 / 2)) ^ 2 = 1 := by
            have h_cos_sq : (endpoint k).trace = 2 := by
              norm_num [ h_eq_one ];
            rw [ endpoint_trace ] at h_cos_sq;
            norm_cast at h_cos_sq; linarith;
          -- Since each cosine term is non-negative and their product is 1, each cosine term must be 1.
          have h_cos_one : ∀ i, Real.cos (k i / 2) = 1 := by
            intro i
            have h_cos_nonneg : 0 ≤ Real.cos (k i / 2) := by
              exact Real.cos_nonneg_of_mem_Icc ⟨ by linarith [ Set.mem_Icc.mp ( hk i ) ], by linarith [ Set.mem_Icc.mp ( hk i ) ] ⟩
            have h_cos_le_one : Real.cos (k i / 2) ≤ 1 := by
              exact Real.cos_le_one _
            fin_cases i <;> simp_all +decide [ mul_pow ];
            · nlinarith [ show 0 ≤ Real.cos ( k 1 / 2 ) ^ 2 * Real.cos ( k 2 / 2 ) ^ 2 by positivity, show Real.cos ( k 1 / 2 ) ^ 2 * Real.cos ( k 2 / 2 ) ^ 2 ≤ 1 by exact mul_le_one₀ ( Real.cos_sq_le_one _ ) ( sq_nonneg _ ) ( Real.cos_sq_le_one _ ) ];
            · nlinarith [ show 0 ≤ Real.cos ( k 0 / 2 ) ^ 2 * Real.cos ( k 2 / 2 ) ^ 2 by positivity, show Real.cos ( k 0 / 2 ) ^ 2 * Real.cos ( k 2 / 2 ) ^ 2 ≤ 1 by exact mul_le_one₀ ( Real.cos_sq_le_one _ ) ( sq_nonneg _ ) ( Real.cos_sq_le_one _ ) ];
            · nlinarith [ show 0 ≤ Real.cos ( k 0 / 2 ) ^ 2 * Real.cos ( k 1 / 2 ) ^ 2 by positivity, show Real.cos ( k 0 / 2 ) ^ 2 * Real.cos ( k 1 / 2 ) ^ 2 ≤ 1 by exact mul_le_one₀ ( Real.cos_sq_le_one _ ) ( sq_nonneg _ ) ( Real.cos_sq_le_one _ ) ];
          assumption;
        intro i; specialize h_cos i; rw [ Real.cos_eq_one_iff ] at h_cos; obtain ⟨ m, hm ⟩ := h_cos; rcases m with ⟨ _ | m ⟩ <;> norm_num at hm <;> nlinarith [ Real.pi_pos, hk i |>.1, hk i |>.2 ] ;
      · intro h; rw [ show k = fun _ => 0 from funext h ] ; exact endpoint_zero;

/-
π-sector census: on the closed cube the endpoint is `-1` iff some coordinate
lies on a boundary face `k i = ± π`.
-/
theorem endpoint_pi_census (k : Fin 3 → ℝ) (hk : cube k) :
    endpoint k = -1 ↔ ∃ i, k i = Real.pi ∨ k i = -Real.pi := by
      rw [ endpoint_eq_neg_one_iff ];
      constructor;
      · intro h;
        have h_cos_zero : ∃ i, Real.cos (k i / 2) = 0 := by
          exact not_forall_not.mp fun h' => absurd h <| by rw [ Mrot_trace ] ; norm_cast at *; aesop;
        obtain ⟨ i, hi ⟩ := h_cos_zero; use i; rw [ Real.cos_eq_zero_iff ] at hi; obtain ⟨ n, hn ⟩ := hi; rcases n with ( ⟨ _ | _ ⟩ | ⟨ _ | _ ⟩ ) <;> norm_num at hn <;> first | left; nlinarith [ Real.pi_pos, hk i |>.1, hk i |>.2 ] | right; nlinarith [ Real.pi_pos, hk i |>.1, hk i |>.2 ] ;
      · rintro ⟨ i, hi | hi ⟩ <;> fin_cases i <;> simp_all +decide [ Mrot_trace ]; all_goals norm_num [ neg_div ]

/-! ### Nontrivial witnesses -/

/-- A nontrivial zero-sector witness: `Γ = 0` gives the identity. -/
example : endpoint (fun _ => 0) = 1 := endpoint_zero

/-- A nontrivial π-sector witness: `k = (π, 0, 0)` gives `-1`. -/
example : endpoint (![Real.pi, 0, 0]) = -1 :=
  endpoint_pi _ 0 (by simp)

/-! ## 8. The degree-one invariant — exact missing topology lemmas

The topological invariant asked for is the **degree** of the map
`U : 𝕋³ → SU(2) ≅ S³`, i.e. `W` in the report's Eq. (6):

`W = -(1/24π²) ∫_{𝕋³} εⁱʲᵏ Tr[Rᵢ Rⱼ Rₖ] dk`,  `Rᵢ = Uᴴ ∂ᵢ U`.

This is **not** `π₄(SU(2))`; it is the third-homotopy/degree class of the map
itself.  Mathlib provides no Brouwer/topological degree theory for maps between
manifolds or spheres, so `W = 1` cannot be discharged from the current library.
The statements below record the missing topological content and the proved
algebraic pillars.  `W = 1` is stated only *relative to* the missing degree API
(supplied as hypotheses), and is therefore **not** claimed unconditionally.
No finite-grid surrogate is used. -/

/-- **Pillar A (single regular preimage of `+σ₀`), PROVED (L6).**  On the closed
cube the `ε = 0` value `+1` is attained only at the Weyl node `Γ = 0`.  This is
the "single regular preimage of the generic target near `+σ₀`" input of the
degree = signed-preimage-count theorem. -/
theorem regular_preimage_plus_one (k : Fin 3 → ℝ) (hk : cube k) :
    endpoint k = 1 ↔ ∀ i, k i = 0 := endpoint_zero_census k hk

/-- **Pillar B (boundary pinning ⇒ descends to `S³`), PROVED (L4).**  The endpoint
is constant `-1` on every boundary face, so the momentum map is constant on
`∂[-π,π]³` and descends to a continuous map `S³ → SU(2) ≅ S³`, on which a
Brouwer degree is defined. -/
theorem boundary_constant (k : Fin 3 → ℝ) (i : Fin 3) (hi : k i = Real.pi) :
    endpoint k = -1 := endpoint_pi k i hi

/-- The Bloch vector `n(k) : ℂ³` extracted from `U(k) = n₀ σ₀ - i n·σ`. -/
def blochVector (k : Fin 3 → ℝ) : Fin 3 → ℂ :=
  ![ I * (endpoint k 0 1 + endpoint k 1 0) / 2,
     (endpoint k 1 0 - endpoint k 0 1) / 2,
     I * (endpoint k 0 0 - endpoint k 1 1) / 2 ]

/-
Along each coordinate axis (only coordinate `j` nonzero) the endpoint reduces
to the single rotation `R_j(t)`.  (The other six substeps collapse to `1` at zero
momentum, and the two surviving ones compose by `Rrot_add`.)
-/
lemma endpoint_along_axis (j : Fin 3) (t : ℝ) :
    endpoint (Function.update (fun _ => 0) j t) = Rrot j t := by
      fin_cases j <;> simp +decide [ Function.update_apply, endpoint ];
      · simp +decide [ Uminus_eq, Uplus_eq, Uhminus_eq, Uhplus_eq, Rrot_add ];
        simp +decide [ ← smul_assoc, ← Complex.exp_add ] ; ring;
        convert Rrot_add 0 ( t / 2 ) ( t / 2 ) using 1 ; ring;
        · unfold Rrot; norm_num;
        · ring;
      · simp +decide [ Uminus_zero, Uplus_zero, Uhminus_zero, Uhplus_zero ];
        convert Rrot_add 1 ( t / 2 ) ( t / 2 ) using 1 ; ring;
        · rw [ Uminus_eq, Uplus_eq ] ; norm_num [ ← smul_assoc, ← Complex.exp_add ] ; ring;
        · ring;
      · simp +decide [ Uminus_zero, Uplus_zero, Uhminus_zero, Uhplus_zero ];
        rw [ Uhplus_eq, Uhminus_eq ];
        simp +decide [ smul_smul, ← Complex.exp_add, Rrot_add ];
        ring

/-
**Pillar C (local orientation `+1` at `Γ`), PROVED (L8).**
With `U = n₀ σ₀ - i n·σ`, the tangent map `J_{ij} = ∂ n_i / ∂ k_j` at `Γ` is the
identity: along axis `j` the Bloch vector is `n_i(t) = δ_{ij} · sin t`, whose
derivative at `0` is `δ_{ij}`.  Hence `χ = sign det J(Γ) = +1`, i.e. the local
degree at the single preimage `Γ` is `+1`.
-/
theorem local_orientation_plus_one :
    ∀ i j : Fin 3,
      HasDerivAt (fun t : ℝ => blochVector (Function.update (fun _ => 0) j t) i)
        (if i = j then 1 else 0) 0 := by
  intro i j;
  -- By definition of $blochVector$, we know that
  have h_blochVector : ∀ t : ℝ, blochVector (Function.update (fun _ => 0) j t) i = (if i = j then ((Real.sin t : ℝ) : ℂ) else 0) := by
    intro t; fin_cases i <;> fin_cases j <;> simp +decide [ blochVector, endpoint_along_axis, Rrot, pauli, sx, sy, sz, Matrix.smul_apply, Matrix.sub_apply, Matrix.one_apply, Matrix.mul_apply, Fin.sum_univ_two ] <;> ring;
    · norm_num [ Complex.ext_iff, sq ];
    · norm_num [ Complex.ext_iff, sq ];
    · norm_num [ Complex.ext_iff, sq ];
  split_ifs <;> simp_all +decide [ hasDerivAt_iff_tendsto_slope_zero ];
  have := Real.hasDerivAt_sin 0; have := this.tendsto_slope_zero; simp_all +decide ;
  convert Complex.continuous_ofReal.continuousAt.tendsto.comp this using 2 ; norm_num

/-- **MISSING TOPOLOGY THEOREM (degree = signed preimage count) ⟹ `W = 1`.**

`deg` is any integer-valued Brouwer degree defined on momentum maps that are
constant `-1` on the boundary; `hdeg_signed` is the (missing) theorem that this
degree equals the signed count of regular preimages of the value `+1`, which by
Pillar A is the single point `Γ` and by Pillar C carries orientation `+1`.  With
those inputs the degree of the HNU endpoint is `1`.

Because `deg` and `hdeg_signed` are hypotheses, this does **not** assert `W = 1`
absolutely — it isolates exactly what remains to be built. -/
theorem hnuDegree_eq_one
    (deg : ((Fin 3 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ) → ℤ)
    (hdeg_signed :
      (∀ k, cube k → (endpoint k = 1 ↔ ∀ i, k i = 0)) →
      (∀ i j : Fin 3,
        HasDerivAt (fun t : ℝ => blochVector (Function.update (fun _ => 0) j t) i)
          (if i = j then 1 else 0) 0) →
      deg endpoint = 1) :
    deg endpoint = 1 :=
  hdeg_signed (fun k hk => endpoint_zero_census k hk) local_orientation_plus_one

/-! ## 9. Build-enforced axiom guards for every headline theorem

Each `#print axioms` runs during compilation and surfaces the full axiom set of
the corresponding theorem.  A sorry (`sorryAx`) or any nonstandard axiom would
appear here; every guard below shows only `propext`, `Classical.choice`,
`Quot.sound`. -/

#print axioms proj_herm
#print axioms proj_idem
#print axioms proj_add
#print axioms proj_orthogonal
#print axioms Uplus_unitary
#print axioms Uminus_unitary
#print axioms Uhplus_unitary
#print axioms Uhminus_unitary
#print axioms Uplus_det
#print axioms Uminus_det
#print axioms Uhplus_det
#print axioms Uhminus_det
#print axioms endpoint_unitary
#print axioms endpoint_det_one
#print axioms endpoint_eq_Msq
#print axioms endpoint_trace
#print axioms endpoint_zero
#print axioms endpoint_pi
#print axioms endpoint_zero_census
#print axioms endpoint_pi_census
#print axioms endpoint_along_axis
#print axioms local_orientation_plus_one
#print axioms hnuDegree_eq_one

end

end HNUExactCore
```

### AgentTasks/aristotle-downloads/73a1d386-9910-493b-84b2-1867bdf6ef2e/output-final_aristotle/HNUManyStepContinuum.lean (555 lines)

```lean
/-
# HNU compact-momentum one-step `O(eps^2)` and many-step `O(1/n)` continuum bound

Bridge B2–B3 of the continuum/3+1 synthesis: a *quantitative* comparison of the
exact HNU single-Weyl Floquet endpoint `U(k)` (from `HNUExactCore.Core`) against
the continuum Weyl flow `exp(-i eps H_W(q))`, for compact momentum `q` and small
step `eps`, followed by a fixed-time many-step telescope that vanishes as `1/n`.

## Objects (matching the HNU tangent theorem, signs preserved)

* `Hw q = q₀ σ₁ + q₁ σ₂ + q₂ σ₃`   (the Weyl Hamiltonian symbol);
* `Wend q eps = endpoint (eps • q)` (the exact HNU endpoint at rescaled momentum);
* `Eflow q eps = exp(-i eps Hw q)`  (the continuum flow);
* `firstOrder q eps = 1 - (i eps) Hw q`.

The sign convention agrees with `HNUExactCore.Core.local_orientation_plus_one`:
to first order `endpoint (eps • q) = 1 - i eps (q·σ) + O(eps²)`, i.e. the tangent
generator is `-i (k·σ)`, exactly the generator of `Eflow`.

## What is proved

* `one_step_bound`  : `‖Wend q eps - Eflow q eps‖ ≤ Cbound q * eps²` for `|eps| ≤ 1`,
  an explicit compact-momentum second-order local remainder in the L2 operator norm;
* `many_step_bound` : with `eps = t/n`, `‖(Wend q (t/n))ⁿ - Eflow q t‖ ≤ Cbound q * t²/n`,
  obtained by an exact-unitary telescope with no exponential-in-`n` loss;
* `many_step_tendsto`: the `n`-step endpoint word converges to the exact flow.

All theorem *shapes* are reused from `FixedMomentumManyStepContinuum.lean`; the
`1+1` split-step walk there is **not** identified with the HNU endpoint — the
bounds below are proved for the actual HNU endpoint via its `U = M²` rotation
factorisation.

No position-space, full-`L²`, Lorentz, winding, chirality, or primitive-null
claim is made here.
-/
import Mathlib
import HNUExactCore.Core

open Matrix Complex Real
open scoped Matrix.Norms.L2Operator

namespace HNUManyStepContinuum

open HNUExactCore

abbrev Mat := Matrix (Fin 2) (Fin 2) ℂ

/-! ## Reused infrastructure (copied verbatim from `FixedMomentumManyStepContinuum`) -/

/-- Entrywise max of a `2×2` matrix. -/
noncomputable def entryMax (A : Mat) : ℝ :=
  max (max ‖A 0 0‖ ‖A 0 1‖) (max ‖A 1 0‖ ‖A 1 1‖)

theorem l2_opNorm_le_two_entryMax (A : Mat) :
    ‖A‖ ≤ 2 * entryMax A := by
  set c := entryMax A with hc
  have hc_nonneg : 0 ≤ c := by
    exact le_max_of_le_left ( le_max_of_le_left ( norm_nonneg _ ) );
  have h_bound : ∀ i j, ‖A i j‖ ≤ c := by
    intro i j; fin_cases i <;> fin_cases j <;> unfold entryMax at * <;> aesop;
  convert ContinuousLinearMap.opNorm_le_bound _ _ _ using 1;
  · positivity;
  · intro x; erw [ EuclideanSpace.norm_eq ] ; simp +decide [ Fin.sum_univ_two, Matrix.mulVec ] ; ring_nf; (
    have h_triangle : ‖A 0 0 * x.ofLp 0 + A 0 1 * x.ofLp 1‖ ≤ c * (‖x.ofLp 0‖ + ‖x.ofLp 1‖) ∧ ‖x.ofLp 0 * A 1 0 + x.ofLp 1 * A 1 1‖ ≤ c * (‖x.ofLp 0‖ + ‖x.ofLp 1‖) := by
      refine' ⟨ le_trans ( norm_add_le _ _ ) _, le_trans ( norm_add_le _ _ ) _ ⟩ <;> norm_num [ mul_add, mul_comm ]; all_goals exact add_le_add ( mul_le_mul_of_nonneg_right ( h_bound _ _ ) ( norm_nonneg _ ) ) ( mul_le_mul_of_nonneg_right ( h_bound _ _ ) ( norm_nonneg _ ) );
    rw [ EuclideanSpace.norm_eq ] ; norm_num [ Fin.sum_univ_two ] ; ring_nf at * ; (
    rw [ Real.sqrt_le_iff ] ; ring_nf at * ; norm_num at *;
    exact ⟨ by positivity, by rw [ Real.sq_sqrt <| by positivity ] ; nlinarith [ sq_nonneg ( ‖x.ofLp 0‖ - ‖x.ofLp 1‖ ), mul_nonneg hc_nonneg <| norm_nonneg <| x.ofLp 0, mul_nonneg hc_nonneg <| norm_nonneg <| x.ofLp 1, pow_le_pow_left₀ ( by positivity ) h_triangle.1 2, pow_le_pow_left₀ ( by positivity ) h_triangle.2 2 ] ⟩););

theorem abs_one_sub_cos_le (x : ℝ) : |1 - Real.cos x| ≤ x ^ 2 / 2 := by
  have h_cos_bound : 1 - x^2 / 2 ≤ Real.cos x := by
    apply Real.one_sub_sq_div_two_le_cos;
  exact abs_le.mpr ⟨ by linarith [ Real.cos_le_one x ], by linarith [ Real.cos_le_one x ] ⟩

theorem abs_sub_sin_le (x : ℝ) : |x - Real.sin x| ≤ x ^ 2 / 2 := by
  by_contra! h_contra;
  have h_g_nonneg : ∀ x : ℝ, 0 ≤ x → x^2 / 2 - x + Real.sin x ≥ 0 := by
    have h_g_deriv_nonneg : ∀ x : ℝ, 0 ≤ x → x - 1 + Real.cos x ≥ 0 := by
      intro x hx_nonneg
      have h_cos_bound : ∀ x : ℝ, 0 ≤ x → Real.cos x ≥ 1 - x^2 / 2 := by
        exact fun _ _ => Real.one_sub_sq_div_two_le_cos
      nlinarith [ h_cos_bound x hx_nonneg, Real.cos_sq' x ];
    have h_g_integral : ∀ x : ℝ, 0 ≤ x → ∫ t in (0 : ℝ)..x, (t - 1 + Real.cos t) = x^2 / 2 - x + Real.sin x := by
      norm_num;
    exact fun x hx => h_g_integral x hx ▸ intervalIntegral.integral_nonneg ( by linarith ) fun t ht => h_g_deriv_nonneg t ( by linarith [ ht.1 ] );
  cases abs_cases ( x - Real.sin x ) <;> simp_all +decide;
  · by_cases hx : 0 ≤ x;
    · linarith [ h_g_nonneg x hx ];
    · nlinarith [ Real.sin_lt ( neg_pos.mpr ( lt_of_not_ge hx ) ), Real.sin_neg x ];
  · by_cases hx : x < 0;
    · have := h_g_nonneg ( -x ) ( by linarith ) ; norm_num at * ; nlinarith [ Real.sin_neg x ] ;
    · nlinarith [ Real.sin_lt <| show 0 < x from lt_of_le_of_ne ( le_of_not_gt hx ) ( Ne.symm <| by rintro rfl; norm_num at h_contra ) ]

theorem norm_exp_sub_one_sub_le (X : Mat) :
    ‖NormedSpace.exp X - 1 - X‖ ≤ ‖X‖ ^ 2 / 2 * Real.exp ‖X‖ := by
  set A := NormedSpace.exp X - 1 - X with hA_def;
  have hA_series : A = ∑' n : ℕ, (1 / (Nat.factorial (n + 2)) : ℂ) • X ^ (n + 2) := by
    have hA_series : A = ∑' n : ℕ, (1 / (Nat.factorial n) : ℂ) • X ^ n - 1 - X := by
      convert rfl;
      norm_num [ NormedSpace.exp_eq_tsum ];
      grind +suggestions;
    rw [ hA_series, ← Summable.sum_add_tsum_nat_add 2 ];
    · norm_num [ Finset.sum_range_succ ] ; abel1;
    · refine' .of_norm _;
      have h_norm_pow : ∀ n : ℕ, ‖X ^ n‖ ≤ ‖X‖ ^ n := by
        exact fun n => norm_pow_le X n
      simp_all +decide [ norm_smul ];
      exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ( norm_nonneg _ ) ) ( fun n => mul_le_mul_of_nonneg_left ( h_norm_pow n ) ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ) ( by simpa [ inv_mul_eq_div ] using Real.summable_pow_div_factorial ‖X‖ );
  have hA_norm : ‖A‖ ≤ ∑' n : ℕ, (‖X‖ ^ (n + 2) / (Nat.factorial (n + 2)) : ℝ) := by
    refine' hA_series ▸ le_trans ( norm_tsum_le_tsum_norm _ ) _;
    · have h_norm_pow : ∀ n : ℕ, ‖X ^ (n + 2)‖ ≤ ‖X‖ ^ (n + 2) := by
        intro n;
        exact norm_pow_le X (n + 2)
      simp_all +decide [ norm_smul ];
      exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ( norm_nonneg _ ) ) ( fun n => mul_le_mul_of_nonneg_left ( h_norm_pow n ) ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ) ( by simpa [ inv_mul_eq_div ] using summable_nat_add_iff 2 |>.2 <| Real.summable_pow_div_factorial _ );
    · refine' Summable.tsum_le_tsum _ _ _;
      · intro n; rw [ norm_smul, norm_div ] ; norm_num ; ring_nf;
        rw [ mul_assoc ] ; gcongr ; ring_nf ;
        rw [ ← pow_add ] ; exact norm_pow_le' _ ( by norm_num ) ;
      · have h_norm_pow : ∀ n : ℕ, ‖X ^ n‖ ≤ ‖X‖ ^ n := by
          intro n; induction n <;> simp_all +decide [ pow_succ' ] ;
          exact le_trans ( norm_mul_le _ _ ) ( mul_le_mul_of_nonneg_left ‹_› ( norm_nonneg _ ) );
        norm_num [ norm_smul ];
        exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ( norm_nonneg _ ) ) ( fun n => mul_le_mul_of_nonneg_left ( h_norm_pow _ ) ( inv_nonneg.2 ( Nat.cast_nonneg _ ) ) ) ( by simpa [ inv_mul_eq_div ] using summable_nat_add_iff 2 |>.2 <| Real.summable_pow_div_factorial _ );
      · exact Real.summable_pow_div_factorial _ |> Summable.comp_injective <| add_left_injective 2;
  have h_sum_bound : ∑' n : ℕ, (‖X‖ ^ (n + 2) / (Nat.factorial (n + 2)) : ℝ) ≤ (‖X‖ ^ 2 / 2) * ∑' n : ℕ, (‖X‖ ^ n / (Nat.factorial n) : ℝ) := by
    rw [ ← tsum_mul_left ] ; refine' Summable.tsum_le_tsum _ _ _;
    · intro n; rw [ div_mul_div_comm ] ; rw [ div_le_div_iff₀ ] <;> first | positivity | norm_cast ; ring_nf ;
      exact mul_le_mul_of_nonneg_left ( mod_cast by rw [ add_comm ] ; exact Nat.factorial_mul_factorial_dvd_factorial_add _ _ |> Nat.le_of_dvd ( by positivity ) ) ( by positivity );
    · exact Real.summable_pow_div_factorial _ |> Summable.comp_injective <| Nat.succ_injective.comp <| Nat.succ_injective;
    · exact Summable.mul_left _ <| Real.summable_pow_div_factorial _;
  exact hA_norm.trans <| h_sum_bound.trans_eq <| by rw [ Real.exp_eq_exp_ℝ ] ; rw [ NormedSpace.exp_eq_tsum_div ] ;

theorem unitary_pow_telescope {U V : Mat}
    (hU : U ∈ Matrix.unitaryGroup (Fin 2) ℂ)
    (hV : V ∈ Matrix.unitaryGroup (Fin 2) ℂ) (n : ℕ) :
    ‖U ^ n - V ^ n‖ ≤ (n : ℝ) * ‖U - V‖ := by
  induction' n with n ih;
  · norm_num [ Norm.norm ];
  · have h_succ : U ^ (n + 1) - V ^ (n + 1) = U * (U ^ n - V ^ n) + (U - V) * V ^ n := by
      simp +decide [ pow_succ', mul_sub, sub_mul ];
    have h_unitary : ‖U‖ = 1 ∧ ‖V‖ = 1 := by
      exact ⟨ CStarRing.norm_of_mem_unitary hU, CStarRing.norm_of_mem_unitary hV ⟩;
    have h_Vn : ‖V ^ n‖ ≤ 1 := by
      refine' Nat.recOn n _ _ <;> simp_all +decide [ pow_succ' ];
      exact fun n hn => le_trans ( norm_mul_le _ _ ) ( by simpa [ hV ] using hn );
    have h_ind : ‖U * (U ^ n - V ^ n)‖ ≤ ‖U ^ n - V ^ n‖ ∧ ‖(U - V) * V ^ n‖ ≤ ‖U - V‖ := by
      exact ⟨ by simpa [ h_unitary ] using norm_mul_le U ( U ^ n - V ^ n ), by simpa [ h_unitary ] using norm_mul_le ( U - V ) ( V ^ n ) |> le_trans <| mul_le_of_le_one_right ( norm_nonneg _ ) h_Vn ⟩;
    exact h_succ.symm ▸ le_trans ( norm_add_le _ _ ) ( by push_cast; linarith )

/-! ## HNU-specific objects -/

noncomputable section

/-- The Weyl Hamiltonian symbol `H_W(q) = q₀ σ₁ + q₁ σ₂ + q₂ σ₃`. -/
def Hw (q : Fin 3 → ℝ) : Mat :=
  (q 0 : ℂ) • sx + (q 1 : ℂ) • sy + (q 2 : ℂ) • sz

/-- The exact HNU endpoint at rescaled compact momentum `W(q, eps) = U(eps • q)`. -/
def Wend (q : Fin 3 → ℝ) (eps : ℝ) : Mat := endpoint (fun i => eps * q i)

/-- The continuum Weyl flow `E(q, eps) = exp(-i eps H_W(q))`. -/
def Eflow (q : Fin 3 → ℝ) (eps : ℝ) : Mat :=
  NormedSpace.exp ((-(eps : ℂ)) • (I • Hw q))

/-- First-order term `1 - i eps H_W(q)`. -/
def firstOrder (q : Fin 3 → ℝ) (eps : ℝ) : Mat := 1 - (I * (eps : ℂ)) • Hw q

/-- First-order term of the half-period rotation word `M`: `1 - (i eps/2) H_W(q)`. -/
def Mfirst (q : Fin 3 → ℝ) (eps : ℝ) : Mat := 1 - (I * (eps : ℂ) / 2) • Hw q

/-- Compact-momentum magnitude `|q₀| + |q₁| + |q₂|`. -/
def qAbs (q : Fin 3 → ℝ) : ℝ := |q 0| + |q 1| + |q 2|

/-- Per-factor first-order generator `-(i θ) σ_j` (so `Rrot j θ = 1 + gen j θ + O(θ²)`). -/
def gen (j : Fin 3) (θ : ℝ) : Mat := -(I * (θ : ℂ)) • pauli j

theorem qAbs_nonneg (q : Fin 3 → ℝ) : 0 ≤ qAbs q := by
  unfold qAbs; positivity

/-- Generous explicit constant for the rotation-word remainder `‖M(eps•q) - Mfirst‖`. -/
def CM (q : Fin 3 → ℝ) : ℝ := 40 * (qAbs q) ^ 2 + 40 * (qAbs q) ^ 3

/-- Generous explicit one-step constant. -/
def Cbound (q : Fin 3 → ℝ) : ℝ :=
  CM q * (2 + qAbs q / 2) + (qAbs q) ^ 2 / 4 + (qAbs q) ^ 2 * Real.exp (qAbs q)

theorem CM_nonneg (q : Fin 3 → ℝ) : 0 ≤ CM q := by
  unfold CM; have := qAbs_nonneg q; positivity

theorem Cbound_nonneg (q : Fin 3 → ℝ) : 0 ≤ Cbound q := by
  unfold Cbound
  have h1 := CM_nonneg q
  have h2 := qAbs_nonneg q
  positivity

/-! ## Hermiticity and the norm of `H_W` -/

theorem Hw_isHermitian (q : Fin 3 → ℝ) : (Hw q).IsHermitian := by
  unfold Hw;
  unfold sx sy sz; ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.IsHermitian ] ;

theorem norm_Hw_le (q : Fin 3 → ℝ) : ‖Hw q‖ ≤ qAbs q := by
  refine' le_trans _ ( show qAbs q ≥ ‖( q 0 : ℂ) • sx‖ + ‖( q 1 : ℂ) • sy‖ + ‖( q 2 : ℂ) • sz‖ from _ );
  · exact le_trans ( norm_add₃_le .. ) ( by norm_num );
  · -- By definition of $sx$, $sy$, and $sz$, we know that their norms are 1.
    have h_norm_sx : ‖sx‖ ≤ 1 := by
      refine' ContinuousLinearMap.opNorm_le_bound _ zero_le_one _;
      simp +decide [ EuclideanSpace.norm_eq, sx ];
      exact fun x => Real.sqrt_le_sqrt <| by linarith!;
    have h_norm_sy : ‖sy‖ ≤ 1 := by
      refine' ContinuousLinearMap.opNorm_le_bound _ zero_le_one _;
      simp +decide [ EuclideanSpace.norm_eq, sy ];
      exact fun x => Real.sqrt_le_sqrt <| by linarith!;
    have h_norm_sz : ‖sz‖ ≤ 1 := by
      convert ContinuousLinearMap.opNorm_le_bound _ zero_le_one _;
      intro x; simp +decide [ sz, EuclideanSpace.norm_eq ];
      rfl;
    simp_all +decide [ norm_smul, qAbs ];
    exact add_le_add_three ( mul_le_of_le_one_right ( abs_nonneg _ ) h_norm_sx ) ( mul_le_of_le_one_right ( abs_nonneg _ ) h_norm_sy ) ( mul_le_of_le_one_right ( abs_nonneg _ ) h_norm_sz )

/-! ## Single-rotation first-order control -/

/-
Each `Rrot` is unitary for real angles.
-/
theorem Rrot_mem_unitary (j : Fin 3) (θ : ℝ) :
    Rrot j θ ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  apply Matrix.mem_unitaryGroup_iff'.mpr;
  fin_cases j <;> ext a b <;> fin_cases a <;> fin_cases b <;> simp +decide [ Rrot, pauli, sx, sy, sz, Matrix.mul_apply, Fin.sum_univ_two, Matrix.conjTranspose_apply, star, Complex.ext_iff ] <;> ring_nf;
  all_goals norm_cast; norm_num [ Real.sin_sq, Real.cos_sq ] ;

theorem norm_Rrot (j : Fin 3) (θ : ℝ) : ‖Rrot j θ‖ = 1 :=
  CStarRing.norm_of_mem_unitary (Rrot_mem_unitary j θ)

/-
Entrywise `O(θ²)` bound of one rotation against its first-order term.
-/
theorem Rrot_sub_gen_bound (j : Fin 3) (θ : ℝ) :
    ‖Rrot j θ - (1 + gen j θ)‖ ≤ 2 * θ ^ 2 := by
  refine' le_trans ( l2_opNorm_le_two_entryMax _ ) _;
  fin_cases j <;> simp +decide [ entryMax, Rrot, gen, pauli ];
  · norm_num [ Complex.normSq, Complex.norm_def, sx ];
    norm_cast;
    rw [ Real.sqrt_mul_self_eq_abs, Real.sqrt_mul_self_eq_abs ];
    have := abs_one_sub_cos_le θ; have := abs_sub_sin_le θ; simp_all +decide [ abs_sub_comm ];
    grind;
  · simp +decide [ Complex.normSq, Complex.norm_def, sy ];
    norm_cast;
    rw [ Real.sqrt_mul_self_eq_abs, Real.sqrt_mul_self_eq_abs, Real.sqrt_mul_self_eq_abs ];
    have := abs_one_sub_cos_le θ; have := abs_sub_sin_le θ; simp_all +decide [ abs_sub_comm ];
    grind;
  · simp +decide [ sz ];
    norm_num [ Complex.normSq, Complex.norm_def ];
    norm_cast;
    refine' ⟨ ⟨ _, sq_nonneg _ ⟩, sq_nonneg _, _ ⟩; all_goals rw [ Real.sqrt_le_left ] <;> nlinarith [ abs_one_sub_cos_le θ, abs_sub_sin_le θ, abs_le.mp ( abs_one_sub_cos_le θ ), abs_le.mp ( abs_sub_sin_le θ ) ]

theorem norm_gen_le (j : Fin 3) (θ : ℝ) : ‖gen j θ‖ ≤ 2 * |θ| := by
  convert l2_opNorm_le_two_entryMax _ |> le_trans <| mul_le_mul_of_nonneg_left ( show entryMax ( gen j θ ) ≤ |θ| from ?_ ) zero_le_two using 1;
  unfold entryMax gen; fin_cases j <;> simp +decide [ HNUExactCore.pauli ] ;
  · unfold sx; norm_num;
  · unfold sy; norm_num [ Complex.normSq, Complex.norm_def ] ;
  · unfold sz; norm_num

/-
`‖Rrot j θ - 1‖ ≤ 2|θ| + 2θ²`.
-/
theorem norm_Rrot_sub_one (j : Fin 3) (θ : ℝ) :
    ‖Rrot j θ - 1‖ ≤ 2 * |θ| + 2 * θ ^ 2 := by
  -- Apply the norm_sub_le lemma to split the norm into two parts.
  have h_split : ‖Rrot j θ - 1‖ ≤ ‖Rrot j θ - (1 + gen j θ)‖ + ‖gen j θ‖ := by
    convert norm_add_le ( Rrot j θ - ( 1 + gen j θ ) ) ( gen j θ ) using 2 ; abel_nf;
  linarith [ Rrot_sub_gen_bound j θ, norm_gen_le j θ ]

/-! ## Binary near-identity product telescope -/

/-
If `A ≈ 1 + X` and `B ≈ 1 + Y`, then `A B ≈ 1 + (X + Y)` with the stated remainder.
This uses the exact identity
`A B - (1 + (X + Y)) = (A - (1 + X)) B + X (B - 1) + (B - (1 + Y))`.
-/
theorem prod_sub_add (A B X Y : Mat) {a x b1 nb bY : ℝ}
    (hA : ‖A - (1 + X)‖ ≤ a) (hX : ‖X‖ ≤ x)
    (hB1 : ‖B - 1‖ ≤ b1) (hnB : ‖B‖ ≤ nb) (hBY : ‖B - (1 + Y)‖ ≤ bY)
    (hb1 : 0 ≤ b1) (hnb : 0 ≤ nb) :
    ‖A * B - (1 + (X + Y))‖ ≤ a * nb + x * b1 + bY := by
  convert norm_add_le ( ( A - ( 1 + X ) ) * B + X * ( B - 1 ) ) ( B - ( 1 + Y ) ) |> le_trans <| ?_ using 1;
  · simp +decide [ add_mul, mul_add, mul_sub, sub_mul, add_assoc, add_sub_assoc ];
    exact congr_arg Norm.norm ( by abel1 );
  · refine' le_trans ( add_le_add ( norm_add_le _ _ ) le_rfl ) _;
    gcongr;
    · exact le_trans ( norm_mul_le _ _ ) ( mul_le_mul hA hnB ( by positivity ) ( by linarith [ norm_nonneg ( A - ( 1 + X ) ) ] ) );
    · exact le_trans ( norm_mul_le _ _ ) ( mul_le_mul hX hB1 ( by positivity ) ( by linarith [ norm_nonneg X ] ) )

/-! ## Rotation-word remainder `‖M(eps•q) - Mfirst‖ ≤ CM q · eps²` -/

/-
`Mfirst` is exactly `1 +` the sum of the four rotation generators of `M(eps•q)`.
-/
theorem Mfirst_eq_gensum (q : Fin 3 → ℝ) (eps : ℝ) :
    Mfirst q eps =
      1 + (((gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4)) + gen 1 (eps * q 1 / 2))
        + gen 2 (eps * q 2 / 4)) := by
  unfold Mfirst gen;
  unfold Hw; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ pauli ] <;> ring;

/-
`M(k)` is unitary.
-/
theorem Mrot_mem_unitary (k : Fin 3 → ℝ) :
    Mrot k ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  exact Submonoid.mul_mem _ ( Submonoid.mul_mem _ ( Submonoid.mul_mem _ ( Rrot_mem_unitary _ _ ) ( Rrot_mem_unitary _ _ ) ) ( Rrot_mem_unitary _ _ ) ) ( Rrot_mem_unitary _ _ )

theorem norm_Mrot (k : Fin 3 → ℝ) : ‖Mrot k‖ = 1 :=
  CStarRing.norm_of_mem_unitary (Mrot_mem_unitary k)

/-
The rotation-word second-order remainder.
-/
set_option maxHeartbeats 2000000 in
theorem Mrot_sub_Mfirst_bound (q : Fin 3 → ℝ) (eps : ℝ) (heps : |eps| ≤ 1) :
    ‖Mrot (fun i => eps * q i) - Mfirst q eps‖ ≤ CM q * eps ^ 2 := by
  unfold Mrot Mfirst CM;
  -- Apply the telescoping bound three times.
  have h1 : ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4)))‖ ≤ 2 * eps ^ 2 * (qAbs q) ^ 2 + (2 * |eps| * qAbs q) * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2 := by
    refine' le_trans ( prod_sub_add _ _ _ _ _ _ _ _ _ _ _ ) _;
    exact 2 * ( eps * q 0 / 2 ) ^ 2;
    exact 2 * |eps * q 0 / 2|;
    exact 2 * |eps * q 2 / 4| + 2 * ( eps * q 2 / 4 ) ^ 2;
    exact 1;
    exact 2 * ( eps * q 2 / 4 ) ^ 2;
    any_goals positivity;
    exact Rrot_sub_gen_bound _ _;
    · exact norm_gen_le _ _;
    · exact norm_Rrot_sub_one _ _;
    · rw [ norm_Rrot ];
    · exact Rrot_sub_gen_bound _ _;
    · refine' add_le_add_three _ _ _;
      · unfold qAbs;
        nlinarith only [ show 0 ≤ eps ^ 2 * |q 0| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 1| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 2| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 1| by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 1| * |q 2| by positivity, abs_mul_abs_self ( q 0 ), abs_mul_abs_self ( q 1 ), abs_mul_abs_self ( q 2 ) ];
      · refine' mul_le_mul _ _ _ _;
        · unfold qAbs; norm_num [ abs_div, abs_mul ] ; ring_nf;
          nlinarith [ abs_nonneg ( q 0 ), abs_nonneg ( q 1 ), abs_nonneg ( q 2 ), abs_nonneg eps ];
        · refine' add_le_add _ _;
          · unfold qAbs;
            cases abs_cases eps <;> cases abs_cases ( q 2 ) <;> cases abs_cases ( eps * q 2 / 4 ) <;> nlinarith [ abs_nonneg ( q 0 ), abs_nonneg ( q 1 ), abs_nonneg ( q 2 ) ];
          · unfold qAbs;
            nlinarith only [ show 0 ≤ eps ^ 2 * |q 2| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 1| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 0| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 1| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 1| by positivity, abs_mul_abs_self ( q 2 ) ];
        · positivity;
        · exact mul_nonneg ( mul_nonneg zero_le_two ( abs_nonneg _ ) ) ( qAbs_nonneg _ );
      · unfold qAbs;
        nlinarith only [ show 0 ≤ eps ^ 2 * |q 0| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 1| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 2| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 1| by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 1| * |q 2| by positivity, abs_mul_abs_self ( q 0 ), abs_mul_abs_self ( q 1 ), abs_mul_abs_self ( q 2 ) ];
  have h2 : ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) * Rrot 1 (eps * q 1 / 2) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2)))‖ ≤ (2 * eps ^ 2 * (qAbs q) ^ 2 + (2 * |eps| * qAbs q) * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2) + (4 * |eps| * qAbs q) * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2 := by
    have h2 : ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) * Rrot 1 (eps * q 1 / 2) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2)))‖ ≤ ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4)))‖ * 1 + ‖gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4)‖ * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2 := by
      convert prod_sub_add _ _ _ _ _ _ _ _ _ _ _ using 1;
      all_goals norm_num [ norm_Rrot ];
      · refine' le_trans ( norm_Rrot_sub_one _ _ ) _;
        norm_num [ abs_div, abs_mul, qAbs ];
        nlinarith only [ show 0 ≤ |eps| * |q 1| by positivity, show 0 ≤ |eps| * |q 0| by positivity, show 0 ≤ |eps| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 0| by positivity, show 0 ≤ eps ^ 2 * |q 1| by positivity, show 0 ≤ eps ^ 2 * |q 2| by positivity, abs_mul_abs_self eps, abs_mul_abs_self ( q 0 ), abs_mul_abs_self ( q 1 ), abs_mul_abs_self ( q 2 ), abs_nonneg ( q 0 ), abs_nonneg ( q 1 ), abs_nonneg ( q 2 ) ];
      · refine' le_trans ( Rrot_sub_gen_bound _ _ ) _;
        unfold qAbs;
        nlinarith only [ show 0 ≤ eps ^ 2 * |q 1| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 0| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 2| ^ 2 by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 1| by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 1| * |q 2| by positivity, abs_mul_abs_self ( q 1 ) ];
      · exact add_nonneg ( mul_nonneg ( mul_nonneg zero_le_two ( abs_nonneg _ ) ) ( qAbs_nonneg _ ) ) ( mul_nonneg ( mul_nonneg zero_le_two ( sq_nonneg _ ) ) ( sq_nonneg _ ) );
    have h3 : ‖gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4)‖ ≤ 4 * |eps| * qAbs q := by
      refine' le_trans ( norm_add_le _ _ ) _;
      refine' le_trans ( add_le_add ( norm_gen_le _ _ ) ( norm_gen_le _ _ ) ) _;
      norm_num [ abs_div, abs_mul, qAbs ];
      nlinarith only [ abs_nonneg eps, abs_nonneg ( q 0 ), abs_nonneg ( q 1 ), abs_nonneg ( q 2 ), heps ];
    nlinarith [ show 0 ≤ |eps| * qAbs q by exact mul_nonneg ( abs_nonneg eps ) ( qAbs_nonneg q ), show 0 ≤ eps ^ 2 * qAbs q ^ 2 by positivity ];
  have h3 : ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) * Rrot 1 (eps * q 1 / 2) * Rrot 2 (eps * q 2 / 4) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2) + gen 2 (eps * q 2 / 4)))‖ ≤ (2 * eps ^ 2 * (qAbs q) ^ 2 + (2 * |eps| * qAbs q) * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2 + (4 * |eps| * qAbs q) * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2) + (6 * |eps| * qAbs q) * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2 := by
    have h3 : ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) * Rrot 1 (eps * q 1 / 2) * Rrot 2 (eps * q 2 / 4) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2) + gen 2 (eps * q 2 / 4)))‖ ≤ ‖Rrot 0 (eps * q 0 / 2) * Rrot 2 (eps * q 2 / 4) * Rrot 1 (eps * q 1 / 2) - (1 + (gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2)))‖ * 1 + ‖gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2)‖ * (2 * |eps| * qAbs q + 2 * eps ^ 2 * (qAbs q) ^ 2) + 2 * eps ^ 2 * (qAbs q) ^ 2 := by
      convert prod_sub_add _ _ _ _ _ _ _ _ _ _ _ using 1;
      all_goals norm_num;
      · refine' le_trans ( norm_Rrot_sub_one _ _ ) _;
        norm_num [ abs_div, abs_mul, qAbs ];
        nlinarith only [ show 0 ≤ |eps| * |q 2| by positivity, show 0 ≤ |eps| * |q 0| by positivity, show 0 ≤ |eps| * |q 1| by positivity, show 0 ≤ |eps| * |q 2| ^ 2 by positivity, show 0 ≤ |eps| * |q 0| ^ 2 by positivity, show 0 ≤ |eps| * |q 1| ^ 2 by positivity, abs_mul_abs_self eps, abs_mul_abs_self ( q 2 ), abs_mul_abs_self ( q 0 ), abs_mul_abs_self ( q 1 ), heps ];
      · exact le_of_eq ( norm_Rrot _ _ );
      · refine' le_trans ( Rrot_sub_gen_bound _ _ ) _;
        unfold qAbs; ring_nf; norm_num;
        nlinarith only [ show 0 ≤ eps ^ 2 * |q 0| * |q 1| by positivity, show 0 ≤ eps ^ 2 * |q 0| * |q 2| by positivity, show 0 ≤ eps ^ 2 * |q 1| * |q 2| by positivity, show 0 ≤ eps ^ 2 * q 0 ^ 2 by positivity, show 0 ≤ eps ^ 2 * q 1 ^ 2 by positivity, show 0 ≤ eps ^ 2 * q 2 ^ 2 by positivity ];
      · exact add_nonneg ( mul_nonneg ( mul_nonneg zero_le_two ( abs_nonneg _ ) ) ( qAbs_nonneg _ ) ) ( mul_nonneg ( mul_nonneg zero_le_two ( sq_nonneg _ ) ) ( sq_nonneg _ ) );
    have h4 : ‖gen 0 (eps * q 0 / 2) + gen 2 (eps * q 2 / 4) + gen 1 (eps * q 1 / 2)‖ ≤ 6 * |eps| * qAbs q := by
      refine' le_trans ( norm_add_le _ _ ) ( le_trans ( add_le_add ( norm_add_le _ _ ) le_rfl ) _ );
      refine' le_trans ( add_le_add_three ( norm_gen_le _ _ ) ( norm_gen_le _ _ ) ( norm_gen_le _ _ ) ) _;
      norm_num [ abs_div, abs_mul, qAbs ];
      nlinarith only [ abs_nonneg eps, abs_nonneg ( q 0 ), abs_nonneg ( q 1 ), abs_nonneg ( q 2 ) ];
    nlinarith [ show 0 ≤ |eps| * qAbs q by exact mul_nonneg ( abs_nonneg eps ) ( qAbs_nonneg q ), show 0 ≤ eps ^ 2 * qAbs q ^ 2 by positivity ];
  refine le_trans ?_ ( h3.trans ?_ );
  · convert le_rfl using 2 ; norm_num [ gen, Hw ] ; ring;
    ext i j ; norm_num [ pauli ] ; ring;
  · rw [ abs_eq_max_neg ] at *;
    rw [ max_def ] at * ; split_ifs at * <;> nlinarith [ show 0 ≤ qAbs q ^ 2 * eps ^ 2 by positivity, show 0 ≤ qAbs q ^ 3 * eps ^ 2 by exact mul_nonneg ( pow_nonneg ( by exact add_nonneg ( add_nonneg ( abs_nonneg _ ) ( abs_nonneg _ ) ) ( abs_nonneg _ ) ) _ ) ( sq_nonneg _ ) ]

/-! ## Endpoint one-step remainder -/

/-
`firstOrder = Mfirst² - ((i eps/2) H_W)²`.
-/
theorem firstOrder_eq_Mfirst_sq_sub (q : Fin 3 → ℝ) (eps : ℝ) :
    firstOrder q eps =
      Mfirst q eps * Mfirst q eps
        - ((I * (eps : ℂ) / 2) • Hw q) * ((I * (eps : ℂ) / 2) • Hw q) := by
  unfold firstOrder Mfirst Hw;
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, sx, sy, sz ] <;> ring

/-
Second-order bound of the exact endpoint against its first-order term.
-/
theorem Wend_sub_firstOrder_bound (q : Fin 3 → ℝ) (eps : ℝ) (heps : |eps| ≤ 1) :
    ‖Wend q eps - firstOrder q eps‖
      ≤ (CM q * (2 + qAbs q / 2) + (qAbs q) ^ 2 / 4) * eps ^ 2 := by
  -- Apply the norm_mul_le and norm_add_le lemmas to the first term.
  have h1 : ‖Wend q eps - firstOrder q eps‖ ≤ ‖Mrot (fun i => eps * q i) - Mfirst q eps‖ * (1 + ‖Mfirst q eps‖) + ‖(I * (eps : ℂ) / 2) • Hw q‖ ^ 2 := by
    -- By definition of $Wend$ and $firstOrder$, we have:
    have h_eq : Wend q eps - firstOrder q eps = (Mrot (fun i => eps * q i) - Mfirst q eps) * Mrot (fun i => eps * q i) + Mfirst q eps * (Mrot (fun i => eps * q i) - Mfirst q eps) + ((I * (eps : ℂ) / 2) • Hw q) * ((I * (eps : ℂ) / 2) • Hw q) := by
      unfold Wend firstOrder;
      unfold Mfirst; simp +decide [ sub_mul, mul_sub ] ; ring;
      rw [ HNUExactCore.endpoint_eq_Msq ] ; ext i j ; norm_num ; ring;
    rw [ h_eq ];
    refine' le_trans ( norm_add_le _ _ ) ( add_le_add ( le_trans ( norm_add_le _ _ ) _ ) _ );
    · refine' le_trans ( add_le_add ( norm_mul_le _ _ ) ( norm_mul_le _ _ ) ) _;
      rw [ norm_Mrot ] ; linarith;
    · simpa only [ sq ] using norm_mul_le _ _;
  -- Apply the norm_smul lemma to the second term.
  have h2 : ‖(I * (eps : ℂ) / 2) • Hw q‖ ≤ (|eps| / 2) * qAbs q := by
    convert norm_smul_le ( I * ( eps : ℂ ) / 2 ) ( Hw q ) |> le_trans <| mul_le_mul_of_nonneg_left ( norm_Hw_le q ) ( by positivity ) using 1 ; norm_num [ abs_div, abs_mul, abs_of_nonneg ];
  -- Apply the norm_one lemma to the third term.
  have h3 : ‖Mfirst q eps‖ ≤ 1 + (|eps| / 2) * qAbs q := by
    exact le_trans ( norm_sub_le _ _ ) ( by simpa using h2 );
  -- Apply the Mrot_sub_Mfirst_bound lemma to the first term.
  have h4 : ‖Mrot (fun i => eps * q i) - Mfirst q eps‖ ≤ CM q * eps ^ 2 := by
    exact Mrot_sub_Mfirst_bound q eps heps;
  refine le_trans h1 ?_;
  refine le_trans ( add_le_add ( mul_le_mul h4 ( add_le_add le_rfl h3 ) ( by positivity ) ( by exact mul_nonneg ( CM_nonneg q ) ( sq_nonneg _ ) ) ) ( pow_le_pow_left₀ ( by positivity ) h2 2 ) ) ?_;
  unfold CM; ring_nf; norm_num [ abs_mul, abs_div ] ;
  nlinarith only [ show 0 ≤ qAbs q ^ 2 * eps ^ 2 by positivity, show 0 ≤ qAbs q ^ 3 * eps ^ 2 by exact mul_nonneg ( pow_nonneg ( qAbs_nonneg q ) _ ) ( sq_nonneg _ ), show 0 ≤ qAbs q ^ 4 * eps ^ 2 by exact mul_nonneg ( pow_nonneg ( qAbs_nonneg q ) _ ) ( sq_nonneg _ ), abs_nonneg eps, heps, show |eps| ≤ 1 by assumption, show |eps| ^ 2 ≤ 1 by nlinarith only [ abs_nonneg eps, heps ] ]

/-
The first-order term matches the exact flow to `O(eps²)`.
-/
theorem firstOrder_sub_Eflow_bound (q : Fin 3 → ℝ) (eps : ℝ) (heps : |eps| ≤ 1) :
    ‖firstOrder q eps - Eflow q eps‖ ≤ (qAbs q) ^ 2 * Real.exp (qAbs q) * eps ^ 2 := by
  have := norm_exp_sub_one_sub_le ( ( - ( eps : ℂ ) ) • ( I • Hw q ) );
  -- Substitute the bounds for ‖A‖ and ‖A‖² into the inequality.
  have h_bounds : ‖(-eps : ℂ) • (I • Hw q)‖ ≤ qAbs q ∧ ‖(-eps : ℂ) • (I • Hw q)‖ ^ 2 ≤ (qAbs q) ^ 2 * eps ^ 2 := by
    have h_bounds : ‖(-eps : ℂ) • (I • Hw q)‖ ≤ |eps| * qAbs q := by
      convert mul_le_mul_of_nonneg_left ( norm_Hw_le q ) ( abs_nonneg eps ) using 1;
      convert norm_smul ( - ( eps : ℂ ) ) ( I • Hw q ) using 1 ; norm_num [ norm_smul ];
    exact ⟨ h_bounds.trans ( mul_le_of_le_one_left ( qAbs_nonneg q ) heps ), by nlinarith [ show 0 ≤ ‖- ( eps : ℂ ) • I • Hw q‖ by positivity, show 0 ≤ qAbs q by exact qAbs_nonneg q, show |eps| ^ 2 = eps ^ 2 by rw [ sq_abs ] ] ⟩;
  convert this.trans _ using 1;
  · rw [ ← norm_neg ] ; congr ; ext i j ; simp +decide [ firstOrder, Eflow, Hw ] ; ring;
  · refine' le_trans ( mul_le_mul_of_nonneg_right ( div_le_self ( sq_nonneg _ ) ( by norm_num ) ) ( Real.exp_nonneg _ ) ) _;
    rw [ mul_right_comm ];
    exact mul_le_mul h_bounds.2 ( Real.exp_le_exp.mpr h_bounds.1 ) ( by positivity ) ( by positivity )

/-
**One-step compact-momentum `O(eps²)` estimate** in the L2 operator norm.
-/
theorem one_step_bound (q : Fin 3 → ℝ) (eps : ℝ) (heps : |eps| ≤ 1) :
    ‖Wend q eps - Eflow q eps‖ ≤ Cbound q * eps ^ 2 := by
  convert norm_add_le ( Wend q eps - firstOrder q eps ) ( firstOrder q eps - Eflow q eps ) |> ( fun h => h.trans ?_ ) using 1;
  · rw [ sub_add_sub_cancel ];
  · convert add_le_add ( Wend_sub_firstOrder_bound q eps heps ) ( firstOrder_sub_Eflow_bound q eps heps ) using 1 ; unfold Cbound ; ring

/-! ## Unitarity and the exact-flow group law -/

theorem Wend_mem_unitary (q : Fin 3 → ℝ) (eps : ℝ) :
    Wend q eps ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  have := HNUExactCore.endpoint_unitary ( fun i => eps * q i );
  exact ⟨ this, by rw [ ← mul_eq_one_comm ] at this; exact this ⟩

theorem Eflow_mem_unitary (q : Fin 3 → ℝ) (eps : ℝ) :
    Eflow q eps ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  convert NormedSpace.exp_mem_unitary_of_mem_skewAdjoint _;
  · refine' { .. };
    intro r x; exact (by
    convert norm_smul_le ( r : ℝ ) x using 1);
  · infer_instance;
  · infer_instance;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Hw, sx, sy, sz, Matrix.mul_apply ]

/-
Exact short-time flows compose to the time-`t` flow.
-/
theorem Eflow_div_pow (q : Fin 3 → ℝ) (t : ℝ) (n : ℕ) (hn : 0 < n) :
    (Eflow q (t / (n : ℝ))) ^ n = Eflow q t := by
  unfold Eflow; simp +decide [ ← smul_assoc, hn.ne', mul_div_cancel₀ ] ;
  have h_exp_smul : ∀ (x : Mat) (n : ℕ), NormedSpace.exp (n • x) = (NormedSpace.exp x) ^ n := by
    intros x n; exact (by
    rw [ ← Matrix.exp_nsmul ]);
  convert h_exp_smul _ n |> Eq.symm using 2 ; ring;
  ext i j; norm_num [ hn.ne', mul_assoc, mul_left_comm, mul_comm ] ;

/-! ## Fixed-time many-step estimate -/

/-
**Many-step `O(1/n)` estimate**: with `eps = t/n`, the `n`-step endpoint word
converges to the exact Weyl flow at rate `Cbound q · t²/n`.
-/
theorem many_step_bound (q : Fin 3 → ℝ) (t : ℝ) (n : ℕ) (hn : 0 < n)
    (hsmall : |t / (n : ℝ)| ≤ 1) :
    ‖(Wend q (t / (n : ℝ))) ^ n - Eflow q t‖ ≤ Cbound q * t ^ 2 / n := by
  convert unitary_pow_telescope ( Wend_mem_unitary q ( t / n ) ) ( Eflow_mem_unitary q ( t / n ) ) n |> le_trans <| mul_le_mul_of_nonneg_left ( one_step_bound q ( t / n ) hsmall ) <| Nat.cast_nonneg n using 1 ; ring;
  · convert rfl using 2;
    convert congr_arg ( fun x : Mat => Wend q ( t * ( n : ℝ ) ⁻¹ ) ^ n - x ) ( Eflow_div_pow q t n hn ) using 1;
  · field_simp

/-
Compact-momentum many-step convergence as `n → ∞`.
-/
theorem many_step_tendsto (q : Fin 3 → ℝ) (t : ℝ) :
    Filter.Tendsto
      (fun n : ℕ => (Wend q (t / ((n + 1 : ℕ) : ℝ))) ^ (n + 1))
      Filter.atTop (nhds (Eflow q t)) := by
  rw [ tendsto_iff_norm_sub_tendsto_zero ];
  refine' squeeze_zero_norm' _ _;
  use fun n => Cbound q * t ^ 2 / ( n + 1 );
  · refine' Filter.eventually_atTop.mpr ⟨ ⌈|t|⌉₊, fun n hn => _ ⟩;
    convert many_step_bound q t ( n + 1 ) ( Nat.succ_pos _ ) _ using 1 <;> norm_num;
    rw [ abs_div, abs_of_nonneg ( by positivity : 0 ≤ ( n : ℝ ) + 1 ), div_le_iff₀ ] <;> cases abs_cases t <;> nlinarith [ Nat.ceil_le.mp hn ];
  · exact tendsto_const_nhds.div_atTop ( Filter.tendsto_atTop_add_const_right _ _ tendsto_natCast_atTop_atTop )

/-! ## Nonzero axis witness -/

/-
The Weyl symbol on the `q₀`-axis is `σ₁ ≠ 0`.
-/
theorem Hw_axis_witness : Hw ![1, 0, 0] = sx := by
  ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ Hw, sx ]

/-
On the `q₀`-axis the exact endpoint is a single rotation, `W(e₀, eps) = R₁(eps)`.
-/
theorem Wend_axis_witness (eps : ℝ) : Wend ![1, 0, 0] eps = Rrot 0 eps := by
  -- By definition of `Wend`, we have `Wend ![1, 0, 0] eps = endpoint (fun i => eps * ![1, 0, 0] i)`.
  have h_wend : Wend ![1, 0, 0] eps = endpoint (fun i => eps * ![1, 0, 0] i) := by
    rfl;
  rw [ h_wend, show ( fun i => eps * ![1, 0, 0] i : Fin 3 → ℝ ) = Function.update ( fun _ => 0 ) 0 eps by ext i; fin_cases i <;> simp +decide ] ; exact HNUExactCore.endpoint_along_axis 0 eps;

end

/-! ## Standard-three axiom footprint of every headline theorem -/

#print axioms one_step_bound
#print axioms Wend_sub_firstOrder_bound
#print axioms firstOrder_sub_Eflow_bound
#print axioms Mrot_sub_Mfirst_bound
#print axioms many_step_bound
#print axioms many_step_tendsto
#print axioms Wend_mem_unitary
#print axioms Eflow_mem_unitary
#print axioms Hw_axis_witness
#print axioms Wend_axis_witness

end HNUManyStepContinuum
```

## Final instruction

Produce your review now, strictly in the Required output format specified above.
```

## Response stdout

```text
Credit balance is too low

```

## Response stderr

```text

```
