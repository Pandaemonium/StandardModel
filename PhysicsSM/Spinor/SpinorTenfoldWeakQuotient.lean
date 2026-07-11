import PhysicsSM.Spinor.SpinorTenfoldColorAxis

/-!
# The weak quotient derived from the marked Spin(10) pure-spinor pair

For the normal-form Krasnov pair `(vacuumSpinor, weakSpinor)`, the trusted
`SpinorTenfoldColorAxis` module derives the common annihilator
`N1 ∩ N2 ≃ C^3` and the first annihilator `N1 ≃ C^5`. This module defines
the quotient

`weakQuotient = N1 / (N1 ∩ N2)`

and proves that it has complex dimension two. Unlike an arbitrarily chosen
complement, the quotient is canonical once the ordered marked spinor pair is
fixed. An explicit direction supported on index `3` gives a nonzero quotient
class.

Claim boundary: this is a derived vector-space quotient. It does not yet prove
that a stabilizer action descends to the quotient, identify that action with
the physical `SU(2)_L`, derive hypercharge, or prove a full Standard Model
stabilizer theorem. The tokens "weak" in the declaration names are
physics-motivated labels, not proved identifications.

Provenance: clean-room composition of the kernel-checked annihilator and
dimension theorems in `SpinorTenfoldColorAxis`, motivated by Krasnov,
arXiv:2209.05088, especially the compatible split `C^5 = C^2 + C^3` and
Theorem A. No external code and no compiled evaluator.

Status: trusted - proof complete under the pinned toolchain.
-/

noncomputable section

namespace PhysicsSM.Spinor.SpinorTenfold

/-- The annihilator of the first marked pure spinor. -/
abbrev VacuumAnnihilator := annihilator vacuumSpinor

/-- The color axis, regarded as a submodule of the first annihilator rather
than of the ambient ten-dimensional quadratic space. -/
def colorAxisInVacuum : Submodule Complex VacuumAnnihilator :=
  colorAxisSubmodule.comap (Submodule.subtype (annihilator vacuumSpinor))

/-- Forgetting the nested subtype identifies the color axis inside `N1` with
the previously derived common annihilator `N1 ∩ N2`. -/
def colorAxisInVacuumEquiv :
    colorAxisInVacuum ≃ₗ[Complex] colorAxisSubmodule where
  toFun v := ⟨v.1.1, v.2⟩
  invFun c := ⟨⟨c.1, c.2.1⟩, c.2⟩
  left_inv _ := rfl
  right_inv _ := rfl
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- The nested color axis still has complex dimension three. -/
theorem finrank_colorAxisInVacuum :
    Module.finrank Complex colorAxisInVacuum = 3 := by
  rw [colorAxisInVacuumEquiv.finrank_eq, finrank_colorAxis]

/-- The two-dimensional quotient derived from the ordered marked spinor pair:
the first annihilator modulo the common color axis. The label "weak" is
motivational only; no `SU(2)_L` action is supplied or derived here. -/
abbrev weakQuotient := VacuumAnnihilator ⧸ colorAxisInVacuum

/-- An explicit weak direction: the annihilation coordinate supported at index
`3`, viewed inside the first annihilator. -/
def weakDirection3 : VacuumAnnihilator :=
  ⟨(0, fun i => if i = (3 : Fin 5) then 1 else 0),
    (mem_annihilator_vacuumSpinor_iff _).2 rfl⟩

/-- The explicit weak direction is not part of the color axis. -/
theorem weakDirection3_not_mem_colorAxis :
    weakDirection3 ∉ colorAxisInVacuum := by
  intro h
  change ((weakDirection3 : VacuumAnnihilator) : V10) ∈ colorAxisSubmodule at h
  have hc := (mem_colorAxis_iff _).1 h
  have h3 := hc.2.1
  simp [weakDirection3] at h3

/-- Therefore the explicit weak direction gives a nonzero quotient class. -/
theorem weakDirection3_class_ne_zero :
    (Submodule.Quotient.mk weakDirection3 : weakQuotient) ≠ 0 := by
  rw [ne_eq, Submodule.Quotient.mk_eq_zero]
  exact weakDirection3_not_mem_colorAxis

/-- Read the two residual annihilation coordinates, indexed by `3` and `4`. -/
def weakCoordinates : VacuumAnnihilator →ₗ[Complex] (Fin 2 → Complex) where
  toFun v := fun j => (v : V10).2 ⟨j.val + 3, by omega⟩
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Build a first-annihilator vector from its two weak coordinates. -/
def weakCoordinatesInv (w : Fin 2 → Complex) : VacuumAnnihilator :=
  ⟨(0, fun i =>
      if i = (3 : Fin 5) then w 0
      else if i = (4 : Fin 5) then w 1
      else 0),
    (mem_annihilator_vacuumSpinor_iff _).2 rfl⟩

/-- Every pair of weak coordinates has a representative in the first
annihilator. -/
theorem weakCoordinates_surjective : Function.Surjective weakCoordinates := by
  intro w
  refine ⟨weakCoordinatesInv w, ?_⟩
  funext j
  fin_cases j <;> simp [weakCoordinates, weakCoordinatesInv]

/-- The weak-coordinate map forgets exactly the common color axis. -/
theorem weakCoordinates_ker :
    LinearMap.ker weakCoordinates = colorAxisInVacuum := by
  ext v
  constructor
  · intro hv
    change ((v : VacuumAnnihilator) : V10) ∈ colorAxisSubmodule
    rw [mem_colorAxis_iff]
    have hv0 := congrFun hv 0
    have hv1 := congrFun hv 1
    refine ⟨(mem_annihilator_vacuumSpinor_iff _).1 v.2, ?_, ?_⟩
    · simpa [weakCoordinates] using hv0
    · simpa [weakCoordinates] using hv1
  · intro hv
    change ((v : VacuumAnnihilator) : V10) ∈ colorAxisSubmodule at hv
    rw [mem_colorAxis_iff] at hv
    funext j
    fin_cases j
    · simpa [weakCoordinates] using hv.2.1
    · simpa [weakCoordinates] using hv.2.2

/-- The quotient `N1 / (N1 intersect N2)` is linearly equivalent to `C^2`.
The quotient object is canonical for the fixed ordered pair and requires no
choice of a complement. This particular equivalence is coordinate-dependent:
it reads the ambient indices `{3,4}` fixed by the normal form and is defined
only up to a change of those two coordinates. -/
def weakQuotientLinearEquivC2 :
    weakQuotient ≃ₗ[Complex] (Fin 2 → Complex) :=
  (Submodule.quotEquivOfEq colorAxisInVacuum
      (LinearMap.ker weakCoordinates) weakCoordinates_ker.symm).trans
    (weakCoordinates.quotKerEquivOfSurjective weakCoordinates_surjective)

/-- The weak quotient derived from the marked pure-spinor pair has complex
dimension two. -/
theorem finrank_weakQuotient :
    Module.finrank Complex weakQuotient = 2 := by
  have hq := Submodule.finrank_quotient_add_finrank colorAxisInVacuum
  have hc : Module.finrank Complex colorAxisInVacuum = 3 :=
    finrank_colorAxisInVacuum
  have hv : Module.finrank Complex VacuumAnnihilator = 5 :=
    finrank_annihilator_vacuumSpinor
  have hq' : Module.finrank Complex weakQuotient +
      Module.finrank Complex colorAxisInVacuum =
        Module.finrank Complex VacuumAnnihilator := by
    simpa only [weakQuotient] using hq
  rw [hc, hv] at hq'
  omega

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Spinor.SpinorTenfold.colorAxisInVacuumEquiv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms colorAxisInVacuumEquiv

/-- info: 'PhysicsSM.Spinor.SpinorTenfold.weakDirection3_class_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weakDirection3_class_ne_zero

/-- info: 'PhysicsSM.Spinor.SpinorTenfold.weakCoordinates_ker' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weakCoordinates_ker

/-- info: 'PhysicsSM.Spinor.SpinorTenfold.weakQuotientLinearEquivC2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weakQuotientLinearEquivC2

/-- info: 'PhysicsSM.Spinor.SpinorTenfold.finrank_weakQuotient' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finrank_weakQuotient

end PhysicsSM.Spinor.SpinorTenfold
