import Mathlib

set_option autoImplicit false
set_option maxHeartbeats 8000000

open Filter Metric Set Topology
open scoped Topology

noncomputable section

namespace NeverAntipodal

universe u v w

variable {X : Type u} {E : Type v}
variable [TopologicalSpace X] [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- The unit sphere in a real normed vector space.  The proof only uses the normed
linear structure; an inner product is not needed. -/
abbrev UnitSphere (E : Type v) [NormedAddCommGroup E] := Metric.sphere (0 : E) 1

/-- The unnormalised straight-line interpolation between two sphere-valued maps. -/
def straightLine (f g : X → UnitSphere E) (p : unitInterval × X) : E :=
  (1 - (p.1 : ℝ)) • (f p.2 : E) + (p.1 : ℝ) • (g p.2 : E)

/-
A straight segment between two unit vectors meets zero exactly when its endpoints
are antipodal (where meeting means at some parameter in the closed unit interval).
-/
theorem straightLine_ne_zero_iff (a b : UnitSphere E) :
    (∀ t : unitInterval, (1 - (t : ℝ)) • (a : E) + (t : ℝ) • (b : E) ≠ 0) ↔
      (a : E) ≠ -(b : E) := by
  constructor <;> intro h;
  · intro H; specialize h ⟨ 1 / 2, by norm_num ⟩ ; norm_num [ H ] at h;
  · intro t ht; contrapose! h; simp_all +decide [ add_eq_zero_iff_eq_neg ] ;
    have := congr_arg Norm.norm ht ; norm_num at this;
    rw [ norm_smul, norm_smul, Real.norm_of_nonneg, Real.norm_of_nonneg ] at this <;> norm_num at *;
    · norm_num [ show ( t : ℝ ) = 1 / 2 by linarith ] at *;
      simpa [ ← smul_assoc ] using congr_arg ( fun x => ( 2 : ℝ ) • x ) ht;
    · exact t.2.1;
    · exact t.2.2

/-
Pointwise never-antipodality makes every value of the unnormalised homotopy nonzero.
-/
omit [TopologicalSpace X] in
theorem straightLine_ne_zero (f g : X → UnitSphere E)
    (h : ∀ x, (f x : E) ≠ -(g x : E)) (p : unitInterval × X) :
    straightLine f g p ≠ 0 := by
  -- Apply the `straightLine_ne_zero_iff` theorem with `a = (f p.2).val` and `b = (g p.2).val`.
  have h_nonzero : ∀ t : unitInterval, (1 - t.val) • (f p.2 : E) + t.val • (g p.2 : E) ≠ 0 := by
    have := h p.2
    exact (straightLine_ne_zero_iff (f p.2) (g p.2)).mpr this;
  exact h_nonzero p.1

/-
Normalizing a nonzero vector produces a point of the unit sphere.
-/
theorem norm_inv_smul_mem_unitSphere (v : E) (hv : v ≠ 0) :
    ‖v‖⁻¹ • v ∈ Metric.sphere (0 : E) 1 := by
  simp +decide [ norm_smul, hv ]

/-
Normalization is continuous along any continuous, nowhere-zero vector-valued map.
-/
theorem continuous_inv_norm_smul {Y : Type*} [TopologicalSpace Y] (q : Y → E)
    (hq : Continuous q) (hne : ∀ y, q y ≠ 0) :
    Continuous (fun y => ‖q y‖⁻¹ • q y) := by
  exact Continuous.smul ( Continuous.inv₀ ( continuous_norm.comp hq ) fun y => norm_ne_zero_iff.mpr ( hne y ) ) hq

/-
The continuous ambient straight-line interpolation.
-/
theorem continuous_straightLine (f g : C(X, UnitSphere E)) :
    Continuous (straightLine f g) := by
  refine' Continuous.add _ _;
  · fun_prop (disch := norm_num);
  · exact Continuous.smul ( continuous_subtype_val.comp continuous_fst ) ( continuous_subtype_val.comp g.continuous |> Continuous.comp <| continuous_snd )

/-- The explicit normalized straight-line homotopy. -/
def normalizedStraightLineHomotopy (f g : C(X, UnitSphere E))
    (h : ∀ x, (f x : E) ≠ -(g x : E)) : ContinuousMap.Homotopy f g := by
  let q : unitInterval × X → E := straightLine f g
  let H : unitInterval × X → UnitSphere E := fun p =>
    ⟨‖q p‖⁻¹ • q p, norm_inv_smul_mem_unitSphere (q p) (straightLine_ne_zero f g h p)⟩
  refine ⟨⟨H, ?_⟩, ?_, ?_⟩
  · exact (continuous_inv_norm_smul q (continuous_straightLine f g)
      (straightLine_ne_zero f g h)).subtype_mk _
  · intro x
    apply Subtype.ext
    simp [H, q, straightLine]
  · intro x
    apply Subtype.ext
    simp [H, q, straightLine]

/-
**Never-antipodal threshold lemma.** Continuous sphere-valued maps which are
pointwise never antipodal are homotopic, via normalized straight-line interpolation.
The construction includes the proof that its denominator never vanishes and that the
resulting map is continuous.
-/
theorem homotopic_of_ne_neg (f g : C(X, UnitSphere E))
    (h : ∀ x, (f x : E) ≠ -(g x : E)) :
    Nonempty (ContinuousMap.Homotopy f g) := by
  exact ⟨normalizedStraightLineHomotopy f g h⟩

/-
Distance strictly below the explicit threshold `2` rules out antipodal values.
-/
theorem ne_neg_of_dist_lt_two (a b : UnitSphere E) (h : dist a b < 2) :
    (a : E) ≠ -(b : E) := by
  contrapose! h;
  simp +decide [ Subtype.dist_eq, h ];
  norm_num [ dist_eq_norm', ← two_smul ℝ, norm_smul ]

/-
**Sup-norm threshold form.** A pointwise (hence also uniform) sphere-metric
perturbation strictly smaller than `2` preserves the homotopy class.
-/
theorem homotopic_of_forall_dist_lt_two (f g : C(X, UnitSphere E))
    (h : ∀ x, dist (f x) (g x) < 2) :
    Nonempty (ContinuousMap.Homotopy f g) := by
  refine' homotopic_of_ne_neg f g fun x => ne_neg_of_dist_lt_two _ _ ( h x )

/-
A concrete antipodal pair on the two-sphere is everywhere at distance exactly `2`.
Classically, these maps are not homotopic: the identity of `S²` has degree `1`, while
its antipodal map has degree `-1`.  We deliberately do not formalize degree theory here.
(The analogous suggested examples on `S¹` or `S³` would be wrong: in odd dimension the
antipodal map has degree `+1` and is homotopic to the identity.)
-/
theorem twoSphere_antipodal_distance_exactly_two
    (x : UnitSphere (Fin 3 → ℝ)) : dist x (-x) = 2 := by
  convert dist_eq_norm (x : Fin 3 → ℝ) (-x : Fin 3 → ℝ) using 1
  all_goals norm_num [dist_eq_norm, ← two_smul ℝ, norm_smul]

/-- The identity map of `S²`, used to exhibit sharpness of the constant `2`. -/
def twoSphereIdentity : C(UnitSphere (Fin 3 → ℝ), UnitSphere (Fin 3 → ℝ)) :=
  ContinuousMap.id _

/-- The antipodal map of `S²`, used to exhibit sharpness of the constant `2`. -/
def twoSphereAntipodal : C(UnitSphere (Fin 3 → ℝ), UnitSphere (Fin 3 → ℝ)) where
  toFun x := -x
  continuous_toFun := continuous_neg

/-- The exhibited identity/antipodal pair is uniformly at the boundary value `2`. -/
theorem twoSphere_sharp_pair_distance :
    ∀ x, dist (twoSphereIdentity x) (twoSphereAntipodal x) = 2 := by
  intro x
  exact twoSphere_antipodal_distance_exactly_two x

/-
Uniform convergence, stated directly in the sphere metric.  Every sufficiently late
continuous map lies in the same homotopy class as the limit.
-/
theorem eventually_homotopic_of_uniformly_tendsto
    (f : C(X, UnitSphere E)) (fseq : ℕ → C(X, UnitSphere E))
    (hu : ∀ ε : ℝ, 0 < ε → ∀ᶠ n in atTop, ∀ x, dist (fseq n x) (f x) < ε) :
    ∀ᶠ n in atTop, Nonempty (ContinuousMap.Homotopy (fseq n) f) := by
  obtain ⟨N, hN⟩ : ∃ N, ∀ n ≥ N, ∀ x : X, dist (fseq n x) (f x) < 2 := by
    exact Filter.eventually_atTop.mp ( hu 2 zero_lt_two );
  filter_upwards [ Filter.Ici_mem_atTop N ] with n hn using homotopic_of_forall_dist_lt_two _ _ ( hN n hn )

/-
Application-shaped corollary: every quantity which is constant on homotopy classes
is unchanged by a sphere-metric perturbation of uniform size strictly below `2`.
This is only an elementary homotopy statement; it makes no claim that any particular
physical perturbation satisfies the threshold.
-/
theorem invariant_eq_of_uniform_dist_lt_two
    {A : Type w} (invariant : C(X, UnitSphere E) → A)
    (hinv : ∀ a b, Nonempty (ContinuousMap.Homotopy a b) → invariant a = invariant b)
    (f g : C(X, UnitSphere E)) (h : ∀ x, dist (f x) (g x) < 2) :
    invariant f = invariant g := by
  exact hinv f g ( homotopic_of_forall_dist_lt_two f g h )

#print axioms straightLine_ne_zero_iff
#print axioms normalizedStraightLineHomotopy
#print axioms homotopic_of_ne_neg
#print axioms homotopic_of_forall_dist_lt_two
#print axioms twoSphere_sharp_pair_distance
#print axioms eventually_homotopic_of_uniformly_tendsto
#print axioms invariant_eq_of_uniform_dist_lt_two

end NeverAntipodal
