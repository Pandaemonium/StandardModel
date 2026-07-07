import Mathlib
import PhysicsSM.Draft.NullEdge.QMF.ProductHaarConfig

/-!
# QMF1-RP: reflection positivity of the product-Haar form for the finite abelian
gauge group `Z2` (Peter-Weyl-free)

This module gives an explicit, computational *finite abelian* instance of the
bare product-Haar reflection positivity proved generally in `QMF/ProductHaarConfig`
(`reflForm_self_nonneg` - for the bare product measure, established there by the
disjoint-block factorization `prod_diag_refl_nonneg`, with NO Peter-Weyl input;
reflection positivity of the *interacting* Wilson measure remains the pending
rung). Here the general product-Haar expectation collapses to a finite sum, and
the reflection form is exhibited concretely as an honest sum of squares. The
gauge group is `Z2 = Multiplicative (ZMod 2)`, for which:

* the (bi-invariant, inversion-invariant) Haar measure is the **normalized
  counting measure** `MeasureTheory.Measure.count` (a Haar measure on any finite
  group — left-invariant, open-positive, finite on compacts);
* `Measure.pi (fun _ => count) = count` on the finite configuration space, so the
  product-Haar expectation collapses to a **finite sum** over configurations
  (`integral_count`);
* every element of `Z2` is its own inverse, so the link reflection `theta` is
  pure edge reindexing;
* Peter-Weyl / character orthogonality reduces to the elementary observation that
  an observable supported on one side of a genuine cut and its reflection depend
  on **disjoint** coordinate blocks with *identical* Haar factors, so the
  reflection form is an honest **square** `(∑ f)² ≥ 0`.

## What is proved (`s o r r y`-free)

* `ProductHaarZ2RP.pi_count_eq` — `Measure.pi (fun _ => count) = count` on the
  finite configuration space.
* `ProductHaarZ2RP.reflForm_count_eq_sum` — the product-Haar reflection form is
  the finite configuration sum `∑ x, F (theta refl x) * G x`.
* `ProductHaarZ2RP.productHaarZ2_reflForm_self_nonneg_oneLink` — reflection
  positivity `0 ≤ reflForm count refl F F` on the single-link lattice `ι = Fin 1`
  (the cut condition forces the positive side to be empty, hence `F` constant).
* `ProductHaarZ2RP.productHaarZ2_reflForm_self_nonneg_twoLink` — reflection
  positivity `0 ≤ reflForm count (swap 0 1) F F` on the two-link lattice
  `ι = Fin 2` with the genuine cut `posEdges = {0}`, exhibited as `(∑ f)² ≥ 0`.

## Scope / honest claim label

**Reflection positivity of the product-Haar form for the finite abelian gauge
group `Z2` (Peter-Weyl-free).** This is a concrete, computational ABELIAN instance
of the general bare product-Haar positivity `ProductHaarConfig.reflForm_self_nonneg`
(here the expectation is a finite sum and the form is an explicit `(∑ f)²`); it is
NOT reflection positivity of the interacting theory, which remains pending. All
definitions (`reflForm`,
`productHaar`, `theta`, `SupportedOn`, `Config`) are reused from
`QMF/ProductHaarConfig`. Draft-trust; no new `a x i o m`, no `n a t i v e _
d e c i d e`, no statement weakening.
-/

namespace PhysicsSM.Draft.NullEdge.QMF.ProductHaarZ2RP

open MeasureTheory
open PhysicsSM.Draft.NullEdge.QMF.ProductHaarConfig

/-! ## The finite abelian gauge group `Z2` and its counting Haar measure -/

/-- The finite abelian gauge group `Z2 = Multiplicative (ZMod 2)`. Every element
is its own inverse (`z2_inv`), matching the ℤ₂ convention of
`GateYM/Z2GaugeCore` (`Bool`/`xor`, self-inverse links). -/
abbrev Z2 := Multiplicative (ZMod 2)

instance : TopologicalSpace Z2 := ⊥
instance : DiscreteTopology Z2 := ⟨rfl⟩
instance : MeasurableSpace Z2 := borel Z2
instance : BorelSpace Z2 := ⟨rfl⟩

/-- Counting measure is **open-positive** on `Z2`: a nonempty (open) set has
nonzero count. Together with left-invariance and finiteness (both automatic on a
finite group), this makes `count` a Haar measure. -/
instance z2count_isOpenPosMeasure : (Measure.count : Measure Z2).IsOpenPosMeasure :=
  ⟨fun _ _ hne => Measure.count_ne_zero hne⟩

/-- **Counting measure is a Haar measure on `Z2`** (finite abelian group): it is
left-invariant, open-positive, and finite on compacts. This is the elementary
finite-group replacement for the general compact-Haar existence input. -/
instance z2count_isHaarMeasure : (Measure.count : Measure Z2).IsHaarMeasure :=
  Measure.IsHaarMeasure.mk

/-- Every element of `Z2` is its own inverse (`Z2` is 2-torsion). -/
lemma z2_inv (a : Z2) : a⁻¹ = a := by revert a; decide

/-! ## Product counting measure and the finite-sum form of `reflForm` -/

/-- **The product Haar (counting) measure is the counting measure** on the finite
configuration space `Config ι Z2 = ι → Z2`: `Measure.pi (fun _ => count) = count`.
Proved by matching values on product sets (`Measure.pi_eq`) via
`Set.encard_pi_eq_prod_encard`. This is the finite-abelian instance of "Haar =
normalized counting measure". -/
lemma pi_count_eq {ι : Type*} [Fintype ι] :
    (Measure.pi (fun _ : ι => (Measure.count : Measure Z2)))
      = (Measure.count : Measure (Config ι Z2)) := by
  have key : ∀ (s : ι → Set Z2), (∀ i, MeasurableSet (s i)) →
      (Measure.count : Measure (Config ι Z2)) (Set.univ.pi s)
        = ∏ i, (Measure.count : Measure Z2) (s i) := by
    intro s hs
    rw [Measure.count_apply (MeasurableSet.univ_pi hs)]
    simp_rw [Measure.count_apply (hs _)]
    rw [Set.encard_pi_eq_prod_encard]
    exact map_prod ENat.toENNRealRingHom (fun i => (s i).encard) Finset.univ
  exact Measure.pi_eq key

/-- **The product-Haar reflection form is a finite configuration sum.** For the
counting Haar measure the product-Haar expectation collapses to a sum over
configurations (`integral_count`), so
`reflForm count refl F G = ∑ x, F (theta refl x) * G x`. -/
lemma reflForm_count_eq_sum {ι : Type*} [Fintype ι] [DecidableEq ι] (refl : ι ≃ ι)
    (F G : Config ι Z2 → ℝ) :
    reflForm (Measure.count) refl F G
      = ∑ x : Config ι Z2, F (theta refl x) * G x := by
  unfold reflForm productHaar
  rw [pi_count_eq]
  exact integral_count _

/-! ## Reflection positivity: the single-link (`Fin 1`) lattice -/

/-- **Reflection positivity of the product-Haar `Z2` form on the single-link
lattice `ι = Fin 1`.** This is the concrete `G = Z2`, `ι = Fin 1` shadow of the
general bare product-Haar theorem `ProductHaarConfig.reflForm_self_nonneg`. On
`Fin 1` the edge reflection is the identity, so the cut condition `hcut` forces
the positive side `posEdges` to be empty; hence `F` is constant and the form is a
nonnegative sum of squares. Peter-Weyl-free. -/
theorem productHaarZ2_reflForm_self_nonneg_oneLink (refl : Fin 1 ≃ Fin 1)
    (_hrefl : Function.Involutive refl) (posEdges : Set (Fin 1))
    (hcut : ∀ e ∈ posEdges, refl e ∉ posEdges)
    (F : Config (Fin 1) Z2 → ℝ) (hF : SupportedOn posEdges F) :
    0 ≤ reflForm (Measure.count) refl F F := by
  rw [reflForm_count_eq_sum]
  -- the cut condition forces `posEdges = ∅` since `refl = id` on `Fin 1`
  have hempty : posEdges = ∅ := by
    ext e
    simp only [Set.mem_empty_iff_false, iff_false]
    intro he
    have hr : refl e = e := Subsingleton.elim _ _
    exact (hr ▸ hcut e he) he
  -- hence `F` is constant
  have hconst : ∀ x y : Config (Fin 1) Z2, F x = F y := by
    intro x y; apply hF; rw [hempty]; intro e he; exact absurd he (by simp)
  rw [Finset.sum_congr rfl
    (fun x _ => by rw [hconst (theta refl x) x] :
      ∀ x ∈ Finset.univ, F (theta refl x) * F x = F x * F x)]
  exact Finset.sum_nonneg (fun x _ => mul_self_nonneg _)

/-! ## Reflection positivity: the two-link (`Fin 2`) lattice -/

/-- Value of a `{0}`-supported observable is a function of the link at edge `0`. -/
private lemma twoLink_val {F : Config (Fin 2) Z2 → ℝ}
    (hF : SupportedOn ({0} : Set (Fin 2)) F) (x : Config (Fin 2) Z2) :
    F x = F (fun _ => x 0) := by
  apply hF; intro e he
  simp only [Set.mem_singleton_iff] at he; subst he; rfl

/-- The `Fin 2` two-link folding identity: for `f : Z2 → ℝ`,
`∑ x, f (x 1) * f (x 0) = (∑ a, f a) * (∑ a, f a)`. This is the finite-abelian
character-free "reflection folds the two independent sides onto each other",
exhibiting the reflection form as a square. -/
lemma fin2_sum_sq (f : Z2 → ℝ) :
    ∑ x : Config (Fin 2) Z2, f (x 1) * f (x 0)
      = (∑ a : Z2, f a) * (∑ a : Z2, f a) := by
  rw [← Equiv.sum_comp (piFinTwoEquiv (fun _ => Z2)).symm (fun x => f (x 1) * f (x 0))]
  simp only [piFinTwoEquiv_symm_apply]
  rw [Fintype.sum_prod_type, Finset.sum_mul_sum, Finset.sum_comm]
  simp

/-- **Reflection positivity of the product-Haar `Z2` form on the two-link lattice
`ι = Fin 2`** with the genuine cut `posEdges = {0}` and edge reflection the swap
`(0 1)`. This is the concrete `G = Z2`, `ι = Fin 2` shadow of the general bare
product-Haar theorem `ProductHaarConfig.reflForm_self_nonneg`. Since every `Z2`
element is self-inverse, `theta` is the
edge swap, so `F ∘ theta` depends only on link `1` while `F` depends only on link
`0`; the two independent factors are identical counting measures, so the form
equals `(∑_{a : Z2} f a)² ≥ 0`. Peter-Weyl-free. -/
theorem productHaarZ2_reflForm_self_nonneg_twoLink
    (F : Config (Fin 2) Z2 → ℝ) (hF : SupportedOn ({0} : Set (Fin 2)) F) :
    0 ≤ reflForm (Measure.count) (Equiv.swap 0 1) F F := by
  rw [reflForm_count_eq_sum]
  set f : Z2 → ℝ := fun a => F (fun _ => a) with hf
  have hFval : ∀ x : Config (Fin 2) Z2, F x = f (x 0) := fun x => twoLink_val hF x
  have hFtheta : ∀ x : Config (Fin 2) Z2, F (theta (Equiv.swap 0 1) x) = f (x 1) := by
    intro x; rw [hFval]; congr 1
    show (x (Equiv.swap 0 1 0))⁻¹ = x 1
    rw [Equiv.swap_apply_left, z2_inv]
  have hsum : ∑ x : Config (Fin 2) Z2, F (theta (Equiv.swap 0 1) x) * F x
      = ∑ x : Config (Fin 2) Z2, f (x 1) * f (x 0) := by
    apply Finset.sum_congr rfl; intro x _; rw [hFtheta, hFval]
  rw [hsum, fin2_sum_sq]
  exact mul_self_nonneg _

end PhysicsSM.Draft.NullEdge.QMF.ProductHaarZ2RP
