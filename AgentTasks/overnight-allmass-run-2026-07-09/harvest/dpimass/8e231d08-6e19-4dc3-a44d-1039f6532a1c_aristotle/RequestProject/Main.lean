import Mathlib

open scoped BigOperators
open scoped Classical

open Matrix

set_option maxHeartbeats 4000000

/-!
# The mass-entropy monotone survives coarse-graining: a finite data-processing bound

A finite, rational, *linear-entropy* avatar of the data-processing inequality (DPI) for the
"visible direction register" of the mass dictionary.  We work entirely with **real rational**
symmetric `2 × 2` density operators (no `Complex`, no `Real.log`/`sqrt`/`cos`/`sin`), so every
statement is kernel-checkable by `ring`/`norm_num`/`fin_cases`.

## Provenance (reference, NOT an import)

Ported from the **lean-quantum** package
(`github.com/Hayata-Yamasaki-Group/lean-quantum`: density operators, channels, partial trace,
entropy, and the data-processing inequality).  There the DPI is proved for the **von Neumann
relative entropy**; here we prove the **linear-entropy** (`Slin = 1 - tr ρ²`) avatar, which is the
form the mass dictionary needs (`mass² = Slin` of the visible register).  Version gap: lean-quantum
is version-pinned and is used only as a mathematical reference — this file depends on Mathlib alone.

## The model

* Density operator `rho p x = !![p, x; x, 1 - p]` (real symmetric, PSD, trace `1`).
* Linear entropy `Slin ρ = 1 - tr(ρ²) = 2 (p(1-p) - x²) = 2 det ρ` (the `mass²` invariant).
* Coarse-graining / pinching channel `Phi t ρ` damps the off-diagonal coherence by `(1 - t)`,
  `t ∈ [0,1]` — the finite avatar of a unital quantum channel.
-/

namespace LeanQuantumDPIMass

/-- Real symmetric rational density operator with parameters `p` (a diagonal population)
and `x` (the off-diagonal coherence): `!![p, x; x, 1 - p]`. -/
def rho (p x : ℚ) : Matrix (Fin 2) (Fin 2) ℚ := !![p, x; x, 1 - p]

/-- The pinching / coarse-graining channel: damps the off-diagonal coherence by a factor `1 - t`.
The finite, unital avatar of a quantum channel. -/
def Phi (t : ℚ) (M : Matrix (Fin 2) (Fin 2) ℚ) : Matrix (Fin 2) (Fin 2) ℚ :=
  !![M 0 0, (1 - t) * M 0 1; (1 - t) * M 1 0, M 1 1]

/-- Linear entropy `Slin ρ = 1 - tr(ρ²)` — the `mass²` invariant of the mass dictionary. -/
def Slin (M : Matrix (Fin 2) (Fin 2) ℚ) : ℚ := 1 - (M * M).trace

/-- A (finite, rational) density operator: positive semidefinite with unit trace. -/
def IsDensity (M : Matrix (Fin 2) (Fin 2) ℚ) : Prop := M.PosSemidef ∧ M.trace = 1

/-! ### Elementary computations -/

/-- Linear entropy of an explicit `2 × 2` matrix. -/
theorem Slin_of (a b c d : ℚ) :
    Slin !![a, b; c, d] = 1 - (a ^ 2 + b * c + (c * b + d ^ 2)) := by
  simp [Slin, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two, Matrix.diag]
  ring

/-- The pinching channel applied to `rho p x` damps the coherence to `(1 - t) x`. -/
theorem Phi_rho (t p x : ℚ) : Phi t (rho p x) = !![p, (1 - t) * x; (1 - t) * x, 1 - p] := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Phi, rho]

/-- A symmetric `2 × 2` rational matrix with nonnegative diagonal and nonnegative determinant is
positive semidefinite. -/
theorem posSemidef_two (a b d : ℚ) (ha : 0 ≤ a) (hd : 0 ≤ d) (hdet : 0 ≤ a * d - b ^ 2) :
    (!![a, b; b, d] : Matrix (Fin 2) (Fin 2) ℚ).PosSemidef := by
  rw [Matrix.posSemidef_iff_dotProduct_mulVec]
  refine ⟨?_, ?_⟩
  · ext i j; fin_cases i <;> fin_cases j <;> simp
  · intro v
    simp only [dotProduct, mulVec, Fin.sum_univ_two, cons_val', cons_val_zero,
      cons_val_one, star_trivial, empty_val', cons_val_fin_one, of_apply]
    rcases eq_or_lt_of_le ha with h | h
    · subst h
      have hb : b = 0 := by nlinarith [sq_nonneg b]
      subst hb; nlinarith [mul_nonneg hd (sq_nonneg (v 1))]
    · have key : a * (v 0 * (a * v 0 + b * v 1) + v 1 * (b * v 0 + d * v 1))
          = (a * v 0 + b * v 1) ^ 2 + (a * d - b ^ 2) * (v 1) ^ 2 := by ring
      nlinarith [sq_nonneg (a * v 0 + b * v 1), mul_nonneg hdet (sq_nonneg (v 1)), mul_pos h h, key]

/-! ### Target 1 — the channel preserves states -/

/-- **`channel_is_state`.** The coarse-graining channel maps a valid density operator to a valid
density operator: for `0 ≤ p ≤ 1`, nonnegative determinant, and `t ∈ [0,1]`, `Phi t (rho p x)` is
symmetric, positive semidefinite, and has unit trace. -/
theorem channel_is_state (p x t : ℚ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (hdet : 0 ≤ p * (1 - p) - x ^ 2) (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    IsDensity (Phi t (rho p x)) := by
  rw [Phi_rho]
  refine ⟨posSemidef_two p ((1 - t) * x) (1 - p) hp0 (by linarith) ?_, ?_⟩
  · nlinarith [hdet, sq_nonneg x, mul_nonneg ht0 (by linarith : (0:ℚ) ≤ 2 - t),
      mul_nonneg (mul_nonneg ht0 (by linarith : (0:ℚ) ≤ 2 - t)) (sq_nonneg x)]
  · simp [Matrix.trace, Matrix.diag, Fin.sum_univ_two]

/-! ### Target 2 — linear entropy is monotone under coarse-graining (the DPI core) -/

/-- The closed-form entropy gain: `Slin (Phi t ρ) - Slin ρ = 2 t (2 - t) x²`. -/
theorem entropy_gain (p x t : ℚ) :
    Slin (Phi t (rho p x)) - Slin (rho p x) = 2 * t * (2 - t) * x ^ 2 := by
  rw [Phi_rho, rho, Slin_of, Slin_of]; ring

/-- **`linear_entropy_monotone`** (the DPI core). Coarse-graining does not decrease the linear
entropy: for `t ∈ [0,1]`, `Slin ρ ≤ Slin (Phi t ρ)`.  Equivalently the gain `2 t (2 - t) x² ≥ 0`.
`mass² = Slin` of the visible register can only grow under decoherence. -/
theorem linear_entropy_monotone (p x t : ℚ) (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    Slin (rho p x) ≤ Slin (Phi t (rho p x)) := by
  have h := entropy_gain p x t
  have h2 : (0:ℚ) ≤ 2 - t := by linarith
  have hnn : 0 ≤ 2 * t * (2 - t) * x ^ 2 :=
    mul_nonneg (mul_nonneg (mul_nonneg (by norm_num) ht0) h2) (sq_nonneg x)
  linarith [h, hnn]

/-! ### Target 3 — the signed coherent-closure exception -/

/-- A rational orthogonal `3-4-5` rotation `U = (1/5) !![3, -4; 4, 3]` (`U Uᵀ = 1`, `det U = 1`). -/
def U345 : Matrix (Fin 2) (Fin 2) ℚ := !![3/5, -4/5; 4/5, 3/5]

/-- **`signed_closure_exception`.** A coherent (unitary) pre-rotation can *lower* the post-channel
linear entropy relative to naive coarse-graining: with the `3-4-5` rotation and `t = 1`,
`Slin (Phi 1 (U ρ Uᵀ)) < Slin (Phi 1 ρ)`.  Explicit rational witness
(`481/1250 < 1/2`): closure is not noise — a coherent move reorganizes and can lower `mass²`. -/
theorem signed_closure_exception :
    Slin (Phi 1 (U345 * rho (1/2) (1/4) * U345ᵀ)) < Slin (Phi 1 (rho (1/2) (1/4))) := by
  norm_num [Slin, Phi, rho, U345, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two, Matrix.diag,
    Matrix.transpose]

/-! ### Mandatory non-degeneracy: coarse-graining creates mass -/

/-- The pure/massless coherent state `!![1/2, 1/2; 1/2, 1/2]` has `Slin = 0`; fully pinching it
(`t = 1`) yields `!![1/2, 0; 0, 1/2]` with `Slin = 1/2 > 0`.  Coarse-graining created mass. -/
theorem mass_created :
    Slin (rho (1/2) (1/2)) = 0 ∧
    Phi 1 (rho (1/2) (1/2)) = !![1/2, 0; 0, 1/2] ∧
    Slin (Phi 1 (rho (1/2) (1/2))) = 1/2 := by
  refine ⟨?_, ?_, ?_⟩
  · rw [rho, Slin_of]; norm_num
  · rw [Phi_rho]; norm_num
  · rw [Phi_rho, Slin_of]; norm_num

/-! ### Target 4 — the DPI verdict -/

/-- **`dpi_verdict`.** The package: `mass² = Slin` of the visible register is a monotone under
coarse-graining (the finite linear-entropy DPI), with explicit closed-form gain, *modulo* the
signed coherent-closure exception, and the non-degeneracy witness that decohering hidden structure
creates mass.

1. monotonicity (DPI): `Slin ρ ≤ Slin (Phi t ρ)` for `t ∈ [0,1]`;
2. closed form of the gain: `Slin (Phi t ρ) - Slin ρ = 2 t (2 - t) x²`;
3. signed exception: a coherent rotation can strictly lower the post-channel entropy;
4. non-degeneracy: coarse-graining turns the massless pure state (`Slin 0`) into a massive mixed
   state (`Slin 1/2`). -/
theorem dpi_verdict :
    (∀ p x t : ℚ, 0 ≤ t → t ≤ 1 → Slin (rho p x) ≤ Slin (Phi t (rho p x))) ∧
    (∀ p x t : ℚ, Slin (Phi t (rho p x)) - Slin (rho p x) = 2 * t * (2 - t) * x ^ 2) ∧
    (Slin (Phi 1 (U345 * rho (1/2) (1/4) * U345ᵀ)) < Slin (Phi 1 (rho (1/2) (1/4)))) ∧
    (Slin (rho (1/2) (1/2)) = 0 ∧ Slin (Phi 1 (rho (1/2) (1/2))) = 1/2) := by
  refine ⟨fun p x t ht0 ht1 => linear_entropy_monotone p x t ht0 ht1, entropy_gain,
    signed_closure_exception, ?_, ?_⟩
  · rw [rho, Slin_of]; norm_num
  · rw [Phi_rho, Slin_of]; norm_num

/-! ### Kernel footprint of every headline (exactly `[propext, Classical.choice, Quot.sound]`) -/

/-- info: 'LeanQuantumDPIMass.channel_is_state' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms channel_is_state

/-- info: 'LeanQuantumDPIMass.linear_entropy_monotone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linear_entropy_monotone

/-- info: 'LeanQuantumDPIMass.signed_closure_exception' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms signed_closure_exception

/-- info: 'LeanQuantumDPIMass.dpi_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dpi_verdict

end LeanQuantumDPIMass
