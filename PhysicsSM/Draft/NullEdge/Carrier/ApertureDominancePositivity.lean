/-
# Aperture dominance => total-operator positivity on the physical sector

DRAFT (kernel-clean; no `s o r r y`). The opener for the program's #1
next target after the S1-CC resolution (Fable call-02, Part C): total
-operator positivity on the doublet-free complement. This is the
program-wide bottleneck - the spectral-language rail lifts only when it
resolves, it is the precondition for the first-meson (S5) statement, and
it gives the finite Banks-Casher count its physical reading.

## The statement

S1-CC showed the closure channel is BALANCED (a bounded, SIGNED
perturbation) on the physical sector. The question is then whether the
aperture (kinetic) channel - which IS positive, its dominance constant the
trusted-core pairwise-disagreement gap - dominates the signed closure
channel on the doublet-free complement. This module lands the abstract
dominance rung:

`aperture_dominance_pos`: if a Hermitian-form split `A + C` has the
aperture part `A` bounded below by `c > 0` on a subspace `P`, and the
balanced part `C` bounded in absolute value by `kappa < c` there, then
`A + C` is positive-definite on `P`.

The physics then lives in two follow-up rungs (Fable Part C, handoff):
(rung 2) `kappa <= ||bivector|| * ||K||` for the closure channel by
submultiplicativity; (rung 3) compute `c` and `kappa` on the 6x6 S1-CC
witness by rational arithmetic - the first kernel-checked total-operator
positivity witness on a physical sector. The general Weyl eigenvalue-shift
refinement is an Aristotle package (Weyl inequalities are likely a genuine
Mathlib gap).

## Claim boundary

This is the pure inequality: bounded-below-plus-bounded-signed is positive
when the gap wins. No physics is claimed here; `A`, `C`, `c`, `kappa`, `P`
are abstract. Instantiating them with the carrier aperture/closure channels
and the physical sector is the (handed-off) content. No positivity of the
closure channel itself is claimed - the point is precisely that closure is
signed and only the SUM is positive.

Two instantiation traps (Fable call-02/03 review): (a) the conclusion is
positivity of `Re<v, (A+C) v>`; for a NON-Hermitian sum this is weaker than
operator positivity, so the physical instantiation must feed the KREIN form
`J . (Q_A + Q_C)` (Krein-self-adjoint), not the bare blocks; (b) `c > 0` is
not a separate hypothesis - it is implied (`hC` forces `kappa >= 0` on a
nonzero `v in P`, and `kappa < c`). This rung is the input to
`sector_ground_mass` (the Rayleigh-Ritz keystone that turns `min spec` into
a genuine mass - the manuscript's central open link, now ripe).

## Provenance

Fable call-02 (2026-07-08), Part C #1 - the recommended house-style opener
- [orig]/[interp]; the dominance inequality is elementary - [import].
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.ApertureDominancePositivity

open Matrix

variable {n : Type*} [Fintype n]

/-- **Aperture dominance rung.** For matrices `A` (aperture, positive) and
`C` (balanced closure, signed) and a subspace `P`, if the aperture
quadratic form is bounded below by `c > 0` on `P` and the closure form is
bounded in magnitude by `kappa < c` on `P`, then `A + C` is
positive-definite on `P \ {0}`. The gap `c - kappa` is the positivity
budget; in the physical instantiation `c` is the aperture (pairwise
-disagreement) gap and `kappa` the balanced-closure bound. -/
theorem aperture_dominance_pos (A C : Matrix n n ℂ)
    (P : Submodule ℂ (n → ℂ)) (c κ : ℝ) (hκc : κ < c)
    (hA : ∀ v ∈ P, c * ‖v‖ ^ 2 ≤ (star v ⬝ᵥ A.mulVec v).re)
    (hC : ∀ v ∈ P, |(star v ⬝ᵥ C.mulVec v).re| ≤ κ * ‖v‖ ^ 2) :
    ∀ v ∈ P, v ≠ 0 → 0 < (star v ⬝ᵥ (A + C).mulVec v).re := by
  intro v hv hv0
  have hsplit : (star v ⬝ᵥ (A + C).mulVec v).re
      = (star v ⬝ᵥ A.mulVec v).re + (star v ⬝ᵥ C.mulVec v).re := by
    rw [Matrix.add_mulVec, dotProduct_add, Complex.add_re]
  have hn : 0 < ‖v‖ ^ 2 := by
    have : 0 < ‖v‖ := norm_pos_iff.mpr hv0
    positivity
  have hAbound := hA v hv
  have hCbound := (abs_le.mp (hC v hv)).1
  have key : 0 < c * ‖v‖ ^ 2 - κ * ‖v‖ ^ 2 := by nlinarith [hn, hκc]
  rw [hsplit]
  linarith [hAbound, hCbound, key]

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.ApertureDominancePositivity.aperture_dominance_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms aperture_dominance_pos

end PhysicsSM.Draft.NullEdge.Carrier.ApertureDominancePositivity
