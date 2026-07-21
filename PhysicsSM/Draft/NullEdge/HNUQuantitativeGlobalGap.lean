import PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap

/-!
# Uniform quantitative zero/pi determinant gap for the massive HNU walk

For every fixed mass angle strictly between zero and pi, this module upgrades
the pointwise nonvanishing theorem to one positive determinant margin valid
uniformly on the complete closed Brillouin cube. The proof uses compactness
and continuity; no quantitative lower bound is assumed.

This is a uniform lower bound on the norms of `det (U - 1)` and `det (U + 1)`.
Turning it into a lower bound on individual quasienergy-angle separation is a
separate finite-dimensional spectral estimate.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay
open PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUQuantitativeGlobalGap

/-- Norm of the determinant shifted from zero quasienergy. -/
def zeroDetGap (a : Real) (k : Fin 3 -> Real) : Real :=
  norm ((massiveHNU (1 : Complex) a k - 1).det)

/-- Norm of the determinant shifted from pi quasienergy. -/
def piDetGap (a : Real) (k : Fin 3 -> Real) : Real :=
  norm ((massiveHNU (1 : Complex) a k + 1).det)

/-- The closed Brillouin cube is compact. -/
lemma isCompact_inBZ : IsCompact {k : Fin 3 -> Real | InBZ k} := by
  convert isCompact_univ_pi fun _ : Fin 3 => isCompact_Icc
  · exact Set.ext fun x =>
      ⟨fun hx => fun i _ => hx i, fun hx => fun i => hx i trivial⟩
  · exact fun _ => inferInstance

/-- The exact zero-shifted determinant norm varies continuously in momentum. -/
lemma continuous_zeroDetGap (a : Real) : Continuous (zeroDetGap a) := by
  refine' continuous_norm.comp (Continuous.matrix_det _)
  unfold massiveHNU
  have h_cont : Continuous (fun k : Fin 3 -> Real => doubledChiralEndpoint k) := by
    unfold doubledChiralEndpoint
    have h_cont_endpoint : Continuous (fun k : Fin 3 -> Real => endpoint k) := by
      unfold endpoint Uminus Uplus
      fun_prop
    exact continuous_pi_iff.mpr fun i => continuous_pi_iff.mpr fun j => by
      fin_cases i <;> fin_cases j <;>
        [ exact Continuous.matrix_elem h_cont_endpoint 0 0;
          exact Continuous.matrix_elem h_cont_endpoint 0 1;
          continuity;
          continuity;
          exact Continuous.matrix_elem h_cont_endpoint 1 0;
          exact Continuous.matrix_elem h_cont_endpoint 1 1;
          continuity;
          continuity;
          continuity;
          continuity;
          exact Continuous.matrix_elem
            (h_cont_endpoint.comp (continuous_neg.comp continuous_id')) 0 0;
          exact Continuous.matrix_elem
            (h_cont_endpoint.comp (continuous_neg.comp continuous_id')) 0 1;
          continuity;
          continuity;
          exact Continuous.matrix_elem
            (h_cont_endpoint.comp (continuous_neg.comp continuous_id')) 1 0;
          exact Continuous.matrix_elem
            (h_cont_endpoint.comp (continuous_neg.comp continuous_id')) 1 1 ]
  refine' Continuous.sub _ continuous_const
  refine' Continuous.mul _ _
  · exact continuous_const
  · exact Continuous.matrix_mul continuous_const h_cont |>
      Continuous.matrix_mul <| continuous_const

/-- The exact pi-shifted determinant norm varies continuously in momentum. -/
lemma continuous_piDetGap (a : Real) : Continuous (piDetGap a) := by
  have h_det_cont :
      Continuous (fun k : Fin 3 -> Real => (massiveHNU (1 : Complex) a k + 1).det) := by
    refine' Continuous.matrix_det (Continuous.add _ continuous_const)
    refine' Continuous.matrix_mul _ _
    · exact continuous_const
    · refine' Continuous.matrix_mul (Continuous.matrix_mul _ _) _
      · exact continuous_const
      · refine' continuous_matrix _
        intro i j
        have h_endpoint_cont : Continuous (fun k : Fin 3 -> Real => endpoint k) := by
          apply_rules [Continuous.matrix_mul, continuous_const, continuous_id]
          all_goals apply_rules [Continuous.add, Continuous.smul,
            continuous_const, continuous_apply]
          all_goals fun_prop
        unfold doubledChiralEndpoint
        fin_cases i <;> fin_cases j <;> simp +decide
        all_goals fun_prop
      · exact continuous_const
  exact h_det_cont.norm

/-- The zero-shifted determinant norm is strictly positive throughout the
closed Brillouin cube for every nontrivial mass angle. -/
lemma zeroDetGap_pos (a : Real) (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) : 0 < zeroDetGap a k := by
  have h := massiveHNU_zero_pi_gap a ha0 hapi k hk
  unfold zeroDetGap
  aesop

/-- The pi-shifted determinant norm is strictly positive throughout the
closed Brillouin cube for every nontrivial mass angle. -/
lemma piDetGap_pos (a : Real) (ha0 : 0 < a) (hapi : a < Real.pi)
    (k : Fin 3 -> Real) (hk : InBZ k) : 0 < piDetGap a k := by
  convert norm_pos_iff.mpr _
  have h := massiveHNU_zero_pi_gap a ha0 hapi k hk
  aesop

/-- A single positive real margin uniformly bounds both shifted determinant
norms on the complete closed Brillouin cube. -/
theorem massiveHNU_quantitative_zero_pi_gap (a : Real) (ha0 : 0 < a)
    (hapi : a < Real.pi) :
    ∃ delta : Real, 0 < delta ∧
      ∀ k : Fin 3 -> Real, InBZ k ->
        delta <= norm ((massiveHNU (1 : Complex) a k - 1).det) ∧
        delta <= norm ((massiveHNU (1 : Complex) a k + 1).det) := by
  obtain ⟨dz, hdz⟩ := IsCompact.exists_forall_le' isCompact_inBZ
    (continuous_zeroDetGap a).continuousOn
    (fun k hk => zeroDetGap_pos a ha0 hapi k hk)
  obtain ⟨dp, hdp⟩ := IsCompact.exists_forall_le' isCompact_inBZ
    (continuous_piDetGap a).continuousOn
    (fun k hk => piDetGap_pos a ha0 hapi k hk)
  exact ⟨min dz dp, lt_min hdz.1 hdp.1, fun k hk =>
    ⟨le_trans (min_le_left _ _) (hdz.2 k hk),
      le_trans (min_le_right _ _) (hdp.2 k hk)⟩⟩

/-- The angle interval used by the quantitative theorem is nonempty. -/
theorem nontrivial_mass_angle_witness :
    ∃ a : Real, 0 < a ∧ a < Real.pi := by
  refine ⟨Real.pi / 2, ?_, ?_⟩ <;> nlinarith [Real.pi_pos]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUQuantitativeGlobalGap.isCompact_inBZ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms isCompact_inBZ

/-- info: 'PhysicsSM.Draft.NullEdge.HNUQuantitativeGlobalGap.continuous_zeroDetGap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms continuous_zeroDetGap

/-- info: 'PhysicsSM.Draft.NullEdge.HNUQuantitativeGlobalGap.continuous_piDetGap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms continuous_piDetGap

/-- info: 'PhysicsSM.Draft.NullEdge.HNUQuantitativeGlobalGap.zeroDetGap_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zeroDetGap_pos

/-- info: 'PhysicsSM.Draft.NullEdge.HNUQuantitativeGlobalGap.piDetGap_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms piDetGap_pos

/-- info: 'PhysicsSM.Draft.NullEdge.HNUQuantitativeGlobalGap.massiveHNU_quantitative_zero_pi_gap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveHNU_quantitative_zero_pi_gap

/-- info: 'PhysicsSM.Draft.NullEdge.HNUQuantitativeGlobalGap.nontrivial_mass_angle_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nontrivial_mass_angle_witness

end PhysicsSM.Draft.NullEdge.HNUQuantitativeGlobalGap
