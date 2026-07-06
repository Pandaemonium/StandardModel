import Mathlib

/-!
# NE-U5 : "Mass from masslessness" at finite grade

This file formalizes, as a self-contained finite kinematic identity, the thesis that a
composite built out of purely **massless (null)** constituents can nevertheless carry a
strictly positive invariant mass.

The mechanism is entirely **relational**: each constituent lies on the light cone
(`minkowskiSq p = 0`, i.e. it is individually massless), yet the invariant mass of the
*sum* of the four-momenta is strictly positive as soon as the constituents do not all
share a common null ray (they are not "aligned" on the light cone).  Thus 100% of the
composite mass comes from the *configuration* (the aperture / binding), and none of it
from any constituent mass.

This is the finite kinematic avatar of Wilczek's slogan that most visible mass is QCD
binding energy rather than Higgs coupling.  **It is a kinematic identity, not a QCD
derivation.**

## Signature conventions

A four-momentum is modelled as an energy `e : ℝ` together with a spatial momentum
`p : EuclideanSpace ℝ (Fin 3)`.  We use the mostly-minus metric, so

`minkowskiSq P = P.e ^ 2 - ‖P.p‖ ^ 2`.

A future-null (massless) momentum satisfies `P.e = ‖P.p‖` (energy equals the magnitude of
the spatial momentum), which is equivalent to `minkowskiSq P = 0` together with `P.e ≥ 0`.

## Main results

* `FourMom.isFutureNull_iff` : characterisation of the null condition.
* `massConstituentSum_eq_zero` : every constituent is massless, so the sum of the
  individual masses is `0`.
* `compositeMinkowskiSq_nonneg` : the composite always has non-negative invariant mass².
* `compositeMinkowskiSq_pos` : the composite has strictly positive invariant mass² as soon
  as two of the constituents do not share a null ray (the *aperture* is open).
* `compositeMass_pos` : the corresponding statement for the invariant mass itself.
* `neu5_backToBack` : a concrete witness — two back-to-back null momenta — with all
  constituents massless yet composite mass `2 > 0`.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.GateI1.MassFromMasslessNEU5

/-- A four-momentum: an energy component together with a spatial momentum vector. -/
structure FourMom where
  /-- Energy (time component). -/
  e : ℝ
  /-- Spatial momentum (three-vector). -/
  p : EuclideanSpace ℝ (Fin 3)

namespace FourMom

/-- The Minkowski square (invariant mass²) of a four-momentum, mostly-minus signature. -/
noncomputable def minkowskiSq (P : FourMom) : ℝ := P.e ^ 2 - ‖P.p‖ ^ 2

/-- The invariant mass of a four-momentum. -/
noncomputable def mass (P : FourMom) : ℝ := Real.sqrt (minkowskiSq P)

/-- A four-momentum is *future-null* (massless, on the forward light cone) when its energy
equals the magnitude of its spatial momentum. -/
def IsFutureNull (P : FourMom) : Prop := P.e = ‖P.p‖

/-- A future-null momentum has vanishing Minkowski square (it is massless). -/
theorem minkowskiSq_of_isFutureNull {P : FourMom} (h : P.IsFutureNull) :
    P.minkowskiSq = 0 := by
  unfold minkowskiSq
  rw [h]; ring

/-- A future-null momentum has vanishing invariant mass. -/
theorem mass_of_isFutureNull {P : FourMom} (h : P.IsFutureNull) : P.mass = 0 := by
  unfold mass
  rw [minkowskiSq_of_isFutureNull h, Real.sqrt_zero]

/-- Characterisation of future-null momenta: energy is non-negative and the Minkowski
square vanishes. -/
theorem isFutureNull_iff {P : FourMom} :
    P.IsFutureNull ↔ 0 ≤ P.e ∧ P.minkowskiSq = 0 := by
  constructor
  · intro h
    exact ⟨h ▸ norm_nonneg _, minkowskiSq_of_isFutureNull h⟩
  · rintro ⟨he, hm⟩
    unfold IsFutureNull
    unfold minkowskiSq at hm
    have : P.e ^ 2 = ‖P.p‖ ^ 2 := by linarith
    have hnn : (0:ℝ) ≤ ‖P.p‖ := norm_nonneg _
    nlinarith [sq_nonneg (P.e - ‖P.p‖), sq_nonneg (P.e + ‖P.p‖)]

end FourMom

open FourMom

/-- Total energy of a finite family of four-momenta. -/
def sumE {ι : Type*} (s : Finset ι) (f : ι → FourMom) : ℝ := ∑ i ∈ s, (f i).e

/-- Total spatial momentum of a finite family of four-momenta. -/
noncomputable def sumP {ι : Type*} (s : Finset ι) (f : ι → FourMom) : EuclideanSpace ℝ (Fin 3) :=
  ∑ i ∈ s, (f i).p

/-- The composite four-momentum obtained by summing a finite family. -/
noncomputable def composite {ι : Type*} (s : Finset ι) (f : ι → FourMom) : FourMom :=
  ⟨sumE s f, sumP s f⟩

/-- The composite Minkowski square (invariant mass²) of a finite family. -/
noncomputable def compositeMinkowskiSq {ι : Type*} (s : Finset ι) (f : ι → FourMom) : ℝ :=
  (composite s f).minkowskiSq

/-- The composite invariant mass of a finite family. -/
noncomputable def compositeMass {ι : Type*} (s : Finset ι) (f : ι → FourMom) : ℝ :=
  (composite s f).mass

/-- The sum of the individual (constituent) invariant masses. -/
noncomputable def massConstituentSum {ι : Type*} (s : Finset ι) (f : ι → FourMom) : ℝ :=
  ∑ i ∈ s, (f i).mass

/-- **All constituents are massless.**  If every constituent is future-null then the sum of
the individual constituent masses is exactly zero. -/
theorem massConstituentSum_eq_zero {ι : Type*} (s : Finset ι) (f : ι → FourMom)
    (hnull : ∀ i ∈ s, (f i).IsFutureNull) :
    massConstituentSum s f = 0 := by
  unfold massConstituentSum
  apply Finset.sum_eq_zero
  intro i hi
  exact mass_of_isFutureNull (hnull i hi)

/-- For a family of future-null constituents the total energy equals the sum of the
magnitudes of the spatial momenta. -/
theorem sumE_eq_sum_norm {ι : Type*} (s : Finset ι) (f : ι → FourMom)
    (hnull : ∀ i ∈ s, (f i).IsFutureNull) :
    sumE s f = ∑ i ∈ s, ‖(f i).p‖ := by
  unfold sumE
  apply Finset.sum_congr rfl
  intro i hi
  exact hnull i hi

/-- The total spatial momentum has norm bounded by the total energy (of a null family). -/
theorem norm_sumP_le_sumE {ι : Type*} (s : Finset ι) (f : ι → FourMom)
    (hnull : ∀ i ∈ s, (f i).IsFutureNull) :
    ‖sumP s f‖ ≤ sumE s f := by
  rw [sumE_eq_sum_norm s f hnull]
  exact norm_sum_le s (fun i => (f i).p)

/-- The total energy of a null family is non-negative. -/
theorem sumE_nonneg {ι : Type*} (s : Finset ι) (f : ι → FourMom)
    (hnull : ∀ i ∈ s, (f i).IsFutureNull) :
    0 ≤ sumE s f :=
  le_trans (norm_nonneg _) (norm_sumP_le_sumE s f hnull)

/-- **Composite mass is always real (non-negative invariant mass²).**  Any composite of
future-null constituents has non-negative Minkowski square. -/
theorem compositeMinkowskiSq_nonneg {ι : Type*} (s : Finset ι) (f : ι → FourMom)
    (hnull : ∀ i ∈ s, (f i).IsFutureNull) :
    0 ≤ compositeMinkowskiSq s f := by
  unfold compositeMinkowskiSq composite minkowskiSq
  simp only
  have h1 : ‖sumP s f‖ ≤ sumE s f := norm_sumP_le_sumE s f hnull
  have h2 : 0 ≤ ‖sumP s f‖ := norm_nonneg _
  nlinarith [h1, h2]

/-- Strict triangle inequality for a finite sum in a strictly convex space: if two of the
summands do not share a common ray, the norm of the sum is strictly less than the sum of
the norms. -/
theorem norm_sum_lt_of_not_sameRay {ι : Type*} {E : Type*} [NormedAddCommGroup E]
    [NormedSpace ℝ E] [StrictConvexSpace ℝ E] (s : Finset ι) (g : ι → E)
    {i j : ι} (hi : i ∈ s) (hj : j ∈ s) (hij : i ≠ j)
    (hns : ¬ SameRay ℝ (g i) (g j)) :
    ‖∑ k ∈ s, g k‖ < ∑ k ∈ s, ‖g k‖ := by
  classical
  set t := (s.erase i).erase j with ht
  have hj' : j ∈ s.erase i := Finset.mem_erase.mpr ⟨(Ne.symm hij), hj⟩
  -- decompose the vector sum
  have hsumP : ∑ k ∈ s, g k = (g i + g j) + ∑ k ∈ t, g k := by
    rw [← Finset.add_sum_erase s g hi, ← Finset.add_sum_erase (s.erase i) g hj']
    rw [ht, add_assoc]
  -- decompose the sum of norms
  have hsumN : ∑ k ∈ s, ‖g k‖ = (‖g i‖ + ‖g j‖) + ∑ k ∈ t, ‖g k‖ := by
    rw [← Finset.add_sum_erase s (fun k => ‖g k‖) hi,
        ← Finset.add_sum_erase (s.erase i) (fun k => ‖g k‖) hj']
    rw [ht, add_assoc]
  have hpair : ‖g i + g j‖ < ‖g i‖ + ‖g j‖ := not_sameRay_iff_norm_add_lt.mp hns
  rw [hsumP, hsumN]
  calc ‖(g i + g j) + ∑ k ∈ t, g k‖
      ≤ ‖g i + g j‖ + ‖∑ k ∈ t, g k‖ := norm_add_le _ _
    _ ≤ ‖g i + g j‖ + ∑ k ∈ t, ‖g k‖ := by gcongr; exact norm_sum_le t g
    _ < (‖g i‖ + ‖g j‖) + ∑ k ∈ t, ‖g k‖ := by gcongr

/-- **The aperture opens the mass gap (n-body).**  If every constituent is future-null and
there exist two constituents whose spatial momenta do *not* share a common ray (they are
not aligned on the light cone), then the composite has strictly positive invariant mass².

The whole of this positive mass² comes from the relational configuration: each constituent
is massless (`minkowskiSq (f i) = 0`), yet the sum is timelike. -/
theorem compositeMinkowskiSq_pos {ι : Type*} (s : Finset ι) (f : ι → FourMom)
    (hnull : ∀ i ∈ s, (f i).IsFutureNull)
    {i j : ι} (hi : i ∈ s) (hj : j ∈ s) (hij : i ≠ j)
    (hns : ¬ SameRay ℝ (f i).p (f j).p) :
    0 < compositeMinkowskiSq s f := by
  unfold compositeMinkowskiSq composite minkowskiSq
  simp only
  rw [sumE_eq_sum_norm s f hnull]
  have hlt : ‖sumP s f‖ < ∑ k ∈ s, ‖(f k).p‖ :=
    norm_sum_lt_of_not_sameRay s (fun k => (f k).p) hi hj hij hns
  have hnn : 0 ≤ ‖sumP s f‖ := norm_nonneg _
  nlinarith [hlt, hnn]

/-- The composite invariant mass is strictly positive when the aperture is open. -/
theorem compositeMass_pos {ι : Type*} (s : Finset ι) (f : ι → FourMom)
    (hnull : ∀ i ∈ s, (f i).IsFutureNull)
    {i j : ι} (hi : i ∈ s) (hj : j ∈ s) (hij : i ≠ j)
    (hns : ¬ SameRay ℝ (f i).p (f j).p) :
    0 < compositeMass s f := by
  unfold compositeMass composite mass
  rw [Real.sqrt_pos]
  have := compositeMinkowskiSq_pos s f hnull hi hj hij hns
  unfold compositeMinkowskiSq composite at this
  exact this

/-! ## Concrete witness: two back-to-back null momenta

The two constituents are `(1; +x̂)` and `(1; -x̂)`.  Each is massless
(`minkowskiSq = 0`), but the composite is `(2; 0)`, purely timelike, with invariant
mass `2`. -/

/-- The two-constituent family: two back-to-back photons along the `x`-axis. -/
noncomputable def backToBack : Fin 2 → FourMom
  | 0 => ⟨1, !₂[1, 0, 0]⟩
  | 1 => ⟨1, !₂[-1, 0, 0]⟩

theorem backToBack_null : ∀ i ∈ (Finset.univ : Finset (Fin 2)),
    (backToBack i).IsFutureNull := by
  intro i _
  fin_cases i <;>
    · unfold FourMom.IsFutureNull backToBack
      simp [EuclideanSpace.norm_eq, Fin.sum_univ_three]

theorem backToBack_not_sameRay :
    ¬ SameRay ℝ (backToBack 0).p (backToBack 1).p := by
  rw [not_sameRay_iff_norm_add_lt]
  have h : (backToBack 0).p + (backToBack 1).p = 0 := by
    unfold backToBack
    ext k; fin_cases k <;> simp
  rw [h]
  unfold backToBack
  simp [EuclideanSpace.norm_eq, Fin.sum_univ_three]

/-- The composite of the two back-to-back photons has invariant mass² equal to `4`. -/
theorem backToBack_compositeMinkowskiSq :
    compositeMinkowskiSq (Finset.univ : Finset (Fin 2)) backToBack = 4 := by
  unfold compositeMinkowskiSq composite minkowskiSq sumE sumP
  simp only
  have hp : (∑ i : Fin 2, (backToBack i).p) = 0 := by
    unfold backToBack
    ext k; fin_cases k <;> simp [Fin.sum_univ_two]
  rw [hp]
  simp only [Fin.sum_univ_two, backToBack, norm_zero]
  norm_num

/-- **NE-U5 witness.**  A composite of two purely massless (null) constituents with
strictly positive composite mass.

* The sum of the individual constituent masses is `0` (each constituent is massless).
* The composite invariant mass is `2 > 0`.

All of the composite mass is relational (from the open aperture between the two null rays);
none comes from any constituent mass. -/
theorem neu5_backToBack :
    massConstituentSum (Finset.univ : Finset (Fin 2)) backToBack = 0 ∧
    0 < compositeMass (Finset.univ : Finset (Fin 2)) backToBack := by
  refine ⟨massConstituentSum_eq_zero _ _ backToBack_null, ?_⟩
  have h0 : (0 : Fin 2) ∈ (Finset.univ : Finset (Fin 2)) := Finset.mem_univ _
  have h1 : (1 : Fin 2) ∈ (Finset.univ : Finset (Fin 2)) := Finset.mem_univ _
  exact compositeMass_pos _ _ backToBack_null h0 h1 (by decide) backToBack_not_sameRay

end PhysicsSM.Draft.NullEdge.GateI1.MassFromMasslessNEU5
