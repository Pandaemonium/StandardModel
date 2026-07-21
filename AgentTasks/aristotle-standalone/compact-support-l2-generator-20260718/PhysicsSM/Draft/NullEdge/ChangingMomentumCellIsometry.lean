import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Set

/-!
# Exact changing-spacing momentum-cell isometry

This is the first honest `R^3` bridge rung. It embeds finitely supported
coefficients on `Z^3` as piecewise-constant functions on half-open momentum
cells of side length `h`. The normalization is exactly the reciprocal square
root of the cell volume.

No walk dynamics, Fourier transform, PDE generator, or continuum limit is
claimed here. Do not weaken the finite-support isometry or remove the wrong-
normalization and disjointness controls.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellIsometry

abbrev Mode3 := Fin 3 -> Int
abbrev Momentum3 := Fin 3 -> Real

def cellLower (h : Real) (k : Mode3) (i : Fin 3) : Real :=
  h * ((k i : Real) - 1 / 2)

def cellUpper (h : Real) (k : Mode3) (i : Fin 3) : Real :=
  h * ((k i : Real) + 1 / 2)

/-- The half-open momentum cell centered at `h k`. -/
def momentumCell (h : Real) (k : Mode3) : Set Momentum3 :=
  Set.pi Set.univ
    (fun i : Fin 3 => Set.Ico (cellLower h k i) (cellUpper h k i))

/-- Reciprocal square root of the three-dimensional cell volume. -/
def cellScale (h : Real) : Real :=
  (Real.sqrt (h ^ 3))⁻¹

/-- A constant complex packet supported on one half-open momentum cell. -/
def cellPacket (h : Real) (k : Mode3) (c : Complex) : Momentum3 -> Complex :=
  (momentumCell h k).indicator (fun _ => (cellScale h : Complex) * c)

/-- The unnormalized packet, included as a scaling control. -/
def rawCellPacket (h : Real) (k : Mode3) (c : Complex) : Momentum3 -> Complex :=
  (momentumCell h k).indicator (fun _ => c)

/-- Piecewise-constant embedding of a finite coefficient family. -/
def embedFinite (h : Real) (s : Finset Mode3) (c : Mode3 -> Complex) :
    Momentum3 -> Complex :=
  fun x => ∑ k ∈ s, cellPacket h k (c k) x

lemma cellLower_le_cellUpper {h : Real} (hh : 0 < h) (k : Mode3) :
    cellLower h k <= cellUpper h k := by
  intro i
  simp [cellLower, cellUpper]
  nlinarith

lemma momentumCell_eq_piIco (h : Real) (k : Mode3) :
    momentumCell h k =
      Set.pi Set.univ
        (fun i : Fin 3 => Set.Ico (cellLower h k i) (cellUpper h k i)) := by
  rfl

lemma momentumCell_measurable (h : Real) (k : Mode3) :
    MeasurableSet (momentumCell h k) := by
  rw [momentumCell_eq_piIco]
  apply MeasurableSet.univ_pi
  intro i
  exact measurableSet_Ico

/-- Every momentum cell has volume exactly `h^3`. -/
theorem volume_momentumCell_toReal {h : Real} (hh : 0 < h) (k : Mode3) :
    (volume (momentumCell h k)).toReal = h ^ 3 := by
  rw [momentumCell_eq_piIco,
    Real.volume_pi_Ico_toReal (cellLower_le_cellUpper hh k)]
  simp [cellLower, cellUpper, Fin.prod_univ_succ]
  ring

lemma volume_momentumCell_ne_top (h : Real) (k : Mode3) :
    volume (momentumCell h k) ≠ ∞ := by
  rw [momentumCell_eq_piIco, Real.volume_pi_Ico]
  exact ENNReal.prod_ne_top (fun _ _ => ENNReal.ofReal_ne_top)

/-- Distinct integer labels give disjoint half-open cells. -/
theorem momentumCell_disjoint {h : Real} (hh : 0 < h) {k l : Mode3}
    (hkl : k ≠ l) :
    Disjoint (momentumCell h k) (momentumCell h l) := by
  rw [Set.disjoint_left]
  intro x hxk hxl
  have hex : ∃ i : Fin 3, k i ≠ l i := by
    by_contra hn
    push_neg at hn
    exact hkl (funext hn)
  obtain ⟨i, hi⟩ := hex
  have hxk' : cellLower h k i ≤ x i ∧ x i < cellUpper h k i := by
    exact ⟨(hxk i (Set.mem_univ i)).1, (hxk i (Set.mem_univ i)).2⟩
  have hxl' : cellLower h l i ≤ x i ∧ x i < cellUpper h l i := by
    exact ⟨(hxl i (Set.mem_univ i)).1, (hxl i (Set.mem_univ i)).2⟩
  rcases lt_or_gt_of_ne hi with hilt | hilt
  · have hgap : (k i : Real) + 1 ≤ (l i : Real) := by
      exact_mod_cast hilt
    have hsep : cellUpper h k i ≤ cellLower h l i := by
      simp [cellUpper, cellLower]
      nlinarith
    nlinarith
  · have hgap : (l i : Real) + 1 ≤ (k i : Real) := by
      exact_mod_cast hilt
    have hsep : cellUpper h l i ≤ cellLower h k i := by
      simp [cellUpper, cellLower]
      nlinarith
    nlinarith

/-- One normalized cell preserves the coefficient's squared norm exactly. -/
theorem integral_norm_sq_cellPacket {h : Real} (hh : 0 < h)
    (k : Mode3) (c : Complex) :
    ∫ x, ‖cellPacket h k c x‖ ^ 2 = ‖c‖ ^ 2 := by
  have hfun : (fun x => ‖cellPacket h k c x‖ ^ 2) =
      (momentumCell h k).indicator
        (fun _ => ‖(cellScale h : Complex) * c‖ ^ 2) := by
    funext x
    by_cases hx : x ∈ momentumCell h k <;> simp [cellPacket, hx]
  rw [hfun, integral_indicator_const
    (‖(cellScale h : Complex) * c‖ ^ 2) (momentumCell_measurable h k)]
  change (volume (momentumCell h k)).toReal *
      ‖(cellScale h : Complex) * c‖ ^ 2 = ‖c‖ ^ 2
  rw [volume_momentumCell_toReal hh k, norm_mul]
  have h3 : 0 < h ^ 3 := pow_pos hh 3
  have hs : 0 < Real.sqrt (h ^ 3) := Real.sqrt_pos.2 h3
  have hs2 : (Real.sqrt (h ^ 3)) ^ 2 = h ^ 3 := Real.sq_sqrt h3.le
  rw [show ‖(cellScale h : Complex)‖ = cellScale h by
    rw [Complex.norm_real]
    exact abs_of_pos (inv_pos.2 hs)]
  unfold cellScale
  field_simp
  nlinarith

/-- Omitting `h^(-3/2)` leaves the wrong factor `h^3`. -/
theorem integral_norm_sq_rawCellPacket {h : Real} (hh : 0 < h)
    (k : Mode3) (c : Complex) :
    ∫ x, ‖rawCellPacket h k c x‖ ^ 2 = h ^ 3 * ‖c‖ ^ 2 := by
  have hfun : (fun x => ‖rawCellPacket h k c x‖ ^ 2) =
      (momentumCell h k).indicator (fun _ => ‖c‖ ^ 2) := by
    funext x
    by_cases hx : x ∈ momentumCell h k <;> simp [rawCellPacket, hx]
  rw [hfun, integral_indicator_const
    (‖c‖ ^ 2) (momentumCell_measurable h k)]
  change (volume (momentumCell h k)).toReal * ‖c‖ ^ 2 = _
  rw [volume_momentumCell_toReal hh k]

/-- Exact finite-support coefficient-to-`L2(R^3)` isometry at spacing `h`. -/
theorem embedFinite_isometry {h : Real} (hh : 0 < h)
    (s : Finset Mode3) (c : Mode3 -> Complex) :
    ∫ x, ‖embedFinite h s c x‖ ^ 2 = ∑ k ∈ s, ‖c k‖ ^ 2 := by
  classical
  have hpoint : ∀ x, ‖embedFinite h s c x‖ ^ 2 =
      ∑ q ∈ s, ‖cellPacket h q (c q) x‖ ^ 2 := by
    intro x
    by_cases hex : ∃ q ∈ s, x ∈ momentumCell h q
    · obtain ⟨q, hqs, hxq⟩ := hex
      have hzero :
          ∀ r ∈ s, r ≠ q → cellPacket h r (c r) x = 0 := by
        intro r hrs hrq
        rw [cellPacket, Set.indicator_of_notMem]
        intro hxr
        exact (Set.disjoint_left.1
          (momentumCell_disjoint hh hrq.symm)) hxq hxr
      have hsum1 :
          ∑ r ∈ s, cellPacket h r (c r) x = cellPacket h q (c q) x :=
        Finset.sum_eq_single q hzero (fun hn => (hn hqs).elim)
      have hsum2 :
          ∑ r ∈ s, ‖cellPacket h r (c r) x‖ ^ 2 =
            ‖cellPacket h q (c q) x‖ ^ 2 :=
        Finset.sum_eq_single q
          (fun r hrs hrq => by rw [hzero r hrs hrq]; simp)
          (fun hn => (hn hqs).elim)
      rw [embedFinite, hsum1, hsum2]
    · have hzero : ∀ q ∈ s, cellPacket h q (c q) x = 0 := by
        intro q hqs
        rw [cellPacket, Set.indicator_of_notMem]
        exact fun hxq => hex ⟨q, hqs, hxq⟩
      have hsum1 : ∑ q ∈ s, cellPacket h q (c q) x = 0 :=
        Finset.sum_eq_zero hzero
      have hsum2 : ∑ q ∈ s, ‖cellPacket h q (c q) x‖ ^ 2 = 0 :=
        Finset.sum_eq_zero (fun q hqs => by rw [hzero q hqs]; simp)
      rw [embedFinite, hsum1, hsum2]
      simp
  have hint :
      ∀ q ∈ s, Integrable (fun x => ‖cellPacket h q (c q) x‖ ^ 2) := by
    intro q hqs
    have hfunq : (fun x => ‖cellPacket h q (c q) x‖ ^ 2) =
        (momentumCell h q).indicator
          (fun _ => ‖(cellScale h : Complex) * c q‖ ^ 2) := by
      funext x
      by_cases hx : x ∈ momentumCell h q <;> simp [cellPacket, hx]
    rw [hfunq]
    exact IntegrableOn.integrable_indicator
      (integrableOn_const (volume_momentumCell_ne_top h q))
      (momentumCell_measurable h q)
  calc
    ∫ x, ‖embedFinite h s c x‖ ^ 2 =
        ∫ x, ∑ q ∈ s, ‖cellPacket h q (c q) x‖ ^ 2 :=
      integral_congr_ae (Filter.Eventually.of_forall hpoint)
    _ = ∑ q ∈ s, ∫ x, ‖cellPacket h q (c q) x‖ ^ 2 :=
      integral_finset_sum s hint
    _ = ∑ q ∈ s, ‖c q‖ ^ 2 := by
      apply Finset.sum_congr rfl
      intro q hqs
      exact integral_norm_sq_cellPacket hh q (c q)

/-- A nonzero one-cell coefficient is a nonvacuous witness. -/
theorem oneCell_nonzero {h : Real} (hh : 0 < h) (k : Mode3) :
    ∫ x, ‖cellPacket h k 1 x‖ ^ 2 = 1 := by
  simpa using integral_norm_sq_cellPacket hh k 1

/-! ## Assumption-footprint audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellIsometry.embedFinite_isometry' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms embedFinite_isometry

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellIsometry.oneCell_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms oneCell_nonzero

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellIsometry
