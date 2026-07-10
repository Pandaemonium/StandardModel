/-
# D2 on the T2 witness: the carrier flow is a genuine sector isometry

DRAFT (kernel-clean; no `s o r r y`). This partially addresses the open dynamics
link of §9a: `FiniteUnitaryEvolution` proves *any* sector isometry
(`LinearIsometryEquiv`) conserves norm and energy; here we exhibit a concrete
isometry from the mass block. **What is kernel-checked (state it exactly):** for
the *positive-definite* Hilbert space `EuclideanSpace ℂ n`, the flow `exp(-i t H)`
of *any* Hermitian matrix `H` is **Euclidean-unitary**, hence a norm-preserving
isometry with norm/energy-conserving orbit; instantiated at the mass block
`MassGapWitness.B lam kappa`. The only block-specific input is `B_isHermitian` —
"B is Hermitian" — so this is honestly *a generic linear-algebra fact instantiated
at B*, not (yet) a property of the carrier's physical evolution.

**Three grade caveats (per the 2026-07-08 flagship audit — do not over-read this
as "the carrier's time evolution"):**
- *(0) Euclidean ≠ Krein evolution.* The carrier lives in a *Krein* (indefinite
  `J`) space; its physical evolution is `J`-unitary and generically *mixes* the
  `J=±1` sectors. Euclidean-unitarity here coincides with `J`-unitarity only *after*
  restricting to the `J`-positive sector (where `Pisoᴴ J Piso = 1`,
  `sector_krein_form_eq_one`) — and *that the Krein flow preserves that sector is
  not proved here*. So this is norm-unitarity on a first-quantized Euclidean
  sector, not the certified Krein evolution.
- *The generator is a posit (grade C).* `B` (= `Q_A + Q_C`, §4) is the compressed
  squared-mass / energy *form*, not a Hamiltonian derived from the D1 action
  (D1 yields the constraint `Dψ = 0`, not a Schrödinger equation). Taking the
  sector mass form as the generator of a one-parameter flow is a *canonical
  modeling choice* (Stueckelberg-style proper-time evolution), defensible but
  chosen, not derived. What is kernel-checked is the unitarity/isometry of
  `exp(-i t H)` for Hermitian `H`; that this flow *is* the carrier's physical time
  evolution is grade **C**.
- *The carrier tie is `(2,1)`-kernel.* `B(λ,κ)` is the carrier's compressed sector
  form kernel-checked only at `(λ,κ) = (2,1)` (via `MassGapWitness.M6_topBlock_eq_B`);
  at general `(λ,κ)` the identification is oracle-grade (`carrier_spectrum_sim.py`).
  So `carrierFlowStep`/`B_flow_unitary` are honest unitary flows of the *block*
  `B(λ,κ)` for all `(λ,κ)`, but "the flow of the *carrier*" is kernel-earned at
  `(2,1)`.

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
import PhysicsSM.Draft.NullEdge.Carrier.FiniteUnitaryEvolution

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

/-- The flow step generated by the mass-gap block `B lam kappa`, as a
`LinearIsometryEquiv` on the sector Hilbert space `EuclideanSpace ℂ (Fin 3)` —
the concrete transfer step `FiniteUnitaryEvolution` takes. (Carrier tie:
kernel-checked at `(λ,κ) = (2,1)`, oracle-grade off it; generator-as-Hamiltonian
is a grade-C posit — see the module docstring.) -/
noncomputable def carrierFlowStep (lam kappa t : ℝ) :
    EuclideanSpace ℂ (Fin 3) ≃ₗᵢ[ℂ] EuclideanSpace ℂ (Fin 3) :=
  hermitian_flow_isometry (MassGapWitness.B_isHermitian lam kappa) t

/-- **D2/D3 fired on the actual carrier — norm.** The discrete time-evolution
orbit of the concrete T2 carrier (generated by the mass-gap block flow) conserves
the sector norm. This is `FiniteUnitaryEvolution.norm_conserved_orbit` instantiated
on the real carrier step, not a generic isometry: the open §9a link, now a
single kernel theorem. -/
theorem carrier_orbit_norm_conserved (lam kappa t : ℝ)
    (psi : EuclideanSpace ℂ (Fin 3)) (n : ℕ) :
    ‖FiniteUnitaryEvolution.orbit (carrierFlowStep lam kappa t) psi n‖ = ‖psi‖ :=
  FiniteUnitaryEvolution.norm_conserved_orbit _ psi n

/-- **D2/D3 fired on the actual carrier — commuting-observable invariance.** Any
observable that commutes with the carrier flow step has conserved real expectation
along the carrier orbit. Scope (batch-6 audit): this is the standard unitary
invariance `⟨Uψ, E Uψ⟩ = ⟨ψ, E ψ⟩` for an observable `E` *already assumed* to
commute with the step (`CommutesWithStep`); the "energy" naming is decorative — it
does not derive a Hamiltonian or a nontrivial constant of motion (the generator
`H` is conserved only via the triviality `[H, exp(-i t H)] = 0`). -/
theorem carrier_orbit_energy_conserved (lam kappa t : ℝ)
    (E : EuclideanSpace ℂ (Fin 3) →L[ℂ] EuclideanSpace ℂ (Fin 3))
    (hUE : FiniteUnitaryEvolution.CommutesWithStep (carrierFlowStep lam kappa t) E)
    (psi : EuclideanSpace ℂ (Fin 3)) (n : ℕ) :
    FiniteUnitaryEvolution.observableEnergy E (FiniteUnitaryEvolution.orbit
      (carrierFlowStep lam kappa t) psi n) = FiniteUnitaryEvolution.observableEnergy E psi :=
  FiniteUnitaryEvolution.energy_conserved_orbit _ E hUE psi n

/-- The flow step of the **full `6×6` physical sector form** `M6` (the actual
carrier compression `Pisoᴴ HAC Piso`, `= B(2,1) ⊕ B(2,-1)` by the bridge), as a
`LinearIsometryEquiv`. This is the honest "carrier sector evolution" object: `M6`
is the real physical sector form (not just the `3×3` block), kernel-tied to the
carrier at the fixed point. `M6` is Hermitian via `M6_posDef`. -/
noncomputable def carrierFlowStep6 (t : ℝ) :
    EuclideanSpace ℂ (Fin 6) ≃ₗᵢ[ℂ] EuclideanSpace ℂ (Fin 6) :=
  hermitian_flow_isometry SectorGroundMassWitness.M6_posDef.1 t

/-- **The full carrier sector orbit conserves norm.** The discrete Euclidean-unitary
evolution generated by the `6×6` sector form `M6` conserves the sector norm (the
`6×6` sector form, not just the `3×3` block). Scope (batch-6 audit): the generator
is `M6` under the grade-**C** "generator-as-Hamiltonian" posit, and that the
*Krein* flow preserves this sector is open (`sector_krein_form_eq_one` is only the
static metric identity) — so "the concrete carrier's actual sector evolution" is
the Euclidean-unitary model, not the certified physical Krein evolution. -/
theorem carrier6_orbit_norm_conserved (t : ℝ)
    (psi : EuclideanSpace ℂ (Fin 6)) (n : ℕ) :
    ‖FiniteUnitaryEvolution.orbit (carrierFlowStep6 t) psi n‖ = ‖psi‖ :=
  FiniteUnitaryEvolution.norm_conserved_orbit _ psi n

end PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow
