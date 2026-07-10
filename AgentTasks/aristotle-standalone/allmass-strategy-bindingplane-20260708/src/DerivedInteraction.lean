import Mathlib
import src.InteractingTwoBody

/-!
# Deriving the two-body interaction `V` from the carrier's closure geometry

The companion module `InteractingTwoBody.lean` proves a genuine finite two-body
bound state strictly below the free constituent threshold for a *modelled*
attractive interaction `V = !![0,-κ,0; -κ,0,0; 0,0,0]`.  Its one remaining
grade-**C** step was that the *scale* of `V` is the closure strength `κ`
(`= -Δ`, the block binding defect of `BindingDefect.lean`) but the rank-one
attractive *form* of `V` was inserted by hand, not derived from the carrier.

This module **conditionally** sharpens that step (per the batch-4 over-claim
audit it is a conditional, NOT an unconditional C → M).  The one-particle carrier
sector is the mass block `B(λ,κ) = λ·I + i·κ·K` with `K` a (real, antisymmetric)
**closure curvature**.  We build a two-body interaction as the *second
quantization* (the `dΓ`, antisymmetric-two-particle projection) of a chosen
one-body closure operator onto `Λ²(sector)` — a mechanical construction from
closure data, with no hand-drawn `V`.  **Scope caveat:** this file does not import
the actual carrier and does not prove that the carrier's *own* `K` occupies the
binding plane; that identification stays grade **C** (see the honest obstruction
below, which shows the plane choice is exactly what decides binding).

## What is derived

* `dGamma2 A` is the antisymmetric second quantization of a one-body operator `A`
  on the three modes onto the three pair-states `0 ↔ {0,1}`, `1 ↔ {0,2}`,
  `2 ↔ {1,2}` (`dGamma2_diagonal` checks it reproduces `freeH2` on diagonals).
* `closureCurvature` is the closure curvature `K` (a real antisymmetric generator);
  `oneBodyClosure κ = i·κ·K` is the closure part of the carrier block `B`.
* `Vderived κ := dGamma2 (oneBodyClosure κ)` is the **derived** two-body
  interaction.  Its explicit form is `!![0,-iκ,0; iκ,0,0; 0,0,0]`
  (`Vderived_eq`): a Hermitian coupling of the two lowest pairs, of strength
  exactly `κ`.

## The main positive result (`derived_boundState_below_threshold`)

The derived interaction is the modelled `V` in a diagonal *phase gauge*:
`Vderived κ = U · (interaction κ)ℂ · U⁻¹` for the diagonal unitary
`U = diag(1,-i,1)` (`Vderived_conj`).  Hence `H2der = U · H2ℂ · U⁻¹`
(`H2der_conj`) is *unitarily equivalent* to the modelled Hamiltonian, so it has
the identical spectrum (`spectrumC_H2der`), and therefore the *same*
below-threshold bound state:

  `IsLeast (spectrumC (H2der d κ)) (boundEnergy d κ)` and
  `boundEnergy d κ < pairThreshold d`  for `κ > 0`, `d 0 ≤ d 1 ≤ d 2`.

So the modelled attractive `V` was **not** an arbitrary rank-one form: it is the
second-quantized closure operator of *a* closure curvature (in the binding plane),
up to a phase gauge.  It is **not** established here that this curvature is the
carrier's own `K` — that is the grade-**C** gap, and `derived_wrongPlane_no_binding`
shows the plane occupied by `K` is precisely what decides whether binding occurs.

## The honest obstruction (`derived_wrongPlane_no_binding`)

Whether the closure geometry binds depends on *which* modes the curvature
couples.  If the closure curvature acts in a plane containing the ground mode
(`closureCurvature2`, coupling modes `{0,1}`), its second quantization couples
the two *heavier* pairs `{0,2}` and `{1,2}` (both containing the top mode `2`),
and the ground pair `{0,1}` stays decoupled at the free threshold.  Then the
least eigenvalue is *exactly* the free threshold whenever
`κ² ≤ (d 2 - d 0)(d 2 - d 1)` — i.e. the closure produces **no** binding below
threshold.  This is the precise boundary of what the closure geometry can supply.
-/

open scoped BigOperators
open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.Carrier.DerivedInteraction

open PhysicsSM.Draft.NullEdge.Carrier.InteractingTwoBody

/-! ## Second quantization onto the antisymmetric two-particle space -/

/-- The antisymmetric second quantization `dΓ(A)` of a one-body operator `A` on
the three modes onto the three pair-states `0 ↔ {0,1}`, `1 ↔ {0,2}`,
`2 ↔ {1,2}`.  Derived from `dΓ(A)(eᵢ∧eⱼ) = (A eᵢ)∧eⱼ + eᵢ∧(A eⱼ)` re-expressed
in the ordered wedge basis. -/
def dGamma2 (A : Matrix (Fin 3) (Fin 3) ℂ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![A 0 0 + A 1 1, A 1 2, - A 0 2;
     A 2 1, A 0 0 + A 2 2, A 0 1;
     - A 2 0, A 1 0, A 1 1 + A 2 2]

/-- `dΓ` of a diagonal one-body operator is the diagonal of pair sums: it
reproduces the free two-body Hamiltonian `freeH2`. -/
theorem dGamma2_diagonal (d : Fin 3 → ℝ) :
    dGamma2 ((Matrix.diagonal d).map (Complex.ofReal)) = (freeH2 d).map (Complex.ofReal) := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [dGamma2, freeH2, pairEnergy, Matrix.diagonal, Matrix.map_apply] <;> ring

/-! ## The carrier closure curvature and the derived interaction -/

/-- The closure curvature `K`: a real antisymmetric generator acting in the plane
of the two excited modes `{1,2}` (spectator = the ground mode `0`).  This is the
`K` of the carrier mass block `B(λ,κ) = λ·I + i·κ·K`. -/
def closureCurvature : Matrix (Fin 3) (Fin 3) ℂ := !![0,0,0; 0,0,-1; 0,1,0]

/-- The one-body closure operator `i·κ·K`: the closure part of the carrier block
`B(λ,κ)`. -/
noncomputable def oneBodyClosure (kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  (kappa : ℂ) • (Complex.I • closureCurvature)

/-- **The derived two-body interaction**: the second quantization of the carrier's
one-body closure operator onto `Λ²(sector)`.  No hand-drawn `V`. -/
noncomputable def Vderived (kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  dGamma2 (oneBodyClosure kappa)

/-- The **derived interacting two-body Hamiltonian**: `dΓ` of the carrier's full
one-body operator `diag d + i·κ·K` onto `Λ²(sector)`. -/
noncomputable def H2der (d : Fin 3 → ℝ) (kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  dGamma2 ((Matrix.diagonal d).map (Complex.ofReal) + oneBodyClosure kappa)

/-- **Explicit form of the derived interaction.**  `Vderived κ` couples the two
lowest pairs `{0,1}` and `{0,2}` with Hermitian off-diagonal `∓iκ` — exactly the
modelled `V`, but with the closure phase `i`.  Its scale is exactly `κ`. -/
theorem Vderived_eq (kappa : ℝ) :
    Vderived kappa = !![0, -(kappa:ℂ)*Complex.I, 0; (kappa:ℂ)*Complex.I, 0, 0; 0,0,0] := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Vderived, dGamma2, oneBodyClosure, closureCurvature, Matrix.smul_apply]

/-- The derived interaction is Hermitian. -/
theorem Vderived_isHermitian (kappa : ℝ) : (Vderived kappa).IsHermitian := by
  rw [Matrix.IsHermitian, Vderived_eq]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.conjTranspose]

/-- The one-body closure operator `i·κ·K` is Hermitian (a legitimate carrier
observable): `K` is real antisymmetric, so `iK` is Hermitian. -/
theorem oneBodyClosure_isHermitian (kappa : ℝ) : (oneBodyClosure kappa).IsHermitian := by
  rw [Matrix.IsHermitian]
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [oneBodyClosure, closureCurvature, Matrix.conjTranspose, Matrix.smul_apply]

/-- **Strength set by `κ`.**  The nonzero coupling entry of the derived
interaction has modulus exactly `|κ|`: the interaction scale is the closure
strength `κ`, matching the block binding defect `Δ = -κ`. -/
theorem Vderived_strength (kappa : ℝ) :
    ‖Vderived kappa 0 1‖ = |kappa| := by
  rw [Vderived_eq]; simp [Complex.norm_real]

/-- The derived interaction vanishes iff the closure is off (`κ = 0`). -/
theorem Vderived_eq_zero_iff (kappa : ℝ) : Vderived kappa = 0 ↔ kappa = 0 := by
  rw [Vderived_eq]
  constructor
  · intro h
    have := congrFun (congrFun h 0) 1
    simpa using this
  · intro h; subst h; ext i j; fin_cases i <;> fin_cases j <;> simp

/-- **`dΓ` decomposition.**  The derived two-body Hamiltonian splits as the free
two-body Hamiltonian plus the derived interaction: `H2der = freeH2ℂ + Vderived`.
The interaction is *not* added by hand — it emerges from `dΓ`. -/
theorem H2der_eq (d : Fin 3 → ℝ) (kappa : ℝ) :
    H2der d kappa = (freeH2 d).map (Complex.ofReal) + Vderived kappa := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [H2der, Vderived, dGamma2, oneBodyClosure, closureCurvature, freeH2, pairEnergy,
      Matrix.diagonal, Matrix.smul_apply, Matrix.map_apply, Matrix.add_apply] <;> ring

/-! ## The phase gauge: derived = modelled up to a diagonal unitary -/

/-- The diagonal phase gauge `U = diag(1, -i, 1)`. -/
noncomputable def U : Matrix (Fin 3) (Fin 3) ℂ := Matrix.diagonal ![1, -Complex.I, 1]

/-- The inverse phase gauge `U⁻¹ = diag(1, i, 1)`. -/
noncomputable def Udag : Matrix (Fin 3) (Fin 3) ℂ := Matrix.diagonal ![1, Complex.I, 1]

theorem U_mul_Udag : U * Udag = 1 := by
  simp only [U, Udag]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Complex.I_mul_I]

theorem Udag_mul_U : Udag * U = 1 := by
  simp only [U, Udag]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Complex.I_mul_I]

/-- The free two-body Hamiltonian (diagonal) commutes through the phase gauge. -/
theorem freeH2_conj (d : Fin 3 → ℝ) :
    U * ((freeH2 d).map (Complex.ofReal)) * Udag = (freeH2 d).map (Complex.ofReal) := by
  ext i j
  simp only [U, Udag, Matrix.mul_diagonal, Matrix.diagonal_mul]
  fin_cases i <;> fin_cases j <;>
    simp [freeH2, pairEnergy, Matrix.diagonal, Matrix.map_apply] <;> ring_nf <;> simp [Complex.I_sq]

/-- **The derived interaction is the modelled one in a phase gauge.**
`Vderived κ = U · (interaction κ)ℂ · U⁻¹`. -/
theorem Vderived_conj (kappa : ℝ) :
    Vderived kappa = U * ((interaction kappa).map (Complex.ofReal)) * Udag := by
  ext i j
  simp only [U, Udag, Matrix.mul_diagonal, Matrix.diagonal_mul]
  fin_cases i <;> fin_cases j <;>
    simp [Vderived, dGamma2, oneBodyClosure, closureCurvature, interaction,
      Matrix.smul_apply, Matrix.map_apply] <;> ring_nf <;> simp [Complex.I_sq]

/-- **Unitary equivalence.**  The derived two-body Hamiltonian is the modelled one
conjugated by the diagonal phase gauge: `H2der = U · H2ℂ · U⁻¹`. -/
theorem H2der_conj (d : Fin 3 → ℝ) (kappa : ℝ) :
    H2der d kappa = U * ((H2 d kappa).map (Complex.ofReal)) * Udag := by
  rw [H2der_eq d kappa, Vderived_conj kappa]
  have hmap : ((H2 d kappa).map (Complex.ofReal))
      = (freeH2 d).map (Complex.ofReal) + (interaction kappa).map (Complex.ofReal) := by
    rw [H2]; ext i j; simp [Matrix.map_apply, Matrix.add_apply]
  rw [hmap, Matrix.mul_add, Matrix.add_mul, freeH2_conj]

/-! ## Spectra -/

/-- The real spectrum of a complex matrix: real `μ` with a nonzero complex
eigenvector. -/
def spectrumC (M : Matrix (Fin 3) (Fin 3) ℂ) : Set ℝ :=
  {μ | ∃ v : Fin 3 → ℂ, v ≠ 0 ∧ M.mulVec v = (μ : ℂ) • v}

/-- The real spectrum of a real matrix (matching `spectrum2`). -/
def realSpec (M : Matrix (Fin 3) (Fin 3) ℝ) : Set ℝ :=
  {μ | ∃ v : Fin 3 → ℝ, v ≠ 0 ∧ M.mulVec v = μ • v}

theorem spectrum2_eq_realSpec (d : Fin 3 → ℝ) (kappa : ℝ) :
    spectrum2 d kappa = realSpec (H2 d kappa) := rfl

/-
**Conjugation invariance of the spectrum.**  For an invertible `P` (with
inverse `Q`), `spectrumC (P·M·Q) = spectrumC M`.
-/
theorem conj_spectrumC (M P Q : Matrix (Fin 3) (Fin 3) ℂ)
    (hPQ : P * Q = 1) (hQP : Q * P = 1) :
    spectrumC (P * M * Q) = spectrumC M := by
  ext μ;
  constructor <;> rintro ⟨ v, hv, hv' ⟩;
  · refine' ⟨ Q.mulVec v, _, _ ⟩;
    · intro h; have := congr_arg ( fun x => P.mulVec x ) h; norm_num [ hPQ, hQP, Matrix.mulVec_smul ] at this; aesop;
    · apply_fun Q.mulVec at hv';
      simp_all +decide [ ← Matrix.mul_assoc, Matrix.mulVec_smul ];
  · refine' ⟨ P.mulVec v, _, _ ⟩;
    · intro h; have := congr_arg ( fun x => Q.mulVec x ) h; norm_num [ hQP, Matrix.mulVec_mulVec ] at this; aesop;
    · simp_all +decide [ ← Matrix.mul_assoc, ← Matrix.mulVec_mulVec ];
      simp_all +decide [ ← Matrix.mul_assoc, ← Matrix.mulVec_smul ]

/-
**Real vs complex spectrum.**  A real matrix has the same real spectrum
whether tested against real or complex eigenvectors (real/imaginary parts of a
complex eigenvector are real eigenvectors for a real eigenvalue).
-/
theorem realComplexSpectrum (M : Matrix (Fin 3) (Fin 3) ℝ) :
    spectrumC (M.map (Complex.ofReal)) = realSpec M := by
  ext μ; constructor <;> rintro ⟨ v, hv, hv' ⟩;
  · -- Consider the real and imaginary part vectors `vr := fun i => (v i).re` and `vi := fun i => (v i).im`.
    set vr : Fin 3 → ℝ := fun i => (v i).re
    set vi : Fin 3 → ℝ := fun i => (v i).im;
    -- Taking real and imaginary parts of the eigen-equation componentwise, we get `M.mulVec vr = μ • vr` and `M.mulVec vi = μ • vi`.
    have h_real : M.mulVec vr = μ • vr := by
      ext i; replace hv' := congr_fun hv' i; simp_all +decide [ Complex.ext_iff, Matrix.mulVec, dotProduct ] ;
      exact hv'.1
    have h_imag : M.mulVec vi = μ • vi := by
      ext i; replace hv' := congr_fun hv' i; simp_all +decide [ Complex.ext_iff, Matrix.mulVec, dotProduct ] ;
      exact hv'.2;
    by_cases hvr : vr = 0;
    · use vi;
      simp_all +decide [ funext_iff, Complex.ext_iff ];
      exact hv.imp fun x hx => by aesop;
    · exact ⟨ vr, hvr, h_real ⟩;
  · refine' ⟨ fun i => v i, _, _ ⟩ <;> simp_all +decide [ funext_iff, Matrix.mulVec, dotProduct ];
    exact_mod_cast hv'

/-- **The derived Hamiltonian has the modelled spectrum.** -/
theorem spectrumC_H2der (d : Fin 3 → ℝ) (kappa : ℝ) :
    spectrumC (H2der d kappa) = spectrum2 d kappa := by
  rw [H2der_conj, conj_spectrumC _ _ _ U_mul_Udag Udag_mul_U, realComplexSpectrum,
    spectrum2_eq_realSpec]

/-! ## The main positive result: the derived interaction binds below threshold -/

/-- **The finite hadron bound state from a second-quantized closure operator
(conditional).**

For a sorted one-particle spectrum `d 0 ≤ d 1 ≤ d 2` and closure strength
`κ > 0`, the two-body Hamiltonian `H2der = dΓ(diag d + i·κ·K)` — the second
quantization of a one-body closure operator (in the binding plane), with **no**
hand-drawn interaction — has least eigenvalue `boundEnergy d κ` lying strictly
below the free two-body threshold.  So the below-threshold bound state of
`InteractingTwoBody` arises from a closure-geometric interaction rather than an
arbitrary form.  This is a **conditional** upgrade: the interaction is a genuine
`dΓ` of a closure curvature, but the curvature is not shown to be the carrier's
own `K` (this file does not import the carrier), so the unconditional
"the carrier's closure binds" stays grade **C** — see
`derived_wrongPlane_no_binding` for why the plane choice is decisive. -/
theorem derived_boundState_below_threshold
    (d : Fin 3 → ℝ) (kappa : ℝ) (hk : 0 < kappa)
    (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2) :
    IsLeast (spectrumC (H2der d kappa)) (boundEnergy d kappa) ∧
      boundEnergy d kappa < pairThreshold d := by
  rw [spectrumC_H2der]
  exact interacting_boundState_below_threshold d kappa hk h01 h12

/-! ## The honest obstruction: closure in the ground-mode plane does not bind -/

/-- An alternative closure curvature acting in the plane `{0,1}` (which *contains*
the ground mode `0`). -/
def closureCurvature2 : Matrix (Fin 3) (Fin 3) ℂ := !![0,-1,0; 1,0,0; 0,0,0]

noncomputable def oneBodyClosure2 (kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  (kappa : ℂ) • (Complex.I • closureCurvature2)

/-- The derived interaction from the ground-mode-plane closure: it couples the two
*heavier* pairs `{0,2}` (index 1) and `{1,2}` (index 2), leaving the ground pair
`{0,1}` (index 0) decoupled at the free threshold. -/
noncomputable def Vderived2 (kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  dGamma2 (oneBodyClosure2 kappa)

noncomputable def H2der2 (d : Fin 3 → ℝ) (kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  dGamma2 ((Matrix.diagonal d).map (Complex.ofReal) + oneBodyClosure2 kappa)

theorem Vderived2_eq (kappa : ℝ) :
    Vderived2 kappa = !![0,0,0; 0,0,-(kappa:ℂ)*Complex.I; 0,(kappa:ℂ)*Complex.I,0] := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Vderived2, dGamma2, oneBodyClosure2, closureCurvature2, Matrix.smul_apply]

/-- The real modelled analogue of `Vderived2`: a real symmetric coupling of the
two heavier pairs (indices 1,2) of strength `κ`. -/
def interaction2 (kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  !![0,0,0; 0,0,-kappa; 0,-kappa,0]

/-- The real Hamiltonian coupling the two heavier pairs. -/
def Hreal2 (d : Fin 3 → ℝ) (kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  freeH2 d + interaction2 kappa

theorem H2der2_eq (d : Fin 3 → ℝ) (kappa : ℝ) :
    H2der2 d kappa = (freeH2 d).map (Complex.ofReal) + Vderived2 kappa := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [H2der2, Vderived2, dGamma2, oneBodyClosure2, closureCurvature2, freeH2, pairEnergy,
      Matrix.diagonal, Matrix.smul_apply, Matrix.map_apply, Matrix.add_apply] <;> ring

/-- Phase gauge for the second obstruction: `U2 = diag(1,1,-i)`. -/
noncomputable def U2 : Matrix (Fin 3) (Fin 3) ℂ := Matrix.diagonal ![1, 1, -Complex.I]
noncomputable def Udag2 : Matrix (Fin 3) (Fin 3) ℂ := Matrix.diagonal ![1, 1, Complex.I]

theorem U2_mul_Udag2 : U2 * Udag2 = 1 := by
  simp only [U2, Udag2]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Complex.I_mul_I]

theorem Udag2_mul_U2 : Udag2 * U2 = 1 := by
  simp only [U2, Udag2]
  ext i j; fin_cases i <;> fin_cases j <;> simp [Complex.I_mul_I]

theorem freeH2_conj2 (d : Fin 3 → ℝ) :
    U2 * ((freeH2 d).map (Complex.ofReal)) * Udag2 = (freeH2 d).map (Complex.ofReal) := by
  ext i j
  simp only [U2, Udag2, Matrix.mul_diagonal, Matrix.diagonal_mul]
  fin_cases i <;> fin_cases j <;>
    simp [freeH2, pairEnergy, Matrix.diagonal, Matrix.map_apply] <;> ring_nf <;> simp [Complex.I_sq]

theorem Vderived2_conj (kappa : ℝ) :
    Vderived2 kappa = U2 * ((interaction2 kappa).map (Complex.ofReal)) * Udag2 := by
  ext i j
  simp only [U2, Udag2, Matrix.mul_diagonal, Matrix.diagonal_mul]
  fin_cases i <;> fin_cases j <;>
    simp [Vderived2, dGamma2, oneBodyClosure2, closureCurvature2, interaction2,
      Matrix.smul_apply, Matrix.map_apply] <;> ring_nf

theorem H2der2_conj (d : Fin 3 → ℝ) (kappa : ℝ) :
    H2der2 d kappa = U2 * ((Hreal2 d kappa).map (Complex.ofReal)) * Udag2 := by
  rw [H2der2_eq d kappa, Vderived2_conj kappa]
  have hmap : ((Hreal2 d kappa).map (Complex.ofReal))
      = (freeH2 d).map (Complex.ofReal) + (interaction2 kappa).map (Complex.ofReal) := by
    rw [Hreal2]; ext i j; simp [Matrix.map_apply, Matrix.add_apply]
  rw [hmap, Matrix.mul_add, Matrix.add_mul, freeH2_conj2]

theorem spectrumC_H2der2 (d : Fin 3 → ℝ) (kappa : ℝ) :
    spectrumC (H2der2 d kappa) = realSpec (Hreal2 d kappa) := by
  rw [H2der2_conj, conj_spectrumC _ _ _ U2_mul_Udag2 Udag2_mul_U2, realComplexSpectrum]

/-
**The ground pair stays at the free threshold.**  When the closure acts in the
ground-mode plane and is weak enough, `κ² ≤ (d 2 - d 0)(d 2 - d 1)`, the least
eigenvalue of the derived Hamiltonian `Hreal2` is *exactly* the free threshold
`d 0 + d 1`: the closure produces no binding below threshold.
-/
theorem Hreal2_isLeast_threshold (d : Fin 3 → ℝ) (kappa : ℝ)
    (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2)
    (hweak : kappa ^ 2 ≤ (d 2 - d 0) * (d 2 - d 1)) :
    IsLeast (realSpec (Hreal2 d kappa)) (d 0 + d 1) := by
  refine' ⟨ _, _ ⟩;
  · refine' ⟨ fun i => if i = 0 then 1 else 0, _, _ ⟩ <;> simp +decide [ Hreal2, freeH2, interaction2 ];
    · exact fun h => by simpa using congr_fun h 0;
    · ext i; fin_cases i <;> simp +decide [ Matrix.mulVec, dotProduct, pairEnergy ] ;
  · intro μ hμ; obtain ⟨ v, hv_ne_zero, hv_eq ⟩ := hμ; simp_all +decide [ Hreal2, freeH2, interaction2, pairEnergy, Matrix.mulVec ] ;
    -- From the equation $(Hreal2 d kappa).mulVec v = μ • v$, we can derive that $(d 0 + d 1 - μ) * ((d 0 + d 2 - μ) * (d 1 + d 2 - μ) - kappa^2) = 0$.
    have h_det : (d 0 + d 1 - μ) * ((d 0 + d 2 - μ) * (d 1 + d 2 - μ) - kappa^2) = 0 := by
      simp_all +decide [ ← List.ofFn_inj, Matrix.mulVec ];
      simp_all +decide [ Fin.sum_univ_three, dotProduct ];
      grind;
    contrapose! hweak; simp_all +decide [ sub_eq_iff_eq_add ] ;
    cases h_det <;> nlinarith [ mul_pos ( sub_pos.mpr hweak ) ( sub_pos.mpr hweak ) ]

/-- **The precise negative finding (obstruction map).**

If the carrier's closure curvature acts in a plane containing the ground mode,
its second-quantized two-body interaction couples only the *heavier* pairs and
leaves the ground pair decoupled.  Then for a sorted spectrum and closure that is
weak relative to the mass gaps, `κ² ≤ (d 2 - d 0)(d 2 - d 1)`, the least
eigenvalue of the derived Hamiltonian is *exactly* the free two-body threshold
`pairThreshold d = d 0 + d 1` — i.e. **no** bound state below threshold.

This bounds what the closure geometry can produce: binding below the constituent
threshold requires the closure to act among the excited modes (as in
`derived_boundState_below_threshold`); a ground-mode-plane closure does not
supply hadronic binding on its own. -/
theorem derived_wrongPlane_no_binding (d : Fin 3 → ℝ) (kappa : ℝ)
    (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2)
    (hweak : kappa ^ 2 ≤ (d 2 - d 0) * (d 2 - d 1)) :
    IsLeast (spectrumC (H2der2 d kappa)) (pairThreshold d) := by
  rw [spectrumC_H2der2, pairThreshold_eq d h01 h12]
  exact Hreal2_isLeast_threshold d kappa h01 h12 hweak

/-! ## Carrier grounding: the closure mode at `λ - κ` (ties `Δ = -κ`) -/

/-- The carrier one-particle mass block `B(λ,κ) = λ·I + i·κ·K`. -/
noncomputable def massBlock (lam kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  (lam : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) + oneBodyClosure kappa

theorem massBlock_isHermitian (lam kappa : ℝ) : (massBlock lam kappa).IsHermitian := by
  rw [Matrix.IsHermitian]
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [massBlock, oneBodyClosure, closureCurvature, Matrix.conjTranspose, Matrix.smul_apply]

/-- **Closure lowers the ground mass by `κ`.**  The carrier block has an explicit
eigenvector `![0, 1, -i]` with eigenvalue `λ - κ`: the closure produces a mode at
`λ - κ`, the block ground mass, matching the binding defect `Δ = -κ` of
`BindingDefect.lean` and pinning the interaction scale to `κ`. -/
theorem massBlock_groundMode (lam kappa : ℝ) :
    (massBlock lam kappa).mulVec ![0, 1, -Complex.I]
      = ((lam - kappa : ℝ) : ℂ) • ![0, 1, -Complex.I] := by
  ext i
  fin_cases i <;>
    simp [massBlock, oneBodyClosure, closureCurvature, Matrix.mulVec, dotProduct,
      Fin.sum_univ_three, Matrix.smul_apply, Matrix.one_apply, Matrix.add_apply] <;>
    ring_nf <;> simp [Complex.I_sq] <;> ring

end PhysicsSM.Draft.NullEdge.Carrier.DerivedInteraction
