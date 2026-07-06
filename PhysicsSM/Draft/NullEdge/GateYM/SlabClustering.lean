import PhysicsSM.Draft.NullEdge.GateYM.OSReconstruction
import PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2Sector

/-!
# Gate YM / NE-U4: exponential clustering from the OS spectral gap on the Z2 slab

This module supplies the **missing clustering link** between the finite NE-U4
center-sector spectral gap (`SlabTransferGap.neU4_closure_gap_pos`,
`OSReconstruction.osSpectralGap_pos`) and the Faizal–Shabir (arXiv 2606.19362)
clustering step: it turns the additive Hamiltonian gap `gap = osSpectralGap` into
**exponential decay of the connected two-point function** of the transfer
operator.

## Setup (exactly solvable one-link Z2 slab)

The Z2 slab transfer matrix `TwoStateTransferZ2L1.slabTransfer beta` on
`State = Fin 2 → ℂ` has the exact eigenstructure

* vacuum `vacuumVec = (1, 1)` with eigenvalue `lam0 = 2 (e^β + e^{-β})`
  (`TwoStateTransferZ2Sector.lambda0`);
* flux `localVec = (1, -1)` with eigenvalue
  `lamFlux = 2 (e^β - e^{-β})` (`TwoStateTransferZ2Sector.lambdaFlux`),

with `0 < lamFlux < lam0`.  We normalise the transfer by its top eigenvalue,
`slabNormTransfer beta = lam0⁻¹ • slabTransfer beta`, so that the vacuum becomes a
fixed point (eigenvalue `1`) and the flux sector contracts by the ratio
`ratio = lamFlux / lam0 = tanh β = exp(-gap)`.

## Deliverables

* `slab_connected_correlation_eq` — the **exact** connected correlation identity
  for the normalised transfer:
  `⟪v, T̂ⁿ w⟫ - ⟪v,Ω⟫⟪Ω,w⟫ = ratioⁿ · ⟪v, flux⟫⟪flux, w⟫ / 2`,
  where the disconnected term subtracts the (unnormalised) vacuum contribution
  `⟪v, vac⟫⟪vac, w⟫ / 2` (note `⟪vac,vac⟫ = 2`).
* `slab_connected_correlation_decay` — the geometric bound
  `‖connected‖ ≤ C · ratioⁿ` with `C = ‖⟪v,flux⟫⟪flux,w⟫ / 2‖`.
* `slab_exponential_clustering` — the same bound rewritten in the Faizal–Shabir
  clustering form `‖connected‖ ≤ C · exp(-(n · gap))` with
  `gap = OSReconstruction.osSpectralGap`.

Everything is a finite, kernel-checked identity on the exactly solvable Z2 slab;
no continuum/physical mass gap is claimed.  Draft-trust: no `s o r r y`, no
`n a t i v e _ d e c i d e`, standard axioms only.
-/

noncomputable section

open scoped BigOperators Matrix

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace SlabClustering

open Matrix
open TwoStateTransferSpectrum
open TwoStateTransferZ2L1

/-! ## General eigenvector-power helper -/

/-- If `v` is an eigenvector of `A` with eigenvalue `c`, then it is an
eigenvector of `Aⁿ` with eigenvalue `cⁿ`. -/
theorem pow_mulVec_eigen {I : Type*} [Fintype I] [DecidableEq I]
    {A : Matrix I I ℂ} {v : I → ℂ} {c : ℂ} (h : A *ᵥ v = c • v) :
    ∀ n : ℕ, A ^ n *ᵥ v = c ^ n • v
  | 0 => by simp [Matrix.one_mulVec]
  | n + 1 => by
      rw [pow_succ, ← Matrix.mulVec_mulVec, h, Matrix.mulVec_smul,
        pow_mulVec_eigen h n, smul_smul, ← pow_succ']

/-! ## The vacuum-normalised Z2 slab transfer operator -/

/-- The top (vacuum) eigenvalue `lam0 = 2 (e^β + e^{-β})`. -/
abbrev lam0 (beta : ℝ) : ℝ := TwoStateTransferZ2Sector.lambda0 beta

/-- The flux eigenvalue `lamFlux = 2 (e^β - e^{-β})`. -/
abbrev lamFlux (beta : ℝ) : ℝ := TwoStateTransferZ2Sector.lambdaFlux beta

/-- The flux/vacuum contraction ratio `lamFlux / lam0` (`= tanh β = exp(-gap)`). -/
def ratio (beta : ℝ) : ℝ := lamFlux beta / lam0 beta

theorem lam0_pos (beta : ℝ) : 0 < lam0 beta :=
  TwoStateTransferZ2Sector.lambda0_pos beta

theorem lamFlux_pos {beta : ℝ} (hbeta : 0 < beta) : 0 < lamFlux beta :=
  TwoStateTransferZ2Sector.lambdaFlux_pos hbeta

theorem ratio_pos {beta : ℝ} (hbeta : 0 < beta) : 0 < ratio beta :=
  div_pos (lamFlux_pos hbeta) (lam0_pos beta)

theorem ratio_nonneg {beta : ℝ} (hbeta : 0 < beta) : 0 ≤ ratio beta :=
  (ratio_pos hbeta).le

/-- The vacuum-normalised transfer matrix `lam0⁻¹ • slabTransfer beta`. -/
def slabNormTransfer (beta : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  ((lam0 beta : ℝ) : ℂ)⁻¹ • slabTransfer beta

/-- The vacuum is a fixed point of the normalised transfer (eigenvalue `1`). -/
theorem slabNormTransfer_mulVec_vacuum (beta : ℝ) :
    slabNormTransfer beta *ᵥ vacuumVec = (1 : ℂ) • vacuumVec := by
  unfold slabNormTransfer
  rw [smul_mulVec,
    show slabTransfer beta *ᵥ vacuumVec
        = ((lam0 beta : ℝ) : ℂ) • vacuumVec from
      TwoStateTransferZ2L1.slabTransfer_mulVec_vacuum beta,
    smul_smul]
  congr 1
  rw [inv_mul_cancel₀]
  exact_mod_cast ne_of_gt (lam0_pos beta)

/-- The flux vector contracts by `ratio` under the normalised transfer. -/
theorem slabNormTransfer_mulVec_local (beta : ℝ) :
    slabNormTransfer beta *ᵥ localVec = ((ratio beta : ℝ) : ℂ) • localVec := by
  unfold slabNormTransfer ratio
  rw [smul_mulVec,
    show slabTransfer beta *ᵥ localVec
        = ((lamFlux beta : ℝ) : ℂ) • localVec from
      TwoStateTransferZ2L1.slabTransfer_mulVec_local beta,
    smul_smul]
  congr 1
  rw [Complex.ofReal_div, div_eq_inv_mul]

theorem slabNormTransfer_pow_mulVec_vacuum (beta : ℝ) (n : ℕ) :
    slabNormTransfer beta ^ n *ᵥ vacuumVec = vacuumVec := by
  rw [pow_mulVec_eigen (slabNormTransfer_mulVec_vacuum beta) n, one_pow, one_smul]

theorem slabNormTransfer_pow_mulVec_local (beta : ℝ) (n : ℕ) :
    slabNormTransfer beta ^ n *ᵥ localVec = ((ratio beta : ℝ) : ℂ) ^ n • localVec :=
  pow_mulVec_eigen (slabNormTransfer_mulVec_local beta) n

/-! ## The connected two-point function -/

/-- The `n`-step connected two-point function of the (vacuum-normalised) Z2 slab
transfer operator between states `v` and `w`:
`⟪v, T̂ⁿ w⟫ - ⟪v, vac⟫⟪vac, w⟫ / 2`, where `⟪x, y⟫ = star x ⬝ᵥ y` is the
Euclidean inner product and the disconnected term subtracts the vacuum
contribution (`⟪vac, vac⟫ = 2`). -/
def slabConnectedCorrelation (beta : ℝ) (n : ℕ) (v w : Fin 2 → ℂ) : ℂ :=
  (star v ⬝ᵥ (slabNormTransfer beta ^ n *ᵥ w))
    - (star v ⬝ᵥ vacuumVec) * (star vacuumVec ⬝ᵥ w) / 2

/-- Decomposition of an arbitrary state into vacuum and flux components. -/
theorem state_decompose (w : Fin 2 → ℂ) :
    w = ((w 0 + w 1) / 2) • vacuumVec + ((w 0 - w 1) / 2) • localVec := by
  funext i
  fin_cases i <;>
    simp [vacuumVec, localVec] <;> ring

/-- The image of a general state under the normalised transfer power, expanded in
the vacuum/flux eigenbasis. -/
theorem slabNormTransfer_pow_mulVec (beta : ℝ) (n : ℕ) (w : Fin 2 → ℂ) :
    slabNormTransfer beta ^ n *ᵥ w
      = ((w 0 + w 1) / 2) • vacuumVec
        + (((w 0 - w 1) / 2) * ((ratio beta : ℝ) : ℂ) ^ n) • localVec := by
  conv_lhs => rw [state_decompose w]
  rw [Matrix.mulVec_add, Matrix.mulVec_smul, Matrix.mulVec_smul,
    slabNormTransfer_pow_mulVec_vacuum, slabNormTransfer_pow_mulVec_local,
    smul_smul]

/-- **Exact connected correlation identity.**  For the vacuum-normalised Z2 slab
transfer operator, the `n`-step connected two-point function factorises as
`ratioⁿ` times the flux-sector overlap:
`connected = ratioⁿ · ⟪v, flux⟫⟪flux, w⟫ / 2`. -/
theorem slab_connected_correlation_eq (beta : ℝ) (n : ℕ) (v w : Fin 2 → ℂ) :
    slabConnectedCorrelation beta n v w
      = ((ratio beta : ℝ) : ℂ) ^ n
        * ((star v ⬝ᵥ localVec) * (star localVec ⬝ᵥ w) / 2) := by
  unfold slabConnectedCorrelation
  rw [slabNormTransfer_pow_mulVec]
  simp only [dotProduct, Fin.sum_univ_two, Pi.add_apply, Pi.smul_apply,
    Pi.star_apply, vacuumVec, localVec, Matrix.cons_val_zero, Matrix.cons_val_one,
    smul_eq_mul, star_one, star_neg]
  ring

/-- **Exponential clustering (geometric form).**  The connected two-point
function is bounded by a constant times `ratioⁿ`, with the constant given by the
flux-sector overlap `C = ‖⟪v, flux⟫⟪flux, w⟫ / 2‖`. -/
theorem slab_connected_correlation_decay (beta : ℝ) (hbeta : 0 < beta) (n : ℕ)
    (v w : Fin 2 → ℂ) :
    ‖slabConnectedCorrelation beta n v w‖
      ≤ ‖(star v ⬝ᵥ localVec) * (star localVec ⬝ᵥ w) / 2‖ * ratio beta ^ n := by
  rw [slab_connected_correlation_eq, norm_mul, norm_pow, Complex.norm_real,
    Real.norm_of_nonneg (ratio_nonneg hbeta), mul_comm]

/-- **Exponential clustering (Faizal–Shabir form).**  The connected two-point
function of the OS-reconstructed Z2 slab transfer operator decays exponentially
in the number of steps `n` at rate `gap = osSpectralGap`:
`‖connected‖ ≤ C · exp(-(n · gap))`.  This is the clustering link feeding the
lane-C end-to-end assembly. -/
theorem slab_exponential_clustering (beta : ℝ) (hbeta : 0 < beta) (n : ℕ)
    (v w : Fin 2 → ℂ) :
    ‖slabConnectedCorrelation beta n v w‖
      ≤ ‖(star v ⬝ᵥ localVec) * (star localVec ⬝ᵥ w) / 2‖
        * Real.exp (-(n * OSReconstruction.osSpectralGap beta hbeta)) := by
  have hgap : ratio beta = Real.exp (-(OSReconstruction.osSpectralGap beta hbeta)) := by
    rw [OSReconstruction.osSpectralGap]
    have h := (TwoStateTransferZ2Sector.fluxGapWitness beta hbeta).exp_neg_fluxGap_eq_ratio
    rw [SlabTransferGap.neU4ClosureGap]
    exact h.symm
  have hpow : ratio beta ^ n
      = Real.exp (-(n * OSReconstruction.osSpectralGap beta hbeta)) := by
    rw [hgap, ← Real.exp_nat_mul]
    congr 1
    ring
  calc
    ‖slabConnectedCorrelation beta n v w‖
        ≤ ‖(star v ⬝ᵥ localVec) * (star localVec ⬝ᵥ w) / 2‖ * ratio beta ^ n :=
          slab_connected_correlation_decay beta hbeta n v w
    _ = ‖(star v ⬝ᵥ localVec) * (star localVec ⬝ᵥ w) / 2‖
          * Real.exp (-(n * OSReconstruction.osSpectralGap beta hbeta)) := by
          rw [hpow]

end SlabClustering
end GateYM
end NullEdge
end Draft
end PhysicsSM
