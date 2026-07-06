import Mathlib

/-!
# Abstract two-level OS gap for a general 2×2 Hermitian PSD transfer block

This module abstracts the Osterwalder–Schrader (OS) two-level spectral gap and
exponential clustering away from the concrete `Z2` Boltzmann weights to **any**
`2 × 2` Hermitian positive-semidefinite transfer block with two positive
eigenvalues `lam0 > lamFlux > 0`.

The companion modules `OSReconstruction` / `SlabClustering` build the finite OS
reconstruction and exponential clustering for the exactly-solvable `Z2`
two-state slab.  Everything group-specific there factors through a single
`2 × 2` transfer block.  This file isolates the **group-agnostic core**: a
`2 × 2` Hermitian PSD block with a top ("vacuum") eigenvalue `lam0` strictly
above a "flux" eigenvalue `lamFlux`, and derives:

* self-adjointness (`transfer_isSelfAdjoint`) and Hermitianity
  (`transfer_isHermitian`) of the transfer;
* positive-semidefiniteness (`transfer_posSemidef`);
* the strictly positive additive spectral gap `gap = -log(lamFlux / lam0)`
  (`gap_pos`), with `ratio = lamFlux / lam0 = exp(-gap)`
  (`ratio_eq_exp_neg_gap`);
* the exact connected two-point identity for the vacuum-normalised transfer
  (`connected_eq`) and its exponential clustering bound
  `‖connected n‖ ≤ C · exp(-(n · gap))` with `C` **uniform in `n`**
  (`exponential_clustering`).

The data of a `TwoLevelBlock` is exactly the spectral-theorem data of a `2 × 2`
Hermitian PSD matrix with two positive eigenvalues: two eigenvalues
`lam0 > lamFlux > 0`, two eigenvectors `v0`, `vFlux`, and the resolution of the
identity `complete` (the completeness / orthonormal-eigenbasis relation, which
by the spectral theorem always holds for such a block).  From these,
Hermitianity and positive-semidefiniteness are **proved**, not assumed.

## Honest scope

This is an **abstract, finite two-level result**.  It is the reusable core that
the `Z2` slab (and any genuinely nonabelian two-level sector that has been
reduced to a `2 × 2` transfer block) instantiates verbatim.  It is **NOT** the
full nonabelian Yang–Mills mass gap: that requires the full transfer operator on
the infinite-dimensional physical Hilbert space, not a `2 × 2` reduction.  No
continuum limit, no area law, no physical mass gap is claimed here.

No `sorry`, no `axiom`, no `native_decide`.
-/

noncomputable section

open scoped BigOperators Matrix ComplexOrder

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TwoLevelOSGap

open Matrix

/-! ## The abstract two-level transfer block -/

/-- An abstract `2 × 2` two-level transfer block: a matrix `T` on `Fin 2 → ℂ`
together with the spectral-theorem data of two positive eigenvalues
`lam0 > lamFlux > 0` and an orthonormal eigenbasis `v0` ("vacuum"), `vFlux`
("flux").  The `complete` field is the resolution of the identity for that
eigenbasis; for a genuine `2 × 2` Hermitian PSD block with two positive
eigenvalues the spectral theorem guarantees it, and from it Hermitianity and
positive-semidefiniteness of `T` are derived below. -/
structure TwoLevelBlock where
  /-- The transfer matrix on the two-level state space `Fin 2 → ℂ`. -/
  T : Matrix (Fin 2) (Fin 2) ℂ
  /-- The vacuum (top) eigenvector. -/
  v0 : Fin 2 → ℂ
  /-- The flux (subleading) eigenvector. -/
  vFlux : Fin 2 → ℂ
  /-- The vacuum eigenvalue. -/
  lam0 : ℝ
  /-- The flux eigenvalue. -/
  lamFlux : ℝ
  /-- The flux eigenvalue is positive. -/
  lamFlux_pos : 0 < lamFlux
  /-- The vacuum eigenvalue lies strictly above the flux eigenvalue. -/
  gap_lam : lamFlux < lam0
  /-- Vacuum eigen-equation. -/
  T_v0 : T *ᵥ v0 = (lam0 : ℂ) • v0
  /-- Flux eigen-equation. -/
  T_vFlux : T *ᵥ vFlux = (lamFlux : ℂ) • vFlux
  /-- Completeness / resolution of the identity in the orthonormal eigenbasis:
  every state decomposes with coefficients given by the inner products with the
  eigenvectors.  (Taking `w = v0`, `w = vFlux` shows the eigenbasis is
  orthonormal.) -/
  complete : ∀ w : Fin 2 → ℂ,
    w = (star v0 ⬝ᵥ w) • v0 + (star vFlux ⬝ᵥ w) • vFlux

namespace TwoLevelBlock

variable (B : TwoLevelBlock)

/-- The vacuum eigenvalue is positive. -/
theorem lam0_pos : 0 < B.lam0 := lt_trans B.lamFlux_pos B.gap_lam

/-- The vacuum eigenvalue is nonzero. -/
theorem lam0_ne_zero : (B.lam0 : ℂ) ≠ 0 := by
  exact_mod_cast ne_of_gt B.lam0_pos

/--
**Key action formula.**  On any state `w`, the transfer acts diagonally in
the eigenbasis: `T w = lam0 ⟪v0,w⟫ v0 + lamFlux ⟪vFlux,w⟫ vFlux`.
-/
theorem T_apply (w : Fin 2 → ℂ) :
    B.T *ᵥ w
      = ((B.lam0 : ℂ) * (star B.v0 ⬝ᵥ w)) • B.v0
        + ((B.lamFlux : ℂ) * (star B.vFlux ⬝ᵥ w)) • B.vFlux := by
  conv_lhs => rw [B.complete w]
  rw [Matrix.mulVec_add, Matrix.mulVec_smul, Matrix.mulVec_smul, B.T_v0, B.T_vFlux,
    smul_smul, smul_smul, mul_comm (star B.v0 ⬝ᵥ w), mul_comm (star B.vFlux ⬝ᵥ w)]

/-! ### Self-adjointness, Hermitianity, positive-semidefiniteness -/

/--
**Self-adjointness** of the transfer for the Euclidean inner product
`⟪x,y⟫ = star x ⬝ᵥ y`: `⟪T x, y⟫ = ⟪x, T y⟫`.
-/
theorem transfer_isSelfAdjoint (x y : Fin 2 → ℂ) :
    star (B.T *ᵥ x) ⬝ᵥ y = star x ⬝ᵥ (B.T *ᵥ y) := by
  rw [ B.T_apply, B.T_apply ];
  simp +decide [ dotProduct, Fin.sum_univ_two ];
  ring

/--
The transfer block is Hermitian.
-/
theorem transfer_isHermitian : B.T.IsHermitian := by
  ext i j
  have := B.transfer_isSelfAdjoint (Pi.single i 1) (Pi.single j 1)
  simpa [Matrix.mulVec, dotProduct, Pi.single_apply, Fin.sum_univ_two,
    Matrix.conjTranspose_apply] using this

/-- **Diagonal quadratic form.**  `⟪x, T x⟫ = lam0 |⟪v0,x⟫|² + lamFlux |⟪vFlux,x⟫|²`. -/
theorem quadForm (x : Fin 2 → ℂ) :
    star x ⬝ᵥ (B.T *ᵥ x)
      = (B.lam0 : ℂ) * (Complex.normSq (star B.v0 ⬝ᵥ x))
        + (B.lamFlux : ℂ) * (Complex.normSq (star B.vFlux ⬝ᵥ x)) := by
  have hconj : ∀ v : Fin 2 → ℂ, star x ⬝ᵥ v = starRingEnd ℂ (star v ⬝ᵥ x) := by
    intro v; simp [dotProduct, Fin.sum_univ_two, map_add, mul_comm]
  rw [B.T_apply x, dotProduct_add, dotProduct_smul, dotProduct_smul,
    hconj B.v0, hconj B.vFlux, smul_eq_mul, smul_eq_mul,
    mul_assoc, mul_assoc, Complex.mul_conj, Complex.mul_conj]

/--
**Positive-semidefiniteness** of the transfer block.
-/
theorem transfer_posSemidef : B.T.PosSemidef := by
  refine ⟨ B.transfer_isHermitian, ?_ ⟩;
  intro x
  have h_nonneg : 0 ≤ star x ⬝ᵥ (B.T *ᵥ x) := by
    have h_quadForm : star x ⬝ᵥ (B.T *ᵥ x) = (B.lam0 : ℂ) * (Complex.normSq (star B.v0 ⬝ᵥ x)) + (B.lamFlux : ℂ) * (Complex.normSq (star B.vFlux ⬝ᵥ x)) := by
      convert B.quadForm x using 1;
    exact h_quadForm.symm ▸ mod_cast add_nonneg ( mul_nonneg ( mod_cast le_of_lt ( B.lam0_pos ) ) ( Complex.normSq_nonneg _ ) ) ( mul_nonneg ( mod_cast le_of_lt ( B.lamFlux_pos ) ) ( Complex.normSq_nonneg _ ) );
  convert h_nonneg using 1;
  simp +decide [ Matrix.mulVec, dotProduct, Finsupp.sum_fintype ];
  ring

/-! ## The spectral gap -/

/-- The flux/vacuum contraction ratio `lamFlux / lam0 ∈ (0,1)`. -/
def ratio : ℝ := B.lamFlux / B.lam0

theorem ratio_pos : 0 < B.ratio := div_pos B.lamFlux_pos B.lam0_pos

theorem ratio_lt_one : B.ratio < 1 := by
  rw [ratio, div_lt_one B.lam0_pos]; exact B.gap_lam

/-- **The additive OS spectral gap** `gap = -log(lamFlux / lam0) = -log(ratio)`,
the Hamiltonian gap `H = -log T` between the vacuum and flux levels. -/
def gap : ℝ := -Real.log B.ratio

/-- **The spectral gap is strictly positive.** -/
theorem gap_pos : 0 < B.gap := by
  rw [gap, neg_pos]
  exact Real.log_neg B.ratio_pos B.ratio_lt_one

/-- The ratio is the exponential of the negative gap: `ratio = exp(-gap)`. -/
theorem ratio_eq_exp_neg_gap : B.ratio = Real.exp (-B.gap) := by
  rw [gap, neg_neg, Real.exp_log B.ratio_pos]

/-! ## Exponential clustering of the connected two-point function -/

/-- The vacuum-normalised transfer `lam0⁻¹ • T`: the vacuum becomes a fixed
point (eigenvalue `1`) and the flux sector contracts by `ratio`. -/
def normTransfer : Matrix (Fin 2) (Fin 2) ℂ := ((B.lam0 : ℂ))⁻¹ • B.T

theorem normTransfer_v0 : B.normTransfer *ᵥ B.v0 = (1 : ℂ) • B.v0 := by
  rw [normTransfer, Matrix.smul_mulVec, B.T_v0, smul_smul,
    inv_mul_cancel₀ B.lam0_ne_zero]

theorem normTransfer_vFlux :
    B.normTransfer *ᵥ B.vFlux = ((B.ratio : ℝ) : ℂ) • B.vFlux := by
  rw [normTransfer, Matrix.smul_mulVec, B.T_vFlux, smul_smul, ratio,
    Complex.ofReal_div, div_eq_inv_mul]

/-- If `A v = c • v` then `Aⁿ v = cⁿ • v`. -/
theorem pow_mulVec_eigen {A : Matrix (Fin 2) (Fin 2) ℂ} {v : Fin 2 → ℂ} {c : ℂ}
    (h : A *ᵥ v = c • v) : ∀ n : ℕ, A ^ n *ᵥ v = c ^ n • v
  | 0 => by simp [Matrix.one_mulVec]
  | n + 1 => by
      rw [pow_succ, ← Matrix.mulVec_mulVec, h, Matrix.mulVec_smul,
        pow_mulVec_eigen h n, smul_smul, ← pow_succ']

theorem normTransfer_pow_v0 (n : ℕ) :
    B.normTransfer ^ n *ᵥ B.v0 = B.v0 := by
  rw [pow_mulVec_eigen B.normTransfer_v0 n, one_pow, one_smul]

theorem normTransfer_pow_vFlux (n : ℕ) :
    B.normTransfer ^ n *ᵥ B.vFlux = (((B.ratio : ℝ) : ℂ) ^ n) • B.vFlux :=
  pow_mulVec_eigen B.normTransfer_vFlux n

/--
The image of a general state under the normalised transfer power, expanded in
the vacuum/flux eigenbasis.
-/
theorem normTransfer_pow_apply (n : ℕ) (w : Fin 2 → ℂ) :
    B.normTransfer ^ n *ᵥ w
      = (star B.v0 ⬝ᵥ w) • B.v0
        + ((((B.ratio : ℝ) : ℂ) ^ n) * (star B.vFlux ⬝ᵥ w)) • B.vFlux := by
  convert congr_arg ( fun x => B.normTransfer ^ n *ᵥ x ) ( B.complete w ) using 1;
  simp +decide [ Matrix.mulVec_add, Matrix.mulVec_smul, B.normTransfer_pow_v0, B.normTransfer_pow_vFlux ];
  rw [ smul_smul, mul_comm ]

/-- The `n`-step connected two-point function of the vacuum-normalised transfer
between states `v` and `w`: `⟪v, T̂ⁿ w⟫` with the vacuum (disconnected) piece
`⟪v, v0⟫⟪v0, w⟫` subtracted off. -/
def connected (n : ℕ) (v w : Fin 2 → ℂ) : ℂ :=
  star v ⬝ᵥ (B.normTransfer ^ n *ᵥ w)
    - (star v ⬝ᵥ B.v0) * (star B.v0 ⬝ᵥ w)

/--
**Exact connected correlation identity.**  The connected two-point function
factorises as `ratioⁿ` times the flux-sector overlap.
-/
theorem connected_eq (n : ℕ) (v w : Fin 2 → ℂ) :
    B.connected n v w
      = (((B.ratio : ℝ) : ℂ) ^ n)
        * ((star v ⬝ᵥ B.vFlux) * (star B.vFlux ⬝ᵥ w)) := by
  unfold TwoLevelBlock.connected;
  rw [ B.normTransfer_pow_apply ] ; norm_num [ dotProduct_add, dotProduct_smul ] ; ring;

/--
**Exponential clustering (geometric form).**  The connected two-point
function is bounded by the flux-sector overlap constant times `ratioⁿ`.
-/
theorem connected_decay (n : ℕ) (v w : Fin 2 → ℂ) :
    ‖B.connected n v w‖
      ≤ ‖(star v ⬝ᵥ B.vFlux) * (star B.vFlux ⬝ᵥ w)‖ * B.ratio ^ n := by
  rw [ B.connected_eq, norm_mul ];
  rw [ mul_comm, Complex.norm_pow, Complex.norm_real ];
  rw [ Real.norm_of_nonneg ( B.ratio_pos.le ) ]

/--
**Exponential clustering.**  The connected two-point function of the
OS-reconstructed abstract two-level transfer decays exponentially in the number
of steps `n` at rate `gap`, with a constant `C` **uniform in `n`**:
`‖connected n v w‖ ≤ C · exp(-(n · gap))`.
-/
theorem exponential_clustering (n : ℕ) (v w : Fin 2 → ℂ) :
    ‖B.connected n v w‖
      ≤ ‖(star v ⬝ᵥ B.vFlux) * (star B.vFlux ⬝ᵥ w)‖
        * Real.exp (-(n * B.gap)) := by
  refine le_trans (B.connected_decay n v w) (le_of_eq ?_)
  rw [B.ratio_eq_exp_neg_gap, ← Real.exp_nat_mul]
  ring_nf

end TwoLevelBlock

/-! ## Non-vacuity: a concrete instance (diagonal two-level block)

To confirm the hypotheses of `TwoLevelBlock` are satisfiable, we exhibit the
diagonal block `diag(lam0, lamFlux)` with the standard basis as its orthonormal
eigenbasis. -/

/-- A concrete diagonal two-level block for any `lamFlux < lam0` with
`0 < lamFlux`, showing the abstract hypotheses are satisfiable. -/
def diagBlock (lam0 lamFlux : ℝ) (hpos : 0 < lamFlux) (hgap : lamFlux < lam0) :
    TwoLevelBlock where
  T := Matrix.diagonal ![(lam0 : ℂ), (lamFlux : ℂ)]
  v0 := ![1, 0]
  vFlux := ![0, 1]
  lam0 := lam0
  lamFlux := lamFlux
  lamFlux_pos := hpos
  gap_lam := hgap
  T_v0 := by
    funext i; fin_cases i <;> simp [Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  T_vFlux := by
    funext i; fin_cases i <;> simp [Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  complete := by
    intro w; funext i; fin_cases i <;> simp [dotProduct, Fin.sum_univ_two]

end TwoLevelOSGap
end GateYM
end NullEdge
end Draft
end PhysicsSM
