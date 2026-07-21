import PhysicsSM.Draft.NullEdge.VariablePointwiseL2Contraction
import Mathlib.Analysis.InnerProductSpace.LinearPMap

/-!
# Maximal graph-domain multipliers on vector-valued L2

An unbounded operator-valued multiplier belongs on the maximal domain of
`L2` vectors whose pointwise image is again square-integrable. This module
packages that construction as Mathlib's `LinearPMap`, without assigning
arbitrary point values to `L2` equivalence classes.

The construction is generic in the measure space and fibre. It proves the
almost-everywhere action formula and transports fibrewise Hermiticity to
symmetry of the partially defined global operator. Density, closedness, and
self-adjointness are deliberately separate analytic obligations.

Provenance: clean-room generalization of the scalar multiplication-operator
architecture in PhysLean
`QuantumMechanics.DDimensions.Operators.Multiplication` (Apache-2.0,
consulted at Lean 4.31.0) to operator-valued fibres, using only Mathlib 4.28.0
APIs. Claim grade `M`, `[comp]`.
-/

noncomputable section

open Filter MeasureTheory Topology

set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.VariablePointwiseL2Multiplier

open VariablePointwiseL2Isometry

variable {X E : Type*}
variable [MeasurableSpace X]
variable [NormedAddCommGroup E] [InnerProductSpace Complex E]

/-- The maximal graph-domain multiplier associated to a pointwise family of
bounded fibre operators. The family may be unbounded as a function of `x`. -/
def maximalMultiplier (mu : Measure X) (A : X -> E →L[Complex] E) :
    Lp E 2 mu →ₗ.[Complex] Lp E 2 mu where
  domain := {
    carrier := {f | MemLp (appliedRepresentative mu A f) 2 mu}
    zero_mem' := by
      refine MemLp.zero.ae_eq ?_
      filter_upwards [Lp.coeFn_zero E 2 mu] with x hx
      rw [show appliedRepresentative mu A (0 : Lp E 2 mu) x =
          A x ((0 : Lp E 2 mu) x) by rfl, hx]
      exact (A x).map_zero.symm
    add_mem' := by
      intro f g hf hg
      refine (hf.add hg).ae_eq ?_
      filter_upwards [Lp.coeFn_add f g] with x hx
      change A x (f x) + A x (g x) = A x ((f + g) x)
      rw [hx, Pi.add_apply, map_add]
    smul_mem' := by
      intro c f hf
      refine (hf.const_smul c).ae_eq ?_
      filter_upwards [Lp.coeFn_smul c f] with x hx
      simp [appliedRepresentative, hx] }
  toFun := {
    toFun f := f.prop.toLp
    map_add' := by
      intro f g
      apply Lp.ext
      filter_upwards
        [(f + g).prop.coeFn_toLp, f.prop.coeFn_toLp, g.prop.coeFn_toLp,
          Lp.coeFn_add f.1 g.1,
          Lp.coeFn_add f.prop.toLp g.prop.toLp]
        with x hfg hf hg hinput houtput
      rw [hfg, houtput]
      simp only [Pi.add_apply]
      rw [hf, hg]
      change A x ((f.1 + g.1) x) = A x (f.1 x) + A x (g.1 x)
      rw [hinput, Pi.add_apply, map_add]
    map_smul' := by
      intro c f
      apply Lp.ext
      filter_upwards
        [(c • f).prop.coeFn_toLp, f.prop.coeFn_toLp,
          Lp.coeFn_smul c f.1, Lp.coeFn_smul c f.prop.toLp]
        with x hcf hf hinput houtput
      rw [hcf]
      simp only [RingHom.id_apply]
      rw [houtput]
      simp only [Pi.smul_apply]
      rw [hf]
      change A x ((c • f.1) x) = c • A x (f.1 x)
      rw [hinput, Pi.smul_apply, map_smul] }

/-- Membership in the maximal multiplier domain is exactly square
integrability of the pointwise image. -/
theorem mem_maximalMultiplier_domain_iff (mu : Measure X)
    (A : X -> E →L[Complex] E) (f : Lp E 2 mu) :
    f ∈ (maximalMultiplier mu A).domain ↔
      MemLp (appliedRepresentative mu A f) 2 mu :=
  Iff.rfl

/-- The packaged multiplier agrees almost everywhere with pointwise
application of the fibre family. -/
theorem maximalMultiplier_apply_ae (mu : Measure X)
    (A : X -> E →L[Complex] E) (f : (maximalMultiplier mu A).domain) :
    maximalMultiplier mu A f =ᵐ[mu] appliedRepresentative mu A f :=
  f.prop.coeFn_toLp

/-- Convergence to zero in vector-valued `L2` is equivalent to convergence of
the integral of the squared pointwise enorm. -/
theorem tendsto_zero_iff_lintegral_enorm_sq
    {I : Type*} {l : Filter I} (mu : Measure X)
    {psi : I -> Lp E 2 mu} :
    Tendsto psi l (nhds 0) ↔
      Tendsto (fun i => ∫⁻ x, ‖psi i x‖ₑ ^ 2 ∂mu) l (nhds 0) := by
  trans Tendsto
    (fun i => (∫⁻ x, ‖psi i x‖ₑ ^ 2 ∂mu) ^ (2⁻¹ : Real)) l (nhds 0)
  · simp [tendsto_iff_edist_tendsto_0, edist_zero_right, Lp.enorm_def,
      eLpNorm, eLpNorm']
  constructor <;> intro h
  · apply Tendsto.ennrpow_const 2 at h
    simpa [← ENNReal.rpow_mul_natCast] using h
  · apply Tendsto.ennrpow_const 2⁻¹ at h
    simpa using h

set_option maxHeartbeats 800000 in
/-- The maximal domain is dense whenever the operator-valued fibre family is
almost-everywhere strongly measurable. The proof truncates by the fibre
operator norm, so it does not require a global bound on the family. -/
theorem maximalMultiplier_dense_domain (mu : Measure X)
    (A : X -> E →L[Complex] E) (hA : AEStronglyMeasurable A mu) :
    Dense ((maximalMultiplier mu A).domain : Set (Lp E 2 mu)) := by
  intro f
  apply mem_closure_iff_seq_limit.mpr
  obtain ⟨u, hu, hAu⟩ := AEStronglyMeasurable.aemeasurable hA
  let s : Nat -> Set X := fun n => u ⁻¹' Metric.closedBall 0 n
  have hs : forall n, MeasurableSet (s n) := by
    intro n
    exact (measurableSet_closedBall.preimage hu)
  let phi : Nat -> Lp E 2 mu := fun n =>
    ((Lp.memLp f).indicator (hs n)).toLp
  have hphi : forall n, phi n =ᵐ[mu] (s n).indicator f := fun n =>
    ((Lp.memLp f).indicator (hs n)).coeFn_toLp
  use phi
  constructor
  · intro n
    refine MemLp.mono (Lp.memLp (((n : Real) : Complex) • f))
      (appliedRepresentative_aestronglyMeasurable mu A hA (phi n)) ?_
    filter_upwards
      [hAu, hphi n, Lp.coeFn_smul (((n : Real) : Complex)) f]
      with x hAx hphix hsmul
    by_cases hx : x ∈ s n
    · have huNorm : norm (u x) <= n := by
        simpa [s] using hx
      have hANorm : norm (A x) <= n := by simpa [hAx] using huNorm
      rw [show appliedRepresentative mu A (phi n) x = A x (phi n x) by rfl,
        hphix, Set.indicator_of_mem hx, hsmul, Pi.smul_apply]
      calc
        norm (A x (f x)) <= norm (A x) * norm (f x) :=
          ContinuousLinearMap.le_opNorm (A x) (f x)
        _ <= n * norm (f x) :=
          mul_le_mul_of_nonneg_right hANorm (norm_nonneg (f x))
        _ = norm (((n : Real) : Complex) • f x) := by
          simp [norm_smul]
    · rw [show appliedRepresentative mu A (phi n) x = A x (phi n x) by rfl,
        hphix, Set.indicator_of_notMem hx, map_zero]
      simpa only [norm_zero] using
        norm_nonneg ((((n : Real) : Complex) • f) x)
  · apply tendsto_sub_nhds_zero_iff.mp
    apply (tendsto_zero_iff_lintegral_enorm_sq mu).mpr
    have hIntegral : forall n,
        (∫⁻ x, ‖(phi n - f) x‖ₑ ^ 2 ∂mu) =
          ∫⁻ x, ‖(s n)ᶜ.indicator f x‖ₑ ^ 2 ∂mu := by
      intro n
      refine lintegral_congr_ae ?_
      filter_upwards [Lp.coeFn_sub (phi n) f, hphi n] with x hsub hphix
      rw [hsub, Pi.sub_apply, hphix]
      by_cases hx : x ∈ s n <;> simp [hx]
    simp_rw [hIntegral]
    rw [← MeasureTheory.lintegral_zero (α := X) (μ := mu)]
    refine tendsto_lintegral_of_dominated_convergence'
      (fun x => ‖f x‖ₑ ^ 2) ?_ ?_ ?_ ?_
    · measurability
    · intro n
      filter_upwards with x
      by_cases hx : x ∈ s n <;> simp [hx]
    · have hfinite := lintegral_rpow_enorm_lt_top_of_eLpNorm_lt_top
        (p := (2 : ENNReal)) (f := fun x => f x) (μ := mu)
        (by norm_num) ENNReal.ofNat_ne_top (Lp.memLp f).2
      norm_num at hfinite
      exact hfinite.ne
    · filter_upwards with x
      refine tendsto_nhds_of_eventually_eq ?_
      apply eventually_atTop.mpr
      use ⌈norm (u x)⌉.toNat
      intro n hn
      have hbound : norm (u x) <= n := by
        calc
          norm (u x) <= (⌈norm (u x)⌉ : Real) := Int.le_ceil _
          _ <= ⌈norm (u x)⌉.toNat :=
            Int.cast_le.mpr (Int.self_le_toNat _)
          _ <= n := Nat.cast_le.mpr hn
      simp [s, hbound]

/-- Fibrewise Hermiticity makes the maximal global multiplier symmetric. -/
theorem maximalMultiplier_isFormalAdjoint_self (mu : Measure X)
    (A : X -> E →L[Complex] E)
    (hHerm : forall x v w, inner Complex (A x v) w = inner Complex v (A x w)) :
    (maximalMultiplier mu A).IsFormalAdjoint (maximalMultiplier mu A) := by
  intro f g
  rw [L2.inner_def, L2.inner_def]
  refine integral_congr_ae ?_
  filter_upwards
    [maximalMultiplier_apply_ae mu A f,
      maximalMultiplier_apply_ae mu A g] with x hf hg
  rw [hf, hg]
  exact hHerm x (f.1 x) (g.1 x)

/-! ## Abstract two-resolvent criterion -/

section ImaginaryRangeCriterion

variable {H : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

open scoped LinearPMap

/-- If `T + i` is onto, the adjoint has no eigenvector with eigenvalue `i`.

This lemma and the two-resolvent criterion below were generated by Aristotle
project `c8ac3461-d32c-4690-8658-1f1558d0ef1b` and independently rebuilt in
the pinned project before integration. -/
lemma adjoint_i_eigenvector_eq_zero
    (T : H →ₗ.[ℂ] H) (hdense : Dense (T.domain : Set H))
    (hplus : ∀ y : H, ∃ x : T.domain, T x + Complex.I • (x : H) = y)
    (v : T.adjoint.domain) (hv : T.adjoint v = Complex.I • (v : H)) :
    (v : H) = 0 := by
  obtain ⟨x, hx⟩ := hplus (v : H)
  have hv_zero : inner ℂ v.val (T x) = inner ℂ (T†.toFun v) x := by
    have := T.adjoint_isFormalAdjoint
    exact this hdense |> fun h => h v x ▸ rfl
  simp_all +decide [mul_comm, inner_add_right, inner_smul_right]
  simp_all +decide [← eq_sub_iff_add_eq']
  replace hx := congr_arg (inner ℂ (v : H)) hx
  simp_all +decide [inner_self_eq_norm_sq_to_K]

/-- If `T - i` is onto, the adjoint has no eigenvector with eigenvalue `-i`. -/
lemma adjoint_neg_i_eigenvector_eq_zero
    (T : H →ₗ.[ℂ] H) (hdense : Dense (T.domain : Set H))
    (hminus : ∀ y : H, ∃ x : T.domain, T x - Complex.I • (x : H) = y)
    (v : T.adjoint.domain) (hv : T.adjoint v = -Complex.I • (v : H)) :
    (v : H) = 0 := by
  obtain ⟨x, hx⟩ := hminus (v : H)
  have hv_zero : inner ℂ v.val (T x) = inner ℂ (T†.toFun v) x := by
    convert T.adjoint_isFormalAdjoint hdense v x |> Eq.symm using 1
  simp_all +decide [sub_eq_iff_eq_add, inner_sub_left, inner_smul_left,
    inner_smul_right]

/-- A densely defined symmetric complex operator is self-adjoint when both
imaginary shifts have full range. -/
theorem isSelfAdjoint_of_isFormalAdjoint_of_surjective_shifts
    (T : H →ₗ.[ℂ] H) (hdense : Dense (T.domain : Set H))
    (hsymm : T.IsFormalAdjoint T)
    (hplus : ∀ y : H, ∃ x : T.domain, T x + Complex.I • (x : H) = y)
    (hminus : ∀ y : H, ∃ x : T.domain, T x - Complex.I • (x : H) = y) :
    IsSelfAdjoint T := by
  have h_T_le_T_star : T ≤ T.adjoint := by
    convert hsymm.le_adjoint hdense using 1
  have h_T_star_le_T : ∀ y ∈ T.adjoint.domain, y ∈ T.domain := by
    intro y hy
    obtain ⟨x, hx⟩ := hplus
      (T.adjoint ⟨y, hy⟩ + Complex.I • y)
    have h_v : T.adjoint ⟨y - x, by
        exact Submodule.sub_mem _ hy (h_T_le_T_star.1 x.2)⟩ =
        -Complex.I • (y - x) := by
      have h_v : T.adjoint ⟨y - x, by
          exact Submodule.sub_mem _ hy (h_T_le_T_star.1 x.2)⟩ =
          T.adjoint ⟨y, hy⟩ - T.adjoint ⟨x, by
            exact h_T_le_T_star.1 x.2⟩ := by
        all_goals generalize_proofs at *
        convert T.adjoint.map_sub ⟨y, hy⟩ ⟨x, by assumption⟩ using 1
      generalize_proofs at *
      have h_v : T.adjoint ⟨x, by assumption⟩ = T x := by
        all_goals generalize_proofs at *
        exact LinearPMap.adjoint_apply_eq hdense
          ⟨↑x, by assumption⟩ (hsymm x)
      generalize_proofs at *
      simp_all +decide [add_eq_zero_iff_eq_neg, smul_sub]
      grind
    generalize_proofs at *
    have := adjoint_neg_i_eigenvector_eq_zero T hdense hminus
      ⟨_, ‹_›⟩ h_v
    simp_all +decide [sub_eq_iff_eq_add]
  ext x
  · exact ⟨h_T_star_le_T x, fun hx => h_T_le_T_star.1 hx⟩
  · obtain ⟨y, hy⟩ := h_T_le_T_star
    exact Eq.symm (hy rfl)

end ImaginaryRangeCriterion

end PhysicsSM.Draft.NullEdge.VariablePointwiseL2Multiplier

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePointwiseL2Multiplier.maximalMultiplier_apply_ae' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.VariablePointwiseL2Multiplier.maximalMultiplier_apply_ae

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePointwiseL2Multiplier.maximalMultiplier_dense_domain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.VariablePointwiseL2Multiplier.maximalMultiplier_dense_domain

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePointwiseL2Multiplier.maximalMultiplier_isFormalAdjoint_self' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.VariablePointwiseL2Multiplier.maximalMultiplier_isFormalAdjoint_self

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePointwiseL2Multiplier.isSelfAdjoint_of_isFormalAdjoint_of_surjective_shifts' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.VariablePointwiseL2Multiplier.isSelfAdjoint_of_isFormalAdjoint_of_surjective_shifts
