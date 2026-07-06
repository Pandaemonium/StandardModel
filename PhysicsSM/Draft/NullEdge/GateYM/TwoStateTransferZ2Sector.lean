import PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2L1

/-!
# Gate YM: honest center-sector flux-gap witness for the one-link Z2 slab

This draft module sharpens the finite-gap witness pathway for the one-link Z2
Wilson slab (`TwoStateTransferZ2L1`).  The existing
`TwoStateTransferZ2L1.spectralWitness` fills the abstract
`FiniteGapAssembly.FiniteGapSpectralWitness` interface, but it does so through
`TwoStateTransferSpectrum.topCyclicityPrereq`: the *whole* two-state space as
the sector and the *full* endomorphism algebra as the local algebra.  That is a
toy filler.  It also silently labels the resulting gap `localGap`
(`FluxSectorZ2.localGlueballGap`), the *within-trivial-flux-sector*
local/glueball gap.

The physical content of the one-link Z2 model is different and is made explicit
here:

* the transfer vacuum `(1, 1)` lives in the `+1` center sector
  (`centerPlusProjector` fixes it);
* the flux excitation `(1, -1)` lives in the `-1` center sector
  (`centerMinusProjector` fixes it);
* the two sectors are genuinely distinct one-dimensional eigenspaces of the
  transfer operator, both preserved by it, and their intersection is trivial;
* the separation between them is therefore a **center-flux gap**
  (`FluxSectorZ2.fluxGap`), not a local/glueball gap
  (`FluxSectorZ2.localGlueballGap`).

We package this as an honest `FiniteFluxGapWitness` structure in which sector
preservation and sector membership are *explicit hypothesis fields*, and we
instantiate it from the exact one-link Z2 slab kernel.  This does **not**
construct the full Wilson slab transfer operator, Gauss projection, OS/GNS
Hilbert space, Hamiltonian, infinite-volume state, cyclicity of a genuine local
plaquette algebra, or a physical mass-gap theorem.

The final section records, as kernel-checked lemmas, the exact obstruction to a
genuine single-sector `FiniteGapSpectralWitness`: on each one-dimensional center
sector the transfer acts as a single scalar, so there is no within-sector
excitation, hence no honest local/glueball eigenvalue pair inside one physical
sector of this model.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: finite identity / honest center-sector flux-gap bridge.
-/

noncomputable section

open scoped BigOperators Matrix

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TwoStateTransferZ2Sector

open TwoStateTransferSpectrum
open TwoStateTransferZ2L1

/-- Honest finite two-sector flux-gap witness.

Unlike `FiniteGapAssembly.FiniteGapSpectralWitness`, this structure keeps the
vacuum and the excitation in **distinct** preserved sectors: the gap it exposes
is the center-flux gap between two sector eigenvalues, not a within-sector
local/glueball gap.  Sector preservation, sector membership, and sector
disjointness are all explicit hypothesis fields, so a later consumer cannot
smuggle in a single-sector local-gap claim. -/
structure FiniteFluxGapWitness (H : Type*) [AddCommGroup H] [Module ℂ H] where
  /-- The finite transfer endomorphism. -/
  transfer : Module.End ℂ H
  /-- The vacuum (leading) center sector. -/
  vacuumSector : Submodule ℂ H
  /-- The flux (subleading) center sector. -/
  fluxSector : Submodule ℂ H
  /-- Named leading eigenvalue in the vacuum sector. -/
  lambda0 : ℝ
  /-- Named subleading eigenvalue in the flux sector. -/
  lambdaFlux : ℝ
  /-- The leading eigenvalue is positive. -/
  lambda0_pos : 0 < lambda0
  /-- The flux eigenvalue is positive. -/
  lambdaFlux_pos : 0 < lambdaFlux
  /-- Strict flux separation below the vacuum eigenvalue. -/
  lambdaFlux_lt_lambda0 : lambdaFlux < lambda0
  /-- The transfer preserves the vacuum sector. -/
  transfer_preserves_vacuumSector :
    ∀ v ∈ vacuumSector, transfer v ∈ vacuumSector
  /-- The transfer preserves the flux sector. -/
  transfer_preserves_fluxSector :
    ∀ v ∈ fluxSector, transfer v ∈ fluxSector
  /-- The vacuum vector. -/
  vacuum : H
  /-- The vacuum lies in the vacuum sector. -/
  vacuum_mem : vacuum ∈ vacuumSector
  /-- The vacuum is nonzero. -/
  vacuum_ne_zero : vacuum ≠ 0
  /-- Vacuum eigenvector equation with the leading eigenvalue. -/
  vacuum_eigen : transfer vacuum = (lambda0 : ℂ) • vacuum
  /-- The flux excitation vector. -/
  fluxExcitation : H
  /-- The flux excitation lies in the flux sector. -/
  fluxExcitation_mem : fluxExcitation ∈ fluxSector
  /-- The flux excitation is nonzero. -/
  fluxExcitation_ne_zero : fluxExcitation ≠ 0
  /-- Flux eigenvector equation with the subleading eigenvalue. -/
  fluxExcitation_eigen :
    transfer fluxExcitation = (lambdaFlux : ℂ) • fluxExcitation
  /-- The two center sectors are genuinely distinct: their intersection is
  trivial. -/
  sectors_disjoint : vacuumSector ⊓ fluxSector = ⊥

namespace FiniteFluxGapWitness

variable {H : Type*} [AddCommGroup H] [Module ℂ H]

/-- The center-flux gap exposed by the witness.  This is
`FluxSectorZ2.fluxGap`, the winding/center-flux separation, **not** the
local/glueball gap. -/
def fluxGap (W : FiniteFluxGapWitness H) : ℝ :=
  FluxSectorZ2.fluxGap W.lambda0 W.lambdaFlux

/-- The exposed gap is the D12 finite spectral-ratio convention applied to the
two center-sector eigenvalues. -/
theorem fluxGap_eq_finiteMassGap (W : FiniteFluxGapWitness H) :
    W.fluxGap =
      TransferGapDefinition.finiteMassGap W.lambda0 W.lambdaFlux :=
  FluxSectorZ2.fluxGap_eq_finiteMassGap W.lambda0 W.lambdaFlux

/-- The center-flux gap is strictly positive under the strict spectral
separation hypothesis. -/
theorem fluxGap_pos (W : FiniteFluxGapWitness H) : 0 < W.fluxGap := by
  rw [fluxGap_eq_finiteMassGap]
  exact TransferGapDefinition.finiteMassGap_pos
    W.lambda0_pos W.lambdaFlux_pos W.lambdaFlux_lt_lambda0

/-- The center-flux gap is nonnegative. -/
theorem fluxGap_nonneg (W : FiniteFluxGapWitness H) : 0 ≤ W.fluxGap :=
  W.fluxGap_pos.le

/-- The transfer image of the vacuum stays in the vacuum sector. -/
theorem transfer_vacuum_mem_vacuumSector (W : FiniteFluxGapWitness H) :
    W.transfer W.vacuum ∈ W.vacuumSector :=
  W.transfer_preserves_vacuumSector W.vacuum W.vacuum_mem

/-- The transfer image of the flux excitation stays in the flux sector. -/
theorem transfer_fluxExcitation_mem_fluxSector (W : FiniteFluxGapWitness H) :
    W.transfer W.fluxExcitation ∈ W.fluxSector :=
  W.transfer_preserves_fluxSector W.fluxExcitation W.fluxExcitation_mem

/-- The vacuum and flux excitation are distinct vectors, because they live in
sectors whose intersection is trivial and both are nonzero. -/
theorem fluxExcitation_ne_vacuum (W : FiniteFluxGapWitness H) :
    W.fluxExcitation ≠ W.vacuum := by
  intro h
  have hmem : W.vacuum ∈ W.vacuumSector ⊓ W.fluxSector :=
    ⟨W.vacuum_mem, h ▸ W.fluxExcitation_mem⟩
  rw [W.sectors_disjoint] at hmem
  exact W.vacuum_ne_zero (Submodule.mem_bot ℂ |>.1 hmem)

/-- The contraction factor `exp (-fluxGap)` recovers the flux/vacuum eigenvalue
ratio. -/
theorem exp_neg_fluxGap_eq_ratio (W : FiniteFluxGapWitness H) :
    Real.exp (-W.fluxGap) = W.lambdaFlux / W.lambda0 := by
  rw [fluxGap_eq_finiteMassGap]
  unfold TransferGapDefinition.finiteMassGap
  rw [neg_neg, Real.exp_log (div_pos W.lambdaFlux_pos W.lambda0_pos)]

end FiniteFluxGapWitness

/-! ## Honest instantiation from the one-link Z2 slab -/

/-- The concrete one-link state space. -/
abbrev State : Type := TwoStateTransferSpectrum.State

/-- The one-link transfer endomorphism, as a linear map. -/
def transferEnd (beta : ℝ) : Module.End ℂ State :=
  (slabTransfer beta).mulVecLin

/-- The `+1` center sector, spanned by the vacuum vector `(1, 1)`. -/
def vacuumCenterSector : Submodule ℂ State :=
  Submodule.span ℂ {(vacuumVec : State)}

/-- The `-1` center sector, spanned by the flux vector `(1, -1)`. -/
def fluxCenterSector : Submodule ℂ State :=
  Submodule.span ℂ {(localVec : State)}

/-- The one-link vacuum eigenvalue branch `2 (exp β + exp (-β))`. -/
def lambda0 (beta : ℝ) : ℝ :=
  2 * (Real.exp beta + Real.exp (-beta))

/-- The one-link flux eigenvalue branch `2 (exp β - exp (-β))`. -/
def lambdaFlux (beta : ℝ) : ℝ :=
  2 * (Real.exp beta - Real.exp (-beta))

theorem transferEnd_vacuum (beta : ℝ) :
    transferEnd beta vacuumVec = (lambda0 beta : ℂ) • vacuumVec := by
  rw [transferEnd, Matrix.mulVecLin_apply, slabTransfer_mulVec_vacuum]
  rfl

theorem transferEnd_local (beta : ℝ) :
    transferEnd beta localVec = (lambdaFlux beta : ℂ) • localVec := by
  rw [transferEnd, Matrix.mulVecLin_apply, slabTransfer_mulVec_local]
  rfl

theorem lambda0_pos (beta : ℝ) : 0 < lambda0 beta := by
  unfold lambda0
  have := add_pos (Real.exp_pos beta) (Real.exp_pos (-beta))
  linarith

theorem lambdaFlux_pos {beta : ℝ} (hbeta : 0 < beta) : 0 < lambdaFlux beta := by
  unfold lambdaFlux
  have h : Real.exp (-beta) < Real.exp beta :=
    Real.exp_lt_exp.mpr (by linarith)
  linarith

theorem lambdaFlux_lt_lambda0 (beta : ℝ) : lambdaFlux beta < lambda0 beta := by
  unfold lambdaFlux lambda0
  have h : 0 < Real.exp (-beta) := Real.exp_pos _
  linarith

theorem transfer_preserves_vacuumCenterSector (beta : ℝ) :
    ∀ v ∈ vacuumCenterSector, transferEnd beta v ∈ vacuumCenterSector := by
  intro v hv
  rw [vacuumCenterSector, Submodule.mem_span_singleton] at hv ⊢
  obtain ⟨a, rfl⟩ := hv
  refine ⟨a * (lambda0 beta : ℂ), ?_⟩
  rw [map_smul, transferEnd_vacuum, smul_smul]

theorem transfer_preserves_fluxCenterSector (beta : ℝ) :
    ∀ v ∈ fluxCenterSector, transferEnd beta v ∈ fluxCenterSector := by
  intro v hv
  rw [fluxCenterSector, Submodule.mem_span_singleton] at hv ⊢
  obtain ⟨a, rfl⟩ := hv
  refine ⟨a * (lambdaFlux beta : ℂ), ?_⟩
  rw [map_smul, transferEnd_local, smul_smul]

theorem centerSectors_disjoint :
    vacuumCenterSector ⊓ fluxCenterSector = ⊥ := by
  rw [Submodule.eq_bot_iff]
  intro x hx
  simp only [Submodule.mem_inf, vacuumCenterSector, fluxCenterSector,
    Submodule.mem_span_singleton] at hx
  obtain ⟨⟨a, ha⟩, ⟨b, hb⟩⟩ := hx
  have h0 := congrFun (ha.trans hb.symm) 0
  have h1 := congrFun (ha.trans hb.symm) 1
  simp [vacuumVec, localVec] at h0 h1
  have hb0 : b = 0 := by linear_combination (h1 - h0) / 2
  rw [← ha, h0, hb0, zero_smul]

/-- The honest one-link Z2 center-sector flux-gap witness.

Every field carries genuine one-link Z2 physical content: the two sectors are
distinct one-dimensional center-charge eigenspaces, the transfer preserves each,
and the vacuum/flux eigenvectors are the exact `(1, 1)` and `(1, -1)` states
with the exact slab eigenvalues.  It is not a whole-space toy filler. -/
def fluxGapWitness (beta : ℝ) (hbeta : 0 < beta) :
    FiniteFluxGapWitness State where
  transfer := transferEnd beta
  vacuumSector := vacuumCenterSector
  fluxSector := fluxCenterSector
  lambda0 := lambda0 beta
  lambdaFlux := lambdaFlux beta
  lambda0_pos := lambda0_pos beta
  lambdaFlux_pos := lambdaFlux_pos hbeta
  lambdaFlux_lt_lambda0 := lambdaFlux_lt_lambda0 beta
  transfer_preserves_vacuumSector := transfer_preserves_vacuumCenterSector beta
  transfer_preserves_fluxSector := transfer_preserves_fluxCenterSector beta
  vacuum := vacuumVec
  vacuum_mem := Submodule.mem_span_singleton_self _
  vacuum_ne_zero := vacuumVec_ne_zero
  vacuum_eigen := transferEnd_vacuum beta
  fluxExcitation := localVec
  fluxExcitation_mem := Submodule.mem_span_singleton_self _
  fluxExcitation_ne_zero := localVec_ne_zero
  fluxExcitation_eigen := transferEnd_local beta
  sectors_disjoint := centerSectors_disjoint

/-- The one-link witness exposes a strictly positive center-flux gap. -/
theorem fluxGapWitness_gap_pos (beta : ℝ) (hbeta : 0 < beta) :
    0 < (fluxGapWitness beta hbeta).fluxGap :=
  (fluxGapWitness beta hbeta).fluxGap_pos

/-- The one-link witness center-flux gap contraction factor is `tanh β`.

This is the honest tie-back to the one-link oracle: the same `tanh β`
contraction factor that `TwoStateTransferZ2L1.spectralWitness_exp_neg_gap_eq_tanh`
records, but now attached to a genuine two-center-sector structure rather than a
whole-space toy sector. -/
theorem fluxGapWitness_exp_neg_gap_eq_tanh (beta : ℝ) (hbeta : 0 < beta) :
    Real.exp (-(fluxGapWitness beta hbeta).fluxGap) = Real.tanh beta := by
  rw [(fluxGapWitness beta hbeta).exp_neg_fluxGap_eq_ratio]
  show lambdaFlux beta / lambda0 beta = Real.tanh beta
  rw [Real.tanh_eq]
  unfold lambdaFlux lambda0
  have hsum : Real.exp beta + Real.exp (-beta) ≠ 0 :=
    ne_of_gt (add_pos (Real.exp_pos beta) (Real.exp_pos (-beta)))
  field_simp

/-! ## The exact obstruction to a single-sector local/glueball witness

The abstract `FiniteGapAssembly.FiniteGapSpectralWitness` demands that the
vacuum and the excitation both lie in **one** sector (`vacuum_mem_sector` and
`localExcitation_mem_sector` reference the *same* `prereq.sector`).  In the
one-link Z2 model the honest physical sectors are the two one-dimensional center
sectors, and on each of them the transfer is a single scalar.  The following
lemmas make that precise: there is no within-sector eigenvalue pair, so no
honest local/glueball gap can be witnessed inside one physical sector. -/

/-- On the vacuum center sector the transfer acts as the single scalar
`lambda0`: every vector of the sector is a `lambda0`-eigenvector. -/
theorem transfer_scalar_on_vacuumSector (beta : ℝ) :
    ∀ v ∈ vacuumCenterSector,
      transferEnd beta v = (lambda0 beta : ℂ) • v := by
  intro v hv
  rw [vacuumCenterSector, Submodule.mem_span_singleton] at hv
  obtain ⟨a, rfl⟩ := hv
  rw [map_smul, transferEnd_vacuum, smul_comm]

/-- On the flux center sector the transfer acts as the single scalar
`lambdaFlux`: every vector of the sector is a `lambdaFlux`-eigenvector. -/
theorem transfer_scalar_on_fluxSector (beta : ℝ) :
    ∀ v ∈ fluxCenterSector,
      transferEnd beta v = (lambdaFlux beta : ℂ) • v := by
  intro v hv
  rw [fluxCenterSector, Submodule.mem_span_singleton] at hv
  obtain ⟨a, rfl⟩ := hv
  rw [map_smul, transferEnd_local, smul_comm]

/-- **Obstruction lemma.**  Inside a single center sector there is no honest
local/glueball eigenvalue pair: any two eigenvalues realised by nonzero vectors
of the vacuum sector coincide.  Hence a genuine single-sector
`FiniteGapSpectralWitness` (which needs two *distinct* eigenvalues on one
sector) cannot be instantiated from this physical sector; the only nonzero gap
available is the cross-sector flux gap of `fluxGapWitness`. -/
theorem no_local_gap_in_vacuumSector (beta : ℝ)
    {v w : State} {mu nu : ℂ}
    (hv : v ∈ vacuumCenterSector) (hvne : v ≠ 0)
    (hw : w ∈ vacuumCenterSector) (hwne : w ≠ 0)
    (hveig : transferEnd beta v = mu • v)
    (hweig : transferEnd beta w = nu • w) :
    mu = nu := by
  have hv' := transfer_scalar_on_vacuumSector beta v hv
  have hw' := transfer_scalar_on_vacuumSector beta w hw
  have hmu : mu • v = (lambda0 beta : ℂ) • v := by rw [← hveig, hv']
  have hnu : nu • w = (lambda0 beta : ℂ) • w := by rw [← hweig, hw']
  have hmu' : mu = (lambda0 beta : ℂ) := by
    have := sub_eq_zero.mpr hmu
    rw [← sub_smul] at this
    rcases smul_eq_zero.1 this with h | h
    · exact sub_eq_zero.1 h
    · exact absurd h hvne
  have hnu' : nu = (lambda0 beta : ℂ) := by
    have := sub_eq_zero.mpr hnu
    rw [← sub_smul] at this
    rcases smul_eq_zero.1 this with h | h
    · exact sub_eq_zero.1 h
    · exact absurd h hwne
  exact hmu'.trans hnu'.symm

end TwoStateTransferZ2Sector
end GateYM
end NullEdge
end Draft
end PhysicsSM
