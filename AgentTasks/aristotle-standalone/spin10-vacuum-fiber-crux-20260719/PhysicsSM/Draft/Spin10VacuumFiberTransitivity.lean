import PhysicsSM.Draft.Spin10AnnihilatorIncidence

/-!
# Selector step 3: marked transitivity on the vacuum's `d = 3` fiber

Target statements for the Aristotle job `spin10-fiber-transitivity-20260719`.

Context.  The corrected-S1 chain now has: the reduction to
standardizability (landed, 215bd4d5), two-argument annihilator
equivariance and the basis-monomial Chevalley incidence with its
normal-form transport bridge (landed, e267089c), and the single-spinor
normal form in flight (371b7803).  The remaining geometric ingredient of
`standardizable_of_genuine_krasnov_pair` is THIS step: with the first
spinor pinned at the marked vacuum, the vacuum stabilizer moves any
partner in the `d = 3` fiber to the standard weak partner (up to a
nonzero scalar - the scale is threaded through `scalarUnit_mem`-style
machinery downstream).

Classical content: Witt-type extension for the spinor variety - pairs at
fixed relative position `d = 3` form one orbit, so the stabilizer of the
first component acts transitively on the fiber.

Pre-registered honesty license: if exact transitivity fails and only the
scalar-projective version holds, that IS the intended statement (the
scalar target below).  If even that fails, a kernel counterexample is a
first-class outcome.  Every `s o r r y` below is a documented Aristotle
handoff hole.
-/

noncomputable section

namespace PhysicsSM.Draft.Spin10VacuumFiberTransitivity

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.Spin10StabilizerTransitivity
open PhysicsSM.Draft.Spin10StandardizablePairs
open PhysicsSM.Draft.Spin10AnnihilatorIncidence

/-- **Warmup (compositional sanity): the fiber is stabilizer-invariant.**
Vacuum-stabilizer elements preserve membership in the vacuum's `d = 3`
fiber - by the landed two-argument equivariance plus the exact vacuum
fixing. -/
theorem inVacuumThreeFiber_of_stabilizer_smul
    (g : evenCliffordGroup) (hg : g ∈ vacuumStabilizer)
    (ψ : FockSpinor) (hψ : InVacuumThreeFiber ψ)
    (hpure : IsPureSpinor (g.val.val ψ)) :
    InVacuumThreeFiber (g.val.val ψ) := by
  refine ⟨hpure, ?_⟩
  convert annihilatorIntersectionDim_smul g vacuumSpinor ψ using 1
  · exact hg.symm ▸ rfl
  · exact hψ.2.symm

/-- **Kernel sanity anchor: the weak partner itself is in the fiber and is
reached trivially.**  Confirms the target class is inhabited in-kernel. -/
theorem weakSpinor_inVacuumThreeFiber : InVacuumThreeFiber weakSpinor := by
  exact ⟨isPureSpinor_weakSpinor, by
    convert basis_commonAnnihilator_finrank ∅ {3, 4} using 1⟩

theorem fiber_transitivity_weakSpinor :
    ∃ g : evenCliffordGroup, g ∈ vacuumStabilizer ∧
      ∃ c : ℂ, c ≠ 0 ∧ g.val.val weakSpinor = c • weakSpinor := by
  refine ⟨1, ?_, 1, ?_, ?_⟩ <;> norm_num

/-- Special case of marked transitivity for the projective weak-spinor line.
No Clifford generators are needed: the identity fixes the vacuum and the
nonzero scalar is retained. -/
theorem exists_vacuumStabilizer_smul_eq_scalar_weak_of_eq_smul
    (ψ : FockSpinor) (a : ℂ) (ha : a ≠ 0) (hψ : ψ = a • weakSpinor) :
    ∃ g : evenCliffordGroup, g ∈ vacuumStabilizer ∧
      ∃ c : ℂ, c ≠ 0 ∧ g.val.val ψ = c • weakSpinor := by
  refine ⟨1, ?_, a, ha, ?_⟩ <;> aesop

/-- **THE step-3 crux: marked transitivity on the vacuum fiber (scalar
form).**  Any member of the vacuum's `d = 3` fiber is carried to a
nonzero multiple of the standard weak partner by a vacuum-stabilizer
element. -/
theorem exists_vacuumStabilizer_smul_eq_scalar_weak
    (ψ : FockSpinor) (hψ : InVacuumThreeFiber ψ) :
    ∃ g : evenCliffordGroup, g ∈ vacuumStabilizer ∧
      ∃ c : ℂ, c ≠ 0 ∧ g.val.val ψ = c • weakSpinor := by
  sorry

end PhysicsSM.Draft.Spin10VacuumFiberTransitivity
