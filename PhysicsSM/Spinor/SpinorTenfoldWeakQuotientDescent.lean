import PhysicsSM.Spinor.SpinorTenfoldWeakQuotient

/-!
# Descent of symmetries to the marked-pair weak quotient

`SpinorTenfoldWeakQuotient` derives the complex two-space

`weakQuotient = N1 / (N1 intersect N2)`

from the fixed ordered normal-form pure-spinor pair. This module isolates the
next exact gate: a complex-linear operator on the first annihilator induces an
operator on the quotient whenever it preserves the common color axis.

The construction is functorial. It preserves identities and composition, has
an exact criterion for acting trivially on the quotient, and can be transported
through the proved equivalence `weakQuotientLinearEquivC2` to a two-coordinate
linear operator.

Claim boundary: this is the descent API, not a derivation of a physical weak
action. No theorem here proves that the stabilizer of the marked spinor pair
preserves the relevant submodules, identifies the descended action with
`SU(2)_L`, or derives chirality or hypercharge.

Provenance: clean-room finite-dimensional quotient linear algebra composed
with `SpinorTenfoldWeakQuotient`. No external code and no compiled evaluator.

Status: trusted - proof complete under the pinned toolchain.
-/

noncomputable section

namespace PhysicsSM.Spinor.SpinorTenfold

/-- A linear operator preserving the common color axis descends to the weak
quotient. This definition makes the missing stabilizer-invariance hypothesis
explicit instead of inferring an action from the quotient dimension. -/
def weakQuotientDescend (f : VacuumAnnihilator →ₗ[Complex] VacuumAnnihilator)
    (hcolor : ∀ x ∈ colorAxisInVacuum, f x ∈ colorAxisInVacuum) :
    weakQuotient →ₗ[Complex] weakQuotient :=
  colorAxisInVacuum.mapQ colorAxisInVacuum f hcolor

@[simp] theorem weakQuotientDescend_mk
    (f : VacuumAnnihilator →ₗ[Complex] VacuumAnnihilator)
    (hcolor : ∀ x ∈ colorAxisInVacuum, f x ∈ colorAxisInVacuum)
    (x : VacuumAnnihilator) :
    weakQuotientDescend f hcolor (Submodule.Quotient.mk x) =
      Submodule.Quotient.mk (f x) := by
  simp [weakQuotientDescend, Submodule.mapQ_apply]

/-- The identity operator descends to the identity on the weak quotient. -/
theorem weakQuotientDescend_id :
    weakQuotientDescend LinearMap.id (fun _ hx => hx) = LinearMap.id := by
  apply LinearMap.ext
  intro q
  obtain ⟨x, rfl⟩ := Submodule.Quotient.mk_surjective colorAxisInVacuum q
  simp

/-- Descent respects composition. -/
theorem weakQuotientDescend_comp
    (f g : VacuumAnnihilator →ₗ[Complex] VacuumAnnihilator)
    (hf : ∀ x ∈ colorAxisInVacuum, f x ∈ colorAxisInVacuum)
    (hg : ∀ x ∈ colorAxisInVacuum, g x ∈ colorAxisInVacuum) :
    weakQuotientDescend (f.comp g) (fun _ hx => hf _ (hg _ hx)) =
      (weakQuotientDescend f hf).comp (weakQuotientDescend g hg) := by
  apply LinearMap.ext
  intro q
  obtain ⟨x, rfl⟩ := Submodule.Quotient.mk_surjective colorAxisInVacuum q
  simp

/-- Exact kernel criterion: a color-axis-preserving operator acts trivially on
the weak quotient exactly when its displacement of every annihilator vector
lies in the color axis. -/
theorem weakQuotientDescend_eq_id_iff
    (f : VacuumAnnihilator →ₗ[Complex] VacuumAnnihilator)
    (hcolor : ∀ x ∈ colorAxisInVacuum, f x ∈ colorAxisInVacuum) :
    weakQuotientDescend f hcolor = LinearMap.id ↔
      ∀ x : VacuumAnnihilator, f x - x ∈ colorAxisInVacuum := by
  constructor
  · intro h x
    have hx := LinearMap.congr_fun h (Submodule.Quotient.mk x)
    simp only [weakQuotientDescend_mk, LinearMap.id_coe, id_eq] at hx
    rw [Submodule.Quotient.eq] at hx
    exact hx
  · intro h
    apply LinearMap.ext
    intro q
    obtain ⟨x, rfl⟩ := Submodule.Quotient.mk_surjective colorAxisInVacuum q
    simp only [weakQuotientDescend_mk, LinearMap.id_coe, id_eq]
    rw [Submodule.Quotient.eq]
    exact h x

/-- A concrete displacement outside the color axis certifies a nontrivial
descended action. -/
theorem weakQuotientDescend_ne_id_of_exists
    (f : VacuumAnnihilator →ₗ[Complex] VacuumAnnihilator)
    (hcolor : ∀ x ∈ colorAxisInVacuum, f x ∈ colorAxisInVacuum)
    (hmove : ∃ x : VacuumAnnihilator, f x - x ∉ colorAxisInVacuum) :
    weakQuotientDescend f hcolor ≠ LinearMap.id := by
  rw [ne_eq, weakQuotientDescend_eq_id_iff]
  push_neg
  exact hmove

/-- The descended operator written in the proved two-coordinate model of the
weak quotient. This is a change of coordinates, not yet a physical `SU(2)`
representation. -/
def weakCoordinateAction
    (f : VacuumAnnihilator →ₗ[Complex] VacuumAnnihilator)
    (hcolor : ∀ x ∈ colorAxisInVacuum, f x ∈ colorAxisInVacuum) :
    (Fin 2 → Complex) →ₗ[Complex] (Fin 2 → Complex) :=
  weakQuotientLinearEquivC2.toLinearMap.comp
    ((weakQuotientDescend f hcolor).comp
      weakQuotientLinearEquivC2.symm.toLinearMap)

/-- Coordinate transport intertwines the descended quotient action with its
two-coordinate realization. -/
theorem weakCoordinateAction_intertwines
    (f : VacuumAnnihilator →ₗ[Complex] VacuumAnnihilator)
    (hcolor : ∀ x ∈ colorAxisInVacuum, f x ∈ colorAxisInVacuum)
    (q : weakQuotient) :
    weakCoordinateAction f hcolor (weakQuotientLinearEquivC2 q) =
      weakQuotientLinearEquivC2 (weakQuotientDescend f hcolor q) := by
  simp [weakCoordinateAction]

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Spinor.SpinorTenfold.weakQuotientDescend_comp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weakQuotientDescend_comp

/-- info: 'PhysicsSM.Spinor.SpinorTenfold.weakQuotientDescend_eq_id_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weakQuotientDescend_eq_id_iff

/-- info: 'PhysicsSM.Spinor.SpinorTenfold.weakQuotientDescend_ne_id_of_exists' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weakQuotientDescend_ne_id_of_exists

/-- info: 'PhysicsSM.Spinor.SpinorTenfold.weakCoordinateAction_intertwines' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weakCoordinateAction_intertwines

end PhysicsSM.Spinor.SpinorTenfold
