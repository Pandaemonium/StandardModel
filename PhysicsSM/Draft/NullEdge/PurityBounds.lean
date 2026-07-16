import Mathlib

/-!
# Purity bounds for a finite density matrix: 1/d <= Tr(rho^2) <= 1

Draft module. For a density matrix `rho` (Hermitian, positive semidefinite, unit
trace) on a finite nonempty Hilbert space of dimension `d = card n`, the purity
`Tr(rho^2) = sum_i lambda_i^2` (over eigenvalues) is bounded by
`1/d <= purity <= 1`: the upper bound (`= 1`) is attained by pure states, the
lower bound (`= 1/d`) by the maximally-mixed state. This is the purity dual of
`PhysicsSM.Draft.NullEdge.VonNeumann` (`S(rho) <= log d`) and a basic resource
monotone for the mass-as-entanglement / information-resource program. CFC-free:
purity is the sum of squared eigenvalues, no matrix functional calculus.

## Statement

`purity_le_one : purity rho hrho <= 1` and, on a nonempty space,
`inv_card_le_purity : 1 / (Fintype.card n : R) <= purity rho hrho`, for
`rho.IsHermitian`, `rho.PosSemidef`, `rho.trace = 1`.

## Trust status

Draft-trust by kernel: both bounds are `sorry`-free and depend only on
`[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard blocks at the end.

## Provenance

Statement authored in-project (AFPL run 2026-07-12). Proof search by Aristotle
(project `d8ca01fc-7f73-4b33-b045-9c7062d750a7`), then independently re-checked in
this repo under the pinned toolchain (`lake env lean`; axiom footprint confirmed
kernel-only). Route: the eigenvalues form a probability vector
(`Matrix.PosSemidef.eigenvalues_nonneg`,
`Matrix.IsHermitian.trace_eq_sum_eigenvalues` with `htr`); the ceiling from
`lambda_i^2 <= lambda_i` (each `lambda_i <= 1`), the floor from the
variance/Cauchy-Schwarz inequality `sum (lambda_i - mean)^2 >= 0`. Clean-room
formalization from the mathematical statement, not copied from external code.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PurityBounds

open Matrix
open scoped ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Purity of a Hermitian matrix, as the sum of squared eigenvalues
(`= Tr(rho^2)` for Hermitian `rho`). -/
def purity (ρ : Matrix n n ℂ) (hρ : ρ.IsHermitian) : ℝ :=
  ∑ i, (hρ.eigenvalues i) ^ 2

/-- **Purity ceiling.**  A density matrix has purity at most `1`
(attained by pure states). -/
theorem purity_le_one (ρ : Matrix n n ℂ)
    (hρ : ρ.IsHermitian) (hpsd : ρ.PosSemidef) (htr : ρ.trace = 1) :
    purity ρ hρ ≤ 1 := by
  have h_sum_eigenvalues : ∑ i, hρ.eigenvalues i = 1 := by
    convert hρ.trace_eq_sum_eigenvalues.symm;
    norm_num [ ← Complex.ofReal_inj, htr ];
  exact h_sum_eigenvalues ▸ Finset.sum_le_sum fun i _ => pow_le_of_le_one ( hpsd.eigenvalues_nonneg i ) ( h_sum_eigenvalues ▸ Finset.single_le_sum ( fun i _ => hpsd.eigenvalues_nonneg i ) ( Finset.mem_univ i ) ) ( by norm_num )

/-- **Purity floor.**  A density matrix on a `d`-dimensional space has purity at
least `1/d` (attained by the maximally-mixed state). -/
theorem inv_card_le_purity [Nonempty n] (ρ : Matrix n n ℂ)
    (hρ : ρ.IsHermitian) (hpsd : ρ.PosSemidef) (htr : ρ.trace = 1) :
    1 / (Fintype.card n : ℝ) ≤ purity ρ hρ := by
  rw [ div_le_iff₀ ( Nat.cast_pos.mpr <| Fintype.card_pos ) ];
  have h_sum_eigenvalues : ∑ i, hρ.eigenvalues i = 1 := by
    convert hρ.trace_eq_sum_eigenvalues using 1;
    norm_num [ ← Complex.ofReal_inj, htr ];
    rw [ eq_comm ];
  have := Finset.univ.sum_le_sum fun i _ => pow_two_nonneg ( hρ.eigenvalues i - ( ∑ j, hρ.eigenvalues j ) / Fintype.card n );
  simp_all +decide [ sub_sq, Finset.sum_add_distrib ];
  simp_all +decide [ ← Finset.mul_sum _ _ _, ← Finset.sum_mul, sq, mul_assoc, ne_of_gt ( Fintype.card_pos ) ];
  rw [ ← div_le_iff₀ ( Nat.cast_pos.mpr <| Fintype.card_pos ) ] ; norm_num [ ← sq, purity ] at * ; nlinarith [ mul_inv_cancel₀ ( show ( Fintype.card n : ℝ ) ≠ 0 by exact Nat.cast_ne_zero.mpr <| ne_of_gt <| Fintype.card_pos ) ] ;

end PhysicsSM.Draft.NullEdge.PurityBounds

-- Axiom-footprint guards (draft-trust by kernel): kernel axioms only, no
-- `native_decide` / `Lean.ofReduceBool`.
/--
info: 'PhysicsSM.Draft.NullEdge.PurityBounds.purity_le_one' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PurityBounds.purity_le_one

/--
info: 'PhysicsSM.Draft.NullEdge.PurityBounds.inv_card_le_purity' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PurityBounds.inv_card_le_purity
