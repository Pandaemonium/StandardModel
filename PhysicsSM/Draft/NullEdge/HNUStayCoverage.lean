import PhysicsSM.Draft.NullEdge.HNUExactCore

/-!
# Stay-sector coverage in the eight-step HNU schedule

Every projector-conditioned HNU substep contains a complementary spin sector
that stays at the same site during that substep. This module proves that the
six distinct conditioned Pauli factors all have nonzero stationary sectors,
while the intersection through the complete eight-step schedule is exactly
zero. The schedule also has the exact movement budget `4 I`.

The result distinguishes a local stay event from a globally stationary
primitive. It does not by itself remove a Floquet partner, prove a physical
decoder, or establish a continuum limit.

Provenance: theorem statements prepared in
`AgentTasks/aristotle-standalone/hnu-stay-coverage-20260719`; proofs completed
by Aristotle project `09a028fc-585e-4cbf-ab86-f6fbc352bb42`, task
`31f1fef7-8537-43a0-843b-9df6039227a9`, and downloaded for independent review
on 2026-07-19. The factor order and projector signs are inherited verbatim
from `HNUExactCore`.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUStayCoverage

/-- Sum of the moving projectors in the eight HNU factors, in the endpoint's
left-to-right factor order. -/
def movementBudget : M2 :=
  Pminus σ1 + Pminus σ3 + Pminus σ2 + Pplus σ3 +
    Pplus σ1 + Pminus σ3 + Pplus σ2 + Pplus σ3

/-- Each Pauli direction is covered equally over one complete schedule: the
eight moving projectors sum to four identities. -/
theorem movementBudget_eq_four :
    movementBudget = (4 : Complex) • (1 : M2) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [movementBudget, Pplus, Pminus, σ1, σ2, σ3]

/-- A spinor fixed by every individual HNU factor for every phase. -/
def FixedByEverySubstep (v : Fin 2 → Complex) : Prop :=
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
theorem fixedByEverySubstep_iff_zero (v : Fin 2 → Complex) :
    FixedByEverySubstep v ↔ v = 0 := by
  constructor
  · intro h_fixed
    have := h_fixed.1 (Real.pi / 2)
    have := h_fixed.2.2.2.2.1 (Real.pi / 2)
    simp_all +decide [Uminus, Uplus, Pplus, Pminus, σ1]
    simp_all +decide [← List.ofFn_inj, Complex.ext_iff,
      Matrix.mulVec, dotProduct]
    norm_num [Complex.exp_re, Complex.exp_im, Matrix.one_apply] at *
    constructor <;> constructor <;> linarith
  · intro hv
    simp [hv, FixedByEverySubstep] at *

/-- Nonvacuity control: every one of the six distinct conditioned Pauli
substeps occurring in the schedule has a nonzero stationary spinor. -/
theorem each_factor_has_nonzero_stationary_sector :
    (∃ v, v ≠ 0 ∧ ∀ θ, Uminus σ1 θ *ᵥ v = v) ∧
    (∃ v, v ≠ 0 ∧ ∀ θ, Uplus σ1 θ *ᵥ v = v) ∧
    (∃ v, v ≠ 0 ∧ ∀ θ, Uminus σ2 θ *ᵥ v = v) ∧
    (∃ v, v ≠ 0 ∧ ∀ θ, Uplus σ2 θ *ᵥ v = v) ∧
    (∃ v, v ≠ 0 ∧ ∀ θ, Uminus σ3 θ *ᵥ v = v) ∧
    (∃ v, v ≠ 0 ∧ ∀ θ, Uplus σ3 θ *ᵥ v = v) := by
  refine' ⟨_, _, _, _, _⟩ <;>
    norm_num [Uminus, Uplus, Pplus, Pminus, σ1, σ2, σ3,
      Matrix.mulVec] at *
  · refine' ⟨fun _ => 1, _, _⟩ <;>
      norm_num [funext_iff, Fin.forall_fin_two, Matrix.mulVec] at *
    ring_nf at *
    aesop
  · refine' ⟨fun i => if i = 0 then -1 else 1, _, _⟩ <;>
      norm_num [funext_iff, Fin.forall_fin_two]
    intro θ
    norm_num [Matrix.mulVec, dotProduct]
    ring_nf
    norm_num [Complex.exp_ne_zero]
  · refine' ⟨fun i => if i = 0 then 1 else Complex.I, _, _⟩ <;>
      norm_num [funext_iff, Fin.forall_fin_two]
    norm_num [Matrix.mulVec, dotProduct]
    ring
    norm_num [Complex.ext_iff, Complex.exp_re, Complex.exp_im]
  · refine' ⟨fun i => if i = 0 then 1 else -1 * Complex.I, _, _⟩ <;>
      norm_num [funext_iff, Fin.forall_fin_two]
    intro θ
    norm_num [Matrix.mulVec, dotProduct]
    ring
    norm_num [Complex.ext_iff, Complex.exp_re, Complex.exp_im]
  · constructor <;> norm_num [← List.ofFn_inj, Matrix.vecMul]
    · refine' ⟨fun i => if i = 0 then 1 else 0, _, _⟩ <;>
        norm_num [Matrix.mulVec]
    · refine' ⟨fun i => if i = 0 then 0 else 1, _, _⟩ <;>
        norm_num [Matrix.mulVec]

/-- A sharp control: the no-global-stasis theorem already follows from the
opposite `sigma1` conditioned factors. -/
theorem opposite_sigma1_factors_force_zero (v : Fin 2 → Complex)
    (hm : ∀ θ, Uminus σ1 θ *ᵥ v = v)
    (hp : ∀ θ, Uplus σ1 θ *ᵥ v = v) :
    v = 0 := by
  have := hm Real.pi
  have := hp Real.pi
  norm_num [σ1, Uminus, Uplus, Pplus, Pminus] at *
  simp_all +decide [Complex.ext_iff, funext_iff, Fin.forall_fin_two,
    Matrix.mulVec, dotProduct]
  have := hm 0
  have := hp 0
  have := hm (Real.pi / 2)
  have := hp (Real.pi / 2)
  norm_num [Complex.exp_re, Complex.exp_im] at *
  constructor <;> constructor <;> linarith

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUStayCoverage.fixedByEverySubstep_iff_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixedByEverySubstep_iff_zero

/-- info: 'PhysicsSM.Draft.NullEdge.HNUStayCoverage.each_factor_has_nonzero_stationary_sector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms each_factor_has_nonzero_stationary_sector

end PhysicsSM.Draft.NullEdge.HNUStayCoverage
