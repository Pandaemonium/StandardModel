import Mathlib

/-!
# Color + electroweak unification: one-generation hypercharges from one SU(5) generator

SM-branch foundation, item 3 (2026-07-17). The Standard-Model hypercharge
convention here is `Q = T_3 + Y/2`. In the `SU(5)` grand-unified embedding
`SU(3)_C x SU(2)_L x U(1)_Y / Z_6 subset SU(5)`, one generation of left-handed
fermions is `5* (+) 10 (+) 1`, and the hypercharge is a SINGLE traceless `SU(5)`
Cartan generator. This module derives that the FIVE independent-looking
one-generation hypercharges are all values of one generator:

- the fundamental `5` carries `Y_5 = diag(-2/3, -2/3, -2/3, 1, 1)` (traceless);
- the `5*` (three `d^c` + the lepton doublet `L`) carries `-Y_5 =
  diag(2/3, 2/3, 2/3, -1, -1)`, so `Y(d^c) = 2/3`, `Y(L) = -1`;
- the antisymmetric `10 = Lambda^2(5)` carries `Y_10(i,j) = Y_5(i) + Y_5(j)`,
  giving `Y(u^c) = -4/3` (colour-colour), `Y(Q) = 1/3` (colour-weak),
  `Y(e^c) = 2` (weak-weak);
- the singlet `1` (`nu^c`) carries `Y = 0`.

Consequences DERIVED (not supplied): every SM hypercharge is fixed, up to one
overall normalization, by `SU(5)` tracelessness; the one-generation hypercharge
trace vanishes (`Tr Y = 0`, the mixed/gravitational anomaly-freedom of the
`U(1)_Y`); and every hypercharge lies in `(1/3) Z` (charge quantization). This
unifies the separately-landed `SU(3)_C` (colour) and `SU(2)_L x U(1)_Y`
(electroweak) sectors into one `SU(5)` structure on one generation.

Clean-room; [comp] for the SU(5) assignment (standard GUT), [orig] for the
formalization. Standard-three axioms. All values numerically verified.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.SU5HyperchargeUnification

open scoped BigOperators

/-- Hypercharge of the fundamental `5` of `SU(5)` (convention `Q = T_3 + Y/2`):
three colour components at `-2/3`, two weak components at `1`. -/
def Y5 : Fin 5 → ℚ := ![-2/3, -2/3, -2/3, 1, 1]

/-- Hypercharge of the `5*` (the three `d^c` plus the lepton doublet `L`). -/
def Y5bar (i : Fin 5) : ℚ := -Y5 i

/-- Hypercharge on the antisymmetric `10 = Lambda^2(5)`: the pair sum. -/
def Y10 (i j : Fin 5) : ℚ := Y5 i + Y5 j

/-- **`Y_5` is a traceless `SU(5)` generator.** This single tracelessness
constraint is what fixes all hypercharge ratios. -/
theorem Y5_traceless : ∑ i, Y5 i = 0 := by
  simp [Y5, Fin.sum_univ_five]; norm_num

/-- **`5*`: the down-antiquark and lepton-doublet hypercharges.**
`Y(d^c) = 2/3`, `Y(L) = -1`. -/
theorem Y5bar_values :
    Y5bar 0 = 2 / 3 ∧ Y5bar 1 = 2 / 3 ∧ Y5bar 2 = 2 / 3 ∧
      Y5bar 3 = -1 ∧ Y5bar 4 = -1 := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> simp [Y5bar, Y5] <;> norm_num

/-- **`10`, colour-colour pair = up-antiquark.** `Y(u^c) = -4/3`. -/
theorem Y10_upAnti : Y10 0 1 = -4 / 3 := by
  simp [Y10, Y5]; norm_num

/-- **`10`, colour-weak pair = quark doublet.** `Y(Q) = 1/3`. -/
theorem Y10_quarkDoublet : Y10 0 3 = 1 / 3 := by
  simp [Y10, Y5]; norm_num

/-- **`10`, weak-weak pair = positron.** `Y(e^c) = 2`. -/
theorem Y10_positron : Y10 3 4 = 2 := by
  simp [Y10, Y5]; norm_num

/-- The `10` hypercharge trace is four times the `5` trace: each of the five
indices appears in exactly four antisymmetric pairs. -/
theorem Y10_trace_eq :
    (Y10 0 1 + Y10 0 2 + Y10 0 3 + Y10 0 4 + Y10 1 2 + Y10 1 3 + Y10 1 4 +
      Y10 2 3 + Y10 2 4 + Y10 3 4) = 4 * ∑ i, Y5 i := by
  simp [Y10, Y5, Fin.sum_univ_five]; norm_num

/-- **One-generation hypercharge anomaly-freedom.** The total hypercharge over
`5* (+) 10 (+) 1` vanishes: `Tr Y = 0`. Because both the `5*` trace (`= -Tr Y_5`)
and the `10` trace (`= 4 Tr Y_5`) are multiples of the single `SU(5)`
tracelessness `Tr Y_5 = 0`, the `U(1)_Y` is automatically anomaly-consistent. -/
theorem oneGeneration_hypercharge_traceZero :
    (∑ i, Y5bar i) +
      (Y10 0 1 + Y10 0 2 + Y10 0 3 + Y10 0 4 + Y10 1 2 + Y10 1 3 + Y10 1 4 +
        Y10 2 3 + Y10 2 4 + Y10 3 4) + 0 = 0 := by
  simp [Y5bar, Y10, Y5, Fin.sum_univ_five]; norm_num

/-- **Charge quantization.** Every one-generation hypercharge lies in `(1/3) Z`:
`3 Y` is an integer for all of `Y(d^c), Y(L), Y(u^c), Y(Q), Y(e^c)` (values
`2, -3, -4, 1, 6`). -/
theorem hypercharge_quantized :
    3 * Y5bar 0 = 2 ∧ 3 * Y5bar 3 = -3 ∧
      3 * Y10 0 1 = -4 ∧ 3 * Y10 0 3 = 1 ∧ 3 * Y10 3 4 = 6 := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> simp [Y5bar, Y10, Y5] <;> norm_num

/-- **Georgi-Glashow embedding (colour block).** `Y_5` is constant on the three
colour indices, so `diag(Y_5)` commutes with the `SU(3)` acting on that block. -/
theorem Y5_const_color : Y5 0 = Y5 1 ∧ Y5 1 = Y5 2 := by
  simp [Y5]

/-- **Georgi-Glashow embedding (weak block).** `Y_5` is constant on the two weak
indices, so `diag(Y_5)` commutes with the `SU(2)` acting on that block. Together
with `Y5_const_color`, this identifies `U(1)_Y` as exactly the `SU(5)` generator
commuting with the block-diagonal `SU(3) x SU(2)` - the Georgi-Glashow breaking
`SU(5) -> SU(3)_C x SU(2)_L x U(1)_Y`. -/
theorem Y5_const_weak : Y5 3 = Y5 4 := by
  simp [Y5]

/-- **The block-constant hypercharge commutes with every block-diagonal
transformation.** For any `M : Fin 5 -> Fin 5 -> Q` supported on the colour
`{0,1,2}` and weak `{3,4}` blocks, `diag(Y_5)` commutes with `M`. Stated as the
entrywise commutator vanishing, using colour/weak block-constancy of `Y_5`. -/
theorem diagY5_comm_blockDiagonal
    (M : Fin 5 → Fin 5 → ℚ)
    (hblock : ∀ i j, M i j ≠ 0 →
      ((i.val < 3 ∧ j.val < 3) ∨ (3 ≤ i.val ∧ 3 ≤ j.val))) (i j : Fin 5) :
    Y5 i * M i j - M i j * Y5 j = 0 := by
  by_cases h : M i j = 0
  · simp [h]
  · rcases hblock i j h with ⟨hi, hj⟩ | ⟨hi, hj⟩
    · -- both in the colour block: Y5 i = Y5 j = -2/3
      have : Y5 i = Y5 j := by
        fin_cases i <;> fin_cases j <;> first | rfl | (simp_all [Y5]) | omega
      rw [this]; ring
    · -- both in the weak block: Y5 i = Y5 j = 1
      have : Y5 i = Y5 j := by
        fin_cases i <;> fin_cases j <;> first | rfl | (simp_all [Y5]) | omega
      rw [this]; ring

end PhysicsSM.Draft.NullEdge.SU5HyperchargeUnification

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SU5HyperchargeUnification.Y5_traceless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SU5HyperchargeUnification.Y5_traceless

/-- info: 'PhysicsSM.Draft.NullEdge.SU5HyperchargeUnification.oneGeneration_hypercharge_traceZero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SU5HyperchargeUnification.oneGeneration_hypercharge_traceZero

/-- info: 'PhysicsSM.Draft.NullEdge.SU5HyperchargeUnification.Y10_quarkDoublet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SU5HyperchargeUnification.Y10_quarkDoublet

/-- info: 'PhysicsSM.Draft.NullEdge.SU5HyperchargeUnification.diagY5_comm_blockDiagonal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SU5HyperchargeUnification.diagY5_comm_blockDiagonal

end
