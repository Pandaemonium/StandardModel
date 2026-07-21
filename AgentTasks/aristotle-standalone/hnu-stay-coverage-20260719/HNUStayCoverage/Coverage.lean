import PhysicsSM.Draft.NullEdge.HNUExactCore

/-!
# Stay-sector coverage in the eight-step HNU schedule

Every projector-conditioned HNU substep contains a complementary spin sector
that stays at the same site during that substep.  This target asks whether any
nonzero spin state can remain stationary through the entire microscopic
schedule.  The exact projector budget is also recorded.

The result distinguishes a local stay event from a globally stationary
primitive.  It does not by itself remove a Floquet partner or prove a physical
decoder.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore

noncomputable section

namespace HNUStayCoverage

/-- Sum of the moving projectors in the eight HNU factors, in the endpoint's
left-to-right factor order. -/
def movementBudget : M2 :=
  Pminus σ1 + Pminus σ3 + Pminus σ2 + Pplus σ3 +
    Pplus σ1 + Pminus σ3 + Pplus σ2 + Pplus σ3

/-- Each Pauli direction is covered equally over one complete schedule: the
eight moving projectors sum to four identities. -/
theorem movementBudget_eq_four :
    movementBudget = (4 : Complex) • (1 : M2) := by
  sorry

/-- A spinor fixed by every individual HNU factor for every phase. -/
def FixedByEverySubstep (v : Fin 2 -> Complex) : Prop :=
  (∀ θ, Uminus σ1 θ *ᵥ v = v) ∧
  (∀ θ, Uminus σ3 θ *ᵥ v = v) ∧
  (∀ θ, Uminus σ2 θ *ᵥ v = v) ∧
  (∀ θ, Uplus σ3 θ *ᵥ v = v) ∧
  (∀ θ, Uplus σ1 θ *ᵥ v = v) ∧
  (∀ θ, Uminus σ3 θ *ᵥ v = v) ∧
  (∀ θ, Uplus σ2 θ *ᵥ v = v) ∧
  (∀ θ, Uplus σ3 θ *ᵥ v = v)

/-- **No global stasis.** Although every individual substep has a stay sector,
their intersection over the complete HNU schedule is zero. -/
theorem fixedByEverySubstep_iff_zero (v : Fin 2 -> Complex) :
    FixedByEverySubstep v ↔ v = 0 := by
  sorry

/-- Nonvacuity control: every one of the six distinct conditioned Pauli
substeps occurring in the schedule has a nonzero stationary spinor. -/
theorem each_factor_has_nonzero_stationary_sector :
    (∃ v, v ≠ 0 ∧ ∀ θ, Uminus σ1 θ *ᵥ v = v) ∧
    (∃ v, v ≠ 0 ∧ ∀ θ, Uplus σ1 θ *ᵥ v = v) ∧
    (∃ v, v ≠ 0 ∧ ∀ θ, Uminus σ2 θ *ᵥ v = v) ∧
    (∃ v, v ≠ 0 ∧ ∀ θ, Uplus σ2 θ *ᵥ v = v) ∧
    (∃ v, v ≠ 0 ∧ ∀ θ, Uminus σ3 θ *ᵥ v = v) ∧
    (∃ v, v ≠ 0 ∧ ∀ θ, Uplus σ3 θ *ᵥ v = v) := by
  sorry

/-- A deliberately sharp control: the no-global-stasis theorem already
follows from the opposite `sigma1` conditioned factors. -/
theorem opposite_sigma1_factors_force_zero (v : Fin 2 -> Complex)
    (hm : ∀ θ, Uminus σ1 θ *ᵥ v = v)
    (hp : ∀ θ, Uplus σ1 θ *ᵥ v = v) :
    v = 0 := by
  sorry

end HNUStayCoverage
