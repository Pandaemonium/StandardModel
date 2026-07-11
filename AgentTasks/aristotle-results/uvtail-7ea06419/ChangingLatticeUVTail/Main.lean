import PhysicsSM.Draft.NullEdge.ChangingLatticePDECore

/-!
# Ultraviolet-tail convergence on expanding bands

Focused dominated-convergence target for the changing-lattice PDE bridge.
-/

noncomputable section

namespace ChangingLatticeUVTail

open MeasureTheory Filter Topology Set

/-
Pointwise identity: the squared enorm of an indicator equals the indicator of
the squared enorm.
-/
lemma enorm_sq_indicator_compl {X E : Type*} [NormedAddCommGroup E]
    (exact : X → E) (s : Set X) (x : X) :
    ‖(sᶜ.indicator exact) x‖ₑ ^ (2 : ℝ) = sᶜ.indicator (fun y => ‖exact y‖ₑ ^ (2 : ℝ)) x := by
  by_cases hx : x ∈ s <;> simp +decide [ hx ]

/-
The finite `L2` integral of `exact` is finite.
-/
lemma lintegral_enorm_sq_ne_top {X E : Type*} [MeasurableSpace X]
    [NormedAddCommGroup E] {mu : Measure X}
    (exact : X → E) (hex : MemLp exact 2 mu) :
    (∫⁻ x, ‖exact x‖ₑ ^ (2 : ℝ) ∂mu) ≠ ⊤ := by
  have := hex.eLpNorm_ne_top; simp_all +decide [ eLpNorm_eq_lintegral_rpow_enorm_toReal ] ;

/-
The inner `L2` integrals over the complements of the bands tend to zero.
-/
lemma inner_lintegral_tendsto_zero {X E : Type*} [MeasurableSpace X]
    [NormedAddCommGroup E] {mu : Measure X}
    (exact : X → E) (hex : MemLp exact 2 mu)
    (B : Nat -> Set X) (hBmeas : ∀ n, MeasurableSet (B n))
    (hmono : Monotone B) (hcover : ⋃ n, B n = Set.univ) :
    Tendsto (fun n => ∫⁻ x, ‖((B n)ᶜ.indicator exact) x‖ₑ ^ (2 : ℝ) ∂mu)
      atTop (nhds 0) := by
  have h_dominated_convergence : Filter.Tendsto (fun n => ∫⁻ x, (B n)ᶜ.indicator (fun y => ‖exact y‖ₑ ^ 2) x ∂mu) Filter.atTop (nhds (∫⁻ x, 0 ∂mu)) := by
    refine' MeasureTheory.tendsto_lintegral_of_dominated_convergence' _ _ _ _ _;
    refine' fun x => ‖exact x‖ₑ ^ 2;
    · intro n;
      exact AEMeasurable.indicator ( hex.1.enorm.pow_const _ ) ( hBmeas n |> MeasurableSet.compl );
    · intro n; filter_upwards [ ] with x; by_cases hx : x ∈ B n <;> simp +decide [ hx ] ;
    · convert lintegral_enorm_sq_ne_top exact hex;
      norm_cast;
    · filter_upwards [ ] with x;
      simp_all +decide [ Set.ext_iff ];
      obtain ⟨ n, hn ⟩ := hcover x; exact tendsto_const_nhds.congr' ( by filter_upwards [ Filter.eventually_ge_atTop n ] with m hm; rw [ Set.indicator_of_notMem ] ; exact fun h => by exact absurd ( hmono hm hn ) h ) ;
  convert h_dominated_convergence using 2;
  · congr with x ; by_cases hx : x ∈ B ‹_› <;> simp +decide [ hx ];
  · simp +decide

/-
The `L2` mass outside measurable increasing bands tends to zero when the
bands exhaust the whole frequency space.
-/
theorem uv_tail_tendsto_zero {X E : Type*} [MeasurableSpace X]
    [NormedAddCommGroup E] {mu : Measure X}
    (exact : X -> E) (hex : MemLp exact 2 mu)
    (B : Nat -> Set X) (hBmeas : ∀ n, MeasurableSet (B n))
    (hmono : Monotone B) (hcover : ⋃ n, B n = Set.univ) :
    Tendsto (fun n => eLpNorm ((B n)ᶜ.indicator exact) 2 mu)
      atTop (nhds 0) := by
  convert ( Filter.Tendsto.comp ( show Filter.Tendsto ( fun t : ENNReal => t ^ ( 1 / 2 : ℝ ) ) ( nhds 0 ) ( nhds 0 ) from by
                                    convert ENNReal.continuous_rpow_const.tendsto 0 using 2 ; norm_num ) ( inner_lintegral_tendsto_zero exact hex B hBmeas hmono hcover ) ) using 2;
  rw [ Function.comp_apply, eLpNorm_eq_lintegral_rpow_enorm_toReal ] <;> norm_num

end ChangingLatticeUVTail
