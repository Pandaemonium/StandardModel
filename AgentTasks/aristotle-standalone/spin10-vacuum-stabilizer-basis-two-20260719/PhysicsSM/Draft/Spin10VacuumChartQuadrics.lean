import PhysicsSM.Draft.Spin10StandardizablePairs

/-!
# Vacuum-chart Pluecker coordinate identities

Kernel-checked coordinate lemmas salvaged from the failed Aristotle chart
normal-form run `d601d2ff-a3b1-4b5e-8579-c54a5aeadc06`. This module does not
claim the returned affine chart reconstruction, which exceeded the heartbeat
limit, or the still-open double-flip invariance statements.
-/

noncomputable section

namespace PhysicsSM.Draft.Spin10StandardizablePairs

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.Spin10StabilizerTransitivity

/-- A fixed affine-chart product of the ten elementary creation roots. -/
def creationChartEnd (ψ : FockSpinor) : Module.End ℂ FockSpinor :=
  creationRootEnd 0 1 (ψ {0, 1}) *
  creationRootEnd 0 2 (ψ {0, 2}) *
  creationRootEnd 0 3 (ψ {0, 3}) *
  creationRootEnd 0 4 (ψ {0, 4}) *
  creationRootEnd 1 2 (ψ {1, 2}) *
  creationRootEnd 1 3 (ψ {1, 3}) *
  creationRootEnd 1 4 (ψ {1, 4}) *
  creationRootEnd 2 3 (ψ {2, 3}) *
  creationRootEnd 2 4 (ψ {2, 4}) *
  creationRootEnd 3 4 (ψ {3, 4})

/-
The degree-four Cartan relation on the coordinate hyperplane missing mode 4.
-/
lemma quadric_coord_0123
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
lemma quadric_coord_0124
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
lemma quadric_coord_0134
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
lemma quadric_coord_0234
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
lemma quadric_coord_1234
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

end PhysicsSM.Draft.Spin10StandardizablePairs
