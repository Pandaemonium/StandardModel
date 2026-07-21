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

The chart-entry and global single-spinor orbit results were completed by
Aristotle project `b07302d3-f3f8-40a2-91ed-8aa17c2ca282`.  The acting group is
the repository's algebraic `GSpin(10, C)` object, which contains scalar units;
these results are not claims about the norm-one `Spin(10)` subgroup.
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

/-
The degree-four Cartan relation on the coordinate hyperplane missing mode 4.
-/
lemma chart_quadric_coord_0123
    (ψ : FockSpinor) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) (h0 : ψ ∅ = 1) :
    ψ {0, 1, 2, 3} =
      ψ {0, 1} * ψ {2, 3} - ψ {0, 2} * ψ {1, 3} + ψ {0, 3} * ψ {1, 2} := by
  unfold gammaBilinear at hquad; simp +decide [ *, Finset.sum_add_distrib, add_mul, mul_add, Finset.mul_sum, Finset.sum_mul, Pi.single_apply ] at hquad;
  have := congrFun hquad.2 4; simp_all +decide [ chevalleyPairing ] ;
  unfold chevalleySign wedge at this; simp_all +decide [ Finset.sum_ite, Finset.filter_ne', Finset.filter_eq' ] ;
  rw [ show ( Finset.filter ( fun x => 4 ∈ x ) Finset.univ : Finset ( Finset ( Fin 5 ) ) ) = { { 4 }, { 0, 4 }, { 1, 4 }, { 2, 4 }, { 3, 4 }, { 0, 1, 4 }, { 0, 2, 4 }, { 0, 3, 4 }, { 1, 2, 4 }, { 1, 3, 4 }, { 2, 3, 4 }, { 0, 1, 2, 4 }, { 0, 1, 3, 4 }, { 0, 2, 3, 4 }, { 1, 2, 3, 4 }, { 0, 1, 2, 3, 4 } } by decide ] at this; simp +decide [ Finset.sum ] at this;
  simp +decide [ opSign ] at this;
  simp +decide [ show ( { 4 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 2, 3 } by decide, show ( { 0, 4 } : Finset ( Fin 5 ) ) ᶜ = { 1, 2, 3 } by decide, show ( { 1, 4 } : Finset ( Fin 5 ) ) ᶜ = { 0, 2, 3 } by decide, show ( { 2, 4 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 3 } by decide, show ( { 3, 4 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 2 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 2, 3 } : Finset ( Fin 5 ) ).erase 1 = { 0, 2, 3 } by decide, show ( { 0, 1, 2, 3 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1, 3 } by decide, show ( { 0, 1, 2, 3 } : Finset ( Fin 5 ) ).erase 3 = { 0, 1, 2 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 4 } : Finset ( Fin 5 ) ).erase 4 = { 0, 1 } by decide, show ( { 0, 2, 4 } : Finset ( Fin 5 ) ).erase 4 = { 0, 2 } by decide, show ( { 0, 3, 4 } : Finset ( Fin 5 ) ).erase 4 = { 0, 3 } by decide, show ( { 1, 2, 4 } : Finset ( Fin 5 ) ).erase 4 = { 1, 2 } by decide, show ( { 1, 3, 4 } : Finset ( Fin 5 ) ).erase 4 = { 1, 3 } by decide, show ( { 2, 3, 4 } : Finset ( Fin 5 ) ).erase 4 = { 2, 3 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 3 } : Finset ( Fin 5 ) ).erase 1 = { 0, 3 } by decide, show ( { 0, 1, 2 } : Finset ( Fin 5 ) ).erase 1 = { 0, 2 } by decide, show ( { 0, 1, 2 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1 } by decide ] at this;
  simp +decide [ show ( { 0, 1 } : Finset ( Fin 5 ) ).erase 1 = { 0 } by decide, show ( { 0, 1, 2, 3, 4 } : Finset ( Fin 5 ) ).erase 4 = { 0, 1, 2, 3 } by decide ] at this;
  have := heven { 0 } ; have := heven { 1 } ; have := heven { 2 } ; have := heven { 3 } ; simp_all +decide [ IsEvenSpinor ] ;
  grind

/-
The degree-four Cartan relation on the coordinate hyperplane missing mode 3.
-/
lemma chart_quadric_coord_0124
    (ψ : FockSpinor) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) (h0 : ψ ∅ = 1) :
    ψ {0, 1, 2, 4} =
      ψ {0, 1} * ψ {2, 4} - ψ {0, 2} * ψ {1, 4} + ψ {0, 4} * ψ {1, 2} := by
  unfold gammaBilinear at hquad; simp_all +decide [ Finset.sum_add_distrib, add_mul, mul_add, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Pi.single_apply ] ;
  have := congrFun hquad.2 3; simp_all +decide [ chevalleyPairing ] ;
  unfold wedge at this; simp_all +decide [ Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.filter_or, Finset.filter_not, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
  rw [ show ( Finset.filter ( fun x => 3 ∈ x ) Finset.univ : Finset ( Finset ( Fin 5 ) ) ) = { { 3 }, { 0, 3 }, { 1, 3 }, { 2, 3 }, { 3, 4 }, { 0, 1, 3 }, { 0, 2, 3 }, { 0, 3, 4 }, { 1, 2, 3 }, { 1, 3, 4 }, { 2, 3, 4 }, { 0, 1, 2, 3 }, { 0, 1, 3, 4 }, { 0, 2, 3, 4 }, { 1, 2, 3, 4 }, { 0, 1, 2, 3, 4 } } by decide ] at this; simp +decide [ Finset.sum ] at this;
  simp +decide [ chevalleySign, opSign ] at this;
  simp +decide [ show ( { 3 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 2, 4 } by decide, show ( { 4 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 2, 3 } by decide ] at this;
  simp +decide [ show ( { 0, 3 } : Finset ( Fin 5 ) ).erase 3 = { 0 } by decide, show ( { 1, 3 } : Finset ( Fin 5 ) ).erase 3 = { 1 } by decide, show ( { 2, 3 } : Finset ( Fin 5 ) ).erase 3 = { 2 } by decide, show ( { 0, 1, 2, 4 } : Finset ( Fin 5 ) ).erase 1 = { 0, 2, 4 } by decide, show ( { 0, 1, 2, 4 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1, 4 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 2, 3 } : Finset ( Fin 5 ) ).erase 3 = { 0, 1, 2 } by decide, show ( { 0, 1, 3 } : Finset ( Fin 5 ) ).erase 3 = { 0, 1 } by decide, show ( { 0, 2, 3 } : Finset ( Fin 5 ) ).erase 3 = { 0, 2 } by decide, show ( { 0, 3, 4 } : Finset ( Fin 5 ) ).erase 3 = { 0, 4 } by decide ] at this;
  simp +decide [ show ( { 1, 2, 3 } : Finset ( Fin 5 ) ).erase 3 = { 1, 2 } by decide, show ( { 0, 1, 4 } : Finset ( Fin 5 ) ).erase 1 = { 0, 4 } by decide, show ( { 1, 3, 4 } : Finset ( Fin 5 ) ).erase 3 = { 1, 4 } by decide, show ( { 2, 3, 4 } : Finset ( Fin 5 ) ).erase 3 = { 2, 4 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 2 } : Finset ( Fin 5 ) ).erase 1 = { 0, 2 } by decide, show ( { 0, 1, 2 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 3, 4 } : Finset ( Fin 5 ) ).erase 3 = { 0, 1, 4 } by decide, show ( { 0, 2, 3, 4 } : Finset ( Fin 5 ) ).erase 3 = { 0, 2, 4 } by decide, show ( { 1, 2, 3, 4 } : Finset ( Fin 5 ) ).erase 3 = { 1, 2, 4 } by decide, show ( { 0, 1, 2, 3, 4 } : Finset ( Fin 5 ) ).erase 3 = { 0, 1, 2, 4 } by decide ] at this;
  simp +decide [ show ( { 0, 1 } : Finset ( Fin 5 ) ).erase 1 = { 0 } by decide, show ( { 0 } : Finset ( Fin 5 ) ).erase 0 = ∅ by decide ] at this;
  have := heven { 0 } ; have := heven { 1 } ; have := heven { 2 } ; have := heven { 4 } ; simp_all +decide [ IsEvenSpinor ] ;
  grind

/-
The degree-four Cartan relation on the coordinate hyperplane missing mode 2.
-/
lemma chart_quadric_coord_0134
    (ψ : FockSpinor) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) (h0 : ψ ∅ = 1) :
    ψ {0, 1, 3, 4} =
      ψ {0, 1} * ψ {3, 4} - ψ {0, 3} * ψ {1, 4} + ψ {0, 4} * ψ {1, 3} := by
  unfold gammaBilinear at hquad; simp_all +decide [ Finset.sum_add_distrib, add_mul, mul_add, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Pi.single_apply ] ;
  have := congrFun hquad.2 2; simp_all +decide [ chevalleyPairing ] ;
  unfold wedge at this; simp_all +decide [ Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.filter_or, Finset.filter_not, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ;
  rw [ show ( Finset.filter ( fun x => 2 ∈ x ) Finset.univ : Finset ( Finset ( Fin 5 ) ) ) = { { 2 }, { 0, 2 }, { 1, 2 }, { 2, 3 }, { 2, 4 }, { 0, 1, 2 }, { 0, 2, 3 }, { 0, 2, 4 }, { 1, 2, 3 }, { 1, 2, 4 }, { 2, 3, 4 }, { 0, 1, 2, 3 }, { 0, 1, 2, 4 }, { 0, 2, 3, 4 }, { 1, 2, 3, 4 }, { 0, 1, 2, 3, 4 } } by decide ] at this; simp +decide [ Finset.sum ] at this;
  simp +decide [ chevalleySign, opSign ] at this;
  simp +decide [ show ( { 2 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 3, 4 } by decide, show ( { 3 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 2, 4 } by decide, show ( { 4 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 2, 3 } by decide ] at this;
  simp +decide [ show ( { 0, 2 } : Finset ( Fin 5 ) ).erase 2 = { 0 } by decide, show ( { 1, 2 } : Finset ( Fin 5 ) ).erase 2 = { 1 } by decide, show ( { 0, 1, 3, 4 } : Finset ( Fin 5 ) ).erase 1 = { 0, 3, 4 } by decide, show ( { 0, 1, 2, 4 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1, 4 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 2, 3 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1, 3 } by decide, show ( { 0, 1, 2 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1 } by decide, show ( { 0, 2, 3 } : Finset ( Fin 5 ) ).erase 2 = { 0, 3 } by decide, show ( { 0, 2, 4 } : Finset ( Fin 5 ) ).erase 2 = { 0, 4 } by decide ] at this;
  simp +decide [ show ( { 1, 2, 3 } : Finset ( Fin 5 ) ).erase 2 = { 1, 3 } by decide, show ( { 1, 2, 4 } : Finset ( Fin 5 ) ).erase 2 = { 1, 4 } by decide, show ( { 0, 1, 2, 3 } : Finset ( Fin 5 ) ).erase 3 = { 0, 1, 2 } by decide, show ( { 0, 1, 4 } : Finset ( Fin 5 ) ).erase 1 = { 0, 4 } by decide, show ( { 0, 1, 3 } : Finset ( Fin 5 ) ).erase 1 = { 0, 3 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 2 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1 } by decide, show ( { 0, 2, 3, 4 } : Finset ( Fin 5 ) ).erase 2 = { 0, 3, 4 } by decide, show ( { 1, 2, 3, 4 } : Finset ( Fin 5 ) ).erase 2 = { 1, 3, 4 } by decide, show ( { 0, 1, 2, 3, 4 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1, 3, 4 } by decide ] at this;
  simp +decide [ show ( { 0, 1 } : Finset ( Fin 5 ) ).erase 1 = { 0 } by decide, show ( { 0 } : Finset ( Fin 5 ) ).erase 0 = ∅ by decide ] at this;
  have := heven { 0 } ; have := heven { 1 } ; have := heven { 3 } ; have := heven { 4 } ; simp_all +decide [ IsEvenSpinor ] ;
  grind

/-
The degree-four Cartan relation on the coordinate hyperplane missing mode 1.
-/
lemma chart_quadric_coord_0234
    (ψ : FockSpinor) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) (h0 : ψ ∅ = 1) :
    ψ {0, 2, 3, 4} =
      ψ {0, 2} * ψ {3, 4} - ψ {0, 3} * ψ {2, 4} + ψ {0, 4} * ψ {2, 3} := by
  unfold gammaBilinear at hquad; simp_all +decide [ Finset.sum_add_distrib, add_mul, mul_add, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Pi.single_apply ] ;
  have := congrFun hquad.2 1; simp_all +decide [ chevalleyPairing ] ;
  unfold wedge at this; simp_all +decide [ Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.filter_or, Finset.filter_not, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
  rw [ show ( Finset.filter ( fun x => 1 ∈ x ) Finset.univ : Finset ( Finset ( Fin 5 ) ) ) = { { 1 }, { 0, 1 }, { 1, 2 }, { 1, 3 }, { 1, 4 }, { 0, 1, 2 }, { 0, 1, 3 }, { 0, 1, 4 }, { 1, 2, 3 }, { 1, 2, 4 }, { 1, 3, 4 }, { 0, 1, 2, 3 }, { 0, 1, 2, 4 }, { 0, 1, 3, 4 }, { 1, 2, 3, 4 }, { 0, 1, 2, 3, 4 } } by decide ] at this; simp +decide [ Finset.sum ] at this;
  simp +decide [ chevalleySign, opSign ] at this;
  simp +decide [ show ( { 1 } : Finset ( Fin 5 ) ) ᶜ = { 0, 2, 3, 4 } by decide, show ( { 2 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 3, 4 } by decide, show ( { 3 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 2, 4 } by decide, show ( { 4 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 2, 3 } by decide ] at this;
  simp +decide [ show ( { 0, 1 } : Finset ( Fin 5 ) ).erase 1 = { 0 } by decide, show ( { 0, 1, 3, 4 } : Finset ( Fin 5 ) ).erase 1 = { 0, 3, 4 } by decide, show ( { 0, 1, 2, 4 } : Finset ( Fin 5 ) ).erase 1 = { 0, 2, 4 } by decide, show ( { 0, 1, 2, 3 } : Finset ( Fin 5 ) ).erase 1 = { 0, 2, 3 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 2 } : Finset ( Fin 5 ) ).erase 1 = { 0, 2 } by decide, show ( { 0, 1, 3 } : Finset ( Fin 5 ) ).erase 1 = { 0, 3 } by decide, show ( { 0, 1, 4 } : Finset ( Fin 5 ) ).erase 1 = { 0, 4 } by decide, show ( { 0, 1, 2, 4 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1, 4 } by decide, show ( { 0, 1, 2, 3 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1, 3 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 2, 3 } : Finset ( Fin 5 ) ).erase 3 = { 0, 1, 2 } by decide, show ( { 0, 1, 2 } : Finset ( Fin 5 ) ).erase 1 = { 0, 2 } by decide, show ( { 0, 1, 2 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1 } by decide ] at this;
  simp +decide [ show ( { 0, 1 } : Finset ( Fin 5 ) ).erase 1 = { 0 } by decide, show ( { 0, 1, 2, 3, 4 } : Finset ( Fin 5 ) ).erase 1 = { 0, 2, 3, 4 } by decide ] at this;
  have := heven { 0 } ; have := heven { 2 } ; have := heven { 3 } ; have := heven { 4 } ; simp_all +decide [ IsEvenSpinor ] ;
  grind

/-
The degree-four Cartan relation on the coordinate hyperplane missing mode 0.
-/
lemma chart_quadric_coord_1234
    (ψ : FockSpinor) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) (h0 : ψ ∅ = 1) :
    ψ {1, 2, 3, 4} =
      ψ {1, 2} * ψ {3, 4} - ψ {1, 3} * ψ {2, 4} + ψ {1, 4} * ψ {2, 3} := by
  unfold gammaBilinear at hquad; simp_all +decide [ Finset.sum_add_distrib, add_mul, mul_add, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Pi.single_apply ] ;
  have := congrFun hquad.2 0; simp_all +decide [ chevalleyPairing ] ;
  unfold wedge at this; simp_all +decide [ Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.filter_or, Finset.filter_not, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
  rw [ show ( Finset.filter ( fun x => 0 ∈ x ) Finset.univ : Finset ( Finset ( Fin 5 ) ) ) = { { 0 }, { 0, 1 }, { 0, 2 }, { 0, 3 }, { 0, 4 }, { 0, 1, 2 }, { 0, 1, 3 }, { 0, 1, 4 }, { 0, 2, 3 }, { 0, 2, 4 }, { 0, 3, 4 }, { 0, 1, 2, 3 }, { 0, 1, 2, 4 }, { 0, 1, 3, 4 }, { 0, 2, 3, 4 }, { 0, 1, 2, 3, 4 } } by decide ] at this; simp +decide [ Finset.sum ] at this;
  simp +decide [ chevalleySign, opSign ] at this;
  simp +decide [ show ( { 0 } : Finset ( Fin 5 ) ) ᶜ = { 1, 2, 3, 4 } by decide, show ( { 1 } : Finset ( Fin 5 ) ) ᶜ = { 0, 2, 3, 4 } by decide, show ( { 2 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 3, 4 } by decide, show ( { 3 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 2, 4 } by decide, show ( { 4 } : Finset ( Fin 5 ) ) ᶜ = { 0, 1, 2, 3 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 3, 4 } : Finset ( Fin 5 ) ).erase 1 = { 0, 3, 4 } by decide, show ( { 0, 1, 3, 4 } : Finset ( Fin 5 ) ).erase 0 = { 1, 3, 4 } by decide, show ( { 0, 1, 2, 4 } : Finset ( Fin 5 ) ).erase 1 = { 0, 2, 4 } by decide, show ( { 0, 1, 2, 4 } : Finset ( Fin 5 ) ).erase 0 = { 1, 2, 4 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 2, 3 } : Finset ( Fin 5 ) ).erase 1 = { 0, 2, 3 } by decide, show ( { 0, 1, 2, 3 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1, 3 } by decide, show ( { 0, 1, 2, 3 } : Finset ( Fin 5 ) ).erase 3 = { 0, 1, 2 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 2, 4 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1, 4 } by decide, show ( { 0, 1, 2 } : Finset ( Fin 5 ) ).erase 2 = { 0, 1 } by decide, show ( { 0, 1, 3 } : Finset ( Fin 5 ) ).erase 1 = { 0, 3 } by decide, show ( { 0, 1, 2 } : Finset ( Fin 5 ) ).erase 1 = { 0, 2 } by decide ] at this;
  simp +decide [ show ( { 0, 1, 4 } : Finset ( Fin 5 ) ).erase 1 = { 0, 4 } by decide, show ( { 0, 1, 4 } : Finset ( Fin 5 ) ).erase 0 = { 1, 4 } by decide, show ( { 0, 1 } : Finset ( Fin 5 ) ).erase 1 = { 0 } by decide, show ( { 0, 1 } : Finset ( Fin 5 ) ).erase 0 = { 1 } by decide ] at this;
  have := heven { 1 } ; have := heven { 2 } ; have := heven { 3 } ; have := heven { 4 } ; simp_all +decide [ IsEvenSpinor ] ;
  grind

/-
In the vacuum chart, the ten Cartan quadrics give the usual finite
bivector-exponential normal form.  This coordinate lemma deliberately uses
`creationRootEnd` products rather than analytic exponentials.
-/
set_option maxHeartbeats 2000000 in
lemma exists_creationRoots_vacuum_eq_of_quadric
    (ψ : FockSpinor) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) (h0 : ψ ∅ = 1) :
    ∃ g : evenCliffordGroup, g.val.val vacuumSpinor = ψ := by
  by_contra h_contra;
  -- By definition of $ creationRootEnd $, we know that each $ creationRootEnd i j t $ is in the evenCliffordGroup.
  have h_creationRootEnd_mem : ∀ i j : Fin 5, ∀ t : ℂ, i ≠ j → ∃ g : evenCliffordGroup, g.val.val = creationRootEnd i j t := by
    exact creationRootEnd_mem
  choose! g hg using h_creationRootEnd_mem;
  -- Let's choose the specific elements $g_{ij}$ for $i < j$.
  set g12 := g 0 1 (ψ {0, 1})
  set g13 := g 0 2 (ψ {0, 2})
  set g14 := g 0 3 (ψ {0, 3})
  set g15 := g 0 4 (ψ {0, 4})
  set g23 := g 1 2 (ψ {1, 2})
  set g24 := g 1 3 (ψ {1, 3})
  set g25 := g 1 4 (ψ {1, 4})
  set g34 := g 2 3 (ψ {2, 3})
  set g35 := g 2 4 (ψ {2, 4})
  set g45 := g 3 4 (ψ {3, 4});
  refine' h_contra ⟨ g12 * g13 * g14 * g15 * g23 * g24 * g25 * g34 * g35 * g45, _ ⟩;
  simp +zetaDelta at *;
  ext S; simp +decide [ hg, creationRootEnd ] ;
  simp +decide [ wedge, contract, Pi.single_apply ] at *;
  simp +decide [ vacuumSpinor ] at *;
  fin_cases S <;> simp +decide [ * ] at *;
  all_goals simp +decide [ basisSpinor, opSign ] at *;
  all_goals have := heven { 0 } ; have := heven { 1 } ; have := heven { 2 } ; have := heven { 3 } ; have := heven { 4 } ; simp_all +decide [ IsEvenSpinor ] ;
  all_goals norm_cast;
  · convert chart_quadric_coord_0123 ψ heven hquad h0 |> Eq.symm using 1 ; ring!;
  · convert chart_quadric_coord_0124 ψ heven hquad h0 |> Eq.symm using 1 ; ring!;
  · convert chart_quadric_coord_0134 ψ heven hquad h0 |> Eq.symm using 1 ; ring!;
  · convert chart_quadric_coord_0234 ψ heven hquad h0 |> Eq.symm using 1 ; ring!;
  · convert chart_quadric_coord_1234 ψ heven hquad h0 |> Eq.symm using 1 ; ring!

/-
A mode flip reads the coefficient at the toggled subset, with the
fermionic ordering sign.
-/
lemma flipUnit_apply_coeff (i : Fin 5) (ψ : FockSpinor)
    (T : Finset (Fin 5)) :
    (flipUnit i : Module.End ℂ FockSpinor) ψ T =
      opSign i T * ψ (flipSet i T) := by
  simp +decide [ flipVec, cliffordAction, wedge, contract, Pi.single_apply, Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
  unfold flipSet; aesop;

/-
The Chevalley pairing is invariant when the same hyperbolic mode
flip is applied in both slots.
-/
set_option maxHeartbeats 2000000 in
lemma chevalleyPairing_flip (i : Fin 5) (ψ φ : FockSpinor) :
    chevalleyPairing ((flipUnit i : Module.End ℂ FockSpinor) ψ)
      ((flipUnit i : Module.End ℂ FockSpinor) φ) = chevalleyPairing ψ φ := by
  apply Finset.sum_bij (fun T _ => if i ∈ T then T.erase i else insert i T);
  · exact fun _ _ => Finset.mem_univ _;
  · decide +revert;
  · grind;
  · intro T hT; split_ifs <;> simp_all +decide [ flipUnit_apply_coeff, cliffordAction_flipVec ] ; ring;
    · unfold wedge contract; simp +decide [ *, Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.filter_or, Finset.filter_not, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
      unfold chevalleySign opSign; simp +decide [ *, Finset.sum_add_distrib, add_mul, mul_add, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.filter_or, Finset.filter_not, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
      fin_cases i <;> simp +decide [ belowCount ] at *;
      · fin_cases T <;> simp +decide at *;
      · fin_cases T <;> simp +decide [ shuffleInversions ] at *;
      · fin_cases T <;> simp +decide at *;
      · fin_cases T <;> simp +decide at *;
      · fin_cases T <;> simp +decide at *;
    · unfold wedge contract; simp +decide [ *, Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
      unfold chevalleySign opSign; simp +decide [ *, Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
      unfold shuffleInversions belowCount; simp +decide [ *, Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
      fin_cases i <;> simp +decide [ Finset.filter_erase, Finset.filter_insert ]; all_goals fin_cases T <;> simp +decide at *

/-
The gamma-bilinear is equivariant under a single mode flip.
-/
lemma gammaBilinear_flip (i : Fin 5) (ψ : FockSpinor) :
    gammaBilinear ((flipUnit i : Module.End ℂ FockSpinor) ψ)
      ((flipUnit i : Module.End ℂ FockSpinor) ψ) =
      reflectTwist (flipVec i) (gammaBilinear ψ ψ) := by
  have h_flip : ∀ (v : V10), B10 (gammaBilinear ((flipUnit i : Module.End ℂ FockSpinor) ψ) ((flipUnit i : Module.End ℂ FockSpinor) ψ)) v = B10 (gammaBilinear ψ ψ) (reflectTwist (flipVec i) v) := by
    intro v
    rw [B10_gammaBilinear, B10_gammaBilinear];
    have h_flip_unit_intertwine : cliffordAction v ((flipUnit i : Module.End ℂ FockSpinor) ψ) = (flipUnit i : Module.End ℂ FockSpinor) (cliffordAction (reflectTwist (flipVec i) v) ψ) := by
      have := gammaUnit_conj_gammaEnd ( flipVec i ) v ( by simp +decide [ Q10_flipVec ] ) ; simp_all +decide [ mul_assoc, mul_left_comm, mul_comm ] ;
      simp +decide [ ← this, ← mul_assoc, ← gammaEnd_apply ];
      have h_flipUnit_inv : (gammaUnit (flipVec i) (by simp +decide [ Q10_flipVec ]) : Module.End ℂ FockSpinor) * (gammaUnit (flipVec i) (by simp +decide [ Q10_flipVec ]) : Module.End ℂ FockSpinor) = 1 := by
        convert gammaEnd_mul_self ( flipVec i ) using 1 ; simp +decide [ Q10_flipVec ];
      convert congr_arg ( fun f => f ( gammaEnd v ( gammaEnd ( flipVec i ) ψ ) ) ) h_flipUnit_inv.symm using 1;
    rw [ h_flip_unit_intertwine, chevalleyPairing_flip ];
  refine' Prod.ext _ _ <;> simp_all +decide [ B10 ];
  · ext x; specialize h_flip 0 ( fun y => if y = x then 1 else 0 ) ; simp_all +decide [ Finset.sum_add_distrib, add_mul, mul_add, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.filter_or, Finset.filter_not, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ;
    unfold reflectTwist; simp +decide [ *, Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.filter_or, Finset.filter_not, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
    unfold B10; simp +decide [ *, Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.filter_or, Finset.filter_not, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
    simp +decide [ Finset.sum_add_distrib, mul_add, add_mul, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, mul_assoc, mul_comm, mul_left_comm, Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.filter_or, Finset.filter_not, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
  · ext j; specialize h_flip ( fun k => if k = j then 1 else 0 ) 0; simp_all +decide [ Finset.sum_ite, Finset.filter_eq', Finset.filter_ne' ] ;
    unfold reflectTwist; simp +decide [ Finset.sum_add_distrib, add_mul, mul_add, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Finset.sum_ite, Finset.filter_ne', Finset.filter_eq' ] ; ring;
    unfold B10; simp +decide [ Finset.sum_add_distrib, add_mul, mul_add, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Finset.sum_ite, Finset.filter_ne', Finset.filter_eq' ] ; ring;

/-
A signed double mode flip preserves Cartan's pure-spinor quadrics.
-/
lemma gammaBilinear_doubleFlip_eq_zero (i j : Fin 5) (ψ : FockSpinor)
    (hquad : gammaBilinear ψ ψ = 0) :
    gammaBilinear
      ((flipUnit i * flipUnit j : (Module.End ℂ FockSpinor)ˣ).val ψ)
      ((flipUnit i * flipUnit j : (Module.End ℂ FockSpinor)ˣ).val ψ) = 0 := by
  convert gammaBilinear_flip i ( ( flipUnit j : Module.End ℂ FockSpinor ) ψ ) using 1;
  rw [ gammaBilinear_flip ];
  unfold reflectTwist; aesop;

/-
Cancellation-safe chart entry for a specified nonzero even support
coordinate.  The bound is the induction measure for removing occupied modes
in pairs.
-/
lemma exists_evenCliffordGroup_vacuum_coeff_of_support (n : ℕ)
    (S : Finset (Fin 5)) (hn : S.card ≤ n) (hpar : S.card % 2 = 0)
    (ψ : FockSpinor) (hcoord : ψ S ≠ 0)
    (hquad : gammaBilinear ψ ψ = 0) :
    ∃ g : evenCliffordGroup,
      gammaBilinear (g.val.val ψ) (g.val.val ψ) = 0 ∧
      (g.val.val ψ) ∅ ≠ 0 := by
  by_contra h_contra;
  induction' n using Nat.strong_induction_on with n ih generalizing S ψ;
  by_cases hS_empty : S = ∅ <;> simp_all +decide [ Finset.card_eq_zero ];
  · specialize h_contra 1 ; simp_all +decide [ evenCliffordGroup ];
  · -- Choose distinct i,j∈S.
    obtain ⟨i, hi, j, hj, hij⟩ : ∃ i ∈ S, ∃ j ∈ S, i ≠ j := by
      exact Finset.one_lt_card.1 ( Nat.one_lt_iff_ne_zero_and_ne_one.2 ⟨ by aesop_cat, by aesop_cat ⟩ ) |> fun ⟨ i, hi, j, hj, hij ⟩ => ⟨ i, hi, j, hj, hij ⟩;
    -- Let ψ'=(flipUnit i*flipUnit j)ψ and S'=flipSet i (flipSet j S)=erase i (erase j S), whose card is card S-2 ≤ n.
    set ψ' : FockSpinor := (flipUnit i * flipUnit j : (Module.End ℂ FockSpinor)ˣ).val ψ
    set S' : Finset (Fin 5) := flipSet i (flipSet j S)
    have hS'_card : S'.card = S.card - 2 := by
      simp +zetaDelta at *;
      unfold flipSet; simp +decide [ *, Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.filter_or, Finset.filter_not, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
      rfl
    have hS'_par : S'.card % 2 = 0 := by
      omega
    have hψ'_coord : ψ' S' ≠ 0 := by
      simp +zetaDelta at *;
      rw [ cliffordAction_flipVec, cliffordAction_flipVec ];
      simp +decide [ wedge, contract, Pi.single_apply, Finset.sum_ite, Finset.filter_ne', Finset.filter_and, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton, hij ] ; ring;
      unfold flipSet; simp +decide [ *, Finset.mem_erase, Finset.mem_insert, Finset.mem_singleton ] ; ring;
      split_ifs <;> simp_all +decide [ opSign_ne_zero ]
    have hψ'_quad : gammaBilinear ψ' ψ' = 0 := by
      convert gammaBilinear_doubleFlip_eq_zero i j ψ hquad using 1;
    -- Apply the induction hypothesis to ψ' and S'.
    obtain ⟨g, hg⟩ : ∃ g : evenCliffordGroup, gammaBilinear (g.val.val ψ') (g.val.val ψ') = 0 ∧ g.val.val ψ' ∅ ≠ 0 := by
      specialize ih ( S'.card ) ( by
        grind +revert ) S' ( by
        lia ) hS'_par ψ' hψ'_coord hψ'_quad; aesop;
    specialize h_contra ( g.val * ( flipUnit i * flipUnit j ) ) ; simp_all +decide [ mul_assoc, mul_left_comm, mul_comm ] ;
    exact hg.2 ( h_contra ( by simpa [ ψ' ] using hg.1 ) ( evenCliffordGroup.mul_mem g.2 ( flipUnit_mul_flipUnit_mem i j ) ) )

/-
A nonzero even spinor satisfying the Cartan quadrics can be moved into
its affine vacuum chart by signed mode flips.
-/
lemma exists_evenCliffordGroup_vacuum_coefficient_ne_zero
    (ψ : FockSpinor) (hne : ψ ≠ 0) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) :
    ∃ g : evenCliffordGroup,
      gammaBilinear (g.val.val ψ) (g.val.val ψ) = 0 ∧
      (g.val.val ψ) ∅ ≠ 0 := by
  -- By definition of even spinor, there exists a subset S such that ψ S ≠ 0 and S.card % 2 = 0.
  obtain ⟨S, hS⟩ : ∃ S : Finset (Fin 5), ψ S ≠ 0 ∧ S.card % 2 = 0 := by
    contrapose! hne;
    ext S; specialize hne S; by_cases hS : S.card % 2 = 0 <;> simp_all +decide ;
    exact heven S hS;
  obtain ⟨g, hg⟩ := exists_evenCliffordGroup_vacuum_coeff_of_support S.card S ( by rfl ) hS.2 ψ hS.1 hquad; exact ⟨ g, hg.1, hg.2 ⟩ ;

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
  obtain ⟨g₀, hquad, hcoeff⟩ :=
    exists_evenCliffordGroup_vacuum_coefficient_ne_zero
      ψ hne hψ.even hψ.quadric
  let a : ℂ := g₀.val.val ψ ∅
  have ha : a ≠ 0 := hcoeff
  let χ : FockSpinor := a⁻¹ • g₀.val.val ψ
  have hχeven : IsEvenSpinor χ := by
    apply IsEvenSpinor.smul
    exact (evenCliffordGroup_preservesChirality g₀.val g₀.property).1.1 ψ hψ.even
  have hχquad : gammaBilinear χ χ = 0 := by
    simp only [χ, gammaBilinear_smul_left, gammaBilinear_smul_right,
      smul_smul, hquad, smul_zero]
  have hχzero : χ ∅ = 1 := by
    simp [χ, a, ha]
  obtain ⟨h, hh⟩ :=
    exists_creationRoots_vacuum_eq_of_quadric χ hχeven hχquad hχzero
  let s : evenCliffordGroup :=
    ⟨scalarUnit a⁻¹ (inv_ne_zero ha), scalarUnit_mem _ _⟩
  refine ⟨h⁻¹ * s * g₀, ?_⟩
  change h⁻¹.val.val (s.val.val (g₀.val.val ψ)) = vacuumSpinor
  have hs : s.val.val (g₀.val.val ψ) = χ := by
    simp [s, χ, scalarUnit_val]
  rw [hs, ← hh]
  exact congr_arg (fun f : Module.End ℂ FockSpinor => f vacuumSpinor)
    (Units.inv_mul h.val)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.Spin10StandardizablePairs.exists_evenCliffordGroup_vacuum_coefficient_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_evenCliffordGroup_vacuum_coefficient_ne_zero

/-- info: 'PhysicsSM.Draft.Spin10StandardizablePairs.exists_evenCliffordGroup_smul_eq_vacuum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_evenCliffordGroup_smul_eq_vacuum

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
