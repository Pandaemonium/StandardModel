import Mathlib

/-!
# Vacuum-shift redundancy on the finite geometry ensemble

Finite core of the proposed vacuum-shift gauge symmetry for the cosmological
constant: on the geometry path sum, a uniform per-event vacuum offset is not
separately observable from the bare cosmological chemical potential —
`(Z_rel, Λ) ↦ (e^{icN} Z_rel, Λ - c)` is an exact invariance — while a
NON-extensive offset is provably not absorbable.  This isolates where the
sequestering question actually lives: in the extensivity of the correction,
not in the phase bookkeeping.

Complements the landed single-complex multiplier result (`LambdaUnimodular`,
parent repository) by working on the ENSEMBLE of geometries, and the
submitted Λ statistics jobs (L3 susceptibility, L4 count dichotomy) by
treating redundancy rather than fluctuation.

## Setting

A finite ensemble of geometries `K : Fin g`, event counts `N : Fin g → ℕ`,
relative amplitudes `Zrel : Fin g → ℂ`.  The dressed total amplitude is
`Ztot N Zrel Λ = ∑ K, exp (I Λ N K) * Zrel K`.

## Targets

1. `vacuum_shift_invariance` — the combined shift is an exact invariance of
   the total amplitude: `Ztot N (fun K => exp (I c N K) * Zrel K) (Λ - c) =
   Ztot N Zrel Λ`.
2. `sector_correlator_invariant` — fixed-`N` normalized correlators are
   invariant under the vacuum shift alone (the per-sector phase cancels in
   the ratio).
3. `sector_decomposition` — the total amplitude decomposes over event-count
   sectors with the phase depending only on the sector.
4. `nonextensive_not_absorbable` — the negative control: for the explicit
   two-geometry ensemble `N = (1, 2)`, `Zrel = (1, 1)`, a quadratic
   (`N^2`-weighted) offset with `c = π` cannot be absorbed by ANY shift of
   `Λ`: there is no `c'` making the shifted total agree with
   `Ztot N Zrel (Λ - c')` for all `Λ`.  Only extensive offsets are gauge.

Do not weaken the statements.  Helper lemmas welcome.  Run the narrow check
`lake env lean VacuumShiftEnsemble/VacuumShift.lean` first; avoid a full
lake build until the holes are closed.
Recovered from Aristotle project `63170980-2893-416c-b36b-a412de5f70a8`; proof bodies verified locally
under the pinned toolchain before porting.
-/

namespace PhysicsSM.Draft.NullEdge.VacuumShiftEnsemble

open Complex

/-- The dressed total amplitude of a finite geometry ensemble. -/
noncomputable def Ztot {g : ℕ} (N : Fin g → ℕ) (Zrel : Fin g → ℂ)
    (Λ : ℝ) : ℂ :=
  ∑ K : Fin g, Complex.exp (Complex.I * (Λ : ℂ) * (N K : ℂ)) * Zrel K

/-- Target 1: the combined vacuum shift `(Zrel, Λ) ↦ (e^{icN} Zrel, Λ - c)`
is an exact invariance of the total amplitude. -/
theorem vacuum_shift_invariance {g : ℕ} (N : Fin g → ℕ) (Zrel : Fin g → ℂ)
    (Λ c : ℝ) :
    Ztot N (fun K => Complex.exp (Complex.I * (c : ℂ) * (N K : ℂ)) * Zrel K)
        (Λ - c) =
      Ztot N Zrel Λ := by
  unfold Ztot; congr; ext; push_cast [ ← mul_assoc, ← Complex.exp_add ] ; ring;

/-- Target 2: fixed-sector normalized correlators are invariant under the
vacuum shift alone: for any observable `O`, the sector ratio is unchanged
when every amplitude in the sector acquires the same per-event phase. -/
theorem sector_correlator_invariant {g : ℕ} (N : Fin g → ℕ)
    (Zrel O : Fin g → ℂ) (c : ℝ) (s : ℕ) :
    (∑ K ∈ Finset.univ.filter (fun K => N K = s),
        O K * (Complex.exp (Complex.I * (c : ℂ) * (N K : ℂ)) * Zrel K)) *
      (∑ K ∈ Finset.univ.filter (fun K => N K = s), Zrel K) =
    (∑ K ∈ Finset.univ.filter (fun K => N K = s), O K * Zrel K) *
      (∑ K ∈ Finset.univ.filter (fun K => N K = s),
        Complex.exp (Complex.I * (c : ℂ) * (N K : ℂ)) * Zrel K) := by
  simp +decide only [Finset.mul_sum _ _ _, mul_left_comm, mul_comm];
  exact Finset.sum_congr rfl fun i hi => Finset.sum_congr rfl fun j hj => by rw [ Finset.mem_filter ] at hi hj; rw [ hi.2, hj.2 ] ; ring;

/-- Target 3: sector decomposition — the total amplitude is the phase-
weighted sum of fixed-count sector amplitudes, with the phase depending only
on the sector count. -/
theorem sector_decomposition {g : ℕ} (N : Fin g → ℕ) (Zrel : Fin g → ℂ)
    (Λ : ℝ) (smax : ℕ) (hs : ∀ K, N K ≤ smax) :
    Ztot N Zrel Λ =
      ∑ s ∈ Finset.range (smax + 1),
        Complex.exp (Complex.I * (Λ : ℂ) * (s : ℂ)) *
          ∑ K ∈ Finset.univ.filter (fun K => N K = s), Zrel K := by
  simp +decide [ Finset.mul_sum, Finset.sum_filter, Ztot ];
  rw [ Finset.sum_comm, Finset.sum_congr rfl ] ; aesop

/-
Target 4 (ORIGINAL, as supplied): non-extensive offsets are NOT gauge.  For the
two-geometry ensemble with counts `(1, 2)` and unit amplitudes, the quadratic
offset `exp (I π (N K)^2)` cannot be absorbed by any constant shift of `Λ`.

*** THIS STATEMENT IS FALSE and is therefore preserved here only as a comment. ***

Reason.  The claimed "quadratic" offset is `exp (I π N^2)`.  But for every natural
number `N`, `N^2 - N = N (N-1)` is even, so `π N^2 ≡ π N (mod 2π)` and hence
`exp (I π N^2) = exp (I π N) = (-1)^N`.  Thus the quadratic offset is *identical*
to the EXTENSIVE (linear-in-`N`) offset with parameter `c = π`, and is trivially
absorbed by the corresponding `Λ`-shift.

Concretely, for the `(1, 2)` ensemble the offset weights are
`(exp (iπ·1²), exp (iπ·2²)) = (e^{iπ}, e^{4iπ}) = (-1, +1)`.  An extensive shift
`Λ ↦ Λ - c'` multiplies the count-`N` term by `e^{-i c' N}`, so matching demands
`e^{-i c'} = -1` and `e^{-2 i c'} = +1`.  The docstring's proposed "ratio
contradiction" does not exist: `e^{-i c'} = -1` already *forces*
`e^{-2 i c'} = (e^{-i c'})^2 = 1`, so `c' = π` satisfies both constraints.
The corrected, true statement is `quadratic_offset_absorbable` below.

theorem nonextensive_not_absorbable :
    ¬ ∃ c' : ℝ, ∀ Λ : ℝ,
      Ztot (g := 2) ![1, 2]
          (fun K =>
            Complex.exp (Complex.I * (Real.pi : ℂ) * ((![1, 2] K : ℕ) : ℂ) ^ 2) *
              (1 : ℂ))
          Λ =
        Ztot (g := 2) ![1, 2] (fun _ => (1 : ℂ)) (Λ - c') := by
  sorry
-/

/-- Target 4 (CORRECTED): the `(1, 2)` quadratic offset `exp (I π N^2)` *is* in
fact gauge, because `exp (I π N^2) = (-1)^N = exp (I π N)` is extensive.  It is
absorbed by the constant shift `c' = π`.  This is the honest replacement for the
false `nonextensive_not_absorbable`: for this ensemble the negative control fails
because `N^2 ≡ N (mod 2)`. -/
theorem quadratic_offset_absorbable :
    ∃ c' : ℝ, ∀ Λ : ℝ,
      Ztot (g := 2) ![1, 2]
          (fun K =>
            Complex.exp (Complex.I * (Real.pi : ℂ) * ((![1, 2] K : ℕ) : ℂ) ^ 2) *
              (1 : ℂ))
          Λ =
        Ztot (g := 2) ![1, 2] (fun _ => (1 : ℂ)) (Λ - c') := by
  refine ⟨Real.pi, fun Λ => ?_⟩
  have hpi : Complex.exp (Complex.I * (Real.pi : ℂ)) = -1 := by
    have := Complex.exp_pi_mul_I
    rw [show Complex.I * (Real.pi : ℂ) = (Real.pi : ℂ) * Complex.I by ring]; exact this
  simp only [Ztot, Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one]
  push_cast
  rw [show Complex.I * (Real.pi : ℂ) * (1 : ℂ) ^ 2 = Complex.I * (Real.pi : ℂ) by ring,
      show Complex.I * (Real.pi : ℂ) * (2 : ℂ) ^ 2
            = Complex.I * (Real.pi : ℂ)
              + (Complex.I * (Real.pi : ℂ)
                + (Complex.I * (Real.pi : ℂ) + Complex.I * (Real.pi : ℂ))) by ring,
      show Complex.I * ((Λ : ℂ) - (Real.pi : ℂ)) * 1
            = Complex.I * (Λ : ℂ) * 1 + (-(Complex.I * (Real.pi : ℂ))) by ring,
      show Complex.I * ((Λ : ℂ) - (Real.pi : ℂ)) * 2
            = Complex.I * (Λ : ℂ) * 2
              + (-(Complex.I * (Real.pi : ℂ)) + -(Complex.I * (Real.pi : ℂ))) by ring]
  simp only [Complex.exp_add, Complex.exp_neg, hpi]
  ring

end PhysicsSM.Draft.NullEdge.VacuumShiftEnsemble

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.VacuumShiftEnsemble.vacuum_shift_invariance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.VacuumShiftEnsemble.vacuum_shift_invariance

/-- info: 'PhysicsSM.Draft.NullEdge.VacuumShiftEnsemble.quadratic_offset_absorbable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.VacuumShiftEnsemble.quadratic_offset_absorbable
