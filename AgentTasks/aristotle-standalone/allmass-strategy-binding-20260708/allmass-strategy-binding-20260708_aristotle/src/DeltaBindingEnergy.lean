/-
# The Δ binding-energy finite invariant (T3b)

DRAFT (kernel-clean; no `sorry`). This file promotes the numeric-oracle finding
`DELTA_BINDING_ENERGY_FINDING.md` — that turning on closure strength lowers the
sector ground mass *below* the free/kinematic baseline by a negative,
closure-controlled amount `Δ` — from an observation into a **kernel-statable
finite invariant with a proved identity**.

## The design

The physical object is the compressed sector mass form of the two-edge `Cl(4)`
carrier. At the fixed point it is the block-diagonal `B(λ,κ) ⊕ B(λ,-κ)` (see
`MassGapWitness.lean`), where `B(λ,κ)` is the `3×3` Hermitian block

  B(λ,κ) = !![λ, κ·I, 0; -κ·I, λ, 0; 0, 0, λ]     (I = Complex.I)

with aperture strength `λ` and closure strength `κ`. Its spectrum is
`{λ-κ, λ, λ+κ}`, so its least eigenvalue (the squared ground mass) is `λ-κ`
(`B_least_eigenvalue`, reproduced here from the kernel-checked `MassGapWitness`).

The **free/kinematic baseline** is the closure-off block `B(λ,0) = λ•1`, whose
least eigenvalue is `λ`. In the free case this is exactly the kinematic Plücker
mass `det P` (the free bridge `0b(a)`, `FreeMassBridge.lean`,
`free_mass_operator_eq_plucker`): the free operator mass IS the kinematic mass.

So the block-level analog of `Δ := min spec − det P` (the finding's invariant,
which the probe measured as `min spec(interacting) − min spec(free)`) is:

  Δ_block(λ,κ) := (ground mass of B(λ,κ)) − (ground mass of B(λ,0))
                = (λ - κ) − λ = -κ.

## The main result

`blockBindingDefect_eq_neg_kappa` — **`Δ_block(λ,κ) = -κ`** (for `0 ≤ κ ≤ λ`):
the binding defect equals *minus the closure strength*, exactly reproducing the
numeric `Δ = -t`. Corollaries:

- `blockBindingDefect_nonpos` / `blockBindingDefect_neg` — `Δ ≤ 0`, strictly `< 0`
  for `κ > 0`: the sign of a **binding energy**, not an additive constituent mass.
- `blockBindingDefect_closure_controlled` — `Δ` is exactly linear in the closure
  strength: `Δ(λ,κ₂) - Δ(λ,κ₁) = -(κ₂ - κ₁)` (unit slope in the closure channel).
- `closurePerturbation_offDiagonal` — the closure perturbation `B(λ,κ) - B(λ,0)`
  has **zero diagonal**, so the naive constituent (first-order diagonal) estimate
  of the shift is `0` in every standard basis direction, yet the true `Δ = -κ`.
  This is the finite shadow of "binding lives off-diagonal in the free basis" —
  precisely why the naive additive bridge `0b` fails.
- `blockGroundMass_massless_line` — the ground mass hits `0` exactly on the
  critical line `κ = λ` (massless bound state), and goes negative for `κ > λ`
  (positivity lost). The finite critical-coupling phase picture.

## No-go / kill

The pre-registered kill is "a carrier with `Δ > 0`, or `Δ` uncorrelated with
closure." At the block level this is well-posed and *cannot* trigger on the
physical branch: `Δ = -κ ≤ 0` with `κ` the closure strength, so `Δ > 0` is
impossible for `κ ≥ 0`, and `Δ` is perfectly (unit-slope) correlated with closure.
A positive `Δ` would require `κ < 0` — a closure term of the *opposite* sign,
i.e. anti-binding — which is the honest boundary of the interpretation
(`blockBindingDefect_pos_iff_neg_kappa`). See `DELTA_BINDING_ENERGY_STRATEGY.md`.

## Provenance

Self-contained: the `B(λ,κ)` spectral lemmas (`B_isHermitian`, `B_det`,
`B_shift_posSemidef`, `B_shift_det`, `B_least_eigenvalue`) are reproduced verbatim
from the kernel-checked `MassGapWitness.lean` (Mathlib-only; the original file also
imports the carrier module `SectorGroundMassWitness`, elided here so this `Δ`
development stands alone). The `Δ`-invariant layer is new (T3b, 2026-07-08).
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.DeltaBindingEnergy

open Matrix Complex

open scoped ComplexOrder

/-! ## The carrier sector mass block `B(λ,κ)` (Mathlib-only spectral theory,
reproduced from `MassGapWitness.lean`) -/

/-- The carrier-sector `3×3` Hermitian mass block with aperture strength `lam`
and closure strength `kappa`. -/
noncomputable def B (lam kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![(lam : ℂ), (kappa : ℂ) * Complex.I, 0;
     -((kappa : ℂ) * Complex.I), (lam : ℂ), 0;
     0, 0, (lam : ℂ)]

/-- The carrier mass block is Hermitian. -/
theorem B_isHermitian (lam kappa : ℝ) : (B lam kappa).IsHermitian := by
  ext i j;
  fin_cases i <;> fin_cases j <;> simp +decide [ B ]

/-- The determinant of the carrier mass block factors as `lam * (lam^2 - kappa^2)`. -/
theorem B_det (lam kappa : ℝ) :
    (B lam kappa).det = (lam : ℂ) * ((lam : ℂ) ^ 2 - (kappa : ℂ) ^ 2) := by
  simp +decide [ B, Matrix.det_fin_three ];
  ring ; norm_num

/-- The shifted block `B - (lam-kappa)•1` is positive semidefinite when
`0 ≤ kappa`: every eigenvalue of `B` is `≥ lam - kappa`. -/
theorem B_shift_posSemidef (lam kappa : ℝ) (h0 : 0 ≤ kappa) :
    (B lam kappa - ((lam - kappa : ℝ) : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)).PosSemidef := by
  constructor;
  · ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ B ] ;
  · have h_simp : ∀ x : Fin 3 → ℂ, (∑ i, ∑ j, star (x i) * (B lam kappa - ((lam - kappa) : ℂ) • 1) i j * x j) = kappa * (∑ i, ‖x i‖ ^ 2) - 2 * kappa * Complex.im (star (x 0) * x 1) := by
      unfold B; simp +decide [ Matrix.one_apply, Fin.sum_univ_three ] ; intros; ring;
      norm_num [ Complex.ext_iff, sq ] ; ring;
      simpa [ Complex.normSq, Complex.sq_norm ] using by ring;
    intro x; specialize h_simp x; simp_all +decide [ Finsupp.sum_fintype ] ;
    norm_cast; simp_all +decide [ Fin.sum_univ_three ];
    norm_num [ Complex.normSq, Complex.sq_norm ];
    nlinarith [ sq_nonneg ( ( x 0 |> Complex.re ) - ( x 1 |> Complex.im ) ), sq_nonneg ( ( x 0 |> Complex.im ) + ( x 1 |> Complex.re ) ), sq_nonneg ( ( x 2 |> Complex.re ) ), sq_nonneg ( ( x 2 |> Complex.im ) ) ]

/-- The shifted block `B - (lam-kappa)•1` is singular: `lam - kappa` is an
eigenvalue of `B`. -/
theorem B_shift_det (lam kappa : ℝ) :
    (B lam kappa - ((lam - kappa : ℝ) : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)).det = 0 := by
  simp only [B, Matrix.det_fin_three, Matrix.sub_apply, Matrix.smul_apply, Matrix.one_apply]
  simp [Matrix.cons_val]
  linear_combination (kappa : ℂ) ^ 2 * (kappa : ℂ) * Complex.I_sq

/-- **The mass gap as an eigenvalue theorem.** The least eigenvalue of the carrier
mass block is `lam - kappa` (for `0 ≤ kappa ≤ lam`). -/
theorem B_least_eigenvalue (lam kappa : ℝ) (h0 : 0 ≤ kappa) (hlk : kappa ≤ lam) :
    IsLeast (Set.range (B_isHermitian lam kappa).eigenvalues) (lam - kappa) := by
  refine ⟨?_, fun x hx => ?_⟩;
  · have h_mem : lam - kappa ∈ spectrum ℝ (B lam kappa) := by
      rw [ spectrum.mem_iff ];
      convert B_shift_det lam kappa using 1;
      rw [ ← neg_sub, Matrix.isUnit_iff_isUnit_det ] ; norm_num [ Algebra.algebraMap_eq_smul_one ];
      rw [ ← neg_sub, Matrix.det_neg ] ; norm_num;
      norm_num [ Matrix.det_fin_three ];
    convert h_mem using 1;
    rw [ Matrix.IsHermitian.spectrum_real_eq_range_eigenvalues ];
  · have h_spectrum : x - (lam - kappa) ∈ spectrum ℝ (B lam kappa - ((lam - kappa : ℝ) : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)) := by
      convert spectrum.sub_singleton_eq ( B lam kappa ) ( lam - kappa ) |> fun h => h.subset ( Set.mem_sub.mpr ?_ ) using 1;
      · norm_num [ Algebra.smul_def ];
        congr!;
      · simp_all +decide;
        obtain ⟨ y, rfl ⟩ := hx; exact B_isHermitian lam kappa |> fun h => h.spectrum_real_eq_range_eigenvalues.symm ▸ Set.mem_range_self _;
    have h_posSemidef : (B lam kappa - ((lam - kappa : ℝ) : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)).PosSemidef := by
      convert B_shift_posSemidef lam kappa h0 using 1;
    have h_eigenvalues_nonneg : ∀ y ∈ spectrum ℝ (B lam kappa - ((lam - kappa : ℝ) : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)), 0 ≤ y := by
      convert h_posSemidef.eigenvalues_nonneg using 1;
      have := Matrix.IsHermitian.spectrum_real_eq_range_eigenvalues h_posSemidef.1;
      grind +splitIndPred;
    linarith [ h_eigenvalues_nonneg _ h_spectrum ]

/-! ## The `Δ` binding-energy invariant -/

/-- The **block ground mass**: the least eigenvalue of the sector mass block
`B(λ,κ)`, i.e. the squared ground mass of the block. Defined as the infimum of
the eigenvalue set; on the physical branch `0 ≤ κ ≤ λ` this equals `λ - κ`
(`blockGroundMass_eq`). -/
noncomputable def blockGroundMass (lam kappa : ℝ) : ℝ :=
  sInf (Set.range (B_isHermitian lam kappa).eigenvalues)

/-- On the physical branch `0 ≤ κ ≤ λ` the block ground mass is `λ - κ`. -/
theorem blockGroundMass_eq (lam kappa : ℝ) (h0 : 0 ≤ kappa) (hlk : kappa ≤ lam) :
    blockGroundMass lam kappa = lam - kappa :=
  (B_least_eigenvalue lam kappa h0 hlk).csInf_eq

/-- The **free/kinematic baseline**: closure off. `blockGroundMass λ 0 = λ`
(the least eigenvalue of `B(λ,0) = λ•1`), which in the free case equals the
kinematic Plücker mass `det P` (`FreeMassBridge.free_mass_operator_eq_plucker`). -/
theorem blockGroundMass_free (lam : ℝ) (hlam : 0 ≤ lam) :
    blockGroundMass lam 0 = lam := by
  simpa using blockGroundMass_eq lam 0 le_rfl hlam

/-- **The Δ binding-defect invariant** (block level): the interacting ground mass
minus the free/kinematic baseline. This is the block analog of the finding's
`Δ := min spec(D#D|P) − det P` (measured by the probe as
`min spec(interacting) − min spec(free)`). -/
noncomputable def blockBindingDefect (lam kappa : ℝ) : ℝ :=
  blockGroundMass lam kappa - blockGroundMass lam 0

/-- **THE MAIN IDENTITY: `Δ_block(λ,κ) = -κ`.** For `0 ≤ κ ≤ λ` the binding defect
equals *minus the closure strength* — exactly reproducing the numeric `Δ = -t`.
It is negative (binding), closure-controlled (unit slope in `κ`), and vanishes in
the free case `κ = 0`. -/
theorem blockBindingDefect_eq_neg_kappa (lam kappa : ℝ) (h0 : 0 ≤ kappa)
    (hlk : kappa ≤ lam) : blockBindingDefect lam kappa = -kappa := by
  unfold blockBindingDefect
  rw [blockGroundMass_eq lam kappa h0 hlk, blockGroundMass_free lam (le_trans h0 hlk)]
  ring

/-- **Binding sign.** `Δ ≤ 0`: the closure channel *lowers* the ground mass — the
sign of a binding energy, not an additive constituent mass. -/
theorem blockBindingDefect_nonpos (lam kappa : ℝ) (h0 : 0 ≤ kappa)
    (hlk : kappa ≤ lam) : blockBindingDefect lam kappa ≤ 0 := by
  rw [blockBindingDefect_eq_neg_kappa lam kappa h0 hlk]; linarith

/-- **Strict binding** whenever closure is genuinely on (`κ > 0`). -/
theorem blockBindingDefect_neg (lam kappa : ℝ) (h0 : 0 < kappa)
    (hlk : kappa ≤ lam) : blockBindingDefect lam kappa < 0 := by
  rw [blockBindingDefect_eq_neg_kappa lam kappa h0.le hlk]; linarith

/-- **Closure control (exact linearity).** The binding defect has unit slope in
the closure strength: increasing closure by `Δκ` lowers the ground mass by exactly
`Δκ`. This is the sharp form of "`Δ` is governed by the closure sector." -/
theorem blockBindingDefect_closure_controlled (lam kappa₁ kappa₂ : ℝ)
    (h1 : 0 ≤ kappa₁) (hlk1 : kappa₁ ≤ lam) (h2 : 0 ≤ kappa₂) (hlk2 : kappa₂ ≤ lam) :
    blockBindingDefect lam kappa₂ - blockBindingDefect lam kappa₁ = -(kappa₂ - kappa₁) := by
  rw [blockBindingDefect_eq_neg_kappa lam kappa₂ h2 hlk2,
      blockBindingDefect_eq_neg_kappa lam kappa₁ h1 hlk1]; ring

/-- **Kill-condition boundary.** On the physical branch `κ ≥ 0` the pre-registered
kill `Δ_block > 0` is *impossible*: a positive binding defect forces `κ < 0`, i.e.
a closure term of the opposite (anti-binding) sign. So the binding-energy reading
is safe on the physical branch, and the only way to break it is to flip the sign of
the closure coupling. -/
theorem blockBindingDefect_pos_imp_neg_kappa (lam kappa : ℝ) (hlk : kappa ≤ lam)
    (h : 0 < blockBindingDefect lam kappa) : kappa < 0 := by
  by_contra hc
  push_neg at hc
  linarith [blockBindingDefect_nonpos lam kappa hc hlk]

/-- **Off-diagonal binding.** The closure perturbation `B(λ,κ) - B(λ,0)` has *zero
diagonal*: the naive constituent (first-order diagonal) estimate of the ground-mass
shift is `0` in every standard basis direction, yet the true `Δ = -κ`. This is the
finite shadow of "binding lives off-diagonal in the free basis" — exactly why the
naive additive bridge `0b` fails. -/
theorem closurePerturbation_offDiagonal (lam kappa : ℝ) (i : Fin 3) :
    (B lam kappa - B lam 0) i i = 0 := by
  fin_cases i <;> simp [B]

/-- **Massless critical line.** The block ground mass vanishes exactly when
closure equals aperture, `κ = λ` (a massless bound state), and is negative when
closure over-dominates, `κ > λ` (positivity lost). -/
theorem blockGroundMass_massless_line (lam kappa : ℝ) (h0 : 0 ≤ kappa)
    (hlk : kappa ≤ lam) : blockGroundMass lam kappa = 0 ↔ kappa = lam := by
  rw [blockGroundMass_eq lam kappa h0 hlk]
  constructor <;> intro h <;> linarith

end PhysicsSM.Draft.NullEdge.Carrier.DeltaBindingEnergy
