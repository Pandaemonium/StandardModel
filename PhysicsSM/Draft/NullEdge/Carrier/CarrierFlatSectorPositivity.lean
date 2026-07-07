import Mathlib

/-!
# Move-1 CRACK 2 - flat-sector Krein positivity (the first genuine positivity theorem)

The first positivity result for the carrier mass form, on the natural sector identified by
Fable call-03: with the **chirality as the fundamental symmetry** `J := Γ`, the Krein form
is `⟪x, y⟫_J := ⟪x, Γ y⟫`, and on the **flat, chiral-positive sector**
`{ψ : (∀ e, ∇ₑ ψ = 0) ∧ Γ ψ = ψ}` the carrier `D = ∑ₑ γₑ ∘ ∇ₑ + Γ ∘ φ` acts as the pure
potential, `D ψ = φ ψ`, so the Krein mass form equals `‖φ ψ‖² ≥ 0`:

>   `⟪D ψ, Γ (D ψ)⟫ = ⟪φ ψ, φ ψ⟫ = ‖φ ψ‖²`,  hence `0 ≤ re ⟪D ψ, Γ (D ψ)⟫`.

Physics readout: on the zero-kinetic chiral-positive sector the mass form is exactly the
turn/potential mass - "mass from `φ`", positive - the thesis at its most defensible point.

## Why this is honest (not the vacuous `κ=0` case)

`J := Γ` is a genuine fundamental symmetry when `Γ` is self-adjoint (`Γ† = Γ`) and an
involution (`Γ² = 1`) with nontrivial `±1` eigenspaces (inertia `κ > 0`) - see the M₄ Pauli
witness (`κ = 2`, a Pontryagin `Π₂`), Codex lane. Here we work on a finite-dimensional
complex inner-product space `M` and take `J = Γ`; the positivity is on the `+1`-eigenspace
`M₊` (`Γ ψ = ψ`), where the Krein form restricts to the genuine inner product. This is the
non-vacuous Krein reading, not the `κ = 0` Hilbert case.

## Scope / honesty (draft)

`Γ` self-adjoint involution, `[Γ, φ] = 0` (chirality-even potential, matching `hPhiComm`).
Only the FLAT sector (`∇ₑ ψ = 0`) is treated here - the off-flat forward-sector positivity
(CRACK 3, via `JointEigenspace` + `nbody_massSq_nonneg` + retardedness) is the separate
prize. No `Q_C`/`E_#` here (they vanish on the flat sector by construction). Provenance:
Fable call-03 CRACK 1+2.
-/

open scoped BigOperators InnerProductSpace

namespace PhysicsSM.Draft.NullEdge.Carrier

variable {E M : Type*} [Fintype E]
  [NormedAddCommGroup M] [InnerProductSpace ℂ M]

/-- The carrier operator `D = ∑ₑ γₑ ∘ ∇ₑ + Γ ∘ φ` on `M`. -/
noncomputable def carrierOp (gamma nabla : E → (M →ₗ[ℂ] M)) (Gamma phi : M →ₗ[ℂ] M) :
    M →ₗ[ℂ] M :=
  (∑ e, gamma e ∘ₗ nabla e) + Gamma ∘ₗ phi

/-- **On the flat chiral-positive sector the carrier acts as the potential.**  If
`∇ₑ ψ = 0` for all `e` and `Γ ψ = ψ` (with `[Γ,φ] = 0`), then `D ψ = φ ψ`. -/
theorem carrierOp_on_flatSector (gamma nabla : E → (M →ₗ[ℂ] M)) (Gamma phi : M →ₗ[ℂ] M)
    (hPhiComm : Gamma ∘ₗ phi = phi ∘ₗ Gamma)
    (ψ : M) (hflat : ∀ e, nabla e ψ = 0) (hchi : Gamma ψ = ψ) :
    carrierOp gamma nabla Gamma phi ψ = phi ψ := by
  have hsum : (∑ e, gamma e ∘ₗ nabla e) ψ = 0 := by
    rw [LinearMap.sum_apply]
    exact Finset.sum_eq_zero fun e _ => by rw [LinearMap.comp_apply, hflat e, map_zero]
  have hGphi : (Gamma ∘ₗ phi) ψ = phi ψ := by
    rw [hPhiComm, LinearMap.comp_apply, hchi]
  rw [carrierOp, LinearMap.add_apply, hsum, zero_add, hGphi]

/-- **Flat-sector Krein positivity (CRACK 2).**  On the flat chiral-positive sector, the
Krein mass form `⟪D ψ, Γ (D ψ)⟫` equals `⟪φ ψ, φ ψ⟫`, hence has nonnegative real part:
the mass form is the (positive) potential mass. -/
theorem flat_sector_positivity (gamma nabla : E → (M →ₗ[ℂ] M)) (Gamma phi : M →ₗ[ℂ] M)
    (hPhiComm : Gamma ∘ₗ phi = phi ∘ₗ Gamma)
    (ψ : M) (hflat : ∀ e, nabla e ψ = 0) (hchi : Gamma ψ = ψ) :
    (inner ℂ (carrierOp gamma nabla Gamma phi ψ) (Gamma (carrierOp gamma nabla Gamma phi ψ)))
      = (inner ℂ (phi ψ) (phi ψ))
    ∧ 0 ≤ (inner ℂ (carrierOp gamma nabla Gamma phi ψ)
            (Gamma (carrierOp gamma nabla Gamma phi ψ))).re := by
  have hD : carrierOp gamma nabla Gamma phi ψ = phi ψ :=
    carrierOp_on_flatSector gamma nabla Gamma phi hPhiComm ψ hflat hchi
  have hGphi : Gamma (phi ψ) = phi ψ := by
    rw [← LinearMap.comp_apply, hPhiComm, LinearMap.comp_apply, hchi]
  rw [hD, hGphi]
  exact ⟨rfl, by simpa using inner_self_nonneg (𝕜 := ℂ) (x := phi ψ)⟩

end PhysicsSM.Draft.NullEdge.Carrier
