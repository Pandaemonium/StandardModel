/-
# D2 on the T2 witness: the carrier flow is a genuine sector isometry

DRAFT (kernel-clean; no `s o r r y`). Closes the one honestly-flagged open link of
the all-mass dynamics layer (manuscript §9a): `FiniteUnitaryEvolution` proves that
*any* sector isometry (`LinearIsometryEquiv`) conserves norm and energy, but leaves
open that the concrete carrier's time step actually *is* such an isometry.

It is. The carrier sector Hamiltonian is a Hermitian matrix `H` (e.g. the mass-gap
block `MassGapWitness.B lam kappa`), and the flow `exp(-i t H)` it generates is
**unitary** — hence a genuine norm-preserving sector isometry. So
`FiniteUnitaryEvolution` fires on the *actual* carrier, not merely a generic
isometry: the conservation of norm and energy along the real carrier orbit is
kernel-checked.

## Landed theorems (all M, kernel-clean)

- `skewHermitian_neg_I_smul` - the generator `A = -i t H` is skew-Hermitian.
- `hermitian_flow_mem_unitaryGroup` - **core**: `exp(-i t H)` is unitary
  (`∈ Matrix.unitaryGroup`), via `star(exp A) = exp(Aᴴ) = exp(-A)` and
  `exp(-A) * exp(A) = exp 0 = 1`.
- `hermitian_flow_isometry` - the induced map on `EuclideanSpace ℂ n` is a
  `LinearIsometryEquiv` (the sector isometry that plugs into
  `FiniteUnitaryEvolution.norm_conserved_orbit` / `energy_conserved_orbit`).
- `B_flow_unitary` - the specialization to the carrier block
  `MassGapWitness.B lam kappa`.

## Provenance

All-mass solo run 2026-07-08 [orig]. Statements by the reviewing agent (Claude);
the complete proofs are from Aristotle (standalone package
`AgentTasks/aristotle-standalone/allmass-d2-on-t2-20260708`), reviewed for
semantic alignment and adopted here. The core route (`Matrix.unitaryGroup` /
`U * Uᴴ = 1` via `Matrix.exp_conjTranspose` + `exp_add_of_commute`) dodges the
`unitary` monoid-instance diamond that times out on the direct `∈ unitary`
formulation. Instantiates `FiniteUnitaryEvolution` on the `MassGapWitness`
carrier block. Mathlib-only + `MassGapWitness`.
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness

namespace PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow

open Matrix Complex

/-- **Helper.** For a Hermitian `H` and real `t`, the generator
`A := (-(t : ℂ)) • (Complex.I • H)` of the flow `exp(-i t H)` is skew-Hermitian:
`Aᴴ = -A`. -/
theorem skewHermitian_neg_I_smul {n : Type*} [Fintype n] [DecidableEq n]
    {H : Matrix n n ℂ} (hH : H.IsHermitian) (t : ℝ) :
    ((-(t : ℂ)) • (Complex.I • H))ᴴ = -((-(t : ℂ)) • (Complex.I • H)) := by
  rw [conjTranspose_smul, conjTranspose_smul, hH.eq]
  simp [Complex.conj_I]

/-- **Core.** For a Hermitian `H` and real `t`, the Hermitian-generated flow
`exp(-i t H)` is a unitary matrix. This is the load-bearing fact: the carrier's
time step is norm-preserving. -/
theorem hermitian_flow_mem_unitaryGroup {n : Type*} [Fintype n] [DecidableEq n]
    {H : Matrix n n ℂ} (hH : H.IsHermitian) (t : ℝ) :
    NormedSpace.exp ((-(t : ℂ)) • (Complex.I • H)) ∈ Matrix.unitaryGroup n ℂ := by
  set A : Matrix n n ℂ := (-(t : ℂ)) • (Complex.I • H) with hA
  have hskew : Aᴴ = -A := skewHermitian_neg_I_smul hH t
  rw [Matrix.mem_unitaryGroup_iff]
  have hstar : star (NormedSpace.exp A) = NormedSpace.exp (-A) := by
    rw [show star (NormedSpace.exp A) = (NormedSpace.exp A)ᴴ from rfl,
        ← Matrix.exp_conjTranspose, hskew]
  rw [hstar, ← Matrix.exp_add_of_commute A (-A) ((Commute.refl A).neg_right),
      add_neg_cancel, NormedSpace.exp_zero]

/-- **Isometry packaging.** The linear map on `EuclideanSpace ℂ n` induced by the
unitary flow `exp(-i t H)` is a `LinearIsometryEquiv`, i.e. a genuine
norm-preserving sector isometry — the object `FiniteUnitaryEvolution` takes as its
step. -/
noncomputable def hermitian_flow_isometry {n : Type*} [Fintype n] [DecidableEq n]
    {H : Matrix n n ℂ} (hH : H.IsHermitian) (t : ℝ) :
    EuclideanSpace ℂ n ≃ₗᵢ[ℂ] EuclideanSpace ℂ n := by
  set U : Matrix n n ℂ := NormedSpace.exp ((-(t : ℂ)) • (Complex.I • H)) with hU
  have hmem : U ∈ Matrix.unitaryGroup n ℂ := hermitian_flow_mem_unitaryGroup hH t
  have h1 : U * Uᴴ = 1 := Matrix.mem_unitaryGroup_iff.mp hmem
  have h2 : Uᴴ * U = 1 := Matrix.mem_unitaryGroup_iff'.mp hmem
  have hmul : ∀ P Q : Matrix n n ℂ,
      (P * Q).toEuclideanLin = P.toEuclideanLin ∘ₗ Q.toEuclideanLin := by
    intro P Q; ext x i; simp [Matrix.mulVec_mulVec]
  have hone : (1 : Matrix n n ℂ).toEuclideanLin = LinearMap.id := by
    ext x i; simp
  refine LinearEquiv.isometryOfInner
    (LinearEquiv.ofLinear U.toEuclideanLin Uᴴ.toEuclideanLin ?_ ?_) ?_
  · rw [← hmul, h1, hone]
  · rw [← hmul, h2, hone]
  · intro x y
    show inner ℂ (U.toEuclideanLin x) (U.toEuclideanLin y) = inner ℂ x y
    rw [← LinearMap.adjoint_inner_right, ← Matrix.toEuclideanLin_conjTranspose_eq_adjoint,
        ← LinearMap.comp_apply, ← hmul, h2, hone]
    rfl

/-- **Specialization.** The carrier block `MassGapWitness.B lam kappa` generates a
unitary flow: the T2 carrier's time step is a genuine sector isometry, so
`FiniteUnitaryEvolution` fires on the actual carrier. -/
theorem B_flow_unitary (lam kappa t : ℝ) :
    NormedSpace.exp ((-(t : ℂ)) • (Complex.I • MassGapWitness.B lam kappa))
      ∈ Matrix.unitaryGroup (Fin 3) ℂ :=
  hermitian_flow_mem_unitaryGroup (MassGapWitness.B_isHermitian lam kappa) t

end PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow
