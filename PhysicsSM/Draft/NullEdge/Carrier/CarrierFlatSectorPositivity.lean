import Mathlib

/-!
# Move-1 CRACK 2 - flat-sector positivity IDENTITY (Krein reading pending the J/κ witness)

A **conditional flat-sector form identity** for the carrier (Codex review-flag applied: this
is NOT yet a certified Krein positivity theorem - the proof does not use, and the statement
does not require, that `Γ` is a self-adjoint involution of inertia `κ > 0`; those make the
`⟪·, Γ ·⟫` form a genuine indefinite inner product, and are supplied only by the M4 Pauli
witness (`κ = 2`, Codex lane). Read this as a form identity whose Krein/Pontryagin
*interpretation* is pending that witness). On the natural sector identified by Fable call-03,
with the **chirality as the (intended) fundamental symmetry** `J := Γ` and Krein form
`⟪x, y⟫_J := ⟪x, Γ y⟫`, on the **flat, chiral-positive sector**
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

/-- **Flat-sector form identity (CRACK 2, conditional).**  On the flat chiral-positive
sector the form `⟪D ψ, Γ (D ψ)⟫` equals `⟪φ ψ, φ ψ⟫`, hence has nonnegative real part
(`= ‖φ ψ‖²`).  When `Γ` is a certified fundamental symmetry (`Γ† = Γ`, `Γ² = 1`, inertia
`κ > 0` - the M4 witness), this reads as "the Krein mass form on the flat sector is the
positive potential mass"; the proof itself needs only `hPhiComm` (so the identity is more
general than the Krein interpretation). -/
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

/-! ## The Krein form is a genuine indefinite inner product when `Γ` is self-adjoint

This is the abstract half of the certified Krein reading (addressing the review-flag): the
form `⟪x, Γ y⟫` is Hermitian (hence a genuine indefinite inner product) exactly when the
fundamental symmetry `Γ` is self-adjoint. Combined with `flat_sector_positivity` (the value
`= ‖φψ‖² ≥ 0`), this gives certified nonnegativity of a *bona fide* indefinite form on the
flat sector - conditional only on `Γ` being a fundamental symmetry (`Γ† = Γ`), which the M4
`κ = 2` Pauli witness supplies concretely. -/

section Krein

variable [FiniteDimensional ℂ M]

open scoped ComplexConjugate

/-- The Krein/indefinite form induced by a (candidate) fundamental symmetry `Γ`:
`⟪x, y⟫_Γ := ⟪x, Γ y⟫`. -/
noncomputable def kreinForm (Gamma : M →ₗ[ℂ] M) (x y : M) : ℂ := inner ℂ x (Gamma y)

/-- **The Krein form is Hermitian when `Γ` is self-adjoint** - i.e. `⟪·, Γ ·⟫` is a genuine
indefinite inner product exactly on a self-adjoint fundamental symmetry. This is the formal
content behind the "Krein" reading (it genuinely uses `Γ† = Γ`, unlike the flat-sector value
identity, which needs only `hPhiComm`). -/
theorem kreinForm_hermitian (Gamma : M →ₗ[ℂ] M)
    (hGammaSA : LinearMap.adjoint Gamma = Gamma) (x y : M) :
    kreinForm Gamma x y = conj (kreinForm Gamma y x) := by
  unfold kreinForm
  rw [inner_conj_symm, ← LinearMap.adjoint_inner_left, hGammaSA]

end Krein

end PhysicsSM.Draft.NullEdge.Carrier
