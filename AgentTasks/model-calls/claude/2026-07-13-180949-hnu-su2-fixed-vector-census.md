# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-13T18:09:41`
- Finished: `2026-07-13T18:09:49`
- Timeout seconds: `240`
- Max budget USD: `2.00`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 2.00 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
You are the independent Skeptic for AFPL. Review the proposed Lean module HNUSU2FixedVectorCensus.lean against the verbatim live HNUExactCore.lean source.\n\nIntended reading: this is only an exact finite refinement of the HNU zero-quasienergy census. It should prove that a 2x2 complex unitary with determinant one and a genuine nonzero +1 eigenvector is the identity, then compose that result with the existing endpoint matrix-equality census to characterize nonzero +1 eigenvectors on the closed Brillouin cube. It must not imply winding, chirality, a real-space QCA, primitive-null support, or bulk-edge correspondence.\n\nAudit:\n1. Check statement semantics and all hypotheses, especially whether determinant-one is load-bearing and whether Matrix.exists_mulVec_eq_zero_iff is used in the correct direction.\n2. Check the endpoint iff and explicit origin/non-origin witnesses for vacuity, hidden assumptions, and convention drift.\n3. Apply the four over-claim tests: vacuity, hollow telescoping, docstring outruns kernel, false shape.\n4. Confirm standard-three guards and no trust expansion.\n5. Return APPROVE, REVISE, or REJECT, with exact required changes. Distinguish whether this is a useful strengthening or merely a definitional restatement.\nDo not edit files.

## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/HNUSU2FixedVectorCensus.lean (125 lines)

```lean
import PhysicsSM.Draft.NullEdge.HNUExactCore

/-!
# SU(2) fixed-vector rigidity and the HNU zero-quasienergy census

This module upgrades `HNUExactCore.zero_census` from an endpoint matrix
equality to a statement about a genuine nonzero `+1` eigenvector. The key
finite-dimensional lemma says that a `2 x 2` complex unitary matrix of
determinant one that fixes a nonzero vector must be the identity.

Provenance: clean-room Aristotle formalization from project
`c626cb61-f1db-49ff-aa41-a9d96e9152ad`, task
`29712ef5-7778-455e-b9b8-416d9ec25ac7`, composed with the independently
reviewed HNU endpoint in `HNUExactCore`.

Scope: this is an exact finite fixed-vector census. It does not prove winding,
chirality, real-space locality, primitive-null support, or bulk-edge
correspondence.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.HNUExactCore

noncomputable section

/-! ## SU(2) fixed-vector rigidity -/

/-- For a `2 x 2` matrix, `det (M - 1) = det M - tr M + 1`. -/
lemma det_sub_one_fin_two (M : M2) : (M - 1).det = M.det - M.trace + 1 := by
  simp [Matrix.det_fin_two, Matrix.trace_fin_two, Matrix.sub_apply]
  ring

/-- A `2 x 2` complex unitary matrix of determinant one that fixes a nonzero
vector is the identity. -/
theorem su2_fixed_vector_eq_one {M : M2} (hU : M ∈ unitary M2) (hdet : M.det = 1)
    (hv : ∃ v : Fin 2 → ℂ, v ≠ 0 ∧ M *ᵥ v = v) : M = 1 := by
  obtain ⟨v, hv0, hvfix⟩ := hv
  have hker : (M - 1) *ᵥ v = 0 := by
    rw [sub_mulVec, one_mulVec, hvfix, sub_self]
  have hdz : (M - 1).det = 0 :=
    Matrix.exists_mulVec_eq_zero_iff.mp ⟨v, hv0, hker⟩
  have htr : M.trace = 2 := by
    rw [det_sub_one_fin_two, hdet] at hdz
    linear_combination -hdz
  exact su2_trace_two hU htr

/-- A determinant-one unitary matrix other than the identity has no nonzero
`+1` eigenvector. -/
theorem su2_ne_one_no_fixed_vector {M : M2} (hU : M ∈ unitary M2)
    (hdet : M.det = 1) (hne : M ≠ 1) :
    ¬ ∃ v : Fin 2 → ℂ, v ≠ 0 ∧ M *ᵥ v = v :=
  fun hv => hne (su2_fixed_vector_eq_one hU hdet hv)

/-! ## HNU endpoint fixed-vector census -/

/-- The first standard basis vector is nonzero. -/
lemma e0_ne_zero : (![1, 0] : Fin 2 → ℂ) ≠ 0 := by
  intro h
  simpa using congrFun h 0

/-- On the closed Brillouin cube, the exact HNU endpoint has a nonzero `+1`
eigenvector exactly at the origin. -/
theorem endpoint_fixed_vector_iff (k : Fin 3 → ℝ)
    (hk : ∀ i, k i ∈ Set.Icc (-Real.pi) Real.pi) :
    (∃ v : Fin 2 → ℂ, v ≠ 0 ∧ endpoint k *ᵥ v = v) ↔ ∀ i, k i = 0 := by
  constructor
  · intro hv
    exact (zero_census k hk).mp
      (su2_fixed_vector_eq_one (endpoint_unitary k) (endpoint_det k) hv)
  · intro h
    refine ⟨![1, 0], e0_ne_zero, ?_⟩
    rw [(zero_census k hk).mpr h, one_mulVec]

/-- Contrapositive form of the fixed-vector census. -/
theorem endpoint_no_fixed_vector_iff_ne_zero (k : Fin 3 → ℝ)
    (hk : ∀ i, k i ∈ Set.Icc (-Real.pi) Real.pi) :
    (¬ ∃ v : Fin 2 → ℂ, v ≠ 0 ∧ endpoint k *ᵥ v = v) ↔ ∃ i, k i ≠ 0 := by
  rw [endpoint_fixed_vector_iff k hk]
  push_neg
  rfl

/-- Explicit nonzero fixed vector at the origin. -/
theorem endpoint_origin_fixed_vector :
    (![1, 0] : Fin 2 → ℂ) ≠ 0 ∧ endpoint ![0, 0, 0] *ᵥ ![1, 0] = ![1, 0] := by
  refine ⟨e0_ne_zero, ?_⟩
  rw [witness_zero, one_mulVec]

/-- Explicit non-origin control with no nonzero `+1` eigenvector. -/
theorem endpoint_nonorigin_no_fixed_vector :
    ¬ ∃ v : Fin 2 → ℂ, v ≠ 0 ∧ endpoint ![Real.pi / 2, 0, 0] *ᵥ v = v := by
  intro hv
  exact witness_zero_unique
    (su2_fixed_vector_eq_one (endpoint_unitary _) (endpoint_det _) hv)

end

end PhysicsSM.Draft.NullEdge.HNUExactCore

/-! ## Build-enforced standard-three axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.su2_fixed_vector_eq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.su2_fixed_vector_eq_one

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.su2_ne_one_no_fixed_vector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.su2_ne_one_no_fixed_vector

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_fixed_vector_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_fixed_vector_iff

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_no_fixed_vector_iff_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_no_fixed_vector_iff_ne_zero

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_origin_fixed_vector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_origin_fixed_vector

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_nonorigin_no_fixed_vector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_nonorigin_no_fixed_vector

```

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
