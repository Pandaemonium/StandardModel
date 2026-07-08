/-
# Fire D2 on the T2 witness: the carrier flow is a genuine sector isometry

Proof job (Aristotle). Mathlib-only. This closes the one honestly-flagged open
link of the all-mass dynamics layer (manuscript §9a): the finite unitary-evolution
scaffold `FiniteUnitaryEvolution` proves that *any* sector isometry
(`LinearIsometryEquiv`) conserves norm and energy, but leaves open that the
concrete carrier's time step actually *is* such an isometry. It is: the carrier
sector Hamiltonian is a Hermitian matrix `H`, and the flow `exp(-i t H)` is
unitary, hence norm-preserving.

## Background object (kernel-clean already in the project)

The carrier sector mass block (from `MassGapWitness`, landed + guard-pinned):

  B(lam, kappa) = !![lam, kappa*I, 0; -kappa*I, lam, 0; 0, 0, lam]

is Hermitian. At the fixed point `(2,1)` it is the actual carrier compression's
top block (`M6 = B(2,1) (+) B(2,-1)`, kernel-checked). We only need Hermiticity.

## Targets (prove kernel-clean, no `sorry`)

Work over `Matrix (Fin n) (Fin n) ℂ` (or specialize to `Fin 3`); `t : ℝ`.

- **`skewHermitian_neg_I_smul`** (helper): for `H.IsHermitian`, the matrix
  `A := (-(t : ℂ)) • (Complex.I • H)` satisfies `Aᴴ = -A` (skew-Hermitian).
- **`hermitian_flow_mem_unitaryGroup`** (core): for `H.IsHermitian` and `t : ℝ`,
  `Matrix.exp ℂ ((-(t : ℂ)) • (Complex.I • H)) ∈ Matrix.unitaryGroup (Fin n) ℂ`.
  (Route: `exp A` with `A` skew-Hermitian is unitary — `(exp A)ᴴ * exp A =
  exp Aᴴ * exp A = exp (-A) * exp A = exp (-A + A) = exp 0 = 1`, using that `A`
  and `Aᴴ` commute, `Matrix.exp_conjTranspose`, `Matrix.exp_add_of_commute`,
  `Matrix.exp_zero`; and symmetrically on the other side.)
- **`hermitian_flow_isometry`** (the instantiation): the linear map on
  `EuclideanSpace ℂ (Fin n)` induced by `exp((-(t:ℂ)) • (I • H))` is a
  `LinearIsometryEquiv` (via `Matrix.unitaryGroup` -> unitary -> norm-preserving,
  e.g. `Matrix.toEuclideanLin` / `Matrix.toLin'` + `unitary` isometry API,
  whichever Mathlib exposes cleanly). Deliver this as far as Mathlib's
  matrix<->EuclideanSpace isometry API cleanly allows; the core unitarity
  (`hermitian_flow_mem_unitaryGroup`) is the must-have.
- **`B_flow_unitary`** (specialization): the `(2,1)` (or general `B lam kappa`)
  carrier flow is unitary — instantiate the core on the concrete Hermitian block
  `B` below.

Deliver `hermitian_flow_mem_unitaryGroup` for certain (that alone closes the
"the carrier step is unitary" link at the matrix level); the `LinearIsometryEquiv`
packaging as far as the API cleanly allows. Report semantic alignment: the
load-bearing content is "the carrier's Hermitian-generated flow is norm-preserving
(a genuine sector isometry), so `FiniteUnitaryEvolution` fires on the real
carrier, not just a generic isometry."

Run `lake env lean AllMassD2/Core.lean` (Mathlib-only). Commit + push.

Provenance: all-mass solo run 2026-07-08; instantiates `FiniteUnitaryEvolution`
on the `MassGapWitness` carrier block. [orig].
-/

import Mathlib

namespace AllMassD2

open Matrix Complex

open scoped ComplexOrder

/-- The carrier sector mass block (Hermitian); only Hermiticity is used here. -/
noncomputable def B (lam kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![(lam : ℂ), (kappa : ℂ) * Complex.I, 0;
     -((kappa : ℂ) * Complex.I), (lam : ℂ), 0;
     0, 0, (lam : ℂ)]

theorem B_isHermitian (lam kappa : ℝ) : (B lam kappa).IsHermitian := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp +decide [ B ]

/-- Placeholder so the Mathlib-only package is valid. Replace with the targets in
the module docstring: `skewHermitian_neg_I_smul`, `hermitian_flow_mem_unitaryGroup`,
`hermitian_flow_isometry`, `B_flow_unitary`. -/
theorem package_ok : True := trivial

end AllMassD2
