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

/-! ## A nontrivial affine chart in the fiber

The opposite nilpotent root in the weak `(3,4)` plane fixes the vacuum and
removes a vacuum component from a spinor on the line through the marked pair.
This gives a genuine affine-line family beyond the scalar-line warmup.

Provenance: Aristotle project `ab9663c1-b4ef-42b2-a7db-6854d1f6eeb1`.
-/

/-- The elementary two-contraction root operator. -/
def annihilationRootEnd (i j : Fin 5) (t : ℂ) : Module.End ℂ FockSpinor where
  toFun ψ := ψ + t • contract i (contract j ψ)
  map_add' ψ φ := by simp only [contract_add, smul_add, add_add_add_comm]
  map_smul' c ψ := by
    simp only [contract_smul, RingHom.id_apply, smul_add, smul_smul]
    module

/-- A two-contraction root is represented by the algebraic even Clifford
group. -/
lemma annihilationRootEnd_mem (i j : Fin 5) (t : ℂ) (hij : i ≠ j) :
    ∃ g : evenCliffordGroup, g.val.val = annihilationRootEnd i j t := by
  refine' ⟨_, _⟩
  set a : V10 := (0, fun k => if k = i then 1 else 0)
  set b : V10 := (0, fun k => if k = j then 1 else 0)
  set f : V10 := (fun k => if k = i then 1 else 0, 0)
  set u : V10 := a + f
  set u' : V10 := a - f
  set r : ℂ := t / 2
  have hu : Q10 u = 1 := by
    simp +zetaDelta at *
    unfold Q10
    simp +decide [Finset.sum_ite, Finset.filter_eq', Finset.filter_ne']
  have hu' : Q10 u' = -1 := by
    unfold Q10
    aesop
  have hu_r : Q10 (u + r • b) = 1 := by
    unfold Q10 at *
    simp_all +decide [Finset.sum_add_distrib, add_mul, mul_add,
      Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Finset.sum_ite,
      Finset.filter_ne', Finset.filter_eq']
    aesop
  have hu'_r : Q10 (u' - r • b) = -1 := by
    simp +zetaDelta at *
    unfold Q10 at *
    simp_all +decide [Finset.sum_ite, Finset.filter_eq', Finset.filter_ne']
  exact ⟨gammaUnit u (by norm_num [hu]) * gammaUnit (u + r • b) (by norm_num [hu_r]) *
      (scalarUnit (-1) (by norm_num) *
        (gammaUnit u' (by norm_num [hu']) * gammaUnit (u' - r • b) (by norm_num [hu'_r]))),
    evenCliffordGroup.mul_mem (gammaUnit_mul_gammaUnit_mem _ _ _ _)
      (evenCliffordGroup.mul_mem (scalarUnit_mem _ _)
        (gammaUnit_mul_gammaUnit_mem _ _ _ _))⟩
  ext ψ
  simp +decide [*, annihilationRootEnd]
  ring
  unfold cliffordAction
  simp +decide [*, Finset.sum_add_distrib, add_mul, mul_add, mul_assoc,
    mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Pi.single_apply]
  ring
  simp +decide [wedge, contract, Pi.single_apply]
  ring
  simp +decide [Finset.sum_ite, Finset.filter_ne', Finset.filter_and,
    Finset.filter_or, Finset.filter_not, Finset.mem_erase, Finset.mem_insert,
    Finset.mem_singleton, hij.symm]
  ring
  grind +suggestions

/-- The weak-plane annihilation root fixes the marked vacuum. -/
lemma annihilationRootEnd_weak_fix_vacuum (t : ℂ) :
    annihilationRootEnd 3 4 t vacuumSpinor = vacuumSpinor := by
  unfold annihilationRootEnd vacuumSpinor
  unfold contract
  simp +decide [basisSpinor]
  exact Or.inr rfl

/-- The suitable weak-plane annihilation root removes the vacuum coefficient. -/
lemma annihilationRootEnd_weak_vacuum_add_weak (a b : ℂ) (ha : a ≠ 0) :
    annihilationRootEnd 3 4 (b / a)
      (b • vacuumSpinor + a • weakSpinor) = a • weakSpinor := by
  unfold annihilationRootEnd
  unfold contract
  norm_num [Finset.sum_ite, Finset.filter_ne', Finset.filter_eq',
    Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton]
  ring
  ext S
  simp +decide [vacuumSpinor, weakSpinor, basisSpinor]
  ring
  fin_cases S <;> simp +decide [ha, opSign]

/-- Every point of the `(vacuum, weak)` affine line away from the vacuum
endpoint lies in the `d = 3` pure-spinor fiber. -/
lemma vacuum_add_weak_inVacuumThreeFiber (a b : ℂ) (ha : a ≠ 0) :
    InVacuumThreeFiber (b • vacuumSpinor + a • weakSpinor) := by
  constructor
  · have h_pure : gammaBilinear (b • vacuumSpinor + a • weakSpinor)
        (b • vacuumSpinor + a • weakSpinor) = 0 := by
      apply line_quadric
      · exact isPureSpinor_vacuumSpinor.3
      · exact isPureSpinor_weakSpinor.3
      · rw [gammaBilinear_vacuum_weak, gammaBilinear_weak_vacuum, add_zero]
    refine' ⟨_, _, h_pure⟩
    · intro h
      have := congr_arg (fun x => x {3, 4}) h
      norm_num [ha, vacuumSpinor, weakSpinor, basisSpinor] at this
    · exact IsEvenSpinor.add
        (IsEvenSpinor.smul isPureSpinor_vacuumSpinor.2 _)
        (IsEvenSpinor.smul isPureSpinor_weakSpinor.2 _)
  · have hdim : ∀ g : evenCliffordGroup,
        annihilatorIntersectionDim (g.val.val vacuumSpinor)
            (g.val.val (b • vacuumSpinor + a • weakSpinor)) =
          annihilatorIntersectionDim vacuumSpinor
            (b • vacuumSpinor + a • weakSpinor) := by
      intro g
      apply annihilatorIntersectionDim_smul
    obtain ⟨g, hg⟩ : ∃ g : evenCliffordGroup,
        g.val.val vacuumSpinor = vacuumSpinor ∧
          g.val.val (b • vacuumSpinor + a • weakSpinor) = a • weakSpinor := by
      obtain ⟨g, hg⟩ := annihilationRootEnd_mem 3 4 (b / a) (by decide)
      use g
      simp_all +decide [annihilationRootEnd_weak_fix_vacuum,
        annihilationRootEnd_weak_vacuum_add_weak]
    rw [← hdim g, hg.1, hg.2]
    convert annihilatorIntersectionDim_smul_scalars
      1 a one_ne_zero ha vacuumSpinor weakSpinor using 1 <;> norm_num
    convert basis_commonAnnihilator_finrank ∅ {3, 4} |> Eq.symm using 1

/-- The `(vacuum, weak)` affine line, away from the vacuum endpoint, is in
one orbit under the exact vacuum stabilizer. -/
theorem exists_vacuumStabilizer_smul_eq_scalar_weak_of_vacuum_add_weak
    (a b : ℂ) (ha : a ≠ 0) :
    ∃ g : evenCliffordGroup, g ∈ vacuumStabilizer ∧
      ∃ c : ℂ, c ≠ 0 ∧
        g.val.val (b • vacuumSpinor + a • weakSpinor) = c • weakSpinor := by
  obtain ⟨g, hg⟩ := annihilationRootEnd_mem 3 4 (b / a) (by decide)
  refine' ⟨g, _, a, ha, _⟩
  · ext
    simp [hg, vacuumSpinor, annihilationRootEnd]
    unfold contract basisSpinor
    aesop
  · convert congr_arg
      (fun f : Module.End ℂ FockSpinor =>
        f (b • vacuumSpinor + a • weakSpinor)) hg using 1
    norm_num [annihilationRootEnd]
    ring
    simp +decide [weakSpinor, vacuumSpinor, contract_basisSpinor_of_mem,
      contract_basisSpinor_of_not_mem]
    simp +decide [contract_add, contract_smul, contract_basisSpinor_of_mem,
      contract_basisSpinor_of_not_mem]
    simp +decide [opSign, Finset.erase]
    simp +decide [ha, smul_smul, mul_assoc, mul_left_comm]

/-- info: 'PhysicsSM.Draft.Spin10VacuumFiberTransitivity.exists_vacuumStabilizer_smul_eq_scalar_weak_of_vacuum_add_weak' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_vacuumStabilizer_smul_eq_scalar_weak_of_vacuum_add_weak

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
