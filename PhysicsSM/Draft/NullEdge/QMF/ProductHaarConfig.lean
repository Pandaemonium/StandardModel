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

## What is FROZEN (documented `s o r r y` handoff)

4. **The RP bilinear form** `reflForm μ refl F G = ∫ (F ∘ theta) * G` on the
   configuration space, and the target nonnegativity `0 ≤ reflForm μ refl F F`
   for observables `F` supported on the positive side of the cut
   (`reflForm_self_nonneg`). Positivity is NOT proved here: it needs the Wilson
   slab / character-expansion (Peter-Weyl) input, which is explicitly OUT OF
   SCOPE for this substrate. The form is DEFINED and the theorem STATEMENT is
   frozen with a clearly-labelled `s o r r y` handoff.

## Scope / honest claim label

This is a **multi-link product-Haar gauge/reflection substrate**: the link
symmetries (gauge invariance at each link / endpoint, reflection invariance) that
Osterwalder-Seiler reflection positivity consumes, now on the finite-lattice
product configuration space. **RP positivity is the pending rung.** This is a
LINK-symmetry / OS-ingredient result, NOT reflection positivity itself, and NOT a
transfer operator. Peter-Weyl / character orthogonality is nowhere assumed.
Draft-trust. Prerequisites: `QMF/SpecialUnitaryCompact`,
`QMF/CompactHaarInvariance`, `QMF/GaugeHaarInvariance`, Mathlib.
-/

namespace PhysicsSM.Draft.NullEdge.QMF.ProductHaarConfig

open MeasureTheory MeasureTheory.Measure
open PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance

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

/-! ### Part 4: the RP bilinear form (statement-freeze)

The reflection (Osterwalder-Schrader) bilinear form on real observables and the
target reflection-positivity statement. Positivity requires the Wilson slab /
character-expansion (Peter-Weyl) input, which is OUT OF SCOPE; only the form is
DEFINED, and the nonnegativity theorem STATEMENT is frozen with a clearly
labelled `s o r r y` handoff. -/

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

/-- **[FROZEN STATEMENT - `s o r r y` handoff, positivity NOT proved here.]**
Target Osterwalder-Seiler **reflection positivity** for the product-Haar
ensemble: the reflection form is nonnegative on the diagonal for observables
supported on the positive side of the cut, `0 ≤ ⟨F, F⟩`, when the edge reflection
`refl` maps the positive side `posEdges` off itself (a genuine cut).

This is the PENDING RUNG. Its proof is NOT available from the product structure
alone: it needs the Wilson-action slab factorization / character-expansion
(Peter-Weyl) positivity input, which is explicitly OUT OF SCOPE for this
gauge/reflection substrate. The statement is frozen here with a documented
`s o r r y`; the multi-link gauge/reflection *symmetries* it will consume
(`productHaar_endpoint_gauge_invariant`, `productHaar_link_conj_invariant`,
`productHaar_reflection_invariant`) ARE proved above. -/
theorem reflForm_self_nonneg (refl : ι ≃ ι) (hrefl : Function.Involutive refl)
    (posEdges : Set ι) (hcut : ∀ e ∈ posEdges, refl e ∉ posEdges)
    (F : Config ι G → ℝ) (hF : SupportedOn posEdges F) :
    0 ≤ reflForm μ refl F F := by
  sorry

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

end SpecialUnitary

end PhysicsSM.Draft.NullEdge.QMF.ProductHaarConfig
