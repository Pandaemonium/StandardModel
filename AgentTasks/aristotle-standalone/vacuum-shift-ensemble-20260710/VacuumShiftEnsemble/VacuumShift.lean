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
-/

namespace VacuumShiftEnsemble

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
  sorry

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
  sorry

/-- Target 3: sector decomposition — the total amplitude is the phase-
weighted sum of fixed-count sector amplitudes, with the phase depending only
on the sector count. -/
theorem sector_decomposition {g : ℕ} (N : Fin g → ℕ) (Zrel : Fin g → ℂ)
    (Λ : ℝ) (smax : ℕ) (hs : ∀ K, N K ≤ smax) :
    Ztot N Zrel Λ =
      ∑ s ∈ Finset.range (smax + 1),
        Complex.exp (Complex.I * (Λ : ℂ) * (s : ℂ)) *
          ∑ K ∈ Finset.univ.filter (fun K => N K = s), Zrel K := by
  sorry

/-- Target 4: non-extensive offsets are NOT gauge.  For the two-geometry
ensemble with counts `(1, 2)` and unit amplitudes, the quadratic offset
`exp (I π (N K)^2)` cannot be absorbed by any constant shift of `Λ`. -/
theorem nonextensive_not_absorbable :
    ¬ ∃ c' : ℝ, ∀ Λ : ℝ,
      Ztot (g := 2) ![1, 2]
          (fun K =>
            Complex.exp (Complex.I * (Real.pi : ℂ) * ((![1, 2] K : ℕ) : ℂ) ^ 2) *
              (1 : ℂ))
          Λ =
        Ztot (g := 2) ![1, 2] (fun _ => (1 : ℂ)) (Λ - c') := by
  sorry

end VacuumShiftEnsemble
