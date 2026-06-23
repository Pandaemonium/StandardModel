import Mathlib.Tactic

/-!
# Non-collinear visible fans carry positive mass and a visible source

This focused Aristotle target proves the P9 no-go theorem ranked by the
post-suppression source-visibility audit:

```text
visible non-collinearity gives nonzero mass/source.
```

For a finite visible fan, `momentMassSq = (E^2 - |C|^2) / 4`, with `E` the total
energy `sum_i weight i` and `C` the weighted closure vector
`sum_i weight i * dir i`. When the directions are unit vectors and the weights
are nonnegative, the gap expands as

```text
E^2 - |C|^2 = sum_{i,j} weight i * weight j * (1 - <dir i, dir j>),
```

every term of which is nonnegative by Cauchy-Schwarz, so the moment mass square
is nonnegative. If two cells with positive weight point in different unit
directions, their off-diagonal term is strictly positive
(`|dir i - dir j|^2 = 2 (1 - <dir i, dir j>) > 0`), so the whole moment mass
square is strictly positive. Visible non-collinear excitations therefore carry
positive rest mass and a source that is visible to the unit test; they cannot be
hidden by closure.

Conventions follow the existing P9 draft core
`PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore`: the same `Vec3`,
`vdot`, `normSq`, `closureVector`, `totalEnergy`, `momentMassSq`, `massSource`,
and `unitTest` definitions, copied here so the package is standalone (Mathlib
only, no `PhysicsSM` import).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9NoncollinearMassNogo

open BigOperators

abbrev Cochain (n : Nat) := Fin n -> Real

/-- Finite source/test pairing. -/
def sourcePairing {n : Nat} (source test : Cochain n) : Real :=
  Finset.univ.sum fun i => source i * test i

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

/-- One-face source equal to the visible fan's moment mass square. -/
def massSource {n : Nat} (weight : Fin n -> Real)
    (dir : Fin n -> Vec3) : Cochain 1 :=
  fun _ => momentMassSq weight dir

/-- Unit test on the one-face toy diamond. -/
def unitTest : Cochain 1 :=
  fun _ => 1

/-- Symmetry of the Euclidean dot product. -/
lemma vdot_comm (a b : Vec3) : vdot a b = vdot b a := by
  unfold vdot
  exact Finset.sum_congr rfl (fun k _ => mul_comm _ _)

/-
The energy/closure gap expands as a double sum of `weight i * weight j *
(1 - <dir i, dir j>)`. This identity holds unconditionally.
-/
lemma gap_eq_doubleSum {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3) :
    totalEnergy weight ^ 2 - normSq (closureVector weight dir)
      = Finset.univ.sum fun i => Finset.univ.sum fun j =>
          weight i * weight j * (1 - vdot (dir i) (dir j)) := by
  simp +decide only [totalEnergy, sq, normSq];
  unfold vdot closureVector; simp +decide [ mul_sub, Finset.mul_sum _ _ _, Finset.sum_mul ] ;
  exact congrArg₂ _ ( Finset.sum_comm ) ( Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring ) ) )

/-
For two unit directions, `1 - <dir i, dir j> = |dir i - dir j|^2 / 2 >= 0`.
-/
lemma one_sub_vdot_nonneg {n : Nat} (dir : Fin n -> Vec3)
    (hu : forall i, normSq (dir i) = 1) (i j : Fin n) :
    0 <= 1 - vdot (dir i) (dir j) := by
  have h_cauchy_schwarz : ∀ (u v : Fin 3 → ℝ), (∑ k, u k * v k) ^ 2 ≤ (∑ k, u k ^ 2) * (∑ k, v k ^ 2) :=
    fun u v => Finset.sum_mul_sq_le_sq_mul_sq Finset.univ u v
  simp_all +decide [ vdot, normSq ];
  exact le_of_pow_le_pow_left₀ ( by norm_num ) ( by norm_num ) ( le_trans ( h_cauchy_schwarz _ _ ) ( by simp +decide [ *, sq ] ) )

/-
For two distinct unit directions, `1 - <dir i, dir j> > 0`.
-/
lemma one_sub_vdot_pos {n : Nat} (dir : Fin n -> Vec3)
    (hu : forall i, normSq (dir i) = 1) {i j : Fin n} (hij : Not (dir i = dir j)) :
    0 < 1 - vdot (dir i) (dir j) := by
  unfold normSq vdot at *;
  have h_diff : ∑ k, (dir i k - dir j k) ^ 2 > 0 := by
    exact lt_of_le_of_ne ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ( Ne.symm <| by intro H; exact hij <| funext fun k => sub_eq_zero.mp <| sq_eq_zero_iff.mp <| by rw [ Finset.sum_eq_zero_iff_of_nonneg fun _ _ => sq_nonneg _ ] at H; aesop );
  simp_all +decide [ sub_sq, Finset.sum_add_distrib, mul_assoc ];
  simp_all +decide [ ← Finset.mul_sum _ _ _, sq ] ; linarith [ hu i, hu j ]

/-
A visible fan of unit directions with nonnegative weights has nonnegative
moment mass square. This is the finite Cauchy-Schwarz bound `|C| <= E`.
-/
theorem visibleFan_mass_nonneg
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hw : forall i, 0 <= weight i)
    (hu : forall i, normSq (dir i) = 1) :
    0 <= momentMassSq weight dir := by
  convert div_nonneg ( gap_eq_doubleSum weight dir ▸ Finset.sum_nonneg fun i hi => Finset.sum_nonneg fun j hj => ?_ ) zero_le_four using 1;
  exact mul_nonneg ( mul_nonneg ( hw i ) ( hw j ) ) ( one_sub_vdot_nonneg dir hu i j )

/-
The P9 no-go: a visible fan with two positively-weighted cells pointing in
different unit directions has strictly positive moment mass square. Visible
non-collinearity carries positive rest mass; closure cannot hide it.
-/
theorem visiblePluckerMass_nonzero_of_noncollinear
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hw : forall i, 0 <= weight i)
    (hu : forall i, normSq (dir i) = 1)
    {i j : Fin n} (hwi : 0 < weight i) (hwj : 0 < weight j)
    (hij : Not (dir i = dir j)) :
    0 < momentMassSq weight dir := by
  refine' div_pos _ ( by norm_num );
  convert Finset.sum_pos' _ _;
  convert gap_eq_doubleSum weight dir using 1;
  · infer_instance;
  · exact fun i _ => Finset.sum_nonneg fun j _ => mul_nonneg ( mul_nonneg ( hw i ) ( hw j ) ) ( one_sub_vdot_nonneg dir hu i j );
  · refine' ⟨ i, Finset.mem_univ _, _ ⟩;
    refine' lt_of_lt_of_le _ ( Finset.single_le_sum ( fun a _ => mul_nonneg ( mul_nonneg hwi.le ( hw a ) ) ( one_sub_vdot_nonneg dir hu i a ) ) ( Finset.mem_univ j ) ) ; exact mul_pos ( mul_pos hwi hwj ) ( one_sub_vdot_pos dir hu hij )

/-
The induced one-face mass source of a non-collinear visible fan is visible to
the unit test.
-/
theorem visiblePluckerMass_source_visible_of_noncollinear
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hw : forall i, 0 <= weight i)
    (hu : forall i, normSq (dir i) = 1)
    {i j : Fin n} (hwi : 0 < weight i) (hwj : 0 < weight j)
    (hij : Not (dir i = dir j)) :
    0 < sourcePairing (massSource weight dir) unitTest := by
  convert visiblePluckerMass_nonzero_of_noncollinear weight dir hw hu hwi hwj hij using 1;
  unfold sourcePairing massSource unitTest; norm_num;

end PhysicsSM.Draft.NullEdgeP9NoncollinearMassNogo
