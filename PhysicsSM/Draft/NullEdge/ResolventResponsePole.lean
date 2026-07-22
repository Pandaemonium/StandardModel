import Mathlib

/-!

WAVE-3 AUDIT CORRECTION (2026-07-21, job `6ea8b5f0`, witnesses in
`MassLandingsAuditWave3`). A formula for the `(0,0)` ENTRY does not determine the full
response matrix, and therefore does not determine a two-point observable:
`AuditWitnesses.same_zero_zero_entry_different_full_response` exhibits two unequal matrices
sharing the displayed entry. Any sentence reading the entry formula as "the response" is an
over-claim; state it as an entry formula.
# Resolvent response: an explicit pole versus a propagator zero at the same gap edge

The correlator-level sharpening of the AFPL gap-to-pole obstruction (gate A4).
Two Hermitian involutions of `ℂ²` with the identical spectrum `{-1, +1}` have
retarded two-point response functions `G_H(z) = ⟨e0, (z • 1 - H)⁻¹ e0⟩` whose
analytic structure at the lower gap edge `z = -1` differs: `G_{Hpole}` has a
genuine pole there while `G_{Hdark}` is regular there (its pole sits at `z = +1`
instead).  This is the explicit "mass pole versus propagator zero" distinction at
the level of the actual response function, complementing the finite spectral-
weight fact `GapPoleResponseObstruction.gap_does_not_fix_pole`.

`Hpole = diag(-1, +1)`, `Hdark = diag(+1, -1)`.  For `z ∉ {-1, +1}` the shifted
matrices are invertible diagonals and the `(0,0)` entry of the inverse — the
physical response `⟨e0, (z-H)⁻¹ e0⟩` — is `(z+1)⁻¹` for `Hpole` (pole at `-1`)
and `(z-1)⁻¹` for `Hdark` (regular at `-1`, value `-1/2`).
-/

namespace PhysicsSM.Draft.NullEdge.ResolventResponsePole

open Matrix

def Hpole : Matrix (Fin 2) (Fin 2) ℂ := !![(-1 : ℂ), 0; 0, 1]
def Hdark : Matrix (Fin 2) (Fin 2) ℂ := !![(1 : ℂ), 0; 0, -1]

/-- **Resolvent response entries.**  For `z` off the spectrum the physical
two-point response `⟨e0, (z-H)⁻¹ e0⟩ = ((z • 1 - H)⁻¹) 0 0` is `(z+1)⁻¹` for the
pole model and `(z-1)⁻¹` for the dark model: the pole model is singular at the
lower gap edge `z = -1`, the dark model is regular there. -/
theorem resolvent_response_entries (z : ℂ) (hz1 : z ≠ 1) (hz2 : z ≠ -1) :
    ((z • (1 : Matrix (Fin 2) (Fin 2) ℂ) - Hpole)⁻¹) 0 0 = (z + 1)⁻¹ ∧
      ((z • (1 : Matrix (Fin 2) (Fin 2) ℂ) - Hdark)⁻¹) 0 0 = (z - 1)⁻¹ := by
  constructor <;> rw [Matrix.inv_def]
  · unfold Hpole
    norm_num [Matrix.det_fin_two, Matrix.adjugate_fin_two]
    ring_nf
    grind
  · simp +decide [Hdark, Matrix.det_fin_two, Matrix.adjugate_fin_two]
    grind

/-- **Residue at the lower gap edge distinguishes pole from zero.**  The residue
factor `(z + 1) · G_H(z)` at `z = -1` is the constant `1` for the pole model
(a genuine unit-residue pole) but tends to `0` for the dark model (no pole);
here stated algebraically for `z ∉ {-1, +1}` as `1` versus `(z+1)/(z-1)`, whose
value at `z = -1` is `0`. -/
theorem resolvent_residue_pole_vs_zero (z : ℂ) (hz1 : z ≠ 1) (hz2 : z ≠ -1) :
    (z + 1) * ((z • (1 : Matrix (Fin 2) (Fin 2) ℂ) - Hpole)⁻¹) 0 0 = 1 ∧
      (z + 1) * ((z • (1 : Matrix (Fin 2) (Fin 2) ℂ) - Hdark)⁻¹) 0 0
        = (z + 1) / (z - 1) := by
  convert resolvent_response_entries z hz1 hz2 using 1
  · grind +qlia
  · grind

end PhysicsSM.Draft.NullEdge.ResolventResponsePole
