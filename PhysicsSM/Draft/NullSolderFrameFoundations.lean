import Mathlib

/-!
# NullSolderFrame foundations: B0 → B1 → B3 → B2

Aristotle draft deliverable for the null-edge **Gate B** finite-core ordering
`B0 → B1 → B3 → B2` (see `PROMPT.md`,
`AgentTasks/null-edge-job-dependency-dag.md`,
`AgentTasks/null-edge-conventions-integration-audit.md`, `docs/CONVENTIONS.md`,
and `docs/NULLSTRAND.md`).

This is **finite linear algebra**.  It does *not* claim a continuum limit, and it
does *not* derive four spacetime dimensions: the tetrahedral frame is exactly the
`d = 4` case of a simplex family that exists for every `d ≥ 2` (Guardrails in
`PROMPT.md`).

## Conventions (locked, from `docs/CONVENTIONS.md` / `docs/NULLSTRAND.md`)

* Mostly-minus Lorentzian signature; null edge vectors satisfy `g(ℓ_a, ℓ_a) = 0`.
* **Dual-soldered architecture**: the Clifford symbol is soldered to the dual
  covectors `α^a`, *not* to the diagonal flats `ℓ_a^♭`.  The diagonal
  architecture `∑_a c(ℓ_a^♭) ∇_{ℓ_a}` is rejected; B2 below is the precise
  trace obstruction that rejects it.
* Simplex normalization: in `d = n` dimensions the spatial simplex vertices
  `n_A` satisfy `n_A · n_A = 1`, `n_A · n_B = -1/(d-1)` (`A ≠ B`), and
  `ℓ_A = (1, n_A)`, giving the null/off-diagonal Gram entries
  `g(ℓ_A, ℓ_A) = 0`, `g(ℓ_A, ℓ_B) = d/(d-1)` (`A ≠ B`).

## Contents

### B0 — `NullSolderFrame` data package
`NullSolderFrame` bundles the null edge basis `ℓ_a`, the dual covectors
`α^a := (ℓ_a).dualBasis`, the Gram form `g`, and the inverse-Gram matrix together
with the inverse identity `∑_b g_{ab} G^{bc} = δ_a^c`.  We provide:
* `NullSolderFrame.alpha_apply_ell` — duality `α^a(ℓ_b) = δ^a_b`;
* `NullSolderFrame.reconstruction` — the reconstruction identity
  `ξ = ∑_a ξ(ℓ_a) · α^a`;
* `NullSolderFrame.gram_invGram` — the inverse-Gram identity restated on `gram`;
* `NullSolderFrame.cliffordCoeff` — the Clifford coefficient placeholder
  `C_a = c(α^a)` for an abstract symbol map `c`.

### B1 — simplex / tetrahedral null-solder frame (general `d = n`)
`simplexGram`/`simplexInvGram` are the general-dimension simplex Gram and
inverse-Gram matrices, and `simplexFrame` realizes the data package over
`Fin n → ℝ` (the `d = 4` case is the tetrahedral frame).  `simplexGram_diag`
records nullity `g(ℓ_a, ℓ_a) = 0` and `simplexGram_offDiag` the off-diagonal
value `d/(d-1)`.

### B3 — explicit tetrahedral inverse-Gram
`simplex_gram_mul_invGram` proves `G · G⁻¹ = I` in general dimension, and
`tetra_inverse_gram` / `tetra_gram_mul_inv` give the requested explicit
tetrahedral form `G⁻¹ = -3/4 · I + 1/4 · J`.

### B2 — diagonal trace obstruction
`diagOp` is the diagonal soldering endomorphism `v ↦ ∑_a b_a · g(ℓ_a, v) · ℓ_a`
(i.e. `∑_a b_a · ℓ_a^♭ ⊗ ℓ_a`).  `diagOp_trace` computes its trace as
`∑_a b_a · g(ℓ_a, ℓ_a)`, so on a null frame the trace vanishes
(`diagOp_trace_eq_zero_of_null`); but the cotangent identity has trace
`d = n > 0`, hence `diag_soldering_ne_id`: **no** choice of diagonal coefficients
reproduces the identity.  This is why `∑_a c(ℓ_a^♭) ∇_{ℓ_a}` is not the active
Dirac symbol.
-/

namespace PhysicsSM
namespace Draft

open Module
open scoped BigOperators

/-! ## B0 — the `NullSolderFrame` data package -/

/-- **B0: a dual-soldered null-solder frame.**

`ell` is the basis of null edge directions `ℓ_a`; `g` is the (symmetric) Gram
form; `invGram` is the inverse-Gram matrix `G^{ab}`, characterised by the
inverse identity `gram_inv`: `∑_b g(ℓ_a, ℓ_b) · G^{bc} = δ_a^c`.

The dual covectors `α^a` are derived as `ell.dualBasis` (so `α^a(ℓ_b) = δ^a_b`
holds by construction), and the Clifford coefficients are the placeholders
`C_a = c(α^a)`. -/
structure NullSolderFrame (V : Type*) [AddCommGroup V] [Module ℝ V] (n : ℕ) where
  /-- The basis of primitive null edge directions `ℓ_a`. -/
  ell : Basis (Fin n) ℝ V
  /-- The Gram form `g`. -/
  g : V →ₗ[ℝ] V →ₗ[ℝ] ℝ
  /-- `g` is symmetric. -/
  g_symm : ∀ u v, g u v = g v u
  /-- The inverse-Gram matrix `G^{ab}`. -/
  invGram : Matrix (Fin n) (Fin n) ℝ
  /-- The inverse-Gram identity `∑_b g(ℓ_a, ℓ_b) · G^{bc} = δ_a^c`. -/
  gram_inv : ∀ a c, (∑ b, g (ell a) (ell b) * invGram b c) = if a = c then (1 : ℝ) else 0

namespace NullSolderFrame

variable {V : Type*} [AddCommGroup V] [Module ℝ V] {n : ℕ}

/-- The dual covectors `α^a := (ℓ_a).dualBasis`. -/
noncomputable def alpha (F : NullSolderFrame V n) : Fin n → Module.Dual ℝ V := F.ell.dualBasis

/-- The Gram matrix entries `g_{ab} = g(ℓ_a, ℓ_b)`. -/
noncomputable def gram (F : NullSolderFrame V n) (a b : Fin n) : ℝ := F.g (F.ell a) (F.ell b)

/-- **Duality** `α^a(ℓ_b) = δ^a_b`. -/
theorem alpha_apply_ell (F : NullSolderFrame V n) (a b : Fin n) :
    F.alpha a (F.ell b) = if a = b then (1 : ℝ) else 0 := by
  rw [alpha, Basis.dualBasis_apply_self]
  by_cases h : a = b
  · simp [h]
  · simp only [h, if_false]
    rw [if_neg (fun hba => h hba.symm)]

/-- **B0 reconstruction identity** `ξ = ∑_a ξ(ℓ_a) · α^a`. -/
theorem reconstruction (F : NullSolderFrame V n) (ξ : Module.Dual ℝ V) :
    ξ = ∑ a, ξ (F.ell a) • F.alpha a := by
  conv_lhs => rw [← F.ell.dualBasis.sum_repr ξ]
  refine Finset.sum_congr rfl fun a _ => ?_
  rw [Basis.dualBasis_repr]; rfl

/-- The inverse-Gram identity restated on `gram`: `∑_b g_{ab} G^{bc} = δ_a^c`. -/
theorem gram_invGram (F : NullSolderFrame V n) (a c : Fin n) :
    (∑ b, F.gram a b * F.invGram b c) = if a = c then (1 : ℝ) else 0 :=
  F.gram_inv a c

/-- **Clifford coefficient placeholder** `C_a = c(α^a)` for an abstract symbol
map `c : Module.Dual ℝ V →ₗ[ℝ] A` into a Clifford-like algebra `A`. -/
noncomputable def cliffordCoeff {A : Type*} [AddCommGroup A] [Module ℝ A]
    (F : NullSolderFrame V n) (c : Module.Dual ℝ V →ₗ[ℝ] A) (a : Fin n) : A :=
  c (F.alpha a)

end NullSolderFrame

/-! ## B1 / B3 — simplex Gram, inverse-Gram, and the tetrahedral case -/

/-- The all-ones matrix `J`. -/
def allOnes (n : ℕ) : Matrix (Fin n) (Fin n) ℝ := fun _ _ => 1

/-- **B1: the simplex Gram matrix** `G = (d/(d-1)) · (J - I)` in dimension
`d = n`.  Diagonal entries are `0` (null edges); off-diagonal entries are
`d/(d-1)`. -/
noncomputable def simplexGram (n : ℕ) : Matrix (Fin n) (Fin n) ℝ :=
  ((n : ℝ) / (n - 1)) • (allOnes n - 1)

/-- **B3: the simplex inverse-Gram matrix** `G⁻¹ = -((d-1)/d) · I + (1/d) · J`. -/
noncomputable def simplexInvGram (n : ℕ) : Matrix (Fin n) (Fin n) ℝ :=
  (-((n : ℝ) - 1) / n) • (1 : Matrix (Fin n) (Fin n) ℝ) + ((1 : ℝ) / n) • allOnes n

/-- Diagonal entries of the simplex Gram matrix vanish: the edges are null. -/
theorem simplexGram_diag (n : ℕ) (a : Fin n) : simplexGram n a a = 0 := by
  simp [simplexGram, allOnes, Matrix.sub_apply]

/-- Off-diagonal entries of the simplex Gram matrix are `d/(d-1)`. -/
theorem simplexGram_offDiag (n : ℕ) {a b : Fin n} (h : a ≠ b) :
    simplexGram n a b = (n : ℝ) / (n - 1) := by
  simp [simplexGram, allOnes, Matrix.sub_apply, h]

/-
**B3, general dimension**: the simplex Gram and inverse-Gram matrices are
mutually inverse, `G · G⁻¹ = I`, for every `d = n ≥ 2`.
-/
theorem simplex_gram_mul_invGram (n : ℕ) (hn : 2 ≤ n) :
    simplexGram n * simplexInvGram n = 1 := by
  unfold simplexGram simplexInvGram;
  ext i j; norm_num [ Matrix.mul_apply, Matrix.smul_apply ] ; ring;
  simp +decide [ Finset.sum_add_distrib, Matrix.one_apply, allOnes ] ; ring;
  split_ifs <;> simp +decide [ *, sq, mul_assoc, mul_comm, ne_of_gt ( zero_lt_two.trans_le hn ) ];
  linarith [ inv_mul_cancel₀ ( by linarith [ show ( n : ℝ ) ≥ 2 by norm_cast ] : ( -1 + n : ℝ ) ≠ 0 ) ]

/-- **B3, tetrahedral case (`d = 4`)**: the explicit inverse-Gram form
`G⁻¹ = -3/4 · I + 1/4 · J`. -/
theorem tetra_inverse_gram :
    simplexInvGram 4 = (-3 / 4 : ℝ) • (1 : Matrix (Fin 4) (Fin 4) ℝ)
      + (1 / 4 : ℝ) • allOnes 4 := by
  unfold simplexInvGram
  norm_num

/-- **B3, tetrahedral case (`d = 4`)**: the tetrahedral Gram matrix times the
explicit inverse-Gram `-3/4 · I + 1/4 · J` is the identity. -/
theorem tetra_gram_mul_inv :
    simplexGram 4 * ((-3 / 4 : ℝ) • (1 : Matrix (Fin 4) (Fin 4) ℝ)
      + (1 / 4 : ℝ) • allOnes 4) = 1 := by
  rw [← tetra_inverse_gram]; exact simplex_gram_mul_invGram 4 (by norm_num)

/-- The simplex Gram matrix is symmetric. -/
theorem simplexGram_symm (n : ℕ) (a b : Fin n) : simplexGram n a b = simplexGram n b a := by
  simp only [simplexGram, allOnes, Matrix.smul_apply, Matrix.sub_apply, Matrix.one_apply,
    smul_eq_mul]
  by_cases h : a = b <;> simp [h, eq_comm]

/-
The bilinear form induced by the (symmetric) simplex Gram matrix is
symmetric.
-/
theorem simplexGram_toLinearMap₂'_symm (n : ℕ) (u v : Fin n → ℝ) :
    (Matrix.toLinearMap₂' ℝ (simplexGram n)) u v
      = (Matrix.toLinearMap₂' ℝ (simplexGram n)) v u := by
  have h_symm : (simplexGram n).IsSymm := by
    exact Matrix.ext fun i j => by simp +decide [ simplexGram_symm ] ;
  convert Matrix.dotProduct_mulVec ( u ) ( simplexGram n ) ( v ) using 1;
  · convert Matrix.toLinearMap₂'_apply' _ _ _;
  · convert Matrix.dotProduct_mulVec ( v ) ( simplexGram n ) ( u ) using 1;
    · convert Matrix.toLinearMap₂'_apply' ( simplexGram n ) v u using 1;
    · simp +decide [ Matrix.vecMul, dotProduct, mul_comm ];
      simp +decide only [Finset.mul_sum _ _ _, mul_left_comm];
      exact Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by rw [ h_symm.apply ] )

/-
The inverse-Gram identity for the standard-basis simplex frame:
`∑_b g(e_a, e_b) · G⁻¹_{bc} = δ_{ac}`.
-/
theorem simplexFrame_gram_inv (n : ℕ) (hn : 2 ≤ n) (a c : Fin n) :
    (∑ b, (Matrix.toLinearMap₂' ℝ (simplexGram n))
        (Pi.basisFun ℝ (Fin n) a) (Pi.basisFun ℝ (Fin n) b) * simplexInvGram n b c)
      = if a = c then (1 : ℝ) else 0 := by
  convert congr_fun ( congr_fun ( simplex_gram_mul_invGram n hn ) a ) c using 1;
  simp +decide [ Matrix.mul_apply, Matrix.toLinearMap₂'_apply' ]

/-- **B1: the simplex / tetrahedral null-solder frame** realized over `Fin n → ℝ`
(the `d = 4` case is the tetrahedral frame).  The edge basis is the standard
basis, the Gram form is induced by `simplexGram n`, and the inverse-Gram data is
`simplexInvGram n`. -/
noncomputable def simplexFrame (n : ℕ) (hn : 2 ≤ n) : NullSolderFrame (Fin n → ℝ) n where
  ell := Pi.basisFun ℝ (Fin n)
  g := Matrix.toLinearMap₂' ℝ (simplexGram n)
  g_symm := simplexGram_toLinearMap₂'_symm n
  invGram := simplexInvGram n
  gram_inv := simplexFrame_gram_inv n hn

/-- The simplex frame is null: each edge satisfies `g(ℓ_a, ℓ_a) = 0`. -/
theorem simplexFrame_null (n : ℕ) (hn : 2 ≤ n) (a : Fin n) :
    (simplexFrame n hn).g ((simplexFrame n hn).ell a) ((simplexFrame n hn).ell a) = 0 := by
  have h : (simplexFrame n hn).g ((simplexFrame n hn).ell a) ((simplexFrame n hn).ell a)
      = simplexGram n a a := by
    simp [simplexFrame, Matrix.toLinearMap₂'_apply']
  rw [h, simplexGram_diag]

/-! ## B2 — diagonal trace obstruction -/

section DiagonalObstruction

variable {V : Type*} [AddCommGroup V] [Module ℝ V] {n : ℕ}

/-- The **diagonal soldering endomorphism** `∑_a b_a · ℓ_a^♭ ⊗ ℓ_a`, acting as
`v ↦ ∑_a b_a · g(ℓ_a, v) · ℓ_a`.  This is the (rejected) diagonal architecture
`∑_a c(ℓ_a^♭) ∇_{ℓ_a}` at the level of its symbol endomorphism. -/
noncomputable def diagOp (g : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (ell : Fin n → V) (b : Fin n → ℝ) : V →ₗ[ℝ] V :=
  ∑ a, ((b a • g (ell a)).smulRight (ell a))

/-- **B2 trace computation.**  The diagonal soldering endomorphism has trace
`∑_a b_a · g(ℓ_a, ℓ_a)`. -/
theorem diagOp_trace (ell : Basis (Fin n) ℝ V) (g : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (b : Fin n → ℝ) :
    (LinearMap.trace ℝ V) (diagOp g (fun a => ell a) b)
      = ∑ a, b a * g (ell a) (ell a) := by
  haveI := Module.Free.of_basis ell
  haveI := Module.Finite.of_basis ell
  unfold diagOp
  rw [map_sum]
  refine Finset.sum_congr rfl fun a _ => ?_
  rw [LinearMap.trace_smulRight]
  simp

/-- **B2 null trace.**  On a null frame (`g(ℓ_a, ℓ_a) = 0`) the diagonal
soldering endomorphism is traceless. -/
theorem diagOp_trace_eq_zero_of_null (ell : Basis (Fin n) ℝ V) (g : V →ₗ[ℝ] V →ₗ[ℝ] ℝ)
    (hnull : ∀ a, g (ell a) (ell a) = 0) (b : Fin n → ℝ) :
    (LinearMap.trace ℝ V) (diagOp g (fun a => ell a) b) = 0 := by
  rw [diagOp_trace ell g b]
  simp [hnull]

/-- **B2: the diagonal trace obstruction.**  On a null frame in positive
dimension, *no* choice of diagonal coefficients `b` makes the diagonal soldering
endomorphism equal the identity: its trace is `0`, while `trace (id) = d = n > 0`.
This is the precise sense in which `∑_a c(ℓ_a^♭) ∇_{ℓ_a}` cannot be the active
Dirac symbol; the active architecture must use the dual covectors `α^a`. -/
theorem diag_soldering_ne_id (ell : Basis (Fin n) ℝ V) (g : V →ₗ[ℝ] V →ₗ[ℝ] ℝ)
    (hnull : ∀ a, g (ell a) (ell a) = 0) (hn : 0 < n) (b : Fin n → ℝ) :
    diagOp g (fun a => ell a) b ≠ LinearMap.id := by
  haveI := Module.Free.of_basis ell
  haveI := Module.Finite.of_basis ell
  intro h
  have htr : (LinearMap.trace ℝ V) (diagOp g (fun a => ell a) b)
      = (LinearMap.trace ℝ V) (LinearMap.id (R := ℝ) (M := V)) := by rw [h]
  rw [diagOp_trace_eq_zero_of_null ell g hnull b, LinearMap.trace_id,
    finrank_eq_card_basis ell, Fintype.card_fin] at htr
  rw [eq_comm, Nat.cast_eq_zero] at htr
  omega

end DiagonalObstruction

/-- **B2 applied to the simplex frame.**  The diagonal soldering of the simplex
null frame is never the identity (positive dimension), because the simplex edges
are null (`simplexGram_diag`). -/
theorem simplex_diag_soldering_ne_id (n : ℕ) (hn : 2 ≤ n) (b : Fin n → ℝ) :
    diagOp (simplexFrame n hn).g (fun a => (simplexFrame n hn).ell a) b ≠ LinearMap.id := by
  apply diag_soldering_ne_id (simplexFrame n hn).ell (simplexFrame n hn).g
  · exact simplexFrame_null n hn
  · omega

end Draft
end PhysicsSM
