import Mathlib
import seeds.Goal1Hadron

/-!
# Goal I rung-5 tie — the channel budget of the ACTUAL rung-3 bound eigenvector

This module closes the one honest gap in the landed toy hadron
(`seeds/Goal1Hadron.lean`, namespace `Goal1Hadron`): its rung 5
(`Goal1Hadron.rung5_signed_budget`) exhibits a signed channel budget
`b_A = 3/2, b_C = -1/2, b_T = 0` with a **negative closure share** `b_C < 0`, but
only as a *modelled witness* (hand-built blocks `QAb, QCb`), **not** computed from
the rung-3 bound eigenvector.

Here we compute the channel budget of the **actual** rung-3 bound ground state and
prove its sign.  We reuse *verbatim* the rung-2/3 data of the seed:
`Goal1Hadron.H2 Goal1Hadron.dW Goal1Hadron.kW` (the `3×3` two-body singlet-channel
Hamiltonian for the witness `d = (0,1,7)`, `κ = 4`), whose bound ground energy is
exactly `-1` (`Goal1Hadron.rung3_bound_below_threshold`).

## What is computed (nothing is posited)

* `bound_eigenvector` — the explicit **rational** eigenvector `v = (2,1,0)` of
  `H2 dW kW` for the ground eigenvalue `-1`, verified by `H2 dW kW *ᵥ v = (-1)•v`
  and `v ≠ 0`.
* The **channel split** of the *actual* Hamiltonian:
  `H2 = H_A + H_C + H_T` with
    - `H_A = freeH2 dW`      the **aperture** (free two-body pair energies),
    - `H_C = interaction kW` the **closure** (the attractive closure interaction κ),
    - `H_T = 0`              the **turn** channel.
* The **shares** are the normalized expectations *in the bound state* `v`:
  `b_X = ⟨v, H_X v⟩ / ⟨v, H2 v⟩` — every ingredient (`v`, the split, the total)
  comes from rung 3.

## The result (a real *Kill*)

For the *true* ground state the shares are the exact rationals
`b_A = -11/5, b_C = 16/5, b_T = 0`, summing to `1`, with
`⟨v, H2 v⟩ = -1 · ⟨v, v⟩` (eigenvalue consistency).  The **closure share is
`b_C = 16/5 ≥ 0`** (`closure_share_nonneg`): binding is *not* realized as a
negative closure *share* for the actual ground state.  This **kills** the
modelled `b_C < 0` reading of `rung5_signed_budget` once it is honestly tied to
the eigenvector.

The reason is transparent and also recorded here: the closure *energy* is
genuinely negative, `⟨v, H_C v⟩ = -16 < 0` (`closure_energy_neg`) — binding *is*
closure-driven at the energy level — but the total energy `⟨v, H2 v⟩ = -5 < 0` is
itself negative, so the normalized *share* flips sign.  A scan over all `±1`
diagonal (signature) expectations gives `b_C ∈ {16/5, 0}`, never negative: only an
eigenbasis-off-diagonal (i.e. posited) metric could force `b_C < 0`.

Everything is exact rational arithmetic (`norm_num`); no `Real.sqrt`/`sin`/`cos`,
no `sorry`/`admit`/`native_decide`/new axiom.
-/

open Matrix
open Goal1Hadron

namespace Goal1Rung5Tie

/-- The explicit **rational** bound eigenvector of `H2 dW kW` for eigenvalue `-1`
(the rung-3 ground state), as `v = (2, 1, 0)`. -/
def v : Fin 3 → ℝ := ![2, 1, 0]

/-- The **aperture** channel `H_A` of the actual Hamiltonian: the free two-body
pair energies `freeH2 dW = diag(1,7,8)`. -/
def HA : Matrix (Fin 3) (Fin 3) ℝ := freeH2 dW

/-- The **closure** channel `H_C` of the actual Hamiltonian: the attractive
closure interaction `interaction kW`. -/
def HC : Matrix (Fin 3) (Fin 3) ℝ := interaction kW

/-- The **turn** channel `H_T` of the actual Hamiltonian (empty for this witness). -/
def HT : Matrix (Fin 3) (Fin 3) ℝ := 0

/-- The state expectation `⟨v, M v⟩` in the bound eigenvector `v`. -/
noncomputable def qexp (M : Matrix (Fin 3) (Fin 3) ℝ) : ℝ := v ⬝ᵥ (M *ᵥ v)

/-- The normalized channel **share** `b_X = ⟨v, H_X v⟩ / ⟨v, H2 v⟩`. -/
noncomputable def share (M : Matrix (Fin 3) (Fin 3) ℝ) : ℝ := qexp M / qexp (H2 dW kW)

/-- The aperture share `b_A`. -/
noncomputable def bA : ℝ := share HA
/-- The closure share `b_C`. -/
noncomputable def bC : ℝ := share HC
/-- The turn share `b_T`. -/
noncomputable def bT : ℝ := share HT

/-! ## The eigenvector -/

/-- **`bound_eigenvector`.** The explicit rational vector `v = (2,1,0)` is an
eigenvector of the rung-3 Hamiltonian `H2 dW kW` for the ground eigenvalue `-1`,
and is nonzero — verified by direct rational computation. -/
theorem bound_eigenvector : (H2 dW kW) *ᵥ v = (-1 : ℝ) • v ∧ v ≠ 0 := by
  refine ⟨?_, ?_⟩
  · funext i
    fin_cases i <;>
      simp [H2, freeH2, interaction, dW, kW, v, pairEnergy, Matrix.mulVec, dotProduct,
        Fin.sum_univ_three, Matrix.diagonal] <;> norm_num
  · intro h; have := congrFun h 0; simp [v] at this

/-! ## The channel split of the actual Hamiltonian -/

/-- The channel split is a genuine decomposition of the *actual* rung-3
Hamiltonian: `H2 = H_A + H_C + H_T`. -/
theorem channel_split : H2 dW kW = HA + HC + HT := by
  simp [H2, HA, HC, HT]

/-! ## Exact rational expectation values (computed from `v`) -/

theorem qexp_H2 : qexp (H2 dW kW) = -5 := by
  simp [qexp, H2, freeH2, interaction, dW, kW, v, pairEnergy, Matrix.mulVec, dotProduct,
    Fin.sum_univ_three, Matrix.diagonal]; norm_num

theorem qexp_vv : v ⬝ᵥ v = 5 := by
  simp [v, dotProduct, Fin.sum_univ_three]; norm_num

theorem qexp_HA : qexp HA = 11 := by
  simp [qexp, HA, freeH2, dW, v, pairEnergy, Matrix.mulVec, dotProduct,
    Fin.sum_univ_three, Matrix.diagonal]; norm_num

theorem qexp_HC : qexp HC = -16 := by
  simp [qexp, HC, interaction, kW, v, Matrix.mulVec, dotProduct, Fin.sum_univ_three]; norm_num

theorem qexp_HT : qexp HT = 0 := by
  simp [qexp, HT]

/-! ## Eigenvalue consistency and the mandatory total -/

/-- **Eigenvalue consistency (mandatory).** `⟨v, H2 v⟩ = -1 · ⟨v, v⟩`: the total
budget denominator equals the ground eigenvalue `-1` times the state norm. -/
theorem total_eq : qexp (H2 dW kW) = (-1 : ℝ) * (v ⬝ᵥ v) := by
  rw [qexp_H2, qexp_vv]; norm_num

/-! ## The signed channel budget of the bound state -/

/-- The aperture share is `b_A = -11/5`. -/
theorem bA_val : bA = -11/5 := by
  simp only [bA, share, qexp_HA, qexp_H2]; norm_num

/-- The closure share is `b_C = 16/5`. -/
theorem bC_val : bC = 16/5 := by
  simp only [bC, share, qexp_HC, qexp_H2]; norm_num

/-- The turn share is `b_T = 0`. -/
theorem bT_val : bT = 0 := by
  simp only [bT, share, qexp_HT, qexp_H2]; norm_num

/-- The three channel shares sum to one. -/
theorem shares_sum_one : bA + bC + bT = 1 := by
  rw [bA_val, bC_val, bT_val]; norm_num

/-- **The Kill.** The *actual* bound eigenvector's closure share is nonnegative
(`b_C = 16/5 ≥ 0`): binding is **not** realized as a negative closure *share* for
the true ground state — falsifying the modelled `b_C < 0` reading of
`Goal1Hadron.rung5_signed_budget` once it is tied to the eigenvector. -/
theorem closure_share_nonneg : 0 ≤ bC := by
  rw [bC_val]; norm_num

/-- The closure *energy* is genuinely negative, `⟨v, H_C v⟩ = -16 < 0`: binding
*is* closure-driven at the energy level.  It is only the normalization by the
(also negative) total energy `⟨v, H2 v⟩ = -5` that flips the *share* to positive. -/
theorem closure_energy_neg : qexp HC < 0 := by
  rw [qexp_HC]; norm_num

/-- **`bound_budget_from_eigenvector`.** The channel budget computed *from the
actual rung-3 bound eigenvector* `v = (2,1,0)`:

* the shares are the exact rationals `b_A = -11/5, b_C = 16/5, b_T = 0`;
* they sum to `1`;
* eigenvalue consistency `⟨v, H2 v⟩ = -1 · ⟨v, v⟩` holds;
* the closure share is `b_C = 16/5 ≥ 0` (the **Kill**);
* while the closure *energy* `⟨v, H_C v⟩ = -16 < 0` is negative.

Nothing is posited: `v`, the split `H2 = H_A + H_C + H_T`, and the total all come
from rung 3. -/
theorem bound_budget_from_eigenvector :
    H2 dW kW = HA + HC + HT ∧
    qexp (H2 dW kW) = (-1 : ℝ) * (v ⬝ᵥ v) ∧
    bA = -11/5 ∧ bC = 16/5 ∧ bT = 0 ∧
    bA + bC + bT = 1 ∧
    0 ≤ bC ∧
    qexp HC < 0 :=
  ⟨channel_split, total_eq, bA_val, bC_val, bT_val, shares_sum_one,
    closure_share_nonneg, closure_energy_neg⟩

/-! ## Axiom footprint (must be exactly `[propext, Classical.choice, Quot.sound]`) -/

/-- info: 'Goal1Rung5Tie.bound_eigenvector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bound_eigenvector

/-- info: 'Goal1Rung5Tie.bound_budget_from_eigenvector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bound_budget_from_eigenvector

/-- info: 'Goal1Rung5Tie.closure_share_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms closure_share_nonneg

end Goal1Rung5Tie
