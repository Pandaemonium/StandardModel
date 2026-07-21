import PhysicsSM.Draft.Spin10VacuumChartQuadrics

/-!
# Reconstruction in the normalized Spin(10) vacuum chart

The ordered product of the ten elementary creation roots reconstructs an even
spinor in the normalized vacuum chart from its degree-two coordinates, provided
the established pure-spinor quadrics hold. The product is then lifted to the
algebraic even Clifford group.

This is an affine-chart theorem. It does not prove that every pure spinor enters
this chart or close the global pair-transitivity theorem.

Provenance: Aristotle project `76823bf2-3010-45f0-9f8e-7bb531dfc3f2`, using
the project XOR/Fock and Spin(10) conventions.
-/

noncomputable section

namespace PhysicsSM.Draft.Spin10StandardizablePairs

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.Spin10StabilizerTransitivity

/-- The fixed ordered product of creation roots reconstructs every normalized
spinor in the vacuum chart from its degree-two coordinates. -/
lemma creationChartEnd_vacuum_eq_of_quadric_chart
    (ψ : FockSpinor) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) (h0 : ψ ∅ = 1) :
    creationChartEnd ψ vacuumSpinor = ψ := by
  by_contra h_contra
  unfold creationChartEnd at h_contra
  simp_all +decide [creationRootEnd]
  simp +decide [funext_iff] at h_contra
  simp +decide [vacuumSpinor, basisSpinor, wedge] at h_contra
  obtain ⟨x, hx⟩ := h_contra
  fin_cases x <;> simp +decide at hx
  all_goals simp_all +decide [opSign, IsEvenSpinor]
  all_goals contrapose! hx; simp_all +decide
  all_goals try rfl
  · convert quadric_coord_0123 ψ heven hquad h0 |> Eq.symm using 1
    ring
  · convert quadric_coord_0124 ψ heven hquad h0 |> Eq.symm using 1
    ring
  · convert quadric_coord_0134 ψ heven hquad h0 |> Eq.symm using 1
    ring
  · convert quadric_coord_0234 ψ heven hquad h0 |> Eq.symm using 1
    ring
  · convert quadric_coord_1234 ψ heven hquad h0 |> Eq.symm using 1
    ring

/-- The fixed chart product is represented by an element of the algebraic
even Clifford group. -/
lemma creationChartEnd_mem (ψ : FockSpinor) :
    ∃ g : evenCliffordGroup, g.val.val = creationChartEnd ψ := by
  have h_factors : ∀ i j : Fin 5, i ≠ j →
      ∃ g : evenCliffordGroup, g.val.val = creationRootEnd i j (ψ {i, j}) := by
    intro i j hij
    exact creationRootEnd_mem i j (ψ {i, j}) hij
  choose! g hg using h_factors
  use g 0 1 * g 0 2 * g 0 3 * g 0 4 * g 1 2 * g 1 3 * g 1 4 * g 2 3 * g 2 4 * g 3 4
  simp [hg, creationChartEnd]

/-- Successor form of the normalized pure-spinor affine-chart theorem. -/
theorem exists_creationRoots_vacuum_eq_of_quadric_chart
    (ψ : FockSpinor) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) (h0 : ψ ∅ = 1) :
    ∃ g : evenCliffordGroup, g.val.val vacuumSpinor = ψ := by
  obtain ⟨g, hg⟩ := creationChartEnd_mem ψ
  refine ⟨g, ?_⟩
  rw [hg, creationChartEnd_vacuum_eq_of_quadric_chart ψ heven hquad h0]

/-- info: 'PhysicsSM.Draft.Spin10StandardizablePairs.exists_creationRoots_vacuum_eq_of_quadric_chart' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_creationRoots_vacuum_eq_of_quadric_chart

end PhysicsSM.Draft.Spin10StandardizablePairs
