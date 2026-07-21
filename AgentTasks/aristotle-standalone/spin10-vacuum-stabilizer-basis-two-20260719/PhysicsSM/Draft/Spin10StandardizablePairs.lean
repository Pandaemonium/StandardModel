import PhysicsSM.Draft.Spin10StabilizerTransitivity

/-!
# Corrected S1: genuine Krasnov pairs are standardizable

Target statements for the Aristotle job `spin10-standardizable-20260719`.

Context.  The previous job (83ee06fc) refuted the original S1 (diagonal
`d = 5` stratum defect; kernel counterexample
`not_evenCliffordGroup_transitive_on_krasnov_pairs`), introduced the repair
condition `ProjectivelyDistinct`, and PROVED the conditional reduction
`evenCliffordGroup_transitive_on_standardizable_krasnov_pairs`.  Its
PROOF_PLAN_REPORT decomposes the remaining geometric content into five
steps; this module states the entry, exit, and the one intermediate that is
statable with existing names.  The step-1 annihilator-dimension invariant
and the step-3 vacuum-stabilizer fiber transitivity require NEW definitions
- introduce them as needed (they are expected deliverables, not scope
creep), following the plan in the prompt.

Pre-registered honesty license: if marked transitivity needs a nonzero
scalar on the target (`g ψ = c • vacuumSpinor`), prove that version, rename
accordingly, and thread the scale through `scalarUnit_mem` as the plan
prescribes; record every statement change prominently.  A kernel
counterexample to any stated target is a first-class outcome.  Every
`s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

namespace PhysicsSM.Draft.Spin10StandardizablePairs

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.Spin10StabilizerTransitivity

/-! ## Elementary creation-root operators -/

/-- The elementary even nilpotent operator attached to two creation modes. -/
def creationRootEnd (i j : Fin 5) (t : ℂ) : Module.End ℂ FockSpinor where
  toFun ψ := ψ + t • wedge i (wedge j ψ)
  map_add' ψ φ := by simp only [wedge_add, smul_add, add_add_add_comm]
  map_smul' c ψ := by
    simp only [wedge_smul, RingHom.id_apply, smul_add, smul_smul]
    module

/-
For distinct modes, the elementary creation-root operator is represented
by an element of the algebraic even Clifford group.
-/
set_option maxHeartbeats 1000000 in
lemma creationRootEnd_mem (i j : Fin 5) (t : ℂ) (hij : i ≠ j) :
    ∃ g : evenCliffordGroup, g.val.val = creationRootEnd i j t := by
  refine' ⟨ _, _ ⟩;
  -- Let $a$ be the creation-only basis vector at $i$, $b$ creation-only at $j$, $f$ the annihilation-only basis vector at $i$, $u=a+f$, $u'=a-f$, and $r=t/2$.
  set a : V10 := (fun k => if k = i then 1 else 0, 0)
  set b : V10 := (fun k => if k = j then 1 else 0, 0)
  set f : V10 := (0, fun k => if k = i then 1 else 0)
  set u : V10 := a + f
  set u' : V10 := a - f
  set r : ℂ := t / 2;
  -- By definition of $u$ and $u'$, we know that $Q(u) = Q(u + r b) = 1$ and $Q(u') = Q(u' - r b) = -1$.
  have hu : Q10 u = 1 := by
    simp +zetaDelta at *;
    unfold Q10; simp +decide [ Finset.sum_ite, Finset.filter_eq', Finset.filter_ne' ] ;
  have hu' : Q10 u' = -1 := by
    unfold Q10; aesop;
  have hu_r : Q10 (u + r • b) = 1 := by
    unfold Q10 at *; simp_all +decide [ Finset.sum_add_distrib, add_mul, mul_add, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Finset.sum_ite, Finset.filter_ne', Finset.filter_eq' ] ;
    aesop
  have hu'_r : Q10 (u' - r • b) = -1 := by
    simp +zetaDelta at *;
    unfold Q10 at *; simp_all +decide [ Finset.sum_ite, Finset.filter_eq', Finset.filter_ne' ] ;
  exact ⟨ gammaUnit u ( by norm_num [ hu ] ) * gammaUnit ( u + r • b ) ( by norm_num [ hu_r ] ) * ( scalarUnit ( -1 ) ( by norm_num ) * ( gammaUnit u' ( by norm_num [ hu' ] ) * gammaUnit ( u' - r • b ) ( by norm_num [ hu'_r ] ) ) ), evenCliffordGroup.mul_mem ( gammaUnit_mul_gammaUnit_mem _ _ _ _ ) ( evenCliffordGroup.mul_mem ( scalarUnit_mem _ _ ) ( gammaUnit_mul_gammaUnit_mem _ _ _ _ ) ) ⟩;
  ext ψ; simp +decide [ *, creationRootEnd ] ; ring;
  unfold cliffordAction; simp +decide [ *, Finset.sum_add_distrib, add_mul, mul_add, mul_assoc, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Pi.single_apply ] ; ring;
  simp +decide [ wedge, contract, Pi.single_apply ] ; ring;
  simp +decide [ Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.filter_or, Finset.filter_not, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton, hij.symm ] ; ring;
  grind +suggestions

/-- In the vacuum chart, the ten Cartan quadrics give the usual finite
bivector-exponential normal form.  This coordinate lemma deliberately uses
`creationRootEnd` products rather than analytic exponentials. -/
lemma exists_creationRoots_vacuum_eq_of_quadric
    (ψ : FockSpinor) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) (h0 : ψ ∅ = 1) :
    ∃ g : evenCliffordGroup, g.val.val vacuumSpinor = ψ := by
  sorry

/-- A nonzero even spinor satisfying the Cartan quadrics can be moved into
its affine vacuum chart by signed mode flips. -/
lemma exists_evenCliffordGroup_vacuum_coefficient_ne_zero
    (ψ : FockSpinor) (hne : ψ ≠ 0) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) :
    ∃ g : evenCliffordGroup,
      gammaBilinear (g.val.val ψ) (g.val.val ψ) = 0 ∧
      (g.val.val ψ) ∅ ≠ 0 := by
  sorry

/-! ## Relative position and the vacuum fiber -/

/-- The common annihilator of two spinors.  For pure spinors this is the
intersection of their associated maximal isotropic subspaces. -/
def commonAnnihilator (ψ₁ ψ₂ : FockSpinor) : Submodule ℂ V10 :=
  annihilator ψ₁ ⊓ annihilator ψ₂

/-- The relative-position invariant of two spinors: the complex dimension of
their common annihilator.  The genuine Krasnov-pair stratum is the value `3`;
the projective diagonal has value `5`. -/
def annihilatorIntersectionDim (ψ₁ ψ₂ : FockSpinor) : ℕ :=
  Module.finrank ℂ (commonAnnihilator ψ₁ ψ₂)

/-- The subgroup of the even Clifford group fixing the marked vacuum
spinor exactly. -/
def vacuumStabilizer : Subgroup evenCliffordGroup where
  carrier := {g | g.val.val vacuumSpinor = vacuumSpinor}
  one_mem' := by simp
  mul_mem' := by
    intro a b ha hb
    change (a * b).val.val vacuumSpinor = vacuumSpinor
    simp only [Subgroup.coe_mul, Units.val_mul, Module.End.mul_apply]
    rw [hb, ha]
  inv_mem' := by
    intro a (ha : a.val.val vacuumSpinor = vacuumSpinor)
    change a⁻¹.val.val vacuumSpinor = vacuumSpinor
    have h_inv : (a⁻¹ * a).val.val vacuumSpinor = vacuumSpinor := by
      rw [inv_mul_cancel]
      rfl
    change a⁻¹.val.val (a.val.val vacuumSpinor) = vacuumSpinor at h_inv
    rw [ha] at h_inv
    exact h_inv

/-- The `d = 3` pure-spinor fiber over the marked vacuum. -/
def InVacuumThreeFiber (ψ : FockSpinor) : Prop :=
  IsPureSpinor ψ ∧ annihilatorIntersectionDim vacuumSpinor ψ = 3

/-- **Step 2 target (plan): marked transitivity on nonzero pure spinors.**
Every nonzero pure spinor is carried to the vacuum spinor by the even
Clifford group (the landed basis-orbit machinery proves this for even wedge
monomials; the content here is the general pure-spinor normal form). -/
theorem exists_evenCliffordGroup_smul_eq_vacuum
    (ψ : FockSpinor) (hψ : IsPureSpinor ψ) (hne : ψ ≠ 0) :
    ∃ g : evenCliffordGroup, g.val.val ψ = vacuumSpinor := by
  sorry

/-- **Main target (plan exit): genuine pairs are standardizable.**
Purity, orthogonality, and projective distinctness put the pair in the
standard `(vacuumSpinor, weakSpinor)` normal form. -/
theorem standardizable_of_genuine_krasnov_pair
    (ψ₁ ψ₂ : FockSpinor)
    (hψ₁ : IsPureSpinor ψ₁) (hψ₂ : IsPureSpinor ψ₂)
    (horth : OrthogonalPureSpinors ψ₁ ψ₂)
    (hdist : ProjectivelyDistinct ψ₁ ψ₂) :
    StandardizablePair ψ₁ ψ₂ := by
  sorry

/-
**Corrected S1 (the lane's flagship statement).**  The even Clifford
group acts transitively on genuine (projectively distinct) Krasnov pairs,
first entry marked, second projective.  Follows from the main target plus
the PROVED conditional reduction.
-/
theorem evenCliffordGroup_transitive_on_genuine_krasnov_pairs
    (ψ₁ ψ₂ φ₁ φ₂ : FockSpinor)
    (hψ₁ : IsPureSpinor ψ₁) (hψ₂ : IsPureSpinor ψ₂)
    (hφ₁ : IsPureSpinor φ₁) (hφ₂ : IsPureSpinor φ₂)
    (hψo : OrthogonalPureSpinors ψ₁ ψ₂)
    (hφo : OrthogonalPureSpinors φ₁ φ₂)
    (hψd : ProjectivelyDistinct ψ₁ ψ₂)
    (hφd : ProjectivelyDistinct φ₁ φ₂) :
    ∃ g : evenCliffordGroup, g.val.val ψ₁ = φ₁ ∧
      ∃ c : ℂ, g.val.val ψ₂ = c • φ₂ := by
  apply evenCliffordGroup_transitive_on_standardizable_krasnov_pairs
  · exact standardizable_of_genuine_krasnov_pair ψ₁ ψ₂ hψ₁ hψ₂ hψo hψd
  · exact standardizable_of_genuine_krasnov_pair φ₁ φ₂ hφ₁ hφ₂ hφo hφd

end PhysicsSM.Draft.Spin10StandardizablePairs
