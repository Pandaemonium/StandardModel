/-
# The finite matrix-grade index of the overlap / Ginsparg-Wilson Dirac operator

This file formalizes, at **finite matrix grade**, the *index* of the
overlap / Ginsparg-Wilson (GW) Dirac operator.

## Physical setting

Let `γ₅` (here written `G`) be a Hermitian involution (`Gᴴ = G`, `G * G = 1`) and let
`D` be a lattice Dirac operator satisfying the (unit-lattice-spacing) Ginsparg-Wilson
relation
$$ γ₅ D + D γ₅ = D γ₅ D . $$
The overlap Dirac operator is in addition `γ₅`-Hermitian, `Dᴴ = γ₅ D γ₅`.

The topological *index* is `Tr (γ₅ (1 - D/2))`, or equivalently the difference
`n₊ - n₋` of the numbers of zero modes of `D` of definite chirality.

## What is proved here (honest scope)

This is a purely **finite-dimensional matrix** statement over `ℂ`; it is *not* the
continuum Atiyah-Singer index theorem. We work with `n × n` complex matrices.

* `trace_int_of_involution` : the trace of *any* matrix `P` with `P * P = 1` is an
  integer.  (It is `+1`/`-1` on its eigenspaces; concretely `Tr P = 2·rank Q - n` where
  `Q = (1+P)/2` is an idempotent, and the trace of an idempotent is the natural-number
  `finrank` of its range.)
* `chirality_involution` / `chirality_hermitian` : the *modified chirality*
  `γ̂₅ := γ₅ (1 - D)` is again a Hermitian involution — this is exactly where the GW
  relation is used.
* `index_integer` / `indexTr_integer` : both `Tr (γ₅ (1 - D/2))` and `½ Tr (γ₅ D)` are
  integer-valued.
* `index_eq_half_sum`, `indexTr_eq_half_diff`, `index_add_indexTr` : the trace formulas
  tying the index to the two Hermitian involutions `γ₅` and `γ̂₅`.
* `zero_mode_chirality_invariant` : the GW relation forces the space of zero modes of `D`
  to be `γ₅`-invariant — the "definite chirality" structure of the index theorem.
* `Example` : an explicit `2 × 2` GW system with **nonzero** index.

## Sign convention

We take the *primary* index to be `index = Tr (γ₅ (1 - D/2))` (the first expression in
the physics statement).  When `γ₅` is traceless this equals `-½ Tr (γ₅ D)`, i.e. it is the
*negative* of the second expression `indexTr = ½ Tr (γ₅ D)`; we keep both and record the
exact relation in `index_add_indexTr`.  In the worked example `index = 1 = n₊ - n₋` while
`indexTr = -1`.
-/
import Mathlib

open scoped BigOperators
open Matrix

namespace PhysicsSM.Draft.NullEdge.GateYM.OverlapIndex

/-! ## Integrality of traces of involutions -/

/-- The trace of an idempotent complex matrix is a (cast of a) natural number: it equals
the `finrank` of the range of the associated projection.  This is the algebraic core of
integrality of the index. -/
theorem trace_int_of_idempotent {n : ℕ} (E : Matrix (Fin n) (Fin n) ℂ) (h : E * E = E) :
    ∃ k : ℤ, E.trace = (k : ℂ) := by
  have hidem : IsIdempotentElem (toLin' E) := by
    have : toLin' E ∘ₗ toLin' E = toLin' E := by rw [← toLin'_mul, h]
    exact this
  have hproj : LinearMap.IsProj (toLin' E).range (toLin' E) :=
    (LinearMap.isProj_range_iff_isIdempotentElem _).2 hidem
  have htr := hproj.trace
  rw [trace_toLin'_eq] at htr
  exact ⟨(Module.finrank ℂ (toLin' E).range : ℤ), by rw [htr]; push_cast; ring⟩

/-- Precise integrality of the trace of an involution `P` (`P * P = 1`): there is an
integer `k` with `Tr P = 2·k - n`.  Here `k = rank ((1+P)/2)` is the dimension of the
`+1`-eigenspace, and `n - k` the dimension of the `-1`-eigenspace, so `Tr P = k - (n-k)`
is the signed count of eigenvalues `±1`. -/
theorem trace_involution_form {n : ℕ} (P : Matrix (Fin n) (Fin n) ℂ) (h : P * P = 1) :
    ∃ k : ℤ, P.trace = 2 * (k : ℂ) - (n : ℂ) := by
  set Q : Matrix (Fin n) (Fin n) ℂ := (1 / 2 : ℂ) • (1 + P) with hQ
  have hidem : Q * Q = Q := by
    have e1 : (1 + P) * (1 + P) = (2 : ℂ) • (1 + P) := by
      rw [Matrix.add_mul, Matrix.mul_add, Matrix.mul_add, Matrix.one_mul, Matrix.mul_one, h,
        two_smul]
      noncomm_ring
    rw [hQ, Matrix.smul_mul, Matrix.mul_smul, e1, smul_smul, smul_smul]
    norm_num
  obtain ⟨k, hk⟩ := trace_int_of_idempotent Q hidem
  refine ⟨k, ?_⟩
  have htr : Q.trace = (1 / 2 : ℂ) * ((n : ℂ) + P.trace) := by
    rw [hQ, Matrix.trace_smul, Matrix.trace_add, Matrix.trace_one]
    simp [Fintype.card_fin]
  rw [htr] at hk
  linear_combination 2 * hk

/-- The trace of an involution is an integer (existence form). -/
theorem trace_int_of_involution {n : ℕ} (P : Matrix (Fin n) (Fin n) ℂ) (h : P * P = 1) :
    ∃ k : ℤ, P.trace = (k : ℂ) := by
  obtain ⟨k, hk⟩ := trace_involution_form P h
  exact ⟨2 * k - n, by rw [hk]; push_cast; ring⟩

/-! ## The overlap / Ginsparg-Wilson structure -/

variable {n : ℕ} (G D : Matrix (Fin n) (Fin n) ℂ)

/-- `γ₅` is a *Hermitian involution*. -/
def IsHermInvol (G : Matrix (Fin n) (Fin n) ℂ) : Prop := Gᴴ = G ∧ G * G = 1

/-- The Ginsparg-Wilson relation `{γ₅, D} = D γ₅ D` (unit lattice spacing). -/
def GinspargWilson (G D : Matrix (Fin n) (Fin n) ℂ) : Prop := G * D + D * G = D * G * D

/-- `γ₅`-Hermiticity of the overlap operator: `Dᴴ = γ₅ D γ₅`. -/
def GammaHermitian (G D : Matrix (Fin n) (Fin n) ℂ) : Prop := Dᴴ = G * D * G

/-- The modified chirality operator `γ̂₅ := γ₅ (1 - D)`. -/
noncomputable def chirality (G D : Matrix (Fin n) (Fin n) ℂ) : Matrix (Fin n) (Fin n) ℂ := G * (1 - D)

/-- The primary index `Tr (γ₅ (1 - D/2))`. -/
noncomputable def index (G D : Matrix (Fin n) (Fin n) ℂ) : ℂ := (G * (1 - (1 / 2 : ℂ) • D)).trace

/-- The second index expression `½ Tr (γ₅ D)`. -/
noncomputable def indexTr (G D : Matrix (Fin n) (Fin n) ℂ) : ℂ := (1 / 2 : ℂ) * (G * D).trace

/-! ### The modified chirality is a Hermitian involution

This is the algebraic heart of the finite index theorem: the Ginsparg-Wilson relation is
*exactly* what makes `γ̂₅ = γ₅(1-D)` square to the identity. -/

/-- **Ginsparg-Wilson ⇒ `γ̂₅² = 1`.**  Uses only `G * G = 1` and the GW relation. -/
theorem chirality_involution (hG : G * G = 1) (hGW : GinspargWilson G D) :
    chirality G D * chirality G D = 1 := by
  unfold chirality GinspargWilson at *
  have expand : (G * (1 - D)) * (G * (1 - D)) = G * (G - (G * D + D * G) + D * G * D) := by
    noncomm_ring
  rw [expand, ← hGW]
  have : G - (G * D + D * G) + (G * D + D * G) = G := by noncomm_ring
  rw [this, hG]

/-- **`γ₅`-Hermiticity ⇒ `γ̂₅` is Hermitian.** -/
theorem chirality_hermitian (hGh : Gᴴ = G) (hG : G * G = 1) (hDH : GammaHermitian G D) :
    (chirality G D)ᴴ = chirality G D := by
  unfold chirality GammaHermitian at *
  rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_sub, Matrix.conjTranspose_one, hGh, hDH,
    Matrix.mul_sub, Matrix.sub_mul]
  simp only [Matrix.one_mul, Matrix.mul_one]
  rw [show G * D * G * G = G * D * (G * G) by noncomm_ring, hG]
  noncomm_ring

/-- The modified chirality is a Hermitian involution. -/
theorem chirality_isHermInvol (hG : IsHermInvol G) (hGW : GinspargWilson G D)
    (hDH : GammaHermitian G D) : IsHermInvol (chirality G D) :=
  ⟨chirality_hermitian G D hG.1 hG.2 hDH, chirality_involution G D hG.2 hGW⟩

/-! ### Trace formulas -/

/-- `Tr (γ₅ D) = Tr γ₅ - Tr γ̂₅`. -/
theorem trace_GD_eq : (G * D).trace = G.trace - (chirality G D).trace := by
  unfold chirality
  rw [Matrix.mul_sub, Matrix.mul_one, Matrix.trace_sub]; ring

/-- `index = ½ (Tr γ₅ + Tr γ̂₅)`. -/
theorem index_eq_half_sum :
    index G D = (1 / 2 : ℂ) * (G.trace + (chirality G D).trace) := by
  have h1 : index G D = G.trace - (1 / 2 : ℂ) * (G * D).trace := by
    unfold index
    rw [Matrix.mul_sub, Matrix.mul_one, Matrix.mul_smul, Matrix.trace_sub, Matrix.trace_smul,
      smul_eq_mul]
  rw [h1, trace_GD_eq]; ring

/-- `indexTr = ½ (Tr γ₅ - Tr γ̂₅)`. -/
theorem indexTr_eq_half_diff :
    indexTr G D = (1 / 2 : ℂ) * (G.trace - (chirality G D).trace) := by
  unfold indexTr
  rw [trace_GD_eq]

/-- The two index conventions add up to the trace of `γ₅` (equal and opposite when
`γ₅` is traceless): `index + indexTr = Tr γ₅`. -/
theorem index_add_indexTr : index G D + indexTr G D = G.trace := by
  rw [index_eq_half_sum, indexTr_eq_half_diff]; ring

/-! ### Integrality of the index -/

/-- **The index is an integer.**  It equals `½(Tr γ₅ + Tr γ̂₅)`, a half-sum of the traces
of two Hermitian involutions; both traces have the same parity as `n`, so the half-sum is
an integer. -/
theorem index_integer (hG : G * G = 1) (hGW : GinspargWilson G D) :
    ∃ k : ℤ, index G D = (k : ℂ) := by
  obtain ⟨a, ha⟩ := trace_involution_form G hG
  obtain ⟨b, hb⟩ := trace_involution_form (chirality G D) (chirality_involution G D hG hGW)
  refine ⟨a + b - n, ?_⟩
  rw [index_eq_half_sum, ha, hb]; push_cast; ring

/-- **`½ Tr (γ₅ D)` is integer-valued** (invariant, in the sense of being a fixed
integer determined by the chiral zero-mode counts). -/
theorem indexTr_integer (hG : G * G = 1) (hGW : GinspargWilson G D) :
    ∃ k : ℤ, indexTr G D = (k : ℂ) := by
  obtain ⟨a, ha⟩ := trace_involution_form G hG
  obtain ⟨b, hb⟩ := trace_involution_form (chirality G D) (chirality_involution G D hG hGW)
  refine ⟨a - b, ?_⟩
  rw [indexTr_eq_half_diff, ha, hb]; push_cast; ring

/-! ### The exact index-theorem structure: zero modes have definite chirality

The Ginsparg-Wilson relation forces the space of zero modes of `D` to be invariant under
`γ₅`.  Since `γ₅` is an involution, that kernel splits into `±1`-eigenspaces, so the zero
modes can be organized by definite chirality — the content of `n₊ - n₋`. -/

/-- **GW ⇒ the kernel of `D` is `γ₅`-invariant.**  If `D v = 0` then `D (γ₅ v) = 0`, so
`γ₅` maps zero modes to zero modes.  Combined with `γ₅² = 1` this splits the zero modes
into definite-chirality subspaces. -/
theorem zero_mode_chirality_invariant (hGW : GinspargWilson G D) (v : Fin n → ℂ)
    (hv : D.mulVec v = 0) : D.mulVec (G.mulVec v) = 0 := by
  unfold GinspargWilson at hGW
  have key : (G * D + D * G).mulVec v = (D * G * D).mulVec v := by rw [hGW]
  rw [Matrix.add_mulVec, ← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec,
    ← Matrix.mulVec_mulVec, hv, Matrix.mulVec_zero, Matrix.mulVec_zero, zero_add] at key
  exact key

/-! ## A concrete `2 × 2` example with nonzero index

Take `γ₅ = diag(1, -1)` (Pauli `σ₃`) and `D = 1 - γ₅ = diag(0, 2)`.  Then all hypotheses
hold, `D` has a single zero mode `(1,0)` of chirality `+1`, none of chirality `-1`, and
`index = 1 = n₊ - n₋` (while `indexTr = -1`). -/

namespace Example

/-- `γ₅ = diag(1, -1)`. -/
noncomputable def Gex : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- `D = 1 - γ₅ = diag(0, 2)`. -/
noncomputable def Dex : Matrix (Fin 2) (Fin 2) ℂ := !![0, 0; 0, 2]

theorem Gex_involution : Gex * Gex = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Gex, Matrix.mul_apply, Fin.sum_univ_two]

theorem Gex_hermitian : Gexᴴ = Gex := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Gex, Matrix.conjTranspose_apply]

theorem Gex_isHermInvol : IsHermInvol Gex := ⟨Gex_hermitian, Gex_involution⟩

theorem Dex_gammaHermitian : GammaHermitian Gex Dex := by
  unfold GammaHermitian
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Gex, Dex, Matrix.conjTranspose_apply, Matrix.mul_apply, Fin.sum_univ_two]

theorem Dex_GW : GinspargWilson Gex Dex := by
  unfold GinspargWilson
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Gex, Dex, Matrix.mul_apply, Fin.sum_univ_two]
  ring

/-- The index of this example is `1` — nonzero. -/
theorem index_eq_one : index Gex Dex = 1 := by
  unfold index
  rw [Matrix.trace_fin_two]
  simp only [Gex, Dex, Matrix.mul_apply, Fin.sum_univ_two, Matrix.sub_apply, Matrix.smul_apply,
    Matrix.one_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.of_apply]
  norm_num

/-- The alternative index expression `½ Tr (γ₅ D)` here equals `-1`. -/
theorem indexTr_eq_neg_one : indexTr Gex Dex = -1 := by
  unfold indexTr
  rw [Matrix.trace_fin_two]
  simp only [Gex, Dex, Matrix.mul_apply, Fin.sum_univ_two, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.of_apply]
  norm_num

/-- Sanity check: the two conventions add up to `Tr γ₅ = 0`. -/
theorem index_add_indexTr_eq_zero : index Gex Dex + indexTr Gex Dex = 0 := by
  rw [index_eq_one, indexTr_eq_neg_one]; ring

end Example

end PhysicsSM.Draft.NullEdge.GateYM.OverlapIndex
