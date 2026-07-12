import PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTangent

/-!
# Exact `9-40-41` off-corner alias for the stationary-amplitude Weyl walk

The deterministic oracle found a root on the symmetric slice
`q_y = -q_x`, `q_z = 0`.  Exact elimination gives
`cos(q_x) = -9/41`, `sin(q_x) = -40/41`.  This target promotes that candidate
to a rational Gaussian witness.

Preserve every statement.  In particular, retain the exact wrong-orientation
matrix entry: it proves that conjugate phase pairing is load-bearing rather
than a decorative choice.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylExactOffCornerAlias

open StationaryAmplitudeWeylTangent

def phaseX : Complex :=
  -(9 : Complex) / 41 - I * ((40 : Complex) / 41)

def phaseY : Complex :=
  -(9 : Complex) / 41 + I * ((40 : Complex) / 41)

theorem phaseX_conj_eq_phaseY : starRingEnd Complex phaseX = phaseY := by
  sorry

theorem phases_on_unit_circle :
    starRingEnd Complex phaseX * phaseX = 1 ∧
      starRingEnd Complex phaseY * phaseY = 1 := by
  sorry

/-- The first oracle off-corner candidate is an exact identity crossing. -/
theorem exact_offCorner_alias :
    weylStep phaseX phaseY 1 = 1 := by
  sorry

theorem offCorner_phase_ne_origin :
    phaseX ≠ 1 ∧ phaseY ≠ 1 := by
  sorry

/-- Negative control: using the same orientation on both axes destroys the
alias, with an exact nonzero off-diagonal entry. -/
theorem wrongOrientation_entry :
    (weylStep phaseX phaseX 1) 0 1 = -(1104 : Complex) / 1681 := by
  sorry

theorem wrongOrientation_not_alias :
    weylStep phaseX phaseX 1 ≠ 1 := by
  sorry

/-- Nondegenerate packaged witness for the manuscript and later root census. -/
theorem exists_exact_nonorigin_unitCircle_alias :
    ∃ zx zy : Complex,
      starRingEnd Complex zx * zx = 1 ∧
      starRingEnd Complex zy * zy = 1 ∧
      zx ≠ 1 ∧ zy ≠ 1 ∧ weylStep zx zy 1 = 1 := by
  sorry

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylExactOffCornerAlias
