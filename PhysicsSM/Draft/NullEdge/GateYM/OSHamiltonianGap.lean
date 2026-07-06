import Mathlib

/-!
# Gate YM / NE-U4: the transfer Hamiltonian `H = -log T` on the two-state Z2 slab

This module formalises the **transfer Hamiltonian** layer on the exactly
solvable one-link `Z2` Wilson slab, sitting directly on top of the finite
Osterwalder-Schrader / GNS spectral picture recorded in this project by
`OSReconstruction` / `TwoStateTransferZ2Sector` / `TwoStateTransferSpectrum` /
`SlabTransferGap`.

The Euclidean transfer operator `T` on the two `Z2` center sectors has two
positive real eigenvalues:

* the **vacuum** eigenvalue `lambda0 = 2 (e^β + e^{-β})`, the TOP of the
  transfer spectrum, and
* the lightest nontrivial **center-flux** eigenvalue
  `lambdaFlux = 2 (e^β - e^{-β})`,

with `lambda0 > lambdaFlux > 0` (`lambdaFlux_lt_lambda0`, `lambda0_pos`,
`lambdaFlux_pos`).  The finite OS spectral gap is the additive
transfer-spectral-ratio gap

`osSpectralGap = -log (lambdaFlux / lambda0) = -log (tanh β) > 0`.

The **Osterwalder-Schrader reconstruction** turns the multiplicative transfer
operator into an additive self-adjoint Hamiltonian by `H = -log T`.  On the two
one-dimensional `Z2` sectors this is literally the eigenvalue transform
`lam ↦ -log lam`, giving the two Hamiltonian energies

* `E0    = -log lambda0`    (vacuum energy), and
* `Eflux = -log lambdaFlux` (first excited / flux energy).

Because `lam ↦ -log lam` is strictly decreasing on the positives, the TOP
transfer eigenvalue becomes the BOTTOM Hamiltonian eigenvalue: the vacuum is the
**ground state** (`E0_lt_Eflux`), and the Hamiltonian gap to the first excited
state is exactly the OS spectral gap
(`osSpectralGap_eq_Eflux_sub_E0`, `hamiltonianGap_pos`).  We package this as an
explicit two-state ground-state statement: `E0` is a lower bound for the whole
spectrum (`hamSpec_ground_le`), it is attained uniquely at the vacuum sector
(`hamSpec_unique_ground`), and the separation to the excited sector is
`osSpectralGap` (`hamSpec_excited_gap`).

## Self-containedness note

The upstream project modules named above carry the same `lambda0`,
`lambdaFlux`, `osSpectralGap`, `lambda0_pos`, `lambdaFlux_pos`,
`lambdaFlux_lt_lambda0`, and `osSpectralGap_eq_neg_log_ratio` declarations, but
their import chains reference modules (`WilsonSlabConnected`,
`ReflectionPositivityKernel`, `TransferGapDefinition`, `TwoStateTransferZ2L1`,
…) that are **not present** in this project directory, so they do not build
here.  To keep this file self-contained and typechecking, the two-state `Z2`
spectral data (the concrete `2 × 2` transfer matrix, its vacuum/flux
eigenvectors, the two disjoint center sectors, and the eigenvalue branches
`lambda0` / `lambdaFlux`) are re-derived locally, matching the upstream
definitions verbatim.  The reused facts requested — `lambda0_pos`,
`lambdaFlux_pos`, `lambdaFlux_lt_lambda0`, `osSpectralGap_eq_neg_log_ratio` —
appear below with identical statements.

## What is NOT claimed (F-YM-CONFLATE guard)

This is an honest **finite two-state `Z2` spectral identity**, NOT a continuum
Hamiltonian.  `H = -log T` is realised here only as the eigenvalue transform on
the two exactly solvable one-dimensional center sectors of the one-link `Z2`
slab; no infinite-volume limit, no continuum Hamiltonian, no physical mass gap,
no Wilson area law, and no entanglement claim is made.  The vacuum and the flux
excitation live in genuinely DISTINCT center sectors (`sectors_disjoint`): the
gap is a distinct-center-sector separation, not a within-trivial-sector
local/glueball gap.

Draft-trust: kernel-checked, no `sorry`, no `axiom`, no `native_decide`.
Claim label: **finite identity / transfer Hamiltonian layer**.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace OSHamiltonianGap

open scoped BigOperators Matrix

/-! ## Two-state `Z2` transfer spectral data (self-contained re-derivation) -/

/-- The one-link `Z2` **vacuum** transfer eigenvalue branch `2 (e^β + e^{-β})`
(the top transfer eigenvalue). -/
def lambda0 (beta : ℝ) : ℝ := 2 * (Real.exp beta + Real.exp (-beta))

/-- The one-link `Z2` **flux** transfer eigenvalue branch `2 (e^β - e^{-β})`
(the lightest nontrivial center-flux eigenvalue). -/
def lambdaFlux (beta : ℝ) : ℝ := 2 * (Real.exp beta - Real.exp (-beta))

/-- The vacuum transfer eigenvalue is strictly positive. -/
theorem lambda0_pos (beta : ℝ) : 0 < lambda0 beta := by
  unfold lambda0
  have := add_pos (Real.exp_pos beta) (Real.exp_pos (-beta))
  linarith

/-- The flux transfer eigenvalue is strictly positive for `β > 0`. -/
theorem lambdaFlux_pos {beta : ℝ} (hbeta : 0 < beta) : 0 < lambdaFlux beta := by
  unfold lambdaFlux
  have h : Real.exp (-beta) < Real.exp beta := Real.exp_lt_exp.mpr (by linarith)
  linarith

/-- The flux eigenvalue lies strictly below the vacuum eigenvalue: the vacuum is
the top of the transfer spectrum. -/
theorem lambdaFlux_lt_lambda0 (beta : ℝ) : lambdaFlux beta < lambda0 beta := by
  unfold lambdaFlux lambda0
  have h : 0 < Real.exp (-beta) := Real.exp_pos _
  linarith

/-- The transfer-spectral ratio `lambdaFlux / lambda0` equals `tanh β`. -/
theorem lambdaFlux_div_lambda0_eq_tanh (beta : ℝ) :
    lambdaFlux beta / lambda0 beta = Real.tanh beta := by
  rw [Real.tanh_eq]
  unfold lambdaFlux lambda0
  have hsum : Real.exp beta + Real.exp (-beta) ≠ 0 :=
    ne_of_gt (add_pos (Real.exp_pos beta) (Real.exp_pos (-beta)))
  field_simp

/-! ### The concrete `2 × 2` transfer matrix and its two center sectors -/

/-- The concrete `2 × 2` one-link `Z2` transfer matrix
`!![2 e^β, 2 e^{-β}; 2 e^{-β}, 2 e^β]`.  Its symmetric/antisymmetric
eigenvectors are the two `Z2` center sectors, with eigenvalues `lambda0` and
`lambdaFlux`. -/
def transfer2 (beta : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![((2 * Real.exp beta : ℝ) : ℂ), ((2 * Real.exp (-beta) : ℝ) : ℂ);
     ((2 * Real.exp (-beta) : ℝ) : ℂ), ((2 * Real.exp beta : ℝ) : ℂ)]

/-- The vacuum (`+1` center) vector `(1, 1)`. -/
def vacuumVec : Fin 2 → ℂ := fun _ => 1

/-- The flux (`-1` center) excitation vector `(1, -1)`. -/
def localVec : Fin 2 → ℂ := ![(1 : ℂ), -1]

/-- The transfer matrix is Hermitian (all entries real). -/
theorem transfer2_conjTranspose (beta : ℝ) :
    (transfer2 beta)ᴴ = transfer2 beta := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [transfer2, Matrix.conjTranspose, ← Complex.exp_conj, Complex.conj_ofReal,
      map_ofNat]

/-- `(1, 1)` is a transfer eigenvector with the vacuum eigenvalue `lambda0`. -/
theorem transfer2_mulVec_vacuum (beta : ℝ) :
    (transfer2 beta) *ᵥ vacuumVec = (lambda0 beta : ℂ) • vacuumVec := by
  funext i
  fin_cases i <;>
  · simp [transfer2, vacuumVec, lambda0, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
    ring

/-- `(1, -1)` is a transfer eigenvector with the flux eigenvalue `lambdaFlux`. -/
theorem transfer2_mulVec_local (beta : ℝ) :
    (transfer2 beta) *ᵥ localVec = (lambdaFlux beta : ℂ) • localVec := by
  funext i
  fin_cases i <;>
  · simp [transfer2, localVec, lambdaFlux, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
    ring

/-- The vacuum vector is nonzero. -/
theorem vacuumVec_ne_zero : vacuumVec ≠ 0 := by
  intro h; have := congrFun h (0 : Fin 2); simp [vacuumVec] at this

/-- The flux excitation vector is nonzero. -/
theorem localVec_ne_zero : localVec ≠ 0 := by
  intro h; have := congrFun h (0 : Fin 2); simp [localVec] at this

/-- The vacuum (`+1`) center sector, spanned by `(1, 1)`. -/
def vacuumSector : Submodule ℂ (Fin 2 → ℂ) := Submodule.span ℂ {vacuumVec}

/-- The flux (`-1`) center sector, spanned by `(1, -1)`. -/
def fluxSector : Submodule ℂ (Fin 2 → ℂ) := Submodule.span ℂ {localVec}

/-- The two center sectors are genuinely distinct: their intersection is
trivial.  The vacuum and the flux excitation are therefore in disjoint sectors,
so the gap is a distinct-center-sector separation. -/
theorem sectors_disjoint : vacuumSector ⊓ fluxSector = ⊥ := by
  rw [Submodule.eq_bot_iff]
  intro x hx
  simp only [Submodule.mem_inf, vacuumSector, fluxSector,
    Submodule.mem_span_singleton] at hx
  obtain ⟨⟨a, ha⟩, ⟨b, hb⟩⟩ := hx
  have h0 := congrFun (ha.trans hb.symm) 0
  have h1 := congrFun (ha.trans hb.symm) 1
  simp [vacuumVec, localVec] at h0 h1
  have hb0 : b = 0 := by linear_combination (h1 - h0) / 2
  rw [← ha, h0, hb0, zero_smul]

/-! ## The OS spectral gap (additive transfer-spectral-ratio gap) -/

/-- **The OS spectral gap.**  The additive gap `-log (lambdaFlux / lambda0)`
between the vacuum and first excited center-flux transfer eigenvalues. -/
def osSpectralGap (beta : ℝ) (_hbeta : 0 < beta) : ℝ :=
  -Real.log (lambdaFlux beta / lambda0 beta)

/-- The OS spectral gap is the negative log of the transfer-spectral ratio
(first excited over vacuum). -/
theorem osSpectralGap_eq_neg_log_ratio (beta : ℝ) (hbeta : 0 < beta) :
    osSpectralGap beta hbeta = -Real.log (lambdaFlux beta / lambda0 beta) := rfl

/-- Strong-coupling read-off: the OS spectral gap equals `-log (tanh β)`. -/
theorem osSpectralGap_eq_neg_log_tanh (beta : ℝ) (hbeta : 0 < beta) :
    osSpectralGap beta hbeta = -Real.log (Real.tanh beta) := by
  rw [osSpectralGap_eq_neg_log_ratio, lambdaFlux_div_lambda0_eq_tanh]

/-! ## The transfer Hamiltonian `H = -log T`

Under OS reconstruction the multiplicative transfer eigenvalue `lam` becomes the
additive Hamiltonian energy `-log lam`.  On the two one-dimensional `Z2` sectors
this is the entire content of `H = -log T`. -/

/-- The Hamiltonian energy of a positive transfer eigenvalue: `E = -log lam`. -/
def hamOfTransfer (lam : ℝ) : ℝ := -Real.log lam

/-- Recovering the transfer eigenvalue from its energy: `exp (-E) = lam` for
`lam > 0`. -/
theorem exp_neg_hamOfTransfer (lam : ℝ) (h : 0 < lam) :
    Real.exp (-hamOfTransfer lam) = lam := by
  unfold hamOfTransfer; rw [neg_neg, Real.exp_log h]

/-- The **vacuum energy** `E0 = -log lambda0` (Hamiltonian ground eigenvalue). -/
def E0 (beta : ℝ) : ℝ := hamOfTransfer (lambda0 beta)

/-- The **flux energy** `Eflux = -log lambdaFlux` (first excited eigenvalue). -/
def Eflux (beta : ℝ) : ℝ := hamOfTransfer (lambdaFlux beta)

/-- `E0` is the Hamiltonian image of the vacuum transfer eigenvalue. -/
theorem E0_eq (beta : ℝ) : E0 beta = -Real.log (lambda0 beta) := rfl

/-- `Eflux` is the Hamiltonian image of the flux transfer eigenvalue. -/
theorem Eflux_eq (beta : ℝ) : Eflux beta = -Real.log (lambdaFlux beta) := rfl

/-- `exp (-E0) = lambda0`: the vacuum transfer eigenvalue is recovered from the
vacuum energy. -/
theorem exp_neg_E0 (beta : ℝ) : Real.exp (-E0 beta) = lambda0 beta :=
  exp_neg_hamOfTransfer _ (lambda0_pos beta)

/-- `exp (-Eflux) = lambdaFlux`: the flux transfer eigenvalue is recovered from
the flux energy. -/
theorem exp_neg_Eflux (beta : ℝ) (hbeta : 0 < beta) :
    Real.exp (-Eflux beta) = lambdaFlux beta :=
  exp_neg_hamOfTransfer _ (lambdaFlux_pos hbeta)

/-- **The vacuum is the ground state.**  Because `lam ↦ -log lam` is strictly
decreasing on the positives, the TOP transfer eigenvalue `lambda0` maps to the
LOWEST Hamiltonian eigenvalue: `E0 < Eflux`. -/
theorem E0_lt_Eflux (beta : ℝ) (hbeta : 0 < beta) : E0 beta < Eflux beta := by
  unfold E0 Eflux hamOfTransfer
  have h := Real.log_lt_log (lambdaFlux_pos hbeta) (lambdaFlux_lt_lambda0 beta)
  linarith

/-- **The Hamiltonian gap is the eigenvalue difference.**  The OS spectral gap
equals the Hamiltonian energy difference `Eflux - E0`. -/
theorem osSpectralGap_eq_Eflux_sub_E0 (beta : ℝ) (hbeta : 0 < beta) :
    osSpectralGap beta hbeta = Eflux beta - E0 beta := by
  unfold osSpectralGap E0 Eflux hamOfTransfer
  rw [Real.log_div (ne_of_gt (lambdaFlux_pos hbeta)) (ne_of_gt (lambda0_pos beta))]
  ring

/-- **The Hamiltonian gap is strictly positive.**  `Eflux - E0 = osSpectralGap
> 0`: there is a genuine energy gap above the vacuum. -/
theorem hamiltonianGap_pos (beta : ℝ) (hbeta : 0 < beta) :
    0 < Eflux beta - E0 beta := by
  have := E0_lt_Eflux beta hbeta; linarith

/-- The OS spectral gap is strictly positive. -/
theorem osSpectralGap_pos (beta : ℝ) (hbeta : 0 < beta) :
    0 < osSpectralGap beta hbeta := by
  rw [osSpectralGap_eq_Eflux_sub_E0 beta hbeta]
  exact hamiltonianGap_pos beta hbeta

/-! ## The two-state Hamiltonian spectrum and its unique ground state -/

/-- The Hamiltonian spectrum on the two `Z2` center sectors: `true` is the
vacuum sector (energy `E0`), `false` is the flux sector (energy `Eflux`). -/
def hamSpec (beta : ℝ) : Bool → ℝ
  | true => E0 beta
  | false => Eflux beta

/-- The vacuum energy `E0` is a lower bound for the whole two-state Hamiltonian
spectrum: the vacuum is the ground state. -/
theorem hamSpec_ground_le (beta : ℝ) (hbeta : 0 < beta) (s : Bool) :
    E0 beta ≤ hamSpec beta s := by
  cases s with
  | true => simp [hamSpec]
  | false => simp only [hamSpec]; exact (E0_lt_Eflux beta hbeta).le

/-- The vacuum energy is attained (at the vacuum sector). -/
theorem hamSpec_vacuum (beta : ℝ) : hamSpec beta true = E0 beta := rfl

/-- **The vacuum is the unique ground state.**  The ground energy `E0` is
attained only in the vacuum center sector. -/
theorem hamSpec_unique_ground (beta : ℝ) (hbeta : 0 < beta) {s : Bool}
    (hs : hamSpec beta s = E0 beta) : s = true := by
  cases s with
  | true => rfl
  | false =>
      simp only [hamSpec] at hs
      exact absurd hs (ne_of_gt (E0_lt_Eflux beta hbeta))

/-- **The gap to the first excited state is `osSpectralGap`.**  The energy
separation between the flux (first excited) sector and the vacuum ground state
is exactly the OS spectral gap. -/
theorem hamSpec_excited_gap (beta : ℝ) (hbeta : 0 < beta) :
    hamSpec beta false - hamSpec beta true = osSpectralGap beta hbeta := by
  simp only [hamSpec]
  rw [osSpectralGap_eq_Eflux_sub_E0 beta hbeta]

/-- **Bundled ground-state statement.**  On the finite two-state `Z2` slab, the
vacuum (`true`) is the unique Hamiltonian ground state, and the first excited
state (the flux sector `false`) sits a strictly positive gap `osSpectralGap =
-log (tanh β)` above it.  This is an honest finite two-state `Z2` spectral
identity, not a continuum Hamiltonian. -/
theorem vacuum_unique_ground_with_gap (beta : ℝ) (hbeta : 0 < beta) :
    (∀ s : Bool, hamSpec beta true ≤ hamSpec beta s) ∧
      (∀ s : Bool, hamSpec beta s = hamSpec beta true → s = true) ∧
      hamSpec beta false - hamSpec beta true = osSpectralGap beta hbeta ∧
      0 < osSpectralGap beta hbeta := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro s; simpa [hamSpec] using hamSpec_ground_le beta hbeta s
  · intro s hs
    exact hamSpec_unique_ground beta hbeta (by simpa [hamSpec] using hs)
  · exact hamSpec_excited_gap beta hbeta
  · exact osSpectralGap_pos beta hbeta

end OSHamiltonianGap
end GateYM
end NullEdge
end Draft
end PhysicsSM
