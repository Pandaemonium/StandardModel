import Mathlib

/-!
# Analytic core for a changing-lattice Dirac limit

This module isolates the new analytic ingredient needed to pass from a
same-momentum-space multiplier estimate to a sampling/interpolation theorem on
changing lattices.  The exact error decomposes into a Brillouin-zone bulk term
and a complementary ultraviolet tail.

It does not identify the finite lattice Fourier transform, construct sampling
or interpolation maps, or claim the final position-space PDE theorem.

Provenance: theorem architecture designed in Aristotle project
`95febb02-550e-4e73-8ea8-0ff1c56355c3`; clean-room proof against Mathlib
`eLpNorm_sub_le`.  Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ChangingLatticePDECore

open MeasureTheory Filter Topology Set

/-- The band-limited approximation error is bounded by the in-band multiplier
error plus the exact solution's ultraviolet tail. -/
theorem tail_bulk_split {X E : Type*} [MeasurableSpace X]
    [NormedAddCommGroup E] {mu : Measure X} (approx exact : X -> E) (B : Set X)
    (hbulk : AEStronglyMeasurable
      (B.indicator fun y => approx y - exact y) mu)
    (htail : AEStronglyMeasurable (Bᶜ.indicator exact) mu) :
    eLpNorm (fun x => B.indicator approx x - exact x) 2 mu <=
      eLpNorm (B.indicator fun y => approx y - exact y) 2 mu +
        eLpNorm (Bᶜ.indicator exact) 2 mu := by
  have hdecomp : (fun x => B.indicator approx x - exact x) =
      fun x => B.indicator (fun y => approx y - exact y) x -
        Bᶜ.indicator exact x := by
    funext x
    by_cases hx : x ∈ B <;>
      simp [Set.indicator_of_mem, Set.indicator_of_notMem, hx,
        Set.mem_compl_iff]
  rw [hdecomp]
  exact eLpNorm_sub_le hbulk htail (by norm_num)

/-- Squared `enorm` commutes pointwise with restriction to a complement. -/
lemma enorm_sq_indicator_compl {X E : Type*} [NormedAddCommGroup E]
    (exact : X -> E) (s : Set X) (x : X) :
    ‖(sᶜ.indicator exact) x‖ₑ ^ (2 : Real) =
      sᶜ.indicator (fun y => ‖exact y‖ₑ ^ (2 : Real)) x := by
  by_cases hx : x ∈ s <;> simp +decide [hx]

/-- `MemLp exact 2 mu` makes the squared-`enorm` integral finite. -/
lemma lintegral_enorm_sq_ne_top {X E : Type*} [MeasurableSpace X]
    [NormedAddCommGroup E] {mu : Measure X}
    (exact : X -> E) (hex : MemLp exact 2 mu) :
    (∫⁻ x, ‖exact x‖ₑ ^ (2 : Real) ∂mu) ≠ ⊤ := by
  have hfinite := hex.eLpNorm_ne_top
  simp_all +decide [eLpNorm_eq_lintegral_rpow_enorm_toReal]

/-- The integrals of the squared `L2` tail over exhausting band complements
tend to zero. -/
lemma inner_lintegral_tendsto_zero {X E : Type*} [MeasurableSpace X]
    [NormedAddCommGroup E] {mu : Measure X}
    (exact : X -> E) (hex : MemLp exact 2 mu)
    (B : Nat -> Set X) (hBmeas : ∀ n, MeasurableSet (B n))
    (hmono : Monotone B) (hcover : ⋃ n, B n = Set.univ) :
    Tendsto
      (fun n => ∫⁻ x, ‖((B n)ᶜ.indicator exact) x‖ₑ ^ (2 : Real) ∂mu)
      Filter.atTop (nhds 0) := by
  have hdc : Tendsto
      (fun n => ∫⁻ x, (B n)ᶜ.indicator
        (fun y => ‖exact y‖ₑ ^ 2) x ∂mu)
      Filter.atTop (nhds (∫⁻ _x, 0 ∂mu)) := by
    refine MeasureTheory.tendsto_lintegral_of_dominated_convergence' ?_ ?_ ?_ ?_ ?_
    refine fun x => ‖exact x‖ₑ ^ 2
    · intro n
      exact AEMeasurable.indicator (hex.1.enorm.pow_const _)
        (MeasurableSet.compl (hBmeas n))
    · intro n
      filter_upwards [] with x
      by_cases hx : x ∈ B n <;> simp +decide [hx]
    · convert lintegral_enorm_sq_ne_top exact hex
      norm_cast
    · filter_upwards [] with x
      simp_all +decide [Set.ext_iff]
      obtain ⟨n, hn⟩ := hcover x
      exact tendsto_const_nhds.congr' (by
        filter_upwards [Filter.eventually_ge_atTop n] with m hm
        rw [Set.indicator_of_notMem]
        exact fun h => absurd (hmono hm hn) h)
  convert hdc using 2
  · congr with x
    by_cases hx : x ∈ B ‹_› <;> simp +decide [hx]
  · simp +decide

/-- **UV-tail convergence.** The `L2` mass outside measurable increasing bands
tends to zero when the bands exhaust the frequency space. -/
theorem uv_tail_tendsto_zero {X E : Type*} [MeasurableSpace X]
    [NormedAddCommGroup E] {mu : Measure X}
    (exact : X -> E) (hex : MemLp exact 2 mu)
    (B : Nat -> Set X) (hBmeas : ∀ n, MeasurableSet (B n))
    (hmono : Monotone B) (hcover : ⋃ n, B n = Set.univ) :
    Tendsto (fun n => eLpNorm ((B n)ᶜ.indicator exact) 2 mu)
      Filter.atTop (nhds 0) := by
  have hsqrt : Tendsto (fun t : ENNReal => t ^ (1 / 2 : Real))
      (nhds 0) (nhds 0) := by
    convert ENNReal.continuous_rpow_const.tendsto 0 using 2
    norm_num
  convert hsqrt.comp
    (inner_lintegral_tendsto_zero exact hex B hBmeas hmono hcover) using 2
  rw [Function.comp_apply, eLpNorm_eq_lintegral_rpow_enorm_toReal] <;>
    norm_num

/-- **Abstract changing-band convergence.** If the approximation error inside
each band tends to zero and the measurable bands exhaust the space, then the
band-restricted approximation converges to the exact `L2` field globally. -/
theorem band_approx_tendsto_zero {X E : Type*} [MeasurableSpace X]
    [NormedAddCommGroup E] {mu : Measure X}
    (approx : Nat -> X -> E) (exact : X -> E) (hex : MemLp exact 2 mu)
    (B : Nat -> Set X) (hBmeas : ∀ n, MeasurableSet (B n))
    (hmono : Monotone B) (hcover : ⋃ n, B n = Set.univ)
    (hbulkMeas : ∀ n, AEStronglyMeasurable
      ((B n).indicator fun x => approx n x - exact x) mu)
    (htailMeas : ∀ n, AEStronglyMeasurable ((B n)ᶜ.indicator exact) mu)
    (hbulk : Tendsto
      (fun n => eLpNorm ((B n).indicator
        (fun x => approx n x - exact x)) 2 mu)
      Filter.atTop (nhds 0)) :
    Tendsto
      (fun n => eLpNorm
        (fun x => (B n).indicator (approx n) x - exact x) 2 mu)
      Filter.atTop (nhds 0) := by
  have hsum : Tendsto
      (fun n => eLpNorm ((B n).indicator
          (fun x => approx n x - exact x)) 2 mu +
        eLpNorm ((B n)ᶜ.indicator exact) 2 mu)
      Filter.atTop (nhds 0) := by
    simpa using hbulk.add
      (uv_tail_tendsto_zero exact hex B hBmeas hmono hcover)
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le'
    (g := fun _ => (0 : ENNReal)) tendsto_const_nhds hsum ?_ ?_
  · exact Eventually.of_forall fun _ => zero_le _
  · exact Eventually.of_forall fun n =>
      tail_bulk_split (approx n) exact (B n)
        (hbulkMeas n) (htailMeas n)

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingLatticePDECore.tail_bulk_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms tail_bulk_split

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingLatticePDECore.uv_tail_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms uv_tail_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingLatticePDECore.band_approx_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms band_approx_tendsto_zero

end PhysicsSM.Draft.NullEdge.ChangingLatticePDECore
