import PhysicsSM.Draft.Spin10VacuumFiberTransitivity

/-!
# Basis-two affine transitivity in the marked Spin(10) vacuum chart

This module constructs number-preserving mixed Clifford roots, composes them
into signed mode swaps, and proves that every non-vacuum point in every
basis-two affine chart can be moved to the standard weak line while fixing the
vacuum exactly.

Provenance: clean-room Aristotle return
`41cce47a-8eb5-497c-9536-9423031288d0` (task
`3cd532a9-8f62-4a89-ac85-c13ed6e9c96d`), locally reviewed and rebuilt under
the pinned project toolchain. The construction uses the project's Fock basis,
Clifford action, and sign conventions without changing them.
-/

noncomputable section

namespace PhysicsSM.Draft.Spin10VacuumFiberTransitivity

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.Spin10StabilizerTransitivity
open PhysicsSM.Draft.Spin10StandardizablePairs

/-- The elementary number-preserving root operator associated to two distinct
modes.  It is the exterior-algebra action of the elementary matrix
`1 + t Eᵢⱼ`. -/
def mixedRootEnd (i j : Fin 5) (t : ℂ) : Module.End ℂ FockSpinor where
  toFun ψ := ψ + t • wedge i (contract j ψ)
  map_add' ψ φ := by simp only [contract_add, wedge_add, smul_add, add_add_add_comm]
  map_smul' c ψ := by
    simp only [contract_smul, wedge_smul, RingHom.id_apply, smul_add, smul_smul]
    module

/-- A number-preserving elementary root is represented by the algebraic even
Clifford group. -/
lemma mixedRootEnd_mem (i j : Fin 5) (t : ℂ) (hij : i ≠ j) :
    ∃ g : evenCliffordGroup, g.val.val = mixedRootEnd i j t := by
  refine' ⟨_, _⟩
  set a : V10 := (fun k => if k = i then 1 else 0, 0)
  set b : V10 := (0, fun k => if k = j then 1 else 0)
  set f : V10 := (0, fun k => if k = i then 1 else 0)
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
  simp +decide [*, mixedRootEnd]
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

/-
Number-preserving roots fix the marked Fock vacuum exactly.
-/
lemma mixedRootEnd_fix_vacuum (i j : Fin 5) (t : ℂ) :
    mixedRootEnd i j t vacuumSpinor = vacuumSpinor := by
  unfold mixedRootEnd;
  unfold wedge contract; simp +decide [ vacuumSpinor ] ;
  unfold basisSpinor; simp +decide [ opSign ] ;
  exact Or.inr rfl

/-- The three elementary roots realizing a signed transposition of two modes. -/
def mixedSwapEnd (i j : Fin 5) : Module.End ℂ FockSpinor :=
  mixedRootEnd i j 1 * mixedRootEnd j i (-1) * mixedRootEnd i j 1

/-
A signed mode transposition is represented in the even Clifford group and
fixes the vacuum exactly.
-/
lemma mixedSwapEnd_mem_fix (i j : Fin 5) (hij : i ≠ j) :
    ∃ g : evenCliffordGroup, g.val.val = mixedSwapEnd i j ∧
      g.val.val vacuumSpinor = vacuumSpinor := by
  obtain ⟨g₃, hg₃⟩ := mixedRootEnd_mem i j 1 hij
  obtain ⟨g₂, hg₂⟩ := mixedRootEnd_mem j i (-1) (Ne.symm hij)
  obtain ⟨g₁, hg₁⟩ := mixedRootEnd_mem i j 1 hij;
  refine' ⟨ g₃ * g₂ * g₁, _, _ ⟩ <;> simp_all +decide [ mixedSwapEnd ];
  simp +decide [ mixedRootEnd_fix_vacuum ]

/-
A signed mode swap replaces an occupied mode by an unoccupied one,
up to the nonzero fermionic ordering sign.
-/
lemma mixedSwapEnd_basisSpinor_of_mem_of_not_mem
    (i j : Fin 5) (hij : i ≠ j) (T : Finset (Fin 5))
    (hi : i ∈ T) (hj : j ∉ T) :
    ∃ c : ℂ, c ≠ 0 ∧
      mixedSwapEnd i j (basisSpinor T) =
        c • basisSpinor (insert j (T.erase i)) := by
  unfold mixedSwapEnd mixedRootEnd;
  unfold wedge contract; simp +decide [ *, Finset.sum_add_distrib, add_mul, mul_add, mul_assoc, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Pi.single_apply ] ;
  refine' ⟨ -opSign i T * opSign j ( T.erase i ), _, _ ⟩ <;> simp_all +decide [ Finset.ext_iff, funext_iff, opSign_ne_zero ];
  unfold basisSpinor; simp +decide [ *, Finset.sum_add_distrib, add_mul, mul_add, mul_assoc,
        mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Pi.single_apply ] ;
  grind +suggestions

/-
A two-particle basis monomial can be carried to the weak monomial by an
even Clifford element fixing the marked vacuum exactly.
-/
lemma exists_vacuumStabilizer_basisTwo_to_weak
    (T : Finset (Fin 5)) (hT : T.card = 2) :
    ∃ g : evenCliffordGroup, g ∈ vacuumStabilizer ∧
      ∃ c : ℂ, c ≠ 0 ∧ g.val.val (basisSpinor T) = c • weakSpinor := by
  by_cases hi : 3 ∈ T <;> by_cases hj : 4 ∈ T <;> simp_all +decide [ vacuumSpinor, weakSpinor ];
  · use 1; simp +decide [ vacuumStabilizer ] ;
    exact ⟨ 1, one_ne_zero, by rw [ show T = { 3, 4 } by fin_cases T <;> trivial ] ; norm_num ⟩;
  · fin_cases T <;> simp_all +decide only [vacuumStabilizer];
    · obtain ⟨ g, hg₁, hg₂ ⟩ := mixedSwapEnd_mem_fix 0 4 ( by decide );
      refine' ⟨ g, _, _ ⟩ <;> simp_all +decide [ mixedSwapEnd ];
      have := mixedSwapEnd_basisSpinor_of_mem_of_not_mem 0 4 ( by decide ) { 0, 3 } ( by decide ) ( by decide ) ; simp_all +decide [ mixedSwapEnd ] ;
      convert this using 4 ; simp +decide [ Finset.pair_comm ];
    · obtain ⟨ g, hg₁, hg₂ ⟩ := mixedSwapEnd_mem_fix 1 4 ( by decide );
      obtain ⟨ c, hc₁, hc₂ ⟩ := mixedSwapEnd_basisSpinor_of_mem_of_not_mem 1 4 ( by decide ) { 1, 3 } ( by decide ) ( by decide );
      refine' ⟨ g, _, c, hc₁, _ ⟩ <;> simp_all +decide [ mixedSwapEnd ];
      convert hc₂ using 1;
      exact congr_arg _ ( by ext; simp +decide [ Finset.pair_comm ] );
    · obtain ⟨ g, hg₁, hg₂ ⟩ := mixedSwapEnd_mem_fix 2 4 ( by decide );
      obtain ⟨ c, hc₁, hc₂ ⟩ := mixedSwapEnd_basisSpinor_of_mem_of_not_mem 2 4 ( by decide ) { 2, 3 } ( by decide ) ( by decide );
      refine' ⟨ g.val, _, c, hc₁, _ ⟩ <;> simp_all +decide [ Finset.ext_iff, funext_iff ];
      convert hc₂ using 3 ; simp +decide [ Finset.pair_comm ];
  · obtain ⟨k, hk⟩ : ∃ k, T = {k, 4} ∧ k ≠ 3 := by
      decide +revert;
    obtain ⟨g₁, hg₁⟩ := mixedSwapEnd_mem_fix k 3 (by
    exact hk.2);
    refine' ⟨ g₁, _, _ ⟩ <;> simp_all +decide [ vacuumStabilizer ];
    · exact hg₁.1 ▸ hg₁.2;
    · convert mixedSwapEnd_basisSpinor_of_mem_of_not_mem k 3 ( by aesop ) { k, 4 } ( by aesop ) ( by aesop ) using 1;
      fin_cases k <;> trivial;
  · fin_cases T <;> simp +decide at hT hi hj ⊢;
    · obtain ⟨ g₁, hg₁ ⟩ := mixedSwapEnd_mem_fix 0 3 ( by decide ) ; obtain ⟨ g₂, hg₂ ⟩ := mixedSwapEnd_mem_fix 1 4 ( by decide ) ; use g₂ * g₁; simp_all +decide [ vacuumStabilizer ] ;
      refine' ⟨ ⟨ _, _ ⟩, _ ⟩;
      · exact Subgroup.mul_mem _ g₂.2 g₁.2;
      · simp +decide [ mixedSwapEnd, mixedRootEnd_fix_vacuum ];
      · obtain ⟨ c₁, hc₁, hc₁' ⟩ := mixedSwapEnd_basisSpinor_of_mem_of_not_mem 0 3 ( by decide ) { 0, 1 } ( by decide ) ( by decide ) ; obtain ⟨ c₂, hc₂, hc₂' ⟩ := mixedSwapEnd_basisSpinor_of_mem_of_not_mem 1 4 ( by decide ) { 3, 1 } ( by decide ) ( by decide ) ; use c₂ * c₁; simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ] ;
        convert congr_arg ( fun x => ( mixedSwapEnd 1 4 ) x ) hc₁' using 1 ; simp +decide [ hc₂', mul_assoc, mul_comm, mul_left_comm, smul_smul ];
        congr! 2;
        decide +revert;
    · obtain ⟨ g₁, hg₁ ⟩ := mixedSwapEnd_mem_fix 0 3 ( by decide ) ; obtain ⟨ g₂, hg₂ ⟩ := mixedSwapEnd_mem_fix 2 4 ( by decide ) ; use g₂ * g₁; simp_all +decide [ vacuumStabilizer ] ;
      refine' ⟨ ⟨ evenCliffordGroup.mul_mem g₂.2 g₁.2, _ ⟩, _ ⟩;
      · simp +decide [ mixedSwapEnd, mixedRootEnd_fix_vacuum ];
      · obtain ⟨ c₁, hc₁, hc₁' ⟩ := mixedSwapEnd_basisSpinor_of_mem_of_not_mem 0 3 ( by decide ) { 0, 2 } ( by decide ) ( by decide ) ; obtain ⟨ c₂, hc₂, hc₂' ⟩ := mixedSwapEnd_basisSpinor_of_mem_of_not_mem 2 4 ( by decide ) { 2, 3 } ( by decide ) ( by decide ) ; use c₂ * c₁; simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ] ;
        convert congr_arg ( fun x => ( mixedSwapEnd 2 4 ) x ) hc₁' using 1 ; simp +decide [ mul_comm c₁ c₂, smul_smul ];
        rw [ show ( { 3, 2 } : Finset ( Fin 5 ) ) = { 2, 3 } by decide, hc₂' ] ; simp +decide [ mul_comm c₁ c₂, smul_smul ];
        exact congr_arg _ ( by ext; simp +decide [ Finset.pair_comm ] );
    · -- Use the mixedSwapEnd to swap 1 and 3, then 2 and 4.
      obtain ⟨g₁, hg₁⟩ := mixedSwapEnd_mem_fix 1 3 (by decide)
      obtain ⟨g₂, hg₂⟩ := mixedSwapEnd_mem_fix 2 4 (by decide);
      refine' ⟨ g₂.val * g₁.val, _, _ ⟩ <;> simp_all +decide [ vacuumStabilizer ];
      · exact ⟨ evenCliffordGroup.mul_mem g₂.2 g₁.2, by aesop ⟩;
      · obtain ⟨ c₁, hc₁, hc₁' ⟩ := mixedSwapEnd_basisSpinor_of_mem_of_not_mem 1 3 ( by decide ) { 1, 2 } ( by decide ) ( by decide ) ; obtain ⟨ c₂, hc₂, hc₂' ⟩ := mixedSwapEnd_basisSpinor_of_mem_of_not_mem 2 4 ( by decide ) { 2, 3 } ( by decide ) ( by decide ) ; use c₂ * c₁; simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ] ;
        convert congr_arg ( fun x => c₁ • x ) hc₂' using 1;
        · convert congr_arg ( fun x => ( mixedSwapEnd 2 4 ) x ) hc₁' using 1;
          rw [ show ( { 3, 2 } : Finset ( Fin 5 ) ) = { 2, 3 } by decide, map_smul ];
        · rw [ mul_smul, Finset.pair_comm ]

/-
Every non-vacuum point on every basis-two affine chart is carried to the
standard weak line by an element fixing the vacuum exactly.
-/
theorem exists_vacuumStabilizer_affine_basisTwo_to_weak
    (T : Finset (Fin 5)) (hT : T.card = 2)
    (a b : ℂ) (hb : b ≠ 0) :
    ∃ g : evenCliffordGroup, g ∈ vacuumStabilizer ∧
      ∃ c : ℂ, c ≠ 0 ∧
        g.val.val (a • vacuumSpinor + b • basisSpinor T) = c • weakSpinor := by
  obtain ⟨ g₁, hg₁ ⟩ : ∃ g₁ : evenCliffordGroup, g₁ ∈ vacuumStabilizer ∧ ∃ c₁ : ℂ, c₁ ≠ 0 ∧ g₁.val.val (basisSpinor T) = c₁ • weakSpinor := by
    exact exists_vacuumStabilizer_basisTwo_to_weak T hT;
  obtain ⟨ c₁, hc₁, hc₁' ⟩ := hg₁.2;
  obtain ⟨g₂, hg₂⟩ : ∃ g₂ : evenCliffordGroup, g₂ ∈ vacuumStabilizer ∧ ∃ c₂ : ℂ, c₂ ≠ 0 ∧ g₂.val.val (a • vacuumSpinor + (b * c₁) • weakSpinor) = c₂ • weakSpinor := by
    apply exists_vacuumStabilizer_smul_eq_scalar_weak_of_vacuum_add_weak;
    exact mul_ne_zero hb hc₁;
  refine' ⟨ g₂ * g₁, _, _ ⟩ <;> simp_all +decide [ vacuumStabilizer ];
  obtain ⟨ c₂, hc₂, hc₂' ⟩ := hg₂.2; use c₂; simp_all +decide [ mul_assoc, mul_comm, mul_left_comm, smul_smul ] ;

/-- info: 'PhysicsSM.Draft.Spin10VacuumFiberTransitivity.exists_vacuumStabilizer_affine_basisTwo_to_weak' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_vacuumStabilizer_affine_basisTwo_to_weak

end PhysicsSM.Draft.Spin10VacuumFiberTransitivity
