import PhysicsSM.Draft.NullEdge.HNURealSpaceCore

/-!
# Exact real-space ↔ momentum-space bridge for the HNU endpoint

This module assembles the finite real-space **spin-conditioned schedule** whose
exact Fourier symbol is, mode by mode, each `Uplus`/`Uminus` substep of the
supplied `HNUExactCore`, and whose depth-eight composite symbol is exactly
`HNUExactCore.endpoint`.

The building block is `HNURealSpace.condShift`, the projector-conditioned
nearest-neighbor shift proved unitary (inner-product preserving) and strictly
range-one local in `HNURealSpace.Core`.  Here we:

* fix the discrete momentum-to-real dictionary `kR`;
* identify each conditioned shift's exact symbol with `Uplus`/`Uminus`
  (`substep_*_symbol` + the concrete phase lemmas);
* compose the eight substeps and prove `schedule_symbol`:
  `schedule (planeWave v) = planeWave (endpoint (kR k) *ᵥ v)`;
* record the full-schedule unitarity `schedule_gInner`;
* prove the conditioned substep admits **no** spin-blind scalar-shift/fixed-coin
  factorization (`no_scalar_coin_factorization`);
* audit the stationary-sector vs primitive-null-support issue honestly
  (`stationary_sector_fixed`, `moving_sector_phase`, `W8_stationary`, and the
  `Primitive null-support audit` note below).

Nothing here infers `W=1`, continuum-Weyl behavior, anomaly cancellation, or
bulk-edge correspondence: those are separate gates, deliberately not touched.

Provenance: clean-room formalization returned by Aristotle job
`da29672d-5b8a-4e65-bac0-4d3d154dda57`. The stationary-sector results are part
of the payload: they prevent a local conditioned shift from being mislabeled as
an update in which every microscopic branch propagates on a null edge.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore

namespace PhysicsSM.Draft.NullEdge.HNURealSpace

noncomputable section

variable {L : ℕ}

/-! ## Discrete momentum → real momentum dictionary

For a discrete momentum index `k : Site L`, the axis-1,2 real momenta are
`2π n/L`; the axis-3 index runs over `Fin (2L)` and its real momentum is again
`2π n₃/L`, so that the axis-3 *half-step* `kR k 2 / 2 = π n₃ / L` is realized by
a single nearest-neighbor shift on the finer `2L` lattice. -/

/-- The real momentum vector fed to `endpoint`. -/
def kR (k : Site L) : Fin 3 → ℝ :=
  ![2 * Real.pi * (k.1.val : ℝ) / L,
    2 * Real.pi * (k.2.1.val : ℝ) / L,
    2 * Real.pi * (k.2.2.val : ℝ) / L]

@[simp] lemma kR_zero (k : Site L) : kR k 0 = 2 * Real.pi * (k.1.val : ℝ) / L := rfl
@[simp] lemma kR_one (k : Site L) : kR k 1 = 2 * Real.pi * (k.2.1.val : ℝ) / L := rfl
@[simp] lemma kR_two (k : Site L) : kR k 2 = 2 * Real.pi * (k.2.2.val : ℝ) / L := rfl

/-! ## Exact phases of the shifts as `exp (± i θ)` (item 3 inputs) -/

lemma char_shPlus1_exp [NeZero L] (hL : 2 ≤ L) (k x : Site L) :
    char k (shPlus1 x) = Complex.exp (I * ↑(kR k 0)) * char k x := by
  rw [char_shPlus1, cphase_one L k.1 (by omega), kR_zero]

lemma char_shPlus2_exp [NeZero L] (hL : 2 ≤ L) (k x : Site L) :
    char k (shPlus2 x) = Complex.exp (I * ↑(kR k 1)) * char k x := by
  rw [char_shPlus2, cphase_one L k.2.1 (by omega), kR_one]

lemma char_shPlus3_exp [NeZero L] (hL : 2 ≤ L) (k x : Site L) :
    char k (shPlus3 x) = Complex.exp (I * ↑(kR k 2 / 2)) * char k x := by
  have hL0 : (L : ℝ) ≠ 0 := by exact_mod_cast (NeZero.ne L)
  rw [char_shPlus3, cphase_one (2 * L) k.2.2 (by omega)]
  have hreal : (2 * Real.pi * ((k.2.2.val : ℕ) : ℝ) / ((2 * L : ℕ) : ℝ)) = kR k 2 / 2 := by
    rw [kR_two]; push_cast; rw [mul_comm 2 (L : ℝ)]; field_simp
  rw [hreal]

lemma char_shMinus1_exp [NeZero L] (hL : 2 ≤ L) (k x : Site L) :
    char k (shMinus1 x) = Complex.exp (-(I * ↑(kR k 0))) * char k x := by
  rw [char_shMinus1, cphase_one L k.1 (by omega), ← Complex.exp_neg, kR_zero]

lemma char_shMinus2_exp [NeZero L] (hL : 2 ≤ L) (k x : Site L) :
    char k (shMinus2 x) = Complex.exp (-(I * ↑(kR k 1))) * char k x := by
  rw [char_shMinus2, cphase_one L k.2.1 (by omega), ← Complex.exp_neg, kR_one]

lemma char_shMinus3_exp [NeZero L] (hL : 2 ≤ L) (k x : Site L) :
    char k (shMinus3 x) = Complex.exp (-(I * ↑(kR k 2 / 2))) * char k x := by
  have hL0 : (L : ℝ) ≠ 0 := by exact_mod_cast (NeZero.ne L)
  rw [char_shMinus3, cphase_one (2 * L) k.2.2 (by omega), ← Complex.exp_neg]
  have hreal : (2 * Real.pi * ((k.2.2.val : ℕ) : ℝ) / ((2 * L : ℕ) : ℝ)) = kR k 2 / 2 := by
    rw [kR_two]; push_cast; rw [mul_comm 2 (L : ℝ)]; field_simp
  rw [hreal]

/-! ## The eight conditioned-shift substeps (item 2)

`endpoint` writes its eight factors with the rightmost acting first.  We name the
real-space substep realizing each factor `Wᵢ`, in the same left-to-right order,
so that the schedule applies `W8` first. -/

variable [NeZero L]

/-- `f1 = Uminus σ1 (k 0)`. -/
def W1 : State L → State L := condShift (Pminus σ1) (Pplus σ1) shPlus1
/-- `f2 = Uminus σ3 (k 2 / 2)`. -/
def W2 : State L → State L := condShift (Pminus σ3) (Pplus σ3) shPlus3
/-- `f3 = Uminus σ2 (k 1)`. -/
def W3 : State L → State L := condShift (Pminus σ2) (Pplus σ2) shPlus2
/-- `f4 = Uplus σ3 (k 2 / 2)`. -/
def W4 : State L → State L := condShift (Pplus σ3) (Pminus σ3) shMinus3
/-- `f5 = Uplus σ1 (k 0)`. -/
def W5 : State L → State L := condShift (Pplus σ1) (Pminus σ1) shMinus1
/-- `f6 = Uminus σ3 (k 2 / 2)`. -/
def W6 : State L → State L := condShift (Pminus σ3) (Pplus σ3) shPlus3
/-- `f7 = Uplus σ2 (k 1)`. -/
def W7 : State L → State L := condShift (Pplus σ2) (Pminus σ2) shMinus2
/-- `f8 = Uplus σ3 (k 2 / 2)`. -/
def W8 : State L → State L := condShift (Pplus σ3) (Pminus σ3) shMinus3

/-- The full depth-eight real-space schedule (rightmost substep `W8` acts first). -/
def schedule (ψ : State L) : State L :=
  W1 (W2 (W3 (W4 (W5 (W6 (W7 (W8 ψ)))))))

/-! ## Exact per-substep symbol identification (item 3) -/

omit [NeZero L] in
/-- A `+`-conditioned shift whose character phase is `exp(-iθ)` has exact symbol
`Uplus s θ`. -/
lemma substep_plus_symbol (s : M2) (σ : Site L ≃ Site L) (θ : ℝ) (k : Site L)
    (v : Fin 2 → ℂ)
    (hc : ∀ x, char k (σ x) = Complex.exp (-(Complex.I * θ)) * char k x) :
    condShift (Pplus s) (Pminus s) σ (planeWave (char k) v)
      = planeWave (char k) (Uplus s θ *ᵥ v) := by
  rw [condShift_planeWave (Pplus s) (Pminus s) σ (char k)
      (Complex.exp (-(Complex.I * θ))) v hc]
  rfl

omit [NeZero L] in
/-- A `-`-conditioned shift whose character phase is `exp(+iθ)` has exact symbol
`Uminus s θ`. -/
lemma substep_minus_symbol (s : M2) (σ : Site L ≃ Site L) (θ : ℝ) (k : Site L)
    (v : Fin 2 → ℂ)
    (hc : ∀ x, char k (σ x) = Complex.exp (Complex.I * θ) * char k x) :
    condShift (Pminus s) (Pplus s) σ (planeWave (char k) v)
      = planeWave (char k) (Uminus s θ *ᵥ v) := by
  rw [condShift_planeWave (Pminus s) (Pplus s) σ (char k)
      (Complex.exp (Complex.I * θ)) v hc]
  rfl

/-! ## Depth-eight composition: the schedule symbol is exactly `endpoint` (item 4) -/

/-- **Main bridge.**  On every Fourier mode `k`, the finite real-space schedule
acts as multiplication by the exact depth-eight momentum-space symbol
`endpoint (kR k)`. -/
theorem schedule_symbol (hL : 2 ≤ L) (k : Site L) (v : Fin 2 → ℂ) :
    schedule (planeWave (char k) v) = planeWave (char k) (endpoint (kR k) *ᵥ v) := by
  unfold schedule W1 W2 W3 W4 W5 W6 W7 W8
  rw [substep_plus_symbol σ3 shMinus3 (kR k 2 / 2) k v (char_shMinus3_exp hL k),
      substep_plus_symbol σ2 shMinus2 (kR k 1) k _ (char_shMinus2_exp hL k),
      substep_minus_symbol σ3 shPlus3 (kR k 2 / 2) k _ (char_shPlus3_exp hL k),
      substep_plus_symbol σ1 shMinus1 (kR k 0) k _ (char_shMinus1_exp hL k),
      substep_plus_symbol σ3 shMinus3 (kR k 2 / 2) k _ (char_shMinus3_exp hL k),
      substep_minus_symbol σ2 shPlus2 (kR k 1) k _ (char_shPlus2_exp hL k),
      substep_minus_symbol σ3 shPlus3 (kR k 2 / 2) k _ (char_shPlus3_exp hL k),
      substep_minus_symbol σ1 shPlus1 (kR k 0) k _ (char_shPlus1_exp hL k)]
  congr 1
  rw [endpoint]
  simp only [mulVec_mulVec, mul_assoc]

/-! ## Full-schedule unitarity (item 2) -/

omit [NeZero L] in
/-- Inner-product preservation for a `+`-conditioned shift built from `s²=1`,
`sᴴ=s`. -/
lemma condShift_gInner_plus (s : M2) (hh : sᴴ = s) (hs : s * s = 1)
    (σ : Site L ≃ Site L) (ψ φ : State L) :
    gInner (condShift (Pplus s) (Pminus s) σ ψ) (condShift (Pplus s) (Pminus s) σ φ)
      = gInner ψ φ :=
  condShift_gInner (Pplus s) (Pminus s) σ (Pplus_herm hh) (Pminus_herm hh)
    (Pplus_idem hs) (Pminus_idem hs) (Pplus_mul_Pminus hs) (Pminus_mul_Pplus hs)
    (Pplus_add_Pminus s) ψ φ

omit [NeZero L] in
/-- Inner-product preservation for a `-`-conditioned shift. -/
lemma condShift_gInner_minus (s : M2) (hh : sᴴ = s) (hs : s * s = 1)
    (σ : Site L ≃ Site L) (ψ φ : State L) :
    gInner (condShift (Pminus s) (Pplus s) σ ψ) (condShift (Pminus s) (Pplus s) σ φ)
      = gInner ψ φ :=
  condShift_gInner (Pminus s) (Pplus s) σ (Pminus_herm hh) (Pplus_herm hh)
    (Pminus_idem hs) (Pplus_idem hs) (Pminus_mul_Pplus hs) (Pplus_mul_Pminus hs)
    ((add_comm _ _).trans (Pplus_add_Pminus s)) ψ φ

/-- **Schedule unitarity.**  The full depth-eight real-space schedule preserves
the state inner product. -/
theorem schedule_gInner (ψ φ : State L) :
    gInner (schedule ψ) (schedule φ) = gInner ψ φ := by
  unfold schedule W1 W2 W3 W4 W5 W6 W7 W8
  rw [condShift_gInner_minus σ1 σ1_herm σ1_sq,
      condShift_gInner_minus σ3 σ3_herm σ3_sq,
      condShift_gInner_minus σ2 σ2_herm σ2_sq,
      condShift_gInner_plus σ3 σ3_herm σ3_sq,
      condShift_gInner_plus σ1 σ1_herm σ1_sq,
      condShift_gInner_minus σ3 σ3_herm σ3_sq,
      condShift_gInner_plus σ2 σ2_herm σ2_sq,
      condShift_gInner_plus σ3 σ3_herm σ3_sq]

/-! ## No spin-blind scalar-shift/fixed-coin factorization (item 5)

A "spin-blind scalar-shift/fixed-coin" update has momentum symbol `φ(k) • C` for
a single momentum-independent coin `C`.  The conditioned substep symbol
`Uplus σ1 θ` is *not* of this form: as `θ` varies its matrix direction changes,
so no fixed `C` works. -/

/-- `Uplus σ1 θ` at entry `(0,1)` equals `(exp(-iθ) - 1)/2`. -/
lemma Uplus_σ1_entry01 (θ : ℝ) :
    (Uplus σ1 θ) 0 1 = (Complex.exp (-(Complex.I * θ)) - 1) / 2 := by
  simp [Uplus, Pplus, Pminus, σ1]
  ring

/-- `Uplus σ1 θ` at entry `(0,0)` equals `(exp(-iθ) + 1)/2`. -/
lemma Uplus_σ1_entry00 (θ : ℝ) :
    (Uplus σ1 θ) 0 0 = (Complex.exp (-(Complex.I * θ)) + 1) / 2 := by
  simp [Uplus, Pplus, Pminus, σ1]
  ring

/-- **No factorization.**  There is no fixed coin `C` and phase function `φ` with
`Uplus σ1 θ = φ θ • C` for all `θ`; the conditioned substep is genuinely
spin-conditioned, not a scalar shift times a fixed coin. -/
theorem no_scalar_coin_factorization :
    ¬ ∃ (C : M2) (φ : ℝ → ℂ), ∀ θ : ℝ, Uplus σ1 θ = φ θ • C := by
  rintro ⟨C, φ, h⟩
  have h0_00 : φ 0 * C 0 0 = 1 := by
    have hh := congrArg (fun M => M 0 0) (h 0)
    simp only [Uplus_σ1_entry00, Matrix.smul_apply, smul_eq_mul, Complex.ofReal_zero,
      mul_zero, neg_zero, Complex.exp_zero] at hh
    rw [← hh]; norm_num
  have h0_01 : φ 0 * C 0 1 = 0 := by
    have hh := congrArg (fun M => M 0 1) (h 0)
    simp only [Uplus_σ1_entry01, Matrix.smul_apply, smul_eq_mul, Complex.ofReal_zero,
      mul_zero, neg_zero, Complex.exp_zero] at hh
    rw [← hh]; norm_num
  have hexp : Complex.exp (-(Complex.I * (Real.pi : ℝ))) = -1 := by
    rw [show (-(Complex.I * (Real.pi : ℝ))) = -(Real.pi * Complex.I) from by ring,
      Complex.exp_neg, Complex.exp_pi_mul_I]
    norm_num
  have hπ_01 : φ Real.pi * C 0 1 = -1 := by
    have hh := congrArg (fun M => M 0 1) (h Real.pi)
    simp only [Uplus_σ1_entry01, Matrix.smul_apply, smul_eq_mul, hexp] at hh
    rw [← hh]; norm_num
  have hφ0 : φ 0 ≠ 0 := by
    intro hz; rw [hz, zero_mul] at h0_00; exact one_ne_zero h0_00.symm
  have hC01 : C 0 1 = 0 := by
    rcases mul_eq_zero.mp h0_01 with hcon | hcon
    · exact absurd hcon hφ0
    · exact hcon
  rw [hC01, mul_zero] at hπ_01
  exact absurd hπ_01 (by norm_num)

/-! ## Primitive null-support audit (item 6)

The `σ₃` plus-substep splits the spin space into a **moving** sector (the `σ₃`
`+1` eigenvector, which acquires the shift phase `exp(-iθ)`) and a **stationary**
complementary sector (the `σ₃` `-1` eigenvector, held fixed with phase `1`).  A
stationary complementary sector is *not* null propagation.

Because the eight substeps condition on three *different* Pauli axes
(`σ₁, σ₂, σ₃`), no single fixed spin eigenbasis is moved by every substep, so the
existence of a genuine primitive null link (a branch displaced on every tick,
under a declared time/spacing normalization) is **not** established by the symbol
bridge and remains the exact remaining obstruction.  The lattice has already been
refined (axis 3 doubled) so that every substep is an honest nearest-neighbor
lattice shift; the residual obstruction is purely the per-substep stationary
complementary sector, recorded exactly below. -/

/-- Moving sector: the `σ₃` `+1` eigenvector `![1,0]` acquires the shift phase. -/
lemma moving_sector_phase (θ : ℝ) :
    (Uplus σ3 θ) *ᵥ (![1, 0] : Fin 2 → ℂ)
      = Complex.exp (-(Complex.I * θ)) • (![1, 0] : Fin 2 → ℂ) := by
  funext i
  fin_cases i <;>
    (simp [Uplus, Pplus, Pminus, σ3, mulVec, dotProduct, Fin.sum_univ_two]; try ring)

/-- Stationary complementary sector: the `σ₃` `-1` eigenvector `![0,1]` is held
fixed by the substep symbol for *every* `θ` (phase `1`, no propagation). -/
lemma stationary_sector_fixed (θ : ℝ) :
    (Uplus σ3 θ) *ᵥ (![0, 1] : Fin 2 → ℂ) = (![0, 1] : Fin 2 → ℂ) := by
  funext i
  fin_cases i <;>
    (simp [Uplus, Pplus, Pminus, σ3, mulVec, dotProduct, Fin.sum_univ_two]; try norm_num)

/-- The stationary complementary sector is a nontrivial subspace: there is a
nonzero spin vector held fixed by the `σ₃` substep symbol for all `θ`.  This is
exactly why a per-tick "primitive null" link is not automatic. -/
theorem stationary_sector_nontrivial :
    ∃ w : Fin 2 → ℂ, w ≠ 0 ∧ ∀ θ : ℝ, (Uplus σ3 θ) *ᵥ w = w := by
  refine ⟨![0, 1], ?_, stationary_sector_fixed⟩
  intro hcontra
  have := congrArg (fun f => f 1) hcontra
  simp at this

/-- `Pplus σ3` annihilates the `σ₃` `-1` eigenvector. -/
lemma Pplus_σ3_e1 : (Pplus σ3) *ᵥ (![0, 1] : Fin 2 → ℂ) = 0 := by
  funext i
  fin_cases i <;> simp [Pplus, σ3, mulVec, dotProduct, Fin.sum_univ_two]

/-- `Pminus σ3` fixes the `σ₃` `-1` eigenvector. -/
lemma Pminus_σ3_e1 : (Pminus σ3) *ᵥ (![0, 1] : Fin 2 → ℂ) = ![0, 1] := by
  funext i
  fin_cases i <;> (simp [Pminus, σ3, mulVec, dotProduct, Fin.sum_univ_two]; try norm_num)

/-- Real-space form of the stationary sector: a plane wave carrying the `σ₃`
`-1` spin amplitude is a fixed point of the axis-3 plus-substep `W8`, for every
momentum `k`.  This is the exact microscopic witness of a stationary
complementary sector (no motion), the residual primitive-null obstruction. -/
theorem W8_stationary (k : Site L) :
    W8 (planeWave (char k) (![0, 1] : Fin 2 → ℂ)) = planeWave (char k) ![0, 1] := by
  unfold W8 condShift planeWave
  funext x
  rw [mulVec_smul, mulVec_smul, Pplus_σ3_e1, Pminus_σ3_e1, smul_zero, zero_add]

end

end PhysicsSM.Draft.NullEdge.HNURealSpace
