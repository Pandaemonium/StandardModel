import PhysicsSM.Draft.NullEdge.PairModularSelection

/-!
# Phase-covariant modular selection of the Plücker pair generator

This module is the **convention-locked successor** to `DYNModularMaxEntCapstone`,
which fixed the transfer phase at `z = 1` and explicitly did *not* claim that the
selected modular flow observes the general complex Plücker phase.

The canonical rest block is `Bz z = !![0, z; conj z, 0]`
(`PairModularSelection.Bz`).  For the real transfer `Bz 1 = sigmaX` the capstone
proved unique fixed-energy Gibbs selection and the actual modular-flow equality.
The general rest operator is `Bz z`, where `z = spinorWedge ψ φ` carries an
oriented-area **phase** `arg z`.

## What is and is not phase

Two genuinely different phase notions are kept strictly separate here:

* **Single-site basis covariance (gauge).**  Multiplying `z` by a unit phase is
  an explicit diagonal *basis change*.  For `z ≠ 0` the diagonal unitary
  `phaseGauge z` conjugates `Bz z` to the phase-free real block `‖z‖ • Bz 1`
  (`phaseGauge_conj`).  Consequently the whole Gibbs/modular-flow ladder for
  `Bz z` is unitarily conjugate to the `Bz 1` ladder, with the phase absorbed and
  the modulus `‖z‖` rescaling the inverse temperature (`gibbsState_conj`,
  `modFlow_conj`).  The single-site *spectrum* only ever sees `‖z‖`
  (`single_site_phase_blind`): a single link's phase is gauge-removable.

* **Relative and operational phase.**  A single link phase is removable, while
  the bilinear comparing two links is invariant under their common phase change
  (`relative_phase_gauge_invariant`).  Invariance alone does not make an
  observable.  The separate supplied full-Fock evolution `Uop` does distinguish
  equal-modulus couplings with different phases
  (`PairModularSelection.pair_evolution_phase_sensitive`); that theorem is the
  operational witness, **not** the coordinate covariance above.

## Convention lock (orientation and the half-phase)

We fix the **asymmetric gauge** `phaseGauge z = diag(conj z / ‖z‖, 1)`, which is a
single-valued `U(2)` element for every `z ≠ 0` with determinant the pure phase
`conj z / ‖z‖`.  The **symmetric half-phase** `SU(2)` variant
`phaseGaugeHalf z = diag(exp(-i arg z / 2), exp(+i arg z / 2))` has determinant
`1` but is only defined up to the sign of the square root of the orientation
datum; it is provided as an alternative convention (`phaseGaugeHalf_conj`).  Both
conjugate `Bz z` to the same real block; the asymmetric one is chosen as the
canonical lock because it avoids the branch cut.

Nothing here divides by `‖z‖` without a `z ≠ 0` hypothesis; the `z = 0` boundary
(`Bz 0 = 0`, maximally mixed Gibbs state) is a separate control
(`Bz_zero`, `gibbsState_zero`), where there is no phase to observe.

## Scope

Finite `2 x 2` pair-sector algebra over the canonical repository symbols.  No
continuum, no Standard Model identification, no maximum-entropy *uniqueness*
beyond what `DYNModularMaxEntCapstone` already established for `z = 1`
(transported here by unitary conjugation).

## Provenance

Clean-room successor authored in-project (AFPL run 2026-07-13) over
`PairModularSelection` and `ModularSelection`.  Lean 4.28.0 / Mathlib.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection

open Matrix
open ModularSelection
open PhysicsSM.Draft.NullEdge.PairModularSelection
open PhysicsSM.Draft.NullEdge.PlueckerPairGenerator
open PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction

/-! ## The diagonal phase gauge (single-site basis covariance) -/

/-- **Asymmetric diagonal phase gauge** (convention lock).  For `z ≠ 0` this is a
`U(2)` element; it removes the phase of a single link. -/
def phaseGauge (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(starRingEnd ℂ) z / (‖z‖ : ℂ), 0; 0, 1]

/-- **Symmetric half-phase `SU(2)` gauge** (alternative convention).  Determinant
`1`, but defined only up to the sign of the half-phase square root. -/
def phaseGaugeHalf (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![Complex.exp (-(Complex.I * (z.arg : ℂ) / 2)), 0;
     0, Complex.exp (Complex.I * (z.arg : ℂ) / 2)]

/-- A real transfer is a real multiple of the canonical `Bz 1`. -/
theorem Bz_ofReal_eq_smul (r : ℝ) :
    Bz (r : ℂ) = (r : ℂ) • Bz 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Bz, Matrix.smul_apply, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.head_cons, Matrix.of_apply, Complex.conj_ofReal]

/-- The phase gauge has determinant equal to the pure phase `conj z / ‖z‖`. -/
theorem phaseGauge_det (z : ℂ) :
    (phaseGauge z).det = (starRingEnd ℂ) z / (‖z‖ : ℂ) := by
  simp [phaseGauge, Matrix.det_fin_two]

/--
The phase gauge is unitary for `z ≠ 0`.
-/
theorem phaseGauge_unitary (z : ℂ) (hz : z ≠ 0) :
    phaseGauge z * (phaseGauge z)ᴴ = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ phaseGauge, Matrix.mul_apply, Fin.sum_univ_two, Matrix.conjTranspose_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.of_apply, Matrix.one_apply ] ;
  rw [ div_mul_div_comm, div_eq_iff ] <;> norm_cast <;> simp +decide [ hz, Complex.mul_conj, Complex.normSq_eq_norm_sq ];
  simp +decide [ mul_comm, Complex.mul_conj, Complex.normSq_eq_norm_sq ];
  ring

/--
The phase gauge is invertible for `z ≠ 0` and its inverse is its adjoint.
-/
theorem phaseGauge_isUnit (z : ℂ) (hz : z ≠ 0) : IsUnit (phaseGauge z) := by
  -- The determinant of the phase gauge matrix is non-zero since $z \neq 0$.
  have h_det_nonzero : (phaseGauge z).det ≠ 0 := by
    grind +suggestions;
  rw [ Matrix.isUnit_iff_isUnit_det ] ; aesop;

theorem phaseGauge_inv (z : ℂ) (hz : z ≠ 0) :
    (phaseGauge z)⁻¹ = (phaseGauge z)ᴴ := by
  convert Matrix.inv_eq_right_inv ( phaseGauge_unitary z hz ) using 1

/--
**Single-site basis covariance (the gauge lemma).**  For `z ≠ 0` the diagonal
phase gauge conjugates the phased rest block `Bz z` to the phase-free real block
`‖z‖ • Bz 1`.  This is a *basis change*, not a spatial gauge field.
-/
theorem phaseGauge_conj (z : ℂ) (hz : z ≠ 0) :
    phaseGauge z * Bz z * (phaseGauge z)ᴴ = (‖z‖ : ℂ) • Bz 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ phaseGauge, Bz, Matrix.mul_apply ] <;> ring;
  · field_simp;
    rw [ div_eq_iff ] <;> norm_num [ Complex.ext_iff, hz ];
    norm_num [ ← sq, Complex.normSq_apply, Complex.norm_def ] ; ring;
    exact ⟨ by rw [ Real.sq_sqrt ( add_nonneg ( sq_nonneg _ ) ( sq_nonneg _ ) ) ], trivial ⟩;
  · rw [ ← div_eq_mul_inv, div_eq_iff ] <;> norm_cast <;> simp +decide [ hz, Complex.normSq_eq_norm_sq ];
    grind +suggestions

/-- Half-phase (symmetric `SU(2)`) form of the gauge lemma.  The `z ≠ 0`
hypothesis is retained to fix the intended domain of the half-phase gauge
(where `arg z` is the genuine orientation datum); the entrywise identity itself
extends to `z = 0`, where both sides vanish. -/
theorem phaseGaugeHalf_conj (z : ℂ) (hz : z ≠ 0) :
    phaseGaugeHalf z * Bz z * (phaseGaugeHalf z)ᴴ = (‖z‖ : ℂ) • Bz 1 := by
  unfold phaseGaugeHalf Bz; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff ] <;> ring <;> norm_num [ Complex.exp_re, Complex.exp_im ] ;
  · norm_num [ Matrix.vecMul, dotProduct ];
  · norm_num [ Matrix.vecMul ];
    norm_num [ Complex.exp_re, Complex.exp_im, vecHead, vecTail ] ; ring ; norm_num [ Complex.normSq, Complex.norm_def ];
    rw [ show z.re = Complex.normSq z ^ ( 1 / 2 : ℝ ) * Real.cos ( Complex.arg z ) by
          rw [ ← Real.sqrt_eq_rpow, Complex.normSq_eq_norm_sq, Real.sqrt_sq ( norm_nonneg _ ), Complex.norm_mul_cos_arg ], show z.im = Complex.normSq z ^ ( 1 / 2 : ℝ ) * Real.sin ( Complex.arg z ) by
                                                                                              norm_num [ ← Real.sqrt_eq_rpow, Complex.normSq_eq_norm_sq ] ] ; norm_num [ Real.sin_sq, Real.cos_sq ] ; ring ; norm_num [ Complex.normSq_eq_norm_sq, hz ] ;
    rw [ show z.arg = 2 * ( z.arg / 2 ) by ring, Real.sin_two_mul, Real.cos_two_mul ] ; ring ; norm_num [ ← Real.sqrt_eq_rpow ] ; ring;
    rw [ show Real.sin ( z.arg * ( 1 / 2 ) ) ^ 2 = 1 - Real.cos ( z.arg * ( 1 / 2 ) ) ^ 2 by rw [ Real.sin_sq ] ] ; ring ; norm_num [ hz ];
  · norm_num [ Complex.exp_re, Complex.exp_im, Matrix.vecMul, Matrix.vecHead, Matrix.vecTail ] ; ring;
    rw [ ← Complex.norm_mul_cos_arg, ← Complex.norm_mul_sin_arg ] ; ring ; norm_num [ Real.sin_sq, Real.cos_sq ] ; ring;
    rw [ show z.arg = 2 * ( z.arg / 2 ) by ring, Real.cos_two_mul, Real.sin_two_mul ] ; ring ; norm_num [ Real.sin_sq, Real.cos_sq ] ; ring;
    rw [ show Real.cos z.arg = 2 * Real.cos ( z.arg / 2 ) ^ 2 - 1 by rw [ ← Real.cos_two_mul ] ; ring ] ; ring;
  · simp +decide [ Matrix.vecMul, dotProduct ]

/-! ## Single-site spectrum is phase-blind -/

/--
**Single-site spectral phase-blindness.**  The rest block squares to the pure
modulus datum `‖z‖² • 1`; the single-site spectrum `±‖z‖` never sees `arg z`.
-/
theorem single_site_phase_blind (z : ℂ) :
    Bz z * Bz z = ((‖z‖ : ℂ) * (‖z‖ : ℂ)) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  -- By definition of Bz, we have Bz z * Bz z = (z * (starRingEnd ℂ) z) • 1.
  rw [PairModularSelection.Bz_sq];
  simp +decide [ ← mul_assoc, ← sq, Complex.mul_conj, Complex.normSq_eq_norm_sq ]

/--
**Normalized observable** `Bz z / ‖z‖`.  For `z ≠ 0` the modulus-normalized
rest block is gauged to the canonical `Bz 1`, so at fixed expectation of the
normalized observable the max-entropy selection is *unitarily identical* to the
`z = 1` capstone: the normalization by `‖z‖` (legal only for `z ≠ 0`) shows the
single-site max-entropy problem does not observe the phase.
-/
theorem normalized_observable_gauged (z : ℂ) (hz : z ≠ 0) :
    phaseGauge z * ((‖z‖ : ℂ)⁻¹ • Bz z) * (phaseGauge z)ᴴ = Bz 1 := by
  convert congr_arg ( fun x : Matrix ( Fin 2 ) ( Fin 2 ) ℂ => ( ‖z‖ : ℂ ) ⁻¹ • x ) ( phaseGauge_conj z hz ) using 1;
  · simp +decide [ mul_assoc, smul_smul ];
  · rw [ inv_smul_smul₀ ( Complex.ofReal_ne_zero.mpr <| norm_ne_zero_iff.mpr hz ) ]

/-! ## Gibbs-state and modular-flow covariance (explicit scale factors) -/

/--
**Gibbs-weight covariance.**  Conjugating the unnormalized Gibbs weight of
`Bz z` at inverse temperature `β` yields the Gibbs weight of `Bz 1` at the
rescaled inverse temperature `β · ‖z‖`.
-/
theorem gibbsWeight_conj (z : ℂ) (hz : z ≠ 0) (β : ℝ) :
    phaseGauge z * gibbsWeight (Bz z) β * (phaseGauge z)ᴴ
      = gibbsWeight (Bz 1) (β * ‖z‖) := by
  unfold gibbsWeight;
  convert ( Matrix.exp_conj ( phaseGauge z ) ( - ( β : ℂ ) • ( Bz z ) ) ( phaseGauge_isUnit z hz ) |> Eq.symm ) using 1;
  · rw [ phaseGauge_inv z hz ];
  · rw [ phaseGauge_inv z hz ];
    simp_all +decide [ Matrix.mul_smul, Matrix.smul_mul, phaseGauge_conj ];
    norm_num [ ← smul_assoc ];
    norm_cast

/--
**Partition-function covariance.**  Traces are unitarily invariant, so the
partition function of `Bz z` at `β` equals that of `Bz 1` at `β · ‖z‖`.
-/
theorem partition_conj (z : ℂ) (hz : z ≠ 0) (β : ℝ) :
    partition (Bz z) β = partition (Bz 1) (β * ‖z‖) := by
  convert congr_arg Matrix.trace ( gibbsWeight_conj z hz β |> Eq.symm ) using 1;
  · apply Eq.symm; exact (by
      have := gibbsWeight_conj z hz β;
      rw [ ← this, Matrix.trace_mul_comm ];
      convert Matrix.trace_mul_cycle ( ( phaseGauge z )ᴴ ) ( phaseGauge z ) ( gibbsWeight ( Bz z ) β ) using 1;
      · rw [ Matrix.mul_assoc ];
      · rw [ Matrix.mul_assoc, mul_eq_one_comm.mp ( phaseGauge_unitary z hz ) ] ; norm_num;
        rfl
    );
  · rw [ gibbsWeight_conj z hz β ];
    rfl

/--
**Gibbs-state covariance.**  The finite Gibbs state of `Bz z` at `β` is
unitarily conjugate (by the diagonal phase gauge) to the Gibbs state of `Bz 1` at
the rescaled inverse temperature `β · ‖z‖`.
-/
theorem gibbsState_conj (z : ℂ) (hz : z ≠ 0) (β : ℝ) :
    phaseGauge z * gibbsState (Bz z) β * (phaseGauge z)ᴴ
      = gibbsState (Bz 1) (β * ‖z‖) := by
  convert congr_arg ( fun x : Matrix ( Fin 2 ) ( Fin 2 ) ℂ => ( partition ( Bz ( z ) ) β ) ⁻¹ • x ) ( gibbsWeight_conj z hz β ) using 1;
  · simp +decide [ Matrix.mul_assoc, gibbsState ];
  · rw [ partition_conj z hz β ];
    rfl

/--
**Modular-flow covariance.**  The modular flow of the balanced Gibbs state of
`Bz z` is, after the diagonal phase gauge, the modular flow of `Bz 1` at the
rescaled modular time `β · ‖z‖`, acting on the gauged observable.  The phase is
carried entirely by the basis change; only `‖z‖` enters the flow.
-/
theorem modFlow_conj (z : ℂ) (hz : z ≠ 0) (β t : ℝ)
    (X : Matrix (Fin 2) (Fin 2) ℂ) :
    phaseGauge z * modFlow (Bz z) β t X * (phaseGauge z)ᴴ
      = modFlow (Bz 1) (β * ‖z‖) t (phaseGauge z * X * (phaseGauge z)ᴴ) := by
  -- By definition of `modFlow`, we can rewrite the left-hand side of the equation.
  rw [ModularSelection.modular_flow_of_gibbs, ModularSelection.modular_flow_of_gibbs] at *;
  have hconj : ∀ c : ℂ, phaseGauge z * NormedSpace.exp (c • Bz z) * (phaseGauge z)ᴴ = NormedSpace.exp ((c * (‖z‖ : ℂ)) • Bz 1) := by
    intro c;
    have h_exp_conj : ∀ c : ℂ, phaseGauge z * NormedSpace.exp (c • Bz z) * (phaseGauge z)ᴴ = NormedSpace.exp (phaseGauge z * (c • Bz z) * (phaseGauge z)ᴴ) := by
      intro c; exact (by
      have := @Matrix.exp_conj;
      convert this ( phaseGauge z ) ( c • Bz z ) ( phaseGauge_isUnit z hz ) |> Eq.symm using 1; all_goals rw [ phaseGauge_inv z hz ]);
    rw [ h_exp_conj, show phaseGauge z * c • Bz z * ( phaseGauge z ) ᴴ = c • ( phaseGauge z * Bz z * ( phaseGauge z ) ᴴ ) by simp +decide [ mul_assoc, smul_smul ] ];
    rw [ phaseGauge_conj z hz, smul_smul ];
  convert congr_arg₂ ( fun a b => a * ( phaseGauge z * X * ( phaseGauge z ) ᴴ ) * b ) ( hconj ( - ( Complex.I * β * t ) ) ) ( hconj ( Complex.I * β * t ) ) using 1 ; ring;
  · simp +decide [ ← mul_assoc, phaseGauge_unitary z hz ];
    have h_unitary : (phaseGauge z)ᴴ * phaseGauge z = 1 := by
      convert mul_eq_one_comm.mp ( phaseGauge_unitary z hz ) using 1;
    simp +decide [ mul_assoc, h_unitary ];
  · norm_num [ mul_assoc, mul_comm, mul_left_comm ]

/-! ## Relative phase and an operational witness (NOT coordinate covariance) -/

/--
**Gauge-invariance of a relative-phase bilinear.**  A common unit phase `u`
acts on two couplings `z₁, z₂` without changing `z₁ · conj z₂`.  This theorem
establishes an invariant candidate for comparing phases across links.  It does
not by itself construct a spatial connection, holonomy, or measurement.
-/
theorem relative_phase_gauge_invariant (u z₁ z₂ : ℂ)
    (hu : u * (starRingEnd ℂ) u = 1) :
    (u * z₁) * (starRingEnd ℂ) (u * z₂) = z₁ * (starRingEnd ℂ) z₂ := by
  grind +qlia

/-- **Operational phase witness (imported).**  The supplied full-Fock pair
evolution `Uop` distinguishes the equal-modulus fields `3 + 4i` and `5`; it reads
`arg z`.  This is the operational content that the single-site gauge lemma
`phaseGauge_conj` provably cannot see. -/
theorem operational_phase_observed :
    Uop 0 1 (3 + 4 * Complex.I) 5 (basisVec lowPair) highPair
      ≠ Uop 0 1 (5 : ℂ) 5 (basisVec lowPair) highPair :=
  pair_evolution_phase_sensitive

/-! ## `z = 0` boundary controls -/

/-- `z = 0` control: the rest block vanishes (no phase, no gauge). -/
theorem Bz_zero : Bz 0 = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Bz, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.of_apply]

/--
`z = 0` control: the Gibbs state of the vanishing generator is the maximally
mixed state `½ • 1` for every inverse temperature.
-/
theorem gibbsState_zero (β : ℝ) :
    gibbsState (Bz 0) β = (2 : ℂ)⁻¹ • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  unfold gibbsState gibbsWeight partition;
  -- By definition of $Bz$, we know that $Bz 0 = 0$.
  simp [Bz_zero];
  unfold gibbsWeight; norm_num [ NormedSpace.exp_zero ] ;

/-! ## Nonzero control -/

/--
Nonzero control (`z = 3 + 4i`, `‖z‖ = 5`): the phase gauge conjugates the
phased block to the real block `5 • Bz 1`.
-/
theorem phaseGauge_conj_control :
    phaseGauge (3 + 4 * Complex.I) * Bz (3 + 4 * Complex.I)
        * (phaseGauge (3 + 4 * Complex.I))ᴴ
      = (5 : ℂ) • Bz 1 := by
  convert phaseGauge_conj ( 3 + 4 * Complex.I ) ( by norm_num [ Complex.ext_iff ] ) using 2 ; norm_num [ Complex.normSq, Complex.norm_def ]

/-! ## Build-enforced assumption-footprint guards (standard three axioms only) -/

/-- info: 'PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection.phaseGauge_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phaseGauge_conj

/-- info: 'PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection.phaseGaugeHalf_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phaseGaugeHalf_conj

/-- info: 'PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection.single_site_phase_blind' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms single_site_phase_blind

/-- info: 'PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection.normalized_observable_gauged' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normalized_observable_gauged

/-- info: 'PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection.gibbsState_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gibbsState_conj

/-- info: 'PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection.modFlow_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms modFlow_conj

/-- info: 'PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection.relative_phase_gauge_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms relative_phase_gauge_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection.gibbsState_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gibbsState_zero

end PhysicsSM.Draft.NullEdge.PhaseCovariantModularSelection
