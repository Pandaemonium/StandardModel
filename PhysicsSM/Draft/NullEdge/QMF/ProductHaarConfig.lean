import Mathlib
import PhysicsSM.Draft.NullEdge.QMF.SpecialUnitaryCompact
import PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance
import PhysicsSM.Draft.NullEdge.QMF.GaugeHaarInvariance

/-!
# QMF1-RP: multi-link product-Haar gauge/reflection substrate

The audited "pending next rung" of the QMF1-RP compact-Haar programme: lift the
SINGLE-link gauge/reflection Haar invariances of `QMF/CompactHaarInvariance` and
`QMF/GaugeHaarInvariance` from one copy of the gauge group to a MULTI-link
product-Haar configuration space over a finite edge set.

Over a finite edge set `ι` (`[Fintype ι]`) the gauge-field configuration space is
`Config ι G := ι → G` (`= ∏_e G`), with `G` a compact topological group - the
physical case being `G = SU(N) = Matrix.specialUnitaryGroup (Fin n) ℂ`, whose
compactness / topological-group structure is `QMF/SpecialUnitaryCompact` and
whose single-link bi-invariant Haar measure exists by
`GaugeHaarInvariance.specialUnitaryGroup_exists_isHaarMeasure`.

## What is proved (`s o r r y`-free)

1. **Product Haar measure** `productHaar μ := Measure.pi (fun _ : ι => μ)` on
   `Config ι G`. It is again a Haar measure (`pi.isHaarMeasure`), finite, and the
   configuration space is compact - reusing the single-link Haar `μ` and
   Mathlib's `Measure.pi` product machinery (`isCompact_univ_pi`, `Pi.compactSpace`).

2. **Per-link and endpoint gauge invariance** of the product-Haar expectation.
   From per-factor measure-preservation (the single-link content -
   bi-invariance of compact Haar, `compactGroup_haar_isMulRightInvariant`) and
   `measurePreserving_pi` (the product-measure Fubini fact), the integral of any
   observable over `Config` is unchanged by:
   * the lattice gauge action `U_e ↦ a_e * U_e * b_e⁻¹` at the two endpoints
     (`productHaar_endpoint_gauge_invariant`);
   * conjugation `U_{e₀} ↦ g * U_{e₀} * g⁻¹` on a single link `e₀`
     (`productHaar_link_conj_invariant`).

3. **The link-reflection involution** `theta refl : Config → Config`,
   `theta refl x e = (x (refl e))⁻¹`, for an involutive edge reflection `refl`.
   It is an involution (`theta_involutive`) and measure-preserving for
   `productHaar` (`theta_measurePreserving`), so the product-Haar expectation is
   reflection-invariant (`productHaar_reflection_invariant`) - reusing the
   single-link inversion invariance (`compactGroup_haar_isInvInvariant`) and
   permutation-invariance of a product of identical Haar factors.

4. **The RP bilinear form and free-ensemble positivity.** The reflection
   (OS) form `reflForm μ refl F G = ∫ (F ∘ theta) * G` on the configuration space,
   and its diagonal nonnegativity `0 ≤ reflForm μ refl F F` for observables `F`
   supported on the positive side of a genuine cut (`reflForm_self_nonneg`). This
   is proved for the BARE product-Haar measure (no interaction / Boltzmann
   weight): `F` and `F ∘ theta` then depend on disjoint blocks of links, so the
   form factorizes into a nonnegative constant times a square
   (`prod_diag_refl_nonneg`), using NO Peter-Weyl / character orthogonality.

## What is the pending rung (NOT done here)

Reflection positivity of the physical **interacting** ensemble - the Wilson
Boltzmann weight `e^{-S}` coupling the two sides of the cut, under which the
measure no longer factorizes - is NOT established here. That is where the Wilson-
slab / character-expansion (Peter-Weyl) argument is required, and it is out of
scope for this substrate.

## Scope / honest claim label

This is a **multi-link product-Haar gauge/reflection substrate**: the link
symmetries (gauge invariance at each link / endpoint, reflection invariance) that
Osterwalder-Seiler reflection positivity consumes, on the finite-lattice product
configuration space, together with **free-ensemble (bare product-Haar) reflection
positivity**. **Interacting-measure RP positivity is the pending rung.** This is a
LINK-symmetry / OS-ingredient result plus the free-ensemble RP bound, NOT
reflection positivity of the interacting theory, and NOT a transfer operator.
Peter-Weyl / character orthogonality is nowhere assumed. Draft-trust.
Prerequisites: `QMF/SpecialUnitaryCompact`, `QMF/CompactHaarInvariance`,
`QMF/GaugeHaarInvariance`, Mathlib.
-/

namespace PhysicsSM.Draft.NullEdge.QMF.ProductHaarConfig

open MeasureTheory MeasureTheory.Measure
open PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance

/-! ## Abstract disjoint-block independence positivity

A self-contained probabilistic fact used to close the reflection-positivity of
the BARE product measure (no interaction/Boltzmann weight): on a finite product
of finite nonzero measures, if a "positive-side" observable `P` depends only on
the coordinates in the block `p` and a "reflected" observable `Q` depends only on
the complementary block `¬p`, then the two are independent, so the diagonal form
`∫ Q·P` factorizes as `(∫P/·)(∫Q/·)`; using `∫P = ∫Q` it becomes a nonnegative
constant times a square, hence `0 ≤ ∫ Q·P`. This is the elementary product-measure
content - it does NOT use Peter-Weyl and does NOT involve any lattice action. -/

/-- **Product-measure factorization across a coordinate cut.** For the product
measure `Measure.pi ν`, integrating `f` of the `p`-coordinates times `g` of the
complementary `¬p`-coordinates factors as the product of the two block integrals
(Fubini on the `piEquivPiSubtypeProd` splitting). -/
theorem integral_pi_split_mul {ι : Type*} [Fintype ι] {α : ι → Type*}
    [∀ i, MeasurableSpace (α i)] (ν : ∀ i, Measure (α i)) [∀ i, SigmaFinite (ν i)]
    (p : ι → Prop) [DecidablePred p]
    (f : (∀ i : {i // p i}, α i) → ℝ) (g : (∀ i : {i // ¬ p i}, α i) → ℝ) :
    ∫ x, f (fun i => x i) * g (fun i => x i) ∂(Measure.pi ν)
      = (∫ u, f u ∂(Measure.pi (fun i : {i // p i} => ν i)))
        * (∫ v, g v ∂(Measure.pi (fun i : {i // ¬ p i} => ν i))) := by
  rw [ ← MeasureTheory.integral_prod_mul ];
  rw [ ← MeasureTheory.measurePreserving_piEquivPiSubtypeProd ( ν ) p |> MeasureTheory.MeasurePreserving.integral_comp' ];
  congr! 2

/-- **Block-dependence factoring (positive side).** An observable depending only
on the `p`-coordinates factors through the `p`-block projection. -/
theorem exists_leftFactor {ι : Type*} {α : ι → Type*} [∀ i, Nonempty (α i)]
    (p : ι → Prop) (P : (∀ i, α i) → ℝ)
    (hP : ∀ x y : ∀ i, α i, (∀ i, p i → x i = y i) → P x = P y) :
    ∃ f : (∀ i : {i // p i}, α i) → ℝ, ∀ x, P x = f (fun i => x i) := by
  classical
  use fun u => P (fun i => if h : p i then u ⟨i, h⟩ else Classical.arbitrary (α i))
  grind

/-- **Block-dependence factoring (reflected side).** An observable depending only
on the `¬p`-coordinates factors through the `¬p`-block projection. -/
theorem exists_rightFactor {ι : Type*} {α : ι → Type*} [∀ i, Nonempty (α i)]
    (p : ι → Prop) (Q : (∀ i, α i) → ℝ)
    (hQ : ∀ x y : ∀ i, α i, (∀ i, ¬ p i → x i = y i) → Q x = Q y) :
    ∃ g : (∀ i : {i // ¬ p i}, α i) → ℝ, ∀ x, Q x = g (fun i => x i) := by
  classical
  use fun v => Q (fun i => if hi : ¬ p i then v ⟨i, hi⟩ else Classical.arbitrary (α i))
  grind

/-- **Total mass of a finite product measure is positive.** -/
theorem pi_univ_toReal_pos {J : Type*} [Fintype J] {β : J → Type*}
    [∀ j, MeasurableSpace (β j)] (κ : ∀ j, Measure (β j)) [∀ j, IsFiniteMeasure (κ j)]
    (hκ : ∀ j, κ j Set.univ ≠ 0) : 0 < ((Measure.pi κ) Set.univ).toReal := by
  simp +decide [ MeasureTheory.Measure.pi_univ ];
  exact Finset.prod_pos fun j _ => ENNReal.toReal_pos ( hκ j ) ( MeasureTheory.measure_ne_top _ _ )

theorem prod_diag_refl_nonneg {ι : Type*} [Fintype ι] {α : ι → Type*}
    [∀ i, MeasurableSpace (α i)] [∀ i, Nonempty (α i)]
    (ν : ∀ i, Measure (α i)) [∀ i, IsFiniteMeasure (ν i)]
    (hν : ∀ i, ν i Set.univ ≠ 0)
    (p : ι → Prop)
    (P Q : (∀ i, α i) → ℝ)
    (hP : ∀ x y : ∀ i, α i, (∀ i, p i → x i = y i) → P x = P y)
    (hQ : ∀ x y : ∀ i, α i, (∀ i, ¬ p i → x i = y i) → Q x = Q y)
    (hPQ : ∫ x, P x ∂(Measure.pi ν) = ∫ x, Q x ∂(Measure.pi ν)) :
    0 ≤ ∫ x, Q x * P x ∂(Measure.pi ν) := by
  classical
  obtain ⟨f, hf⟩ := exists_leftFactor p P hP
  obtain ⟨g, hg⟩ := exists_rightFactor p Q hQ
  -- abbreviations for the two block integrals and the two block masses
  set cf : ℝ := ∫ u, f u ∂(Measure.pi (fun i : {i // p i} => ν i)) with hcf
  set cg : ℝ := ∫ v, g v ∂(Measure.pi (fun i : {i // ¬ p i} => ν i)) with hcg
  set a : ℝ := ∫ _x, (1 : ℝ) ∂(Measure.pi (fun i : {i // ¬ p i} => ν i)) with ha'
  set b : ℝ := ∫ _x, (1 : ℝ) ∂(Measure.pi (fun i : {i // p i} => ν i)) with hb'
  -- the diagonal form factorizes
  have key : ∫ x, Q x * P x ∂(Measure.pi ν) = cf * cg := by
    have hcongr : ∫ x, Q x * P x ∂(Measure.pi ν)
        = ∫ x, f (fun i => x i) * g (fun i => x i) ∂(Measure.pi ν) := by
      refine integral_congr_ae (Filter.Eventually.of_forall (fun x => ?_))
      simp only [hf, hg]; ring
    rw [hcongr]; exact integral_pi_split_mul ν p f g
  -- marginal of P
  have hP_int : ∫ x, P x ∂(Measure.pi ν) = cf * a := by
    have hrw : ∫ x, P x ∂(Measure.pi ν)
        = ∫ x, f (fun i => x i) * (fun _ => (1 : ℝ)) (fun i => x i)
            ∂(Measure.pi ν) := by
      refine integral_congr_ae (Filter.Eventually.of_forall (fun x => ?_))
      simp only [hf, mul_one]
    rw [hrw]; exact integral_pi_split_mul ν p f (fun _ => (1 : ℝ))
  -- marginal of Q
  have hQ_int : ∫ x, Q x ∂(Measure.pi ν) = b * cg := by
    have hrw : ∫ x, Q x ∂(Measure.pi ν)
        = ∫ x, (fun _ => (1 : ℝ)) (fun i => x i) * g (fun i => x i)
            ∂(Measure.pi ν) := by
      refine integral_congr_ae (Filter.Eventually.of_forall (fun x => ?_))
      simp only [hg, one_mul]
    rw [hrw]; exact integral_pi_split_mul ν p (fun _ => (1 : ℝ)) g
  -- masses are strictly positive
  have ha : 0 < a := by
    rw [ha', integral_const, smul_eq_mul, mul_one]
    exact pi_univ_toReal_pos (fun i : {i // ¬ p i} => ν i) (fun i => hν i)
  have hb : 0 < b := by
    rw [hb', integral_const, smul_eq_mul, mul_one]
    exact pi_univ_toReal_pos (fun i : {i // p i} => ν i) (fun i => hν i)
  -- combine: cf * a = b * cg
  have hIV : cf * a = b * cg := by rw [← hP_int, ← hQ_int]; exact hPQ
  rw [key]
  -- (cf*cg)*(a*b) = (cf*a)*(cf*a) ≥ 0 and a*b > 0 ⇒ 0 ≤ cf*cg
  have hab : 0 < a * b := mul_pos ha hb
  have hexpand : (cf * cg) * (a * b) = (cf * a) * (cf * a) := by
    calc (cf * cg) * (a * b) = (cf * a) * (b * cg) := by ring
      _ = (cf * a) * (cf * a) := by rw [hIV]
  nlinarith [hexpand, mul_self_nonneg (cf * a), hab]

/-! ## General compact-group section

Everything is proved for an arbitrary compact topological group `G` with a Borel
Haar measure `μ`; the `SU(N)` case is a specialization at the end. The Borel
measurable structure and `MeasurableMul`/`MeasurableInv` are taken as instance
arguments (matching the single-link `GaugeHaarInvariance` convention), since they
are not canonical global instances on the matrix subtype. -/

section General

variable {ι : Type*} [Fintype ι]
variable {G : Type*} [Group G] [TopologicalSpace G] [IsTopologicalGroup G]
  [CompactSpace G] [MeasurableSpace G] [BorelSpace G] [MeasurableMul G] [MeasurableInv G]

/-- The gauge-field **configuration space** over the edge set `ι`: one copy of the
gauge group `G` per link, `Config ι G = ι → G = ∏_e G`. An `abbrev` so the
product topological / measurable / group instances transfer automatically. -/
abbrev Config (ι : Type*) (G : Type*) := ι → G

variable (μ : Measure G) [μ.IsHaarMeasure]

/-- **Product Haar measure** on the configuration space: the `Measure.pi` product
of one single-link Haar measure `μ` per edge, `μ_E = ∏_e μ`. -/
noncomputable def productHaar : Measure (Config ι G) := Measure.pi (fun _ : ι => μ)

/-- The configuration space is **compact** - a finite product of the compact
gauge group (Tychonoff, `Pi.compactSpace`). -/
instance : CompactSpace (Config ι G) := inferInstanceAs (CompactSpace (ι → G))

/-- The **product Haar measure is again a Haar measure** on the (product) gauge
group `Config ι G`, via `Measure.pi.isHaarMeasure`. -/
instance productHaar_isHaarMeasure : (productHaar (ι := ι) μ).IsHaarMeasure :=
  inferInstanceAs (Measure.pi (fun _ : ι => μ)).IsHaarMeasure

/-- The **product Haar measure is finite** (finite product of finite compact-group
Haar measures). -/
instance productHaar_isFiniteMeasure : IsFiniteMeasure (productHaar (ι := ι) μ) :=
  inferInstanceAs (IsFiniteMeasure (Measure.pi (fun _ : ι => μ)))

/-- The product Haar measure is **left-invariant** under the pointwise gauge-group
action on the configuration space. -/
instance productHaar_isMulLeftInvariant : (productHaar (ι := ι) μ).IsMulLeftInvariant :=
  inferInstanceAs (Measure.pi (fun _ : ι => μ)).IsMulLeftInvariant

/-! ### Part 2: per-link and endpoint gauge invariance

The engine is `factorwise_integral_invariant`: if every link is transformed by a
measure-preserving self-map of the gauge group, the product-Haar expectation is
unchanged. This is the multi-link Fubini lift of the single-link statement, using
`MeasureTheory.measurePreserving_pi` on the product measure. -/

omit [IsTopologicalGroup G] [BorelSpace G] [MeasurableMul G] [MeasurableInv G] in
/-- **Factorwise measure invariance of the product-Haar expectation.** If each link
`e` is transformed by a measure-preserving measurable equivalence `ef e` of the
gauge group, then integrating any observable over `Config` is unchanged. Proved
by assembling the per-factor maps with `MeasurableEquiv.piCongrRight`, whose
measure-preservation is `measurePreserving_pi`, then `integral_comp'`. -/
theorem factorwise_integral_invariant {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (ef : ∀ _ : ι, G ≃ᵐ G) (hef : ∀ e, MeasurePreserving (ef e) μ μ)
    (obs : Config ι G → F) :
    ∫ x, obs (fun e => ef e (x e)) ∂(productHaar μ) = ∫ x, obs x ∂(productHaar μ) := by
  have hmp : MeasurePreserving (MeasurableEquiv.piCongrRight ef)
      (productHaar (ι := ι) μ) (productHaar (ι := ι) μ) :=
    measurePreserving_pi (fun _ : ι => μ) (fun _ : ι => μ) hef
  exact hmp.integral_comp' obs

omit [MeasurableInv G] in
/-- Conjugation `x ↦ g * x * g⁻¹` is **measure-preserving** for a compact-group
Haar measure: left-multiplication by `g` composed with right-multiplication by
`g⁻¹`, both measure-preserving by (compact) bi-invariance. -/
theorem conj_measurePreserving (g : G) :
    MeasurePreserving (fun x => g * x * g⁻¹) μ μ := by
  haveI := compactGroup_haar_isMulRightInvariant μ
  have h1 : MeasurePreserving (fun x : G => g * x) μ μ := measurePreserving_mul_left μ g
  have h2 : MeasurePreserving (fun x : G => x * g⁻¹) μ μ := measurePreserving_mul_right μ g⁻¹
  simpa [Function.comp] using h2.comp h1

omit [MeasurableInv G] in
/-- **Endpoint gauge invariance of the product-Haar expectation.** For the lattice
gauge action `U_e ↦ a_e * U_e * b_e⁻¹` (with `a_e = g_{s(e)}` and `b_e = g_{t(e)}`
the gauge-transformation values at the source/target endpoints of link `e`), the
integral of any observable over `Config` is unchanged. This is the finite-lattice
gauge invariance of the product-Haar ensemble; each factor map is measure
preserving by (compact) bi-invariance. -/
theorem productHaar_endpoint_gauge_invariant {F : Type*} [NormedAddCommGroup F]
    [NormedSpace ℝ F] (a b : ι → G) (obs : Config ι G → F) :
    ∫ x, obs (fun e => a e * x e * (b e)⁻¹) ∂(productHaar μ)
      = ∫ x, obs x ∂(productHaar μ) := by
  haveI := compactGroup_haar_isMulRightInvariant μ
  refine factorwise_integral_invariant μ
    (fun e => (MeasurableEquiv.mulLeft (a e)).trans (MeasurableEquiv.mulRight (b e)⁻¹))
    (fun e => ?_) obs
  exact (measurePreserving_mul_right μ (b e)⁻¹).comp (measurePreserving_mul_left μ (a e))

omit [MeasurableInv G] in
/-- **Per-link gauge (conjugation) invariance of the product-Haar expectation.**
For a gauge transformation acting on a single link `e₀` by conjugation
`U_{e₀} ↦ g * U_{e₀} * g⁻¹` (leaving all other links fixed), the integral of any
observable over `Config` is unchanged. Special case of
`productHaar_endpoint_gauge_invariant` supported on one link, or directly via
`factorwise_integral_invariant`. -/
theorem productHaar_link_conj_invariant [DecidableEq ι] {F : Type*} [NormedAddCommGroup F]
    [NormedSpace ℝ F] (e₀ : ι) (g : G) (obs : Config ι G → F) :
    ∫ x, obs (Function.update x e₀ (g * x e₀ * g⁻¹)) ∂(productHaar μ)
      = ∫ x, obs x ∂(productHaar μ) := by
  have hpt : ∀ x : Config ι G, obs (Function.update x e₀ (g * x e₀ * g⁻¹))
      = obs (fun e => (Function.update (fun _ => (1 : G)) e₀ g) e * x e
          * ((Function.update (fun _ => (1 : G)) e₀ g) e)⁻¹) := by
    intro x
    congr 1
    funext e
    by_cases h : e = e₀
    · subst h; simp
    · simp [Function.update_of_ne h]
  calc ∫ x, obs (Function.update x e₀ (g * x e₀ * g⁻¹)) ∂(productHaar μ)
      = ∫ x, obs (fun e => (Function.update (fun _ => (1 : G)) e₀ g) e * x e
          * ((Function.update (fun _ => (1 : G)) e₀ g) e)⁻¹) ∂(productHaar μ) := by
        simp_rw [hpt]
    _ = ∫ x, obs x ∂(productHaar μ) :=
        productHaar_endpoint_gauge_invariant μ _ _ obs

/-! ### Part 3: the link-reflection involution on configurations

`theta refl` implements a reflection across a cut: it maps each link `e` to the
mirror link `refl e` with link inversion `U ↦ U⁻¹` (the OS reflection acting on a
gauge link). `refl : ι ≃ ι` is the edge reflection; it is required to be an
involution for `theta` to be an involution. -/

/-- The **link-reflection map** on configurations: reflect the edge index by `refl`
and invert the link variable, `theta refl x e = (x (refl e))⁻¹`. -/
def theta (refl : ι ≃ ι) (x : Config ι G) : Config ι G := fun e => (x (refl e))⁻¹

omit [Fintype ι] [TopologicalSpace G] [IsTopologicalGroup G] [CompactSpace G]
  [MeasurableSpace G] [BorelSpace G] [MeasurableMul G] [MeasurableInv G] in
/-- `theta refl` is an **involution** when `refl` is: reflecting twice returns the
original configuration, since `refl` is an involution and inversion is an
involution. -/
theorem theta_involutive (refl : ι ≃ ι) (hrefl : Function.Involutive refl) :
    Function.Involutive (theta (G := G) refl) := by
  intro x
  funext e
  simp only [theta, inv_inv, hrefl e]

omit [IsTopologicalGroup G] [BorelSpace G] [MeasurableMul G] [MeasurableInv G] in
/-- Reindexing a product of IDENTICAL Haar factors by an edge permutation is
measure-preserving (the factors are interchangeable). -/
theorem reindex_measurePreserving (refl : ι ≃ ι) :
    MeasurePreserving (fun (x : Config ι G) e => x (refl e))
      (productHaar μ) (productHaar μ) := by
  unfold productHaar
  refine ⟨by fun_prop, ?_⟩
  refine (Measure.pi_eq (fun s hs => ?_)).symm
  rw [Measure.map_apply (by fun_prop) (MeasurableSet.univ_pi hs)]
  have hpre : (fun (x : Config ι G) e => x (refl e)) ⁻¹' (Set.univ.pi s)
      = Set.univ.pi (fun j => s (refl.symm j)) := by
    ext x
    simp only [Set.mem_preimage, Set.mem_univ_pi]
    constructor
    · intro h j; simpa using h (refl.symm j)
    · intro h e; simpa using h (refl e)
  rw [hpre, Measure.pi_pi]
  exact Fintype.prod_equiv refl.symm (fun j => μ (s (refl.symm j))) (fun i => μ (s i))
    (fun j => rfl)

omit [MeasurableMul G] in
/-- Pointwise inversion of every link is measure-preserving for `productHaar`
(single-link inversion invariance of compact Haar, lifted by `measurePreserving_pi`). -/
theorem pointwiseInv_measurePreserving :
    MeasurePreserving (fun (x : Config ι G) e => (x e)⁻¹)
      (productHaar μ) (productHaar μ) := by
  haveI := compactGroup_haar_isInvInvariant μ
  exact measurePreserving_pi (fun _ : ι => μ) (fun _ : ι => μ)
    (fun _ => measurePreserving_inv μ)

omit [MeasurableMul G] in
/-- **`theta refl` is measure-preserving** for the product Haar measure: it is the
composition of link reindexing (`reindex_measurePreserving`) and pointwise link
inversion (`pointwiseInv_measurePreserving`). -/
theorem theta_measurePreserving (refl : ι ≃ ι) :
    MeasurePreserving (theta (G := G) refl) (productHaar μ) (productHaar μ) := by
  have h := (pointwiseInv_measurePreserving μ).comp (reindex_measurePreserving μ refl)
  exact h

/-- The **link-reflection measurable equivalence** on configurations, packaging
`theta refl` (which is an involution when `refl` is) together with its
measurability. Built with `refl.symm` on the inverse branch so it is an `Equiv`
for any `refl`. -/
def thetaEquiv (refl : ι ≃ ι) : Config ι G ≃ᵐ Config ι G where
  toFun := theta refl
  invFun := fun y j => (y (refl.symm j))⁻¹
  left_inv := by
    intro x; funext j; simp only [theta, inv_inv, Equiv.apply_symm_apply]
  right_inv := by
    intro y; funext j; simp only [theta, inv_inv, Equiv.symm_apply_apply]
  measurable_toFun := by
    show Measurable (fun (x : Config ι G) e => (x (refl e))⁻¹); fun_prop
  measurable_invFun := by
    show Measurable (fun (y : Config ι G) j => (y (refl.symm j))⁻¹); fun_prop

omit [MeasurableMul G] in
/-- **Reflection invariance of the product-Haar expectation.** The integral of any
observable over `Config` is unchanged under the link-reflection `theta refl` -
the multi-link Osterwalder-Seiler reflection symmetry, obtained from
`theta_measurePreserving`. -/
theorem productHaar_reflection_invariant {F : Type*} [NormedAddCommGroup F]
    [NormedSpace ℝ F] (refl : ι ≃ ι) (obs : Config ι G → F) :
    ∫ x, obs (theta refl x) ∂(productHaar μ) = ∫ x, obs x ∂(productHaar μ) := by
  have hmp : MeasurePreserving (thetaEquiv (G := G) refl)
      (productHaar μ) (productHaar μ) := theta_measurePreserving μ refl
  exact hmp.integral_comp' obs

/-! ### Part 4: the RP bilinear form and free-ensemble positivity

The reflection (Osterwalder-Schrader) bilinear form on real observables, and its
nonnegativity on the diagonal for the BARE product-Haar ensemble (no interaction /
Boltzmann weight). For the bare product measure the positivity is elementary and
is PROVED here (`reflForm_self_nonneg`) directly from the product structure -
via the disjoint-block factorization `prod_diag_refl_nonneg` - with NO Peter-Weyl /
character-orthogonality input. What remains the genuine pending rung is reflection
positivity for the INTERACTING measure (the Wilson Boltzmann weight `e^{-S}`
coupling the two sides of the cut); that is NOT addressed here and is where the
Wilson-slab / character-expansion argument is needed. -/

/-- An observable `F` is **supported on the edge set `S`** (the positive side of a
cut) if it depends only on the links in `S`: configurations agreeing on `S` give
the same value. -/
def SupportedOn (S : Set ι) (F : Config ι G → ℝ) : Prop :=
  ∀ x y : Config ι G, (∀ e ∈ S, x e = y e) → F x = F y

/-- **The reflection (OS) bilinear form** on real observables:
`⟨F, G⟩ = ∫_Config (F ∘ theta) · G d(productHaar)`, i.e. the product-Haar
expectation of `(θ⋆F) · G`, where `θ = theta refl` is the link reflection. This
is the doubled-configuration reflection form whose positivity is reflection
positivity. -/
noncomputable def reflForm (refl : ι ≃ ι) (F G : Config ι G → ℝ) : ℝ :=
  ∫ x, F (theta refl x) * G x ∂(productHaar μ)

omit [MeasurableMul G] in
/-- **Osterwalder-Seiler reflection positivity of the BARE product-Haar ensemble.**
The reflection form is nonnegative on the diagonal for observables supported on
the positive side of the cut, `0 ≤ ⟨F, F⟩`, when the edge reflection `refl` maps
the positive side `posEdges` off itself (`hcut`, a genuine cut).

This is PROVED - but only for the bare product-Haar measure, where there is no
interaction coupling the two sides: `F` depends on the `posEdges`-links and
`F ∘ theta` on the disjoint mirror links `refl '' posEdges ⊆ posEdgesᶜ`, so the two
are independent and the form factorizes into a nonnegative constant times a square
(`prod_diag_refl_nonneg`). No Peter-Weyl / character orthogonality is used.

This is NOT reflection positivity of the physical interacting theory: with the
Wilson Boltzmann weight `e^{-S}` the measure no longer factorizes across the cut,
and establishing RP there is the genuine pending rung (the Wilson-slab /
character-expansion argument, out of scope here). The multi-link gauge/reflection
*symmetries* an interacting RP proof will additionally consume
(`productHaar_endpoint_gauge_invariant`, `productHaar_link_conj_invariant`,
`productHaar_reflection_invariant`) are proved above.

The involutivity of `refl` is not needed for this bound - only the cut condition
`hcut` - so it is not assumed; `theta_involutive` records involutivity separately. -/
theorem reflForm_self_nonneg (refl : ι ≃ ι)
    (posEdges : Set ι) (hcut : ∀ e ∈ posEdges, refl e ∉ posEdges)
    (F : Config ι G → ℝ) (hF : SupportedOn posEdges F) :
    0 ≤ reflForm μ refl F F := by
  classical
  haveI : Nonempty G := ⟨1⟩
  have hQ : ∀ x y : Config ι G, (∀ i, ¬ (i ∈ posEdges) → x i = y i) →
      F (theta refl x) = F (theta refl y) := by
    intro x y h
    refine hF _ _ ?_
    intro e he
    have hxy : x (refl e) = y (refl e) := h (refl e) (hcut e he)
    simp only [theta, hxy]
  have hPQ : ∫ x, F x ∂(Measure.pi (fun _ : ι => μ))
      = ∫ x, F (theta refl x) ∂(Measure.pi (fun _ : ι => μ)) :=
    (productHaar_reflection_invariant μ refl F).symm
  have hmain := prod_diag_refl_nonneg (fun _ : ι => μ)
    (fun _ => by simp only [ne_eq, measure_univ_eq_zero]; exact NeZero.ne μ)
    (· ∈ posEdges) F (fun x => F (theta refl x)) hF hQ hPQ
  simpa only [reflForm, productHaar] using hmain

end General

/-! ## Specialization to the physical gauge group `SU(N)`

The multi-link product-Haar substrate at `G = SU(N) = Matrix.specialUnitaryGroup
(Fin n) ℂ`, whose compactness and topological-group structure come from
`QMF/SpecialUnitaryCompact`. As in `GaugeHaarInvariance`, the Borel measurable
structure and `MeasurableMul`/`MeasurableInv` are instance arguments, so the
results hold for any Borel Haar measure on `SU(N)`; existence is
`GaugeHaarInvariance.specialUnitaryGroup_exists_isHaarMeasure`. -/

section SpecialUnitary

open PhysicsSM.Draft.NullEdge.QMF.SpecialUnitaryCompact

variable {ι : Type*} [Fintype ι] {n : ℕ}
  [MeasurableSpace (Matrix.specialUnitaryGroup (Fin n) ℂ)]
  [BorelSpace (Matrix.specialUnitaryGroup (Fin n) ℂ)]
  [MeasurableMul (Matrix.specialUnitaryGroup (Fin n) ℂ)]
  [MeasurableInv (Matrix.specialUnitaryGroup (Fin n) ℂ)]
  (μ : Measure (Matrix.specialUnitaryGroup (Fin n) ℂ)) [μ.IsHaarMeasure]

omit [MeasurableInv (Matrix.specialUnitaryGroup (Fin n) ℂ)] in
/-- **Endpoint gauge invariance** of the `SU(N)` multi-link product-Haar
expectation: instance of `productHaar_endpoint_gauge_invariant` at the physical
gauge group. -/
theorem su_productHaar_endpoint_gauge_invariant {F : Type*} [NormedAddCommGroup F]
    [NormedSpace ℝ F] (a b : ι → Matrix.specialUnitaryGroup (Fin n) ℂ)
    (obs : Config ι (Matrix.specialUnitaryGroup (Fin n) ℂ) → F) :
    ∫ x, obs (fun e => a e * x e * (b e)⁻¹) ∂(productHaar μ)
      = ∫ x, obs x ∂(productHaar μ) :=
  productHaar_endpoint_gauge_invariant μ a b obs

omit [MeasurableInv (Matrix.specialUnitaryGroup (Fin n) ℂ)] in
/-- **Per-link conjugation gauge invariance** of the `SU(N)` multi-link
product-Haar expectation. -/
theorem su_productHaar_link_conj_invariant [DecidableEq ι] {F : Type*} [NormedAddCommGroup F]
    [NormedSpace ℝ F] (e₀ : ι) (g : Matrix.specialUnitaryGroup (Fin n) ℂ)
    (obs : Config ι (Matrix.specialUnitaryGroup (Fin n) ℂ) → F) :
    ∫ x, obs (Function.update x e₀ (g * x e₀ * g⁻¹)) ∂(productHaar μ)
      = ∫ x, obs x ∂(productHaar μ) :=
  productHaar_link_conj_invariant μ e₀ g obs

omit [MeasurableMul (Matrix.specialUnitaryGroup (Fin n) ℂ)] in
/-- **Reflection invariance** of the `SU(N)` multi-link product-Haar expectation. -/
theorem su_productHaar_reflection_invariant {F : Type*} [NormedAddCommGroup F]
    [NormedSpace ℝ F] (refl : ι ≃ ι)
    (obs : Config ι (Matrix.specialUnitaryGroup (Fin n) ℂ) → F) :
    ∫ x, obs (theta refl x) ∂(productHaar μ) = ∫ x, obs x ∂(productHaar μ) :=
  productHaar_reflection_invariant μ refl obs

omit [MeasurableMul (Matrix.specialUnitaryGroup (Fin n) ℂ)] in
/-- **Free-ensemble reflection positivity** of the `SU(N)` multi-link product-Haar
reflection form: instance of `reflForm_self_nonneg` at the physical gauge group,
for the bare product-Haar measure (interacting-measure RP remains pending). -/
theorem su_reflForm_self_nonneg (refl : ι ≃ ι) (posEdges : Set ι)
    (hcut : ∀ e ∈ posEdges, refl e ∉ posEdges)
    (F : Config ι (Matrix.specialUnitaryGroup (Fin n) ℂ) → ℝ)
    (hF : SupportedOn posEdges F) :
    0 ≤ reflForm μ refl F F :=
  reflForm_self_nonneg μ refl posEdges hcut F hF

end SpecialUnitary

end PhysicsSM.Draft.NullEdge.QMF.ProductHaarConfig
