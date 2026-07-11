import PhysicsSM.Draft.NullEdge.ChangingModeEmbedding

/-!
# Quantitative Sobolev-weighted tail rate on changing 3D mode boxes

This target upgrades qualitative square-summable exhaustion to an explicit
three-dimensional cutoff rate.  It is still a coefficient-space theorem, not
Shannon interpolation or position-space Dirac convergence.
-/

noncomputable section

open scoped BigOperators Topology

namespace PhysicsSM.Draft.NullEdge.SobolevTailRate

open ChangingModeEmbedding

/-- Max-coordinate radius of an integer three-momentum. -/
def modeRadius (k : Mode) : Nat :=
  k.1.1.natAbs ⊔ k.1.2.natAbs ⊔ k.2.natAbs

/-- Sobolev-shaped weighted squared mode energy. -/
def weightedModeEnergy {E : Type*} [Norm E]
    (s : Nat) (f : Mode -> E) : Real :=
  ∑' k, ((1 + modeRadius k : Nat) ^ s : Real) * ‖f k‖ ^ 2

theorem mem_modeBox_iff_radius_le (k : Mode) (N : Nat) :
    k ∈ modeBox N ↔ modeRadius k ≤ N := by
  sorry

theorem radius_ge_succ_of_not_mem {k : Mode} {N : Nat}
    (hk : k ∉ modeBox N) : N + 1 ≤ modeRadius k := by
  sorry

theorem cutoff_weight_le {k : Mode} {N s : Nat}
    (hk : k ∉ modeBox N) :
    ((N + 2 : Nat) ^ s : Real) ≤
      ((1 + modeRadius k : Nat) ^ s : Real) := by
  sorry

theorem residual_energy_eq_tail {E : Type*} [NormedAddCommGroup E]
    (N : Nat) (f : Mode -> E) :
    modeEnergy (fun k => f k - interpolate N (sample N f) k) =
      ∑' k, if k ∈ modeBox N then 0 else ‖f k‖ ^ 2 := by
  sorry

/-- Quantitative cutoff rate: `s` weighted derivatives control the squared
tail by the inverse `s`th power of the box radius. -/
theorem residual_energy_le_weighted_rate
    {E : Type*} [NormedAddCommGroup E]
    (s N : Nat) (f : Mode -> E)
    (hf : Summable
      (fun k => ((1 + modeRadius k : Nat) ^ s : Real) * ‖f k‖ ^ 2)) :
    modeEnergy (fun k => f k - interpolate N (sample N f) k) ≤
      (((N + 2 : Nat) ^ s : Real)⁻¹) * weightedModeEnergy s f := by
  sorry

/-- Sharp nonzero boundary control: a delta mode just beyond the positive
x-face saturates the pointwise cutoff weight. -/
theorem boundary_delta_weight_control (s N : Nat) :
    let q : Mode := ((((N + 1 : Nat) : Int), 0), 0)
    weightedModeEnergy s (deltaAt q (1 : Real)) =
      ((N + 2 : Nat) ^ s : Real) ∧
    modeEnergy (fun k =>
      deltaAt q (1 : Real) k -
        interpolate N (sample N (deltaAt q (1 : Real))) k) = 1 := by
  sorry

end PhysicsSM.Draft.NullEdge.SobolevTailRate
