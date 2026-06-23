import Mathlib.Tactic

/-!
# Visible-fan mass characterization: massive iff non-collinear, with a bound

This focused Aristotle target completes the finite characterization of when a
visible celestial fan carries rest mass, the companion to the non-collinearity
no-go. With `momentMassSq = (E^2 - |C|^2) / 4` and the gap identity

```text
E^2 - |C|^2 = sum_{i,j} weight i * weight j * (1 - <dir i, dir j>),
```

for unit directions and nonnegative weights each summand is nonnegative, so:

- a quantitative lower bound: the moment mass square dominates any single pair
  contribution `weight i * weight j * (1 - <dir i, dir j>) / 4`;
- masslessness is exactly collinearity: the moment mass square vanishes iff every
  pair of positively-weighted cells points in the same unit direction.

Together with `visiblePluckerMass_nonzero_of_noncollinear` this pins down the P9
visibility dichotomy: visible closure is a rest-frame condition, and visible mass
vanishes only in the degenerate collinear (lightlike) case.

Conventions follow `PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore`; the
definitions are copied so the package is standalone (Mathlib only).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9VisibleFanMassCharacterization

open BigOperators

abbrev Vec3 := Fin 3 -> Real

/-- Euclidean dot product on coordinate three-vectors. -/
def vdot (a b : Vec3) : Real :=
  Finset.univ.sum fun k => a k * b k

/-- Squared Euclidean norm for three-vectors. -/
def normSq (a : Vec3) : Real :=
  vdot a a

/-- Weighted celestial closure vector. -/
def closureVector {n : Nat} (weight : Fin n -> Real)
    (dir : Fin n -> Vec3) : Vec3 :=
  fun k => Finset.univ.sum fun i => weight i * dir i k

/-- Total energy of a weighted finite fan. -/
def totalEnergy {n : Nat} (weight : Fin n -> Real) : Real :=
  Finset.univ.sum weight

/-- Celestial moment mass square `(E^2 - |C|^2) / 4`. -/
def momentMassSq {n : Nat} (weight : Fin n -> Real)
    (dir : Fin n -> Vec3) : Real :=
  (totalEnergy weight ^ 2 - normSq (closureVector weight dir)) / 4

/-- Symmetry of the dot product. -/
lemma vdot_comm (a b : Vec3) : vdot a b = vdot b a := by
  unfold vdot
  exact Finset.sum_congr rfl (fun k _ => by ring)

/-
Gap identity: `E^2 - |C|^2 = sum_{i,j} weight i * weight j * (1 - <dir i, dir j>)`.
-/
lemma gap_identity {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (_hu : forall i, normSq (dir i) = 1) :
    totalEnergy weight ^ 2 - normSq (closureVector weight dir)
      = Finset.univ.sum fun i => Finset.univ.sum fun j =>
          weight i * weight j * (1 - vdot (dir i) (dir j)) := by
  unfold totalEnergy normSq closureVector vdot;
  simp +decide [mul_sub, Finset.mul_sum _ _ _, mul_comm, mul_left_comm, pow_two];
  exact Eq.symm Finset.sum_comm_cycle

/-
For unit vectors, `0 <= 1 - <dir i, dir j>`.
-/
lemma one_sub_vdot_nonneg (a b : Vec3)
    (ha : normSq a = 1) (hb : normSq b = 1) :
    0 <= 1 - vdot a b := by
  -- By definition of dot product, we know that $\langle a, b \rangle = \sum_{k=0}^{2} a_k b_k$.
  unfold vdot normSq at *;
  unfold vdot at *; simp_all +decide [ Fin.sum_univ_three ] ; nlinarith [ sq_nonneg ( a 0 - b 0 ), sq_nonneg ( a 1 - b 1 ), sq_nonneg ( a 2 - b 2 ) ] ;

/-
For unit vectors, `<dir i, dir j> = 1` forces equality of the directions.
-/
lemma eq_of_vdot_eq_one (a b : Vec3)
    (ha : normSq a = 1) (hb : normSq b = 1) (h : vdot a b = 1) :
    a = b := by
  unfold normSq vdot at *;
  simp_all +decide [ Fin.sum_univ_three ];
  exact funext fun i => by fin_cases i <;> norm_num <;> nlinarith! only [ sq_nonneg ( a 0 - b 0 ), sq_nonneg ( a 1 - b 1 ), sq_nonneg ( a 2 - b 2 ), ha, hb, h ] ;

/-
Quantitative visibility bound: the moment mass square dominates the contribution
of any single pair of cells.
-/
theorem momentMassSq_ge_pair_term
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hw : forall i, 0 <= weight i)
    (hu : forall i, normSq (dir i) = 1)
    (i j : Fin n) :
    weight i * weight j * (1 - vdot (dir i) (dir j)) / 4 <= momentMassSq weight dir := by
  unfold momentMassSq;
  gcongr;
  convert Finset.single_le_sum ( fun i _ => Finset.sum_nonneg fun j _ => mul_nonneg ( mul_nonneg ( hw i ) ( hw j ) ) ( one_sub_vdot_nonneg ( dir i ) ( dir j ) ( hu i ) ( hu j ) ) ) ( Finset.mem_univ i ) |> le_trans ( Finset.single_le_sum ( fun j _ => mul_nonneg ( mul_nonneg ( hw i ) ( hw j ) ) ( one_sub_vdot_nonneg ( dir i ) ( dir j ) ( hu i ) ( hu j ) ) ) ( Finset.mem_univ j ) ) using 1;
  convert gap_identity weight dir hu using 1

/-
Collinear visible fans are massless: if every pair of positively-weighted cells
points in the same unit direction, the moment mass square vanishes.
-/
theorem visibleFan_massless_of_collinear
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hw : forall i, 0 <= weight i)
    (hu : forall i, normSq (dir i) = 1)
    (hcol : forall i j, 0 < weight i -> 0 < weight j -> dir i = dir j) :
    momentMassSq weight dir = 0 := by
  convert div_eq_zero_iff.mpr ( Or.inl _ ) using 1;
  rw [ gap_identity ];
  · refine' Finset.sum_eq_zero _;
    intro i hi; refine' Finset.sum_eq_zero fun j hj => _; by_cases hi' : weight i = 0 <;> by_cases hj' : weight j = 0 <;> simp_all +decide [ mul_assoc ] ;
    grind +locals;
  · assumption

/-
Massless visible fans are collinear: if the moment mass square vanishes, every
pair of positively-weighted cells points in the same unit direction.
-/
theorem visibleFan_massless_imp_collinear
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hw : forall i, 0 <= weight i)
    (hu : forall i, normSq (dir i) = 1)
    (hmass : momentMassSq weight dir = 0) :
    forall i j, 0 < weight i -> 0 < weight j -> dir i = dir j := by
  intros i j hi hj
  have h_dot : vdot (dir i) (dir j) = 1 := by
    contrapose! hmass; have := momentMassSq_ge_pair_term weight dir hw hu i j; simp_all +decide ;
    exact ne_of_gt ( lt_of_lt_of_le ( div_pos ( mul_pos ( mul_pos hi hj ) ( sub_pos.mpr ( lt_of_le_of_ne ( by linarith [ one_sub_vdot_nonneg ( dir i ) ( dir j ) ( hu i ) ( hu j ) ] ) hmass ) ) ) zero_lt_four ) this )
  exact eq_of_vdot_eq_one (dir i) (dir j) (hu i) (hu j) h_dot

end PhysicsSM.Draft.NullEdgeP9VisibleFanMassCharacterization
