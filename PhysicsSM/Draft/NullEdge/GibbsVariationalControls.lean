import PhysicsSM.Draft.NullEdge.GibbsVariational

/-!
# Non-hollow controls for the finite Gibbs variational principle

The general theorem `GibbsVariational.gibbs_maximizes_entropy` is meaningful
only if its feasible set can contain a competitor distinct from the Gibbs
distribution. In a two-state model, normalization plus one nonconstant mean-
energy constraint can already determine the distribution, making uniqueness
true before entropy enters.

This module supplies an exact three-level control. The energy observable is
nonconstant, with levels `[-1, 0, 1]`. At `beta = 0`, the Gibbs state is uniform.
The edge-supported competitor `[1/2, 0, 1/2]` is normalized, nonnegative,
distinct from Gibbs, and has the same mean energy zero. The landed variational
theorem then gives a strict entropy gap.

This demonstrates nontrivial optimization at the distribution level. It does
not remove the beta-zero boundary, prove a noncommuting density-matrix theorem,
or derive the supplied energies or inverse temperature.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GibbsVariationalControls

open scoped BigOperators
open GibbsVariational

/-- Three nonconstant energy levels symmetric about zero. -/
def energyThree : Fin 3 -> Real := ![-1, 0, 1]

/-- A normalized edge-supported competitor with the same mean energy as the
beta-zero Gibbs state. -/
def edgeCompetitor : Fin 3 -> Real := ![1 / 2, 0, 1 / 2]

theorem edgeCompetitor_nonneg (i : Fin 3) :
    0 <= edgeCompetitor i := by
  fin_cases i <;> norm_num [edgeCompetitor]

theorem edgeCompetitor_sum_one :
    ∑ i, edgeCompetitor i = 1 := by
  norm_num [edgeCompetitor, Fin.sum_univ_succ]

/-- At beta zero, the Gibbs distribution is exactly uniform on the three
levels. -/
theorem gibbs_energyThree_zero (i : Fin 3) :
    gibbs energyThree 0 i = 1 / 3 := by
  fin_cases i <;>
    norm_num [gibbs, partition, energyThree, Fin.sum_univ_succ]

/-- The explicit competitor and Gibbs state have the same mean energy. -/
theorem edgeCompetitor_same_energy :
    energy energyThree edgeCompetitor =
      energy energyThree (gibbs energyThree 0) := by
  unfold energy
  simp_rw [gibbs_energyThree_zero]
  norm_num [energyThree, edgeCompetitor, Fin.sum_univ_succ]

/-- The feasible competitor is genuinely distinct from the Gibbs state. -/
theorem edgeCompetitor_ne_gibbs :
    edgeCompetitor ≠ gibbs energyThree 0 := by
  intro h
  have h0 := congrFun h 0
  norm_num [edgeCompetitor, gibbs_energyThree_zero] at h0

/-- **Non-hollow strict control.** A distinct distribution with the same
nonconstant mean-energy constraint has strictly less entropy than Gibbs. -/
theorem edgeCompetitor_entropy_strict :
    shannonEntropy edgeCompetitor <
      shannonEntropy (gibbs energyThree 0) := by
  have h := gibbs_maximizes_entropy energyThree 0 edgeCompetitor
    edgeCompetitor_nonneg edgeCompetitor_sum_one edgeCompetitor_same_energy
  exact lt_of_le_of_ne h.1 (fun heq => edgeCompetitor_ne_gibbs (h.2.mp heq))

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GibbsVariationalControls.edgeCompetitor_same_energy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms edgeCompetitor_same_energy

/-- info: 'PhysicsSM.Draft.NullEdge.GibbsVariationalControls.edgeCompetitor_entropy_strict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms edgeCompetitor_entropy_strict

end PhysicsSM.Draft.NullEdge.GibbsVariationalControls
