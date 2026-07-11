import Mathlib

/-!
# Explicit changing-space mode embeddings

This module supplies concrete sample/interpolate maps between expanding finite
momentum boxes and a common countable Fourier-mode space. It proves exact round
trips, energy preservation, and strong square-summable tail convergence.

This is changing-Hilbert-space infrastructure, not a continuum `R^3` sampling
theorem: live-walk Fourier conjugacy, Sobolev rates, and Dirac-flow convergence
remain separate composition gates.
-/

noncomputable section

open scoped BigOperators Topology
open Filter

namespace PhysicsSM.Draft.NullEdge.ChangingModeEmbedding

/-- Integer momentum labels in three dimensions. -/
abbrev Mode := (Int × Int) × Int

/-- Symmetric integer interval of radius `N`. -/
def intInterval (N : Nat) : Finset Int :=
  Finset.Icc (-(N : Int)) (N : Int)

/-- The cubic momentum box `[-N,N]^3`. -/
def modeBox (N : Nat) : Finset Mode :=
  (intInterval N).product (intInterval N) |>.product (intInterval N)

/-- The finite coefficient space at cutoff `N`. -/
abbrev BoxCoeff (N : Nat) (E : Type*) := {k : Mode // k ∈ modeBox N} → E

/-- Restrict a common mode field to the finite cutoff box. -/
def sample {E : Type*} (N : Nat) (f : Mode → E) : BoxCoeff N E :=
  fun k => f k.1

/-- Embed finite coefficients into the common mode space by zero padding. -/
def interpolate {E : Type*} [Zero E] (N : Nat) (c : BoxCoeff N E) : Mode → E :=
  fun k => if hk : k ∈ modeBox N then c ⟨k, hk⟩ else 0

/-- Cut a common mode field off outside the box. -/
def truncate {E : Type*} [Zero E] (N : Nat) (f : Mode → E) : Mode → E :=
  fun k => if k ∈ modeBox N then f k else 0

/-- The symmetric integer interval grows with its radius. -/
theorem intInterval_mono : Monotone intInterval := by
  intro a b hab
  apply Finset.Icc_subset_Icc <;>
    simp only [neg_le_neg_iff, Nat.cast_le] <;> exact_mod_cast hab

/-- Explicit membership criterion for the cubic momentum box. -/
theorem mem_modeBox_iff (x y z : Int) (N : Nat) :
    ((x, y), z) ∈ modeBox N ↔
      (-(N : Int) ≤ x ∧ x ≤ N) ∧
      (-(N : Int) ≤ y ∧ y ≤ N) ∧
      (-(N : Int) ≤ z ∧ z ≤ N) := by
  simp only [modeBox, Finset.product_eq_sprod, Finset.mem_product, intInterval,
    Finset.mem_Icc]
  tauto

/-- Sampling after zero-padding is exactly the identity on every finite space. -/
theorem sample_interpolate {E : Type*} [Zero E] (N : Nat) (c : BoxCoeff N E) :
    sample N (interpolate N c) = c := by
  funext k
  simp only [sample, interpolate, dif_pos k.2]

/-- Zero-padding after sampling is exactly common-space truncation. -/
theorem interpolate_sample {E : Type*} [Zero E] (N : Nat) (f : Mode → E) :
    interpolate N (sample N f) = truncate N f := by
  funext k
  by_cases hk : k ∈ modeBox N <;> simp [interpolate, sample, truncate, hk]

/-- The boxes are nested as the cutoff grows. -/
theorem modeBox_mono : Monotone modeBox := by
  intro a b hab
  apply Finset.product_subset_product
  · apply Finset.product_subset_product <;> exact intInterval_mono hab
  · exact intInterval_mono hab

/-- Every integer momentum lies in some finite box. -/
theorem modeBox_exhausts :
    (⋃ N : Nat, (modeBox N : Set Mode)) = Set.univ := by
  rw [Set.eq_univ_iff_forall]
  intro k
  rw [Set.mem_iUnion]
  obtain ⟨⟨x, y⟩, z⟩ := k
  refine ⟨(x.natAbs ⊔ y.natAbs ⊔ z.natAbs), ?_⟩
  simp only [Finset.mem_coe, modeBox, Finset.product_eq_sprod,
    Finset.mem_product, intInterval, Finset.mem_Icc]
  refine ⟨⟨⟨?_, ?_⟩, ?_, ?_⟩, ?_, ?_⟩ <;> omega

/-- A mode whose coordinates are bounded by `N` lies in its radius-`N` box. -/
theorem mem_modeBox_of_le (k : Mode) (N : Nat)
    (hx : k.1.1.natAbs ⊔ k.1.2.natAbs ⊔ k.2.natAbs ≤ N) :
    k ∈ modeBox N := by
  obtain ⟨⟨x, y⟩, z⟩ := k
  rw [mem_modeBox_iff]
  simp only at hx
  omega

/-- The cubic boxes eventually contain every finite set of modes. -/
theorem tendsto_modeBox_atTop : Tendsto modeBox atTop atTop := by
  rw [tendsto_atTop_atTop]
  intro t
  refine ⟨t.sup (fun k => k.1.1.natAbs ⊔ k.1.2.natAbs ⊔ k.2.natAbs), ?_⟩
  intro n hn k hk
  apply modeBox_mono hn
  apply mem_modeBox_of_le
  exact Finset.le_sup
    (f := fun k => k.1.1.natAbs ⊔ k.1.2.natAbs ⊔ k.2.natAbs) hk

/-- Finite squared norm of cutoff coefficients. -/
def finiteEnergy {E : Type*} [Norm E] (N : Nat) (c : BoxCoeff N E) : Real :=
  ∑ k, ‖c k‖ ^ 2

/-- Squared norm in the common countable mode space. -/
def modeEnergy {E : Type*} [Norm E] (f : Mode → E) : Real :=
  ∑' k, ‖f k‖ ^ 2

/-- Zero-padding preserves the finite coefficient energy exactly. -/
theorem interpolate_energy {E : Type*} [NormedAddCommGroup E]
    (N : Nat) (c : BoxCoeff N E) :
    modeEnergy (interpolate N c) = finiteEnergy N c := by
  unfold modeEnergy finiteEnergy
  have hzero : ∀ b ∉ modeBox N, ‖interpolate N c b‖ ^ 2 = 0 := by
    intro b hb
    simp only [interpolate, dif_neg hb, norm_zero, ne_eq,
      OfNat.ofNat_ne_zero, not_false_eq_true, zero_pow]
  rw [tsum_eq_sum hzero,
    Finset.sum_coe_sort_eq_attach (modeBox N) (fun k => ‖c k‖ ^ 2),
    ← Finset.sum_attach (modeBox N) (fun x => ‖interpolate N c x‖ ^ 2)]
  apply Finset.sum_congr rfl
  intro k hk
  simp only [interpolate, dif_pos k.2]

/-- Sampling and zero-padding converge strongly in squared mode energy for
every square-summable common-space field. -/
theorem interpolate_sample_tendsto {E : Type*} [NormedAddCommGroup E]
    (f : Mode → E) (hf : Summable (fun k => ‖f k‖ ^ 2)) :
    Tendsto
      (fun N => modeEnergy (fun k => f k - interpolate N (sample N f) k))
      atTop (nhds 0) := by
  set g : Mode → ℝ := fun k => ‖f k‖ ^ 2 with hg_def
  set S : ℝ := ∑' k, g k with hS_def
  have hpt : ∀ N,
      modeEnergy (fun k => f k - interpolate N (sample N f) k) =
        S - ∑ k ∈ modeBox N, g k := by
    intro N
    have hb : Summable (fun k => if k ∈ modeBox N then g k else 0) := by
      apply summable_of_ne_finset_zero (s := modeBox N)
      intro k hk
      simp [hk]
    have hrw :
        (fun k => ‖f k - interpolate N (sample N f) k‖ ^ 2) =
          (fun k => g k - (if k ∈ modeBox N then g k else 0)) := by
      funext k
      rw [interpolate_sample]
      by_cases hk : k ∈ modeBox N
      · simp [truncate, hk, hg_def]
      · simp [truncate, hk, hg_def]
    unfold modeEnergy
    rw [hrw, Summable.tsum_sub hf hb]
    congr 1
    rw [tsum_eq_sum (s := modeBox N) (by intro b hb; simp [hb])]
    apply Finset.sum_congr rfl
    intro k hk
    simp [hk]
  rw [tendsto_congr hpt]
  have hP : Tendsto (fun N => ∑ k ∈ modeBox N, g k) atTop (nhds S) :=
    (hf.hasSum).comp tendsto_modeBox_atTop
  have h := hP.const_sub S
  simpa using h

/-- Delta field at one momentum. -/
def deltaAt {E : Type*} [Zero E] (q : Mode) (v : E) : Mode → E :=
  fun k => if k = q then v else 0

/-- Nonzero control: zero momentum survives every cutoff. -/
theorem zero_mode_roundtrip {E : Type*} [Zero E] (N : Nat) (v : E) :
    interpolate N (sample N (deltaAt ((0, 0), 0) v)) =
      deltaAt ((0, 0), 0) v := by
  rw [interpolate_sample]
  funext k
  simp only [truncate, deltaAt]
  by_cases hk : k = ((0, 0), 0)
  · subst hk
    simp [mem_modeBox_iff]
  · simp only [if_neg hk, ite_self]

/-- Boundary control: a mode one unit beyond the positive x face is removed. -/
theorem outside_mode_killed {E : Type*} [Zero E] (N : Nat) (v : E) :
    interpolate N
        (sample N (deltaAt ((((N + 1 : Nat) : Int), 0), 0) v)) = 0 := by
  rw [interpolate_sample]
  funext k
  simp only [truncate, deltaAt, Pi.zero_apply]
  by_cases hk : k ∈ modeBox N
  · rw [if_pos hk]
    have hne : k ≠ ((((N + 1 : Nat) : Int), 0), 0) := by
      rintro rfl
      rw [mem_modeBox_iff] at hk
      push_cast at hk
      omega
    rw [if_neg hne]
  · rw [if_neg hk]

/-- Nondegenerate boundary control: a genuinely nonzero mode just outside the
positive x face is nevertheless removed by restriction and zero padding. -/
theorem outside_mode_killed_nontrivial {E : Type*} [Zero E] (N : Nat) {v : E}
    (hv : v ≠ 0) :
    deltaAt ((((N + 1 : Nat) : Int), 0), 0) v ≠ 0 ∧
      interpolate N
          (sample N (deltaAt ((((N + 1 : Nat) : Int), 0), 0) v)) = 0 := by
  constructor
  · intro h
    apply hv
    simpa [deltaAt] using congrFun h ((((N + 1 : Nat) : Int), 0), 0)
  · exact outside_mode_killed N v

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingModeEmbedding.interpolate_energy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms interpolate_energy

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingModeEmbedding.interpolate_sample_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms interpolate_sample_tendsto

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingModeEmbedding.zero_mode_roundtrip' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zero_mode_roundtrip

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingModeEmbedding.outside_mode_killed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms outside_mode_killed

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingModeEmbedding.outside_mode_killed_nontrivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms outside_mode_killed_nontrivial

end PhysicsSM.Draft.NullEdge.ChangingModeEmbedding
