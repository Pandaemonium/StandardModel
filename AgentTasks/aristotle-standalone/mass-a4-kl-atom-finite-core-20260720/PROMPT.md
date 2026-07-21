# Lemma job: the finite core of the A4 named missing lemma (KL atom positivity)

Type: self-contained Mathlib-only theorem. AFPL gate A4. The A4 ladder reduced
the whole gate to one contracted analytic lemma `osterwalderSeiler_AFN_gap_to_KL_atom`
(OS positivity + changing-lattice regularity + overlap convergence + dispersion
convergence => positive dynamics + KL atom + residue + convergence). This job
proves its FINITE, continuum-free CORE, isolating exactly which part is pure
finite linear algebra and which part is the genuine analytic bridge.

## Target (finite core)

Let `T : Matrix (Fin m) (Fin m) ℝ` be symmetric positive definite (a
reflection-positive finite transfer matrix, `T = e^{-a H}`, `H` symmetric),
with a nondegenerate top eigenvalue `lam0 = ‖T‖` (ground state) and eigenvector
`e0`. For a physical observable `v`, define the ground KL atomic weight
`w0 = ⟨v, P0 v⟩` where `P0` is the rank-one projector onto `e0`. Prove:

1. `w0 ≥ 0` (positivity of the KL atom), and `w0 = |⟨e0, v⟩|²` for a unit `e0`;
2. `w0 > 0` iff the observable overlaps the ground state (`⟨e0, v⟩ ≠ 0`);
3. the ground-normalized correlation `⟨v, Tⁿ v⟩ / lam0ⁿ → w0` (so the atom is the
   large-`n` limit of the normalized correlation — the finite spectral-measure
   statement);
4. therefore the physical ground mass (`-log lam0` normalized, or the gap to the
   next level) is DETECTED by the correlation exactly when `w0 > 0`, and HIDDEN
   (propagator-zero) when `w0 = 0`.

A concrete diagonalized `T = diagonal d` with `d 0` strictly largest is an
acceptable rigorous form; state exactly what is proved. This is the finite core;
the continuum/changing-lattice limit (the genuine analytic bridge) is explicitly
OUT OF SCOPE — name it as the remaining piece.

## Constraints

Mathlib only; no new `axiom`/`opaque`/`unsafe`; no `native_decide`; standard
axioms. Report axioms. Success: the four finite-core facts proved, with the
continuum bridge named as the sole remaining analytic ingredient of
`osterwalderSeiler_AFN_gap_to_KL_atom`.
